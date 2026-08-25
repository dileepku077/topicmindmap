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


delete from public.questions where course_code = 'MCR3U';

insert into public.questions
  (course_code, unit_code, subtopic_code, sort_order, difficulty,
   prompt, correct_index, options, misconception_tag)
values
('MCR3U', 'discrete-functions', 'arithmetic-sequences', 1, 'Easy',
 'Find the next term:   3, 7, 11, 15, ...', 2,
 '[
   {"text": "17", "feedback": "Check the pattern between terms — each one increases by the same fixed amount."},
   {"text": "18", "feedback": "Close, but recheck the common difference between consecutive terms."},
   {"text": "19", "feedback": "Correct. This is arithmetic with common difference 4, so the next term is 15 + 4 = 19."},
   {"text": "20", "feedback": "This adds 5 rather than the actual difference between the given terms."}
 ]'::jsonb,
 'arithmetic-common-difference'),
('MCR3U', 'discrete-functions', 'arithmetic-sequences', 2, 'Easy',
 'Find the 10th term of the arithmetic sequence with first term 5 and common difference 3.', 0,
 '[
   {"text": "32", "feedback": "Correct. tₙ = a + (n − 1)d = 5 + 9(3) = 5 + 27 = 32."},
   {"text": "35", "feedback": "This multiplies by 10 rather than 9 — the formula uses (n − 1), not n."},
   {"text": "27", "feedback": "This is only the added part, 9 × 3. The first term of 5 still needs to be included."},
   {"text": "38", "feedback": "This adds one extra step of 3. Check that (n − 1) uses 9, not 10 or 11."}
 ]'::jsonb,
 'nth-term-off-by-one'),
('MCR3U', 'discrete-functions', 'arithmetic-sequences', 3, 'Easy',
 'A sequence is defined by t₁ = 5, tₙ = tₙ₋₁ + 4. What is t₄?', 1,
 '[
   {"text": "13", "feedback": "This looks like only two steps of adding 4 were applied. Starting from t₁, three additions are needed to reach t₄."},
   {"text": "17", "feedback": "Correct. t₂ = 9, t₃ = 13, t₄ = 17 — three additions of 4 starting from 5."},
   {"text": "20", "feedback": "This applies four additions of 4, but t₁ is already the first term, so only three more steps are needed."},
   {"text": "9", "feedback": "This is only t₂. Continue applying the rule two more times to reach t₄."}
 ]'::jsonb,
 'recursive-sequence'),
('MCR3U', 'discrete-functions', 'arithmetic-sequences', 4, 'Easy',
 'What is the common difference of the sequence 9, 15, 21, ...?', 0,
 '[
   {"text": "6", "feedback": "Correct."},
   {"text": "9", "feedback": "9 is the first term. The common difference is what gets added to move along."},
   {"text": "15", "feedback": "15 is the second term, not the step between terms."},
   {"text": "5/3", "feedback": "That divides 15 by 9, which is what you would do for a ratio. A common difference is found by SUBTRACTING one term from the next."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'arithmetic-sequences', 5, 'Easy',
 'For the sequence 1, 4, 7, 10, ..., what is the 10th term?', 1,
 '[
   {"text": "27", "feedback": "That is 9 times 3, the total added on, without the first term of 1."},
   {"text": "28", "feedback": "Correct."},
   {"text": "31", "feedback": "That adds the common difference ten times. The first term is already there, so it is added only nine times."},
   {"text": "30", "feedback": "That works out 10 times 3. The first term of 1 still has to be counted."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'arithmetic-sequences', 6, 'Medium',
 'The interior angles of polygons form a sequence: triangle 180°, quadrilateral 360°, pentagon 540°. What is the formula for an n-sided polygon?', 2,
 '[
   {"text": "180n", "feedback": "Test this on the triangle: 180 × 3 = 540, but a triangle only has 180° total."},
   {"text": "360(n − 2)", "feedback": "Test with n = 3: 360(1) = 360, which is double what a triangle actually has."},
   {"text": "180(n − 2)", "feedback": "Correct. For n = 3, 180(1) = 180. For n = 4, 180(2) = 360. For n = 5, 180(3) = 540 — all match."},
   {"text": "360(n − 1)", "feedback": "Test with n = 3: 360(2) = 720, which is far more than the 180° a triangle actually has."}
 ]'::jsonb,
 'pattern-generalization'),
('MCR3U', 'discrete-functions', 'arithmetic-sequences', 7, 'Medium',
 'For the sequence 9, 15, 21, ..., what is the 12th term?', 2,
 '[
   {"text": "69", "feedback": "That adds it ten times. Reaching the 12th term takes eleven steps from the first."},
   {"text": "72", "feedback": "That works out 12 times 6. The first term of 9 has been lost and an extra step added."},
   {"text": "75", "feedback": "Correct."},
   {"text": "81", "feedback": "That adds the common difference twelve times. The first term is already there, so it is added only eleven times."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'arithmetic-sequences', 8, 'Medium',
 'In an arithmetic sequence the 3rd term is 25 and the 9th term is 43. What is d?', 3,
 '[
   {"text": "18", "feedback": "18 is the total change from the 3rd term to the 9th. It still has to be shared out over the steps between them."},
   {"text": "6", "feedback": "6 is the number of STEPS from the 3rd term to the 9th, not the size of each one."},
   {"text": "2", "feedback": "That divides 18 by 9. The steps run from term 3 to term 9, which is 6 steps, not 9."},
   {"text": "3", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'arithmetic-sequences', 9, 'Challenge',
 'In an arithmetic sequence the 3rd term is 25 and the 9th term is 43.
How many terms are less than 100?', 1,
 '[
   {"text": "34", "feedback": "That divides 100 by 3 and treats every term as a multiple of the common difference. The sequence starts at 19, not at 0."},
   {"text": "27", "feedback": "Correct."},
   {"text": "28", "feedback": "The 28th term is exactly 100, and 100 is not less than 100."},
   {"text": "26", "feedback": "One term short. The very next term is 97, which is still below 100 and so counts."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'arithmetic-sequences', 10, 'Challenge',
 'In an arithmetic sequence the 17th term is 53 and the 28th term is 86.
Find a and d.', 1,
 '[
   {"text": "a = 2, d = 3", "feedback": "The common difference is right, but one step too many was taken back. Getting from the 17th term to the first takes 16 steps."},
   {"text": "a = 5, d = 3", "feedback": "Correct."},
   {"text": "a = 5, d = 11", "feedback": "11 is the number of STEPS between the two given terms, not the size of each step."},
   {"text": "a = 53, d = 3", "feedback": "53 is the 17th term, not the first. Sixteen steps still have to be taken back off it."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'arithmetic-sequences', 11, 'Advanced',
 'An arithmetic sequence has tₙ = 19 + 3(n - 1). Which term is equal to 100?', 0,
 '[
   {"text": "The 28th", "feedback": "Correct."},
   {"text": "The 27th", "feedback": "The 27th term is 97. One more step of 3 is needed."},
   {"text": "The 34th", "feedback": "That divides 100 by 3 and ignores the starting value of 19."},
   {"text": "No term equals 100", "feedback": "81 divides by 3 exactly, so the sequence does land on 100 rather than stepping over it."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'arithmetic-sequences', 12, 'Advanced',
 'The sum of the first 6 terms of an arithmetic series is 297 and the sum of
the first 8 terms is 500. What is the 5th term?', 0,
 '[
   {"text": "69", "feedback": "Correct."},
   {"text": "56", "feedback": "That uses three steps of the common difference. Reaching the 5th term from the first takes four."},
   {"text": "82", "feedback": "That uses five steps. The exponent-style count is n - 1, so the 5th term is four steps along."},
   {"text": "30", "feedback": "30 is the SECOND term. The 5th is three more steps along."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'arithmetic-series', 1, 'Easy',
 'What is the sum 1 + 2 + 3 + ... + 10?', 3,
 '[
   {"text": "50", "feedback": "That works out 10 times 5. The average of the ten terms is 5.5, not 5."},
   {"text": "45", "feedback": "45 is the sum of 1 to 9. The tenth term is still to be added."},
   {"text": "100", "feedback": "That squares the 10. The sum of the first n whole numbers is not n squared."},
   {"text": "55", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'arithmetic-series', 2, 'Easy',
 'How many terms are there in the series 21 + 23 + 25 + ... + 43?', 2,
 '[
   {"text": "22", "feedback": "22 is the total distance from 21 to 43. It still has to be divided by the step size of 2."},
   {"text": "23", "feedback": "23 is the second term of the series, not how many terms it has."},
   {"text": "12", "feedback": "Correct."},
   {"text": "11", "feedback": "That counts the STEPS from 21 to 43. There is always one more term than there are steps between them."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'arithmetic-series', 3, 'Medium',
 'Find the sum of the first 20 terms of the arithmetic sequence 2, 5, 8, 11, ...', 1,
 '[
   {"text": "590", "feedback": "Close — recheck the 20th term: a + 19d = 2 + 57 = 59, not a smaller value."},
   {"text": "610", "feedback": "Correct. Using Sₙ = n/2 × (2a + (n−1)d) = 10 × (4 + 57) = 10 × 61 = 610."},
   {"text": "1220", "feedback": "This looks like the sum was doubled. Recheck the n/2 factor at the start of the formula."},
   {"text": "600", "feedback": "Very close, but recompute (n − 1)d = 19 × 3 = 57 exactly before adding 2a."}
 ]'::jsonb,
 'arithmetic-series-sum'),
('MCR3U', 'discrete-functions', 'arithmetic-series', 4, 'Medium',
 'For the sequence 1, 4, 7, 10, ..., what is the sum of the first 12 terms?', 3,
 '[
   {"text": "228", "feedback": "That uses 12 steps of the common difference. The bracket in the formula holds (n - 1)d, which is eleven steps."},
   {"text": "192", "feedback": "That uses ten steps. Twelve terms means eleven gaps between them."},
   {"text": "176", "feedback": "That stops at the 11th term. Twelve terms were asked for."},
   {"text": "210", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'arithmetic-series', 5, 'Medium',
 'What is the sum of the series 21 + 23 + 25 + ... + 43?', 2,
 '[
   {"text": "768", "feedback": "The halving was left out. The formula is n over 2 times the first plus the last."},
   {"text": "320", "feedback": "That counts 10 terms, taking one off the number of steps from 21 to 43 instead of adding one."},
   {"text": "384", "feedback": "Correct."},
   {"text": "352", "feedback": "That uses 11 terms. There are 12, because there is always one more term than there are steps."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'arithmetic-series', 6, 'Challenge',
 'In an arithmetic series the 12th term is 15 and the sum of the first 15
terms is 105. What is the sum of the first three terms?', 3,
 '[
   {"text": "15", "feedback": "15 is the 12th term, which the question already gives."},
   {"text": "-21", "feedback": "That is three times the first term, which would only be right if the common difference were zero."},
   {"text": "-9", "feedback": "That adds the second, third and fourth terms instead of the first three."},
   {"text": "-15", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'arithmetic-series', 7, 'Challenge',
 'What is the sum of the series 251 + 243 + 235 + ... + (-205)?', 2,
 '[
   {"text": "2668", "feedback": "The halving was left out. The formula is n over 2 times the first plus the last."},
   {"text": "667", "feedback": "That halves twice. The n over 2 has already done the halving once."},
   {"text": "1334", "feedback": "Correct."},
   {"text": "1288", "feedback": "That uses 56 terms. The count is (251 + 205) divided by 8, plus one for the first term."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'arithmetic-series', 8, 'Advanced',
 'For the series 5 + 8 + 11 + ..., how many terms are needed to reach a sum of 440?', 3,
 '[
   {"text": "15", "feedback": "15 terms give 390, which is 50 short."},
   {"text": "17", "feedback": "17 terms give 493, which overshoots by 53."},
   {"text": "20", "feedback": "That divides 440 by an average term of 22, which is nowhere near the true average of 27.5."},
   {"text": "16", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'arithmetic-series', 9, 'Advanced',
 'Which is larger: the sum of the first 20 terms of 3, 7, 11, ...,
or the sum of the first 30 terms of 2, 4, 6, ...?', 0,
 '[
   {"text": "The second, by 110", "feedback": "Correct."},
   {"text": "The first, by 110", "feedback": "The gap is the right size but it falls the other way. The second series has ten more terms, and that outweighs its smaller steps."},
   {"text": "They are equal", "feedback": "Ten extra terms and a smaller common difference do not have to cancel out. Work each sum out and compare them."},
   {"text": "The second, by 1750", "feedback": "1750 is the two sums ADDED together. The question asks by how much one beats the other."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'geometric-sequences', 1, 'Easy',
 'Is the sequence   4, 8, 16, 32, ...   arithmetic or geometric?', 1,
 '[
   {"text": "Arithmetic", "feedback": "Check the differences between terms: 8 − 4 = 4, but 16 − 8 = 8. They are not the same, so it is not arithmetic."},
   {"text": "Geometric", "feedback": "Correct. Each term is double the one before it, a constant ratio of 2, which is what defines a geometric sequence."},
   {"text": "Neither", "feedback": "There is a clear, consistent pattern here — check whether dividing consecutive terms gives the same result each time."},
   {"text": "Both", "feedback": "A sequence can only be one or the other unless it has just one or two terms. Check the ratio between consecutive terms."}
 ]'::jsonb,
 'arithmetic-vs-geometric'),
('MCR3U', 'discrete-functions', 'geometric-sequences', 2, 'Easy',
 'What is the common ratio of the sequence 2187, 729, 243, 81, ...?', 0,
 '[
   {"text": "1/3", "feedback": "Correct."},
   {"text": "3", "feedback": "The terms are getting smaller, so the ratio has to be below 1. Divide a term by the one BEFORE it, not the other way round."},
   {"text": "-1458", "feedback": "That subtracts one term from the next. A common ratio comes from dividing."},
   {"text": "1/2187", "feedback": "2187 is the first term, not the ratio. The ratio is what each term is multiplied by to reach the next."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'geometric-sequences', 3, 'Easy',
 'For the sequence 5, 15, 45, ..., what is the 4th term?', 3,
 '[
   {"text": "60", "feedback": "That adds 15 to the third term. This sequence multiplies rather than adds."},
   {"text": "90", "feedback": "That doubles the third term. The common ratio here is 3."},
   {"text": "405", "feedback": "That is the FIFTH term. The ratio has been applied one time too many."},
   {"text": "135", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'geometric-sequences', 4, 'Medium',
 'Find the 6th term of the geometric sequence with first term 3 and common ratio 2.', 2,
 '[
   {"text": "18", "feedback": "This adds 3 six times rather than multiplying repeatedly, which is the arithmetic pattern rather than geometric."},
   {"text": "48", "feedback": "This uses one fewer multiplication than needed. Check that the exponent is n − 1, not n − 2."},
   {"text": "96", "feedback": "Correct. tₙ = ar^(n−1) = 3 × 2⁵ = 3 × 32 = 96."},
   {"text": "192", "feedback": "This uses one extra multiplication by 2. The exponent should be n − 1 = 5, not 6."}
 ]'::jsonb,
 'geometric-nth-term'),
('MCR3U', 'discrete-functions', 'geometric-sequences', 5, 'Medium',
 'For the sequence -1, 2, -4, 8, ..., what is the 12th term?', 0,
 '[
   {"text": "2048", "feedback": "Correct."},
   {"text": "-2048", "feedback": "The ratio -2 is raised to an ODD power here, and a negative first term turns that back to positive. Check the sign pattern: even-numbered terms are positive."},
   {"text": "-4096", "feedback": "The ratio has been applied twelve times. Reaching the 12th term takes only eleven multiplications."},
   {"text": "4096", "feedback": "The size is one doubling too large as well as being the wrong sign trail. The exponent on the ratio is n - 1."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'geometric-sequences', 6, 'Medium',
 'For the sequence 2187, 729, 243, ..., what is the 10th term?', 2,
 '[
   {"text": "1/27", "feedback": "The ratio has been applied one time too many. The exponent on the ratio is n - 1, not n."},
   {"text": "9", "feedback": "The ratio was used the right way up but the count is four short. Nine steps from 2187 lands below 1."},
   {"text": "1/9", "feedback": "Correct."},
   {"text": "1/3", "feedback": "The ratio has been applied one time too few. Reaching the 10th term takes nine divisions by 3."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'geometric-sequences', 7, 'Challenge',
 'The 5th term of a geometric sequence is 405 and the 6th term is 1215.
What is the first term?', 3,
 '[
   {"text": "15", "feedback": "That divides by the ratio three times. Getting from the 5th term back to the 1st takes four divisions."},
   {"text": "135", "feedback": "That divides by the ratio only once, which lands on the 4th term."},
   {"text": "45", "feedback": "That divides by the ratio twice, which lands on the 3rd term."},
   {"text": "5", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'geometric-sequences', 8, 'Challenge',
 'What is the general term of the sequence 2187, 729, 243, 81, 27?', 0,
 '[
   {"text": "tₙ = 2187(1/3)ⁿ⁻¹", "feedback": "Correct."},
   {"text": "tₙ = 2187(3)ⁿ⁻¹", "feedback": "The terms are shrinking, so the ratio has to be below 1. This one grows."},
   {"text": "tₙ = 2187(1/3)ⁿ", "feedback": "The exponent is one too big. At n = 1 this gives 729, and the first term is 2187."},
   {"text": "tₙ = 27(1/3)ⁿ⁻¹", "feedback": "27 is the LAST term listed. The a in the formula is the first term."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'geometric-sequences', 9, 'Advanced',
 'Which is the first term of the sequence 5, 15, 45, ... to exceed 100 000?', 1,
 '[
   {"text": "The 9th", "feedback": "The 9th term is 32 805, well under the target."},
   {"text": "The 11th", "feedback": "Correct."},
   {"text": "The 10th", "feedback": "The 10th term is 98 415, which is still under 100 000."},
   {"text": "The 12th", "feedback": "The 12th does exceed it, but it is not the first to do so. Check the term just before it."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'geometric-sequences', 10, 'Advanced',
 'In a geometric sequence the 2nd term is 6 and the 5th term is 48. Find a and r.', 1,
 '[
   {"text": "a = 2, r = 3", "feedback": "The two values have swapped places. Check by building the sequence: this one gives 2, 6, 18, 54, 162."},
   {"text": "a = 3, r = 2", "feedback": "Correct."},
   {"text": "a = 6, r = 2", "feedback": "The ratio is right, but 6 is the SECOND term. One division still has to take it back to the first."},
   {"text": "a = 3, r = 8", "feedback": "8 is what the terms are multiplied by across THREE steps. The ratio is the cube root of that."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'geometric-series', 1, 'Easy',
 'What is the sum 1 + 2 + 4 + 8?', 3,
 '[
   {"text": "16", "feedback": "16 is the next term in the pattern, not the total of the four terms listed."},
   {"text": "8", "feedback": "8 is the last term on its own. The other three still have to be added."},
   {"text": "14", "feedback": "That misses the 1 at the start."},
   {"text": "15", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'geometric-series', 2, 'Easy',
 'A geometric series has a = 5 and r = 3. What is the sum of the first three terms?', 2,
 '[
   {"text": "20", "feedback": "That adds 5 + 15 and stops. The third term of 45 is still to come."},
   {"text": "195", "feedback": "That starts the sum at the SECOND term instead of the first. The a in the formula is 5."},
   {"text": "65", "feedback": "Correct."},
   {"text": "45", "feedback": "45 is the third TERM on its own. A series adds all the terms up to that point."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'geometric-series', 3, 'Medium',
 'Find the sum of the first 5 terms of the geometric sequence 2, 6, 18, 54, ...', 3,
 '[
   {"text": "80", "feedback": "This looks like the terms were simply added up to the 4th term. There is a 5th term still to include."},
   {"text": "150", "feedback": "Check the ratio used in the formula — it should be 3, matching how each term triples."},
   {"text": "486", "feedback": "That is the value of the 6th term, not the sum of the first 5 terms."},
   {"text": "242", "feedback": "Correct. Sₙ = a(rⁿ − 1)/(r − 1) = 2(3⁵ − 1)/(3 − 1) = 2(242)/2 = 242."}
 ]'::jsonb,
 'geometric-series-sum'),
('MCR3U', 'discrete-functions', 'geometric-series', 4, 'Medium',
 'How many terms are there in the series -4 - 12 - 36 - ... - 8748?', 2,
 '[
   {"text": "9", "feedback": "One multiplication too many. Applying the ratio eight times overshoots to -26244."},
   {"text": "2187", "feedback": "2187 is 8748 divided by 4, which is the power of 3 involved. It is not a count of terms."},
   {"text": "8", "feedback": "Correct."},
   {"text": "7", "feedback": "7 is the number of times the ratio is applied. There is always one more term than there are multiplications."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'geometric-series', 5, 'Medium',
 'What is the sum of the series -4 - 12 - 36 - ... - 8748?', 0,
 '[
   {"text": "-13 120", "feedback": "Correct."},
   {"text": "-13 116", "feedback": "That misses the first term of -4. The formula already includes it."},
   {"text": "13 120", "feedback": "Every term is negative, so the sum has to be negative too. The a in the formula is -4."},
   {"text": "-4372", "feedback": "That stops one term short of the end. Count the terms in the series before summing."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'geometric-series', 6, 'Hard',
 'Find the sum to infinity of   6 + 3 + 1.5 + 0.75 + ...', 0,
 '[
   {"text": "12", "feedback": "Correct. The ratio is 0.5, and since it is between −1 and 1 the sum converges: S = a/(1 − r) = 6/0.5 = 12."},
   {"text": "6", "feedback": "This is just the first term. The infinite sum accounts for every term added afterwards as well."},
   {"text": "18", "feedback": "Check the formula a/(1 − r) directly — divide 6 by 0.5 rather than multiplying."},
   {"text": "Infinite", "feedback": "The sum only diverges when the size of the ratio is 1 or more. Here the ratio is 0.5, which is small enough for the sum to settle."}
 ]'::jsonb,
 'infinite-series-ratio'),
('MCR3U', 'discrete-functions', 'geometric-series', 7, 'Hard',
 'A ball dropped from 8 m bounces back to half its previous height each time. What total distance has it travelled by the time it comes to rest?', 3,
 '[
   {"text": "16 m", "feedback": "This only counts the initial 8 m drop doubled. The repeated bounces up and down still need to be included."},
   {"text": "8 m", "feedback": "This is just the first drop. Every bounce afterwards adds more distance, both up and back down."},
   {"text": "32 m", "feedback": "Close in spirit, but check the geometric series carefully — the up-and-down bounces form a sum that converges to a specific value."},
   {"text": "24 m", "feedback": "Correct. The first drop is 8 m; after that, each bounce goes up and comes back down, forming 2 × 8 × (0.5)/(1 − 0.5) = 16 m, plus the initial 8 m gives 24 m."}
 ]'::jsonb,
 'bouncing-total-distance'),
('MCR3U', 'discrete-functions', 'geometric-series', 8, 'Challenge',
 'The 5th term of a geometric series is 405 and the 6th is 1215.
What is the sum of the first nine terms?', 1,
 '[
   {"text": "9841", "feedback": "That is the sum with a = 1 rather than a = 5. The first term still has to be worked back from the 5th."},
   {"text": "49 205", "feedback": "Correct."},
   {"text": "49 210", "feedback": "That adds the first term on separately. The formula already includes it."},
   {"text": "98 410", "feedback": "The denominator r - 1 was taken as 1 rather than 2. With r = 3 it is 2."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'geometric-series', 9, 'Challenge',
 'What is the sum of the series 1280 - 640 + 320 - ... + 5?', 1,
 '[
   {"text": "2555", "feedback": "The alternating minus signs were ignored. The ratio here is negative one half, not positive."},
   {"text": "855", "feedback": "Correct."},
   {"text": "850", "feedback": "That stops one term early, at the eighth. The series ends on +5, which is the ninth term."},
   {"text": "852.5", "feedback": "That runs one term too far. The ninth term is +5, and the series stops there."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'geometric-series', 10, 'Advanced',
 'What is the exact sum of the first 12 terms of the series
2187 + 729 + 243 + ...?', 0,
 '[
   {"text": "265 720/81", "feedback": "Correct."},
   {"text": "265 720/243", "feedback": "The denominator carries one power of 3 too many. Check the r - 1 in the formula, which is -2/3."},
   {"text": "3280", "feedback": "That stops at the last whole-number term, which is the eighth. Twelve terms were asked for."},
   {"text": "2187/81", "feedback": "That is the first term divided by 81, which is one of the later terms rather than the sum."}
 ]'::jsonb,
 null),
('MCR3U', 'discrete-functions', 'geometric-series', 11, 'Advanced',
 'What is the sum of the first 6 terms of the series 3 - 6 + 12 - 24 + ...?', 1,
 '[
   {"text": "21", "feedback": "That adds 3 + 6 + 12 with the minus signs dropped. Six terms were asked for, and they alternate in sign."},
   {"text": "-63", "feedback": "Correct."},
   {"text": "63", "feedback": "With r = -2 the denominator r - 1 is -3, and a negative denominator flips the sign of the whole thing."},
   {"text": "-189", "feedback": "The denominator was taken as -1 rather than -3."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'exponent-rules', 1, 'Easy',
 'Simplify:   x⁵ ÷ x²', 1,
 '[
   {"text": "x⁷", "feedback": "Adding exponents is the rule for multiplying powers. Dividing subtracts them instead."},
   {"text": "x³", "feedback": "Correct. Dividing powers of the same base subtracts the exponents: 5 − 2 = 3."},
   {"text": "x^2.5", "feedback": "This divides the exponents rather than subtracting them, which is not the rule for division of powers."},
   {"text": "x^10", "feedback": "This multiplies the exponents, which is the rule for a power raised to another power, not for dividing."}
 ]'::jsonb,
 'exponent-division-rule'),
('MCR3U', 'rational-expressions', 'exponent-rules', 2, 'Easy',
 'Evaluate:   8^(2/3)', 2,
 '[
   {"text": "2", "feedback": "This is only the cube root of 8. The exponent still needs the outer square applied to that result."},
   {"text": "16", "feedback": "This looks like 8 doubled and then something extra. Take the cube root of 8 first, then square that result."},
   {"text": "4", "feedback": "Correct: the cube root of 8 is 2, and squaring that gives 4."},
   {"text": "64", "feedback": "This treats the exponent as 2 without the root, giving 8² instead of the fractional exponent."}
 ]'::jsonb,
 'fractional-exponent-root-power'),
('MCR3U', 'rational-expressions', 'exponent-rules', 3, 'Easy',
 'Evaluate:   5⁰', 3,
 '[
   {"text": "0", "feedback": "Zero as an exponent has a specific, fixed value, whatever the base is."},
   {"text": "5", "feedback": "This treats the exponent as if it were 1. An exponent of 0 behaves differently."},
   {"text": "Undefined", "feedback": "Any nonzero base raised to the power 0 has a defined value."},
   {"text": "1", "feedback": "Correct. Any nonzero number raised to the power 0 equals 1."}
 ]'::jsonb,
 'zero-exponent'),
('MCR3U', 'rational-expressions', 'exponent-rules', 4, 'Easy',
 'Simplify: x⁵ × x³', 1,
 '[
   {"text": "x¹⁵", "feedback": "That multiplies the exponents. Multiplying powers of the same base adds them instead."},
   {"text": "x⁸", "feedback": "Correct."},
   {"text": "x²", "feedback": "That subtracts the exponents, which is the rule for dividing powers, not multiplying."},
   {"text": "2x⁸", "feedback": "The two bases do not add together to make a coefficient. There is still only one x being built up."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'exponent-rules', 5, 'Easy',
 'Simplify: (x⁴)³', 3,
 '[
   {"text": "x⁷", "feedback": "That adds the exponents. A power raised to another power multiplies them."},
   {"text": "x⁴", "feedback": "The outer exponent 3 was ignored entirely."},
   {"text": "3x⁴", "feedback": "The outer 3 was turned into a coefficient. It is an exponent acting on the whole power."},
   {"text": "x¹²", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'exponent-rules', 6, 'Medium',
 'Simplify:   (2x³)⁴', 0,
 '[
   {"text": "16x^12", "feedback": "Correct. Both factors inside the bracket get raised to the 4th power: 2⁴ = 16 and (x³)⁴ = x^12."},
   {"text": "8x^12", "feedback": "The 2 needs to be raised to the 4th power as well, not just multiplied by 4."},
   {"text": "16x⁷", "feedback": "This adds the exponents, 3 + 4, but a power outside the bracket multiplies the inner exponent instead."},
   {"text": "2x^12", "feedback": "The coefficient 2 is inside the bracket too, so it also needs to be raised to the 4th power."}
 ]'::jsonb,
 'power-of-product-rule'),
('MCR3U', 'rational-expressions', 'exponent-rules', 7, 'Medium',
 'Simplify, leaving only positive exponents: 12k²m⁸/(4k⁵m⁵)', 2,
 '[
   {"text": "3k³m³", "feedback": "The k exponents were subtracted the wrong way round. The larger power of k sits on the bottom here."},
   {"text": "3k⁷m¹³", "feedback": "The exponents were added. Division subtracts them."},
   {"text": "3m³/k³", "feedback": "Correct."},
   {"text": "8m³/k³", "feedback": "The coefficients were subtracted: 12 take away 4. Coefficients divide, they do not subtract."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'exponent-rules', 8, 'Medium',
 'Simplify: (3xy)³/(9x⁴y⁴)', 0,
 '[
   {"text": "3/(xy)", "feedback": "Correct."},
   {"text": "1/(3xy)", "feedback": "The 3 inside the bracket was not cubed. Everything inside takes the outer power."},
   {"text": "3xy", "feedback": "The exponents were subtracted the wrong way round. The denominator carries the larger powers."},
   {"text": "3x⁷y⁷", "feedback": "The exponents were added instead of subtracted."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'exponent-rules', 9, 'Challenge',
 'Simplify, leaving only positive exponents: (2z³)⁻²/(w⁵z²)', 1,
 '[
   {"text": "1/(2w⁵z⁸)", "feedback": "The 2 inside the bracket also takes the power -2, so it lands on the bottom as 4 rather than 2."},
   {"text": "1/(4w⁵z⁸)", "feedback": "Correct."},
   {"text": "1/(4w⁵z⁴)", "feedback": "The z exponents were combined by adding. The z² sits on the bottom, so its power is taken away."},
   {"text": "-1/(4w⁵z⁸)", "feedback": "A minus in the exponent moves the power across the fraction bar. It never becomes a minus sign out front."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'exponent-rules', 10, 'Challenge',
 'Simplify, leaving only positive exponents: (x⁻⁴)⁵x³/(3x⁻¹)', 3,
 '[
   {"text": "1/(3x¹⁸)", "feedback": "Dividing by x to the power -1 subtracts a negative, which adds one to the exponent rather than taking one away."},
   {"text": "x¹⁶/3", "feedback": "The exponent finished negative, so the power belongs on the bottom of the fraction."},
   {"text": "1/(3x¹⁷)", "feedback": "The x to the power -1 in the denominator was never dealt with at all."},
   {"text": "1/(3x¹⁶)", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'exponent-rules', 11, 'Advanced',
 'Simplify: (5c³d × 4c²d²)/((2c²d)²)', 0,
 '[
   {"text": "5cd", "feedback": "Correct."},
   {"text": "10cd", "feedback": "The 2 inside the bracket was not squared. Everything inside a bracket takes the outer power."},
   {"text": "5cd²", "feedback": "The d inside the bracket was left un-squared while the c was squared."},
   {"text": "5c⁹d⁵", "feedback": "The exponents were added across the fraction bar. Division subtracts them."}
 ]'::jsonb,
 null),
('MCR3U', 'rational-expressions', 'exponent-rules', 12, 'Advanced',
 'Which expression is equal to (a + b)⁻¹?', 2,
 '[
   {"text": "1/a + 1/b", "feedback": "A negative exponent does not spread over a sum. Try a = 1 and b = 1 and watch the two disagree."},
   {"text": "-(a + b)", "feedback": "A negative exponent turns the expression over. It does not change its sign."},
   {"text": "1/(a + b)", "feedback": "Correct."},
   {"text": "a⁻¹b⁻¹", "feedback": "That treats the plus as a multiplication. The power applies to the whole sum as one object."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'exponential-growth', 1, 'Easy',
 'An insect colony starts at 15 and QUADRUPLES every day.
Which function models the population after n days?', 3,
 '[
   {"text": "P(n) = 15 + 4n", "feedback": "That adds 4 each day, which is straight-line growth. Quadrupling multiplies, so the 4 belongs in the exponent position."},
   {"text": "P(n) = 4(15)ⁿ", "feedback": "The starting amount and the growth factor have swapped places. The colony starts at 15, not at 4."},
   {"text": "P(n) = 15(4n)", "feedback": "That multiplies by 4n, so day 2 would only be eight times the start. Each day multiplies by 4 again, which is a power."},
   {"text": "P(n) = 15(4)ⁿ", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'exponential-growth', 2, 'Easy',
 'In y = 200(3)ˣ, what is the initial amount?', 1,
 '[
   {"text": "0", "feedback": "The initial amount is the value at x = 0, and an exponential with a positive front number is never zero."},
   {"text": "200", "feedback": "Correct."},
   {"text": "3", "feedback": "The 3 is the growth factor, the number the amount is multiplied by each step."},
   {"text": "600", "feedback": "That multiplies the two numbers together. At x = 0 the power is 1, so only the front number survives."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'exponential-growth', 3, 'Medium',
 'A population of bacteria doubles every hour, starting at 100. How many after 4 hours?', 1,
 '[
   {"text": "800", "feedback": "This multiplies 100 by 4 doublings added together rather than applying each doubling in turn."},
   {"text": "1600", "feedback": "Correct. 100 × 2⁴ = 100 × 16 = 1600."},
   {"text": "400", "feedback": "This only doubles twice. There are four hours, so the doubling happens four times."},
   {"text": "500", "feedback": "This adds 100 four times rather than doubling, which is linear growth rather than exponential."}
 ]'::jsonb,
 'exponential-vs-linear-growth'),
('MCR3U', 'exponential-functions', 'exponential-growth', 4, 'Medium',
 'An ant colony of 213 doubles every week. What is the population after 4 weeks?', 0,
 '[
   {"text": "3408", "feedback": "Correct."},
   {"text": "1704", "feedback": "Only three doublings were counted. Four weeks means the 2 is used four times."},
   {"text": "6816", "feedback": "One doubling too many. After four weeks the exponent is 4, not 5."},
   {"text": "852", "feedback": "That multiplies by 4 once. Doubling four times multiplies by 2 to the power 4, which is a good deal more."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'exponential-growth', 5, 'Medium',
 'A town of 20000 grows by 13 percent each year.
What is the population after 10 years, to the nearest whole person?', 1,
 '[
   {"text": "275 717", "feedback": "The growth factor was written as 1.3. A 13 percent rise makes the factor 1.13, not 1.3."},
   {"text": "67 891", "feedback": "Correct."},
   {"text": "46 000", "feedback": "That adds 13 percent of the ORIGINAL ten times over. Each year the percentage is taken of the new, larger number."},
   {"text": "22 600", "feedback": "Only one year of growth was applied. The exponent has to be 10."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'exponential-growth', 6, 'Challenge',
 'A bacteria culture starts at 12 000 and doubles every four hours.
How many are present after one day?', 2,
 '[
   {"text": "288 000", "feedback": "That multiplies by 24. The 24 hours has to be divided by the four-hour period first, and the result used as an exponent."},
   {"text": "201 326 592 000", "feedback": "The four-hour period was ignored, so 24 doublings were counted instead of six."},
   {"text": "768 000", "feedback": "Correct."},
   {"text": "96 000", "feedback": "That is the count after 12 hours. One day is 24 hours, which is six doubling periods, not three."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'exponential-growth', 7, 'Challenge',
 'A culture of 20 bacteria doubles every 15 minutes.
How long does it take to reach 163 840?', 2,
 '[
   {"text": "180 minutes", "feedback": "Twelve doublings gets to 81 920, which is only half way. One more period is needed."},
   {"text": "8192 minutes", "feedback": "8192 is how many times the colony has multiplied, not a length of time. Write it as a power of 2 first."},
   {"text": "195 minutes", "feedback": "Correct."},
   {"text": "13 minutes", "feedback": "13 is the number of DOUBLINGS. Each one takes 15 minutes, so they still have to be multiplied out."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'exponential-growth', 8, 'Advanced',
 'A culture starts with 50 bacteria. After 3 minutes there are 204 800.
What is the doubling period?', 0,
 '[
   {"text": "15 seconds", "feedback": "Correct."},
   {"text": "12 minutes", "feedback": "12 is the number of DOUBLINGS that happened in those 3 minutes, not how long one of them takes."},
   {"text": "4 minutes", "feedback": "The equation 12 = 3/t was solved upside down. Solving it properly makes t a fraction of a minute, not several minutes."},
   {"text": "0.25 seconds", "feedback": "The working gives 0.25 MINUTES. A quarter of a minute is not a quarter of a second."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'exponential-growth', 9, 'Advanced',
 'Insects follow P(n) = 15(4)ⁿ with n in days. How many are there after one week?', 3,
 '[
   {"text": "61 440", "feedback": "Six days were counted. A week is seven."},
   {"text": "983 040", "feedback": "Eight days were counted. A week is seven."},
   {"text": "420", "feedback": "That works out 15 times 4 times 7. The 7 is an exponent, so the 4 is used seven times over."},
   {"text": "245 760", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'exponential-decay', 1, 'Easy',
 'In y = a(b)ˣ with a positive, which value of b gives DECAY?', 0,
 '[
   {"text": "b = 0.8", "feedback": "Correct."},
   {"text": "b = 1.2", "feedback": "Anything above 1 makes the amount larger each step, which is growth."},
   {"text": "b = 2", "feedback": "A base of 2 doubles the amount every step, which is the fastest growth on this list."},
   {"text": "b = 1", "feedback": "A base of exactly 1 leaves the amount unchanged forever, so it neither grows nor decays."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'exponential-decay', 2, 'Easy',
 'A car loses 20 percent of its value each year. What is the base b in y = a(b)ˣ?', 0,
 '[
   {"text": "0.8", "feedback": "Correct."},
   {"text": "0.2", "feedback": "0.2 is the fraction LOST. The base is the fraction that survives, which is what is left of the whole."},
   {"text": "1.2", "feedback": "Adding the 20 percent makes the car gain value. A loss subtracts from 1."},
   {"text": "20", "feedback": "The percent has to become a decimal before it can be used, and it has to be subtracted from 1."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'exponential-decay', 3, 'Medium',
 'Which function models exponential decay?', 2,
 '[
   {"text": "y = 3x + 5", "feedback": "This is a straight line, with constant growth per step rather than a shrinking factor."},
   {"text": "y = 5(2)^x", "feedback": "The base here is greater than 1, which produces growth rather than decay."},
   {"text": "y = 5(0.5)^x", "feedback": "Correct. A base between 0 and 1 means each step multiplies by a fraction, shrinking the value."},
   {"text": "y = x²", "feedback": "This is a quadratic, which does not have the repeated-multiplication pattern that defines exponential behaviour."}
 ]'::jsonb,
 'decay-base-less-than-one'),
('MCR3U', 'exponential-functions', 'exponential-decay', 4, 'Medium',
 'Radium has a half-life of 1620 years. A hospital buys 0.5 g.
How much is left after 4860 years?', 0,
 '[
   {"text": "0.0625 g", "feedback": "Correct."},
   {"text": "0.1667 g", "feedback": "That divides the amount by 3. Three half-lives halve it three times over, which is a division by 8."},
   {"text": "0.03125 g", "feedback": "One half-life too many. 4860 divided by 1620 is exactly three, not four."},
   {"text": "0.125 g", "feedback": "Only two half-lives were counted. 4860 divided by 1620 gives three."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'exponential-decay', 5, 'Medium',
 'Polonium-210 has a half-life of 20 days. A sample starts at 40 mg.
Which equation gives the mass remaining after t days?', 2,
 '[
   {"text": "f(t) = 40(2)^(t/20)", "feedback": "A base of 2 doubles the sample every 20 days. A half-life halves it."},
   {"text": "f(t) = 20(1/2)^(t/40)", "feedback": "The starting mass and the half-life have swapped places. The sample starts at 40 mg."},
   {"text": "f(t) = 40(1/2)^(t/20)", "feedback": "Correct."},
   {"text": "f(t) = 40(1/2)^(20t)", "feedback": "The half-life multiplies t here instead of dividing it, so the sample would be halved 20 times on day 1. The exponent has to count halvings, not days."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'exponential-decay', 6, 'Hard',
 'The half-life of a substance is 3 years. Starting with 80 g, how much remains after 9 years?', 0,
 '[
   {"text": "10 g", "feedback": "Correct. Nine years is three half-lives, so 80 → 40 → 20 → 10 g."},
   {"text": "20 g", "feedback": "This applies the halving only twice, but nine years covers three half-lives of three years each."},
   {"text": "26.7 g", "feedback": "This divides 80 by 3 directly, treating the decay as linear rather than repeated halving."},
   {"text": "40 g", "feedback": "This applies the halving only once. Check how many three-year periods fit into nine years."}
 ]'::jsonb,
 'half-life-count'),
('MCR3U', 'exponential-functions', 'exponential-decay', 7, 'Challenge',
 'A coffee contains 96 mg of caffeine, and the amount in the body halves
every 5 hours. How long until only 12 mg is left?', 1,
 '[
   {"text": "40 hours", "feedback": "That multiplies the 5 hours by 8. The 8 is the division factor; the number of halvings is the power of 2 inside it."},
   {"text": "15 hours", "feedback": "Correct."},
   {"text": "3 hours", "feedback": "3 is the number of HALVINGS. Each one takes 5 hours, so they still have to be multiplied out."},
   {"text": "8 hours", "feedback": "8 is how many times smaller the amount has become, not a length of time. Write it as a power of 2 first."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'exponential-decay', 8, 'Challenge',
 'A motorcycle costs $13 500 and depreciates by 20 percent of its current
value every year. What is it worth after 6 years?', 3,
 '[
   {"text": "$4423.68", "feedback": "Only five years were counted. The 0.8 has to be used six times."},
   {"text": "$10 800.00", "feedback": "Only one year was counted. The 0.8 has to be raised to the power 6."},
   {"text": "$0.00", "feedback": "That takes 20 percent of the ORIGINAL price six times, which wipes the value out entirely. Each year the percentage is of the current, smaller value."},
   {"text": "$3538.94", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'exponential-decay', 9, 'Advanced',
 'Polonium-210 has a half-life of 20 days.
How long until a sample decays to 8 percent of its initial mass?', 0,
 '[
   {"text": "About 73 days", "feedback": "Correct."},
   {"text": "About 3.6 days", "feedback": "3.6 is the number of HALF-LIVES needed. Each one lasts 20 days, so they still have to be multiplied out."},
   {"text": "About 60 days", "feedback": "Three whole half-lives leaves 12.5 percent, which has not fallen far enough. It does not land on a whole number of half-lives."},
   {"text": "About 160 days", "feedback": "That counts eight half-lives because the 8 in 8 percent was read as a number of halvings."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'exponential-decay', 10, 'Advanced',
 'A motorcycle depreciates by 20 percent of its current value each year.
How long until it is worth half of what it cost?', 3,
 '[
   {"text": "About 2.5 years", "feedback": "That divides 50 by 20, which treats the loss as a flat amount each year. Each year takes 20 percent of a smaller value than the year before."},
   {"text": "About 0.32 years", "feedback": "The logarithms are the wrong way up. It is log 0.5 divided by log 0.8, not the other way round."},
   {"text": "About 10 years", "feedback": "By then it is worth about a tenth of its cost, not half."},
   {"text": "About 3.1 years", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'properties-of-exponential-functions', 1, 'Easy',
 'What is the y-intercept of   y = 4(3)^x ?', 1,
 '[
   {"text": "3", "feedback": "That is the base, which controls the growth rate rather than the starting value."},
   {"text": "4", "feedback": "Correct. Setting x = 0 gives y = 4(3)⁰ = 4 × 1 = 4."},
   {"text": "12", "feedback": "This multiplies 4 and 3 together, but x = 0 makes 3^x equal to 1, not 3."},
   {"text": "1", "feedback": "This is 3⁰ on its own, but the leading 4 still needs to be included."}
 ]'::jsonb,
 'exponential-y-intercept'),
('MCR3U', 'exponential-functions', 'properties-of-exponential-functions', 2, 'Easy',
 'What is the horizontal asymptote of y = 2ˣ?', 2,
 '[
   {"text": "y = 2", "feedback": "The 2 is the base, which sets how fast the curve climbs. It does not set the floor."},
   {"text": "y = 1", "feedback": "1 is where the curve crosses the y-axis. The asymptote is the level it heads toward far to the left."},
   {"text": "y = 0", "feedback": "Correct."},
   {"text": "x = 0", "feedback": "A horizontal asymptote is a horizontal line, so its equation names y. This curve has no vertical asymptote at all."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'properties-of-exponential-functions', 3, 'Easy',
 'What is the y-intercept of y = 5(3)ˣ?', 3,
 '[
   {"text": "3", "feedback": "The 3 is the base. At x = 0 the base raised to the power 0 is 1, so it disappears."},
   {"text": "15", "feedback": "That multiplies the two numbers. Anything to the power 0 is 1, not itself."},
   {"text": "1", "feedback": "That is only what the power on its own is worth at x = 0. The y-intercept is the whole value of y there, not just the power."},
   {"text": "5", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'properties-of-exponential-functions', 4, 'Medium',
 'Solve for x:   2^x = 32', 3,
 '[
   {"text": "16", "feedback": "This divides 32 by 2 rather than asking how many times 2 must be multiplied to reach 32."},
   {"text": "2", "feedback": "2² is only 4. You need a larger exponent to reach 32."},
   {"text": "4", "feedback": "2⁴ is 16, which is still short of 32. Try one more factor of 2."},
   {"text": "5", "feedback": "Correct. 2⁵ = 32, since 2 × 2 × 2 × 2 × 2 = 32."}
 ]'::jsonb,
 'solve-exponent-by-inspection'),
('MCR3U', 'exponential-functions', 'properties-of-exponential-functions', 5, 'Medium',
 'What are the domain and range of y = 3(2)ˣ?', 2,
 '[
   {"text": "Domain all positive numbers, range y > 0", "feedback": "Negative exponents are perfectly legal here; they just give small positive outputs."},
   {"text": "Domain all real numbers, range y > 3", "feedback": "3 is the y-intercept, not the floor. Far to the left the outputs drop below 3 and keep going."},
   {"text": "Domain all real numbers, range y > 0", "feedback": "Correct."},
   {"text": "Domain all real numbers, range y ≥ 0", "feedback": "The curve gets as close to zero as you like but never lands on it, so zero itself is not in the range."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'properties-of-exponential-functions', 6, 'Medium',
 'An exponential curve passes through (0, 6) and (1, 12). Which equation fits?', 2,
 '[
   {"text": "y = 2(6)ˣ", "feedback": "The starting value and the base have swapped places. At x = 0 the output has to be 6."},
   {"text": "y = 6 + 6x", "feedback": "That fits both given points but grows by adding, so at x = 2 it gives 18 where the curve gives 24."},
   {"text": "y = 6(2)ˣ", "feedback": "Correct."},
   {"text": "y = 6(0.5)ˣ", "feedback": "This curve falls, and the given points climb from 6 to 12. The base is found by DIVIDING the second output by the first."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'properties-of-exponential-functions', 7, 'Challenge',
 'Which equation gives a DECREASING curve with a y-intercept of 3?', 1,
 '[
   {"text": "y = -3ˣ", "feedback": "This one falls, but it starts at -1 and lives entirely below the x-axis."},
   {"text": "y = 3(1/3)ˣ", "feedback": "Correct."},
   {"text": "y = 3(3ˣ)", "feedback": "The y-intercept is right, but a base above 1 makes the curve climb."},
   {"text": "y = (1/3)(3ˣ)", "feedback": "The base and the front number are the wrong way round: this crosses the y-axis at one third and then climbs."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'properties-of-exponential-functions', 8, 'Challenge',
 'A curve passes through (0, 8), (1, 4) and (2, 2). Which equation fits?', 0,
 '[
   {"text": "y = 8(1/2)ˣ", "feedback": "Correct."},
   {"text": "y = 8(2)ˣ", "feedback": "The outputs are falling, so the base has to be below 1. Divide each output by the one before it to find it."},
   {"text": "y = 4(1/2)ˣ", "feedback": "The base is right but the starting value is not. At x = 0 the output has to be 8."},
   {"text": "y = 8 - 4x", "feedback": "That fits the first two points but reaches 0 at x = 2, where the curve is still at 2. Halving never gets to zero."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'properties-of-exponential-functions', 9, 'Advanced',
 'Why can y = a(b)ˣ, with a and b both positive, never output zero?', 3,
 '[
   {"text": "Because the exponent x is not allowed to take the value zero", "feedback": "x = 0 is perfectly legal and gives the y-intercept. It is the OUTPUT that never reaches zero."},
   {"text": "Because the base b is only ever allowed to be greater than 1", "feedback": "b can be a fraction, and the curve then falls forever without ever landing on zero."},
   {"text": "Because the graph of y = a(b)ˣ is a straight line and not a curve", "feedback": "The graph is a curve. A straight line with a non-zero slope actually would cross zero, which is the opposite of what happens here."},
   {"text": "Because a positive base raised to any power stays positive", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'properties-of-exponential-functions', 10, 'Advanced',
 'How does the graph of y = (1/3)(3ˣ) differ from the graph of y = 3(3ˣ)?', 1,
 '[
   {"text": "The new curve settles onto a different horizontal asymptote from the first one", "feedback": "Multiplying by 1/3 leaves zero at zero, so both curves settle onto the same floor."},
   {"text": "Same shape and same asymptote, but it crosses the y-axis at 1/3 instead of 3", "feedback": "Correct."},
   {"text": "It decays as x increases instead of growing", "feedback": "The base is 3 in both, so both climb. The 1/3 out front only scales the outputs."},
   {"text": "It is the first curve shifted straight down", "feedback": "The 1/3 multiplies every output rather than subtracting from it, so the curve is squashed toward the axis rather than slid down it."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'compound-interest', 1, 'Easy',
 'In A = P(1 + i)ⁿ, what is i for 7 percent per year compounded annually?', 2,
 '[
   {"text": "1.07", "feedback": "That is the whole bracket, 1 + i, already worked out. On its own i is just the rate."},
   {"text": "0.7", "feedback": "7 percent is 7 hundredths, not 7 tenths. The decimal point moved one place too few."},
   {"text": "0.07", "feedback": "Correct."},
   {"text": "7", "feedback": "The percent has to be divided by 100 before it goes into the formula."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'compound-interest', 2, 'Easy',
 'What is $1000 worth after 1 year at 5 percent compounded annually?', 1,
 '[
   {"text": "$950.00", "feedback": "Interest is earned, so it is added. Subtracting would be a loss."},
   {"text": "$1050.00", "feedback": "Correct."},
   {"text": "$1005.00", "feedback": "That uses 0.005 as the rate. 5 percent is 5 hundredths, which is 0.05."},
   {"text": "$1500.00", "feedback": "That adds 50 percent. The rate is 5 percent, ten times smaller."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'compound-interest', 3, 'Medium',
 'How much is $1500 worth after 8 years at 3.5 percent compounded annually?', 1,
 '[
   {"text": "$16 548.61", "feedback": "The growth factor was written as 1.35. A 3.5 percent rate makes it 1.035."},
   {"text": "$1975.21", "feedback": "Correct."},
   {"text": "$1920.00", "feedback": "That is simple interest: 3.5 percent of the original, eight times. Compounding takes the percentage of the new balance each year."},
   {"text": "$1552.50", "feedback": "Only one year of interest was applied. The exponent has to be 8."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'compound-interest', 4, 'Medium',
 'An investment earns 7 percent per year compounded annually.
How much must be invested now to have $13 450 in 9 years?', 0,
 '[
   {"text": "$7315.91", "feedback": "Correct."},
   {"text": "$24 727.28", "feedback": "That grows the money forward for another nine years. To find the starting amount, divide rather than multiply."},
   {"text": "$4976.50", "feedback": "That takes 7 percent off nine times as a simple percentage of the original, which strips away far too much."},
   {"text": "$12 570.09", "feedback": "Only one year was undone. The 1.07 has to be raised to the power 9."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'compound-interest', 5, 'Hard',
 'An investment of $1000 grows at 6% per year, compounded annually. Which expression gives its value after t years?', 2,
 '[
   {"text": "1000 + 60t", "feedback": "This is simple interest, adding a fixed amount each year rather than growing by a percentage of the current total."},
   {"text": "1000 × 6^t", "feedback": "This uses the interest rate itself as the base. The base should reflect keeping the original amount plus adding 6%."},
   {"text": "1000(1.06)^t", "feedback": "Correct. Each year the amount is multiplied by 1 plus the rate, 1.06, and this repeats t times."},
   {"text": "1000(0.06)^t", "feedback": "A base below 1 describes decay. Growing at 6% needs a base above 1, specifically 1.06."}
 ]'::jsonb,
 'compound-interest-form'),
('MCR3U', 'exponential-functions', 'compound-interest', 6, 'Challenge',
 'Five years ago Denise deposited money at 7.5 percent compounded annually.
Today the balance is $4200. What was the deposit?', 3,
 '[
   {"text": "$6029.64", "feedback": "That grows the money forward another five years. Going back in time means dividing by the growth factor."},
   {"text": "$2625.00", "feedback": "That takes 7.5 percent of $4200 away five times over. Compounding does not work backwards as a flat percentage."},
   {"text": "$3906.98", "feedback": "Only one year was undone. The 1.075 has to be raised to the power 5."},
   {"text": "$2925.55", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'compound-interest', 7, 'Challenge',
 'Money is invested at 3.5 percent compounded annually.
Roughly how long does it take to double?', 0,
 '[
   {"text": "About 20 years", "feedback": "Correct."},
   {"text": "About 29 years", "feedback": "That is 100 divided by 3.5, which is the rule for SIMPLE interest. Compounding gets there noticeably sooner."},
   {"text": "About 10 years", "feedback": "After 10 years the balance has grown by roughly 41 percent, which is well short of doubling."},
   {"text": "About 2 years", "feedback": "That divides 2 by 1.035. Solving for an exponent needs logarithms: log 2 divided by log 1.035."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'compound-interest', 8, 'Advanced',
 'An account pays 7.5 percent compounded annually and holds $4200 today.
What was in it two years ago, and what will be in it two years from now?', 0,
 '[
   {"text": "$3634.40 two years ago, $4853.63 in two years", "feedback": "Correct."},
   {"text": "$4853.63 two years ago, $3634.40 in two years", "feedback": "The two directions are swapped. Going back in time divides by the growth factor and going forward multiplies."},
   {"text": "$3570.00 two years ago, $4830.00 in two years", "feedback": "That applies 7.5 percent of the CURRENT balance twice in each direction, which is simple interest rather than compounding."},
   {"text": "$3906.98 two years ago, $4515.00 in two years", "feedback": "Only one year was applied in each direction. The 1.075 has to be squared."}
 ]'::jsonb,
 null),
('MCR3U', 'exponential-functions', 'compound-interest', 9, 'Advanced',
 '$5000 is put into one account at 6 percent compounded annually, and $5000
into another at 6.5 percent SIMPLE interest. After 10 years, which is worth
more and by roughly how much?', 1,
 '[
   {"text": "The two accounts end up worth the same", "feedback": "They would only match if the compounding never happened. Work both out to ten years and the totals are several hundred dollars apart."},
   {"text": "The compound account, by about $704", "feedback": "Correct."},
   {"text": "The simple interest account, by about $704", "feedback": "The gap is about that size, so the arithmetic held up; what has not been checked is which of the two balances the subtraction started from. Work both out to year 10 before deciding the direction."},
   {"text": "The simple account, because its rate is higher", "feedback": "A higher rate does win at first, but simple interest only ever earns on the original $5000 while the other earns on everything accumulated."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'function-notation', 1, 'Easy',
 'Which relation is a function?', 2,
 '[
   {"text": "{(1, 2), (1, 5), (2, 3)}", "feedback": "The input 1 maps to two different outputs, 2 and 5. A function cannot do that."},
   {"text": "A circle x² + y² = 9", "feedback": "For most x-values a circle gives two y-values, one above and one below the axis, so it fails the vertical line test."},
   {"text": "{(1, 4), (2, 4), (3, 7)}", "feedback": "Correct. Every input has exactly one output. Two inputs sharing the same output is still allowed."},
   {"text": "A vertical line x = 3", "feedback": "This single x-value would need to map to every possible y-value at once, which no function can do."}
 ]'::jsonb,
 'vertical-line-test'),
('MCR3U', 'functions', 'function-notation', 2, 'Easy',
 'If f(x) = 2x² − 3, find f(4).', 1,
 '[
   {"text": "13", "feedback": "It looks like 2x was used instead of 2x². Square the 4 first."},
   {"text": "29", "feedback": "Correct. f(4) = 2(4)² − 3 = 2(16) − 3 = 32 − 3 = 29."},
   {"text": "5", "feedback": "This looks like only x² − 3 was computed, without the factor of 2."},
   {"text": "61", "feedback": "Check the order: square 4 first to get 16, then multiply by 2, then subtract 3."}
 ]'::jsonb,
 'substitution-before-squaring'),
('MCR3U', 'functions', 'function-notation', 3, 'Easy',
 'If f(x) = 3x + 1 and g(x) = x², find f(g(2)).', 3,
 '[
   {"text": "9", "feedback": "This computed g(2) but forgot to feed that result into f. There is one more step."},
   {"text": "49", "feedback": "It looks like g was applied to f(2) instead of f being applied to g(2). The order matters."},
   {"text": "7", "feedback": "Check g(2) first — squaring 2 does not give 2."},
   {"text": "13", "feedback": "Correct. g(2) = 4, then f(4) = 3(4) + 1 = 13."}
 ]'::jsonb,
 'composition-order'),
('MCR3U', 'functions', 'function-notation', 4, 'Easy',
 'Does the graph of   x = y²   represent a function of x?', 1,
 '[
   {"text": "Yes", "feedback": "Try x = 4: both y = 2 and y = −2 satisfy the equation, so one input gives two outputs."},
   {"text": "No", "feedback": "Correct. This is a sideways parabola, and it fails the vertical line test — most x-values give two y-values."},
   {"text": "Only for positive x", "feedback": "Even restricting to positive x, each of those values still produces two y-values, positive and negative."},
   {"text": "Only for x = 0", "feedback": "x = 0 does give a single output, but the question is about the whole relation, not one special point."}
 ]'::jsonb,
 'vertical-line-test'),
('MCR3U', 'functions', 'function-notation', 5, 'Easy',
 'If f(x) = 2x + 5, find f(3).', 1,
 '[
   {"text": "16", "feedback": "That computes 2(3 + 5), adding before multiplying. Substitute 3 for x first."},
   {"text": "11", "feedback": "Correct."},
   {"text": "6", "feedback": "That stops after multiplying. The + 5 still needs adding."},
   {"text": "10", "feedback": "That adds 2 + 3 + 5. The 2 multiplies x, it does not add to it."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'function-notation', 6, 'Easy',
 'If g(x) = x² - 4, find g(-2).', 0,
 '[
   {"text": "0", "feedback": "Correct."},
   {"text": "-8", "feedback": "The square of -2 is +4, not -4. A square is never negative."},
   {"text": "4", "feedback": "That squares -2 and stops. The - 4 in the rule still applies."},
   {"text": "8", "feedback": "That adds the 4 instead of subtracting it. Read the sign in the rule."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'function-notation', 7, 'Medium',
 'If f(x) = x² - 3x, find f(-1).', 2,
 '[
   {"text": "2", "feedback": "The square of -1 is +1, not -1. The first term does not stay negative."},
   {"text": "-4", "feedback": "Both signs went astray: the square is positive and -3 times -1 is positive."},
   {"text": "4", "feedback": "Correct."},
   {"text": "-2", "feedback": "The second term is -3 times -1, which is +3, not -3. Two negatives multiply to a positive."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'function-notation', 8, 'Challenge',
 'If f(x) = x² + 2x, find all values of x for which f(x) = 15.', 3,
 '[
   {"text": "x = -3 or x = 5", "feedback": "x² + 2x - 15 factors as (x + 5)(x - 3). Solve each bracket and watch the signs flip."},
   {"text": "x = 3 only", "feedback": "The equation is quadratic, and this one genuinely has two solutions. Nothing rules the negative one out."},
   {"text": "x = 5 or x = 3", "feedback": "5 and 3 multiply to 15, but after moving 15 across, the pair must multiply to -15 and add to +2."},
   {"text": "x = 3 or x = -5", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'function-notation', 9, 'Challenge',
 'A repair company charges by C(n) = 25n + 500, where n is the number of hours. What does C(40) cost?', 3,
 '[
   {"text": "1000", "feedback": "That is the hourly part alone. The fixed 500 is charged on top of it."},
   {"text": "540", "feedback": "That adds 40 to the 500 and drops the 25. The 25 multiplies the hours."},
   {"text": "12500", "feedback": "That put the 500 in as the number of hours. The input to C is 40."},
   {"text": "1500", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'function-notation', 10, 'Advanced',
 'If f(x) = 4x - 1, solve f(2a) = f(a) + 9 for a.', 2,
 '[
   {"text": "a = 9/8", "feedback": "The 4a on the right has to come across before dividing: 8a - 4a leaves 4a, not 8a."},
   {"text": "a = -9/4", "feedback": "The two -1 terms cancel, and moving 4a to the left keeps the 9 positive."},
   {"text": "a = 9/4", "feedback": "Correct."},
   {"text": "a = 5/2", "feedback": "f(2a) means substituting 2a into the rule: 4(2a) - 1. It is not 2 times f(a), which would double the -1 as well."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'domain-and-range', 1, 'Easy',
 'Which of these relations is NOT a function?', 3,
 '[
   {"text": "y = -x²", "feedback": "Flipping a parabola upside down does not stop each x having one y."},
   {"text": "y = x²", "feedback": "Every x gives exactly one y here, so it passes the vertical line test."},
   {"text": "y = 3x + 1", "feedback": "A straight line that is not vertical is always a function."},
   {"text": "x = y²", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'domain-and-range', 2, 'Easy',
 'What is the domain of y = x²?', 2,
 '[
   {"text": "y ≥ 0", "feedback": "That describes the outputs. The domain is about which x values are allowed IN."},
   {"text": "x ≠ 0", "feedback": "Zero squares perfectly well. There is no division here to forbid it."},
   {"text": "All real numbers", "feedback": "Correct."},
   {"text": "x ≥ 0", "feedback": "Any number can be squared, negative inputs included. Nothing restricts x here."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'domain-and-range', 3, 'Medium',
 'What is the domain of   f(x) = 1 / (x − 5) ?', 3,
 '[
   {"text": "All real numbers", "feedback": "One value of x makes the denominator zero, which is not allowed in a fraction."},
   {"text": "x ≥ 5", "feedback": "This restriction is for square roots, not for a denominator. Every value except one is fine here."},
   {"text": "x > 0", "feedback": "Negative x-values work perfectly well here, as long as they do not make the denominator zero."},
   {"text": "x ≠ 5", "feedback": "Correct. The denominator cannot equal zero, and x − 5 = 0 when x = 5, so that single value is excluded."}
 ]'::jsonb,
 'domain-denominator-zero'),
('MCR3U', 'functions', 'domain-and-range', 4, 'Medium',
 'What is the domain of   f(x) = √(x − 3) ?', 1,
 '[
   {"text": "x ≠ 3", "feedback": "That restriction applies to denominators. A square root has a different requirement: the inside cannot be negative."},
   {"text": "x ≥ 3", "feedback": "Correct. The expression under a square root must be zero or positive, so x − 3 ≥ 0 gives x ≥ 3."},
   {"text": "x ≤ 3", "feedback": "Check the direction of the inequality — you need x − 3 to be at least zero, not at most."},
   {"text": "All real numbers", "feedback": "Try x = 0: the inside becomes −3, and the square root of a negative number is not a real number."}
 ]'::jsonb,
 'domain-radicand-negative'),
('MCR3U', 'functions', 'domain-and-range', 5, 'Medium',
 'What is the range of   f(x) = x² + 2 ?', 3,
 '[
   {"text": "All real numbers", "feedback": "A squared term can never be negative, so the output has a floor. Not every real number is reachable."},
   {"text": "y ≥ 0", "feedback": "This ignores the +2. The smallest value of x² is 0, but the whole function adds 2 to that."},
   {"text": "x ≥ 0", "feedback": "This describes possible inputs, but the question asks about the outputs, y."},
   {"text": "y ≥ 2", "feedback": "Correct. x² is never negative, so its smallest value is 0, making the smallest output 0 + 2 = 2."}
 ]'::jsonb,
 'range-from-vertex'),
('MCR3U', 'functions', 'domain-and-range', 6, 'Medium',
 'What is the domain of y = √(x - 4)?', 3,
 '[
   {"text": "x > 4", "feedback": "x = 4 itself is allowed: the root of zero is zero. Only negatives under the root are forbidden."},
   {"text": "x ≤ 4", "feedback": "The inequality points the wrong way. The inside of the root must be zero or MORE."},
   {"text": "x ≥ -4", "feedback": "Setting x - 4 ≥ 0 moves the 4 across as +4, not -4."},
   {"text": "x ≥ 4", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'domain-and-range', 7, 'Challenge',
 'What is the range of y = -3(x - 2)² + 5?', 3,
 '[
   {"text": "y ≥ 5", "feedback": "The negative a opens this parabola downward, so 5 is the ceiling, not the floor."},
   {"text": "y ≤ 2", "feedback": "2 is the x-coordinate of the vertex. The range is measured in y, from the k value."},
   {"text": "All real numbers", "feedback": "A parabola is capped at its vertex on one side. Only its domain runs over all the reals."},
   {"text": "y ≤ 5", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'domain-and-range', 8, 'Advanced',
 'What is the domain of f(x) = 1/√(3 - x)?', 3,
 '[
   {"text": "x ≤ 3", "feedback": "x = 3 makes the inside zero, and the root of zero sits in the denominator. Division by zero rules that point out."},
   {"text": "x > 3", "feedback": "The inequality points the wrong way: 3 - x must stay positive, which happens for SMALL x, not large."},
   {"text": "x ≠ 3", "feedback": "That only removes one point. Every x above 3 makes the inside negative, and a negative cannot sit under the root."},
   {"text": "x < 3", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'domain-and-range', 9, 'Advanced',
 'What is the range of f(x) = √(x - 2) + 3?', 1,
 '[
   {"text": "y > 3", "feedback": "At x = 2 the root is exactly zero, so the output 3 is actually reached."},
   {"text": "y ≥ 3", "feedback": "Correct."},
   {"text": "y ≥ 2", "feedback": "The 2 shifts the graph sideways, which changes the domain. It is the + 3 that sets the lowest output."},
   {"text": "y ≥ 0", "feedback": "The bare root starts at zero, but the + 3 lifts every output up by three."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'reading-a-k-d-and-c', 1, 'Easy',
 'In g(x) = af[k(x - d)] + c, which parameter moves the graph up and down?', 3,
 '[
   {"text": "a", "feedback": "a stretches the graph vertically or flips it. Stretching pins the graph to the x-axis rather than lifting it off."},
   {"text": "d", "feedback": "d moves the graph sideways. It sits inside the bracket with the x."},
   {"text": "k", "feedback": "k stretches or squashes the graph horizontally. It sits inside the bracket too."},
   {"text": "c", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'reading-a-k-d-and-c', 2, 'Easy',
 'What does g(x) = f(x) + 5 do to the graph of f?', 1,
 '[
   {"text": "Stretches it vertically by 5", "feedback": "A stretch multiplies the outputs, as 5f(x). Adding shifts, it does not scale."},
   {"text": "Shifts it up 5 units", "feedback": "Correct."},
   {"text": "Shifts it right 5 units", "feedback": "A sideways shift needs the 5 inside the bracket, as f(x - 5). Out here it acts on the y-values."},
   {"text": "Shifts it down 5 units", "feedback": "Adding 5 to every output raises the graph. Subtracting would lower it."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'reading-a-k-d-and-c', 3, 'Medium',
 'A function is transformed to   y = f(x) + 3.   How does the graph move?', 0,
 '[
   {"text": "Up 3 units", "feedback": "Correct. Adding outside the function shifts every y-value up by 3."},
   {"text": "Down 3 units", "feedback": "Adding 3 raises the output, which moves the graph up rather than down."},
   {"text": "Right 3 units", "feedback": "A horizontal shift comes from changing what is inside the brackets with x, not adding outside."},
   {"text": "Left 3 units", "feedback": "This is a vertical shift, since the 3 is added after f(x) is evaluated, not before."}
 ]'::jsonb,
 'transformation-vertical-shift'),
('MCR3U', 'transformations', 'reading-a-k-d-and-c', 4, 'Medium',
 'A function is transformed to   y = f(x − 2).   How does the graph move?', 2,
 '[
   {"text": "Up 2 units", "feedback": "A number added or subtracted outside f(x) shifts vertically. This one is inside, with the x."},
   {"text": "Left 2 units", "feedback": "The sign is backwards. Subtracting inside the brackets moves the graph to the right."},
   {"text": "Right 2 units", "feedback": "Correct. Subtracting inside the brackets shifts the graph right — f needs x = 2 to produce what f(0) used to."},
   {"text": "Down 2 units", "feedback": "This shift is horizontal, not vertical, because the 2 changes what goes into f rather than what comes out."}
 ]'::jsonb,
 'transformation-horizontal-direction'),
('MCR3U', 'transformations', 'reading-a-k-d-and-c', 5, 'Medium',
 'List the transformations in g(x) = -f(x - 3) - 4.', 0,
 '[
   {"text": "Reflection in the x-axis, right 3, down 4", "feedback": "Correct."},
   {"text": "Reflection in the x-axis, left 3, down 4", "feedback": "x - d moves the graph RIGHT when d is positive. The minus sign reads the opposite way to the movement."},
   {"text": "Reflection in the y-axis, right 3, down 4", "feedback": "The minus sits outside f, so it multiplies the outputs. A y-axis reflection needs the minus inside the bracket, next to the x."},
   {"text": "Reflection in the x-axis, right 3, up 4", "feedback": "The 4 is being subtracted, so every output drops by 4."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'reading-a-k-d-and-c', 6, 'Medium',
 'In h(x) = -(1/3)f(2x) + 10, describe the HORIZONTAL change.', 0,
 '[
   {"text": "Horizontal compression by a factor of 1/2", "feedback": "Correct."},
   {"text": "Horizontal stretch by a factor of 2", "feedback": "k = 2 squashes the graph rather than stretching it. The factor is 1 over k, and it is the reciprocal that decides which way."},
   {"text": "Horizontal compression by a factor of 1/3", "feedback": "The 1/3 sits outside f, so it changes the y-values. Only what is inside the bracket touches x."},
   {"text": "Horizontal reflection in the y-axis", "feedback": "A horizontal reflection needs a negative inside the bracket, and the 2 there is positive."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'reading-a-k-d-and-c', 7, 'Hard',
 'The point (2, 5) lies on y = f(x). What point must lie on y = −f(x)?', 1,
 '[
   {"text": "(−2, 5)", "feedback": "This reflects the x-coordinate. The negative sign is outside f(x), so it flips the output instead."},
   {"text": "(2, −5)", "feedback": "Correct. −f(x) negates the output only, so the point becomes (2, −5)."},
   {"text": "(−2, −5)", "feedback": "Both coordinates were flipped, but the negative sign here only affects the y-value."},
   {"text": "(5, 2)", "feedback": "This swaps the coordinates, which describes an inverse rather than a reflection."}
 ]'::jsonb,
 'reflection-axis-confusion'),
('MCR3U', 'transformations', 'reading-a-k-d-and-c', 8, 'Challenge',
 'List ALL the transformations in g(x) = -5f[-(1/4)(x + 2)] + 7.', 0,
 '[
   {"text": "Vertical stretch 5 and reflection in the x-axis; horizontal stretch 4 and reflection in the y-axis; left 2; up 7", "feedback": "Correct."},
   {"text": "Vertical stretch 5 and reflection in the x-axis; horizontal COMPRESSION by 1/4 and reflection in the y-axis; left 2; up 7", "feedback": "k = -1/4 stretches the graph rather than squashing it. The factor is 1 over k, and 1 over a quarter is 4."},
   {"text": "Vertical stretch 5 and reflection in the x-axis; horizontal stretch 4 and reflection in the y-axis; RIGHT 2; up 7", "feedback": "The bracket reads x + 2, and a plus inside moves the graph left."},
   {"text": "Vertical stretch 5 only; horizontal stretch 4 and reflection in the y-axis; left 2; up 7", "feedback": "The minus in front of the 5 was read as part of the number. It flips the graph vertically as well as stretching it."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'reading-a-k-d-and-c', 9, 'Challenge',
 'The point (6, -2) lies on y = f(x). Where does it land on y = 3f(2x) - 1?', 2,
 '[
   {"text": "(3, -6)", "feedback": "The stretch was applied but the shift down was not. The - 1 still comes off at the end."},
   {"text": "(3, -9)", "feedback": "The - 1 was applied before the stretch, so it got tripled too. Stretches happen first, translations last."},
   {"text": "(3, -7)", "feedback": "Correct."},
   {"text": "(12, -7)", "feedback": "k = 2 DIVIDES the x-coordinate. Multiplying by k stretches the graph when it should squash it."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'reading-a-k-d-and-c', 10, 'Advanced',
 'The point (a, b) lies on y = f(x).
Where does it land on y = -2f[3(x + 1)] + 5?', 1,
 '[
   {"text": "(a/3 - 1, -2(b + 5))", "feedback": "The + 5 is added after the stretch, not carried inside it. Stretches happen first, translations last."},
   {"text": "(a/3 - 1, -2b + 5)", "feedback": "Correct."},
   {"text": "(3a - 1, -2b + 5)", "feedback": "k = 3 divides the x-coordinate rather than multiplying it. Multiplying stretches the graph when k should squash it."},
   {"text": "(a/3 + 1, -2b + 5)", "feedback": "The bracket reads x + 1, and a plus inside moves the graph left, so the 1 comes off."}
 ]'::jsonb,
 null),
('MCR3U', 'transformations', 'reading-a-k-d-and-c', 11, 'Advanced',
 'Every point of y = f(x) is moved so its y-coordinate doubles and its
x-coordinate is 3 larger. Which equation describes the result?', 2,
 '[
   {"text": "g(x) = f(2x - 3)", "feedback": "The doubling ended up inside f, where it acts on the x-coordinates. To double y it has to multiply the whole function."},
   {"text": "g(x) = 2f(x) + 3", "feedback": "The 3 ended up outside, where it raises the graph. To move x it has to sit inside the bracket."},
   {"text": "g(x) = 2f(x - 3)", "feedback": "Correct."},
   {"text": "g(x) = 2f(x + 3)", "feedback": "Moving the graph right is written x - 3. The sign inside the bracket is the opposite of the direction."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'max-and-min-of-quadratics', 1, 'Easy',
 'Write   y = x² + 6x + 5   in vertex form by completing the square.', 1,
 '[
   {"text": "y = (x + 6)² − 5", "feedback": "The number added inside the bracket should be half of 6, not 6 itself."},
   {"text": "y = (x + 3)² − 4", "feedback": "Correct. Half of 6 is 3, and 5 − 3² = 5 − 9 = −4."},
   {"text": "y = (x + 3)² + 5", "feedback": "The bracket is right, but the constant needs adjusting once 3² is accounted for, not left as the original 5."},
   {"text": "y = (x − 3)² − 4", "feedback": "The sign inside the bracket should match the sign of the middle term, which is +6x here."}
 ]'::jsonb,
 'completing-square-sign'),
('MCR3U', 'functions', 'max-and-min-of-quadratics', 2, 'Easy',
 'What is the vertex of   y = 3(x + 1)² − 7 ?', 2,
 '[
   {"text": "(1, −7)", "feedback": "Watch the sign inside the bracket — the vertex x-value makes (x + 1) equal to zero."},
   {"text": "(1, 7)", "feedback": "Both the sign of x and the sign of the constant need checking here."},
   {"text": "(−1, −7)", "feedback": "Correct. The bracket is zero when x = −1, and the constant −7 is the y-value at the vertex."},
   {"text": "(3, −1)", "feedback": "The 3 is the stretch factor, not a coordinate — it controls how narrow the parabola is."}
 ]'::jsonb,
 'vertex-sign-from-brackets'),
('MCR3U', 'functions', 'max-and-min-of-quadratics', 3, 'Easy',
 'The quadratic y = 2(x - 3)² + 1 is in vertex form. What is its vertex?', 0,
 '[
   {"text": "(3, 1)", "feedback": "Correct."},
   {"text": "(-3, 1)", "feedback": "The sign inside the bracket flips: (x - h) means the vertex is at x = h, so x - 3 puts it at positive 3."},
   {"text": "(1, 3)", "feedback": "The coordinates are swapped. The number inside the bracket is the x-coordinate."},
   {"text": "(2, 1)", "feedback": "The 2 out front is the stretch factor a. It is not part of the vertex."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'max-and-min-of-quadratics', 4, 'Medium',
 'A ball is thrown so that its height is   h(t) = −5t² + 20t + 1.   At what time does it reach its maximum height?', 2,
 '[
   {"text": "t = 0.5", "feedback": "Check the formula for the axis of symmetry: t = −b ÷ (2a), using a = −5 and b = 20."},
   {"text": "t = 1", "feedback": "This is too early. Substitute a = −5 and b = 20 into −b ÷ (2a) carefully."},
   {"text": "t = 2", "feedback": "Correct. The maximum occurs at t = −b ÷ (2a) = −20 ÷ (2 × −5) = 2."},
   {"text": "t = 4", "feedback": "This doubles the correct answer. Recheck the division in −b ÷ (2a)."}
 ]'::jsonb,
 'vertex-time-vs-height'),
('MCR3U', 'functions', 'max-and-min-of-quadratics', 5, 'Medium',
 'The graph of   y = a(x − 2)² + 3   passes through (0, 11). Find a.', 0,
 '[
   {"text": "2", "feedback": "Correct. Substituting gives 11 = a(0 − 2)² + 3, so 8 = 4a, giving a = 2."},
   {"text": "8", "feedback": "This is 11 − 3, but the division by (0 − 2)² = 4 still needs to happen."},
   {"text": "4", "feedback": "This is (0 − 2)² on its own. It still needs to be matched against 11 − 3."},
   {"text": "0.5", "feedback": "Check the direction of the division: it should be 8 ÷ 4, not 4 ÷ 8."}
 ]'::jsonb,
 'stretch-factor-from-point'),
('MCR3U', 'functions', 'max-and-min-of-quadratics', 6, 'Medium',
 'Complete the square: y = x² + 6x + 2', 2,
 '[
   {"text": "y = (x + 3)² - 9", "feedback": "The 9 was subtracted, but the original + 2 vanished. Combine them."},
   {"text": "y = (x + 6)² - 34", "feedback": "The bracket takes HALF the x coefficient. Half of 6 is 3."},
   {"text": "y = (x + 3)² - 7", "feedback": "Correct."},
   {"text": "y = (x + 3)² + 2", "feedback": "The bracket quietly added 9 to the expression. That 9 has to be subtracted back off the constant."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'max-and-min-of-quadratics', 7, 'Medium',
 'Does y = -2(x - 1)² + 8 have a maximum or a minimum, and what is it?', 0,
 '[
   {"text": "A maximum of 8", "feedback": "Correct."},
   {"text": "A minimum of 8", "feedback": "A negative a opens the parabola downward, so its vertex is the top, not the bottom."},
   {"text": "A maximum of 1", "feedback": "1 is where the vertex sits along x. The max or min VALUE is the k, the height of the vertex."},
   {"text": "A minimum of -2", "feedback": "-2 is the stretch factor a. It tells you which way the parabola opens, not its value there."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'max-and-min-of-quadratics', 8, 'Hard',
 'Two numbers have a sum of 20. What is the maximum possible value of their product?', 1,
 '[
   {"text": "20", "feedback": "This is far too small. Try a few pairs that sum to 20, like 5 and 15, and compare their products."},
   {"text": "100", "feedback": "Correct. If the numbers are x and 20 − x, the product x(20 − x) = −x² + 20x is maximised at x = 10, giving 10 × 10 = 100."},
   {"text": "400", "feedback": "This is 20², but the two numbers do not have to both equal 20 — they only need to sum to 20."},
   {"text": "200", "feedback": "Try the pair 10 and 10 directly: their product is 100, not 200."}
 ]'::jsonb,
 'optimization-vertex'),
('MCR3U', 'functions', 'max-and-min-of-quadratics', 9, 'Challenge',
 'By completing the square, find the minimum value of y = 2x² - 12x + 7.', 2,
 '[
   {"text": "3", "feedback": "3 is the x-value where the minimum happens. The minimum itself is the y-value there."},
   {"text": "7", "feedback": "The constant term is only the minimum when there is no x term to shift the vertex — and this has -12x."},
   {"text": "-11", "feedback": "Correct."},
   {"text": "-2", "feedback": "The 9 completed inside the bracket sits behind a factor of 2, so 18 comes off the constant, not 9."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'max-and-min-of-quadratics', 10, 'Challenge',
 'A rectangle has a perimeter of 40 m. What is the largest area it can enclose?', 0,
 '[
   {"text": "100 m²", "feedback": "Correct."},
   {"text": "400 m²", "feedback": "Length plus width is 20, so the sides cannot BOTH be 20. Each side of the best square is half of that."},
   {"text": "40 m²", "feedback": "That repeats the perimeter. The area comes from multiplying the two sides."},
   {"text": "96 m²", "feedback": "12 by 8 fits the perimeter but is not the top of the curve. The maximum happens when the sides are equal."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'max-and-min-of-quadratics', 11, 'Advanced',
 'Tickets cost $8 and 200 people attend. Each $1 increase in price loses 10 attendees.
What ticket price gives the maximum revenue?', 2,
 '[
   {"text": "$8", "feedback": "Staying put is not optimal: the revenue expression is a downward parabola whose vertex sits at a higher price."},
   {"text": "$20", "feedback": "By $20 the lost attendees outweigh the higher price. Find the vertex of (8 + x)(200 - 10x) rather than guessing high."},
   {"text": "$14", "feedback": "Correct."},
   {"text": "$6", "feedback": "That is the number of increases at the vertex, not the price. The increases are added onto the original $8."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'the-quadratic-formula', 1, 'Easy',
 'What does the discriminant tell you about a quadratic?', 3,
 '[
   {"text": "The y-intercept", "feedback": "The y-intercept comes from the constant term c directly, not from the discriminant."},
   {"text": "The axis of symmetry", "feedback": "That comes from −b/2a. The discriminant answers a different question."},
   {"text": "The maximum value", "feedback": "The maximum or minimum comes from the vertex, found using a, b and c differently than the discriminant does."},
   {"text": "The number of real roots", "feedback": "Correct. A positive discriminant gives two roots, zero gives one, and negative gives none."}
 ]'::jsonb,
 'discriminant-interpretation'),
('MCR3U', 'functions', 'the-quadratic-formula', 2, 'Easy',
 'In the quadratic formula, which expression is the discriminant?', 0,
 '[
   {"text": "b² - 4ac", "feedback": "Correct."},
   {"text": "b² + 4ac", "feedback": "The sign is wrong: the 4ac is subtracted from b squared."},
   {"text": "4ac - b²", "feedback": "That is the discriminant backwards, which flips its sign and every conclusion drawn from it."},
   {"text": "2a", "feedback": "That is the denominator of the formula, not the part under the root."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'the-quadratic-formula', 3, 'Medium',
 'Use the quadratic formula to solve   x² − 4x − 5 = 0.', 2,
 '[
   {"text": "x = 2 and x = −2", "feedback": "This looks like a mix-up with a different equation. Substitute a = 1, b = −4, c = −5 into the formula directly."},
   {"text": "x = 1 and x = −5", "feedback": "These multiply to −5, matching c, but check what they add to — it should be 4, not −4."},
   {"text": "x = 5 and x = −1", "feedback": "Correct. The discriminant is 16 + 20 = 36, and (4 ± 6) ÷ 2 gives x = 5 and x = −1."},
   {"text": "x = −5 and x = 1", "feedback": "Close — these are the right two numbers. Recheck which one is positive and which is negative."}
 ]'::jsonb,
 'quadratic-formula-sign'),
('MCR3U', 'functions', 'the-quadratic-formula', 4, 'Medium',
 'How many real roots does   x² + 2x + 5 = 0   have?', 0,
 '[
   {"text": "Zero", "feedback": "Correct. The discriminant is 4 − 20 = −16, which is negative, so there are no real roots."},
   {"text": "One", "feedback": "One root happens when the discriminant is exactly zero. Calculate b² − 4ac here."},
   {"text": "Two", "feedback": "Two real roots happen when the discriminant is positive. Check whether b² − 4ac comes out positive or negative."},
   {"text": "Infinitely many", "feedback": "A quadratic can have at most two real roots. Calculate the discriminant to see how many exist here."}
 ]'::jsonb,
 'discriminant-sign-meaning'),
('MCR3U', 'functions', 'the-quadratic-formula', 5, 'Medium',
 'Use the quadratic formula to solve: 2x² + 7x - 4 = 0', 1,
 '[
   {"text": "x = 1 or x = -8", "feedback": "The denominator is 2a = 4, not 2. Everything gets divided by 4."},
   {"text": "x = 1/2 or x = -4", "feedback": "Correct."},
   {"text": "x = -1/2 or x = 4", "feedback": "The formula starts with MINUS b. With b = 7 that opening term is -7, and these two came from +7."},
   {"text": "x = (-7 ± √17)/4", "feedback": "The discriminant is 49 - 4(2)(-4). Subtracting a negative ADDS 32, it does not take 32 away."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'the-quadratic-formula', 6, 'Hard',
 'For what value of k does   x² + kx + 9 = 0   have exactly one real root?', 3,
 '[
   {"text": "k = 3", "feedback": "Substitute this into the discriminant b² − 4ac = k² − 36 and check whether it actually equals zero."},
   {"text": "k = 9", "feedback": "This is much too large — check what k² − 4(1)(9) equals when k = 9."},
   {"text": "k = 0", "feedback": "This would make the discriminant −36, which is negative, giving no real roots at all."},
   {"text": "k = 6 or k = −6", "feedback": "Correct. One root needs the discriminant to be zero: k² − 36 = 0, so k² = 36, giving k = ±6."}
 ]'::jsonb,
 'discriminant-zero-condition'),
('MCR3U', 'functions', 'the-quadratic-formula', 7, 'Challenge',
 'How many real solutions does 3x² - 2x + 5 = 0 have?', 1,
 '[
   {"text": "It cannot be determined without graphing", "feedback": "The discriminant settles it from the coefficients alone — that is the whole point of it."},
   {"text": "None", "feedback": "Correct."},
   {"text": "Two", "feedback": "The discriminant is 4 - 60, which is negative. A negative discriminant leaves nothing to square root."},
   {"text": "One", "feedback": "Exactly one solution needs the discriminant to be exactly zero, and 4 - 60 is well below zero."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'the-quadratic-formula', 8, 'Challenge',
 'Solve 3x² - 5x - 1 = 0, giving the exact answer.', 1,
 '[
   {"text": "x = (5 ± √37)/3", "feedback": "The denominator is 2a, which is 6 here, not 3."},
   {"text": "x = (5 ± √37)/6", "feedback": "Correct."},
   {"text": "x = (-5 ± √37)/6", "feedback": "The formula opens with -b, and b here is -5, so the front becomes +5."},
   {"text": "x = (5 ± √13)/6", "feedback": "The discriminant is 25 - 4(3)(-1). With c negative, the 12 is ADDED to 25."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'the-quadratic-formula', 9, 'Advanced',
 'A rectangle is 3 m longer than it is wide, and its area is 30 m².
What is its exact width?', 0,
 '[
   {"text": "(-3 + √129)/2 m", "feedback": "Correct."},
   {"text": "(3 + √129)/2 m", "feedback": "In w² + 3w - 30 = 0, b is +3, so the formula opens with MINUS 3."},
   {"text": "There is no real width", "feedback": "The discriminant is 9 - 4(1)(-30), and subtracting a negative adds 120 — it is comfortably positive."},
   {"text": "(-3 + √129) m", "feedback": "The whole expression is divided by 2a = 2, the root included."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'solving-by-factoring', 1, 'Easy',
 'Solve by factoring: x² - 7x + 12 = 0', 0,
 '[
   {"text": "x = 3 or x = 4", "feedback": "Correct."},
   {"text": "x = -3 or x = -4", "feedback": "The factors are (x - 3)(x - 4), and x - 3 = 0 gives POSITIVE 3. The sign flips when solving each factor."},
   {"text": "x = 2 or x = 6", "feedback": "2 and 6 multiply to 12 but add to 8. The pair must also add to 7."},
   {"text": "x = 1 or x = 12", "feedback": "1 and 12 multiply to 12 but add to 13, and the middle term needs 7."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'solving-by-factoring', 2, 'Medium',
 'Factor:   2x² + 7x + 3', 1,
 '[
   {"text": "(2x + 3)(x + 1)", "feedback": "Expand this to check: it gives 2x² + 5x + 3, not the 7x needed here."},
   {"text": "(2x + 1)(x + 3)", "feedback": "Correct. Expanding gives 2x² + 6x + x + 3 = 2x² + 7x + 3."},
   {"text": "(x + 1)(x + 3)", "feedback": "This expands to x² + 4x + 3, missing the factor of 2 on the x² term entirely."},
   {"text": "(2x + 7)(x + 3)", "feedback": "This uses the 7 directly as a factor, but 7 needs to be split across the two brackets instead."}
 ]'::jsonb,
 'factoring-with-leading-coefficient'),
('MCR3U', 'functions', 'solving-by-factoring', 3, 'Medium',
 'Solve: 2x² - 8x - 42 = 0', 3,
 '[
   {"text": "x = -7 or x = 3", "feedback": "This is the factor pair itself, read straight off as the roots. Each bracket still has to be set to zero and solved."},
   {"text": "x = 7 or x = 3", "feedback": "Two positive roots would add to a positive middle term, and this one has -4x after dividing out the 2."},
   {"text": "x = 21 or x = -1", "feedback": "21 and -1 multiply to -21, but they add to 20, and the pair must add to -4."},
   {"text": "x = 7 or x = -3", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'solving-by-factoring', 4, 'Medium',
 'Solve: -6 = x² - 5x', 2,
 '[
   {"text": "x = 6 or x = -1", "feedback": "Moving the -6 across makes it +6, so the equation ends in +6, not -6."},
   {"text": "x = 0 or x = 5", "feedback": "That solves x² - 5x = 0. The -6 disappeared before it was moved across."},
   {"text": "x = 2 or x = 3", "feedback": "Correct."},
   {"text": "x = -2 or x = -3", "feedback": "The factors (x - 2)(x - 3) each flip sign when set to zero. Solve x - 2 = 0 carefully."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'solving-by-factoring', 5, 'Challenge',
 'A ball follows h = -5t² + 20t, with h in metres and t in seconds. When does it hit the ground?', 3,
 '[
   {"text": "t = 2", "feedback": "That is the top of the flight — the vertex. The ground is where h returns to zero."},
   {"text": "t = 0", "feedback": "That is the launch moment. The question asks when it comes back down."},
   {"text": "t = -4", "feedback": "Factoring gives t(-5t + 20) = 0, and -5t + 20 = 0 solves to a positive time."},
   {"text": "t = 4", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'solving-by-factoring', 6, 'Advanced',
 'Solve: 3x² + 10x - 8 = 0', 1,
 '[
   {"text": "x = -4/3 or x = 2", "feedback": "Check the middle term: (3x + 4)(x - 2) gives -2x, and this equation needs +10x."},
   {"text": "x = 2/3 or x = -4", "feedback": "Correct."},
   {"text": "x = -2/3 or x = 4", "feedback": "The factors are (3x - 2)(x + 4). Setting 3x - 2 = 0 gives a positive fraction."},
   {"text": "x = 2 or x = -4", "feedback": "The first factor is 3x - 2, and its 3 divides the root: the solution is a third of 2."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'special-angles-and-exact-ratios', 1, 'Easy',
 'What is the exact value of   sin 30° ?', 1,
 '[
   {"text": "√3/2", "feedback": "That is cos 30°. Sine and cosine of 30° are different values."},
   {"text": "1/2", "feedback": "Correct. sin 30° = 1/2, a standard value worth memorising."},
   {"text": "1", "feedback": "That is sin 90°. At 30° the sine has not yet reached its maximum."},
   {"text": "√2/2", "feedback": "That is sin 45°. Check the special triangle for a 30° angle instead."}
 ]'::jsonb,
 'special-angle-ratio'),
('MCR3U', 'trig-geometry', 'special-angles-and-exact-ratios', 2, 'Easy',
 'In the 30-60-90 special triangle whose shortest side is 1,
how long is the hypotenuse?', 2,
 '[
   {"text": "√2", "feedback": "√2 is the hypotenuse of the OTHER special triangle, the 45-45-90 one."},
   {"text": "1", "feedback": "1 is the shortest side, opposite the 30 degree angle. The hypotenuse is opposite the right angle."},
   {"text": "2", "feedback": "Correct."},
   {"text": "√3", "feedback": "√3 is the side opposite the 60 degree angle. The hypotenuse is longer than both legs."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'special-angles-and-exact-ratios', 3, 'Easy',
 'What is the exact value of sin 45°?', 3,
 '[
   {"text": "√3/2", "feedback": "That is sin 60, which comes from the other special triangle."},
   {"text": "1/2", "feedback": "That is sin 30. In the 45-45-90 triangle the two legs are equal, so the ratio is not a half."},
   {"text": "√2", "feedback": "√2 is the HYPOTENUSE of the 45-45-90 triangle. A sine is a ratio, and it cannot exceed 1."},
   {"text": "1/√2", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'special-angles-and-exact-ratios', 4, 'Medium',
 'In which quadrant is θ = 200° located?', 2,
 '[
   {"text": "First", "feedback": "The first quadrant covers 0° to 90°. 200° is well past that."},
   {"text": "Second", "feedback": "The second quadrant runs from 90° to 180°. 200° is just beyond that boundary."},
   {"text": "Third", "feedback": "Correct. The third quadrant runs from 180° to 270°, and 200° falls inside that range."},
   {"text": "Fourth", "feedback": "The fourth quadrant runs from 270° to 360°. 200° comes before that range starts."}
 ]'::jsonb,
 'quadrant-identification'),
('MCR3U', 'trig-geometry', 'special-angles-and-exact-ratios', 5, 'Medium',
 'Find the reference angle for θ = 150°.', 1,
 '[
   {"text": "150°", "feedback": "The reference angle is measured to the nearest x-axis, not the full angle itself."},
   {"text": "30°", "feedback": "Correct. 150° sits in the second quadrant, so the reference angle is 180° − 150° = 30°."},
   {"text": "60°", "feedback": "This subtracts from 90° rather than from 180°, which applies to a different quadrant."},
   {"text": "210°", "feedback": "This adds rather than finding the gap to the nearest axis. Reference angles are always between 0° and 90°."}
 ]'::jsonb,
 'reference-angle'),
('MCR3U', 'trig-geometry', 'special-angles-and-exact-ratios', 6, 'Medium',
 'What is the exact value of cos 60°?', 0,
 '[
   {"text": "1/2", "feedback": "Correct."},
   {"text": "√3/2", "feedback": "That is cos 30. In the special triangle the side adjacent to 60 is the SHORT one."},
   {"text": "1/√2", "feedback": "That is cos 45, from the other special triangle."},
   {"text": "2", "feedback": "2 is the hypotenuse of the 30-60-90 triangle. A cosine is a ratio and cannot exceed 1."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'special-angles-and-exact-ratios', 7, 'Medium',
 'What is the exact value of tan 30°?', 3,
 '[
   {"text": "√3", "feedback": "That is tan 60. The ratio is upside down: at 30 degrees the opposite side is the short one."},
   {"text": "1/2", "feedback": "1/2 is sin 30. Tangent divides by the ADJACENT side, not by the hypotenuse."},
   {"text": "√3/2", "feedback": "√3/2 is cos 30. Tangent divides by the adjacent side, not by the hypotenuse."},
   {"text": "1/√3", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'special-angles-and-exact-ratios', 8, 'Challenge',
 'What is the exact value of cot 300°?', 0,
 '[
   {"text": "-1/√3", "feedback": "Correct."},
   {"text": "1/√3", "feedback": "The size is right but 300 sits in the fourth quadrant, where tangent and therefore cotangent are negative."},
   {"text": "-√3", "feedback": "That is tan 300. Cotangent is its reciprocal, so the fraction turns over."},
   {"text": "√3", "feedback": "Both the size and the sign are off: the reciprocal is needed, and the fourth quadrant makes it negative."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'special-angles-and-exact-ratios', 9, 'Challenge',
 'What is the exact value of tan 135°?', 1,
 '[
   {"text": "-1/√3", "feedback": "The sign is right but the reference angle is not. 180 - 135 gives 45, not 30."},
   {"text": "-1", "feedback": "Correct."},
   {"text": "1", "feedback": "The related acute angle 45 gives 1, but 135 is in the second quadrant, where tangent is negative."},
   {"text": "-√3", "feedback": "The sign is right but the reference angle is not. 180 - 135 gives 45, not 60."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'special-angles-and-exact-ratios', 10, 'Advanced',
 'What is the exact value of sin 60° cos 30° + cos 60° sin 30°?', 3,
 '[
   {"text": "3/4", "feedback": "That is the first product on its own. The second product still has to be added to it."},
   {"text": "1/2", "feedback": "The two products were averaged rather than added."},
   {"text": "√3/2", "feedback": "That is sin 60 by itself, with the rest of the expression left out."},
   {"text": "1", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'trig-applications', 1, 'Easy',
 'A ferris wheel takes 40 seconds to turn once.
What is the period of the height function of one seat?', 0,
 '[
   {"text": "40 seconds", "feedback": "Correct."},
   {"text": "20 seconds", "feedback": "20 seconds is half a turn, which takes a seat from the bottom to the top. A full cycle brings it back down again."},
   {"text": "80 seconds", "feedback": "80 seconds is two full turns. The pattern has already repeated once by then."},
   {"text": "360 seconds", "feedback": "360 is the number of DEGREES in a full turn, not the number of seconds this wheel takes."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'trig-applications', 2, 'Easy',
 'A lake has a highest tide of 5.2 m and a lowest tide of 0.6 m.
What is the amplitude of the tide function?', 3,
 '[
   {"text": "4.6 m", "feedback": "4.6 is the full range from lowest to highest. Amplitude is half of that."},
   {"text": "2.9 m", "feedback": "2.9 is the equation of the axis, the level half way between the two tides."},
   {"text": "5.8 m", "feedback": "That adds the two heights. Amplitude comes from their difference, halved."},
   {"text": "2.3 m", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'trig-applications', 3, 'Medium',
 'A right triangle has hypotenuse 10 and one angle 40°. Find the side opposite that angle.', 0,
 '[
   {"text": "6.43", "feedback": "Correct. sin 40° ≈ 0.643, and 0.643 × 10 ≈ 6.43."},
   {"text": "7.66", "feedback": "That uses cos 40° instead. The opposite side needs sine, not cosine."},
   {"text": "8.39", "feedback": "That uses tan 40° multiplied by the hypotenuse, but tangent does not directly involve the hypotenuse."},
   {"text": "10", "feedback": "This uses the full hypotenuse without adjusting for the angle at all."}
 ]'::jsonb,
 'chooses-wrong-ratio'),
('MCR3U', 'trig-functions', 'trig-applications', 4, 'Medium',
 'In triangle ABC, angle A = 50°, side a = 12, side b = 15. Use the law of sines to find angle B.', 2,
 '[
   {"text": "50°", "feedback": "Angle B cannot equal angle A here, since side b is longer than side a, which means angle B must be larger."},
   {"text": "40°", "feedback": "Side b is longer than side a, so angle B should be larger than angle A, not smaller."},
   {"text": "73°", "feedback": "Correct. sin B / 15 = sin 50° / 12 gives sin B ≈ 0.957, and taking the inverse sine gives about 73°."},
   {"text": "90°", "feedback": "This assumes a right angle without checking. Solve sin B = 15 × sin50° / 12 directly."}
 ]'::jsonb,
 'sine-law-setup'),
('MCR3U', 'trig-functions', 'trig-applications', 5, 'Medium',
 'A ladder leans against a wall, making a 70° angle with the ground, and reaches 5 m up the wall. How long is the ladder?', 3,
 '[
   {"text": "5 × sin70°", "feedback": "The 5 m is already the opposite side, so multiplying by sine again is not the right move here."},
   {"text": "5 × cos70°", "feedback": "Cosine relates the adjacent side to the hypotenuse, but the 5 m given is the side opposite the angle."},
   {"text": "5 × tan70°", "feedback": "Tangent would connect the two legs of the triangle, but the question asks for the hypotenuse, the ladder itself."},
   {"text": "5 ÷ sin70°", "feedback": "Correct. sin70° = opposite ÷ hypotenuse = 5 ÷ ladder length, so ladder length = 5 ÷ sin70°."}
 ]'::jsonb,
 'chooses-wrong-ratio'),
('MCR3U', 'trig-functions', 'trig-applications', 6, 'Medium',
 'A lake has its highest tide at 8:00 am and its lowest at 8:00 pm,
and the pattern repeats daily. What is the period?', 0,
 '[
   {"text": "24 hours", "feedback": "Correct."},
   {"text": "12 hours", "feedback": "12 hours is high tide to low tide, which is HALF a cycle. A full cycle returns to high tide."},
   {"text": "8 hours", "feedback": "8 is when the high tide happens, measured from midnight. That is the phase shift, not the period."},
   {"text": "20 hours", "feedback": "That adds 8 and 12. The period is the time from one high tide to the next."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'trig-applications', 7, 'Medium',
 'A lake has a highest tide of 5.2 m and a lowest of 0.6 m.
What is the equation of the axis of the tide function?', 2,
 '[
   {"text": "y = 5.8", "feedback": "That adds the two heights without halving them."},
   {"text": "y = 0.6", "feedback": "0.6 is the lowest tide, the bottom of the curve. The axis is half way up."},
   {"text": "y = 2.9", "feedback": "Correct."},
   {"text": "y = 2.3", "feedback": "2.3 is the amplitude, which comes from the DIFFERENCE. The axis comes from the average."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'trig-applications', 8, 'Hard',
 'Two sides of a triangle are 8 and 10, with an included angle of 60°. Find the third side, using the law of cosines.', 3,
 '[
   {"text": "6", "feedback": "This is too small for these side lengths and this angle. Recompute 8² + 10² − 2(8)(10)cos60° carefully."},
   {"text": "9", "feedback": "Close, but check the subtraction of 2(8)(10)cos60° from 8² + 10² before taking the square root."},
   {"text": "8.7", "feedback": "This looks like the law of sines was used instead. The law of cosines is needed when you know two sides and the included angle."},
   {"text": "9.17", "feedback": "Correct. c² = 64 + 100 − 160(0.5) = 84, and √84 ≈ 9.17."}
 ]'::jsonb,
 'cosine-law-setup'),
('MCR3U', 'trig-functions', 'trig-applications', 9, 'Challenge',
 'A windmill tower is 40 m tall and each blade is 10 m long.
What is the greatest height reached by the tip of a blade?', 1,
 '[
   {"text": "80 m", "feedback": "That doubles the tower. It is the blade that is added on top, and the blade is 10 m."},
   {"text": "50 m", "feedback": "Correct."},
   {"text": "30 m", "feedback": "30 m is the LOWEST the tip gets, when the blade points straight down."},
   {"text": "40 m", "feedback": "40 m is the height of the hub, the level the tip waves about. The blade carries the tip above it."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'trig-applications', 10, 'Challenge',
 'A lake has its highest tide of 5.2 m at 8:00 am and its lowest of 0.6 m at
8:00 pm, repeating daily. Which cosine equation gives the height y in terms
of the hours after midnight, x?', 3,
 '[
   {"text": "y = 2.3 cos[15(x + 8)] + 2.9", "feedback": "High tide is 8 hours AFTER midnight, so the curve is pushed right, which needs x - 8 inside the bracket."},
   {"text": "y = 2.3 cos[24(x - 8)] + 2.9", "feedback": "24 is the period. k is 360 divided by the period, which is 15."},
   {"text": "y = 2.9 cos[15(x - 8)] + 2.3", "feedback": "The amplitude and the axis have swapped places. The bigger of the two is the level the tide waves about."},
   {"text": "y = 2.3 cos[15(x - 8)] + 2.9", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'trig-applications', 11, 'Advanced',
 'A ferris wheel has a radius of 9 m and its centre is 11 m above the ground.
A rider boards at the lowest point. Which equation gives the height y after
the wheel has turned x degrees?', 3,
 '[
   {"text": "y = 9 cos x + 11", "feedback": "That puts the rider at the TOP when x = 0. Boarding at the lowest point needs the cosine turned over."},
   {"text": "y = -9 cos x + 9", "feedback": "The radius was used as the axis as well. The axis is the height of the centre."},
   {"text": "y = -11 cos x + 9", "feedback": "The radius and the centre height have swapped places. The radius is how far the seat swings from the centre."},
   {"text": "y = -9 cos x + 11", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'trig-applications', 12, 'Advanced',
 'A windmill tower is 40 m tall with 10 m blades. A blade tip starts at the
bottom and one rotation takes 360° of x. Which SINE equation gives its
height?', 3,
 '[
   {"text": "y = 10 sin(x + 90°) + 40", "feedback": "That puts the tip at the TOP when x = 0. Starting at the bottom needs the curve pushed the other way."},
   {"text": "y = 10 sin(x - 90°) + 30", "feedback": "30 m is the lowest point the tip reaches. The axis is the height of the hub, which is the tower."},
   {"text": "y = 40 sin(x - 90°) + 10", "feedback": "The blade length and the tower height have swapped places. The blade is how far the tip swings from the hub."},
   {"text": "y = 10 sin(x - 90°) + 40", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'graphing-sine-and-cosine', 1, 'Easy',
 'What is the period of   y = sin x ?', 1,
 '[
   {"text": "90°", "feedback": "That is a quarter of the way through one cycle, not the full length of a repeat."},
   {"text": "360°", "feedback": "Correct. The sine curve completes one full cycle every 360°, then repeats."},
   {"text": "180°", "feedback": "The curve has not fully repeated after 180° — it has only reached its lowest point by then, not returned to start."},
   {"text": "45°", "feedback": "This is far too short. Picture the sine wave: it takes a full 360° to trace one complete shape."}
 ]'::jsonb,
 'period-of-sine'),
('MCR3U', 'trig-functions', 'graphing-sine-and-cosine', 2, 'Easy',
 'What is the value of sin 90°?', 3,
 '[
   {"text": "0", "feedback": "sin 0 and sin 180 are zero. At 90 the sine curve is at the top of its first hill."},
   {"text": "-1", "feedback": "-1 is sin 270, at the bottom of the trough."},
   {"text": "90", "feedback": "A sine is a ratio between -1 and 1. It is never the angle itself."},
   {"text": "1", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'graphing-sine-and-cosine', 3, 'Easy',
 'Between 0° and 360°, where does y = cos x reach its maximum?', 2,
 '[
   {"text": "At 180°", "feedback": "At 180 cosine is at its lowest, not its highest."},
   {"text": "At 270°", "feedback": "At 270 cosine is back on the axis, half way up from its trough."},
   {"text": "At 0°", "feedback": "Correct."},
   {"text": "At 90°", "feedback": "That is where SINE peaks. Cosine starts at the top and is already coming down by 90."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'graphing-sine-and-cosine', 4, 'Medium',
 'What is the amplitude of   y = 4sin(x) − 2 ?', 0,
 '[
   {"text": "4", "feedback": "Correct. The amplitude is the coefficient in front of sine, ignoring the vertical shift of −2."},
   {"text": "2", "feedback": "That is the vertical shift. The amplitude only concerns the number multiplying the sine function."},
   {"text": "−2", "feedback": "The amplitude is always reported as a positive size, describing how far the curve swings from its centre."},
   {"text": "6", "feedback": "This adds the 4 and the 2, but the amplitude and the vertical shift are two separate features of the graph."}
 ]'::jsonb,
 'amplitude-vs-vertical-shift'),
('MCR3U', 'trig-functions', 'graphing-sine-and-cosine', 5, 'Medium',
 'What is the graph of y = sin x doing at x = 180°?', 3,
 '[
   {"text": "Reaching a maximum", "feedback": "The maximum is at 90. By 180 the curve has come all the way back down to the axis."},
   {"text": "Reaching a minimum", "feedback": "The minimum is at 270. At 180 the curve is level with the axis, not below it."},
   {"text": "Undefined", "feedback": "Sine is defined for every angle. It is tangent that has gaps in it."},
   {"text": "Crossing the axis on its way down", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'graphing-sine-and-cosine', 6, 'Medium',
 'Between 0° and 360°, at what value of x does y = cos x equal -1?', 0,
 '[
   {"text": "180°", "feedback": "Correct."},
   {"text": "0°", "feedback": "At 0 the cosine curve is at its highest, at +1."},
   {"text": "90°", "feedback": "At 90 cosine is 0, half way down from its peak."},
   {"text": "270°", "feedback": "270 is where SINE bottoms out. Cosine is back on the axis there."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'graphing-sine-and-cosine', 7, 'Challenge',
 'Which single transformation turns the graph of y = sin x into y = cos x?', 1,
 '[
   {"text": "A shift up of 1", "feedback": "That would lift the whole curve off the axis. Both sine and cosine still wave about y = 0."},
   {"text": "A shift left of 90°", "feedback": "Correct."},
   {"text": "A shift right of 90°", "feedback": "That takes cosine to sine, not the other way. Cosine peaks a quarter turn EARLIER than sine."},
   {"text": "A reflection in the x-axis", "feedback": "That gives y = -sin x, which is zero at 0 rather than at its maximum."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'graphing-sine-and-cosine', 8, 'Challenge',
 'What is the value of y = sin(x + 60°) + 1 when x = 30°?', 1,
 '[
   {"text": "1.5", "feedback": "That takes the sine of 30, which is a half, and adds 1. The sine is of 90, not of 30."},
   {"text": "2", "feedback": "Correct."},
   {"text": "1", "feedback": "That reads the cosine at 90 rather than the sine, the across value on the unit circle instead of the up one."},
   {"text": "0.5", "feedback": "That misses both the shift inside and the + 1 outside."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'graphing-sine-and-cosine', 9, 'Advanced',
 'How many solutions does sin x = 0.5 have between 0° and 720°?', 2,
 '[
   {"text": "3", "feedback": "The solutions come in pairs, one pair per turn, so the total is even."},
   {"text": "8", "feedback": "That counts four per turn. Sine takes each value between -1 and 1 exactly twice in one turn."},
   {"text": "4", "feedback": "Correct."},
   {"text": "2", "feedback": "Two is right for a single turn. 720 degrees is two full turns, and the pattern repeats."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-functions', 'graphing-sine-and-cosine', 10, 'Advanced',
 'Three curves: y = sin x, y = sin(x + 60°) + 1, and y = 2 sin[(2/3)(x - 60°)] - 1.
Which has the LONGEST period?', 0,
 '[
   {"text": "The third, at 540°", "feedback": "Correct."},
   {"text": "The first, at 360°", "feedback": "That assumes the plain sine curve is the slowest one on offer. The period comes from k, so the k inside every bracket has to be checked."},
   {"text": "The second, at 360°", "feedback": "The + 60 and the + 1 slide the curve about but leave its period alone. Only k changes the period."},
   {"text": "They all have the same period", "feedback": "That treats every transformation as leaving the period alone. Sliding a curve sideways or up does, but a k in front of x inside the bracket does not."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'solving-trig-equations', 1, 'Easy',
 'If sin θ = 1/2, what is the ACUTE angle θ?', 1,
 '[
   {"text": "150°", "feedback": "150 does have a sine of a half, but it is obtuse. The question asks for the acute angle."},
   {"text": "30°", "feedback": "Correct."},
   {"text": "60°", "feedback": "sin 60 is √3/2. The angle whose sine is a half is the smaller one in the special triangle."},
   {"text": "45°", "feedback": "sin 45 is 1/√2, which is about 0.71 rather than 0.5."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'solving-trig-equations', 2, 'Easy',
 'How many solutions does sin θ = 0.4 have between 0° and 360°?', 1,
 '[
   {"text": "4", "feedback": "Four solutions would need two full turns. Between 0 and 360 there is only one turn."},
   {"text": "2", "feedback": "Correct."},
   {"text": "1", "feedback": "The calculator gives one, but sine is positive in two quadrants, so a second angle shares the same value."},
   {"text": "3", "feedback": "Sine repeats once per full turn, and it takes each value between -1 and 1 exactly twice in a single turn."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'solving-trig-equations', 3, 'Medium',
 'Find both angles between 0° and 360° with tan θ = -√3.', 2,
 '[
   {"text": "60° and 120°", "feedback": "Only the second of these has a negative tangent. Tangent is positive in the first quadrant."},
   {"text": "150° and 330°", "feedback": "The related acute angle is 60, not 30. tan 60 is √3."},
   {"text": "120° and 300°", "feedback": "Correct."},
   {"text": "60° and 240°", "feedback": "Those are the angles where the tangent is POSITIVE √3. A negative tangent lives in the second and fourth quadrants."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'solving-trig-equations', 4, 'Medium',
 'Find both angles between 0° and 360° with sin θ = √3/2.', 2,
 '[
   {"text": "30° and 150°", "feedback": "The related acute angle is 60, not 30. sin 30 is a half."},
   {"text": "120° and 240°", "feedback": "The first-quadrant solution went missing. Sine is positive in both the first and second quadrants."},
   {"text": "60° and 120°", "feedback": "Correct."},
   {"text": "60° and 240°", "feedback": "240 is in the third quadrant, where sine is negative. The second solution comes from 180 MINUS the first."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'solving-trig-equations', 5, 'Hard',
 'Solve for θ in [0°, 360°):   2sinθ = 1', 2,
 '[
   {"text": "θ = 30° only", "feedback": "This finds one solution, but sine is positive in two quadrants within a full rotation."},
   {"text": "θ = 30° and 330°", "feedback": "330° is in the fourth quadrant, where sine is negative, not the quadrant matching this positive value."},
   {"text": "θ = 30° and 150°", "feedback": "Correct. sinθ = 0.5 in the first quadrant at 30°, and by symmetry also in the second quadrant at 180° − 30° = 150°."},
   {"text": "θ = 150° only", "feedback": "This finds only the second-quadrant solution. There is a matching first-quadrant angle as well."}
 ]'::jsonb,
 'second-quadrant-solution'),
('MCR3U', 'trig-geometry', 'solving-trig-equations', 6, 'Challenge',
 'Find both angles between 0° and 360° with tan θ = -0.32,
each to one decimal place.', 2,
 '[
   {"text": "197.7° and 342.3°", "feedback": "The second-quadrant solution was placed in the third instead. Tangent is positive in the third quadrant."},
   {"text": "162.3° and 197.7°", "feedback": "Both solutions were put on the same side of the axis. Tangent is negative in the second and fourth quadrants, not the second and third."},
   {"text": "162.3° and 342.3°", "feedback": "Correct."},
   {"text": "17.7° and 197.7°", "feedback": "The minus on the ratio was dropped. Those are the two angles whose tangent is POSITIVE 0.32."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'solving-trig-equations', 7, 'Advanced',
 'Find both angles between 0° and 360° with sin θ = -0.46,
each to one decimal place.', 3,
 '[
   {"text": "27.4° and 152.6°", "feedback": "The minus on the ratio was dropped. Those are the two angles whose sine is POSITIVE 0.46."},
   {"text": "152.6° and 332.6°", "feedback": "The first solution is in the second quadrant, where sine is positive. A negative sine lives in the third and fourth."},
   {"text": "207.4° and 27.4°", "feedback": "The first solution is right, but the second was left as the bare related acute angle, where the sine comes out positive."},
   {"text": "207.4° and 332.6°", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCR3U', 'trig-geometry', 'solving-trig-equations', 8, 'Advanced',
 'Solve 2 sin θ - 1 = 0 for 0° ≤ θ ≤ 360°.', 1,
 '[
   {"text": "60° and 120°", "feedback": "Rearranging gives sin θ = 1/2, not √3/2. The 2 divides rather than multiplies."},
   {"text": "30° and 150°", "feedback": "Correct."},
   {"text": "30° only", "feedback": "The calculator gives one angle, but sine is positive in two quadrants, so a second solution shares the value."},
   {"text": "30° and 210°", "feedback": "210 is in the third quadrant, where sine is negative. The second solution comes from 180 MINUS the first."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'working-with-radicals', 1, 'Easy',
 'Simplify √50 as a mixed radical.', 0,
 '[
   {"text": "5√2", "feedback": "Correct."},
   {"text": "25√2", "feedback": "The perfect square 25 comes OUT as its square root, which is 5, not as 25 itself."},
   {"text": "2√5", "feedback": "The numbers are the wrong way round. It is the square root of the perfect square factor that moves out front."},
   {"text": "5√10", "feedback": "That splits 50 as 5 × 10 and takes the root of the 5. Neither 5 nor 10 is a perfect square — use 25 × 2."}
 ]'::jsonb,
 null),
('MCR3U', 'functions', 'working-with-radicals', 2, 'Easy',
 'Evaluate: √9 × √4', 2,
 '[
   {"text": "13", "feedback": "That adds 9 + 4. The radicals here are multiplied, not added."},
   {"text": "12", "feedback": "One root was taken and the other forgotten: 3 × 4 uses the un-rooted 4."},
   {"text": "6", "feedback": "Correct."},
   {"text": "36", "feedback": "That multiplies 9 by 4 and never takes the roots. Root first, or root the product 36 at the end — either way finish the root."}
 ]'::jsonb,
 null);