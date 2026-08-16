/// Maps Grade 10 (MPM2D) subtopic codes to the lesson id that covers them
/// in `assets/data/mpm2d_topics_mindmap.json`.
///
/// Every subtopic in the Grade 10 curriculum has a matching lesson as of
/// this revision. Keyed by subtopic code only (not course + code) because
/// none of these codes are reused by another grade's curriculum.
const grade10LessonIdBySubtopicCode = <String, String>{
  // Linear Systems
  'solving-by-graphing': 'b3',
  'solving-by-substitution': 'b2',
  'solving-by-elimination': 'b1',
  'number-of-solutions': 'b8',
  'linear-system-applications': 'b9',

  // Analytic Geometry
  'length-of-a-line-segment': 'b4',
  'midpoint-of-a-line-segment': 'b4',
  'slope-and-equation-of-a-line': 'b10',
  'equation-of-a-circle': 'b5',
  'classifying-shapes': 'b11',
  'verifying-properties': 'b7',

  // Quadratic Relations
  'investigating-parabolas': 'a1',
  'transformations-vertex-form': 'a2',
  'expanding-and-simplifying': 'a3',
  'factoring-quadratics': 'a4',
  'solving-by-factoring': 'a5',
  'completing-the-square': 'a6',
  'quadratic-formula': 'a7',
  'graphing-quadratics': 'a9',
  'quadratic-applications': 'a8',

  // Trigonometry
  'similar-triangles': 'c1',
  'primary-trig-ratios': 'c2',
  'solving-right-triangles': 'c3',
  'elevation-and-depression': 'c6',
  'sine-law': 'c4',
  'cosine-law': 'c5',
  'acute-triangle-applications': 'c7',
};
