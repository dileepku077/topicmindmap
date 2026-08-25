-- MTH1W part c (continued -- no delete here, part a already cleared this course's rows)

insert into public.questions
  (course_code, unit_code, subtopic_code, sort_order, difficulty,
   prompt, correct_index, options, misconception_tag)
values
('MTH1W', 'financial-literacy', 'appreciation-and-depreciation', 4, 'Medium',
 'A car worth 30000 dollars new is worth 21000 dollars after one year. By what percentage did it depreciate?', 2,
 '[
   {"text": "21 percent", "feedback": "That reads the remaining value in thousands as a percentage."},
   {"text": "70 percent", "feedback": "That is the percentage of its value the car KEEPS. The question asks how much it lost."},
   {"text": "30 percent", "feedback": "Correct."},
   {"text": "9 percent", "feedback": "That is the drop in thousands of dollars, not a percentage of the original price."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'appreciation-and-depreciation', 5, 'Challenge',
 'A car bought for 30000 dollars keeps 70 percent of its value each year. What is it worth after 10 years?', 0,
 '[
   {"text": "847.43 dollars", "feedback": "Correct."},
   {"text": "0 dollars", "feedback": "That treats the loss as a fixed 30 percent of the ORIGINAL price each year. It is 30 percent of the CURRENT value."},
   {"text": "21000.00 dollars", "feedback": "That is its value after one year."},
   {"text": "1210.61 dollars", "feedback": "That is its value after nine years. One more year of depreciation is still to come."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'appreciation-and-depreciation', 6, 'Challenge',
 'Over 10 years, which grows more: 100 dollars gaining 20 dollars a year, or 100 dollars gaining 20 percent a year?', 3,
 '[
   {"text": "The fixed 20 dollars a year", "feedback": "A fixed gain adds the same amount every year. A percentage gain grows along with the value."},
   {"text": "They reach the same value", "feedback": "They match in the first year only. After that the percentage version pulls ahead."},
   {"text": "The percentage, but only after about 20 years", "feedback": "The crossover comes much sooner than that. Work out both at 10 years."},
   {"text": "The percentage, reaching about 619 dollars against 300 dollars", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'appreciation-and-depreciation', 7, 'Advanced',
 'A house bought for 400000 dollars appreciates at 4 percent a year. What is it worth after 12 years, to the nearest dollar?', 3,
 '[
   {"text": "592000 dollars", "feedback": "That adds 4 percent of the ORIGINAL price twelve times. Each year the percentage applies to the current value."},
   {"text": "416000 dollars", "feedback": "That is the value after one year only."},
   {"text": "615782 dollars", "feedback": "That compounds for eleven years rather than twelve."},
   {"text": "640413 dollars", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'appreciation-and-depreciation', 8, 'Advanced',
 'A laptop bought for 1500 dollars depreciates 25 percent a year. After how many whole years is it worth less than 500 dollars?', 1,
 '[
   {"text": "3 years", "feedback": "Work out the value at that point: it is still above the 500 dollar mark, though not by much."},
   {"text": "4 years", "feedback": "Correct."},
   {"text": "5 years", "feedback": "It drops below the mark before that, so this is one year later than needed."},
   {"text": "2 years", "feedback": "After that long it is still worth well over 800 dollars."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'loans-credit-and-repayment', 1, 'Easy',
 'In the monthly loan payment formula, what does r stand for?', 2,
 '[
   {"text": "The total amount repaid by the end of the loan", "feedback": "That is what the formula helps you work out, not one of its inputs."},
   {"text": "The annual interest rate, the percentage charged for a year", "feedback": "The payments happen monthly, so the rate has to be scaled down to match them."},
   {"text": "The monthly interest rate, which is the annual rate divided by 12", "feedback": "Correct."},
   {"text": "The number of payments to be made across the whole term of the loan", "feedback": "That is n, the loan term counted in months."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'loans-credit-and-repayment', 2, 'Easy',
 'Why is cash or debit usually a better choice than credit for buying groceries?', 0,
 '[
   {"text": "Because you spend only money you already have and pay no interest", "feedback": "Correct."},
   {"text": "Because debit cards give more rewards than credit cards", "feedback": "Rewards are usually a credit card feature. The advantage of debit lies elsewhere."},
   {"text": "Because credit cards never charge interest", "feedback": "They do charge interest on any balance not paid off in full."},
   {"text": "Because debit builds your credit score faster", "feedback": "Building a credit score is actually an argument FOR responsible credit card use."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'loans-credit-and-repayment', 3, 'Medium',
 'Sarah borrows 15000 dollars at 6 percent compounded monthly over a 5 year term. What is her monthly payment?', 3,
 '[
   {"text": "312.50 dollars", "feedback": "That spreads the loan over four years rather than five, and still ignores the interest."},
   {"text": "325.00 dollars", "feedback": "Five years of simple interest was added at the start rather than compounding on the falling balance."},
   {"text": "250.00 dollars", "feedback": "That divides the loan by the number of payments, which ignores the interest completely."},
   {"text": "289.99 dollars", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'loans-credit-and-repayment', 4, 'Medium',
 'Jacob borrows 12000 dollars and repays it at 381.60 dollars a month for 3 years. How much does he repay in total?', 0,
 '[
   {"text": "13737.60 dollars", "feedback": "Correct."},
   {"text": "4579.20 dollars", "feedback": "That is one year of payments. The term runs for three years."},
   {"text": "12000.00 dollars", "feedback": "That is only the amount he borrowed. The payments come to more than that."},
   {"text": "1737.60 dollars", "feedback": "That is the interest portion. The question asks for everything he hands over."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'loans-credit-and-repayment', 5, 'Challenge',
 'Emma owes 5000 dollars on a credit card charging 18 percent compounded monthly. She plans to clear it in 2 years with equal monthly payments. What is each payment?', 0,
 '[
   {"text": "249.62 dollars", "feedback": "Correct."},
   {"text": "283.33 dollars", "feedback": "That charges 18 percent on the full balance for both years. The balance falls as she pays it down."},
   {"text": "312.50 dollars", "feedback": "That spreads the debt over sixteen months rather than twenty-four, and still ignores the interest."},
   {"text": "208.33 dollars", "feedback": "That divides the balance by the number of payments, which ignores the interest completely."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'loans-credit-and-repayment', 6, 'Challenge',
 'Emma pays 249.62 dollars a month for 24 months to clear a 5000 dollar credit card balance. Roughly how much interest does she pay?', 3,
 '[
   {"text": "About 900 dollars", "feedback": "Close, but work it out exactly: total the payments, then take off what she borrowed."},
   {"text": "About 1800 dollars", "feedback": "That charges 18 percent on the full 5000 for both years. The balance shrinks as she pays."},
   {"text": "None, because she clears the balance in full", "feedback": "Clearing a balance over time still costs interest along the way. Only paying immediately avoids it."},
   {"text": "About 990 dollars", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'loans-credit-and-repayment', 7, 'Advanced',
 'Sarah could take her 15000 dollar loan at 6 percent compounded monthly over 7 years instead of 5. What happens?', 3,
 '[
   {"text": "Both the monthly payment and the total interest fall", "feedback": "Stretching a loan out means the balance carries interest for longer, so the total cost goes up."},
   {"text": "Both the monthly payment and the total interest rise", "feedback": "Spreading the same principal over more payments makes each one smaller, not larger."},
   {"text": "The monthly payment falls and the total interest stays the same", "feedback": "Interest is charged on the outstanding balance each month, so more months means more interest."},
   {"text": "The monthly payment falls but the total interest paid rises", "feedback": "Correct."}
 ]'::jsonb,
 null),
('MTH1W', 'financial-literacy', 'loans-credit-and-repayment', 8, 'Advanced',
 'Jacob borrows 12000 dollars at 9 percent compounded monthly for 3 years, paying 381.60 dollars a month. How much interest does he pay in total?', 2,
 '[
   {"text": "13737.60 dollars", "feedback": "That is everything he hands over. The interest is what is left after the loan itself is taken off."},
   {"text": "1080.00 dollars", "feedback": "That is one year of interest on the full balance. The loan runs for three years."},
   {"text": "1737.60 dollars", "feedback": "Correct."},
   {"text": "3240.00 dollars", "feedback": "That charges 9 percent on the full 12000 for all three years. The balance falls with every payment."}
 ]'::jsonb,
 null);