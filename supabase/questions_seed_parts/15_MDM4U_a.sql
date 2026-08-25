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


delete from public.questions where course_code = 'MDM4U';

insert into public.questions
  (course_code, unit_code, subtopic_code, sort_order, difficulty,
   prompt, correct_index, options, misconception_tag)
values
('MDM4U', 'displays-of-data', 'populations-samples-and-types-of-data', 1, 'Easy',
 'What is the difference between a population and a sample?', 0,
 '[
   {"text": "A sample is a subset of the population", "feedback": "Correct."},
   {"text": "A population is a subset of the sample", "feedback": "The two terms have been exchanged here. Go back to what each word names before deciding which one sits inside the other."},
   {"text": "They are two words for the same thing", "feedback": "If they were the same there would be no need for statistics at all: you could just measure everybody."},
   {"text": "A population is any group of more than a thousand", "feedback": "Size has nothing to do with it. A population is whatever whole group the question is about, however small."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'populations-samples-and-types-of-data', 2, 'Easy',
 'Eye colour is which type of data?', 3,
 '[
   {"text": "Numeric and discrete", "feedback": "Discrete numeric data are counts. Eye colour has no number attached to it at all."},
   {"text": "Numeric and continuous", "feedback": "Continuous numeric data come from measuring. Eye colour is a label rather than a measurement."},
   {"text": "A statistic", "feedback": "A statistic is a number CALCULATED from data. This is the data itself."},
   {"text": "Categoric", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'populations-samples-and-types-of-data', 3, 'Medium',
 'A value calculated from a sample is called what?', 1,
 '[
   {"text": "A census", "feedback": "A census is the ACT of measuring everybody, not a number that comes out of it."},
   {"text": "A statistic", "feedback": "Correct."},
   {"text": "A parameter", "feedback": "A parameter describes the whole POPULATION. It is usually the thing you cannot measure and are trying to estimate."},
   {"text": "A population", "feedback": "A population is the group itself, not a number computed from it."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'populations-samples-and-types-of-data', 4, 'Medium',
 'The number of siblings a student has is which type of data?', 1,
 '[
   {"text": "A parameter", "feedback": "A parameter is a number describing a whole population. This is a measurement on one person."},
   {"text": "Numeric and discrete", "feedback": "Correct."},
   {"text": "Numeric and continuous", "feedback": "Continuous data can take any value in a range. Nobody has 2.4 siblings."},
   {"text": "Categoric", "feedback": "The values are genuine numbers that can be added and averaged, which categories cannot."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'populations-samples-and-types-of-data', 5, 'Challenge',
 'What distinguishes inferential statistics from descriptive statistics?', 2,
 '[
   {"text": "Inferential statistics only summarise the data collected", "feedback": "This is the job of DESCRIPTIVE statistics, attached to the wrong name."},
   {"text": "They are two names for the same activity", "feedback": "They answer different questions. One says what this data looks like; the other says what it suggests about everyone else."},
   {"text": "Inferential statistics draw conclusions about a population from a sample", "feedback": "Correct."},
   {"text": "Descriptive statistics draw conclusions about a population from a sample", "feedback": "Descriptive statistics stay inside the data that was actually collected. Reaching past the sample is not part of what they do."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'populations-samples-and-types-of-data', 6, 'Challenge',
 'A researcher measures every single member of the population. What is that called?', 2,
 '[
   {"text": "A statistic", "feedback": "A statistic is a NUMBER computed from data, not the method of collecting it."},
   {"text": "An experiment", "feedback": "An experiment imposes a treatment on its subjects. Measuring everyone imposes nothing."},
   {"text": "A census", "feedback": "Correct."},
   {"text": "A sample", "feedback": "A sample deliberately leaves people out. Nobody is left out here."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'populations-samples-and-types-of-data', 7, 'Advanced',
 'Which of these is a PARAMETER rather than a statistic?', 1,
 '[
   {"text": "The standard deviation of the 200 sampled heights", "feedback": "Any number computed from a sample is a statistic, whichever measure it is."},
   {"text": "The mean height of every student in Ontario", "feedback": "Correct."},
   {"text": "The mean height of 200 randomly chosen students", "feedback": "That comes from a sample, which makes it a statistic. It is an estimate of the parameter rather than the parameter itself."},
   {"text": "The number of students included in the sample", "feedback": "That is a fact about the sample, so it is a statistic. It says nothing about the population."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'displaying-categoric-data', 1, 'Easy',
 'Which display is designed for categoric data?', 1,
 '[
   {"text": "A scatter plot", "feedback": "A scatter plot pairs two numeric variables against each other."},
   {"text": "A bar graph", "feedback": "Correct."},
   {"text": "A frequency histogram", "feedback": "A histogram needs intervals along its horizontal axis, which only numeric data can supply."},
   {"text": "A box-and-whisker plot", "feedback": "A box plot is built from quartiles, and quartiles need the data to be ordered by size."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'displaying-categoric-data', 2, 'Medium',
 'When is a pie chart NOT an appropriate display?', 0,
 '[
   {"text": "When the categories do not together make up a single whole", "feedback": "Correct."},
   {"text": "When there are more than four categories", "feedback": "Many categories make a pie chart hard to read, but that is a matter of clarity rather than correctness."},
   {"text": "When the data come from a sample of the group rather than from a full census", "feedback": "Where the data came from has no bearing on which display suits them."},
   {"text": "When the percentages are already known", "feedback": "Knowing the percentages is exactly what makes a pie chart easy to build."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'displaying-categoric-data', 3, 'Challenge',
 'How are the bars of a Pareto chart ordered?', 1,
 '[
   {"text": "By the order in which the data were collected", "feedback": "Collection order carries no meaning for categories, and it is not what defines a Pareto chart."},
   {"text": "From tallest to shortest", "feedback": "Correct."},
   {"text": "From shortest to tallest", "feedback": "The sort is by size but it runs the wrong way. Check which end of a Pareto chart is meant to carry the emphasis."},
   {"text": "Alphabetically by category name", "feedback": "Alphabetical order is a plain bar graph. A Pareto chart sorts by size on purpose."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'displaying-categoric-data', 4, 'Challenge',
 'What is the main advantage a bar graph has over a pie chart when comparing the sizes of categories accurately?', 0,
 '[
   {"text": "People judge lengths far more accurately than they judge angles or areas", "feedback": "Correct."},
   {"text": "A bar graph can show a larger number of categories at once than a pie chart can", "feedback": "It usually can, but that is a matter of room rather than accuracy. The real gain is in how the eye reads the shape."},
   {"text": "A bar graph can use colour", "feedback": "Both can, and colour is decoration rather than information."},
   {"text": "A bar graph shows percentages and a pie chart does not", "feedback": "A pie chart is built out of percentages. Either display can be labelled with them."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'displaying-categoric-data', 5, 'Advanced',
 'A survey asks people to name their favourite of five sports, and 15 per cent answer Other.
Is a pie chart appropriate?', 3,
 '[
   {"text": "No, because Other is not a real category", "feedback": "It is a perfectly real category for this purpose: it holds everybody the first five miss, which is what keeps the total complete."},
   {"text": "No, because six separate categories are far too many for a single pie chart to show clearly", "feedback": "Six is comfortably readable. Nothing about the count rules the display out."},
   {"text": "Only if the Other group is left out first", "feedback": "Dropping it is the one thing that would break the chart, because the remaining slices would no longer add to a whole."},
   {"text": "Yes, because every person falls into exactly one category and the six add to the whole", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'displaying-categoric-data', 6, 'Advanced',
 'Why should every bar in a bar graph be drawn the same width?', 2,
 '[
   {"text": "Because graphing software requires it", "feedback": "Software will happily draw uneven bars. The requirement comes from honesty, not from the tool."},
   {"text": "Because the categories have to be equally likely", "feedback": "Categories are almost never equally likely, and a bar graph exists precisely to show that they are not."},
   {"text": "Because a reader judges by area as well as height, so unequal widths distort the comparison", "feedback": "Correct."},
   {"text": "Because otherwise the bars will not fit on the page", "feedback": "Fitting is a practical matter and can always be solved by rescaling. The reason is about how the picture is read."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'displaying-numeric-data', 1, 'Easy',
 'Why do the bars of a histogram touch when the bars of a bar graph do not?', 3,
 '[
   {"text": "Because a histogram always has more bars", "feedback": "It may have fewer. The number of bars has nothing to do with whether they touch."},
   {"text": "It is only a matter of style", "feedback": "It carries real information: the gaps in a bar graph say the categories are separate things rather than neighbouring stretches of a number line."},
   {"text": "Because a histogram is always sorted in order from the tallest bar down to the shortest bar", "feedback": "A histogram is sorted by VALUE along the axis, which often puts the tallest bar in the middle."},
   {"text": "Because a histogram covers a continuous run of intervals with no gaps between them", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'displaying-numeric-data', 2, 'Easy',
 'What does a stem-and-leaf plot keep that a histogram throws away?', 2,
 '[
   {"text": "The range", "feedback": "A histogram shows the range perfectly well, from the left edge of the first bar to the right edge of the last."},
   {"text": "The median", "feedback": "Neither one marks the median directly. The difference is that a stem-and-leaf plot lets you count to it exactly."},
   {"text": "The individual data values", "feedback": "Correct."},
   {"text": "The overall shape of the distribution", "feedback": "Both show the shape. Turn a stem-and-leaf plot on its side and it looks like a histogram."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'displaying-numeric-data', 3, 'Medium',
 'A distribution has a long tail stretching to the right. What is its shape called?', 2,
 '[
   {"text": "Symmetric about its centre", "feedback": "A symmetric distribution has matching tails on both sides."},
   {"text": "Bimodal", "feedback": "Bimodal means two separate peaks. A long tail is not a second peak."},
   {"text": "Skewed right", "feedback": "Correct."},
   {"text": "Skewed left", "feedback": "This names the shape after the side where the data pile up. That is not the convention the names follow."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'displaying-numeric-data', 4, 'Medium',
 'In a distribution that is skewed right, which is larger, the mean or the median?', 0,
 '[
   {"text": "The mean", "feedback": "Correct."},
   {"text": "The median", "feedback": "A median only counts positions, so a long tail barely shifts it. Ask which of the two measures actually adds the extreme values in."},
   {"text": "They are equal", "feedback": "They are equal in a symmetric distribution. Skew is exactly what separates them."},
   {"text": "It depends on the sample size", "feedback": "Sample size does not decide the direction. A tail on one side pulls the two measures apart the same way at any size."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'displaying-numeric-data', 5, 'Challenge',
 'A data set is 3, 7, 7, 8, 12, 15, 21.
What are the median and the interquartile range?', 3,
 '[
   {"text": "Median 8 and IQR 18", "feedback": "The median is right but the RANGE was reported instead of the interquartile range. The IQR uses the quartiles, not the extremes."},
   {"text": "Median 10.4 and IQR 8", "feedback": "The IQR is right but the MEAN was reported instead of the median. The median is the middle value once the data are in order."},
   {"text": "Median 7 and IQR 8", "feedback": "The middle of seven values is the fourth one, not the third."},
   {"text": "Median 8 and IQR 8", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'displaying-numeric-data', 6, 'Challenge',
 'On a box plot the right-hand whisker is much longer than the left-hand one. What does that say about the distribution?', 1,
 '[
   {"text": "It is bimodal", "feedback": "A box plot cannot show a second peak at all, so it can never be the evidence for bimodality."},
   {"text": "It is skewed right", "feedback": "Correct."},
   {"text": "It is skewed left", "feedback": "This takes the direction from the wrong end of the plot."},
   {"text": "It is symmetric about its centre", "feedback": "Symmetric distributions have whiskers of similar length on both sides."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'displaying-numeric-data', 7, 'Advanced',
 'A data set is 4, 8, 9, 11, 14, 40.
Which measure of centre represents it best, and why?', 1,
 '[
   {"text": "The range, because it shows how spread out the data are", "feedback": "The range is a measure of SPREAD rather than of centre, and the outlier distorts it too."},
   {"text": "The median, because the 40 is an outlier that drags the mean upward", "feedback": "Correct."},
   {"text": "The mean, because it uses every value in the data", "feedback": "Using every value is exactly the weakness here. One unusual value pulls the mean above five of the six numbers."},
   {"text": "The mode, because it is the value that occurs most often", "feedback": "Every value here occurs once, so there is no mode to report."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'scatter-plots-and-correlation', 1, 'Easy',
 'On a scatter plot the points cluster tightly around a line that falls to the right. What does that indicate?', 3,
 '[
   {"text": "A strong positive correlation", "feedback": "Positive means the two rise together. Here one falls as the other rises."},
   {"text": "A weak negative correlation", "feedback": "The direction is right but not the strength. Weak means the points are scattered widely about the line, and these are tight to it."},
   {"text": "No correlation", "feedback": "No correlation means no line describes the points at all. Here one describes them well."},
   {"text": "A strong negative correlation", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'scatter-plots-and-correlation', 2, 'Easy',
 'A strong correlation between two variables does not establish what?', 2,
 '[
   {"text": "That there is a pattern in the data", "feedback": "A pattern is what a strong correlation reports."},
   {"text": "That the two move together", "feedback": "Moving together is what correlation measures."},
   {"text": "That one causes the other", "feedback": "Correct."},
   {"text": "That the two are associated", "feedback": "Association is exactly what a correlation does establish. It is the step beyond it that fails."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'scatter-plots-and-correlation', 3, 'Medium',
 'What does a correlation coefficient of -0.92 describe?', 2,
 '[
   {"text": "A strong positive linear relationship", "feedback": "The size is right but the sign says the two move in opposite directions."},
   {"text": "No relationship", "feedback": "That is what a value near zero means. This one is near the extreme."},
   {"text": "A strong negative linear relationship", "feedback": "Correct."},
   {"text": "A weak negative linear relationship", "feedback": "The strength is read from the SIZE, ignoring the sign, and 0.92 is close to 1."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'scatter-plots-and-correlation', 4, 'Medium',
 'The scatter plot shows a clear pattern, yet the correlation coefficient for this data is close to zero.
How can both be true?', 0,
 '[
   {"text": "Because r only measures how well a STRAIGHT line fits, and this pattern is curved", "feedback": "Correct."},
   {"text": "Because there must be an error in the calculation", "feedback": "This treats a value that surprises you as an arithmetic slip. Nothing has gone wrong in the computing of r."},
   {"text": "Because the sample is too small for r to be meaningful", "feedback": "This blames the sample size. A thousand more points following the same pattern would leave r exactly where it is."},
   {"text": "Because the two variables are not really related", "feedback": "This reads r near zero as a verdict on the whole plot, which contradicts the clear pattern the question describes."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'scatter-plots-and-correlation', 5, 'Challenge',
 'Ice cream sales and drowning deaths both rise and fall together across the year, giving r = 0.9.
What is the best explanation?', 0,
 '[
   {"text": "A lurking variable, the season, drives both", "feedback": "Correct."},
   {"text": "Eating ice cream makes people more likely to drown", "feedback": "This is the causal reading, and it is the trap the whole lesson exists to set. A third factor moves both at once."},
   {"text": "The drownings are what cause ice cream sales to rise", "feedback": "Reversing the direction does not rescue a causal claim that was never supported."},
   {"text": "The correlation must have been calculated incorrectly", "feedback": "The number is real. What is wrong is the story people attach to it."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'scatter-plots-and-correlation', 6, 'Advanced',
 'Two variables have a correlation coefficient of 0.05, yet their scatter plot shows the points sitting on a near-perfect curve.
What does that tell you?', 3,
 '[
   {"text": "There is essentially no relationship between the two variables", "feedback": "The picture says otherwise. A near-perfect curve is about as strong a relationship as data can show."},
   {"text": "The data must have been recorded incorrectly", "feedback": "Nothing is wrong with the data. The mismatch is between what r measures and what the data does."},
   {"text": "The correlation coefficient should have come out as 1", "feedback": "It would if the pattern were a straight line. On a symmetric curve the best straight fit really is flat."},
   {"text": "The relationship is strong but not linear, and r only measures the linear part", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'scatter-plots-and-correlation', 7, 'Advanced',
 'Two variables have a correlation coefficient of exactly zero. Can they still be related?', 1,
 '[
   {"text": "Only if one of the variables is categoric", "feedback": "A correlation coefficient is only computed for two numeric variables in the first place."},
   {"text": "Yes, because a non-linear relationship can give a correlation of zero", "feedback": "Correct."},
   {"text": "No, a coefficient of zero rules out any relationship", "feedback": "This reads a zero coefficient as a verdict on relationships of every kind. Check what r is actually built to detect."},
   {"text": "Only if the sample is very small", "feedback": "Sample size does not change the point. A coefficient of zero carries the same meaning whatever the size of the sample."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'linear-regression', 1, 'Easy',
 'What is the line of best fit on a scatter plot?', 0,
 '[
   {"text": "The straight line that comes closest to all the points", "feedback": "Correct."},
   {"text": "The straight line joining the first point to the last point", "feedback": "Two points cannot speak for the rest. Every point in the set has a say in where the line sits."},
   {"text": "The line that passes through the greatest number of points", "feedback": "Counting hits is not the test. A few points that happen to fall in a row can drag such a line into a direction the rest of the data never goes."},
   {"text": "The line that separates the points into two equal halves", "feedback": "Splitting the count evenly is not the aim. Endlessly many different lines put half the points above and half below, so this condition never picks out a single one."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'linear-regression', 2, 'Medium',
 'A regression on age against annual income gives r = 0.9825.
What is the coefficient of determination, to four decimal places?', 2,
 '[
   {"text": "0.9825", "feedback": "That is r itself, copied across without being squared."},
   {"text": "1.9650", "feedback": "The value was doubled rather than squared."},
   {"text": "0.9653", "feedback": "Correct."},
   {"text": "0.9912", "feedback": "The square ROOT was taken instead of the square. Squaring a number below 1 makes it smaller, not larger."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'linear-regression', 3, 'Medium',
 'A regression of income on age gives a coefficient of determination of 0.9654. What does that mean?', 0,
 '[
   {"text": "About 96.5 per cent of the variation in income is explained by the linear relationship with age", "feedback": "Correct."},
   {"text": "About 96.5 per cent of the data points lie exactly on the line", "feedback": "No count of points is involved. Often none of them lie exactly on the line."},
   {"text": "The correlation between age and income is 96.5 per cent", "feedback": "That describes r, and r is the square root of this value rather than this value."},
   {"text": "The slope of the line of best fit is 0.965", "feedback": "The slope is a separate number carried in dollars per year. This one has no units at all."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'linear-regression', 4, 'Challenge',
 'For eight employees, income in thousands against age fits the line y = -0.864 + 1.150x.
What income does it predict for a 65-year-old, to two decimal places?', 0,
 '[
   {"text": "73.89 thousand", "feedback": "Correct."},
   {"text": "74.75 thousand", "feedback": "The intercept was left out. The line is not just the slope times the age."},
   {"text": "75.61 thousand", "feedback": "The intercept was added instead of subtracted. It is negative in this equation."},
   {"text": "64.14 thousand", "feedback": "The intercept was subtracted from the age rather than from the slope times the age."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'linear-regression', 5, 'Challenge',
 'What is a residual in linear regression?', 1,
 '[
   {"text": "The difference between the largest and the smallest y-value", "feedback": "That is the range of the data, which has nothing to do with the line."},
   {"text": "The observed value minus the value the line predicts", "feedback": "Correct."},
   {"text": "The horizontal distance from a data point to the line", "feedback": "Regression measures vertically, because the line is being used to predict y from x."},
   {"text": "The slope of the line of best fit", "feedback": "The slope is one number for the whole line. There is one residual for every data point."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'linear-regression', 6, 'Advanced',
 'The line y = -0.864 + 1.150x was fitted to employees aged between 19 and 54.
What is wrong with using it to predict the income of a 5-year-old?', 3,
 '[
   {"text": "It is interpolation, and interpolation is always unreliable", "feedback": "Interpolation means predicting INSIDE the range of the data, which this is not, and it is generally the reliable case."},
   {"text": "It is extrapolation, but extrapolation is perfectly reliable so long as the correlation is strong", "feedback": "A strong correlation says the line fits the data you HAVE. It promises nothing about a region no data ever came from."},
   {"text": "Nothing is wrong, because the line is defined for every value of x", "feedback": "The equation is defined everywhere; the RELATIONSHIP it describes was only ever observed over a narrow band of ages."},
   {"text": "It is extrapolation: 5 lies far outside the range of the data, so the pattern may not hold there", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'linear-regression', 7, 'Advanced',
 'For income in thousands of dollars against age in years, the line of best fit has slope 1.150.
What does that slope mean in context?', 2,
 '[
   {"text": "The income of a person aged zero is about 1150 dollars", "feedback": "That is what the INTERCEPT would say, and here the intercept is negative."},
   {"text": "Income rises by about 1.15 per cent for each additional year", "feedback": "The slope is in the units of the data, which are thousands of dollars per year, not a percentage."},
   {"text": "Each additional year of age is associated with about 1150 dollars more annual income", "feedback": "Correct."},
   {"text": "Each additional year of age CAUSES about 1150 dollars more annual income", "feedback": "The arithmetic is right and the claim is not. A regression line describes an association; it cannot establish a cause."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'misleading-graphs', 1, 'Easy',
 'A bar chart has a vertical axis that starts at 40 rather than at zero. What effect does that have?', 3,
 '[
   {"text": "It understates the differences between the bars", "feedback": "This assumes the cut takes something away from each difference. The part removed is the part every bar shares, and the gaps between the bar tops are untouched by it."},
   {"text": "It has no effect, as long as the axis is labelled", "feedback": "A label helps a careful reader, but the shape of the picture still says something the numbers do not."},
   {"text": "It makes the bar heights proportional to the values", "feedback": "That is what starting at zero achieves. Starting anywhere else destroys the proportionality."},
   {"text": "It exaggerates the differences between the bars", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'misleading-graphs', 2, 'Medium',
 'A pictograph shows a doubling by drawing an icon at twice the width AND twice the height.
What is wrong with that?', 3,
 '[
   {"text": "Nothing is wrong here, since both dimensions were scaled by exactly the same factor", "feedback": "Scaling both dimensions is precisely the problem. The eye compares the whole icon rather than one of its dimensions on its own."},
   {"text": "The area is halved", "feedback": "Enlarging in both directions can only make the icon bigger."},
   {"text": "The icon becomes too small to recognise", "feedback": "It becomes larger rather than smaller, and legibility is not what is being distorted."},
   {"text": "The area becomes four times as large, so the change looks four times as big", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'misleading-graphs', 3, 'Challenge',
 'A graph has a vertical axis with a label but no numbers on it. Why is that misleading?', 2,
 '[
   {"text": "It is acceptable, as long as the graph itself has been given a title", "feedback": "A title says what is being shown. It does not say how much."},
   {"text": "It forces the reader to extrapolate", "feedback": "Extrapolation is predicting beyond the data. Here the trouble is that even the data cannot be read."},
   {"text": "There is no way to tell how big any of the changes actually are", "feedback": "Correct."},
   {"text": "It makes the graph look symmetric", "feedback": "Removing the numbers does not change the shape of the picture at all; it changes what can be concluded from it."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'misleading-graphs', 4, 'Advanced',
 'A line graph is drawn with its horizontal axis squeezed narrow, so a slow rise over ten years climbs steeply across the page. What has been done?', 0,
 '[
   {"text": "The horizontal scale has been compressed to steepen the line", "feedback": "Correct."},
   {"text": "The vertical axis has been truncated", "feedback": "Truncating the vertical axis is a different trick with a similar effect. Nothing has been done to the vertical axis in this graph."},
   {"text": "The data have been smoothed", "feedback": "Smoothing removes wobble from a line. It does not change how steep the overall climb appears."},
   {"text": "The sample was biased", "feedback": "Bias is a fault in how the data were COLLECTED. This is a fault in how honest data were drawn."}
 ]'::jsonb,
 null),
('MDM4U', 'displays-of-data', 'misleading-graphs', 5, 'Advanced',
 'A pie chart is drawn in three dimensions and tilted so that one slice sits at the front. Why is that a problem?', 1,
 '[
   {"text": "The labels can no longer be attached to the slices", "feedback": "Labels can be placed on any pie chart. The distortion happens even when every slice is labelled."},
   {"text": "Perspective gives the front slice more visible area than its share of the total", "feedback": "Correct."},
   {"text": "It is not a problem at all, because the underlying percentages themselves are unchanged", "feedback": "The percentages are unchanged and the picture still lies. A reader judges by the area they can see."},
   {"text": "The slices no longer add up to 100 per cent", "feedback": "They still do. What changes is how much of each one the eye is shown."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'theses-variables-and-sources-of-data', 1, 'Easy',
 'Data that you collect yourself, firsthand, is called what?', 3,
 '[
   {"text": "Secondary data", "feedback": "Secondary data comes from a study somebody ELSE carried out. The distinction is who did the collecting."},
   {"text": "Aggregate data", "feedback": "Aggregate describes data that has been summarised into totals. It says nothing about who gathered it."},
   {"text": "Microdata", "feedback": "Microdata describes data kept at the level of individual records. Again, that is about its form rather than its source."},
   {"text": "Primary data", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'theses-variables-and-sources-of-data', 2, 'Easy',
 'A study investigates how the number of hours spent studying affects test scores. Which is the independent variable?', 3,
 '[
   {"text": "The test scores the students achieve", "feedback": "That is what is being MEASURED in response, which makes it the dependent variable."},
   {"text": "The students", "feedback": "The students are the subjects being studied, not a variable measured on them."},
   {"text": "The school", "feedback": "The setting is not a variable in this study; nothing about it is being changed or measured."},
   {"text": "The number of hours spent studying", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'theses-variables-and-sources-of-data', 3, 'Medium',
 'You download a table from the Statistics Canada website for your project. What kind of data is that?', 3,
 '[
   {"text": "Primary data", "feedback": "Primary means you collected it yourself. Somebody else did the collecting here."},
   {"text": "Microdata", "feedback": "It may or may not be microdata, depending on whether individual records are kept. Either way that is a separate question from where it came from."},
   {"text": "A census of the whole population", "feedback": "A census is a method of collection. What you have is the output, and it came from somebody else."},
   {"text": "Secondary data", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'theses-variables-and-sources-of-data', 4, 'Medium',
 'What makes a good thesis, or research question, for a data management project?', 1,
 '[
   {"text": "It can be answered with a yes or a no", "feedback": "Plenty of good questions are yes-or-no ones, and plenty are not. What matters is whether data can settle it."},
   {"text": "It can be settled by data that you are able to collect", "feedback": "Correct."},
   {"text": "It is broad enough to cover the whole topic", "feedback": "A question broad enough to cover everything is usually one that no realistic data set can settle."},
   {"text": "It is phrased so the answer is already known", "feedback": "Then there is nothing left to investigate, and the study becomes an exercise in confirming what you started with."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'theses-variables-and-sources-of-data', 5, 'Challenge',
 'A study finds that children who eat breakfast score higher on tests. Children who eat breakfast also tend to come from wealthier homes.
What role does family income play here?', 2,
 '[
   {"text": "It is the treatment", "feedback": "Nothing was imposed on anybody. This is an observational study, so there is no treatment at all."},
   {"text": "There is no confounding, because breakfast clearly comes first in time", "feedback": "Coming first in time is not enough. Income was there before both, and it could be producing both effects on its own."},
   {"text": "It is a confounding variable", "feedback": "Correct."},
   {"text": "It is the response variable", "feedback": "The response is the thing measured at the end, which is the test score."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'theses-variables-and-sources-of-data', 6, 'Challenge',
 'Why is primary data often preferred to secondary data?', 2,
 '[
   {"text": "Because it is cheaper to obtain", "feedback": "It is usually far more expensive in time and effort. Secondary data is often free."},
   {"text": "Because it is always larger", "feedback": "It is almost always much smaller. Secondary sources are where the large data sets live."},
   {"text": "Because you control how it was collected, so you know exactly what its limitations are", "feedback": "Correct."},
   {"text": "Because it is always more accurate", "feedback": "A carefully run national survey will usually beat anything a student can collect. What primary data gives you is knowledge of its own weaknesses."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'theses-variables-and-sources-of-data', 7, 'Advanced',
 'Observational studies suggested hormone replacement cut heart attack risk. The women who chose to take hormones were also richer, better educated, and saw doctors more often.
What role do wealth and doctor visits play?', 2,
 '[
   {"text": "They are the treatments the women received", "feedback": "Nothing was imposed on anybody. The women decided for themselves, which is precisely what makes the study observational."},
   {"text": "They are strata", "feedback": "Strata are groups a researcher DIVIDES a population into on purpose before sampling. These are traits that happened to travel with the choice."},
   {"text": "They are confounding variables", "feedback": "Correct."},
   {"text": "They are response variables", "feedback": "The response is the outcome being measured, which is the rate of heart attacks."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'characteristics-of-data', 1, 'Easy',
 'What is microdata?', 0,
 '[
   {"text": "Data that is kept at the level of the individual respondents", "feedback": "Correct."},
   {"text": "Data that has already been summarised into totals", "feedback": "That is AGGREGATE data. Microdata is what those totals were built from."},
   {"text": "Data from a very small sample", "feedback": "The size of the sample is a separate matter. Microdata from a huge survey is still microdata."},
   {"text": "Data whose values happen to be small numbers", "feedback": "The word refers to the level of DETAIL kept, not to the size of any number in it."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'characteristics-of-data', 2, 'Medium',
 'A researcher is choosing between a longitudinal study and a cross-sectional study. Which of the two follows the SAME subjects throughout?', 2,
 '[
   {"text": "Both of them", "feedback": "Only one of the two tracks individuals. The other deliberately does not."},
   {"text": "Neither of them", "feedback": "One of them is defined by exactly this property."},
   {"text": "A longitudinal study", "feedback": "Correct."},
   {"text": "A cross-sectional study", "feedback": "A cross-sectional study takes a snapshot of a population at one moment. Different people may appear at different times."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'characteristics-of-data', 3, 'Challenge',
 'What kind of question can aggregate data NOT answer?', 2,
 '[
   {"text": "Anything about percentages", "feedback": "Percentages come straight out of totals, so aggregate data handles them easily."},
   {"text": "Anything about how a figure has changed over time", "feedback": "Aggregate figures from several years show a trend perfectly well."},
   {"text": "Anything about the individual respondents behind those totals", "feedback": "Correct."},
   {"text": "Anything about totals", "feedback": "Totals are exactly what aggregate data is made of."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'characteristics-of-data', 4, 'Challenge',
 'A survey records each respondent height to the nearest tenth of a centimetre. What kind of data is that?', 1,
 '[
   {"text": "Aggregate", "feedback": "These are individual measurements, so they are microdata rather than aggregate."},
   {"text": "Numeric and continuous", "feedback": "Correct."},
   {"text": "Numeric and discrete, because of the rounding", "feedback": "Rounding to a tenth is a limit of the ruler, not of the quantity. A height can in principle take any value in a range."},
   {"text": "Categoric", "feedback": "The values are genuine numbers that can be averaged, which categories cannot."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'characteristics-of-data', 5, 'Advanced',
 'A researcher has survey data from 2015 and from 2025, but the two surveys questioned different people.
What kind of data is that, and what can it not show?', 2,
 '[
   {"text": "Experimental data", "feedback": "No treatment was imposed on anybody, so nothing here is an experiment."},
   {"text": "A census, so it describes the whole population exactly", "feedback": "A census measures everybody. These are surveys, which sample."},
   {"text": "Two cross-sections: it can show that the population changed, but not that any individual did", "feedback": "Correct."},
   {"text": "Longitudinal data, with no real limitation", "feedback": "Longitudinal data follows the SAME people. Different respondents at each date makes these two separate snapshots."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'characteristics-of-data', 6, 'Advanced',
 'Why can microdata answer questions that aggregate data cannot?', 3,
 '[
   {"text": "Because it is more accurate", "feedback": "Aggregate figures are computed from microdata, so they are exactly as accurate as their source."},
   {"text": "Because it is more recent", "feedback": "Both forms can be old or new. The difference is in the level of detail retained."},
   {"text": "Because it is smaller and therefore easier to work with", "feedback": "It is far LARGER than the summary built from it, and considerably harder to handle."},
   {"text": "Because it keeps each individual record", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'sampling-methods', 1, 'Easy',
 'What makes a sample a SIMPLE RANDOM sample?', 1,
 '[
   {"text": "The population is divided into groups before anyone is chosen", "feedback": "That describes stratified or cluster sampling, both of which add a step before the randomness."},
   {"text": "Every member of the population is equally likely to be chosen, and choices are made independently", "feedback": "Correct."},
   {"text": "The first n people encountered are chosen", "feedback": "That is a convenience sample. Being first through a door is not the same as being chosen by chance."},
   {"text": "The sample is chosen so that it looks representative", "feedback": "Choosing it to look representative is a judgement, and judgements carry bias. Randomness is what makes the process fair."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'sampling-methods', 2, 'Easy',
 'A researcher surveys whoever happens to be walking past the entrance of a shopping centre. Which sampling method is that?', 0,
 '[
   {"text": "Convenience sampling", "feedback": "Correct."},
   {"text": "Simple random sampling", "feedback": "Nobody who was somewhere else at that moment had any chance of being chosen, so the chances were not equal."},
   {"text": "Systematic sampling", "feedback": "Systematic sampling picks every nth member from an ordered list of the whole population. No such list is being used here."},
   {"text": "Stratified sampling", "feedback": "Stratified sampling divides the population into groups first and samples within each. No groups are being formed here."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'sampling-methods', 3, 'Medium',
 'A school has 1500 students and a systematic random sample of 75 is wanted.
What is the sampling interval?', 3,
 '[
   {"text": "75", "feedback": "That is the sample size. The interval is how far apart the chosen names sit on the list."},
   {"text": "1425", "feedback": "That is the number of students left out. The interval comes from dividing, not subtracting."},
   {"text": "5", "feedback": "That is the sample expressed as a percentage of the school. An interval counts places along the list, not per cent."},
   {"text": "20", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'sampling-methods', 4, 'Medium',
 'A school of 800 students has 240 in grade nine. A stratified random sample of 10 per cent of the school is taken.
How many grade nines are in the sample?', 0,
 '[
   {"text": "24", "feedback": "Correct."},
   {"text": "80", "feedback": "That is the size of the WHOLE sample. Grade nine is only part of the school, so it supplies only part of it."},
   {"text": "20", "feedback": "The 80 places were split evenly among four grades. Stratified sampling makes each grade proportional to its own size instead."},
   {"text": "240", "feedback": "That is the number of grade nines in the school. The sample takes a tenth of them."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'sampling-methods', 5, 'Challenge',
 'In stratified random sampling, why is the number taken from each stratum made proportional to the size of that stratum?', 0,
 '[
   {"text": "So that each group keeps its share of the whole population", "feedback": "Correct."},
   {"text": "So that every group carries equal weight in the sample", "feedback": "Equal weight would OVER-represent the small groups. Proportional weight is what keeps the sample looking like the population."},
   {"text": "Because it makes the arithmetic easier", "feedback": "Equal sizes would make the arithmetic easier. Proportional allocation is chosen despite the extra work."},
   {"text": "To reduce non-response", "feedback": "Non-response depends on who agrees to take part, and proportional allocation does nothing about that."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'sampling-methods', 6, 'Challenge',
 'A systematic sample takes every tenth name from a list. What hidden risk does that carry?', 0,
 '[
   {"text": "A pattern of period ten in the list skews the sample", "feedback": "Correct."},
   {"text": "It is never random, because the choices are not independent", "feedback": "The choices genuinely are not independent, but with a randomly chosen starting point every member still has the same chance of being picked."},
   {"text": "The sample will be too small", "feedback": "The interval is chosen to give whatever sample size is wanted, so size is not the issue."},
   {"text": "It is the same as convenience sampling", "feedback": "Convenience sampling takes whoever is easiest to reach. This one works through the entire population in order."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'sampling-methods', 7, 'Advanced',
 'A researcher divides a city into neighbourhoods, chooses four neighbourhoods at random, and surveys every household in those four. Which method is that?', 3,
 '[
   {"text": "Stratified sampling", "feedback": "Stratified sampling takes some members from EVERY group. This one takes all the members of a few groups, which is the mirror image."},
   {"text": "Systematic sampling", "feedback": "Systematic sampling steps through an ordered list of the whole population at a fixed interval."},
   {"text": "Simple random sampling", "feedback": "Households in the neighbourhoods that were not chosen had no chance at all, so the chances were not equal."},
   {"text": "Cluster sampling", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'survey-and-question-design', 1, 'Easy',
 'A question that gives the respondent a fixed list of answers to choose from is called what?', 1,
 '[
   {"text": "A loaded question", "feedback": "A loaded question smuggles an assumption into itself. That is about the wording, not about the answer format."},
   {"text": "A closed question", "feedback": "Correct."},
   {"text": "An open question", "feedback": "An open question leaves the answer entirely up to the respondent, in their own words."},
   {"text": "A leading question", "feedback": "A leading question pushes towards one answer. It can be either open or closed."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'survey-and-question-design', 2, 'Medium',
 'What is the problem with the survey question: Which player would you NOT select first?', 0,
 '[
   {"text": "The negative wording is easy for a respondent to misread", "feedback": "Correct."},
   {"text": "It offers too many options for anyone to hold in mind", "feedback": "The number of options is reasonable. The difficulty is in reading the question at all."},
   {"text": "It is an open question", "feedback": "It is closed: a list of players is supplied to choose from."},
   {"text": "It collects categoric data", "feedback": "Categoric data is perfectly respectable and is exactly what this question should collect."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'survey-and-question-design', 3, 'Challenge',
 'What is a Likert scale used for in a survey?', 0,
 '[
   {"text": "Rating each item on a common scale", "feedback": "Correct."},
   {"text": "Ranking a list of items in order of importance", "feedback": "That is a ranking question, which forces the items into an order against one another."},
   {"text": "Collecting demographic facts such as age and gender", "feedback": "Those are collected with a simple list of categories rather than a scale."},
   {"text": "Asking a question with no fixed answers at all", "feedback": "That is an open question, which leaves the answer entirely in the words of the respondent."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'survey-and-question-design', 4, 'Challenge',
 'What is wrong with the question: Given the rising problem of obesity among teenagers, do you agree that physical education should be mandatory?', 3,
 '[
   {"text": "It is a closed question", "feedback": "Closed questions are perfectly acceptable and are usually easier to analyse."},
   {"text": "It collects categoric data rather than numbers", "feedback": "Categoric data is exactly right for an agree-or-disagree question."},
   {"text": "It offers too few options", "feedback": "Adding more options would not undo the effect of the sentence in front of the question."},
   {"text": "The preamble leads towards agreeing", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'survey-and-question-design', 5, 'Advanced',
 'A survey asks respondents to put four factors in order from 1 to 4, where 1 is most important. Which type of closed question is that?', 3,
 '[
   {"text": "A Likert scale question", "feedback": "A Likert scale rates each item separately, so two items can receive the same score."},
   {"text": "A checklist question", "feedback": "A checklist lets the respondent tick any number of items with no order among them."},
   {"text": "A demographic question", "feedback": "Demographic questions collect facts about the respondent, such as age or grade."},
   {"text": "A ranking question", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'survey-and-question-design', 6, 'Advanced',
 'Why should a survey avoid asking two things at once, as in: Did you find the staff friendly and helpful?', 1,
 '[
   {"text": "It uses a Likert scale", "feedback": "It does not, and switching to one would not help: a single rating still cannot separate the two qualities."},
   {"text": "Friendly but unhelpful staff leaves no honest answer", "feedback": "Correct."},
   {"text": "It takes too long for the respondent to read and answer", "feedback": "It is a short question. The trouble is that it has two answers hiding inside one."},
   {"text": "It is an open question", "feedback": "It is closed, and would normally be answered yes or no. That is exactly what makes the double barrel a problem."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'types-of-bias', 1, 'Easy',
 'A questionnaire is mailed to 1000 households and only the people with strong opinions bother to send it back. Which type of bias is that?', 3,
 '[
   {"text": "Sampling bias, because the 1000 households were badly chosen", "feedback": "The sample was chosen fairly. What went wrong happened afterwards, when part of it declined to take part."},
   {"text": "Measurement bias", "feedback": "Measurement bias comes from the way the questions are asked. Nothing here is said about the wording."},
   {"text": "Household bias", "feedback": "Household bias is about which PERSON within a home ends up answering. Here the trouble is which homes answered at all."},
   {"text": "Non-response bias", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'types-of-bias', 2, 'Easy',
 'A survey asks: Do you agree that our excellent new recycling policy should continue? Which type of bias does that introduce?', 2,
 '[
   {"text": "Sampling bias", "feedback": "Sampling bias is about who was asked. Nothing here is said about how the respondents were chosen."},
   {"text": "Household bias", "feedback": "Household bias is about which member of a home answers. This question is about the wording."},
   {"text": "Response bias", "feedback": "Correct."},
   {"text": "Non-response bias", "feedback": "That name is for people who decline to take part at all. Everyone here answers; the problem is what they are being nudged towards."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'types-of-bias', 3, 'Medium',
 'A telephone survey is carried out only on weekday mornings, so people at work are never reached. Which type of bias is that?', 0,
 '[
   {"text": "Sampling bias", "feedback": "Correct."},
   {"text": "Non-response bias", "feedback": "Non-response bias needs people to have been asked and to have declined. These people were never reachable in the first place."},
   {"text": "Measurement bias", "feedback": "Measurement bias comes from how the questions are worded. Nothing here is said about the questions."},
   {"text": "Household bias", "feedback": "Household bias is about which member of a home answers. Here whole categories of home are never called at all."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'types-of-bias', 4, 'Medium',
 'A survey selects households at random and interviews whoever opens the door. What bias does that introduce?', 1,
 '[
   {"text": "None, because the households were chosen at random", "feedback": "The households were chosen fairly. The individuals within them were not, and it is individuals who answer."},
   {"text": "Household bias, from unequal household sizes", "feedback": "Correct."},
   {"text": "Non-response bias", "feedback": "Somebody does answer at every home visited. The trouble is in WHICH person that turns out to be."},
   {"text": "Measurement bias", "feedback": "Measurement bias comes from the wording. Nothing here is said about the questions."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'types-of-bias', 5, 'Challenge',
 'To measure support for a candidate among 1500 students, a campaign manager surveys the first 50 students to enter the cafeteria in period four. Lunch runs in periods two, three and four.
What is the main problem?', 1,
 '[
   {"text": "Nothing, because the period was chosen by a random draw", "feedback": "Using randomness at one step does not make the result a random sample of the population."},
   {"text": "Sampling bias, from surveying only one lunch period", "feedback": "Correct."},
   {"text": "Non-response bias, because some of the 50 may not hand the form back", "feedback": "Non-response bias needs people who were asked and then declined. Nobody here has refused anything."},
   {"text": "Measurement bias, because of how the questions are worded", "feedback": "Nothing is said here about the wording. The trouble is in who was reachable."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'types-of-bias', 6, 'Advanced',
 'A school of 1500 students has 73 homerooms. An earlier survey reached only the students in one lunch period, and let them take the forms away.
A revised plan gives one questionnaire to a single student in each homeroom, and waits while it is filled in.
What problem does this NOT fix?', 3,
 '[
   {"text": "Non-response bias", "feedback": "Waiting for the form does fix that: nobody gets to take it away and forget about it."},
   {"text": "Students in only one lunch period being reachable", "feedback": "That is fixed too, since homerooms cover the whole school regardless of when anyone eats."},
   {"text": "The sample being far too small to support any conclusion", "feedback": "Seventy-three out of 1500 is a workable sample. What is wrong with it is its shape rather than its size."},
   {"text": "Unequal chances between large and small homerooms", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'types-of-bias', 7, 'Advanced',
 'An interviewer wearing a campaign badge for one candidate stops people in the street and asks whom they support. Which type of bias is that?', 0,
 '[
   {"text": "Response bias", "feedback": "Correct."},
   {"text": "Sampling bias", "feedback": "Who gets stopped is a separate matter. Here the trouble is what happens once somebody has been stopped."},
   {"text": "Non-response bias", "feedback": "That name needs people who decline to take part. These people do reply; the worry is that they shade what they say."},
   {"text": "Household bias", "feedback": "Household bias is about which member of a home ends up answering, and no homes are involved here."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'experiment-design', 1, 'Easy',
 'What distinguishes an experiment from an observational study?', 2,
 '[
   {"text": "An observational study uses a survey and an experiment does not", "feedback": "A survey is one kind of observational study, but plenty of others watch behaviour instead of asking about it."},
   {"text": "An experiment is always blinded", "feedback": "Blinding is a good idea and many experiments use it, but an experiment is still an experiment without it."},
   {"text": "An experiment imposes a treatment on its subjects rather than merely observing them", "feedback": "Correct."},
   {"text": "An experiment uses a larger sample", "feedback": "Size is not what separates them. Many observational studies are far larger than any experiment."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'experiment-design', 2, 'Easy',
 'What is a placebo?', 1,
 '[
   {"text": "The variable being measured at the end of the study", "feedback": "That is the response variable."},
   {"text": "A dummy treatment that looks like the real one", "feedback": "Correct."},
   {"text": "The real treatment being tested", "feedback": "That is what the placebo is compared AGAINST."},
   {"text": "The group of subjects who receive no treatment at all", "feedback": "That is the control group. The placebo is the thing given to them, not the people."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'experiment-design', 3, 'Medium',
 'Fifty smokers are randomly split into two groups. One group gets nicotine patches containing a new drug and the other gets ordinary nicotine patches.
What is the second group called?', 2,
 '[
   {"text": "A block", "feedback": "A block is a group of similar subjects formed BEFORE the random assignment, to remove a known source of variation."},
   {"text": "The placebo", "feedback": "The placebo is the dummy treatment itself, not the people who receive it."},
   {"text": "The control group", "feedback": "Correct."},
   {"text": "The treatment group", "feedback": "That is the group receiving the thing being tested, which is the first one here."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'experiment-design', 4, 'Medium',
 'What does assigning subjects to treatments at random accomplish?', 1,
 '[
   {"text": "It guarantees the sample is large enough", "feedback": "Size is the principle of replication, which is a separate requirement."},
   {"text": "It spreads unknown differences across the groups", "feedback": "Correct."},
   {"text": "It makes the two treatment groups exactly the same size", "feedback": "Equal sizes are convenient and are usually arranged separately. Randomness is doing something else entirely."},
   {"text": "It removes the need for a control group", "feedback": "The comparison is still needed. Random assignment decides WHO goes into each group, not whether the groups exist."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'experiment-design', 5, 'Challenge',
 'What is a double-blind experiment?', 1,
 '[
   {"text": "Nobody sees any of the results until the study has finished", "feedback": "Holding back results is good practice for other reasons, but blinding is about who knows the ASSIGNMENTS."},
   {"text": "Neither the subjects nor the assessors know the assignments", "feedback": "Correct."},
   {"text": "Only the subjects do not know which treatment they received", "feedback": "That is single blind. Only one side of the study is kept in the dark here."},
   {"text": "Only the researchers do not know which subject received which treatment", "feedback": "That is single blind from the other side. One party still knows what each subject received."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'experiment-design', 6, 'Advanced',
 'A firm tests four tyre types by buying four cars and fitting each car with one type.
What is the serious weakness?', 2,
 '[
   {"text": "There is no control group", "feedback": "The four types are being compared against each other, which supplies the comparison a control group would."},
   {"text": "There is no placebo", "feedback": "A placebo is for hiding a treatment from a person. A car cannot be fooled about which tyres it is wearing."},
   {"text": "The car and the tyre type are confounded, so a difference could come from the cars instead", "feedback": "Correct."},
   {"text": "The sample is too small, and that is the only problem", "feedback": "Four is indeed thin, but even four hundred cars fitted this way would carry the same flaw."}
 ]'::jsonb,
 null),
('MDM4U', 'collecting-data', 'experiment-design', 7, 'Advanced',
 'The firm improves the tyre study by fitting each car with one tyre of each of the four types.
What is this design called, and what does it achieve?', 0,
 '[
   {"text": "A blocked design: each car is a block, so car differences drop out", "feedback": "Correct."},
   {"text": "A placebo design, which stops the drivers from knowing which tyres they have", "feedback": "The drivers might well be kept in the dark, but that is blinding and it is not what this arrangement fixes."},
   {"text": "A double-blind design, which stops the researchers from knowing which tyres are which", "feedback": "Blinding hides an assignment. This design changes the assignment itself, so that every car carries every type."},
   {"text": "A stratified design, which divides the tyres into groups before assignment", "feedback": "Stratification is a SAMPLING idea, used when choosing who takes part rather than when assigning treatments."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'shapes-of-distributions', 1, 'Easy',
 'A distribution has two clearly separated peaks. What is its shape called?', 1,
 '[
   {"text": "Uniform", "feedback": "A uniform distribution is flat, with no peak anywhere."},
   {"text": "Bimodal", "feedback": "Correct."},
   {"text": "Symmetric", "feedback": "It may happen to be symmetric as well, but that word says nothing about the number of peaks."},
   {"text": "Skewed", "feedback": "Skew describes a single long tail on one side, not a second peak."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'shapes-of-distributions', 2, 'Easy',
 'What shape does a distribution have when every value occurs about equally often?', 3,
 '[
   {"text": "Normal", "feedback": "A normal distribution has a definite peak in the middle and thin tails."},
   {"text": "Bimodal", "feedback": "Bimodal needs two peaks, and a flat distribution has none."},
   {"text": "Skewed right", "feedback": "Skewed right needs a bulk on the left and a long tail to the right. A flat shape has neither."},
   {"text": "Uniform", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'shapes-of-distributions', 3, 'Medium',
 'Household incomes in a country have a small number of very high values. What shape is that distribution?', 2,
 '[
   {"text": "Symmetric", "feedback": "A handful of extreme values on one side only is precisely what breaks symmetry."},
   {"text": "Uniform", "feedback": "A uniform distribution is flat, with as many households at every income."},
   {"text": "Skewed right", "feedback": "Correct."},
   {"text": "Skewed left", "feedback": "The name follows the tail. A few very high values make a long tail on the right."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'shapes-of-distributions', 4, 'Challenge',
 'A distribution of ages at a family reunion has one cluster of children and another of grandparents, with few in between. What shape is that?', 0,
 '[
   {"text": "Bimodal", "feedback": "Correct."},
   {"text": "Skewed left", "feedback": "Skew describes one long tail. Here there are two separate clusters, each with its own peak."},
   {"text": "Normal", "feedback": "A normal distribution has one peak in the middle, which is precisely where this one is thin."},
   {"text": "Uniform", "feedback": "A uniform distribution is flat, with no clustering anywhere."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'shapes-of-distributions', 5, 'Challenge',
 'A distribution is bimodal. Why is the mean a poor summary of it?', 1,
 '[
   {"text": "The mean is only defined for symmetric distributions", "feedback": "The mean is defined for any numeric data at all."},
   {"text": "The mean lands in the sparse gap between the two peaks, where almost no data sits", "feedback": "Correct."},
   {"text": "The mean cannot be calculated for a bimodal distribution", "feedback": "It can be calculated perfectly well. The trouble is what it turns out to describe."},
   {"text": "The mean will always equal one of the two modes", "feedback": "It rarely equals either. It usually falls between them."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'shapes-of-distributions', 6, 'Advanced',
 'A distribution has a mean of 50 and a median of 62. What can you say about its shape?', 3,
 '[
   {"text": "It is skewed right, because the mean is a good deal smaller than the median", "feedback": "The relationship runs the other way. In a right-skewed distribution the long tail is on the high side, which pulls the mean ABOVE the median."},
   {"text": "It is symmetric, because the mean and the median are reasonably close together", "feedback": "A gap of twelve is not close. In a symmetric distribution the two coincide."},
   {"text": "Nothing can be said about the shape without knowing the standard deviation", "feedback": "The comparison of mean and median alone settles the direction of the skew."},
   {"text": "It is skewed left, because the mean has been dragged below the median", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'measures-of-central-tendency', 1, 'Easy',
 'Which measure of central tendency is most affected by a single extreme value?', 2,
 '[
   {"text": "The mode", "feedback": "The mode is whichever value occurs most often, and a single outlier occurs once."},
   {"text": "All three are affected equally", "feedback": "They are not. Only one of the three adds the actual value into a total, and a very large number pulls that one hard."},
   {"text": "The mean", "feedback": "Correct."},
   {"text": "The median", "feedback": "The median only counts positions, so one unusual value moves it by at most one place."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'measures-of-central-tendency', 2, 'Easy',
 'What is the median of the data set 4, 9, 11, 15, 20?', 3,
 '[
   {"text": "11.8", "feedback": "That is the MEAN. The median is the middle value once the data are in order."},
   {"text": "16", "feedback": "That is the range, from 4 up to 20."},
   {"text": "9", "feedback": "That is the second value. With five values the middle one is the third."},
   {"text": "11", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'measures-of-central-tendency', 3, 'Medium',
 'A student scores 80 on a test worth 30 per cent of the mark and 60 on a test worth 70 per cent.
What is the weighted mean?', 2,
 '[
   {"text": "74", "feedback": "The weights were applied to the wrong scores. The 70 per cent belongs to the mark of 60."},
   {"text": "140", "feedback": "The weighted contributions were added without being expressed as fractions of the whole."},
   {"text": "66", "feedback": "Correct."},
   {"text": "70", "feedback": "The two scores were simply averaged. The weights are unequal, so the 60 counts more than twice as much."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'measures-of-central-tendency', 4, 'Medium',
 'A class has 16 final grades: 43, 48, 56, 59, 62, 64, 67, 71, 72, 75, 75, 78, 81, 84, 88, 90.
What is the median?', 0,
 '[
   {"text": "71.5", "feedback": "Correct."},
   {"text": "71", "feedback": "With an even number of values the median is halfway BETWEEN the two middle ones, not the lower of them."},
   {"text": "69.56", "feedback": "That is the mean. The median comes from position rather than from adding everything up."},
   {"text": "72", "feedback": "That is the ninth value. The median of sixteen values sits between the eighth and the ninth."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'measures-of-central-tendency', 5, 'Challenge',
 'A data set is 4, 8, 9, 11, 14, 40.
What are the mean and the median?', 1,
 '[
   {"text": "Mean 14.33 and median 11", "feedback": "That is the fourth value. The median of six values sits between the third and the fourth."},
   {"text": "Mean 14.33 and median 10", "feedback": "Correct."},
   {"text": "Mean 10 and median 14.33", "feedback": "The two have been swapped. The 40 pulls the mean well above the middle of the data."},
   {"text": "Mean 14.33 and median 9", "feedback": "With six values the median is halfway between the third and the fourth, not the third alone."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'measures-of-central-tendency', 6, 'Challenge',
 'A set of nine numbers has a mean of 12. One value of 20 is replaced by 38.
What is the new mean?', 3,
 '[
   {"text": "12", "feedback": "Changing a value changes the total, so the mean has to move with it."},
   {"text": "18", "feedback": "That is the difference between the old value and the new one, which is not a mean at all."},
   {"text": "30", "feedback": "The change of 18 was added to the old mean in full. It has to be shared out over all nine values first."},
   {"text": "14", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'measures-of-central-tendency', 7, 'Advanced',
 'A set of five numbers has a mean of 20 and a median of 18.
What can you conclude?', 3,
 '[
   {"text": "The largest value must be exactly 22", "feedback": "Many different sets fit these two facts. Nothing pins down any single value."},
   {"text": "The data must be normally distributed", "feedback": "In a normal distribution the mean and the median coincide, so this data is not normal."},
   {"text": "The standard deviation must be 2", "feedback": "The gap between mean and median says nothing about the standard deviation."},
   {"text": "At least one value is far enough above 18 to pull the mean upward", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'measures-of-spread', 1, 'Easy',
 'What does the interquartile range measure?', 2,
 '[
   {"text": "The average distance of each value from the mean", "feedback": "That describes the standard deviation, which is built from deviations rather than from quartiles."},
   {"text": "The difference between the mean and the median", "feedback": "That difference is a hint about skew, but it is not a measure of spread."},
   {"text": "The spread of the middle half of the data", "feedback": "Correct."},
   {"text": "The spread of the whole data set from lowest to highest", "feedback": "That is the RANGE. The interquartile range deliberately ignores the outer quarters."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'measures-of-spread', 2, 'Easy',
 'What is the relationship between the variance and the standard deviation?', 0,
 '[
   {"text": "The standard deviation is the square root of the variance", "feedback": "Correct."},
   {"text": "The variance is equal to the square root of the standard deviation", "feedback": "The two have been swapped. The variance is the larger of the two whenever it is above 1."},
   {"text": "They are the same thing", "feedback": "They measure the same idea in different units. The variance is in squared units, which is why the root is taken."},
   {"text": "The standard deviation is half the variance", "feedback": "There is no fixed multiple between them. The relationship is a square root."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'measures-of-spread', 3, 'Medium',
 'For that same set of 16 grades, Q1 is 60.5 and Q3 is 79.5.
What is the interquartile range?', 3,
 '[
   {"text": "47", "feedback": "That is the RANGE, from the lowest grade to the highest. The interquartile range uses the quartiles instead."},
   {"text": "140", "feedback": "The two quartiles were added rather than subtracted."},
   {"text": "9.5", "feedback": "The difference was halved. The interquartile range is the whole distance between the two quartiles."},
   {"text": "19", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'measures-of-spread', 4, 'Medium',
 'What is the difference between the population standard deviation and the sample standard deviation?', 2,
 '[
   {"text": "The sample version uses the median instead of the mean", "feedback": "Both are built from deviations about the mean."},
   {"text": "The sample version is not square rooted", "feedback": "Both take the square root at the end. Without it you would have a variance, not a standard deviation."},
   {"text": "The sample version divides by n take away 1 rather than by n", "feedback": "Correct."},
   {"text": "The sample version divides by n and the population version by n take away 1", "feedback": "The two have been swapped. It is the SAMPLE that needs the smaller divisor, to stop it underestimating."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'measures-of-spread', 5, 'Medium',
 'Heights on a team are 183, 165, 148, 146, 181, 178, 154 cm, and this is the whole population.
What is the mean, and the population standard deviation to two decimal places?', 0,
 '[
   {"text": "Mean 165 and standard deviation 14.74", "feedback": "Correct."},
   {"text": "Mean 165 and standard deviation 15.92", "feedback": "The mean is right but the sample formula was used, dividing by n take away 1. This set is the whole population."},
   {"text": "Mean 165 and standard deviation 217.14", "feedback": "That is the VARIANCE. The square root still has to be taken."},
   {"text": "Mean 178 and standard deviation 14.74", "feedback": "A height was read straight off the list instead of the centre of the seven being worked out."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'measures-of-spread', 6, 'Advanced',
 'Every value in a data set has 10 added to it. What happens to the mean and to the standard deviation?', 0,
 '[
   {"text": "The mean increases by 10 and the standard deviation is unchanged", "feedback": "Correct."},
   {"text": "Both increase by 10", "feedback": "Shifting every value by the same amount leaves all the distances between them the same, and the standard deviation is built from distances."},
   {"text": "The mean is unchanged and the standard deviation increases by 10 instead", "feedback": "The two have been swapped. It is the centre that moves and the spread that stays."},
   {"text": "Both are unchanged", "feedback": "The centre certainly moves. Adding 10 to everything adds 10 to the average."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'the-normal-distribution', 1, 'Easy',
 'In a normal distribution, roughly what percentage of the data lies within one standard deviation of the mean?', 2,
 '[
   {"text": "99.7 per cent", "feedback": "That is the figure for THREE standard deviations."},
   {"text": "50 per cent", "feedback": "Half the data lies below the mean, but one standard deviation on each side reaches considerably further than that."},
   {"text": "68 per cent", "feedback": "Correct."},
   {"text": "95 per cent", "feedback": "That is the figure for TWO standard deviations."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'the-normal-distribution', 2, 'Easy',
 'In a normal distribution, where do the mean, the median and the mode sit?', 3,
 '[
   {"text": "The mean is above the median, which is above the mode", "feedback": "That is the pattern for a distribution skewed RIGHT. A normal distribution is symmetric."},
   {"text": "The mode is at the centre and the other two are in the tails", "feedback": "Neither the mean nor the median ever sits in a tail of a symmetric distribution."},
   {"text": "Their positions depend on the standard deviation", "feedback": "The standard deviation decides how wide the curve is, not where its centre lies."},
   {"text": "All three are at the centre, in the same place", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'the-normal-distribution', 3, 'Medium',
 'Marks are normally distributed with a mean of 70 and a standard deviation of 8.
Between which two marks does about 95 per cent of the class fall?', 3,
 '[
   {"text": "62 and 78", "feedback": "That is one standard deviation on each side, which captures about 68 per cent."},
   {"text": "46 and 94", "feedback": "That is three standard deviations on each side, which captures about 99.7 per cent."},
   {"text": "70 and 86", "feedback": "That is only the upper half of the interval. The other two standard deviations below the mean belong as well."},
   {"text": "54 and 86", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'the-normal-distribution', 4, 'Medium',
 'What happens to the shape of a normal curve when the standard deviation increases and the mean stays the same?', 2,
 '[
   {"text": "It shifts to the right", "feedback": "Shifting sideways is what changing the MEAN does. The standard deviation controls width."},
   {"text": "It becomes narrower and taller, staying centred in the same place", "feedback": "That is what happens when the standard deviation DECREASES."},
   {"text": "It becomes wider and flatter, staying centred in the same place", "feedback": "Correct."},
   {"text": "It becomes wider and taller", "feedback": "It cannot become both. The area under the curve is always 1, so spreading it out has to bring the peak down."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'the-normal-distribution', 5, 'Challenge',
 'Heights cannot be negative, yet a normal distribution is routinely used to model them. Why is that only an approximation?', 2,
 '[
   {"text": "Because the mean and the median of real heights are different", "feedback": "For heights they are very close, which is one of the reasons the normal model fits as well as it does."},
   {"text": "Because the standard deviation of heights is too large for the model to apply", "feedback": "A normal distribution accepts any positive standard deviation. Size is not the obstacle."},
   {"text": "The normal curve never quite reaches the axis, so it assigns a tiny probability to impossible values", "feedback": "Correct."},
   {"text": "Because heights are discrete rather than continuous", "feedback": "Heights are continuous: between any two heights there is another. That is not what makes the model approximate."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'the-normal-distribution', 6, 'Advanced',
 'A machine fills bottles with a mean of 500 mL and a standard deviation of 4 mL, normally distributed.
About what percentage of bottles hold less than 492 mL?', 3,
 '[
   {"text": "About 5 per cent", "feedback": "That is the total in BOTH tails beyond two standard deviations. Only the lower one was asked for."},
   {"text": "About 16 per cent", "feedback": "That is the tail beyond ONE standard deviation. 492 mL is two standard deviations below the mean."},
   {"text": "About 95 per cent", "feedback": "That is the proportion INSIDE two standard deviations. The question asks about the small piece outside it on one side."},
   {"text": "About 2.5 per cent", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'z-scores-and-probabilities', 1, 'Easy',
 'A test has a mean of 70 and a standard deviation of 8.
What is the z-score of a mark of 82?', 0,
 '[
   {"text": "1.5", "feedback": "Correct."},
   {"text": "-1.5", "feedback": "The subtraction went the wrong way round. A mark ABOVE the mean has a positive z-score."},
   {"text": "12", "feedback": "That is the raw difference from the mean. A z-score divides it by the standard deviation."},
   {"text": "10.25", "feedback": "The mark was divided by the standard deviation without the mean being subtracted first."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'z-scores-and-probabilities', 2, 'Medium',
 'Marks are normally distributed with a mean of 70 and a standard deviation of 8.
What proportion of students score below 82, to four decimal places?', 0,
 '[
   {"text": "0.9332", "feedback": "Correct."},
   {"text": "0.0668", "feedback": "That is the proportion scoring ABOVE 82. The two add to 1, so one has been read for the other."},
   {"text": "0.8664", "feedback": "That is the proportion between 58 and 82, the symmetric interval. Only one side was asked for here."},
   {"text": "1.5000", "feedback": "That is the z-score. A proportion can never exceed 1."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'z-scores-and-probabilities', 3, 'Challenge',
 'Marks are normally distributed with a mean of 70 and a standard deviation of 8.
What mark sits at the 90th percentile, to two decimal places?', 1,
 '[
   {"text": "78.00", "feedback": "That is one standard deviation above the mean, which sits at about the 84th percentile rather than the 90th."},
   {"text": "80.25", "feedback": "Correct."},
   {"text": "1.28", "feedback": "That is the Z-SCORE for the 90th percentile. It still has to be converted back into a mark."},
   {"text": "83.16", "feedback": "That is the 95th percentile. The z-score for 90 per cent is about 1.28, not 1.64."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'z-scores-and-probabilities', 4, 'Challenge',
 'Marks are normally distributed with a mean of 70 and a standard deviation of 8.
What proportion of students score between 58 and 82, to four decimal places?', 0,
 '[
   {"text": "0.8664", "feedback": "Correct."},
   {"text": "0.9332", "feedback": "That is the proportion below 82 alone. The part below 58 still has to be taken off."},
   {"text": "0.0668", "feedback": "That is the proportion in one tail. The question asks for the middle."},
   {"text": "0.9500", "feedback": "That would be the answer for two full standard deviations each way, reaching 54 and 86. These limits are 1.5 standard deviations out."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'z-scores-and-probabilities', 5, 'Advanced',
 'Two students take different tests. One scores 78 where the mean is 70 and the standard deviation is 4. The other scores 85 where the mean is 75 and the standard deviation is 10. Who did better relative to their class?', 2,
 '[
   {"text": "They performed equally, since both beat their class mean by 8 or more", "feedback": "The size of the gap matters relative to the spread. Eight marks in a tight class is a much bigger achievement than ten in a loose one."},
   {"text": "There is not enough information without knowing the class sizes", "feedback": "The mean and the standard deviation are all a z-score needs."},
   {"text": "The first student, whose z-score is 2 against the other 1", "feedback": "Correct."},
   {"text": "The second student, who scored the higher raw mark", "feedback": "Raw marks from different tests cannot be compared. Standardising is exactly what makes them comparable."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'z-scores-and-probabilities', 6, 'Advanced',
 'A value has a z-score of -0.8. What does that mean?', 1,
 '[
   {"text": "It sits at the 80th percentile of the distribution", "feedback": "A negative z-score is below the mean, so it sits below the 50th percentile. This one is at about the 21st."},
   {"text": "It lies 0.8 standard deviations below the mean", "feedback": "Correct."},
   {"text": "It lies 0.8 units below the mean", "feedback": "A z-score counts standard deviations, not units. How many units that is depends on the standard deviation."},
   {"text": "It lies 0.8 standard deviations above the mean", "feedback": "The negative sign puts it below. Above the mean gives a positive score."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'confidence-intervals', 1, 'Easy',
 'What does a 95 per cent confidence interval tell you?', 1,
 '[
   {"text": "That 95 per cent of the population lies inside the interval", "feedback": "The interval brackets a single number, the population mean or proportion, not the spread of individuals."},
   {"text": "A range that, by this method, would capture the true population value 95 times out of 100", "feedback": "Correct."},
   {"text": "That 95 per cent of the sample lies inside the interval", "feedback": "The interval is about the unknown POPULATION value, not about where the sample values sit."},
   {"text": "That the sample mean has a 95 per cent chance of being correct", "feedback": "The sample mean is whatever it is, with no uncertainty. What is uncertain is the population value it estimates."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'confidence-intervals', 2, 'Medium',
 'What happens to the width of a confidence interval when the sample size increases, everything else being equal?', 0,
 '[
   {"text": "It gets narrower", "feedback": "Correct."},
   {"text": "It gets wider", "feedback": "More data makes an estimate more precise, not less. The sample size sits underneath a square root in the denominator."},
   {"text": "It stays the same", "feedback": "The sample size appears in the margin of error, so changing it changes the width."},
   {"text": "It depends on whether the mean goes up or down", "feedback": "The centre of the interval moves with the mean, but its WIDTH does not depend on the mean at all."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'confidence-intervals', 3, 'Challenge',
 'Drying times for a paint have a standard deviation of 10.5 minutes. Twenty test areas give a mean of 75.4 minutes.
What is the 95 per cent confidence interval, to three decimal places?', 0,
 '[
   {"text": "70.798 to 80.002 minutes", "feedback": "Correct."},
   {"text": "71.538 to 79.262 minutes", "feedback": "The critical value 1.645 was used, which belongs to a 90 per cent interval. For 95 per cent it is 1.960."},
   {"text": "64.900 to 85.900 minutes", "feedback": "The standard deviation was used as the margin of error directly. It has to be divided by the square root of the sample size and scaled by the critical value."},
   {"text": "69.352 to 81.448 minutes", "feedback": "The critical value 2.576 was used, which belongs to a 99 per cent interval."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'confidence-intervals', 4, 'Challenge',
 'Julia has jogged 2 miles many times, with a standard deviation of 1.8 minutes. A random sample of 90 of her times has a mean of 15.6 minutes.
What is the 95 per cent confidence interval, to three decimal places?', 2,
 '[
   {"text": "15.410 to 15.790 minutes", "feedback": "The standard error was used as the margin of error on its own, with no critical value applied to it."},
   {"text": "15.600 to 15.972 minutes", "feedback": "Only the upper half of the interval was given. The margin of error goes both ways from the sample mean."},
   {"text": "15.228 to 15.972 minutes", "feedback": "Correct."},
   {"text": "13.800 to 17.400 minutes", "feedback": "The standard deviation was used as the margin of error directly, without being divided by the square root of 90."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'confidence-intervals', 5, 'Advanced',
 'In an election 53 per cent of 1500 voters supported the mayor.
What is the 90 per cent confidence interval for the true level of support, to four decimal places?', 1,
 '[
   {"text": "0.4700 to 0.5300", "feedback": "The complement of the proportion was used as the lower limit. A confidence interval is centred on the sample proportion itself."},
   {"text": "0.5088 to 0.5512", "feedback": "Correct."},
   {"text": "0.5047 to 0.5553", "feedback": "The critical value 1.960 was used, which belongs to a 95 per cent interval. For 90 per cent it is 1.645."},
   {"text": "0.5295 to 0.5305", "feedback": "The sample size was used instead of its square root, which makes the interval far too narrow."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'confidence-intervals', 6, 'Advanced',
 'Of 188 books sold, 66 were murder mysteries.
What is the 90 per cent confidence interval for the proportion of murder mysteries, to four decimal places?', 3,
 '[
   {"text": "0.2827 to 0.4194", "feedback": "The critical value 1.960 was used, which belongs to a 95 per cent interval. For 90 per cent it is 1.645."},
   {"text": "0.3511 to 0.4083", "feedback": "Only the upper half of the interval was given. The margin of error goes both ways from the sample proportion."},
   {"text": "0.3469 to 0.3552", "feedback": "The sample size was used instead of its square root, which makes the interval far too narrow."},
   {"text": "0.2938 to 0.4083", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'confidence-intervals', 7, 'Advanced',
 'Why is a 99 per cent confidence interval wider than a 95 per cent one built from the same data?', 1,
 '[
   {"text": "It is not wider; higher confidence gives a more precise estimate", "feedback": "Confidence and precision pull against each other. You can have a narrow interval or a very safe one, not both."},
   {"text": "Being more certain of capturing the true value requires casting a wider net", "feedback": "Correct."},
   {"text": "Because a 99 per cent interval uses a larger sample", "feedback": "The data is the same in both cases. Only the critical value changes."},
   {"text": "Because the standard deviation is recalculated at the higher confidence level", "feedback": "The standard deviation comes from the data and does not depend on the confidence level chosen."}
 ]'::jsonb,
 null),
('MDM4U', 'normal-distributions', 'confidence-intervals', 8, 'Advanced',
 'A newspaper reports that 46 per cent support a policy, with a margin of error of 3 percentage points. Support has risen from 44 per cent last month. What is the honest conclusion?', 1,
 '[
   {"text": "The margin of error only applies to the newer figure, so the rise is real", "feedback": "Both figures came from samples and both carry uncertainty, which makes the comparison even less conclusive."},
   {"text": "The apparent rise is smaller than the margin of error, so no real change has been shown", "feedback": "Correct."},
   {"text": "Support has definitely risen by 2 percentage points", "feedback": "A change of 2 sits well inside a margin of 3, so the two figures are consistent with no change at all."},
   {"text": "Support has definitely fallen, because 46 is below 50", "feedback": "Being below half says the policy is a minority view; it says nothing about which direction it has moved."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'experimental-probability', 1, 'Easy',
 'What is experimental probability?', 3,
 '[
   {"text": "A probability worked out by counting the sample space", "feedback": "That is THEORETICAL probability. It needs no trials at all."},
   {"text": "A probability that is guaranteed to come out equal to the theoretical one", "feedback": "The two usually differ, and the gap between them is often the point of the exercise."},
   {"text": "An estimate made without collecting any data", "feedback": "Experimental probability is built entirely out of collected data."},
   {"text": "A probability worked out from the results of trials actually carried out", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'experimental-probability', 2, 'Easy',
 'A coin is tossed 100 times and lands heads 47 times. What is the experimental probability of heads?', 1,
 '[
   {"text": "47", "feedback": "That is the count of heads. A probability is that count divided by the number of trials."},
   {"text": "0.47", "feedback": "Correct."},
   {"text": "0.50", "feedback": "That is the THEORETICAL probability for a fair coin. The experimental one comes from what actually happened."},
   {"text": "0.53", "feedback": "That is the experimental probability of TAILS."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'experimental-probability', 3, 'Medium',
 'Why does experimental probability move closer to theoretical probability as the number of trials grows?', 2,
 '[
   {"text": "Because rounding errors cancel out", "feedback": "Rounding is not what is happening. The variation being smoothed out is genuine chance."},
   {"text": "It does not; the two are unrelated", "feedback": "They are closely related, and the way one approaches the other is one of the central facts of the subject."},
   {"text": "Because of the law of large numbers", "feedback": "Correct."},
   {"text": "Because the theoretical probability adjusts to match the results", "feedback": "The theoretical value is fixed by the structure of the experiment. It is the experimental one that settles down."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'experimental-probability', 4, 'Challenge',
 'A coin is tossed 10 times and lands heads 7 times. Should you conclude that it is biased?', 0,
 '[
   {"text": "No, because 10 tosses is far too few to distinguish a biased coin from an ordinary run of luck", "feedback": "Correct."},
   {"text": "Yes, because 7 out of 10 is well above one half", "feedback": "A fair coin gives seven or more heads in ten tosses about one time in six. That is not unusual enough to accuse it of anything."},
   {"text": "Yes, but only if it happens twice in a row", "feedback": "Two short runs are still a short run. What is needed is many more tosses, not a repeat of a small experiment."},
   {"text": "Only if it lands heads on all 10 tosses", "feedback": "Even ten heads in a row happens to a fair coin about once in a thousand attempts, so it is suggestive rather than conclusive."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'experimental-probability', 5, 'Challenge',
 'A simulation of 10 000 coin tosses gives an experimental probability of 0.503 where the theory says 0.5. What does that show?', 3,
 '[
   {"text": "The coin is biased by 0.003", "feedback": "Every finite run wanders a little from the long-run value. A gap this small over 10 000 trials is exactly what a fair coin produces."},
   {"text": "The theoretical probability of one half must be wrong for a coin that behaves like this", "feedback": "The theoretical value comes from the structure of the coin. A close experimental result supports it rather than undermining it."},
   {"text": "The trials must have been miscounted", "feedback": "No error is needed to explain a gap of three thousandths. Chance alone accounts for it."},
   {"text": "The result is entirely consistent with a fair coin; small departures are expected", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'experimental-probability', 6, 'Advanced',
 'A simulation of a million coin tosses returns 0.4998 where the theory says 0.5. What is the best reading of that?', 3,
 '[
   {"text": "The model is wrong by 0.0002", "feedback": "Every finite run lands near the true value rather than on it. Two ten-thousandths over a million trials is well inside the expected wobble."},
   {"text": "The simulation must have a fault", "feedback": "A simulation that returned exactly 0.500000 would be the suspicious one. Real randomness never lands that neatly."},
   {"text": "Running more trials would eventually give exactly 0.5", "feedback": "The results get closer on average but never settle on the value exactly. That is what a limit means here."},
   {"text": "Strong evidence that the model is right, since a gap this small over a million trials is exactly what chance produces", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'theoretical-probability', 1, 'Easy',
 'A die with faces numbered 1 to 20 is rolled once. What is the probability of rolling a number divisible by 5?', 1,
 '[
   {"text": "1/4", "feedback": "The 20 was divided by 5 and used as the denominator. The denominator is the total number of faces."},
   {"text": "1/5", "feedback": "Correct."},
   {"text": "1/20", "feedback": "Only one favourable outcome was counted. There are four multiples of 5 between 1 and 20."},
   {"text": "4/5", "feedback": "The favourable outcomes and the unfavourable ones were swapped. Sixteen of the twenty faces are NOT multiples of 5."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'theoretical-probability', 2, 'Easy',
 'If the probability of an event is 0.3, what is the probability that it does NOT happen?', 1,
 '[
   {"text": "1.3", "feedback": "The value was added to 1 rather than subtracted from it. No probability can exceed 1."},
   {"text": "0.7", "feedback": "Correct."},
   {"text": "0.3", "feedback": "An event and its complement have the same probability only when both are one half."},
   {"text": "-0.3", "feedback": "A probability can never be negative. The complement is found by subtracting FROM 1."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'theoretical-probability', 3, 'Medium',
 'Two fair dice are rolled. What is the probability that the sum is 7?', 2,
 '[
   {"text": "7/36", "feedback": "The target sum was used as the count of favourable outcomes. There are six ways to make 7, not seven."},
   {"text": "1/36", "feedback": "Only one favourable outcome was counted. Six different pairs add to 7."},
   {"text": "1/6", "feedback": "Correct."},
   {"text": "1/12", "feedback": "The sample space was counted as 12 outcomes rather than 36. Each die has six faces, and every pairing is a separate outcome."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'theoretical-probability', 4, 'Medium',
 'The odds in favour of an event are 3 to 7. What is the probability of the event?', 3,
 '[
   {"text": "3/7", "feedback": "Odds compare successes to FAILURES. A probability compares successes to every trial, favourable and unfavourable together."},
   {"text": "7/10", "feedback": "That is the probability that the event does NOT happen."},
   {"text": "7/3", "feedback": "The two numbers were used in the wrong order, which gives the odds AGAINST written as a fraction. No probability can be greater than 1."},
   {"text": "3/10", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'theoretical-probability', 5, 'Challenge',
 'A single card is drawn from a standard deck of 52. What is the probability that it is a heart OR a king?', 1,
 '[
   {"text": "1/52", "feedback": "Only the king of hearts was counted, which is the INTERSECTION rather than the union."},
   {"text": "4/13", "feedback": "Correct."},
   {"text": "17/52", "feedback": "The two counts were added without the overlap being removed. The king of hearts belongs to both and was counted twice."},
   {"text": "13/52", "feedback": "Only the hearts were counted. The three kings in the other suits qualify as well."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'theoretical-probability', 6, 'Challenge',
 'An event has a probability of 0. What does that mean?', 3,
 '[
   {"text": "It is unlikely but still possible", "feedback": "Unlikely events have small positive probabilities. Zero is reserved for the impossible."},
   {"text": "It is certain to occur every time", "feedback": "Certainty is a probability of 1, at the other end of the scale."},
   {"text": "The probability has not been calculated yet", "feedback": "Zero is a genuine answer rather than a placeholder."},
   {"text": "It cannot occur at all", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'theoretical-probability', 7, 'Advanced',
 'A die is rolled four times.
What is the probability of getting at least one six?', 0,
 '[
   {"text": "671/1296", "feedback": "Correct."},
   {"text": "625/1296", "feedback": "That is the probability of getting NO six at all. The complement still has to be taken."},
   {"text": "2/3", "feedback": "The single-roll probability was multiplied by four. Probabilities cannot be added up like that, and this method breaks completely at seven rolls."},
   {"text": "1/6", "feedback": "That is the probability of a six on ONE roll. Four rolls give many more chances."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'probability-using-sets', 1, 'Easy',
 'What does the intersection of A and B contain?', 1,
 '[
   {"text": "The elements that are in neither A nor B", "feedback": "That is what is left outside both circles."},
   {"text": "The elements that are in both A and B", "feedback": "Correct."},
   {"text": "The elements that are in A or in B or in both", "feedback": "That is the UNION. The intersection is the smaller of the two."},
   {"text": "The elements that are in A but not in B", "feedback": "That is a different region again, and it deliberately excludes the overlap rather than being it."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'probability-using-sets', 2, 'Easy',
 'Two events that cannot both happen on the same trial are called what?', 1,
 '[
   {"text": "Conditional", "feedback": "Conditional describes a probability computed once something else is known to have happened."},
   {"text": "Mutually exclusive", "feedback": "Correct."},
   {"text": "Independent", "feedback": "Independent events CAN both happen; the point is that one does not affect the chance of the other."},
   {"text": "Complementary", "feedback": "Complementary events cannot both happen either, but they must also cover every possibility between them, which is a stronger condition."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'probability-using-sets', 3, 'Medium',
 'For two sets, n(A) = 18, n(B) = 20, and n(A and B) = 13.
What is n(A or B)?', 2,
 '[
   {"text": "51", "feedback": "The overlap was ADDED rather than subtracted, so it has now been counted three times."},
   {"text": "12", "feedback": "The overlap was subtracted from both totals rather than from their sum, which removes it once too often."},
   {"text": "25", "feedback": "Correct."},
   {"text": "38", "feedback": "The two totals were added without the overlap being taken off. The 13 elements in both were counted twice."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'probability-using-sets', 4, 'Challenge',
 'A bus carries the basketball and hockey teams. There are 10 on the basketball team and 17 on the hockey team, and 3 students play on both.
How many seats are needed?', 2,
 '[
   {"text": "30", "feedback": "The overlap was ADDED rather than subtracted, so those three have now been counted three times."},
   {"text": "21", "feedback": "The three were subtracted from both team totals rather than once from the sum, which removes them one time too many."},
   {"text": "24", "feedback": "Correct."},
   {"text": "27", "feedback": "The two teams were added without the overlap being taken off. The three who play both were counted twice."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'probability-using-sets', 5, 'Advanced',
 'In the rule P(A or B) = P(A) + P(B) minus P(A and B), which condition on A and B covers ALL the cases in which the subtracted term vanishes?', 0,
 '[
   {"text": "When A and B are mutually exclusive", "feedback": "Correct."},
   {"text": "When A and B are independent", "feedback": "Independent events usually have a non-zero overlap; in fact their overlap is the product of the two probabilities."},
   {"text": "When A and B are complementary", "feedback": "Complementary events do make the term vanish, but they carry an extra requirement: between them they must cover every outcome. That is one case rather than all of them."},
   {"text": "Always, because the overlap is counted only once anyway", "feedback": "It is counted twice by the two separate totals, which is exactly why the rule has to take it off."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'probability-using-sets', 6, 'Advanced',
 'A and B are mutually exclusive, with P(A) = 0.4 and P(B) = 0.5.
What are P(A and B) and P(A or B)?', 3,
 '[
   {"text": "0.2 and 0.9", "feedback": "The two probabilities were multiplied to get the overlap, which is the rule for INDEPENDENT events. Mutually exclusive events have no overlap at all."},
   {"text": "0 and 0.7", "feedback": "The intersection is right but something was subtracted from the union anyway. With no overlap there is nothing to take off."},
   {"text": "0.2 and 0.7", "feedback": "Both errors at once: an overlap was invented by multiplying, and then subtracted."},
   {"text": "0 and 0.9", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'conditional-probability', 1, 'Easy',
 'How is the notation P(A given B) read?', 2,
 '[
   {"text": "The probability that A or B occurs", "feedback": "That is a union, which uses addition rather than a condition."},
   {"text": "The probability of B, given that A has occurred", "feedback": "The two have been read in the wrong order. The event before the bar is the one being asked about."},
   {"text": "The probability of A, given that B has occurred", "feedback": "Correct."},
   {"text": "The probability that A and B both occur", "feedback": "That is a joint probability, which is usually the smaller of the two."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'conditional-probability', 2, 'Medium',
 'Of 200 students, 120 play a sport and 110 play an instrument, and exactly 80 students do both.
What is the probability that a student plays an instrument, given that they play a sport?', 1,
 '[
   {"text": "8/11", "feedback": "That is the conditional probability the other way round, given that a student plays an instrument."},
   {"text": "2/3", "feedback": "Correct."},
   {"text": "80/200", "feedback": "The whole school was used as the denominator. The condition narrows it to the students who play a sport."},
   {"text": "120/200", "feedback": "That is the probability of playing a sport at all, which is what was GIVEN rather than what was asked."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'conditional-probability', 3, 'Medium',
 'Of the same 200 students, 110 play an instrument and 80 of those also play a sport.
What is the probability that a student plays a sport, given that they play an instrument?', 1,
 '[
   {"text": "110/200", "feedback": "That is the probability of playing an instrument at all, which is what was GIVEN rather than what was asked."},
   {"text": "8/11", "feedback": "Correct."},
   {"text": "2/3", "feedback": "That is the conditional probability the other way round, given that a student plays a sport."},
   {"text": "80/200", "feedback": "The whole school was used as the denominator. The condition narrows it to the students who play an instrument."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'conditional-probability', 4, 'Challenge',
 'Of 200 students, 110 play an instrument. Among the 120 who play a sport, 80 play an instrument.
Are playing a sport and playing an instrument independent?', 1,
 '[
   {"text": "It cannot be determined without knowing how many play neither", "feedback": "Everything needed is here: the unconditional probability and the conditional one can both be computed from these figures."},
   {"text": "No: the probability of playing an instrument rises from 0.55 to about 0.67 once you know the student plays a sport", "feedback": "Correct."},
   {"text": "Yes, because a student can do both", "feedback": "Being able to do both is what makes them not mutually exclusive. Independence is a different and stronger condition about probabilities."},
   {"text": "Yes, because 0.55 and 0.67 are reasonably close", "feedback": "Independence requires them to be EQUAL, not close. Any gap at all means knowing one changes the other."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'conditional-probability', 5, 'Challenge',
 'Which expression gives the probability that both A and B occur, whether or not they are independent?', 2,
 '[
   {"text": "P(A) plus P(B)", "feedback": "Adding is for a union, and even there the overlap has to be taken off."},
   {"text": "P(A) divided by P(B)", "feedback": "Division appears when isolating a conditional probability, not when combining two events."},
   {"text": "P(A) times P(B given A)", "feedback": "Correct."},
   {"text": "P(A) times P(B)", "feedback": "That is the shortcut for INDEPENDENT events only. When one affects the other it gives the wrong answer."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'conditional-probability', 6, 'Advanced',
 'A disease affects 1 per cent of people. A test is correct 99 per cent of the time on both the sick and the healthy. Someone tests positive.
Roughly what is the probability that they have the disease?', 3,
 '[
   {"text": "About 99 per cent", "feedback": "That is the accuracy of the TEST, not the probability of disease given a positive result. The two are different questions."},
   {"text": "About 1 per cent", "feedback": "That is the probability before the test was taken. A positive result raises it considerably."},
   {"text": "About 98 per cent", "feedback": "Two accuracy figures were combined. The rarity of the disease is what has been left out."},
   {"text": "About 50 per cent", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'conditional-probability', 7, 'Advanced',
 'Why is the probability of disease after a positive result so much lower than the accuracy of the test?', 0,
 '[
   {"text": "Because the disease is rare, so the 1 per cent of healthy people who test positive are as numerous as the sick who do", "feedback": "Correct."},
   {"text": "Because the test is not really 99 per cent accurate", "feedback": "It genuinely is. The surprise comes from the sizes of the two groups it is applied to."},
   {"text": "Because the sample of people tested is too small", "feedback": "The effect appears at any sample size, and gets no better with more people."},
   {"text": "Because 99 per cent accuracy means 99 per cent of positives are correct", "feedback": "That is exactly the confusion the question exists to break. Accuracy is about how the test performs on each group, not about what a positive result means."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'independent-and-dependent-events', 1, 'Easy',
 'When are two events independent?', 2,
 '[
   {"text": "When they always happen together", "feedback": "Then each one would guarantee the other, which is about as dependent as two events can be."},
   {"text": "When the two events have exactly the same probability of happening", "feedback": "Equal probabilities say nothing about whether one affects the other."},
   {"text": "When one happening does not change the probability of the other", "feedback": "Correct."},
   {"text": "When they cannot both happen", "feedback": "That is MUTUALLY EXCLUSIVE, and it is very nearly the opposite: if one happening rules the other out, it changes its probability to zero."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'independent-and-dependent-events', 2, 'Medium',
 'A fair coin is tossed twice. What is the probability of getting two heads?', 0,
 '[
   {"text": "1/4", "feedback": "Correct."},
   {"text": "1/2", "feedback": "That is the probability of a head on one toss. Two independent tosses multiply their probabilities together."},
   {"text": "1/8", "feedback": "That is the answer for THREE tosses. Two tosses give four equally likely outcomes."},
   {"text": "3/4", "feedback": "That is the probability of getting at least one head."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'independent-and-dependent-events', 3, 'Challenge',
 'A bag holds 5 red and 3 blue marbles. Two are drawn WITHOUT replacement.
What is the probability that both are red?', 2,
 '[
   {"text": "5/8", "feedback": "That is the probability that the FIRST marble is red. The second draw still has to be accounted for."},
   {"text": "1/2", "feedback": "Neither draw has this probability, and the two do not combine to it either."},
   {"text": "5/14", "feedback": "Correct."},
   {"text": "25/64", "feedback": "The two draws were treated as independent. Without replacement the first marble is gone, so the second draw faces 4 reds out of 7."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'independent-and-dependent-events', 4, 'Challenge',
 'The same bag holds 5 red and 3 blue marbles, but now the first marble is replaced before the second is drawn.
What is the probability that both are red?', 1,
 '[
   {"text": "25/8", "feedback": "Only the numerator was squared. A value larger than 1 cannot be a probability at all, which is the quickest way to catch this one."},
   {"text": "25/64", "feedback": "Correct."},
   {"text": "5/14", "feedback": "That is the answer WITHOUT replacement. Putting the marble back leaves the second draw facing the same eight marbles as the first."},
   {"text": "5/8", "feedback": "That is the probability for a single draw. Two draws multiply."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'independent-and-dependent-events', 5, 'Advanced',
 'Three cards are dealt from a standard deck without replacement. Are the three draws independent?', 2,
 '[
   {"text": "Yes, because every card in the deck is equally likely to be drawn on each deal", "feedback": "Each card is equally likely on any given draw, but the probabilities on the second draw depend on what came first."},
   {"text": "Only the first two are independent of each other", "feedback": "The second already depends on the first. There is no pair here that is independent."},
   {"text": "No, because each card removed changes what is left in the deck", "feedback": "Correct."},
   {"text": "Yes, because the deck was shuffled first", "feedback": "Shuffling makes the ORDER random. It does not put the dealt cards back."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'independent-and-dependent-events', 6, 'Advanced',
 'A and B are independent, with P(A) = 0.6 and P(B) = 0.5.
What is P(A or B)?', 0,
 '[
   {"text": "0.8", "feedback": "Correct."},
   {"text": "1.1", "feedback": "The two were added without the overlap being taken off, which pushes the answer above 1 and so cannot be a probability at all."},
   {"text": "0.3", "feedback": "That is P(A and B), the overlap itself. The question asks for the union."},
   {"text": "0.6", "feedback": "That is P(A) on its own. The part of B outside A still has to be added."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'permutations-and-combinations', 1, 'Easy',
 'What is 5 factorial?', 0,
 '[
   {"text": "120", "feedback": "Correct."},
   {"text": "25", "feedback": "The number was squared. A factorial multiplies every whole number down to 1."},
   {"text": "15", "feedback": "The numbers from 1 to 5 were added rather than multiplied."},
   {"text": "5", "feedback": "The factorial sign has to do something. It multiplies 5 by 4 by 3 by 2 by 1."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'permutations-and-combinations', 2, 'Easy',
 'In a permutation, does the order of the objects matter?', 0,
 '[
   {"text": "Yes, always", "feedback": "Correct."},
   {"text": "No, never", "feedback": "That describes a COMBINATION. The two exist as separate ideas precisely because of this difference."},
   {"text": "Only when some of the objects are repeated", "feedback": "Repeats change how many arrangements are DISTINGUISHABLE, but order matters either way."},
   {"text": "Only when there are more than three objects", "feedback": "The number of objects makes no difference to whether order counts."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'permutations-and-combinations', 3, 'Medium',
 'The word MATHEMATICS has 11 letters, with M, A and T each appearing twice.
How many distinguishable arrangements are there?', 3,
 '[
   {"text": "39 916 800", "feedback": "That is 11 factorial, which treats the two M values as different letters. Repeats have to be divided out."},
   {"text": "19 958 400", "feedback": "Only one of the three repeated letters was divided out. Each repeated pair contributes a factor of 2 to divide by."},
   {"text": "9 979 200", "feedback": "Only two of the three repeated letters were divided out. There are three letters appearing twice, not two."},
   {"text": "4 989 600", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'permutations-and-combinations', 4, 'Medium',
 'A baseball team has 15 players.
How many different nine-person batting orders can the coach make?', 3,
 '[
   {"text": "5005", "feedback": "That is the number of ways to CHOOSE nine players with no regard to order. A batting order is an order."},
   {"text": "362 880", "feedback": "That is 9 factorial, the number of ways to arrange a fixed nine. The nine still have to be chosen from fifteen."},
   {"text": "1 307 674 368 000", "feedback": "That is 15 factorial, which arranges all fifteen players. Only nine bat."},
   {"text": "1 816 214 400", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'permutations-and-combinations', 5, 'Challenge',
 'How many different committees of 3 can be formed from 8 people?', 2,
 '[
   {"text": "24", "feedback": "The 8 was multiplied by 3. Choosing three from eight is a combination, not a product."},
   {"text": "512", "feedback": "That is 8 cubed, which would allow the same person to be picked three times."},
   {"text": "56", "feedback": "Correct."},
   {"text": "336", "feedback": "That is the number of ordered arrangements. A committee is a set, so the same three people in a different order is the same committee."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'permutations-and-combinations', 6, 'Advanced',
 'A subdivision has 6 one-storey houses, 4 two-storey houses and 2 split-level houses, all in one row.
In how many distinguishable ways can they be arranged?', 3,
 '[
   {"text": "479 001 600", "feedback": "That is 12 factorial, which treats every house as different. Houses of the same type are interchangeable."},
   {"text": "924", "feedback": "That places only the six one-storey houses and treats the remaining six as interchangeable with each other. A two-storey house and a split-level house are different types."},
   {"text": "48", "feedback": "The three group sizes were multiplied together. The count comes from a factorial divided by three factorials."},
   {"text": "13 860", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'probability', 'permutations-and-combinations', 7, 'Advanced',
 'When should a combination be used rather than a permutation?', 0,
 '[
   {"text": "When the order of the chosen objects does not matter", "feedback": "Correct."},
   {"text": "When the order of the chosen objects matters", "feedback": "That is exactly when a PERMUTATION is needed. The two have been swapped."},
   {"text": "When the objects may be chosen more than once, so repeats are allowed", "feedback": "Both formulas assume each object is chosen at most once. Repetition needs a different count again."},
   {"text": "When the number of objects is large", "feedback": "The size of the problem has nothing to do with which formula is right."}
 ]'::jsonb,
 null),
('MDM4U', 'probability-distributions', 'probability-distributions', 1, 'Easy',
 'What is a random variable?', 2,
 '[
   {"text": "Any quantity whose value is unknown", "feedback": "Plenty of unknowns are fixed numbers waiting to be found. A random variable takes different values on different trials."},
   {"text": "The probability of an outcome", "feedback": "A probability is attached to a value of the random variable. It is not the variable itself."},
   {"text": "A variable whose value is the numerical outcome of a chance process", "feedback": "Correct."},
   {"text": "A variable chosen at random from the alphabet", "feedback": "The randomness is in the OUTCOME, not in which letter is used to write it down."}
 ]'::jsonb,
 null),
('MDM4U', 'probability-distributions', 'probability-distributions', 2, 'Easy',
 'In any probability distribution, what must all the probabilities add up to?', 3,
 '[
   {"text": "0", "feedback": "A total of zero would mean nothing can happen at all."},
   {"text": "100", "feedback": "That is the total in PERCENTAGES. The probabilities in a distribution are not written on that scale."},
   {"text": "The number of possible outcomes", "feedback": "That would make the total grow as the list of outcomes got longer. Something is certain to happen, however many ways there are for it to."},
   {"text": "1", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MDM4U', 'probability-distributions', 'probability-distributions', 3, 'Medium',
 'A distribution has P(0) = 0.2, P(1) = 0.5, P(2) = 0.2 and one more outcome, x = 3.
What must P(3) be?', 1,
 '[
   {"text": "0", "feedback": "The three given values total 0.9, so something is still unaccounted for."},
   {"text": "0.1", "feedback": "Correct."},
   {"text": "0.9", "feedback": "The three given probabilities were added and reported. What is missing is the amount needed to reach 1."},
   {"text": "0.3", "feedback": "Neither the sum nor the shortfall comes to this. Add the three given values and take the total from 1."}
 ]'::jsonb,
 null);