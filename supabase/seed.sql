-- Seed data: Ontario academic-stream math curriculum (grades 9-12) units &
-- subtopics, plus Grade 10 science and Grade 11 physics, plus demo students.
-- Run after schema.sql. Safe to re-run (upserts on the unique `code` columns).
--
-- Content mirrors the common textbook breakdown of each course:
--   MTH1W  Grade 9  Math (destreamed)
--   MPM2D  Grade 10 Academic Math
--   MCR3U  Grade 11 Functions (university prep)
--   MHF4U  Grade 12 Advanced Functions (university prep)
--   MCV4U  Grade 12 Calculus and Vectors (university prep)
--   MDM4U  Grade 12 Data Management (university prep)
--   SNC2D  Grade 10 Academic Science
--   SPH3U  Grade 11 Physics (university prep)
-- Adjust wording/order here to match your own board's course outline.
--
-- MTH1W/MPM2D/MCR3U/MHF4U's units and subtopics below, and MCV4U/MDM4U in
-- full, were rebuilt to match a codeveloper-authored 1,600-question bank
-- (see questions_seed.sql's header) -- a finer-grained taxonomy than this
-- file used to have. Existing questions were remapped onto the new
-- subtopic codes rather than lost; see questions_seed.sql.

-- Grade 9 used to be MPM1D (the pre-2021 academic-stream course). Ontario
-- destreamed Grade 9 math in Sept 2021 — MPM1D no longer exists for current
-- students, replaced by MTH1W for everyone, with a mandatory Data and
-- Financial Literacy strand MPM1D never had. `on conflict (code)` below only
-- upserts a matching code, so the old MPM1D row (and its units/subtopics,
-- via the FK cascades in schema.sql) needs an explicit delete first, not
-- just a rename.
delete from public.courses where code = 'MPM1D';

with course_data (grade, code, title, description, order_index) as (
  values
    (9, 'MTH1W', 'Grade 9 Math',
     'Number, algebra, linear relations, geometry and measurement, and data and financial literacy.', 0),
    (10, 'MPM2D', 'Grade 10 Academic Math',
     'Linear systems, analytic geometry, quadratics, and trigonometry.', 1),
    (11, 'MCR3U', 'Grade 11 Functions',
     'Functions, exponential and trigonometric relationships, and sequences.', 2),
    (12, 'MHF4U', 'Grade 12 Advanced Functions',
     'Polynomial, rational, logarithmic, and trigonometric functions.', 3),
    (12, 'MCV4U', 'Grade 12 Calculus and Vectors',
     'Derivatives, curve sketching, and an introduction to geometric and algebraic vectors.', 6),
    (12, 'MDM4U', 'Grade 12 Data Management',
     'Organizing and analyzing data, probability, and probability distributions.', 7),
    (10, 'SNC2D', 'Grade 10 Academic Science',
     'Biology, chemistry, earth and space science, and physics.', 4),
    (11, 'SPH3U', 'Grade 11 Physics',
     'Kinematics, dynamics, energy and momentum, waves and sound, and electricity and magnetism.', 5)
)
insert into public.courses (grade, code, title, description, order_index)
select grade, code, title, description, order_index from course_data
on conflict (code) do update
  set grade = excluded.grade,
      title = excluded.title,
      description = excluded.description,
      order_index = excluded.order_index;


-- ===========================================================================
-- Grade 9 — MTH1W
-- ===========================================================================

-- Old units that no longer exist under any of the new codes below, plus
-- old subtopics under units whose code persisted but whose subtopic list
-- changed -- see the equivalent note above MHF4U.
delete from public.units
where course_id = (select id from public.courses where code = 'MTH1W')
  and code in ('linear-relations', 'geometry-and-measurement', 'data-and-financial-literacy');

delete from public.subtopics
where unit_id = (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MTH1W' and un.code = 'number-sense'
) and code in (
  'order-of-operations', 'integer-operations', 'exponent-rules',
  'fractions-and-ratios', 'percent-and-estimation'
);

delete from public.subtopics
where unit_id = (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MTH1W' and un.code = 'algebraic-expressions'
) and code in (
  'expanding-expressions', 'evaluating-expressions',
  'solving-two-step-equations', 'solving-multi-step-equations'
);

with c as (select id from public.courses where code = 'MTH1W'),
unit_data (code, title, description, color, order_index) as (
  values
    ('number-sense', 'Number sense',
     'Integers, ratios, rates and proportions, fractions, number sets, and density and limits.', '#5B8DEF', 0),
    ('powers', 'Powers',
     'Powers and exponent form, scientific notation, product, quotient and power laws, power of a product or quotient, and negative exponents.', '#4CAF93', 1),
    ('algebraic-expressions', 'Algebraic expressions',
     'Terms, degree and naming polynomials, collecting like terms, adding and subtracting polynomials, distributive property, and multiplying binomials.', '#E0834B', 2),
    ('solving-equations', 'Solving equations',
     'Solving multi-step linear equations, equations involving fractions, simple quadratic and cubic equations, rearranging formulas, linear inequalities, and turning word problems into equations.', '#B15BE0', 3),
    ('linear-relations-part-1', 'Linear relations part 1',
     'Plotting points and the Cartesian plane, linear vs non-linear and first differences, slope and rate of change, slope-intercept form, standard form and intercepts, parallel and perpendicular lines, and finding the equation of a line.', '#D4A017', 4),
    ('linear-relations-part-2', 'Linear relations part 2',
     'Solving linear systems, how many solutions a system has, transformations of linear functions, graphing inequalities in two variables, and reciprocal relationships.', '#2E9B98', 5),
    ('geometry', 'Geometry',
     'Angle relationships and polygons, angles in triangles and circles, area and perimeter of composite shapes, pythagorean theorem, and surface area and volume.', '#E85B7A', 6),
    ('data', 'Data',
     'Measures of central tendency, averages from a frequency table, measures of spread, boxplots and the five-number summary, and scatterplots and correlation.', '#7C8CE0', 7),
    ('financial-literacy', 'Financial literacy',
     'Simple interest, compound interest, appreciation and depreciation, budgeting, and loans, credit and repayment.', '#4B9E5B', 8)
)
insert into public.units (course_id, code, title, description, color, order_index)
select c.id, u.code, u.title, u.description, u.color, u.order_index from unit_data u, c
on conflict (course_id, code) do update
  set title = excluded.title,
      description = excluded.description,
      color = excluded.color,
      order_index = excluded.order_index;

-- Number sense ----------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MTH1W' and un.code = 'number-sense'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('integers', 'Integers',
     'Practice questions on integers.', 0),
    ('ratios-rates-and-proportions', 'Ratios, rates and proportions',
     'Practice questions on ratios, rates and proportions.', 1),
    ('fractions', 'Fractions',
     'Practice questions on fractions.', 2),
    ('number-sets', 'Number sets',
     'Practice questions on number sets.', 3),
    ('density-and-limits', 'Density and limits',
     'Practice questions on density and limits.', 4)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Powers ----------------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MTH1W' and un.code = 'powers'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('powers-and-exponent-form', 'Powers and exponent form',
     'Practice questions on powers and exponent form.', 0),
    ('scientific-notation', 'Scientific notation',
     'Practice questions on scientific notation.', 1),
    ('product-quotient-and-power-laws', 'Product, quotient and power laws',
     'Practice questions on product, quotient and power laws.', 2),
    ('power-of-a-product-or-quotient', 'Power of a product or quotient',
     'Practice questions on power of a product or quotient.', 3),
    ('negative-exponents', 'Negative exponents',
     'Practice questions on negative exponents.', 4)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Algebraic expressions -------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MTH1W' and un.code = 'algebraic-expressions'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('terms-degree-and-naming-polynomials', 'Terms, degree and naming polynomials',
     'Practice questions on terms, degree and naming polynomials.', 0),
    ('collecting-like-terms', 'Collecting like terms',
     'Practice questions on collecting like terms.', 1),
    ('adding-and-subtracting-polynomials', 'Adding and subtracting polynomials',
     'Practice questions on adding and subtracting polynomials.', 2),
    ('distributive-property', 'Distributive property',
     'Practice questions on distributive property.', 3),
    ('multiplying-binomials', 'Multiplying binomials',
     'Practice questions on multiplying binomials.', 4)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Solving equations -----------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MTH1W' and un.code = 'solving-equations'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('solving-multi-step-linear-equations', 'Solving multi-step linear equations',
     'Practice questions on solving multi-step linear equations.', 0),
    ('equations-involving-fractions', 'Equations involving fractions',
     'Practice questions on equations involving fractions.', 1),
    ('simple-quadratic-and-cubic-equations', 'Simple quadratic and cubic equations',
     'Practice questions on simple quadratic and cubic equations.', 2),
    ('rearranging-formulas', 'Rearranging formulas',
     'Practice questions on rearranging formulas.', 3),
    ('linear-inequalities', 'Linear inequalities',
     'Practice questions on linear inequalities.', 4),
    ('turning-word-problems-into-equations', 'Turning word problems into equations',
     'Practice questions on turning word problems into equations.', 5)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Linear relations part 1 -----------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MTH1W' and un.code = 'linear-relations-part-1'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('plotting-points-and-the-cartesian-plane', 'Plotting points and the Cartesian plane',
     'Practice questions on plotting points and the Cartesian plane.', 0),
    ('linear-vs-non-linear-and-first-differences', 'Linear vs non-linear and first differences',
     'Practice questions on linear vs non-linear and first differences.', 1),
    ('slope-and-rate-of-change', 'Slope and rate of change',
     'Practice questions on slope and rate of change.', 2),
    ('slope-intercept-form', 'Slope-intercept form',
     'Practice questions on slope-intercept form.', 3),
    ('standard-form-and-intercepts', 'Standard form and intercepts',
     'Practice questions on standard form and intercepts.', 4),
    ('parallel-and-perpendicular-lines', 'Parallel and perpendicular lines',
     'Practice questions on parallel and perpendicular lines.', 5),
    ('finding-the-equation-of-a-line', 'Finding the equation of a line',
     'Practice questions on finding the equation of a line.', 6)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Linear relations part 2 -----------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MTH1W' and un.code = 'linear-relations-part-2'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('solving-linear-systems', 'Solving linear systems',
     'Practice questions on solving linear systems.', 0),
    ('how-many-solutions-a-system-has', 'How many solutions a system has',
     'Practice questions on how many solutions a system has.', 1),
    ('transformations-of-linear-functions', 'Transformations of linear functions',
     'Practice questions on transformations of linear functions.', 2),
    ('graphing-inequalities-in-two-variables', 'Graphing inequalities in two variables',
     'Practice questions on graphing inequalities in two variables.', 3),
    ('reciprocal-relationships', 'Reciprocal relationships',
     'Practice questions on reciprocal relationships.', 4)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Geometry --------------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MTH1W' and un.code = 'geometry'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('angle-relationships-and-polygons', 'Angle relationships and polygons',
     'Practice questions on angle relationships and polygons.', 0),
    ('angles-in-triangles-and-circles', 'Angles in triangles and circles',
     'Practice questions on angles in triangles and circles.', 1),
    ('area-and-perimeter-of-composite-shapes', 'Area and perimeter of composite shapes',
     'Practice questions on area and perimeter of composite shapes.', 2),
    ('pythagorean-theorem', 'Pythagorean theorem',
     'Practice questions on pythagorean theorem.', 3),
    ('surface-area-and-volume', 'Surface area and volume',
     'Practice questions on surface area and volume.', 4)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Data ------------------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MTH1W' and un.code = 'data'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('measures-of-central-tendency', 'Measures of central tendency',
     'Practice questions on measures of central tendency.', 0),
    ('averages-from-a-frequency-table', 'Averages from a frequency table',
     'Practice questions on averages from a frequency table.', 1),
    ('measures-of-spread', 'Measures of spread',
     'Practice questions on measures of spread.', 2),
    ('boxplots-and-the-five-number-summary', 'Boxplots and the five-number summary',
     'Practice questions on boxplots and the five-number summary.', 3),
    ('scatterplots-and-correlation', 'Scatterplots and correlation',
     'Practice questions on scatterplots and correlation.', 4)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Financial literacy ----------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MTH1W' and un.code = 'financial-literacy'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('simple-interest', 'Simple interest',
     'Practice questions on simple interest.', 0),
    ('compound-interest', 'Compound interest',
     'Practice questions on compound interest.', 1),
    ('appreciation-and-depreciation', 'Appreciation and depreciation',
     'Practice questions on appreciation and depreciation.', 2),
    ('budgeting', 'Budgeting',
     'Practice questions on budgeting.', 3),
    ('loans-credit-and-repayment', 'Loans, credit and repayment',
     'Practice questions on loans, credit and repayment.', 4)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- ===========================================================================
-- Grade 10 — MPM2D
-- ===========================================================================

-- Old unit that no longer exists under any of the new codes below, plus
-- old subtopics under units whose code persisted but whose subtopic list
-- changed -- see the equivalent note above MHF4U.
delete from public.units
where course_id = (select id from public.courses where code = 'MPM2D')
  and code = 'quadratic-relations';

delete from public.subtopics
where unit_id = (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MPM2D' and un.code = 'linear-systems'
) and code = 'number-of-solutions';

delete from public.subtopics
where unit_id = (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MPM2D' and un.code = 'analytic-geometry'
) and code in (
  'length-of-a-line-segment', 'midpoint-of-a-line-segment',
  'slope-and-equation-of-a-line', 'classifying-shapes', 'verifying-properties'
);

delete from public.subtopics
where unit_id = (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MPM2D' and un.code = 'trigonometry'
) and code in (
  'primary-trig-ratios', 'solving-right-triangles',
  'elevation-and-depression', 'acute-triangle-applications'
);

with c as (select id from public.courses where code = 'MPM2D'),
unit_data (code, title, description, color, order_index) as (
  values
    ('linear-systems', 'Linear systems',
     'Solving by graphing, solving by substitution, solving by elimination, and linear system applications.', '#5B8DEF', 0),
    ('analytic-geometry', 'Analytic geometry',
     'Midpoint and length of a line segment, medians, right bisectors and altitudes, equation of a circle, and geometric properties of shapes.', '#4CAF93', 1),
    ('factoring', 'Factoring',
     'Multiplying binomials, common factoring, factoring ax² + bx + c, factoring x² + bx + c, and special products.', '#E0834B', 2),
    ('quadratics', 'Quadratics',
     'Properties of quadratics, vertex form, completing the square, and factored form and zeros.', '#B15BE0', 3),
    ('solving-quadratic-equations', 'Solving quadratic equations',
     'Solving by factoring, solving by completing the square, the quadratic formula, standard form analysis, and applications of quadratics.', '#D4A017', 4),
    ('trigonometry', 'Trigonometry',
     'Similar triangles, the primary trig ratios, trig for angles, trig for side lengths, sine law, and cosine law.', '#2E9B98', 5)
)
insert into public.units (course_id, code, title, description, color, order_index)
select c.id, u.code, u.title, u.description, u.color, u.order_index from unit_data u, c
on conflict (course_id, code) do update
  set title = excluded.title,
      description = excluded.description,
      color = excluded.color,
      order_index = excluded.order_index;

-- Linear systems --------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MPM2D' and un.code = 'linear-systems'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('solving-by-graphing', 'Solving by graphing',
     'Practice questions on solving by graphing.', 0),
    ('solving-by-substitution', 'Solving by substitution',
     'Practice questions on solving by substitution.', 1),
    ('solving-by-elimination', 'Solving by elimination',
     'Practice questions on solving by elimination.', 2),
    ('linear-system-applications', 'Linear system applications',
     'Practice questions on linear system applications.', 3)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Analytic geometry -----------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MPM2D' and un.code = 'analytic-geometry'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('midpoint-and-length-of-a-line-segment', 'Midpoint and length of a line segment',
     'Practice questions on midpoint and length of a line segment.', 0),
    ('medians-right-bisectors-and-altitudes', 'Medians, right bisectors and altitudes',
     'Practice questions on medians, right bisectors and altitudes.', 1),
    ('equation-of-a-circle', 'Equation of a circle',
     'Practice questions on equation of a circle.', 2),
    ('geometric-properties-of-shapes', 'Geometric properties of shapes',
     'Practice questions on geometric properties of shapes.', 3)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Factoring -------------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MPM2D' and un.code = 'factoring'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('multiplying-binomials', 'Multiplying binomials',
     'Practice questions on multiplying binomials.', 0),
    ('common-factoring', 'Common factoring',
     'Practice questions on common factoring.', 1),
    ('factoring-ax-bx-c', 'Factoring ax² + bx + c',
     'Practice questions on factoring ax² + bx + c.', 2),
    ('factoring-x-bx-c', 'Factoring x² + bx + c',
     'Practice questions on factoring x² + bx + c.', 3),
    ('special-products', 'Special products',
     'Practice questions on special products.', 4)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Quadratics ------------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MPM2D' and un.code = 'quadratics'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('properties-of-quadratics', 'Properties of quadratics',
     'Practice questions on properties of quadratics.', 0),
    ('vertex-form', 'Vertex form',
     'Practice questions on vertex form.', 1),
    ('completing-the-square', 'Completing the square',
     'Practice questions on completing the square.', 2),
    ('factored-form-and-zeros', 'Factored form and zeros',
     'Practice questions on factored form and zeros.', 3)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Solving quadratic equations -------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MPM2D' and un.code = 'solving-quadratic-equations'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('solving-by-factoring', 'Solving by factoring',
     'Practice questions on solving by factoring.', 0),
    ('solving-by-completing-the-square', 'Solving by completing the square',
     'Practice questions on solving by completing the square.', 1),
    ('the-quadratic-formula', 'The quadratic formula',
     'Practice questions on the quadratic formula.', 2),
    ('standard-form-analysis', 'Standard form analysis',
     'Practice questions on standard form analysis.', 3),
    ('applications-of-quadratics', 'Applications of quadratics',
     'Practice questions on applications of quadratics.', 4)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Trigonometry ----------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MPM2D' and un.code = 'trigonometry'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('similar-triangles', 'Similar triangles',
     'Practice questions on similar triangles.', 0),
    ('the-primary-trig-ratios', 'The primary trig ratios',
     'Practice questions on the primary trig ratios.', 1),
    ('trig-for-angles', 'Trig for angles',
     'Practice questions on trig for angles.', 2),
    ('trig-for-side-lengths', 'Trig for side lengths',
     'Practice questions on trig for side lengths.', 3),
    ('sine-law', 'Sine law',
     'Practice questions on sine law.', 4),
    ('cosine-law', 'Cosine law',
     'Practice questions on cosine law.', 5)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- ===========================================================================
-- Grade 11 — MCR3U
-- ===========================================================================

-- Old units that no longer exist under any of the new codes below -- see
-- the equivalent note above MHF4U.
delete from public.units
where course_id = (select id from public.courses where code = 'MCR3U')
  and code in (
    'functions-fundamentals', 'quadratic-and-exponential-functions',
    'trigonometric-functions', 'sequences-and-series'
  );

with c as (select id from public.courses where code = 'MCR3U'),
unit_data (code, title, description, color, order_index) as (
  values
    ('functions', 'Functions',
     'Domain and range, function notation, max and min of quadratics, working with radicals, solving by factoring, the quadratic formula, and linear-quadratic systems.', '#5B8DEF', 0),
    ('rational-expressions', 'Rational Expressions',
     'Exponent rules, rational exponents, restrictions on the variable, simplifying, multiplying and dividing, and adding and subtracting.', '#4CAF93', 1),
    ('transformations', 'Transformations',
     'Reading a, k, d and c, transforming x squared, transforming the square root, transforming 1 over x, and inverse of a function.', '#E0834B', 2),
    ('exponential-functions', 'Exponential Functions',
     'Exponential growth, exponential decay, compound interest, properties of exponential functions, and transforming exponential functions.', '#B15BE0', 3),
    ('trig-geometry', 'Trig Geometry',
     'Special angles and exact ratios, ratios for angles beyond 90 degrees, solving trig equations, reciprocal trig ratios, sine law, cosine law and the ambiguous case, and trig identities.', '#D4A017', 4),
    ('trig-functions', 'Trig Functions',
     'Periodic behaviour, graphing sine and cosine, reading a trig equation, building a trig equation, and trig applications.', '#2E9B98', 5),
    ('discrete-functions', 'Discrete Functions',
     'Arithmetic sequences, geometric sequences, arithmetic series, geometric series, and recursion and Pascal triangle.', '#E85B7A', 6)
)
insert into public.units (course_id, code, title, description, color, order_index)
select c.id, u.code, u.title, u.description, u.color, u.order_index from unit_data u, c
on conflict (course_id, code) do update
  set title = excluded.title,
      description = excluded.description,
      color = excluded.color,
      order_index = excluded.order_index;

-- Functions -------------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MCR3U' and un.code = 'functions'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('domain-and-range', 'Domain and range',
     'Practice questions on domain and range.', 0),
    ('function-notation', 'Function notation',
     'Practice questions on function notation.', 1),
    ('max-and-min-of-quadratics', 'Max and min of quadratics',
     'Practice questions on max and min of quadratics.', 2),
    ('working-with-radicals', 'Working with radicals',
     'Practice questions on working with radicals.', 3),
    ('solving-by-factoring', 'Solving by factoring',
     'Practice questions on solving by factoring.', 4),
    ('the-quadratic-formula', 'The quadratic formula',
     'Practice questions on the quadratic formula.', 5),
    ('linear-quadratic-systems', 'Linear-quadratic systems',
     'Practice questions on linear-quadratic systems.', 6)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Rational Expressions --------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MCR3U' and un.code = 'rational-expressions'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('exponent-rules', 'Exponent rules',
     'Practice questions on exponent rules.', 0),
    ('rational-exponents', 'Rational exponents',
     'Practice questions on rational exponents.', 1),
    ('restrictions-on-the-variable', 'Restrictions on the variable',
     'Practice questions on restrictions on the variable.', 2),
    ('simplifying-multiplying-and-dividing', 'Simplifying, multiplying and dividing',
     'Practice questions on simplifying, multiplying and dividing.', 3),
    ('adding-and-subtracting', 'Adding and subtracting',
     'Practice questions on adding and subtracting.', 4)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Transformations -------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MCR3U' and un.code = 'transformations'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('reading-a-k-d-and-c', 'Reading a, k, d and c',
     'Practice questions on reading a, k, d and c.', 0),
    ('transforming-x-squared', 'Transforming x squared',
     'Practice questions on transforming x squared.', 1),
    ('transforming-the-square-root', 'Transforming the square root',
     'Practice questions on transforming the square root.', 2),
    ('transforming-1-over-x', 'Transforming 1 over x',
     'Practice questions on transforming 1 over x.', 3),
    ('inverse-of-a-function', 'Inverse of a function',
     'Practice questions on inverse of a function.', 4)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Exponential Functions -------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MCR3U' and un.code = 'exponential-functions'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('exponential-growth', 'Exponential growth',
     'Practice questions on exponential growth.', 0),
    ('exponential-decay', 'Exponential decay',
     'Practice questions on exponential decay.', 1),
    ('compound-interest', 'Compound interest',
     'Practice questions on compound interest.', 2),
    ('properties-of-exponential-functions', 'Properties of exponential functions',
     'Practice questions on properties of exponential functions.', 3),
    ('transforming-exponential-functions', 'Transforming exponential functions',
     'Practice questions on transforming exponential functions.', 4)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Trig Geometry ---------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MCR3U' and un.code = 'trig-geometry'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('special-angles-and-exact-ratios', 'Special angles and exact ratios',
     'Practice questions on special angles and exact ratios.', 0),
    ('ratios-for-angles-beyond-90-degrees', 'Ratios for angles beyond 90 degrees',
     'Practice questions on ratios for angles beyond 90 degrees.', 1),
    ('solving-trig-equations', 'Solving trig equations',
     'Practice questions on solving trig equations.', 2),
    ('reciprocal-trig-ratios', 'Reciprocal trig ratios',
     'Practice questions on reciprocal trig ratios.', 3),
    ('sine-law-cosine-law-and-the-ambiguous-case', 'Sine law, cosine law and the ambiguous case',
     'Practice questions on sine law, cosine law and the ambiguous case.', 4),
    ('trig-identities', 'Trig identities',
     'Practice questions on trig identities.', 5)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Trig Functions --------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MCR3U' and un.code = 'trig-functions'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('periodic-behaviour', 'Periodic behaviour',
     'Practice questions on periodic behaviour.', 0),
    ('graphing-sine-and-cosine', 'Graphing sine and cosine',
     'Practice questions on graphing sine and cosine.', 1),
    ('reading-a-trig-equation', 'Reading a trig equation',
     'Practice questions on reading a trig equation.', 2),
    ('building-a-trig-equation', 'Building a trig equation',
     'Practice questions on building a trig equation.', 3),
    ('trig-applications', 'Trig applications',
     'Practice questions on trig applications.', 4)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Discrete Functions ----------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MCR3U' and un.code = 'discrete-functions'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('arithmetic-sequences', 'Arithmetic sequences',
     'Practice questions on arithmetic sequences.', 0),
    ('geometric-sequences', 'Geometric sequences',
     'Practice questions on geometric sequences.', 1),
    ('arithmetic-series', 'Arithmetic series',
     'Practice questions on arithmetic series.', 2),
    ('geometric-series', 'Geometric series',
     'Practice questions on geometric series.', 3),
    ('recursion-and-pascal-triangle', 'Recursion and Pascal triangle',
     'Practice questions on recursion and Pascal triangle.', 4)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- ===========================================================================
-- Grade 12 — MHF4U
-- ===========================================================================

-- Old units that no longer exist under any of the new codes below --
-- delete explicitly so re-running this file doesn't leave stale
-- units/subtopics behind (see the MPM1D note near the top of this file
-- for why `on conflict` alone can't do this).
delete from public.units
where course_id = (select id from public.courses where code = 'MHF4U')
  and code in (
    'polynomial-and-rational-functions', 'exponential-and-logarithmic-functions',
    'trigonometric-functions', 'combining-functions'
  );

with c as (select id from public.courses where code = 'MHF4U'),
unit_data (code, title, description, color, order_index) as (
  values
    ('polynomial-functions', 'Polynomial Functions',
     'Power functions and end behaviour, characteristics of polynomials, factored form and zeros, transforming polynomials, and even, odd and symmetry.', '#5B8DEF', 0),
    ('factoring-polynomials', 'Factoring Polynomials',
     'Long and synthetic division, the remainder theorem, the factor theorem and factoring, solving polynomial equations, and polynomial inequalities.', '#4CAF93', 1),
    ('logarithmic-functions', 'Logarithmic Functions',
     'Logs as the inverse of exponentials, laws of logarithms and change of base, solving exponential equations, solving logarithmic equations, and applications and transformations.', '#E0834B', 2),
    ('trig-in-radians', 'Trig in Radians',
     'Radian measure and arc length, exact trig ratios in radians, the six trig functions and their graphs, transforming trig functions, and trig applications in radians.', '#B15BE0', 3),
    ('trig-identities-and-equations', 'Trig identities and equations',
     'Cofunction and transformation identities, compound angle formulas, double angle formulas, proving trig identities, and solving trig equations.', '#D4A017', 4),
    ('rates-of-change', 'Rates of Change',
     'Average rate of change, instantaneous rate of change, the Newton quotient, limits, and interpreting a rate of change.', '#2E9B98', 5),
    ('rational-functions', 'Rational Functions',
     'Reciprocal of a linear or quadratic function, quotient of linear functions, combining functions, composite functions, solving rational equations, and solving rational inequalities.', '#E85B7A', 6)
)
insert into public.units (course_id, code, title, description, color, order_index)
select c.id, u.code, u.title, u.description, u.color, u.order_index from unit_data u, c
on conflict (course_id, code) do update
  set title = excluded.title,
      description = excluded.description,
      color = excluded.color,
      order_index = excluded.order_index;

-- Polynomial Functions --------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MHF4U' and un.code = 'polynomial-functions'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('power-functions-and-end-behaviour', 'Power functions and end behaviour',
     'Practice questions on power functions and end behaviour.', 0),
    ('characteristics-of-polynomials', 'Characteristics of polynomials',
     'Practice questions on characteristics of polynomials.', 1),
    ('factored-form-and-zeros', 'Factored form and zeros',
     'Practice questions on factored form and zeros.', 2),
    ('transforming-polynomials', 'Transforming polynomials',
     'Practice questions on transforming polynomials.', 3),
    ('even-odd-and-symmetry', 'Even, odd and symmetry',
     'Practice questions on even, odd and symmetry.', 4)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Factoring Polynomials -------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MHF4U' and un.code = 'factoring-polynomials'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('long-and-synthetic-division', 'Long and synthetic division',
     'Practice questions on long and synthetic division.', 0),
    ('the-remainder-theorem', 'The remainder theorem',
     'Practice questions on the remainder theorem.', 1),
    ('the-factor-theorem-and-factoring', 'The factor theorem and factoring',
     'Practice questions on the factor theorem and factoring.', 2),
    ('solving-polynomial-equations', 'Solving polynomial equations',
     'Practice questions on solving polynomial equations.', 3),
    ('polynomial-inequalities', 'Polynomial inequalities',
     'Practice questions on polynomial inequalities.', 4)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Logarithmic Functions -------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MHF4U' and un.code = 'logarithmic-functions'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('logs-as-the-inverse-of-exponentials', 'Logs as the inverse of exponentials',
     'Practice questions on logs as the inverse of exponentials.', 0),
    ('laws-of-logarithms-and-change-of-base', 'Laws of logarithms and change of base',
     'Practice questions on laws of logarithms and change of base.', 1),
    ('solving-exponential-equations', 'Solving exponential equations',
     'Practice questions on solving exponential equations.', 2),
    ('solving-logarithmic-equations', 'Solving logarithmic equations',
     'Practice questions on solving logarithmic equations.', 3),
    ('applications-and-transformations', 'Applications and transformations',
     'Practice questions on applications and transformations.', 4)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Trig in Radians -------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MHF4U' and un.code = 'trig-in-radians'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('radian-measure-and-arc-length', 'Radian measure and arc length',
     'Practice questions on radian measure and arc length.', 0),
    ('exact-trig-ratios-in-radians', 'Exact trig ratios in radians',
     'Practice questions on exact trig ratios in radians.', 1),
    ('the-six-trig-functions-and-their-graphs', 'The six trig functions and their graphs',
     'Practice questions on the six trig functions and their graphs.', 2),
    ('transforming-trig-functions', 'Transforming trig functions',
     'Practice questions on transforming trig functions.', 3),
    ('trig-applications-in-radians', 'Trig applications in radians',
     'Practice questions on trig applications in radians.', 4)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Trig identities and equations -----------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MHF4U' and un.code = 'trig-identities-and-equations'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('cofunction-and-transformation-identities', 'Cofunction and transformation identities',
     'Practice questions on cofunction and transformation identities.', 0),
    ('compound-angle-formulas', 'Compound angle formulas',
     'Practice questions on compound angle formulas.', 1),
    ('double-angle-formulas', 'Double angle formulas',
     'Practice questions on double angle formulas.', 2),
    ('proving-trig-identities', 'Proving trig identities',
     'Practice questions on proving trig identities.', 3),
    ('solving-trig-equations', 'Solving trig equations',
     'Practice questions on solving trig equations.', 4)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Rates of Change -------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MHF4U' and un.code = 'rates-of-change'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('average-rate-of-change', 'Average rate of change',
     'Practice questions on average rate of change.', 0),
    ('instantaneous-rate-of-change', 'Instantaneous rate of change',
     'Practice questions on instantaneous rate of change.', 1),
    ('the-newton-quotient', 'The Newton quotient',
     'Practice questions on the Newton quotient.', 2),
    ('limits', 'Limits',
     'Practice questions on limits.', 3),
    ('interpreting-a-rate-of-change', 'Interpreting a rate of change',
     'Practice questions on interpreting a rate of change.', 4)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Rational Functions ----------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MHF4U' and un.code = 'rational-functions'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('reciprocal-of-a-linear-or-quadratic-function', 'Reciprocal of a linear or quadratic function',
     'Practice questions on reciprocal of a linear or quadratic function.', 0),
    ('quotient-of-linear-functions', 'Quotient of linear functions',
     'Practice questions on quotient of linear functions.', 1),
    ('combining-functions', 'Combining functions',
     'Practice questions on combining functions.', 2),
    ('composite-functions', 'Composite functions',
     'Practice questions on composite functions.', 3),
    ('solving-rational-equations', 'Solving rational equations',
     'Practice questions on solving rational equations.', 4),
    ('solving-rational-inequalities', 'Solving rational inequalities',
     'Practice questions on solving rational inequalities.', 5)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- ===========================================================================
-- Grade 12 — MCV4U
-- ===========================================================================

with c as (select id from public.courses where code = 'MCV4U'),
unit_data (code, title, description, color, order_index) as (
  values
    ('derivative-rules', 'Derivative Rules',
     'Power, constant and sum rules, the product rule, the quotient rule, the chain rule, displacement, velocity and acceleration, and applications of rates of change.', '#5B8DEF', 0),
    ('curve-sketching', 'Curve Sketching',
     'Increasing and decreasing intervals, critical numbers and extrema, concavity and the second derivative, sketching rational functions, putting a full sketch together, and optimization.', '#4CAF93', 1),
    ('derivatives-of-trig-and-exponential-functions', 'Derivatives of trig and exponential functions',
     'Derivatives of trig functions, derivative rules with trig functions, derivatives of exponential functions, derivative rules with exponential functions, implicit differentiation and logarithms, and applications of trig and exponential derivatives.', '#E0834B', 2),
    ('geometric-vectors', 'Geometric Vectors',
     'What a vector is, and how direction is written, adding and subtracting vectors, scalar multiplication of vectors, resolving a vector into components, resultant and equilibrant forces, and resultant velocity problems.', '#B15BE0', 3),
    ('algebraic-vectors', 'Algebraic Vectors',
     'Cartesian vectors and magnitude, the dot product, applications of the dot product, vectors in three dimensions, the cross product, and applications of the cross product.', '#D4A017', 4),
    ('lines-and-planes', 'Lines and Planes',
     'Equations of lines in 2-space, equations of lines in 3-space, vector equation of a plane, scalar equation of a plane, intersections of lines, and intersections of planes.', '#2E9B98', 5)
)
insert into public.units (course_id, code, title, description, color, order_index)
select c.id, u.code, u.title, u.description, u.color, u.order_index from unit_data u, c
on conflict (course_id, code) do update
  set title = excluded.title,
      description = excluded.description,
      color = excluded.color,
      order_index = excluded.order_index;

-- Derivative Rules ------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MCV4U' and un.code = 'derivative-rules'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('power-constant-and-sum-rules', 'Power, constant and sum rules',
     'Practice questions on power, constant and sum rules.', 0),
    ('the-product-rule', 'The product rule',
     'Practice questions on the product rule.', 1),
    ('the-quotient-rule', 'The quotient rule',
     'Practice questions on the quotient rule.', 2),
    ('the-chain-rule', 'The chain rule',
     'Practice questions on the chain rule.', 3),
    ('displacement-velocity-and-acceleration', 'Displacement, velocity and acceleration',
     'Practice questions on displacement, velocity and acceleration.', 4),
    ('applications-of-rates-of-change', 'Applications of rates of change',
     'Practice questions on applications of rates of change.', 5)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Curve Sketching -------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MCV4U' and un.code = 'curve-sketching'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('increasing-and-decreasing-intervals', 'Increasing and decreasing intervals',
     'Practice questions on increasing and decreasing intervals.', 0),
    ('critical-numbers-and-extrema', 'Critical numbers and extrema',
     'Practice questions on critical numbers and extrema.', 1),
    ('concavity-and-the-second-derivative', 'Concavity and the second derivative',
     'Practice questions on concavity and the second derivative.', 2),
    ('sketching-rational-functions', 'Sketching rational functions',
     'Practice questions on sketching rational functions.', 3),
    ('putting-a-full-sketch-together', 'Putting a full sketch together',
     'Practice questions on putting a full sketch together.', 4),
    ('optimization', 'Optimization',
     'Practice questions on optimization.', 5)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Derivatives of trig and exponential functions -------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MCV4U' and un.code = 'derivatives-of-trig-and-exponential-functions'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('derivatives-of-trig-functions', 'Derivatives of trig functions',
     'Practice questions on derivatives of trig functions.', 0),
    ('derivative-rules-with-trig-functions', 'Derivative rules with trig functions',
     'Practice questions on derivative rules with trig functions.', 1),
    ('derivatives-of-exponential-functions', 'Derivatives of exponential functions',
     'Practice questions on derivatives of exponential functions.', 2),
    ('derivative-rules-with-exponential-functions', 'Derivative rules with exponential functions',
     'Practice questions on derivative rules with exponential functions.', 3),
    ('implicit-differentiation-and-logarithms', 'Implicit differentiation and logarithms',
     'Practice questions on implicit differentiation and logarithms.', 4),
    ('applications-of-trig-and-exponential-derivatives', 'Applications of trig and exponential derivatives',
     'Practice questions on applications of trig and exponential derivatives.', 5)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Geometric Vectors -----------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MCV4U' and un.code = 'geometric-vectors'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('what-a-vector-is-and-how-direction-is-written', 'What a vector is, and how direction is written',
     'Practice questions on what a vector is, and how direction is written.', 0),
    ('adding-and-subtracting-vectors', 'Adding and subtracting vectors',
     'Practice questions on adding and subtracting vectors.', 1),
    ('scalar-multiplication-of-vectors', 'Scalar multiplication of vectors',
     'Practice questions on scalar multiplication of vectors.', 2),
    ('resolving-a-vector-into-components', 'Resolving a vector into components',
     'Practice questions on resolving a vector into components.', 3),
    ('resultant-and-equilibrant-forces', 'Resultant and equilibrant forces',
     'Practice questions on resultant and equilibrant forces.', 4),
    ('resultant-velocity-problems', 'Resultant velocity problems',
     'Practice questions on resultant velocity problems.', 5)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Algebraic Vectors -----------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MCV4U' and un.code = 'algebraic-vectors'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('cartesian-vectors-and-magnitude', 'Cartesian vectors and magnitude',
     'Practice questions on cartesian vectors and magnitude.', 0),
    ('the-dot-product', 'The dot product',
     'Practice questions on the dot product.', 1),
    ('applications-of-the-dot-product', 'Applications of the dot product',
     'Practice questions on applications of the dot product.', 2),
    ('vectors-in-three-dimensions', 'Vectors in three dimensions',
     'Practice questions on vectors in three dimensions.', 3),
    ('the-cross-product', 'The cross product',
     'Practice questions on the cross product.', 4),
    ('applications-of-the-cross-product', 'Applications of the cross product',
     'Practice questions on applications of the cross product.', 5)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Lines and Planes ------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MCV4U' and un.code = 'lines-and-planes'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('equations-of-lines-in-2-space', 'Equations of lines in 2-space',
     'Practice questions on equations of lines in 2-space.', 0),
    ('equations-of-lines-in-3-space', 'Equations of lines in 3-space',
     'Practice questions on equations of lines in 3-space.', 1),
    ('vector-equation-of-a-plane', 'Vector equation of a plane',
     'Practice questions on vector equation of a plane.', 2),
    ('scalar-equation-of-a-plane', 'Scalar equation of a plane',
     'Practice questions on scalar equation of a plane.', 3),
    ('intersections-of-lines', 'Intersections of lines',
     'Practice questions on intersections of lines.', 4),
    ('intersections-of-planes', 'Intersections of planes',
     'Practice questions on intersections of planes.', 5)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- ===========================================================================
-- Grade 12 — MDM4U
-- ===========================================================================

with c as (select id from public.courses where code = 'MDM4U'),
unit_data (code, title, description, color, order_index) as (
  values
    ('displays-of-data', 'Displays of Data',
     'Populations, samples and types of data, displaying categoric data, displaying numeric data, scatter plots and correlation, linear regression, and misleading graphs.', '#5B8DEF', 0),
    ('collecting-data', 'Collecting Data',
     'Theses, variables and sources of data, characteristics of data, sampling methods, survey and question design, types of bias, and experiment design.', '#4CAF93', 1),
    ('normal-distributions', 'Normal Distributions',
     'Shapes of distributions, measures of central tendency, measures of spread, the normal distribution, Z-scores and probabilities, and confidence intervals.', '#E0834B', 2),
    ('probability', 'Probability',
     'Experimental probability, theoretical probability, probability using sets, conditional probability, independent and dependent events, and permutations and combinations.', '#B15BE0', 3),
    ('probability-distributions', 'Probability distributions',
     'Probability distributions, expected value, hypergeometric distributions, binomial distributions, geometric distributions, and the binomial theorem.', '#D4A017', 4)
)
insert into public.units (course_id, code, title, description, color, order_index)
select c.id, u.code, u.title, u.description, u.color, u.order_index from unit_data u, c
on conflict (course_id, code) do update
  set title = excluded.title,
      description = excluded.description,
      color = excluded.color,
      order_index = excluded.order_index;

-- Displays of Data ------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MDM4U' and un.code = 'displays-of-data'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('populations-samples-and-types-of-data', 'Populations, samples and types of data',
     'Practice questions on populations, samples and types of data.', 0),
    ('displaying-categoric-data', 'Displaying categoric data',
     'Practice questions on displaying categoric data.', 1),
    ('displaying-numeric-data', 'Displaying numeric data',
     'Practice questions on displaying numeric data.', 2),
    ('scatter-plots-and-correlation', 'Scatter plots and correlation',
     'Practice questions on scatter plots and correlation.', 3),
    ('linear-regression', 'Linear regression',
     'Practice questions on linear regression.', 4),
    ('misleading-graphs', 'Misleading graphs',
     'Practice questions on misleading graphs.', 5)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Collecting Data -------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MDM4U' and un.code = 'collecting-data'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('theses-variables-and-sources-of-data', 'Theses, variables and sources of data',
     'Practice questions on theses, variables and sources of data.', 0),
    ('characteristics-of-data', 'Characteristics of data',
     'Practice questions on characteristics of data.', 1),
    ('sampling-methods', 'Sampling methods',
     'Practice questions on sampling methods.', 2),
    ('survey-and-question-design', 'Survey and question design',
     'Practice questions on survey and question design.', 3),
    ('types-of-bias', 'Types of bias',
     'Practice questions on types of bias.', 4),
    ('experiment-design', 'Experiment design',
     'Practice questions on experiment design.', 5)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Normal Distributions --------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MDM4U' and un.code = 'normal-distributions'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('shapes-of-distributions', 'Shapes of distributions',
     'Practice questions on shapes of distributions.', 0),
    ('measures-of-central-tendency', 'Measures of central tendency',
     'Practice questions on measures of central tendency.', 1),
    ('measures-of-spread', 'Measures of spread',
     'Practice questions on measures of spread.', 2),
    ('the-normal-distribution', 'The normal distribution',
     'Practice questions on the normal distribution.', 3),
    ('z-scores-and-probabilities', 'Z-scores and probabilities',
     'Practice questions on Z-scores and probabilities.', 4),
    ('confidence-intervals', 'Confidence intervals',
     'Practice questions on confidence intervals.', 5)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Probability -----------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MDM4U' and un.code = 'probability'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('experimental-probability', 'Experimental probability',
     'Practice questions on experimental probability.', 0),
    ('theoretical-probability', 'Theoretical probability',
     'Practice questions on theoretical probability.', 1),
    ('probability-using-sets', 'Probability using sets',
     'Practice questions on probability using sets.', 2),
    ('conditional-probability', 'Conditional probability',
     'Practice questions on conditional probability.', 3),
    ('independent-and-dependent-events', 'Independent and dependent events',
     'Practice questions on independent and dependent events.', 4),
    ('permutations-and-combinations', 'Permutations and combinations',
     'Practice questions on permutations and combinations.', 5)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Probability distributions ---------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MDM4U' and un.code = 'probability-distributions'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('probability-distributions', 'Probability distributions',
     'Practice questions on probability distributions.', 0),
    ('expected-value', 'Expected value',
     'Practice questions on expected value.', 1),
    ('hypergeometric-distributions', 'Hypergeometric distributions',
     'Practice questions on hypergeometric distributions.', 2),
    ('binomial-distributions', 'Binomial distributions',
     'Practice questions on binomial distributions.', 3),
    ('geometric-distributions', 'Geometric distributions',
     'Practice questions on geometric distributions.', 4),
    ('the-binomial-theorem', 'The binomial theorem',
     'Practice questions on the binomial theorem.', 5)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;


-- =============================================================================
-- Grade 10 — SNC2D (Academic Science)
-- =============================================================================

with c as (select id from public.courses where code = 'SNC2D'),
unit_data (code, title, description, color, order_index) as (
  values
    ('tissues-organs-and-systems', 'Biology: Tissues, Organs, and Systems',
     'How cells organize into the tissues, organs, and systems of plants and animals.', '#4CAA6E', 0),
    ('chemical-reactions', 'Chemistry: Chemical Reactions',
     'Atoms, bonding, and chemical reactions, with a focus on acids and bases.', '#8E5BC9', 1),
    ('climate-change', 'Earth and Space Science: Climate Change',
     'The natural and human forces that shape and change Earth''s climate.', '#2E9B98', 2),
    ('light-and-optics', 'Physics: Light and Geometric Optics',
     'How light behaves, bends, and interacts with mirrors, lenses, and matter.', '#E0954B', 3)
)
insert into public.units (course_id, code, title, description, color, order_index)
select c.id, u.code, u.title, u.description, u.color, u.order_index from unit_data u, c
on conflict (course_id, code) do update
  set title = excluded.title,
      description = excluded.description,
      color = excluded.color,
      order_index = excluded.order_index;

-- Biology: Tissues, Organs, and Systems -----------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'SNC2D' and un.code = 'tissues-organs-and-systems'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('cell-theory-and-structure', 'Cell Theory and Cell Structure',
     'The cell theory and the structure and function of plant and animal cell organelles.', 0),
    ('levels-of-organization', 'Levels of Biological Organization',
     'How cells build up into tissues, organs, systems, and whole organisms.', 1),
    ('plant-tissues-and-structures', 'Plant Tissues and Structures',
     'Xylem, phloem, and the specialized tissues of roots, stems, and leaves.', 2),
    ('plant-transport-systems', 'Plant Transport Systems',
     'How water and nutrients move through a plant via transpiration and translocation.', 3),
    ('animal-tissue-types', 'Animal Tissue Types',
     'The four basic animal tissue types: epithelial, connective, muscle, and nervous.', 4),
    ('the-circulatory-system', 'The Circulatory System',
     'The structure of the heart, blood vessels, and blood, and how they move materials.', 5),
    ('the-respiratory-system', 'The Respiratory System',
     'How the lungs and alveoli exchange oxygen and carbon dioxide with the blood.', 6),
    ('the-digestive-system', 'The Digestive System',
     'How the digestive system breaks down and absorbs food mechanically and chemically.', 7),
    ('homeostasis-and-feedback', 'Homeostasis and Feedback Systems',
     'How negative and positive feedback loops keep the body''s internal conditions stable.', 8)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Chemistry: Chemical Reactions ---------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'SNC2D' and un.code = 'chemical-reactions'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('atoms-and-the-periodic-table', 'Atoms, Elements, and the Periodic Table',
     'Atomic structure and how the periodic table organizes elements by properties.', 0),
    ('chemical-bonding', 'Chemical Bonding: Ionic and Covalent',
     'How atoms bond by transferring or sharing electrons.', 1),
    ('naming-compounds', 'Naming Compounds and Chemical Formulas',
     'Naming ionic and molecular compounds and writing their chemical formulas.', 2),
    ('types-of-chemical-reactions', 'Types of Chemical Reactions',
     'Recognizing synthesis, decomposition, displacement, and combustion reactions.', 3),
    ('balancing-chemical-equations', 'Balancing Chemical Equations',
     'Using conservation of mass to balance chemical equations.', 4),
    ('intro-to-acids-and-bases', 'Introduction to Acids and Bases',
     'The properties of acids and bases and how indicators detect them.', 5),
    ('the-ph-scale', 'The pH Scale',
     'What the pH scale measures and how it relates to acidity and basicity.', 6),
    ('acid-base-neutralization', 'Acid-Base Neutralization',
     'What happens when an acid and a base react to form a salt and water.', 7),
    ('acids-bases-and-the-environment', 'Acids, Bases, and the Environment',
     'Real-world acid-base chemistry, from acid rain to buffering in living systems.', 8)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Earth and Space Science: Climate Change -----------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'SNC2D' and un.code = 'climate-change'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('earths-interconnected-spheres', 'Earth''s Interconnected Spheres',
     'How the atmosphere, hydrosphere, lithosphere, and biosphere interact.', 0),
    ('weather-vs-climate', 'Weather vs. Climate',
     'The difference between short-term weather and long-term climate patterns.', 1),
    ('the-greenhouse-effect', 'The Greenhouse Effect',
     'How greenhouse gases trap energy and keep Earth warm enough to live on.', 2),
    ('natural-causes-of-climate-change', 'Natural Causes of Climate Change',
     'Orbital cycles, solar variability, and volcanic activity as natural climate drivers.', 3),
    ('human-impact-on-climate', 'Human Impact on Climate',
     'How burning fossil fuels and land-use change add greenhouse gases to the atmosphere.', 4),
    ('evidence-of-climate-change', 'Evidence of a Changing Climate',
     'Ice cores, temperature records, and sea level data as evidence of climate change.', 5),
    ('climate-feedback-loops', 'Feedback Loops in the Climate System',
     'How positive and negative feedback loops can amplify or dampen climate change.', 6),
    ('consequences-of-climate-change', 'Consequences of Climate Change',
     'The effects of climate change on sea level, weather, and ecosystems.', 7),
    ('responding-to-climate-change', 'Responding to Climate Change',
     'Mitigation and adaptation strategies, from renewable energy to policy.', 8)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Physics: Light and Geometric Optics ----------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'SNC2D' and un.code = 'light-and-optics'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('the-nature-of-light', 'The Nature of Light',
     'Light as an electromagnetic wave and its place in the electromagnetic spectrum.', 0),
    ('rectilinear-propagation', 'Light Travels in Straight Lines',
     'How rectilinear propagation explains shadows, eclipses, and pinhole cameras.', 1),
    ('reflection-of-light', 'Reflection of Light and Plane Mirrors',
     'The law of reflection and how plane mirrors form images.', 2),
    ('curved-mirrors', 'Curved Mirrors',
     'Ray diagrams and image formation in concave and convex mirrors.', 3),
    ('refraction-of-light', 'Refraction of Light',
     'Why light bends when it crosses between materials, and total internal reflection.', 4),
    ('lenses-and-ray-diagrams', 'Lenses and Ray Diagrams',
     'Ray diagrams and image formation in converging and diverging lenses.', 5),
    ('the-human-eye', 'The Human Eye and Vision',
     'The structure of the eye and how lenses correct common vision defects.', 6),
    ('optical-instruments', 'Optical Instruments',
     'How cameras, microscopes, and telescopes combine lenses and mirrors.', 7),
    ('light-and-colour', 'Light and Colour',
     'Why objects appear coloured, and additive versus subtractive colour mixing.', 8)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- =============================================================================
-- Grade 11 — SPH3U (Physics, University Preparation)
-- =============================================================================

with c as (select id from public.courses where code = 'SPH3U'),
unit_data (code, title, description, color, order_index) as (
  values
    ('kinematics', 'Kinematics',
     'Describing motion using position, velocity, acceleration, and graphs.', '#4E7FE0', 0),
    ('dynamics', 'Dynamics',
     'Newton''s laws and the forces that cause and change motion.', '#D65A4A', 1),
    ('energy-and-momentum', 'Energy and Momentum',
     'Work, energy, power, momentum, and collisions.', '#C9820A', 2),
    ('waves-and-sound', 'Waves and Sound',
     'The properties of mechanical waves and sound.', '#7C5CBF', 3),
    ('electricity-and-magnetism', 'Electricity and Magnetism',
     'Electric charge, circuits, and magnetism.', '#C9A227', 4)
)
insert into public.units (course_id, code, title, description, color, order_index)
select c.id, u.code, u.title, u.description, u.color, u.order_index from unit_data u, c
on conflict (course_id, code) do update
  set title = excluded.title,
      description = excluded.description,
      color = excluded.color,
      order_index = excluded.order_index;

-- Kinematics -----------------------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'SPH3U' and un.code = 'kinematics'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('position-distance-displacement', 'Position, Distance, and Displacement',
     'Distinguishing distance and displacement, and describing position along a line.', 0),
    ('speed-and-velocity', 'Speed and Velocity',
     'Calculating average speed and velocity, and the difference between them.', 1),
    ('acceleration', 'Acceleration',
     'Defining acceleration as the rate of change of velocity.', 2),
    ('uniform-acceleration-equations', 'Uniform Acceleration Equations',
     'Using the kinematics equations to solve constant-acceleration problems.', 3),
    ('motion-graphs', 'Motion Graphs',
     'Interpreting and sketching position-time and velocity-time graphs.', 4),
    ('free-fall-and-gravity', 'Free Fall and Gravity',
     'Applying uniform acceleration to objects falling under gravity.', 5),
    ('projectile-motion', 'Projectile Motion',
     'Analyzing two-dimensional motion by treating horizontal and vertical components separately.', 6),
    ('relative-velocity', 'Relative Velocity',
     'Adding velocity vectors to find velocity relative to a moving observer.', 7)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Dynamics -------------------------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'SPH3U' and un.code = 'dynamics'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('newtons-first-law', 'Newton''s First Law',
     'Inertia and why objects resist changes to their motion.', 0),
    ('newtons-second-law', 'Newton''s Second Law',
     'Relating net force, mass, and acceleration with F = ma.', 1),
    ('newtons-third-law', 'Newton''s Third Law',
     'Action-reaction force pairs and how to identify them.', 2),
    ('free-body-diagrams', 'Free-Body Diagrams',
     'Drawing and using free-body diagrams to analyze the forces on an object.', 3),
    ('gravity-and-weight', 'Gravity and Weight',
     'Distinguishing mass from weight and calculating gravitational force.', 4),
    ('friction', 'Friction',
     'Static and kinetic friction, and calculating friction force with the coefficient of friction.', 5),
    ('applications-of-newtons-laws', 'Applications of Newton''s Laws',
     'Solving multi-force problems like inclines, elevators, and connected objects.', 6),
    ('uniform-circular-motion', 'Uniform Circular Motion',
     'Centripetal acceleration and force for objects moving in a circle.', 7)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Energy and Momentum ----------------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'SPH3U' and un.code = 'energy-and-momentum'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('work-and-energy', 'Work and the Work-Energy Theorem',
     'Defining work and relating it to a change in kinetic energy.', 0),
    ('kinetic-energy', 'Kinetic Energy',
     'Calculating the energy of a moving object.', 1),
    ('gravitational-potential-energy', 'Gravitational Potential Energy',
     'Calculating stored energy due to an object''s height.', 2),
    ('conservation-of-energy', 'Conservation of Mechanical Energy',
     'Using conservation of energy to solve problems without forces or time.', 3),
    ('power', 'Power',
     'Calculating the rate at which work is done or energy is transferred.', 4),
    ('momentum-and-impulse', 'Momentum and Impulse',
     'Defining momentum and relating impulse to a change in momentum.', 5),
    ('conservation-of-momentum', 'Conservation of Momentum',
     'Using conservation of momentum to analyze interactions between objects.', 6),
    ('elastic-and-inelastic-collisions', 'Elastic and Inelastic Collisions',
     'Distinguishing collision types and solving for velocities after a collision.', 7)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Waves and Sound ---------------------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'SPH3U' and un.code = 'waves-and-sound'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('properties-of-waves', 'Properties of Waves',
     'Wavelength, frequency, period, amplitude, and wave speed.', 0),
    ('wave-interference', 'Wave Interference and Superposition',
     'How overlapping waves combine constructively and destructively.', 1),
    ('standing-waves', 'Standing Waves',
     'How reflected waves combine to form standing waves with nodes and antinodes.', 2),
    ('nature-of-sound', 'The Nature of Sound',
     'Sound as a longitudinal mechanical wave and how it travels through matter.', 3),
    ('resonance-and-music', 'Resonance and Musical Instruments',
     'How resonance produces the sounds of strings and air columns.', 4),
    ('doppler-effect', 'The Doppler Effect',
     'Why a sound''s pitch changes when its source or the listener is moving.', 5),
    ('sound-intensity-decibels', 'Intensity and the Decibel Scale',
     'Measuring the loudness of sound on the logarithmic decibel scale.', 6)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Electricity and Magnetism -------------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'SPH3U' and un.code = 'electricity-and-magnetism'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('electric-charge-and-static', 'Electric Charge and Static Electricity',
     'Electric charge, charging methods, and Coulomb''s law.', 0),
    ('electric-current-and-circuits', 'Electric Current and Circuits',
     'Current, voltage, and the basic components of an electric circuit.', 1),
    ('ohms-law', 'Ohm''s Law',
     'Relating voltage, current, and resistance in a circuit.', 2),
    ('series-and-parallel-circuits', 'Series and Parallel Circuits',
     'Analyzing current, voltage, and resistance in series and parallel circuits.', 3),
    ('electrical-power-and-energy', 'Electrical Power and Energy',
     'Calculating electrical power and the cost of electrical energy.', 4),
    ('magnetism-and-magnetic-fields', 'Magnetism and Magnetic Fields',
     'Magnetic poles, fields, and how to sketch them.', 5),
    ('electromagnetism', 'Electromagnetism',
     'How electric current creates magnetism, and the basis of motors and generators.', 6)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- ---------------------------------------------------------------------------
-- Sample students & practice test results (local/dev demo data)
-- ---------------------------------------------------------------------------
-- Creates two demo student accounts so the mindmap's progress color-coding
-- (grey = not started, orange = struggling, yellow = progressing,
-- light green = nearing completion, green = completed) can be seen
-- end-to-end by actually signing in. Both accounts use the password
-- 'abc123'. Their sample results are all against Grade 10 (MPM2D) — switch
-- the grade dropdown to Grade 10 after signing in to see them.
--
--   a@gmail.com  password: abc123
--   b@gmail.com  password: abc123
--
-- WARNING: this uses the standard local-dev trick of inserting directly into
-- auth.users / auth.identities. Only run this against a project you're happy
-- to have these throwaway demo logins on (e.g. local/dev/staging) — don't
-- run it against a production project with real users.

-- Drop any older-named demo accounts from a previous version of this seed,
-- so re-running always leaves exactly the two accounts below.
delete from auth.users where email like '%.demo@example.com';

with demo_users (id, email, display_name) as (
  values
    ('11111111-1111-1111-1111-111111111111'::uuid, 'a@gmail.com', 'Student A'),
    ('22222222-2222-2222-2222-222222222222'::uuid, 'b@gmail.com', 'Student B')
)
insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password,
  email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
  created_at, updated_at, confirmation_token, recovery_token,
  email_change_token_new, email_change
)
select
  '00000000-0000-0000-0000-000000000000', d.id, 'authenticated', 'authenticated', d.email,
  crypt('abc123', gen_salt('bf')),
  now(), '{"provider":"email","providers":["email"]}'::jsonb,
  jsonb_build_object('display_name', d.display_name),
  now(), now(), '', '', '', ''
from demo_users d
on conflict (id) do update set encrypted_password = excluded.encrypted_password;

with demo_users (id, email) as (
  values
    ('11111111-1111-1111-1111-111111111111'::uuid, 'a@gmail.com'),
    ('22222222-2222-2222-2222-222222222222'::uuid, 'b@gmail.com')
)
insert into auth.identities (
  id, provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at
)
select
  gen_random_uuid(), d.id::text, d.id,
  jsonb_build_object('sub', d.id::text, 'email', d.email),
  'email', now(), now(), now()
from demo_users d
on conflict (provider, provider_id) do nothing;

-- Clear any previously-seeded demo results so this section is safe to re-run.
delete from public.subtopic_mastery
where student_id in (select id from auth.users where email in ('a@gmail.com', 'b@gmail.com'));

-- Progress colors are traffic-signal style, banded by best score per
-- subtopic: grey (not attempted) / orange <50% (struggling) / yellow
-- 50-69% (progressing) / light green 70-89% (nearing completion) / green
-- >=90% (completed). A unit's color is the least-complete band among its
-- attempted subtopics.
--
-- Student A (a@gmail.com): Linear Systems fully completed (every subtopic
-- >=90% — green branch). Analytic Geometry is close but not quite there
-- (light green) with a few subtopics still untouched (grey mixed in).
-- Quadratic Relations is progressing (yellow). Trigonometry hasn't been
-- touched yet (grey, no rows below).
with results (unit_code, subtopic_code, student_email, questions_total, questions_correct) as (
  values
    ('linear-systems', 'solving-by-graphing', 'a@gmail.com', 10, 9),
    ('linear-systems', 'solving-by-substitution', 'a@gmail.com', 10, 10),
    ('linear-systems', 'solving-by-elimination', 'a@gmail.com', 10, 9),
    ('linear-systems', 'linear-system-applications', 'a@gmail.com', 10, 9),
    ('analytic-geometry', 'midpoint-and-length-of-a-line-segment', 'a@gmail.com', 10, 8),
    ('analytic-geometry', 'geometric-properties-of-shapes', 'a@gmail.com', 10, 8),
    -- equation-of-a-circle, medians-right-bisectors-and-altitudes: not attempted yet.
    ('quadratics', 'properties-of-quadratics', 'a@gmail.com', 10, 6),
    ('quadratics', 'vertex-form', 'a@gmail.com', 10, 6),
    ('factoring', 'multiplying-binomials', 'a@gmail.com', 10, 5),
    ('factoring', 'factoring-x-bx-c', 'a@gmail.com', 10, 6),
    ('solving-quadratic-equations', 'solving-by-factoring', 'a@gmail.com', 10, 6),
    ('quadratics', 'completing-the-square', 'a@gmail.com', 10, 6),
    ('solving-quadratic-equations', 'the-quadratic-formula', 'a@gmail.com', 10, 5),
    ('quadratics', 'factored-form-and-zeros', 'a@gmail.com', 10, 6),
    ('solving-quadratic-equations', 'applications-of-quadratics', 'a@gmail.com', 10, 6),

    -- Student B (b@gmail.com): Trigonometry fully completed (green
    -- branch). Quadratic Relations is a mix of nearing-completion (light
    -- green) and struggling (orange) subtopics, so the whole branch reads
    -- as struggling — the most urgent subtopic wins. Analytic Geometry is
    -- struggling across the board (orange). Linear Systems hasn't been
    -- started (grey, no rows below).
    ('trigonometry', 'similar-triangles', 'b@gmail.com', 10, 9),
    ('trigonometry', 'the-primary-trig-ratios', 'b@gmail.com', 10, 10),
    ('trigonometry', 'trig-for-side-lengths', 'b@gmail.com', 10, 9),
    ('trigonometry', 'sine-law', 'b@gmail.com', 10, 10),
    ('trigonometry', 'cosine-law', 'b@gmail.com', 10, 9),
    ('quadratics', 'properties-of-quadratics', 'b@gmail.com', 10, 8),
    ('quadratics', 'vertex-form', 'b@gmail.com', 10, 7),
    ('factoring', 'multiplying-binomials', 'b@gmail.com', 10, 3),
    ('factoring', 'factoring-x-bx-c', 'b@gmail.com', 10, 2),
    ('analytic-geometry', 'midpoint-and-length-of-a-line-segment', 'b@gmail.com', 10, 3),
    ('analytic-geometry', 'geometric-properties-of-shapes', 'b@gmail.com', 10, 2)
    -- linear-systems: not attempted yet.
),
-- subtopic_mastery keys on (course_code, unit_code, subtopic_code) text —
-- not subtopic_id — so unlike the old practice_test_results insert, this
-- needs no join against courses/units/subtopics at all; see
-- supabase/schema_practice.sql for why. `ts` is computed once per row (in
-- this CTE) rather than inline in the insert, so first_earned_at and
-- updated_at get the same random demo timestamp instead of two different
-- ones. Chained onto `results` above with a comma rather than a second
-- `with` — CTEs only exist within the one statement they're attached to,
-- so a second `with` here couldn't see `results` at all.
results_ts as (
  select r.*, now() - (random() * interval '14 days') as ts
  from results r
)
insert into public.subtopic_mastery (
  student_id, course_code, unit_code, subtopic_code,
  best_first_try, total_questions, medal, times_completed,
  first_earned_at, updated_at
)
select
  au.id, 'MPM2D', r.unit_code, r.subtopic_code,
  r.questions_correct, r.questions_total,
  case
    when r.questions_correct::numeric / r.questions_total >= 0.9 then 'Gold'
    when r.questions_correct::numeric / r.questions_total >= 0.7 then 'Silver'
    else 'Bronze'
  end,
  1, r.ts, r.ts
from results_ts r
join auth.users au on au.email = r.student_email;
