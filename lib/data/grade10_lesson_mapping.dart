/// Maps Grade 10 (MPM2D) subtopic codes to the lesson id that covers them
/// in `assets/data/mpm2d_topics_mindmap.json`.
///
/// Remapped onto the finer MPM2D subtopic taxonomy introduced alongside the
/// codeveloper question bank (see supabase/seed.sql / questions_seed.sql).
/// A few old subtopics collapsed onto the same new subtopic; where that
/// happened only one of the two lessons could keep a direct link here (a
/// student can still reach both lessons' material through the practice
/// questions either way) -- b8, b10, c6, and c7 lost their direct subtopic
/// link for that reason. The new 'trig-for-angles' subtopic has no lesson
/// of its own yet.
///
/// Keyed by subtopic code only (not course + code) because none of these
/// codes are reused by another grade's curriculum.
const grade10LessonIdBySubtopicCode = <String, String>{
  // Linear Systems
  'solving-by-graphing': 'b3',
  'solving-by-substitution': 'b2',
  'solving-by-elimination': 'b1',
  'linear-system-applications': 'b9',

  // Analytic Geometry
  'midpoint-and-length-of-a-line-segment': 'b4',
  'geometric-properties-of-shapes': 'b11',
  'equation-of-a-circle': 'b5',
  'medians-right-bisectors-and-altitudes': 'b7',

  // Quadratics / Solving Quadratic Equations
  'properties-of-quadratics': 'a1',
  'vertex-form': 'a2',
  'completing-the-square': 'a6',
  'factored-form-and-zeros': 'a9',
  'solving-by-factoring': 'a5',
  'the-quadratic-formula': 'a7',
  'applications-of-quadratics': 'a8',

  // Factoring
  'multiplying-binomials': 'a3',
  'factoring-x-bx-c': 'a4',

  // Trigonometry
  'similar-triangles': 'c1',
  'the-primary-trig-ratios': 'c2',
  'trig-for-side-lengths': 'c3',
  'sine-law': 'c4',
  'cosine-law': 'c5',
};

/// Whether [lessonId] is one of MPM2D's own lessons -- used to gate
/// features scoped to Grade 10 Math specifically, like
/// lesson_mindmap_summary.dart's visual lesson overview.
bool isGrade10MathLesson(String lessonId) =>
    grade10LessonIdBySubtopicCode.values.contains(lessonId);
