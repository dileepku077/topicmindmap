-- MTH1W part b (continued -- no delete here, part a already cleared this course's rows)

insert into public.questions
  (course_code, unit_code, subtopic_code, sort_order, difficulty,
   prompt, correct_index, options, misconception_tag)
values
('MTH1W', 'number-sense', 'fractions', 11, 'Advanced',
 'Evaluate: 5/6 divided by 4/3, simplified fully.', 3,
 '[
   {"text": "20/18", "feedback": "That multiplied straight across without taking the reciprocal."},
   {"text": "8/5", "feedback": "That flipped the first fraction instead of the second."},
   {"text": "9/10", "feedback": "Both fractions were turned over. Only the second one gets flipped."},
   {"text": "5/8", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'ratios-rates-and-proportions', 1, 'Easy',
 'Write the ratio 18 : 24 in simplest form.', 2,
 '[
   {"text": "9 : 12", "feedback": "You divided by 2, which helps, but both numbers can still be divided further."},
   {"text": "18 : 24", "feedback": "Both numbers share a common factor, so this can be reduced."},
   {"text": "3 : 4", "feedback": "Correct. Dividing both by 6, their greatest common factor, gives 3 : 4."},
   {"text": "6 : 8", "feedback": "You divided by 3. There is still a common factor of 2 left in both numbers."}
 ]'::jsonb,
 'ratio-not-fully-simplified'),
('MTH1W', 'number-sense', 'ratios-rates-and-proportions', 2, 'Easy',
 'A bag holds circles and squares in the ratio 2 : 4. How many parts does that ratio have in total?', 0,
 '[
   {"text": "6", "feedback": "Correct."},
   {"text": "8", "feedback": "That multiplied the two parts. A total is found by adding them."},
   {"text": "2", "feedback": "That is one part of the ratio only. The total counts both parts."},
   {"text": "4", "feedback": "That is the other part on its own. Add the two together."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'ratios-rates-and-proportions', 3, 'Medium',
 'Simplify the ratio 18 : 24', 2,
 '[
   {"text": "4 : 3", "feedback": "The numbers are right but the order is not. A ratio has to keep the order it was given in."},
   {"text": "12 : 18", "feedback": "That took the same amount away from each part. Ratios simplify by division, not by subtraction."},
   {"text": "3 : 4", "feedback": "Correct."},
   {"text": "1 : 6", "feedback": "That divided the two parts by different numbers. Both parts have to be divided by the same one."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'ratios-rates-and-proportions', 4, 'Medium',
 'A shop sells 4 chocolate bars for 10 dollars. What is the unit rate?', 1,
 '[
   {"text": "0.40 dollars per bar", "feedback": "That divided the number of bars by the price. A cost per bar puts the money on top."},
   {"text": "2.50 dollars per bar", "feedback": "Correct."},
   {"text": "14 dollars per bar", "feedback": "That added the two numbers. A rate compares them by division."},
   {"text": "40 dollars per bar", "feedback": "That multiplied. A unit rate is what ONE bar costs, so it must be less than the total."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'ratios-rates-and-proportions', 5, 'Medium',
 'Convert 58 percent to a decimal.', 3,
 '[
   {"text": "5800", "feedback": "That multiplied by 100. Going from percent to decimal divides by 100."},
   {"text": "0.058", "feedback": "The decimal moved three places instead of two."},
   {"text": "5.8", "feedback": "The decimal moved one place. Percent means out of 100, so it moves two."},
   {"text": "0.58", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'ratios-rates-and-proportions', 6, 'Challenge',
 'A recipe uses 3 cups of flour to 2 eggs. You have only 1 egg. How much flour do you need?', 2,
 '[
   {"text": "3 cups", "feedback": "The flour has to change too — the ratio between them must stay the same."},
   {"text": "6 cups", "feedback": "That doubled instead of halved. Fewer eggs means less flour, not more."},
   {"text": "1.5 cups", "feedback": "Correct."},
   {"text": "2 cups", "feedback": "That subtracted 1 from the flour instead of scaling it. Halving the eggs halves everything."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'ratios-rates-and-proportions', 7, 'Challenge',
 'Which is the better buy: 8.49 dollars for 0.45 kg, or 34.81 dollars for 2.14 kg?', 0,
 '[
   {"text": "The 34.81 dollar option", "feedback": "Correct."},
   {"text": "They cost the same per kilogram", "feedback": "Work out the cost per kilogram for each — they are more than two dollars apart."},
   {"text": "There is not enough information", "feedback": "There is: a price and a mass for each. That is all a unit rate needs."},
   {"text": "The 8.49 dollar option, because it costs less in total", "feedback": "A smaller total price buys a smaller amount. Compare what one kilogram costs in each."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'ratios-rates-and-proportions', 8, 'Challenge',
 'Callum types 100 words in 4 minutes. At that rate, how many words does he type in 10 minutes?', 1,
 '[
   {"text": "40 words", "feedback": "That divided when it should have multiplied. More time means more words."},
   {"text": "250 words", "feedback": "Correct."},
   {"text": "106 words", "feedback": "That added the extra 6 minutes as 6 words. Find the rate per minute first."},
   {"text": "400 words", "feedback": "That multiplied 100 by 4. The 4 minutes is what the 100 words already took."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'ratios-rates-and-proportions', 9, 'Challenge',
 'There are 60 shapes in a ratio of 1 circle to 2 squares. How many circles are there?', 1,
 '[
   {"text": "30", "feedback": "That split the 60 into two equal halves. A ratio of 1 to 2 is not an even split."},
   {"text": "20", "feedback": "Correct."},
   {"text": "15", "feedback": "That divided by 4. Count how many parts the ratio actually has in total."},
   {"text": "40", "feedback": "That is the other part of the ratio. The question asks for the smaller share."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'ratios-rates-and-proportions', 10, 'Advanced',
 'A 1.8 m tall person casts a 2.4 m shadow. At the same moment a tree casts a 14 m shadow. How tall is the tree?', 1,
 '[
   {"text": "25.2 m", "feedback": "That multiplied the height by the whole shadow length, skipping the ratio."},
   {"text": "10.5 m", "feedback": "Correct."},
   {"text": "18.7 m", "feedback": "That multiplied by the shadow ratio the wrong way round. The tree is taller than its shadow only if the person is too."},
   {"text": "13.4 m", "feedback": "That subtracted rather than scaled. The two triangles are related by multiplication."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'ratios-rates-and-proportions', 11, 'Advanced',
 'A jacket costs 80 dollars. Its price rises 25 percent, then falls 25 percent. What is the final price?', 1,
 '[
   {"text": "80 dollars", "feedback": "The two percentages are taken from different amounts, so they do not cancel."},
   {"text": "75 dollars", "feedback": "Correct."},
   {"text": "85 dollars", "feedback": "That worked the rise out from the raised price and the fall from the original. Each percentage is taken from the price in force at the time."},
   {"text": "100 dollars", "feedback": "That applied only the rise. The fall happens afterwards."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'number-sets', 1, 'Easy',
 'Which set contains 0 but NOT any negative numbers?', 0,
 '[
   {"text": "Whole numbers", "feedback": "Correct."},
   {"text": "Integers", "feedback": "Integers do include zero, but they also run in the negative direction."},
   {"text": "Rational numbers", "feedback": "Rationals include zero, but they include far more than this question allows."},
   {"text": "Natural numbers", "feedback": "The natural numbers are the counting numbers, and counting starts at 1."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'number-sets', 2, 'Easy',
 'Which of these numbers is IRRATIONAL?', 3,
 '[
   {"text": "4", "feedback": "Any integer can be written over 1, which makes it a fraction of two integers."},
   {"text": "0.125", "feedback": "This decimal stops. A decimal that terminates can always be written as a fraction."},
   {"text": "-9/2", "feedback": "This is already written as a fraction of two integers."},
   {"text": "the square root of 2", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'number-sets', 3, 'Medium',
 'Between which two whole numbers does √50 lie?', 1,
 '[
   {"text": "6 and 7", "feedback": "6² is 36 and 7² is 49. Both are below 50, so the root is larger than this range."},
   {"text": "7 and 8", "feedback": "Correct. 7² = 49 and 8² = 64, and 50 sits between them."},
   {"text": "24 and 26", "feedback": "That is roughly half of 50. A square root is much smaller than half for numbers this size."},
   {"text": "8 and 9", "feedback": "8² is already 64, which is well past 50. Try one pair lower."}
 ]'::jsonb,
 'square-root-estimation'),
('MTH1W', 'number-sense', 'number-sets', 4, 'Medium',
 'Which subsets does the number 0 belong to?', 1,
 '[
   {"text": "Natural, whole, integer and rational", "feedback": "One of these starts counting at 1, so zero is not in it."},
   {"text": "Whole, integer and rational", "feedback": "Correct."},
   {"text": "Integer and rational only", "feedback": "That ruled a set out too soon. Test zero against the definition of each set before leaving it off the list."},
   {"text": "Rational only", "feedback": "Zero sits in more of these sets than this. Check what each definition actually allows in."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'number-sets', 5, 'Challenge',
 'Which list puts the number sets in order so that each one is completely contained inside the next?', 0,
 '[
   {"text": "Natural, whole, integer, rational", "feedback": "Correct."},
   {"text": "Whole, natural, integer, rational", "feedback": "The first two are the wrong way round. Adding zero to the counting numbers makes the larger set, not the smaller one."},
   {"text": "Integer, whole, natural, rational", "feedback": "The integers already contain both of the sets listed after them."},
   {"text": "Rational, integer, whole, natural", "feedback": "The rationals already contain every set listed after them. The list has to start with the smallest set."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'number-sets', 6, 'Advanced',
 'A student claims every square root is irrational. Which number proves them wrong?', 3,
 '[
   {"text": "pi", "feedback": "Pi is irrational, and it is not a square root either."},
   {"text": "the square root of 2", "feedback": "This one is genuinely irrational, so it supports the claim rather than disproving it."},
   {"text": "the square root of 3", "feedback": "This one is irrational too. Look for a root that comes out exactly."},
   {"text": "the square root of 16", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'density-and-limits', 1, 'Easy',
 'A set is DENSE when:', 3,
 '[
   {"text": "all its elements are close to zero", "feedback": "Density is about the spacing between elements, not about where they sit."},
   {"text": "it has a largest and a smallest element", "feedback": "That describes a bounded set. Density says nothing about the ends."},
   {"text": "it has infinitely many elements", "feedback": "The integers are infinite too, and they are not dense. Density is about gaps, not about size."},
   {"text": "between any two of its numbers there is always another one from the same set", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'density-and-limits', 2, 'Medium',
 'How many elements are in the set of WHOLE numbers between 5 and 10?', 1,
 '[
   {"text": "Infinitely many", "feedback": "That is true for the rationals in this range, but whole numbers have gaps between them."},
   {"text": "4", "feedback": "Correct."},
   {"text": "6", "feedback": "That counted 5 and 10 themselves. Between means strictly inside."},
   {"text": "5", "feedback": "One of the two endpoints was counted. Between excludes both."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'density-and-limits', 3, 'Challenge',
 'The set of RATIONAL numbers between 5 and 10 contains how many elements?', 0,
 '[
   {"text": "Infinitely many", "feedback": "Correct."},
   {"text": "5", "feedback": "That counts a few obvious values. Between any two of them there is always another."},
   {"text": "It cannot be determined", "feedback": "It can. Ask whether a number always exists between any two you name."},
   {"text": "4", "feedback": "That is the count of whole numbers in that range. Rationals include everything in between them."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'density-and-limits', 4, 'Challenge',
 'What is the limit of the set of WHOLE numbers as the values decrease?', 0,
 '[
   {"text": "0", "feedback": "Correct."},
   {"text": "1", "feedback": "That is where the NATURAL numbers stop. The whole numbers include one more value below it."},
   {"text": "There is no limit", "feedback": "Decreasing whole numbers do run out — they cannot go below their smallest member."},
   {"text": "Negative infinity", "feedback": "That is the answer for the integers. The whole numbers stop somewhere the integers do not."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'density-and-limits', 5, 'Advanced',
 'How many subsets does a set with 5 elements have?', 2,
 '[
   {"text": "10", "feedback": "That doubled the number of elements. The rule uses the count as an exponent, not a multiplier."},
   {"text": "25", "feedback": "That squared the number of elements. The base and the exponent are the other way round."},
   {"text": "32", "feedback": "Correct."},
   {"text": "5", "feedback": "That counts only the single-element subsets, and forgets the empty set and the larger ones."}
 ]'::jsonb,
 null),
('MTH1W', 'number-sense', 'density-and-limits', 6, 'Advanced',
 'What is the limit of the values in the sequence 1/3, 1/9, 1/27, ... as the terms continue?', 2,
 '[
   {"text": "Infinity", "feedback": "The terms are shrinking, not growing. Check which direction they move."},
   {"text": "There is no limit, because the sequence never ends", "feedback": "An endless sequence can still settle on a value. Endless and unbounded are different things."},
   {"text": "0", "feedback": "Correct."},
   {"text": "1/3", "feedback": "That is the first term. The limit is what the terms head towards, not where they start."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'scientific-notation', 1, 'Easy',
 'Which of these is written correctly in scientific notation?', 3,
 '[
   {"text": "4.5 x 9^3", "feedback": "Scientific notation always uses a power of ten, whatever the number."},
   {"text": "45 x 10^2", "feedback": "The number in front has to be at least 1 and less than 10. This one is too large."},
   {"text": "0.45 x 10^4", "feedback": "The number in front has to be at least 1. This one is too small."},
   {"text": "4.5 x 10^3", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'scientific-notation', 2, 'Easy',
 'Write 3.2 x 10^4 in standard form.', 3,
 '[
   {"text": "3 200", "feedback": "The decimal moved three places. The exponent says how many."},
   {"text": "320 000", "feedback": "The decimal moved five places, one too many."},
   {"text": "0.00032", "feedback": "That moved the decimal LEFT. A positive exponent moves it right."},
   {"text": "32 000", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'scientific-notation', 3, 'Medium',
 'Write 0.00047 in scientific notation.', 2,
 '[
   {"text": "47 x 10^-5", "feedback": "The power of ten is consistent, but the number in front must be at least 1 and less than 10."},
   {"text": "4.7 x 10^-3", "feedback": "The decimal was counted one place short. Count every place it has to move."},
   {"text": "4.7 x 10^-4", "feedback": "Correct."},
   {"text": "4.7 x 10^4", "feedback": "The exponent has the wrong sign. A number smaller than 1 needs a negative power of ten."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'scientific-notation', 4, 'Medium',
 'Write 947 000 000 in scientific notation.', 0,
 '[
   {"text": "9.47 x 10^8", "feedback": "Correct."},
   {"text": "9.47 x 10^-8", "feedback": "The sign is wrong. A number larger than 1 needs a positive power of ten."},
   {"text": "9.47 x 10^7", "feedback": "One place short. Count the places the decimal moves from the end of the number."},
   {"text": "947 x 10^6", "feedback": "The power of ten works, but the number in front has to be less than 10."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'scientific-notation', 5, 'Challenge',
 'Which of these numbers is the largest?', 3,
 '[
   {"text": "8.7 x 10^3", "feedback": "This has the smallest power of ten of all four."},
   {"text": "5.0 x 10^4", "feedback": "Its power of ten is beaten by one of the others."},
   {"text": "9.9 x 10^4", "feedback": "This has the biggest number in front, but that is not what decides the size. Compare the powers of ten first."},
   {"text": "3.2 x 10^5", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'scientific-notation', 6, 'Challenge',
 'Evaluate (2 x 10^3)(4 x 10^5), leaving the answer in scientific notation.', 1,
 '[
   {"text": "6 x 10^8", "feedback": "The power of ten is right, but the numbers in front were added rather than multiplied."},
   {"text": "8 x 10^8", "feedback": "Correct."},
   {"text": "8 x 10^2", "feedback": "The exponents were subtracted, which is the rule for dividing."},
   {"text": "8 x 10^15", "feedback": "The exponents were multiplied. Multiplying powers of ten adds them."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'scientific-notation', 7, 'Advanced',
 'Evaluate (6 x 10^8) divided by (3 x 10^-2), leaving the answer in scientific notation.', 1,
 '[
   {"text": "2 x 10^-16", "feedback": "The exponents were multiplied. Dividing powers of ten subtracts them."},
   {"text": "2 x 10^10", "feedback": "Correct."},
   {"text": "3 x 10^10", "feedback": "The power of ten is right, but the numbers in front were subtracted instead of divided."},
   {"text": "2 x 10^6", "feedback": "Subtracting a negative exponent adds. This went the other way."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'scientific-notation', 8, 'Advanced',
 'Evaluate 3.5 x 10^4 + 2.1 x 10^5, leaving the answer in scientific notation.', 1,
 '[
   {"text": "5.6 x 10^9", "feedback": "Adding does not combine the powers of ten. That is what multiplying does."},
   {"text": "2.45 x 10^5", "feedback": "Correct."},
   {"text": "2.45 x 10^4", "feedback": "The addition is right, but the answer was left on the smaller power of ten."},
   {"text": "5.6 x 10^5", "feedback": "The numbers in front were added without first putting both terms on the same power of ten."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'power-of-a-product-or-quotient', 1, 'Easy',
 'Simplify (xy)^3.', 0,
 '[
   {"text": "x^3y^3", "feedback": "Correct."},
   {"text": "x^3y", "feedback": "The exponent only reached the first factor. Both are inside the brackets."},
   {"text": "3xy", "feedback": "That multiplied by 3. The exponent repeats the whole bracket, it does not multiply it."},
   {"text": "xy^3", "feedback": "The exponent only reached one of the two factors. Everything inside the brackets is being cubed."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'power-of-a-product-or-quotient', 2, 'Easy',
 'Evaluate (2/3)^2.', 2,
 '[
   {"text": "4/3", "feedback": "Only the numerator was squared. The exponent applies to the bottom as well."},
   {"text": "4/6", "feedback": "The top was squared but the bottom was only doubled."},
   {"text": "4/9", "feedback": "Correct."},
   {"text": "2/9", "feedback": "Only the denominator was squared. The exponent applies to the top as well."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'power-of-a-product-or-quotient', 3, 'Medium',
 'Simplify (3x^2)^4.', 0,
 '[
   {"text": "81x^8", "feedback": "Correct."},
   {"text": "81x^6", "feedback": "The coefficient is right, but the exponents on x were added instead of multiplied."},
   {"text": "3x^8", "feedback": "The variable was handled correctly, but the coefficient is inside the brackets too."},
   {"text": "12x^8", "feedback": "The coefficient was multiplied by the exponent rather than raised to it."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'power-of-a-product-or-quotient', 4, 'Medium',
 'Simplify (x^2 / y^3)^4.', 1,
 '[
   {"text": "x^2 / y^12", "feedback": "The exponent only reached the denominator. It applies to the numerator as well."},
   {"text": "x^8 / y^12", "feedback": "Correct."},
   {"text": "x^8 / y^3", "feedback": "The exponent only reached the numerator. It applies to the denominator as well."},
   {"text": "x^6 / y^7", "feedback": "The exponents were added. A power of a power multiplies them."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'power-of-a-product-or-quotient', 5, 'Challenge',
 'Simplify (-2x^4y^5)^2.', 2,
 '[
   {"text": "-2x^8y^10", "feedback": "The variables were raised correctly, but the coefficient was left untouched."},
   {"text": "-4x^8y^10", "feedback": "Everything else is right, but an even exponent on a negative base does not leave it negative."},
   {"text": "4x^8y^10", "feedback": "Correct."},
   {"text": "4x^6y^7", "feedback": "The coefficient is right, but the exponents were added rather than multiplied."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'power-of-a-product-or-quotient', 6, 'Challenge',
 'Simplify (3a^2b)^5.', 2,
 '[
   {"text": "15a^10b^5", "feedback": "The coefficient was multiplied by the exponent rather than raised to it."},
   {"text": "243a^7b^5", "feedback": "The coefficient is right, but the exponents on a were added instead of multiplied."},
   {"text": "243a^10b^5", "feedback": "Correct."},
   {"text": "3a^10b^5", "feedback": "The variables are right, but the coefficient is inside the brackets and has to be raised too."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'power-of-a-product-or-quotient', 7, 'Advanced',
 'Simplify (-2uv^3)(8u^2v^2) divided by (4uv^2)^2.', 3,
 '[
   {"text": "uv", "feedback": "Everything else is right, but the minus sign from the first bracket was lost."},
   {"text": "-16uv", "feedback": "The variables divided correctly, but the 4 in the bottom bracket was dropped instead of being squared."},
   {"text": "-16u^3v^5", "feedback": "That is the top simplified. The bottom still has to be squared and divided out."},
   {"text": "-uv", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'power-of-a-product-or-quotient', 8, 'Advanced',
 'Simplify (3m^3n)^2 divided by (2mn)(3m^2n).', 1,
 '[
   {"text": "m^3 / 2", "feedback": "The 3 in the top bracket was not squared before dividing."},
   {"text": "3m^3 / 2", "feedback": "Correct."},
   {"text": "3m^9 / 2", "feedback": "The exponents on m were added rather than subtracted after the bracket was squared."},
   {"text": "3m^3", "feedback": "The variables are right, but the numbers do not divide evenly. Check 9 against 6."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'negative-exponents', 1, 'Easy',
 'Evaluate 5^-2.', 1,
 '[
   {"text": "-1/25", "feedback": "The reciprocal is right, but the minus sign should not survive the move."},
   {"text": "1/25", "feedback": "Correct."},
   {"text": "1/10", "feedback": "That multiplied the base by the exponent before taking the reciprocal."},
   {"text": "-25", "feedback": "A negative exponent does not make the answer negative. It moves the power to the bottom of a fraction."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'negative-exponents', 2, 'Easy',
 'The negative exponent rule says a^-3 is equal to:', 3,
 '[
   {"text": "-a^3", "feedback": "The minus sign does not move onto the front of the power. It signals a reciprocal."},
   {"text": "-3a", "feedback": "That multiplied the base by the exponent. The exponent still means repeated multiplication."},
   {"text": "a^3", "feedback": "The sign was simply dropped. It has a meaning that has to be honoured."},
   {"text": "1/a^3", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'negative-exponents', 3, 'Medium',
 'Simplify x^5 / x^9, writing the answer without a negative exponent.', 2,
 '[
   {"text": "x^4", "feedback": "The exponents were subtracted the other way round. Take the bottom from the top."},
   {"text": "1 / x^14", "feedback": "That added the exponents. Dividing subtracts them."},
   {"text": "1 / x^4", "feedback": "Correct."},
   {"text": "x^45", "feedback": "That multiplied the exponents, which is the rule for a power of a power."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'negative-exponents', 4, 'Medium',
 'Evaluate (3/4)^-2.', 2,
 '[
   {"text": "6/8", "feedback": "That multiplied top and bottom by 2 instead of squaring them."},
   {"text": "9/16", "feedback": "The fraction was squared but never flipped. A negative exponent on a fraction takes its reciprocal first."},
   {"text": "16/9", "feedback": "Correct."},
   {"text": "-16/9", "feedback": "The flip is right, but the minus sign should not survive it."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'negative-exponents', 5, 'Challenge',
 'Simplify (2m^2)^-3, writing the answer without a negative exponent.', 0,
 '[
   {"text": "1 / (8m^6)", "feedback": "Correct."},
   {"text": "1 / (6m^6)", "feedback": "The coefficient was multiplied by the exponent rather than raised to it."},
   {"text": "-8m^6", "feedback": "The minus sign was moved to the front instead of signalling a reciprocal."},
   {"text": "1 / (2m^6)", "feedback": "The reciprocal and the variable are right, but the 2 is inside the brackets and must be cubed as well."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'negative-exponents', 6, 'Challenge',
 'Simplify (x^7 / y^9)^-4, writing the answer without negative exponents.', 0,
 '[
   {"text": "y^36 / x^28", "feedback": "Correct."},
   {"text": "y^13 / x^11", "feedback": "The flip is right, but the exponents were added rather than multiplied."},
   {"text": "1 / (x^28 y^9)", "feedback": "The outer power was applied to the numerator only. It reaches every factor inside the bracket, top and bottom."},
   {"text": "x^28 / y^36", "feedback": "The exponents were applied correctly, but the fraction was never flipped."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'negative-exponents', 7, 'Advanced',
 'Simplify (y/4)^-3, writing the answer without a negative exponent.', 3,
 '[
   {"text": "12 / y^3", "feedback": "The flip is right, but the 4 was multiplied by 3 instead of cubed."},
   {"text": "-y^3 / 64", "feedback": "Neither the flip nor the sign was handled. A negative exponent means a reciprocal, not a minus."},
   {"text": "y^3 / 64", "feedback": "The cube is right, but the fraction was never flipped."},
   {"text": "64 / y^3", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'powers', 'negative-exponents', 8, 'Advanced',
 'Simplify (2x^-2)^3, writing the answer without a negative exponent.', 0,
 '[
   {"text": "8 / x^6", "feedback": "Correct."},
   {"text": "2 / x^6", "feedback": "The variable is right, but the 2 is inside the brackets and has to be cubed as well."},
   {"text": "8x^6", "feedback": "The coefficient is right, but the negative on the exponent was dropped rather than turned into a reciprocal."},
   {"text": "6 / x^6", "feedback": "The coefficient was multiplied by the exponent rather than raised to it."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'terms-degree-and-naming-polynomials', 1, 'Easy',
 'The depth of a falling stone after t seconds is given by the term -4.9t^2. What is the coefficient of that term?', 0,
 '[
   {"text": "-4.9", "feedback": "Correct."},
   {"text": "4.9", "feedback": "The minus sign belongs to the coefficient. It is not separate from it."},
   {"text": "t^2", "feedback": "That is the variable part. The coefficient is the number multiplying it."},
   {"text": "2", "feedback": "That is the exponent on the variable, not the number in front."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'terms-degree-and-naming-polynomials', 2, 'Easy',
 'What is the degree of the term -2a^2b?', 1,
 '[
   {"text": "2", "feedback": "That used only the exponent on a. The degree adds the exponents on every variable."},
   {"text": "3", "feedback": "Correct."},
   {"text": "1", "feedback": "That counted only the b. Every variable in the term contributes."},
   {"text": "0", "feedback": "Only a constant has degree 0. This term has variables in it."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'terms-degree-and-naming-polynomials', 3, 'Medium',
 'What is the degree of the polynomial 7x^2y^4 + x^6y?', 0,
 '[
   {"text": "7", "feedback": "Correct."},
   {"text": "13", "feedback": "That added the exponents across the whole polynomial. Only the highest term counts."},
   {"text": "2", "feedback": "That counted the terms. The number of terms names the polynomial, it does not give the degree."},
   {"text": "6", "feedback": "That is the largest single exponent. Add the exponents within each term first, then compare the terms."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'terms-degree-and-naming-polynomials', 4, 'Medium',
 'Write an algebraic expression for 10 times the result of 6 less than x.', 3,
 '[
   {"text": "6 - 10x", "feedback": "Both the order and the bracket are lost here. Multiply the whole result by 10."},
   {"text": "10x - 6", "feedback": "That takes 6 off after multiplying. The subtraction happens first, so it needs a bracket."},
   {"text": "10(6 - x)", "feedback": "6 less than x means x take away 6, not the other way round."},
   {"text": "10(x - 6)", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'terms-degree-and-naming-polynomials', 5, 'Challenge',
 'A golf instructor earns 5000 dollars for the season, plus 20 dollars for each childrens lesson (C) and 30 dollars for each adult lesson (A). His earnings are E = 20C + 30A + 5000. What does he earn after 8 childrens lessons and 6 adult lessons?', 2,
 '[
   {"text": "340 dollars in total", "feedback": "The 5000 dollar season fee was left out of the total."},
   {"text": "5700 dollars", "feedback": "The two rates were added and applied to all 14 lessons. Each rate belongs to its own lesson type."},
   {"text": "5340 dollars", "feedback": "Correct."},
   {"text": "5360 dollars", "feedback": "The two lesson counts were swapped. The 8 goes with the 20 dollar rate."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'terms-degree-and-naming-polynomials', 6, 'Challenge',
 'What is the degree of the polynomial 3x^2y^4 + 11x^2y^2 + y^5?', 1,
 '[
   {"text": "15", "feedback": "That added the exponents across every term. Only the highest term decides."},
   {"text": "6", "feedback": "Correct."},
   {"text": "5", "feedback": "That is the degree of the last term. Another term adds up higher."},
   {"text": "4", "feedback": "That is the largest single exponent, not the largest sum on one term."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'terms-degree-and-naming-polynomials', 7, 'Advanced',
 'A polynomial has four terms, and its highest degree term is 5x^2y^3. Which description is correct?', 2,
 '[
   {"text": "A polynomial with three terms and degree 5", "feedback": "The degree is right, but this polynomial has four terms, not three, so it is not a trinomial."},
   {"text": "A polynomial with four terms and degree 6", "feedback": "The exponents were multiplied. Degree adds them."},
   {"text": "A polynomial with four terms and degree 5", "feedback": "Correct."},
   {"text": "A polynomial with four terms and degree 3", "feedback": "That used only the exponent on y. Add the exponents on every variable in the term."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'terms-degree-and-naming-polynomials', 8, 'Advanced',
 'A four-sided shape has sides of length 18x + 7, 9x - 2, 3x + 5 and 3x + 5. What is its perimeter when x = 5?', 1,
 '[
   {"text": "184", "feedback": "The -2 was treated as a positive 2 when the constants were collected."},
   {"text": "180", "feedback": "Correct."},
   {"text": "48", "feedback": "The 33 and the 15 were added straight away. The 33 has to be multiplied by x first."},
   {"text": "165", "feedback": "The x terms collect to 33x, but the constants were dropped. They collect to 15."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'adding-and-subtracting-polynomials', 1, 'Easy',
 'Simplify (4x + 3) + (7x + 2).', 2,
 '[
   {"text": "-3x + 1", "feedback": "That subtracted the second bracket. The operator between them is a plus."},
   {"text": "11x^2 + 5", "feedback": "The exponents were added along with the coefficients. Only the coefficients combine."},
   {"text": "11x + 5", "feedback": "Correct."},
   {"text": "16x", "feedback": "The constants were folded into the x term. A number and an x term are not like terms."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'adding-and-subtracting-polynomials', 2, 'Easy',
 'Simplify (3y + 5) + (7y - 4).', 1,
 '[
   {"text": "10y + 9", "feedback": "The -4 was treated as a positive 4. Keep the sign that sits in front of it."},
   {"text": "10y + 1", "feedback": "Correct."},
   {"text": "10y - 1", "feedback": "The constants were combined the wrong way round. Start from the 5."},
   {"text": "4y + 1", "feedback": "The y terms were subtracted. Both brackets are being added."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'adding-and-subtracting-polynomials', 3, 'Medium',
 'Simplify (4x + 3) - (7x + 2).', 0,
 '[
   {"text": "-3x + 1", "feedback": "Correct."},
   {"text": "-3x + 5", "feedback": "The subtraction reached the 7x but not the 2. Every term in the second bracket changes sign."},
   {"text": "11x + 5", "feedback": "The brackets were added. The operator between them is a minus."},
   {"text": "3x + 1", "feedback": "The x terms were subtracted the wrong way round. Start from the 4x."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'adding-and-subtracting-polynomials', 4, 'Medium',
 'Simplify (6x - 12) + (-9x - 4) + (x + 14).', 3,
 '[
   {"text": "-2x - 30", "feedback": "All three constants were taken as negative. The 14 is being added."},
   {"text": "16x - 2", "feedback": "The minus on the 9x was dropped. Keep the sign attached to the term."},
   {"text": "-4x - 2", "feedback": "The final x was subtracted rather than added."},
   {"text": "-2x - 2", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'adding-and-subtracting-polynomials', 5, 'Challenge',
 'Simplify (a^2 - 2a + 1) - (-a^2 - 2a - 5).', 2,
 '[
   {"text": "-4a - 4", "feedback": "The brackets were simply dropped. Subtracting flips the sign of every term in the second bracket."},
   {"text": "2a^2 - 4a + 6", "feedback": "The squared terms and the constants were flipped, but the -2a was not. It becomes +2a and cancels."},
   {"text": "2a^2 + 6", "feedback": "Correct."},
   {"text": "2a^2 - 4", "feedback": "The constants were subtracted as 1 take away 5. Subtracting a negative 5 adds it."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'adding-and-subtracting-polynomials', 6, 'Challenge',
 'Simplify (3x + y - 4z) - (7x + 3y - 2z).', 2,
 '[
   {"text": "4x + 2y + 2z", "feedback": "Each pair was subtracted the wrong way round. Start from the first bracket every time."},
   {"text": "-4x - 2y - 6z", "feedback": "The subtraction reached the first two terms but not the -2z. It becomes +2z."},
   {"text": "-4x - 2y - 2z", "feedback": "Correct."},
   {"text": "10x + 4y - 6z", "feedback": "The brackets were added. The operator between them is a minus."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'adding-and-subtracting-polynomials', 7, 'Advanced',
 'Three players have year end salaries of 100000 + 25x, 75000 + 18x and 90000 + 10x, where x is the bonus paid per goal. What is the total paid when x = 10000?', 0,
 '[
   {"text": "795000 dollars", "feedback": "Correct."},
   {"text": "318000 dollars", "feedback": "The bonus was worked out as 53 times 10000 = 53000. Count the zeros again."},
   {"text": "530000 dollars", "feedback": "That is the bonus money only. The three base salaries still have to be added on."},
   {"text": "265000 dollars", "feedback": "That is the base salaries only. The bonuses still have to be added on."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'adding-and-subtracting-polynomials', 8, 'Advanced',
 'Simplify (5x - 4y - 1) + (-2x + 5y + 13) - (x - y + 2).', 0,
 '[
   {"text": "2x + 2y + 10", "feedback": "Correct."},
   {"text": "4x + 14", "feedback": "The third bracket was added rather than subtracted. Every term inside it changes sign."},
   {"text": "2x + 10", "feedback": "The -y stayed negative, so the y terms cancelled. Subtracting a negative y adds a y."},
   {"text": "2x + 2y + 12", "feedback": "The 2 in the last bracket was dropped instead of subtracted."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'multiplying-binomials', 1, 'Easy',
 'Expand and simplify (x + 2)(x + 3).', 0,
 '[
   {"text": "x^2 + 5x + 6", "feedback": "Correct."},
   {"text": "x^2 + 6x + 5", "feedback": "The middle number and the last number have been swapped. The two constants multiply, they do not add."},
   {"text": "2x + 5", "feedback": "The brackets were added rather than multiplied."},
   {"text": "x^2 + 6", "feedback": "Only the first terms and the last terms were multiplied. FOIL has four products, not two."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'multiplying-binomials', 2, 'Easy',
 'Expand and simplify (x + 4)(x - 5).', 0,
 '[
   {"text": "x^2 - x - 20", "feedback": "Correct."},
   {"text": "x^2 + x - 20", "feedback": "The two middle products are -5x and +4x. Check which one is larger."},
   {"text": "x^2 - 20", "feedback": "The outside and inside products were left out. They do not cancel here."},
   {"text": "x^2 - 9x - 20", "feedback": "The middle products were added as if both were negative. Only one of them is."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'multiplying-binomials', 3, 'Medium',
 'Expand and simplify (3x + 1)(2x + 7).', 1,
 '[
   {"text": "6x^2 + 23x + 8", "feedback": "The two constants were added at the end rather than multiplied."},
   {"text": "6x^2 + 23x + 7", "feedback": "Correct."},
   {"text": "5x + 8", "feedback": "The brackets were added rather than multiplied out."},
   {"text": "6x^2 + 21x + 7", "feedback": "The inside product was left out. 1 times 2x also belongs in the middle."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'multiplying-binomials', 4, 'Medium',
 'Expand and simplify (2x - 3)(x + 5).', 1,
 '[
   {"text": "2x^2 - 15", "feedback": "The outside and inside products were left out. They do not cancel here."},
   {"text": "2x^2 + 7x - 15", "feedback": "Correct."},
   {"text": "2x^2 - 7x - 15", "feedback": "The middle products are +10x and -3x. Check which one is larger."},
   {"text": "2x^2 + 13x - 15", "feedback": "The middle products were added as if both were positive. The -3 stays negative."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'multiplying-binomials', 5, 'Challenge',
 'Expand and simplify (x - 4)^2.', 0,
 '[
   {"text": "x^2 - 8x + 16", "feedback": "Correct."},
   {"text": "x^2 - 8x - 16", "feedback": "The middle term is right. The last term is -4 times -4, which is positive."},
   {"text": "x^2 + 16", "feedback": "Each term was squared on its own. Squaring a bracket means multiplying it by itself, which gives a middle term."},
   {"text": "x^2 - 16", "feedback": "That is what (x - 4)(x + 4) gives. A square is the same bracket twice, so the middle products do not cancel."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'multiplying-binomials', 6, 'Challenge',
 'Expand and simplify (2x + 3)(2x - 3).', 1,
 '[
   {"text": "2x^2 - 9", "feedback": "The first product is 2x times 2x, not 2x times x."},
   {"text": "4x^2 - 9", "feedback": "Correct."},
   {"text": "4x^2 + 9", "feedback": "The last product is +3 times -3, which is negative."},
   {"text": "4x^2 + 12x - 9", "feedback": "The two middle products are -6x and +6x. They cancel."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'multiplying-binomials', 7, 'Advanced',
 'Expand and simplify (2x - 5)(3x + 4) - (x + 2)(x - 3).', 3,
 '[
   {"text": "7x^2 - 8x - 26", "feedback": "The second product was added. The minus in front of it flips every term."},
   {"text": "5x^2 - 8x - 26", "feedback": "The subtraction reached the x^2 term but not the rest of the second product."},
   {"text": "5x^2 - 6x - 26", "feedback": "The x terms are handled, but the -6 was not flipped. Subtracting it adds 6."},
   {"text": "5x^2 - 6x - 14", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'algebraic-expressions', 'multiplying-binomials', 8, 'Advanced',
 'Expand and simplify (x + 3)(x^2 - 2x + 5).', 3,
 '[
   {"text": "x^3 + 15", "feedback": "Only the first terms and the last terms were multiplied. Each term in the first bracket meets all three in the second."},
   {"text": "x^3 + 5x^2 - x + 15", "feedback": "The squared terms are -2x^2 and +3x^2. They were added as if both were positive."},
   {"text": "x^3 + x^2 + 11x + 15", "feedback": "The x terms are +5x and -6x. The 3 times -2x product stays negative."},
   {"text": "x^3 + x^2 - x + 15", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'equations-involving-fractions', 1, 'Easy',
 'Solve x / 3 = 10.', 1,
 '[
   {"text": "x = 10 / 3", "feedback": "That divided again. The x is already being divided by 3, so undo it by multiplying."},
   {"text": "x = 30", "feedback": "Correct."},
   {"text": "x = 13", "feedback": "The 3 was added across. It is attached by division, so it comes off by multiplication."},
   {"text": "x = 7", "feedback": "The 3 was subtracted across. Look at how it is attached to the x."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'equations-involving-fractions', 2, 'Easy',
 'Solve 2x / 5 = 10.', 3,
 '[
   {"text": "x = 50", "feedback": "Multiplying by 5 is the right first move, but the 2 in front of x still has to be divided out."},
   {"text": "x = 4", "feedback": "The 5 was divided and the 2 multiplied. Both inverse operations are the wrong way round."},
   {"text": "x = 1", "feedback": "Both steps were done as divisions. Only the 2 comes off by dividing."},
   {"text": "x = 25", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'equations-involving-fractions', 3, 'Medium',
 'Solve (1/3)(x - 2) = 5.', 3,
 '[
   {"text": "x = 21", "feedback": "The 3 was multiplied into only one term of the bracket. It multiplies the whole bracket at once."},
   {"text": "x = 15", "feedback": "That stopped at x - 2 = 15. The 2 still has to be moved."},
   {"text": "x = 13", "feedback": "The 2 was subtracted. It is already being subtracted, so undo it by adding."},
   {"text": "x = 17", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'equations-involving-fractions', 4, 'Medium',
 'Solve -14 = 2(x - 3) / 5.', 3,
 '[
   {"text": "x = -38", "feedback": "After multiplying by 5 you get -70 = 2x - 6. The 6 is being subtracted, so it moves across as an addition."},
   {"text": "x = -35", "feedback": "The 2 in front of the bracket was never divided out, and the 6 was dropped."},
   {"text": "x = -76", "feedback": "The 6 was moved across with the wrong sign, and the answer was left at the value of 2x."},
   {"text": "x = -32", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'equations-involving-fractions', 5, 'Challenge',
 'Solve (2x - 1) / 3 = (3x - 2) / 5.', 0,
 '[
   {"text": "x = -1", "feedback": "Correct."},
   {"text": "x = 1", "feedback": "Each bracket was multiplied out only into its constant term. The multiplier reaches the x as well."},
   {"text": "x = 7/9", "feedback": "The cross multiplication paired each numerator with its own denominator. Each numerator meets the OTHER denominator."},
   {"text": "x = -11", "feedback": "The -5 crossed the equals sign but kept its minus sign."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'equations-involving-fractions', 6, 'Advanced',
 'Solve (1/4)(x - 3) = (1/3)(x - 2).', 0,
 '[
   {"text": "x = -1", "feedback": "Correct."},
   {"text": "x = 6", "feedback": "The 12 was handed to the wrong sides. A quarter needs the 4 cleared, so that side gets multiplied by 3."},
   {"text": "x = -12", "feedback": "The brackets were multiplied out before the denominators were cleared, and a term was lost."},
   {"text": "x = 1", "feedback": "The constants were collected the wrong way round when they crossed sides."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'equations-involving-fractions', 7, 'Advanced',
 'Solve (x - 5) / 3 = (x + 10) / 6.', 0,
 '[
   {"text": "x = 20", "feedback": "Correct."},
   {"text": "x = 15", "feedback": "After multiplying by 6, the 2 in front of the left numerator reached only the x and not the 5."},
   {"text": "x = 5", "feedback": "The brackets were dropped during cross multiplication. The 6 multiplies the whole of x - 5."},
   {"text": "x = -25", "feedback": "The cross multiplication was paired the wrong way. The left numerator meets the RIGHT denominator."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'simple-quadratic-and-cubic-equations', 1, 'Easy',
 'Solve x^2 = 9.', 2,
 '[
   {"text": "x = 81", "feedback": "That squared both sides again. Undo a square by taking the square root."},
   {"text": "x = 3", "feedback": "Only one root was recorded. Check the sign rule that comes with taking a square root."},
   {"text": "x = 3 or x = -3", "feedback": "Correct."},
   {"text": "x = 4.5", "feedback": "That halved the 9. Squaring is not the same as multiplying by 2."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'simple-quadratic-and-cubic-equations', 2, 'Easy',
 'Solve x^3 - 125 = 0.', 1,
 '[
   {"text": "x = 5 or x = -5", "feedback": "Both signs were attached as if this were a square root. Check what cubing does to the sign of a negative base."},
   {"text": "x = 5", "feedback": "Correct."},
   {"text": "x = 375", "feedback": "That multiplied by 3. Undo a cube by taking the cube root, not by multiplying."},
   {"text": "x = 11.18", "feedback": "That took the square root. The exponent here is 3."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'simple-quadratic-and-cubic-equations', 3, 'Medium',
 'Solve x^2 + 100 = 0.', 1,
 '[
   {"text": "x = -10", "feedback": "Squaring -10 gives +100, not -100. The minus sign cannot be carried in by the root."},
   {"text": "There is no real solution", "feedback": "Correct."},
   {"text": "x = 50 or x = -50", "feedback": "That halved the 100. Undo a square with a square root."},
   {"text": "x = 10 or x = -10", "feedback": "Those both give +100 when squared, not -100. Check the sign after moving the 100 across."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'simple-quadratic-and-cubic-equations', 4, 'Challenge',
 'The area of a circle is 30 cm^2. What is its radius, to the nearest tenth of a cm? Use A = pi x r^2.', 1,
 '[
   {"text": "9.5 cm", "feedback": "That is the value of r squared. There is still a square root to take."},
   {"text": "3.1 cm", "feedback": "Correct."},
   {"text": "5.5 cm", "feedback": "That is the square root of 30. The 30 has to be divided by pi first."},
   {"text": "4.8 cm", "feedback": "That used the circumference formula. This question gives an area."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'simple-quadratic-and-cubic-equations', 5, 'Challenge',
 'Solve x^3 = 100, to the nearest hundredth.', 2,
 '[
   {"text": "x = 10", "feedback": "That took the square root. The exponent is 3, so it needs a cube root."},
   {"text": "x = 33.33", "feedback": "That divided by 3. A cube is repeated multiplication, not multiplication by 3."},
   {"text": "x = 4.64", "feedback": "Correct."},
   {"text": "x = 300", "feedback": "That multiplied by 3 instead of undoing the cube."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'simple-quadratic-and-cubic-equations', 6, 'Advanced',
 'The volume of a sphere is 52 cm^3. What is its radius, to the nearest tenth of a cm? Use V = (4/3) x pi x r^3.', 0,
 '[
   {"text": "2.3 cm", "feedback": "Correct."},
   {"text": "3.7 cm", "feedback": "That is the cube root of 52 on its own. The 4/3 and the pi both have to be cleared first."},
   {"text": "2.5 cm", "feedback": "The pi was divided out but the 4/3 was not. Multiply by 3/4 before dividing by pi."},
   {"text": "12.4 cm", "feedback": "That is the value of r cubed. There is still a cube root to take."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'rearranging-formulas', 1, 'Easy',
 'Rearrange d = a + b to isolate a.', 2,
 '[
   {"text": "a = b - d", "feedback": "The two letters were swapped. Start from d and take b off it."},
   {"text": "a = d / b", "feedback": "The b is being added to a, not multiplied by it, so it comes off by subtraction."},
   {"text": "a = d - b", "feedback": "Correct."},
   {"text": "a = d + b", "feedback": "The b was added again. Treat the other letters like numbers and undo the addition."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'rearranging-formulas', 2, 'Easy',
 'The circumference of a circle is C = 2 x pi x r. Rearrange it to isolate r.', 0,
 '[
   {"text": "r = C / (2 x pi)", "feedback": "Correct."},
   {"text": "r = (2 x pi) / C", "feedback": "The fraction is upside down. C is the one being divided."},
   {"text": "r = 2 x pi x C", "feedback": "That multiplied again. Everything attached to r by multiplication comes off by division."},
   {"text": "r = C - 2 x pi", "feedback": "The 2 and the pi are multiplying r, not being added to it."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'rearranging-formulas', 3, 'Medium',
 'Rearrange y = mx + b to isolate x.', 2,
 '[
   {"text": "x = m(y - b)", "feedback": "The m is multiplying x, so it comes off by division, not by multiplying the other side."},
   {"text": "x = (y + b) / m", "feedback": "The b is being added, so it moves across as a subtraction."},
   {"text": "x = (y - b) / m", "feedback": "Correct."},
   {"text": "x = y / m - b", "feedback": "The b was taken off after dividing. It has to come off first, while it is still added to the whole term."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'rearranging-formulas', 4, 'Challenge',
 'Rearrange k = (1/2)mv^2 to isolate v. Write sqrt() for a square root.', 3,
 '[
   {"text": "v = +/- sqrt(k / (2m))", "feedback": "The half was divided rather than multiplied away. Multiply both sides by 2 to clear it."},
   {"text": "v = 2k / m", "feedback": "The square on v was never undone. A square root is still needed."},
   {"text": "v = +/- sqrt(2k) / m", "feedback": "The m stayed outside the root. It is under the square with the 2k."},
   {"text": "v = +/- sqrt(2k / m)", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'rearranging-formulas', 5, 'Challenge',
 'The distance to the horizon is d = 2 x sqrt(3.2h), where h is your height in metres and d is in km. If the horizon is 75.64 km away, how high up are you, to the nearest metre?', 3,
 '[
   {"text": "894 m", "feedback": "The squaring was done, but the 3.2 was only half divided out."},
   {"text": "1788 m", "feedback": "The 2 out front was never divided away before squaring both sides."},
   {"text": "12 m", "feedback": "The 2 was divided out correctly, but then the square root was never undone."},
   {"text": "447 m", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'rearranging-formulas', 6, 'Advanced',
 'The area of a trapezoid is A = (1/2)(a + b)h. Rearrange it to isolate b.', 1,
 '[
   {"text": "b = (2A - a)/h", "feedback": "The a was taken off before the h was divided out. Clear the h first, while a and b are still bracketed together."},
   {"text": "b = 2A/h - a", "feedback": "Correct."},
   {"text": "b = 2A/h + a", "feedback": "The a is inside the bracket being added to b, so it moves across as a subtraction."},
   {"text": "b = A/(2h) - a", "feedback": "The half was divided rather than multiplied away. Multiply both sides by 2 to clear it."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'rearranging-formulas', 7, 'Advanced',
 'Rearrange d = 2 x sqrt(3.2h) to isolate h.', 1,
 '[
   {"text": "h = d^2 / 6.4", "feedback": "The 2 was divided away after squaring rather than before. Squaring turns it into a 4."},
   {"text": "h = d^2 / 12.8", "feedback": "Correct."},
   {"text": "h = 3.2(d/2)^2", "feedback": "The 3.2 is multiplying h under the root, so it comes off by division, not multiplication."},
   {"text": "h = d^2 / 3.2", "feedback": "The 2 out front was never divided away before both sides were squared."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'linear-inequalities', 1, 'Easy',
 'Solve the inequality x + 4 < 10.', 3,
 '[
   {"text": "x > 6", "feedback": "The number is right, but the sign was flipped. It only reverses when you multiply or divide by a negative."},
   {"text": "x < 14", "feedback": "The 4 was added to both sides. Subtract it to isolate x."},
   {"text": "x < 2.5", "feedback": "That divided by 4. The 4 is being added, so it comes off by subtraction."},
   {"text": "x < 6", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'linear-inequalities', 2, 'Medium',
 'Solve the inequality -4x <= -16.', 1,
 '[
   {"text": "x <= 4", "feedback": "The number is right, but dividing both sides by a negative reverses the inequality sign."},
   {"text": "x >= 4", "feedback": "Correct."},
   {"text": "x >= -4", "feedback": "A negative divided by a negative is positive. Check the sign of the answer."},
   {"text": "x <= -4", "feedback": "Neither the sign of the answer nor the direction of the inequality was handled."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'linear-inequalities', 3, 'Medium',
 'Solve the inequality 3 - x < 4.', 2,
 '[
   {"text": "x > 1", "feedback": "The direction was reversed correctly, but the sign of the number was not."},
   {"text": "x < -1", "feedback": "The number is right, but dividing by -1 reverses the inequality."},
   {"text": "x > -1", "feedback": "Correct."},
   {"text": "x < 1", "feedback": "The 3 moves across to give -x < 1. Dividing by -1 reverses the sign."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'linear-inequalities', 4, 'Challenge',
 'Solve the inequality 91 - 4x <= 5x + 10.', 0,
 '[
   {"text": "x >= 9", "feedback": "Correct."},
   {"text": "x <= 9", "feedback": "The number is right, but nothing was divided by a negative here, so the sign should not have flipped."},
   {"text": "x >= -9", "feedback": "The constants were collected the wrong way round. 91 - 10 is positive."},
   {"text": "x <= -9", "feedback": "Both the sign of the number and the direction of the inequality went the wrong way."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'linear-inequalities', 5, 'Challenge',
 'Solve the inequality x/2 + x/3 > 5.', 2,
 '[
   {"text": "x > 1", "feedback": "Only the left side was multiplied by 6. The right side has to be multiplied by 6 as well."},
   {"text": "x > 30", "feedback": "Both sides were multiplied by 6, but the left side was not collected. 3x + 2x is 5x, not x."},
   {"text": "x > 6", "feedback": "Correct."},
   {"text": "x < 6", "feedback": "The number is right, but nothing was divided by a negative, so the sign should not have flipped."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'linear-inequalities', 6, 'Advanced',
 'Boarding house A charges 90 dollars plus 5 dollars per day. Boarding house B charges 100 dollars plus 4 dollars per day. For how many days is A cheaper than B?', 1,
 '[
   {"text": "More than ten days", "feedback": "A charges more per day, so its advantage shrinks as the stay gets longer, not the other way round."},
   {"text": "Fewer than ten days", "feedback": "Correct."},
   {"text": "Fewer than 190 days", "feedback": "The 90 kept its sign when it crossed the inequality."},
   {"text": "Exactly ten days", "feedback": "At that point the two are equal, so neither is cheaper. The question asks when A costs less."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'linear-inequalities', 7, 'Advanced',
 'Solve 2 <= x - 6 and write the answer in interval notation.', 2,
 '[
   {"text": "(-infinity, 8]", "feedback": "The inequality was read backwards. Here x is at least 8, not at most 8."},
   {"text": "(8, infinity)", "feedback": "The round bracket says 8 is excluded, but this inequality allows equality."},
   {"text": "[8, infinity)", "feedback": "Correct."},
   {"text": "[8, infinity]", "feedback": "Infinity is never reached, so it always takes a round bracket."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'turning-word-problems-into-equations', 1, 'Easy',
 'Five more than a number is twenty-seven. Which equation says this?', 1,
 '[
   {"text": "5x = 27", "feedback": "That is five times the number. More than is not multiplication."},
   {"text": "x + 5 = 27", "feedback": "Correct."},
   {"text": "5 - x = 27", "feedback": "That subtracts the number from 5, which reverses the whole statement."},
   {"text": "x - 5 = 27", "feedback": "That is five LESS than the number. More than means addition."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'turning-word-problems-into-equations', 2, 'Medium',
 'Three consecutive integers have a sum of 75. What are the three integers?', 3,
 '[
   {"text": "23, 25, 27", "feedback": "Those add to 75, but they go up in twos. Consecutive integers go up by one."},
   {"text": "25, 25, 25", "feedback": "Those add to 75, but they are the same number three times, not three consecutive integers."},
   {"text": "24, 26, 28", "feedback": "Those go up in twos and do not add to 75."},
   {"text": "24, 25, 26", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'turning-word-problems-into-equations', 3, 'Medium',
 'Curtis is paid 6 dollars per hour plus 50 cents for every bag of peanuts he sells. What does he earn for selling 42 bags during a 4 hour shift?', 1,
 '[
   {"text": "24 dollars", "feedback": "That is the hourly pay only. The commission on 42 bags still has to be added."},
   {"text": "45 dollars", "feedback": "Correct."},
   {"text": "21 dollars", "feedback": "That is the commission only. The 4 hours of pay still has to be added."},
   {"text": "66 dollars", "feedback": "The commission was counted as one dollar a bag. It is 50 cents."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'turning-word-problems-into-equations', 4, 'Challenge',
 'The length of a rectangle is 7 m more than its width, and its perimeter is 60 m. What is the width?', 2,
 '[
   {"text": "13 m", "feedback": "That divided 60 by 4 and then took off 2. The 7 has to be doubled before it is removed."},
   {"text": "26.5 m", "feedback": "The extra 7 was only counted once. A rectangle has two lengths."},
   {"text": "11.5 m", "feedback": "Correct."},
   {"text": "18.5 m", "feedback": "That is the length. The question asks for the width, which is 7 m less."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'turning-word-problems-into-equations', 5, 'Advanced',
 'Sidney makes twice as much per week as Evgeni. Jensen makes 200 dollars a week more than Sidney. The total weekly payroll is 1450 dollars. How much does Sidney make?', 3,
 '[
   {"text": "580 dollars", "feedback": "The 200 dollars was left in the total and shared out, instead of belonging only to Jensen."},
   {"text": "250 dollars", "feedback": "That is what Evgeni makes. Sidney makes twice as much."},
   {"text": "700 dollars", "feedback": "That is what Jensen makes. Sidney makes 200 dollars less than that."},
   {"text": "500 dollars", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'solving-equations', 'turning-word-problems-into-equations', 6, 'Advanced',
 'Max cycles 13 km/h faster than Rory runs. Max covers 46 km in the same time it takes Rory to run 23 km. How fast does Rory run?', 0,
 '[
   {"text": "13 km/h", "feedback": "Correct."},
   {"text": "26 km/h", "feedback": "That is the cycling speed. The question asks for the running speed, which is the slower of the two."},
   {"text": "23 km/h", "feedback": "That is the distance Rory covers, not a speed. Set the two times equal and solve."},
   {"text": "6.5 km/h", "feedback": "That halved the 13. Set 46 over the faster speed equal to 23 over the slower one."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'plotting-points-and-the-cartesian-plane', 1, 'Easy',
 'In which quadrant does the point (3, -2) lie?', 0,
 '[
   {"text": "Quadrant 4", "feedback": "Correct."},
   {"text": "Quadrant 3", "feedback": "That needs both coordinates negative. The x here is positive."},
   {"text": "Quadrant 1", "feedback": "Both coordinates would have to be positive. One of these is not."},
   {"text": "Quadrant 2", "feedback": "That needs a negative x and a positive y. Here it is the other way round."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'plotting-points-and-the-cartesian-plane', 2, 'Easy',
 'Which of these points lies on the y-axis?', 0,
 '[
   {"text": "(0, -4)", "feedback": "Correct."},
   {"text": "(3, 4)", "feedback": "Neither coordinate is zero, so this point sits inside a quadrant."},
   {"text": "(-1, -1)", "feedback": "Neither coordinate is zero here either, and both are negative — this point sits in the third quadrant, not on an axis."},
   {"text": "(2, 0)", "feedback": "A zero in the second slot puts a point on the x-axis, not the y-axis."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'plotting-points-and-the-cartesian-plane', 3, 'Medium',
 'A triangle has vertices at A(-5, -3), B(3, -3) and C(3, 8). What is its area?', 3,
 '[
   {"text": "19 square units", "feedback": "The base and height were added rather than multiplied."},
   {"text": "22 square units", "feedback": "The base was halved as well as the product. Only halve once."},
   {"text": "88 square units", "feedback": "That is base times height. The formula for a triangle takes half of that."},
   {"text": "44 square units", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'plotting-points-and-the-cartesian-plane', 4, 'Challenge',
 'The points D(1, 1), E(1, -2), F(-5, -2) and G(-5, 1) are joined in order to close a figure. What is it, and what is its area?', 3,
 '[
   {"text": "A rectangle with area 12 square units", "feedback": "The width is 6 units, not 4. Count from -5 across to 1."},
   {"text": "A square with area 18 square units", "feedback": "The area is right, but the two side lengths are not equal, so it is not a square."},
   {"text": "A rectangle with area 9 square units", "feedback": "The side lengths were added rather than multiplied."},
   {"text": "A rectangle with area 18 square units", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'plotting-points-and-the-cartesian-plane', 5, 'Advanced',
 'Three vertices of a rectangle are (-2, 5), (6, 5) and (6, -1). What are the coordinates of the fourth vertex?', 2,
 '[
   {"text": "(-2, 1)", "feedback": "The sign on the y was dropped. It has to match the bottom edge of the rectangle."},
   {"text": "(-1, -2)", "feedback": "The two coordinates are the right numbers but in the wrong order. The x comes first."},
   {"text": "(-2, -1)", "feedback": "Correct."},
   {"text": "(6, -2)", "feedback": "That reuses an x-value that is already taken. The missing corner sits below (-2, 5)."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'linear-vs-non-linear-and-first-differences', 1, 'Easy',
 'A table of values has x going up by 1 each row, and its first differences are 2, 2, 2, 2. What does this tell you?', 2,
 '[
   {"text": "It is linear, because all of the y-values are even numbers", "feedback": "Whether the values are even has nothing to do with it. Look at the differences between them."},
   {"text": "It is non-linear, because the first differences are not zero", "feedback": "First differences of zero would mean a horizontal line. Constant is what matters, not zero."},
   {"text": "It is linear, because the first differences are constant", "feedback": "Correct."},
   {"text": "It is non-linear, because the y-values keep changing from row to row", "feedback": "The y-values change in every relationship. What matters is whether they change by the same amount each time."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'linear-vs-non-linear-and-first-differences', 2, 'Easy',
 'A table of values has x going up by 1 each row, and its first differences are -5, -3, -1, 1, 3, 5. What does this tell you?', 0,
 '[
   {"text": "It is non-linear, because the first differences are not constant", "feedback": "Correct."},
   {"text": "It is linear, because the first differences go up by 2 each time", "feedback": "The differences themselves have to be equal, not merely follow a pattern."},
   {"text": "It is linear, because the x-values go up by 1", "feedback": "Evenly spaced x-values are what makes the test valid. They do not make the relationship linear."},
   {"text": "It is non-linear, because some first differences are negative", "feedback": "A line can have negative first differences all the way down. Being negative is not the problem."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'linear-vs-non-linear-and-first-differences', 3, 'Medium',
 'Rory starts with 0 dollars saved and earns 20 dollars per hour. Cal starts with 100 dollars saved and also earns 20 dollars per hour. Which statement is true?', 1,
 '[
   {"text": "Only the relationship for Rory is linear, because it starts at zero", "feedback": "Starting at zero is not what makes a relationship linear. A constant rate of change is."},
   {"text": "Both relationships are linear and have the same rate of change", "feedback": "Correct."},
   {"text": "Neither relationship is linear, because the amounts keep rising", "feedback": "Rising steadily is exactly what a linear relationship does. What matters is that it rises by the same amount each hour."},
   {"text": "Cal has a larger rate of change, because he starts with more money", "feedback": "The starting amount is the intercept, not the rate. Both earn the same per hour."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'linear-vs-non-linear-and-first-differences', 4, 'Challenge',
 'A table has x-values 0, 1, 2, 3 and y-values 5, 8, 13, 20. Which statement is correct?', 1,
 '[
   {"text": "It is linear, because the first differences increase by a constant 2", "feedback": "That is a pattern in the SECOND differences. The first differences themselves have to be equal."},
   {"text": "It is non-linear, because the first differences are not constant", "feedback": "Correct."},
   {"text": "It is linear, because the x-values increase by 1 in every row of the table", "feedback": "Evenly spaced x-values only make the test valid. They do not make the relationship linear."},
   {"text": "It is non-linear, because none of the y-values are equal to each other", "feedback": "A line never repeats a y-value unless it is horizontal. That is not the test."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'linear-vs-non-linear-and-first-differences', 5, 'Advanced',
 'A table has x-values 0, 2, 4, 6 and y-values 3, 11, 19, 27. What equation describes the relationship?', 2,
 '[
   {"text": "y = 4x + 8", "feedback": "The rate of change is right, but the starting value was taken from the differences instead of the table."},
   {"text": "y = 8x + 3", "feedback": "8 is the change in y between rows, but the x-values step by 2, so that has to be divided out."},
   {"text": "y = 4x + 3", "feedback": "Correct."},
   {"text": "y = 3x + 4", "feedback": "The rate of change and the starting value have swapped places."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'parallel-and-perpendicular-lines', 1, 'Easy',
 'A line has a slope of 3. What is the slope of any line parallel to it?', 3,
 '[
   {"text": "-1/3", "feedback": "That is the negative reciprocal, which gives a perpendicular line."},
   {"text": "-3", "feedback": "That would be a line sloping the other way. Parallel lines never meet, so they lean the same way."},
   {"text": "1/3", "feedback": "That is the reciprocal. Parallel lines keep the slope exactly as it is."},
   {"text": "3", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'parallel-and-perpendicular-lines', 2, 'Medium',
 'A line has the equation y = -(2/3)x + 20. What is the slope of a line perpendicular to it?', 3,
 '[
   {"text": "-3/2", "feedback": "The fraction was flipped but the sign was kept. A negative reciprocal changes both."},
   {"text": "2/3", "feedback": "The sign was changed but the fraction was not flipped."},
   {"text": "-2/3", "feedback": "That is the same slope, which would give a parallel line."},
   {"text": "3/2", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'parallel-and-perpendicular-lines', 3, 'Challenge',
 'What is the slope of a line perpendicular to 2x - 3y - 6 = 0?', 0,
 '[
   {"text": "-3/2", "feedback": "Correct."},
   {"text": "-2/3", "feedback": "The sign was changed but the fraction was not flipped."},
   {"text": "2/3", "feedback": "That is the slope of the given line itself, which would give a parallel line."},
   {"text": "3/2", "feedback": "The fraction was flipped but the sign was kept. A negative reciprocal changes both."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'parallel-and-perpendicular-lines', 4, 'Challenge',
 'One line has a slope of 4 and another has a slope of -1/4. What is the relationship between them?', 2,
 '[
   {"text": "Neither parallel nor perpendicular, because the slopes are not equal", "feedback": "Unequal slopes only rule out parallel. There is a second relationship worth testing."},
   {"text": "They are parallel, because their slopes are reciprocals of each other", "feedback": "Parallel lines have identical slopes, not reciprocal ones."},
   {"text": "They are perpendicular, because the product of their slopes is -1", "feedback": "Correct."},
   {"text": "They are perpendicular, because their y-intercepts are different numbers", "feedback": "The conclusion is right but the reason is not. Intercepts play no part in this test."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'parallel-and-perpendicular-lines', 5, 'Advanced',
 'Find the equation of the line perpendicular to y = (3/4)x + 1 that passes through (0, -5).', 1,
 '[
   {"text": "y = (4/3)x - 5", "feedback": "The fraction was flipped but the sign was kept. A negative reciprocal changes both."},
   {"text": "y = -(4/3)x - 5", "feedback": "Correct."},
   {"text": "y = (3/4)x - 5", "feedback": "That keeps the original slope, which gives a parallel line."},
   {"text": "y = -(3/4)x - 5", "feedback": "The sign was changed but the fraction was not flipped."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-1', 'parallel-and-perpendicular-lines', 6, 'Advanced',
 'Are the lines 2x + 4y = 8 and y = -(1/2)x + 3 parallel, perpendicular, or neither?', 3,
 '[
   {"text": "They are the same line", "feedback": "The slopes do match, but the two lines cross the y-axis at different heights."},
   {"text": "Perpendicular", "feedback": "That would need the slopes to multiply to -1. Rearrange the first equation and compare."},
   {"text": "Neither", "feedback": "Rearranging the first equation into slope-intercept form reveals a slope worth comparing."},
   {"text": "Parallel", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'solving-linear-systems', 1, 'Easy',
 'What does it mean to solve a linear system?', 3,
 '[
   {"text": "Find the y-intercept of each line", "feedback": "The intercepts help you draw the lines, but they are not the solution to the system."},
   {"text": "Find the ordered pair where each line in the system crosses the x-axis", "feedback": "Those are the x-intercepts. The solution is where the lines meet each other, not the axis."},
   {"text": "Add the two equations together", "feedback": "Adding equations is a step in one method, not the answer the method produces."},
   {"text": "Find the ordered pair that satisfies every equation in the system", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'solving-linear-systems', 2, 'Easy',
 'Where do the lines y = x + 4 and y = -x + 2 intersect?', 3,
 '[
   {"text": "(-1, -3)", "feedback": "The x-value is right. Substitute it back into either equation to get the matching y."},
   {"text": "(3, -1)", "feedback": "The two coordinates have been written in the wrong order. The x comes first."},
   {"text": "(1, 3)", "feedback": "The y-value is right, but check the sign of x. Setting x + 4 equal to -x + 2 gives a negative x."},
   {"text": "(-1, 3)", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'solving-linear-systems', 3, 'Medium',
 'Solve the system 2x + y = 5 and x - 2y = 10.', 2,
 '[
   {"text": "(-3, 4)", "feedback": "The two coordinates have been written in the wrong order. The x comes first."},
   {"text": "(4, 3)", "feedback": "The x-value is right, but check the sign of y. Substitute x back into 2x + y = 5."},
   {"text": "(4, -3)", "feedback": "Correct."},
   {"text": "(2, 1)", "feedback": "Those values fit 2x + y = 5 but not x - 2y = 10. Only one equation was checked."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'solving-linear-systems', 4, 'Medium',
 'Solve the system y = 3x - 1 and y = x + 5.', 1,
 '[
   {"text": "(-3, 2)", "feedback": "The sign was lost when the x terms were collected. 3x - x is positive."},
   {"text": "(3, 8)", "feedback": "Correct."},
   {"text": "(3, 4)", "feedback": "The x-value is right. Substitute it into either equation to get the matching y."},
   {"text": "(8, 3)", "feedback": "The two coordinates have been written in the wrong order. The x comes first."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'solving-linear-systems', 5, 'Challenge',
 'Solve the system y = x + 4 and 2x + y = 10.', 0,
 '[
   {"text": "(2, 6)", "feedback": "Correct."},
   {"text": "(-2, 2)", "feedback": "The sign was lost when the x terms were collected. 2x + x is positive."},
   {"text": "(6, 2)", "feedback": "The two coordinates have been written in the wrong order. The x comes first."},
   {"text": "(2, 4)", "feedback": "The x-value is right, but the 4 was used directly as y. Substitute x back into y = x + 4."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'solving-linear-systems', 6, 'Challenge',
 'Solve the system 2x - 3y = 12 and x + y = 1.', 3,
 '[
   {"text": "(-2, 3)", "feedback": "The two coordinates have been written in the wrong order. The x comes first."},
   {"text": "(3, 2)", "feedback": "The x-value is right, but check the sign of y. Substitute x back into x + y = 1."},
   {"text": "(-3, 4)", "feedback": "Those values fit x + y = 1 but not 2x - 3y = 12. Only one equation was checked."},
   {"text": "(3, -2)", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'solving-linear-systems', 7, 'Advanced',
 'Solve the system 5x + 2y = 4 and 3x - y = 9.', 1,
 '[
   {"text": "(1, -6)", "feedback": "Those values fit 3x - y = 9 but not 5x + 2y = 4. Only one equation was checked."},
   {"text": "(2, -3)", "feedback": "Correct."},
   {"text": "(-3, 2)", "feedback": "The two coordinates have been written in the wrong order. The x comes first."},
   {"text": "(2, 3)", "feedback": "The x-value is right, but check the sign of y. Substitute x into 3x - y = 9."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'solving-linear-systems', 8, 'Advanced',
 'Phone plan A costs 30 dollars a month plus 10 cents per minute. Plan B costs 20 dollars a month plus 15 cents per minute. After how many minutes do the two plans cost the same?', 3,
 '[
   {"text": "50 minutes", "feedback": "The two monthly fees were added together instead of compared. That total is not a number of minutes."},
   {"text": "400 minutes", "feedback": "The 10 dollar gap was divided by 2.5 cents. Check the difference between the two per-minute rates."},
   {"text": "100 minutes", "feedback": "The 10 dollar gap was divided by the wrong difference. The rates differ by 5 cents, not 10."},
   {"text": "200 minutes", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'how-many-solutions-a-system-has', 1, 'Easy',
 'Two lines in a system have different slopes. How many solutions does the system have?', 1,
 '[
   {"text": "None", "feedback": "Lines that lean differently must cross somewhere. They cannot stay apart forever."},
   {"text": "Exactly one", "feedback": "Correct."},
   {"text": "Infinitely many", "feedback": "That happens only when the two equations describe the same line, which needs matching slopes."},
   {"text": "It depends on the intercepts", "feedback": "Once the slopes differ, the intercepts cannot change the answer."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'how-many-solutions-a-system-has', 2, 'Easy',
 'Two lines in a system have the same slope AND the same y-intercept. How many solutions does the system have?', 0,
 '[
   {"text": "Infinitely many", "feedback": "Correct."},
   {"text": "Two", "feedback": "Two straight lines can never cross at exactly two places."},
   {"text": "Exactly one", "feedback": "That needs the lines to cross at a single place. These two lie exactly on top of each other."},
   {"text": "None", "feedback": "That happens when the slopes match but the intercepts differ. Here both match."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'how-many-solutions-a-system-has', 3, 'Medium',
 'How many solutions does the system y = 2x + 3 and y = 2x - 4 have?', 2,
 '[
   {"text": "None, because both slopes are positive", "feedback": "Two lines can both slope upward and still cross. It is the equal slopes that matter."},
   {"text": "Exactly one, because the intercepts differ", "feedback": "Different intercepts alone do not force a crossing. Check the slopes first."},
   {"text": "None, because the lines are parallel and distinct", "feedback": "Correct."},
   {"text": "Infinitely many, because the slopes match", "feedback": "Matching slopes are only half of it. The intercepts have to match too."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'how-many-solutions-a-system-has', 4, 'Medium',
 'How many solutions does the system 2x + 4y = 8 and y = -(1/2)x + 2 have?', 0,
 '[
   {"text": "Infinitely many", "feedback": "Correct."},
   {"text": "Two", "feedback": "Two straight lines can never cross at exactly two places."},
   {"text": "Exactly one", "feedback": "Rearrange the first equation into slope-intercept form and compare it with the second."},
   {"text": "None", "feedback": "That would need the intercepts to differ. Rearrange the first equation and check."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'how-many-solutions-a-system-has', 5, 'Challenge',
 'A system of two lines has no solution. What must be true of the lines?', 1,
 '[
   {"text": "One line is horizontal and the other is vertical", "feedback": "Those two always cross at right angles, giving exactly one solution."},
   {"text": "The slopes are equal and the y-intercepts are different", "feedback": "Correct."},
   {"text": "The slopes are equal and the y-intercepts are equal", "feedback": "That makes the two equations describe the same line, which gives infinitely many solutions."},
   {"text": "The slopes are different", "feedback": "Lines that lean differently always cross somewhere, giving exactly one solution."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'how-many-solutions-a-system-has', 6, 'Challenge',
 'For what value of k does the system 2x + 3y = 6 and 6x + ky = 18 have infinitely many solutions?', 1,
 '[
   {"text": "k = 6", "feedback": "That matched k to the x-coefficient rather than scaling the y-coefficient by the same factor."},
   {"text": "k = 9", "feedback": "Correct."},
   {"text": "k = 1", "feedback": "Substituting that value gives two lines with different slopes, so they would cross exactly once."},
   {"text": "k = 3", "feedback": "That copies the coefficient straight across. The whole second equation is a multiple of the first, so every coefficient scales."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'how-many-solutions-a-system-has', 7, 'Advanced',
 'The system y = mx + 2 and 4x - 2y = 6 has no solution. What is the value of m?', 0,
 '[
   {"text": "m = 2", "feedback": "Correct."},
   {"text": "m = -2", "feedback": "Rearranging 4x - 2y = 6 gives a positive slope, because a negative divided by a negative is positive."},
   {"text": "m = 1/2", "feedback": "The coefficients were divided the wrong way round when rearranging the second equation."},
   {"text": "m = -1/2", "feedback": "That is the negative reciprocal, which would make the lines perpendicular and give one solution."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'how-many-solutions-a-system-has', 8, 'Advanced',
 'What is the solution of the system x = 3 and y = -1?', 2,
 '[
   {"text": "(-1, 3)", "feedback": "The two coordinates have been written in the wrong order. The x comes first."},
   {"text": "No solution, because one slope is undefined", "feedback": "An undefined slope does not stop the lines meeting. A vertical and a horizontal line always cross."},
   {"text": "(3, -1)", "feedback": "Correct."},
   {"text": "Infinitely many solutions", "feedback": "That needs the two equations to describe the same line. These two are perpendicular."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'transformations-of-linear-functions', 1, 'Easy',
 'How does the graph of y = 2x + 3 compare with the graph of y = 2x?', 0,
 '[
   {"text": "Translated up 3 units", "feedback": "Correct."},
   {"text": "Translated right 3 units", "feedback": "A horizontal shift changes what is subtracted from x inside a bracket, not what is added at the end."},
   {"text": "Translated down 3 units", "feedback": "The constant is being added, which lifts the line rather than lowering it."},
   {"text": "Reflected in the x-axis", "feedback": "A reflection changes the sign of the slope. Here the slope is unchanged."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'transformations-of-linear-functions', 2, 'Easy',
 'How does the graph of y = 2(x - 3) compare with the graph of y = 2x?', 2,
 '[
   {"text": "Translated 3 units left", "feedback": "A subtraction inside the bracket moves the graph the opposite way to what it looks like."},
   {"text": "Translated 3 units down", "feedback": "A vertical shift changes what is added at the end, outside the bracket."},
   {"text": "Translated 3 units right", "feedback": "Correct."},
   {"text": "Translated 6 units right", "feedback": "The 3 was multiplied by the slope. The shift is read straight off the bracket."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'transformations-of-linear-functions', 3, 'Medium',
 'The graph of y = -(1/2)x is translated 3 units down. What is the equation of the new line?', 1,
 '[
   {"text": "y = -(1/2)x + 3", "feedback": "Adding lifts the line. Moving down needs a subtraction."},
   {"text": "y = -(1/2)x - 3", "feedback": "Correct."},
   {"text": "y = -(1/2)(x - 3)", "feedback": "Putting the 3 inside the bracket shifts the line sideways, not up or down."},
   {"text": "y = -(1/2)(x + 3)", "feedback": "Putting the 3 inside the bracket shifts the line sideways, not up or down."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'transformations-of-linear-functions', 4, 'Medium',
 'The graph of y = -(1/2)x is shifted 2 units left. What is the equation of the new line?', 2,
 '[
   {"text": "y = -(1/2)(x - 2)", "feedback": "A subtraction inside the bracket shifts the graph to the right, not the left."},
   {"text": "y = -(1/2)x + 2", "feedback": "A constant added at the end shifts the line up, not sideways."},
   {"text": "y = -(1/2)(x + 2)", "feedback": "Correct."},
   {"text": "y = -(1/2)x - 2", "feedback": "A constant added at the end shifts the line down, not sideways."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'transformations-of-linear-functions', 5, 'Challenge',
 'The graph of y = -(1/2)x is reflected in the x-axis. What is the equation of the new line?', 3,
 '[
   {"text": "y = -2x", "feedback": "The fraction was flipped and the sign was kept. A reflection does not turn the slope upside down."},
   {"text": "y = -(1/2)x + 1", "feedback": "That is a translation upward. A reflection changes the slope, not the intercept."},
   {"text": "y = 2x", "feedback": "Both the sign and the fraction were changed. A reflection only changes the sign of the slope."},
   {"text": "y = (1/2)x", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'transformations-of-linear-functions', 6, 'Challenge',
 'The graph of y = -(1/2)x is rotated 90 degrees about the origin. What is the equation of the new line?', 0,
 '[
   {"text": "y = 2x", "feedback": "Correct."},
   {"text": "y = -2x", "feedback": "The fraction was flipped but the sign was kept. A rotation uses the negative reciprocal."},
   {"text": "y = (1/2)x", "feedback": "That is a reflection in the x-axis, which changes only the sign."},
   {"text": "y = -(1/2)x", "feedback": "That is the line you started with. Something has to change."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'transformations-of-linear-functions', 7, 'Advanced',
 'The graph of y = 4x is translated 5 units right and 2 units down. What is the equation of the new line?', 3,
 '[
   {"text": "y = 4(x - 5) + 2", "feedback": "The horizontal shift is right, but adding at the end lifts the line rather than lowering it."},
   {"text": "y = 4x - 7", "feedback": "The 5 was subtracted at the end rather than inside the bracket, so it never got multiplied by the slope."},
   {"text": "y = 4(x + 5) - 2", "feedback": "A shift to the right subtracts inside the bracket. The plus sign moves it left."},
   {"text": "y = 4(x - 5) - 2", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'transformations-of-linear-functions', 8, 'Advanced',
 'Which single transformation turns the graph of y = 3x into the graph of y = -3x?', 1,
 '[
   {"text": "A 90 degree rotation about the origin", "feedback": "A rotation uses the negative reciprocal, which would give a slope of -1/3."},
   {"text": "A reflection in the x-axis", "feedback": "Correct."},
   {"text": "A translation down 6 units", "feedback": "A translation never changes the slope, and these two lines lean opposite ways."},
   {"text": "A translation left 3 units", "feedback": "Shifting a line through the origin sideways leaves it exactly where it was."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'graphing-inequalities-in-two-variables', 1, 'Easy',
 'When graphing y < 2x + 3, should the boundary line be solid or dashed?', 3,
 '[
   {"text": "Dashed, because the slope is positive", "feedback": "The slope has nothing to do with it. Look at the inequality symbol."},
   {"text": "Solid, because the inequality has two variables", "feedback": "Every inequality of this kind has two variables. Look at the symbol instead."},
   {"text": "Solid, because the line is the boundary", "feedback": "Being the boundary is not enough. What matters is whether points ON the line count as solutions."},
   {"text": "Dashed, because points on the line are not solutions", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'graphing-inequalities-in-two-variables', 2, 'Easy',
 'How do you decide which side of the boundary line to shade?', 1,
 '[
   {"text": "Shade whichever side of the boundary line contains the y-intercept", "feedback": "The y-intercept sits on the boundary line itself, so it cannot separate the two sides."},
   {"text": "Substitute a test point that is off the line and see if it makes the inequality true", "feedback": "Correct."},
   {"text": "Shade whichever side of the boundary line holds all the points with positive x-values", "feedback": "The axes play no part in this. The boundary line decides the two regions."},
   {"text": "Always shade the region above the boundary line", "feedback": "That is right only some of the time. It depends on the inequality."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'graphing-inequalities-in-two-variables', 3, 'Medium',
 'You are graphing y <= -(1/2)x + 2 and you test the point (0, 0). What happens next?', 2,
 '[
   {"text": "The statement is true, so shade the region away from the origin", "feedback": "When the test point works, it is inside the solution, so its own side gets shaded."},
   {"text": "The origin is on the line, so choose another test point", "feedback": "Setting x to zero on this line gives y equal to 2, so the origin is not on it."},
   {"text": "The statement is true, so shade the region containing the origin", "feedback": "Correct."},
   {"text": "The statement is false, so shade the region away from the origin", "feedback": "Substituting zero for x and zero for y gives 0 on the left and 2 on the right, and 0 is less than 2."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'graphing-inequalities-in-two-variables', 4, 'Medium',
 'You are graphing 2x + 3y < 6 and you test the point (5, 0). What happens next?', 0,
 '[
   {"text": "It is false, so shade the region that does not contain (5, 0)", "feedback": "Correct."},
   {"text": "It is false, so shade the region containing (5, 0)", "feedback": "A failed test point is outside the solution, so the OTHER side gets shaded."},
   {"text": "It is true, so shade the region that does not contain (5, 0)", "feedback": "A test point that works is inside the solution, so its own side would be shaded."},
   {"text": "It is true, so shade the region containing (5, 0)", "feedback": "Substituting gives 10 on the left, and 10 is not less than 6."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'graphing-inequalities-in-two-variables', 5, 'Challenge',
 'Which description matches the graph of y > 3x - 1?', 3,
 '[
   {"text": "A dashed line with the region not containing (0, 0) shaded", "feedback": "The line style is right. Test the origin: 0 is greater than -1, so it is a solution."},
   {"text": "A solid line with the region not containing (0, 0) shaded", "feedback": "Neither part holds. The symbol is strict, and the origin does satisfy the inequality."},
   {"text": "A solid line with the region containing (0, 0) shaded", "feedback": "The shading is right, but a strict inequality excludes the line itself."},
   {"text": "A dashed line with the region containing (0, 0) shaded", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'graphing-inequalities-in-two-variables', 6, 'Challenge',
 'Is the point (4, 2) a solution of 2x + 3y < 6?', 0,
 '[
   {"text": "No, because 14 is not less than 6", "feedback": "Correct."},
   {"text": "Yes, because both coordinates are positive", "feedback": "The signs of the coordinates do not decide it. Substitute them in and compare."},
   {"text": "Yes, because 14 is greater than 6", "feedback": "The arithmetic is right, but the inequality asks for a value LESS than 6."},
   {"text": "It cannot be decided without graphing", "feedback": "Substituting the point into the inequality settles it without any graph."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'graphing-inequalities-in-two-variables', 7, 'Advanced',
 'A graph shows a solid boundary line through (0, 2) with a slope of -1/2, and the region containing the origin is shaded. Which inequality does it represent?', 2,
 '[
   {"text": "y < -(1/2)x + 2", "feedback": "The shading is right, but a strict symbol would need a dashed line."},
   {"text": "y >= -(1/2)x + 2", "feedback": "The solid line is right, but this shades the region away from the origin."},
   {"text": "y <= -(1/2)x + 2", "feedback": "Correct."},
   {"text": "y > -(1/2)x + 2", "feedback": "Neither part matches. A strict symbol needs a dashed line, and this shades the wrong side."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'graphing-inequalities-in-two-variables', 8, 'Advanced',
 'You are graphing xy > 5 in the first quadrant and you test the point (2, 2). What happens next?', 2,
 '[
   {"text": "It is true, so shade the region containing (2, 2)", "feedback": "Substituting gives a product of 4, and 4 is not greater than 5."},
   {"text": "It is false, so shade the region containing (2, 2)", "feedback": "A failed test point is outside the solution, so the OTHER region gets shaded."},
   {"text": "It is false, so shade the region that does not contain (2, 2)", "feedback": "Correct."},
   {"text": "The point is on the curve itself, so choose a different test point", "feedback": "A point on this curve would have a product of exactly 5. This one gives 4."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'reciprocal-relationships', 1, 'Easy',
 'Which of these points lies on the graph of xy = 6?', 0,
 '[
   {"text": "(2, 3)", "feedback": "Correct."},
   {"text": "(2, 4)", "feedback": "Those coordinates add to 6 rather than multiplying to 6."},
   {"text": "(3, 3)", "feedback": "Those coordinates add to 6. On this curve they have to multiply to 6."},
   {"text": "(1, 5)", "feedback": "Those coordinates add to 6. On this curve they have to multiply to 6."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'reciprocal-relationships', 2, 'Easy',
 'In which quadrants does the graph of xy = 6 lie?', 2,
 '[
   {"text": "All four quadrants", "feedback": "Two of the quadrants always produce a negative product, so the curve cannot reach them."},
   {"text": "Quadrant 1 only", "feedback": "Two negatives also multiply to a positive, so there is a second branch."},
   {"text": "Quadrants 1 and 3", "feedback": "Correct."},
   {"text": "Quadrants 2 and 4", "feedback": "In those quadrants one coordinate is positive and the other negative, so the product would be negative."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'reciprocal-relationships', 3, 'Medium',
 'Where are the asymptotes of the graph of xy = 6?', 3,
 '[
   {"text": "There are none", "feedback": "Neither coordinate can ever be zero, because the product would then be zero rather than 6."},
   {"text": "x = 6 and y = 6", "feedback": "The curve crosses those values freely. The asymptotes are the lines it can never reach."},
   {"text": "y = x and y = -x", "feedback": "Those are diagonals. The two branches flatten against the axes instead."},
   {"text": "x = 0 and y = 0", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'reciprocal-relationships', 4, 'Medium',
 'Rewrite xy = 4 in the form y equals an expression in x.', 2,
 '[
   {"text": "y = x + 4", "feedback": "The x and y are multiplied together, not added."},
   {"text": "y = 4x", "feedback": "That multiplies where it should divide. The x is on the left multiplying y."},
   {"text": "y = 4/x", "feedback": "Correct."},
   {"text": "y = x/4", "feedback": "The fraction is upside down. Divide both sides by x, not by 4."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'reciprocal-relationships', 5, 'Challenge',
 'In which quadrants does the graph of xy = -8 lie?', 0,
 '[
   {"text": "Quadrants 2 and 4", "feedback": "Correct."},
   {"text": "Quadrants 3 and 4", "feedback": "Quadrant 3 has both coordinates negative, which multiplies to a positive."},
   {"text": "All four quadrants", "feedback": "Two of the quadrants always produce a positive product, so the curve cannot reach them."},
   {"text": "Quadrants 1 and 3", "feedback": "Those quadrants give a positive product. This constant is negative."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'reciprocal-relationships', 6, 'Challenge',
 'A reciprocal function passes through (1, 3), (3, 1) and (-1, -3). What is its equation?', 1,
 '[
   {"text": "y = 3x", "feedback": "That is a straight line through the origin, not a hyperbola. Test the point (3, 1) in it."},
   {"text": "xy = 3", "feedback": "Correct."},
   {"text": "xy = -3", "feedback": "The sign is wrong. All three points give a positive product."},
   {"text": "xy = 1", "feedback": "Check by substituting a point: 1 times 3 does not give 1."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'reciprocal-relationships', 7, 'Advanced',
 'The point (-2, k) lies on the graph of xy = -8. What is the value of k?', 3,
 '[
   {"text": "k = -4", "feedback": "A negative times a negative gives a positive product. The constant here is negative, so the two coordinates must have opposite signs."},
   {"text": "k = 16", "feedback": "The two numbers were multiplied. Divide the constant by the known coordinate instead."},
   {"text": "k = -6", "feedback": "The -2 was subtracted from the -8. On this curve the coordinates multiply."},
   {"text": "k = 4", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'linear-relations-part-2', 'reciprocal-relationships', 8, 'Advanced',
 'On the graph of xy = 6, what happens to y as x grows very large?', 1,
 '[
   {"text": "It approaches 6", "feedback": "The 6 is the product of the two coordinates, not a value y settles on."},
   {"text": "It approaches zero without ever reaching it", "feedback": "Correct."},
   {"text": "It becomes negative", "feedback": "On this branch both coordinates stay positive, because their product has to be positive."},
   {"text": "It grows without limit, getting larger and larger", "feedback": "If both coordinates grew, their product would grow too. The product has to stay at 6."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'pythagorean-theorem', 1, 'Easy',
 'A right triangle has legs of 3 units and 7 units. What is the hypotenuse, to the nearest tenth?', 3,
 '[
   {"text": "58.0 units", "feedback": "That is the sum of the squares. There is still a square root to take."},
   {"text": "6.3 units", "feedback": "The squares were subtracted rather than added. Subtraction is for finding a leg."},
   {"text": "10.0 units", "feedback": "The two legs were added. It is their SQUARES that add."},
   {"text": "7.6 units", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'pythagorean-theorem', 2, 'Easy',
 'In the Pythagorean theorem a^2 + b^2 = c^2, what does c represent?', 3,
 '[
   {"text": "Either of the two shorter sides", "feedback": "Those are a and b, the legs that form the right angle."},
   {"text": "The side that forms the right angle with a", "feedback": "That describes the other leg. The right angle is formed by a and b."},
   {"text": "The perimeter of the triangle", "feedback": "The theorem relates side lengths to each other, not to the distance around."},
   {"text": "The hypotenuse, the longest side, opposite the right angle", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'pythagorean-theorem', 3, 'Medium',
 'A right triangle has a hypotenuse of 11 units and one leg of 3.9 units. What is the other leg, to the nearest tenth?', 3,
 '[
   {"text": "105.8 units", "feedback": "That is the difference of the squares. There is still a square root to take."},
   {"text": "11.7 units", "feedback": "The squares were added. When you know the hypotenuse, you subtract."},
   {"text": "7.1 units", "feedback": "The two side lengths were subtracted directly. It is their SQUARES that subtract."},
   {"text": "10.3 units", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'pythagorean-theorem', 4, 'Medium',
 'A television screen measures 30 inches by 22.5 inches. What is the length of its diagonal?', 2,
 '[
   {"text": "1406.25 inches", "feedback": "That is the sum of the squares. There is still a square root to take."},
   {"text": "52.5 inches", "feedback": "The two sides were added. It is their squares that add, before a square root is taken."},
   {"text": "37.5 inches", "feedback": "Correct."},
   {"text": "26.25 inches", "feedback": "That is the average of the two sides. The diagonal is longer than either of them."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'pythagorean-theorem', 5, 'Challenge',
 'An isosceles triangle has two equal sides of 7 units and a base of 10 units. What is its area, to the nearest hundredth?', 0,
 '[
   {"text": "24.49 square units", "feedback": "Correct."},
   {"text": "48.99 square units", "feedback": "The height is right, but the halving was left out."},
   {"text": "12.50 square units", "feedback": "Half the base was used as the height as well as the base."},
   {"text": "35.00 square units", "feedback": "The equal side was used as the height. The height is the perpendicular drop to the base, which is shorter."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'pythagorean-theorem', 6, 'Challenge',
 'Zeke drives 64 km east and then 135 km north. A new expressway runs in a straight line between his start and finish. How much travel distance does the expressway save, to the nearest tenth?', 0,
 '[
   {"text": "49.6 km", "feedback": "Correct."},
   {"text": "71.0 km", "feedback": "The two distances were subtracted from each other. Find the straight-line route first."},
   {"text": "149.4 km", "feedback": "That is the length of the expressway itself. The saving is what is left of the old route."},
   {"text": "199.0 km", "feedback": "That is the old route. The expressway still has to be subtracted from it."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'pythagorean-theorem', 7, 'Advanced',
 'A 5 m ladder leans against a wall with its foot 1.4 m from the base of the wall. How far up the wall does it reach, to the nearest tenth?', 3,
 '[
   {"text": "6.4 m", "feedback": "The two lengths were added. The wall height is shorter than the ladder."},
   {"text": "3.6 m", "feedback": "The two lengths were subtracted directly. It is their SQUARES that subtract."},
   {"text": "5.2 m", "feedback": "The squares were added. The ladder is the hypotenuse here, so you subtract."},
   {"text": "4.8 m", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'geometry', 'pythagorean-theorem', 8, 'Advanced',
 'Is a triangle with sides of 9, 40 and 41 units right-angled?', 2,
 '[
   {"text": "No, because the three numbers are not consecutive", "feedback": "The numbers do not have to follow any pattern. Test them in the theorem."},
   {"text": "No, because 9 plus 40 does not equal 41", "feedback": "The theorem adds the SQUARES of the two shorter sides, not the sides themselves."},
   {"text": "Yes, because 9 squared plus 40 squared equals 41 squared", "feedback": "Correct."},
   {"text": "Yes, because all three sides are different", "feedback": "That describes a scalene triangle, which need not have a right angle."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'averages-from-a-frequency-table', 1, 'Easy',
 'A frequency table shows hourly wages: 17 dollars for 20 employees, 19 dollars for 8, 20 dollars for 5, 25 dollars for 7 and 30 dollars for 3. What is the modal wage?', 2,
 '[
   {"text": "20 dollars", "feedback": "That wage is paid to only five employees. Look for the largest frequency, not the roundest wage."},
   {"text": "30 dollars", "feedback": "That is the highest wage. The mode is the one paid most often."},
   {"text": "17 dollars", "feedback": "Correct."},
   {"text": "19.93 dollars", "feedback": "That is the mean wage. The mode has to be a wage that actually appears in the table."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'averages-from-a-frequency-table', 2, 'Easy',
 'In that same wage table (frequencies 20, 8, 5, 7 and 3), how many employees are there altogether?', 1,
 '[
   {"text": "5", "feedback": "That is the number of different wage levels, not the number of people."},
   {"text": "43", "feedback": "Correct."},
   {"text": "111", "feedback": "The wages were added instead of the frequencies."},
   {"text": "20", "feedback": "That is the largest single frequency. All five have to be added."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'averages-from-a-frequency-table', 3, 'Medium',
 'From the wage table (17 dollars for 20 employees, 19 for 8, 20 for 5, 25 for 7, 30 for 3), what is the mean wage, to two decimal places?', 2,
 '[
   {"text": "22.20 dollars", "feedback": "The five different wages were averaged. Each one has to be weighted by how many people earn it."},
   {"text": "857.00 dollars", "feedback": "That is the total payroll per hour. It still has to be divided by the number of employees."},
   {"text": "19.93 dollars", "feedback": "Correct."},
   {"text": "18.08 dollars", "feedback": "Only the largest group was weighted; the other four wages were each counted once."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'averages-from-a-frequency-table', 4, 'Medium',
 'From that same wage table, what is the median wage?', 2,
 '[
   {"text": "22 dollars", "feedback": "That is the POSITION of the middle employee, not the wage that employee earns."},
   {"text": "17 dollars", "feedback": "That is the modal wage. Twenty employees earn it, but the middle position falls just past them."},
   {"text": "19 dollars", "feedback": "Correct."},
   {"text": "20 dollars", "feedback": "The middle position falls inside a smaller group than that. Build up the running totals."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'averages-from-a-frequency-table', 5, 'Challenge',
 'In the wage table (17 dollars for 20 employees, 19 for 8, 20 for 5, 25 for 7, 30 for 3), one more employee is hired at 30 dollars an hour, taking that group from 3 people to 4. What happens to the modal wage?', 0,
 '[
   {"text": "It stays at 17 dollars", "feedback": "Correct."},
   {"text": "There are now two modes", "feedback": "Two modes would need two groups tied for the largest frequency. These are not close."},
   {"text": "It rises slightly", "feedback": "The mode always equals a value from the table. It cannot drift between them."},
   {"text": "It becomes 30 dollars", "feedback": "Four people is still far short of the largest group in the table."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'averages-from-a-frequency-table', 6, 'Challenge',
 'Every employee in the wage table is given a raise of 2 dollars an hour. What happens to the mean wage?', 3,
 '[
   {"text": "It rises by 2 divided by the number of employees", "feedback": "That would be right if only one person got the raise. Everybody got it here."},
   {"text": "It stays the same", "feedback": "The total payroll grows, and the number of employees does not, so the average has to move."},
   {"text": "It doubles", "feedback": "The raise is added to each wage, not multiplied into it."},
   {"text": "It rises by exactly 2 dollars", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'averages-from-a-frequency-table', 7, 'Advanced',
 'In a frequency table of test marks, 6 students scored 5, 4 students scored 7, and n students scored 10. The mean mark is exactly 7. What is n?', 1,
 '[
   {"text": "n = 6", "feedback": "Substitute it back: the total comes to 118 across 16 students, which is above the target mean."},
   {"text": "n = 4", "feedback": "Correct."},
   {"text": "n = 2", "feedback": "Substitute it back: the total comes to 78 across 12 students, which falls short of the target mean."},
   {"text": "n = 10", "feedback": "That copies the mark rather than solving for the frequency."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'averages-from-a-frequency-table', 8, 'Advanced',
 'Why does the mean of a frequency table use the sum of each value times its frequency, divided by the total frequency?', 3,
 '[
   {"text": "Because the mode has to be found first", "feedback": "The three measures are found independently of one another."},
   {"text": "Because the values are not always whole numbers", "feedback": "Whole numbers or not, the issue is how many people sit behind each value."},
   {"text": "Because a frequency table is already sorted", "feedback": "Sorting matters for the median. It has nothing to do with how the mean is weighted."},
   {"text": "Because each value stands for several data points, not just one", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'boxplots-and-the-five-number-summary', 1, 'Easy',
 'Which five values make up the summary a boxplot is drawn from?', 2,
 '[
   {"text": "Q1, Q2, Q3, range and interquartile range", "feedback": "The quartiles are right, but a boxplot also needs the two extreme values."},
   {"text": "Mean, median, mode, range and interquartile range", "feedback": "Those are summary statistics, but a boxplot is built from positions in the ordered data."},
   {"text": "Minimum, Q1, median, Q3 and maximum", "feedback": "Correct."},
   {"text": "Minimum, mean, median, mode and maximum", "feedback": "The mean and mode never appear on a boxplot. The quartiles do."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'boxplots-and-the-five-number-summary', 2, 'Easy',
 'On a boxplot, what does the rectangular box span?', 1,
 '[
   {"text": "From the median to the maximum", "feedback": "That is the upper half of the data. The box covers the middle half."},
   {"text": "From Q1 to Q3", "feedback": "Correct."},
   {"text": "From the mean to the median", "feedback": "The mean is never plotted on a boxplot."},
   {"text": "From the minimum to the maximum", "feedback": "That is the whole plot including the whiskers. The box is narrower."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'boxplots-and-the-five-number-summary', 3, 'Medium',
 'For the ordered data 1, 2, 2, 3, 3, 3, 4, 4, 5, 5, 6, 7, 8, 9, 10, 10, 12, 15, 26, what is the median?', 0,
 '[
   {"text": "5", "feedback": "Correct."},
   {"text": "6", "feedback": "That is one place past the middle. With nineteen values the middle sits at the tenth."},
   {"text": "26", "feedback": "That is the largest value, which is the maximum rather than the middle."},
   {"text": "3", "feedback": "That is the most common value, which is the mode rather than the middle one."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'boxplots-and-the-five-number-summary', 4, 'Medium',
 'For that same ordered data set of nineteen values, what is Q3?', 0,
 '[
   {"text": "10", "feedback": "Correct."},
   {"text": "26", "feedback": "That is the maximum. Q3 is the middle of the upper half, not its top."},
   {"text": "12", "feedback": "That is one place past Q3. The upper half here has nine values, so its middle is the fifth of them."},
   {"text": "9", "feedback": "That is one place before Q3. Count the upper half again, starting just above the overall median."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'boxplots-and-the-five-number-summary', 5, 'Challenge',
 'A boxplot has the five-number summary minimum 1, Q1 3, median 5, Q3 10, maximum 26. What is the interquartile range?', 3,
 '[
   {"text": "5", "feedback": "That is the median. The interquartile range is a distance between two quartiles."},
   {"text": "13", "feedback": "The two quartiles were added. The interquartile range subtracts them."},
   {"text": "25", "feedback": "That is the range, which uses the two extreme values rather than the quartiles."},
   {"text": "7", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'boxplots-and-the-five-number-summary', 6, 'Challenge',
 'For that boxplot (minimum 1, Q1 3, median 5, Q3 10, maximum 26), which whisker is longer and what does it tell you?', 1,
 '[
   {"text": "Whisker length says nothing about the data", "feedback": "A whisker shows how far the outer quarter of the data reaches, which is exactly what spread means."},
   {"text": "The upper whisker, so the data stretch out at the high end", "feedback": "Correct."},
   {"text": "The lower whisker, so the data trail off at the low end", "feedback": "The lower whisker runs only from 1 to 3. Compare that with the gap above the box."},
   {"text": "They are the same length", "feedback": "Measure each one: the gap below the box and the gap above it are very different."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'boxplots-and-the-five-number-summary', 7, 'Advanced',
 'Parallel boxplots compare resting pulse rates. Females: Q1 68, median 74, Q3 80. Males: Q1 62, median 70, Q3 76. What can you conclude?', 2,
 '[
   {"text": "Nothing can be compared from boxplots", "feedback": "Comparing centre and spread across groups is exactly what parallel boxplots are for."},
   {"text": "The male rates are centred higher", "feedback": "Compare the two medians. The one for males sits four beats lower."},
   {"text": "The female rates are centred higher, and the two middle spreads are similar", "feedback": "Correct."},
   {"text": "The female rates are much more spread out", "feedback": "Work out each middle spread by subtracting the quartiles. They come out within two beats of each other."}
 ]'::jsonb,
 null),
('MTH1W', 'data', 'boxplots-and-the-five-number-summary', 8, 'Advanced',
 'On a boxplot, what fraction of the data lies below Q1?', 2,
 '[
   {"text": "It depends on how many values are in the set", "feedback": "The quartiles are defined by fractions of the data, so this holds for every set no matter how large."},
   {"text": "One half", "feedback": "That fraction lies below the MEDIAN. Q1 sits lower than that."},
   {"text": "One quarter", "feedback": "Correct."},
   {"text": "Three quarters", "feedback": "That fraction lies below Q3, at the far end of the box."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'compound-interest', 1, 'Easy',
 'Which formula gives the amount in an account when interest is compounded once a year?', 0,
 '[
   {"text": "A = P(1 + r)^t", "feedback": "Correct."},
   {"text": "A = P(1 + rt)", "feedback": "That is the simple interest version, where the interest never earns interest of its own."},
   {"text": "A = P + rt", "feedback": "That adds a fixed dollar amount each year, which is linear growth rather than compounding."},
   {"text": "A = P(1 - r)^t", "feedback": "The minus sign shrinks the balance. That version models depreciation."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'compound-interest', 2, 'Easy',
 'What is 1000 dollars worth after 3 years at 5 percent compounded annually?', 0,
 '[
   {"text": "1157.63 dollars", "feedback": "Correct."},
   {"text": "1102.50 dollars", "feedback": "That is the balance after only two years."},
   {"text": "3375.00 dollars", "feedback": "The rate was applied as 50 percent rather than 5 percent."},
   {"text": "1150.00 dollars", "feedback": "That is simple interest. Under compounding, each year the interest earns interest too."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'compound-interest', 3, 'Medium',
 'What is 1000 dollars worth after 1 year at 6 percent compounded monthly?', 2,
 '[
   {"text": "1060.90 dollars", "feedback": "That is the semi-annual result, where interest is added only twice."},
   {"text": "1061.36 dollars", "feedback": "That is the quarterly result, where interest is added four times."},
   {"text": "1061.68 dollars", "feedback": "Correct."},
   {"text": "1060.00 dollars", "feedback": "That is simple interest for the year. Compounding monthly adds a little more."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'compound-interest', 4, 'Medium',
 'At the same annual rate, which compounding frequency leaves you with the most money?', 2,
 '[
   {"text": "Quarterly", "feedback": "That beats annual compounding, but there is a more frequent option on the list."},
   {"text": "They all give exactly the same amount", "feedback": "More frequent compounding means each period starts with a slightly larger balance."},
   {"text": "Daily", "feedback": "Correct."},
   {"text": "Annually", "feedback": "That adds interest only once a year, so the interest has the least chance to earn interest of its own."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'compound-interest', 5, 'Challenge',
 'Bank A offers 4.8 percent compounded quarterly and Bank B offers 4.6 percent compounded monthly. For 5000 dollars over 3 years, which is better and by roughly how much?', 1,
 '[
   {"text": "Bank B, by about 31 dollars", "feedback": "The more frequent compounding does not make up for the lower rate here."},
   {"text": "Bank A, by about 31 dollars", "feedback": "Correct."},
   {"text": "Bank A, by about 200 dollars", "feedback": "The direction is right, but the gap between the two is far smaller than that."},
   {"text": "They come out the same", "feedback": "Work each one out separately. The two totals differ by a modest amount."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'compound-interest', 6, 'Challenge',
 'You need 3000 dollars in 3 years. An account pays 3.2 percent compounded monthly. How much do you need to invest now?', 3,
 '[
   {"text": "2712.00 dollars", "feedback": "That subtracts three years of simple interest instead of dividing by the growth factor."},
   {"text": "2905.64 dollars", "feedback": "Only one year of growth was divided out. The money has three years to grow."},
   {"text": "3300.00 dollars", "feedback": "That grows the target instead of working backwards from it. You need LESS than 3000 today."},
   {"text": "2725.74 dollars", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'compound-interest', 7, 'Advanced',
 'What is 2000 dollars worth after 4 years at 5 percent compounded quarterly?', 0,
 '[
   {"text": "2439.78 dollars", "feedback": "Correct."},
   {"text": "2400.00 dollars", "feedback": "That is simple interest. Compounding adds a little more."},
   {"text": "2431.01 dollars", "feedback": "That compounds only once a year. Quarterly means four times."},
   {"text": "2441.79 dollars", "feedback": "That compounds monthly, which is more often than the question asks."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'compound-interest', 8, 'Advanced',
 'If you double how often interest is compounded per year, does the interest you earn double?', 0,
 '[
   {"text": "No, the gain is much smaller than that", "feedback": "Correct."},
   {"text": "It depends entirely on the size of the principal", "feedback": "The principal scales everything equally, so it does not change the comparison."},
   {"text": "Yes, exactly", "feedback": "The annual rate is split across more periods, so each period pays proportionally less."},
   {"text": "No, the interest is halved instead", "feedback": "More frequent compounding never lowers the total. It raises it slightly."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'appreciation-and-depreciation', 1, 'Easy',
 'Which of these is an example of depreciation?', 1,
 '[
   {"text": "Gold rising in value", "feedback": "Rising value is appreciation. Depreciation goes the other way."},
   {"text": "A new car losing value every year it is driven", "feedback": "Correct."},
   {"text": "A savings account earning interest", "feedback": "A growing balance is a kind of appreciation."},
   {"text": "A house rising in value over ten years", "feedback": "Rising value is appreciation. Depreciation goes the other way."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'appreciation-and-depreciation', 2, 'Easy',
 'A rookie card is worth 100 dollars now and is expected to gain 20 dollars in value every year. Which equation models its value after t years?', 0,
 '[
   {"text": "A = 100 + 20t", "feedback": "Correct."},
   {"text": "A = 100(1.20)^t", "feedback": "That grows by 20 PERCENT each year. Here the gain is a fixed 20 dollars."},
   {"text": "A = 100 - 20t", "feedback": "The minus sign makes the value fall. This card is gaining value."},
   {"text": "A = 20 + 100t", "feedback": "The starting value and the yearly gain have swapped places."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'appreciation-and-depreciation', 3, 'Medium',
 'A car bought for 30000 dollars depreciates by 2000 dollars every year. How long until it is worth 10000 dollars?', 0,
 '[
   {"text": "10 years", "feedback": "Correct."},
   {"text": "20 years", "feedback": "That is the size of the drop in dollars, not the number of years it takes."},
   {"text": "5 years", "feedback": "After that long the car would still be worth twice the target value."},
   {"text": "15 years", "feedback": "That divides the purchase price by the yearly loss. Only the DROP of 20000 has to be covered."}
 ]'::jsonb,
 null);