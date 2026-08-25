-- Astro STEM Labs: full practice-test question bank.
--
-- Rebuilt on top of a codeveloper-authored 1,600-question bank covering all
-- six Ontario grades 9-12 math courses (MTH1W, MPM2D, MCR3U, MHF4U, plus two
-- new grade-12 courses, MCV4U and MDM4U). The codeveloper's unit/subtopic
-- taxonomy is finer-grained than this app's previous one, so every unit and
-- subtopic below was rebuilt to match it (see seed.sql) -- including for the
-- 4 courses that already had content, whose existing questions were remapped
-- onto the new subtopic codes rather than discarded.
--
-- Before import, every question in the codeveloper's bank was independently
-- re-verified (answers recomputed from scratch, distractors and feedback
-- checked) rather than trusted as-is -- the source spreadsheet's own review
-- columns were still all blank. 11 questions that turned out to be genuinely
-- unanswerable without a missing referenced image were dropped, along with 6
-- that duplicated an existing question once mapped into the same subtopic.
--
-- Run after schema.sql, schema_practice.sql, schema_difficulty_tiers.sql,
-- schema_subscriptions.sql and seed.sql. Safe to re-run: each course section
-- deletes its own rows first.


delete from public.questions where course_code = 'MCV4U';

insert into public.questions
  (course_code, unit_code, subtopic_code, sort_order, difficulty,
   prompt, correct_index, options, misconception_tag)
values
('MCV4U', 'derivative-rules', 'power-constant-and-sum-rules', 1, 'Easy',
 'What is the derivative of f(x) = 3x^5?', 2,
 '[
   {"text": "3x^4", "feedback": "The exponent was reduced but the old exponent was never brought down as a multiplier."},
   {"text": "15x^6", "feedback": "The exponent went up instead of down. Differentiating lowers a power; it is integrating that raises one."},
   {"text": "15x^4", "feedback": "Correct."},
   {"text": "15x^5", "feedback": "The coefficient was multiplied correctly but the exponent was never reduced. The power rule drops it by one."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'power-constant-and-sum-rules', 2, 'Easy',
 'What is the derivative of f(x) = 71?', 3,
 '[
   {"text": "71", "feedback": "The function was copied out again. A constant function has a flat graph, so its slope is the same everywhere."},
   {"text": "71x", "feedback": "That is what you get by integrating, not differentiating."},
   {"text": "1", "feedback": "The slope of y = x is 1. A horizontal line is not the same thing."},
   {"text": "0", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'power-constant-and-sum-rules', 3, 'Medium',
 'Differentiate y = 5x^6 - 4x^3 + 6.', 1,
 '[
   {"text": "5x^5 - 4x^2", "feedback": "The exponents were reduced but never brought down as multipliers."},
   {"text": "30x^5 - 12x^2", "feedback": "Correct."},
   {"text": "30x^5 - 12x^2 + 6", "feedback": "The constant was carried through untouched. A constant has zero slope, so it drops out."},
   {"text": "30x^5 - 12x^2 + 1", "feedback": "The constant was differentiated as if it were 6x. There is no x on it, so it goes to zero."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'power-constant-and-sum-rules', 4, 'Medium',
 'Differentiate f(x) = -3x^5 + 8sqrt(x) - 9.3.', 2,
 '[
   {"text": "-15x^4 + 4/sqrt(x) - 9.3", "feedback": "The constant was carried through untouched. A constant has zero slope, so it drops out."},
   {"text": "-15x^4 + 4sqrt(x)", "feedback": "The exponent one half was reduced to negative one half, but the result was written as if it were still positive."},
   {"text": "-15x^4 + 4/sqrt(x)", "feedback": "Correct."},
   {"text": "-15x^4 + 8/sqrt(x)", "feedback": "The root was rewritten as a power of one half, but that one half was never used as a multiplier."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'power-constant-and-sum-rules', 5, 'Challenge',
 'Differentiate h(x) = (-8x^6 + 8x^2)/(4x^5) by simplifying first.', 1,
 '[
   {"text": "-2 - 2/x^4", "feedback": "The exponent was reduced but the negative 3 was never brought down as a multiplier."},
   {"text": "-2 - 6/x^4", "feedback": "Correct."},
   {"text": "-2 + 6/x^4", "feedback": "The second term of the simplified function is 2 times x to the negative 3. Differentiating that brings down a negative 3, so the sign turns over."},
   {"text": "-2 - 6x^4", "feedback": "The negative exponent was moved to the top instead of the bottom. A negative power means a reciprocal."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'power-constant-and-sum-rules', 6, 'Advanced',
 'For f(x) = (1/3)x^3 - x^2 - 3x + 4, at which value of x is the second derivative equal to zero?', 2,
 '[
   {"text": "x = 0", "feedback": "Differentiating twice leaves 2x take away 2, and that is not zero at the origin."},
   {"text": "x = -1", "feedback": "A sign was flipped when the linear equation was solved. Setting 2x take away 2 to zero gives a positive value."},
   {"text": "x = 1", "feedback": "Correct."},
   {"text": "x = -1 and x = 3", "feedback": "Those are the values where the FIRST derivative is zero. The question asks about the second."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'the-product-rule', 1, 'Easy',
 'If h(x) = f(x)g(x), which expression gives h prime of x?', 3,
 '[
   {"text": "the derivative of f times the derivative of g", "feedback": "The derivative of a product is not the product of the derivatives. Test the idea on x times x: it would give 1, when differentiating x squared gives 2x."},
   {"text": "f prime g - f g prime", "feedback": "That is the top of the QUOTIENT rule. A product does not subtract."},
   {"text": "(f prime g - f g prime) divided by g squared", "feedback": "That is the whole quotient rule. It is being used on a product."},
   {"text": "f prime g + f g prime", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'the-product-rule', 2, 'Medium',
 'Use the product rule to differentiate g(x) = (2x - 3)(x + 1).', 3,
 '[
   {"text": "2", "feedback": "The two derivatives were multiplied. That is not the product rule, and you can see it fails by expanding first and differentiating."},
   {"text": "4x + 1", "feedback": "A sign was lost while collecting. The negative 3 multiplies the derivative of the second bracket."},
   {"text": "2x^2 - x - 3", "feedback": "That is the expanded ORIGINAL function. It still has to be differentiated."},
   {"text": "4x - 1", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'the-product-rule', 3, 'Medium',
 'Use the product rule to differentiate h(x) = x^2(3x + 5).', 1,
 '[
   {"text": "3x^2 + 10x", "feedback": "The second term is right but the first lost its coefficient when 2x met 3x."},
   {"text": "9x^2 + 10x", "feedback": "Correct."},
   {"text": "6x", "feedback": "The two derivatives were multiplied. The product rule needs two terms, each keeping one factor undifferentiated."},
   {"text": "6x^2 + 10x", "feedback": "Only the first term of the rule was written out. The x squared also has to multiply the derivative of the bracket."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'the-product-rule', 4, 'Challenge',
 'Differentiate y = (x^2 + 1)(x^3 - 2x) and simplify.', 0,
 '[
   {"text": "5x^4 - 3x^2 - 2", "feedback": "Correct."},
   {"text": "6x^3 - 4x", "feedback": "The two derivatives were multiplied. The product rule keeps one factor whole in each of its two terms."},
   {"text": "5x^4 - 3x^2 + 2", "feedback": "The constant term came out with the wrong sign. The 1 in the first bracket multiplies the negative 2 in the second derivative."},
   {"text": "2x^4 - 4x^2", "feedback": "Only the first term of the product rule was written out. The second term is missing entirely."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'the-product-rule', 5, 'Challenge',
 'Let y = (3x - 1)(2x + 5).
Evaluate the derivative at x = 2.', 0,
 '[
   {"text": "37", "feedback": "Correct."},
   {"text": "27", "feedback": "Only the first term of the product rule was evaluated. The second term contributes as well."},
   {"text": "10", "feedback": "Only the second term of the product rule was evaluated. The first term contributes as well."},
   {"text": "6", "feedback": "The two derivatives were multiplied. That gives a constant, which cannot be right for a quadratic."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'the-product-rule', 6, 'Advanced',
 'Differentiate y = (x + 1)^2(x - 3)^3 and write the result in factored form.', 2,
 '[
   {"text": "(x + 1)(x - 3)^2(5x + 3)", "feedback": "A sign slipped inside the last bracket. The constants coming out of the two product-rule terms were combined incorrectly."},
   {"text": "2(x + 1)(x - 3)^3", "feedback": "Only the first term of the product rule was written out. The second term contributes the rest."},
   {"text": "(x + 1)(x - 3)^2(5x - 3)", "feedback": "Correct."},
   {"text": "6(x + 1)(x - 3)^2", "feedback": "The two derivatives were multiplied. This is a product, so both terms of the product rule are needed."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'the-quotient-rule', 1, 'Easy',
 'If h(x) = f(x) divided by g(x), which expression gives h prime of x?', 0,
 '[
   {"text": "(f prime g - f g prime) divided by g squared", "feedback": "Correct."},
   {"text": "(f g prime - f prime g) divided by g squared", "feedback": "The two terms on top are the right way round in the wrong order, which flips the sign of every answer you get."},
   {"text": "the derivative of f divided by the derivative of g", "feedback": "The derivative of a quotient is not the quotient of the derivatives. Test it on x squared over x."},
   {"text": "(f prime g + f g prime) divided by g squared", "feedback": "The top of the PRODUCT rule was used over a squared denominator. A quotient subtracts."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'the-quotient-rule', 2, 'Medium',
 'Differentiate y = (x + 1)/(x - 1).', 0,
 '[
   {"text": "-2/(x - 1)^2", "feedback": "Correct."},
   {"text": "2/(x - 1)^2", "feedback": "The two terms on top of the quotient rule were subtracted in the wrong order, which flips the sign."},
   {"text": "1", "feedback": "The derivatives of top and bottom were divided. Test that idea on x squared over x and it falls apart."},
   {"text": "-2/(x - 1)", "feedback": "The denominator was never squared. The quotient rule puts g squared underneath."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'the-quotient-rule', 3, 'Medium',
 'Differentiate y = x^2/(x + 3).', 3,
 '[
   {"text": "(x^2 + 6x)/(x + 3)", "feedback": "The numerator is right but the denominator was never squared."},
   {"text": "(-x^2 - 6x)/(x + 3)^2", "feedback": "The two terms on top were subtracted in the wrong order, so both terms came out negative."},
   {"text": "2x", "feedback": "The derivatives of top and bottom were divided. The quotient rule has four pieces, not two."},
   {"text": "(x^2 + 6x)/(x + 3)^2", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'the-quotient-rule', 4, 'Challenge',
 'Differentiate y = (2x - 3)/(x^2 + 1).', 0,
 '[
   {"text": "(-2x^2 + 6x + 2)/(x^2 + 1)^2", "feedback": "Correct."},
   {"text": "(2x^2 - 6x - 2)/(x^2 + 1)^2", "feedback": "The two terms on top were subtracted in the wrong order, which flips every sign in the numerator."},
   {"text": "(-2x^2 + 6x + 2)/(x^2 + 1)", "feedback": "The numerator is right but the denominator was never squared."},
   {"text": "2/(2x)", "feedback": "The derivatives of top and bottom were divided. The quotient rule has four pieces, not two."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'the-quotient-rule', 5, 'Challenge',
 'The value of a car t years after purchase is V(t) = (50000 + 6t)/(1 + 0.4t) dollars.
What is the rate of change of its value at t = 2, to the nearest dollar per year?', 0,
 '[
   {"text": "-6171 dollars per year", "feedback": "Correct."},
   {"text": "-11108 dollars per year", "feedback": "The denominator was never squared. The quotient rule puts the whole bottom, squared, underneath."},
   {"text": "6171 dollars per year", "feedback": "The two terms on top were subtracted in the wrong order. A car losing value has a negative rate."},
   {"text": "15 dollars per year", "feedback": "The top and the bottom were differentiated separately and then divided. That is not the quotient rule."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'the-quotient-rule', 6, 'Advanced',
 'Differentiate y = x/sqrt(x^2 + 1).', 2,
 '[
   {"text": "-1/(x^2 + 1)^(3/2)", "feedback": "The two terms on top were subtracted in the wrong order, which flips the sign."},
   {"text": "1/(x^2 + 1)", "feedback": "The denominator was squared but the root inside it was dropped. Squaring the square root of a quantity leaves the quantity itself, not the quantity to the three halves."},
   {"text": "1/(x^2 + 1)^(3/2)", "feedback": "Correct."},
   {"text": "1/sqrt(x^2 + 1)", "feedback": "Only the first term of the quotient rule was kept. The second term is not zero, because the bottom depends on x."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'the-chain-rule', 1, 'Easy',
 'What is the derivative of y = (2x + 1)^4?', 0,
 '[
   {"text": "8(2x + 1)^3", "feedback": "Correct."},
   {"text": "4(2x + 1)^3", "feedback": "The inner derivative was forgotten. After the power rule, multiply by the derivative of what is inside the bracket."},
   {"text": "8(2x + 1)^4", "feedback": "The inner derivative was applied but the exponent was never reduced."},
   {"text": "4(2)^3", "feedback": "The bracket was replaced by its derivative instead of being kept. The bracket itself stays put."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'the-chain-rule', 2, 'Easy',
 'What is the derivative of y = (x^2 + 3)^5?', 0,
 '[
   {"text": "10x(x^2 + 3)^4", "feedback": "Correct."},
   {"text": "5(x^2 + 3)^4", "feedback": "The inner derivative was forgotten. The bracket contains an x squared, so differentiating it gives 2x, not 1."},
   {"text": "10x(x^2 + 3)^5", "feedback": "The inner derivative is there but the exponent was never reduced."},
   {"text": "5(2x)^4", "feedback": "The bracket was replaced by its derivative. The original bracket stays and the inner derivative multiplies on the outside."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'the-chain-rule', 3, 'Medium',
 'Differentiate y = sqrt(3x + 1).', 2,
 '[
   {"text": "3/sqrt(3x + 1)", "feedback": "The inner derivative is there but the one half from the power rule was dropped."},
   {"text": "3/(2sqrt(3x))", "feedback": "The plus 1 was dropped from inside the root. The bracket stays intact under the radical."},
   {"text": "3/(2sqrt(3x + 1))", "feedback": "Correct."},
   {"text": "1/(2sqrt(3x + 1))", "feedback": "The inner derivative was forgotten. Differentiating 3x plus 1 gives 3, not 1."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'the-chain-rule', 4, 'Medium',
 'Differentiate y = (x^3 - 2x)^6.', 1,
 '[
   {"text": "(3x^2 - 2)^6", "feedback": "Only the inside was differentiated. The outer power rule was never applied at all."},
   {"text": "6(x^3 - 2x)^5(3x^2 - 2)", "feedback": "Correct."},
   {"text": "6(x^3 - 2x)^5", "feedback": "The inner derivative was forgotten. The chain rule multiplies by the derivative of what is inside."},
   {"text": "6(3x^2 - 2)^5", "feedback": "The bracket was replaced by its derivative. The original bracket stays and the inner derivative multiplies on the outside."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'the-chain-rule', 5, 'Challenge',
 'Let y = (x^2 + 3x)^3.
Evaluate the derivative at x = 1.', 3,
 '[
   {"text": "48", "feedback": "The inner derivative was forgotten. After the outer power rule, multiply by the derivative of what is inside."},
   {"text": "64", "feedback": "That is the value of the FUNCTION at x equals 1, not of its derivative."},
   {"text": "5", "feedback": "Only the inner derivative was evaluated. The outer power rule contributes the rest."},
   {"text": "240", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'the-chain-rule', 6, 'Challenge',
 'Differentiate y = 1/(2x - 5)^3.', 1,
 '[
   {"text": "6/(2x - 5)^4", "feedback": "The sign was lost. The negative 3 comes down as a multiplier and stays negative."},
   {"text": "-6/(2x - 5)^4", "feedback": "Correct."},
   {"text": "-3/(2x - 5)^4", "feedback": "The inner derivative was forgotten. Differentiating 2x take away 5 gives 2."},
   {"text": "-6/(2x - 5)^2", "feedback": "Rewriting as a power of negative 3 and reducing gives negative 4, so the bracket on the bottom ends up to the fourth."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'the-chain-rule', 7, 'Advanced',
 'Differentiate y = ((2x + 1)/(x - 1))^3.', 1,
 '[
   {"text": "-9(2x + 1)^2/(x - 1)^2", "feedback": "The two denominators were not combined. The outer power leaves one squared bracket and the inner quotient rule leaves another."},
   {"text": "-9(2x + 1)^2/(x - 1)^4", "feedback": "Correct."},
   {"text": "3(2x + 1)^2/(x - 1)^2", "feedback": "The chain rule stopped at the outer power. The inside is a quotient, so its derivative has to be found and multiplied in."},
   {"text": "9(2x + 1)^2/(x - 1)^4", "feedback": "The inner quotient derivative came out positive. Its numerator is 2(x take away 1) take away (2x plus 1), which is negative."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'displacement-velocity-and-acceleration', 1, 'Easy',
 'If s(t) gives the displacement of an object, which expression gives its acceleration?', 0,
 '[
   {"text": "s double prime of t", "feedback": "Correct."},
   {"text": "the derivative s prime of t", "feedback": "That is the velocity. Acceleration is the rate of change OF the velocity, so it is one derivative further along."},
   {"text": "s of t divided by t squared", "feedback": "The units happen to work out but the mathematics does not. Acceleration is a derivative, not a division."},
   {"text": "the function s of t itself", "feedback": "That is the displacement itself. Two derivatives separate it from acceleration."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'displacement-velocity-and-acceleration', 2, 'Easy',
 'A hammer falls from a height of 90 m, with s(t) = 90 - 4.9t^2 metres.
What is its velocity function?', 3,
 '[
   {"text": "v(t) = 9.8t", "feedback": "The negative sign was lost. The hammer is falling towards the ground, so its displacement is decreasing."},
   {"text": "v(t) = -4.9t", "feedback": "The exponent was reduced but the old exponent was never brought down as a multiplier."},
   {"text": "v(t) = 90 - 9.8t", "feedback": "The constant was carried through. The derivative of a constant is zero, so the 90 disappears."},
   {"text": "v(t) = -9.8t", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'displacement-velocity-and-acceleration', 3, 'Medium',
 'A particle moves with s(t) = t^3 - 6t^2 + 9t.
At which times is the particle at rest?', 1,
 '[
   {"text": "t = 2", "feedback": "That is where the ACCELERATION is zero. At rest means the velocity is zero."},
   {"text": "t = 1 and t = 3", "feedback": "Correct."},
   {"text": "t = 0 and t = 3", "feedback": "The POSITION was set to zero instead of the velocity. Those are the times the particle is back at the origin, not the times it stops."},
   {"text": "t = 1 only", "feedback": "The quadratic was only half solved. It factors into two brackets and both give a time."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'displacement-velocity-and-acceleration', 4, 'Advanced',
 'A hammer falls from 90 m with s(t) = 90 - 4.9t^2 metres.
What is its velocity when it hits the ground, to one decimal place?', 2,
 '[
   {"text": "-4.3 m/s", "feedback": "That is the TIME the hammer takes to land, in seconds. It still has to be substituted into the velocity function."},
   {"text": "-21.0 m/s", "feedback": "The 4.9 was used where the 9.8 belongs. Differentiating doubles that coefficient before the time is substituted."},
   {"text": "-42.0 m/s", "feedback": "Correct."},
   {"text": "42.0 m/s", "feedback": "The magnitude is right but the sign is not. The hammer is moving downwards, towards the origin at ground level."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'displacement-velocity-and-acceleration', 5, 'Advanced',
 'A particle moves with s(t) = t^3 - 12t^2 + 36t for t >= 0.
What is its acceleration the SECOND time it comes to rest?', 1,
 '[
   {"text": "36", "feedback": "That is a coefficient from the position function. The acceleration has to be evaluated at the time in question."},
   {"text": "12", "feedback": "Correct."},
   {"text": "-12", "feedback": "The first time it comes to rest was used. The velocity has two zeros, and the question asks about the later one."},
   {"text": "0", "feedback": "At rest means the VELOCITY is zero. The acceleration has no reason to vanish at the same instant."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'displacement-velocity-and-acceleration', 6, 'Advanced',
 'At a certain instant a particle has negative velocity and negative acceleration. What is it doing?', 2,
 '[
   {"text": "Momentarily at rest", "feedback": "At rest means the velocity is zero. Here it is negative, so the particle is definitely moving."},
   {"text": "Moving in the positive direction", "feedback": "A negative velocity means the particle is moving back towards the origin, not away from it."},
   {"text": "Speeding up", "feedback": "Correct."},
   {"text": "Slowing down", "feedback": "That happens when velocity and acceleration have OPPOSITE signs. Here they agree, so the acceleration is pushing the particle further in the direction it is already going."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'applications-of-rates-of-change', 1, 'Easy',
 'Economists give a special name to the derivative of the cost function C(x). What is it?', 1,
 '[
   {"text": "The fixed cost", "feedback": "That is the constant term in C of x, the part that does not change with the number of units."},
   {"text": "Marginal cost", "feedback": "Correct."},
   {"text": "The total cost", "feedback": "That is C of x itself, before any differentiating."},
   {"text": "The average cost", "feedback": "That is the total cost divided by the number of units, which is a ratio rather than a derivative."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'applications-of-rates-of-change', 2, 'Easy',
 'What is the slope of the tangent to f(x) = x^2 at x = 3?', 0,
 '[
   {"text": "6", "feedback": "Correct."},
   {"text": "9", "feedback": "That is f of 3, the height of the curve. The slope comes from the DERIVATIVE evaluated at 3."},
   {"text": "3", "feedback": "That is the x-value itself. It has to be substituted into the derivative first."},
   {"text": "2", "feedback": "That is the exponent brought down on its own. The x that comes with it still has to be evaluated."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'applications-of-rates-of-change', 3, 'Medium',
 'Find the equation of the tangent to f(x) = 4x^3 + 3x^2 - 5 at x = -1.', 1,
 '[
   {"text": "y = -6x", "feedback": "The slope came out with the wrong sign. The derivative at negative 1 is 12 take away 6."},
   {"text": "y = 6x", "feedback": "Correct."},
   {"text": "y = 6x - 6", "feedback": "The slope is right but the point was mishandled. Substitute the point into y equals mx plus b and solve for b rather than using the y-value as the intercept."},
   {"text": "y = 6x + 12", "feedback": "A sign slipped when the point was substituted. The y-value at x equals negative 1 is negative, not positive."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'applications-of-rates-of-change', 4, 'Challenge',
 'At which points on the graph of y = x^2(x + 3) is the slope of the tangent equal to 24?', 3,
 '[
   {"text": "(2, 20) only", "feedback": "The quadratic was only half solved. Setting the derivative equal to 24 gives two x-values, and both are on the curve."},
   {"text": "(4, 112) and (-2, 4)", "feedback": "Both x-values had their signs flipped when the factored quadratic was read out."},
   {"text": "(-4, 0) and (2, 0)", "feedback": "The x-values are right but the heights were never found. Substitute each one back into the ORIGINAL function."},
   {"text": "(-4, -16) and (2, 20)", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'applications-of-rates-of-change', 5, 'Challenge',
 'A shop sells 1500 DVDs a month at 10 dollars each. Sales fall by 125 a month for each 0.25 dollar rise in price, giving the demand function p(x) = 13 - 0.002x.
What is the marginal revenue when sales are 1000 DVDs a month?', 3,
 '[
   {"text": "11 dollars", "feedback": "That is the total revenue at 1000 divided by 1000, which is the average revenue per DVD, not the marginal one."},
   {"text": "13 dollars", "feedback": "Only the constant term of the demand function survived. Revenue is x times p of x, so differentiating leaves an x term behind."},
   {"text": "10 dollars", "feedback": "That is the current selling price. Marginal revenue is the derivative of the revenue function, not the price."},
   {"text": "9 dollars", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'applications-of-rates-of-change', 6, 'Advanced',
 'A 0.35 kg ball is thrown upward with v(t) = 40 - 9.8t m/s. Its kinetic energy is K = 0.5mv^2 joules.
What is the rate of change of its kinetic energy at t = 3 seconds, to one decimal place?', 2,
 '[
   {"text": "3.7 J/s", "feedback": "The chain rule was stopped after the outer square. The bracket contains a t, so its derivative has to multiply in."},
   {"text": "19.7 J/s", "feedback": "That is the kinetic energy itself at 3 seconds, not its rate of change."},
   {"text": "-36.4 J/s", "feedback": "Correct."},
   {"text": "36.4 J/s", "feedback": "The inner derivative was taken as positive 9.8. The velocity function is decreasing, so its derivative is negative."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'applications-of-rates-of-change', 7, 'Advanced',
 'The mass in kg of the first x metres of a wire is f(x) = sqrt(3x + 1).
What is the average linear density of the wire from x = 5 to x = 8, to three decimal places?', 3,
 '[
   {"text": "0.375 kg/m", "feedback": "That is the derivative at x equals 5, which is the linear density AT that point. An average needs the change in mass over the change in length."},
   {"text": "1.000 kg/m", "feedback": "That is the change in mass on its own. A density divides it by the length it was spread over."},
   {"text": "3.000 kg/m", "feedback": "The fraction is upside down. Mass goes on top and length underneath."},
   {"text": "0.333 kg/m", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'derivative-rules', 'applications-of-rates-of-change', 8, 'Advanced',
 'The cost of producing x DVDs is C(x) = -0.004x^2 + 9.2x + 5000 dollars.
What is the marginal cost at a production level of 1000 DVDs a month?', 3,
 '[
   {"text": "9.20 dollars", "feedback": "Only the linear term was differentiated. The squared term also contributes, and at 1000 units it contributes a lot."},
   {"text": "10.20 dollars", "feedback": "That is the total cost at 1000 divided by 1000, which is the average cost per DVD, not the marginal one."},
   {"text": "-8.00 dollars", "feedback": "Only the squared term was differentiated. The linear term contributes as well, and it is the larger of the two."},
   {"text": "1.20 dollars", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'increasing-and-decreasing-intervals', 1, 'Easy',
 'If f prime of x is positive throughout an interval, what is f doing on that interval?', 0,
 '[
   {"text": "Increasing", "feedback": "Correct."},
   {"text": "Decreasing", "feedback": "A positive slope tilts upward as you move to the right, so the values are going up rather than down."},
   {"text": "Concave up", "feedback": "Concavity is decided by the SECOND derivative. The first one only says which way the curve is heading."},
   {"text": "At a maximum", "feedback": "A maximum needs the derivative to be zero and to change sign. Here it is positive right across the interval."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'increasing-and-decreasing-intervals', 2, 'Easy',
 'On which interval is f(x) = x^2 - 6x + 8 decreasing?', 2,
 '[
   {"text": "x < 0", "feedback": "The vertex was placed at the origin. Setting 2x take away 6 to zero moves it."},
   {"text": "All real numbers", "feedback": "A parabola turns around. It cannot be decreasing on both sides of its vertex."},
   {"text": "x < 3", "feedback": "Correct."},
   {"text": "x > 3", "feedback": "The wrong side of the vertex was taken. To the right of the turning point of an upward parabola the values are climbing."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'increasing-and-decreasing-intervals', 3, 'Medium',
 'On which intervals is f(x) = 2x^3 + 3x^2 - 36x + 5 increasing?', 3,
 '[
   {"text": "-3 < x < 2", "feedback": "The wrong side of the sign chart was chosen. Between the two critical numbers the derivative is negative."},
   {"text": "x < -2 or x > 3", "feedback": "The two critical numbers had their signs swapped when the factored derivative was read out."},
   {"text": "x > 2 only", "feedback": "Only one of the two stretches was found. The derivative is also positive to the left of the smaller critical number."},
   {"text": "x < -3 or x > 2", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'increasing-and-decreasing-intervals', 4, 'Medium',
 'Is f(x) = x^3 + 2 ever decreasing?', 2,
 '[
   {"text": "Yes, for x > 0", "feedback": "The derivative 3x squared is positive there, so the function is climbing, not falling."},
   {"text": "Yes, at x = 0 only", "feedback": "The derivative is zero at that single point, which makes the tangent flat. A flat tangent at one point is not a decreasing interval."},
   {"text": "No, because its derivative is never negative", "feedback": "Correct."},
   {"text": "Yes, for x < 0", "feedback": "The cubic itself is negative there, but the DERIVATIVE is 3x squared, which cannot be negative for any real x."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'increasing-and-decreasing-intervals', 5, 'Challenge',
 'On which interval is f(x) = x/(x^2 + 1) increasing?', 3,
 '[
   {"text": "x < -1 or x > 1", "feedback": "The wrong side of the sign chart was chosen. The numerator of the derivative is 1 take away x squared, which is negative out there."},
   {"text": "x > 0", "feedback": "The function is odd, so it behaves the same way on both sides of the origin. The turning points are what bound the interval."},
   {"text": "Everywhere", "feedback": "The derivative does change sign. Its numerator is a difference of squares, which has two zeros."},
   {"text": "-1 < x < 1", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'increasing-and-decreasing-intervals', 6, 'Challenge',
 'Describe the intervals of increase and decrease for f(x) = x^(2/3).', 2,
 '[
   {"text": "Increasing everywhere", "feedback": "The graph has a sharp point at the origin with a valley either side. It cannot be climbing on both sides of that."},
   {"text": "Decreasing everywhere", "feedback": "Once past the origin the cube root is positive, so the derivative is positive and the curve climbs."},
   {"text": "Decreasing for x < 0 and increasing for x > 0", "feedback": "Correct."},
   {"text": "Increasing for x < 0 and decreasing for x > 0", "feedback": "The two sides were swapped. The derivative is 2 over 3 times the cube root of x, which is negative when x is negative."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'increasing-and-decreasing-intervals', 7, 'Advanced',
 'On which intervals is f(x) = x^4 - 8x^2 increasing?', 3,
 '[
   {"text": "x < -2 or 0 < x < 2", "feedback": "Every interval on the sign chart was taken the wrong way. The derivative factors into three brackets, so it alternates."},
   {"text": "x > 0", "feedback": "The critical numbers at plus and minus 2 were missed. The derivative is a cubic with three zeros, not one."},
   {"text": "-2 < x < 2", "feedback": "The whole strip between the outer critical numbers was taken. The derivative changes sign again at the origin, in the middle of it."},
   {"text": "-2 < x < 0 or x > 2", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'critical-numbers-and-extrema', 1, 'Easy',
 'What is a critical number of a function f?', 1,
 '[
   {"text": "Any value where f is undefined", "feedback": "A critical number has to be IN the domain. A vertical asymptote is outside it, so it does not count."},
   {"text": "A value in the domain of f where f prime is zero or does not exist", "feedback": "Correct."},
   {"text": "A value where f itself is zero", "feedback": "That is an x-intercept. It says where the curve crosses the axis, not where it turns."},
   {"text": "A value where the second derivative is zero", "feedback": "That is a candidate for a point of INFLECTION. A critical number comes from the first derivative."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'critical-numbers-and-extrema', 2, 'Easy',
 'What is the critical number of f(x) = x^2 - 6x + 8?', 2,
 '[
   {"text": "x = 8", "feedback": "That is the constant term. Differentiating removes it entirely."},
   {"text": "x = -3", "feedback": "A sign was flipped. Setting 2x take away 6 to zero gives a positive value."},
   {"text": "x = 3", "feedback": "Correct."},
   {"text": "x = 2 and x = 4", "feedback": "Those are the zeros of the FUNCTION. A critical number comes from setting the derivative to zero."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'critical-numbers-and-extrema', 3, 'Medium',
 'Find the local extrema of f(x) = 2x^3 + 3x^2 - 36x + 5.', 3,
 '[
   {"text": "Local min at (-3, 86) and local max at (2, -39)", "feedback": "The two classifications were swapped. Check the sign of the second derivative at each critical number, or the sign chart of the first."},
   {"text": "Local max at x = -3 and local min at x = 2, with no y-values", "feedback": "The critical x-values are right but a turning POINT needs both coordinates. Substitute each one back into the original function."},
   {"text": "Local max at (3, 86) and local min at (-2, -39)", "feedback": "Both critical numbers had their signs flipped when the factored derivative was read out."},
   {"text": "Local max at (-3, 86) and local min at (2, -39)", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'critical-numbers-and-extrema', 4, 'Medium',
 'What is the absolute MINIMUM value of f(x) = x^3 - 12x - 3 on the interval from -3 to 4?', 0,
 '[
   {"text": "-19", "feedback": "Correct."},
   {"text": "6", "feedback": "That is the value at the left endpoint. It is a candidate, but a critical number inside the interval goes lower."},
   {"text": "13", "feedback": "That is the largest value on the interval, so it is the absolute MAXIMUM rather than the minimum."},
   {"text": "-3", "feedback": "That is the constant term of the function, which happens to be its value at zero. Zero is not a critical number here."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'critical-numbers-and-extrema', 5, 'Challenge',
 'For f(x) = x^(2/3), the derivative does not exist at x = 0.
Is x = 0 a critical number?', 3,
 '[
   {"text": "No, because the derivative does not exist there", "feedback": "That is exactly the second way a critical number arises. A cusp is a critical point, and this function has one."},
   {"text": "No, because f of 0 is zero", "feedback": "The VALUE of the function has nothing to do with it. What matters is whether the value is in the domain and what the derivative does."},
   {"text": "Only if the second derivative exists there", "feedback": "Critical numbers are decided by the first derivative alone. The second is not consulted."},
   {"text": "Yes, because the derivative fails to exist there and f itself is defined there", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'critical-numbers-and-extrema', 6, 'Challenge',
 'A cylinder of surface area 100 cm^2 has volume V(r) = 50r - pi r^3, where the radius cannot exceed 3 cm.
What is the maximum volume, to one decimal place?', 2,
 '[
   {"text": "2.3 cm^3", "feedback": "That is the RADIUS that maximises the volume, not the volume itself. It still has to be substituted back."},
   {"text": "150.0 cm^3", "feedback": "Only the first term of the volume function was evaluated at r equals 3. The cubic term takes a large amount back off."},
   {"text": "76.8 cm^3", "feedback": "Correct."},
   {"text": "65.2 cm^3", "feedback": "That is the volume at the endpoint r equals 3. The endpoint has to be checked, but a critical number inside the interval beats it here."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'critical-numbers-and-extrema', 7, 'Advanced',
 'Classify the critical points of f(x) = 3x^5 - 5x^3.', 2,
 '[
   {"text": "Local min at x = -1, local max at x = 1, and neither at x = 0", "feedback": "The two outer classifications were swapped. Check the sign of the second derivative at each of them."},
   {"text": "Local max at x = -1 and local min at x = 1 only, because x = 0 is not a critical number", "feedback": "It is a critical number: the derivative factors into 15x squared times a bracket, so the origin does make it vanish. It simply is not a turning point."},
   {"text": "Local max at x = -1, local min at x = 1, and neither at x = 0", "feedback": "Correct."},
   {"text": "Local max at x = -1, local min at x = 1, and a local max at x = 0", "feedback": "The second derivative test returns zero at the origin, so it fails there and tells you nothing. The first derivative is negative on BOTH sides, so nothing turns around."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'concavity-and-the-second-derivative', 1, 'Easy',
 'If f double prime of x is negative throughout an interval, what is the shape of the graph there?', 0,
 '[
   {"text": "Concave down", "feedback": "Correct."},
   {"text": "Concave up", "feedback": "The sign was read backwards. A positive second derivative is the one that bends the curve upward."},
   {"text": "Decreasing", "feedback": "That is what a negative FIRST derivative gives. The second derivative describes bending, not direction."},
   {"text": "Increasing", "feedback": "Direction comes from the first derivative. A curve can be rising and still bending downward."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'concavity-and-the-second-derivative', 2, 'Easy',
 'In the second derivative test, if f prime of c is zero and f double prime of c is positive, what is at x = c?', 1,
 '[
   {"text": "An absolute maximum", "feedback": "The test is local; it only describes the immediate neighbourhood. It also gives the wrong kind of turning point here."},
   {"text": "A local minimum", "feedback": "Correct."},
   {"text": "A local maximum", "feedback": "The two cases were swapped. A curve bending upward at a flat point sits in a valley, not on a hill."},
   {"text": "A point of inflection", "feedback": "An inflection point needs the second derivative to be ZERO and to change sign. Here it is positive."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'concavity-and-the-second-derivative', 3, 'Medium',
 'For f(x) = x^4 - 2x^3 - 5, at which values of x is the second derivative equal to zero?', 3,
 '[
   {"text": "x = 0 and x = 3/2", "feedback": "Those are the values where the FIRST derivative is zero. The question asks about the second."},
   {"text": "x = 1 only", "feedback": "The second derivative factors into 12x times the bracket, and the bare 12x gives a value of its own."},
   {"text": "x = 3/2 only", "feedback": "That value comes from the first derivative, and it is only half of what that one gives anyway."},
   {"text": "x = 0 and x = 1", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'concavity-and-the-second-derivative', 4, 'Medium',
 'For f(x) = x^4 the second derivative is zero at x = 0.
Is x = 0 a point of inflection?', 1,
 '[
   {"text": "It is an inflection point from the left but not from the right", "feedback": "The second derivative is 12x squared, which is positive on both sides. The bending is the same either way."},
   {"text": "No, because the concavity does not change there", "feedback": "Correct."},
   {"text": "Yes, because the second derivative is zero there", "feedback": "A zero of the second derivative is only a CANDIDATE. It has to be checked for an actual change of concavity, and here there is none."},
   {"text": "Yes, because the first derivative is zero there too", "feedback": "Both derivatives do vanish there, but that makes it a flat point at the bottom of the curve rather than a change of bending."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'concavity-and-the-second-derivative', 5, 'Challenge',
 'On which interval is f(x) = x^3 - 3x^2 + 1 concave down?', 3,
 '[
   {"text": "x > 1", "feedback": "The inequality was read the wrong way. The second derivative is 6x take away 6, which is positive out there."},
   {"text": "-1 < x < 1", "feedback": "A cubic has one point of inflection, so its concavity changes exactly once. What you are looking for is a half line, not a strip between two values."},
   {"text": "x < 0", "feedback": "The inflection point was placed at the origin. Setting 6x take away 6 to zero moves it."},
   {"text": "x < 1", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'concavity-and-the-second-derivative', 6, 'Advanced',
 'On which intervals is f(x) = x^4 - 2x^3 - 5 concave up?', 3,
 '[
   {"text": "0 < x < 1", "feedback": "The wrong side of the sign chart was taken. Between the two zeros of the second derivative the product 12x times the bracket comes out negative."},
   {"text": "x > 1 only", "feedback": "Only one of the two stretches was found. To the left of the origin both factors are negative, so their product is positive."},
   {"text": "x < 0 or x > 3/2", "feedback": "The larger boundary came from the FIRST derivative. The second derivative has its own zeros."},
   {"text": "x < 0 or x > 1", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'concavity-and-the-second-derivative', 7, 'Advanced',
 'If f double prime of c equals zero, what can be concluded about the graph at x = c?', 1,
 '[
   {"text": "The graph is a straight line near x = c", "feedback": "That would need the second derivative to be zero on a whole interval, not at a single value."},
   {"text": "Nothing yet — the concavity has to be checked on both sides", "feedback": "Correct."},
   {"text": "There is a point of inflection at x = c", "feedback": "That is the assumption this question exists to break. The fourth power function has a zero second derivative at the origin and no change of bending at all."},
   {"text": "There is a local maximum or minimum at x = c", "feedback": "Turning points come from the FIRST derivative vanishing, not the second."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'sketching-rational-functions', 1, 'Easy',
 'The graph of y = 1/x is concave down to the left of x = 0 and concave up to the right of it.
Is x = 0 a point of inflection?', 2,
 '[
   {"text": "Yes, because the second derivative is zero there", "feedback": "The second derivative is not zero at that value; it is undefined, along with the function itself."},
   {"text": "Only if the graph is continuous everywhere else", "feedback": "What happens elsewhere is irrelevant. The test is whether this particular value is in the domain."},
   {"text": "No, because the function is not defined at x = 0", "feedback": "Correct."},
   {"text": "Yes, because the concavity changes there", "feedback": "The concavity does change, but a point of inflection has to BE a point on the curve. There is nothing there to be one."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'sketching-rational-functions', 2, 'Medium',
 'On which interval is f(x) = 1/(x - 2) concave up?', 0,
 '[
   {"text": "x > 2", "feedback": "Correct."},
   {"text": "x < 2", "feedback": "The wrong branch was chosen. Cubing a negative quantity keeps it negative, so the second derivative is negative on that side."},
   {"text": "Everywhere except x = 2", "feedback": "The two branches bend in opposite directions. Only one of them curves upward."},
   {"text": "Nowhere", "feedback": "The second derivative is 2 over the cube of the bracket, which is positive on one side of the asymptote."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'sketching-rational-functions', 3, 'Challenge',
 'What is the oblique asymptote of f(x) = (x^2 + 1)/x?', 3,
 '[
   {"text": "y = 0", "feedback": "That is the horizontal asymptote rule for when the bottom has the higher degree. Here the top is one degree higher, which produces a slanted line instead."},
   {"text": "x = 0", "feedback": "That is the VERTICAL asymptote. It is real, but it is not the oblique one."},
   {"text": "y = x + 1", "feedback": "Dividing out gives x plus 1 over x. The leftover term goes to zero, so the constant 1 does not belong to the line."},
   {"text": "y = x", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'sketching-rational-functions', 4, 'Challenge',
 'How many local extrema does f(x) = x/(x - 3) have?', 1,
 '[
   {"text": "One local minimum, at x = 0", "feedback": "That is the x-intercept, where the curve crosses the axis rather than turns."},
   {"text": "None", "feedback": "Correct."},
   {"text": "One local minimum, at x = 3", "feedback": "That value is the vertical asymptote, so it is not in the domain and cannot be a turning point."},
   {"text": "One local maximum, at x = 0", "feedback": "That is the x-intercept. The derivative there is negative three ninths, which is not zero."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'sketching-rational-functions', 5, 'Advanced',
 'For f(x) = (x^2 - 4)/(x^2 - 1), how many vertical asymptotes and how many x-intercepts does the graph have?', 2,
 '[
   {"text": "Only one vertical asymptote and two x-intercepts", "feedback": "The denominator factors into two brackets, so it vanishes at two separate values."},
   {"text": "Two vertical asymptotes and no x-intercepts", "feedback": "The numerator does reach zero. Setting x squared take away 4 to zero gives two real values."},
   {"text": "Two vertical asymptotes and two x-intercepts", "feedback": "Correct."},
   {"text": "Two vertical asymptotes and one x-intercept", "feedback": "The numerator is also a difference of squares, so it has two zeros rather than one."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'sketching-rational-functions', 6, 'Advanced',
 'What are the coordinates of the local minimum of f(x) = x + 3/x for x > 0, to two decimal places?', 1,
 '[
   {"text": "(1.73, 4.73)", "feedback": "The two terms were added as if the second were 3 rather than 3 divided by x. Substitute the critical number into the second term as it is written."},
   {"text": "(1.73, 3.46)", "feedback": "Correct."},
   {"text": "(1.73, 1.73)", "feedback": "The x-value is right but was reused as the height. Substitute it back into the whole function, which has two terms."},
   {"text": "(3.00, 4.00)", "feedback": "The 3 from the numerator was taken as the critical value. Setting 1 take away 3 over x squared to zero gives its square root instead."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'optimization', 1, 'Easy',
 'In an optimization problem, once the quantity has been written as a function of a single variable, what is the next step?', 2,
 '[
   {"text": "Set the second derivative equal to zero and solve", "feedback": "That finds points of inflection. The maximum or minimum is where the FIRST derivative vanishes."},
   {"text": "Substitute the endpoints of the given domain", "feedback": "The endpoints do have to be checked, but only alongside the critical numbers, which have to be found first."},
   {"text": "Set the derivative equal to zero and solve", "feedback": "Correct."},
   {"text": "Set the function itself equal to zero and solve", "feedback": "That finds where the quantity is ZERO, which is usually the worst possible answer rather than the best."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'optimization', 2, 'Easy',
 'A lifeguard has 200 m of rope to enclose a rectangular swimming area, with the beach forming the fourth side as shown.
If each of the two sides perpendicular to the beach is x metres, what is the length of the third roped side?', 0,
 '[
   {"text": "200 - 2x", "feedback": "Correct."},
   {"text": "200 - x", "feedback": "Only one of the perpendicular sides was subtracted. There are two of them, and both use rope."},
   {"text": "(200 - x)/2", "feedback": "x was taken as the side parallel to the beach, so the leftover rope was split between the other two sides. The prompt puts x on each of the sides perpendicular to the beach."},
   {"text": "100 - x", "feedback": "The full perimeter formula for a four-sided rectangle was used. Here only three sides are roped."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'optimization', 3, 'Medium',
 'A lifeguard uses 200 m of rope for three sides of a rectangle, the fourth side being the beach.
Which dimensions give the maximum enclosed area?', 1,
 '[
   {"text": "66.7 m by 66.7 m", "feedback": "The rope was split equally between three sides. A square is optimal when all FOUR sides are fenced, which is not the case here."},
   {"text": "50 m by 100 m", "feedback": "Correct."},
   {"text": "50 m by 50 m", "feedback": "The area function was maximised for one variable and then the same value was used for the other. Substitute back into the expression for the third side."},
   {"text": "100 m by 100 m", "feedback": "That uses 300 m of rope on the three sides. Only 200 m is available."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'optimization', 4, 'Medium',
 'Why must the endpoints be tested in an optimization problem on a restricted domain?', 1,
 '[
   {"text": "The second derivative test always fails at an endpoint", "feedback": "The test is about classifying interior critical points. The reason endpoints matter is that they are candidates in their own right."},
   {"text": "The largest or smallest value can occur at an endpoint, where the derivative need not be zero", "feedback": "Correct."},
   {"text": "The derivative is always undefined at an endpoint", "feedback": "That is not generally true, and it would not matter if it were. The reason is that the extreme value can simply sit there."},
   {"text": "Critical numbers can never be maxima or minima", "feedback": "They very often are. Endpoints are checked ALONGSIDE them, not instead of them."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'optimization', 5, 'Challenge',
 'A closed cardboard box with a square base is to hold 8000 cm^3.
What is the minimum surface area of cardboard needed?', 1,
 '[
   {"text": "20 cm^2", "feedback": "That is the side LENGTH that minimises the area, not the area itself. It still has to be substituted back."},
   {"text": "2400 cm^2", "feedback": "Correct."},
   {"text": "800 cm^2", "feedback": "Only the two square ends were counted. The four rectangular sides make up the larger part of the surface."},
   {"text": "1600 cm^2", "feedback": "Only the four sides were counted. The top and the bottom have to be included as well."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'optimization', 6, 'Advanced',
 'A can of volume 500 cm^3 has a top costing 0.4 cents per cm^2 and a bottom and sides costing 0.2 cents per cm^2.
What radius minimises the cost, to two decimal places?', 0,
 '[
   {"text": "3.76 cm", "feedback": "Correct."},
   {"text": "4.30 cm", "feedback": "The top and the bottom were priced the same. The dearer top pulls the best radius smaller, because it shrinks the two circular faces."},
   {"text": "5.42 cm", "feedback": "The 500 was used where the cost coefficients belong. Build the cost function first, then differentiate it."},
   {"text": "79.84 cm", "feedback": "That is the minimum COST in cents, not the radius. The radius still has to be read off the critical number."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'optimization', 7, 'Advanced',
 'A rectangular field of area 1200 m^2 is to be fenced, with one side running along a river and needing no fence.
What is the least length of fence needed, to one decimal place?', 0,
 '[
   {"text": "98.0 m", "feedback": "Correct."},
   {"text": "69.3 m", "feedback": "The two perpendicular sides were counted once instead of twice. Only the river side is saved; the opposite pair still needs fencing on both sides."},
   {"text": "138.6 m", "feedback": "All four sides were fenced. The side along the river is free, so it comes out of the total."},
   {"text": "49.0 m", "feedback": "That is the length of the side along the river, which is one of the DIMENSIONS. The question asks for the total fence."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'putting-a-full-sketch-together', 1, 'Challenge',
 'A function has f prime of x positive and f double prime of x negative throughout an interval. Which describes its graph there?', 1,
 '[
   {"text": "Falling, but bending upwards", "feedback": "Both signs were read backwards. Positive first means rising and negative second means bending down."},
   {"text": "Rising, but bending downwards", "feedback": "Correct."},
   {"text": "Rising, and bending upwards", "feedback": "The direction is right but the bending is not. A negative second derivative curves the graph downwards."},
   {"text": "Falling, and bending downwards", "feedback": "The bending is right but the direction is not. A positive first derivative makes the graph climb."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'putting-a-full-sketch-together', 2, 'Challenge',
 'A function satisfies f(2) = 0, f prime of 2 = 0, and f double prime of 2 > 0.
What feature does the graph have at x = 2?', 0,
 '[
   {"text": "A local minimum sitting on the x-axis", "feedback": "Correct."},
   {"text": "A local maximum sitting on the x-axis", "feedback": "The second derivative test was applied backwards. Bending upwards at a flat point puts the graph in a valley."},
   {"text": "A point of inflection on the x-axis", "feedback": "An inflection point needs the second derivative to be zero and to change sign. Here it is strictly positive."},
   {"text": "A vertical asymptote", "feedback": "The function has a value there, namely zero, so the graph passes through the point rather than running away from it."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'putting-a-full-sketch-together', 3, 'Advanced',
 'The graph of f prime is an upward parabola with x-intercepts at -1 and 3.
What does the graph of f have at those two values?', 2,
 '[
   {"text": "Points of inflection at both values", "feedback": "Inflection points come from the second derivative, which here is the SLOPE of the drawn parabola. That is zero only at its vertex."},
   {"text": "A local maximum at x = 1, the vertex of the parabola", "feedback": "The picture is the graph of f prime, so its vertex marks where f is steepest downhill, which is a point of inflection on f."},
   {"text": "A local maximum at x = -1 and a local minimum at x = 3", "feedback": "Correct."},
   {"text": "A local minimum at x = -1 and a local maximum at x = 3", "feedback": "The two were swapped. An upward parabola is positive to the left of its first root, so f is climbing before it reaches negative 1."}
 ]'::jsonb,
 null),
('MCV4U', 'curve-sketching', 'putting-a-full-sketch-together', 4, 'Advanced',
 'A function is decreasing and concave up throughout an interval. What is its derivative doing there?', 0,
 '[
   {"text": "Negative and increasing", "feedback": "Correct."},
   {"text": "Negative and decreasing", "feedback": "The sign is right but the trend is not. Concave up means the SLOPES are climbing, even while they stay below zero."},
   {"text": "Positive and increasing", "feedback": "The trend is right but the sign is not. A decreasing function has a negative derivative."},
   {"text": "Positive and decreasing", "feedback": "Both parts were read backwards. Decreasing gives a negative derivative and concave up makes it climb."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'derivatives-of-trig-functions', 1, 'Easy',
 'What is the derivative of sin x?', 3,
 '[
   {"text": "-cos x", "feedback": "The minus sign belongs to the other one. Differentiating COSINE is what introduces it."},
   {"text": "-sin x", "feedback": "That is the SECOND derivative of sine, after differentiating twice."},
   {"text": "sec^2 x", "feedback": "That is the derivative of tangent."},
   {"text": "cos x", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'derivatives-of-trig-functions', 2, 'Easy',
 'What is the derivative of cos x?', 2,
 '[
   {"text": "-cos x", "feedback": "That is the SECOND derivative of cosine, after differentiating twice."},
   {"text": "sec^2 x", "feedback": "That is the derivative of tangent."},
   {"text": "-sin x", "feedback": "Correct."},
   {"text": "sin x", "feedback": "The minus sign was dropped. Cosine is falling where sine is positive, so its derivative has to be the negative one."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'derivatives-of-trig-functions', 3, 'Medium',
 'Differentiate y = sin(3x).', 0,
 '[
   {"text": "3cos(3x)", "feedback": "Correct."},
   {"text": "cos(3x)", "feedback": "The inner derivative was forgotten. Differentiating 3x gives 3, which multiplies on the outside."},
   {"text": "3cos x", "feedback": "The 3 came out but the argument lost it. The 3x stays inside the cosine untouched."},
   {"text": "-3cos(3x)", "feedback": "A minus sign appeared from nowhere. It belongs to the derivative of cosine, not of sine."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'derivatives-of-trig-functions', 4, 'Medium',
 'Differentiate y = cos(x^2).', 3,
 '[
   {"text": "-sin(x^2)", "feedback": "The inner derivative was forgotten. Differentiating x squared gives 2x, which multiplies on the outside."},
   {"text": "2x sin(x^2)", "feedback": "The minus sign was dropped. Differentiating cosine always introduces one."},
   {"text": "-2x sin(2x)", "feedback": "The inner function was replaced by its derivative. The x squared stays inside the sine."},
   {"text": "-2x sin(x^2)", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'derivatives-of-trig-functions', 5, 'Challenge',
 'Differentiate y = (sin x)^2.', 3,
 '[
   {"text": "2 sin x", "feedback": "The inner derivative was forgotten. The outer power rule leaves a sine, and differentiating that sine supplies a cosine."},
   {"text": "2 cos^2 x", "feedback": "The sine was replaced by its derivative before the power rule was applied. The original function stays and the inner derivative multiplies on."},
   {"text": "-2 sin x cos x", "feedback": "A minus sign appeared from nowhere. It would belong if the outer function were built on cosine."},
   {"text": "2 sin x cos x", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'derivatives-of-trig-functions', 6, 'Challenge',
 'Differentiate y = tan(3x).', 2,
 '[
   {"text": "3 sec^2 x", "feedback": "The 3 came out but the argument lost it. The 3x stays inside the secant untouched."},
   {"text": "3 tan(3x) sec(3x)", "feedback": "That is built from the derivative of SECANT. The derivative of tangent is a secant squared."},
   {"text": "3 sec^2(3x)", "feedback": "Correct."},
   {"text": "sec^2(3x)", "feedback": "The inner derivative was forgotten. Differentiating 3x gives 3, which multiplies on the outside."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'derivatives-of-trig-functions', 7, 'Advanced',
 'Differentiate y = (cos(2x))^3.', 0,
 '[
   {"text": "-6 cos^2(2x) sin(2x)", "feedback": "Correct."},
   {"text": "3 cos^2(2x) sin(2x)", "feedback": "Two things went missing: the minus sign from the derivative of cosine, and the 2 from differentiating the argument."},
   {"text": "-3 cos^2(2x) sin(2x)", "feedback": "The innermost derivative was forgotten. There are two layers inside the cube, and differentiating 2x supplies a factor of 2."},
   {"text": "-6 cos^2(2x)", "feedback": "The middle layer was skipped. Differentiating the cosine itself supplies a sine as well."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'derivative-rules-with-trig-functions', 1, 'Easy',
 'What is the derivative of tan x?', 2,
 '[
   {"text": "cot x", "feedback": "That is the reciprocal of tangent, not its derivative."},
   {"text": "-csc^2 x", "feedback": "That is the derivative of COTANGENT. Note the minus sign, which tangent does not have."},
   {"text": "sec^2 x", "feedback": "Correct."},
   {"text": "sec x tan x", "feedback": "That is the derivative of SECANT, which is a different function."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'derivative-rules-with-trig-functions', 2, 'Medium',
 'Differentiate y = x sin x.', 1,
 '[
   {"text": "sin x + cos x", "feedback": "The x was dropped from the second term. Each term keeps one factor exactly as it was."},
   {"text": "sin x + x cos x", "feedback": "Correct."},
   {"text": "x cos x", "feedback": "Only the second term of the product rule was written. The derivative of x also multiplies the sine."},
   {"text": "cos x", "feedback": "The two derivatives were multiplied. The product rule needs two terms, each keeping one factor whole."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'derivative-rules-with-trig-functions', 3, 'Challenge',
 'Differentiate y = (sin x)/x.', 3,
 '[
   {"text": "(sin x - x cos x)/x^2", "feedback": "The two terms on top were subtracted in the wrong order, which flips the sign of the whole thing."},
   {"text": "(x cos x - sin x)/x", "feedback": "The numerator is right but the denominator was never squared."},
   {"text": "cos x", "feedback": "The top and the bottom were differentiated separately and then divided. That is not the quotient rule."},
   {"text": "(x cos x - sin x)/x^2", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'derivative-rules-with-trig-functions', 4, 'Challenge',
 'Differentiate y = x^2 cos x.', 0,
 '[
   {"text": "2x cos x - x^2 sin x", "feedback": "Correct."},
   {"text": "2x cos x + x^2 sin x", "feedback": "The minus sign from the derivative of cosine was lost."},
   {"text": "-2x sin x", "feedback": "The two derivatives were multiplied. The product rule adds two terms, each keeping one factor whole."},
   {"text": "-x^2 sin x", "feedback": "Only the second term of the product rule was written. The derivative of x squared also multiplies the cosine."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'derivative-rules-with-trig-functions', 5, 'Advanced',
 'Differentiate y = (sin x)/(1 + cos x) and simplify fully.', 3,
 '[
   {"text": "(2 cos x - 1)/(1 + cos x)", "feedback": "The minus sign from differentiating the cosine underneath was dropped, so the second term of the quotient rule came out with the wrong sign."},
   {"text": "cos x/(1 + cos x)", "feedback": "Only the first term of the quotient rule was kept. The second term is not zero, because the denominator depends on x."},
   {"text": "-1/(1 + cos x)^2", "feedback": "The two terms on top were subtracted in the wrong order, and the cancellation was then missed."},
   {"text": "1/(1 + cos x)", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'derivative-rules-with-trig-functions', 6, 'Advanced',
 'What is the slope of the tangent to y = x sin x at x = pi?', 1,
 '[
   {"text": "-1", "feedback": "Only the cosine was evaluated. The x that multiplies it in the product rule still has to be substituted."},
   {"text": "-pi", "feedback": "Correct."},
   {"text": "pi", "feedback": "The sign was lost. The cosine of pi is negative 1, not positive 1."},
   {"text": "0", "feedback": "That is the VALUE of the function at pi, since the sine vanishes there. The slope comes from the derivative."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'derivatives-of-exponential-functions', 1, 'Easy',
 'What is the derivative of e^x?', 1,
 '[
   {"text": "e", "feedback": "That is the base, a constant. The function itself is what comes back out."},
   {"text": "e^x", "feedback": "Correct."},
   {"text": "x e^(x - 1)", "feedback": "The power rule was applied. That rule is for a variable BASE with a constant exponent, which is the other way round here."},
   {"text": "1", "feedback": "The exponent was differentiated on its own. The whole expression is what has to be differentiated."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'derivatives-of-exponential-functions', 2, 'Easy',
 'What is the derivative of 2^x?', 1,
 '[
   {"text": "2^x / ln 2", "feedback": "The logarithm ended up underneath. It multiplies rather than divides."},
   {"text": "2^x ln 2", "feedback": "Correct."},
   {"text": "2^x", "feedback": "That is the rule for base e only. Any other base picks up the natural logarithm of that base as a factor."},
   {"text": "x 2^(x - 1)", "feedback": "The power rule was applied. That rule is for a variable base with a constant exponent, which is the other way round here."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'derivatives-of-exponential-functions', 3, 'Medium',
 'Differentiate y = e^(x^2).', 2,
 '[
   {"text": "2x e^(2x)", "feedback": "The exponent was replaced by its own derivative. The exponent stays exactly as it was."},
   {"text": "x^2 e^(x^2 - 1)", "feedback": "The power rule was applied to the exponent. That rule is for a variable base, not a variable exponent."},
   {"text": "2x e^(x^2)", "feedback": "Correct."},
   {"text": "e^(x^2)", "feedback": "The inner derivative was forgotten. Differentiating x squared gives 2x, which multiplies on the outside."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'derivatives-of-exponential-functions', 4, 'Medium',
 'Differentiate y = 3^(2x).', 3,
 '[
   {"text": "3^(2x) times ln 3", "feedback": "The inner derivative was forgotten. The exponent is 2x, and differentiating that gives 2."},
   {"text": "2 times 3^(2x)", "feedback": "The natural logarithm of the base was dropped. Only base e escapes it."},
   {"text": "2 times 3^(2x) times ln 2", "feedback": "The logarithm was taken of the wrong number. It is the BASE that goes inside it, not the coefficient in the exponent."},
   {"text": "2 times 3^(2x) times ln 3", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'derivatives-of-exponential-functions', 5, 'Challenge',
 'Differentiate y = e^(sin x).', 1,
 '[
   {"text": "sin x times e^(sin x - 1)", "feedback": "The power rule was applied to the exponent. That rule is for a variable base, not a variable exponent."},
   {"text": "cos x times e^(sin x)", "feedback": "Correct."},
   {"text": "e^(sin x)", "feedback": "The inner derivative was forgotten. The exponent is a sine, and differentiating it supplies a cosine."},
   {"text": "e^(cos x)", "feedback": "The exponent was replaced by its own derivative. The exponent stays exactly as it was and the derivative multiplies on the outside."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'derivatives-of-exponential-functions', 6, 'Challenge',
 'What is the equation of the tangent to y = e^x at x = 0?', 2,
 '[
   {"text": "y = ex", "feedback": "The base was used as the slope. The slope is the derivative evaluated at zero, and e to the power zero is 1."},
   {"text": "y = 1", "feedback": "That is the height of the curve there, drawn as a horizontal line. The tangent has the slope of the curve, which is not zero."},
   {"text": "y = x + 1", "feedback": "Correct."},
   {"text": "y = x", "feedback": "The slope is right but the point was forgotten. The curve passes through a height of 1 at the origin, not zero."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'derivatives-of-exponential-functions', 7, 'Advanced',
 'At which value of x does y = x e^x have a horizontal tangent?', 1,
 '[
   {"text": "Nowhere, because an exponential is never zero", "feedback": "The exponential factor indeed never vanishes, but the product rule leaves a bracket alongside it, and that bracket can."},
   {"text": "x = -1", "feedback": "Correct."},
   {"text": "x = 0", "feedback": "The derivative there is 1, not zero. The exponential never vanishes, so the bracket that comes with it is what has to."},
   {"text": "x = 1", "feedback": "A sign was flipped when the bracket was solved. Setting 1 plus x to zero gives a negative value."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'derivative-rules-with-exponential-functions', 1, 'Easy',
 'What is the derivative of e^(3x)?', 2,
 '[
   {"text": "3e^x", "feedback": "The 3 came down correctly but the exponent lost it. The exponent is untouched by differentiating."},
   {"text": "e^(3x)/3", "feedback": "The 3 ended up underneath. That is what integrating would do, not differentiating."},
   {"text": "3e^(3x)", "feedback": "Correct."},
   {"text": "e^(3x)", "feedback": "The inner derivative was forgotten. The exponent is 3x, and differentiating that gives 3."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'derivative-rules-with-exponential-functions', 2, 'Medium',
 'Differentiate y = x^2 e^x.', 0,
 '[
   {"text": "2x e^x + x^2 e^x", "feedback": "Correct."},
   {"text": "2x e^x", "feedback": "Only the first term of the product rule was written. The x squared also multiplies the derivative of the exponential."},
   {"text": "x^2 e^x", "feedback": "Only the second term of the product rule was written. The derivative of x squared also multiplies the exponential."},
   {"text": "2x e^x + x^3 e^(x - 1)", "feedback": "The power rule was applied to the exponential in the second term. That rule is for a variable base with a constant exponent, which is the other way round here."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'derivative-rules-with-exponential-functions', 3, 'Challenge',
 'Differentiate y = (e^x)/x.', 3,
 '[
   {"text": "e^x(1 - x)/x^2", "feedback": "The two terms on top were subtracted in the wrong order, which flips the sign."},
   {"text": "e^x(x - 1)/x", "feedback": "The numerator is right but the denominator was never squared."},
   {"text": "e^x", "feedback": "The top and the bottom were differentiated separately and then divided. That is not the quotient rule."},
   {"text": "e^x(x - 1)/x^2", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'derivative-rules-with-exponential-functions', 4, 'Challenge',
 'Differentiate y = 3^x e^(sin x) and factor the result.', 3,
 '[
   {"text": "3^x e^(sin x)(ln 3 times cos x)", "feedback": "The two derivatives were multiplied. The product rule adds its two terms, which is why they collect into a sum inside the bracket."},
   {"text": "3^x e^(sin x)(1 + cos x)", "feedback": "The natural logarithm of the base was dropped. Only base e escapes it."},
   {"text": "3^x e^(sin x)(ln 3 + 1)", "feedback": "The inner derivative was forgotten. The exponent of the second factor is a sine rather than x, so the chain rule still owes a factor there."},
   {"text": "3^x e^(sin x)(ln 3 + cos x)", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'derivative-rules-with-exponential-functions', 5, 'Advanced',
 'Differentiate y = e^(2x)/(x^2 + 1) and factor the numerator.', 1,
 '[
   {"text": "2e^(2x)(x^2 - x + 1)/(x^2 + 1)", "feedback": "The numerator is right but the denominator was never squared."},
   {"text": "2e^(2x)(x^2 - x + 1)/(x^2 + 1)^2", "feedback": "Correct."},
   {"text": "e^(2x)(x^2 - 2x + 1)/(x^2 + 1)^2", "feedback": "The inner derivative of the exponential was forgotten. Differentiating e to the 2x brings down a 2, which multiplies the first term of the quotient rule."},
   {"text": "2e^(2x)(x^2 + x + 1)/(x^2 + 1)^2", "feedback": "The subtraction in the quotient rule was carried out as an addition, so the middle term came out with the wrong sign."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'derivative-rules-with-exponential-functions', 6, 'Advanced',
 'A 6.0 mg sample of Au-198 decays as N(t) = 6e^(-0.2657t) mg.
How fast is it decaying after 3 days, to three decimal places?', 2,
 '[
   {"text": "2.704 mg per day", "feedback": "That is the MASS remaining after 3 days, not the rate at which it is falling."},
   {"text": "0.718 mg per day", "feedback": "The magnitude is right but the sign is not. The sample is losing mass, so the rate is negative."},
   {"text": "-0.718 mg per day", "feedback": "Correct."},
   {"text": "-1.594 mg per day", "feedback": "That is the rate at time ZERO. The exponential factor still has to be evaluated at 3 days, and it has shrunk by then."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'implicit-differentiation-and-logarithms', 1, 'Easy',
 'When differentiating with respect to x, what does y^2 become?', 1,
 '[
   {"text": "y^2 times dy/dx", "feedback": "The dy/dx is right but the power rule was never applied. The exponent has to come down and drop by one."},
   {"text": "2y times dy/dx", "feedback": "Correct."},
   {"text": "2y", "feedback": "The chain rule was stopped one step early. y is itself a function of x, so its derivative has to be attached."},
   {"text": "2 times dy/dx", "feedback": "The power rule was not applied to the y. It should leave a 2y, not a bare 2."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'implicit-differentiation-and-logarithms', 2, 'Easy',
 'What is the derivative of ln x?', 0,
 '[
   {"text": "1/x", "feedback": "Correct."},
   {"text": "1/(x ln 10)", "feedback": "That is the derivative of the base-10 logarithm. For a natural logarithm the base is e, and the natural logarithm of e is 1."},
   {"text": "ln x", "feedback": "The function was copied out again. That happens with the exponential, not the logarithm."},
   {"text": "x/1", "feedback": "The reciprocal was turned the wrong way up."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'implicit-differentiation-and-logarithms', 3, 'Medium',
 'For the circle x^2 + y^2 = 16, what is dy/dx?', 2,
 '[
   {"text": "-y/x", "feedback": "The fraction is upside down. Isolating dy/dx divides by the coefficient that came from the y term."},
   {"text": "-2x", "feedback": "Only the x side was differentiated. The y squared also produces a term, and it carries dy/dx."},
   {"text": "-x/y", "feedback": "Correct."},
   {"text": "x/y", "feedback": "The sign was lost while isolating. The 2x term has to cross to the other side, which flips it."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'implicit-differentiation-and-logarithms', 4, 'Medium',
 'Differentiate y = 2 ln(1 + x^2).', 2,
 '[
   {"text": "2/(1 + x^2)", "feedback": "The inner derivative was forgotten. Differentiating 1 plus x squared gives 2x, which goes on top."},
   {"text": "4x", "feedback": "The bracket was never put underneath. The derivative of a logarithm is a fraction with the inner function on the bottom."},
   {"text": "4x/(1 + x^2)", "feedback": "Correct."},
   {"text": "2x/(1 + x^2)", "feedback": "The coefficient 2 in front of the logarithm was dropped somewhere. It multiplies the whole derivative."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'implicit-differentiation-and-logarithms', 5, 'Challenge',
 'Find dy/dx for y^2 + x^3 - y^3 + 6 = 3y.', 3,
 '[
   {"text": "3x^2/(2y - 3y^2 - 3)", "feedback": "The sign is inverted throughout. Collecting the dy/dx terms on the other side flips every one of them."},
   {"text": "3x^2/(3y^2 - 2y)", "feedback": "The 3y on the right-hand side was left out of the collection. Both sides of the equation get differentiated, so the right-hand side contributes a term too."},
   {"text": "3x^2/(2y - 3y^2)", "feedback": "Two errors at once: the signs were not flipped and the term from the right-hand side was left out."},
   {"text": "3x^2/(3y^2 - 2y + 3)", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'implicit-differentiation-and-logarithms', 6, 'Advanced',
 'Differentiate f(x) = 1 - log base 4 of (2x - 1).', 2,
 '[
   {"text": "-1/((2x - 1) ln 4)", "feedback": "The inner derivative was forgotten. Differentiating 2x take away 1 gives 2, which goes on top."},
   {"text": "-2/(2x - 1)", "feedback": "The natural logarithm of the base was dropped from the denominator. Only a natural logarithm escapes it."},
   {"text": "-2/((2x - 1) ln 4)", "feedback": "Correct."},
   {"text": "2/((2x - 1) ln 4)", "feedback": "The minus sign in front of the logarithm was dropped. It carries through to the whole derivative."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'implicit-differentiation-and-logarithms', 7, 'Advanced',
 'What is the slope of the tangent to the circle x^2 + y^2 = 25 at the point (3, 4)?', 1,
 '[
   {"text": "4/3", "feedback": "The coordinates were swapped and the sign was lost as well."},
   {"text": "-3/4", "feedback": "Correct."},
   {"text": "3/4", "feedback": "The sign was lost while isolating dy/dx. At this point the circle is falling as you move right."},
   {"text": "-4/3", "feedback": "The two coordinates were substituted the wrong way round. The x-coordinate belongs on top."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'applications-of-trig-and-exponential-derivatives', 1, 'Easy',
 'A power supply delivers a voltage V(t) = 5sin(t) + 12 volts.
What is the maximum voltage?', 3,
 '[
   {"text": "12 volts", "feedback": "That is the DC part on its own, the level the signal oscillates about. The alternating part rides on top of it."},
   {"text": "5 volts", "feedback": "That is the amplitude, the size of the swing. It has to be added to the level the signal sits at."},
   {"text": "7 volts", "feedback": "That is the MINIMUM voltage. The amplitude was subtracted rather than added."},
   {"text": "17 volts", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'applications-of-trig-and-exponential-derivatives', 2, 'Easy',
 'A radioactive sample decays according to N(t) = N0 e^(-kt), where N is the mass remaining after t days.
What does N prime of t represent?', 0,
 '[
   {"text": "How fast the sample is decaying, in mass per day", "feedback": "Correct."},
   {"text": "The mass of the sample still remaining after t days", "feedback": "That is N of t itself, before any differentiating."},
   {"text": "The number of days it takes for half the sample to decay", "feedback": "That is a single number, not a function of time, and it comes from solving rather than differentiating."},
   {"text": "The value of the disintegration constant k for the sample", "feedback": "That is k, a fixed number in the exponent. The derivative is a function that changes with time."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'applications-of-trig-and-exponential-derivatives', 3, 'Medium',
 'A 6.0 mg sample of Au-198 decays to 4.6 mg after 1 day, following N(t) = N0 e^(-kt).
What is the disintegration constant k, to four decimal places?', 0,
 '[
   {"text": "0.2657", "feedback": "Correct."},
   {"text": "-0.2657", "feedback": "The minus sign is already in the exponent of the model, so k itself comes out positive. Taking logarithms of the ratio the other way round gives this."},
   {"text": "0.7667", "feedback": "That is the RATIO of the two masses. A logarithm still has to be taken, and the result divided by the time."},
   {"text": "1.3043", "feedback": "That is the ratio the other way up. It is what goes inside the logarithm, not the answer itself."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'applications-of-trig-and-exponential-derivatives', 4, 'Medium',
 'Au-198 has a disintegration constant of 0.2657 per day in the model N(t) = N0 e^(-kt).
What is its half-life, to two decimal places?', 1,
 '[
   {"text": "3.76 days", "feedback": "The logarithm was left out entirely and 1 was divided by the constant. The reciprocal of the disintegration constant is the mean lifetime, not the half-life."},
   {"text": "2.61 days", "feedback": "Correct."},
   {"text": "7.53 days", "feedback": "The 2 was divided by the constant instead of its natural logarithm. Setting the model equal to half is what brings the logarithm in."},
   {"text": "0.26 days", "feedback": "That is the disintegration constant itself, which is the rate rather than the time."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'applications-of-trig-and-exponential-derivatives', 5, 'Challenge',
 'A voltage signal is V(t) = 5sin(t) + 12 volts, with t in seconds.
What is its frequency, to three decimal places?', 0,
 '[
   {"text": "0.159 Hz", "feedback": "Correct."},
   {"text": "6.283 Hz", "feedback": "That is the PERIOD in seconds. Frequency is its reciprocal, the number of cycles per second."},
   {"text": "5.000 Hz", "feedback": "That is the amplitude in volts. It says how big the swing is, not how often it happens."},
   {"text": "0.500 Hz", "feedback": "The period was taken as 2 seconds. With a coefficient of 1 on t the period is a full 2 pi."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'applications-of-trig-and-exponential-derivatives', 6, 'Advanced',
 'A voltage signal is V(t) = 5sin(t) + 12 volts, with t in seconds.
At what time does it FIRST reach its maximum, to two decimal places?', 0,
 '[
   {"text": "1.57 s", "feedback": "Correct."},
   {"text": "4.71 s", "feedback": "That is the other value where the derivative vanishes, but the second derivative is positive there, so it is the minimum."},
   {"text": "3.14 s", "feedback": "The sine is zero there, so the voltage is back at its middle level rather than at a peak."},
   {"text": "6.28 s", "feedback": "That is the full period. The signal has returned to its starting level by then, not to a peak."}
 ]'::jsonb,
 null),
('MCV4U', 'derivatives-of-trig-and-exponential-functions', 'applications-of-trig-and-exponential-derivatives', 7, 'Advanced',
 'A population grows as P(t) = 500e^(0.04t).
How fast is it growing at the moment the population reaches 2000?', 0,
 '[
   {"text": "80 per unit time", "feedback": "Correct."},
   {"text": "20 per unit time", "feedback": "That is the growth rate at the START, when the population was 500. It grows as the population does."},
   {"text": "2000 per unit time", "feedback": "That is the population itself at that moment, not the rate at which it is changing."},
   {"text": "0.04 per unit time", "feedback": "That is the growth CONSTANT. It has to be multiplied by the population to give an actual rate."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'what-a-vector-is-and-how-direction-is-written', 1, 'Easy',
 'Which of these is a vector quantity?', 2,
 '[
   {"text": "10 kg", "feedback": "Mass has size but no direction, so it is a scalar."},
   {"text": "-5 degrees C", "feedback": "The minus sign is part of the temperature scale, not a direction in space. Temperature is a scalar."},
   {"text": "80 km/h west", "feedback": "Correct."},
   {"text": "100 km/h", "feedback": "That is a speed, which is magnitude only. Adding a direction to it would turn it into a velocity."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'what-a-vector-is-and-how-direction-is-written', 2, 'Easy',
 'A true bearing is measured from which line, and in which rotational direction?', 0,
 '[
   {"text": "From north, turning clockwise", "feedback": "Correct."},
   {"text": "From north, turning counter-clockwise", "feedback": "The reference line is right but the rotation is not. A compass runs the other way, so a bearing of 090 is east."},
   {"text": "From east, turning clockwise", "feedback": "The rotation is right but the reference line is not. A bearing of zero points north."},
   {"text": "From the horizontal, turning counter-clockwise", "feedback": "That is the OTHER convention, the one used for an angle to the horizontal. A bearing uses the compass."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'what-a-vector-is-and-how-direction-is-written', 3, 'Medium',
 'Write the true bearing 150 degrees as a quadrant bearing.', 0,
 '[
   {"text": "S30E", "feedback": "Correct."},
   {"text": "N30E", "feedback": "The wrong end of the north-south line was used. A bearing of 150 has already swung past east and into the southern half."},
   {"text": "S30W", "feedback": "The direction is on the wrong side. Turning clockwise from north by 150 degrees ends up east of south."},
   {"text": "N150E", "feedback": "A quadrant bearing has to be between 0 and 90 degrees. This one has to be measured back from the nearer axis."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'what-a-vector-is-and-how-direction-is-written', 4, 'Medium',
 'Write the quadrant bearing N50W as a true bearing.', 3,
 '[
   {"text": "050 degrees", "feedback": "The turn was made clockwise from north. The W says to turn the other way, which lands in the last quarter of the compass."},
   {"text": "230 degrees", "feedback": "The measurement was made from SOUTH rather than north. The letter in front tells you which axis to start at."},
   {"text": "130 degrees", "feedback": "The angle was subtracted from 180. A true bearing is measured clockwise from north all the way round."},
   {"text": "310 degrees", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'what-a-vector-is-and-how-direction-is-written', 5, 'Challenge',
 'Which statement about the vectors AB and BA is correct?', 0,
 '[
   {"text": "They have equal magnitude but opposite direction, so they are not equal vectors", "feedback": "Correct."},
   {"text": "They are equal vectors, because they join the same two points", "feedback": "Joining the same points is not enough. A vector carries a direction, and these two run opposite ways along the segment."},
   {"text": "They have equal magnitude and the same direction", "feedback": "Reversing the letters reverses the arrow. The lengths match but the directions do not."},
   {"text": "They have different magnitudes", "feedback": "The distance from A to B is the same as from B to A, so the magnitudes are identical. It is the direction that differs."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'what-a-vector-is-and-how-direction-is-written', 6, 'Challenge',
 'Two vectors are EQUIVALENT when which condition holds?', 1,
 '[
   {"text": "They have the same direction", "feedback": "Same direction with different lengths makes them PARALLEL, which is a weaker condition than equivalent."},
   {"text": "They have the same magnitude and the same direction, wherever they are drawn", "feedback": "Correct."},
   {"text": "They have the same magnitude", "feedback": "Two vectors of the same length can point anywhere. Direction has to match as well."},
   {"text": "They start at the same point", "feedback": "Where a vector is drawn does not matter at all. It can be slid anywhere without changing."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'what-a-vector-is-and-how-direction-is-written', 7, 'Advanced',
 'A vector is described as 14 cm at 110 degrees to the horizontal, measured counter-clockwise.
What is its true bearing?', 0,
 '[
   {"text": "340 degrees", "feedback": "Correct."},
   {"text": "020 degrees", "feedback": "The two angles were subtracted the wrong way round, 110 minus 090 rather than the other way about. Check the sign the subtraction gives before reading it as a bearing."},
   {"text": "110 degrees", "feedback": "The angle was copied straight across. The two conventions use different reference lines and opposite rotations, so they never agree by accident."},
   {"text": "200 degrees", "feedback": "The angle was added to 090 rather than subtracted from it. Counter-clockwise and clockwise pull in opposite directions."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'adding-and-subtracting-vectors', 1, 'Easy',
 'For any three points A, B and C, what does the vector AB plus the vector BC equal?', 3,
 '[
   {"text": "The vector CA", "feedback": "The direction is reversed. Head to tail addition starts where the first vector starts and finishes where the second one finishes."},
   {"text": "The vector AB", "feedback": "That is only the first of the two. The second one moves you further along."},
   {"text": "The vector BA", "feedback": "That is the first one reversed. Adding does not send you back where you came from."},
   {"text": "The vector AC", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'adding-and-subtracting-vectors', 2, 'Easy',
 'The vector AB with a minus sign in front of it can also be written how?', 3,
 '[
   {"text": "AB", "feedback": "The minus sign has to do something. Reversing a vector swaps its start and its finish."},
   {"text": "The magnitude of AB", "feedback": "A magnitude is a number with no direction at all, and it is never negative."},
   {"text": "A plus B", "feedback": "A and B are points, not vectors, so they cannot be added."},
   {"text": "BA", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'adding-and-subtracting-vectors', 3, 'Medium',
 'Two vectors have the same magnitude and point in opposite directions. What is their sum?', 3,
 '[
   {"text": "A vector of twice the magnitude", "feedback": "That is what happens when they point the SAME way. Opposite directions cancel instead."},
   {"text": "A vector with the same magnitude as either one", "feedback": "Nothing is left over. Placed head to tail they return you exactly to where you started."},
   {"text": "A vector at right angles to both", "feedback": "Adding two vectors keeps you on the line or in the plane they span; it does not create a new direction here."},
   {"text": "The zero vector", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'adding-and-subtracting-vectors', 4, 'Challenge',
 'Vectors u and v have magnitudes 5 and 8, with an angle of 60 degrees between them.
What is the magnitude of u + v, to two decimal places?', 1,
 '[
   {"text": "9.43", "feedback": "The Pythagorean theorem was used on its own. That only works at right angles; at any other angle the cosine law is needed."},
   {"text": "11.36", "feedback": "Correct."},
   {"text": "13.00", "feedback": "The magnitudes were added. That only works when the two point the same way, and there are 60 degrees between them."},
   {"text": "7.00", "feedback": "That is the magnitude of u take away v. The cosine term was subtracted where it should have been added."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'adding-and-subtracting-vectors', 5, 'Challenge',
 'Vectors u and v have magnitudes 5 and 8, with an angle of 60 degrees between them.
What is the magnitude of u - v, to two decimal places?', 2,
 '[
   {"text": "3.00", "feedback": "The magnitudes were subtracted. That only works when the two point the same way, and there are 60 degrees between them."},
   {"text": "9.43", "feedback": "The Pythagorean theorem was used on its own. That only works at right angles; at any other angle the cosine law is needed."},
   {"text": "7.00", "feedback": "Correct."},
   {"text": "11.36", "feedback": "That is the magnitude of the SUM. Subtracting flips the sign of the cosine term."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'adding-and-subtracting-vectors', 6, 'Advanced',
 'If u + v + w is the zero vector, which statement must be true?', 3,
 '[
   {"text": "w equals u + v", "feedback": "That would give twice the sum rather than zero. To cancel a vector you need its opposite."},
   {"text": "w equals u - v", "feedback": "Subtracting v does not undo adding it. Both u and v have to be cancelled together."},
   {"text": "The magnitude of w equals the magnitude of u plus the magnitude of v", "feedback": "That only holds when u and v happen to point the same way. In general the magnitude of their sum is smaller."},
   {"text": "w is the opposite of u + v", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'scalar-multiplication-of-vectors', 1, 'Easy',
 'A vector v has magnitude 6. What is the magnitude of 3v?', 2,
 '[
   {"text": "9", "feedback": "The 3 was added rather than multiplied."},
   {"text": "2", "feedback": "The magnitude was divided by the scalar. Multiplying by a number bigger than 1 lengthens a vector."},
   {"text": "18", "feedback": "Correct."},
   {"text": "6", "feedback": "The scalar was applied to the direction only. Multiplying by 3 makes the vector three times as long."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'scalar-multiplication-of-vectors', 2, 'Medium',
 'If u = 2v, what is the relationship between u and v?', 0,
 '[
   {"text": "They are parallel, and u is twice as long in the same direction", "feedback": "Correct."},
   {"text": "They are parallel, and u is twice as long in the opposite direction", "feedback": "The scalar is positive, so the direction is preserved. A negative scalar is what reverses it."},
   {"text": "They are perpendicular", "feedback": "A scalar multiple never changes the line a vector lies along, so the two cannot be at right angles."},
   {"text": "They have the same magnitude", "feedback": "The 2 does exactly what it looks like: it doubles the length."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'scalar-multiplication-of-vectors', 3, 'Challenge',
 'A vector v has magnitude 4. What is the magnitude of -2.5v?', 1,
 '[
   {"text": "6.5", "feedback": "The scalar was added to the magnitude rather than multiplied by it."},
   {"text": "10", "feedback": "Correct."},
   {"text": "-10", "feedback": "A magnitude is a length, so it can never be negative. The minus sign is carried by the DIRECTION instead."},
   {"text": "1.6", "feedback": "The magnitude was divided by the scalar rather than multiplied by it."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'scalar-multiplication-of-vectors', 4, 'Challenge',
 'A vector v has magnitude 5. Which expression gives a unit vector in the same direction as v?', 0,
 '[
   {"text": "One fifth of v", "feedback": "Correct."},
   {"text": "Five times v", "feedback": "That makes it five times longer still. A unit vector has a magnitude of exactly 1."},
   {"text": "v itself", "feedback": "Its magnitude is 5, not 1. It has to be scaled down before it counts as a unit vector."},
   {"text": "Negative one fifth of v", "feedback": "The magnitude would be right but the direction would be reversed. The question asks for the SAME direction."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'scalar-multiplication-of-vectors', 5, 'Advanced',
 'Vectors a and b satisfy a = -3b, and b has magnitude 4.
What can be said about a?', 0,
 '[
   {"text": "Its magnitude is 12 and it points the opposite way to b", "feedback": "Correct."},
   {"text": "Its magnitude is 12 and it points the same way as b", "feedback": "The length is right but the negative sign was ignored. A negative scalar reverses the direction."},
   {"text": "Its magnitude is -12 and it points the opposite way to b", "feedback": "The direction is right but a magnitude is a length, so it can never be negative."},
   {"text": "Its magnitude is 1.33 and it points the opposite way to b", "feedback": "The magnitude was divided by the scalar rather than multiplied by it."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'scalar-multiplication-of-vectors', 6, 'Advanced',
 'For which value of k does kv point in the opposite direction to v with half its magnitude?', 2,
 '[
   {"text": "k = -2", "feedback": "The direction is right but this makes the vector twice as long rather than half."},
   {"text": "k = 2", "feedback": "Both parts are wrong: this keeps the direction and doubles the length."},
   {"text": "k = -0.5", "feedback": "Correct."},
   {"text": "k = 0.5", "feedback": "The length is right but the direction is not. A positive scalar keeps a vector pointing the same way."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'resolving-a-vector-into-components', 1, 'Easy',
 'The diagram shows a force f resolved into its horizontal and vertical components, with the angle marked at the tail.
Which expression gives the magnitude of the HORIZONTAL component?', 3,
 '[
   {"text": "The magnitude of f times sin of the angle", "feedback": "That gives the VERTICAL component. Sine reaches the side across from the marked angle, not the one beside it."},
   {"text": "The magnitude of f times tan of the angle", "feedback": "Tangent compares the two components with each other. Neither of them is the hypotenuse, which is what f is here."},
   {"text": "The magnitude of f divided by cos of the angle", "feedback": "That would make the component LONGER than the force itself, which no component of a right triangle can be."},
   {"text": "The magnitude of f times cos of the angle", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'resolving-a-vector-into-components', 2, 'Easy',
 'Kayla pulls a sleigh with a force of 200 N along a rope at 20 degrees to the horizontal.
What is the forward component of that force, to one decimal place?', 1,
 '[
   {"text": "212.8 N", "feedback": "The cosine ended up underneath. A component can never be larger than the force it came from."},
   {"text": "187.9 N", "feedback": "Correct."},
   {"text": "68.4 N", "feedback": "That is the component that lifts the sleigh. Sine reaches the vertical side; the forward one sits beside the angle."},
   {"text": "200.0 N", "feedback": "That is the whole force along the rope. Only part of it acts in the forward direction."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'resolving-a-vector-into-components', 3, 'Medium',
 'A tow truck pulls a car with a cable tension of 15000 N at 40 degrees to the horizontal.
What is the vertical component, to the nearest newton?', 1,
 '[
   {"text": "12586 N", "feedback": "Tangent was used instead of sine. Tangent compares the two components with each other, not either one with the cable."},
   {"text": "9642 N", "feedback": "Correct."},
   {"text": "11491 N", "feedback": "That is the HORIZONTAL component. Cosine reaches the side beside the angle; the vertical one is across from it."},
   {"text": "15000 N", "feedback": "That is the whole tension along the cable. Only part of it acts vertically."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'resolving-a-vector-into-components', 4, 'Medium',
 'Kayla pulls a sleigh with 200 N along a rope at 20 degrees to the horizontal.
What is the component that tends to LIFT the sleigh, to one decimal place?', 0,
 '[
   {"text": "68.4 N", "feedback": "Correct."},
   {"text": "187.9 N", "feedback": "That is the forward component. Cosine reaches the side beside the angle; the lifting one is across from it."},
   {"text": "72.8 N", "feedback": "Tangent was used instead of sine. Tangent compares the two components with each other, not either one with the rope."},
   {"text": "200.0 N", "feedback": "That is the whole force along the rope. Only part of it acts upward."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'resolving-a-vector-into-components', 5, 'Challenge',
 'A box weighing 140 N rests on a ramp inclined at 20 degrees.
What is the component of its weight PERPENDICULAR to the ramp surface, to one decimal place?', 1,
 '[
   {"text": "51.0 N", "feedback": "Tangent was used instead of cosine. Tangent compares the two components with each other, not either one with the weight."},
   {"text": "131.6 N", "feedback": "Correct."},
   {"text": "47.9 N", "feedback": "That is the component along the SLOPE, the one that would slide the box. Sine and cosine have been swapped."},
   {"text": "140.0 N", "feedback": "That is the whole weight, straight down. Only part of it presses into the ramp surface."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'resolving-a-vector-into-components', 6, 'Advanced',
 'A force has a horizontal component of 120 N and a vertical component of 90 N.
What is its magnitude and its angle to the horizontal?', 2,
 '[
   {"text": "210 N at 36.9 degrees", "feedback": "The angle is right but the two components were added. They are at right angles, so the Pythagorean theorem applies."},
   {"text": "150 N at 0.8 degrees", "feedback": "The ratio of the components was reported instead of the angle. An inverse tangent still has to be taken."},
   {"text": "150 N at 36.9 degrees", "feedback": "Correct."},
   {"text": "150 N at 53.1 degrees", "feedback": "The magnitude is right but the two components were used the other way round in the tangent, giving the angle from the vertical."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'resultant-and-equilibrant-forces', 1, 'Easy',
 'What is the equilibrant of a system of forces?', 2,
 '[
   {"text": "The sum of all the forces acting", "feedback": "That is the RESULTANT. The equilibrant is what you would add to it to reach zero."},
   {"text": "The largest of the forces acting", "feedback": "The size of any one force is beside the point. The equilibrant balances the whole system at once."},
   {"text": "A force equal in magnitude to the resultant and opposite in direction", "feedback": "Correct."},
   {"text": "A force equal to the resultant, in the same direction", "feedback": "That would double the push rather than cancel it. The equilibrant has to oppose."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'resultant-and-equilibrant-forces', 2, 'Easy',
 'Two perpendicular forces of 3 N and 4 N act at the same point. What is the magnitude of the resultant?', 2,
 '[
   {"text": "1 N", "feedback": "The magnitudes were subtracted. That only works when the two forces point in opposite directions."},
   {"text": "12 N", "feedback": "The magnitudes were multiplied. Vector addition uses the Pythagorean theorem when the two are perpendicular."},
   {"text": "5 N", "feedback": "Correct."},
   {"text": "7 N", "feedback": "The magnitudes were added. That only works when the two forces point in the same direction, and these are at right angles."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'resultant-and-equilibrant-forces', 3, 'Medium',
 'A clown of mass 80 kg is fired horizontally with a force of 2000 N, while gravity pulls him down with a force of 784 N.
What is the magnitude of the resultant force, to one decimal place?', 3,
 '[
   {"text": "2784.0 N", "feedback": "The two magnitudes were added. That only works when the forces point the same way, and these are at right angles."},
   {"text": "1216.0 N", "feedback": "The two magnitudes were subtracted. That only works when the forces point in opposite directions."},
   {"text": "2000.0 N", "feedback": "Only the horizontal force was reported. Gravity pulls the resultant off the horizontal and makes it longer."},
   {"text": "2148.2 N", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'resultant-and-equilibrant-forces', 4, 'Medium',
 'The resultant force on the clown has magnitude 2148.2 N.
What is the equilibrant force?', 0,
 '[
   {"text": "2148.2 N, directed opposite to the resultant", "feedback": "Correct."},
   {"text": "2148.2 N, in the same direction as the resultant", "feedback": "The magnitude is right but that would push him harder rather than hold him still."},
   {"text": "784 N, directed upward", "feedback": "That balances gravity alone. The horizontal force still has to be opposed as well."},
   {"text": "0 N, because the forces already balance", "feedback": "They do not balance: the resultant is over 2000 N. The equilibrant is what would have to be added to make it zero."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'resultant-and-equilibrant-forces', 5, 'Challenge',
 'The diagram shows a 20 kg mass suspended from a ceiling by two ropes, at 60 degrees and 45 degrees to the ceiling. Take gravity as 9.8 m/s^2.
What is the tension in the rope at 60 degrees, to one decimal place?', 1,
 '[
   {"text": "196.0 N", "feedback": "That is the whole weight of the mass. It is shared between the two ropes, and neither one carries all of it."},
   {"text": "143.5 N", "feedback": "Correct."},
   {"text": "101.5 N", "feedback": "That is the tension in the OTHER rope. The steeper rope carries more of the load, so it is the larger of the two."},
   {"text": "98.0 N", "feedback": "The weight was simply halved. The ropes are at different angles, so they do not share the load equally."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'resultant-and-equilibrant-forces', 6, 'Advanced',
 'A clown is fired with a horizontal force of 2000 N while gravity pulls him down with 784 N.
At what angle below the horizontal does the resultant act, to one decimal place?', 3,
 '[
   {"text": "68.6 degrees", "feedback": "The two sides were used the other way round in the tangent, which gives the angle measured from the vertical instead."},
   {"text": "20.1 degrees", "feedback": "The RESULTANT was used in the tangent where the horizontal force belongs. Tangent needs the two perpendicular sides, not the hypotenuse."},
   {"text": "45.0 degrees", "feedback": "That would need the two forces to be equal. The horizontal one is well over twice the vertical one."},
   {"text": "21.4 degrees", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'resultant-and-equilibrant-forces', 7, 'Advanced',
 'A 20 kg mass hangs from two ropes making 60 degrees and 45 degrees with the ceiling. Take gravity as 9.8 m/s^2.
What is the tension in the rope at 45 degrees, to one decimal place?', 1,
 '[
   {"text": "138.6 N", "feedback": "The whole weight was divided by root 2, as though this rope alone held the mass at 45 degrees. The other rope carries part of it."},
   {"text": "101.5 N", "feedback": "Correct."},
   {"text": "143.5 N", "feedback": "That is the tension in the OTHER rope. The steeper rope carries more of the load, so this one is the smaller of the two."},
   {"text": "98.0 N", "feedback": "The weight was simply halved. The ropes are at different angles, so they do not share the load equally."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'resultant-velocity-problems', 1, 'Easy',
 'For an aircraft, the air velocity added to the wind velocity gives which quantity?', 2,
 '[
   {"text": "The wind speed", "feedback": "That is the magnitude of the second of the two, on its own."},
   {"text": "Zero", "feedback": "The two would have to be equal and opposite for that, which would leave the plane hovering."},
   {"text": "The ground velocity", "feedback": "Correct."},
   {"text": "The airspeed", "feedback": "That is the magnitude of the FIRST of the two, before the wind has been taken into account."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'resultant-velocity-problems', 2, 'Medium',
 'A sailboat travels 8 km east and 6 km north.
What is the magnitude and true bearing of the resultant displacement?', 2,
 '[
   {"text": "14 km at a bearing of 053 degrees", "feedback": "The bearing is right but the two distances were added. They are at right angles, so the Pythagorean theorem applies."},
   {"text": "10 km at a bearing of 143 degrees", "feedback": "The rotation went the wrong way past east. The boat ends up north AND east of where it started, so the bearing is less than 090."},
   {"text": "10 km at a bearing of 053 degrees", "feedback": "Correct."},
   {"text": "10 km at a bearing of 037 degrees", "feedback": "The magnitude is right but the angle was measured from EAST rather than from north. A bearing starts at north and turns clockwise."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'resultant-velocity-problems', 3, 'Challenge',
 'A plane flies N40E at an airspeed of 1000 km/h. The ground track is measured as N45E at 1050 km/h.
What is the speed of the wind, to one decimal place?', 3,
 '[
   {"text": "50.0 km/h", "feedback": "The two speeds were subtracted. That would only be right if the plane and the ground track pointed the same way, and they differ by 5 degrees."},
   {"text": "1050.0 km/h", "feedback": "That is the ground speed. The wind is the DIFFERENCE between the ground velocity and the air velocity, as vectors."},
   {"text": "2050.0 km/h", "feedback": "The two speeds were added. The wind is what you get by subtracting the air velocity from the ground velocity."},
   {"text": "102.4 km/h", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'resultant-velocity-problems', 4, 'Challenge',
 'For that same plane, the wind velocity works out to about 99.7 km/h east and 23.6 km/h south.
What is its true bearing, to the nearest degree?', 1,
 '[
   {"text": "077 degrees", "feedback": "The angle was measured on the north side of east rather than the south side. A southward component pushes the bearing past 090, not below it."},
   {"text": "103 degrees", "feedback": "Correct."},
   {"text": "013 degrees", "feedback": "The wind has a SOUTHWARD component, so its bearing has to be past 090. This one points into the north-east quarter."},
   {"text": "283 degrees", "feedback": "The direction was reversed. This wind blows towards the east, not away from it."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'resultant-velocity-problems', 5, 'Advanced',
 'A boat heads due north at 12 km/h across a river whose current runs east at 5 km/h.
What is the resultant velocity of the boat?', 1,
 '[
   {"text": "13 km/h at a bearing of 337 degrees", "feedback": "The current pushes the boat EAST of north, so the bearing is a little more than zero, not a little less."},
   {"text": "13 km/h at a bearing of 023 degrees", "feedback": "Correct."},
   {"text": "13 km/h at a bearing of 067 degrees", "feedback": "The magnitude is right but the angle was measured from EAST rather than from north."},
   {"text": "17 km/h at a bearing of 023 degrees", "feedback": "The bearing is right but the two speeds were added. They are at right angles, so the Pythagorean theorem applies."}
 ]'::jsonb,
 null),
('MCV4U', 'geometric-vectors', 'resultant-velocity-problems', 6, 'Advanced',
 'The same boat heads due north at 12 km/h across a river 600 m wide, with the current running east at 5 km/h.
How long does the crossing take, and does the current change that time?', 3,
 '[
   {"text": "2.8 minutes, because the resultant speed is higher", "feedback": "The resultant speed is higher, but the extra speed is all sideways. Only the northward part carries the boat across."},
   {"text": "3.0 minutes, but the current makes it longer", "feedback": "The current runs across the crossing rather than against it, so it has been treated as something the boat must fight. Look at which component of the velocity carries the boat toward the far bank."},
   {"text": "7.2 minutes, because the current sets the pace", "feedback": "The width was divided by the CURRENT speed. The boat crosses at its own northward speed."},
   {"text": "3.0 minutes, and the current does not change it", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'cartesian-vectors-and-magnitude', 1, 'Easy',
 'P is the point (2, -3) and Q is the point (7, 1). What is the vector PQ in component form?', 3,
 '[
   {"text": "[-5, -4]", "feedback": "The subtraction went the wrong way round. That is the vector QP, which points back the other way."},
   {"text": "[9, -2]", "feedback": "The two points were added. A vector between points comes from subtracting the start from the finish."},
   {"text": "[5, -4]", "feedback": "The second component was subtracted the other way round from the first. Both of them have to run from the start point to the finish point."},
   {"text": "[5, 4]", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'cartesian-vectors-and-magnitude', 2, 'Easy',
 'What is the magnitude of the vector [3, -4]?', 0,
 '[
   {"text": "5", "feedback": "Correct."},
   {"text": "-1", "feedback": "The components were added. A magnitude comes from squaring each one first, which removes the signs."},
   {"text": "7", "feedback": "The absolute values were added. That is the distance you would walk in two straight legs, not the direct distance."},
   {"text": "25", "feedback": "The square root was never taken. That is the SQUARE of the magnitude."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'cartesian-vectors-and-magnitude', 3, 'Medium',
 'Compute [3, -4] + 2[-1, 6].', 1,
 '[
   {"text": "[4, 4]", "feedback": "The scalar was applied to the first vector as well as the second."},
   {"text": "[1, 8]", "feedback": "Correct."},
   {"text": "[1, -8]", "feedback": "The negative sign from the first vector was carried down into the second component instead of being added in."},
   {"text": "[2, 2]", "feedback": "The scalar 2 was never applied. It multiplies BOTH components of the second vector."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'cartesian-vectors-and-magnitude', 4, 'Medium',
 'What is the unit vector in the direction of [3, -4]?', 0,
 '[
   {"text": "[0.6, -0.8]", "feedback": "Correct."},
   {"text": "[3, -4]", "feedback": "Its magnitude is 5, not 1. It has to be divided by that magnitude first."},
   {"text": "[-0.6, 0.8]", "feedback": "The magnitude is right but the direction is reversed. Dividing by a positive length cannot flip a vector."},
   {"text": "[0.8, -0.6]", "feedback": "The two components were swapped. Each one is divided by the magnitude in place."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'cartesian-vectors-and-magnitude', 5, 'Challenge',
 'For what value of k are [2, k] and [6, 9] parallel?', 2,
 '[
   {"text": "k = 27", "feedback": "The scale factor between the two vectors was applied in the wrong direction. It carries the first vector onto the second, and here you need to come back the other way."},
   {"text": "k = 4.5", "feedback": "The second component of one vector was divided by the FIRST component of the other. Matching components have to be compared with matching components."},
   {"text": "k = 3", "feedback": "Correct."},
   {"text": "k = -3", "feedback": "A sign was flipped. Both given vectors have positive first components, so the scalar linking them is positive."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'cartesian-vectors-and-magnitude', 6, 'Challenge',
 'A vector has magnitude 10 and makes an angle of 30 degrees with the positive x-axis.
What is it in component form, to two decimal places?', 0,
 '[
   {"text": "[8.66, 5.00]", "feedback": "Correct."},
   {"text": "[5.00, 8.66]", "feedback": "The two components were swapped. Cosine reaches the side beside the angle, which is the horizontal one."},
   {"text": "[10.00, 30.00]", "feedback": "The magnitude and the angle were written down as though they were components. They still have to be resolved."},
   {"text": "[5.77, 5.00]", "feedback": "Tangent was used for the first component. Tangent compares the two components with each other, not either one with the magnitude."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'cartesian-vectors-and-magnitude', 7, 'Advanced',
 'Let u = [2, -1] and v = [3, 4].
Write w = [12, 5] in the form a times u plus b times v.', 1,
 '[
   {"text": "w = -3u + 2v", "feedback": "A sign was flipped on the first coefficient. That would make the first component zero."},
   {"text": "w = 3u + 2v", "feedback": "Correct."},
   {"text": "w = 2u + 3v", "feedback": "The two coefficients were swapped. Substitute this back and the first component comes out as 13, not 12."},
   {"text": "w = 3u - 2v", "feedback": "A sign was flipped. With a minus here the second component comes out as negative 11."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'the-dot-product', 1, 'Easy',
 'What is the dot product of [3, -4] and [2, 5]?', 0,
 '[
   {"text": "-14", "feedback": "Correct."},
   {"text": "14", "feedback": "The signs were stripped off the two products and the smaller size taken from the larger. Each product keeps the sign of the components it came from."},
   {"text": "[6, -20]", "feedback": "The two products were left as a pair. A dot product adds them together into a single number."},
   {"text": "26", "feedback": "The two products were subtracted rather than added."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'the-dot-product', 2, 'Easy',
 'What kind of quantity is a dot product?', 1,
 '[
   {"text": "An angle", "feedback": "An angle can be recovered FROM a dot product, but only after dividing by both magnitudes and taking an inverse cosine."},
   {"text": "A scalar, a single number with no direction", "feedback": "Correct."},
   {"text": "A vector perpendicular to both", "feedback": "That is the CROSS product. The dot product collapses everything into a single number."},
   {"text": "A vector in the same plane as both", "feedback": "There is no vector at the end of a dot product at all."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'the-dot-product', 3, 'Medium',
 'What does the dot product of a vector u with itself equal?', 3,
 '[
   {"text": "The magnitude of u", "feedback": "The square root was taken one step too early. Each component is squared and the results are added, with no root at the end."},
   {"text": "Twice the magnitude of u", "feedback": "The dot product multiplies corresponding components; it does not double anything."},
   {"text": "Zero", "feedback": "That would need u to be perpendicular to itself, which only the zero vector manages."},
   {"text": "The square of the magnitude of u", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'the-dot-product', 4, 'Medium',
 'What is the angle between [4, 5, 2] and [3, 2, 7], to one decimal place?', 2,
 '[
   {"text": "133.0 degrees", "feedback": "A sign was lost somewhere. The dot product here is positive, so the angle has to be acute."},
   {"text": "36.0 degrees", "feedback": "That is the dot product itself, read as though it were already an angle. It still has to be divided by both magnitudes."},
   {"text": "47.0 degrees", "feedback": "Correct."},
   {"text": "43.0 degrees", "feedback": "The inverse SINE was taken instead of the inverse cosine, which gives the complement of the angle wanted."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'the-dot-product', 5, 'Challenge',
 'For what value of k are [2, k, 3] and [4, -1, 2] perpendicular?', 0,
 '[
   {"text": "k = 14", "feedback": "Correct."},
   {"text": "k = -14", "feedback": "A sign was flipped when isolating. The middle term of the dot product is negative k, so moving it across makes k positive."},
   {"text": "k = 2", "feedback": "The sign of the third term was flipped, so that product was taken away instead of added."},
   {"text": "k = -2", "feedback": "Two signs went astray at once: the middle term was taken as positive k and the third product was subtracted."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'the-dot-product', 6, 'Challenge',
 'Vectors u and v have magnitudes 5 and 8, with an angle of 60 degrees between them.
What is u dot v?', 3,
 '[
   {"text": "34.64", "feedback": "Sine was used where cosine belongs. Sine is what appears in the magnitude of the CROSS product."},
   {"text": "40", "feedback": "The two magnitudes were multiplied and the angle was ignored. That is the answer only when the two point the same way."},
   {"text": "3", "feedback": "The magnitudes were subtracted. A dot product multiplies them and then scales by the cosine."},
   {"text": "20", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'the-dot-product', 7, 'Advanced',
 'What is the angle between [1, 1, 0] and [0, 1, 1]?', 0,
 '[
   {"text": "60 degrees", "feedback": "Correct."},
   {"text": "45 degrees", "feedback": "Only one of the two magnitudes was divided out. Both vectors have length root 2, and the dot product has to be divided by each of them in turn."},
   {"text": "90 degrees", "feedback": "The dot product is 1, not zero, so the two are not perpendicular. They share a component."},
   {"text": "120 degrees", "feedback": "A sign was lost. The dot product here is positive, so the angle has to be acute."}
 ]'::jsonb,
 null);