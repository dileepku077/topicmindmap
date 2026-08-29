import 'mastery_config.dart';

/// One difficulty tier's raw attempt counts for one topic — the input the
/// calculator works from. "Attempted" counts a question once it's been
/// tapped at all, whether or not it was ever answered correctly; distinct
/// from the rest of this app's "solved" convention (every question
/// eventually correct), because mastery needs real accuracy, not just a
/// finished/not-finished signal.
class DifficultyStats {
  const DifficultyStats({
    required this.difficulty,
    required this.attempted,
    required this.correct,
    required this.firstTryCorrect,
  });

  final String difficulty;
  final int attempted;
  final int correct;
  final int firstTryCorrect;

  /// First-try accuracy — the same metric this app's medals have always
  /// used (see award_medal() in supabase/schema_medal_tiers.sql), not
  /// "eventually correct after however many retries".
  double get accuracyPercent => attempted == 0 ? 0 : 100.0 * firstTryCorrect / attempted;
}

/// One difficulty tier's own medal within a topic — the "Difficulty
/// Performance" breakdown (e.g. "Easy 95% Diamond, Advanced 42% Bronze").
/// Independent of the topic's overall weighted medal below.
class DifficultyMedal {
  const DifficultyMedal({
    required this.stats,
    required this.medal,
    required this.insufficientData,
  });

  final DifficultyStats stats;
  final String medal;
  final bool insufficientData;
}

/// The result of scoring one topic (or any other grouping of
/// [DifficultyStats] — a whole unit's stats pooled together works the same
/// way) — a single weighted mastery % and medal, plus the per-difficulty
/// breakdown feeding it.
class MasteryResult {
  const MasteryResult({
    required this.masteryPercent,
    required this.medal,
    required this.insufficientData,
    required this.totalAttempted,
    required this.byDifficulty,
  });

  /// 0 when [insufficientData] — there's nothing meaningful to show yet.
  final double masteryPercent;

  /// 'None' when [insufficientData] or below the Bronze floor.
  final String medal;

  /// True when there have been too few attempts (across every difficulty
  /// combined) to report anything — see
  /// [MasteryConfig.minAttemptsForRating]. The UI should show something
  /// like "Keep practicing — we're still learning about your progress"
  /// rather than a specific (and misleadingly precise) number.
  final bool insufficientData;

  final int totalAttempted;
  final Map<String, DifficultyMedal> byDifficulty;

  static const empty = MasteryResult(
    masteryPercent: 0,
    medal: 'None',
    insufficientData: true,
    totalAttempted: 0,
    byDifficulty: {},
  );
}

/// Bronze/Silver/Gold/Diamond/None purely by percentage against
/// [config]'s thresholds — used both for a single difficulty's own medal
/// and (with the extra Diamond gate below) a topic's overall one.
String bandForPercent(double percent, [MasteryConfig config = MasteryConfig.standard]) {
  if (percent >= config.diamondThreshold) return 'Diamond';
  if (percent >= config.goldThreshold) return 'Gold';
  if (percent >= config.silverThreshold) return 'Silver';
  if (percent >= config.bronzeThreshold) return 'Bronze';
  return 'None';
}

/// The single, centralized mastery calculation this whole app should call
/// rather than each screen computing its own version. Takes whatever
/// [DifficultyStats] are available — one topic's own tiers, or several
/// topics' tiers pooled together for a unit/course-level score, the math
/// is the same either way — and [config] for every tunable number, so
/// changing a threshold or weight never means touching this function.
///
/// Mastery is a weighted average of each difficulty's accuracy, weighted
/// by both the difficulty's own weight (harder counts more) and how many
/// questions were attempted at it (more evidence counts more) — so a
/// student can't reach a high score purely by acing a handful of Easy
/// questions: [MasteryConfig.difficultyWeights] makes a correct Advanced
/// answer worth several correct Easy ones, and the minimum-attempts gates
/// below stop both a whole-topic score and a Diamond specifically from
/// being awarded on too little evidence.
MasteryResult calculateMastery(
  List<DifficultyStats> stats, {
  MasteryConfig config = MasteryConfig.standard,
}) {
  final attempted = stats.where((s) => s.attempted > 0).toList();
  final totalAttempted = attempted.fold<int>(0, (sum, s) => sum + s.attempted);

  final byDifficulty = <String, DifficultyMedal>{
    for (final s in attempted)
      s.difficulty: DifficultyMedal(
        stats: s,
        medal: s.attempted < config.minAttemptsForRating
            ? 'None'
            : bandForPercent(s.accuracyPercent, config),
        insufficientData: s.attempted < config.minAttemptsForRating,
      ),
  };

  if (totalAttempted < config.minAttemptsForRating) {
    return MasteryResult(
      masteryPercent: 0,
      medal: 'None',
      insufficientData: true,
      totalAttempted: totalAttempted,
      byDifficulty: byDifficulty,
    );
  }

  var weightedSum = 0.0;
  var weightTotal = 0.0;
  var higherTierAttempted = 0;
  for (final s in attempted) {
    final w = config.weightFor(s.difficulty) * s.attempted;
    weightedSum += s.accuracyPercent * w;
    weightTotal += w;
    if (config.isHigherTier(s.difficulty)) higherTierAttempted += s.attempted;
  }
  final mastery = weightTotal == 0 ? 0.0 : weightedSum / weightTotal;

  var medal = bandForPercent(mastery, config);
  // A weighted score can still land in the Diamond band from Easy/Medium
  // accuracy alone if a student never attempts a harder tier — this is
  // the one place that's explicitly blocked, per design.
  if (medal == 'Diamond' && higherTierAttempted < config.minHigherTierAttemptsForDiamond) {
    medal = 'Gold';
  }

  return MasteryResult(
    masteryPercent: mastery,
    medal: medal,
    insufficientData: false,
    totalAttempted: totalAttempted,
    byDifficulty: byDifficulty,
  );
}
