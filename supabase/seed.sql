-- Seed data: Ontario Grade 10 Academic Math (MPM2D) curriculum units & subtopics.
-- Run after schema.sql. Safe to re-run (upserts on the unique `code` columns).
--
-- Content mirrors the common textbook breakdown of MPM2D (Nelson / McGraw-Hill):
-- Linear Systems, Analytic Geometry, Quadratic Relations, Trigonometry.
-- Adjust wording/order here to match your own board's course outline.

with unit_data (code, title, description, color, order_index) as (
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
insert into public.units (code, title, description, color, order_index)
select code, title, description, color, order_index from unit_data
on conflict (code) do update
  set title = excluded.title,
      description = excluded.description,
      color = excluded.color,
      order_index = excluded.order_index;

-- Linear Systems -------------------------------------------------------------
with u as (select id from public.units where code = 'linear-systems'),
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
with u as (select id from public.units where code = 'analytic-geometry'),
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
with u as (select id from public.units where code = 'quadratic-relations'),
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

-- Trigonometry (subtopics) -------------------------------------------------------
with u as (select id from public.units where code = 'trigonometry'),
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

-- ---------------------------------------------------------------------------
-- Sample students & practice test results (local/dev demo data)
-- ---------------------------------------------------------------------------
-- Creates two demo student accounts so the mindmap's progress color-coding
-- (green = completed/mastered, yellow = developing, red = needs practice,
-- grey = not started) can be seen end-to-end by actually signing in. Both
-- accounts use the password 'abc123'.
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

-- Student A (a@gmail.com): has fully completed Linear Systems (every
-- subtopic mastered, >=80% correct — the whole branch renders green) and
-- made a good start on Analytic Geometry (some subtopics completed green,
-- others not yet attempted, so that unit shows a mix of green and grey).
-- Quadratic Relations is still developing (yellow). Trigonometry hasn't
-- been touched yet (grey, no rows below).
with results (student_email, unit_code, subtopic_code, questions_total, questions_correct) as (
  values
    ('a@gmail.com', 'linear-systems', 'solving-by-graphing', 10, 9),
    ('a@gmail.com', 'linear-systems', 'solving-by-substitution', 10, 10),
    ('a@gmail.com', 'linear-systems', 'solving-by-elimination', 10, 8),
    ('a@gmail.com', 'linear-systems', 'number-of-solutions', 10, 9),
    ('a@gmail.com', 'linear-systems', 'linear-system-applications', 10, 10),
    ('a@gmail.com', 'analytic-geometry', 'length-of-a-line-segment', 10, 9),
    ('a@gmail.com', 'analytic-geometry', 'midpoint-of-a-line-segment', 10, 10),
    ('a@gmail.com', 'analytic-geometry', 'slope-and-equation-of-a-line', 10, 8),
    -- equation-of-a-circle, classifying-shapes, verifying-properties: not attempted yet.
    ('a@gmail.com', 'quadratic-relations', 'investigating-parabolas', 10, 6),
    ('a@gmail.com', 'quadratic-relations', 'transformations-vertex-form', 10, 7),
    ('a@gmail.com', 'quadratic-relations', 'expanding-and-simplifying', 10, 5),
    ('a@gmail.com', 'quadratic-relations', 'factoring-quadratics', 10, 6),
    ('a@gmail.com', 'quadratic-relations', 'solving-by-factoring', 10, 7),
    ('a@gmail.com', 'quadratic-relations', 'completing-the-square', 10, 6),
    ('a@gmail.com', 'quadratic-relations', 'quadratic-formula', 10, 5),
    ('a@gmail.com', 'quadratic-relations', 'graphing-quadratics', 10, 6),
    ('a@gmail.com', 'quadratic-relations', 'quadratic-applications', 10, 7),

    -- Student B (b@gmail.com): has fully completed Trigonometry (every
    -- subtopic mastered — green branch) and is halfway through Quadratic
    -- Relations, where the subtopics attempted so far split evenly between
    -- completed (green) and needs-practice (red). Analytic Geometry has
    -- been attempted but is still weak across the board (red). Linear
    -- Systems hasn't been started (grey, no rows below).
    ('b@gmail.com', 'trigonometry', 'similar-triangles', 10, 9),
    ('b@gmail.com', 'trigonometry', 'primary-trig-ratios', 10, 10),
    ('b@gmail.com', 'trigonometry', 'solving-right-triangles', 10, 8),
    ('b@gmail.com', 'trigonometry', 'elevation-and-depression', 10, 9),
    ('b@gmail.com', 'trigonometry', 'sine-law', 10, 10),
    ('b@gmail.com', 'trigonometry', 'cosine-law', 10, 8),
    ('b@gmail.com', 'trigonometry', 'acute-triangle-applications', 10, 9),
    ('b@gmail.com', 'quadratic-relations', 'investigating-parabolas', 10, 9),
    ('b@gmail.com', 'quadratic-relations', 'transformations-vertex-form', 10, 8),
    ('b@gmail.com', 'quadratic-relations', 'expanding-and-simplifying', 10, 3),
    ('b@gmail.com', 'quadratic-relations', 'factoring-quadratics', 10, 2),
    ('b@gmail.com', 'analytic-geometry', 'length-of-a-line-segment', 10, 3),
    ('b@gmail.com', 'analytic-geometry', 'midpoint-of-a-line-segment', 10, 4),
    ('b@gmail.com', 'analytic-geometry', 'slope-and-equation-of-a-line', 10, 2)
    -- linear-systems: not attempted yet.
)
insert into public.practice_test_results (
  student_id, subtopic_id, questions_total, questions_correct, attempted_at
)
select
  u.id, s.id, r.questions_total, r.questions_correct,
  now() - (random() * interval '14 days')
from results r
join auth.users u on u.email = r.student_email
join public.units un on un.code = r.unit_code
join public.subtopics s on s.code = r.subtopic_code and s.unit_id = un.id;
