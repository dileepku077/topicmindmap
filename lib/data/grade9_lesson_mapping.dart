// Subtopic code -> Grade 9 (MTH1W) lesson id, mirroring
// grade10_lesson_mapping.dart's pattern. Safe to key by subtopic code alone
// since MTH1W subtopic codes don't collide with other courses' codes.
//
// Remapped onto the finer MTH1W subtopic taxonomy introduced alongside the
// codeveloper question bank (see supabase/seed.sql / questions_seed.sql).
// A few old subtopics collapsed onto the same new subtopic; where that
// happened only one of the two lessons could keep a direct link here (a
// student can still reach both lessons' material through the practice
// questions either way) -- g9-ns2, g9-alg3, g9-lin5, and g9-geo2 lost their
// direct subtopic link for that reason.
const grade9LessonIdBySubtopicCode = <String, String>{
  // Number Sense
  'integers': 'g9-ns1',
  'powers-and-exponent-form': 'g9-ns3',
  // Algebraic Expressions
  'collecting-like-terms': 'g9-alg1',
  'distributive-property': 'g9-alg2',
  'solving-multi-step-linear-equations': 'g9-alg5',
  // Linear Relations Part 1
  'slope-and-rate-of-change': 'g9-lin1',
  'finding-the-equation-of-a-line': 'g9-lin2',
  'standard-form-and-intercepts': 'g9-lin3',
  'slope-intercept-form': 'g9-lin4',
  // Geometry
  'area-and-perimeter-of-composite-shapes': 'g9-geo1',
  'surface-area-and-volume': 'g9-geo3',
  'angle-relationships-and-polygons': 'g9-geo4',
  // Data
  'measures-of-central-tendency': 'g9-dfl1',
  'measures-of-spread': 'g9-dfl2',
  'scatterplots-and-correlation': 'g9-dfl3',
  // Financial Literacy
  'simple-interest': 'g9-dfl4',
  'budgeting': 'g9-dfl5',
};
