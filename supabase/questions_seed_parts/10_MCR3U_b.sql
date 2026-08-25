-- MCR3U part b (continued -- no delete here, part a already cleared this course's rows)

insert into public.questions
  (course_code, unit_code, subtopic_code, sort_order, difficulty,
   prompt, correct_index, options, misconception_tag)
values
('MCR3U', 'functions', 'working-with-radicals', 3, 'Medium',
 'Multiply and simplify fully: 2√3 × 4√6', 1,
 '[
   {"text": "72√2", "feedback": "When the 9 leaves the radical it becomes 3, not 9. Multiply 8 by 3."},
   {"text": "24√2", "feedback": "Correct."},
   {"text": "8√18", "feedback": "The multiplication is right but 18 still hides a perfect square. Pull the 9 out."},
   {"text": "6√18", "feedback": "The numbers out front multiply, they do not add: 2 × 4, not 2 + 4."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'working-with-radicals', 4, 'Challenge',
 'Expand and simplify: (3 + √2)(3 - √2)', 2,
 '[
   {"text": "9", "feedback": "The middle terms cancel, but √2 × √2 = 2 survives and must be subtracted."},
   {"text": "11 - 6√2", "feedback": "That squares (3 - √2) instead of multiplying the two different brackets together."},
   {"text": "7", "feedback": "Correct."},
   {"text": "11", "feedback": "The product of conjugates SUBTRACTS the squares: the √2 terms cancel and their product comes off the 9."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'working-with-radicals', 5, 'Advanced',
 'Simplify fully: √12 + √27', 3,
 '[
   {"text": "√39", "feedback": "Roots do not add through the radicand: √12 + √27 is not √(12 + 27). Simplify each first."},
   {"text": "6√3", "feedback": "The coefficients 2 and 3 are ADDED once the radicands match, not multiplied."},
   {"text": "5√6", "feedback": "Both radicals simplify to a radicand of 3: check 12 = 4 × 3 and 27 = 9 × 3."},
   {"text": "5√3", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'working-with-radicals', 6, 'Advanced',
 'Evaluate: (2√5)²', 1,
 '[
   {"text": "4√5", "feedback": "The 2 was squared but the radical was left standing. Squaring removes the root entirely."},
   {"text": "20", "feedback": "Correct."},
   {"text": "10", "feedback": "Only the radical was squared. The 2 out front gets squared as well."},
   {"text": "100", "feedback": "Squaring √5 gives 5, not 25. The root and the square undo each other."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'linear-quadratic-systems', 1, 'Easy',
 'What is the greatest number of points at which a straight line can intersect a parabola?', 0,
 '[
   {"text": "2", "feedback": "Correct."},
   {"text": "1", "feedback": "One touch is the tangent case, but a line can also cut clean through both arms."},
   {"text": "3", "feedback": "Three crossings would need the line to bend back, and lines do not bend."},
   {"text": "4", "feedback": "Substituting the line into the parabola gives a quadratic, and a quadratic has at most two solutions."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'linear-quadratic-systems', 2, 'Medium',
 'Find the x-coordinates where the line y = 2x + 3 meets the parabola y = x².', 2,
 '[
   {"text": "x = 1 and x = 3", "feedback": "Check by multiplying: (x - 1)(x - 3) ends in +3, and this equation ends in -3."},
   {"text": "They never meet", "feedback": "The discriminant is 4 - 4(1)(-3), and subtracting a negative makes it positive, not negative."},
   {"text": "x = 3 and x = -1", "feedback": "Correct."},
   {"text": "x = -3 and x = 1", "feedback": "x² - 2x - 3 factors as (x - 3)(x + 1). Each bracket flips sign when solved."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'linear-quadratic-systems', 3, 'Medium',
 'A line is substituted into a parabola and the resulting quadratic has a discriminant of exactly zero. What does this mean?', 1,
 '[
   {"text": "The line passes through the vertex", "feedback": "A tangent line can touch anywhere on the curve. The vertex is not special here."},
   {"text": "The line touches the parabola at exactly one point", "feedback": "Correct."},
   {"text": "The line misses the parabola entirely", "feedback": "Missing entirely is the NEGATIVE discriminant case — no real solutions at all."},
   {"text": "The line crosses the parabola at two points", "feedback": "Two crossings need two different solutions, which takes a positive discriminant."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'linear-quadratic-systems', 4, 'Challenge',
 'Find the points where the line y = x - 5 meets the parabola y = x² - 2x - 3.', 3,
 '[
   {"text": "(1, -4) only", "feedback": "The algebra produced two x-values, and both are genuine crossings. Neither can be discarded."},
   {"text": "(-1, -6) and (-2, -7)", "feedback": "x² - 3x + 2 factors as (x - 1)(x - 2), and each bracket solves to a POSITIVE x."},
   {"text": "They never meet", "feedback": "The discriminant of x² - 3x + 2 is 9 - 8, which is positive, so there are two crossings."},
   {"text": "(1, -4) and (2, -3)", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'linear-quadratic-systems', 5, 'Advanced',
 'For what value of k is the line y = 2x + k tangent to the parabola y = x² + 3x + 5?', 0,
 '[
   {"text": "k = 19/4", "feedback": "Correct."},
   {"text": "k = -19/4", "feedback": "From 1 - 4(5 - k) = 0, expanding gives -20 + 4k, and solving that keeps k positive."},
   {"text": "k = 21/4", "feedback": "The 4ac term has been added here instead of subtracted. The discriminant is b² - 4ac."},
   {"text": "k = 5", "feedback": "Matching the constant terms is not tangency. Tangency is the combined discriminant hitting exactly zero."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'rational-exponents', 1, 'Easy',
 'Write ∛x using a rational exponent.', 0,
 '[
   {"text": "x^(1/3)", "feedback": "Correct."},
   {"text": "x³", "feedback": "The index of the root became a whole-number power. A root is a fractional power."},
   {"text": "3x", "feedback": "The index was turned into a multiplier. It belongs on the bottom of the exponent."},
   {"text": "x^(-3)", "feedback": "A root is not a reciprocal power. Nothing here flips the base."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'rational-exponents', 2, 'Easy',
 'Evaluate: 8^(1/3)', 2,
 '[
   {"text": "24", "feedback": "That multiplies 8 by 3. A fractional exponent asks for a root, not a product."},
   {"text": "512", "feedback": "That cubes the 8. An exponent of one third undoes a cube, it does not apply one."},
   {"text": "2", "feedback": "Correct."},
   {"text": "8/3", "feedback": "That divides 8 by 3. The 3 on the bottom of the exponent is the index of a root."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'rational-exponents', 3, 'Medium',
 'Evaluate: 8^(2/3)', 3,
 '[
   {"text": "2", "feedback": "The cube root was taken and then the power 2 was never applied."},
   {"text": "64", "feedback": "That squares 8 and forgets the 3 on the bottom of the exponent."},
   {"text": "16/3", "feedback": "That multiplies 8 by two thirds. A fractional exponent is a root and a power, not a product."},
   {"text": "4", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'rational-exponents', 4, 'Medium',
 'Evaluate: 81^(5/4)', 1,
 '[
   {"text": "3", "feedback": "The fourth root was taken and the power 5 was never applied."},
   {"text": "243", "feedback": "Correct."},
   {"text": "405", "feedback": "That multiplies 81 by 5. The 5 is an exponent applied to the root, not a multiplier."},
   {"text": "15", "feedback": "The fourth root was found correctly and then multiplied by 5 instead of being raised to the power 5."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'rational-exponents', 5, 'Challenge',
 'Simplify: (5x^(1/2))² × 4x^(-1/2)', 2,
 '[
   {"text": "20√x", "feedback": "Only the x inside the bracket was squared. The 5 takes the outer power as well."},
   {"text": "40√x", "feedback": "The 5 was doubled rather than squared."},
   {"text": "100√x", "feedback": "Correct."},
   {"text": "100x^(3/2)", "feedback": "The minus on the second exponent was dropped, so the two half-powers were added instead of one being taken away."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'rational-exponents', 6, 'Challenge',
 'Evaluate: (49/81)^(-3/2)', 0,
 '[
   {"text": "729/343", "feedback": "Correct."},
   {"text": "343/729", "feedback": "A negative exponent flips the base before the power is applied, and this is what the same power gives without that flip."},
   {"text": "9/7", "feedback": "The base was flipped and square rooted, but the 3 on the top of the exponent was never applied."},
   {"text": "-729/343", "feedback": "A negative exponent turns the fraction over. It does not make the value negative."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'rational-exponents', 7, 'Advanced',
 'Simplify, leaving only positive exponents:
((m⁻²)³√(m⁴))/(m√(pq⁻³))', 1,
 '[
   {"text": "m⁵q^(3/2)/√p", "feedback": "The m exponent finished negative, so that power belongs on the bottom of the fraction."},
   {"text": "q^(3/2)/(m⁵√p)", "feedback": "Correct."},
   {"text": "1/(m⁵√p q^(3/2))", "feedback": "The q carried a negative exponent inside the root on the bottom, so it travels up to the top."},
   {"text": "q^(3/2)/(m⁴√p)", "feedback": "The lone m in the denominator was never divided out, and it costs one more power of m."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'rational-exponents', 8, 'Advanced',
 'Simplify, leaving only positive exponents: (y^(1/4))² × (y^(-1/3))²', 3,
 '[
   {"text": "y^(1/6)", "feedback": "The combined exponent finishes negative, because two thirds is larger than one half."},
   {"text": "1/y^(1/12)", "feedback": "The outer squares were never applied. Both exponents double before they combine."},
   {"text": "1/y^(1/3)", "feedback": "The exponents were multiplied. Multiplying powers of the same base adds them."},
   {"text": "1/y^(1/6)", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'restrictions-on-the-variable', 1, 'Easy',
 'State the restriction on the variable: (x + 2)/(x - 5)', 1,
 '[
   {"text": "x ≠ -5", "feedback": "Solving x - 5 = 0 moves the 5 across as a positive number."},
   {"text": "x ≠ 5", "feedback": "Correct."},
   {"text": "x ≠ -2", "feedback": "That is the value making the numerator zero. A zero on top is allowed; only the bottom is forbidden."},
   {"text": "x ≠ 0", "feedback": "The denominator here is x - 5, not x on its own, so it reaches zero somewhere other than the origin."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'restrictions-on-the-variable', 2, 'Easy',
 'State all restrictions on the variable: 7/(x(x + 3))', 3,
 '[
   {"text": "x ≠ 0 and x ≠ 3", "feedback": "The bracket x + 3 hits zero at a negative value. The sign flips when the bracket is solved."},
   {"text": "x ≠ -3 only", "feedback": "There are two factors on the bottom, and the bare x is one of them."},
   {"text": "x ≠ 0 only", "feedback": "The bracket x + 3 can reach zero as well, and that value is forbidden too."},
   {"text": "x ≠ 0 and x ≠ -3", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'restrictions-on-the-variable', 3, 'Medium',
 'State all restrictions on the variable: (x - 3)/(x² + 3x - 18)', 2,
 '[
   {"text": "x ≠ -6, with no other restriction", "feedback": "The expression cancels down to a single bracket, but the restriction from the cancelled factor still stands."},
   {"text": "x ≠ 6 and x ≠ -3", "feedback": "The numbers were copied straight out of the brackets as the restricted values. Each bracket still has to be set to zero and solved."},
   {"text": "x ≠ -6 and x ≠ 3", "feedback": "Correct."},
   {"text": "x ≠ 3, with no other restriction", "feedback": "The denominator has two factors, and both of them can reach zero."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'restrictions-on-the-variable', 4, 'Medium',
 'State all restrictions on the variable: (x + 12)/(x + 10) ÷ (x + 12)/(x - 5)', 0,
 '[
   {"text": "x ≠ -10, x ≠ -12 and x ≠ 5", "feedback": "Correct."},
   {"text": "x ≠ -10 and x ≠ 5", "feedback": "Once the second fraction is flipped, its numerator becomes a denominator, so that bracket is restricted too."},
   {"text": "x ≠ -10 only", "feedback": "A division brings two more brackets into play: the one being divided by, and the one it turns into after the flip."},
   {"text": "x ≠ -10 and x ≠ -12", "feedback": "The second fraction has a denominator of its own before the flip, and that value is forbidden as well."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'restrictions-on-the-variable', 5, 'Challenge',
 'State ALL restrictions on the variable:
(x² - 7x + 10)/(x² - 4) ÷ (x² - 4x - 5)/(3x + 6)', 3,
 '[
   {"text": "x ≠ -2 and x ≠ 2", "feedback": "Only the first denominator was checked. A division adds the thing being divided by to the list of what cannot be zero."},
   {"text": "x ≠ -2, x ≠ -1 and x ≠ 2", "feedback": "The expression being divided by factors into two brackets, and only one of them was recorded."},
   {"text": "x ≠ -1 only", "feedback": "Those are the restrictions of the simplified result. The original expression forbids more values than that."},
   {"text": "x ≠ -2, x ≠ -1, x ≠ 2 and x ≠ 5", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'restrictions-on-the-variable', 6, 'Challenge',
 'State all restrictions on the variable: (2x² + 7x - 15)/(2x² + 3x - 9)', 1,
 '[
   {"text": "x ≠ -3, with no other restriction", "feedback": "The denominator has two factors, and the one that cancels away still counts."},
   {"text": "x ≠ -3 and x ≠ 3/2", "feedback": "Correct."},
   {"text": "x ≠ 3/2, with no other restriction", "feedback": "The bracket x + 3 on the bottom also reaches zero, and that value is forbidden too."},
   {"text": "x ≠ -5 and x ≠ 3/2", "feedback": "The value -5 comes from the numerator. A zero on the top is perfectly legal."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'restrictions-on-the-variable', 7, 'Advanced',
 'State ALL restrictions on the variable:
(x² + 3x + 2)/(x² - 1) × (x - 1)/(x² - 2x - 8)', 0,
 '[
   {"text": "x ≠ -2, x ≠ -1, x ≠ 1 and x ≠ 4", "feedback": "Correct."},
   {"text": "x ≠ -1, x ≠ 1 and x ≠ 4", "feedback": "x² - 2x - 8 factors into two brackets, and only one of them was recorded."},
   {"text": "x ≠ -2, x ≠ 1 and x ≠ 4", "feedback": "x² - 1 is a difference of squares, so it has two roots, one on each side of zero."},
   {"text": "x ≠ 4 only", "feedback": "Those are the restrictions of the simplified result. Every bracket that cancelled on the way still counts."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'restrictions-on-the-variable', 8, 'Advanced',
 'Simplify (x² - 25)/(x² - 10x + 25) and state the restrictions.', 2,
 '[
   {"text": "(x + 5)/(x - 5), with x ≠ 5 and x ≠ -5", "feedback": "The value -5 makes the numerator zero, not the denominator. A zero on the top is allowed."},
   {"text": "(x - 5)/(x + 5), with x ≠ -5", "feedback": "The denominator is a perfect square, and the bracket being squared is x - 5, not x + 5."},
   {"text": "(x + 5)/(x - 5), with x ≠ 5", "feedback": "Correct."},
   {"text": "(x + 5)/(x - 5), with no restrictions", "feedback": "Simplifying does not repair the original expression. It was already undefined at that value before any cancelling happened."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'simplifying-multiplying-and-dividing', 1, 'Easy',
 'Simplify: 3x²/(yx)', 0,
 '[
   {"text": "3x/y", "feedback": "Correct."},
   {"text": "3x³/y", "feedback": "The x exponents were added. Dividing powers of the same base subtracts them."},
   {"text": "3/y", "feedback": "The whole x² was cancelled against a single x. Only one factor of x is available to cancel."},
   {"text": "3xy", "feedback": "The y was moved to the top. Cancelling never relocates a factor that has no partner."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'simplifying-multiplying-and-dividing', 2, 'Easy',
 'Simplify: (x² + 10x + 21)/(x + 3)', 2,
 '[
   {"text": "x + 3", "feedback": "The bracket that cancels is the one matching the bottom. What survives is the other factor."},
   {"text": "(x² + 10x + 21)/x", "feedback": "Only the number 3 was struck out. Cancelling works on whole factors, never on one term inside a bracket."},
   {"text": "x + 7", "feedback": "Correct."},
   {"text": "7", "feedback": "The x and the 3 were struck out separately. A bracket cancels as one piece or not at all."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'simplifying-multiplying-and-dividing', 3, 'Medium',
 'Simplify: (x² - 9)/(x² + 7x + 12)', 3,
 '[
   {"text": "-9/(7x + 12)", "feedback": "The x² terms were struck out across a subtraction and an addition. Cancelling works only on whole factors."},
   {"text": "(x - 3)/(x + 3)", "feedback": "The bracket that goes is the one appearing on both the top and the bottom. Check which factor the two share."},
   {"text": "(x + 3)/(x + 4)", "feedback": "A difference of squares factors into one plus bracket and one minus bracket, not two pluses."},
   {"text": "(x - 3)/(x + 4)", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'simplifying-multiplying-and-dividing', 4, 'Medium',
 'Simplify: (4x + 24)/(x² + 8x) × 12x²/(3x + 18)', 1,
 '[
   {"text": "48x/(x + 8)", "feedback": "The 3 in the second denominator was never divided out."},
   {"text": "16x/(x + 8)", "feedback": "Correct."},
   {"text": "16x²/(x + 8)", "feedback": "One factor of x on the bottom was left uncancelled. There is an x hiding inside x² + 8x."},
   {"text": "16/(x + 8)", "feedback": "Both factors of x on the top were cancelled, but the bottom only offers one to cancel against."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'simplifying-multiplying-and-dividing', 5, 'Challenge',
 'Simplify: (6x² - 7x - 5)/(3x² + x - 10)', 0,
 '[
   {"text": "(2x + 1)/(x + 2)", "feedback": "Correct."},
   {"text": "(2x - 1)/(x + 2)", "feedback": "Multiply the numerator factors back out: pairing 2x - 1 with 3x - 5 gives a constant of +5, and this numerator ends in -5."},
   {"text": "(2x + 1)/(x - 2)", "feedback": "Multiply the denominator factors back out: that version ends in +10, and this denominator ends in -10."},
   {"text": "(2x + 1)/(3x - 5)", "feedback": "The shared bracket 3x - 5 is what cancels, and it has to go from the top and the bottom at the same time."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'simplifying-multiplying-and-dividing', 6, 'Challenge',
 'Simplify:
(2x² - 8x)/(x² - 3x - 10) ÷ 4x²/(x² - 9x + 20)', 2,
 '[
   {"text": "8x³/((x - 5)²(x + 2))", "feedback": "The second fraction was multiplied in as it stood. Dividing means turning it over first."},
   {"text": "2x(x + 2)/(x - 4)²", "feedback": "The wrong fraction was flipped. It is the one after the division sign that turns over."},
   {"text": "(x - 4)²/(2x(x + 2))", "feedback": "Correct."},
   {"text": "(x - 4)²/(2x(x - 2))", "feedback": "x² - 3x - 10 needs a pair multiplying to -10, so one of the two numbers has to be positive."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'simplifying-multiplying-and-dividing', 7, 'Advanced',
 'Simplify:
(x² - 1)/(x² - 4) × (x² + 3x - 4)/(x² + 5x + 4)', 3,
 '[
   {"text": "(x + 1)²/((x - 2)(x + 2))", "feedback": "The bracket the two fractions share is x + 1, and it cancels away. The one left doubled is the other."},
   {"text": "(x - 1)/((x - 2)(x + 2))", "feedback": "The two x - 1 brackets come from different fractions and both survive. Only a top and a bottom cancel each other."},
   {"text": "(x - 1)²/((x + 1)(x - 2)(x + 2))", "feedback": "The x + 1 on the bottom has a partner on the top and should have gone."},
   {"text": "(x - 1)²/((x - 2)(x + 2))", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'simplifying-multiplying-and-dividing', 8, 'Advanced',
 'Simplify:
(x² - 9)/(x² - x - 6) ÷ (x² + 7x + 12)/(x² + 2x - 8)', 1,
 '[
   {"text": "(x + 2)/(x - 2)", "feedback": "The result came out upside down, which is what happens when the first fraction is flipped instead of the second."},
   {"text": "(x - 2)/(x + 2)", "feedback": "Correct."},
   {"text": "(x - 3)/(x + 2)", "feedback": "The x - 2 on the top was struck out against the x - 3 on the bottom. Brackets cancel only when they are identical."},
   {"text": "(x - 2)/(x + 3)", "feedback": "The x + 3 cancels away completely. The bracket left on the bottom comes from x² - x - 6."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'adding-and-subtracting', 1, 'Easy',
 'Simplify: 3/x + 4/x', 3,
 '[
   {"text": "7/(2x)", "feedback": "The denominators were added as well. With a common denominator already in place it stays exactly as it is."},
   {"text": "12/x²", "feedback": "The two fractions were multiplied. The sign between them is a plus."},
   {"text": "1/x", "feedback": "That subtracts the numerators. Read the sign between the two fractions again."},
   {"text": "7/x", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'adding-and-subtracting', 2, 'Easy',
 'Simplify: 1/(5x) + 1/(2x)', 1,
 '[
   {"text": "2/(7x)", "feedback": "Numerators and denominators were added straight across. Fractions are never combined that way."},
   {"text": "7/(10x)", "feedback": "Correct."},
   {"text": "2/(10x)", "feedback": "The common denominator is right, but the numerators were not rescaled to match it."},
   {"text": "7/(10x²)", "feedback": "The x was multiplied along with the numbers. Each denominator already carries exactly one x."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'adding-and-subtracting', 3, 'Medium',
 'Simplify: 5/(7x) - 3/(4x)', 0,
 '[
   {"text": "-1/(28x)", "feedback": "Correct."},
   {"text": "1/(28x)", "feedback": "The subtraction ran the wrong way round: 21 taken from 20 lands below zero."},
   {"text": "2/(3x)", "feedback": "Numerators and denominators were subtracted straight across. Fractions are never combined that way."},
   {"text": "41/(28x)", "feedback": "The two rescaled numerators were added instead of subtracted."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'adding-and-subtracting', 4, 'Medium',
 'Simplify: 4/(ab) + 9/(2b)', 2,
 '[
   {"text": "13/(ab + 2b)", "feedback": "Numerators and denominators were added straight across. Fractions are never combined that way."},
   {"text": "13/(2ab²)", "feedback": "The numerators were added and the denominators multiplied. A common denominator is not the product of everything in sight."},
   {"text": "(8 + 9a)/(2ab)", "feedback": "Correct."},
   {"text": "17/(2ab)", "feedback": "The denominators were brought to 2ab correctly, but the numerators were not rescaled by the same factors."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'adding-and-subtracting', 5, 'Challenge',
 'Simplify: 2/(x - 3) - 5/(x + 3)', 1,
 '[
   {"text": "(-3x - 9)/((x - 3)(x + 3))", "feedback": "The minus reached the 5x but not the -15 behind it. It has to hit every term in the bracket."},
   {"text": "(-3x + 21)/((x - 3)(x + 3))", "feedback": "Correct."},
   {"text": "(7x - 9)/((x - 3)(x + 3))", "feedback": "The two rescaled numerators were added. The sign between the fractions is a minus."},
   {"text": "-3/((x - 3)(x + 3))", "feedback": "The numerators were subtracted as they stood, without first being rescaled by the bracket each one was missing."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'adding-and-subtracting', 6, 'Challenge',
 'Simplify: 4x/(x² - 9x + 18) + (2x - 1)/(x - 6)', 3,
 '[
   {"text": "(6x - 1)/((x - 3)(x - 6))", "feedback": "The numerators were added as they stood. The second one still needs rescaling by the bracket it is missing."},
   {"text": "(2x² - 9x + 6)/((x - 3)(x - 6))", "feedback": "The second fraction was rescaled by x - 6, which it already has. The bracket it lacks is x - 3."},
   {"text": "(2x² - 3x + 3)/((x² - 9x + 18)(x - 6))", "feedback": "The denominators were multiplied together. One of them already contains the other as a factor."},
   {"text": "(2x² - 3x + 3)/((x - 3)(x - 6))", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'adding-and-subtracting', 7, 'Advanced',
 'Simplify:
(3x + 9)/(x² + 5x + 6) - (2x - 2)/(x² + x - 2)', 2,
 '[
   {"text": "5/(x + 2)", "feedback": "The two reduced fractions were added. The sign between them is a minus."},
   {"text": "-1/(x + 2)", "feedback": "The subtraction ran backwards. It is the second numerator that comes off the first."},
   {"text": "1/(x + 2)", "feedback": "Correct."},
   {"text": "1/(x + 3)", "feedback": "Both fractions reduce to the same denominator, and it is the bracket they have in common, not the one only the first carries."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'adding-and-subtracting', 8, 'Advanced',
 'Simplify: (3x + 2)/(3 - 4x) + (2x + 1)/(4x - 3)', 0,
 '[
   {"text": "(x + 1)/(3 - 4x)", "feedback": "Correct."},
   {"text": "(5x + 3)/(3 - 4x)", "feedback": "The two denominators differ by a factor of -1, and pulling that minus out turns the addition into a subtraction."},
   {"text": "(5x + 3)/((3 - 4x)(4x - 3))", "feedback": "The denominators were multiplied together. They are already the same apart from a factor of -1."},
   {"text": "(x + 3)/(3 - 4x)", "feedback": "The minus that came out of the second fraction reached the 2x but not the 1 behind it."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'transforming-x-squared', 1, 'Easy',
 'What is the vertex of y = (x - 4)² + 1?', 3,
 '[
   {"text": "(-4, 1)", "feedback": "The sign inside the bracket flips: x - 4 puts the vertex at positive 4."},
   {"text": "(1, 4)", "feedback": "The coordinates are swapped. The number inside the bracket is the x-coordinate."},
   {"text": "(4, -1)", "feedback": "The constant outside the bracket is added, so the vertex sits above the axis, not below it."},
   {"text": "(4, 1)", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'transforming-x-squared', 2, 'Easy',
 'How does the graph of y = -x² compare with y = x²?', 2,
 '[
   {"text": "It is shifted down", "feedback": "A shift needs a number added or subtracted outside. The minus multiplies every output instead."},
   {"text": "It is compressed vertically", "feedback": "A compression needs a factor between -1 and 1. The factor here is exactly -1, so the shape is unchanged."},
   {"text": "It is reflected in the x-axis", "feedback": "Correct."},
   {"text": "It is reflected in the y-axis", "feedback": "A reflection in the y-axis needs the minus inside, as (-x)², and squaring would undo it anyway."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'transforming-x-squared', 3, 'Medium',
 'Write the equation for y = x² after a vertical stretch by 3,
a shift left 2 and a shift down 1.', 3,
 '[
   {"text": "y = 3(x - 2)² - 1", "feedback": "A shift LEFT is written x + 2. The sign inside the bracket is the opposite of the direction."},
   {"text": "y = 3(x + 2)² + 1", "feedback": "A shift down subtracts from the output, so the constant on the end is negative."},
   {"text": "y = (3x + 2)² - 1", "feedback": "The 3 has slipped inside the bracket, where it would stretch the graph sideways instead of upward."},
   {"text": "y = 3(x + 2)² - 1", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'transforming-x-squared', 4, 'Medium',
 'The point (3, 9) lies on y = x². Where does it land on y = 2(x - 1)² + 5?', 2,
 '[
   {"text": "(4, 14)", "feedback": "The shift up was applied but the stretch was not. The y-value doubles before the 5 is added."},
   {"text": "(2, 23)", "feedback": "The x-coordinate moved the wrong way. x - 1 slides the graph right, so 3 becomes 4."},
   {"text": "(4, 23)", "feedback": "Correct."},
   {"text": "(4, 18)", "feedback": "The stretch was applied but the shift up was not. The + 5 still has to be added on."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'transforming-x-squared', 5, 'Challenge',
 'Write the equation for y = x² after a vertical stretch by 2, a horizontal
stretch by 3, a reflection in the x-axis, a shift up 2 and a shift left 6.', 1,
 '[
   {"text": "y = 2[(1/3)(x + 6)]² + 2", "feedback": "The reflection in the x-axis never reached a. It is the minus in front that flips the graph over."},
   {"text": "y = -2[(1/3)(x + 6)]² + 2", "feedback": "Correct."},
   {"text": "y = -2[3(x + 6)]² + 2", "feedback": "A horizontal stretch by 3 needs k = 1/3, because the graph is scaled by 1 over k. Putting 3 in squashes it instead."},
   {"text": "y = -2[(1/3)(x - 6)]² + 2", "feedback": "A shift LEFT is written x + 6. The sign inside the bracket is the opposite of the direction."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'transforming-x-squared', 6, 'Challenge',
 'Give the vertex of f(x) = -(x + 6)² + 4 and say which way it opens.', 1,
 '[
   {"text": "Vertex (4, -6), opens downward", "feedback": "The coordinates are swapped. The number inside the bracket gives x and the one outside gives y."},
   {"text": "Vertex (-6, 4), opens downward", "feedback": "Correct."},
   {"text": "Vertex (6, 4), opens downward", "feedback": "The sign inside the bracket flips: x + 6 puts the vertex at negative 6."},
   {"text": "Vertex (-6, 4), opens upward", "feedback": "The minus in front of the bracket turns every output negative, which tips the parabola over."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'transforming-x-squared', 7, 'Advanced',
 'Which transformations of y = x² produce y = x² - 6x + 11?', 3,
 '[
   {"text": "Left 3 and up 2", "feedback": "Completing the square gives a bracket of (x - 3), and a minus inside moves the graph right."},
   {"text": "Right 6 and up 11", "feedback": "The coefficients were read straight off the expanded form. Complete the square first to see the real shifts."},
   {"text": "Right 3 and up 11", "feedback": "Completing the square puts a 9 inside the bracket, and that 9 has to be taken back off the 11."},
   {"text": "Right 3 and up 2", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'transforming-the-square-root', 1, 'Easy',
 'The graph of y = √x is moved to give y = √(x - 3). Which way did it move?', 2,
 '[
   {"text": "Down 3 units", "feedback": "The 3 is inside the root, so it acts on x. A vertical move needs it outside."},
   {"text": "Up 3 units", "feedback": "The 3 is inside the root, so it acts on x, and it is being subtracted rather than added."},
   {"text": "Right 3 units", "feedback": "Correct."},
   {"text": "Left 3 units", "feedback": "The minus sign was read as the direction of travel. Inside the root the sign is the opposite of the way the graph moves."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'transforming-the-square-root', 2, 'Easy',
 'Where does the graph of y = √x + 2 start?', 2,
 '[
   {"text": "(2, 0)", "feedback": "The 2 sits outside the root, so it moves the graph up. Inside the root it would move it sideways."},
   {"text": "(-2, 0)", "feedback": "The 2 is outside the root and positive, so it lifts the start point rather than sliding it left."},
   {"text": "(0, 2)", "feedback": "Correct."},
   {"text": "(0, -2)", "feedback": "The 2 is being added, so the starting point rises rather than drops."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'transforming-the-square-root', 3, 'Medium',
 'Write the equation for y = √x translated up 4 and right 9.', 1,
 '[
   {"text": "y = √(x - 4) + 9", "feedback": "The two numbers have swapped jobs. The 9 is the horizontal move and the 4 is the vertical one."},
   {"text": "y = √(x - 9) + 4", "feedback": "Correct."},
   {"text": "y = √(x + 9) + 4", "feedback": "A shift RIGHT is written x - 9. The sign inside the root is the opposite of the direction."},
   {"text": "y = √(x - 9) - 4", "feedback": "A shift up adds to the output, so the constant on the end is positive."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'transforming-the-square-root', 4, 'Medium',
 'State the domain and range of y = -√(x + 2) + 1.', 2,
 '[
   {"text": "x ≥ -2 and y ≥ 1", "feedback": "The minus in front of the root flips the graph downward, so 1 is its ceiling rather than its floor."},
   {"text": "x ≤ -2 and y ≤ 1", "feedback": "The inside of a root must be zero or MORE, so the domain runs upward from -2."},
   {"text": "x ≥ -2 and y ≤ 1", "feedback": "Correct."},
   {"text": "x ≥ 2 and y ≤ 1", "feedback": "Setting x + 2 ≥ 0 moves the 2 across as a negative number."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'transforming-the-square-root', 5, 'Challenge',
 'Which point lies on g(x) = 2√(-2x) - 3?', 1,
 '[
   {"text": "(-2, 4)", "feedback": "The stretch was applied but the shift down was not. The - 3 still comes off at the end."},
   {"text": "(-2, 1)", "feedback": "Correct."},
   {"text": "(2, 1)", "feedback": "At x = 2 the inside of the root is negative, so the graph does not exist there at all. The minus on the 2x flips it to the left of the axis."},
   {"text": "(-8, 1)", "feedback": "k = -2 divides the x-coordinate rather than multiplying it, so the parent point does not travel that far out."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'transforming-the-square-root', 6, 'Challenge',
 'State the domain and range of g(x) = √(-4x) + 1.', 1,
 '[
   {"text": "x ≤ 0 and y ≤ 1", "feedback": "Nothing here puts a minus in FRONT of the root, so the graph still climbs away from its starting point."},
   {"text": "x ≤ 0 and y ≥ 1", "feedback": "Correct."},
   {"text": "x ≥ 0 and y ≥ 1", "feedback": "Dividing -4x ≥ 0 by a negative flips the inequality, and that flip was skipped."},
   {"text": "x ≤ 0 and y ≥ 0", "feedback": "The root itself starts at zero, but the + 1 lifts every output by one."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'transforming-the-square-root', 7, 'Advanced',
 'Which point lies on h(x) = (1/2)√(2x) - 3?', 1,
 '[
   {"text": "(2, 1)", "feedback": "The compression was applied but the shift down was not. The - 3 still comes off at the end."},
   {"text": "(2, -2)", "feedback": "Correct."},
   {"text": "(8, -2)", "feedback": "k = 2 divides the x-coordinate rather than multiplying it, so the parent point does not travel that far out."},
   {"text": "(2, -1)", "feedback": "The shift down was applied but the vertical compression was not. The output is halved before the 3 comes off."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'transforming-1-over-x', 1, 'Easy',
 'What is the vertical asymptote of y = 1/x?', 0,
 '[
   {"text": "x = 0", "feedback": "Correct."},
   {"text": "y = 0", "feedback": "That is the HORIZONTAL asymptote. A vertical asymptote is a vertical line, so its equation names x."},
   {"text": "x = 1", "feedback": "The 1 is the numerator. The asymptote comes from what makes the DENOMINATOR zero."},
   {"text": "There is no asymptote", "feedback": "The denominator can reach zero, and where it does the function has no value at all."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'transforming-1-over-x', 2, 'Easy',
 'What is the vertical asymptote of y = 1/(x - 5)?', 3,
 '[
   {"text": "x = -5", "feedback": "Solving x - 5 = 0 moves the 5 across as a positive number."},
   {"text": "y = 5", "feedback": "A vertical asymptote is a vertical line, so its equation names x, not y."},
   {"text": "x = 0", "feedback": "That is the parent asymptote of 1/x. The - 5 has dragged it sideways."},
   {"text": "x = 5", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'transforming-1-over-x', 3, 'Medium',
 'State both asymptotes of y = 1/(x + 3) - 2.', 2,
 '[
   {"text": "x = -3 and y = 2", "feedback": "The 2 is being subtracted, so the whole graph drops and its horizontal asymptote drops with it."},
   {"text": "x = -2 and y = -3", "feedback": "The two numbers have swapped jobs. The one inside the bracket sets the vertical asymptote."},
   {"text": "x = -3 and y = -2", "feedback": "Correct."},
   {"text": "x = 3 and y = -2", "feedback": "Solving x + 3 = 0 moves the 3 across as a negative number."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'transforming-1-over-x', 4, 'Medium',
 'For f(x) = 1/x, what is the horizontal asymptote of g(x) = (1/2)f(x + 1) - 1?', 3,
 '[
   {"text": "y = 0", "feedback": "That is the parent asymptote of 1/x, before the graph was moved down."},
   {"text": "x = -1", "feedback": "That is the VERTICAL asymptote, set by the bracket. A horizontal asymptote names y."},
   {"text": "y = 1/2", "feedback": "The 1/2 squashes the graph toward its asymptote. It is the - 1 that says where that asymptote sits."},
   {"text": "y = -1", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'transforming-1-over-x', 5, 'Challenge',
 'State both asymptotes of y = 1/(2x - 6) + 1.', 0,
 '[
   {"text": "x = 3 and y = 1", "feedback": "Correct."},
   {"text": "x = 6 and y = 1", "feedback": "The 2 in front of the x has to be divided out. Solve 2x - 6 = 0 rather than reading the 6 straight off."},
   {"text": "x = -3 and y = 1", "feedback": "Solving 2x - 6 = 0 moves the 6 across as a positive number."},
   {"text": "x = 3 and y = 0", "feedback": "That is the parent horizontal asymptote. The + 1 lifts the whole graph, and the asymptote rises with it."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'transforming-1-over-x', 6, 'Challenge',
 'As x grows very large, what happens to y = 3/(x + 2) - 4?', 0,
 '[
   {"text": "y approaches -4 from above", "feedback": "Correct."},
   {"text": "y approaches -4 from below", "feedback": "For large positive x the fraction 3/(x + 2) is a small POSITIVE number, not a negative one. Check its sign at x = 1000."},
   {"text": "y approaches 0", "feedback": "That is the parent behaviour of 1/x, before the graph was pulled down by the - 4."},
   {"text": "y grows without bound", "feedback": "That happens close to the vertical asymptote, not far out. Out here the fraction is shrinking toward nothing."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'transforming-1-over-x', 7, 'Advanced',
 'Rewrite g(x) = (2x + 7)/(x + 3) as a transformation of 1/x,
and give both asymptotes.', 3,
 '[
   {"text": "g(x) = 1/(x + 3) + 2, with x = 3 and y = 2", "feedback": "The rewrite is right but the vertical asymptote is not. Solving x + 3 = 0 moves the 3 across as a negative."},
   {"text": "g(x) = 1/(x + 3) + 7/3, with x = -3 and y = 7/3", "feedback": "The horizontal asymptote was read from the two constants. It comes from the leading coefficients, which are 2 and 1."},
   {"text": "g(x) = 1/(x + 3), with x = -3 and y = 0", "feedback": "The whole-number part of the division was dropped. Dividing 2x + 7 by x + 3 leaves something before the remainder."},
   {"text": "g(x) = 1/(x + 3) + 2, with x = -3 and y = 2", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'transforming-1-over-x', 8, 'Advanced',
 'The point (0.5, 2) lies on y = 1/x. Where does it land on y = -1/(x - 2) + 3?', 3,
 '[
   {"text": "(2.5, 5)", "feedback": "The reflection was skipped. The minus in front turns the y-value negative before the 3 is added."},
   {"text": "(2.5, -2)", "feedback": "The reflection was applied but the shift up was not. The + 3 still has to be added on."},
   {"text": "(-1.5, 1)", "feedback": "The x-coordinate moved the wrong way. x - 2 slides the graph right, so 0.5 becomes 2.5."},
   {"text": "(2.5, 1)", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'inverse-of-a-function', 1, 'Easy',
 'If f(3) = 7, what is f inverse of 7?', 0,
 '[
   {"text": "3", "feedback": "Correct."},
   {"text": "7", "feedback": "That repeats the input. The inverse sends an output back to the input it came from."},
   {"text": "1/7", "feedback": "The -1 in the inverse notation is not an exponent, so nothing is being flipped over here."},
   {"text": "-3", "feedback": "The inverse swaps the coordinates. It does not change any signs."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'inverse-of-a-function', 2, 'Easy',
 'The graph of the inverse of f is the graph of f reflected in which line?', 1,
 '[
   {"text": "y = -x", "feedback": "That line has the right slant but the wrong sign, and reflecting in it would negate both coordinates as well as swapping them."},
   {"text": "y = x", "feedback": "Correct."},
   {"text": "The x-axis", "feedback": "Reflecting in the x-axis flips the y-values only. An inverse swaps x and y with each other."},
   {"text": "The y-axis", "feedback": "Reflecting in the y-axis flips the x-values only. An inverse swaps x and y with each other."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'inverse-of-a-function', 3, 'Medium',
 'Find the inverse of h(x) = 4x + 3.', 2,
 '[
   {"text": "4x - 3", "feedback": "The operations were reversed in place rather than solved for. Swap x and y first, then isolate y."},
   {"text": "1/(4x + 3)", "feedback": "The -1 in the inverse notation is not an exponent, so the function is not flipped over."},
   {"text": "(x - 3)/4", "feedback": "Correct."},
   {"text": "(x + 3)/4", "feedback": "Moving the 3 to the other side of x = 4y + 3 makes it negative."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'inverse-of-a-function', 4, 'Medium',
 'If f(x) = 2x - 6, find the value of f inverse at 10.', 3,
 '[
   {"text": "14", "feedback": "That computes f(10). The inverse runs the other way: it asks which input gives 10."},
   {"text": "2", "feedback": "Moving the -6 across makes it +6, so the 6 is added to the 10 before dividing, not taken off it."},
   {"text": "1/14", "feedback": "The -1 in the inverse notation is not an exponent, so nothing is being flipped over."},
   {"text": "8", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'inverse-of-a-function', 5, 'Challenge',
 'Find the inverse of f(x) = x² - 1.', 2,
 '[
   {"text": "±√(x - 1)", "feedback": "Moving the -1 across the equals sign makes it positive."},
   {"text": "1/(x² - 1)", "feedback": "The -1 in the inverse notation is not an exponent, so the function is not flipped over."},
   {"text": "±√(x + 1)", "feedback": "Correct."},
   {"text": "√(x + 1)", "feedback": "Only half the inverse. A parabola sends two different x values to each y, so undoing it needs both branches of the root."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'inverse-of-a-function', 6, 'Challenge',
 'Find the inverse of f(x) = (4x + 3)/5.', 0,
 '[
   {"text": "(5x - 3)/4", "feedback": "Correct."},
   {"text": "(5x + 3)/4", "feedback": "Moving the 3 to the other side of 5x = 4y + 3 makes it negative."},
   {"text": "(4x - 3)/5", "feedback": "The 4 and the 5 never traded places. Multiply both sides by 5 first, then divide by 4."},
   {"text": "5/(4x + 3)", "feedback": "The -1 in the inverse notation is not an exponent, so the function is not flipped over."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'inverse-of-a-function', 7, 'Advanced',
 'Find the inverse of f(x) = 2x² + 16x + 30 by completing the square first.', 0,
 '[
   {"text": "-4 ± √((x + 2)/2)", "feedback": "Correct."},
   {"text": "4 ± √((x + 2)/2)", "feedback": "The completed square is (x + 4)², so when the 4 crosses the equals sign it stays negative."},
   {"text": "-4 ± √((x - 2)/2)", "feedback": "The vertex form ends in - 2, so moving that constant across the equals sign makes it positive."},
   {"text": "-4 ± √(2(x + 2))", "feedback": "The 2 in front of the bracket is undone by dividing, not by multiplying."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'inverse-of-a-function', 8, 'Advanced',
 'Find the inverse of f(x) = √x + 2 and state the domain of that inverse.', 1,
 '[
   {"text": "√(x - 2), with x ≥ 2", "feedback": "A square root is undone by squaring. Taking another root applies the same operation twice instead of reversing it."},
   {"text": "(x - 2)², with x ≥ 2", "feedback": "Correct."},
   {"text": "(x - 2)², with x ≥ 0", "feedback": "The domain of an inverse is the RANGE of the original, and the original never outputs anything below 2."},
   {"text": "(x + 2)², with x ≥ 2", "feedback": "Moving the 2 across the equals sign before squaring makes it negative."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'inverse-of-a-function', 9, 'Advanced',
 'Find the inverse of f(x) = 2(x - 1)² + 2.', 0,
 '[
   {"text": "1 ± √((x - 2)/2)", "feedback": "Correct."},
   {"text": "-1 ± √((x - 2)/2)", "feedback": "The bracket reads y - 1, so when the 1 crosses the equals sign it becomes positive."},
   {"text": "1 ± √((x + 2)/2)", "feedback": "The + 2 on the end moves across the equals sign as a subtraction."},
   {"text": "1 ± √(2(x - 2))", "feedback": "The 2 in front of the bracket is undone by dividing, not by multiplying."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'inverse-of-a-function', 10, 'Advanced',
 'Which statement about a function and its inverse is true?', 3,
 '[
   {"text": "The domain of the inverse is the domain of the original", "feedback": "Swapping x and y swaps domain and range with each other, so the two do not stay put."},
   {"text": "The inverse of f is the same as 1 divided by f", "feedback": "The -1 in the inverse notation is not an exponent. An inverse undoes the function; a reciprocal divides into 1."},
   {"text": "Every function has an inverse that is also a function", "feedback": "Squaring is the counterexample: two inputs share an output, so reversing it gives two outputs for one input."},
   {"text": "The domain of the inverse is the range of the original", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'transforming-exponential-functions', 1, 'Easy',
 'How does the graph of y = 2ˣ + 4 compare with y = 2ˣ?', 2,
 '[
   {"text": "It is 4 units to the left", "feedback": "A sideways move needs the 4 in the exponent. Out here it acts on the y-values."},
   {"text": "It is 4 units further down", "feedback": "The 4 is being added to every output, which lifts the curve."},
   {"text": "It is 4 units higher", "feedback": "Correct."},
   {"text": "It is 4 units to the right", "feedback": "A sideways move needs the 4 in the exponent, as 2 to the power x - 4. Out here it acts on the y-values."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'transforming-exponential-functions', 2, 'Easy',
 'How does the graph of y = -2ˣ compare with y = 2ˣ?', 2,
 '[
   {"text": "It is reflected in the y-axis", "feedback": "A y-axis reflection needs the minus on the x, as 2 to the power -x. Out here the minus multiplies the output."},
   {"text": "It is shifted downward by 1 unit", "feedback": "A shift needs a number added or subtracted. The minus multiplies every output by -1 instead."},
   {"text": "It is reflected in the x-axis", "feedback": "Correct."},
   {"text": "It decays away instead of growing", "feedback": "The base is still 2, so the size of the output keeps doubling. The minus flips the curve rather than slowing it."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'transforming-exponential-functions', 3, 'Medium',
 'Write the equation for y = 3ˣ shifted right 2 and down 5.', 0,
 '[
   {"text": "y = 3^(x - 2) - 5", "feedback": "Correct."},
   {"text": "y = 3^(x + 2) - 5", "feedback": "A shift RIGHT is written x - 2. The sign in the exponent is the opposite of the direction."},
   {"text": "y = 3^(x - 2) + 5", "feedback": "A shift down subtracts from the output, so the constant on the end is negative."},
   {"text": "y = 3^(x - 5) - 2", "feedback": "The two numbers have swapped jobs. The 2 is the sideways move and the 5 is the vertical one."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'transforming-exponential-functions', 4, 'Medium',
 'What is the horizontal asymptote of y = 2ˣ - 7?', 3,
 '[
   {"text": "y = 0", "feedback": "That is the parent asymptote of 2 to the power x, before the curve was pulled down."},
   {"text": "y = 7", "feedback": "The 7 is being subtracted, so the whole curve drops and its floor drops with it."},
   {"text": "x = -7", "feedback": "A horizontal asymptote is a horizontal line, so its equation names y. This curve has no vertical asymptote."},
   {"text": "y = -7", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'transforming-exponential-functions', 5, 'Challenge',
 'For f(x) = -2(1/2)^(x + 1) - 2, is the function increasing or decreasing,
and where is its horizontal asymptote?', 1,
 '[
   {"text": "Increasing, asymptote y = 2", "feedback": "The 2 on the end is being subtracted, so the asymptote sits below the axis."},
   {"text": "Increasing, asymptote y = -2", "feedback": "Correct."},
   {"text": "Decreasing, asymptote y = -2", "feedback": "The base below 1 does fall, but the minus in front turns the whole curve over, so it climbs."},
   {"text": "Increasing, asymptote y = 0", "feedback": "The - 2 on the end drags the whole curve down, and its asymptote goes with it."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'transforming-exponential-functions', 6, 'Challenge',
 'What is the y-intercept of y = 4(3)^(x - 1) + 2?', 1,
 '[
   {"text": "4/3", "feedback": "The power was handled correctly but the + 2 was never added on."},
   {"text": "10/3", "feedback": "Correct."},
   {"text": "6", "feedback": "The shift was ignored, so 3 to the power 0 was used. At x = 0 the exponent is -1, not 0."},
   {"text": "14", "feedback": "The exponent came out as +1 rather than -1. Substituting x = 0 into x - 1 gives a negative."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'transforming-exponential-functions', 7, 'Advanced',
 'Give the horizontal asymptote and the y-intercept of y = -5(2)^(x - 3) + 6.', 3,
 '[
   {"text": "Asymptote y = 6, y-intercept 1", "feedback": "The shift right was ignored, so 2 to the power 0 was used. At x = 0 the exponent is -3."},
   {"text": "Asymptote y = 6, y-intercept -34", "feedback": "The exponent came out as +3 rather than -3. Substituting x = 0 into x - 3 gives a negative."},
   {"text": "Asymptote y = 0, y-intercept 43/8", "feedback": "The + 6 lifts the whole curve, and its asymptote rises with it."},
   {"text": "Asymptote y = 6, y-intercept 43/8", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'transforming-exponential-functions', 8, 'Advanced',
 'y = 2ˣ is stretched vertically by 3, reflected in the x-axis and shifted up 1.
Give the equation and the range.', 3,
 '[
   {"text": "y = -3(2ˣ) + 1, range y > 1", "feedback": "The reflection puts the whole curve BELOW its asymptote, so 1 is the ceiling rather than the floor."},
   {"text": "y = 3(2ˣ) + 1, range y > 1", "feedback": "The reflection in the x-axis never reached the 3. It is the minus in front that flips the curve over."},
   {"text": "y = -3(2ˣ) + 1, range y ≤ 1", "feedback": "The curve creeps toward 1 forever without ever arriving, so 1 itself is not in the range."},
   {"text": "y = -3(2ˣ) + 1, range y < 1", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'ratios-for-angles-beyond-90-degrees', 1, 'Easy',
 'In which quadrant are all three primary trig ratios positive?', 0,
 '[
   {"text": "The first", "feedback": "Correct."},
   {"text": "The second", "feedback": "In the second quadrant only sine is positive, which is the S in CAST."},
   {"text": "The third", "feedback": "In the third quadrant only tangent is positive, which is the T in CAST."},
   {"text": "The fourth", "feedback": "In the fourth quadrant only cosine is positive, which is the C in CAST."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'ratios-for-angles-beyond-90-degrees', 2, 'Easy',
 'What is the reference angle for 330°?', 3,
 '[
   {"text": "60°", "feedback": "That would be the reference angle for 300 degrees. Subtract 330 from a full turn."},
   {"text": "150°", "feedback": "A reference angle is measured to the nearest part of the x-axis, so it is never more than 90 degrees."},
   {"text": "330°", "feedback": "That is the angle itself. The reference angle is the acute angle it makes with the x-axis."},
   {"text": "30°", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'ratios-for-angles-beyond-90-degrees', 3, 'Medium',
 'What is the exact value of sin 225°?', 0,
 '[
   {"text": "-1/√2", "feedback": "Correct."},
   {"text": "1/√2", "feedback": "The reference angle is right but 225 lands in the third quadrant, where sine is negative."},
   {"text": "-√3/2", "feedback": "The sign is right but the reference angle is not. 225 - 180 gives 45, not 60."},
   {"text": "-1/2", "feedback": "The sign is right but the reference angle is not. 225 - 180 gives 45, not 30."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'ratios-for-angles-beyond-90-degrees', 4, 'Medium',
 'Which pair of angles is coterminal with 97°?', 0,
 '[
   {"text": "457° and 817°", "feedback": "Correct."},
   {"text": "263° and 623°", "feedback": "263 is 360 - 97, which is a reflection rather than a full turn. Coterminal angles differ by whole turns."},
   {"text": "97° and 187°", "feedback": "187 is 97 + 90, which is a quarter turn. A full turn is 360."},
   {"text": "-97° and 277°", "feedback": "-97 flips the angle to the other side of the axis rather than turning it all the way round."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'ratios-for-angles-beyond-90-degrees', 5, 'Challenge',
 'cos A = -8/17 and the terminal arm of A lies in the second quadrant.
Find sin A and tan A.', 1,
 '[
   {"text": "sin A = 15/17 and tan A = 15/8", "feedback": "The sine is right, but a positive sine over a negative cosine has to give a negative tangent."},
   {"text": "sin A = 15/17 and tan A = -15/8", "feedback": "Correct."},
   {"text": "sin A = -15/17 and tan A = 15/8", "feedback": "The quadrant was not used. In the second quadrant sine is positive and tangent is negative."},
   {"text": "sin A = 15/17 and tan A = -8/15", "feedback": "The tangent is upside down. It is the opposite side over the adjacent one."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'ratios-for-angles-beyond-90-degrees', 6, 'Challenge',
 'The point P(-3, 4) lies on the terminal arm of an angle in standard
position. Find sin θ and tan θ.', 3,
 '[
   {"text": "sin θ = -4/5 and tan θ = -4/3", "feedback": "The minus belongs to the x-coordinate, not to the y-coordinate. Sine is built from y over r."},
   {"text": "sin θ = -3/5 and tan θ = -3/4", "feedback": "The two coordinates have swapped roles. Sine uses the y value, tangent is y over x."},
   {"text": "sin θ = 4/5 and tan θ = 4/3", "feedback": "The sine is right, but tangent divides by the x value, and that x value is negative."},
   {"text": "sin θ = 4/5 and tan θ = -4/3", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'ratios-for-angles-beyond-90-degrees', 7, 'Advanced',
 'Solve tan θ = -1 for 0° ≤ θ ≤ 360°.', 2,
 '[
   {"text": "45° and 135°", "feedback": "At 45 the tangent is positive. Only one of these two actually satisfies the equation."},
   {"text": "225° and 315°", "feedback": "At 225 the tangent is positive, because tangent is positive in the third quadrant."},
   {"text": "135° and 315°", "feedback": "Correct."},
   {"text": "45° and 225°", "feedback": "Those are the angles where the tangent is POSITIVE 1. The minus sign moves both solutions a quadrant along."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'reciprocal-trig-ratios', 1, 'Easy',
 'What is csc θ equal to?', 1,
 '[
   {"text": "sin θ/cos θ", "feedback": "That is tan θ, and it is not a reciprocal ratio at all."},
   {"text": "1/sin θ", "feedback": "Correct."},
   {"text": "1/cos θ", "feedback": "That is sec θ. The names do not line up with the letters they start with, which is exactly what makes them easy to swap."},
   {"text": "1/tan θ", "feedback": "That is cot θ."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'reciprocal-trig-ratios', 2, 'Medium',
 'What is the exact value of sec 120°?', 1,
 '[
   {"text": "-√3", "feedback": "That is tan 120. Secant comes from cosine, not from tangent."},
   {"text": "-2", "feedback": "Correct."},
   {"text": "2", "feedback": "The size is right but 120 sits in the second quadrant, where cosine and therefore secant are negative."},
   {"text": "-1/2", "feedback": "That is cos 120 itself. Secant is its RECIPROCAL, so the fraction turns over."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'reciprocal-trig-ratios', 3, 'Medium',
 'What is the exact value of csc 150°?', 2,
 '[
   {"text": "-2", "feedback": "150 is in the second quadrant, where sine is positive, so its reciprocal is positive too."},
   {"text": "√2", "feedback": "√2 is csc 45. The related acute angle for 150 is 30, not 45."},
   {"text": "2", "feedback": "Correct."},
   {"text": "1/2", "feedback": "That is sin 150 itself. Cosecant is its RECIPROCAL, so the fraction turns over."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'reciprocal-trig-ratios', 4, 'Challenge',
 'If cot θ = 1 and θ lies between 180° and 270°, what is θ?', 0,
 '[
   {"text": "225°", "feedback": "Correct."},
   {"text": "45°", "feedback": "45 does satisfy cot θ = 1, but it sits in the first quadrant and the question restricts θ to between 180 and 270."},
   {"text": "135°", "feedback": "At 135 the cotangent is -1. Cotangent is positive in the first and third quadrants."},
   {"text": "315°", "feedback": "At 315 the cotangent is -1, and 315 is outside the range asked for as well."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'reciprocal-trig-ratios', 5, 'Advanced',
 'The point Q(-12, -5) lies on the terminal arm of an angle in standard
position. Find sec θ and cot θ.', 2,
 '[
   {"text": "sec θ = 13/12 and cot θ = 12/5", "feedback": "The cotangent is right, but the x value is negative, so the secant built from it is negative too."},
   {"text": "sec θ = -13/12 and cot θ = -12/5", "feedback": "Both coordinates are negative, and a negative divided by a negative gives a positive cotangent."},
   {"text": "sec θ = -13/12 and cot θ = 12/5", "feedback": "Correct."},
   {"text": "sec θ = -12/13 and cot θ = 5/12", "feedback": "Those are cos θ and tan θ. Both still need turning over to become the reciprocal ratios."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'reciprocal-trig-ratios', 6, 'Advanced',
 'csc θ = -13/5 and the terminal arm of θ lies in the third quadrant.
What is cos θ?', 3,
 '[
   {"text": "12/13", "feedback": "The size is right, but in the third quadrant cosine is negative as well as sine."},
   {"text": "-5/12", "feedback": "That divides the opposite side by the adjacent one and keeps the minus from the sine alone. Cosine is the adjacent side over the hypotenuse."},
   {"text": "-13/12", "feedback": "That is sec θ, the reciprocal. The question asks for cosine itself."},
   {"text": "-12/13", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'sine-law-cosine-law-and-the-ambiguous-case', 1, 'Easy',
 'Which law do you use when you are given two sides and the angle BETWEEN them?', 2,
 '[
   {"text": "The Pythagorean theorem", "feedback": "Pythagoras only works in a right triangle, and nothing here says the contained angle is 90 degrees."},
   {"text": "The ambiguous case test", "feedback": "That test is for two sides and an angle NOT between them, where a second triangle might fit the same numbers."},
   {"text": "The cosine law", "feedback": "Correct."},
   {"text": "The sine law", "feedback": "The sine law needs a side and the angle OPPOSITE it as a matched pair, and a contained angle is not opposite either of the given sides."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'sine-law-cosine-law-and-the-ambiguous-case', 2, 'Easy',
 'Two angles of a triangle are 40° and 75°. What is the third?', 1,
 '[
   {"text": "105°", "feedback": "That is what would be left if only the 75 were taken off 180. Both given angles come off."},
   {"text": "65°", "feedback": "Correct."},
   {"text": "115°", "feedback": "That is the sum of the two given angles, not what is left over from 180."},
   {"text": "45°", "feedback": "That would make the three angles add to 160. They have to add to exactly 180."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'sine-law-cosine-law-and-the-ambiguous-case', 3, 'Medium',
 'In triangle ABC, angle A = 40°, angle B = 75° and side b = 12 cm.
Find side a, to one decimal place.', 2,
 '[
   {"text": "11.3 cm", "feedback": "The third angle, 65 degrees, was used in place of angle A. Side a is opposite A."},
   {"text": "7.7 cm", "feedback": "That treats the triangle as right-angled and works out 12 sin 40. There is no right angle here, so the sine law is needed."},
   {"text": "8.0 cm", "feedback": "Correct."},
   {"text": "18.0 cm", "feedback": "The ratio was set up upside down. Side a pairs with angle A on the same side of the equation."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'sine-law-cosine-law-and-the-ambiguous-case', 4, 'Challenge',
 'In triangle ABC, a = 42 cm, b = 21 cm and c = 28 cm.
Find angle A, to one decimal place.', 1,
 '[
   {"text": "36.3°", "feedback": "That is angle C. Angle A is opposite side a, which is the longest side here."},
   {"text": "117.3°", "feedback": "Correct."},
   {"text": "62.7°", "feedback": "The cosine came out negative, and a negative cosine means an obtuse angle. That value is its supplement."},
   {"text": "26.4°", "feedback": "That is angle B. Angle A is opposite side a, which is the LONGEST side, so A is the largest angle."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'sine-law-cosine-law-and-the-ambiguous-case', 5, 'Challenge',
 'A tree 18.5 m tall casts a shadow 10.2 m long.
What is the angle of elevation of the sun, to one decimal place?', 0,
 '[
   {"text": "61.1°", "feedback": "Correct."},
   {"text": "28.9°", "feedback": "The opposite and adjacent sides are the wrong way round. The tree is opposite the angle of elevation, and it is the taller of the two."},
   {"text": "33.5°", "feedback": "That uses sine with the shadow over the tree, which treats the tree as the hypotenuse. The tree is a vertical leg, not the slanted side."},
   {"text": "1.1°", "feedback": "That is the answer in RADIANS. The calculator was left in the wrong mode; 1.07 radians is the same angle."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'sine-law-cosine-law-and-the-ambiguous-case', 6, 'Advanced',
 'In triangle ABC, a = 12 cm, b = 17 cm and angle A = 21°.
How many triangles are possible, and what can angle B be?', 2,
 '[
   {"text": "Two triangles, with B = 30.5° or B = 210.5°", "feedback": "The second angle comes from 180 MINUS the first, not from adding 180. An angle of 210 degrees cannot sit inside a triangle."},
   {"text": "No triangle exists", "feedback": "No triangle would need a to be shorter than the height b sin A, which is about 6.1 cm. Side a is twice that."},
   {"text": "Two triangles, with B = 30.5° or B = 149.5°", "feedback": "Correct."},
   {"text": "One triangle, with B = 30.5°", "feedback": "The height b sin A is about 6.1 cm, and a sits between that and b. When h is less than a and a is less than b, a second triangle fits the same numbers."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'sine-law-cosine-law-and-the-ambiguous-case', 7, 'Advanced',
 'Dave is in a balloon 400 m up, exactly above the midpoint of two houses.
Rhonda stands 4.6 km from House 1 and 3.4 km from House 2, and the two
houses are 64° apart as she sees them. Find her angle of elevation to Dave.', 3,
 '[
   {"text": "About 5.2°", "feedback": "The distance used was the whole gap between the houses. Rhonda is not standing on that line, so her distance to the midpoint has to be found separately."},
   {"text": "About 10.4°", "feedback": "The distance used was half the gap between the houses, which would only be right if Rhonda were standing at one of them."},
   {"text": "About 71.5°", "feedback": "That is the angle at House 2 inside the ground triangle, found on the way. The elevation is measured from where Rhonda stands."},
   {"text": "About 6.7°", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'trig-identities', 1, 'Easy',
 'Which of these is the Pythagorean identity?', 0,
 '[
   {"text": "sin²θ + cos²θ = 1", "feedback": "Correct."},
   {"text": "sin²θ - cos²θ = 1", "feedback": "The sign is wrong. Try θ = 0: that version gives -1, not 1."},
   {"text": "sin θ + cos θ = 1", "feedback": "The squares matter. Try θ = 45: that version gives about 1.41."},
   {"text": "tan²θ + 1 = sin²θ", "feedback": "The right-hand side is wrong. Dividing the real identity through by cos²θ gives sec²θ there, not sin²θ."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'trig-identities', 2, 'Medium',
 'Simplify: sin θ / cos θ', 1,
 '[
   {"text": "1", "feedback": "Sine and cosine are different numbers for almost every angle, so they do not cancel."},
   {"text": "tan θ", "feedback": "Correct."},
   {"text": "cot θ", "feedback": "That is the same fraction upside down, cos over sin."},
   {"text": "sec θ", "feedback": "sec θ is 1 over cos θ. There is a sine on top here, not a 1."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'trig-identities', 3, 'Challenge',
 'Simplify: sec θ cos θ + sec θ sin θ', 3,
 '[
   {"text": "1 + cot θ", "feedback": "The second term gives sine over cosine, and that fraction is tangent. Cotangent is the other way up."},
   {"text": "sec θ + tan θ", "feedback": "The first term simplifies all the way: secant times cosine leaves 1, because the two are reciprocals."},
   {"text": "cos θ + sin θ", "feedback": "The secant was dropped rather than combined. Write it as 1 over cosine and multiply through."},
   {"text": "1 + tan θ", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'trig-identities', 4, 'Challenge',
 'Simplify: tan²x + cos²x + sin²x', 0,
 '[
   {"text": "1/cos²x", "feedback": "Correct."},
   {"text": "1/sin²x", "feedback": "That is what cot²x + 1 gives. The term here is tan²x, so a different Pythagorean identity applies."},
   {"text": "2", "feedback": "The last two terms do collapse to 1, but tan²x is not 1 as well. It stays as a term."},
   {"text": "cos²x", "feedback": "The tan²x term was cancelled away rather than converted. Write it as sin²x over cos²x and combine."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'trig-identities', 5, 'Advanced',
 'Simplify: (1 - cos²x)/(sin x cos x)', 3,
 '[
   {"text": "cot x", "feedback": "The numerator was read as cos²x. The 1 - in front of it has to be resolved with the Pythagorean identity first."},
   {"text": "sin x cos x", "feedback": "The cosine underneath was multiplied through rather than divided out. 1 - cos²x is sin²x, which shares a factor with the bottom."},
   {"text": "sec x", "feedback": "The numerator is not 1. It becomes sin²x, and one factor of sine cancels with the bottom rather than all of it."},
   {"text": "tan x", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'trig-identities', 6, 'Advanced',
 'Simplify: (sec²θ - 1)/sec²θ', 0,
 '[
   {"text": "sin²θ", "feedback": "Correct."},
   {"text": "cos²θ", "feedback": "The numerator was treated as 1, leaving nothing but the reciprocal of sec²θ. The - 1 is subtracted from sec²θ rather than standing alone on top."},
   {"text": "tan²θ", "feedback": "The numerator was simplified correctly, but the division by sec²θ was never carried out."},
   {"text": "1", "feedback": "The sec²θ terms were cancelled top and bottom, but the - 1 stops sec²θ being a factor of the numerator."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'periodic-behaviour', 1, 'Easy',
 'What is the period of y = sin x, in degrees?', 0,
 '[
   {"text": "360°", "feedback": "Correct."},
   {"text": "180°", "feedback": "At 180 degrees the curve is only half way through: it has come back to the axis but it is heading down, not up."},
   {"text": "90°", "feedback": "90 degrees is a quarter of the way round, where the curve reaches its first maximum."},
   {"text": "1", "feedback": "1 is the amplitude, the height of the curve. The period is measured along the x-axis."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'periodic-behaviour', 2, 'Easy',
 'What is the amplitude of y = sin x?', 2,
 '[
   {"text": "360", "feedback": "360 is the period, measured along the x-axis. Amplitude is measured up the y-axis."},
   {"text": "0", "feedback": "0 is the equation of the axis the curve waves about. The amplitude is how far it strays from it."},
   {"text": "1", "feedback": "Correct."},
   {"text": "2", "feedback": "2 is the full distance from the lowest point to the highest. Amplitude is HALF of that."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'periodic-behaviour', 3, 'Medium',
 'A sine function repeats every 90°. What is k in y = sin(kx)?', 1,
 '[
   {"text": "270", "feedback": "That is 360 take away 90. The two are related by division, not subtraction."},
   {"text": "4", "feedback": "Correct."},
   {"text": "1/4", "feedback": "The relationship is upside down. A SHORTER period needs a LARGER k, because k is 360 divided by the period."},
   {"text": "90", "feedback": "90 is the period itself. k is what you divide 360 by to get it."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'periodic-behaviour', 4, 'Medium',
 'What is the period of y = cos(3x)?', 2,
 '[
   {"text": "3°", "feedback": "3 is the value of k. The period is 360 divided by it."},
   {"text": "360°", "feedback": "360 is the period of the plain cosine curve, before the 3 squeezed it."},
   {"text": "120°", "feedback": "Correct."},
   {"text": "1080°", "feedback": "The 3 was multiplied instead of divided. A larger k squeezes the curve, so the period gets shorter."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'periodic-behaviour', 5, 'Challenge',
 'What is the period of y = (1/4) sin[(1/2)(x + 90°)] - 2?', 3,
 '[
   {"text": "180°", "feedback": "The 1/2 was multiplied by 360 instead of divided into it. A k below 1 stretches the curve out."},
   {"text": "90°", "feedback": "90 is the phase shift, which slides the curve sideways. The period comes from k."},
   {"text": "360°", "feedback": "360 is the period of the plain sine curve, before the 1/2 stretched it."},
   {"text": "720°", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'periodic-behaviour', 6, 'Challenge',
 'For y = (1/4) sin[(1/2)(x + 90°)] - 2, give the amplitude and the maximum value.', 2,
 '[
   {"text": "Amplitude 4, maximum 2", "feedback": "The 1/4 was turned over. A quarter out front squashes the curve rather than stretching it."},
   {"text": "Amplitude 0.25, maximum -2.25", "feedback": "That is the MINIMUM. The amplitude is added to the axis for the peak and subtracted for the trough."},
   {"text": "Amplitude 0.25, maximum -1.75", "feedback": "Correct."},
   {"text": "Amplitude 0.25, maximum 0.25", "feedback": "That reports the amplitude twice. The - 2 on the end moves the whole curve before any peak is read off it."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'periodic-behaviour', 7, 'Advanced',
 'Two sinusoids have the same amplitude, but the second has a k value
twice as large. How do their graphs compare?', 0,
 '[
   {"text": "The second fits twice as many cycles into the same stretch of x", "feedback": "Correct."},
   {"text": "The second is twice as tall", "feedback": "Height comes from a, and the two have the same amplitude. k works along the x-axis."},
   {"text": "The second has twice the period", "feedback": "Period is 360 divided by k, so doubling k HALVES the period."},
   {"text": "They are identical", "feedback": "k genuinely changes the graph. Only a change that cancels itself out would leave the curve alone."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'periodic-behaviour', 8, 'Advanced',
 'A function has a period of 720°.
How many complete cycles does it make between 0° and 2160°?', 2,
 '[
   {"text": "1.5", "feedback": "That divides 2160 by 1440, which is two periods rather than one."},
   {"text": "8.64", "feedback": "That divides 2160 by 250. The period here is 720."},
   {"text": "3", "feedback": "Correct."},
   {"text": "6", "feedback": "That divides by 360 rather than by the period of this particular curve."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'reading-a-trig-equation', 1, 'Easy',
 'What is the amplitude of y = 4 sin x?', 1,
 '[
   {"text": "1/4", "feedback": "The 4 multiplies the outputs, so it makes the curve taller rather than shorter."},
   {"text": "4", "feedback": "Correct."},
   {"text": "1", "feedback": "1 is the amplitude of the plain sine curve. The 4 out front stretches it."},
   {"text": "8", "feedback": "8 is the full distance from the lowest point to the highest. Amplitude is half of that."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'reading-a-trig-equation', 2, 'Easy',
 'What is the equation of the axis of y = sin x + 5?', 3,
 '[
   {"text": "y = 0", "feedback": "That is the axis of the plain sine curve, before the + 5 lifted it."},
   {"text": "y = 1", "feedback": "1 is the amplitude. The axis is the level the curve waves about."},
   {"text": "x = 5", "feedback": "The axis of a sinusoid is a horizontal line, so its equation names y."},
   {"text": "y = 5", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'reading-a-trig-equation', 3, 'Medium',
 'For y = 4 cos[3(x - 20°)] + 5, give the amplitude and the period.', 1,
 '[
   {"text": "Amplitude 3, period 120°", "feedback": "3 is k, and it sits inside the bracket where it changes the period. The amplitude is out front."},
   {"text": "Amplitude 4, period 120°", "feedback": "Correct."},
   {"text": "Amplitude 4, period 1080°", "feedback": "The 3 was multiplied by 360 instead of divided into it. A larger k squeezes the curve."},
   {"text": "Amplitude 5, period 120°", "feedback": "5 is the vertical shift, which moves the curve up. The amplitude is the number in front of the cosine."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'reading-a-trig-equation', 4, 'Medium',
 'For y = 4 cos[3(x - 20°)] + 5, give the maximum and minimum values.', 0,
 '[
   {"text": "Maximum 9, minimum 1", "feedback": "Correct."},
   {"text": "Maximum 4, minimum -4", "feedback": "That is the plain 4 cos curve, before the + 5 lifted the whole thing."},
   {"text": "Maximum 5, minimum -5", "feedback": "5 is the level the curve waves about. The amplitude of 4 is added and subtracted from it."},
   {"text": "Maximum 9, minimum -9", "feedback": "The minimum was taken as the negative of the maximum. That only works for a curve waving about zero, and the + 5 has lifted this one."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'reading-a-trig-equation', 5, 'Challenge',
 'Which list of steps turns y = sin x into y = -3 sin[4(x + 30°)] + 1?', 3,
 '[
   {"text": "Reflect in the x-axis, stretch vertically by 3, STRETCH horizontally by 4, left 30°, up 1", "feedback": "k = 4 squeezes the curve rather than stretching it. The scale factor is 1 over k."},
   {"text": "Reflect in the x-axis, stretch vertically by 3, compress horizontally by 1/4, RIGHT 30°, up 1", "feedback": "The bracket reads x + 30, and a plus inside moves the curve left."},
   {"text": "Stretch vertically by 3, compress horizontally by 1/4, left 30°, up 1", "feedback": "The minus in front of the 3 was read as part of the number. It flips the curve over as well as stretching it."},
   {"text": "Reflect in the x-axis, stretch vertically by 3, compress horizontally by 1/4, left 30°, up 1", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'reading-a-trig-equation', 6, 'Challenge',
 'For y = (1/4) sin[(1/2)(x + 90°)] - 2, give the phase shift and the vertical shift.', 1,
 '[
   {"text": "Left 45°, down 2", "feedback": "The 1/2 was applied to the 90 as well. The 90 is already outside the k, sitting in the (x - d) bracket, so it is the shift as it stands."},
   {"text": "Left 90°, down 2", "feedback": "Correct."},
   {"text": "Right 90°, down 2", "feedback": "The bracket reads x + 90, and a plus inside moves the curve left."},
   {"text": "Left 90°, up 2", "feedback": "The 2 is being subtracted, so the whole curve drops."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'reading-a-trig-equation', 7, 'Advanced',
 'For y = -3 sin[4(x + 30°)] + 1, give the maximum, the minimum and the axis.', 1,
 '[
   {"text": "Maximum -2, minimum 4, axis y = 1", "feedback": "The reflection was taken to swap which value is the maximum. Turning the curve over changes where the peak happens, not which number is larger."},
   {"text": "Maximum 4, minimum -2, axis y = 1", "feedback": "Correct."},
   {"text": "Maximum 3, minimum -3, axis y = 0", "feedback": "The + 1 was never applied. It lifts the axis and both turning points with it."},
   {"text": "Maximum 4, minimum -2, axis y = -1", "feedback": "The minus in front of the 3 flips the curve over, but it does not move the axis. The axis comes from the constant on the end."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'reading-a-trig-equation', 8, 'Advanced',
 'What is the phase shift of y = 4 cos[3(x - 20°)] + 5?', 2,
 '[
   {"text": "Right 60°", "feedback": "The 20 was multiplied by k. It is already outside the k, sitting in the (x - d) bracket, so it is the shift as it stands."},
   {"text": "Right 20/3°", "feedback": "The 20 was divided by k. That would be needed if the bracket read 3x - 20, but here the 3 has already been factored out."},
   {"text": "Right 20°", "feedback": "Correct."},
   {"text": "Left 20°", "feedback": "The bracket reads x - 20, and a minus inside moves the curve right."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'building-a-trig-equation', 1, 'Easy',
 'A sine curve has a maximum of 7 and a minimum of 1. What is its amplitude?', 0,
 '[
   {"text": "3", "feedback": "Correct."},
   {"text": "6", "feedback": "6 is the full distance from the minimum to the maximum. Amplitude is half of that."},
   {"text": "4", "feedback": "4 is the equation of the axis, the level half way between the two."},
   {"text": "8", "feedback": "That adds the maximum and the minimum. Amplitude comes from their difference."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'building-a-trig-equation', 2, 'Easy',
 'A sine curve has a maximum of 7 and a minimum of 1. What is the equation of its axis?', 3,
 '[
   {"text": "y = 3", "feedback": "3 is the amplitude, which comes from the DIFFERENCE. The axis comes from the average."},
   {"text": "y = 6", "feedback": "6 is the difference between the two. The axis sits half way between them."},
   {"text": "y = 8", "feedback": "That adds the two without halving. The axis is the average of the maximum and the minimum."},
   {"text": "y = 4", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'building-a-trig-equation', 3, 'Medium',
 'A sinusoid has a maximum at (0, 2/3), a vertical shift of 1/3 up
and a period of 120°. What is its amplitude?', 0,
 '[
   {"text": "1/3", "feedback": "Correct."},
   {"text": "2/3", "feedback": "2/3 is the height of the maximum above zero. Amplitude is measured from the AXIS, which is already 1/3 up."},
   {"text": "1", "feedback": "That adds the maximum to the shift. Amplitude is the maximum take away the axis."},
   {"text": "1/2", "feedback": "That averages the maximum with the vertical shift. Averaging belongs to a maximum and a minimum, and the axis here is given already."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'building-a-trig-equation', 4, 'Medium',
 'A sinusoid has a period of 120°. What is its k value?', 2,
 '[
   {"text": "120", "feedback": "120 is the period itself. k is what 360 has to be divided by to get it."},
   {"text": "240", "feedback": "That is 360 take away 120. The two are related by division, not subtraction."},
   {"text": "3", "feedback": "Correct."},
   {"text": "1/3", "feedback": "The relationship is upside down. k is 360 divided by the period, not the period divided by 360."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'building-a-trig-equation', 5, 'Challenge',
 'A curve has a maximum of 0.75, a minimum of -0.75 and a period of 90°,
and it starts at zero and rises. Which SINE equation fits?', 1,
 '[
   {"text": "y = 0.75 sin(x/4)", "feedback": "That k stretches the curve to a period of 1440. A period shorter than 360 needs a k bigger than 1."},
   {"text": "y = 0.75 sin(4x)", "feedback": "Correct."},
   {"text": "y = 0.75 sin(90x)", "feedback": "90 is the period. k is 360 divided by the period, not the period itself."},
   {"text": "y = 1.5 sin(4x)", "feedback": "1.5 is the full distance from the minimum to the maximum. The amplitude is half of that."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'building-a-trig-equation', 6, 'Challenge',
 'The same curve — maximum 0.75, minimum -0.75, period 90°, starting at zero
and rising. Which COSINE equation fits?', 1,
 '[
   {"text": "y = 0.75 cos(4x)", "feedback": "That curve starts at its maximum, and this one starts at zero. A quarter period of shift is needed."},
   {"text": "y = 0.75 cos[4(x - 22.5°)]", "feedback": "Correct."},
   {"text": "y = 0.75 cos[4(x + 22.5°)]", "feedback": "Cosine peaks at the start of its own cycle, so it has to be pushed RIGHT to line up with a sine curve, not left."},
   {"text": "y = 0.75 cos(4x - 22.5°)", "feedback": "The 22.5 has to sit inside the bracket WITH the k. Written like this the shift is only 22.5 divided by 4."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'building-a-trig-equation', 7, 'Advanced',
 'A sinusoid has a maximum at (0, 2/3), a vertical shift of 1/3 up and a
period of 120°. Which SINE equation fits?', 0,
 '[
   {"text": "y = (1/3) sin[3(x + 30°)] + 1/3", "feedback": "Correct."},
   {"text": "y = (1/3) sin[3(x - 30°)] + 1/3", "feedback": "The shift has gone the wrong way round: this curve is at its minimum at x = 0 and does not peak until x = 60."},
   {"text": "y = (1/3) sin(3x) + 1/3", "feedback": "That curve is on its axis and rising at x = 0, not at its maximum. A quarter period of shift is needed."},
   {"text": "y = (2/3) sin[3(x + 30°)] + 1/3", "feedback": "2/3 is the height of the maximum above zero. The amplitude is measured from the axis, which is already 1/3 up."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'building-a-trig-equation', 8, 'Advanced',
 'The same sinusoid — maximum at (0, 2/3), vertical shift 1/3 up, period 120°.
Which COSINE equation fits?', 2,
 '[
   {"text": "y = (2/3) cos(3x) + 1/3", "feedback": "2/3 is the height of the maximum above zero. The amplitude is measured from the axis, which is already 1/3 up."},
   {"text": "y = (1/3) cos(3x) + 2/3", "feedback": "2/3 is the maximum, not the axis. The axis is the vertical shift, which is given as 1/3."},
   {"text": "y = (1/3) cos(3x) + 1/3", "feedback": "Correct."},
   {"text": "y = (1/3) cos[3(x - 30°)] + 1/3", "feedback": "Cosine already starts at its maximum, so with the maximum at x = 0 no sideways shift is needed at all."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'recursion-and-pascal-triangle', 1, 'Easy',
 'A sequence has t₁ = -6 and tₙ = tₙ₋₁ + 5. What is t₃?', 3,
 '[
   {"text": "-1", "feedback": "-1 is the SECOND term. The rule has to be applied once more."},
   {"text": "9", "feedback": "9 is the fourth term. The rule has been applied one time too many."},
   {"text": "-16", "feedback": "That subtracts 5 each time. The rule says plus 5."},
   {"text": "4", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'recursion-and-pascal-triangle', 2, 'Easy',
 'In Pascal triangle the single 1 at the top is row 0.
How many entries are in row 4?', 1,
 '[
   {"text": "16", "feedback": "16 is the SUM of row 4. The question asks how many numbers are in it."},
   {"text": "5", "feedback": "Correct."},
   {"text": "4", "feedback": "That is the row number itself. Because the counting starts at row 0, every row has one more entry than its number."},
   {"text": "6", "feedback": "6 entries belong to row 5. Row 4 is one shorter."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'recursion-and-pascal-triangle', 3, 'Medium',
 'A sequence has t₁ = -2, t₂ = -1 and tₙ = tₙ₋₁ × tₙ₋₂.
What are the first four terms?', 2,
 '[
   {"text": "-2, -1, -2, 2", "feedback": "The third term multiplies two negatives together, and that gives a positive."},
   {"text": "-2, -1, -3, -4", "feedback": "The rule multiplies the two previous terms. This one adds them."},
   {"text": "-2, -1, 2, -2", "feedback": "Correct."},
   {"text": "-2, -1, 2, 2", "feedback": "The fourth term multiplies the third by the SECOND, and the second is -1, so the sign flips."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'recursion-and-pascal-triangle', 4, 'Medium',
 'Which row of Pascal triangle gives the coefficients of the expansion
of (1 - x)¹¹?', 2,
 '[
   {"text": "Row 10", "feedback": "Row 10 supplies the coefficients for a power of 10. The row number and the power are the same."},
   {"text": "Row 1", "feedback": "Row 1 is just 1 and 1, which handles a bracket raised to the power 1."},
   {"text": "Row 11", "feedback": "Correct."},
   {"text": "Row 12", "feedback": "12 is how many TERMS the expansion has. The row number matches the power itself."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'recursion-and-pascal-triangle', 5, 'Challenge',
 'Which recursive formula generates the sequence 1, 1, 2, 3, 5, 8, ...?', 1,
 '[
   {"text": "tₙ = tₙ₋₁ × tₙ₋₂", "feedback": "Multiplying the first two 1s gives 1, not 2. The rule adds them."},
   {"text": "tₙ = tₙ₋₁ + tₙ₋₂", "feedback": "Correct."},
   {"text": "tₙ = tₙ₋₁ + 1", "feedback": "That gives 1, 2, 3, 4, 5. The steps here are not all the same size."},
   {"text": "tₙ = 2tₙ₋₁", "feedback": "That gives 1, 2, 4, 8. This sequence grows more slowly than doubling."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'recursion-and-pascal-triangle', 6, 'Challenge',
 'How many terms are there in the expansion of (1 - x)¹¹?', 0,
 '[
   {"text": "12", "feedback": "Correct."},
   {"text": "11", "feedback": "11 is the power. The exponent on the first part of the bracket runs from 11 all the way down to 0, which is one more value than 11."},
   {"text": "13", "feedback": "One too many. The exponents run 11, 10, and so on down to 0."},
   {"text": "22", "feedback": "That doubles the power. Each term comes from one exponent, not two."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'recursion-and-pascal-triangle', 7, 'Advanced',
 'A sequence has t₁ = 3 and tₙ = 2tₙ₋₁ - 1. What is t₄?', 2,
 '[
   {"text": "33", "feedback": "That is the fifth term. The rule has been applied one time too many."},
   {"text": "23", "feedback": "That doubles three times over and takes the 1 off only at the end. The minus 1 comes off at every step."},
   {"text": "17", "feedback": "Correct."},
   {"text": "9", "feedback": "9 is the THIRD term. The rule has to be applied once more."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'recursion-and-pascal-triangle', 8, 'Advanced',
 'Using the binomial theorem, what is the THIRD term of the expansion of (x² - 2y)⁴?', 3,
 '[
   {"text": "-24x⁴y²", "feedback": "The -2y is squared in this term, and squaring a negative gives a positive."},
   {"text": "6x⁴y²", "feedback": "The Pascal coefficient of 6 is right, but the -2 inside the bracket also gets squared and contributes a factor of 4."},
   {"text": "24x²y²", "feedback": "The x² is squared as well, so its exponent doubles rather than staying at 2."},
   {"text": "24x⁴y²", "feedback": "Correct."}
 ]'::jsonb,
 null);