/// Maps Grade 10 (MPM2D) subtopic codes to the lesson id that covers them
/// in `assets/data/mpm2d_topics_mindmap.json`.
///
/// The lesson content was authored as its own, slightly coarser breakdown
/// (20 lessons) than the app's curriculum (27 subtopics) — a few lessons
/// cover two closely-related subtopics (e.g. length and midpoint of a line
/// segment share one lesson), and a handful of subtopics have no matching
/// lesson yet. Subtopics with no entry here simply don't show a "Lesson"
/// link. Keyed by subtopic code only (not course + code) because none of
/// these codes are reused by another grade's curriculum.
const grade10LessonIdBySubtopicCode = <String, String>{
  // Linear Systems
  'solving-by-graphing': 'b3',
  'solving-by-substitution': 'b2',
  'solving-by-elimination': 'b1',

  // Analytic Geometry
  'length-of-a-line-segment': 'b4',
  'midpoint-of-a-line-segment': 'b4',
  'equation-of-a-circle': 'b5',
  'verifying-properties': 'b7',

  // Quadratic Relations
  'investigating-parabolas': 'a1',
  'transformations-vertex-form': 'a2',
  'expanding-and-simplifying': 'a3',
  'factoring-quadratics': 'a4',
  'solving-by-factoring': 'a5',
  'completing-the-square': 'a6',
  'quadratic-formula': 'a7',
  'quadratic-applications': 'a8',

  // Trigonometry
  'similar-triangles': 'c1',
  'primary-trig-ratios': 'c2',
  'solving-right-triangles': 'c3',
  'sine-law': 'c4',
  'cosine-law': 'c5',
};
