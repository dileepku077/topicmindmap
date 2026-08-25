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


delete from public.questions where course_code = 'MTH1W';

insert into public.questions
  (course_code, unit_code, subtopic_code, sort_order, difficulty,
   prompt, correct_index, options, misconception_tag)
values
('MTH1W', 'algebraic-expressions', 'collecting-like-terms', 1, 'Easy',
 'Simplify:   3x + 5x − 2x', 0,
 '[
   {"text": "6x", "feedback": "Correct. The coefficients combine: 3 + 5 − 2 = 6."},
   {"text": "10x", "feedback": "It looks like all three were added. The last term is being subtracted."},
   {"text": "6x³", "feedback": "The exponent should not change. Adding like terms combines the numbers in front, not the powers."},
   {"text": "8x", "feedback": "This adds the first two but leaves out the −2x. All three terms need combining."}
 ]'::jsonb,
 'combines-unlike-terms'),
('MTH1W', 'algebraic-expressions', 'collecting-like-terms', 2, 'Easy',
 'Evaluate   3a − 2b   when a = 4 and b = 5.', 3,
 '[
   {"text": "22", "feedback": "It looks like the two products were added. The expression subtracts the second one."},
   {"text": "−2", "feedback": "Check which value goes with which letter. a is 4 and b is 5."},
   {"text": "7", "feedback": "This substitutes without multiplying, giving something like 4 + 5 − 2. Each letter has a coefficient."},
   {"text": "2", "feedback": "Correct. 3 × 4 = 12 and 2 × 5 = 10, so 12 − 10 = 2."}
 ]'::jsonb,
 'substitution-sign-error'),
('MTH1W', 'algebraic-expressions', 'collecting-like-terms', 3, 'Easy',
 'In the expression 7 + 3x + 3y - 2xy - 1, which pair are like terms?', 2,
 '[
   {"text": "3x and 3y", "feedback": "The coefficients match, but the variables do not. Like terms need the same variable."},
   {"text": "3x and -2xy", "feedback": "Both contain x, but one also carries a y. Every variable has to match."},
   {"text": "7 and -1", "feedback": "Correct."},
   {"text": "3y and -2xy", "feedback": "Both contain y, but one also carries an x. Every variable has to match."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'collecting-like-terms', 4, 'Easy',
 'Simplify 3x + 4x.', 3,
 '[
   {"text": "7", "feedback": "The variable does not disappear. It is carried through unchanged."},
   {"text": "12x", "feedback": "The coefficients were multiplied. Collecting like terms adds them."},
   {"text": "7x^2", "feedback": "The coefficients are right, but the variable stays as it is. Only the numbers in front combine."},
   {"text": "7x", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'collecting-like-terms', 5, 'Medium',
 'Simplify 2b - b + 7 - 8 + 3b.', 2,
 '[
   {"text": "5b - 1", "feedback": "The -b was dropped instead of subtracted."},
   {"text": "6b - 1", "feedback": "The -b was counted as +b. A lone b in front of a minus sign carries a coefficient of -1."},
   {"text": "4b - 1", "feedback": "Correct."},
   {"text": "4b - 15", "feedback": "The 7 and the 8 were both taken as negative. Only the 8 has a minus in front of it."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'collecting-like-terms', 6, 'Medium',
 'Simplify 3x^2 + 2 - 6x + 9x - 3x^2.', 2,
 '[
   {"text": "3x^2 + 3x + 2", "feedback": "Only one squared term was used. There are two, and they cancel each other."},
   {"text": "-3x + 2", "feedback": "The x terms were combined the wrong way round. Start from the -6x and add 9x."},
   {"text": "3x + 2", "feedback": "Correct."},
   {"text": "6x^4 + 3x + 2", "feedback": "The two squared terms were combined by adding exponents. They are like terms, so their coefficients add and cancel."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'collecting-like-terms', 7, 'Challenge',
 'Simplify a^2b + 2ab - ab^2 + 2ab^2 - 3ab + a^2b.', 1,
 '[
   {"text": "2a^2b^2 + ab^2 - ab", "feedback": "The exponents were added when the a^2b terms were collected. Only the coefficients combine."},
   {"text": "2a^2b + ab^2 - ab", "feedback": "Correct."},
   {"text": "2a^2b - ab^2 - ab", "feedback": "The two ab^2 terms were combined the wrong way round. Start from the -1 and add 2."},
   {"text": "2a^2b + ab^2 + ab", "feedback": "The ab terms were combined the wrong way round. 2 take away 3 is negative."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'collecting-like-terms', 8, 'Challenge',
 'Simplify 2x^2 - 3y^2 + xy + 2y^2 - 8x^3, writing the terms in descending order of degree.', 3,
 '[
   {"text": "-8x^3 + 2x^2 + y^2 + xy", "feedback": "The y^2 terms were combined the wrong way round. Start from the -3."},
   {"text": "-8x^3 + 2x^2 - 5y^2 + xy", "feedback": "The two y^2 terms were both taken as negative. The second one is being added."},
   {"text": "-6x^5 - y^2 + xy", "feedback": "The x^3 and x^2 terms were combined. Different exponents means they are not like terms."},
   {"text": "-8x^3 + 2x^2 - y^2 + xy", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'collecting-like-terms', 9, 'Advanced',
 'Which of these expressions cannot be simplified any further?', 1,
 '[
   {"text": "4xy + 6xy", "feedback": "Both terms carry exactly x and y, so they are like terms and combine."},
   {"text": "3x + 4x^2", "feedback": "Correct."},
   {"text": "9 - 4 + 2", "feedback": "These are all constants, which are always like terms."},
   {"text": "5a + 2a", "feedback": "Both terms are plain a terms, so their coefficients add."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'collecting-like-terms', 10, 'Advanced',
 'Simplify 5p^2q - 3pq^2 + 2p^2q + 4pq^2 - p^2q.', 0,
 '[
   {"text": "6p^2q + pq^2", "feedback": "Correct."},
   {"text": "6p^2q - pq^2", "feedback": "The pq^2 terms were combined the wrong way round. Start from the -3 and add 4."},
   {"text": "7p^2q + pq^2", "feedback": "The last term was added rather than subtracted. A lone p^2q behind a minus sign has coefficient -1."},
   {"text": "6p^3q^3 + pq^2", "feedback": "The exponents were added when the p^2q terms were collected. Only the coefficients combine."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'distributive-property', 1, 'Easy',
 'Expand:   4(x + 3)', 1,
 '[
   {"text": "4x + 3", "feedback": "The 4 has to multiply everything inside the bracket, not just the first term."},
   {"text": "4x + 12", "feedback": "Correct. The 4 multiplies both terms: 4 × x and 4 × 3."},
   {"text": "7x", "feedback": "You added the 4 and 3. Distributing means multiplying, and x and 3 are not like terms anyway."},
   {"text": "4x + 7", "feedback": "The 4 was added to the 3 rather than multiplied by it."}
 ]'::jsonb,
 'distributive-incomplete'),
('MTH1W', 'algebraic-expressions', 'distributive-property', 2, 'Easy',
 'Expand 5(x + 4).', 3,
 '[
   {"text": "9x", "feedback": "The 5 and the 4 were added and the bracket dropped. Distributing multiplies, it does not add."},
   {"text": "x + 20", "feedback": "Only the second term inside was multiplied. The 5 reaches both."},
   {"text": "5x + 4", "feedback": "Only the first term inside was multiplied. The 5 reaches every term in the bracket."},
   {"text": "5x + 20", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'distributive-property', 3, 'Easy',
 'Expand -2(7x - 4).', 3,
 '[
   {"text": "-14x - 8", "feedback": "A negative times a negative gives a positive. Check the sign on the second term."},
   {"text": "14x - 8", "feedback": "The minus in front of the 2 was dropped before distributing."},
   {"text": "-14x - 4", "feedback": "Only the first term inside was multiplied. The -2 reaches both."},
   {"text": "-14x + 8", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'distributive-property', 4, 'Medium',
 'Simplify:   2(3x − 1) + 5', 2,
 '[
   {"text": "6x + 4", "feedback": "Recheck the constant. Expanding gives −2, and −2 + 5 is not 4."},
   {"text": "6x − 1 + 5", "feedback": "The 2 needs to multiply the −1 as well as the 3x, and then the constants combine."},
   {"text": "6x + 3", "feedback": "Correct. Expanding gives 6x − 2, then −2 + 5 = 3."},
   {"text": "11x − 2", "feedback": "The 5 was combined with the 6x, but they are not like terms — one has an x and one does not."}
 ]'::jsonb,
 'distributive-then-collect'),
('MTH1W', 'algebraic-expressions', 'distributive-property', 5, 'Medium',
 'Expand:   −3(2x − 5)', 1,
 '[
   {"text": "−6x − 15", "feedback": "The sign on the second term needs care. A negative times a negative gives a positive."},
   {"text": "−6x + 15", "feedback": "Correct. −3 × 2x = −6x, and −3 × −5 = +15."},
   {"text": "6x + 15", "feedback": "Both signs flipped. Only the second one changes, because it multiplies two negatives."},
   {"text": "−6x − 5", "feedback": "The −3 has to multiply the −5 as well, not just the first term."}
 ]'::jsonb,
 'distributive-sign-error'),
('MTH1W', 'algebraic-expressions', 'distributive-property', 6, 'Medium',
 'Expand -3(2x^2 - 5x + 4).', 0,
 '[
   {"text": "-6x^2 + 15x - 12", "feedback": "Correct."},
   {"text": "-6x^2 + 15x + 12", "feedback": "The first two signs are right. Check the last one: -3 times +4."},
   {"text": "-6x^2 - 5x + 4", "feedback": "Only the first term was multiplied. The -3 reaches all three terms."},
   {"text": "-6x^2 - 15x - 12", "feedback": "Every term was multiplied, but the signs inside the bracket were ignored. A negative times a negative is positive."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'distributive-property', 7, 'Medium',
 'Expand and simplify 2(6m - 3) + 3(16 + 4m).', 3,
 '[
   {"text": "24m - 42", "feedback": "The constants were combined the wrong way round. The 48 is larger than the 6."},
   {"text": "24m + 54", "feedback": "The -3 was added instead of subtracted. 48 take away 6 is not 54."},
   {"text": "12m + 42", "feedback": "The 3 never reached the 4m. Both terms inside the second bracket get multiplied."},
   {"text": "24m + 42", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'distributive-property', 8, 'Challenge',
 'Expand -3x(2x^2 - 5x + 4).', 3,
 '[
   {"text": "-6x^3 + 15x^2 - 12", "feedback": "The last term lost its x. Multiplying 4 by -3x still leaves an x behind."},
   {"text": "-6x^3 - 15x^2 - 12x", "feedback": "The powers are right, but the signs inside the bracket were ignored."},
   {"text": "-6x^2 + 15x - 12", "feedback": "The x in the -3x was never multiplied through. Each exponent should climb by one."},
   {"text": "-6x^3 + 15x^2 - 12x", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'distributive-property', 9, 'Challenge',
 'Expand and simplify 3m(m - 5) - (2m^2 - m).', 2,
 '[
   {"text": "5m^2 - 16m", "feedback": "The second bracket was added rather than subtracted."},
   {"text": "3m^2 - 14m", "feedback": "The 2m^2 was never taken off. It cancels most of the 3m^2."},
   {"text": "m^2 - 14m", "feedback": "Correct."},
   {"text": "m^2 - 16m", "feedback": "The -m in the second bracket was not flipped. Subtracting it adds an m back."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'distributive-property', 10, 'Advanced',
 'Expand and simplify 3[2 + 5(2k - 1)].', 1,
 '[
   {"text": "30k + 3", "feedback": "The 5 was multiplied by the k term but not by the -1. Inside the square bracket that leaves 2 + 10k - 1."},
   {"text": "30k - 9", "feedback": "Correct."},
   {"text": "10k - 3", "feedback": "The inner bracket was expanded correctly, but the outer 3 was never distributed."},
   {"text": "30k - 3", "feedback": "The outer 3 reached the k term but not the constant. It multiplies everything inside."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'distributive-property', 11, 'Advanced',
 'Expand and simplify -2[3x - (4 - 2y)] + 5[y - 2(x + 1)].', 2,
 '[
   {"text": "-16x + 9y - 2", "feedback": "Inside the first square bracket, subtracting (4 - 2y) gives -4 + 2y. The sign on the 2y was missed."},
   {"text": "-16x + y + 3", "feedback": "In the second square bracket the -2 reached the x but not the 1. It multiplies both."},
   {"text": "-16x + y - 2", "feedback": "Correct."},
   {"text": "-16x - y - 2", "feedback": "The y terms are -4y and +5y. Check which one is larger."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'solving-multi-step-linear-equations', 1, 'Easy',
 'Solve for x:   2x + 7 = 19', 1,
 '[
   {"text": "13", "feedback": "You subtracted 7 but stopped there. The x is still multiplied by 2."},
   {"text": "6", "feedback": "Correct. Subtracting 7 gives 2x = 12, then dividing by 2 gives x = 6."},
   {"text": "26", "feedback": "It looks like 7 was added instead of subtracted. Do the opposite of what the equation does."},
   {"text": "12", "feedback": "That is 2x, not x. One step remains."}
 ]'::jsonb,
 'inverse-operation-order'),
('MTH1W', 'solving-equations', 'solving-multi-step-linear-equations', 2, 'Easy',
 'Solve for x:   x ÷ 4 = 3', 2,
 '[
   {"text": "0.75", "feedback": "This divides 3 by 4. To undo a division you multiply instead."},
   {"text": "7", "feedback": "It looks like 4 was added to 3. The equation divides, so undo it with multiplication."},
   {"text": "12", "feedback": "Correct. Multiplying both sides by 4 gives x = 12, and 12 ÷ 4 = 3."},
   {"text": "3", "feedback": "Substitute this back: 3 ÷ 4 is 0.75, not 3."}
 ]'::jsonb,
 'inverse-operation-direction'),
('MTH1W', 'solving-equations', 'solving-multi-step-linear-equations', 3, 'Easy',
 'Solve x - 5 = 10.', 0,
 '[
   {"text": "x = 15", "feedback": "Correct."},
   {"text": "x = 5", "feedback": "The 5 was subtracted again. The inverse of subtracting 5 is adding 5."},
   {"text": "x = -5", "feedback": "That took 10 away from 5. Start from the 10 and undo the subtraction."},
   {"text": "x = 2", "feedback": "That divided instead. The 5 is being subtracted, not multiplied."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'solving-multi-step-linear-equations', 4, 'Easy',
 'Solve 3x = 12.', 3,
 '[
   {"text": "x = 15", "feedback": "The 3 was added. Look at how it is attached to the x."},
   {"text": "x = 36", "feedback": "The two numbers were multiplied. The inverse of multiplying by 3 is dividing by 3."},
   {"text": "x = 9", "feedback": "The 3 was subtracted. It is attached to x by multiplication, so it comes off by division."},
   {"text": "x = 4", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'solving-multi-step-linear-equations', 5, 'Medium',
 'Solve for x:   5x − 3 = 2x + 12', 2,
 '[
   {"text": "3", "feedback": "Substitute 3 back in: the left side gives 12 and the right gives 18. Not equal, so try again."},
   {"text": "9", "feedback": "Check the step where you collect the x terms. 5x − 2x gives 3x, not x."},
   {"text": "5", "feedback": "Correct. Collecting terms gives 3x = 15, so x = 5. Both sides then equal 22."},
   {"text": "15", "feedback": "That is 3x. You still need to divide by the coefficient."}
 ]'::jsonb,
 'variables-both-sides'),
('MTH1W', 'solving-equations', 'solving-multi-step-linear-equations', 6, 'Medium',
 'Solve for x:   3(x − 2) = 12', 3,
 '[
   {"text": "2", "feedback": "Substitute back: 3(2 − 2) gives 0, not 12."},
   {"text": "10", "feedback": "It looks like 2 was added to 12 without dealing with the 3 outside the bracket."},
   {"text": "4", "feedback": "Close. You divided by 3 correctly to get x − 2 = 4, but there is one step left."},
   {"text": "6", "feedback": "Correct. Dividing by 3 gives x − 2 = 4, then adding 2 gives x = 6."}
 ]'::jsonb,
 'bracket-before-divide'),
('MTH1W', 'solving-equations', 'solving-multi-step-linear-equations', 7, 'Medium',
 'Solve 7 - 2x = 8 - 5x.', 0,
 '[
   {"text": "x = 1/3", "feedback": "Correct."},
   {"text": "x = -1/3", "feedback": "The constants were combined the wrong way round, which flipped the sign of the answer."},
   {"text": "x = 3", "feedback": "The final division was done upside down. Check which number is being divided by which."},
   {"text": "x = -3", "feedback": "Both the sign and the final division went the wrong way."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'solving-multi-step-linear-equations', 8, 'Medium',
 'Solve 5(x - 3) - (x - 2) = 19.', 0,
 '[
   {"text": "x = 8", "feedback": "Correct."},
   {"text": "x = 32", "feedback": "That stopped at 4x = 32. There is one division left to do."},
   {"text": "x = 9", "feedback": "The minus in front of the second bracket reached the x but not the 2. That term becomes +2."},
   {"text": "x = 5", "feedback": "The 5 was multiplied by the x but not by the 3. It reaches both terms."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'solving-multi-step-linear-equations', 9, 'Challenge',
 'Solve 2(x - 3) = -3(x + 5) - 6.', 3,
 '[
   {"text": "x = -3/5", "feedback": "The -6 on the right was added instead of subtracted when it moved across."},
   {"text": "x = 3", "feedback": "The final division dropped the negative. 5x = -15 gives a negative answer."},
   {"text": "x = 1", "feedback": "The -3 reached the x but not the 5. That term becomes -15."},
   {"text": "x = -3", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'solving-multi-step-linear-equations', 10, 'Challenge',
 'Solve 5(5x - 13) = 23x - 13.', 2,
 '[
   {"text": "x = 39", "feedback": "The -13 lost its minus sign when the two constants were combined."},
   {"text": "x = 13", "feedback": "That stopped one step early. 2x = 52 still has to be divided out."},
   {"text": "x = 26", "feedback": "Correct."},
   {"text": "x = -26", "feedback": "The constants were combined the wrong way round, which flipped the sign of the answer."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'solving-multi-step-linear-equations', 11, 'Advanced',
 'Solve 3(2x + 5) - 2(x - 4) = 4(x + 6) - 5.', 2,
 '[
   {"text": "Infinitely many solutions", "feedback": "Matching x terms are not enough for that answer. The constant terms have to match as well."},
   {"text": "x = -1", "feedback": "The 4x was cancelled on the right side only. What comes off one side has to come off both."},
   {"text": "The equation has no solution", "feedback": "Correct."},
   {"text": "x = 0", "feedback": "Substitute 0 into both sides and they do not match. Expand each side fully first."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'product-quotient-and-power-laws', 1, 'Easy',
 'Simplify:   x² × x³', 0,
 '[
   {"text": "x⁵", "feedback": "Correct. Multiplying powers of the same base means adding the exponents: 2 + 3 = 5."},
   {"text": "x⁶", "feedback": "You multiplied the exponents. That rule is for a power raised to another power, not for multiplying."},
   {"text": "2x⁵", "feedback": "The exponent is right, but no coefficient appears. There is nothing to add out front."},
   {"text": "x", "feedback": "That comes from subtracting the exponents, which is the rule for dividing rather than multiplying."}
 ]'::jsonb,
 'exponent-multiplication-rule'),
('MTH1W', 'powers', 'product-quotient-and-power-laws', 2, 'Easy',
 'Simplify 2^3 x 2^4 as a single power.', 3,
 '[
   {"text": "2^1", "feedback": "That subtracted the exponents, which is the rule for dividing, not multiplying."},
   {"text": "2^12", "feedback": "That multiplied the exponents. Multiplying powers of the same base adds them."},
   {"text": "4^7", "feedback": "The exponents were handled correctly, but the bases were multiplied as well. The base stays as it is."},
   {"text": "2^7", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'product-quotient-and-power-laws', 3, 'Easy',
 'What is the value of 7^0?', 2,
 '[
   {"text": "0", "feedback": "An exponent of zero does not make the whole power zero. Follow the pattern down from 7^2, 7^1."},
   {"text": "7", "feedback": "That is 7^1. Take one more step down the pattern."},
   {"text": "1", "feedback": "Correct."},
   {"text": "Undefined", "feedback": "Only 0^0 is undefined. This base is not zero."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'product-quotient-and-power-laws', 4, 'Medium',
 'Simplify 8^7 divided by 8^5, then evaluate.', 3,
 '[
   {"text": "8^12", "feedback": "That added the exponents. Dividing powers of the same base subtracts them."},
   {"text": "1", "feedback": "That cancelled the exponents completely. Subtracting them does not always leave zero."},
   {"text": "8^35", "feedback": "That multiplied the exponents, which is the rule for a power of a power."},
   {"text": "64", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'product-quotient-and-power-laws', 5, 'Medium',
 'Simplify (3^2)^4 as a single power.', 3,
 '[
   {"text": "3^16", "feedback": "That raised the inner exponent to the outer one instead of multiplying the two."},
   {"text": "6^4", "feedback": "That multiplied the base by the inner exponent instead of repeating it, then applied the outer exponent."},
   {"text": "3^6", "feedback": "That added the exponents. A power raised to a power multiplies them."},
   {"text": "3^8", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'product-quotient-and-power-laws', 6, 'Challenge',
 'Simplify (3^2 x 3^4)^3 as a single power.', 1,
 '[
   {"text": "3^11", "feedback": "The two exponents inside the bracket were multiplied together and the outer one was then added on. Inside the bracket they are added."},
   {"text": "3^18", "feedback": "Correct."},
   {"text": "3^9", "feedback": "The bracket was simplified correctly, but the outer exponent was added rather than multiplied."},
   {"text": "3^24", "feedback": "That multiplied all three exponents together. Inside the bracket they are added first."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'product-quotient-and-power-laws', 7, 'Challenge',
 'Simplify x^20 / (x^5 . x^6).', 1,
 '[
   {"text": "x^14", "feedback": "Only the other factor was divided out. Both are on the bottom."},
   {"text": "x^9", "feedback": "Correct."},
   {"text": "x^11", "feedback": "That is the bottom combined. The division by the top still has to happen."},
   {"text": "x^15", "feedback": "Only one of the two factors on the bottom was divided out. Combine them first."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'product-quotient-and-power-laws', 8, 'Advanced',
 'Simplify (-4)^4 divided by (-4)^3.', 0,
 '[
   {"text": "-4", "feedback": "Correct."},
   {"text": "(-4)^12", "feedback": "That multiplied the exponents. Dividing powers of the same base subtracts them."},
   {"text": "1", "feedback": "That cancelled the exponents to zero. Subtracting them leaves something behind here."},
   {"text": "4", "feedback": "The exponent arithmetic is right, but the sign of the base was dropped on the way out."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'product-quotient-and-power-laws', 9, 'Advanced',
 'Use the quotient of powers rule to simplify 5^2 / 5^2.', 2,
 '[
   {"text": "5", "feedback": "The exponents were subtracted to 1 rather than to 0. They are equal."},
   {"text": "25", "feedback": "That worked out the top and forgot to divide by the bottom."},
   {"text": "1", "feedback": "Correct."},
   {"text": "0", "feedback": "The exponents do subtract to zero, but a zero exponent does not make the whole power zero."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'measures-of-central-tendency', 1, 'Easy',
 'Find the mean of:   4, 8, 10, 6, 2', 2,
 '[
   {"text": "30", "feedback": "That is the total. The mean divides that total by how many values there are."},
   {"text": "8", "feedback": "Check your division: there are five values, not fewer."},
   {"text": "6", "feedback": "Correct. The values sum to 30, and 30 ÷ 5 = 6."},
   {"text": "5", "feedback": "This is the number of values, not their average."}
 ]'::jsonb,
 'mean-calculation'),
('MTH1W', 'data', 'measures-of-central-tendency', 2, 'Easy',
 'Find the median of:   3, 7, 2, 9, 5', 1,
 '[
   {"text": "2", "feedback": "That is the smallest value. The median sits in the middle once the list is ordered."},
   {"text": "5", "feedback": "Correct. Ordered, the list is 2, 3, 5, 7, 9, and 5 is the middle value."},
   {"text": "7", "feedback": "This takes the middle of the list as written. Sort the numbers into order first."},
   {"text": "5.2", "feedback": "That is the mean. The median is a position in the ordered list, not an average."}
 ]'::jsonb,
 'unsorted-median'),
('MTH1W', 'data', 'measures-of-central-tendency', 3, 'Easy',
 'Find the mode of:   2, 3, 3, 5, 7, 3', 0,
 '[
   {"text": "3", "feedback": "Correct. The mode is the value that appears most often, and 3 appears three times."},
   {"text": "5", "feedback": "That is the middle-ish value. The mode is about how often a value appears, not where it sits."},
   {"text": "7", "feedback": "That is the largest value. Count how many times each number shows up instead."},
   {"text": "3.83", "feedback": "That is the mean. The mode is always one of the values in the list."}
 ]'::jsonb,
 'mode-vs-frequency'),
('MTH1W', 'data', 'measures-of-central-tendency', 4, 'Easy',
 'Find the mean of the test scores 72, 85, 78, 90, 85, 88, 78, 85, 92, 75.', 0,
 '[
   {"text": "82.8", "feedback": "Correct."},
   {"text": "85", "feedback": "That is the value that appears most often. The mean shares the total out evenly instead."},
   {"text": "82", "feedback": "The total is right, but it was rounded down rather than divided exactly."},
   {"text": "8.28", "feedback": "The total was divided by 100 rather than by the number of scores."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'measures-of-central-tendency', 5, 'Easy',
 'Find the mode of the test scores 72, 85, 78, 90, 85, 88, 78, 85, 92, 75.', 0,
 '[
   {"text": "85", "feedback": "Correct."},
   {"text": "92", "feedback": "That is the largest score. The mode is about frequency, not size."},
   {"text": "78", "feedback": "That value does repeat, but another one repeats more often."},
   {"text": "82.8", "feedback": "That is the mean. The mode is a value that actually appears in the list."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'measures-of-central-tendency', 6, 'Medium',
 'Find the median of the points scored: 0, 8, 6, 0, 3, 5, 3, 4, 2, 9, 12.', 0,
 '[
   {"text": "4", "feedback": "Correct."},
   {"text": "5", "feedback": "That is the sixth value of the list as written. The list has to be sorted first."},
   {"text": "6", "feedback": "That is the position of the middle value, not the value sitting in that position."},
   {"text": "4.73", "feedback": "That is the mean. The median is an actual position in the ordered list."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'measures-of-central-tendency', 7, 'Medium',
 'Find the mean of the points scored: 0, 8, 6, 0, 3, 5, 3, 4, 2, 9, 12. Round to two decimal places.', 1,
 '[
   {"text": "5.20", "feedback": "The total is right, but it was divided by ten. The two zeros still count as players."},
   {"text": "4.73", "feedback": "Correct."},
   {"text": "4.00", "feedback": "That is the median of this set. The mean shares the total out evenly instead."},
   {"text": "52.00", "feedback": "That is the total. It still has to be divided by how many players there are."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'measures-of-central-tendency', 8, 'Challenge',
 'In the data set 0, 8, 6, 0, 3, 5, 3, 4, 2, 9, 12, the player with 12 points instead scores 20. Which measures of central tendency change?', 1,
 '[
   {"text": "The mean and the median", "feedback": "The changed value is already the largest, so it stays at the top of the ordered list and the middle position is untouched."},
   {"text": "Only the mean", "feedback": "Correct."},
   {"text": "The median and the mode", "feedback": "Neither of those depends on how large the biggest value is, only on where it sits and how often values repeat."},
   {"text": "All three", "feedback": "Only one of the three uses the actual size of every value."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'measures-of-central-tendency', 9, 'Challenge',
 'A set of five numbers has a mean of 20. One number is removed and the mean of the remaining four is 22. What was the number that was removed?', 2,
 '[
   {"text": "18", "feedback": "Removing that value would barely move the mean. Work with the two totals instead."},
   {"text": "42", "feedback": "The two means were added. It is the totals behind them that have to be compared."},
   {"text": "12", "feedback": "Correct."},
   {"text": "2", "feedback": "That is the change in the mean, not the value that left the set."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'measures-of-central-tendency', 10, 'Advanced',
 'A class of 20 students has a mean score of 70. A new student joins with a score of 91. What is the new mean?', 3,
 '[
   {"text": "71.05", "feedback": "The extra marks were shared across the wrong number of students."},
   {"text": "74.55", "feedback": "The new total was divided by the old class size rather than the new one."},
   {"text": "80.5", "feedback": "That averages the old mean with the new score. The old mean already stands for twenty students."},
   {"text": "71", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'measures-of-central-tendency', 11, 'Advanced',
 'A data set has a mean of 50 but a median of 30. What does this suggest about the data?', 3,
 '[
   {"text": "A few unusually small values are pulling the mean downward", "feedback": "That would push the mean BELOW the median. Here the mean sits above it."},
   {"text": "The data are symmetric about their centre", "feedback": "Symmetric data have a mean and median that sit on top of each other."},
   {"text": "There must be a calculation error", "feedback": "Nothing is wrong. The two measures often disagree, and the gap is informative."},
   {"text": "A few unusually large values are pulling the mean upward", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'measures-of-spread', 1, 'Easy',
 'Find the range of:   12, 5, 20, 8', 3,
 '[
   {"text": "45", "feedback": "That is the sum of all the values. Range compares only the extremes."},
   {"text": "10", "feedback": "That is close to the mean. The range measures spread rather than centre."},
   {"text": "20", "feedback": "That is the largest value. The range subtracts the smallest from it."},
   {"text": "15", "feedback": "Correct. The largest is 20 and the smallest is 5, so the range is 20 − 5 = 15."}
 ]'::jsonb,
 'range-calculation'),
('MTH1W', 'data', 'measures-of-spread', 2, 'Easy',
 'Find the range of the data set 12, 15, 18, 22, 27.', 0,
 '[
   {"text": "15", "feedback": "Correct."},
   {"text": "27", "feedback": "That is the largest value. The range subtracts the smallest from it."},
   {"text": "18", "feedback": "That is the middle value. The range uses the two extremes."},
   {"text": "39", "feedback": "The two extremes were added. The range subtracts them."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'measures-of-spread', 3, 'Easy',
 'What does the interquartile range measure?', 1,
 '[
   {"text": "The value that appears most often", "feedback": "That is the mode, which describes the centre rather than the spread."},
   {"text": "The spread of the middle half of the data", "feedback": "Correct."},
   {"text": "The difference between the largest and smallest values", "feedback": "That is the range. The interquartile range ignores the extremes."},
   {"text": "The average distance of each value from the mean", "feedback": "That is a different measure of spread. This one is built from quartiles."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'measures-of-spread', 4, 'Medium',
 'In a set of data, what is an outlier?', 3,
 '[
   {"text": "The most common value", "feedback": "That is the mode. An outlier is about distance from the rest, not frequency."},
   {"text": "The middle value", "feedback": "That is the median, which sits at the centre of the ordered data."},
   {"text": "The difference between the largest and smallest", "feedback": "That is the range, a measure of spread rather than a single unusual value."},
   {"text": "A value far away from the others", "feedback": "Correct. An outlier sits well apart from the rest, and can pull the mean noticeably."}
 ]'::jsonb,
 'outlier-definition'),
('MTH1W', 'data', 'measures-of-spread', 5, 'Medium',
 'For the data set 8, 12, 15, 18, 22, 27, 30, 35, 40, what is Q1?', 1,
 '[
   {"text": "15", "feedback": "That is one of the two middle values of the lower half. The two of them get averaged."},
   {"text": "13.5", "feedback": "Correct."},
   {"text": "12", "feedback": "That is the other middle value of the lower half. The two of them get averaged."},
   {"text": "22", "feedback": "That is the overall median, which is Q2 rather than Q1."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'measures-of-spread', 6, 'Medium',
 'For the data set 8, 12, 15, 18, 22, 27, 30, 35, 40, what is the interquartile range?', 3,
 '[
   {"text": "32", "feedback": "That is the range, which uses the two extreme values rather than the quartiles."},
   {"text": "46", "feedback": "The two quartiles were added. The interquartile range subtracts them."},
   {"text": "22", "feedback": "That is the overall median, not a measure of spread."},
   {"text": "19", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'measures-of-spread', 7, 'Challenge',
 'Data set A is 50, 50, 50, 50, 50 and data set B is 10, 30, 50, 70, 90. What distinguishes them?', 0,
 '[
   {"text": "Their spread: A has a range of 0 and B has a range of 80", "feedback": "Correct."},
   {"text": "Nothing, they are equivalent data sets", "feedback": "The centres agree, but one set is identical values and the other stretches widely."},
   {"text": "Their means", "feedback": "Both totals come to 250 across five values, so the means match."},
   {"text": "Their medians", "feedback": "The middle value of each ordered set is the same."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'measures-of-spread', 8, 'Challenge',
 'A data set has a range of 15 but an interquartile range of only 4. What does that suggest?', 2,
 '[
   {"text": "The mean must equal the median", "feedback": "These two measures say nothing about where the mean sits."},
   {"text": "The data are evenly spread across the whole range", "feedback": "Even spreading would put the quartiles far apart, giving a much larger middle spread."},
   {"text": "The middle half is tightly packed, with a few values far out at the ends", "feedback": "Correct."},
   {"text": "The data set must contain a calculation error", "feedback": "Nothing is wrong. A middle spread smaller than the full spread is entirely normal."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'measures-of-spread', 9, 'Advanced',
 'Find the interquartile range of 4, 7, 9, 12, 15, 18, 21, 24.', 3,
 '[
   {"text": "27.5", "feedback": "The two quartiles were added. The interquartile range subtracts them."},
   {"text": "20", "feedback": "That is the range, which uses the two extreme values rather than the quartiles."},
   {"text": "13.5", "feedback": "That is the overall median. With eight values it falls between the fourth and fifth."},
   {"text": "11.5", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'measures-of-spread', 10, 'Advanced',
 'A data set currently has a maximum of 40. A single new value of 100 is added. Which is affected more, the range or the interquartile range?', 1,
 '[
   {"text": "Neither changes", "feedback": "At least one measure has to react, because the largest value in the set has moved a long way."},
   {"text": "The range, because it depends only on the extreme values", "feedback": "Correct."},
   {"text": "The interquartile range, because it uses the middle half", "feedback": "Using the middle half is exactly what protects it from one extreme value."},
   {"text": "Both change by the same amount", "feedback": "One of the two is built from the extremes and the other deliberately avoids them."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'scatterplots-and-correlation', 1, 'Easy',
 'Which graph is best for showing how a whole is divided into parts?', 2,
 '[
   {"text": "A line graph", "feedback": "Line graphs are best for showing change over time, not division of a total."},
   {"text": "A scatter plot", "feedback": "Scatter plots show the relationship between two variables, not parts of one total."},
   {"text": "A circle graph", "feedback": "Correct. A circle graph, or pie chart, shows each category as a slice of the whole."},
   {"text": "A histogram", "feedback": "Histograms show how often values fall into ranges, rather than shares of a total."}
 ]'::jsonb,
 'graph-type-choice'),
('MTH1W', 'data', 'scatterplots-and-correlation', 2, 'Easy',
 'On a scatterplot, which variable goes on the x-axis?', 2,
 '[
   {"text": "Whichever variable has the larger values", "feedback": "The size of the numbers does not decide it. The roles of the variables do."},
   {"text": "Whichever variable has more data points", "feedback": "Both variables have the same number of points, since they come in pairs."},
   {"text": "The independent variable", "feedback": "Correct."},
   {"text": "The dependent variable", "feedback": "That one goes on the vertical axis, because it responds to the other."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'scatterplots-and-correlation', 3, 'Easy',
 'On a scatterplot of hours studied against test score, the points run from the lower left to the upper right. What kind of correlation is this?', 3,
 '[
   {"text": "Negative", "feedback": "That pattern runs from the upper left down to the lower right instead."},
   {"text": "No correlation", "feedback": "A clear direction in the points means there is a relationship to describe."},
   {"text": "It cannot be told from a scatterplot", "feedback": "The direction of the pattern is exactly what a scatterplot shows."},
   {"text": "Positive", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'scatterplots-and-correlation', 4, 'Medium',
 'Two variables have a correlation coefficient of -0.9. What does that tell you?', 1,
 '[
   {"text": "No linear correlation", "feedback": "That would need a value close to zero."},
   {"text": "A strong negative linear correlation", "feedback": "Correct."},
   {"text": "A weak negative linear correlation", "feedback": "The minus sign gives the direction, but the size tells the strength, and this one sits close to the extreme."},
   {"text": "A strong positive linear correlation", "feedback": "The strength is right, but the sign says the two variables move in opposite directions."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'scatterplots-and-correlation', 5, 'Medium',
 'Two variables have a correlation coefficient of 0.05. What does that tell you?', 2,
 '[
   {"text": "A strong positive linear correlation", "feedback": "That would need a value close to one. This one sits close to zero."},
   {"text": "A strong negative linear correlation", "feedback": "That would need a value close to minus one, and this value is not even negative."},
   {"text": "Little or no linear correlation", "feedback": "Correct."},
   {"text": "A perfect correlation", "feedback": "That would need a value of exactly one or minus one."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'scatterplots-and-correlation', 6, 'Challenge',
 'A line of best fit for hours studied (x) against test score (y) is y = 5.4x + 48. Predict the score for 8 hours of study.', 0,
 '[
   {"text": "91.2", "feedback": "Correct."},
   {"text": "53.4", "feedback": "The slope was counted once instead of once for every hour studied."},
   {"text": "43.2", "feedback": "The starting value of 48 was left out of the prediction."},
   {"text": "427.2", "feedback": "The whole expression was multiplied by 8. Only the x term is."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'scatterplots-and-correlation', 7, 'Challenge',
 'A scatterplot rises steeply at first and then flattens out as x grows, never turning back downward. Which regression model is likely to fit it best?', 3,
 '[
   {"text": "No model can fit a curved pattern", "feedback": "Regression is not limited to straight lines. Several curved models are available."},
   {"text": "Linear", "feedback": "A straight line rises at the same rate the whole way. This pattern changes its rate."},
   {"text": "Quadratic", "feedback": "A quadratic curve turns and comes back down. This one keeps rising while flattening."},
   {"text": "Logarithmic", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'scatterplots-and-correlation', 8, 'Advanced',
 'Opening week revenue and lifetime gross revenue for a set of films have a correlation coefficient of 0.68. How should this be described?', 0,
 '[
   {"text": "A moderate positive linear correlation", "feedback": "Correct."},
   {"text": "A strong negative correlation", "feedback": "The value is positive, so the two revenues rise together."},
   {"text": "Sixty-eight percent of the films sit exactly on the trend line", "feedback": "The coefficient measures how closely the points follow a line, not how many land on it."},
   {"text": "No correlation", "feedback": "That would need a value close to zero. This one is well away from it."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'scatterplots-and-correlation', 9, 'Advanced',
 'Ice cream sales and drowning numbers show a strong positive correlation across the year. What does this establish?', 3,
 '[
   {"text": "That buying ice cream causes drownings", "feedback": "A pattern in the data cannot by itself show which way, if either, the influence runs."},
   {"text": "That drownings cause ice cream sales", "feedback": "Reversing the claim does not fix it. Neither direction follows from the correlation alone."},
   {"text": "That the correlation must be a calculation error", "feedback": "The correlation is real. It is the causal reading of it that does not follow."},
   {"text": "Only that the two move together, possibly because of a third factor such as hot weather", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'simple-interest', 1, 'Easy',
 'Calculate the simple interest on a loan of 10000 dollars at 5 percent per annum for 6 years.', 1,
 '[
   {"text": "300 dollars", "feedback": "The rate was used as 0.005 rather than 0.05. Five percent is five hundredths."},
   {"text": "3000 dollars", "feedback": "Correct."},
   {"text": "500 dollars", "feedback": "That is one year of interest. The loan runs for six."},
   {"text": "13000 dollars", "feedback": "That is the total owed at the end. The question asks for the interest alone."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'simple-interest', 2, 'Easy',
 'In the simple interest formula I = P x r x t, what does P stand for?', 1,
 '[
   {"text": "The percentage charged for the use of the money", "feedback": "That is r, the rate, which is written as a decimal."},
   {"text": "The principal, the amount invested or borrowed at the start", "feedback": "Correct."},
   {"text": "The profit made on the investment once it is cashed in", "feedback": "The profit is the interest itself, which is what the formula works out."},
   {"text": "The payment made each month until the whole loan is paid off", "feedback": "Monthly payments belong to a repayment formula. This one has no payments in it."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'simple-interest', 3, 'Medium',
 'Find the simple interest on $500 at 4% per year for 3 years.', 1,
 '[
   {"text": "$20", "feedback": "That is one year of interest. The money is invested for three."},
   {"text": "$60", "feedback": "Correct. I = Prt = 500 × 0.04 × 3 = $60."},
   {"text": "$560", "feedback": "That is the total amount at the end. The question asks for the interest alone."},
   {"text": "$600", "feedback": "It looks like the percentage was applied without converting 4% to 0.04."}
 ]'::jsonb,
 'simple-interest-formula'),
('MTH1W', 'financial-literacy', 'simple-interest', 4, 'Medium',
 'You deposit $200 at 5% simple interest per year. What is the total after 2 years?', 2,
 '[
   {"text": "$20", "feedback": "That is the interest earned. The question asks for the total including the original deposit."},
   {"text": "$210", "feedback": "This counts only one year of interest. The money sits for two."},
   {"text": "$220", "feedback": "Correct. Interest is 200 × 0.05 × 2 = $20, and 200 + 20 = $220."},
   {"text": "$400", "feedback": "This doubles the deposit. At 5% a year it would take far longer than two years to double."}
 ]'::jsonb,
 'interest-not-added-to-principal'),
('MTH1W', 'financial-literacy', 'simple-interest', 5, 'Medium',
 'Max invests 3240 dollars at 2.4 percent simple interest. How much interest does he earn in 20 years?', 2,
 '[
   {"text": "155.52 dollars", "feedback": "The rate was used as 0.0024 rather than 0.024."},
   {"text": "77.76 dollars", "feedback": "That is one year of interest. The investment runs for twenty."},
   {"text": "1555.20 dollars", "feedback": "Correct."},
   {"text": "4795.20 dollars", "feedback": "That is the total value of the investment. The question asks for the interest alone."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'simple-interest', 6, 'Medium',
 'Rory invests 750 dollars at 10 percent per annum simple interest. How long until his investment is worth 1000 dollars?', 3,
 '[
   {"text": "0.3 years", "feedback": "The rate was left out of the division. Interest is principal times rate times time."},
   {"text": "13.3 years", "feedback": "The whole 1000 was treated as interest. Only the 250 dollar GAIN is interest."},
   {"text": "2.5 years", "feedback": "The final value of 1000 was used as the principal. The principal is the amount actually invested."},
   {"text": "3.3 years", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'simple-interest', 7, 'Challenge',
 'How long does 2000 dollars have to sit at 4 percent simple interest to earn 560 dollars in interest?', 1,
 '[
   {"text": "14 years", "feedback": "The rate was halved somewhere. Divide the interest by the principal times the rate."},
   {"text": "7 years", "feedback": "Correct."},
   {"text": "3.5 years", "feedback": "The rate was doubled somewhere. Divide the interest by the principal times the rate."},
   {"text": "28 years", "feedback": "The rate was read as 1 percent rather than 4 percent. Divide the interest by the principal times the rate."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'simple-interest', 8, 'Challenge',
 'An investment of 1200 dollars grows to 1560 dollars in 5 years under simple interest. What is the annual rate?', 3,
 '[
   {"text": "26 percent", "feedback": "The whole 1560 was treated as interest. Only the growth above the original investment is interest."},
   {"text": "3 percent", "feedback": "The gain was halved somewhere in the division."},
   {"text": "30 percent", "feedback": "That is the total percentage gain across all five years, not the annual rate."},
   {"text": "6 percent", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'simple-interest', 9, 'Advanced',
 'How long does any amount of money take to double at 5 percent simple interest?', 2,
 '[
   {"text": "14 years", "feedback": "That rule of thumb belongs to COMPOUND interest. Simple interest takes longer."},
   {"text": "5 years", "feedback": "That copies the rate. Doubling means the interest has to grow to equal the principal."},
   {"text": "20 years", "feedback": "Correct."},
   {"text": "10 years", "feedback": "After that long the interest would equal only half the original amount."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'simple-interest', 10, 'Advanced',
 'Compare 5000 dollars over 10 years at 6 percent simple interest against 6 percent compounded annually. What is the difference?', 2,
 '[
   {"text": "Compounding wins by about 3000 dollars", "feedback": "That is the whole simple interest amount, not the gap between the two methods."},
   {"text": "Simple interest wins by about 954 dollars", "feedback": "Compounding lets the interest earn interest, so it is the larger of the two."},
   {"text": "Compounding wins by about 954 dollars", "feedback": "Correct."},
   {"text": "They come out equal, because the rate is the same", "feedback": "The rate matches, but simple interest never pays interest on the interest already earned."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'budgeting', 1, 'Easy',
 'A monthly income is $2000 and total expenses are $1650. How much is left to save?', 1,
 '[
   {"text": "$3650", "feedback": "This adds the two figures. Savings are what remains after expenses are taken out."},
   {"text": "$350", "feedback": "Correct. 2000 − 1650 = $350 left over."},
   {"text": "$450", "feedback": "Check the subtraction once more, looking carefully at the tens and units."},
   {"text": "$1650", "feedback": "That is the expenses figure. Savings are the difference between income and expenses."}
 ]'::jsonb,
 'budget-subtraction'),
('MTH1W', 'financial-literacy', 'budgeting', 2, 'Easy',
 'What is 15% of 80?', 2,
 '[
   {"text": "15", "feedback": "That is the percentage itself, not the amount. You need 15% of the 80."},
   {"text": "5.33", "feedback": "This divides 80 by 15. Finding a percentage means multiplying instead."},
   {"text": "12", "feedback": "Correct. 15% is 0.15, and 0.15 × 80 = 12."},
   {"text": "120", "feedback": "That is 15 × 8. Check where the decimal point goes when converting 15% to a decimal."}
 ]'::jsonb,
 'percent-as-decimal'),
('MTH1W', 'financial-literacy', 'budgeting', 3, 'Easy',
 'Which of these is a fixed expense in a monthly budget?', 1,
 '[
   {"text": "A weekend trip", "feedback": "That is discretionary. You can cut it back without losing anything essential."},
   {"text": "Rent", "feedback": "Correct."},
   {"text": "Dining out", "feedback": "That is discretionary. You can cut it back without losing anything essential."},
   {"text": "Concert tickets", "feedback": "That is discretionary. You can cut it back without losing anything essential."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'budgeting', 4, 'Easy',
 'Max has a monthly income of 1146.99 dollars and monthly expenses of 900 dollars. What is his net profit for the month?', 2,
 '[
   {"text": "2046.99 dollars", "feedback": "The two figures were added. Net profit subtracts expenses from income."},
   {"text": "900.00 dollars", "feedback": "That is what he spends, not what he has left."},
   {"text": "246.99 dollars", "feedback": "Correct."},
   {"text": "-246.99 dollars", "feedback": "The subtraction went the wrong way round. His income is larger than his expenses."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'budgeting', 5, 'Medium',
 'A jacket costs $80 and is discounted by 15%. What is the sale price?', 0,
 '[
   {"text": "$68", "feedback": "Correct. The discount is 0.15 × 80 = $12, so the sale price is 80 − 12 = $68."},
   {"text": "$12", "feedback": "That is the discount itself. The question asks what you actually pay."},
   {"text": "$92", "feedback": "The discount was added rather than subtracted. A discount lowers the price."},
   {"text": "$65", "feedback": "Check the discount calculation: 15% of 80 is not 15."}
 ]'::jsonb,
 'percent-discount-not-subtracted'),
('MTH1W', 'financial-literacy', 'budgeting', 6, 'Medium',
 'Arthur has a monthly income of 2100 dollars and monthly expenses totalling 2185 dollars. Is his budget balanced?', 2,
 '[
   {"text": "No, he has a surplus of 85 dollars", "feedback": "The subtraction went the wrong way. His expenses are the larger of the two."},
   {"text": "No, he has a deficit of 185 dollars", "feedback": "Check the subtraction. The gap between the two totals is smaller than that."},
   {"text": "No, he has a deficit of 85 dollars", "feedback": "Correct."},
   {"text": "Yes, it is exactly balanced", "feedback": "The two totals differ. Subtract one from the other."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'budgeting', 7, 'Medium',
 'Arthur needs to close an 85 dollar monthly gap. Which adjustment cuts only discretionary spending?', 3,
 '[
   {"text": "Move somewhere with cheaper monthly rent", "feedback": "Rent is a fixed expense. It is not easy to minimise month to month."},
   {"text": "Cancel the car insurance he pays for every month", "feedback": "Insurance is a fixed expense, and cancelling it creates a much larger risk."},
   {"text": "Cut the amount of money he spends on food each month in half", "feedback": "Food is treated as a fixed expense, because it is essential."},
   {"text": "Reduce his entertainment and gym membership spending", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'budgeting', 8, 'Challenge',
 'Max earns 1146.99 dollars a month and wants to save 20 percent of it. His rent is 500, food 250 and transport 50 dollars. How much is left for discretionary spending?', 1,
 '[
   {"text": "232.29 dollars", "feedback": "Only 10 percent was set aside. He wants to save twice that."},
   {"text": "117.59 dollars", "feedback": "Correct."},
   {"text": "2.89 dollars", "feedback": "30 percent was set aside rather than 20."},
   {"text": "346.99 dollars", "feedback": "The savings were never set aside. Twenty percent of his income has to come off as well."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'budgeting', 9, 'Challenge',
 'Why should every dollar of income be accounted for in a budget, even the leftover money?', 3,
 '[
   {"text": "So that income always works out to exactly zero on paper", "feedback": "The aim is not to reach zero. It is to give every dollar a job."},
   {"text": "Because fixed expenses change from one month to the next", "feedback": "Fixed expenses are the ones that stay steady. That is what makes them fixed."},
   {"text": "Because banks require you to hand in a complete budget before they will open an account", "feedback": "No bank asks for this. The reason is about your own money, not theirs."},
   {"text": "So that the leftover money is deliberately saved or invested rather than quietly spent", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'budgeting', 10, 'Advanced',
 'Someone earns 3200 dollars a month but spends 3400 dollars. What is the most sensible first step?', 1,
 '[
   {"text": "Stop paying rent until the budget recovers", "feedback": "Rent is a fixed expense with serious consequences if it goes unpaid."},
   {"text": "Cut discretionary spending such as dining out and entertainment", "feedback": "Correct."},
   {"text": "Nothing, a small monthly deficit is not a problem", "feedback": "A deficit repeats every month, so it compounds into a large shortfall over a year."},
   {"text": "Put the 200 dollar shortfall on a credit card each month", "feedback": "That turns a monthly gap into a growing debt that charges interest on top."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'budgeting', 11, 'Advanced',
 'A budget shows a surplus of 400 dollars a month. What is the best use of it?', 1,
 '[
   {"text": "Nothing, a surplus means the budget was worked out wrongly", "feedback": "A surplus is the goal of a healthy budget, not an error in it."},
   {"text": "Save or invest it so it earns interest and covers unexpected costs", "feedback": "Correct."},
   {"text": "Leave it sitting in the chequing account and do not record it", "feedback": "Unrecorded money tends to get spent without a decision being made about it."},
   {"text": "Raise discretionary spending until the surplus is used up", "feedback": "That converts a real advantage into ordinary spending and leaves nothing for emergencies."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'area-and-perimeter-of-composite-shapes', 1, 'Easy',
 'Find the area of a triangle with base 10 cm and height 6 cm.', 1,
 '[
   {"text": "60 cm²", "feedback": "That is base times height, which gives the area of a rectangle. A triangle is half of that."},
   {"text": "30 cm²", "feedback": "Correct. Area is half the base times the height: ½ × 10 × 6 = 30."},
   {"text": "16 cm²", "feedback": "That is base plus height. Area needs multiplication, not addition."},
   {"text": "32 cm²", "feedback": "This looks like the perimeter of something. Area of a triangle uses base and height multiplied, then halved."}
 ]'::jsonb,
 'forgets-half-in-triangle-area'),
('MTH1W', 'geometry', 'area-and-perimeter-of-composite-shapes', 2, 'Easy',
 'Find the circumference of a circle with radius 5 cm. Use π ≈ 3.14.', 2,
 '[
   {"text": "15.7 cm", "feedback": "This used the radius where the diameter belongs. Circumference is π times the diameter."},
   {"text": "78.5 cm", "feedback": "That is the area, πr². Circumference measures the distance around the edge."},
   {"text": "31.4 cm", "feedback": "Correct. C = 2πr = 2 × 3.14 × 5 = 31.4 cm."},
   {"text": "10 cm", "feedback": "That is the diameter. There is still a π to apply."}
 ]'::jsonb,
 'circumference-vs-area'),
('MTH1W', 'geometry', 'area-and-perimeter-of-composite-shapes', 3, 'Easy',
 'Find the perimeter of a rectangle 8 m long and 5 m wide.', 0,
 '[
   {"text": "26 m", "feedback": "Correct. Perimeter is 2(8 + 5) = 26 m."},
   {"text": "40 m", "feedback": "That is the area, in square metres. Perimeter is the distance around the outside."},
   {"text": "13 m", "feedback": "This adds one length and one width. A rectangle has two of each."},
   {"text": "80 m", "feedback": "This doubles the area. Perimeter adds the four sides rather than multiplying."}
 ]'::jsonb,
 'perimeter-vs-area'),
('MTH1W', 'geometry', 'area-and-perimeter-of-composite-shapes', 4, 'Easy',
 'What is the area of a rectangle measuring 2.4 m by 3.8 m?', 1,
 '[
   {"text": "4.56 square metres", "feedback": "That halves the product, which is the rule for a triangle rather than a rectangle."},
   {"text": "9.12 square metres", "feedback": "Correct."},
   {"text": "12.4 square metres", "feedback": "That is the perimeter, and it is measured in metres rather than square metres."},
   {"text": "6.2 square metres", "feedback": "The two side lengths were added. Area multiplies them."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'area-and-perimeter-of-composite-shapes', 5, 'Easy',
 'Which formula gives the area of a circle?', 2,
 '[
   {"text": "2 x pi x r^2", "feedback": "That is twice the area. There is no 2 in the area formula for a circle."},
   {"text": "2 x pi x r", "feedback": "That is the circumference, which is a distance rather than an area."},
   {"text": "pi x r^2", "feedback": "Correct."},
   {"text": "pi x d", "feedback": "That is the circumference written using the diameter."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'area-and-perimeter-of-composite-shapes', 6, 'Medium',
 'Find the area of a circle with radius 4 cm. Use π ≈ 3.14.', 0,
 '[
   {"text": "50.24 cm²", "feedback": "Correct. A = πr² = 3.14 × 16 = 50.24 cm²."},
   {"text": "25.12 cm²", "feedback": "That is the circumference, 2πr. Area squares the radius instead of doubling it."},
   {"text": "12.56 cm²", "feedback": "This is π times the radius without squaring it. The r has an exponent."},
   {"text": "100.48 cm²", "feedback": "That is double the correct area — it comes from multiplying the radius by the diameter (4 × 8) instead of squaring the radius (4 × 4)."}
 ]'::jsonb,
 'radius-not-squared'),
('MTH1W', 'geometry', 'area-and-perimeter-of-composite-shapes', 7, 'Medium',
 'A composite figure is made of a rectangle measuring 2.4 m by 3.8 m together with a full circle of radius 1.2 m. What is the total area, to the nearest hundredth?', 2,
 '[
   {"text": "9.12 square metres", "feedback": "That is the rectangle on its own. The circle still has to be added."},
   {"text": "4.52 square metres", "feedback": "That is the circle on its own. The rectangle still has to be added."},
   {"text": "13.64 square metres", "feedback": "Correct."},
   {"text": "11.38 square metres", "feedback": "Only half the circle was counted. The question gives a full circle."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'area-and-perimeter-of-composite-shapes', 8, 'Medium',
 'What is the area of a triangle with a base of 3.2 m and a height of 3.8 m?', 2,
 '[
   {"text": "3.04 square metres", "feedback": "The halving was done twice."},
   {"text": "12.16 square metres", "feedback": "The half was left out. That product is the area of a rectangle with those dimensions."},
   {"text": "6.08 square metres", "feedback": "Correct."},
   {"text": "7.00 square metres", "feedback": "The base and height were added. Area multiplies them and then halves."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'area-and-perimeter-of-composite-shapes', 9, 'Challenge',
 'A rectangle measures 5 m by 2 m. A semicircle of diameter 2 m is cut out of one of the short ends. What area remains, to the nearest hundredth?', 2,
 '[
   {"text": "10.00 square metres", "feedback": "That is the whole rectangle. The cut-out still has to be taken off."},
   {"text": "6.86 square metres", "feedback": "A full circle was removed. Only half of one is cut out here."},
   {"text": "8.43 square metres", "feedback": "Correct."},
   {"text": "11.57 square metres", "feedback": "The semicircle was added rather than removed."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'area-and-perimeter-of-composite-shapes', 10, 'Challenge',
 'A rectangle measures 10 m by 3 m. A semicircle of diameter 3 m is attached to one of the short ends. What is the perimeter of the composite shape, to the nearest hundredth?', 0,
 '[
   {"text": "27.71 metres", "feedback": "Correct."},
   {"text": "30.71 metres", "feedback": "The 3 m end was counted as well as the arc. Once the semicircle is attached, that edge is inside the shape."},
   {"text": "26.00 metres", "feedback": "That is the rectangle on its own. One straight edge is replaced by a curved one."},
   {"text": "32.42 metres", "feedback": "The whole circumference of the circle was used. Only half of it forms the outside edge."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'area-and-perimeter-of-composite-shapes', 11, 'Advanced',
 'A square of side 8 cm has a quarter circle of radius 8 cm removed from one corner. What area remains, to the nearest hundredth?', 0,
 '[
   {"text": "13.73 square centimetres", "feedback": "Correct."},
   {"text": "51.43 square centimetres", "feedback": "A quarter of the CIRCUMFERENCE was subtracted. What is removed is an area."},
   {"text": "50.27 square centimetres", "feedback": "That is the piece that was removed, not what is left behind."},
   {"text": "64.00 square centimetres", "feedback": "That is the whole square. The quarter circle still has to be taken off."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'area-and-perimeter-of-composite-shapes', 12, 'Advanced',
 'A running track encloses a rectangle 50 m by 30 m with a semicircle of diameter 30 m at each end. What is the total enclosed area, to the nearest hundredth?', 2,
 '[
   {"text": "1853.43 square metres", "feedback": "Only one of the two semicircular ends was counted."},
   {"text": "1500.00 square metres", "feedback": "That is the rectangle on its own. The two semicircular ends still have to be added."},
   {"text": "2206.86 square metres", "feedback": "Correct."},
   {"text": "2913.72 square metres", "feedback": "Two FULL circles were added. Each end is only half a circle."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'surface-area-and-volume', 1, 'Easy',
 'Find the volume of a rectangular prism measuring 3 cm by 4 cm by 5 cm.', 3,
 '[
   {"text": "12 cm³", "feedback": "This multiplies only two of the three dimensions. Volume needs all three."},
   {"text": "24 cm³", "feedback": "Check your multiplication of all three numbers once more."},
   {"text": "94 cm³", "feedback": "That is the surface area, the total of all six faces. Volume is the space inside."},
   {"text": "60 cm³", "feedback": "Correct. Volume is length × width × height: 3 × 4 × 5 = 60 cm³."}
 ]'::jsonb,
 'volume-vs-surface-area'),
('MTH1W', 'geometry', 'surface-area-and-volume', 2, 'Easy',
 'What is the volume of a rectangular prism measuring 17 m by 4 m by 10 m?', 2,
 '[
   {"text": "31 cubic metres", "feedback": "The three dimensions were added. Volume multiplies them."},
   {"text": "68 cubic metres", "feedback": "Only two of the three dimensions were multiplied."},
   {"text": "680 cubic metres", "feedback": "Correct."},
   {"text": "556 cubic metres", "feedback": "That is the surface area of this prism, which is measured in square metres."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'surface-area-and-volume', 3, 'Easy',
 'Which formula gives the volume of a sphere?', 0,
 '[
   {"text": "(4/3) x pi x r^3", "feedback": "Correct."},
   {"text": "(1/3) x pi x r^2 x h", "feedback": "That is the volume of a cone."},
   {"text": "4 x pi x r^2", "feedback": "That is the surface area of a sphere, which is measured in square units."},
   {"text": "pi x r^2 x h", "feedback": "That is the volume of a cylinder. A sphere has no height to measure."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'surface-area-and-volume', 4, 'Medium',
 'Find the volume of a cylinder with radius 3 cm and height 10 cm. Use π ≈ 3.14.', 2,
 '[
   {"text": "94.2 cm³", "feedback": "This used πrh (3.14 × 3 × 10) instead of πr²h — the radius needs to be squared, not just multiplied once."},
   {"text": "30 cm³", "feedback": "The π has gone missing. The base is a circle, so its area involves π."},
   {"text": "282.6 cm³", "feedback": "Correct. V = πr²h = 3.14 × 9 × 10 = 282.6 cm³."},
   {"text": "942 cm³", "feedback": "This swaps the radius and height — π × 10² × 3 instead of π × 3² × 10. Double-check which number is the radius."}
 ]'::jsonb,
 'cylinder-volume-formula'),
('MTH1W', 'geometry', 'surface-area-and-volume', 5, 'Medium',
 'Find the surface area of a cube with side length 4 cm.', 1,
 '[
   {"text": "64 cm²", "feedback": "That is the volume, 4³, and it would be in cubic centimetres. Surface area covers the outside."},
   {"text": "96 cm²", "feedback": "Correct. Each face is 4 × 4 = 16 cm², and a cube has 6 faces: 6 × 16 = 96 cm²."},
   {"text": "16 cm²", "feedback": "That is one face only. A cube has six of them."},
   {"text": "24 cm²", "feedback": "This looks like 6 × 4, using the side length rather than the area of a face."}
 ]'::jsonb,
 'surface-area-face-count'),
('MTH1W', 'geometry', 'surface-area-and-volume', 6, 'Medium',
 'A sphere has a diameter of 12 cm. What is its volume, to the nearest hundredth?', 1,
 '[
   {"text": "7238.23 cubic centimetres", "feedback": "The diameter was used in place of the radius. Halve it first."},
   {"text": "904.78 cubic centimetres", "feedback": "Correct."},
   {"text": "226.19 cubic centimetres", "feedback": "That is the volume of a CONE with this radius and height. A sphere is four times as large."},
   {"text": "452.39 cubic centimetres", "feedback": "That is the surface area of this sphere, which is measured in square centimetres."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'surface-area-and-volume', 7, 'Medium',
 'What is the surface area of a rectangular prism measuring 17 m by 4 m by 10 m?', 0,
 '[
   {"text": "556 square metres", "feedback": "Correct."},
   {"text": "680 square metres", "feedback": "That is the volume of this prism, which is measured in cubic metres."},
   {"text": "278 square metres", "feedback": "The three face areas were added but never doubled. Every face has a matching one opposite it."},
   {"text": "62 square metres", "feedback": "The three dimensions were added and doubled. Each face is a product of two dimensions."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'surface-area-and-volume', 8, 'Challenge',
 'A cone has a radius of 8 cm and a slant height of 17.9 cm. What is its vertical height, to the nearest tenth?', 3,
 '[
   {"text": "9.9 cm", "feedback": "The radius was subtracted from the slant height directly. It is their SQUARES that subtract."},
   {"text": "19.6 cm", "feedback": "The squares were added. The slant height is the hypotenuse here, so you subtract."},
   {"text": "25.9 cm", "feedback": "The two lengths were added. The height is shorter than the slant height."},
   {"text": "16.0 cm", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'surface-area-and-volume', 9, 'Challenge',
 'A cylinder has a diameter of 20 m and a height of 13 m. What is its volume, to the nearest hundredth?', 3,
 '[
   {"text": "1445.13 cubic metres", "feedback": "That is the surface area of this cylinder, which is measured in square metres."},
   {"text": "314.16 cubic metres", "feedback": "The height was left out of the calculation."},
   {"text": "16336.28 cubic metres", "feedback": "The diameter was used in place of the radius. Halve it first."},
   {"text": "4084.07 cubic metres", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'surface-area-and-volume', 10, 'Advanced',
 'A baseball has a surface area of 215 square centimetres. What is its radius, to the nearest tenth?', 1,
 '[
   {"text": "5.8 cm", "feedback": "A 2 was used where the formula needs a 4. The surface area of a sphere is four pi r squared."},
   {"text": "4.1 cm", "feedback": "Correct."},
   {"text": "17.1 cm", "feedback": "That is the value of r squared. There is still a square root to take."},
   {"text": "8.3 cm", "feedback": "That is the diameter. The question asks for the radius."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'surface-area-and-volume', 11, 'Advanced',
 'A rectangular prism measures 5 cm by 2 cm by 3 cm. Both its length and its height are doubled. What happens to its volume?', 0,
 '[
   {"text": "It is multiplied by 4", "feedback": "Correct."},
   {"text": "It stays the same", "feedback": "Volume depends on all three dimensions, so changing any of them changes it."},
   {"text": "It is doubled", "feedback": "Only one dimension doubling would double it. Two of them changed here."},
   {"text": "It is multiplied by 8", "feedback": "That is what happens when all THREE dimensions double. The width is unchanged."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'angles-in-triangles-and-circles', 1, 'Easy',
 'Two angles in a triangle are 50° and 60°. What is the third angle?', 2,
 '[
   {"text": "110°", "feedback": "That is the two given angles added together. The third is what remains from the total."},
   {"text": "50°", "feedback": "Check the total: the three angles in a triangle must add to 180°."},
   {"text": "70°", "feedback": "Correct. 180 − 50 − 60 = 70°."},
   {"text": "250°", "feedback": "This adds when it should subtract. A single angle in a triangle cannot exceed 180°."}
 ]'::jsonb,
 'angle-sum-triangle'),
('MTH1W', 'geometry', 'angles-in-triangles-and-circles', 2, 'Easy',
 'Two angles of a triangle each measure 70 degrees. What is the third angle?', 1,
 '[
   {"text": "60 degrees", "feedback": "That would make the triangle equilateral, but two of these angles are 70."},
   {"text": "40 degrees", "feedback": "Correct."},
   {"text": "20 degrees", "feedback": "The angles of a triangle add to 180 degrees, not 160."},
   {"text": "140 degrees", "feedback": "That is the sum of the two given angles, not what is left over."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'angles-in-triangles-and-circles', 3, 'Easy',
 'An angle is inscribed in a semicircle. What does it measure?', 1,
 '[
   {"text": "It depends where the point sits on the arc", "feedback": "Every point on the arc gives the same inscribed angle here."},
   {"text": "90 degrees, a right angle wherever the point sits", "feedback": "Correct."},
   {"text": "180 degrees", "feedback": "That is the arc of the semicircle itself. The inscribed angle is half of it."},
   {"text": "45 degrees", "feedback": "That would be half of a right angle. An inscribed angle is half the angle at the centre."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'angles-in-triangles-and-circles', 4, 'Medium',
 'An isosceles triangle has an apex angle of 100 degrees. What does each base angle measure?', 3,
 '[
   {"text": "100 degrees", "feedback": "Three angles of 100 degrees would add to far more than a triangle allows."},
   {"text": "80 degrees", "feedback": "That is what the two base angles add to. They still have to be shared between the two of them."},
   {"text": "50 degrees", "feedback": "The 100 was halved. It is the REMAINING 80 degrees that gets shared."},
   {"text": "40 degrees", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'angles-in-triangles-and-circles', 5, 'Medium',
 'An arc subtends an angle of 35 degrees at a point on the circumference. What angle does the same arc subtend at the centre?', 3,
 '[
   {"text": "145 degrees", "feedback": "That subtracts from 180. The relationship here is a doubling."},
   {"text": "17.5 degrees", "feedback": "That halves it. The angle at the CENTRE is the larger of the two."},
   {"text": "35 degrees", "feedback": "Equal angles come from two points on the circumference. The centre is different."},
   {"text": "70 degrees", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'angles-in-triangles-and-circles', 6, 'Challenge',
 'An exterior angle of a triangle measures 120 degrees. One of the two opposite interior angles is 45 degrees. What is the other?', 1,
 '[
   {"text": "15 degrees", "feedback": "Check the subtraction. The exterior angle is 120, not 60."},
   {"text": "75 degrees", "feedback": "Correct."},
   {"text": "60 degrees", "feedback": "That is the interior angle beside the exterior one, taken as 180 minus 120. It is not one of the two opposite interior angles."},
   {"text": "165 degrees", "feedback": "The two were added. The exterior angle EQUALS their sum, so one subtracts from it."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'angles-in-triangles-and-circles', 7, 'Challenge',
 'The three angles of a triangle measure 2x, 3x + 10 and 4x - 1 degrees. What is x?', 0,
 '[
   {"text": "x = 19", "feedback": "Correct."},
   {"text": "x = 20", "feedback": "The two constants were dropped before dividing. The +10 and the -1 have to be dealt with first."},
   {"text": "x = 21", "feedback": "The constants were added to the 180 instead of being taken off it."},
   {"text": "x = 39", "feedback": "A total of 360 was used. The interior angles of a TRIANGLE add to 180."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'angles-in-triangles-and-circles', 8, 'Advanced',
 'The three angles of a triangle are in the ratio 2 to 3 to 4. What is the largest angle?', 3,
 '[
   {"text": "60 degrees", "feedback": "That is the middle share of the three."},
   {"text": "90 degrees", "feedback": "That assumes the triangle is right-angled. Share 180 out in the given ratio instead."},
   {"text": "40 degrees", "feedback": "That is the SMALLEST of the three shares. The question asks for the largest."},
   {"text": "80 degrees", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'angles-in-triangles-and-circles', 9, 'Advanced',
 'Two inscribed angles in a circle are subtended by the same arc. One measures 3x degrees and the other measures x + 40 degrees. What is x?', 1,
 '[
   {"text": "x = -20", "feedback": "The 40 was moved across without changing sign."},
   {"text": "x = 20", "feedback": "Correct."},
   {"text": "x = 10", "feedback": "The two expressions were added and set equal to 40 rather than being set equal to each other."},
   {"text": "x = 35", "feedback": "The two were treated as supplementary. Inscribed angles on the same arc are EQUAL."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'angle-relationships-and-polygons', 1, 'Easy',
 'What do the interior angles of a quadrilateral add up to?', 1,
 '[
   {"text": "180°", "feedback": "That is the total for a triangle. A quadrilateral splits into two triangles."},
   {"text": "360°", "feedback": "Correct. A quadrilateral can be divided into two triangles, so 2 × 180° = 360°."},
   {"text": "90°", "feedback": "That is a single right angle, not the total of four angles."},
   {"text": "540°", "feedback": "That is the total for a pentagon, which splits into three triangles rather than two."}
 ]'::jsonb,
 'angle-sum-polygon'),
('MTH1W', 'geometry', 'angle-relationships-and-polygons', 2, 'Easy',
 'What is the complement of a 35° angle?', 3,
 '[
   {"text": "145°", "feedback": "That is the supplement, which pairs with the angle to make 180°."},
   {"text": "325°", "feedback": "That pairs to make a full turn of 360°, which is neither complement nor supplement."},
   {"text": "35°", "feedback": "An angle is its own complement only at 45°, since 45 + 45 = 90."},
   {"text": "55°", "feedback": "Correct. Complementary angles add to 90°, and 90 − 35 = 55°."}
 ]'::jsonb,
 'complement-vs-supplement'),
('MTH1W', 'geometry', 'angle-relationships-and-polygons', 3, 'Easy',
 'Two angles are complementary. One of them measures 35 degrees. What is the other?', 3,
 '[
   {"text": "145 degrees", "feedback": "That pair would be supplementary. Complementary angles add to a right angle."},
   {"text": "65 degrees", "feedback": "Check the subtraction. A right angle is 90 degrees."},
   {"text": "35 degrees", "feedback": "Two equal 35 degree angles do not add to a right angle."},
   {"text": "55 degrees", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'angle-relationships-and-polygons', 4, 'Easy',
 'What is the sum of the interior angles of an octagon?', 1,
 '[
   {"text": "1440 degrees", "feedback": "The 2 was not subtracted from the number of sides before multiplying."},
   {"text": "1080 degrees", "feedback": "Correct."},
   {"text": "900 degrees", "feedback": "That is the sum for a seven-sided polygon. An octagon has eight sides."},
   {"text": "360 degrees", "feedback": "That is the sum of the EXTERIOR angles, which is the same for every polygon."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'angle-relationships-and-polygons', 5, 'Medium',
 'Two parallel lines are cut by a transversal. One of a pair of co-interior angles measures 65 degrees. What is the other?', 0,
 '[
   {"text": "115 degrees", "feedback": "Correct."},
   {"text": "25 degrees", "feedback": "That pair would be complementary. Co-interior angles add to 180 degrees."},
   {"text": "295 degrees", "feedback": "The 65 was subtracted from a full turn. Co-interior angles add to a straight line."},
   {"text": "65 degrees", "feedback": "Alternate interior and corresponding angles are equal. Co-interior angles are the pair that add to a straight line."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'angle-relationships-and-polygons', 6, 'Medium',
 'A regular polygon has interior angles of 140 degrees each. How many sides does it have?', 1,
 '[
   {"text": "10", "feedback": "A ten-sided polygon has interior angles of 144 degrees, which is slightly too large."},
   {"text": "9", "feedback": "Correct."},
   {"text": "8", "feedback": "An octagon has interior angles of 135 degrees. This polygon needs slightly larger ones."},
   {"text": "7", "feedback": "A seven-sided polygon has interior angles under 130 degrees."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'angle-relationships-and-polygons', 7, 'Challenge',
 'The interior angles of a pentagon measure 110, 138, 100, x and 2x degrees. What is x?', 2,
 '[
   {"text": "124", "feedback": "That uses a total of 720, which belongs to a six-sided polygon."},
   {"text": "48", "feedback": "That uses a total of 540 but treats the last two angles as x and x rather than x and 2x."},
   {"text": "64", "feedback": "Correct."},
   {"text": "128", "feedback": "That is the value of the LARGER unknown angle. The question asks for x itself."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'angle-relationships-and-polygons', 8, 'Challenge',
 'Each exterior angle of a regular polygon measures 24 degrees. How many sides does it have?', 0,
 '[
   {"text": "15 sides", "feedback": "Correct."},
   {"text": "8 sides", "feedback": "That comes from dividing 180 by 24 and rounding. The exterior angles add to 360."},
   {"text": "24 sides", "feedback": "That copies the angle straight across. Divide a full turn by the angle instead."},
   {"text": "30 sides", "feedback": "Each vertex was counted as having two exterior angles, so 720 was divided by 24 instead of one full turn."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'angle-relationships-and-polygons', 9, 'Advanced',
 'Two parallel lines are cut by a transversal. An angle of 125 degrees is corresponding to angle z, and angle y sits on a straight line with z. What is y?', 1,
 '[
   {"text": "125 degrees", "feedback": "That is the value of z itself. Angle y is the one that completes the straight line with it."},
   {"text": "55 degrees", "feedback": "Correct."},
   {"text": "35 degrees", "feedback": "That subtracts from 90. Angles on a straight line add to 180."},
   {"text": "235 degrees", "feedback": "That subtracts from a full turn. Angles on a straight line add to 180."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'angle-relationships-and-polygons', 10, 'Advanced',
 'In a regular polygon each interior angle is three times its exterior angle. How many sides does the polygon have?', 2,
 '[
   {"text": "12 sides", "feedback": "That polygon has interior angles of 150 and exterior angles of 30, a ratio of five to one."},
   {"text": "4 sides", "feedback": "A square has interior angles of 90 and exterior angles of 90, a ratio of one to one."},
   {"text": "8 sides", "feedback": "Correct."},
   {"text": "6 sides", "feedback": "A hexagon has interior angles of 120 and exterior angles of 60, which is a ratio of two to one."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'slope-and-rate-of-change', 1, 'Easy',
 'What is the slope of   y = 4x − 7 ?', 0,
 '[
   {"text": "4", "feedback": "Correct. In y = mx + b the slope is m, the number multiplying x."},
   {"text": "−7", "feedback": "That is the y-intercept, where the line crosses the vertical axis."},
   {"text": "7", "feedback": "That is the intercept with its sign changed. The slope is elsewhere in the equation."},
   {"text": "4x", "feedback": "Close, but the slope is just the number. The x is not part of it."}
 ]'::jsonb,
 'slope-vs-intercept-confusion'),
('MTH1W', 'linear-relations-part-1', 'slope-and-rate-of-change', 2, 'Easy',
 'Find the slope of the line through (1, 2) and (3, 8).', 2,
 '[
   {"text": "2", "feedback": "That is the run, the change in x. Slope compares it to the rise."},
   {"text": "1/3", "feedback": "The fraction is upside down. Slope is rise over run."},
   {"text": "3", "feedback": "Correct. The rise is 8 − 2 = 6, the run is 3 − 1 = 2, and 6 ÷ 2 = 3."},
   {"text": "6", "feedback": "That is the rise on its own. It still needs comparing to the run."}
 ]'::jsonb,
 'slope-formula-inverted'),
('MTH1W', 'linear-relations-part-1', 'slope-and-rate-of-change', 3, 'Easy',
 'What is the slope of any line parallel to   y = 5x + 1 ?', 2,
 '[
   {"text": "1", "feedback": "That is the y-intercept. Parallel lines can have any intercept — it is the slope that must match."},
   {"text": "−1/5", "feedback": "That is the perpendicular slope, which gives a line crossing at a right angle instead."},
   {"text": "5", "feedback": "Correct. Parallel lines have equal slopes, so any line parallel to this one also has slope 5."},
   {"text": "−5", "feedback": "This line would slope downwards while the original slopes up, so they would cross rather than stay parallel."}
 ]'::jsonb,
 'parallel-slope'),
('MTH1W', 'linear-relations-part-1', 'slope-and-rate-of-change', 4, 'Easy',
 'Moving from one point on a line to another, you go up 6 and right 3. What is the slope of the line?', 0,
 '[
   {"text": "2", "feedback": "Correct."},
   {"text": "1/2", "feedback": "The fraction is upside down. Slope is rise over run, not run over rise."},
   {"text": "9", "feedback": "The two numbers were added. Slope divides the rise by the run."},
   {"text": "18", "feedback": "The two numbers were multiplied. Slope divides the rise by the run."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'slope-and-rate-of-change', 5, 'Easy',
 'What is the slope of a horizontal line?', 1,
 '[
   {"text": "1", "feedback": "A slope of 1 rises one unit for every unit across, which is a diagonal line."},
   {"text": "0", "feedback": "Correct."},
   {"text": "It depends on the line", "feedback": "Every horizontal line behaves the same way. The rise is always zero."},
   {"text": "Undefined", "feedback": "That belongs to a vertical line, where the run is zero and you would be dividing by zero."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'slope-and-rate-of-change', 6, 'Medium',
 'What does a line with slope 0 look like?', 0,
 '[
   {"text": "Horizontal", "feedback": "Correct. Zero slope means no rise for any run, so the line stays level."},
   {"text": "Vertical", "feedback": "A vertical line has an undefined slope, because the run is zero and you cannot divide by it."},
   {"text": "A 45 degree diagonal", "feedback": "That is slope 1, where the rise equals the run."},
   {"text": "A curve", "feedback": "Any equation of the form y = mx + b graphs as a straight line, whatever m is."}
 ]'::jsonb,
 'zero-slope-vs-undefined'),
('MTH1W', 'linear-relations-part-1', 'slope-and-rate-of-change', 7, 'Medium',
 'What is the slope of the line through A(5, -7) and B(1, 3)?', 2,
 '[
   {"text": "-2/5", "feedback": "The fraction is upside down. Slope divides the change in y by the change in x."},
   {"text": "2/5", "feedback": "The fraction is upside down and the sign was dropped as well."},
   {"text": "-5/2", "feedback": "Correct."},
   {"text": "5/2", "feedback": "The run came out negative here, because you move left from A to B. That sign belongs in the answer."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'slope-and-rate-of-change', 8, 'Medium',
 'What is the slope of the line through P1(-4, 6) and P2(-2, 10)?', 1,
 '[
   {"text": "1/2", "feedback": "The fraction is upside down. Slope divides the change in y by the change in x."},
   {"text": "2", "feedback": "Correct."},
   {"text": "8", "feedback": "The two y-values were added rather than subtracted, so the top of the fraction is a total instead of a change."},
   {"text": "-2", "feedback": "Both x-values are negative, but the change between them is positive. Moving from -4 to -2 is a move to the right."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'slope-and-rate-of-change', 9, 'Challenge',
 'A table has x-values -20, -18, -16, -14 and y-values 75, 70, 65, 60. What is the rate of change?', 1,
 '[
   {"text": "-5", "feedback": "That is the change in y between rows. The x-values step by 2, so that has to be divided out."},
   {"text": "-5/2", "feedback": "Correct."},
   {"text": "5/2", "feedback": "The y-values are falling, so the rate of change is negative."},
   {"text": "-2/5", "feedback": "The fraction is upside down. Rate of change divides the change in y by the change in x."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'slope-and-rate-of-change', 10, 'Advanced',
 'A line with slope -2 passes through the points (a, 5) and (7, -3). What is the value of a?', 3,
 '[
   {"text": "a = 5", "feedback": "That is the y-value of the first point. The unknown here sits in the x slot."},
   {"text": "a = 11", "feedback": "The subtraction was done in opposite orders on the top and bottom. Keep both going the same way."},
   {"text": "a = -3", "feedback": "That is the y-value of the second point, not the missing x-value."},
   {"text": "a = 3", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'standard-form-and-intercepts', 1, 'Easy',
 'What is the y-intercept of   y = −2x + 5 ?', 1,
 '[
   {"text": "−2", "feedback": "That is the slope, which tells you how steep the line is rather than where it starts."},
   {"text": "5", "feedback": "Correct. Setting x = 0 gives y = 5, so the line crosses the y-axis there."},
   {"text": "2", "feedback": "That is the slope without its sign. The intercept is the constant on the end."},
   {"text": "−5", "feedback": "Right number, wrong sign. The 5 is being added, not subtracted."}
 ]'::jsonb,
 'reads-sign-from-equation'),
('MTH1W', 'linear-relations-part-1', 'standard-form-and-intercepts', 2, 'Easy',
 'What is the x-intercept of the line 4x + 6y = 12?', 0,
 '[
   {"text": "(3, 0)", "feedback": "Correct."},
   {"text": "(12, 0)", "feedback": "The 4 in front of x was never divided out."},
   {"text": "(0, 3)", "feedback": "The number is right, but it is written in the wrong slot. An x-intercept has y equal to zero."},
   {"text": "(0, 2)", "feedback": "That is the y-intercept. For the x-intercept you set y to zero instead."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'standard-form-and-intercepts', 3, 'Medium',
 'Where does   y = 3x − 6   cross the x-axis?', 1,
 '[
   {"text": "(0, −6)", "feedback": "That is the y-intercept, found by setting x = 0. Crossing the x-axis means y = 0 instead."},
   {"text": "(2, 0)", "feedback": "Correct. Setting y = 0 gives 3x = 6, so x = 2."},
   {"text": "(−2, 0)", "feedback": "Check the sign. Solving 3x − 6 = 0 means adding 6 to both sides."},
   {"text": "(6, 0)", "feedback": "It looks like the division by 3 was missed after moving the 6 across."}
 ]'::jsonb,
 'intercept-solves-wrong-variable'),
('MTH1W', 'linear-relations-part-1', 'standard-form-and-intercepts', 4, 'Medium',
 'Convert y = -4x - 11 to standard form, with integer values and a positive coefficient on x.', 0,
 '[
   {"text": "4x + y = -11", "feedback": "Correct."},
   {"text": "4x + y = 11", "feedback": "The x term was moved correctly, but the constant on the right kept the wrong sign."},
   {"text": "-4x + y = -11", "feedback": "The -4x was carried to the other side but kept its sign. A term changes sign when it crosses the equals sign."},
   {"text": "4x - y = -11", "feedback": "The y term was flipped as well, but it never crossed the equals sign, so its sign should have stayed."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'standard-form-and-intercepts', 5, 'Medium',
 'What is the y-intercept of the line 3x - 6y = 24?', 3,
 '[
   {"text": "(0, 4)", "feedback": "The sign was lost. Dividing 24 by -6 gives a negative."},
   {"text": "(0, -24)", "feedback": "The -6 in front of y was never divided out."},
   {"text": "(8, 0)", "feedback": "That is the x-intercept. For the y-intercept you set x to zero instead."},
   {"text": "(0, -4)", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'standard-form-and-intercepts', 6, 'Challenge',
 'Convert y = (5/3)x - 8 to standard form, with integers and a positive coefficient on x.', 0,
 '[
   {"text": "5x - 3y = 24", "feedback": "Correct."},
   {"text": "5x + 3y = 24", "feedback": "The equation was negated to make the x coefficient positive, but the y term was left with its old sign."},
   {"text": "5x - 3y = -24", "feedback": "The constant was multiplied by 3 but kept the wrong sign after both terms moved."},
   {"text": "5x - 3y = 8", "feedback": "Only the x term was multiplied by 3 when the fraction was cleared. The constant took no part in it."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'standard-form-and-intercepts', 7, 'Challenge',
 'What is the x-intercept of the line 2x - 5y = 20?', 2,
 '[
   {"text": "(20, 0)", "feedback": "The 2 in front of x was never divided out."},
   {"text": "(0, 10)", "feedback": "The number is right, but it is in the wrong slot. An x-intercept has y equal to zero."},
   {"text": "(10, 0)", "feedback": "Correct."},
   {"text": "(0, -4)", "feedback": "That is the y-intercept. For the x-intercept you set y to zero instead."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'standard-form-and-intercepts', 8, 'Advanced',
 'The line 4x + 6y = 12 has intercepts at (3, 0) and (0, 2). Use them to find the slope of the line.', 0,
 '[
   {"text": "-2/3", "feedback": "Correct."},
   {"text": "-3/2", "feedback": "The fraction is upside down. Slope divides the change in y by the change in x."},
   {"text": "3/2", "feedback": "The fraction is upside down and the sign was dropped as well."},
   {"text": "2/3", "feedback": "Going from the x-intercept to the y-intercept you move left, so the run is negative."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'slope-intercept-form', 1, 'Easy',
 'Is the point (2, 5) on the line   y = 2x + 1 ?', 0,
 '[
   {"text": "Yes", "feedback": "Correct. Substituting x = 2 gives 2(2) + 1 = 5, which matches the y-value."},
   {"text": "No", "feedback": "Try substituting x = 2 into the equation and compare the result to 5."},
   {"text": "Only if the line is extended", "feedback": "A straight line already continues forever in both directions, so this is not a factor."},
   {"text": "There is not enough information", "feedback": "There is enough — substitute the x-value and see whether the y-value comes out right."}
 ]'::jsonb,
 'point-verification'),
('MTH1W', 'linear-relations-part-1', 'slope-intercept-form', 2, 'Easy',
 'For the line y = 3x - 5, what is the y-intercept?', 2,
 '[
   {"text": "3", "feedback": "That is the slope. In y = mx + b the intercept is the constant term."},
   {"text": "-3", "feedback": "That is the slope with a sign added. The intercept is the constant term."},
   {"text": "-5", "feedback": "Correct."},
   {"text": "5", "feedback": "The sign was dropped. The constant is being subtracted."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'slope-intercept-form', 3, 'Medium',
 'State the slope and the y-intercept of the line y = -3x - 1.', 1,
 '[
   {"text": "Slope -1, y-intercept -3", "feedback": "The two have been swapped. In y = mx + b the slope is what multiplies x."},
   {"text": "Slope -3, y-intercept -1", "feedback": "Correct."},
   {"text": "Slope 3, y-intercept -1", "feedback": "The minus in front of the 3 belongs to the slope."},
   {"text": "Slope -3, y-intercept 1", "feedback": "The constant is being subtracted, so the intercept is negative."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'slope-intercept-form', 4, 'Medium',
 'What is the equation of the horizontal line through the point (2, 4)?', 3,
 '[
   {"text": "y = 2x", "feedback": "That line has a slope of 2, so it is not horizontal."},
   {"text": "x = 4", "feedback": "That is vertical, and it uses the wrong coordinate as well."},
   {"text": "x = 2", "feedback": "That is a vertical line. It holds x fixed while y varies."},
   {"text": "y = 4", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'slope-intercept-form', 5, 'Challenge',
 'Rearrange 3x - 6y = 24 into slope-intercept form.', 3,
 '[
   {"text": "y = 2x - 4", "feedback": "The fraction was inverted. Divide the 3 by the 6, not the other way round."},
   {"text": "y = -(1/2)x - 4", "feedback": "Dividing -3x by -6 gives a positive result. Two negatives make a positive."},
   {"text": "y = (1/2)x + 4", "feedback": "Dividing 24 by -6 gives a negative constant."},
   {"text": "y = (1/2)x - 4", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'slope-intercept-form', 6, 'Challenge',
 'A line has a slope of 0 and passes through the point (3, 1). What is its equation?', 1,
 '[
   {"text": "y = x + 1", "feedback": "That line has a slope of 1, so it is not flat."},
   {"text": "y = 1", "feedback": "Correct."},
   {"text": "x = 3", "feedback": "That is a vertical line, which has an undefined slope rather than a slope of zero."},
   {"text": "y = 3", "feedback": "The wrong coordinate was used. A horizontal line is fixed at its y-value."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'slope-intercept-form', 7, 'Advanced',
 'A vertical line passes through the point (2, 4). What are its slope and y-intercept?', 0,
 '[
   {"text": "Undefined slope and no y-intercept", "feedback": "Correct."},
   {"text": "Slope 0 and no y-intercept", "feedback": "The second part is right, but dividing by a run of zero is what makes the slope undefined, not zero."},
   {"text": "Slope 0 and y-intercept 4", "feedback": "A slope of zero belongs to a horizontal line. A vertical line has a run of zero instead."},
   {"text": "Undefined slope and y-intercept 2", "feedback": "The slope is right, but this line runs parallel to the y-axis, so it never crosses it."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'finding-the-equation-of-a-line', 1, 'Easy',
 'Write the equation of a line with slope 2 and y-intercept −3.', 1,
 '[
   {"text": "y = −3x + 2", "feedback": "The slope and the intercept have swapped places. In y = mx + b, which one multiplies x?"},
   {"text": "y = 2x − 3", "feedback": "Correct. The slope 2 goes in front of x, and the intercept −3 goes on the end."},
   {"text": "y = 2x + 3", "feedback": "Almost. Check the sign on the intercept — it is below the origin."},
   {"text": "y = 2 − 3x", "feedback": "This has slope −3 and intercept 2, which is the two values the wrong way round."}
 ]'::jsonb,
 'slope-intercept-form-order'),
('MTH1W', 'linear-relations-part-1', 'finding-the-equation-of-a-line', 2, 'Easy',
 'In the relation   C = 40h + 50,   what does the 50 represent?', 3,
 '[
   {"text": "The cost per hour", "feedback": "That is the 40, the number attached to h. The 50 stands apart from h."},
   {"text": "The number of hours", "feedback": "Hours are represented by h, the variable. The 50 is a fixed number."},
   {"text": "The total cost", "feedback": "The total cost is C, which changes as h changes. The 50 stays the same."},
   {"text": "The fixed starting cost", "feedback": "Correct. When h = 0 the cost is already 50, so it is the fixed or initial value."}
 ]'::jsonb,
 'confuses-fixed-and-rate'),
('MTH1W', 'linear-relations-part-1', 'finding-the-equation-of-a-line', 3, 'Easy',
 'A line has a slope of 2 and passes through (0, 7). What is its equation?', 2,
 '[
   {"text": "y = 2x - 7", "feedback": "The point has a positive y-value, so the constant is positive."},
   {"text": "y = 2x", "feedback": "That line passes through the origin. This one crosses the y-axis higher up."},
   {"text": "y = 2x + 7", "feedback": "Correct."},
   {"text": "y = 7x + 2", "feedback": "The slope and the intercept have swapped places. In y = mx + b the slope multiplies x."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'finding-the-equation-of-a-line', 4, 'Medium',
 'A plumber charges a $50 call-out fee plus $40 per hour. What is the cost of a 3 hour job?', 2,
 '[
   {"text": "$120", "feedback": "This is the hourly charge only. The call-out fee is paid on top."},
   {"text": "$90", "feedback": "It looks like the $40 was charged once rather than for each of the three hours."},
   {"text": "$170", "feedback": "Correct. Three hours at $40 is $120, plus the $50 fee gives $170."},
   {"text": "$270", "feedback": "This charges the $50 fee for each hour as well. The call-out fee is a one-off."}
 ]'::jsonb,
 'confuses-fixed-and-rate'),
('MTH1W', 'linear-relations-part-1', 'finding-the-equation-of-a-line', 5, 'Medium',
 'Find the equation of the line with slope -2 that passes through (-3, -7).', 3,
 '[
   {"text": "y = -2x - 1", "feedback": "When -2 is multiplied by -3 the result is positive 6. Check the sign in that step."},
   {"text": "y = -2x + 13", "feedback": "The constant was moved to the wrong side when solving for b."},
   {"text": "y = -2x - 7", "feedback": "The y-value of the point was used as the intercept directly. It is only the intercept if x is zero."},
   {"text": "y = -2x - 13", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'finding-the-equation-of-a-line', 6, 'Challenge',
 'Find the equation of the line that passes through A(4, -3) and B(2, 5).', 1,
 '[
   {"text": "y = 4x - 19", "feedback": "The slope lost its sign. Going from A to B the y rises while the x falls."},
   {"text": "y = -4x + 13", "feedback": "Correct."},
   {"text": "y = -4x + 5", "feedback": "The slope is right, but the y-value of the other point was used as the intercept."},
   {"text": "y = -4x - 3", "feedback": "The slope is right, but the y-value of a point was used as the intercept. It is only the intercept if x is zero."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'finding-the-equation-of-a-line', 7, 'Advanced',
 'Find the equation of the line parallel to y = -(3/5)x + 10 that passes through (20, -4).', 2,
 '[
   {"text": "y = (5/3)x - 4", "feedback": "That is the negative reciprocal, which gives a perpendicular line, and the point was used as the intercept."},
   {"text": "y = -(3/5)x + 10", "feedback": "The slope is right, but this is the original line. It does not pass through the given point."},
   {"text": "y = -(3/5)x + 8", "feedback": "Correct."},
   {"text": "y = -(3/5)x - 16", "feedback": "The -12 was subtracted rather than moved across. Moving it makes it an addition."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'finding-the-equation-of-a-line', 8, 'Advanced',
 'Find the equation of the line perpendicular to 2x - y + 4 = 0 that passes through (-2, 5).', 2,
 '[
   {"text": "y = 2x + 9", "feedback": "That keeps the slope of the original line, which gives a parallel line."},
   {"text": "y = (1/2)x + 6", "feedback": "The fraction was flipped but the sign was kept. A negative reciprocal changes both."},
   {"text": "y = -(1/2)x + 4", "feedback": "Correct."},
   {"text": "y = -(1/2)x + 6", "feedback": "The slope is right, but -1/2 multiplied by -2 gives a positive 1, which changes the constant."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'finding-the-equation-of-a-line', 9, 'Advanced',
 'Find the equation of the line that passes through (-1, 8) and (3, -4).', 1,
 '[
   {"text": "y = -(1/3)x + 5", "feedback": "The slope fraction is upside down. Divide the change in y by the change in x."},
   {"text": "y = -3x + 5", "feedback": "Correct."},
   {"text": "y = -3x + 11", "feedback": "The slope is right, but -3 multiplied by -1 gives a positive 3, which changes the constant."},
   {"text": "y = 3x + 11", "feedback": "The slope lost its sign. The y-value falls as the x-value rises here."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'integers', 1, 'Easy',
 'Evaluate:   −3 + 7 × 2', 2,
 '[
   {"text": "8", "feedback": "It looks like you worked left to right, doing −3 + 7 first. Multiplication comes before addition."},
   {"text": "−14", "feedback": "This adds first, then multiplies. Check the order of operations: which comes first?"},
   {"text": "11", "feedback": "Correct. Multiplication first gives 7 × 2 = 14, then −3 + 14 = 11."},
   {"text": "17", "feedback": "Close, but check the sign on the 3. You are adding it rather than subtracting."}
 ]'::jsonb,
 'order-of-operations'),
('MTH1W', 'number-sense', 'integers', 2, 'Easy',
 'Evaluate:   (−12) ÷ (−3) + 5', 0,
 '[
   {"text": "9", "feedback": "Correct. A negative divided by a negative gives +4, and 4 + 5 = 9."},
   {"text": "1", "feedback": "Check the sign of the division. Two negatives divided give a positive result."},
   {"text": "−9", "feedback": "The size is right but the sign is not. Dividing two negatives gives a positive."},
   {"text": "−1.4", "feedback": "It looks like the addition happened before the division. Division comes first."}
 ]'::jsonb,
 'sign-error-negatives'),
('MTH1W', 'number-sense', 'integers', 3, 'Easy',
 'Which of these is NOT an integer?', 3,
 '[
   {"text": "13", "feedback": "Positive whole numbers are integers. Look for the one that is not whole."},
   {"text": "-7", "feedback": "Negative whole numbers are integers. Look for the one that is not whole."},
   {"text": "0", "feedback": "Zero is an integer. Look for the one that is not a whole number."},
   {"text": "2.5", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'integers', 4, 'Easy',
 'Evaluate: -5 + 2', 1,
 '[
   {"text": "3", "feedback": "The sign is wrong. Starting at -5 and moving 2 to the right does not reach the positive side."},
   {"text": "-3", "feedback": "Correct."},
   {"text": "-7", "feedback": "Adding a positive moves RIGHT along the number line, not further left."},
   {"text": "7", "feedback": "That adds the two sizes and ignores the negative sign on the first number."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'integers', 5, 'Easy',
 'Evaluate: 15 - (-6)', 1,
 '[
   {"text": "9", "feedback": "Subtracting a negative is not the same as subtracting a positive. Add the opposite."},
   {"text": "21", "feedback": "Correct."},
   {"text": "-21", "feedback": "The sign is wrong. Both numbers here pull the answer above 15, not below zero."},
   {"text": "-9", "feedback": "Two mistakes at once: the double negative was not resolved, and the sign was flipped."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'integers', 6, 'Medium',
 'Evaluate:   5 − 2(3 − 7)', 3,
 '[
   {"text": "−3", "feedback": "You worked left to right. The bracket has to be done first, before the subtraction."},
   {"text": "12", "feedback": "Close. Recheck the sign: 3 − 7 is negative, and subtracting a negative adds."},
   {"text": "−13", "feedback": "The size is right but the sign is flipped. Subtracting 2 × (−4) means subtracting a negative."},
   {"text": "13", "feedback": "Correct. The bracket gives −4, then 2 × (−4) = −8, and 5 − (−8) = 13."}
 ]'::jsonb,
 'distributive-sign-error'),
('MTH1W', 'number-sense', 'integers', 7, 'Medium',
 'Evaluate: -6 x (-4) + 3', 2,
 '[
   {"text": "-27", "feedback": "The arithmetic is right but the sign is not. Two negatives multiplied do not stay negative."},
   {"text": "42", "feedback": "That did the addition before the multiplication and dropped both minus signs on the way."},
   {"text": "27", "feedback": "Correct."},
   {"text": "-21", "feedback": "The product of two negatives is positive. That treated it as negative."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'integers', 8, 'Medium',
 'Evaluate: 20 divided by (-4) - 3', 2,
 '[
   {"text": "-2", "feedback": "The 3 was added at the end instead of taken away."},
   {"text": "8", "feedback": "Two mistakes: the sign of the quotient, and then subtracting in the wrong direction."},
   {"text": "-8", "feedback": "Correct."},
   {"text": "-20/7", "feedback": "That divided 20 by the whole expression -4 - 3 instead of dividing first."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'integers', 9, 'Challenge',
 'The temperature at 6 pm was 4 degrees. Overnight it fell 11 degrees, then rose 3 degrees by morning. What was the morning temperature?', 2,
 '[
   {"text": "-10 degrees", "feedback": "The fall was handled correctly but the rise was subtracted as well. A rise moves back up."},
   {"text": "4 degrees", "feedback": "That treated the fall and the rise as cancelling out. They are different sizes."},
   {"text": "-4 degrees", "feedback": "Correct."},
   {"text": "18 degrees", "feedback": "That added the fall instead of subtracting it. A fall moves down the number line."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'integers', 10, 'Challenge',
 'A diver is 12 m below sea level. She descends until she is 3 times as deep. What is her new depth, written as an integer?', 3,
 '[
   {"text": "-4 m", "feedback": "That divided by 3. Going three times as deep makes the number further from zero, not closer."},
   {"text": "36 m", "feedback": "The size is right but the sign is not. Below sea level stays negative."},
   {"text": "-15 m", "feedback": "That went 3 metres deeper rather than to 3 times the depth."},
   {"text": "-36 m", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'integers', 11, 'Advanced',
 'A submarine sits at -80 m. It rises 25 m, then descends twice the distance it rose. What is its final depth?', 2,
 '[
   {"text": "-5 m", "feedback": "That treated both moves as upward. Only the first one is a rise."},
   {"text": "-55 m", "feedback": "That stopped after the rise. There is still a descent to apply."},
   {"text": "-105 m", "feedback": "Correct."},
   {"text": "-130 m", "feedback": "That descended from the starting depth. The rise happens first."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'integers', 12, 'Advanced',
 'A student writes: -3 squared equals 9. Their teacher marks it wrong. Why?', 2,
 '[
   {"text": "The answer should be -6, for the same reason", "feedback": "Two mistakes: squaring is not doubling, and the sign handling is separate."},
   {"text": "Nothing is wrong; the teacher made a mistake", "feedback": "Brackets matter here. Consider what the exponent is actually attached to."},
   {"text": "The answer should be -9, because without brackets only the 3 is squared", "feedback": "Correct."},
   {"text": "The answer should be 6, because squaring means doubling", "feedback": "Squaring means multiplying a number by itself, not adding it to itself."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'integers', 13, 'Advanced',
 'The triangular numbers begin 1, 3, 6, 10, 15, ... What is the 10th triangular number?', 3,
 '[
   {"text": "50", "feedback": "That added 5 to the 9th term. Each step adds the term number itself."},
   {"text": "100", "feedback": "That squared the term number. The rule multiplies by the NEXT number and then halves."},
   {"text": "45", "feedback": "That is the 9th. One more step is needed."},
   {"text": "55", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'powers-and-exponent-form', 1, 'Easy',
 'Evaluate:   (−2)³', 1,
 '[
   {"text": "8", "feedback": "The size is right, but check the sign. An odd number of negative factors keeps the result negative."},
   {"text": "−8", "feedback": "Correct. (−2) × (−2) × (−2) gives 4 × (−2) = −8."},
   {"text": "−6", "feedback": "That is −2 × 3. The exponent means multiply −2 by itself three times, not multiply by 3."},
   {"text": "6", "feedback": "This multiplies rather than using the exponent, and drops the sign as well."}
 ]'::jsonb,
 'negative-base-exponent-parity'),
('MTH1W', 'powers', 'powers-and-exponent-form', 2, 'Easy',
 'Evaluate:   2⁴ ÷ 2²', 0,
 '[
   {"text": "4", "feedback": "Correct. 16 ÷ 4 = 4. You can also subtract the exponents: 2⁴⁻² = 2² = 4."},
   {"text": "2", "feedback": "It looks like you divided the exponents, 4 ÷ 2. When dividing powers of the same base you subtract them instead."},
   {"text": "8", "feedback": "That is 2³. Check the subtraction of the exponents once more."},
   {"text": "64", "feedback": "That is 2⁶, which comes from adding the exponents. Adding is for multiplying powers, not dividing."}
 ]'::jsonb,
 'exponent-division-rule'),
('MTH1W', 'powers', 'powers-and-exponent-form', 3, 'Easy',
 'Write 3 x 3 x 3 x 3 as a power.', 1,
 '[
   {"text": "3^3", "feedback": "That counted the multiplication signs. Count the factors themselves."},
   {"text": "3^4", "feedback": "Correct."},
   {"text": "4^3", "feedback": "The base and the exponent have been swapped. The base is the number being repeated."},
   {"text": "12", "feedback": "That multiplied the base by how many times it appears. A power repeats the multiplication instead."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'powers-and-exponent-form', 4, 'Easy',
 'Evaluate 4^3.', 0,
 '[
   {"text": "64", "feedback": "Correct."},
   {"text": "43", "feedback": "That wrote the two digits side by side rather than working the power out."},
   {"text": "16", "feedback": "That used an exponent of 2. Check how many factors of 4 the exponent asks for."},
   {"text": "12", "feedback": "That multiplied the base by the exponent. The exponent says how many times to multiply the base by ITSELF."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'powers-and-exponent-form', 5, 'Medium',
 'Evaluate (-2)^4.', 2,
 '[
   {"text": "8", "feedback": "That multiplied the base by the exponent, and dropped the sign along the way."},
   {"text": "-16", "feedback": "A negative base does not always give a negative answer. Count how many negative factors there are."},
   {"text": "16", "feedback": "Correct."},
   {"text": "-8", "feedback": "That used an exponent of 3. Check how many factors the exponent asks for."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'powers-and-exponent-form', 6, 'Medium',
 'Evaluate -3^4.', 2,
 '[
   {"text": "12", "feedback": "Two mistakes: the base was multiplied by the exponent, and the sign was dropped."},
   {"text": "81", "feedback": "That treated the expression as if the minus sign were inside brackets with the 3. It is not."},
   {"text": "-81", "feedback": "Correct."},
   {"text": "-12", "feedback": "That multiplied the base by the exponent instead of repeating it."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'powers-and-exponent-form', 7, 'Challenge',
 'Evaluate 6x^2 when x = 5.', 0,
 '[
   {"text": "150", "feedback": "Correct."},
   {"text": "30", "feedback": "That substituted but never applied the exponent."},
   {"text": "900", "feedback": "That multiplied 6 by 5 first and then squared the result. The exponent belongs to x alone."},
   {"text": "60", "feedback": "That multiplied 6 by 5 by 2. The 2 is an exponent, not a factor."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'powers-and-exponent-form', 8, 'Challenge',
 'Evaluate 6x^2 - 2x - 24 when x = -6.', 1,
 '[
   {"text": "252", "feedback": "The middle term was handled correctly but the constant was added instead of subtracted."},
   {"text": "204", "feedback": "Correct."},
   {"text": "180", "feedback": "The squared term is right, but the middle term lost its sign. Subtracting a negative adds."},
   {"text": "-228", "feedback": "The negative was not enclosed in brackets before squaring, so the first term came out negative."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'powers-and-exponent-form', 9, 'Advanced',
 'The zero exponent rule is written a^0 = 1, with the condition that a is not 0. Why is that condition needed?', 3,
 '[
   {"text": "Because a negative base is not allowed in the rule", "feedback": "Negative bases are fine here. The restriction names one specific value."},
   {"text": "Because zero cannot be used as an exponent", "feedback": "Zero is exactly the exponent this rule is about. The restriction is on the base."},
   {"text": "Because 0^0 equals 0, which breaks the pattern", "feedback": "0^0 does not equal 0. Compare what the zero exponent rule says with what the pattern of powers of 0 says, and see whether they agree."},
   {"text": "Because 0^0 is undefined", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'powers-and-exponent-form', 10, 'Advanced',
 'Evaluate (-2)^5.', 0,
 '[
   {"text": "-32", "feedback": "Correct."},
   {"text": "-10", "feedback": "That multiplied the base by the exponent rather than repeating it."},
   {"text": "10", "feedback": "Two mistakes: the base was multiplied by the exponent, and the sign was dropped."},
   {"text": "32", "feedback": "The size is right but the sign is not. Count whether the number of negative factors is odd or even."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'fractions', 1, 'Easy',
 'Evaluate:   3/4 + 1/6', 3,
 '[
   {"text": "4/10", "feedback": "Adding the tops and the bottoms separately does not work for fractions. You need a common denominator first."},
   {"text": "1", "feedback": "Check the size: 3/4 alone is already 0.75, and 1/6 is small, so the total lands just under 1."},
   {"text": "4/6", "feedback": "This is smaller than 3/4 on its own, so something has gone wrong. Adding cannot make the total shrink."},
   {"text": "11/12", "feedback": "Correct. The common denominator is 12, giving 9/12 + 2/12 = 11/12."}
 ]'::jsonb,
 'fraction-common-denominator'),
('MTH1W', 'number-sense', 'fractions', 2, 'Easy',
 'Convert the mixed number 3 and 2/5 to an improper fraction.', 0,
 '[
   {"text": "17/5", "feedback": "Correct."},
   {"text": "32/5", "feedback": "That writes the digits side by side rather than doing the arithmetic."},
   {"text": "5/5", "feedback": "That adds the whole number to the numerator. The whole number has to be multiplied by the denominator first."},
   {"text": "6/5", "feedback": "That multiplies the whole number by the NUMERATOR. It is the denominator that says how many parts make one whole."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'fractions', 3, 'Easy',
 'Simplify the fraction 15/20 to lowest terms.', 3,
 '[
   {"text": "5/10", "feedback": "That subtracted 10 from each part. Simplifying divides, it does not subtract."},
   {"text": "5/20", "feedback": "That divided the top by 3 and left the bottom untouched. A factor has to come out of both parts at once."},
   {"text": "1/5", "feedback": "That divided the top and bottom by different numbers. Both must be divided by the same one."},
   {"text": "3/4", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'fractions', 4, 'Easy',
 'Evaluate: 2/3 x 5/7', 0,
 '[
   {"text": "10/21", "feedback": "Correct."},
   {"text": "14/15", "feedback": "That multiplied each numerator by the other denominator. Multiplying fractions goes straight across."},
   {"text": "7/10", "feedback": "That added the tops and added the bottoms, which is not how any fraction operation works."},
   {"text": "10/10", "feedback": "The numerators multiplied correctly, but the denominators did not."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'fractions', 5, 'Medium',
 'Which of these is the largest?', 1,
 '[
   {"text": "3/5", "feedback": "As a decimal this is 0.6. Convert the others the same way and compare."},
   {"text": "0.7", "feedback": "Correct. As decimals: 3/5 is 0.6, 65% is 0.65, and 0.7 is the largest."},
   {"text": "65%", "feedback": "This is 0.65, which is bigger than 3/5 but not the largest of the three."},
   {"text": "They are all equal", "feedback": "Convert each to a decimal and you will see three different values."}
 ]'::jsonb,
 'decimal-fraction-comparison'),
('MTH1W', 'number-sense', 'fractions', 6, 'Medium',
 'Evaluate: 2/3 divided by 5/4', 0,
 '[
   {"text": "8/15", "feedback": "Correct."},
   {"text": "15/8", "feedback": "That flipped the FIRST fraction. Keep the first, flip the second."},
   {"text": "6/5", "feedback": "Both fractions were turned over. Only one of them is flipped when you divide."},
   {"text": "10/12", "feedback": "That multiplied straight across without flipping. Division needs the reciprocal first."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'fractions', 7, 'Medium',
 'Evaluate: 2/5 + 3/10', 2,
 '[
   {"text": "6/50", "feedback": "That multiplied the fractions instead of adding them."},
   {"text": "5/15", "feedback": "That added the tops and added the bottoms. Only the numerators are added, once the denominators match."},
   {"text": "7/10", "feedback": "Correct."},
   {"text": "5/10", "feedback": "The denominators were matched correctly, but the first numerator was not rescaled with it."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'fractions', 8, 'Medium',
 'Convert the improper fraction 11/3 to a mixed number.', 0,
 '[
   {"text": "3 and 2/3", "feedback": "Correct."},
   {"text": "3 and 1/3", "feedback": "The whole number part is right. Check what is actually left over after taking those wholes away."},
   {"text": "4 and 1/3", "feedback": "That went one group of 3 too far and then used the overshoot as the leftover."},
   {"text": "3 and 2/11", "feedback": "The denominator does not change when you convert. Only the numerator does."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'fractions', 9, 'Challenge',
 'Evaluate: 7/12 + 5/8', 3,
 '[
   {"text": "29/96", "feedback": "The numerators were rescaled correctly, but the denominator was multiplied out instead of matched."},
   {"text": "35/96", "feedback": "That multiplied the two fractions instead of adding them."},
   {"text": "12/20", "feedback": "That added the tops and the bottoms. The denominators have to be made equal first."},
   {"text": "29/24", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'fractions', 10, 'Advanced',
 'Express 5/4 as a multiple of a unit fraction.', 1,
 '[
   {"text": "4 lots of 1/5", "feedback": "The numerator and denominator have been swapped. The unit fraction keeps the original denominator."},
   {"text": "5 lots of 1/4", "feedback": "Correct."},
   {"text": "1 lot of 5/4", "feedback": "A unit fraction has 1 on top. This is just the original fraction restated."},
   {"text": "5 lots of 1/5", "feedback": "That would come to 1, which is less than the fraction given."}
 ]'::jsonb,
 null);