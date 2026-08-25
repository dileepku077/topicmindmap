-- MHF4U part b (continued -- no delete here, part a already cleared this course's rows)

insert into public.questions
  (course_code, unit_code, subtopic_code, sort_order, difficulty,
   prompt, correct_index, options, misconception_tag)
values
('MHF4U', 'rational-functions', 'solving-rational-equations', 2, 'Medium',
 'Solve   1 / (x − 1) = 3.', 2,
 '[
   {"text": "x = 4", "feedback": "The 3 has to be distributed across both terms in the bracket before rearranging."},
   {"text": "x = 1/3", "feedback": "This solves 3x = 1 and drops the −1 that came from inside the bracket."},
   {"text": "x = 4/3", "feedback": "Correct. Multiplying both sides by x − 1 gives 1 = 3x − 3, so 3x = 4."},
   {"text": "x = 2/3", "feedback": "Check the sign when moving the −3 across the equals sign."}
 ]'::jsonb,
 'solve-rational-distribute'),
('MHF4U', 'rational-functions', 'solving-rational-equations', 3, 'Medium',
 'Solve 6 / (x - 2) = x - 1.', 3,
 '[
   {"text": "x = 4 only", "feedback": "The quadratic was only half solved. Both brackets give a valid value here, and neither is a restriction."},
   {"text": "x = -1 only", "feedback": "The quadratic was only half solved. Both brackets give a valid value here, and neither is a restriction."},
   {"text": "x = 1 or x = 2", "feedback": "Each side was set to zero separately. Multiply across by the denominator and collect into one quadratic instead."},
   {"text": "x = 4 or x = -1", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'solving-rational-equations', 4, 'Challenge',
 'Solve 1/x + 1/(x + 3) = 1/2.', 3,
 '[
   {"text": "x = 3 and no others", "feedback": "Only one bracket was used. Neither root here is a restriction, so both survive."},
   {"text": "x = -3 or x = 2", "feedback": "Both signs were flipped when reading the roots out of the factored quadratic."},
   {"text": "x = 1 or x = -4", "feedback": "The two fractions were added by putting the sum of the numerators over the product of the denominators."},
   {"text": "x = 3 or x = -2", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'solving-rational-equations', 5, 'Advanced',
 'Solve 1/(x - 2) + 1/(x + 2) = 4/(x^2 - 4).', 2,
 '[
   {"text": "x = 2 or x = -2", "feedback": "Both of these make a denominator zero. Neither can be substituted back into the original equation."},
   {"text": "x = 4", "feedback": "The 4 from the right-hand side was carried through as if it were the answer. Clear the denominators and collect first."},
   {"text": "There is no solution", "feedback": "Correct."},
   {"text": "x = 2", "feedback": "The algebra is right but the restrictions were never checked. This value makes a denominator zero, so it has to be thrown out."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'solving-rational-equations', 6, 'Advanced',
 'Solve x/(x - 3) + 3/(x + 3) = 18/(x^2 - 9).', 2,
 '[
   {"text": "x = 3", "feedback": "The root that had to be rejected was kept and the other one was dropped. Check each root against the restrictions."},
   {"text": "x = 9", "feedback": "The sign was flipped when reading the root out of the factored form. A bracket of x plus 9 is zero at negative 9."},
   {"text": "x = -9", "feedback": "Correct."},
   {"text": "x = -9 or x = 3", "feedback": "Both roots of the quadratic were kept. One of them makes a denominator zero, so it has to be rejected."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'solving-rational-inequalities', 1, 'Easy',
 'At which x-values can the expression (x + 5) / (x - 1) change sign?', 0,
 '[
   {"text": "x = -5 and x = 1", "feedback": "Correct."},
   {"text": "x = -5 only", "feedback": "The zero of the top was found, but the expression also flips sign as it jumps across the value that makes the bottom zero."},
   {"text": "x = 1 only", "feedback": "The bottom was found, but the expression also changes sign where the top passes through zero."},
   {"text": "x = 5 and x = -1", "feedback": "Both signs have been flipped. Set each part equal to zero and solve rather than reading the numbers off."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'solving-rational-inequalities', 2, 'Medium',
 'Solve (x - 3) / (x + 1) < 0.', 0,
 '[
   {"text": "-1 < x < 3", "feedback": "Correct."},
   {"text": "x < -1 or x > 3", "feedback": "The wrong side of the sign table was chosen. Outside the two critical values the top and bottom share a sign, so the quotient is positive."},
   {"text": "-3 < x < 1", "feedback": "Both critical values had their signs flipped. Set each bracket equal to zero and solve rather than reading the numbers off."},
   {"text": "x < 3", "feedback": "The denominator was ignored. Below negative one the quotient is positive, so that whole stretch does not belong."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'solving-rational-inequalities', 3, 'Hard',
 'Solve the inequality   (x − 2) / (x + 1) ≥ 0.', 3,
 '[
   {"text": "−1 < x < 2", "feedback": "Between the critical values the numerator and denominator have opposite signs, so the quotient is negative there."},
   {"text": "x ≤ −1 or x ≥ 2", "feedback": "Very close, but one of these endpoints makes the denominator zero, and that value cannot be included."},
   {"text": "x ≥ 2 only", "feedback": "This misses the region far to the left, where the numerator and denominator are both negative."},
   {"text": "x < −1 or x ≥ 2", "feedback": "Correct. Outside the critical values the top and bottom share a sign, and only the zero of the numerator may be included."}
 ]'::jsonb,
 'rational-inequality-endpoints'),
('MHF4U', 'rational-functions', 'solving-rational-inequalities', 4, 'Challenge',
 'Solve (x + 4) / (x - 1) >= 0.', 0,
 '[
   {"text": "x <= -4 or x > 1", "feedback": "Correct."},
   {"text": "x <= -4 or x >= 1", "feedback": "The endpoint at the vertical asymptote was included. The expression is undefined there, so it can never be part of a solution set."},
   {"text": "-4 <= x < 1", "feedback": "The wrong side of the sign table was chosen. Between the two critical values the top and bottom have opposite signs."},
   {"text": "x < -4 or x > 1", "feedback": "The endpoint at the zero of the numerator was excluded. The sign here is greater than OR EQUAL to zero, and the fraction does reach zero there."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'solving-rational-inequalities', 5, 'Advanced',
 'Solve x - 2 < 8/x.', 0,
 '[
   {"text": "x < -2 or 0 < x < 4", "feedback": "Correct."},
   {"text": "-2 < x < 4", "feedback": "Both sides were multiplied by x as if x were always positive. When x is negative the inequality sign turns round, which splits the answer."},
   {"text": "x < -2 or x > 4", "feedback": "The critical value at zero was missed. The expression is undefined there and changes sign across it."},
   {"text": "0 < x < 4", "feedback": "Only half the sign table was read. There is a second stretch where the quotient is negative, to the left of the smaller critical value."}
 ]'::jsonb,
 null),
('MHF4U', 'rational-functions', 'solving-rational-inequalities', 6, 'Advanced',
 'Solve (x^2 + 6x + 5) / (2x^2 - 7x + 3) < 0.', 1,
 '[
   {"text": "-1 < x < 1/2", "feedback": "Only the middle strip was tested. Factor both quadratics to get all four critical values, then check every strip they create."},
   {"text": "-5 < x < -1 or 1/2 < x < 3", "feedback": "Correct."},
   {"text": "-5 <= x <= -1 or 1/2 <= x <= 3", "feedback": "The endpoints were included. The inequality is strict, and two of those four values make the bottom zero, so they could not be included even if it were not."},
   {"text": "x < -5 or -1 < x < 1/2 or x > 3", "feedback": "The wrong intervals were taken. Test one point inside each strip and keep only the strips where the quotient comes out negative."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'radian-measure-and-arc-length', 1, 'Easy',
 'Convert 60° to radians.', 2,
 '[
   {"text": "π/6", "feedback": "That is 30°, which is half the angle given."},
   {"text": "π/2", "feedback": "That is 90°, a right angle, which is larger than the angle given."},
   {"text": "π/3", "feedback": "Correct. Multiply by π/180: 60 × π/180 = π/3."},
   {"text": "3π", "feedback": "The conversion factor π/180 has been used upside down, which gives a very large angle."}
 ]'::jsonb,
 'radian-degree-conversion'),
('MHF4U', 'trig-in-radians', 'radian-measure-and-arc-length', 2, 'Easy',
 'Convert   π/4   radians to degrees.', 3,
 '[
   {"text": "90°", "feedback": "That is π/2. Halving that gives the angle asked for here."},
   {"text": "180°", "feedback": "That is π on its own, without the division by 4."},
   {"text": "60°", "feedback": "That comes from π/3. Check the denominator carefully."},
   {"text": "45°", "feedback": "Correct. Multiply by 180/π: (π/4)(180/π) = 45."}
 ]'::jsonb,
 'radian-degree-conversion'),
('MHF4U', 'trig-in-radians', 'radian-measure-and-arc-length', 3, 'Easy',
 'How many radians are there in 180°?', 3,
 '[
   {"text": "2π", "feedback": "2π is a FULL turn, which is 360 degrees. Half a turn is half of that."},
   {"text": "π/2", "feedback": "π/2 is a quarter turn, which is 90 degrees."},
   {"text": "360", "feedback": "360 is a count of degrees, not radians. The two systems measure the same turn with different units."},
   {"text": "π", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'radian-measure-and-arc-length', 4, 'Easy',
 'Convert 75° to an exact radian measure.', 0,
 '[
   {"text": "5π/12", "feedback": "Correct."},
   {"text": "12π/5", "feedback": "The fraction is upside down. Multiply by π/180 and cancel."},
   {"text": "75π", "feedback": "The 180 in the denominator was dropped. Multiplying by π alone leaves the answer 180 times too big."},
   {"text": "5π/6", "feedback": "That is the radian measure of 150 degrees. Check the cancelling: 75 and 180 share a factor of 15."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'radian-measure-and-arc-length', 5, 'Medium',
 'Convert 4π/9 radians to an exact degree measure.', 3,
 '[
   {"text": "20°", "feedback": "The 4 in the numerator was dropped. Multiply the whole fraction by 180/π."},
   {"text": "160°", "feedback": "That multiplies by 360/π, using a full turn where the conversion takes a half turn."},
   {"text": "45°", "feedback": "That divides 180 by 4 and ignores the 9. Multiply the fraction as a whole."},
   {"text": "80°", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'radian-measure-and-arc-length', 6, 'Medium',
 'Convert 1.24 radians to degrees, to one decimal place.', 1,
 '[
   {"text": "0.4°", "feedback": "That divides by π and stops. The 180 still has to be multiplied in."},
   {"text": "71.0°", "feedback": "Correct."},
   {"text": "0.0216°", "feedback": "That multiplies by π/180, which is the conversion the other way. Going TO degrees multiplies by 180/π."},
   {"text": "142.1°", "feedback": "That doubles the answer, as though the conversion factor were 360/π."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'radian-measure-and-arc-length', 7, 'Challenge',
 'Convert 6.91 radians to degrees, to one decimal place.', 1,
 '[
   {"text": "2.2°", "feedback": "That divides by π and stops. The 180 still has to be multiplied in."},
   {"text": "395.9°", "feedback": "Correct."},
   {"text": "35.9°", "feedback": "That takes the answer down by a full turn. 6.91 radians is more than 2π, so its degree measure is above 360."},
   {"text": "0.121°", "feedback": "That multiplies by π/180, which is the conversion the other way round."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'radian-measure-and-arc-length', 8, 'Challenge',
 'Convert 9° to an exact radian measure.', 1,
 '[
   {"text": "20π", "feedback": "The fraction was turned upside down before the π was attached."},
   {"text": "π/20", "feedback": "Correct."},
   {"text": "20/π", "feedback": "The π and the 20 have swapped. Multiplying by π/180 leaves the π on top."},
   {"text": "π/9", "feedback": "That reads the 9 straight into the denominator and loses the 180 altogether."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'radian-measure-and-arc-length', 9, 'Advanced',
 'An angle measures 2.82 radians.
Which quadrant is it in, and what is its degree measure to one decimal place?', 0,
 '[
   {"text": "Second quadrant, 161.6°", "feedback": "Correct."},
   {"text": "Third quadrant, 161.6°", "feedback": "The degree measure is right, and 161.6 is still short of 180, so the arm has not reached the third quadrant."},
   {"text": "First quadrant, 161.6°", "feedback": "The degree measure is right, but the first quadrant stops at 90 degrees."},
   {"text": "Second quadrant, 0.049°", "feedback": "The quadrant is right. Converting TO degrees multiplies by 180/π, not by π/180."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'exact-trig-ratios-in-radians', 1, 'Easy',
 'What is the exact value of   sin(π/6) ?', 0,
 '[
   {"text": "1/2", "feedback": "Correct. π/6 is 30°, and the sine of 30° is one half."},
   {"text": "√3/2", "feedback": "That is the cosine of this angle, not its sine."},
   {"text": "√2/2", "feedback": "That value belongs to π/4, the 45° angle."},
   {"text": "1", "feedback": "Sine only reaches 1 at π/2, a full right angle."}
 ]'::jsonb,
 'special-angle-ratio'),
('MHF4U', 'trig-in-radians', 'exact-trig-ratios-in-radians', 2, 'Easy',
 'In which quadrant does the angle 5π/3 lie?', 2,
 '[
   {"text": "The second", "feedback": "The second quadrant runs from π/2 to π. 5π/3 is well beyond a half turn."},
   {"text": "The first", "feedback": "The first quadrant stops at π/2, and 5π/3 is nearly a full turn."},
   {"text": "The fourth", "feedback": "Correct."},
   {"text": "The third", "feedback": "The third quadrant runs from π to 3π/2, and 5π/3 is past 3π/2."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'exact-trig-ratios-in-radians', 3, 'Medium',
 'What is the exact value of sin(5π/3)?', 1,
 '[
   {"text": "-1/√2", "feedback": "The sign is right but the related acute angle is not. 2π - 5π/3 gives π/3, not π/4."},
   {"text": "-√3/2", "feedback": "Correct."},
   {"text": "√3/2", "feedback": "The related acute angle is right, but 5π/3 lands in the fourth quadrant, where sine is negative."},
   {"text": "-1/2", "feedback": "The sign is right but the related acute angle is not. 2π - 5π/3 gives π/3, not π/6."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'exact-trig-ratios-in-radians', 4, 'Medium',
 'What is the exact value of cos(5π/4)?', 2,
 '[
   {"text": "-√3/2", "feedback": "The sign is right but the related acute angle is not. 5π/4 - π gives π/4, not π/6."},
   {"text": "-1/2", "feedback": "The sign is right but the related acute angle is not. 5π/4 - π gives π/4, not π/3."},
   {"text": "-1/√2", "feedback": "Correct."},
   {"text": "1/√2", "feedback": "The related acute angle is right, but 5π/4 lands in the third quadrant, where cosine is negative."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'exact-trig-ratios-in-radians', 5, 'Hard',
 'What is the exact value of   cos(2π/3) ?', 3,
 '[
   {"text": "1/2", "feedback": "The related acute angle is right, but this angle lies in the second quadrant, where cosine takes the opposite sign."},
   {"text": "√3/2", "feedback": "That is the sine of this angle, and the quadrant still has to be considered."},
   {"text": "−√3/2", "feedback": "The sign is right but the ratio is not. Check which value belongs to the cosine of the related acute angle π/3."},
   {"text": "−1/2", "feedback": "Correct. The related acute angle is π/3, its cosine is one half, and cosine is negative in the second quadrant."}
 ]'::jsonb,
 'quadrant-sign-cosine'),
('MHF4U', 'trig-in-radians', 'exact-trig-ratios-in-radians', 6, 'Challenge',
 'What is the exact value of cot(π/3)?', 1,
 '[
   {"text": "2/√3", "feedback": "2/√3 is csc(π/3). Cotangent comes from tangent, not from sine."},
   {"text": "1/√3", "feedback": "Correct."},
   {"text": "√3", "feedback": "That is tan(π/3). Cotangent is its reciprocal, so the fraction turns over."},
   {"text": "1/2", "feedback": "1/2 is cos(π/3). Cotangent is cosine over SINE, not cosine on its own."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'exact-trig-ratios-in-radians', 7, 'Challenge',
 'The terminal arm of θ passes through the point (-4, 2).
Find the exact values of cot θ and sin θ.', 2,
 '[
   {"text": "cot θ = -2 and sin θ = -1/√5", "feedback": "The minus belongs to the x-coordinate. Sine is built from y over r, and both of those are positive here."},
   {"text": "cot θ = 2 and sin θ = 1/√5", "feedback": "The x-coordinate is negative and the y-coordinate is positive, so their ratio comes out negative."},
   {"text": "cot θ = -2 and sin θ = 1/√5", "feedback": "Correct."},
   {"text": "cot θ = -1/2 and sin θ = 1/√5", "feedback": "The cotangent is upside down. It is x over y, so the 4 sits on top."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'exact-trig-ratios-in-radians', 8, 'Challenge',
 'Determine the exact value of cot(π/4) divided by [cos(π/3) csc(π/2)].', 0,
 '[
   {"text": "2", "feedback": "Correct."},
   {"text": "1/2", "feedback": "The expression was turned upside down, dividing the product by the cotangent rather than the other way round."},
   {"text": "1", "feedback": "csc(π/2) is 1, but cos(π/3) is a half, and that half still has to divide into the numerator."},
   {"text": "√2", "feedback": "That reads cos(π/3) as 1/√2, which belongs to π/4. The 60 degree angle has a different cosine in the special triangle."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'exact-trig-ratios-in-radians', 9, 'Advanced',
 'Determine the exact value of cos(π/6) csc(π/3) + sin(π/4).', 3,
 '[
   {"text": "1 + √2", "feedback": "The second term is sin(π/4), and its root belongs underneath, not out front."},
   {"text": "2/√2", "feedback": "The two terms were combined over a single √2 denominator. Only the second term has a root underneath it, so the first cannot be written over that root."},
   {"text": "√2/2", "feedback": "That is the second term on its own. The product in front of it was dropped instead of being evaluated."},
   {"text": "(√2 + 1)/√2", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'exact-trig-ratios-in-radians', 10, 'Advanced',
 'Determine the exact value of sec(5π/4) + cot(2π/3) sin(11π/6).', 3,
 '[
   {"text": "(1 + 2√6)/(2√3)", "feedback": "sec(5π/4) is negative, because 5π/4 sits in the third quadrant where cosine is below zero."},
   {"text": "(2√6 - 1)/(2√3)", "feedback": "Both signs are flipped. The secant term is negative and the product of the two negative ratios is positive."},
   {"text": "-√2 - 1/(2√3)", "feedback": "The secant term is right. The other two ratios are both negative, so their product comes out positive and is ADDED."},
   {"text": "(1 - 2√6)/(2√3)", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'transforming-trig-functions', 1, 'Easy',
 'What is the amplitude of y = 5 sin[2(x - π/4)] - 1?', 3,
 '[
   {"text": "2", "feedback": "2 is k, which sits inside the bracket and changes the period."},
   {"text": "1", "feedback": "1 is the vertical shift, which moves the curve down rather than changing its height."},
   {"text": "-1", "feedback": "Amplitude is a distance, so it is never negative. -1 is the vertical shift."},
   {"text": "5", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'transforming-trig-functions', 2, 'Easy',
 'What is the period of y = cos(x + π/3) + 1?', 3,
 '[
   {"text": "π", "feedback": "Halving the period would need k = 2 inside. Here k is 1, so the curve keeps the parent period."},
   {"text": "2π/3", "feedback": "π/3 is the phase shift, which slides the curve sideways without changing how often it repeats."},
   {"text": "π/3", "feedback": "π/3 is the phase shift. Only k affects the period, and k is 1 here."},
   {"text": "2π", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'transforming-trig-functions', 3, 'Medium',
 'What is the period of   y = sin(2x) ?', 1,
 '[
   {"text": "2π", "feedback": "That is the period of the basic sine curve. The 2 inside the brackets compresses the graph horizontally."},
   {"text": "π", "feedback": "Correct. The period is 2π divided by the coefficient of x, so 2π/2 = π."},
   {"text": "4π", "feedback": "The 2 has been multiplied rather than divided. A larger coefficient inside makes the cycle finish sooner."},
   {"text": "2", "feedback": "A period measured in radians keeps a factor of π here. Divide 2π by the coefficient."}
 ]'::jsonb,
 'period-from-coefficient'),
('MHF4U', 'trig-in-radians', 'transforming-trig-functions', 4, 'Medium',
 'What is the range of   y = 3sin(x) + 2 ?', 2,
 '[
   {"text": "−3 ≤ y ≤ 3", "feedback": "This is the range after the stretch but before the vertical shift. The +2 lifts the whole graph."},
   {"text": "0 ≤ y ≤ 5", "feedback": "The lowest point is not zero. Start from the minimum of sine, which is −1, then stretch and shift."},
   {"text": "−1 ≤ y ≤ 5", "feedback": "Correct. Sine runs from −1 to 1, tripling gives −3 to 3, and adding 2 gives −1 to 5."},
   {"text": "2 ≤ y ≤ 5", "feedback": "The graph dips below the midline just as much as it rises above it."}
 ]'::jsonb,
 'range-after-transformation'),
('MHF4U', 'trig-in-radians', 'transforming-trig-functions', 5, 'Medium',
 'For y = cos(x + π/3) + 1, give the phase shift and the vertical shift.', 2,
 '[
   {"text": "π/3 left, 1 down", "feedback": "The 1 is being added, so the whole curve rises."},
   {"text": "1 left, π/3 up", "feedback": "The two numbers have swapped jobs. What sits inside the bracket moves the curve sideways."},
   {"text": "π/3 left, 1 up", "feedback": "Correct."},
   {"text": "π/3 right, 1 up", "feedback": "The bracket reads x + π/3, and a plus inside moves the curve left."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'transforming-trig-functions', 6, 'Medium',
 'Give the maximum and minimum values of y = 5 sin[2(x - π/4)] - 1.', 2,
 '[
   {"text": "Maximum 6, minimum -4", "feedback": "The vertical shift is -1, so the axis moves DOWN, taking both turning points with it."},
   {"text": "Maximum 4, minimum -5", "feedback": "The vertical shift was taken off the maximum but never off the minimum. Both turning points move with the axis."},
   {"text": "Maximum 4, minimum -6", "feedback": "Correct."},
   {"text": "Maximum 5, minimum -5", "feedback": "That is the plain 5 sin curve, before the - 1 pulled the whole thing down."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'transforming-trig-functions', 7, 'Hard',
 'In   y = 2cos(x − π/3) + 1,   what is the phase shift?', 1,
 '[
   {"text": "Left π/3", "feedback": "The sign inside the bracket is a subtraction, which moves the graph in the positive direction instead."},
   {"text": "Right π/3", "feedback": "Correct. Subtracting inside the bracket delays the cycle, shifting the graph in the positive x direction."},
   {"text": "Up π/3", "feedback": "Vertical movement comes from the number added outside the cosine, which here is 1."},
   {"text": "Right 2", "feedback": "The 2 in front controls the vertical stretch, not any horizontal movement."}
 ]'::jsonb,
 'phase-shift-direction'),
('MHF4U', 'trig-in-radians', 'transforming-trig-functions', 8, 'Challenge',
 'Give the period and the phase shift of y = 5 sin[2(x - π/4)] - 1.', 2,
 '[
   {"text": "Period π, shifted π/4 left", "feedback": "The period is right. The bracket reads x - π/4, and a minus inside moves the curve right."},
   {"text": "Period π, shifted π/8 right", "feedback": "The π/4 is already outside the k, sitting in the (x - d) bracket, so it is the shift as it stands rather than being divided by 2."},
   {"text": "Period π, shifted π/4 right", "feedback": "Correct."},
   {"text": "Period 2π, shifted π/4 right", "feedback": "The shift is right. k = 2 halves the period, so it comes to π rather than 2π."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'transforming-trig-functions', 9, 'Challenge',
 'Write the equation of a cosine function with amplitude 3, period π,
shifted π/2 to the right and 2 down.', 0,
 '[
   {"text": "y = 3 cos[2(x - π/2)] - 2", "feedback": "Correct."},
   {"text": "y = 3 cos[2(x + π/2)] - 2", "feedback": "A shift RIGHT is written x - π/2. The sign inside the bracket is the opposite of the direction."},
   {"text": "y = 3 cos[(1/2)(x - π/2)] - 2", "feedback": "k is 2π divided by the period, so a period of π needs k = 2. A k below 1 would stretch the curve instead."},
   {"text": "y = 3 cos[2(x - π/2)] + 2", "feedback": "A shift down subtracts from the output, so the constant on the end is negative."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'transforming-trig-functions', 10, 'Advanced',
 'For y = cos(x + π/3) + 1, give the maximum, the minimum,
and the x-value where the first maximum happens.', 3,
 '[
   {"text": "Maximum 2, minimum 0, first maximum at x = π/3", "feedback": "The turning points are right. The bracket reads x + π/3, and the curve peaks when that bracket is zero, which is at a negative x."},
   {"text": "Maximum 1, minimum -1, first maximum at x = -π/3", "feedback": "The position is right, but the + 1 lifts the whole curve, taking both turning points up with it."},
   {"text": "Maximum 2, minimum 0, first maximum at x = 0", "feedback": "The turning points are right. At x = 0 the bracket is π/3 rather than 0, so the curve is already past its peak."},
   {"text": "Maximum 2, minimum 0, first maximum at x = -π/3", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'transforming-trig-functions', 11, 'Advanced',
 'A sinusoid has amplitude 5, period π, a phase shift of π/4 right
and a vertical shift of 1 down. What is its k value?', 0,
 '[
   {"text": "2", "feedback": "Correct."},
   {"text": "π", "feedback": "π is the period itself. k is 2π divided by the period."},
   {"text": "1/2", "feedback": "The fraction is upside down. A period SHORTER than 2π needs a k above 1."},
   {"text": "1", "feedback": "k = 1 leaves the period at 2π. This curve repeats twice as often as that."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'solving-trig-equations', 1, 'Easy',
 'Solve sin x = 1/2 for 0 ≤ x ≤ 2π, giving exact values.', 2,
 '[
   {"text": "x = π/6 and x = 7π/6", "feedback": "7π/6 is in the third quadrant, where sine is negative. The second solution comes from π MINUS the first."},
   {"text": "x = π/3 and x = 2π/3", "feedback": "Those are the angles whose sine is √3/2. The related acute angle for a half is π/6."},
   {"text": "x = π/6 and x = 5π/6", "feedback": "Correct."},
   {"text": "x = π/6 and no other value", "feedback": "The calculator gives one, but sine is positive in TWO quadrants, so a second solution shares the value."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'solving-trig-equations', 2, 'Easy',
 'How many solutions does sin x = 2.5 have?', 3,
 '[
   {"text": "One", "feedback": "Sine never leaves the interval from -1 to 1, so no angle produces 2.5."},
   {"text": "Two", "feedback": "Two would be right for any value BETWEEN -1 and 1. This one is outside the range entirely."},
   {"text": "Infinitely many", "feedback": "Sine is periodic, so values it does take repeat forever. 2.5 is not one of them."},
   {"text": "None", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'solving-trig-equations', 3, 'Medium',
 'Solve   sin x = 1/2   for   0 ≤ x ≤ 2π.', 3,
 '[
   {"text": "x = π/6 only", "feedback": "Sine is positive in two different quadrants, so there is a second solution inside this interval."},
   {"text": "x = π/6 and 7π/6", "feedback": "The second angle here sits in a quadrant where sine is negative. Reflect the first angle across the vertical axis instead."},
   {"text": "x = π/3 and 2π/3", "feedback": "These angles belong to a different sine value. Check which special angle has a sine of one half."},
   {"text": "x = π/6 and 5π/6", "feedback": "Correct. The related acute angle is π/6, and sine is positive in the first and second quadrants."}
 ]'::jsonb,
 'second-quadrant-solution'),
('MHF4U', 'trig-identities-and-equations', 'solving-trig-equations', 4, 'Medium',
 'Solve tan x + 1 = 0 for 0 ≤ x ≤ 2π, giving exact values.', 0,
 '[
   {"text": "x = 3π/4 and x = 7π/4", "feedback": "Correct."},
   {"text": "x = π/4 and x = 5π/4", "feedback": "Those are the angles where the tangent is POSITIVE 1. A negative tangent moves both solutions a quadrant along."},
   {"text": "x = 3π/4 and no other value", "feedback": "Tangent is negative in TWO quadrants, the second and the fourth, so a second solution exists."},
   {"text": "x = π/4 and x = 3π/4", "feedback": "At π/4 the tangent is positive. Only one of these two satisfies the equation."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'solving-trig-equations', 5, 'Medium',
 'Solve cos x + 0.6 = 0 for 0 ≤ x ≤ 2π, to two decimal places.', 0,
 '[
   {"text": "x = 2.21 and x = 4.07", "feedback": "Correct."},
   {"text": "x = 0.93 and x = 5.36", "feedback": "0.93 is the RELATED ACUTE angle, where the cosine is positive 0.6. A negative cosine lives in the second and third quadrants."},
   {"text": "x = 2.21 and no other value", "feedback": "Cosine is negative in two quadrants, so a second solution sits below the axis at the same related acute angle."},
   {"text": "x = 0.93 and x = 2.21", "feedback": "0.93 is the related acute angle used to build the solutions, not a solution itself. Put it back into the equation and the cosine comes out positive."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'solving-trig-equations', 6, 'Challenge',
 'Solve csc x + 3 = 0 for 0 ≤ x ≤ 2π, to two decimal places.', 1,
 '[
   {"text": "x = 2.80 and x = 5.94", "feedback": "5.94 is right, but 2.80 is in the second quadrant, where sine is positive."},
   {"text": "x = 3.48 and x = 5.94", "feedback": "Correct."},
   {"text": "x = 0.34 and x = 2.80", "feedback": "Those are the angles whose sine is POSITIVE one third. A negative cosecant means a negative sine."},
   {"text": "x = 3.48 and no other value", "feedback": "Sine is negative in two quadrants, the third and the fourth, so a second solution exists."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'solving-trig-equations', 7, 'Challenge',
 'Solve sec x - √2 = 0 for 0 ≤ x ≤ 2π, giving exact values.', 1,
 '[
   {"text": "x = π/4 and no other value", "feedback": "Cosine is positive in two quadrants, so a second solution sits below the axis at the same related acute angle."},
   {"text": "x = π/4 and x = 7π/4", "feedback": "Correct."},
   {"text": "x = π/4 and x = 3π/4", "feedback": "At 3π/4 the cosine is negative, so its secant is negative too. Cosine is positive in the first and FOURTH quadrants."},
   {"text": "x = 3π/4 and x = 5π/4", "feedback": "Both of those have a negative cosine, and the equation needs a positive one."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'solving-trig-equations', 8, 'Advanced',
 'Solve 2sin²x - sin x - 1 = 0 for 0 ≤ x ≤ 2π, giving exact values.', 2,
 '[
   {"text": "x = π/2 and no other value", "feedback": "That comes from sin x = 1. The other factor gives sin x = -1/2, which supplies two more solutions."},
   {"text": "x = π/6, 5π/6 and 3π/2", "feedback": "The signs are swapped. Factoring gives sin x = -1/2 and sin x = 1, not the other way round."},
   {"text": "x = π/2, 7π/6 and 11π/6", "feedback": "Correct."},
   {"text": "x = 7π/6 and 11π/6", "feedback": "Those come from sin x = -1/2. The other factor gives sin x = 1, which supplies a third solution."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'solving-trig-equations', 9, 'Advanced',
 'Solve sin 2x = 1/2 for 0 ≤ x ≤ 2π, giving exact values.', 3,
 '[
   {"text": "x = π/12 and 5π/12", "feedback": "As x runs over one turn, 2x runs over TWO, so the pattern repeats and there are four solutions rather than two."},
   {"text": "x = π/6 and 5π/6", "feedback": "Those solve sin x = 1/2. The angle inside is 2x, so each of those still has to be halved, and two more come from the second turn."},
   {"text": "x = π/12, 5π/12 and 13π/12", "feedback": "One is missing. The second turn of 2x contributes a pair, not a single value."},
   {"text": "x = π/12, 5π/12, 13π/12 and 17π/12", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'proving-trig-identities', 1, 'Easy',
 'Which of these is the Pythagorean identity?', 3,
 '[
   {"text": "sin²x - cos²x = 1", "feedback": "The sign is wrong. Try x = 0: that version gives -1."},
   {"text": "tan²x + 1 = sin²x", "feedback": "Dividing the real identity by cos²x gives sec²x on the right, not sin²x."},
   {"text": "sin x + cos x = 1", "feedback": "The squares matter. Try x = π/4 and the left side comes to about 1.41."},
   {"text": "sin²x + cos²x = 1", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'proving-trig-identities', 2, 'Easy',
 'When proving a trig identity, what are you NOT allowed to do?', 2,
 '[
   {"text": "Rewrite everything in terms of sine and cosine", "feedback": "That is usually the first move, and it is always allowed."},
   {"text": "Work on the two sides separately and meet in the middle", "feedback": "That is allowed too, as long as the two sides are never mixed together."},
   {"text": "Move terms across the equals sign as though it were an equation", "feedback": "Correct."},
   {"text": "Simplify one side on its own", "feedback": "That is exactly the standard method: work down one side until it matches the other."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'proving-trig-identities', 3, 'Medium',
 'Simplify   1 − cos²x.', 0,
 '[
   {"text": "sin²x", "feedback": "Correct. Rearranging the Pythagorean identity sin²x + cos²x = 1 gives exactly this."},
   {"text": "tan²x", "feedback": "That comes from a different identity, the one involving secant. This expression only needs the Pythagorean relation."},
   {"text": "sin x", "feedback": "The square has been dropped. Rearranging the identity keeps the exponent intact."},
   {"text": "−sin²x", "feedback": "Check the signs: moving cos²x across the identity leaves a positive term behind."}
 ]'::jsonb,
 'pythagorean-identity'),
('MHF4U', 'trig-identities-and-equations', 'proving-trig-identities', 4, 'Medium',
 'Simplify sin²x (1 + cot²x).', 1,
 '[
   {"text": "cos²x", "feedback": "That would follow from cos²x times csc²x times sin²x. The bracket here is 1 + cot²x, which is csc²x on its own."},
   {"text": "1", "feedback": "Correct."},
   {"text": "sin²x", "feedback": "The bracket does not simplify to 1. It becomes csc²x, which is one over sin²x."},
   {"text": "cot²x", "feedback": "The 1 inside the bracket cannot be dropped. Together with cot²x it forms a Pythagorean identity."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'proving-trig-identities', 5, 'Medium',
 'What does 1 - cos²x equal?', 3,
 '[
   {"text": "-sin²x", "feedback": "The sign is wrong. Moving the cosine term across the Pythagorean identity leaves a positive square, not a negative one."},
   {"text": "tan²x", "feedback": "tan²x is what is left when 1 is taken from sec²x, which is a different rearrangement."},
   {"text": "1", "feedback": "cos²x is not zero for most angles, so it does not simply disappear."},
   {"text": "sin²x", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'proving-trig-identities', 6, 'Challenge',
 'Simplify (cos x - sin x)².', 3,
 '[
   {"text": "1 + sin 2x", "feedback": "Expanding gives a middle term of MINUS 2 sin x cos x, so the double angle is subtracted."},
   {"text": "cos 2x", "feedback": "cos 2x is the difference of the SQUARES. Here the bracket is squared, which produces a cross term as well."},
   {"text": "1", "feedback": "The two squares do add to 1, but the cross term -2 sin x cos x survives and does not vanish."},
   {"text": "1 - sin 2x", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'proving-trig-identities', 7, 'Challenge',
 'Simplify 1/(1 + cos x) + 1/(1 - cos x).', 1,
 '[
   {"text": "2", "feedback": "The denominator does not cancel away. It becomes 1 - cos²x, which is sin²x rather than 1."},
   {"text": "2csc²x", "feedback": "Correct."},
   {"text": "2sec²x", "feedback": "The common denominator comes to 1 - cos²x, which is sin²x. One over sin²x is cosecant squared."},
   {"text": "csc²x", "feedback": "The numerators add to 2, not 1. Both fractions contribute a 1 on top."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'proving-trig-identities', 8, 'Advanced',
 'Simplify [sin 2x](tan x + cot x).', 3,
 '[
   {"text": "1", "feedback": "The bracket comes to 1 over (sin x cos x), but sin 2x is not that same product, so the cancellation does not clear everything away."},
   {"text": "sin 2x", "feedback": "The bracket does not simplify to 1. Written over a common denominator it becomes 1 over sin x cos x."},
   {"text": "2 sin 2x", "feedback": "The bracket cancels the sine and cosine in sin 2x completely, leaving only the numerical factor."},
   {"text": "2", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'proving-trig-identities', 9, 'Advanced',
 'Simplify (csc x - cot x)².', 2,
 '[
   {"text": "1", "feedback": "csc²x minus cot²x comes to 1, but this is the SQUARE of their difference, which is not the same thing."},
   {"text": "sin²x", "feedback": "The denominator does become sin²x on the way, but the numerator is (1 - cos x)², so the two do not cancel to leave sin²x."},
   {"text": "(1 - cos x)/(1 + cos x)", "feedback": "Correct."},
   {"text": "(1 + cos x)/(1 - cos x)", "feedback": "The fraction is upside down. The squared numerator is (1 - cos x)², and it is the (1 - cos x) that survives on top."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'trig-applications-in-radians', 1, 'Easy',
 'The arc length formula a = rθ needs θ measured in what?', 0,
 '[
   {"text": "Radian measure", "feedback": "Correct."},
   {"text": "Degree measure", "feedback": "In degrees the formula picks up an extra factor of π/180. Radians are defined precisely so this formula comes out clean."},
   {"text": "Either one works", "feedback": "It makes an enormous difference: the same angle in degrees is about 57 times the number it is in radians."},
   {"text": "Revolutions", "feedback": "A revolution is 2π radians, so using it would leave the formula short by that factor."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'trig-applications-in-radians', 2, 'Easy',
 'A circle has radius 4 cm and a central angle of 2 radians.
How long is the arc it cuts off?', 1,
 '[
   {"text": "8π cm", "feedback": "No π is needed. The angle is already given in radians, which is exactly what makes the formula this simple."},
   {"text": "8 cm", "feedback": "Correct."},
   {"text": "2 cm", "feedback": "That reports the angle. The arc length is the radius multiplied by it."},
   {"text": "0.5 cm", "feedback": "The formula multiplies rather than divides: a = rθ."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'trig-applications-in-radians', 3, 'Medium',
 'An arc of 22.5 cm subtends a central angle of 4π/3 radians.
What is the radius, to one decimal place?', 0,
 '[
   {"text": "5.4 cm", "feedback": "Correct."},
   {"text": "94.2 cm", "feedback": "That multiplies rather than divides. Rearranging a = rθ for r puts the angle underneath."},
   {"text": "5.6 cm", "feedback": "That divides by 4 rather than by 4π/3. The π has to stay in the denominator."},
   {"text": "16.9 cm", "feedback": "That divides by 4/3 and drops the π entirely."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'trig-applications-in-radians', 4, 'Hard',
 'A Ferris wheel completes one full rotation every 40 seconds.
Its height is modelled by h(t) = a cos(kt) + c. What is the value of k?', 0,
 '[
   {"text": "π/20", "feedback": "Correct. The period equals 2π divided by k, so k = 2π/40 = π/20."},
   {"text": "40", "feedback": "That is the period itself. The coefficient inside the brackets is 2π divided by the period."},
   {"text": "2π/20", "feedback": "This divides by half the period. The full rotation takes 40 seconds, not 20."},
   {"text": "20/π", "feedback": "The fraction is upside down. Dividing 2π by 40 leaves the π on the top."}
 ]'::jsonb,
 'period-to-coefficient'),
('MHF4U', 'trig-in-radians', 'trig-applications-in-radians', 5, 'Challenge',
 'A satellite orbits 700 km above the surface of the Earth, whose radius is
6400 km. It sweeps through a central angle of 0.8 radians.
How far does it travel, to the nearest kilometre?', 3,
 '[
   {"text": "5120 km", "feedback": "That uses the radius of the Earth alone. The satellite is 700 km further out, so its own circle is larger."},
   {"text": "8875 km", "feedback": "That divides by the angle rather than multiplying. a = rθ multiplies."},
   {"text": "560 km", "feedback": "That multiplies only the 700 km of altitude by the angle. The satellite travels on a circle centred at the Earth centre, so the whole distance from there counts."},
   {"text": "5680 km", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'trig-applications-in-radians', 6, 'Advanced',
 'A wheel of radius 30 cm turns through 5π/6 radians.
How far does a point on the rim travel, to one decimal place?', 1,
 '[
   {"text": "11.5 cm", "feedback": "That divides by the angle rather than multiplying. a = rθ multiplies."},
   {"text": "78.5 cm", "feedback": "Correct."},
   {"text": "25.0 cm", "feedback": "That works out 5π/6 times 30 and then divides by π, dropping it. The π belongs in the answer."},
   {"text": "157.1 cm", "feedback": "That uses the DIAMETER of 60 cm. The arc length formula takes the radius."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'trig-applications-in-radians', 7, 'Advanced',
 'A pendulum on a 1.2 m string swings through an angle of π/5 radians.
How far does the bob travel, to two decimal places?', 2,
 '[
   {"text": "3.77 m", "feedback": "That multiplies by π and forgets to divide by 5."},
   {"text": "1.91 m", "feedback": "That divides 1.2 by π/5 rather than multiplying. a = rθ multiplies."},
   {"text": "0.75 m", "feedback": "Correct."},
   {"text": "0.24 m", "feedback": "That works out 1.2 divided by 5 and drops the π."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'power-functions-and-end-behaviour', 1, 'Easy',
 'State the degree and the leading coefficient of y = x³ - 2x² - 5x⁴ + 3.', 0,
 '[
   {"text": "Degree 4, leading coefficient -5", "feedback": "Correct."},
   {"text": "Degree 3, leading coefficient 1", "feedback": "The terms are out of order. The degree is the HIGHEST power present, and that is the x⁴ term."},
   {"text": "Degree 4, leading coefficient 3", "feedback": "The degree is right, but 3 is the constant term. The leading coefficient belongs to the highest-power term."},
   {"text": "Degree 5, leading coefficient -5", "feedback": "That reads the 5 from the coefficient as the power. The degree is the exponent written on the term, not the number in front of it."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'power-functions-and-end-behaviour', 2, 'Easy',
 'What is the end behaviour of y = 3x⁷?', 3,
 '[
   {"text": "Q2 to Q4", "feedback": "That is what a NEGATIVE leading coefficient does to an odd-degree function. This one is positive."},
   {"text": "Q2 to Q1", "feedback": "Both ends going up needs an EVEN degree. An odd power sends the two ends in opposite directions."},
   {"text": "Q3 to Q4", "feedback": "Both ends going down needs an even degree and a negative leading coefficient. Neither is true here."},
   {"text": "Q3 to Q1", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'power-functions-and-end-behaviour', 3, 'Medium',
 'What is the end behaviour of y = -0.25x⁶?', 1,
 '[
   {"text": "Q2 to Q4", "feedback": "That needs an odd degree with a negative leading coefficient. The degree here is 6."},
   {"text": "Q3 to Q4", "feedback": "Correct."},
   {"text": "Q2 to Q1", "feedback": "That is what a POSITIVE leading coefficient does to an even-degree function. This one is negative."},
   {"text": "Q3 to Q1", "feedback": "Ends going in opposite directions needs an ODD degree. An even power sends both the same way."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'power-functions-and-end-behaviour', 4, 'Medium',
 'State the degree and the leading coefficient of y = 21 - 2x + 4x² - 6x³.', 3,
 '[
   {"text": "Degree 3, leading coefficient 21", "feedback": "The degree is right, but 21 is the constant term. The leading coefficient belongs to the highest power."},
   {"text": "Degree 4, leading coefficient 4", "feedback": "There is no x⁴ term here. The 4 sits on x squared."},
   {"text": "Degree 1, leading coefficient -2", "feedback": "That reads the second term. The polynomial is written lowest power first, so the leading term is at the END."},
   {"text": "Degree 3, leading coefficient -6", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'power-functions-and-end-behaviour', 5, 'Challenge',
 'Which function has end behaviour running from Q2 to Q4?', 1,
 '[
   {"text": "y = -0.25x⁶", "feedback": "The leading coefficient is negative, which is right, but an even degree sends both ends down: Q3 to Q4."},
   {"text": "y = -(1/2)x³", "feedback": "Correct."},
   {"text": "y = 3x⁷", "feedback": "The degree is odd, which is right, but a positive leading coefficient sends it from Q3 to Q1 instead."},
   {"text": "y = 2x⁴", "feedback": "An even degree sends both ends the same way, so this one runs Q2 to Q1."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'power-functions-and-end-behaviour', 6, 'Challenge',
 'A power function has domain all real numbers, range y ≥ 0, line symmetry
about the y-axis and end behaviour Q2 to Q1. What can be said about it?', 3,
 '[
   {"text": "Odd degree with a positive leading coefficient", "feedback": "An odd degree gives a range of all real numbers and point symmetry, not a floor at zero and line symmetry."},
   {"text": "Even degree with a negative leading coefficient", "feedback": "A negative leading coefficient with an even degree sends both ends DOWN, which is Q3 to Q4, and the range would be capped above rather than below."},
   {"text": "Odd degree with a negative leading coefficient", "feedback": "That runs Q2 to Q4 and has point symmetry, so neither the end behaviour nor the symmetry matches."},
   {"text": "Even degree with a positive leading coefficient", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'power-functions-and-end-behaviour', 7, 'Advanced',
 'For very large positive values of x, which of these functions is largest?', 3,
 '[
   {"text": "y = 2x⁴", "feedback": "The bigger coefficient loses to the bigger degree in the long run. By x = 10 the degree 7 term is already thousands of times larger."},
   {"text": "y = -0.25x⁶", "feedback": "The leading coefficient is negative, so this function heads DOWN for large x rather than up."},
   {"text": "y = -(1/2)x³", "feedback": "This one is negative for large positive x, so it is the smallest on the list rather than the largest."},
   {"text": "y = 3x⁷", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'power-functions-and-end-behaviour', 8, 'Advanced',
 'A power function y = ax⁵ passes through (2, 32). What is a?', 2,
 '[
   {"text": "2", "feedback": "That reads the x-value straight off. Substitute the point in and solve for a."},
   {"text": "1/32", "feedback": "That divides 1 by 32 rather than 32 by 32."},
   {"text": "1", "feedback": "Correct."},
   {"text": "32", "feedback": "That reads the y-value straight off. The 2 raised to the power 5 is already 32, so a has nothing left to contribute."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'transforming-polynomials', 1, 'Easy',
 'In g(x) = 2[-4(x + 7)]⁴ - 1, what is the value of a?', 3,
 '[
   {"text": "-4", "feedback": "-4 is k. It sits inside the bracket, where it acts on the x-values."},
   {"text": "7", "feedback": "7 comes from d. It also sits inside the bracket, and it moves the curve sideways."},
   {"text": "-1", "feedback": "-1 is c, the vertical shift on the end."},
   {"text": "2", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'transforming-polynomials', 2, 'Easy',
 'What does g(x) = f(x) - 1 do to the graph of f?', 0,
 '[
   {"text": "Moves it down 1 unit", "feedback": "Correct."},
   {"text": "Moves it up 1 unit", "feedback": "The 1 is being subtracted from every output, which lowers the curve."},
   {"text": "Moves it right 1 unit", "feedback": "A sideways move needs the 1 inside the bracket with the x. Out here it acts on the outputs."},
   {"text": "Moves it left 1 unit", "feedback": "A sideways move needs the 1 inside the bracket with the x."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'transforming-polynomials', 3, 'Medium',
 'If f(x) = x³, what is the equation of g(x) = (1/2)f(x + 2) - 4?', 2,
 '[
   {"text": "g(x) = 2(x + 2)³ - 4", "feedback": "The 1/2 was turned over. It multiplies the whole function, which squashes it toward the x-axis."},
   {"text": "g(x) = (1/2)(x + 2)³ + 4", "feedback": "The 4 is being subtracted, so it stays negative on the end."},
   {"text": "g(x) = (1/2)(x + 2)³ - 4", "feedback": "Correct."},
   {"text": "g(x) = (1/2)(x - 2)³ - 4", "feedback": "The bracket reads x + 2, and it goes into the parent function exactly as written."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'transforming-polynomials', 4, 'Medium',
 'In g(x) = 2[-4(x + 7)]⁴ - 1, describe the HORIZONTAL change.', 0,
 '[
   {"text": "Reflection in the y-axis and compression by a factor of 1/4", "feedback": "Correct."},
   {"text": "Reflection in the y-axis and stretch by a factor of 4", "feedback": "k = -4 squeezes the curve rather than stretching it. The scale factor is 1 over k."},
   {"text": "Compression by a factor of 1/4, with no reflection in the y-axis", "feedback": "The minus sign on the 4 flips the curve across the y-axis as well as squeezing it."},
   {"text": "A horizontal shift to the left of 4 units", "feedback": "The 4 multiplies the bracket rather than being added to x, so it scales rather than slides. The shift comes from the 7."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'transforming-polynomials', 5, 'Challenge',
 'f(x) = x⁴ is compressed vertically by 3/5, stretched horizontally by 2,
reflected in the y-axis, and moved 1 up and 4 left. Write g(x).', 0,
 '[
   {"text": "g(x) = (3/5)[-(1/2)(x + 4)]⁴ + 1", "feedback": "Correct."},
   {"text": "g(x) = (3/5)[-2(x + 4)]⁴ + 1", "feedback": "A horizontal stretch by 2 needs k = 1/2, because the graph is scaled by 1 over k. Putting 2 in squeezes it."},
   {"text": "g(x) = (5/3)[-(1/2)(x + 4)]⁴ + 1", "feedback": "A compression by 3/5 means a is 3/5. Turning it over would stretch the curve instead."},
   {"text": "g(x) = (3/5)[-(1/2)(x - 4)]⁴ + 1", "feedback": "A move LEFT is written x + 4. The sign inside the bracket is the opposite of the direction."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'transforming-polynomials', 6, 'Challenge',
 'f(x) = x³ is compressed horizontally by 1/4, stretched vertically by 5,
reflected in the x-axis, and moved 2 left and 7 up. Write g(x).', 2,
 '[
   {"text": "g(x) = 5[4(x + 2)]³ + 7", "feedback": "The reflection in the x-axis never reached a. It is the minus in front that flips the curve over."},
   {"text": "g(x) = -5[4(x - 2)]³ + 7", "feedback": "A move LEFT is written x + 2. The sign inside the bracket is the opposite of the direction."},
   {"text": "g(x) = -5[4(x + 2)]³ + 7", "feedback": "Correct."},
   {"text": "g(x) = -5[(1/4)(x + 2)]³ + 7", "feedback": "A horizontal compression by 1/4 needs k = 4, because the graph is scaled by 1 over k."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'transforming-polynomials', 7, 'Advanced',
 'For g(x) = 2[-4(x + 7)]⁴ - 1, state a, k, d and c.', 1,
 '[
   {"text": "a = 2, k = -4, d = -7, c = 1", "feedback": "The 1 is being subtracted on the end, so c is negative."},
   {"text": "a = 2, k = -4, d = -7, c = -1", "feedback": "Correct."},
   {"text": "a = 2, k = -4, d = 7, c = -1", "feedback": "The general form is x - d, and the bracket here reads x + 7, so d is negative."},
   {"text": "a = 2, k = 4, d = -7, c = -1", "feedback": "The minus in front of the 4 belongs to k. It reflects the curve across the y-axis."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'transforming-polynomials', 8, 'Advanced',
 'f(x) = x⁴, so the point (2, 16) lies on it.
Where does that point land on g(x) = -f[(1/2)(x - 1)] + 7?', 0,
 '[
   {"text": "(5, -9)", "feedback": "Correct."},
   {"text": "(2, -9)", "feedback": "The x-coordinate was carried straight across. Both the 1/2 and the subtraction inside the bracket act on it."},
   {"text": "(5, 23)", "feedback": "The x-coordinate is right, but the minus in front of f flips the output before the 7 is added."},
   {"text": "(5, -23)", "feedback": "The + 7 was carried inside the reflection. It is added after the output has been flipped, not before."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'even-odd-and-symmetry', 1, 'Easy',
 'A function whose graph has line symmetry about the y-axis is called what?', 2,
 '[
   {"text": "Neither", "feedback": "Line symmetry about the y-axis is exactly the definition of one of the two named types."},
   {"text": "Periodic", "feedback": "A periodic function repeats along the x-axis. That is a different property altogether."},
   {"text": "Even", "feedback": "Correct."},
   {"text": "Odd", "feedback": "An odd function has POINT symmetry about the origin instead, so its graph looks the same after a half turn."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'even-odd-and-symmetry', 2, 'Easy',
 'Which of these functions is EVEN?', 1,
 '[
   {"text": "f(x) = x⁵", "feedback": "That one is ODD: replacing x with -x flips the whole thing rather than leaving it alone."},
   {"text": "f(x) = 3x⁶ + 2x² - 5", "feedback": "Correct."},
   {"text": "f(x) = x³ - 4x² + 1", "feedback": "The x³ term changes sign when x is replaced by -x while the x² term does not, so the two do not match."},
   {"text": "f(x) = x⁴ + 5x", "feedback": "The lone 5x term has an odd power, and that is enough to break the symmetry."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'even-odd-and-symmetry', 3, 'Medium',
 'Is f(x) = x³ - 4x² + 1 even, odd or neither?', 0,
 '[
   {"text": "Neither", "feedback": "Correct."},
   {"text": "Odd, with point symmetry about the origin", "feedback": "An odd function needs f(-x) to be the exact negative of f(x), and the -4x² term keeps its sign. The graph does have point symmetry, but about its own inflection point rather than the origin."},
   {"text": "Even, with line symmetry about the y-axis", "feedback": "An even function needs f(-x) to match f(x), and the x³ term changes sign."},
   {"text": "Both even and odd", "feedback": "Only the zero function manages both, and this one is not it."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'even-odd-and-symmetry', 4, 'Medium',
 'Is f(x) = x⁴ + 5x even, odd or neither?', 3,
 '[
   {"text": "Even, with line symmetry about the y-axis", "feedback": "The x⁴ term is even, but the 5x term flips sign, so f(-x) does not match f(x)."},
   {"text": "Odd, with point symmetry about the origin", "feedback": "The 5x term is odd, but the x⁴ term does not flip sign, so f(-x) is not the negative of f(x)."},
   {"text": "Both even and odd", "feedback": "That labels each term on its own and reports the two labels together. A function has to be tested as a whole, and only the zero function carries both."},
   {"text": "Neither", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'even-odd-and-symmetry', 5, 'Challenge',
 'Is f(x) = -3x⁴ + 6x² - 10 even, odd or neither, and why?', 2,
 '[
   {"text": "Neither, because of the constant term -10", "feedback": "A constant is an even-power term, x to the power 0, so it does not break the symmetry."},
   {"text": "Both even and odd", "feedback": "Only the zero function manages both, and this one has a constant of -10."},
   {"text": "Even, because f(-x) works out identical to f(x)", "feedback": "Correct."},
   {"text": "Odd, because every term changes sign when x is replaced by -x", "feedback": "Substituting -x leaves all three terms exactly as they were, because every power present is even."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'even-odd-and-symmetry', 6, 'Challenge',
 'Which statement is true of EVERY cubic function?', 3,
 '[
   {"text": "It is an odd function", "feedback": "Only cubics whose point of symmetry sits at the origin are odd. Adding a constant moves that point without destroying the symmetry."},
   {"text": "It has line symmetry about the y-axis", "feedback": "Line symmetry about the y-axis belongs to even functions, and a cubic sends its two ends in opposite directions."},
   {"text": "It has no symmetry of any kind, about a line or a point", "feedback": "Every cubic is symmetric about the point where it changes concavity, even when that point is nowhere near the origin."},
   {"text": "It has point symmetry about its inflection point", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'even-odd-and-symmetry', 7, 'Advanced',
 'A function has point symmetry about the origin and f(3) = -5. What is f(-3)?', 1,
 '[
   {"text": "-3", "feedback": "That reports an x-value with its sign changed. The question asks for an output."},
   {"text": "5", "feedback": "Correct."},
   {"text": "-5", "feedback": "That is what an EVEN function would give. Point symmetry about the origin flips the sign of the output as well as the input."},
   {"text": "3", "feedback": "That reports an x-value. The question asks for an output."}
 ]'::jsonb,
 null),
('MHF4U', 'polynomial-functions', 'even-odd-and-symmetry', 8, 'Advanced',
 'Which best describes f(x) = x⁵ - x?', 2,
 '[
   {"text": "Neither even nor odd", "feedback": "Both terms flip sign together, which is exactly what makes a function odd."},
   {"text": "Both even and odd", "feedback": "Only the zero function manages both, and this one takes the value 30 at x = 2."},
   {"text": "Odd, with point symmetry about the origin", "feedback": "Correct."},
   {"text": "Even, with line symmetry about the y-axis", "feedback": "Both powers present are odd, so substituting -x flips the whole thing rather than leaving it alone."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'long-and-synthetic-division', 1, 'Easy',
 'To divide a polynomial by x + 1 using synthetic division,
which number goes in the box?', 3,
 '[
   {"text": "1", "feedback": "The box holds the value that makes the DIVISOR zero, and solving x + 1 = 0 moves the 1 across with its sign changed."},
   {"text": "0", "feedback": "0 would be the right box for a divisor of x on its own."},
   {"text": "x", "feedback": "The box holds a number, not a variable. Solve x + 1 = 0 to find it."},
   {"text": "-1", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'long-and-synthetic-division', 2, 'Easy',
 'A degree 4 polynomial is divided by a linear expression.
What is the degree of the quotient?', 1,
 '[
   {"text": "1", "feedback": "1 is the degree of the DIVISOR. The quotient keeps most of the original degree."},
   {"text": "3", "feedback": "Correct."},
   {"text": "4", "feedback": "Dividing by a degree 1 expression takes one off the degree."},
   {"text": "5", "feedback": "Dividing lowers the degree. Multiplying by a linear expression would raise it to 5."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'long-and-synthetic-division', 3, 'Medium',
 'Write (x⁴ - 4x² - 2x + 3) divided by (x - 2) in quotient form.', 2,
 '[
   {"text": "x³ - 2x² - 2 - 1/(x - 2)", "feedback": "The second coefficient is wrong. Bringing 1 down and multiplying by 2 gives +2, not -2."},
   {"text": "x³ + 2x² + 2 - 1/(x - 2)", "feedback": "The constant in the quotient came out negative. Check the third step of the synthetic division."},
   {"text": "x³ + 2x² - 2 - 1/(x - 2)", "feedback": "Correct."},
   {"text": "x³ + 2x² - 2 + 1/(x - 2)", "feedback": "The remainder came out as -1, so the fraction on the end is subtracted."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'long-and-synthetic-division', 4, 'Medium',
 'Divide 12x³ - 2x² + x - 11 by 3x + 1. What are the quotient and the remainder?', 0,
 '[
   {"text": "Quotient 4x² - 2x + 1, remainder -12", "feedback": "Correct."},
   {"text": "Quotient 4x² - 2x + 1, remainder 12", "feedback": "The quotient is right. Subtracting 3x + 1 from 3x - 11 leaves a negative."},
   {"text": "Quotient 4x² + 2x + 1, remainder -12", "feedback": "The middle term of the quotient is negative. Check the sign after the first subtraction."},
   {"text": "Quotient 12x² - 2x + 1, remainder -12", "feedback": "The leading term of the quotient comes from dividing 12x³ by 3x, which gives 4x², not 12x²."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'long-and-synthetic-division', 5, 'Challenge',
 'Divide -8x⁴ + 10x³ - x² - 4x + 15 by 2x - 1.', 1,
 '[
   {"text": "Quotient -8x³ + 3x² + x - 3/2, remainder 27/2", "feedback": "The leading term comes from dividing -8x⁴ by 2x, which gives -4x³."},
   {"text": "Quotient -4x³ + 3x² + x - 3/2, remainder 27/2", "feedback": "Correct."},
   {"text": "Quotient -4x³ + 3x² + x - 3/2, remainder -27/2", "feedback": "The quotient is right. Subtracting -3x + 3/2 from -3x + 15 leaves a positive remainder."},
   {"text": "Quotient -4x³ + 3x² + x + 3/2, remainder 27/2", "feedback": "The constant term of the quotient is negative. Dividing -3x by 2x gives -3/2."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'long-and-synthetic-division', 6, 'Challenge',
 'A division gives (x³ + 4x² - 3) ÷ (x - 2) = x² + 6x + 12 with remainder 21.
Which statement checks it?', 1,
 '[
   {"text": "x³ + 4x² - 3 = (x - 2)(x² + 6x + 12 + 21)", "feedback": "The remainder sits outside the bracket. Putting it inside would multiply it by the divisor as well."},
   {"text": "x³ + 4x² - 3 = (x - 2)(x² + 6x + 12) + 21", "feedback": "Correct."},
   {"text": "x³ + 4x² - 3 = (x - 2)(x² + 6x + 12) - 21", "feedback": "The remainder is what is LEFT OVER, so it is added back on, not taken away."},
   {"text": "x³ + 4x² - 3 = (x² + 6x + 12) + 21(x - 2)", "feedback": "The divisor and the remainder have swapped roles. The divisor multiplies the quotient."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'long-and-synthetic-division', 7, 'Advanced',
 'Divide x⁵ - x⁴ + 2x³ + 3x - 2 by x² + 2.', 3,
 '[
   {"text": "Quotient x³ - x² + 2, remainder 3x + 6", "feedback": "The quotient is right. Subtracting 2x² + 4 from 2x² + 3x - 2 leaves a negative constant."},
   {"text": "Quotient x³ + x² + 2, remainder 3x - 6", "feedback": "The x² term of the quotient is negative. The -x⁴ in the dividend divides by x² to give -x²."},
   {"text": "Quotient x³ - x² - 2, remainder 3x - 6", "feedback": "The constant in the quotient is positive. Check the last step before the remainder."},
   {"text": "Quotient x³ - x² + 2, remainder 3x - 6", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'factoring-polynomials', 'long-and-synthetic-division', 8, 'Advanced',
 'Why can synthetic division not be used to divide by x² + 2?', 2,
 '[
   {"text": "Because its leading coefficient is 1", "feedback": "A leading coefficient of 1 is the easiest case, not an obstacle."},
   {"text": "It can be used, provided the division is set up with two boxes instead of one", "feedback": "The method depends on the divisor having a single root to substitute, so a second box does not rescue it."},
   {"text": "Because synthetic division only works when the divisor is linear", "feedback": "Correct."},
   {"text": "Because x² + 2 has no real roots", "feedback": "Having no real roots is true but beside the point. Even x² - 1, which has two, is out of reach for the method."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'the-six-trig-functions-and-their-graphs', 1, 'Easy',
 'What is the period of y = tan x, in radians?', 2,
 '[
   {"text": "π/2", "feedback": "π/2 is where the first asymptote sits. The pattern does not start over until π."},
   {"text": "4π", "feedback": "Nothing stretches this graph. The plain tangent repeats faster than sine, not slower."},
   {"text": "π", "feedback": "Correct."},
   {"text": "2π", "feedback": "2π is the period of sine and cosine. Tangent repeats twice as often, because it is built from their ratio."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'the-six-trig-functions-and-their-graphs', 2, 'Easy',
 'Where does y = csc x have its vertical asymptotes?', 1,
 '[
   {"text": "Wherever sin x = 1", "feedback": "Where sine is 1 the cosecant is also 1, which is a perfectly ordinary point."},
   {"text": "Wherever sin x = 0", "feedback": "Correct."},
   {"text": "Wherever cos x = 0", "feedback": "That gives the asymptotes of SECANT, which is built from cosine."},
   {"text": "Nowhere", "feedback": "Cosecant is one over sine, and sine does reach zero, so the reciprocal blows up there."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'the-six-trig-functions-and-their-graphs', 3, 'Medium',
 'What is the value of tan(3π)?', 2,
 '[
   {"text": "1", "feedback": "Tangent is 1 at π/4 and at angles coterminal with it. 3π is a whole number of half turns."},
   {"text": "-1", "feedback": "That is cos(3π), not the tangent. Tangent is sine over cosine, so the sine still has to be worked out."},
   {"text": "0", "feedback": "Correct."},
   {"text": "Undefined", "feedback": "Tangent is undefined where COSINE is zero, and cos(3π) is -1. It is the sine on top that vanishes here."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'the-six-trig-functions-and-their-graphs', 4, 'Medium',
 'What is the value of sin(3π/2)?', 1,
 '[
   {"text": "Undefined", "feedback": "Sine is defined everywhere. It is tangent and secant that have gaps."},
   {"text": "-1", "feedback": "Correct."},
   {"text": "1", "feedback": "That is sin(π/2), a quarter turn round. Three quarters of a turn puts the point at the BOTTOM of the circle."},
   {"text": "0", "feedback": "Sine is zero at 0, π and 2π. Three quarters of a turn is between two of those, at the extreme."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'the-six-trig-functions-and-their-graphs', 5, 'Challenge',
 'What is the exact value of sec(11π/6)?', 0,
 '[
   {"text": "2/√3", "feedback": "Correct."},
   {"text": "-2/√3", "feedback": "11π/6 lands in the FOURTH quadrant, where cosine and therefore secant are positive."},
   {"text": "2", "feedback": "2 is sec(π/3). The related acute angle here is π/6, not π/3."},
   {"text": "√3/2", "feedback": "That is cos(11π/6) itself. Secant is its reciprocal, so the fraction turns over."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'the-six-trig-functions-and-their-graphs', 6, 'Challenge',
 'Why does the graph of y = sec x never take a value strictly between -1 and 1?', 2,
 '[
   {"text": "Because cosine is always positive", "feedback": "Cosine is negative for half of every turn, and secant is negative there too. The bound is about SIZE, not sign."},
   {"text": "It does take those values, near its asymptotes", "feedback": "Near an asymptote secant grows without bound. It is at cosine peaks that it comes closest to zero, and even then it only reaches 1."},
   {"text": "Because cos x is never bigger than 1 in size, so its reciprocal is never smaller than 1", "feedback": "Correct."},
   {"text": "Because secant is undefined", "feedback": "Secant is undefined only where cosine is zero. Everywhere else it has a perfectly good value."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'the-six-trig-functions-and-their-graphs', 7, 'Advanced',
 'For θ = 5π/3, which pair of exact values is right?', 1,
 '[
   {"text": "sec θ = 1/2 and cot θ = -1/√3", "feedback": "1/2 is cos(5π/3) itself. Secant is its reciprocal."},
   {"text": "sec θ = 2 and cot θ = -1/√3", "feedback": "Correct."},
   {"text": "sec θ = -2 and cot θ = -1/√3", "feedback": "5π/3 is in the fourth quadrant, where cosine and therefore secant are positive."},
   {"text": "sec θ = 2 and cot θ = -√3", "feedback": "The secant is right. tan(5π/3) is -√3, so its reciprocal is the fraction turned over."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'the-six-trig-functions-and-their-graphs', 8, 'Advanced',
 'How many vertical asymptotes does y = sec x have between 0 and 2π inclusive?', 3,
 '[
   {"text": "1", "feedback": "Cosine hits zero twice in a full turn, once on the way down and once on the way back up."},
   {"text": "3", "feedback": "Three would need cosine to cross zero three times in one turn. It crosses at π/2 and 3π/2 only."},
   {"text": "4", "feedback": "Four zeros in a turn belongs to a function of double the frequency. Plain cosine has two."},
   {"text": "2", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-in-radians', 'the-six-trig-functions-and-their-graphs', 9, 'Advanced',
 'How does the graph of y = csc x relate to the graph of y = sin x?', 0,
 '[
   {"text": "It has an asymptote wherever sine crosses zero, and it touches sine at every peak and trough", "feedback": "Correct."},
   {"text": "It is sine reflected in the x-axis", "feedback": "A reflection would keep the same shape upside down. Cosecant has asymptotes, which sine does not."},
   {"text": "It is sine with half the period", "feedback": "The period is unchanged at 2π. Taking a reciprocal does not speed the pattern up."},
   {"text": "It is sine shifted π/2 to the right", "feedback": "That would give a cosine curve, not a reciprocal. Cosecant is unbounded, and no shift can do that."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'cofunction-and-transformation-identities', 1, 'Easy',
 'Which expression is equal to cos θ?', 0,
 '[
   {"text": "sin(π/2 - θ)", "feedback": "Correct."},
   {"text": "cos(π/2 - θ)", "feedback": "The complement is right but the cofunction identity was applied to the wrong ratio. Try θ = 0: cosine gives 1, and this expression gives 0."},
   {"text": "sin(θ - π/2)", "feedback": "The bracket is the wrong way round, and reversing it flips the sign of the whole thing."},
   {"text": "sin(π/2) - sin θ", "feedback": "Sine does not distribute across a subtraction, so the bracket cannot be split into two terms. The whole angle has to go inside one sine."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'cofunction-and-transformation-identities', 2, 'Easy',
 'What does sin(-θ) equal?', 0,
 '[
   {"text": "-sin θ", "feedback": "Correct."},
   {"text": "sin θ", "feedback": "That is how COSINE behaves. Sine is odd, so reversing the angle reverses the output."},
   {"text": "cos θ", "feedback": "Negating an angle does not turn one ratio into another. It reflects the point across the x-axis."},
   {"text": "-cos θ", "feedback": "Negating an angle reflects the point across the x-axis, which changes the sign of the y-coordinate. That is sine, not cosine."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'cofunction-and-transformation-identities', 3, 'Medium',
 'Given that sin(2π/7) is about 0.7818, evaluate cos(3π/14)
using an equivalent trig expression.', 3,
 '[
   {"text": "About -0.7818", "feedback": "The size is right but the sign is not. 3π/14 is a first-quadrant angle, so its cosine is positive."},
   {"text": "About 0.6235", "feedback": "That is cos(2π/7). The cofunction identity turns the cosine into a SINE of the complementary angle."},
   {"text": "About 0.2182", "feedback": "That is 1 minus the given value. The cofunction identity is not a subtraction of the ratio."},
   {"text": "About 0.7818", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'cofunction-and-transformation-identities', 4, 'Medium',
 'Given that sin(2π/7) is about 0.7818, evaluate cos(11π/14).', 0,
 '[
   {"text": "About -0.7818", "feedback": "Correct."},
   {"text": "About 0.7818", "feedback": "11π/14 is more than a quarter turn, so it sits in the second quadrant where cosine is negative."},
   {"text": "About -0.6235", "feedback": "That is -cos(2π/7). The cofunction identity turns the cosine into a sine of the complementary angle."},
   {"text": "About 0.2182", "feedback": "That is 1 minus the given value. The cofunction identity is not a subtraction of the ratio."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'cofunction-and-transformation-identities', 5, 'Challenge',
 'Simplify sin(2π - x).', 2,
 '[
   {"text": "cos x", "feedback": "Turning by a whole or half turn keeps a ratio as itself or its negative. Only quarter turns swap sine for cosine."},
   {"text": "-cos x", "feedback": "Turning by a full turn keeps sine as sine. Only quarter turns swap the two functions."},
   {"text": "-sin x", "feedback": "Correct."},
   {"text": "sin x", "feedback": "Subtracting from a full turn reflects the angle across the x-axis, which flips the sign of the sine."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'cofunction-and-transformation-identities', 6, 'Challenge',
 'Which expression equals cos(x - π/2)?', 3,
 '[
   {"text": "-sin x", "feedback": "Expanding with the cosine formula kills the first product, because cos(π/2) is zero, and what survives has both factors positive."},
   {"text": "cos x", "feedback": "A quarter turn genuinely swaps the two functions. It cannot leave cosine as cosine."},
   {"text": "-cos x", "feedback": "A quarter turn swaps the functions rather than negating one. A half turn is what negates."},
   {"text": "sin x", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'cofunction-and-transformation-identities', 7, 'Advanced',
 'Simplify cos(π - x).', 0,
 '[
   {"text": "-cos x", "feedback": "Correct."},
   {"text": "cos x", "feedback": "A half turn puts the angle in the mirror quadrant across the y-axis, which flips the sign of the cosine."},
   {"text": "sin x", "feedback": "Only quarter turns swap sine for cosine. A half turn keeps the function and changes the sign."},
   {"text": "-sin x", "feedback": "A half turn keeps cosine as cosine. It is a quarter turn that swaps the two functions."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'compound-angle-formulas', 1, 'Easy',
 'What is the compound angle formula for sin(A + B)?', 3,
 '[
   {"text": "sin A cos B - cos A sin B", "feedback": "That is the formula for sin(A - B). The sign inside matches the sign in the formula for sine."},
   {"text": "cos A cos B - sin A sin B", "feedback": "That is the formula for cos(A + B). The cosine formula keeps the two functions matched; the sine formula mixes them."},
   {"text": "sin A sin B + cos A cos B", "feedback": "That is cos(A - B). Notice both terms here pair like with like, which is the signature of the cosine formula."},
   {"text": "sin A cos B + cos A sin B", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'compound-angle-formulas', 2, 'Easy',
 'What is the compound angle formula for cos(A + B)?', 2,
 '[
   {"text": "sin A cos B + cos A sin B", "feedback": "That is sin(A + B). The sine formula mixes the two functions; the cosine one pairs like with like."},
   {"text": "cos A + cos B", "feedback": "Cosine does not distribute over a sum. Try A = B = π/3 and the two sides disagree."},
   {"text": "cos A cos B - sin A sin B", "feedback": "Correct."},
   {"text": "cos A cos B + sin A sin B", "feedback": "That is cos(A - B). The cosine formula reverses the sign: a plus inside becomes a minus in the middle."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'compound-angle-formulas', 3, 'Medium',
 'Find the exact value of sin(π/3)cos(π/6) + cos(π/3)sin(π/6).', 0,
 '[
   {"text": "1", "feedback": "Correct."},
   {"text": "0", "feedback": "That would be sin of a half turn. The two angles ADD to a quarter turn, not a half."},
   {"text": "√3/2", "feedback": "That is cos(π/3 - π/6), which is what the cosine formula for a difference returns. This expression mixes sine with cosine, so it is not the cosine formula."},
   {"text": "1/2", "feedback": "That is sin(π/3 - π/6). The sign in the middle was read as a minus."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'compound-angle-formulas', 4, 'Medium',
 'Find the exact value of cos(π/3)cos(5π/12) - sin(π/3)sin(5π/12).', 2,
 '[
   {"text": "-1/2", "feedback": "The related acute angle is π/4, not π/3. Adding π/3 and 5π/12 gives 3π/4."},
   {"text": "-√3/2", "feedback": "The related acute angle is π/4, not π/6. Adding π/3 and 5π/12 gives 3π/4."},
   {"text": "-√2/2", "feedback": "Correct."},
   {"text": "√2/2", "feedback": "The two angles add to 3π/4, which lands in the second quadrant where cosine is negative."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'compound-angle-formulas', 5, 'Challenge',
 'Find the exact value of cos(3π/4 - π/6).', 2,
 '[
   {"text": "(√6 + √2)/4", "feedback": "The cosine formula for a DIFFERENCE has a plus in the middle, but cos(3π/4) is itself negative, so the first term is below zero."},
   {"text": "-(√6 + √2)/4", "feedback": "The first term is negative but the second is positive, so they partly cancel rather than piling up."},
   {"text": "(√2 - √6)/4", "feedback": "Correct."},
   {"text": "(√6 - √2)/4", "feedback": "The signs are swapped. cos(3π/4) is negative, so the term it appears in comes out negative."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'compound-angle-formulas', 6, 'Challenge',
 'Find the exact value of sin(11π/12).', 1,
 '[
   {"text": "-(√6 - √2)/4", "feedback": "11π/12 is in the second quadrant, where sine is positive."},
   {"text": "(√6 - √2)/4", "feedback": "Correct."},
   {"text": "(√6 + √2)/4", "feedback": "Splitting 11π/12 as 2π/3 plus π/4 gives a cos(2π/3) of -1/2, so one of the two terms comes out negative."},
   {"text": "-(√6 + √2)/4", "feedback": "That is cos(11π/12). Splitting the angle was fine, but the two products were combined with the cosine formula instead of the sine one."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'compound-angle-formulas', 7, 'Advanced',
 'A 15 m ladder leaning against a wall is unsafe if it makes an angle of
less than π/12 with the WALL, as shown. Using a compound angle formula,
find the exact minimum distance from the foot of the ladder to the wall.', 1,
 '[
   {"text": "15√6/4 m", "feedback": "Only the first term of the expansion was kept. The second product still has to be subtracted."},
   {"text": "15(√6 - √2)/4 m", "feedback": "Correct."},
   {"text": "15(√6 + √2)/4 m", "feedback": "Splitting π/12 as π/3 minus π/4 gives a sine formula with a MINUS in the middle, so the two terms partly cancel."},
   {"text": "15(√2 - √6)/4 m", "feedback": "The signs are swapped, which makes the distance negative. A length cannot be below zero."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'compound-angle-formulas', 8, 'Advanced',
 'Angle x is in the first quadrant with cos x = 12/13, and angle y is in the
second quadrant with sin y = 7/25. Find the exact value of sin(x + y).', 0,
 '[
   {"text": "-36/325", "feedback": "Correct."},
   {"text": "-323/325", "feedback": "That is cos(x + y). The sine formula mixes the two functions; the cosine formula pairs like with like."},
   {"text": "36/325", "feedback": "cos y is negative in the second quadrant, and that term is the larger of the two, so the total comes out below zero."},
   {"text": "-204/325", "feedback": "That is sin(x - y). The formula for a sum has a PLUS between the two products."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'compound-angle-formulas', 9, 'Advanced',
 'With the same angles — x in the first quadrant with cos x = 12/13, and y in
the second with sin y = 7/25 — find the exact value of cos(x - y).', 1,
 '[
   {"text": "-204/325", "feedback": "That is sin(x - y). The cosine formula pairs cosine with cosine; the sine formula mixes them."},
   {"text": "-253/325", "feedback": "Correct."},
   {"text": "-323/325", "feedback": "That is cos(x + y). The formula for a difference has a PLUS between the two products."},
   {"text": "253/325", "feedback": "cos y is negative in the second quadrant, and that first product outweighs the second, so the total is below zero."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'double-angle-formulas', 1, 'Easy',
 'What does 2 sin θ cos θ equal?', 1,
 '[
   {"text": "sin²θ", "feedback": "The two factors are different functions, so their product is not a square."},
   {"text": "sin 2θ", "feedback": "Correct."},
   {"text": "cos 2θ", "feedback": "cos 2θ comes from the DIFFERENCE of the two squares, not from twice their product."},
   {"text": "2 sin θ", "feedback": "The cosine cannot simply be dropped. It is doing real work in the formula."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'double-angle-formulas', 2, 'Easy',
 'What does cos²θ - sin²θ equal?', 0,
 '[
   {"text": "cos 2θ", "feedback": "Correct."},
   {"text": "sin 2θ", "feedback": "sin 2θ is twice the PRODUCT of the two, not the difference of their squares."},
   {"text": "1", "feedback": "The SUM of the two squares comes to 1. The difference does not."},
   {"text": "cos²2θ", "feedback": "The angle doubles but the square does not survive. The result is a plain cosine of the doubled angle."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'double-angle-formulas', 3, 'Medium',
 'Express 2 sin(π/12)cos(π/12) as a single trig ratio and evaluate it exactly.', 1,
 '[
   {"text": "sin(π/24), which is about 0.13", "feedback": "The double angle formula doubles the angle rather than halving it."},
   {"text": "sin(π/6), which is 1/2", "feedback": "Correct."},
   {"text": "sin(π/6), which is √3/2", "feedback": "The ratio is right but the value is not. √3/2 is sin(π/3), not sin(π/6)."},
   {"text": "cos(π/6), which is √3/2", "feedback": "Twice the product of sine and cosine gives a SINE of the doubled angle."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'double-angle-formulas', 4, 'Medium',
 'Express cos²(π/12) - sin²(π/12) as a single trig ratio and evaluate it exactly.', 0,
 '[
   {"text": "cos(π/6), which is √3/2", "feedback": "Correct."},
   {"text": "cos(π/6), which is 1/2", "feedback": "The ratio is right but the value is not. 1/2 is cos(π/3), not cos(π/6)."},
   {"text": "sin(π/6), which is 1/2", "feedback": "The difference of the two squares gives a COSINE of the doubled angle."},
   {"text": "1, because the two squares always add to 1", "feedback": "They add to 1. Here they are being subtracted, which is a different identity altogether."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'double-angle-formulas', 5, 'Challenge',
 'Angle x is in the third quadrant and tan x = 7/24. Find the exact value of cos 2x.', 0,
 '[
   {"text": "527/625", "feedback": "Correct."},
   {"text": "-527/625", "feedback": "cos 2x is cos²x minus sin²x, and the cosine term is the larger of the two here, so the result is positive."},
   {"text": "336/625", "feedback": "That is sin 2x, which is twice the product rather than the difference of the squares."},
   {"text": "49/625", "feedback": "That is sin²x on its own. The cos²x term has to be subtracted from, not dropped."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'double-angle-formulas', 6, 'Challenge',
 'Given sin x = 5/13 and 0 ≤ x ≤ π/2, find the exact value of sin 2x.', 2,
 '[
   {"text": "10/13", "feedback": "That doubles the sine. Doubling an angle is not the same as doubling its sine."},
   {"text": "119/169", "feedback": "That is cos 2x, which comes from the difference of the two squares."},
   {"text": "120/169", "feedback": "Correct."},
   {"text": "60/169", "feedback": "The 2 in front of the formula was left out. sin 2x is TWICE the product."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'double-angle-formulas', 7, 'Advanced',
 'Given cos x = -4/5 and π ≤ x ≤ 3π/2, find the exact value of tan 2x.', 2,
 '[
   {"text": "7/24", "feedback": "The fraction is upside down. The denominator of the formula is 1 - tan²x, which comes to 7/16, and dividing by it flips it up."},
   {"text": "3/2", "feedback": "That is the numerator, 2 tan x, on its own. It still has to be divided by 1 - tan²x."},
   {"text": "24/7", "feedback": "Correct."},
   {"text": "-24/7", "feedback": "In the third quadrant both sine and cosine are negative, so tan x is POSITIVE, and the double angle formula keeps it positive here."}
 ]'::jsonb,
 null),
('MHF4U', 'trig-identities-and-equations', 'double-angle-formulas', 8, 'Advanced',
 'Express [2 tan(π/6)]/[1 - tan²(π/6)] as a single trig ratio
and evaluate it exactly.', 3,
 '[
   {"text": "tan(π/12), which is 2 - √3", "feedback": "The double angle formula DOUBLES the angle rather than halving it."},
   {"text": "tan(π/3), which is 1/√3", "feedback": "The ratio is right but the value is not. 1/√3 is tan(π/6), the angle we started from."},
   {"text": "2 tan(π/6), which is 2/√3", "feedback": "The denominator 1 - tan²(π/6) is not 1, so it cannot simply be dropped."},
   {"text": "tan(π/3), which is √3", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'the-newton-quotient', 1, 'Easy',
 'What is the Newton quotient for a function f at a point a?', 2,
 '[
   {"text": "f(a + h)/h", "feedback": "The starting value f(a) has to be subtracted. Without it this is not a change at all."},
   {"text": "[f(a + h) + f(a)]/h", "feedback": "A rate of change needs a DIFFERENCE on top, not a sum."},
   {"text": "[f(a + h) - f(a)]/h", "feedback": "Correct."},
   {"text": "[f(a) - f(a + h)]/h", "feedback": "The two terms are the wrong way round, which flips the sign of every rate it produces."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'the-newton-quotient', 2, 'Easy',
 'In the Newton quotient, what happens to h?', 2,
 '[
   {"text": "It stays fixed", "feedback": "Leaving h fixed gives an average rate. The instantaneous rate is what appears as the interval closes up."},
   {"text": "It approaches infinity", "feedback": "A growing h widens the interval, which takes the estimate further from the point rather than closer."},
   {"text": "It approaches 0", "feedback": "Correct."},
   {"text": "It approaches 1", "feedback": "h is the width of the interval, and shrinking it to 1 still leaves a whole unit of averaging in the answer."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'the-newton-quotient', 3, 'Medium',
 'For f(x) = x², simplify the Newton quotient [f(a + h) - f(a)]/h.', 0,
 '[
   {"text": "2a + h", "feedback": "Correct."},
   {"text": "2a", "feedback": "That is the value the quotient approaches as h shrinks. Before the limit is taken, an h survives."},
   {"text": "2ah + h²", "feedback": "That is the numerator after expanding. Every term still has to be divided by h."},
   {"text": "a² + h", "feedback": "Expanding (a + h)² gives a² + 2ah + h², and the a² cancels against the one being subtracted."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'the-newton-quotient', 4, 'Medium',
 'For f(x) = 3x + 1, what does the Newton quotient simplify to?', 2,
 '[
   {"text": "3h", "feedback": "The numerator is 3h, and it still has to be divided by the h underneath."},
   {"text": "1", "feedback": "1 is the constant term of f, read straight off the rule. The two constants cancel in the numerator, so neither of them survives into the quotient."},
   {"text": "3", "feedback": "Correct."},
   {"text": "3 + h", "feedback": "The h terms cancel completely for a linear function. Expanding 3(a + h) + 1 leaves only 3h on top."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'the-newton-quotient', 5, 'Challenge',
 'For f(x) = x² - 3x + 2, simplify the Newton quotient at a general point a.', 2,
 '[
   {"text": "2a + h", "feedback": "The -3x term contributes a -3h to the numerator, which leaves a -3 behind after dividing."},
   {"text": "a + h - 3", "feedback": "Expanding (a + h)² gives 2ah in the cross term, so dividing by h leaves 2a rather than a."},
   {"text": "2a + h - 3", "feedback": "Correct."},
   {"text": "2a - 3", "feedback": "That is the value the quotient approaches as h shrinks. Before the limit is taken, an h survives."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'the-newton-quotient', 6, 'Challenge',
 'Using the Newton quotient, find the instantaneous rate of change
of f(x) = x² - 3x + 2 at x = 2.', 3,
 '[
   {"text": "0", "feedback": "0 is the VALUE of the function at x = 2, not its rate of change there."},
   {"text": "4", "feedback": "That evaluates only the 2a part and forgets the -3."},
   {"text": "-3", "feedback": "That evaluates only the -3 and forgets the 2a."},
   {"text": "1", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'the-newton-quotient', 7, 'Advanced',
 'For f(x) = 1/x, simplify the Newton quotient [f(a + h) - f(a)]/h.', 0,
 '[
   {"text": "-1/[a(a + h)]", "feedback": "Correct."},
   {"text": "1/[a(a + h)]", "feedback": "Combining the two fractions gives a - (a + h) on top, which is -h. That minus survives the division."},
   {"text": "-1/a²", "feedback": "That is the value the quotient approaches as h shrinks. Before the limit is taken, an h is still there."},
   {"text": "-1/(a + h)", "feedback": "The common denominator is a(a + h), so both factors stay underneath."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'the-newton-quotient', 8, 'Advanced',
 'Using the Newton quotient, find the instantaneous rate of change of f(x) = 1/x at x = 2.', 0,
 '[
   {"text": "-1/4", "feedback": "Correct."},
   {"text": "1/4", "feedback": "The function is falling everywhere it is defined, so its rate of change is negative."},
   {"text": "-1/2", "feedback": "That is f(2) with a minus attached. The rate involves the square of the a value."},
   {"text": "-4", "feedback": "The fraction is upside down. The a² sits in the DENOMINATOR."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'limits', 1, 'Easy',
 'What is the limit of (x + 3) as x approaches 2?', 3,
 '[
   {"text": "2", "feedback": "2 is the value x is heading toward. The limit is what the EXPRESSION heads toward."},
   {"text": "3", "feedback": "3 is the constant in the expression, not the value the whole thing approaches."},
   {"text": "Undefined", "feedback": "This expression is perfectly well behaved at x = 2, so the limit is simply its value there."},
   {"text": "5", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'limits', 2, 'Easy',
 'A limit exists at x = a only when which of these is true?', 0,
 '[
   {"text": "The left and right limits agree", "feedback": "Correct."},
   {"text": "The value of f(a) is defined there", "feedback": "A limit can exist at a point where the function has a hole. What matters is where the values are heading, not whether they arrive."},
   {"text": "The function is a polynomial there", "feedback": "Polynomials always have limits, but plenty of other functions do too."},
   {"text": "The graph is a straight line there", "feedback": "Any continuous curve has limits. Straightness is not required."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'limits', 3, 'Medium',
 'Find the limit of (x² - 9)/(x - 3) as x approaches 3.', 1,
 '[
   {"text": "3", "feedback": "3 is the value x approaches. Factoring the top gives x + 3, and that is what has to be evaluated."},
   {"text": "6", "feedback": "Correct."},
   {"text": "0", "feedback": "Substituting 3 gives 0 over 0, which is not a value but a signal to factor first."},
   {"text": "Undefined", "feedback": "The function is undefined AT 3, but the limit asks where the values head as x gets close, and they head somewhere perfectly definite."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'limits', 4, 'Medium',
 'Find the limit of 2x/x as x approaches 0.', 0,
 '[
   {"text": "2", "feedback": "Correct."},
   {"text": "0", "feedback": "Substituting gives 0 over 0. Cancelling the x first leaves a constant."},
   {"text": "Undefined", "feedback": "The expression is undefined AT 0, but the limit asks where the values head as x gets close, and they head somewhere perfectly definite."},
   {"text": "1", "feedback": "That cancels the x on top against the x underneath and throws away the coefficient standing in front of it."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'limits', 5, 'Challenge',
 'Find the limit of (x² - 3x + 2)/(x - 2) as x approaches 2.', 3,
 '[
   {"text": "0", "feedback": "Substituting gives 0 over 0, which is a signal to factor rather than an answer."},
   {"text": "2", "feedback": "2 is the value x approaches. Factoring the top and cancelling leaves x - 1, and that has to be evaluated."},
   {"text": "Undefined", "feedback": "The function is undefined at 2, but the limit asks where the values head as x gets close, and they head somewhere definite."},
   {"text": "1", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'limits', 6, 'Challenge',
 'Find the limit of (x³ - 1)/(x - 1) as x approaches 1.', 2,
 '[
   {"text": "0", "feedback": "Substituting gives 0 over 0, which is a signal to factor as a difference of cubes."},
   {"text": "Undefined", "feedback": "The function has a hole at 1, but the values on either side head toward a perfectly definite number."},
   {"text": "3", "feedback": "Correct."},
   {"text": "1", "feedback": "Factoring gives x² + x + 1 after the cancellation, and substituting 1 into that adds three terms together."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'limits', 7, 'Advanced',
 'Find the limit of (√(x + 4) - 2)/x as x approaches 0.', 0,
 '[
   {"text": "1/4", "feedback": "Correct."},
   {"text": "0", "feedback": "Substituting gives 0 over 0, which is a signal to multiply by the conjugate rather than an answer."},
   {"text": "1/2", "feedback": "After multiplying by the conjugate the denominator becomes √(x + 4) + 2, and at x = 0 that comes to 4, not 2."},
   {"text": "Undefined", "feedback": "The expression is undefined at 0, but the values on either side head toward a perfectly definite number."}
 ]'::jsonb,
 null),
('MHF4U', 'rates-of-change', 'limits', 8, 'Advanced',
 'Find the limit of (3x² + 5)/(x² - 2) as x approaches infinity.', 3,
 '[
   {"text": "0", "feedback": "The top and bottom have the SAME degree, so neither runs away from the other. The ratio settles on the leading coefficients."},
   {"text": "Infinity", "feedback": "That happens when the top has the higher degree. Here the two degrees match."},
   {"text": "-5/2", "feedback": "That is the ratio of the CONSTANT terms, which is what matters as x approaches 0 rather than infinity."},
   {"text": "3", "feedback": "Correct."}
 ]'::jsonb,
 null);