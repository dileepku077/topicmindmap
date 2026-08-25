-- MCV4U part b (continued -- no delete here, part a already cleared this course's rows)

insert into public.questions
  (course_code, unit_code, subtopic_code, sort_order, difficulty,
   prompt, correct_index, options, misconception_tag)
values
('MCV4U', 'algebraic-vectors', 'applications-of-the-dot-product', 1, 'Easy',
 'Two non-zero vectors have a dot product of zero. What does that tell you?', 1,
 '[
   {"text": "They point in opposite directions", "feedback": "Opposite vectors give a negative dot product, as large in size as it can be, rather than zero."},
   {"text": "They are perpendicular to each other", "feedback": "Correct."},
   {"text": "They are parallel", "feedback": "Parallel vectors give the LARGEST possible dot product for their lengths, not zero. It is the CROSS product that vanishes when they are parallel."},
   {"text": "They are equal", "feedback": "Equal vectors have a dot product equal to the square of their magnitude, which is positive."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'applications-of-the-dot-product', 2, 'Medium',
 'A force F = [300, 700, 500] newtons moves an object through a displacement d = [3, 1, 12] metres.
How much work is done?', 0,
 '[
   {"text": "7600 J", "feedback": "Correct."},
   {"text": "6000 J", "feedback": "Only the third pair of components was multiplied. All three pairs contribute to the work."},
   {"text": "900 J", "feedback": "Only the first pair of components was multiplied."},
   {"text": "1500 J", "feedback": "Only the force components were added up. The displacement has to be paired with them component by component."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'applications-of-the-dot-product', 3, 'Challenge',
 'The diagram shows the projection of a onto b: the piece of the line carrying b that reaches the foot of the perpendicular from the head of a.
Which formula produces that piece?', 3,
 '[
   {"text": "(a dot b divided by a dot a) times a", "feedback": "That produces a piece lying along A, not along b. The picture shows the result on the other line."},
   {"text": "(a dot b) times b", "feedback": "The scaling is wrong. Without dividing by b dot b the result grows with the SQUARE of the length of b."},
   {"text": "a dot b divided by the magnitude of b", "feedback": "That is a number, the length of the projection. The picture shows a vector, so a direction has to be attached to it."},
   {"text": "(a dot b divided by b dot b) times b", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'applications-of-the-dot-product', 4, 'Challenge',
 'Let v = [4, 2, 7] and u = [6, 3, 8].
What is the MAGNITUDE of the projection of v onto u, to three decimal places?', 1,
 '[
   {"text": "4.734", "feedback": "That is the FIRST COMPONENT of the projection vector. Its magnitude uses all three components."},
   {"text": "8.237", "feedback": "Correct."},
   {"text": "10.440", "feedback": "That is the magnitude of u itself. The projection is shorter, because only part of v lies along it."},
   {"text": "86.000", "feedback": "That is the dot product of the two vectors, before any dividing has been done."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'applications-of-the-dot-product', 5, 'Advanced',
 'A force F = [300, 700, 500] newtons moves an object through d = [3, 1, 12] metres. Gravity acts along the negative z-axis.
How much work is done against gravity?', 1,
 '[
   {"text": "500 J", "feedback": "That is the vertical component of the force on its own. It still has to be multiplied by the vertical distance moved."},
   {"text": "6000 J", "feedback": "Correct."},
   {"text": "7600 J", "feedback": "That is the total work in the direction of travel. Work against gravity uses only the VERTICAL components."},
   {"text": "1600 J", "feedback": "The two horizontal pairs were used and the vertical one was left out. It is the only pair that matters here."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'applications-of-the-dot-product', 6, 'Advanced',
 'The dot product of a with b comes out negative. What does that say about the projection of a onto b?', 1,
 '[
   {"text": "It is longer than a", "feedback": "A projection is never longer than the vector being projected, whatever the sign of the dot product."},
   {"text": "It points in the opposite direction to b", "feedback": "Correct."},
   {"text": "It is the zero vector", "feedback": "That happens when the dot product is exactly zero. A negative value still leaves something to project."},
   {"text": "The two vectors are perpendicular", "feedback": "Perpendicular vectors give a dot product of exactly zero, not a negative one."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'vectors-in-three-dimensions', 1, 'Easy',
 'What is the magnitude of the vector [2, -3, 6]?', 3,
 '[
   {"text": "5", "feedback": "The components were added. A magnitude squares each one first, which removes the signs."},
   {"text": "11", "feedback": "The absolute values were added. That is not the direct distance from the origin."},
   {"text": "49", "feedback": "The square root was never taken. That is the SQUARE of the magnitude."},
   {"text": "7", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'vectors-in-three-dimensions', 2, 'Easy',
 'In three dimensions, the vector [1, 0, 0] is usually written with which single letter?', 3,
 '[
   {"text": "j", "feedback": "That is the unit vector along the y-axis, which is [0, 1, 0]."},
   {"text": "k", "feedback": "That is the unit vector along the z-axis, which is [0, 0, 1]."},
   {"text": "The zero vector", "feedback": "The zero vector has every component zero. This one has a length of 1."},
   {"text": "i", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'vectors-in-three-dimensions', 3, 'Medium',
 'What is the distance between the points (1, 2, 3) and (4, 6, 3)?', 2,
 '[
   {"text": "25", "feedback": "The square root was never taken."},
   {"text": "3", "feedback": "Only the x-difference was used. The y-coordinates differ as well."},
   {"text": "5", "feedback": "Correct."},
   {"text": "7", "feedback": "The differences were added rather than squared and rooted."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'vectors-in-three-dimensions', 4, 'Challenge',
 'What is the vector from the point (1, -2, 4) to the point (-3, 0, 5)?', 2,
 '[
   {"text": "[-2, -2, 9]", "feedback": "The two points were added. A vector between points comes from subtracting the start from the finish."},
   {"text": "[-4, -2, 1]", "feedback": "The middle component kept the sign it carried in the starting point instead of being subtracted at all."},
   {"text": "[-4, 2, 1]", "feedback": "Correct."},
   {"text": "[4, -2, -1]", "feedback": "The subtraction went the wrong way round. That vector points from the second point back to the first."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'vectors-in-three-dimensions', 5, 'Advanced',
 'What is the unit vector in the direction of [1, 2, 2]?', 0,
 '[
   {"text": "[1/3, 2/3, 2/3]", "feedback": "Correct."},
   {"text": "[1, 2, 2]", "feedback": "Its magnitude is 3, not 1. It has to be divided by that magnitude first."},
   {"text": "[1/9, 2/9, 2/9]", "feedback": "The components were divided by the SQUARE of the magnitude. The square root was never taken."},
   {"text": "[1/5, 2/5, 2/5]", "feedback": "The components were added to get the divisor. A magnitude squares each one first."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'vectors-in-three-dimensions', 6, 'Advanced',
 'What vector has magnitude 6 and points in the direction of [1, 2, 2]?', 0,
 '[
   {"text": "[2, 4, 4]", "feedback": "Correct."},
   {"text": "[6, 12, 12]", "feedback": "The original was multiplied by 6 without being reduced to unit length first. Its magnitude is already 3, so this one has magnitude 18."},
   {"text": "[3, 6, 6]", "feedback": "The original was tripled instead. That gives a magnitude of 9."},
   {"text": "[1, 2, 2]", "feedback": "That is the original, whose magnitude is 3 rather than 6."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'the-cross-product', 1, 'Easy',
 'What kind of quantity is a cross product?', 2,
 '[
   {"text": "A vector in the same plane as both of the originals", "feedback": "It leaves that plane entirely, at right angles to it. That is what makes it useful for finding a normal."},
   {"text": "An angle", "feedback": "An angle is hidden inside its magnitude, but the product itself is a vector."},
   {"text": "A vector perpendicular to both of the original vectors", "feedback": "Correct."},
   {"text": "A scalar", "feedback": "That is the DOT product. The cross product returns a vector, which is why it only exists in three dimensions."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'the-cross-product', 2, 'Easy',
 'What is i cross j?', 1,
 '[
   {"text": "The zero vector", "feedback": "A cross product vanishes only when the two vectors are collinear, and these two are at right angles."},
   {"text": "k", "feedback": "Correct."},
   {"text": "Negative k", "feedback": "The order was reversed. That is j cross i, which points the opposite way."},
   {"text": "i", "feedback": "The result has to be perpendicular to BOTH of the originals, and this one is not perpendicular to itself."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'the-cross-product', 3, 'Medium',
 'If p = [-1, 3, 2] and q = [2, -5, 6], what is p cross q?', 2,
 '[
   {"text": "[28, -10, -1]", "feedback": "The middle component came out with the wrong sign. It is the one built the opposite way round from the other two."},
   {"text": "[-2, -15, 12]", "feedback": "The components were multiplied straight across. A cross product pairs each component with the OTHER two."},
   {"text": "[28, 10, -1]", "feedback": "Correct."},
   {"text": "[-28, -10, 1]", "feedback": "The order was reversed. That is q cross p, which points the opposite way."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'the-cross-product', 4, 'Medium',
 'Two non-zero vectors have a cross product equal to the zero vector. What does that tell you?', 2,
 '[
   {"text": "They are equal", "feedback": "Equal vectors do give a zero cross product, but so do many pairs that are not equal. The condition is weaker than that."},
   {"text": "They are both unit vectors", "feedback": "Length has nothing to do with it. Two unit vectors at any angle other than zero or 180 degrees give a non-zero cross product."},
   {"text": "They are collinear, lying along the same line", "feedback": "Correct."},
   {"text": "They are perpendicular", "feedback": "Perpendicular vectors give the LARGEST possible cross product for their lengths. It is the DOT product that vanishes at right angles."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'the-cross-product', 5, 'Challenge',
 'The diagram shows two vectors a and b lying in the plane of the page, with b turned counter-clockwise from a.
In which direction does a cross b point?', 2,
 '[
   {"text": "Along a", "feedback": "A cross product is perpendicular to BOTH of the vectors it came from, so it cannot lie along either one."},
   {"text": "Along b", "feedback": "A cross product is perpendicular to BOTH of the vectors it came from, so it cannot lie along either one."},
   {"text": "Out of the page", "feedback": "Correct."},
   {"text": "Into the page", "feedback": "That is the direction of b cross a. Point your fingers along a and curl them towards b, and the thumb goes the other way."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'the-cross-product', 6, 'Advanced',
 'Vectors u and v have magnitudes 30 and 20, with an angle of 40 degrees between them.
What is the magnitude of u cross v, to two decimal places?', 3,
 '[
   {"text": "459.63", "feedback": "Cosine was used where sine belongs. Cosine is what appears in the DOT product."},
   {"text": "600.00", "feedback": "The two magnitudes were multiplied and the angle was ignored. That is the answer only when the two are perpendicular."},
   {"text": "192.84", "feedback": "The result was halved, as though a triangle had been asked for. The magnitude of a cross product is the whole parallelogram."},
   {"text": "385.67", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'the-cross-product', 7, 'Advanced',
 'How are u cross v and v cross u related?', 2,
 '[
   {"text": "They are perpendicular to each other", "feedback": "Both are perpendicular to the same plane, so they lie on the same line rather than at right angles."},
   {"text": "One is a vector and the other is a scalar", "feedback": "Both are vectors. It is the dot product that returns a number."},
   {"text": "Each one is exactly the opposite of the other", "feedback": "Correct."},
   {"text": "They are equal", "feedback": "Order matters for a cross product, unlike a dot product. Swapping the two flips the result."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'applications-of-the-cross-product', 1, 'Easy',
 'What does the magnitude of u cross v measure?', 3,
 '[
   {"text": "The area of the triangle defined by u and v", "feedback": "That is HALF of it. The parallelogram is made of two such triangles."},
   {"text": "The perimeter of the parallelogram defined by u and v", "feedback": "A perimeter is a sum of lengths, and it would not vanish when the two vectors line up. This quantity does."},
   {"text": "The volume of the box built on u and v", "feedback": "A volume needs three vectors. Two of them span a flat region."},
   {"text": "The area of the parallelogram defined by u and v", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'applications-of-the-cross-product', 2, 'Medium',
 'What is the area of the parallelogram defined by u = [4, 5, 2] and v = [3, 2, 7], to two decimal places?', 3,
 '[
   {"text": "19.33", "feedback": "That is the area of the TRIANGLE. The parallelogram is twice as big."},
   {"text": "1494.00", "feedback": "The square root was never taken. That is the sum of the squares of the components of the cross product."},
   {"text": "36.00", "feedback": "That is the DOT product of the two vectors. Area comes from the cross product."},
   {"text": "38.65", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'applications-of-the-cross-product', 3, 'Medium',
 'What is the area of the TRIANGLE defined by u = [4, 5, 2] and v = [3, 2, 7], to two decimal places?', 1,
 '[
   {"text": "9.66", "feedback": "The parallelogram area was quartered. Halving it once is enough."},
   {"text": "19.33", "feedback": "Correct."},
   {"text": "38.65", "feedback": "That is the area of the parallelogram. A triangle is half of it."},
   {"text": "77.30", "feedback": "The parallelogram area was doubled rather than halved."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'applications-of-the-cross-product', 4, 'Challenge',
 'Evaluate the triple scalar product (u cross v) dot w for u = [4, 3, 1], v = [2, 5, 6] and w = [10, -3, -14].', 0,
 '[
   {"text": "0", "feedback": "Correct."},
   {"text": "130", "feedback": "Only the first pair of components was multiplied in the final dot product. All three pairs contribute."},
   {"text": "-196", "feedback": "Only the third pair of components was multiplied in the final dot product."},
   {"text": "66", "feedback": "Only the middle pair of components was multiplied in the final dot product."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'applications-of-the-cross-product', 5, 'Challenge',
 'Three non-zero vectors have a triple scalar product of zero. What does that tell you?', 3,
 '[
   {"text": "They are mutually perpendicular", "feedback": "Three mutually perpendicular vectors build the largest possible box for their lengths, so their triple scalar product is as far from zero as it gets."},
   {"text": "They are all unit vectors", "feedback": "Length has nothing to do with it. The quantity measures a volume, and a volume can vanish at any length."},
   {"text": "Two of them are equal", "feedback": "That would force it to zero, but so would many arrangements where no two are equal. The condition is weaker than that."},
   {"text": "They all lie in the same plane", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'applications-of-the-cross-product', 6, 'Advanced',
 'The diagram shows a wrench. A force of 60 N is applied at 80 degrees to the handle, 20 cm from the centre of the bolt.
What is the magnitude of the torque, to two decimal places?', 1,
 '[
   {"text": "1181.77 N m", "feedback": "The 20 cm was never converted to metres. Torque is measured in newton metres."},
   {"text": "11.82 N m", "feedback": "Correct."},
   {"text": "12.00 N m", "feedback": "The angle was ignored, as though the force were exactly perpendicular to the handle. At 80 degrees a little of it is wasted along the handle."},
   {"text": "2.08 N m", "feedback": "Cosine was used where sine belongs. Only the part of the force ACROSS the handle turns the bolt."}
 ]'::jsonb,
 null),
('MCV4U', 'algebraic-vectors', 'applications-of-the-cross-product', 7, 'Advanced',
 'What is the volume of the parallelepiped defined by a = [6, 3, -2], b = [-4, 6, 9] and c = [3, 3, -11]?', 2,
 '[
   {"text": "1098", "feedback": "The result was doubled. That step belongs to going from a triangle to a parallelogram, not here."},
   {"text": "183", "feedback": "The result was divided by 3, as though a pyramid had been asked for. The parallelepiped is the whole box."},
   {"text": "549", "feedback": "Correct."},
   {"text": "-549", "feedback": "A volume is never negative. The triple scalar product can come out either way, and its absolute value is taken."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'equations-of-lines-in-2-space', 1, 'Easy',
 'A line passes through A(1, 4) and B(3, 1). What is a direction vector for it?', 1,
 '[
   {"text": "[1, 4]", "feedback": "That is the position vector to A. A point on the line is not the same as a direction along it."},
   {"text": "[2, -3]", "feedback": "Correct."},
   {"text": "[4, 5]", "feedback": "The two points were added. A direction comes from subtracting one from the other."},
   {"text": "[2, 3]", "feedback": "The second component lost its sign. Going from A to B the y-value drops from 4 to 1."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'equations-of-lines-in-2-space', 2, 'Medium',
 'What is a vector equation of the line through A(1, 4) and B(3, 1)?', 3,
 '[
   {"text": "[x, y] = [2, -3] + t[1, 4]", "feedback": "The point and the direction have swapped places. The point goes first, on its own."},
   {"text": "[x, y] = [1, 4] + t[3, 1]", "feedback": "The second POINT was used as a direction. A direction comes from subtracting one point from the other."},
   {"text": "[x, y] = [1, 4] + t[4, 5]", "feedback": "The two points were added to make the direction. They have to be subtracted."},
   {"text": "[x, y] = [1, 4] + t[2, -3]", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'equations-of-lines-in-2-space', 3, 'Medium',
 'Is the point (2, 3) on the line [x, y] = [1, 4] + t[2, -3]?', 0,
 '[
   {"text": "No, because the two coordinates need different values of t", "feedback": "Correct."},
   {"text": "Yes, at t = 0.5", "feedback": "That value works for the x-coordinate, but substituting it gives a y of 2.5 rather than 3. One coordinate agreeing is not enough."},
   {"text": "Yes, at t = 1", "feedback": "At that value the point is (3, 1), which is neither coordinate of the one being tested."},
   {"text": "Yes, because both coordinates lie between those of the two given points", "feedback": "Lying between two points on a line does not put you on the line; the whole plane between them is off it."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'equations-of-lines-in-2-space', 4, 'Challenge',
 'A line has parametric equations x = 3 + 2t and y = -5 + 4t. What is its scalar equation?', 1,
 '[
   {"text": "2x - y + 11 = 0", "feedback": "The constant came out with the wrong sign. Substitute (3, -5) and this one gives 22."},
   {"text": "2x - y - 11 = 0", "feedback": "Correct."},
   {"text": "4x - 2y - 11 = 0", "feedback": "The two sides were not reduced to lowest terms consistently, so the constant no longer fits. Substitute the point (3, -5) and see."},
   {"text": "2x + y - 11 = 0", "feedback": "A sign was flipped while rearranging. Substitute (3, -5) and this one gives negative 10 rather than zero."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'equations-of-lines-in-2-space', 5, 'Challenge',
 'Which vector is a direction vector for the line 3x + 2y - 11 = 0?', 3,
 '[
   {"text": "[3, 2]", "feedback": "Those are the coefficients, which give the NORMAL. A direction has to be perpendicular to it."},
   {"text": "[3, -2]", "feedback": "The signs were swapped without the components being swapped. Check the dot product with the normal: it comes out as 5, not zero."},
   {"text": "[2, 3]", "feedback": "The components were swapped but no sign was changed. Its dot product with the normal is 12, not zero."},
   {"text": "[2, -3]", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'equations-of-lines-in-2-space', 6, 'Advanced',
 'What is the distance from the point (4, 1) to the line 3x + 4y - 10 = 0?', 0,
 '[
   {"text": "1.2", "feedback": "Correct."},
   {"text": "6", "feedback": "That is the value of the left-hand side at the point, before dividing by the magnitude of the normal."},
   {"text": "5.2", "feedback": "The constant term was added when the point was substituted rather than subtracted."},
   {"text": "0", "feedback": "The point is not on the line. Substituting it gives 6, not zero."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'equations-of-lines-in-3-space', 1, 'Easy',
 'Why does a line in 3-space have no single scalar equation?', 0,
 '[
   {"text": "Because a single scalar equation in three variables describes a plane", "feedback": "Correct."},
   {"text": "Because a line in 3-space has no normal vector to build such an equation from", "feedback": "It has infinitely many normals, which is part of the difficulty; the trouble is that one equation is not restrictive enough."},
   {"text": "Because a line in 3-space needs a parameter to pin a point down", "feedback": "It does use one, but that is a consequence rather than the reason. One equation in three variables simply leaves too much freedom."},
   {"text": "Because a line in 3-space is not the graph of a function", "feedback": "Being a function has nothing to do with it. A line in 2-space is often not a function either and still has a scalar equation."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'equations-of-lines-in-3-space', 2, 'Easy',
 'For the line [x, y, z] = [1, 0, 3] + t[2, -1, 5], which point is on the line when t = 2?', 2,
 '[
   {"text": "(2, -1, 5)", "feedback": "That is the direction vector on its own. The starting point still has to be added."},
   {"text": "(1, 0, 3)", "feedback": "That is the point at t = 0. Two lots of the direction still have to be added to it."},
   {"text": "(5, -2, 13)", "feedback": "Correct."},
   {"text": "(3, -1, 8)", "feedback": "That is the point at t = 1. The parameter has to multiply every component of the direction."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'equations-of-lines-in-3-space', 3, 'Medium',
 'What are the parametric equations of the line through (2, -1, 4) with direction [3, 0, -2]?', 2,
 '[
   {"text": "x = 2 + 3t, y = -1, z = 4 + 2t", "feedback": "The sign on the third component of the direction was lost."},
   {"text": "x = 2 + 3t, y = -1 + t, z = 4 - 2t", "feedback": "The middle component of the direction is zero, so y is stuck. Nothing may be invented for it."},
   {"text": "x = 2 + 3t, y = -1, z = 4 - 2t", "feedback": "Correct."},
   {"text": "x = 3 + 2t, y = -t, z = -2 + 4t", "feedback": "The point and the direction have swapped places in every coordinate."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'equations-of-lines-in-3-space', 4, 'Medium',
 'Two lines in 3-space have non-parallel directions and never meet. What are they called?', 1,
 '[
   {"text": "Perpendicular", "feedback": "Perpendicular describes the ANGLE between two directions, and perpendicular lines in 3-space may or may not meet."},
   {"text": "Skew", "feedback": "Correct."},
   {"text": "Parallel", "feedback": "Parallel lines have directions that are scalar multiples of one another, which the question rules out."},
   {"text": "Coincident", "feedback": "Coincident lines share every point, which is the opposite of never meeting."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'equations-of-lines-in-3-space', 5, 'Challenge',
 'What are the symmetric equations of the line through (1, -2, 4) with direction [3, 5, -1]?', 2,
 '[
   {"text": "(x - 3)/1 = (y - 5)/(-2) = (z + 1)/4", "feedback": "The point and the direction have swapped places."},
   {"text": "(x - 1)/3 = (y - 2)/5 = (z - 4)/(-1)", "feedback": "The middle term is wrong. Subtracting negative 2 from y gives a plus sign there."},
   {"text": "(x - 1)/3 = (y + 2)/5 = (z - 4)/(-1)", "feedback": "Correct."},
   {"text": "(x + 1)/3 = (y - 2)/5 = (z + 4)/(-1)", "feedback": "Every sign on the point was flipped. The coordinates of the point are SUBTRACTED, so a negative coordinate becomes an addition."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'equations-of-lines-in-3-space', 6, 'Challenge',
 'Is the point (7, 8, 2) on the line [x, y, z] = [1, -2, 4] + t[3, 5, -1]?', 1,
 '[
   {"text": "Yes, at t = 6", "feedback": "The starting x was subtracted from 7, but the difference was never divided by the first component of the direction. Test any candidate in all three coordinates."},
   {"text": "Yes, at t = 2", "feedback": "Correct."},
   {"text": "No, because the coordinates need different values of t", "feedback": "They do not. One value satisfies all three, which is exactly what puts the point on the line."},
   {"text": "Yes, at t = 3", "feedback": "At that value the point is (10, 13, 1), which is not the one being tested."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'equations-of-lines-in-3-space', 7, 'Advanced',
 'What is a direction vector for the line of intersection of 2x - y + z - 1 = 0 and x + y + z - 6 = 0?', 1,
 '[
   {"text": "[1, 1, 1]", "feedback": "That is the normal of the second plane. The line of intersection lies in that plane too."},
   {"text": "[-2, -1, 3]", "feedback": "Correct."},
   {"text": "[3, 0, 2]", "feedback": "The two normals were added. A direction along the intersection has to be perpendicular to BOTH normals, which calls for a cross product."},
   {"text": "[2, -1, 1]", "feedback": "That is the normal of the first plane. The line of intersection lies IN that plane, so it is perpendicular to this."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'vector-equation-of-a-plane', 1, 'Easy',
 'How many direction vectors does the vector equation of a plane need?', 3,
 '[
   {"text": "One", "feedback": "One direction and a point gives a LINE. A plane needs a second, independent way to move."},
   {"text": "Three", "feedback": "Three directions in three-space generally fill all of space rather than a plane."},
   {"text": "None, only a normal vector is needed", "feedback": "That is enough for the SCALAR equation. The vector equation is built from directions instead."},
   {"text": "Two, and they must not be collinear", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'vector-equation-of-a-plane', 2, 'Medium',
 'Which is a vector equation of the plane through (1, 2, 3) containing the directions [1, 0, 0] and [0, 1, 0]?', 0,
 '[
   {"text": "[x, y, z] = [1, 2, 3] + s[1, 0, 0] + t[0, 1, 0]", "feedback": "Correct."},
   {"text": "[x, y, z] = [1, 2, 3] + t[1, 0, 0]", "feedback": "Only one direction was used, which describes a LINE. A plane needs two independent parameters."},
   {"text": "[x, y, z] = [1, 0, 0] + s[1, 2, 3] + t[0, 1, 0]", "feedback": "The point and the first direction have swapped places."},
   {"text": "[x, y, z] = [1, 2, 3] + s[1, 0, 0] + t[0, 1, 0] + u[0, 0, 1]", "feedback": "Three independent directions fill the whole of space rather than a plane."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'vector-equation-of-a-plane', 3, 'Challenge',
 'A plane has vector equation [x, y, z] = [1, 0, 2] + s[2, 1, 0] + t[0, 3, 1]. What is a normal vector to it?', 2,
 '[
   {"text": "[1, 0, 2]", "feedback": "That is the position vector of the given point. Where the plane sits says nothing about which way it faces."},
   {"text": "[1, 2, 6]", "feedback": "The middle component came out with the wrong sign. In a cross product it is built the opposite way round from the other two."},
   {"text": "[1, -2, 6]", "feedback": "Correct."},
   {"text": "[2, 1, 0]", "feedback": "That is one of the DIRECTIONS lying in the plane. A normal has to be perpendicular to both of them."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'vector-equation-of-a-plane', 4, 'Challenge',
 'Why must the two direction vectors in the vector equation of a plane be non-collinear?', 1,
 '[
   {"text": "Because otherwise the given point would not lie on the plane", "feedback": "The point lies on it either way, at s and t both zero. What collapses is everything else."},
   {"text": "Because two collinear directions sweep out only a line", "feedback": "Correct."},
   {"text": "Because their cross product has to come out equal to zero", "feedback": "It has to be non-zero. That cross product is exactly what supplies the normal, and collinear directions would leave you without one."},
   {"text": "Because the normal vector is required to have magnitude 1", "feedback": "A normal of any length will do. The requirement is that a normal exists at all."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'vector-equation-of-a-plane', 5, 'Advanced',
 'Which plane does [x, y, z] = [0, 0, 0] + s[1, 1, 0] + t[1, -1, 0] describe?', 3,
 '[
   {"text": "The xz-plane, y = 0", "feedback": "The two directions were subtracted and the difference read off as a normal. A normal has to be perpendicular to both directions, and that difference is perpendicular to neither."},
   {"text": "The plane x + y = 0", "feedback": "That would be a plane containing the z-axis, and neither of these directions has any z-component at all."},
   {"text": "A line through the origin", "feedback": "The two directions are not multiples of one another, so together they sweep out a full plane rather than a line."},
   {"text": "The xy-plane, z = 0", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'scalar-equation-of-a-plane', 1, 'Easy',
 'In the plane equation Ax + By + Cz + D = 0, what does [A, B, C] represent?', 2,
 '[
   {"text": "One of the points on the plane", "feedback": "Nothing in the coefficients names a point. D shifts the plane, but a point has to be found by substituting."},
   {"text": "The position vector of the origin", "feedback": "That is the zero vector, which has no direction at all."},
   {"text": "A normal vector to the plane", "feedback": "Correct."},
   {"text": "A direction vector lying in the plane", "feedback": "It is the exact opposite: it is perpendicular to every direction lying in the plane. This is the single most common mix-up in the unit."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'scalar-equation-of-a-plane', 2, 'Easy',
 'What is a normal vector to the plane 3x - 2y + z - 7 = 0?', 0,
 '[
   {"text": "[3, -2, 1]", "feedback": "Correct."},
   {"text": "[3, -2, -7]", "feedback": "The constant term was collected as a component. Only the three coefficients of x, y and z make up the normal."},
   {"text": "[3, 2, 1]", "feedback": "The sign on the middle component was lost. It has to be read straight off the equation."},
   {"text": "[1, -2, 3]", "feedback": "The first and third components were swapped. They belong to x and z in the order they appear."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'scalar-equation-of-a-plane', 3, 'Medium',
 'What is the scalar equation of the plane through (2, -1, 5) with normal [3, 4, -2]?', 1,
 '[
   {"text": "3x + 4y - 2z = 0", "feedback": "The constant was left out, which puts the plane through the origin instead of through the given point."},
   {"text": "3x + 4y - 2z + 8 = 0", "feedback": "Correct."},
   {"text": "3x + 4y - 2z - 8 = 0", "feedback": "The constant was copied with the sign of the substitution instead of the sign that cancels it. Put (2, -1, 5) into this equation and the left side does not come out as zero."},
   {"text": "2x - y + 5z + 8 = 0", "feedback": "The POINT was used as the coefficients. The normal supplies them; the point only fixes the constant."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'scalar-equation-of-a-plane', 4, 'Medium',
 'Are the planes 2x - 6y + 4z - 7 = 0 and 3x - 9y + 6z - 2 = 0 parallel?', 3,
 '[
   {"text": "No, because their constant terms are different numbers", "feedback": "The constants decide whether they are the same plane or two distinct ones. Being parallel is decided by the normals alone."},
   {"text": "No, because their coefficients are not the same numbers as one another", "feedback": "Different numbers can still be in the same ratio. Divide one set by the other and every quotient comes out the same."},
   {"text": "No, they are perpendicular to one another", "feedback": "Perpendicular planes have normals with a dot product of zero. These two normals point the same way."},
   {"text": "Yes, because their normal vectors are scalar multiples of one another", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'scalar-equation-of-a-plane', 5, 'Challenge',
 'What is the scalar equation of the plane through (1, 0, 2) containing the directions [2, 1, 0] and [0, 3, 1]?', 1,
 '[
   {"text": "x + 2y + 6z - 13 = 0", "feedback": "The middle coefficient came out with the wrong sign in the cross product. It is built the opposite way round from the other two."},
   {"text": "x - 2y + 6z - 13 = 0", "feedback": "Correct."},
   {"text": "x - 2y + 6z + 13 = 0", "feedback": "The constant was copied with the sign of the substitution instead of the sign that cancels it. Put (1, 0, 2) into this equation and the left side does not come out as zero."},
   {"text": "2x + y + 0z - 2 = 0", "feedback": "One of the DIRECTIONS was used as the normal. A normal is perpendicular to both directions, which means taking their cross product first."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'scalar-equation-of-a-plane', 6, 'Challenge',
 'What is the angle between the planes x + y + z = 0 and x - y = 0?', 0,
 '[
   {"text": "90 degrees", "feedback": "Correct."},
   {"text": "45 degrees", "feedback": "That would be the angle if the normals had a dot product equal to the product of one magnitude with the other over root 2. Here the dot product is exactly zero."},
   {"text": "60 degrees", "feedback": "The dot product of the two normals is zero, which forces the cosine to zero and the angle to a right angle."},
   {"text": "0 degrees", "feedback": "That would need the normals to be parallel, and one has a z-component while the other does not."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'scalar-equation-of-a-plane', 7, 'Advanced',
 'What is the scalar equation of the plane through the points (1, 0, 0), (0, 1, 0) and (0, 0, 1)?', 0,
 '[
   {"text": "x + y + z - 1 = 0", "feedback": "Correct."},
   {"text": "x + y + z = 0", "feedback": "That plane passes through the origin, and none of the three given points is the origin. Substitute any one of them and it gives 1."},
   {"text": "x + y + z - 3 = 0", "feedback": "The three coordinates were added across all three points. Substituting one point into the first three terms gives 1, so the constant is negative 1."},
   {"text": "x - y + z - 1 = 0", "feedback": "A sign was flipped in the normal. Substituting the second point gives negative 2 rather than zero."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'scalar-equation-of-a-plane', 8, 'Advanced',
 'What is the distance from the origin to the plane 2x - y + 2z - 9 = 0?', 2,
 '[
   {"text": "1", "feedback": "The divisor was the sum of the SQUARES of the components, with the square root never taken."},
   {"text": "4.5", "feedback": "Only the first component of the normal was used as the divisor. The whole magnitude of the normal belongs underneath."},
   {"text": "3", "feedback": "Correct."},
   {"text": "9", "feedback": "That is the size of the constant term, before dividing by the magnitude of the normal."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'intersections-of-lines', 1, 'Easy',
 'Two lines in 2-space have direction vectors that are not parallel. In how many points do they intersect?', 2,
 '[
   {"text": "Infinitely many", "feedback": "That would make them the same line, which would need their directions to be parallel."},
   {"text": "Two", "feedback": "Two straight lines that meet twice would have to be the same line. Straight lines cross at most once."},
   {"text": "Exactly one", "feedback": "Correct."},
   {"text": "None", "feedback": "That happens when the directions ARE parallel and the lines are distinct. Non-parallel lines in a plane cannot avoid each other."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'intersections-of-lines', 2, 'Medium',
 'How are the lines [x, y] = [1, 2] + t[3, 1] and [x, y] = [0, 5] + s[6, 2] related?', 0,
 '[
   {"text": "Parallel and distinct, so they never meet", "feedback": "Correct."},
   {"text": "They meet at exactly one point", "feedback": "The second direction is twice the first, so the lines never converge. Two parallel lines meet only if they are the same line."},
   {"text": "Coincident, so they meet everywhere", "feedback": "The directions do match, but the point (0, 5) is not on the first line. Substituting its x-value gives a y of five thirds."},
   {"text": "Skew", "feedback": "Skew is only possible in 3-space. Two lines in a plane are either parallel or they cross."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'intersections-of-lines', 3, 'Challenge',
 'How are the lines [x, y, z] = [1, 0, 2] + t[1, 2, -1] and [x, y, z] = [2, 3, 1] + s[2, 4, -2] related?', 3,
 '[
   {"text": "They meet at exactly one point", "feedback": "The second direction is twice the first, so the lines never converge on each other."},
   {"text": "Coincident, so they meet everywhere", "feedback": "The directions do match, but (2, 3, 1) is not on the first line. Its x-coordinate needs t equal to 1, and that gives a y of 2 rather than 3."},
   {"text": "Skew", "feedback": "Skew lines have non-parallel directions. These two directions are multiples of one another."},
   {"text": "Parallel and distinct, so they never meet", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'intersections-of-lines', 4, 'Advanced',
 'How are the lines [x, y, z] = [1, 0, 2] + t[1, 2, -1] and [x, y, z] = [0, 1, 1] + s[2, 1, 1] related?', 2,
 '[
   {"text": "They are parallel and distinct", "feedback": "The two directions are not multiples of one another, so the lines are not parallel."},
   {"text": "They are coincident", "feedback": "Coincident lines share every point, and these two share none at all."},
   {"text": "They are skew", "feedback": "Correct."},
   {"text": "They meet at exactly one point", "feedback": "Two of the three equations can be satisfied together, at t equal to two thirds, but the first one then fails. All three have to agree."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'intersections-of-lines', 5, 'Advanced',
 'Two lines in 2-space have the same direction vector and share one point. How are they related?', 3,
 '[
   {"text": "They are parallel and distinct, so they never share a point", "feedback": "Distinct parallel lines share NO points. One shared point plus a common direction forces the rest to follow."},
   {"text": "They meet at exactly one point", "feedback": "That needs different directions. With the same direction, one shared point drags the whole line along."},
   {"text": "They are skew", "feedback": "Skew is only possible in 3-space, and skew lines never meet at all."},
   {"text": "They are coincident, so they share every point", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'intersections-of-lines', 6, 'Advanced',
 'Two lines in 3-space have direction vectors that are not parallel. What can be concluded?', 0,
 '[
   {"text": "They either meet at exactly one point or they are skew", "feedback": "Correct."},
   {"text": "They must meet at exactly one point, since they are not parallel", "feedback": "That is what happens in 2-space. In three dimensions two lines can pass each other at different heights without ever touching."},
   {"text": "They must be skew, so they never meet at any point", "feedback": "They may well meet. Non-parallel directions leave both possibilities open, which is why the system has to be solved."},
   {"text": "They must be parallel", "feedback": "The question rules that out: parallel lines have directions that are scalar multiples of one another."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'intersections-of-planes', 1, 'Easy',
 'Two distinct planes have normal vectors that are not parallel. What is their intersection?', 0,
 '[
   {"text": "A line", "feedback": "Correct."},
   {"text": "A single point", "feedback": "Two planes never meet in just a point. Once they share one point they share a whole line through it."},
   {"text": "A plane", "feedback": "That would make them the same plane, which the question rules out by calling them distinct."},
   {"text": "Nothing", "feedback": "That happens only when the normals ARE parallel and the planes are distinct."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'intersections-of-planes', 2, 'Easy',
 'Two plane equations are scalar multiples of one another. What does that mean geometrically?', 2,
 '[
   {"text": "They meet in a line", "feedback": "That needs the normals to point in different directions, and multiples of one another point the same way."},
   {"text": "They are perpendicular", "feedback": "Perpendicular planes have normals with a dot product of zero, which multiples of each other never manage."},
   {"text": "They are the same plane, so every point of one lies on the other", "feedback": "Correct."},
   {"text": "They are parallel and distinct planes, so they never meet at any point", "feedback": "Parallel and distinct planes have normals that are multiples but constants that are NOT in the same ratio. Here the whole equation matches."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'intersections-of-planes', 3, 'Medium',
 'How do the planes 2x - y + z - 1 = 0 and x + y + z - 6 = 0 intersect?', 3,
 '[
   {"text": "At a single point", "feedback": "Two planes never meet in one point alone. Once they share a point they share the whole line through it."},
   {"text": "They do not intersect", "feedback": "That needs parallel normals, and these two are not multiples of one another."},
   {"text": "They are the same plane", "feedback": "The two equations are not multiples of each other, so they describe different planes."},
   {"text": "In a line", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'intersections-of-planes', 4, 'Medium',
 'How do the planes x + y - 2z + 2 = 0 and 2x + 2y - 4z + 4 = 0 intersect?', 1,
 '[
   {"text": "They meet at a single point, and nowhere else", "feedback": "Two planes never meet in one point alone."},
   {"text": "They are coincident, so every point of one lies on the other", "feedback": "Correct."},
   {"text": "They intersect in a line, and share every point along that line", "feedback": "That needs the normals to point in different directions. Here the second equation is exactly twice the first."},
   {"text": "They do not intersect, so they have no point in common", "feedback": "That would make them parallel and distinct, which needs the constants to be in a different ratio from the coefficients. Here every ratio is 2."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'intersections-of-planes', 5, 'Challenge',
 'Two planes are parallel and distinct. How many solutions does the system of their two equations have?', 1,
 '[
   {"text": "Two", "feedback": "A system of linear equations has no solutions, one solution or infinitely many. Two is never available."},
   {"text": "None", "feedback": "Correct."},
   {"text": "Exactly one", "feedback": "Two planes never share exactly one point, whether they are parallel or not."},
   {"text": "Infinitely many", "feedback": "That happens when the two are COINCIDENT. Distinct parallel planes share nothing at all."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'intersections-of-planes', 6, 'Advanced',
 'Three planes have normals that are neither parallel nor coplanar. How do they intersect?', 3,
 '[
   {"text": "In a line", "feedback": "That is the case where the normals are not parallel but ARE coplanar. Here they are independent enough to pin down a single point."},
   {"text": "In a plane", "feedback": "That needs all three equations to be multiples of one another, which would make the normals parallel."},
   {"text": "They do not intersect", "feedback": "Independent normals guarantee a solution. It is when the normals become coplanar that a system can turn inconsistent."},
   {"text": "At exactly one point", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MCV4U', 'lines-and-planes', 'intersections-of-planes', 7, 'Advanced',
 'How do you test whether the normals of three planes are coplanar?', 2,
 '[
   {"text": "Check whether all three are unit vectors", "feedback": "Length has nothing to do with it. Scaling a normal does not move the plane it belongs to."},
   {"text": "Check whether the three normals add together to give exactly the zero vector", "feedback": "That would force them to be coplanar, but plenty of coplanar triples do not add to zero. The test is too strict."},
   {"text": "Check whether the triple scalar product of the three normals is zero", "feedback": "Correct."},
   {"text": "Check whether all three pairwise dot products come out as zero", "feedback": "That tests whether they are mutually perpendicular, which is as far from coplanar as three vectors can get."}
 ]'::jsonb,
 null);