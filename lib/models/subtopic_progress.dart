/// One subtopic's mastery for the Progress Report bar chart — see
/// supabase/schema_progress_report.sql's subtopic_progress_report() for
/// exactly how [masteryPercent] is derived (fraction of this topic's
/// difficulty tiers fully solved at least once, Practice Test only).
class SubtopicProgress {
  const SubtopicProgress({
    required this.unitCode,
    required this.subtopicCode,
    required this.tiersTotal,
    required this.tiersCompleted,
    required this.masteryPercent,
  });

  final String unitCode;
  final String subtopicCode;
  final int tiersTotal;
  final int tiersCompleted;
  final double masteryPercent;

  factory SubtopicProgress.fromMap(Map<String, dynamic> map) {
    return SubtopicProgress(
      unitCode: map['unit_code'] as String,
      subtopicCode: map['subtopic_code'] as String,
      tiersTotal: map['tiers_total'] as int,
      tiersCompleted: map['tiers_completed'] as int,
      masteryPercent: (map['mastery_percent'] as num).toDouble(),
    );
  }
}
