/// Every tunable number the mastery/medal calculation depends on, in one
/// place — see mastery_calculator.dart, which takes this as a parameter
/// rather than hard-coding any of these values itself. Change the values
/// here (or pass a different config into calculateMastery()) rather than
/// touching the calculation logic.
class MasteryConfig {
  const MasteryConfig({
    this.difficultyWeights = const {
      'Easy': 1.0,
      'Medium': 2.0,
      'Hard': 3.0,
      'Challenge': 3.0,
      'Advanced': 4.0,
    },
    this.higherTiers = const {'Hard', 'Challenge', 'Advanced'},
    this.minAttemptsForRating = 5,
    this.minHigherTierAttemptsForDiamond = 3,
    this.bronzeThreshold = 30,
    this.silverThreshold = 60,
    this.goldThreshold = 80,
    this.diamondThreshold = 90,
  });

  /// How much a difficulty counts toward overall mastery, relative to the
  /// others — a harder tier should move the needle more than an easy one,
  /// so a student can't reach a high mastery % purely by acing Easy
  /// questions. 'Hard' and 'Challenge' share a weight since no course uses
  /// both (see award_medal()'s own comment on this in schema_practice.sql).
  final Map<String, double> difficultyWeights;

  /// Which difficulty labels count as "higher tier" for the Diamond gate
  /// below.
  final Set<String> higherTiers;

  /// Below this many total attempts across every difficulty, there isn't
  /// enough evidence to award any medal or report a mastery number at all
  /// — see MasteryResult.insufficientData.
  final int minAttemptsForRating;

  /// A mastery score alone can hit the Diamond band purely from Easy/Medium
  /// accuracy if a student never touches a higher tier. Diamond additionally
  /// requires at least this many attempts at a "higher tier" difficulty;
  /// short of that, the result is capped at Gold no matter how high the
  /// weighted score comes out.
  final int minHigherTierAttemptsForDiamond;

  final double bronzeThreshold;
  final double silverThreshold;
  final double goldThreshold;
  final double diamondThreshold;

  double weightFor(String difficulty) => difficultyWeights[difficulty] ?? 1.0;

  bool isHigherTier(String difficulty) => higherTiers.contains(difficulty);

  static const standard = MasteryConfig();
}
