-- Seed data: Ontario academic-stream math curriculum (grades 9-12) units &
-- subtopics, plus one Grade 10 science course, plus demo students.
-- Run after schema.sql. Safe to re-run (upserts on the unique `code` columns).
--
-- Content mirrors the common textbook breakdown of each course:
--   MPM1D  Grade 9  Academic Math
--   MPM2D  Grade 10 Academic Math
--   MCR3U  Grade 11 Functions (university prep)
--   MHF4U  Grade 12 Advanced Functions (university prep)
--   SNC2D  Grade 10 Academic Science
-- Adjust wording/order here to match your own board's course outline.

with course_data (grade, code, title, description, order_index) as (
  values
    (9, 'MPM1D', 'Grade 9 Academic Math',
     'Foundations of algebra, linear relations, and geometry.', 0),
    (10, 'MPM2D', 'Grade 10 Academic Math',
     'Linear systems, analytic geometry, quadratics, and trigonometry.', 1),
    (11, 'MCR3U', 'Grade 11 Functions',
     'Functions, exponential and trigonometric relationships, and sequences.', 2),
    (12, 'MHF4U', 'Grade 12 Advanced Functions',
     'Polynomial, rational, logarithmic, and trigonometric functions.', 3),
    (10, 'SNC2D', 'Grade 10 Academic Science',
     'Biology, chemistry, earth and space science, and physics.', 4)
)
insert into public.courses (grade, code, title, description, order_index)
select grade, code, title, description, order_index from course_data
on conflict (code) do update
  set grade = excluded.grade,
      title = excluded.title,
      description = excluded.description,
      order_index = excluded.order_index;

-- =============================================================================
-- Grade 9 — MPM1D
-- =============================================================================

with c as (select id from public.courses where code = 'MPM1D'),
unit_data (code, title, description, color, order_index) as (
  values
    ('number-sense-and-algebra', 'Number Sense and Algebra',
     'Exponent rules and operations with polynomial expressions.', '#5B8DEF', 0),
    ('linear-relations', 'Linear Relations',
     'Recognizing and representing relationships that change at a constant rate.', '#4CAF93', 1),
    ('equations-of-lines', 'Equations of Lines',
     'Determining and using the equation of a straight line.', '#E0834B', 2),
    ('measurement-and-geometry', 'Measurement and Geometry',
     'Surface area, volume, and geometric properties of shapes and solids.', '#B15BE0', 3)
)
insert into public.units (course_id, code, title, description, color, order_index)
select c.id, u.code, u.title, u.description, u.color, u.order_index from unit_data u, c
on conflict (course_id, code) do update
  set title = excluded.title,
      description = excluded.description,
      color = excluded.color,
      order_index = excluded.order_index;

-- Number Sense and Algebra ----------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MPM1D' and un.code = 'number-sense-and-algebra'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('exponent-laws', 'Exponent Laws',
     'Applying the laws of exponents to simplify numerical and algebraic expressions.', 0),
    ('adding-subtracting-polynomials', 'Adding and Subtracting Polynomials',
     'Collecting like terms to add and subtract polynomial expressions.', 1),
    ('multiplying-polynomials', 'Multiplying Polynomials',
     'Expanding products of monomials, binomials, and polynomials.', 2),
    ('simplifying-algebraic-expressions', 'Simplifying Algebraic Expressions',
     'Combining exponent rules and polynomial operations to simplify expressions.', 3),
    ('polynomial-applications', 'Applications of Polynomials',
     'Using polynomial expressions to model and solve real-world problems.', 4)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Linear Relations -------------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MPM1D' and un.code = 'linear-relations'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('first-differences', 'First Differences',
     'Using first differences in a table of values to identify a linear relation.', 0),
    ('rate-of-change', 'Rate of Change',
     'Calculating and interpreting the rate of change between two points.', 1),
    ('direct-variation', 'Direct Variation',
     'Relations of the form y = mx that pass through the origin.', 2),
    ('partial-variation', 'Partial Variation',
     'Relations of the form y = mx + b with a non-zero initial value.', 3),
    ('graphing-linear-relations', 'Graphing Linear Relations',
     'Creating tables of values and graphs to represent linear relations.', 4)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Equations of Lines -------------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MPM1D' and un.code = 'equations-of-lines'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('slope', 'Slope',
     'Calculating slope from a graph, table, or two points.', 0),
    ('slope-intercept-form', 'Slope-Intercept Form',
     'Writing and interpreting equations in the form y = mx + b.', 1),
    ('standard-form', 'Standard Form',
     'Converting linear equations between slope-intercept and standard form.', 2),
    ('graphing-from-equations', 'Graphing from Equations',
     'Sketching a line directly from its equation.', 3),
    ('solving-linear-equations', 'Solving Linear Equations',
     'Solving single-variable linear equations algebraically.', 4),
    ('linear-system-intro', 'Introduction to Linear Systems',
     'Finding the intersection of two lines by graphing.', 5)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Measurement and Geometry -------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MPM1D' and un.code = 'measurement-and-geometry'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('surface-area-of-solids', 'Surface Area of 3-D Solids',
     'Calculating the surface area of prisms, cylinders, and composite solids.', 0),
    ('volume-of-solids', 'Volume of 3-D Solids',
     'Calculating the volume of prisms, cylinders, and composite solids.', 1),
    ('optimization', 'Optimizing Measurements',
     'Finding dimensions that minimize surface area or maximize volume.', 2),
    ('similar-triangles-and-figures', 'Similar Triangles and Figures',
     'Using proportional reasoning to solve problems with similar shapes.', 3),
    ('angle-properties-of-polygons', 'Angle Properties of Polygons',
     'Interior and exterior angle relationships in triangles and polygons.', 4)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- =============================================================================
-- Grade 10 — MPM2D
-- =============================================================================

with c as (select id from public.courses where code = 'MPM2D'),
unit_data (code, title, description, color, order_index) as (
  values
    ('linear-systems', 'Linear Systems',
     'Solving and applying systems of two linear equations.', '#5B8DEF', 0),
    ('analytic-geometry', 'Analytic Geometry',
     'Using algebra to study lines, line segments, and shapes on the coordinate plane.', '#4CAF93', 1),
    ('quadratic-relations', 'Quadratic Relations',
     'Graphing, expanding, factoring, and solving quadratic equations.', '#E0834B', 2),
    ('trigonometry', 'Trigonometry',
     'Similar triangles and trigonometric ratios for right and acute triangles.', '#B15BE0', 3)
)
insert into public.units (course_id, code, title, description, color, order_index)
select c.id, u.code, u.title, u.description, u.color, u.order_index from unit_data u, c
on conflict (course_id, code) do update
  set title = excluded.title,
      description = excluded.description,
      color = excluded.color,
      order_index = excluded.order_index;

-- Linear Systems -------------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MPM2D' and un.code = 'linear-systems'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('solving-by-graphing', 'Solving by Graphing',
     'Finding the intersection point of two linear relations graphically.', 0),
    ('solving-by-substitution', 'Solving by Substitution',
     'Isolating a variable in one equation and substituting into the other.', 1),
    ('solving-by-elimination', 'Solving by Elimination',
     'Adding or subtracting equations to eliminate a variable.', 2),
    ('number-of-solutions', 'Number of Solutions',
     'Recognizing systems with one solution, no solution, or infinitely many.', 3),
    ('linear-system-applications', 'Applications of Linear Systems',
     'Modelling and solving real-world problems with two linear equations.', 4)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Analytic Geometry ------------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MPM2D' and un.code = 'analytic-geometry'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('length-of-a-line-segment', 'Length of a Line Segment',
     'Using the distance formula to find the length between two points.', 0),
    ('midpoint-of-a-line-segment', 'Midpoint of a Line Segment',
     'Finding the midpoint between two coordinates.', 1),
    ('slope-and-equation-of-a-line', 'Slope and Equation of a Line',
     'Determining slope and writing equations in slope-intercept and standard form.', 2),
    ('equation-of-a-circle', 'Equation of a Circle',
     'The equation x^2 + y^2 = r^2 for a circle centred at the origin.', 3),
    ('classifying-shapes', 'Classifying Shapes',
     'Using slope, length, and midpoint to classify triangles and quadrilaterals.', 4),
    ('verifying-properties', 'Verifying Geometric Properties',
     'Proving properties of shapes (e.g. medians, right angles) using coordinates.', 5)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Quadratic Relations ------------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MPM2D' and un.code = 'quadratic-relations'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('investigating-parabolas', 'Investigating y = ax^2',
     'Exploring how the parameter a affects the shape of a parabola.', 0),
    ('transformations-vertex-form', 'Transformations & Vertex Form',
     'Graphing y = a(x - h)^2 + k using transformations.', 1),
    ('expanding-and-simplifying', 'Expanding and Simplifying',
     'Converting quadratic expressions between factored and standard form.', 2),
    ('factoring-quadratics', 'Factoring Quadratic Expressions',
     'Common factoring, simple and complex trinomials, and special products.', 3),
    ('solving-by-factoring', 'Solving by Factoring',
     'Using the zero-product property to solve quadratic equations.', 4),
    ('completing-the-square', 'Completing the Square',
     'Rewriting standard form as vertex form to solve or graph.', 5),
    ('quadratic-formula', 'The Quadratic Formula',
     'Solving any quadratic equation using the quadratic formula and discriminant.', 6),
    ('graphing-quadratics', 'Graphing from Different Forms',
     'Sketching parabolas from standard, factored, or vertex form.', 7),
    ('quadratic-applications', 'Applications of Quadratic Relations',
     'Modelling projectile motion, area, and revenue problems.', 8)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Trigonometry -------------------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MPM2D' and un.code = 'trigonometry'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('similar-triangles', 'Similar Triangles',
     'Identifying and using similar triangles to find unknown side lengths.', 0),
    ('primary-trig-ratios', 'Primary Trigonometric Ratios',
     'Sine, cosine, and tangent ratios (SOH CAH TOA) in right triangles.', 1),
    ('solving-right-triangles', 'Solving Right Triangles',
     'Finding missing sides and angles using primary trig ratios.', 2),
    ('elevation-and-depression', 'Angle of Elevation & Depression',
     'Applying right-triangle trigonometry to real-world height/distance problems.', 3),
    ('sine-law', 'The Sine Law',
     'Solving acute triangles when a right angle is not present.', 4),
    ('cosine-law', 'The Cosine Law',
     'Solving triangles given SAS or SSS using the cosine law.', 5),
    ('acute-triangle-applications', 'Applications of Acute Triangle Trig',
     'Combining the sine law and cosine law to solve multi-step problems.', 6)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- =============================================================================
-- Grade 11 — MCR3U (Functions)
-- =============================================================================

with c as (select id from public.courses where code = 'MCR3U'),
unit_data (code, title, description, color, order_index) as (
  values
    ('functions-fundamentals', 'Functions Fundamentals',
     'Function notation, domain and range, and transformations.', '#5B8DEF', 0),
    ('quadratic-and-exponential-functions', 'Quadratic and Exponential Functions',
     'Extending quadratic functions and introducing exponential growth and decay.', '#4CAF93', 1),
    ('trigonometric-functions', 'Trigonometric Functions',
     'Radian measure, the unit circle, and graphing trigonometric functions.', '#E0834B', 2),
    ('sequences-and-series', 'Sequences and Series',
     'Arithmetic and geometric patterns and their sums.', '#B15BE0', 3)
)
insert into public.units (course_id, code, title, description, color, order_index)
select c.id, u.code, u.title, u.description, u.color, u.order_index from unit_data u, c
on conflict (course_id, code) do update
  set title = excluded.title,
      description = excluded.description,
      color = excluded.color,
      order_index = excluded.order_index;

-- Functions Fundamentals ----------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MCR3U' and un.code = 'functions-fundamentals'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('function-notation', 'Function Notation',
     'Using f(x) notation to evaluate and interpret functions.', 0),
    ('domain-and-range', 'Domain and Range',
     'Determining the domain and range of a function from its equation or graph.', 1),
    ('transformations-of-functions', 'Transformations of Functions',
     'Translating, reflecting, and stretching the graph of a function.', 2),
    ('inverse-functions', 'Inverse Functions',
     'Finding and graphing the inverse of a function.', 3),
    ('function-operations', 'Operations with Functions',
     'Adding, subtracting, multiplying, and composing functions.', 4)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Quadratic and Exponential Functions ----------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MCR3U' and un.code = 'quadratic-and-exponential-functions'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('review-of-quadratic-functions', 'Review of Quadratic Functions',
     'Revisiting factored, standard, and vertex forms of a quadratic.', 0),
    ('quadratic-linear-systems', 'Quadratic-Linear Systems',
     'Solving systems of a quadratic and a linear equation.', 1),
    ('laws-of-exponents-review', 'Laws of Exponents Review',
     'Extending exponent laws to rational exponents.', 2),
    ('exponential-growth-and-decay', 'Exponential Growth and Decay',
     'Modelling growth and decay with exponential functions.', 3),
    ('solving-exponential-equations', 'Solving Exponential Equations',
     'Solving equations by comparing bases or using logic.', 4),
    ('applications-of-exponential-functions', 'Applications of Exponential Functions',
     'Modelling population growth, compound interest, and decay.', 5)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Trigonometric Functions -----------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MCR3U' and un.code = 'trigonometric-functions'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('radian-measure', 'Radian Measure',
     'Converting between degrees and radians.', 0),
    ('the-unit-circle', 'The Unit Circle',
     'Using the unit circle to determine exact trigonometric values.', 1),
    ('graphing-sine-and-cosine', 'Graphing Sine and Cosine',
     'Sketching and transforming sine and cosine functions.', 2),
    ('trigonometric-identities', 'Trigonometric Identities',
     'Proving and applying the reciprocal and Pythagorean identities.', 3),
    ('solving-trigonometric-equations', 'Solving Trigonometric Equations',
     'Solving equations involving trigonometric functions over a given interval.', 4),
    ('trigonometric-applications', 'Applications of Trigonometric Functions',
     'Modelling periodic phenomena such as tides and Ferris wheels.', 5)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Sequences and Series ---------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MCR3U' and un.code = 'sequences-and-series'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('arithmetic-sequences', 'Arithmetic Sequences',
     'Identifying and generating terms of an arithmetic sequence.', 0),
    ('geometric-sequences', 'Geometric Sequences',
     'Identifying and generating terms of a geometric sequence.', 1),
    ('arithmetic-series', 'Arithmetic Series',
     'Finding the sum of an arithmetic series.', 2),
    ('geometric-series', 'Geometric Series',
     'Finding the sum of a finite or infinite geometric series.', 3),
    ('financial-applications', 'Financial Applications',
     'Applying sequences and series to loans, investments, and annuities.', 4)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- =============================================================================
-- Grade 12 — MHF4U (Advanced Functions)
-- =============================================================================

with c as (select id from public.courses where code = 'MHF4U'),
unit_data (code, title, description, color, order_index) as (
  values
    ('polynomial-and-rational-functions', 'Polynomial and Rational Functions',
     'Properties, factoring, and graphing of polynomial and rational functions.', '#5B8DEF', 0),
    ('exponential-and-logarithmic-functions', 'Exponential and Logarithmic Functions',
     'Logarithms as the inverse of exponential functions.', '#4CAF93', 1),
    ('trigonometric-functions', 'Trigonometric Functions',
     'Compound angle formulas and advanced trigonometric identities.', '#E0834B', 2),
    ('combining-functions', 'Combining Functions',
     'Building new functions from sums, products, and compositions.', '#B15BE0', 3)
)
insert into public.units (course_id, code, title, description, color, order_index)
select c.id, u.code, u.title, u.description, u.color, u.order_index from unit_data u, c
on conflict (course_id, code) do update
  set title = excluded.title,
      description = excluded.description,
      color = excluded.color,
      order_index = excluded.order_index;

-- Polynomial and Rational Functions --------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MHF4U' and un.code = 'polynomial-and-rational-functions'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('polynomial-function-properties', 'Polynomial Function Properties',
     'End behaviour, degree, and turning points of polynomial functions.', 0),
    ('factoring-and-remainder-theorem', 'Factoring and the Remainder Theorem',
     'Using the remainder and factor theorems to factor polynomials.', 1),
    ('graphing-polynomial-functions', 'Graphing Polynomial Functions',
     'Sketching polynomial functions from their factored form.', 2),
    ('rational-functions', 'Rational Functions',
     'Graphing rational functions, including asymptotes and holes.', 3),
    ('polynomial-and-rational-inequalities', 'Polynomial and Rational Inequalities',
     'Solving inequalities using sign analysis and graphs.', 4)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Exponential and Logarithmic Functions ------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MHF4U' and un.code = 'exponential-and-logarithmic-functions'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('exponential-functions-review', 'Exponential Functions Review',
     'Revisiting exponential growth, decay, and their graphs.', 0),
    ('introduction-to-logarithms', 'Introduction to Logarithms',
     'Defining logarithms as the inverse of exponential functions.', 1),
    ('laws-of-logarithms', 'Laws of Logarithms',
     'Applying the product, quotient, and power laws of logarithms.', 2),
    ('solving-exponential-and-log-equations', 'Solving Exponential and Logarithmic Equations',
     'Solving equations using logarithms and exponent rules.', 3),
    ('applications-of-logarithms', 'Applications of Logarithms',
     'Modelling pH, sound intensity, and earthquake magnitude.', 4)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Trigonometric Functions (advanced) ---------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MHF4U' and un.code = 'trigonometric-functions'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('trigonometric-identities-review', 'Trigonometric Identities Review',
     'Revisiting reciprocal, quotient, and Pythagorean identities.', 0),
    ('compound-angle-formulas', 'Compound Angle Formulas',
     'Deriving and applying sine and cosine sum and difference formulas.', 1),
    ('double-angle-formulas', 'Double Angle Formulas',
     'Deriving and applying double angle identities.', 2),
    ('graphing-trigonometric-functions', 'Graphing Trigonometric Functions',
     'Graphing transformed sine, cosine, and tangent functions.', 3),
    ('solving-advanced-trigonometric-equations', 'Solving Advanced Trigonometric Equations',
     'Solving trigonometric equations using identities.', 4)
)
insert into public.subtopics (unit_id, code, title, description, order_index)
select u.id, s.code, s.title, s.description, s.order_index from subtopic_data s, u
on conflict (unit_id, code) do update
  set title = excluded.title, description = excluded.description, order_index = excluded.order_index;

-- Combining Functions -------------------------------------------------------------
with u as (
  select un.id from public.units un
  join public.courses c on c.id = un.course_id
  where c.code = 'MHF4U' and un.code = 'combining-functions'
),
subtopic_data (code, title, description, order_index) as (
  values
    ('sums-and-differences-of-functions', 'Sums and Differences of Functions',
     'Graphing and analyzing the sum or difference of two functions.', 0),
    ('products-and-quotients-of-functions', 'Products and Quotients of Functions',
     'Graphing and analyzing the product or quotient of two functions.', 1),
    ('composite-functions', 'Composite Functions',
     'Forming and evaluating composite functions.', 2),
    ('rates-of-change-of-functions', 'Rates of Change',
     'Estimating average and instantaneous rates of change from a graph.', 3)
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
delete from public.practice_test_results
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
    ('linear-systems', 'number-of-solutions', 'a@gmail.com', 10, 10),
    ('linear-systems', 'linear-system-applications', 'a@gmail.com', 10, 9),
    ('analytic-geometry', 'length-of-a-line-segment', 'a@gmail.com', 10, 8),
    ('analytic-geometry', 'midpoint-of-a-line-segment', 'a@gmail.com', 10, 7),
    ('analytic-geometry', 'slope-and-equation-of-a-line', 'a@gmail.com', 10, 8),
    -- equation-of-a-circle, classifying-shapes, verifying-properties: not attempted yet.
    ('quadratic-relations', 'investigating-parabolas', 'a@gmail.com', 10, 6),
    ('quadratic-relations', 'transformations-vertex-form', 'a@gmail.com', 10, 6),
    ('quadratic-relations', 'expanding-and-simplifying', 'a@gmail.com', 10, 5),
    ('quadratic-relations', 'factoring-quadratics', 'a@gmail.com', 10, 6),
    ('quadratic-relations', 'solving-by-factoring', 'a@gmail.com', 10, 6),
    ('quadratic-relations', 'completing-the-square', 'a@gmail.com', 10, 6),
    ('quadratic-relations', 'quadratic-formula', 'a@gmail.com', 10, 5),
    ('quadratic-relations', 'graphing-quadratics', 'a@gmail.com', 10, 6),
    ('quadratic-relations', 'quadratic-applications', 'a@gmail.com', 10, 6),

    -- Student B (b@gmail.com): Trigonometry fully completed (green
    -- branch). Quadratic Relations is a mix of nearing-completion (light
    -- green) and struggling (orange) subtopics, so the whole branch reads
    -- as struggling — the most urgent subtopic wins. Analytic Geometry is
    -- struggling across the board (orange). Linear Systems hasn't been
    -- started (grey, no rows below).
    ('trigonometry', 'similar-triangles', 'b@gmail.com', 10, 9),
    ('trigonometry', 'primary-trig-ratios', 'b@gmail.com', 10, 10),
    ('trigonometry', 'solving-right-triangles', 'b@gmail.com', 10, 9),
    ('trigonometry', 'elevation-and-depression', 'b@gmail.com', 10, 9),
    ('trigonometry', 'sine-law', 'b@gmail.com', 10, 10),
    ('trigonometry', 'cosine-law', 'b@gmail.com', 10, 9),
    ('trigonometry', 'acute-triangle-applications', 'b@gmail.com', 10, 9),
    ('quadratic-relations', 'investigating-parabolas', 'b@gmail.com', 10, 8),
    ('quadratic-relations', 'transformations-vertex-form', 'b@gmail.com', 10, 7),
    ('quadratic-relations', 'expanding-and-simplifying', 'b@gmail.com', 10, 3),
    ('quadratic-relations', 'factoring-quadratics', 'b@gmail.com', 10, 2),
    ('analytic-geometry', 'length-of-a-line-segment', 'b@gmail.com', 10, 3),
    ('analytic-geometry', 'midpoint-of-a-line-segment', 'b@gmail.com', 10, 4),
    ('analytic-geometry', 'slope-and-equation-of-a-line', 'b@gmail.com', 10, 2)
    -- linear-systems: not attempted yet.
)
insert into public.practice_test_results (
  student_id, subtopic_id, questions_total, questions_correct, attempted_at
)
select
  au.id, s.id, r.questions_total, r.questions_correct,
  now() - (random() * interval '14 days')
from results r
join auth.users au on au.email = r.student_email
join public.courses c on c.code = 'MPM2D'
join public.units un on un.code = r.unit_code and un.course_id = c.id
join public.subtopics s on s.code = r.subtopic_code and s.unit_id = un.id;
