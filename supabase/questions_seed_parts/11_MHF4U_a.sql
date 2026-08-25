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


delete from public.questions where course_code = 'MHF4U';

insert into public.questions
  (course_code, unit_code, subtopic_code, sort_order, difficulty,
   prompt, correct_index, options, misconception_tag)
values
('MHF4U', 'logarithmic-functions', 'logs-as-the-inverse-of-exponentials', 1, 'Easy',
 'Evaluate   log₂ 32.', 1,
 '[
   {"text": "6", "feedback": "That exponent would give 64. Count the factors of 2 needed: 2 × 2 × 2 × 2 × 2."},
   {"text": "5", "feedback": "Correct. 2⁵ = 32, and a logarithm asks for the exponent."},
   {"text": "16", "feedback": "This halves 32 rather than asking which power of 2 produces 32."},
   {"text": "4", "feedback": "2⁴ is only 16, so one more factor of 2 is needed."}
 ]'::jsonb,
 'log-as-exponent'),
('MHF4U', 'logarithmic-functions', 'logs-as-the-inverse-of-exponentials', 2, 'Easy',
 'Rewrite   log₃ 81 = 4   in exponential form.', 0,
 '[
   {"text": "3⁴ = 81", "feedback": "Correct. The base stays the base, the value of the logarithm becomes the exponent, and the argument is the result."},
   {"text": "4³ = 81", "feedback": "The base and the exponent have swapped places. The small number written after log is always the base."},
   {"text": "81³ = 4", "feedback": "The argument has been used as the base. The subscript is the base."},
   {"text": "3⁸¹ = 4", "feedback": "The exponent and the argument have swapped, which would give an enormous number rather than 4."}
 ]'::jsonb,
 'log-exponential-form-swap'),
('MHF4U', 'logarithmic-functions', 'logs-as-the-inverse-of-exponentials', 3, 'Easy',
 'Write 4³ = 64 in logarithmic form.', 3,
 '[
   {"text": "log₃64 = 4", "feedback": "The base of the power becomes the base of the log. Here the base is 4, not the exponent."},
   {"text": "log₆₄4 = 3", "feedback": "The base and the result have swapped. 64 is what the power EQUALS, so it goes inside the log."},
   {"text": "log₄3 = 64", "feedback": "The exponent and the result have swapped. A logarithm gives you the exponent as its answer."},
   {"text": "log₄64 = 3", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'logs-as-the-inverse-of-exponentials', 4, 'Easy',
 'Write 7 = log₂128 in exponential form.', 2,
 '[
   {"text": "128⁷ = 2", "feedback": "The base and the result have swapped places entirely."},
   {"text": "2¹²⁸ = 7", "feedback": "The exponent and the result have swapped. A logarithm IS the exponent, so the 7 belongs upstairs."},
   {"text": "2⁷ = 128", "feedback": "Correct."},
   {"text": "7² = 128", "feedback": "The base and the exponent have swapped. The little number on the log is the base of the power."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'logs-as-the-inverse-of-exponentials', 5, 'Easy',
 'What is the domain of y = log₂x?', 0,
 '[
   {"text": "x > 0", "feedback": "Correct."},
   {"text": "x ≥ 0", "feedback": "Zero itself is not allowed: no power of 2 ever equals 0, it only creeps toward it."},
   {"text": "All real numbers", "feedback": "That is the RANGE. The inputs are restricted, because a positive base never produces a negative output."},
   {"text": "x ≠ 0", "feedback": "That would allow negative inputs, and no power of 2 is negative either."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'logs-as-the-inverse-of-exponentials', 6, 'Medium',
 'What is the horizontal asymptote of   y = 2ˣ − 3 ?', 1,
 '[
   {"text": "y = 0", "feedback": "That is the asymptote before the vertical shift. Subtracting 3 moves the whole graph."},
   {"text": "y = −3", "feedback": "Correct. As x becomes very negative, 2ˣ approaches 0, so y approaches −3."},
   {"text": "y = 3", "feedback": "The shift is a subtraction, so the graph moves down rather than up."},
   {"text": "x = −3", "feedback": "This names a vertical line. An exponential graph of this form flattens out horizontally instead."}
 ]'::jsonb,
 'exponential-vertical-shift'),
('MHF4U', 'logarithmic-functions', 'logs-as-the-inverse-of-exponentials', 7, 'Medium',
 'What is the domain of   y = log(x − 5) ?', 2,
 '[
   {"text": "x ≥ 5", "feedback": "At x = 5 the argument becomes zero, and the logarithm of zero is undefined, so that endpoint cannot be included."},
   {"text": "x ≠ 5", "feedback": "Negative arguments are also not allowed, so a whole region has to be excluded, not just one point."},
   {"text": "x > 5", "feedback": "Correct. The argument of a logarithm must be strictly positive, so x − 5 > 0."},
   {"text": "All real numbers", "feedback": "Try x = 0: the argument becomes −5, and logarithms of negative numbers are undefined."}
 ]'::jsonb,
 'log-domain-positive-argument'),
('MHF4U', 'logarithmic-functions', 'logs-as-the-inverse-of-exponentials', 8, 'Medium',
 'What is the inverse of f(x) = (1/4)ˣ?', 1,
 '[
   {"text": "y = x^(1/4)", "feedback": "That undoes a fourth POWER. Here the variable is the exponent, not the base."},
   {"text": "y = log base 1/4 of x", "feedback": "Correct."},
   {"text": "y = log base 4 of x", "feedback": "That undoes 4ˣ, which is not the function given. Read the base inside the bracket again."},
   {"text": "y = 4ˣ", "feedback": "That is the reciprocal of the original function, not its inverse. An inverse swaps the inputs and the outputs."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'logs-as-the-inverse-of-exponentials', 9, 'Medium',
 'What intercepts does the graph of y = log₂x have?', 3,
 '[
   {"text": "A y-intercept at (0, 1) and no x-intercept", "feedback": "That describes the EXPONENTIAL. The log is its mirror image, so the intercept swaps axes too."},
   {"text": "An x-intercept at (0, 0)", "feedback": "x = 0 is not even in the domain, so the curve never reaches the origin. That point has been borrowed from graphs that do pass through it."},
   {"text": "Intercepts at both (1, 1) and (0, 1)", "feedback": "log₂1 is 0, not 1, and x = 0 is outside the domain."},
   {"text": "An x-intercept at (1, 0) and no y-intercept", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'logs-as-the-inverse-of-exponentials', 10, 'Challenge',
 'Give the domain and range of y = log₂x and of y = 2ˣ.', 2,
 '[
   {"text": "Both have domain x > 0 and range all reals", "feedback": "The exponential accepts any input at all, including negatives, which just give small positive outputs."},
   {"text": "Both have domain and range equal to all real numbers", "feedback": "Neither does. Each has exactly one side restricted, and being inverses is what swaps which side."},
   {"text": "Log: domain x > 0, range all reals. Exponential: domain all reals, range y > 0", "feedback": "Correct."},
   {"text": "Log: domain all reals, range y > 0. Exponential: domain x > 0, range all reals", "feedback": "The two functions have been swapped. The one with the restricted INPUT is the logarithm."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'logs-as-the-inverse-of-exponentials', 11, 'Challenge',
 'Which feature does y = 2ˣ have that y = log₂x does not?', 1,
 '[
   {"text": "A maximum value", "feedback": "Neither has one. Both climb without bound, just at very different speeds."},
   {"text": "A horizontal asymptote at y = 0", "feedback": "Correct."},
   {"text": "A vertical asymptote", "feedback": "That is the LOG curve, which hugs the y-axis. The exponential has no vertical asymptote at all."},
   {"text": "An x-intercept", "feedback": "The log crosses the x-axis at (1, 0). The exponential never touches it."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'logs-as-the-inverse-of-exponentials', 12, 'Advanced',
 'The graph of y = 3ˣ and the graph of its inverse are reflections in which
line, and what is that inverse?', 0,
 '[
   {"text": "In y = x, and the inverse is y = log₃x", "feedback": "Correct."},
   {"text": "In the x-axis, and the inverse is y = log₃x", "feedback": "The inverse is right. Reflecting in the x-axis only flips the outputs; an inverse swaps inputs with outputs, which is a reflection in y = x."},
   {"text": "In y = x, and the inverse is y = 3^(1/x)", "feedback": "The line is right. A reciprocal in the exponent is not what undoes an exponential."},
   {"text": "In y = x, and the inverse is y = x³", "feedback": "The line is right. Cubing undoes a cube ROOT; here the variable is the exponent, not the base."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'logs-as-the-inverse-of-exponentials', 13, 'Advanced',
 'Why does the logarithm of a negative number not exist for a positive base?', 2,
 '[
   {"text": "Because the base is not allowed to be negative", "feedback": "That is a separate rule about the base. The question is about what goes inside."},
   {"text": "It does exist, and it comes out negative", "feedback": "A negative OUTPUT is fine, and it happens for inputs between 0 and 1. A negative INPUT is the impossible case."},
   {"text": "Because a positive base raised to any real power stays positive", "feedback": "Correct."},
   {"text": "Because logarithms are only defined for whole numbers", "feedback": "log 2.5 exists perfectly well. It is the SIGN that is the obstacle, not whether the number is whole."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'solving-exponential-equations', 1, 'Easy',
 'Solve   2ˣ = 64.', 3,
 '[
   {"text": "x = 32", "feedback": "This divides 64 by 2 once. The question asks for the exponent, not for half the number."},
   {"text": "x = 8", "feedback": "That is the square root of 64, which would answer x² = 64 instead."},
   {"text": "x = 5", "feedback": "2⁵ gives 32, which is only half of 64."},
   {"text": "x = 6", "feedback": "Correct. 2⁶ = 64, so the exponent is 6."}
 ]'::jsonb,
 'solve-exponent-by-inspection'),
('MHF4U', 'logarithmic-functions', 'solving-exponential-equations', 2, 'Easy',
 'Solve 2ˣ = 32.', 2,
 '[
   {"text": "x = 4", "feedback": "2 to the power 4 is 16, which is only half of 32. One more doubling is needed."},
   {"text": "x = 6", "feedback": "2 to the power 6 is 64, which overshoots."},
   {"text": "x = 5", "feedback": "Correct."},
   {"text": "x = 16", "feedback": "That divides 32 by 2. The exponent counts how many 2s are multiplied together."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'solving-exponential-equations', 3, 'Easy',
 'Write 64 as a power of 4.', 3,
 '[
   {"text": "4⁴", "feedback": "4 to the power 4 is 256. One factor of 4 too many."},
   {"text": "4⁶", "feedback": "64 is 2 to the power 6, not 4 to the power 6. The base matters."},
   {"text": "4^(1/3)", "feedback": "A fractional exponent SHRINKS the number. 64 is bigger than 4, so the exponent has to be above 1."},
   {"text": "4³", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'solving-exponential-equations', 4, 'Medium',
 'Solve 3^(5x) = 27^(x - 1).', 1,
 '[
   {"text": "x = -1/2", "feedback": "27 is 3 cubed, so the right side becomes 3 to the power 3x - 3, not 3x - 1."},
   {"text": "x = -3/2", "feedback": "Correct."},
   {"text": "x = 3/2", "feedback": "Collecting 5x - 3x = -3 gives 2x = -3, so x lands below zero."},
   {"text": "x = -3", "feedback": "The 2 in 2x = -3 was dropped. Both sides still have to be divided by it."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'solving-exponential-equations', 5, 'Medium',
 'Solve 8^(2x + 1) = 32^(x - 1).', 0,
 '[
   {"text": "x = -8", "feedback": "Correct."},
   {"text": "x = 8", "feedback": "Collecting 6x - 5x = -5 - 3 leaves x equal to a negative."},
   {"text": "x = -2", "feedback": "The 1 in the bracket lost its sign when it was tripled. Cubing 8 gives a left exponent of 6x + 3, not 6x - 3."},
   {"text": "x = -8/11", "feedback": "The two exponents were added rather than one being subtracted from the other."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'solving-exponential-equations', 6, 'Hard',
 'Solve   3^(2x) = 81.', 3,
 '[
   {"text": "x = 4", "feedback": "This solves for the whole exponent 2x rather than for x. There is one more step."},
   {"text": "x = 27", "feedback": "This divides 81 by 3, which does not undo an exponent."},
   {"text": "x = 1/2", "feedback": "The 2 has been used in the wrong direction. Set the exponents equal and solve 2x = 4."},
   {"text": "x = 2", "feedback": "Correct. Writing 81 as 3⁴ makes the exponents equal, so 2x = 4."}
 ]'::jsonb,
 'equate-exponents-same-base'),
('MHF4U', 'logarithmic-functions', 'solving-exponential-equations', 7, 'Challenge',
 'Solve 3^(x - 2) = 5ˣ, correct to 3 decimal places.', 0,
 '[
   {"text": "x = -4.301", "feedback": "Correct."},
   {"text": "x = 4.301", "feedback": "Collecting the x terms gives x(log 3 - log 5), and log 3 is smaller than log 5, so that bracket is negative."},
   {"text": "x = -2.151", "feedback": "The 2 log 3 on the right was left as log 3. Expanding (x - 2)log 3 gives x log 3 minus TWO log 3."},
   {"text": "x = 0.301", "feedback": "That is log 2 by itself. Take the log of both whole sides and expand the bracket first."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'solving-exponential-equations', 8, 'Challenge',
 'Solve 10 = 2 × 4^(x + 2), correct to 2 decimal places.', 1,
 '[
   {"text": "x = -2.84", "feedback": "The shift of 2 was taken off twice over. Track the 2 in the exponent through the rearrangement."},
   {"text": "x = -0.84", "feedback": "Correct."},
   {"text": "x = 0.84", "feedback": "log 5 divided by log 4 is about 1.16, and the 2 still has to come off, which pushes the answer below zero."},
   {"text": "x = -1.34", "feedback": "The 2 out front was divided into the 10 twice over. One division by 2 is all the equation allows."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'solving-exponential-equations', 9, 'Advanced',
 'Solve 2^(k - 2) = 3^(k + 1), correct to 3 decimal places.', 0,
 '[
   {"text": "k = -6.129", "feedback": "Correct."},
   {"text": "k = 6.129", "feedback": "Collecting the k terms gives k(log 2 - log 3), and log 2 is smaller than log 3, so that bracket is negative."},
   {"text": "k = -2.710", "feedback": "The constant side came to log 3 rather than log 12. Both the 2 log 2 and the log 3 have to move across."},
   {"text": "k = 0.090", "feedback": "That divides log 12 by 12 rather than by log(2/3)."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'solving-exponential-equations', 10, 'Advanced',
 'Solve 3ˣ = 4^(1 - x), correct to 2 decimal places.', 3,
 '[
   {"text": "x = 1.26", "feedback": "The x log 4 term has to be brought over to the left, which ADDS it to x log 3 rather than leaving it behind."},
   {"text": "x = 0.44", "feedback": "That works out log 3 over log 12. The constant left on the right is log 4, because the 1 sits on the exponent of the 4."},
   {"text": "x = -0.56", "feedback": "The size is right but the sign is not. Both logs are positive, so the quotient is positive."},
   {"text": "x = 0.56", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'laws-of-logarithms-and-change-of-base', 1, 'Easy',
 'Evaluate log₂16.', 0,
 '[
   {"text": "4", "feedback": "Correct."},
   {"text": "8", "feedback": "8 is half of 16. The question asks what POWER of 2 gives 16."},
   {"text": "2", "feedback": "2 is the base. What a logarithm returns is the exponent the base has to be raised to."},
   {"text": "16", "feedback": "16 is what the power equals. The log returns the exponent instead."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'laws-of-logarithms-and-change-of-base', 2, 'Easy',
 'What does log(ab) equal?', 3,
 '[
   {"text": "log a × log b", "feedback": "Logs turn multiplication INTO addition, which is the whole point of them. They do not pass the multiplication through."},
   {"text": "log a - log b", "feedback": "Subtraction matches a QUOTIENT inside the log, not a product."},
   {"text": "log a ÷ log b", "feedback": "That expression is the change-of-base formula, which is a different thing entirely."},
   {"text": "log a + log b", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'laws-of-logarithms-and-change-of-base', 3, 'Medium',
 'Simplify   log₂ 8 + log₂ 4.', 2,
 '[
   {"text": "6", "feedback": "This looks like the arguments were divided, or the two results multiplied. Evaluate each logarithm separately and add."},
   {"text": "12", "feedback": "This multiplies the two arguments and stops. A logarithm still has to be taken of that product."},
   {"text": "5", "feedback": "Correct. log₂ 8 = 3 and log₂ 4 = 2, and the product rule agrees because log₂ 32 = 5."},
   {"text": "32", "feedback": "That is the product of the two arguments. One more step turns it into an exponent."}
 ]'::jsonb,
 'log-product-rule'),
('MHF4U', 'logarithmic-functions', 'laws-of-logarithms-and-change-of-base', 4, 'Medium',
 'Evaluate log₄(1/16).', 0,
 '[
   {"text": "-2", "feedback": "Correct."},
   {"text": "2", "feedback": "4 squared is 16, not one sixteenth. A fraction below 1 needs a NEGATIVE exponent."},
   {"text": "-4", "feedback": "That is log₂(1/16). The base here is 4, so 1/16 has to be written as a power of 4."},
   {"text": "1/2", "feedback": "A fractional exponent gives a root, which would land between 1 and 4. This value is far smaller."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'laws-of-logarithms-and-change-of-base', 5, 'Medium',
 'Evaluate log₂(32³) using the power law.', 1,
 '[
   {"text": "96", "feedback": "That multiplies 32 by 3 and takes the log of nothing. The power law brings the exponent OUT, it does not fold it in."},
   {"text": "15", "feedback": "Correct."},
   {"text": "5", "feedback": "That is log₂32 on its own. The exponent 3 comes out front and multiplies it."},
   {"text": "3", "feedback": "3 is the exponent that comes out front. It still has to be multiplied by log₂32."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'laws-of-logarithms-and-change-of-base', 6, 'Hard',
 'Solve   log₂ x + log₂ (x − 2) = 3.', 1,
 '[
   {"text": "x = 4 and x = −2", "feedback": "Both values solve the quadratic, but one of them makes a logarithm argument negative and has to be rejected."},
   {"text": "x = 4", "feedback": "Correct. The product rule gives x(x − 2) = 8, and only the positive root keeps both arguments valid."},
   {"text": "x = −2", "feedback": "This root makes the arguments negative, which is outside the domain of a logarithm."},
   {"text": "x = 5", "feedback": "Check the conversion to exponential form: the product x(x − 2) has to equal 2 raised to the power 3."}
 ]'::jsonb,
 'log-reject-extraneous'),
('MHF4U', 'logarithmic-functions', 'laws-of-logarithms-and-change-of-base', 7, 'Challenge',
 'Write log₇8 + log₇4 - log₇16 as a single logarithm.', 2,
 '[
   {"text": "log₇(-4)", "feedback": "The three numbers were added and subtracted as they stood. The laws turn those operations into multiplying and dividing INSIDE the log."},
   {"text": "2", "feedback": "That reports what is left INSIDE the logarithm once the laws have been applied. The logarithm of it still has to be taken, and 7 squared is 49."},
   {"text": "log₇2", "feedback": "Correct."},
   {"text": "log₇512", "feedback": "The last term is SUBTRACTED, so its 16 divides rather than multiplies."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'laws-of-logarithms-and-change-of-base', 8, 'Challenge',
 'Evaluate log₆8 + log₆27.', 0,
 '[
   {"text": "3", "feedback": "Correct."},
   {"text": "216", "feedback": "216 is what goes INSIDE the combined logarithm. The log of it still has to be taken."},
   {"text": "log₆35", "feedback": "The two numbers were added rather than multiplied. A sum of logs becomes a PRODUCT inside."},
   {"text": "6", "feedback": "6 is the base. What a logarithm returns is the power the base has to be raised to in order to reach 216."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'laws-of-logarithms-and-change-of-base', 9, 'Advanced',
 'Write 2 log a + log(3b) - (1/2) log c as a single logarithm.', 2,
 '[
   {"text": "log(3a²b√c)", "feedback": "The last term is subtracted, so the root of c belongs on the BOTTOM."},
   {"text": "log(2a + 3b - c/2)", "feedback": "The three logs were combined as though they were plain numbers. The laws turn addition into multiplication INSIDE the log."},
   {"text": "log(3a²b/√c)", "feedback": "Correct."},
   {"text": "log(6ab/√c)", "feedback": "The 2 in front of log a becomes an EXPONENT on the a, not a multiplier of it."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'laws-of-logarithms-and-change-of-base', 10, 'Advanced',
 'Use the change of base formula to evaluate log₉12, to 1 decimal place.', 1,
 '[
   {"text": "3.0", "feedback": "That reads the square root of 9. Change of base divides the log of the argument by the log of the base."},
   {"text": "1.1", "feedback": "Correct."},
   {"text": "0.9", "feedback": "The fraction is upside down. It is log 12 divided by log 9, and 12 is the larger of the two."},
   {"text": "1.3", "feedback": "That divides 12 by 9 without taking any logarithms."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'laws-of-logarithms-and-change-of-base', 11, 'Advanced',
 'Simplify log(x² + 2x - 15) - log(x² - 7x + 12).', 1,
 '[
   {"text": "log(x² + 2x - 15) ÷ log(x² - 7x + 12)", "feedback": "Subtracting two logs is not the same as dividing them. The quotient law puts the division INSIDE a single log."},
   {"text": "log((x + 5)/(x - 4))", "feedback": "Correct."},
   {"text": "log((x - 3)/(x - 4))", "feedback": "The bracket x - 3 is the one the two share, so it cancels. What survives on top is the other factor."},
   {"text": "log((x + 5)(x - 4))", "feedback": "A DIFFERENCE of logs becomes a quotient inside, not a product."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'solving-logarithmic-equations', 1, 'Easy',
 'Solve log₃x = 4.', 3,
 '[
   {"text": "x = 12", "feedback": "That multiplies the base by the exponent. Rewriting in exponential form RAISES the base to the power instead."},
   {"text": "x = 64", "feedback": "That works out 4 cubed. The base is 3 and the exponent is 4, not the other way round."},
   {"text": "x = 1/81", "feedback": "A negative exponent would give a fraction. This one is positive."},
   {"text": "x = 81", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'solving-logarithmic-equations', 2, 'Medium',
 'Solve   log(x − 1) = 2,   where log means base 10.', 0,
 '[
   {"text": "x = 101", "feedback": "Correct. Base 10 gives x − 1 = 10² = 100, so x = 101."},
   {"text": "x = 21", "feedback": "This uses 10 multiplied by 2 instead of 10 raised to the power of 2."},
   {"text": "x = 3", "feedback": "This treats the 2 as the value of x − 1 directly, without undoing the logarithm."},
   {"text": "x = 100", "feedback": "The right side was undone correctly, but the −1 inside the bracket still has to be moved across."}
 ]'::jsonb,
 'log-undo-with-base'),
('MHF4U', 'logarithmic-functions', 'solving-logarithmic-equations', 3, 'Medium',
 'Solve log₂x = -3.', 3,
 '[
   {"text": "x = -8", "feedback": "A negative exponent gives a small POSITIVE number, not a negative one. Powers of 2 are never negative."},
   {"text": "x = 8", "feedback": "That ignores the minus sign. A negative exponent flips the power into a fraction."},
   {"text": "x = -1/8", "feedback": "The size is right but the sign is not. 2 to any power stays above zero."},
   {"text": "x = 1/8", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'solving-logarithmic-equations', 4, 'Medium',
 'Solve log x + log(x - 3) = 1.', 1,
 '[
   {"text": "There is no solution", "feedback": "One of the two roots survives the check. Only the negative one fails."},
   {"text": "x = 5", "feedback": "Correct."},
   {"text": "x = 5 and x = -2", "feedback": "The quadratic does give both, but -2 makes both logarithms take a negative input. It has to be thrown out."},
   {"text": "x = -2", "feedback": "-2 is the root that has to be REJECTED, because log(-2) does not exist."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'solving-logarithmic-equations', 5, 'Challenge',
 'Solve log(2m + 6) - log(m² - 9) = 0.', 1,
 '[
   {"text": "m = 5 and m = -3", "feedback": "5 survives the check, but -3 makes both logarithms take zero as their input."},
   {"text": "m = 5", "feedback": "Correct."},
   {"text": "m = 3", "feedback": "At m = 3 the denominator m² - 9 is zero, so the second logarithm does not exist."},
   {"text": "m = -3", "feedback": "At m = -3 both expressions inside the logarithms are zero, and log 0 does not exist."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'solving-logarithmic-equations', 6, 'Challenge',
 'Solve log₂x + log₂(x - 2) = 3.', 1,
 '[
   {"text": "There is no solution", "feedback": "One root survives. Only the negative one fails the check."},
   {"text": "x = 4", "feedback": "Correct."},
   {"text": "x = 4 and x = -2", "feedback": "The quadratic does give both, but -2 makes both logarithms take a negative input, so it has to be thrown out."},
   {"text": "x = -2", "feedback": "-2 is the root that has to be REJECTED. A logarithm of a negative number does not exist."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'solving-logarithmic-equations', 7, 'Advanced',
 'Solve log(x + 3) + log x = 1.', 0,
 '[
   {"text": "x = 2", "feedback": "Correct."},
   {"text": "x = 2 and x = -5", "feedback": "The quadratic gives both, but -5 makes log x take a negative input, so it has to be thrown out."},
   {"text": "x = -5", "feedback": "-5 is the root that has to be REJECTED. A logarithm of a negative number does not exist."},
   {"text": "x = 0.30 and x = -3.30", "feedback": "The 1 on the right was carried inside as it stands. Rewrite log of the product equals 1 in exponential form first."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'solving-logarithmic-equations', 8, 'Advanced',
 'Why does every solution of a logarithmic equation have to be checked?', 0,
 '[
   {"text": "Because combining the logs can produce values that make a logarithm take a negative or zero input", "feedback": "Correct."},
   {"text": "Because logarithms are only approximate", "feedback": "The laws are exact. The problem is that combining two logs into one quietly widens what the equation allows."},
   {"text": "Because the base might change during the working", "feedback": "The base stays put throughout. What changes is the set of inputs the combined expression accepts."},
   {"text": "There is no need to check; every root of the quadratic works", "feedback": "The three equations in this unit each produce one root that has to be discarded, so checking is exactly what stops the wrong answer."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'applications-and-transformations', 1, 'Easy',
 'What is the base of the natural logarithm?', 2,
 '[
   {"text": "2", "feedback": "Base 2 turns up constantly in computing, but it is not what natural means."},
   {"text": "π", "feedback": "π belongs to circles. The constant behind natural growth is a different one, and slightly smaller."},
   {"text": "e, which is about 2.718", "feedback": "Correct."},
   {"text": "10", "feedback": "Base 10 is the COMMON logarithm, the one written as log with no base at all."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'applications-and-transformations', 2, 'Easy',
 'Where is the vertical asymptote of y = log(x - 3)?', 3,
 '[
   {"text": "x = -3", "feedback": "Solving x - 3 = 0 moves the 3 across as a positive number."},
   {"text": "y = 3", "feedback": "A vertical asymptote is a vertical line, so its equation names x."},
   {"text": "x = 0", "feedback": "That is the parent asymptote of y = log x. The - 3 has dragged it sideways."},
   {"text": "x = 3", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'applications-and-transformations', 3, 'Medium',
 'An investment is worth A = 1500(1.12)ᵗ dollars after t years.
What is it worth after 4 years?', 2,
 '[
   {"text": "$1680.00", "feedback": "Only one year of growth was applied. The exponent has to be 4."},
   {"text": "$6720.00", "feedback": "That multiplies 1500 by 1.12 and then by 4. The 4 is an exponent, not a multiplier."},
   {"text": "$2360.28", "feedback": "Correct."},
   {"text": "$2220.00", "feedback": "That adds 12 percent of the ORIGINAL four times over, which is simple interest rather than compounding."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'applications-and-transformations', 4, 'Medium',
 'Write the equation for y = log x moved 3 right and 2 up.', 2,
 '[
   {"text": "y = log(x - 3) - 2", "feedback": "A move up adds to the output, so the constant on the end is positive."},
   {"text": "y = log(x - 2) + 3", "feedback": "The two numbers have swapped jobs. The 3 is the sideways move and the 2 is the vertical one."},
   {"text": "y = log(x - 3) + 2", "feedback": "Correct."},
   {"text": "y = log(x + 3) + 2", "feedback": "A move RIGHT is written x - 3. The sign inside the bracket is the opposite of the direction."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'applications-and-transformations', 5, 'Hard',
 'A radioactive sample has a half-life of 5 years. What fraction remains after 20 years?', 0,
 '[
   {"text": "1/16", "feedback": "Correct. Twenty years is four half-lives, so the amount halves four times: (1/2)⁴."},
   {"text": "1/4", "feedback": "This halves twice, which matches 10 years. Count how many 5-year periods fit into 20."},
   {"text": "1/20", "feedback": "Decay is not found by dividing by the total time. Each half-life multiplies what is left by one half."},
   {"text": "0", "feedback": "Exponential decay approaches zero but never actually reaches it after a finite number of half-lives."}
 ]'::jsonb,
 'half-life-count'),
('MHF4U', 'logarithmic-functions', 'applications-and-transformations', 6, 'Challenge',
 'An investment follows A = 1500(1.12)ᵗ.
How long does it take to double, to 2 decimal places?', 3,
 '[
   {"text": "8.33 years", "feedback": "That is 100 divided by 12, which is the rule for SIMPLE interest. Compounding gets there sooner."},
   {"text": "2.00 years", "feedback": "That reads the 2 in the doubling as the answer. The 2 goes inside a logarithm, not into the answer directly."},
   {"text": "12.00 years", "feedback": "That reads the 12 percent as a number of years. Solve 2 = 1.12 to the power t with logarithms."},
   {"text": "6.12 years", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'applications-and-transformations', 7, 'Challenge',
 'How does the graph of y = log(3x) differ from the graph of y = log x?', 2,
 '[
   {"text": "It is stretched vertically by a factor of 3", "feedback": "A vertical stretch by 3 needs the 3 OUTSIDE, as 3 log x. Inside, the product law turns it into an addition."},
   {"text": "It is moved up by 3 units", "feedback": "The 3 sits inside the logarithm, so it does not lift the graph by 3. A constant multiplied inside does not come out of the log unchanged."},
   {"text": "It is the same curve moved up by log 3, about 0.477", "feedback": "Correct."},
   {"text": "It is moved 3 units to the right", "feedback": "A sideways move needs the 3 ADDED or subtracted inside, as log(x - 3). Multiplying inside does something different."}
 ]'::jsonb,
 null),
('MHF4U', 'logarithmic-functions', 'applications-and-transformations', 8, 'Advanced',
 'The loudness of a sound in decibels is L = 10 log(I/I₀), where I is its intensity
and I₀ is the threshold intensity. A concert reads 110 dB and a vacuum cleaner
reads 70 dB. How many times more intense is the concert?', 3,
 '[
   {"text": "40 times", "feedback": "That is the gap between the two readings, and a gap in decibels is not a ratio of intensities. The scale is logarithmic, so the gap still has to be undone."},
   {"text": "about 1.6 times", "feedback": "That divides one reading by the other. Decibel readings behave like exponents, and exponents subtract rather than divide."},
   {"text": "10⁴⁰ times", "feedback": "The 10 in front of the logarithm was skipped, so each reading was treated as a power of 10 on its own."},
   {"text": "10 000 times", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'characteristics-of-polynomials', 1, 'Easy',
 'What is the degree of   f(x) = 3x⁴ − 2x⁷ + 5x ?', 2,
 '[
   {"text": "4", "feedback": "That is the exponent on the first term written down, but the terms are not in descending order here. Look for the largest exponent anywhere in the expression."},
   {"text": "3", "feedback": "That is a coefficient, not an exponent. Degree comes from the powers of x only."},
   {"text": "7", "feedback": "Correct. The degree is the largest exponent on x, which is 7 in the term −2x⁷."},
   {"text": "12", "feedback": "Exponents are not added together. The degree is the single largest power of x, not a total."}
 ]'::jsonb,
 'degree-largest-exponent'),
('MHF4U', 'polynomial-functions', 'characteristics-of-polynomials', 2, 'Easy',
 'Describe the end behaviour of   f(x) = −2x³ + 5x − 1.', 1,
 '[
   {"text": "Both ends point upward", "feedback": "Both ends can only agree when the degree is even. The highest power here is odd."},
   {"text": "As x → −∞, y → +∞ and as x → +∞, y → −∞", "feedback": "Correct. An odd degree sends the two ends in opposite directions, and the negative leading coefficient pulls the right end downward."},
   {"text": "As x → −∞, y → −∞ and as x → +∞, y → +∞", "feedback": "This is the behaviour of an odd-degree polynomial with a positive leading coefficient. Check the sign of the leading term."},
   {"text": "Both ends point downward", "feedback": "Matching ends require an even degree. This polynomial has an odd one."}
 ]'::jsonb,
 'end-behaviour-odd-even'),
('MHF4U', 'polynomial-functions', 'characteristics-of-polynomials', 3, 'Easy',
 'A polynomial has constant 5th differences. What is its degree?', 1,
 '[
   {"text": "120", "feedback": "120 is 5 factorial, which turns up when the leading coefficient is worked out. It is not a degree."},
   {"text": "5", "feedback": "Correct."},
   {"text": "4", "feedback": "Constant 4th differences belong to a degree 4 polynomial. The number of the difference and the degree match."},
   {"text": "6", "feedback": "A degree 6 polynomial has constant 6th differences, not 5th."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'characteristics-of-polynomials', 4, 'Medium',
 'What is the maximum number of turning points a degree 5 polynomial can have?', 3,
 '[
   {"text": "5", "feedback": "That is the degree itself. A polynomial always changes direction fewer times than its degree."},
   {"text": "6", "feedback": "This is one more than the degree. The relationship goes the other way."},
   {"text": "2", "feedback": "This is the limit for a quadratic. A higher degree allows more direction changes."},
   {"text": "4", "feedback": "Correct. A polynomial of degree n has at most n − 1 turning points, so degree 5 allows 4."}
 ]'::jsonb,
 'turning-points-count'),
('MHF4U', 'polynomial-functions', 'characteristics-of-polynomials', 5, 'Medium',
 'How many turning points could g(x) = -20x⁶ - 5x³ + x² - 17 have?', 3,
 '[
   {"text": "6, 4, 2 or 0", "feedback": "An even-degree polynomial has an ODD number of turning points, because both ends go the same way."},
   {"text": "Any number up to 6", "feedback": "6 is the degree, and turning points top out one below it. They also cannot be even here."},
   {"text": "Exactly 5, no more and no fewer", "feedback": "5 is the maximum. The curve can have fewer, as long as the count stays odd."},
   {"text": "5, 3 or 1", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'characteristics-of-polynomials', 6, 'Medium',
 'A polynomial has constant third differences equal to 42.
What are its degree and its leading coefficient?', 0,
 '[
   {"text": "Degree 3, leading coefficient 7", "feedback": "Correct."},
   {"text": "Degree 3, leading coefficient 42", "feedback": "The degree is right. The constant difference is a times 3 factorial, so the 42 still has to be divided by 6."},
   {"text": "Degree 4, leading coefficient 7", "feedback": "Third differences go with degree 3. The number of the difference matches the degree."},
   {"text": "Degree 3, leading coefficient 14", "feedback": "That divides by 3 rather than by 3 factorial, which is 6."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'characteristics-of-polynomials', 7, 'Hard',
 'Which function is even, meaning its graph is symmetric about the y-axis?', 1,
 '[
   {"text": "f(x) = x³ − x", "feedback": "Replacing x with −x flips the sign of the whole expression here, which is the test for a different kind of symmetry."},
   {"text": "f(x) = x⁴ − 3x² + 1", "feedback": "Correct. Every exponent is even, so f(−x) = f(x) and the two halves of the graph mirror each other across the y-axis."},
   {"text": "f(x) = x³ + x²", "feedback": "Mixing odd and even powers breaks the symmetry. Compare f(−1) with f(1) to see."},
   {"text": "f(x) = 2x + 5", "feedback": "A slanted line with a nonzero constant is not symmetric about the y-axis. Test f(−1) against f(1)."}
 ]'::jsonb,
 'even-odd-symmetry'),
('MHF4U', 'polynomial-functions', 'characteristics-of-polynomials', 8, 'Challenge',
 'A table of values for a polynomial has constant third differences of -24.
What are its degree and its leading coefficient?', 2,
 '[
   {"text": "Degree 4, leading coefficient -1", "feedback": "That reads third differences as belonging to degree 4 and divides by 4 factorial. The number of the constant difference is the degree itself."},
   {"text": "Degree 3, leading coefficient -12", "feedback": "That divides by 2 rather than by 3 factorial, which is 6."},
   {"text": "Degree 3, leading coefficient -4", "feedback": "Correct."},
   {"text": "Degree 3, leading coefficient -24", "feedback": "The degree is right. The constant difference is a times 3 factorial, so the -24 still has to be divided by 6."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'characteristics-of-polynomials', 9, 'Challenge',
 'How many x-intercepts could h(x) = -x⁵ + x⁴ - x³ + x² - x + 1 have?', 0,
 '[
   {"text": "5, 4, 3, 2 or 1", "feedback": "Correct."},
   {"text": "5, 4, 3, 2, 1 or 0", "feedback": "An odd-degree polynomial runs from one end of the y-axis to the other, so it has to cross at least once. Zero is impossible."},
   {"text": "Exactly 5, no more and no fewer", "feedback": "5 is the maximum. Repeated or complex roots can leave it with fewer crossings."},
   {"text": "Anything from 0 to 4", "feedback": "4 is the maximum number of TURNING points. The number of intercepts can reach the degree itself."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'characteristics-of-polynomials', 10, 'Advanced',
 'For f(x) = -3x⁴ + 6x² - 10, which finite difference is constant,
and what is its value?', 2,
 '[
   {"text": "The 3rd, and it equals -18", "feedback": "The degree here is 4, so it is the 4th differences that settle down, not the 3rd."},
   {"text": "The 4th, and it equals -12", "feedback": "That multiplies by 4 rather than by 4 factorial, which is 24."},
   {"text": "The 4th, and it equals -72", "feedback": "Correct."},
   {"text": "The 4th, and it equals -3", "feedback": "The difference which is constant is right. Its value is the leading coefficient times 4 factorial, not the leading coefficient alone."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'characteristics-of-polynomials', 11, 'Advanced',
 'A polynomial has 4 turning points, 3 x-intercepts and end behaviour
running Q2 to Q4. Give its least possible degree and the sign of its
leading coefficient.', 1,
 '[
   {"text": "Degree 3, negative leading coefficient", "feedback": "A cubic turns at most twice, and this curve turns four times."},
   {"text": "Degree 5, negative leading coefficient", "feedback": "Correct."},
   {"text": "Degree 4, negative leading coefficient", "feedback": "4 turning points need a degree of at least 5, and an even degree cannot send its two ends in opposite directions anyway."},
   {"text": "Degree 5, positive leading coefficient", "feedback": "A positive leading coefficient on an odd degree runs Q3 to Q1, which is the other way round."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'factored-form-and-zeros', 1, 'Easy',
 'What are the x-intercepts of   f(x) = (x − 3)(x + 2)(x − 5) ?', 0,
 '[
   {"text": "3, −2, 5", "feedback": "Correct. Each factor is set equal to zero, so x − 3 = 0, x + 2 = 0 and x − 5 = 0."},
   {"text": "−3, 2, −5", "feedback": "The numbers have been copied straight out of the brackets with their signs unchanged. Solve each factor equal to zero instead."},
   {"text": "3, 2, 5", "feedback": "One of the brackets has a plus sign inside it, and that changes the sign of the root it produces."},
   {"text": "0, 3, 5", "feedback": "Zero is a root only when x on its own is a factor. Every factor here contains a constant."}
 ]'::jsonb,
 'roots-sign-from-factors'),
('MHF4U', 'polynomial-functions', 'factored-form-and-zeros', 2, 'Easy',
 'What are the x-intercepts of f(x) = (x + 1)(x - 3)(x + 2)?', 3,
 '[
   {"text": "1, -3 and 2", "feedback": "Every sign is flipped. Setting x + 1 = 0 gives x = -1, not +1."},
   {"text": "-1, 3 and 2", "feedback": "Two are right. The bracket x + 2 gives a NEGATIVE intercept."},
   {"text": "1, 3 and 2", "feedback": "Those are the numbers inside the brackets read straight off. Each bracket has to be set to zero and solved."},
   {"text": "-1, 3 and -2", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'factored-form-and-zeros', 3, 'Easy',
 'What is the y-intercept of f(x) = (x + 1)(x - 3)(x + 2)?', 0,
 '[
   {"text": "-6", "feedback": "Correct."},
   {"text": "6", "feedback": "The bracket x - 3 gives -3 at x = 0, and one negative among three factors leaves the product negative."},
   {"text": "0", "feedback": "None of the three brackets is zero when x = 0, so the product is not zero either."},
   {"text": "-4", "feedback": "That adds the three bracket constants rather than multiplying them, and takes -2 from the bracket x + 2 on the way."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'factored-form-and-zeros', 4, 'Medium',
 'For h(x) = (x - 4)²(x + 3)³, give the degree and the end behaviour.', 2,
 '[
   {"text": "Degree 6, Q3 to Q1", "feedback": "The exponents on the two brackets were MULTIPLIED together. Multiplying powers of x adds them instead."},
   {"text": "Degree 5, Q2 to Q1", "feedback": "Both ends going the same way needs an even degree, and 5 is odd."},
   {"text": "Degree 5, Q3 to Q1", "feedback": "Correct."},
   {"text": "Degree 5, Q2 to Q4", "feedback": "The degree is right, but nothing here is negative. Multiplying the leading terms gives a positive coefficient."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'factored-form-and-zeros', 5, 'Medium',
 'What is the leading coefficient of p(x) = -4(2x + 5)(x - 2)(x + 4)?', 1,
 '[
   {"text": "8", "feedback": "The size is right but the sign is not. There is one minus out front and none inside the leading terms."},
   {"text": "-8", "feedback": "Correct."},
   {"text": "-4", "feedback": "The -4 out front is only part of it. The 2 in front of the x in the first bracket multiplies in too."},
   {"text": "-160", "feedback": "That multiplies -4 by the bracket CONSTANTS and drops the minus on the -2 along the way. The constants settle the y-intercept, not the leading coefficient."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'factored-form-and-zeros', 6, 'Hard',
 'A cubic has zeros at −1, 2 and 3, so f(x) = a(x + 1)(x − 2)(x − 3).
Its y-intercept is 12. What is the value of a?', 1,
 '[
   {"text": "1", "feedback": "This assumes the brackets already produce the y-intercept on their own. Evaluate the brackets at x = 0 first."},
   {"text": "2", "feedback": "Correct. At x = 0 the brackets give (1)(−2)(−3) = 6, and 6a = 12."},
   {"text": "12", "feedback": "That is the y-intercept itself, not the stretch factor. It still has to be divided by what the brackets produce at x = 0."},
   {"text": "−2", "feedback": "Two of the brackets give negative values at x = 0, and they multiply to a positive, so no sign change is needed."}
 ]'::jsonb,
 'stretch-factor-from-point'),
('MHF4U', 'polynomial-functions', 'factored-form-and-zeros', 7, 'Challenge',
 'Give the x-intercepts of g(x) = -x(x + 1)(x + 2)², including the order of each.', 1,
 '[
   {"text": "0 and -2 of order 1, and -1 of order 2", "feedback": "The squared bracket is x + 2, not x + 1."},
   {"text": "0 and -1 of order 1, and -2 of order 2", "feedback": "Correct."},
   {"text": "0 and 1 of order 1, and 2 of order 2", "feedback": "Every sign is flipped. Setting x + 1 = 0 gives x = -1."},
   {"text": "0, -1 and -2, all three of them of order 1", "feedback": "The bracket x + 2 is squared, so that zero is repeated and the curve touches the axis there rather than crossing."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'factored-form-and-zeros', 8, 'Challenge',
 'What is the y-intercept of h(x) = (x - 4)²(x + 3)³?', 2,
 '[
   {"text": "108", "feedback": "That takes 4 straight off the first bracket instead of the value it has at x = 0, and drops its exponent as well."},
   {"text": "0", "feedback": "Neither bracket is zero at x = 0, so the product is not zero. The intercepts on the x-axis are at 4 and -3."},
   {"text": "432", "feedback": "Correct."},
   {"text": "-432", "feedback": "The -4 is SQUARED, and squaring turns it positive before it meets the 27."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'factored-form-and-zeros', 9, 'Advanced',
 'A polynomial has x-intercepts at -2 (order 2), 1/2 and 4, and it passes
through (1, 5). Write its equation.', 1,
 '[
   {"text": "f(x) = -(5/27)(x + 2)(2x - 1)(x - 4)", "feedback": "The intercept at -2 has order 2, so its bracket appears twice."},
   {"text": "f(x) = -(5/27)(x + 2)²(2x - 1)(x - 4)", "feedback": "Correct."},
   {"text": "f(x) = (5/27)(x + 2)²(2x - 1)(x - 4)", "feedback": "Substituting the point gives -27k = 5, so k comes out negative."},
   {"text": "f(x) = -(5/27)(x - 2)²(2x - 1)(x - 4)", "feedback": "An intercept at -2 comes from the bracket x + 2. The sign inside is the opposite of the intercept."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'factored-form-and-zeros', 10, 'Advanced',
 'A quartic has zeros at -3, -1 and 2 (order 2), and passes through (1, 4).
Write its equation.', 3,
 '[
   {"text": "g(x) = 2(x + 3)(x + 1)(x - 2)²", "feedback": "The equation for k was solved upside down, so the value in front came out inverted."},
   {"text": "g(x) = (1/2)(x - 3)(x - 1)(x + 2)²", "feedback": "Every sign is flipped. A zero at -3 comes from the bracket x + 3."},
   {"text": "g(x) = (1/2)(x + 3)(x + 1)(x - 2)", "feedback": "The zero at 2 has order 2, so its bracket appears twice. As written this is only a cubic."},
   {"text": "g(x) = (1/2)(x + 3)(x + 1)(x - 2)²", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'the-remainder-theorem', 1, 'Easy',
 'By the remainder theorem, dividing P(x) by x - a leaves a remainder of what?', 0,
 '[
   {"text": "P(a)", "feedback": "Correct."},
   {"text": "P(-a)", "feedback": "The sign flips when the bracket is solved: x - a is zero at positive a."},
   {"text": "the number a", "feedback": "a is the input, not the output. The remainder is what the polynomial EVALUATES to there."},
   {"text": "P(x) divided by a", "feedback": "The theorem replaces the whole division with a single substitution. No dividing is left to do."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'the-remainder-theorem', 2, 'Easy',
 'What is the remainder when x⁴ - 4x² - 2x + 3 is divided by x + 1?', 1,
 '[
   {"text": "0", "feedback": "A remainder of zero would make x + 1 a factor, and substituting -1 does not give zero here."},
   {"text": "2", "feedback": "Correct."},
   {"text": "-2", "feedback": "The -2x term becomes +2 when x is -1, because a negative times a negative is positive."},
   {"text": "8", "feedback": "That takes (-1)⁴ as -1. An even power of a negative is positive."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'the-remainder-theorem', 3, 'Medium',
 'What is the remainder when   x³ − 4x² + 2x + 1   is divided by   (x − 2) ?', 1,
 '[
   {"text": "3", "feedback": "The size is right but the sign is not. Recheck the subtraction when substituting."},
   {"text": "−3", "feedback": "Correct. The remainder theorem says to evaluate at x = 2: 8 − 16 + 4 + 1 = −3."},
   {"text": "−11", "feedback": "This comes from substituting x = −2. The divisor x − 2 is zero when x is positive 2."},
   {"text": "1", "feedback": "That is the constant term, which is only the remainder when dividing by x itself."}
 ]'::jsonb,
 'remainder-theorem-substitution'),
('MHF4U', 'factoring-polynomials', 'the-remainder-theorem', 4, 'Medium',
 'Find k so that dividing f(x) = x⁴ + kx³ - 3x - 5 by x - 3
leaves a remainder of -10.', 0,
 '[
   {"text": "k = -77/27", "feedback": "Correct."},
   {"text": "k = 77/27", "feedback": "Moving 67 across the equals sign from -10 makes the left side -77, so k comes out negative."},
   {"text": "k = -10/27", "feedback": "The -10 was divided by 27 on its own. The other terms 81, -9 and -5 also have to be moved across first."},
   {"text": "k = -67/27", "feedback": "That divides the 67 rather than the -77. The -10 on the left still has to be brought over."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'the-remainder-theorem', 5, 'Medium',
 'A division leaves a remainder of 0. What does that tell you?', 1,
 '[
   {"text": "Nothing in particular", "feedback": "A zero remainder is exactly the factor theorem: the divisor goes in a whole number of times."},
   {"text": "The divisor is a factor of the polynomial", "feedback": "Correct."},
   {"text": "The polynomial being divided is the zero polynomial", "feedback": "Only dividing zero by something gives a zero QUOTIENT. A zero remainder says the division came out exactly."},
   {"text": "The quotient is zero", "feedback": "The quotient is what the division produces, and it is usually far from zero. It is the leftover that vanished."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'the-remainder-theorem', 6, 'Challenge',
 'To find the remainder when P(x) is divided by 3x + 1,
which value do you substitute?', 1,
 '[
   {"text": "3", "feedback": "Substituting 3 would suit a divisor of x - 3. Set the actual divisor to zero and solve it."},
   {"text": "-1/3", "feedback": "Correct."},
   {"text": "1/3", "feedback": "The sign flips when the divisor is solved: 3x + 1 is zero at a negative value."},
   {"text": "-3", "feedback": "The 3 and the 1 have swapped roles. Solving 3x + 1 = 0 divides the 1 by the 3, it does not divide the 3 by the 1."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'the-remainder-theorem', 7, 'Challenge',
 'The cubic 8x³ + mx² + nx - 6 has both 2x + 3 and x - 1 as factors.
Find m and n.', 2,
 '[
   {"text": "m = 8 and n = 10", "feedback": "m is right. Substituting 1 gives 8 + m + n - 6 = 0, and with m = 8 that forces n below zero."},
   {"text": "m = -8 and n = -10", "feedback": "n is right, but solving the pair of equations gives a positive m."},
   {"text": "m = 8 and n = -10", "feedback": "Correct."},
   {"text": "m = -10 and n = 8", "feedback": "The two values are the right pair but they have swapped places. m belongs to the x² term."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'the-remainder-theorem', 8, 'Advanced',
 'P(x) leaves a remainder of 5 when divided by x - 2, and a remainder of -3
when divided by x + 1. What is P(2) + P(-1)?', 3,
 '[
   {"text": "8", "feedback": "The second remainder is negative, so the two are added as 5 and -3 rather than 5 and 3."},
   {"text": "-15", "feedback": "That multiplies the two remainders. The question asks for their sum."},
   {"text": "1", "feedback": "That adds the two x-values, 2 and -1, rather than the two remainders."},
   {"text": "2", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'the-remainder-theorem', 9, 'Advanced',
 'For P(x) = x³ + ax + b, both P(1) = 0 and P(-2) = 0. Find a and b.', 2,
 '[
   {"text": "a = -3 and b = -2", "feedback": "a is right. Substituting 1 gives 1 + a + b = 0, so with a = -3 the constant has to be positive."},
   {"text": "a = 2 and b = -3", "feedback": "The two values have swapped places. a is the coefficient of x and b is the constant."},
   {"text": "a = -3 and b = 2", "feedback": "Correct."},
   {"text": "a = 3 and b = -2", "feedback": "Both signs are flipped. Substituting 1 gives 1 + a + b = 0, and this pair makes that come to 2."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'the-factor-theorem-and-factoring', 1, 'Easy',
 'x - 3 is a factor of P(x) exactly when which of these is true?', 0,
 '[
   {"text": "P(3) = 0", "feedback": "Correct."},
   {"text": "P(-3) = 0", "feedback": "The sign flips when the bracket is solved: x - 3 is zero at positive 3."},
   {"text": "P(0) = 3", "feedback": "That is about the y-intercept, which has nothing to do with whether a bracket divides in."},
   {"text": "P(3) = 3", "feedback": "A factor leaves NO remainder, so the value has to be zero rather than 3."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'the-factor-theorem-and-factoring', 2, 'Easy',
 'Is x - 3 a factor of 3x² - 8x - 3?', 3,
 '[
   {"text": "No, because substituting 3 gives 6 rather than 0", "feedback": "That adds the constant term instead of subtracting it. The polynomial ends in -3."},
   {"text": "Yes, because substituting -3 gives 0", "feedback": "The conclusion is right but the test is not. x - 3 is zero at positive 3, and substituting -3 gives 48."},
   {"text": "No, because the constant term is -3 rather than a multiple of 3", "feedback": "The constant term does not settle it. The factor theorem is a substitution, not a look at the coefficients."},
   {"text": "Yes, because substituting 3 gives 0", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'the-factor-theorem-and-factoring', 3, 'Medium',
 'Which of these is a factor of   x³ − 7x + 6 ?', 0,
 '[
   {"text": "(x − 1)", "feedback": "Correct. Substituting x = 1 gives 1 − 7 + 6 = 0, so by the factor theorem this bracket divides evenly."},
   {"text": "(x + 1)", "feedback": "Substituting x = −1 gives a nonzero value, so this bracket leaves a remainder."},
   {"text": "(x − 6)", "feedback": "The constant 6 does suggest testing 6, but substituting it gives a large nonzero value. The smaller divisors of 6 are worth testing too."},
   {"text": "(x + 2)", "feedback": "Substituting x = −2 does not produce zero, so this bracket leaves a remainder."}
 ]'::jsonb,
 'factor-theorem-test'),
('MHF4U', 'factoring-polynomials', 'the-factor-theorem-and-factoring', 4, 'Medium',
 'Factor x³ - 4x² + x + 6 fully.', 0,
 '[
   {"text": "(x + 1)(x - 2)(x - 3)", "feedback": "Correct."},
   {"text": "(x - 1)(x + 2)(x + 3)", "feedback": "Every sign is flipped. Multiply this out and the constant comes to -6 rather than +6."},
   {"text": "(x + 1)(x + 2)(x - 3)", "feedback": "Multiply this out: the constant becomes -6, and the x² coefficient becomes 0 rather than -4."},
   {"text": "(x - 1)(x - 2)(x - 3)", "feedback": "Multiply this out: the constant comes to -6, and substituting 1 into the original gives 4 rather than 0."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'the-factor-theorem-and-factoring', 5, 'Medium',
 'Factor x³ - 64 fully over the real numbers.', 2,
 '[
   {"text": "(x - 4)(x² + 4x - 16)", "feedback": "The last term of the second bracket is b squared, which is positive."},
   {"text": "(x - 4)³", "feedback": "Multiply that out and it gives x³ - 12x² + 48x - 64. A difference of cubes is not a perfect cube."},
   {"text": "(x - 4)(x² + 4x + 16)", "feedback": "Correct."},
   {"text": "(x - 4)(x² - 4x + 16)", "feedback": "In the difference of cubes the middle term of the second bracket is PLUS ab. Only the first bracket carries the minus."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'the-factor-theorem-and-factoring', 6, 'Challenge',
 'Factor 3x³ - 5x² - 26x - 8 fully.', 0,
 '[
   {"text": "(x + 2)(x - 4)(3x + 1)", "feedback": "Correct."},
   {"text": "(x - 2)(x + 4)(3x - 1)", "feedback": "Every sign is flipped. Multiply out and the constant becomes +8 rather than -8."},
   {"text": "(x + 2)(x + 4)(3x - 1)", "feedback": "Multiply out: the constant becomes -8, which is right, but the x² coefficient comes to 17 rather than -5."},
   {"text": "(x + 2)(x - 4)(3x - 1)", "feedback": "That takes the third root to be 1/3. Substituting 1/3 into the original leaves -154/9 rather than zero."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'the-factor-theorem-and-factoring', 7, 'Challenge',
 'Factor -4x³ - 4x² + 16x + 16 fully.', 1,
 '[
   {"text": "-4(x + 1)(x - 4)(x + 4)", "feedback": "The difference of squares left after grouping is x² - 4, not x² - 16."},
   {"text": "-4(x + 1)(x - 2)(x + 2)", "feedback": "Correct."},
   {"text": "-4(x - 1)(x - 2)(x + 2)", "feedback": "Grouping gives x²(x + 1) - 4(x + 1), so the common bracket is x + 1."},
   {"text": "4(x + 1)(x - 2)(x + 2)", "feedback": "The common factor pulled out is -4, not 4. Check the sign of the leading term."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'the-factor-theorem-and-factoring', 8, 'Advanced',
 'Which of these is a possible rational zero of 3x³ - 5x² - 26x - 8?', 0,
 '[
   {"text": "-1/3", "feedback": "Correct."},
   {"text": "1/2", "feedback": "The denominator has to divide the LEADING coefficient, which is 3. There is no 2 in it."},
   {"text": "3", "feedback": "The numerator has to divide the CONSTANT term, which is -8. 3 does not."},
   {"text": "8/5", "feedback": "The numerator divides 8, which is fine, but the denominator has to divide 3, and 5 does not."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'the-factor-theorem-and-factoring', 9, 'Advanced',
 'Find the family of quartic polynomials with real roots at 3 (order 2)
and at 2 plus or minus √2.', 3,
 '[
   {"text": "y = k(x - 3)²(x² + 4x + 2)", "feedback": "Squaring x - 2 gives a middle term of -4x. The pair of roots sits at positive 2, so the bracket subtracts."},
   {"text": "y = k(x - 3)(x² - 4x + 2)", "feedback": "The root at 3 has order 2, so its bracket appears twice. As written this is only a cubic."},
   {"text": "y = k(x - 3)²(x² - 4x - 2)", "feedback": "Rearranging (x - 2)² = 2 gives x² - 4x + 4 - 2, which leaves +2 on the end."},
   {"text": "y = k(x - 3)²(x² - 4x + 2)", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'polynomial-inequalities', 1, 'Easy',
 'Solve (x - 1)(x + 2) > 0.', 2,
 '[
   {"text": "x > 1 only", "feedback": "Half the answer. Below -2 both brackets are negative, and two negatives multiply to a positive."},
   {"text": "All real numbers", "feedback": "Between the roots the product dips below zero, so it is not positive everywhere."},
   {"text": "x < -2 or x > 1", "feedback": "Correct."},
   {"text": "-2 < x < 1", "feedback": "That is where the product is NEGATIVE. Between the two roots exactly one bracket is negative."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'polynomial-inequalities', 2, 'Easy',
 'In interval notation, what does a square bracket mean?', 2,
 '[
   {"text": "The interval runs to infinity", "feedback": "Infinity always takes a round bracket, precisely because it can never be reached."},
   {"text": "The interval turns out to be empty", "feedback": "An empty set is written with its own symbol. Brackets say whether the ends belong."},
   {"text": "The endpoint is included", "feedback": "Correct."},
   {"text": "The endpoint is not included", "feedback": "That is what a round bracket means. A square bracket takes the endpoint in."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'polynomial-inequalities', 3, 'Medium',
 'Solve the inequality   (x − 1)(x + 4) > 0.', 2,
 '[
   {"text": "−4 < x < 1", "feedback": "Between the two roots the factors have opposite signs, so their product is negative there."},
   {"text": "x > 1 only", "feedback": "This is one piece of the answer. Test a large negative value as well, where both factors are negative."},
   {"text": "x < −4 or x > 1", "feedback": "Correct. Outside both roots the two factors share the same sign, so the product is positive."},
   {"text": "x > −4", "feedback": "This ignores the second root, where the product changes sign again. Test a value between the two roots."}
 ]'::jsonb,
 'inequality-sign-regions'),
('MHF4U', 'factoring-polynomials', 'polynomial-inequalities', 4, 'Medium',
 'Solve x³ + 6x² + 11x + 6 > 0.', 3,
 '[
   {"text": "x < -3 or -2 < x < -1", "feedback": "Those are the intervals where the cubic is NEGATIVE. With a positive leading coefficient it starts below the axis on the far left."},
   {"text": "-3 < x < -2 only", "feedback": "Half the answer. To the right of the largest root the curve heads up and stays positive."},
   {"text": "x > -1 only", "feedback": "Half the answer. The curve also pokes above the axis in the gap between -3 and -2."},
   {"text": "-3 < x < -2 or x > -1", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'polynomial-inequalities', 5, 'Medium',
 'For which values of x is y = 8x³ + 1 positive?', 1,
 '[
   {"text": "Every x except -1/2", "feedback": "That would need an even-order root, where the curve touches the axis and turns back. This one crosses cleanly."},
   {"text": "x > -1/2", "feedback": "Correct."},
   {"text": "x < -1/2", "feedback": "A positive leading coefficient on an odd degree means the curve is BELOW the axis to the left of its root."},
   {"text": "x > 1/2", "feedback": "The root comes from 8x³ = -1, so the cube root is negative."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'polynomial-inequalities', 6, 'Challenge',
 'Solve 2x³ + 1 < x² + 2x.', 3,
 '[
   {"text": "-1 < x < 1/2 or x > 1", "feedback": "Those are the intervals where the cubic is POSITIVE. With a positive leading coefficient it starts below the axis on the far left."},
   {"text": "x < -1 only", "feedback": "Half the answer. The curve dips back below the axis between the two larger roots."},
   {"text": "1/2 < x < 1 only", "feedback": "Half the answer. Far to the left the curve is below the axis as well."},
   {"text": "x < -1 or 1/2 < x < 1", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'polynomial-inequalities', 7, 'Challenge',
 'Solve 6x³ + 13x² - 41x + 12 ≤ 0.', 1,
 '[
   {"text": "1/3 ≤ x ≤ 3/2 only", "feedback": "Half the answer. Far to the left the curve is below the axis as well."},
   {"text": "x ≤ -4 or 1/3 ≤ x ≤ 3/2", "feedback": "Correct."},
   {"text": "x ≤ -4 only", "feedback": "Half the answer. Between the two positive roots the curve dips back below the axis."},
   {"text": "-4 ≤ x ≤ 1/3 or x ≥ 3/2", "feedback": "Those are the intervals where the cubic is at or above zero. The inequality asks for where it is at or below."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'polynomial-inequalities', 8, 'Advanced',
 'Why is x² + 1 > 0 for every real value of x?', 1,
 '[
   {"text": "It is not true; the expression is negative when x is a negative number", "feedback": "Squaring a negative gives a positive, so the negative sign disappears before the 1 is added."},
   {"text": "Because a square is never negative, so the total is always at least 1", "feedback": "Correct."},
   {"text": "Because x² + 1 factors into two real brackets", "feedback": "It does not factor over the reals, and factoring would not settle the sign anyway."},
   {"text": "Because its discriminant is positive", "feedback": "The discriminant here is -4. A NEGATIVE discriminant is what tells you the curve never touches the axis."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'polynomial-inequalities', 9, 'Advanced',
 'Which interval notation matches x < -1 or 1/2 < x < 1?', 0,
 '[
   {"text": "(-∞, -1) ∪ (1/2, 1)", "feedback": "Correct."},
   {"text": "(-∞, -1] ∪ [1/2, 1]", "feedback": "Every inequality here is strict, so all four ends are excluded and the brackets stay round."},
   {"text": "(-1, 1/2) ∪ (1, ∞)", "feedback": "That is the complement, the part of the line left over."},
   {"text": "(-∞, -1) ∩ (1/2, 1)", "feedback": "An intersection asks for values in BOTH pieces at once, and no number is in both. The word or calls for a union."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'solving-polynomial-equations', 1, 'Easy',
 'Solve (x - 2)(x + 5) = 0.', 0,
 '[
   {"text": "x = 2 or x = -5", "feedback": "Correct."},
   {"text": "x = -2 or x = 5", "feedback": "Both signs are flipped. Setting x - 2 = 0 gives POSITIVE 2."},
   {"text": "x = 2 or x = 5", "feedback": "The first is right. The bracket x + 5 is zero at a negative value."},
   {"text": "x = -2 or x = -5", "feedback": "The second is right. The bracket x - 2 is zero at a positive value."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'solving-polynomial-equations', 2, 'Easy',
 'What is the greatest number of real roots a cubic equation can have?', 3,
 '[
   {"text": "2", "feedback": "2 is the maximum number of TURNING points for a cubic. The roots can go one higher."},
   {"text": "4", "feedback": "A polynomial never has more roots than its degree."},
   {"text": "1", "feedback": "1 is the MINIMUM for a cubic, because an odd degree has to cross the axis at least once."},
   {"text": "3", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'solving-polynomial-equations', 3, 'Medium',
 'Solve x³ + 6x² + 11x + 6 = 0.', 0,
 '[
   {"text": "x = -1, -2 and -3", "feedback": "Correct."},
   {"text": "x = 1, 2 and 3", "feedback": "Every coefficient here is positive, so a positive x can never make the total zero. The roots have to be negative."},
   {"text": "x = -1, 2 and 3", "feedback": "Only the first is right. Substituting 2 gives 60, not 0."},
   {"text": "x = -1, -2 and 3", "feedback": "Two are right. Substituting 3 gives 120, not 0."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'solving-polynomial-equations', 4, 'Medium',
 'Solve 2x³ + 1 = x² + 2x.', 3,
 '[
   {"text": "x = -1/2, 1 and -1", "feedback": "The bracket 2x - 1 is zero at a POSITIVE half."},
   {"text": "x = 2, 1 and -1", "feedback": "The bracket 2x - 1 has a coefficient on the x, and that coefficient divides the root."},
   {"text": "x = 1/2 only", "feedback": "After grouping, the second factor is x² - 1, which supplies two more roots of its own."},
   {"text": "x = 1/2, 1 and -1", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'solving-polynomial-equations', 5, 'Hard',
 'Solve   x³ − 3x² − x + 3 = 0.', 3,
 '[
   {"text": "x = 3 only", "feedback": "Grouping does produce a factor of x − 3, but the other bracket factors further and gives more roots."},
   {"text": "x = 1 and x = −1 only", "feedback": "The difference of squares has been spotted, but the first bracket from the grouping also gives a root."},
   {"text": "x = 0, 1, 3", "feedback": "Zero can only be a root when the constant term is zero. Substituting x = 0 leaves 3, not 0."},
   {"text": "x = 3, 1, −1", "feedback": "Correct. Grouping gives (x − 3)(x² − 1), and the second bracket is a difference of squares."}
 ]'::jsonb,
 'factor-by-grouping'),
('MHF4U', 'factoring-polynomials', 'solving-polynomial-equations', 6, 'Challenge',
 'Find the REAL roots of (5x² + 20)(3x² - 48) = 0.', 3,
 '[
   {"text": "x = 4, -4, 2 and -2", "feedback": "The first bracket gives x² = -4, and no real number squares to a negative."},
   {"text": "x = 4 and no other value", "feedback": "x² = 16 has two solutions, one on each side of zero."},
   {"text": "There are no real roots", "feedback": "The first bracket has none, but the second gives x² = 16, which is perfectly solvable."},
   {"text": "x = 4 and x = -4", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'solving-polynomial-equations', 7, 'Challenge',
 'Find the real solutions of x⁵ - 4x³ - x² + 4 = 0.', 2,
 '[
   {"text": "x = 2 and x = -2 only", "feedback": "The second grouped factor x³ - 1 also contributes a real root."},
   {"text": "x = 1 and no other value", "feedback": "The first grouped factor x² - 4 supplies two more real roots."},
   {"text": "x = 2, -2 and 1", "feedback": "Correct."},
   {"text": "x = 2, -2, 1 and -1", "feedback": "Grouping leaves x² - 4 and x³ - 1. The cubic factor has only ONE real root, and -1 is not it."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'solving-polynomial-equations', 8, 'Advanced',
 'A family of cubics has roots -2, -3 and -5. The member passing through
(2, -35) has what y-intercept?', 2,
 '[
   {"text": "-30", "feedback": "That is the product of the three roots themselves, not the value of the brackets at x = 0, and no k has been applied."},
   {"text": "-1/4", "feedback": "-1/4 is k itself. The y-intercept is k times the product of the brackets at x = 0."},
   {"text": "-15/2", "feedback": "Correct."},
   {"text": "15/2", "feedback": "k comes out negative, and the three brackets at x = 0 give a positive 30, so the intercept lands below the axis."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'solving-polynomial-equations', 9, 'Advanced',
 'A cubic touches the x-axis at -2, crosses it at 1, and has a y-intercept
of 12. Write its equation.', 2,
 '[
   {"text": "f(x) = -3(x - 2)²(x + 1)", "feedback": "Both signs are flipped. Touching at -2 comes from the bracket x + 2."},
   {"text": "f(x) = -12(x + 2)²(x - 1)", "feedback": "12 is the y-intercept, not k. Substitute x = 0 and solve for k rather than reading it off."},
   {"text": "f(x) = -3(x + 2)²(x - 1)", "feedback": "Correct."},
   {"text": "f(x) = 3(x + 2)²(x - 1)", "feedback": "At x = 0 the brackets give 4 times -1, which is -4, so k has to be negative to land on a positive 12."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'average-rate-of-change', 1, 'Easy',
 'What is the average rate of change of   f(x) = x²   from x = 1 to x = 4?', 1,
 '[
   {"text": "15", "feedback": "That is the change in y only. A rate also needs dividing by the change in x."},
   {"text": "5", "feedback": "Correct. (16 − 1)/(4 − 1) = 15/3 = 5."},
   {"text": "3", "feedback": "That is the change in x, the denominator of the calculation, rather than the whole rate."},
   {"text": "8", "feedback": "This looks like a rate at a single endpoint rather than the average across the whole interval."}
 ]'::jsonb,
 'average-rate-of-change'),
('MHF4U', 'rates-of-change', 'average-rate-of-change', 2, 'Easy',
 'The average rate of change between two points on a curve is the slope of what?', 3,
 '[
   {"text": "The curve at its steepest point", "feedback": "The average takes no notice of what happens in between. It depends only on the two endpoints."},
   {"text": "The horizontal x-axis of the graph", "feedback": "The axis has a slope of zero, which would make every average rate of change zero."},
   {"text": "The tangent line at one of them", "feedback": "A tangent touches at a single point and gives the INSTANTANEOUS rate. An average needs two points."},
   {"text": "The secant line joining them", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'average-rate-of-change', 3, 'Easy',
 'A tire loses pressure from 400 kPa to 170 kPa over 30 minutes.
What is the average rate of change?', 1,
 '[
   {"text": "-0.13 kPa per minute", "feedback": "The fraction is upside down. The change in pressure goes on top and the change in time underneath."},
   {"text": "-7.67 kPa per minute", "feedback": "Correct."},
   {"text": "7.67 kPa per minute", "feedback": "The pressure is falling, so the rate has to be negative. The change in y is 170 take away 400."},
   {"text": "-230 kPa per minute", "feedback": "That is the total CHANGE in pressure. A rate divides it by the time it took."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'average-rate-of-change', 4, 'Medium',
 'What is the average rate of change of   f(x) = 2ˣ   from x = 0 to x = 3?', 2,
 '[
   {"text": "8", "feedback": "That is f(3) on its own. The starting value and the width of the interval still have to be used."},
   {"text": "7", "feedback": "That is the rise. Dividing by the run of 3 completes the calculation."},
   {"text": "7/3", "feedback": "Correct. (8 − 1)/(3 − 0) = 7/3."},
   {"text": "3", "feedback": "That is the run, the denominator, rather than the full ratio."}
 ]'::jsonb,
 'average-rate-of-change'),
('MHF4U', 'rates-of-change', 'average-rate-of-change', 5, 'Medium',
 'For f(x) = x² - 3x + 2, find the average rate of change on -1 ≤ x ≤ 2.', 3,
 '[
   {"text": "2", "feedback": "f(2) is 0 and f(-1) is 6, so the change on top is negative."},
   {"text": "-6", "feedback": "That is the total change in f. A rate divides it by the width of the interval, which is 3."},
   {"text": "6", "feedback": "That is the size of the change with the wrong sign, and it has not been divided by the interval width."},
   {"text": "-2", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'average-rate-of-change', 6, 'Medium',
 'For f(x) = x² - 3x + 2, find the average rate of change on 4 ≤ x ≤ 8.', 1,
 '[
   {"text": "4", "feedback": "4 is the width of the interval, which belongs underneath the fraction rather than being the answer."},
   {"text": "9", "feedback": "Correct."},
   {"text": "12", "feedback": "That ADDS the two function values instead of subtracting them. The top of the fraction has to be a difference."},
   {"text": "36", "feedback": "That is the total change in f. It still has to be divided by the width of the interval."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'average-rate-of-change', 7, 'Hard',
 'An object moves so that its position in metres is s(t) = t² − 4t, with t in seconds.
What is its average velocity from t = 1 to t = 3?', 0,
 '[
   {"text": "0 m/s", "feedback": "Correct. s(1) = −3 and s(3) = −3, so the displacement across the interval is zero even though the object moved."},
   {"text": "−3 m/s", "feedback": "That is the position at each endpoint, not the change between them."},
   {"text": "2 m/s", "feedback": "This is the width of the time interval rather than a velocity."},
   {"text": "−6 m/s", "feedback": "The two position values have been added rather than subtracted."}
 ]'::jsonb,
 'displacement-vs-distance'),
('MHF4U', 'rates-of-change', 'average-rate-of-change', 8, 'Challenge',
 'For f(x) = x² - 3x + 2, on which interval is the average rate of change ZERO?', 1,
 '[
   {"text": "2 ≤ x ≤ 4", "feedback": "f(2) is 0 and f(4) is 6, so the average rate is +3."},
   {"text": "0 ≤ x ≤ 3", "feedback": "Correct."},
   {"text": "0 ≤ x ≤ 2", "feedback": "f(0) is 2 and f(2) is 0, so the average rate is -1."},
   {"text": "1 ≤ x ≤ 3", "feedback": "f(1) is 0 and f(3) is 2, so the average rate is +1."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'average-rate-of-change', 9, 'Challenge',
 'An oven reads 290 °C at 13 minutes and 280 °C at 15 minutes.
What is the average rate of change over that interval?', 1,
 '[
   {"text": "-0.2 °C per minute", "feedback": "The fraction is upside down. The change in temperature goes on top and the change in time underneath."},
   {"text": "-5 °C per minute", "feedback": "Correct."},
   {"text": "5 °C per minute", "feedback": "The temperature fell over this interval, so the rate is negative."},
   {"text": "-10 °C per minute", "feedback": "That is the total change. It still has to be divided by the 2 minutes it took."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'average-rate-of-change', 10, 'Advanced',
 'For f(x) = x² - 3x + 2, find the value of b for which the average rate of
change on 1 ≤ x ≤ b is exactly 4.', 3,
 '[
   {"text": "b = 4", "feedback": "4 is the target rate copied straight into the answer. It is the value the average rate has to reach, not the endpoint that makes it happen."},
   {"text": "b = 5", "feedback": "At b = 5 the average rate is 3. One more unit is needed."},
   {"text": "b = 3", "feedback": "At b = 3 the average rate is 1, which is well short."},
   {"text": "b = 6", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'average-rate-of-change', 11, 'Advanced',
 'A function is never constant on an interval, yet its average rate of change
over that interval is zero. How is that possible?', 1,
 '[
   {"text": "The interval must have zero width", "feedback": "A zero-width interval makes the rate undefined rather than zero, because the denominator vanishes."},
   {"text": "The function can wander away and come back to the same value at the far end", "feedback": "Correct."},
   {"text": "The slope must be zero everywhere on the interval", "feedback": "That would make the function constant, which is exactly what is ruled out."},
   {"text": "The function has to be constant, so the situation cannot arise", "feedback": "The average depends only on the two ENDPOINTS. Everything in between is invisible to it."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'combining-functions', 1, 'Easy',
 'If   f(x) = x²   and   g(x) = 3x − 1,   find   (f + g)(2).', 3,
 '[
   {"text": "20", "feedback": "This multiplies the two results instead of adding them."},
   {"text": "4", "feedback": "That is only f(2). The second function still has to be evaluated and added on."},
   {"text": "5", "feedback": "That is only g(2). The value of the first function has to be added as well."},
   {"text": "9", "feedback": "Correct. f(2) = 4 and g(2) = 5, so the sum is 9."}
 ]'::jsonb,
 'adds-vs-multiplies-functions'),
('MHF4U', 'rational-functions', 'combining-functions', 2, 'Easy',
 'Given f(x) = 3x + 1 and g(x) = x^2 - 4.
What is (f + g)(x)?', 1,
 '[
   {"text": "x^2 - 3x - 3", "feedback": "The 3x lost its sign along the way. Nothing here is being subtracted."},
   {"text": "x^2 + 3x - 3", "feedback": "Correct."},
   {"text": "x^2 + 3x + 5", "feedback": "The two constants were combined as 1 plus 4. The constant in g is negative four."},
   {"text": "x^2 + 3x - 4", "feedback": "The constant from f was dropped. Both constants have to be collected."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'combining-functions', 3, 'Easy',
 'Given f(x) = 3x + 1 and g(x) = x^2 - 4.
What is (f - g)(x)?', 1,
 '[
   {"text": "-x^2 - 3x + 5", "feedback": "The 3x belongs to f, not g, so it is not affected by the subtraction at all."},
   {"text": "-x^2 + 3x + 5", "feedback": "Correct."},
   {"text": "-x^2 + 3x - 3", "feedback": "The subtraction was not distributed to the second term of g. Taking away negative four adds four."},
   {"text": "x^2 + 3x + 5", "feedback": "The x squared kept its sign. Subtracting g flips the sign of every term in g."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'combining-functions', 4, 'Medium',
 'If   f(x) = √x   and   g(x) = x − 4,   what is the domain of   (f + g)(x) ?', 1,
 '[
   {"text": "All real numbers", "feedback": "One of the two functions has a restricted domain, and the sum inherits that restriction."},
   {"text": "x ≥ 0", "feedback": "Correct. The square root needs a nonnegative input and the linear part accepts everything, so the overlap is x ≥ 0."},
   {"text": "x ≥ 4", "feedback": "The 4 comes from the linear function, which places no restriction of its own."},
   {"text": "x ≠ 0", "feedback": "Zero is perfectly acceptable under a square root. The restriction is about negative inputs."}
 ]'::jsonb,
 'combined-domain-restriction'),
('MHF4U', 'rational-functions', 'combining-functions', 5, 'Medium',
 'If   f(x) = x² + 2x   and   g(x) = x² − 5,   find   (f − g)(x).', 3,
 '[
   {"text": "2x − 5", "feedback": "The minus sign has to be distributed across both terms of the second function."},
   {"text": "2x² + 2x − 5", "feedback": "The two x² terms are being added. One is subtracted from the other, so look again at what they leave behind."},
   {"text": "2x² + 2x + 5", "feedback": "The sign on the constant is handled correctly, but check what happens to the two x² terms under subtraction."},
   {"text": "2x + 5", "feedback": "Correct. The x² terms cancel, and subtracting −5 gives +5."}
 ]'::jsonb,
 'subtract-distribute-sign'),
('MHF4U', 'rational-functions', 'combining-functions', 6, 'Medium',
 'Given f(x) = x + 3 and g(x) = x^2 + 8x + 15.
Write (f / g)(x) in simplest form.', 3,
 '[
   {"text": "x + 5", "feedback": "The fraction was turned upside down. The common factor cancels out of the top, leaving 1 there."},
   {"text": "1 / (x + 3)", "feedback": "The wrong factor was cancelled. Factor g fully first and see which bracket it shares with f."},
   {"text": "(x + 3) / (x + 5)", "feedback": "The shared bracket was cancelled from the bottom but left on the top."},
   {"text": "1 / (x + 5)", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'combining-functions', 7, 'Medium',
 'Given f(x) = x + 3 and g(x) = x^2 + 8x + 15.
Expand (f x g)(x).', 3,
 '[
   {"text": "x^2 + 9x + 18", "feedback": "The functions were added rather than multiplied. The product of a linear and a quadratic is cubic."},
   {"text": "x^3 + 8x^2 + 15x", "feedback": "Only the x from f was distributed. The 3 has to multiply every term as well."},
   {"text": "x^3 + 11x^2 + 24x + 45", "feedback": "One of the x terms was missed when collecting. Two separate products land on the plain x term."},
   {"text": "x^3 + 11x^2 + 39x + 45", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'combining-functions', 8, 'Challenge',
 'Let f(x) = sqrt(x - 2) and g(x) = 1 / (x - 5).
What is the domain of (f + g)(x)?', 2,
 '[
   {"text": "x not equal to 5", "feedback": "Only the fraction was considered. A square root cannot take a negative input, which rules out a whole stretch of the line."},
   {"text": "x > 2, x not equal to 5", "feedback": "The endpoint was excluded without cause. A square root of zero is perfectly well defined."},
   {"text": "x >= 2, x not equal to 5", "feedback": "Correct."},
   {"text": "x >= 2", "feedback": "Only the root was considered. The domain of a sum is the OVERLAP of both domains, and g has a restriction too."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'combining-functions', 9, 'Challenge',
 'Let f(x) = 2^x and g(x) = x^2.
Evaluate (f x g)(3).', 2,
 '[
   {"text": "64", "feedback": "The functions were composed the other way round. Multiplication evaluates each at 3 first, then multiplies."},
   {"text": "36", "feedback": "The bases were multiplied and then squared. Each function must be evaluated separately before the two results meet."},
   {"text": "72", "feedback": "Correct."},
   {"text": "512", "feedback": "The functions were composed rather than multiplied. That is f of g of 3, not f times g at 3."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'combining-functions', 10, 'Advanced',
 'Let f(x) = x^2 - 1 and g(x) = x + 1.
Describe the graph of (f / g)(x).', 1,
 '[
   {"text": "The line y = x + 1 with a hole at (-1, 0)", "feedback": "The wrong factor was cancelled. Factor the top as a difference of squares and see which bracket matches the bottom."},
   {"text": "The line y = x - 1 with a hole at (-1, -2)", "feedback": "Correct."},
   {"text": "The line y = x - 1 with no hole", "feedback": "The simplification is right but the restriction was forgotten. Cancelling a factor removes a point from the graph; it does not fill it in."},
   {"text": "The line y = x - 1 with a vertical asymptote at x = -1", "feedback": "The factor cancelled, so the bottom is not the only place that vanishes there. A shared factor gives a hole, not an asymptote."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'combining-functions', 11, 'Advanced',
 'Let f(x) = sqrt(x + 3) and g(x) = sqrt(5 - x).
What is the domain of (f x g)(x)?', 1,
 '[
   {"text": "-5 <= x <= 3", "feedback": "The two numbers were read straight off the expressions. Set each radicand greater than or equal to zero and solve."},
   {"text": "-3 <= x <= 5", "feedback": "Correct."},
   {"text": "x >= -3", "feedback": "Only f was considered. The domain of a product is the overlap of both, and g fails once x passes 5."},
   {"text": "x <= 5", "feedback": "Only g was considered. The domain of a product is the overlap of both, and f fails below negative 3."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'composite-functions', 1, 'Easy',
 'If   f(x) = x + 3   and   g(x) = 2x,   find   f(g(x)).', 2,
 '[
   {"text": "2x + 6", "feedback": "This applies the doubling last instead of first, which is the other order of composition."},
   {"text": "2x² + 3", "feedback": "No squaring happens here, since neither function contains an x²."},
   {"text": "2x + 3", "feedback": "Correct. g acts first and gives 2x, then f adds 3 to that."},
   {"text": "x + 6", "feedback": "Check which function is applied first. The inner one multiplies before the addition happens."}
 ]'::jsonb,
 'composition-order'),
('MHF4U', 'rational-functions', 'composite-functions', 2, 'Easy',
 'Given f(x) = x^2 and g(x) = x + 3.
What is (f o g)(x)?', 0,
 '[
   {"text": "x^2 + 6x + 9", "feedback": "Correct."},
   {"text": "x^2 + 3", "feedback": "That is g of f, not f of g. The inner function is the one substituted in."},
   {"text": "x^2 + 9", "feedback": "The bracket was expanded by squaring each term separately. A binomial squared has a middle term."},
   {"text": "x^2 + 6x + 3", "feedback": "The middle term is right but the last one is not. The 3 gets squared too."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'composite-functions', 3, 'Easy',
 'Let u(x) = 2x - 1 and v(x) = x + 4.
What is v(u(3))?', 1,
 '[
   {"text": "7", "feedback": "That is v of 3. The inner function was skipped entirely."},
   {"text": "9", "feedback": "Correct."},
   {"text": "13", "feedback": "The functions were applied in the wrong order. The one written inside the brackets goes first."},
   {"text": "5", "feedback": "That is u of 3. The outer function still has to be applied to it."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'composite-functions', 4, 'Medium',
 'Given f(x) = x^2 and g(x) = x + 3.
What is (g o f)(x)?', 1,
 '[
   {"text": "x^3 + 3x^2", "feedback": "The functions were multiplied instead of composed. Composition substitutes; it does not multiply."},
   {"text": "x^2 + 3", "feedback": "Correct."},
   {"text": "x^2 + 6x + 9", "feedback": "The order was reversed. Here f is the inner function, so f goes into g."},
   {"text": "x^2 + 9", "feedback": "Two errors: the order was reversed and the binomial was squared term by term."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'composite-functions', 5, 'Medium',
 'Let u(x) = x^2 + 3x + 2 and w(x) = 1 / (x - 1).
Evaluate (u o w)(2).', 0,
 '[
   {"text": "6", "feedback": "Correct."},
   {"text": "1/11", "feedback": "The order was reversed. w is the inner function here, so it is evaluated at 2 first."},
   {"text": "3/4", "feedback": "The whole denominator was not kept together. w of 2 is 1 divided by the quantity 2 take away 1."},
   {"text": "12", "feedback": "That is u of 2. The inner function w was skipped."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'composite-functions', 6, 'Hard',
 'If   f(x) = x²   and   g(x) = x − 3,   find   (f ∘ g)(5).', 2,
 '[
   {"text": "22", "feedback": "This applies the functions in the opposite order, squaring 5 first and then subtracting 3."},
   {"text": "25", "feedback": "This squares 5 and stops. The inner function has to act on the 5 first."},
   {"text": "4", "feedback": "Correct. g(5) = 2, and squaring that gives 4."},
   {"text": "2", "feedback": "That is the value of g(5). The outer squaring step is still to come."}
 ]'::jsonb,
 'composition-order'),
('MHF4U', 'rational-functions', 'composite-functions', 7, 'Challenge',
 'Let f(x) = sqrt(x) and g(x) = x - 7.
What is the domain of (f o g)(x)?', 3,
 '[
   {"text": "x >= 0", "feedback": "That is the domain of f on its own. The inner function has to land inside that domain, which shifts the boundary."},
   {"text": "x >= -7", "feedback": "The shift went the wrong way. Set x take away 7 greater than or equal to zero and solve."},
   {"text": "All real numbers", "feedback": "The square root still cannot take a negative input after the substitution."},
   {"text": "x >= 7", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'composite-functions', 8, 'Challenge',
 'The rabbits in a reserve are modelled by R(t) = 50cos(t) + 100, with t in years.
The wolves are modelled by W(t) = 0.2[R(t - 2)].
Find the full equation for W(t).', 3,
 '[
   {"text": "W(t) = 10cos(t) - 2 + 20", "feedback": "The 2 was subtracted after the function was applied. Inside the square brackets it replaces the input of R."},
   {"text": "W(t) = 50cos(t - 2) + 20", "feedback": "The 0.2 was applied to the constant only. It multiplies every term of R, amplitude included."},
   {"text": "W(t) = 10cos(t - 2) + 100", "feedback": "The 0.2 was applied to the amplitude only. It multiplies the vertical shift as well."},
   {"text": "W(t) = 10cos(t - 2) + 20", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'composite-functions', 9, 'Advanced',
 'Let f(x) = 1 / (x - 2) and g(x) = 3 / x.
Simplify (f o g)(x).', 2,
 '[
   {"text": "3 / (x - 2)", "feedback": "Only the 3 from g was carried across onto the top of f. The x in the denominator of f was never replaced."},
   {"text": "1 / (3x - 2)", "feedback": "The x was moved into the wrong place. Substitute 3 over x for x, then clear the fraction inside the fraction."},
   {"text": "x / (3 - 2x)", "feedback": "Correct."},
   {"text": "(3 - 2x) / x", "feedback": "The complex fraction was left upside down. After combining the bottom over a common denominator, the whole thing flips."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'composite-functions', 10, 'Advanced',
 'Let f(x) = 2x + 5 and suppose (f o g)(x) = 6x - 1.
Find g(x).', 3,
 '[
   {"text": "g(x) = 3x + 2", "feedback": "The 5 was added instead of subtracted when it was moved across. It is already on the left, so it comes off."},
   {"text": "g(x) = 6x - 6", "feedback": "The 5 was handled correctly but the division by 2 was never carried out."},
   {"text": "g(x) = 12x + 3", "feedback": "f was applied to 6x take away 1. That gives f of the composite, not the inner function."},
   {"text": "g(x) = 3x - 3", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'instantaneous-rate-of-change', 1, 'Easy',
 'The instantaneous rate of change at a point is the slope of what?', 2,
 '[
   {"text": "The chord joining the endpoints of the graph", "feedback": "That is the average rate over the whole domain, which says nothing about one particular moment."},
   {"text": "The horizontal x-axis at that point", "feedback": "The axis is a fixed horizontal line and has nothing to do with the curve."},
   {"text": "The tangent line at that point", "feedback": "Correct."},
   {"text": "The secant line through two points", "feedback": "A secant gives the AVERAGE rate over an interval. Shrinking that interval to nothing is what produces the tangent."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'instantaneous-rate-of-change', 2, 'Easy',
 'How do you ESTIMATE an instantaneous rate of change from a table of values?', 2,
 '[
   {"text": "Use the first two values in the table", "feedback": "Those give a rate near the START, which is only useful if the point of interest happens to be there."},
   {"text": "Average every value in the table", "feedback": "Averaging the VALUES gives a typical height, not a rate. A rate needs a change divided by a change."},
   {"text": "Use a small interval surrounding the point", "feedback": "Correct."},
   {"text": "Use the whole interval the table covers", "feedback": "That gives the average over everything, which can be nowhere near the rate at one particular moment."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'instantaneous-rate-of-change', 3, 'Medium',
 'What does the slope of a tangent line to a curve at a point represent?', 0,
 '[
   {"text": "The instantaneous rate of change at that point", "feedback": "Correct. A tangent touches the curve at a single point, and its slope gives the rate of change right there."},
   {"text": "The average rate of change over an interval", "feedback": "That is the slope of a secant line joining two separate points, not a line touching at one."},
   {"text": "The total change in y", "feedback": "A slope is a ratio of two changes, not a single change on its own."},
   {"text": "The area underneath the curve", "feedback": "Area is a different measurement entirely and is not given by a slope."}
 ]'::jsonb,
 'tangent-vs-secant'),
('MHF4U', 'rates-of-change', 'instantaneous-rate-of-change', 4, 'Medium',
 'A tire reads 400 kPa at 0 min, 335 kPa at 5 min and 295 kPa at 10 min.
Estimate the instantaneous rate at 5 minutes using the surrounding interval.', 3,
 '[
   {"text": "-13 kPa per minute", "feedback": "That uses only the interval from 0 to 5. A surrounding interval takes one reading on each side of the point."},
   {"text": "-8 kPa per minute", "feedback": "That uses only the interval from 5 to 10. A surrounding interval straddles the point."},
   {"text": "-105 kPa per minute", "feedback": "That is the total change in pressure across the interval. It still has to be divided by the 10 minutes it took."},
   {"text": "-10.5 kPa per minute", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'instantaneous-rate-of-change', 5, 'Medium',
 'A vole is at 0 m at 0 s, 2 m at 2 s and 8 m at 4 s. Estimate its speed at
2 seconds by averaging the two surrounding secant slopes.', 1,
 '[
   {"text": "4 m/s", "feedback": "That ADDS the two secant slopes. Averaging them means halving the total."},
   {"text": "2 m/s", "feedback": "Correct."},
   {"text": "1 m/s", "feedback": "That is the secant over the first interval alone. The second interval has to be averaged in with it."},
   {"text": "3 m/s", "feedback": "That is the secant over the second interval alone. The first interval has to be averaged in with it."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'instantaneous-rate-of-change', 6, 'Challenge',
 'An oven reads 205 °C at 8 minutes, 250 °C at 10 minutes and 290 °C at
13 minutes. Estimate the instantaneous rate at 10 minutes using the
surrounding interval.', 2,
 '[
   {"text": "13.3 °C per minute", "feedback": "That uses only the interval from 10 to 13. A surrounding interval straddles the point."},
   {"text": "45 °C per minute", "feedback": "45 is a change in temperature, not a rate. It still has to be divided by the time it took."},
   {"text": "17 °C per minute", "feedback": "Correct."},
   {"text": "22.5 °C per minute", "feedback": "That uses only the interval from 8 to 10. A surrounding interval takes one reading on each side."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'instantaneous-rate-of-change', 7, 'Challenge',
 'An oven reads 205 °C at 8 minutes, 250 °C at 10 minutes and 290 °C at
13 minutes. Estimate the rate at 10 minutes by averaging the preceding
interval [8, 10] and the following interval [10, 13].', 3,
 '[
   {"text": "17.0 °C per minute", "feedback": "That is the surrounding-interval estimate, which uses 8 and 13 directly. Averaging the two separate secants gives a slightly different number."},
   {"text": "35.8 °C per minute", "feedback": "That ADDS the two secant slopes. Averaging them means halving the total."},
   {"text": "9.0 °C per minute", "feedback": "That halves the answer a second time. The two slopes are added once and halved once."},
   {"text": "17.9 °C per minute", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'instantaneous-rate-of-change', 8, 'Advanced',
 'Why does averaging the preceding and the following secant usually beat
using just one of them?', 2,
 '[
   {"text": "It needs fewer data points", "feedback": "It needs one more, not fewer. The gain is in accuracy rather than effort."},
   {"text": "The tangent slope is the sum of the two secant slopes", "feedback": "It sits BETWEEN them, which is why they are averaged rather than added."},
   {"text": "The two secants err in opposite directions, so their average lands closer", "feedback": "Correct."},
   {"text": "A single secant always over-estimates the rate", "feedback": "It over-estimates on one side and under-estimates on the other, which is precisely why the pair is useful."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'instantaneous-rate-of-change', 9, 'Advanced',
 'A secant over [2, 2.001] has slope 1.001, and over [2, 2.0001] it has
slope 1.0001. What does this suggest about the rate at x = 2?', 0,
 '[
   {"text": "It is exactly 1", "feedback": "Correct."},
   {"text": "It is exactly 1.001", "feedback": "That is one of the estimates, and the next one is already closer to a rounder number. Follow where the sequence is heading."},
   {"text": "It is exactly 0.001", "feedback": "0.001 is the width of the interval, not the slope."},
   {"text": "It cannot be found from estimates like these", "feedback": "The whole point of shrinking the interval is that the estimates close in on the exact value."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'interpreting-a-rate-of-change', 1, 'Easy',
 'A tire pressure in kilopascals is measured against time in minutes.
What units does its rate of change carry?', 3,
 '[
   {"text": "Kilopascals on their own", "feedback": "Those are the units of the pressure itself. A rate carries the units of both quantities."},
   {"text": "Minutes of elapsed time", "feedback": "Those are the units of the time. A rate divides one quantity by the other, so both appear."},
   {"text": "Kilopascals times minutes", "feedback": "A rate DIVIDES, so the time unit ends up underneath rather than multiplied in."},
   {"text": "Kilopascals per minute", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'interpreting-a-rate-of-change', 2, 'Easy',
 'What does a negative rate of change tell you about a quantity?', 1,
 '[
   {"text": "It is undefined", "feedback": "A negative number is a perfectly ordinary answer. It only means the quantity is heading downward."},
   {"text": "It is decreasing", "feedback": "Correct."},
   {"text": "It is increasing", "feedback": "A rising quantity has a positive change on top of the fraction, so its rate is positive."},
   {"text": "It is constant", "feedback": "A constant quantity has a change of zero, so its rate is zero rather than negative."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'interpreting-a-rate-of-change', 3, 'Medium',
 'A vole is 8 m from its burrow at 4 s and 10 m at 12 s.
What is its average speed over that interval?', 1,
 '[
   {"text": "4 m/s", "feedback": "That divides the time by the distance, which turns the units upside down."},
   {"text": "0.25 m/s", "feedback": "Correct."},
   {"text": "0.125 m/s", "feedback": "That divides by 16 rather than by 8. The interval runs from 4 to 12, which is 8 seconds."},
   {"text": "2 m/s", "feedback": "2 m is the total DISTANCE covered. A speed divides it by the time it took."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'interpreting-a-rate-of-change', 4, 'Medium',
 'A wood-fired oven is at 25 °C at 0 minutes and 285 °C at 25 minutes.
What is the average rate of change of temperature?', 0,
 '[
   {"text": "10.4 °C per minute", "feedback": "Correct."},
   {"text": "11.4 °C per minute", "feedback": "That divides 285 by 25 and forgets to subtract the starting temperature."},
   {"text": "260 °C per minute", "feedback": "That is the total change in temperature. A rate divides it by the time it took."},
   {"text": "0.096 °C per minute", "feedback": "The fraction is upside down. The change in temperature goes on top."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'interpreting-a-rate-of-change', 5, 'Hard',
 'Which function grows the fastest for very large values of x?', 1,
 '[
   {"text": "y = x²", "feedback": "A polynomial is eventually overtaken by exponential growth, no matter how large its degree."},
   {"text": "y = 2ˣ", "feedback": "Correct. Exponential growth eventually outpaces any polynomial or logarithmic function."},
   {"text": "y = 100x", "feedback": "A big coefficient wins early, but the growth stays linear, so faster-curving functions catch up."},
   {"text": "y = log x", "feedback": "Logarithms grow more slowly than everything else on this list."}
 ]'::jsonb,
 'growth-rate-comparison'),
('MHF4U', 'rates-of-change', 'interpreting-a-rate-of-change', 6, 'Challenge',
 'The secant slopes over the intervals [2, 2.5], [2, 2.1], [2, 2.01] and
[2, 2.001] come to 1.5, 1.1, 1.01 and 1.001. What is the instantaneous
rate at x = 2?', 0,
 '[
   {"text": "1", "feedback": "Correct."},
   {"text": "1.001", "feedback": "That is the last estimate in the list, not the value they are heading toward. The pattern is still closing in."},
   {"text": "1.5", "feedback": "That is the first and crudest estimate, taken over the widest interval."},
   {"text": "0", "feedback": "The slopes are settling on a clear positive value, and none of them is anywhere near zero."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'interpreting-a-rate-of-change', 7, 'Challenge',
 'A vole bolts from a hawk, running hard at first and gradually slowing to
a stop. What does its distance-time graph look like?', 0,
 '[
   {"text": "Steep at first, then flattening out", "feedback": "Correct."},
   {"text": "Straight, with a constant slope", "feedback": "A constant slope means a constant speed. This vole slows down, so the slope has to change."},
   {"text": "Flat at first, then getting steeper", "feedback": "That describes something SPEEDING UP. The steep part comes first when the fastest running does."},
   {"text": "Falling as time goes on", "feedback": "A falling distance graph means moving back toward the burrow. The vole keeps going, just more slowly."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'interpreting-a-rate-of-change', 8, 'Advanced',
 'An oven has an average rate of change of +10.4 °C per minute over 25
minutes, yet its instantaneous rate at 21 minutes is negative.
What does that mean?', 2,
 '[
   {"text": "The temperature never actually fell", "feedback": "A negative instantaneous rate is exactly a moment when the temperature was falling."},
   {"text": "The units must have been mixed up", "feedback": "Both figures are in degrees per minute. The two simply describe different things: a whole span and a single moment."},
   {"text": "It cooled for part of the time, even though it finished hotter than it started", "feedback": "Correct."},
   {"text": "One of the two calculations must be wrong", "feedback": "Both can be right at once. The average sees only the endpoints and is blind to everything in between."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'interpreting-a-rate-of-change', 9, 'Advanced',
 'A car position function has a rate of change of zero at t = 5 seconds,
and a positive rate both just before and just after. What is happening?', 3,
 '[
   {"text": "The car reverses", "feedback": "Reversing needs the rate to turn NEGATIVE. Here it only touches zero before climbing back."},
   {"text": "The car stops for good", "feedback": "Stopping for good would keep the rate at zero from then on, and here it is positive again straight after."},
   {"text": "The car is at its fastest", "feedback": "A zero rate is the slowest the car gets, not the fastest."},
   {"text": "The car pauses for an instant and then carries on forward", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'reciprocal-of-a-linear-or-quadratic-function', 1, 'Easy',
 'Where is the vertical asymptote of   f(x) = 1 / (x + 4) ?', 2,
 '[
   {"text": "x = 4", "feedback": "The sign has been read straight from the bracket. Set the denominator equal to zero and solve it."},
   {"text": "y = 4", "feedback": "This describes a horizontal line. A vertical asymptote is written as x equals a number."},
   {"text": "x = −4", "feedback": "Correct. The denominator x + 4 is zero when x = −4, so the function is undefined there."},
   {"text": "x = 0", "feedback": "At x = 0 the denominator is 4, which is perfectly fine, so the function is defined there."}
 ]'::jsonb,
 'vertical-asymptote-sign'),
('MHF4U', 'rational-functions', 'reciprocal-of-a-linear-or-quadratic-function', 2, 'Easy',
 'What is the horizontal asymptote of   f(x) = 2x / (x² + 1) ?', 1,
 '[
   {"text": "y = 2", "feedback": "Comparing leading coefficients only works when the two degrees are equal. Compare the degrees first."},
   {"text": "y = 0", "feedback": "Correct. The denominator grows much faster than the numerator, so the fraction shrinks toward zero."},
   {"text": "y = 1", "feedback": "This uses the constant in the denominator rather than comparing the degrees of the two polynomials."},
   {"text": "There is no horizontal asymptote", "feedback": "That happens when the numerator has the higher degree. Here it is lower, which does give an asymptote."}
 ]'::jsonb,
 'horizontal-asymptote-degrees'),
('MHF4U', 'rational-functions', 'reciprocal-of-a-linear-or-quadratic-function', 3, 'Easy',
 'What is the equation of the vertical asymptote of y = 1 / (x - 5)?', 2,
 '[
   {"text": "y = 5", "feedback": "A vertical asymptote is a vertical line, so its equation starts with x, not y."},
   {"text": "x = 0", "feedback": "That is where the denominator equals -5, not 0. The asymptote sits where the denominator vanishes."},
   {"text": "x = 5", "feedback": "Correct."},
   {"text": "x = -5", "feedback": "The sign has been flipped. Set the denominator equal to zero and solve: x take away 5 equals 0."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'reciprocal-of-a-linear-or-quadratic-function', 4, 'Easy',
 'What is the equation of the horizontal asymptote of y = 1 / (2x + 7)?', 2,
 '[
   {"text": "y = 2", "feedback": "The 2 belongs to the denominator. It stretches the curve; it does not move the level it flattens out to."},
   {"text": "y = 7", "feedback": "The 7 shifts the vertical asymptote sideways. It has no effect on the height the curve settles at."},
   {"text": "y = 0", "feedback": "Correct."},
   {"text": "y = 1/2", "feedback": "That is the ratio of leading coefficients rule, which applies when the top and bottom have the SAME degree. Here the top is a constant."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'reciprocal-of-a-linear-or-quadratic-function', 5, 'Medium',
 'What feature does the graph of   f(x) = (x² − 9) / (x − 3)   have at x = 3?', 3,
 '[
   {"text": "A vertical asymptote", "feedback": "That happens when the factor stays in the denominator. Try factoring the numerator first and see what cancels."},
   {"text": "An x-intercept", "feedback": "An intercept needs the function value to be zero. Simplify the fraction and evaluate near this point."},
   {"text": "A horizontal asymptote", "feedback": "Horizontal asymptotes describe behaviour far out as x grows large, not what happens at one particular x-value."},
   {"text": "A hole", "feedback": "Correct. The numerator factors as (x − 3)(x + 3), so the common bracket cancels and leaves a single missing point."}
 ]'::jsonb,
 'hole-vs-asymptote'),
('MHF4U', 'rational-functions', 'reciprocal-of-a-linear-or-quadratic-function', 6, 'Medium',
 'What is the domain of   f(x) = (x + 1) / (x² − 4) ?', 0,
 '[
   {"text": "x ≠ 2 and x ≠ −2", "feedback": "Correct. The denominator factors as (x − 2)(x + 2), so both of those values make it zero."},
   {"text": "x ≠ 4", "feedback": "The 4 sits under a square. Factor the denominator before deciding what to exclude."},
   {"text": "x ≠ −1", "feedback": "That value makes the numerator zero, which produces an intercept rather than an exclusion."},
   {"text": "x ≠ 2 only", "feedback": "Squaring means two different values produce 4. Check the negative one as well."}
 ]'::jsonb,
 'domain-factor-denominator'),
('MHF4U', 'rational-functions', 'reciprocal-of-a-linear-or-quadratic-function', 7, 'Medium',
 'What are the vertical asymptotes of y = 1 / (x^2 - 9)?', 3,
 '[
   {"text": "x = 9 and x = -9", "feedback": "The square root was never taken. Solving x squared equals 9 gives 3, not 9."},
   {"text": "x = 3 and no others", "feedback": "A square has two square roots. The negative one makes the denominator zero just as well."},
   {"text": "There are no vertical asymptotes", "feedback": "x squared take away 9 does have real zeros. Factor it as a difference of squares."},
   {"text": "x = 3 and x = -3", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'reciprocal-of-a-linear-or-quadratic-function', 8, 'Medium',
 'How many vertical asymptotes does y = 1 / (x^2 + 4) have?', 0,
 '[
   {"text": "0", "feedback": "Correct."},
   {"text": "2", "feedback": "The 4 was treated as if it were negative. x squared plus 4 is never zero for a real x."},
   {"text": "1", "feedback": "A quadratic denominator gives either two asymptotes or none, never exactly one, unless it is a perfect square."},
   {"text": "4", "feedback": "The constant was counted as the number of asymptotes. The count comes from the real zeros of the denominator."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'reciprocal-of-a-linear-or-quadratic-function', 9, 'Hard',
 'What is the oblique (slant) asymptote of   f(x) = (x² + 1) / (x − 1) ?', 0,
 '[
   {"text": "y = x + 1", "feedback": "Correct. Long division gives x + 1 with a remainder of 2, and the remainder term fades away as x grows large."},
   {"text": "y = x", "feedback": "The division has stopped after the first term. Continue until the remainder has a lower degree than the divisor."},
   {"text": "y = 1", "feedback": "A horizontal asymptote needs the numerator degree to be no larger than the denominator degree. Here it is one higher."},
   {"text": "x = 1", "feedback": "That is the vertical asymptote from the denominator, not the slanted line the graph approaches."}
 ]'::jsonb,
 'oblique-asymptote-division'),
('MHF4U', 'rational-functions', 'reciprocal-of-a-linear-or-quadratic-function', 10, 'Hard',
 'For   f(x) = 1 / (x − 3),   what happens to y as x approaches 3 from the left?', 2,
 '[
   {"text": "y approaches 0", "feedback": "The denominator is shrinking toward zero, which makes the fraction grow without bound rather than shrink."},
   {"text": "y approaches +∞", "feedback": "That is the behaviour from the other side. Just to the left of 3, check the sign of the denominator."},
   {"text": "y approaches −∞", "feedback": "Correct. Just left of 3 the denominator is a tiny negative number, so the fraction is large and negative."},
   {"text": "y approaches 3", "feedback": "The value 3 is where x is heading, not where y goes. Substitute x = 2.9 and see what comes out."}
 ]'::jsonb,
 'one-sided-limit-sign'),
('MHF4U', 'rational-functions', 'reciprocal-of-a-linear-or-quadratic-function', 11, 'Challenge',
 'What are the vertical asymptotes of y = 1 / (x^2 - 2x - 15)?', 2,
 '[
   {"text": "x = 15 and x = -1", "feedback": "The numbers 15 and 1 were read off the expression. Factor the quadratic properly first."},
   {"text": "There are no vertical asymptotes", "feedback": "This quadratic does factor over the integers. Look for two numbers multiplying to negative 15 and adding to negative 2."},
   {"text": "x = 5 and x = -3", "feedback": "Correct."},
   {"text": "x = -5 and x = 3", "feedback": "The signs of the roots were taken straight from the brackets. A bracket of x take away 5 is zero at positive 5."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'reciprocal-of-a-linear-or-quadratic-function', 12, 'Challenge',
 'The function g(x) = x^2 - 4 has a minimum point at (0, -4).
What is the corresponding point on the graph of y = 1 / g(x)?', 3,
 '[
   {"text": "(0, -1/4), which is still a minimum", "feedback": "The height is right but the shape is not. Taking reciprocals turns a minimum into a maximum on that branch."},
   {"text": "(0, -4), which is a local maximum", "feedback": "The x-value stays put but the y-value does not. Every y-coordinate gets replaced by its reciprocal."},
   {"text": "(0, 1/4), which is a local maximum", "feedback": "The sign was lost. The reciprocal of a negative number is still negative."},
   {"text": "(0, -1/4), which is a local maximum", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'reciprocal-of-a-linear-or-quadratic-function', 13, 'Advanced',
 'What is the range of y = 2 / (x^2 - 6x + 9)?', 1,
 '[
   {"text": "y > 2", "feedback": "The 2 on top was read as a floor. The denominator can be large, which drives the whole fraction down towards zero."},
   {"text": "y > 0", "feedback": "Correct."},
   {"text": "y >= 0", "feedback": "Zero was included. A fraction with a non-zero top can get as close to zero as you like but never reaches it."},
   {"text": "y not equal to 0", "feedback": "That would allow negative outputs. Factor the denominator and notice it is a perfect square, so it is never negative."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'quotient-of-linear-functions', 1, 'Easy',
 'What is the horizontal asymptote of   f(x) = (3x + 1) / (x − 2) ?', 0,
 '[
   {"text": "y = 3", "feedback": "Correct. The degrees match, so the asymptote is the ratio of the leading coefficients, 3 over 1."},
   {"text": "y = 0", "feedback": "That happens when the denominator has the higher degree. Here the two degrees are the same."},
   {"text": "y = 2", "feedback": "That value breaks the denominator, which locates a vertical asymptote instead."},
   {"text": "y = −1/2", "feedback": "This uses the constant terms. Far from the origin the x terms dominate, so compare those instead."}
 ]'::jsonb,
 'horizontal-asymptote-degrees'),
('MHF4U', 'rational-functions', 'quotient-of-linear-functions', 2, 'Easy',
 'What is the equation of the vertical asymptote of f(x) = (x - 3) / (x + 2)?', 3,
 '[
   {"text": "x = 3", "feedback": "That is the zero of the NUMERATOR. A zero on top gives an x-intercept, not an asymptote."},
   {"text": "x = 2", "feedback": "The sign has been flipped. Solve x plus 2 equals 0."},
   {"text": "x = -3", "feedback": "Two errors at once: the numerator was used, and its sign was flipped as well."},
   {"text": "x = -2", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'quotient-of-linear-functions', 3, 'Easy',
 'What is the equation of the horizontal asymptote of f(x) = (2x - 3) / (x - 1)?', 1,
 '[
   {"text": "y = 0", "feedback": "That is the rule for when the bottom has a higher degree than the top. Here both are degree one."},
   {"text": "y = 2", "feedback": "Correct."},
   {"text": "y = 3", "feedback": "That is the ratio of the CONSTANT terms. The rule uses the coefficients of the highest power of x."},
   {"text": "y = 1", "feedback": "Only the bottom coefficient was used. The rule needs both, as a ratio."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'quotient-of-linear-functions', 4, 'Medium',
 'What is the x-intercept of   f(x) = (x − 5) / (x + 2) ?', 1,
 '[
   {"text": "x = −2", "feedback": "That value makes the denominator zero, so the function is undefined there rather than equal to zero."},
   {"text": "x = 5", "feedback": "Correct. A fraction equals zero only when its numerator is zero, and x − 5 = 0 at x = 5."},
   {"text": "x = −5", "feedback": "The sign has been read straight out of the bracket. Solve x − 5 = 0 instead."},
   {"text": "x = 2", "feedback": "This comes from the denominator with its sign flipped. Intercepts come from the numerator."}
 ]'::jsonb,
 'intercept-from-numerator'),
('MHF4U', 'rational-functions', 'quotient-of-linear-functions', 5, 'Medium',
 'What is the x-intercept of f(x) = (3x + 6) / (x - 4)?', 2,
 '[
   {"text": "x = 2", "feedback": "The sign was flipped. Solving 3x plus 6 equals 0 gives a negative value."},
   {"text": "x = -6", "feedback": "The coefficient 3 was ignored. Divide by it after moving the 6 across."},
   {"text": "x = -2", "feedback": "Correct."},
   {"text": "x = 4", "feedback": "That is the zero of the denominator, which is a vertical asymptote. A fraction is zero when its TOP is zero."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'quotient-of-linear-functions', 6, 'Medium',
 'What is the y-intercept of f(x) = (2x - 8) / (x + 4)?', 2,
 '[
   {"text": "-8", "feedback": "Only the numerator was evaluated. The denominator has to be evaluated at zero as well."},
   {"text": "4", "feedback": "That is the value of the denominator at zero. The intercept is the whole fraction."},
   {"text": "-2", "feedback": "Correct."},
   {"text": "2", "feedback": "The sign was dropped. Substituting zero gives negative eight over four."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'quotient-of-linear-functions', 7, 'Challenge',
 'The two branches of f(x) = (x - 3) / (x + 2) are equidistant from the point where its asymptotes cross. What are the coordinates of that point?', 0,
 '[
   {"text": "(-2, 1)", "feedback": "Correct."},
   {"text": "(2, -1)", "feedback": "Both signs were flipped. The vertical asymptote comes from solving x plus 2 equals zero."},
   {"text": "(-2, -3)", "feedback": "The vertical asymptote is right. The second coordinate has to come from the horizontal asymptote, which is set by the leading coefficients, not by the constant on top."},
   {"text": "(3, -2)", "feedback": "The two coordinates have been swapped and the numerator was used for the vertical asymptote."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'quotient-of-linear-functions', 8, 'Challenge',
 'What happens to the graph of f(x) = (x^2 - 9) / (x - 3) at x = 3?', 0,
 '[
   {"text": "There is a hole at (3, 6)", "feedback": "Correct."},
   {"text": "There is a vertical asymptote at x = 3", "feedback": "An asymptote needs the bottom to be zero while the top is NOT. Here the top is zero at 3 as well, so the factor cancels."},
   {"text": "There is a hole at (3, 0)", "feedback": "The position is right but the height is not. Cancel the common factor first, then substitute 3 into what is left."},
   {"text": "There is a hole at (3, 3)", "feedback": "The height was taken as the x-value. Substitute 3 into the simplified expression to find it."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'quotient-of-linear-functions', 9, 'Advanced',
 'Which function has a vertical asymptote at x = 4, a horizontal asymptote at y = 3, and an x-intercept at 2?', 0,
 '[
   {"text": "f(x) = 3(x - 2) / (x - 4)", "feedback": "Correct."},
   {"text": "f(x) = (3x - 2) / (x - 4)", "feedback": "The first two features are right but the third is not. Check where this numerator equals zero."},
   {"text": "f(x) = 3(x - 4) / (x - 2)", "feedback": "The two brackets have been swapped, so the asymptote and the intercept have traded places."},
   {"text": "f(x) = (x - 2) / (3x - 4)", "feedback": "The 3 was placed on the bottom, which changes both the horizontal asymptote and the vertical one."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'solving-rational-equations', 1, 'Easy',
 'Solve 4 / (3x - 5) = 4.', 1,
 '[
   {"text": "x = 5/3", "feedback": "That is the value that makes the denominator zero, so it is the one value x is not allowed to be."},
   {"text": "x = 2", "feedback": "Correct."},
   {"text": "x = 3", "feedback": "The denominator was set equal to 4 instead of to 1. Multiply both sides by the denominator first."},
   {"text": "x = 1/3", "feedback": "The 5 was left behind. Bring it across before dividing by 3."}
 ]'::jsonb,
 null);