-- Original SSC JE Mechanical Paper I practice mock.
-- Questions are newly authored from broad syllabus areas and do not use
-- questions, options, or answer keys from the supplied paper.
-- Run after the student learning schema and mock_simulation_functions.sql.

DO $seed$
DECLARE
    v_branch_id UUID;
    v_subject_id UUID;
    v_test_id UUID;
    v_question_count INT;
BEGIN
    SELECT id INTO v_branch_id
    FROM public.engineering_branches
    WHERE name = 'Mechanical Engineering'
    LIMIT 1;

    IF v_branch_id IS NULL THEN
        INSERT INTO public.engineering_branches (name, code, description, is_active)
        VALUES (
            'Mechanical Engineering',
            CASE WHEN EXISTS (SELECT 1 FROM public.engineering_branches WHERE code = 'ME')
                 THEN 'ME-' || upper(substr(replace(gen_random_uuid()::TEXT, '-', ''), 1, 8))
                 ELSE 'ME' END,
            'Mechanical engineering branch',
            TRUE
        )
        RETURNING id INTO v_branch_id;
    END IF;

    INSERT INTO public.subjects (branch_id, name, code, description, display_order, is_active)
    VALUES (
        v_branch_id,
        'Mechanical Engineering',
        CASE WHEN EXISTS (SELECT 1 FROM public.subjects WHERE code = 'ME')
             THEN 'ME-' || upper(substr(replace(gen_random_uuid()::TEXT, '-', ''), 1, 8))
             ELSE 'ME' END,
        'Mechanical engineering subjects and SSC JE practice',
        0,
        TRUE
    )
    ON CONFLICT (branch_id, name) DO NOTHING;

    SELECT id INTO v_subject_id
    FROM public.subjects
    WHERE branch_id = v_branch_id AND name = 'Mechanical Engineering'
    LIMIT 1;

    IF v_subject_id IS NULL THEN
        RAISE EXCEPTION 'Could not create or find Mechanical Engineering subject';
    END IF;

    SELECT id INTO v_test_id
    FROM public.mock_tests
    WHERE title = 'Junior Engineer 2024 Mechanical Paper I'
    LIMIT 1;

    IF v_test_id IS NULL THEN
        INSERT INTO public.mock_tests (
            title, description, exam_type, subject_id, duration_minutes,
            total_marks, passing_marks, is_published
        )
        VALUES (
            'Junior Engineer 2024 Mechanical Paper I',
            'Original 200-question SSC JE Paper I style practice test covering reasoning, general awareness, and mechanical engineering. Each question carries one mark; incorrect answers carry 0.25 negative marks. Questions are newly authored and are not copied from the referenced paper.',
            'OTHER',
            v_subject_id,
            120,
            200,
            100,
            TRUE
        )
        RETURNING id INTO v_test_id;
    ELSE
        UPDATE public.mock_tests
        SET description = 'Original 200-question SSC JE Paper I style practice test covering reasoning, general awareness, and mechanical engineering. Each question carries one mark; incorrect answers carry 0.25 negative marks. Questions are newly authored and are not copied from the referenced paper.',
            exam_type = 'OTHER',
            subject_id = v_subject_id,
            duration_minutes = 120,
            total_marks = 200,
            passing_marks = 100,
            is_published = TRUE
        WHERE id = v_test_id;
    END IF;

    SELECT count(*) INTO v_question_count
    FROM public.mock_questions
    WHERE mock_test_id = v_test_id;

    IF v_question_count = 200 THEN
        UPDATE public.mock_questions
        SET marks = 1, negative_marks = 0.25
        WHERE mock_test_id = v_test_id;
        RAISE NOTICE 'Mock already has 200 questions; leaving its question set unchanged.';
        RETURN;
    ELSIF v_question_count <> 0 THEN
        RAISE EXCEPTION 'Mock has % questions. Expected 0 or 200; refusing to duplicate or replace existing questions.', v_question_count;
    END IF;

    INSERT INTO public.mock_questions (
        mock_test_id, question_text, question_type, options, correct_answer,
        marks, negative_marks, display_order
    )
    SELECT
        v_test_id,
        CASE
            WHEN q.display_order <= 50 THEN '[General Intelligence and Reasoning] ' || q.question_text
            WHEN q.display_order <= 100 THEN '[General Awareness] ' || q.question_text
            ELSE '[General Engineering Mechanical] ' || q.question_text
        END,
        'mcq',
        jsonb_build_array(
            jsonb_build_object('value', 'A', 'text', q.option_a),
            jsonb_build_object('value', 'B', 'text', q.option_b),
            jsonb_build_object('value', 'C', 'text', q.option_c),
            jsonb_build_object('value', 'D', 'text', q.option_d)
        ),
        q.correct_answer,
        1,
        0.25,
        q.display_order
    FROM (VALUES
        -- General Intelligence and Reasoning (1-50)
        (1, 'Choose the next number: 5, 11, 23, 47, 95, ?', '181', '189', '191', '193', 'C'),
        (2, 'Find the missing term: 3, 8, 15, 24, 35, ?', '44', '46', '48', '50', 'C'),
        (3, 'Choose the next letter: C, F, J, O, U, ?', 'A', 'B', 'C', 'D', 'B'),
        (4, 'If each letter is replaced by the next letter of the alphabet, how is SHAFT written?', 'TIBGU', 'TIBFU', 'R GZES', 'TICGU', 'A'),
        (5, 'In a code, TABLE is written as UBCMF. How is CHAIR written?', 'DIBJS', 'DIBJR', 'DIBKS', 'BIBJS', 'A'),
        (6, 'Select the item that does not belong with the others.', 'Cylinder', 'Cone', 'Sphere', 'Rectangle', 'D'),
        (7, 'Select the item that does not belong with the others.', 'Copper', 'Zinc', 'Brass', 'Timber', 'D'),
        (8, 'Blueprint is to building as algorithm is to:', 'Computer program', 'Keyboard', 'Electricity', 'Printer', 'A'),
        (9, 'Compass is to direction as stopwatch is to:', 'Distance', 'Time', 'Mass', 'Temperature', 'B'),
        (10, 'A person walks 7 m east, then 4 m north, then 7 m west. How far and in which direction are they from the start?', '4 m north', '4 m south', '7 m east', '7 m west', 'A'),
        (11, 'Facing north, Rina turns right, then turns left twice. Which direction is she facing?', 'North', 'South', 'East', 'West', 'D'),
        (12, 'A student is 14th from the left and 9th from the right in a row. How many students are there?', '21', '22', '23', '24', 'B'),
        (13, 'M is heavier than N. P is lighter than N. Q is heavier than M. Who is heaviest?', 'M', 'N', 'P', 'Q', 'D'),
        (14, 'All gears are machine elements. Some machine elements are alloy steel. Which statement must be true?', 'All gears are alloy steel', 'Some gears are alloy steel', 'All gears are machine elements', 'No gear is alloy steel', 'C'),
        (15, 'All inspectors are trained. No trained person is careless. Which conclusion follows?', 'No inspector is careless', 'All careless people are inspectors', 'Some inspectors are careless', 'No inspector is trained', 'A'),
        (16, 'Some tools are electric. All electric tools need power. Which conclusion follows?', 'All tools need power', 'Some tools need power', 'No tool needs power', 'All powered devices are tools', 'B'),
        (17, 'If X is greater than Y, Y equals Z, and Z is greater than W, which is true?', 'X is greater than W', 'W is greater than X', 'X equals W', 'Y is less than W', 'A'),
        (18, 'Four workers finish a job in 15 days at a constant rate. How many days would 10 workers need?', '5', '6', '8', '10', 'B'),
        (19, 'What is the smaller angle between the hands of a clock at 4:00?', '90 degrees', '100 degrees', '120 degrees', '140 degrees', 'C'),
        (20, 'At 9:00, what is the angle between the hour and minute hands?', '45 degrees', '90 degrees', '135 degrees', '180 degrees', 'B'),
        (21, 'If today is Thursday, what day will it be 52 days from today?', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'C'),
        (22, 'A 30-day month starts on a Saturday. On which day does it end?', 'Sunday', 'Monday', 'Tuesday', 'Saturday', 'A'),
        (23, 'Find the next number: 2, 6, 12, 20, 30, ?', '38', '40', '42', '44', 'C'),
        (24, 'Find the next number: 128, 64, 32, 16, ?', '4', '6', '8', '10', 'C'),
        (25, 'When the letters of MOTOR are arranged alphabetically, which letter is in the middle?', 'M', 'O', 'R', 'T', 'B'),
        (26, 'How many letters lie between the 4th letter from the beginning and the 5th letter from the end of the alphabet?', '15', '16', '17', '18', 'C'),
        (27, 'A is the father of B. B is the sister of C. How is A related to C?', 'Uncle', 'Father', 'Brother', 'Grandfather', 'B'),
        (28, 'R is the brother of S. S is the mother of T. How is R related to T?', 'Paternal uncle', 'Maternal uncle', 'Brother', 'Grandfather', 'B'),
        (29, 'Four people stand in a line. J is before K, K is before L, and M is after L. Who is third in line?', 'J', 'K', 'L', 'M', 'C'),
        (30, 'Four containers are stacked. P is above Q, R is below Q, and S is above P. Which is lowest?', 'P', 'Q', 'R', 'S', 'C'),
        (31, 'If 1 March is a Wednesday in a non-leap year, what day is 1 April?', 'Friday', 'Saturday', 'Sunday', 'Monday', 'B'),
        (32, 'Choose the pair with the same relationship as 9:81.', '7:42', '8:64', '6:30', '5:20', 'B'),
        (33, 'A two-digit number has digit sum 9. Reversing its digits increases it by 27. What is the number?', '36', '45', '54', '63', 'A'),
        (34, 'Six identical pumps fill six equal tanks in 12 minutes. How long do 12 pumps take to fill 12 such tanks?', '6 minutes', '12 minutes', '18 minutes', '24 minutes', 'B'),
        (35, 'A technician is 8 years older than twice a trainee age. If the technician is 36, how old is the trainee?', '12', '14', '16', '18', 'B'),
        (36, 'Complete the letter pair sequence: AZ, CX, EV, GT, ?', 'IR', 'HS', 'IQ', 'JR', 'A'),
        (37, 'In the word MACHINE, which letter is third from the right?', 'H', 'I', 'N', 'C', 'D'),
        (38, 'Which number is different from the others?', '27', '64', '125', '196', 'D'),
        (39, 'Point B is 6 m north of A. Point C is 8 m east of B. In which direction is C from A?', 'North-east', 'North-west', 'South-east', 'South-west', 'A'),
        (40, 'A vehicle travels 9 km west and 12 km south. What is its straight-line distance from its starting point?', '13 km', '15 km', '18 km', '21 km', 'B'),
        (41, 'In a queue, Arun is 11th from the front and 8th from the back. How many people are in the queue?', '17', '18', '19', '20', 'B'),
        (42, 'All P are Q and all Q are R. Which statement necessarily follows?', 'All R are P', 'All P are R', 'No P are R', 'Some R are not Q', 'B'),
        (43, 'Which word cannot be formed using the letters of TRANSMISSION?', 'MOTION', 'STAIN', 'NATION', 'TRAINER', 'D'),
        (44, 'If 1 means A, 2 means B, and so on, what is the code for CAB?', '312', '321', '213', '123', 'A'),
        (45, 'A 150 m train passes a post in 10 seconds. What is its speed?', '45 km/h', '54 km/h', '60 km/h', '72 km/h', 'B'),
        (46, 'In a group of 50 people, 28 like tea, 24 like coffee, and 10 like both. How many like neither?', '6', '8', '10', '12', 'B'),
        (47, 'Find the next pair: BC, EF, HI, KL, ?', 'MN', 'NO', 'OP', 'PQ', 'B'),
        (48, 'If the 5th day of a month is Monday, what day is the 26th?', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'B'),
        (49, 'Three times a number minus 5 is 31. What is the number?', '10', '11', '12', '13', 'C'),
        (50, 'A person faces east, turns left, then right, then right. Which direction do they face?', 'North', 'South', 'East', 'West', 'B'),

        -- General Awareness (51-100)
        (51, 'Which part of the Constitution of India contains the Fundamental Rights?', 'Part II', 'Part III', 'Part IV', 'Part V', 'B'),
        (52, 'Which article guarantees equality before the law and equal protection of laws?', 'Article 14', 'Article 17', 'Article 21', 'Article 32', 'A'),
        (53, 'Who is the ex-officio Chairperson of the Rajya Sabha?', 'President of India', 'Prime Minister', 'Vice-President of India', 'Speaker of Lok Sabha', 'C'),
        (54, 'The minimum age to be elected to the Rajya Sabha is:', '25 years', '30 years', '35 years', '40 years', 'B'),
        (55, 'Which constitutional body conducts elections to Parliament and State Legislatures?', 'Union Public Service Commission', 'Election Commission of India', 'Finance Commission', 'Comptroller and Auditor General', 'B'),
        (56, 'Fundamental Duties are listed in which article of the Constitution?', 'Article 32', 'Article 51A', 'Article 110', 'Article 280', 'B'),
        (57, 'Which is the highest judicial authority in India?', 'Supreme Court of India', 'High Court of Delhi', 'Parliament', 'Law Commission', 'A'),
        (58, 'The Rajya Sabha is a permanent House because:', 'It cannot be dissolved and members retire in rotation', 'Its members serve for life', 'It is not part of Parliament', 'It has no elected members', 'A'),
        (59, 'Which river is the longest river flowing entirely within India?', 'Godavari', 'Narmada', 'Mahanadi', 'Kaveri', 'A'),
        (60, 'Which Indian state has the longest coastline?', 'Andhra Pradesh', 'Gujarat', 'Tamil Nadu', 'Kerala', 'B'),
        (61, 'The Tropic of Cancer passes through how many states in India?', '6', '7', '8', '9', 'C'),
        (62, 'Which soil is commonly associated with the Deccan Trap region?', 'Black soil', 'Laterite soil', 'Desert soil', 'Mountain soil', 'A'),
        (63, 'The Malwa Plateau lies mainly in which region?', 'Central India', 'Eastern Himalaya', 'Western coastal plain', 'Brahmaputra valley', 'A'),
        (64, 'The Sundarbans delta is formed mainly by which river system?', 'Ganga-Brahmaputra-Meghna', 'Indus-Sutlej-Beas', 'Godavari-Krishna', 'Narmada-Tapi', 'A'),
        (65, 'Which pass links the Kashmir Valley with Ladakh?', 'Zoji La', 'Nathu La', 'Shipki La', 'Palghat Gap', 'A'),
        (66, 'The Battle of Plassey was fought in:', '1757', '1764', '1772', '1857', 'A'),
        (67, 'Who founded the Mauryan Empire?', 'Ashoka', 'Chandragupta Maurya', 'Bindusara', 'Harsha', 'B'),
        (68, 'The Non-Cooperation Movement began in:', '1917', '1919', '1920', '1930', 'C'),
        (69, 'Who chaired the Drafting Committee of the Constituent Assembly?', 'B. R. Ambedkar', 'Rajendra Prasad', 'Jawaharlal Nehru', 'C. Rajagopalachari', 'A'),
        (70, 'The Permanent Settlement in Bengal was introduced by:', 'Lord Cornwallis', 'Lord Curzon', 'Lord Dalhousie', 'Lord Ripon', 'A'),
        (71, 'Which gas makes up the largest fraction of Earth atmosphere?', 'Oxygen', 'Nitrogen', 'Carbon dioxide', 'Hydrogen', 'B'),
        (72, 'Which vitamin can be synthesized in human skin following exposure to sunlight?', 'Vitamin A', 'Vitamin C', 'Vitamin D', 'Vitamin K', 'C'),
        (73, 'The SI unit of electric current is:', 'Coulomb', 'Ampere', 'Volt', 'Ohm', 'B'),
        (74, 'Which blood component is chiefly responsible for oxygen transport?', 'Red blood cells', 'Platelets', 'Plasma proteins', 'White blood cells', 'A'),
        (75, 'A solution with pH 4 is:', 'Acidic', 'Neutral', 'Basic', 'Always pure water', 'A'),
        (76, 'Which instrument measures atmospheric pressure?', 'Barometer', 'Thermometer', 'Anemometer', 'Hygrometer', 'A'),
        (77, 'The approximate speed of light in vacuum is:', '3 x 10^6 m/s', '3 x 10^7 m/s', '3 x 10^8 m/s', '3 x 10^9 m/s', 'C'),
        (78, 'Which metal is liquid at ordinary room temperature?', 'Mercury', 'Aluminium', 'Copper', 'Iron', 'A'),
        (79, 'Loss of water vapour from plant leaves is called:', 'Transpiration', 'Respiration', 'Pollination', 'Germination', 'A'),
        (80, 'Which organ filters blood and produces urine?', 'Kidney', 'Lung', 'Pancreas', 'Stomach', 'A'),
        (81, 'The headquarters of the Reserve Bank of India is in:', 'Mumbai', 'New Delhi', 'Kolkata', 'Chennai', 'A'),
        (82, 'GST in India is primarily a:', 'Destination-based indirect tax', 'Direct tax on salary', 'Tax on exports only', 'Local land tax', 'A'),
        (83, 'Which organisation compiles India national accounts statistics?', 'National Statistical Office', 'Election Commission', 'NITI Aayog', 'Securities and Exchange Board of India', 'A'),
        (84, 'The repo rate is the rate at which:', 'RBI lends funds to commercial banks against eligible securities', 'Banks lend to retail customers', 'Government lends to households', 'Companies borrow from the stock exchange', 'A'),
        (85, 'Which institution audits the accounts of the Union and State governments?', 'Comptroller and Auditor General of India', 'Attorney General of India', 'Finance Commission', 'Cabinet Secretariat', 'A'),
        (86, 'The headquarters of UNESCO is located in:', 'Paris', 'Geneva', 'New York', 'Rome', 'A'),
        (87, 'The United Nations came into existence in:', '1945', '1919', '1948', '1955', 'A'),
        (88, 'Which Indian lunar mission achieved a soft landing near the Moon south polar region in 2023?', 'Chandrayaan-1', 'Chandrayaan-2', 'Chandrayaan-3', 'Mangalyaan', 'C'),
        (89, 'Most of Earth protective ozone layer lies in the:', 'Stratosphere', 'Troposphere', 'Mesosphere', 'Exosphere', 'A'),
        (90, 'Which is a renewable energy source?', 'Solar energy', 'Coal', 'Petroleum', 'Natural gas', 'A'),
        (91, 'The Ramsar Convention is concerned with conservation of:', 'Wetlands', 'Tropical deserts', 'Mountain ranges', 'Mineral deposits', 'A'),
        (92, 'Kaziranga National Park is especially known for the:', 'One-horned rhinoceros', 'Asiatic lion', 'Snow leopard', 'Wild ass', 'A'),
        (93, 'Kathakali is a classical dance-drama tradition associated with:', 'Kerala', 'Punjab', 'Assam', 'Gujarat', 'A'),
        (94, 'Biodiversity includes variation at which levels?', 'Genetic, species and ecosystem levels', 'Rainfall and temperature only', 'Soil and rock types only', 'Population size only', 'A'),
        (95, 'Which is the largest planet in the Solar System?', 'Jupiter', 'Saturn', 'Earth', 'Neptune', 'A'),
        (96, 'A galvanometer is used to detect:', 'Small electric currents', 'Atmospheric moisture', 'Sound frequency', 'Liquid density', 'A'),
        (97, 'Ahmedabad is situated on the banks of which river?', 'Sabarmati', 'Tapi', 'Mahi', 'Luni', 'A'),
        (98, 'The Dandi March of 1930 protested against the:', 'Salt tax', 'Forest laws', 'Partition of Bengal', 'Rowlatt Act', 'A'),
        (99, 'Which of these is generally a kharif crop in India?', 'Rice', 'Wheat', 'Mustard', 'Gram', 'A'),
        (100, 'Which constitutional authority is appointed to audit public expenditure in India?', 'Comptroller and Auditor General', 'Chief Election Commissioner', 'Attorney General', 'Chief Justice of India', 'A'),

        -- General Engineering Mechanical (101-200)
        (101, 'A 12 kN force acts perpendicular to a 0.25 m lever arm. What moment does it produce?', '1.5 kN m', '2.0 kN m', '3.0 kN m', '4.8 kN m', 'C'),
        (102, 'The centroid of a uniform rectangular plate lies at its:', 'Geometric centre', 'Lower-left corner', 'Longer edge', 'Point of maximum thickness', 'A'),
        (103, 'The SI unit of moment of inertia of an area is:', 'm^2', 'm^3', 'm^4', 'kg m^2', 'C'),
        (104, 'For a body in planar static equilibrium, the independent equilibrium equations are:', 'Sum Fx = 0, sum Fy = 0, sum moments = 0', 'Sum forces = mass times velocity', 'Sum moments = angular velocity', 'Sum Fx = sum Fy only', 'A'),
        (105, 'A couple consists of two forces that are:', 'Equal, opposite and separated by a distance', 'Equal and parallel in the same direction', 'Unequal and concurrent', 'Perpendicular and concurrent', 'A'),
        (106, 'Work done by a constant force is the product of force and:', 'Displacement in the force direction', 'Time squared', 'Mass density', 'Acceleration only', 'A'),
        (107, 'The coefficient of friction is the ratio of limiting friction to:', 'Normal reaction', 'Tangential velocity', 'Contact area', 'Body weight in every orientation', 'A'),
        (108, 'The angular velocity of a wheel rotating at 120 rpm is approximately:', '2 pi rad/s', '4 pi rad/s', '8 pi rad/s', '120 pi rad/s', 'B'),
        (109, 'The impulse of a force equals the change in:', 'Linear momentum', 'Potential energy', 'Angular displacement', 'Mass density', 'A'),
        (110, 'The centre of gravity of a homogeneous sphere is at its:', 'Geometric centre', 'Surface', 'Lowest point', 'Pole only', 'A'),
        (111, 'Normal stress is defined as:', 'Axial force divided by cross-sectional area', 'Force multiplied by length', 'Area divided by force', 'Shear force divided by length', 'A'),
        (112, 'Within the linear elastic range, Hooke law states that stress is proportional to:', 'Strain', 'Strain squared', 'Cross-sectional area', 'Poisson ratio only', 'A'),
        (113, 'The SI unit of Young modulus is:', 'Pa', 'Pa m', 'm/Pa', 'N m', 'A'),
        (114, 'A uniform bar of length L is fixed at one end and loaded axially by P. For elastic modulus E and area A, its extension is:', 'PL/AE', 'PA/LE', 'AE/PL', 'P/AL', 'A'),
        (115, 'Poisson ratio is the magnitude of the ratio of:', 'Lateral strain to longitudinal strain', 'Stress to strain', 'Shear stress to normal stress', 'Bulk modulus to density', 'A'),
        (116, 'The maximum bending stress in a beam is given by:', 'My/I', 'MI/y', 'Iy/M', 'M/(Iy)', 'A'),
        (117, 'For a simply supported beam with a central point load W and span L, the maximum bending moment is:', 'WL/4', 'WL/8', 'WL/2', 'W/L', 'A'),
        (118, 'For a beam, the rate of change of bending moment along its length equals:', 'Shear force', 'Load intensity squared', 'Deflection', 'Elastic modulus', 'A'),
        (119, 'The neutral axis of a homogeneous beam section passes through the:', 'Centroid of the section', 'Topmost fibre', 'Support reaction', 'Shear force diagram peak', 'A'),
        (120, 'Euler critical load for a slender pin-ended column varies inversely with:', 'Square of effective length', 'Effective length', 'Area only', 'Density only', 'A'),
        (121, 'In a closed thermodynamic system, mass crosses the boundary:', 'No', 'Continuously', 'Only at constant pressure', 'Only during compression', 'A'),
        (122, 'The zeroth law of thermodynamics establishes the concept of:', 'Temperature and thermal equilibrium', 'Entropy generation', 'Work potential', 'Specific heat at constant volume', 'A'),
        (123, 'For an ideal gas, the equation of state is:', 'pV = mRT', 'pT = mRV', 'pV = mR/T', 'p = mVT/R', 'A'),
        (124, 'For a fixed mass of ideal gas, if absolute temperature doubles at constant volume, pressure:', 'Doubles', 'Halves', 'Remains unchanged', 'Becomes four times', 'A'),
        (125, 'For an ideal gas, internal energy is a function primarily of:', 'Temperature', 'Pressure alone', 'Volume alone', 'Container shape', 'A'),
        (126, 'The first law of thermodynamics is an expression of conservation of:', 'Energy', 'Mass density', 'Momentum only', 'Entropy only', 'A'),
        (127, 'During an isothermal process for an ideal gas, the change in internal energy is:', 'Zero', 'Equal to heat input always', 'Equal to work output always', 'Negative for every expansion', 'A'),
        (128, 'For a reversible adiabatic process, entropy change is:', 'Zero', 'Always positive', 'Always negative', 'Equal to pressure change', 'A'),
        (129, 'The thermal efficiency of a heat engine is:', 'Net work output divided by heat supplied', 'Heat rejected divided by work input', 'Work input divided by heat rejected', 'Heat supplied divided by mass', 'A'),
        (130, 'The maximum possible efficiency of a heat engine operating between fixed temperature limits is that of the:', 'Carnot cycle', 'Otto cycle only', 'Diesel cycle only', 'Rankine cycle only', 'A'),
        (131, 'In a simple Rankine cycle, the pump raises the pressure of water:', 'Before it enters the boiler', 'After it leaves the turbine', 'Inside the condenser', 'After superheating', 'A'),
        (132, 'Superheating steam at a fixed boiler pressure generally:', 'Raises its temperature above saturation temperature', 'Converts it directly to liquid', 'Reduces its specific volume to zero', 'Eliminates the need for a turbine', 'A'),
        (133, 'A boiler economizer uses flue-gas heat to warm:', 'Feedwater', 'Combustion air only', 'Lubricating oil', 'Condenser cooling water only', 'A'),
        (134, 'A convergent-divergent nozzle accelerates a gas to supersonic speed when the flow is:', 'Choked at the throat and expands in the diverging section', 'Subsonic everywhere with no pressure drop', 'At zero mass flow', 'Incompressible and at rest', 'A'),
        (135, 'The calorific value of a fuel is the heat released by:', 'Complete combustion of a unit quantity of fuel', 'Partial oxidation of a unit volume of air', 'Vaporization of water only', 'Cooling the fuel below freezing', 'A'),
        (136, 'The stoichiometric air-fuel ratio supplies:', 'Theoretical air required for complete combustion', 'Only half the required oxygen', 'Excess fuel for smoke production', 'Air without oxygen', 'A'),
        (137, 'A four-stroke engine completes one cycle in:', 'Two crankshaft revolutions', 'One crankshaft revolution', 'Four crankshaft revolutions', 'Half a crankshaft revolution', 'A'),
        (138, 'In a compression-ignition engine, ignition occurs because:', 'Fuel injected into hot compressed air self-ignites', 'A spark plug ignites a premixed charge', 'The exhaust valve heats the fuel', 'The piston is cooled suddenly', 'A'),
        (139, 'The compression ratio of an engine is the ratio of:', 'Cylinder volume at BDC to volume at TDC', 'Volume at TDC to volume at BDC', 'Swept volume to clearance volume only', 'Fuel volume to air volume', 'A'),
        (140, 'The function of a flywheel in an engine is to:', 'Reduce cyclic speed fluctuation by storing and releasing energy', 'Control the fuel-air ratio', 'Open the inlet valve', 'Increase cylinder compression ratio', 'A'),
        (141, 'The continuity equation for steady incompressible flow through a duct is:', 'A1V1 = A2V2', 'A1/V1 = A2/V2', 'A1 + V1 = A2 + V2', 'A1V2 = A2V1 in all cases', 'A'),
        (142, 'The SI unit of dynamic viscosity is:', 'Pa s', 'm^2/s', 'N/m^2 only', 'kg/m^3', 'A'),
        (143, 'Reynolds number represents the ratio of:', 'Inertial forces to viscous forces', 'Pressure to temperature', 'Gravity to surface tension only', 'Elastic force to weight', 'A'),
        (144, 'In a static liquid, pressure at a depth h below the free surface is:', 'rho g h', 'rho h/g', 'g h/rho', 'rho g/h', 'A'),
        (145, 'The centre of pressure on a vertical submerged plane is generally located:', 'Below the centroid', 'Above the centroid', 'At the free surface', 'Outside the plane in every case', 'A'),
        (146, 'Bernoulli equation for ideal steady flow expresses conservation of:', 'Mechanical energy per unit weight along a streamline', 'Mass alone at a wall', 'Temperature across a shock', 'Viscosity in every flow', 'A'),
        (147, 'A venturimeter determines flow rate using pressure difference and:', 'Continuity and Bernoulli relations', 'Fourier law', 'Hooke law', 'Coulomb friction only', 'A'),
        (148, 'The Darcy-Weisbach equation estimates:', 'Pipe friction head loss', 'Pump speed', 'Boiler efficiency', 'Fluid specific heat', 'A'),
        (149, 'A hydraulic jump in an open channel changes flow from:', 'Supercritical to subcritical', 'Subcritical to supercritical', 'Laminar to static', 'Uniform to vacuum', 'A'),
        (150, 'The Froude number of critical open-channel flow is:', '1', '0', 'Less than 0', 'Infinite for every channel', 'A'),
        (151, 'The main purpose of a lathe machine is to produce components by:', 'Rotating the workpiece against a cutting tool', 'Rotating only the cutting tool around a fixed part', 'Abrasive blasting without a tool', 'Plastic deformation in a closed die only', 'A'),
        (152, 'In milling, the primary cutting motion is provided by:', 'Rotating multi-point cutter', 'Reciprocating workpiece only', 'Stationary abrasive belt', 'Linear motion of the tailstock', 'A'),
        (153, 'A twist drill is commonly used to make:', 'Cylindrical holes', 'External threads only', 'Flat gears', 'Tapered shafts without rotation', 'A'),
        (154, 'The rake angle of a cutting tool mainly affects:', 'Chip flow and cutting forces', 'Workpiece density', 'Machine foundation stiffness only', 'Coolant boiling point', 'A'),
        (155, 'Built-up edge formation is most likely when machining:', 'Ductile material under conditions favouring adhesion', 'A brittle ceramic with no contact', 'A liquid workpiece', 'Wood with a blunt saw only', 'A'),
        (156, 'The principal function of cutting fluid is to:', 'Cool and lubricate the cutting zone', 'Increase workpiece hardness by itself', 'Replace the cutting tool', 'Increase chip thickness deliberately', 'A'),
        (157, 'In arc welding, heat is generated mainly by:', 'An electric arc between electrode and work', 'A chemical bath at room temperature', 'Mechanical friction in a bearing', 'Solar radiation only', 'A'),
        (158, 'A casting riser is provided to:', 'Feed molten metal to compensate for solidification shrinkage', 'Remove all mould sand', 'Cool the casting faster than the mould', 'Create a permanent vent hole', 'A'),
        (159, 'Forging shapes metal primarily through:', 'Plastic deformation under compressive forces', 'Evaporation of the workpiece', 'Electrochemical deposition only', 'Brittle fracture', 'A'),
        (160, 'In powder metallurgy, a common process sequence is:', 'Powder production, compaction, sintering', 'Melting, distillation, quenching', 'Casting, rolling, carburizing', 'Welding, extrusion, annealing only', 'A'),
        (161, 'A gear train with a 20-tooth driver and 60-tooth driven gear has a driven speed that is:', 'One-third of driver speed', 'Three times driver speed', 'Equal to driver speed', 'Independent of tooth counts', 'A'),
        (162, 'A belt drive can transmit power between shafts by:', 'Friction between belt and pulley', 'Hydrostatic pressure in the belt', 'Magnetic attraction only', 'Gear tooth contact', 'A'),
        (163, 'The purpose of a clutch is to:', 'Engage or disengage power transmission between shafts', 'Convert AC to DC', 'Measure shaft torque without contact', 'Prevent all engine braking', 'A'),
        (164, 'A flywheel stores energy as:', 'Rotational kinetic energy', 'Chemical energy in fuel', 'Elastic energy in a spring only', 'Gravitational potential energy only', 'A'),
        (165, 'A governor in an engine regulates:', 'Mean speed as load changes', 'Instantaneous torque to zero', 'Cylinder bore diameter', 'Valve clearance during machining', 'A'),
        (166, 'In simple harmonic motion, acceleration is:', 'Proportional to displacement and directed toward the mean position', 'Constant and directed away from the mean position', 'Proportional to velocity only', 'Always zero at the extremes', 'A'),
        (167, 'A cam and follower mechanism converts:', 'Rotary motion into a prescribed reciprocating or oscillating motion', 'Heat into electricity', 'Linear motion into fluid pressure only', 'Torque into chemical energy', 'A'),
        (168, 'The critical speed of a rotating shaft is associated with:', 'Resonance between rotational excitation and lateral natural frequency', 'Maximum static friction', 'Minimum bearing clearance only', 'Zero shaft mass', 'A'),
        (169, 'The efficiency of a screw jack is the ratio of:', 'Useful output work to input work', 'Input work to useful output work', 'Load to screw weight', 'Pitch to effort arm', 'A'),
        (170, 'A simple harmonic oscillator has a natural period that depends on mass m and stiffness k as:', '2 pi sqrt(m/k)', '2 pi sqrt(k/m)', 'm/k', 'k/m', 'A'),
        (171, 'The endurance limit of a material is the stress amplitude below which it can withstand:', 'A very large number of load cycles without fatigue failure', 'One static load only', 'Only compressive loads at high temperature', 'Plastic deformation in one cycle', 'A'),
        (172, 'A key between a shaft and hub is primarily used to transmit:', 'Torque', 'Axial thrust only', 'Heat', 'Lubricant pressure', 'A'),
        (173, 'A rolling-element bearing reduces friction mainly by replacing sliding contact with:', 'Rolling contact', 'Fluid combustion', 'Plastic impact', 'Magnetic repulsion only', 'A'),
        (174, 'A helical spring under axial load primarily experiences wire:', 'Torsional shear stress', 'Pure hydrostatic pressure', 'Zero stress', 'Only longitudinal compression', 'A'),
        (175, 'A factor of safety is commonly defined as:', 'Failure strength divided by allowable working stress', 'Working stress divided by failure strength', 'Strain divided by modulus', 'Load divided by displacement', 'A'),
        (176, 'A ductile material under a uniaxial tensile test typically fails after:', 'Significant plastic deformation', 'No measurable strain', 'Instantaneous elastic recovery only', 'Complete melting', 'A'),
        (177, 'The Brinell hardness test uses an indenter that is typically a:', 'Hard ball', 'Diamond cone only', 'Flat-ended steel bar', 'Pendulum hammer', 'A'),
        (178, 'Annealing steel generally involves heating followed by:', 'Controlled slow cooling', 'Rapid quenching in every process', 'No cooling', 'Mechanical polishing only', 'A'),
        (179, 'Adding chromium to steel is commonly used to improve:', 'Corrosion resistance', 'Electrical insulation', 'Density reduction to zero', 'Thermal expansion without limit', 'A'),
        (180, 'A eutectoid steel composition transforms at the eutectoid temperature mainly into:', 'Pearlite', 'Austenite only', 'Cementite only', 'Ferrite only', 'A'),
        (181, 'In a vapour-compression refrigeration cycle, the compressor raises refrigerant:', 'Pressure and temperature', 'Quality to exactly zero', 'Entropy to zero', 'Volume to infinity', 'A'),
        (182, 'The evaporator in a refrigeration system:', 'Absorbs heat from the space being cooled', 'Rejects all heat to ambient air', 'Raises refrigerant pressure', 'Separates lubricant from air only', 'A'),
        (183, 'The coefficient of performance of a refrigerator is:', 'Refrigerating effect divided by work input', 'Work input divided by heat rejected', 'Heat rejected divided by refrigerating effect', 'Cooling capacity multiplied by pressure', 'A'),
        (184, 'A condenser in a refrigeration cycle rejects heat while the refrigerant generally:', 'Condenses from vapour to liquid', 'Evaporates from liquid to vapour', 'Expands through the throttle', 'Remains as a solid', 'A'),
        (185, 'An expansion valve in a vapour-compression system produces:', 'A pressure drop by throttling', 'Useful shaft work output', 'A pressure rise by compression', 'Heat addition at constant pressure', 'A'),
        (186, 'The function of insulation around a cold room is to:', 'Reduce heat gain from surroundings', 'Increase infiltration intentionally', 'Raise compressor discharge pressure', 'Replace the evaporator', 'A'),
        (187, 'A cooling tower primarily cools water by:', 'Evaporative heat and mass transfer to air', 'Compression of the water', 'Freezing the entire circulating flow', 'Magnetic induction', 'A'),
        (188, 'In air conditioning, relative humidity is the ratio of actual water vapour pressure to:', 'Saturation vapour pressure at the same temperature', 'Atmospheric pressure at sea level only', 'Dry-bulb temperature', 'Specific volume of dry air', 'A'),
        (189, 'A psychrometric wet-bulb temperature is normally:', 'Less than or equal to dry-bulb temperature', 'Greater than dry-bulb temperature', 'Always equal to dew point', 'Independent of air moisture', 'A'),
        (190, 'A heat pump operating in heating mode delivers heat to a room using:', 'Electrical work input and heat absorbed from a source', 'Only heat generated by a resistance wire', 'No energy input of any kind', 'Combustion inside the room only', 'A'),
        (191, 'The primary purpose of a limit switch in an automated machine is to:', 'Detect an end position or travel limit', 'Measure material hardness', 'Lubricate the spindle', 'Control coolant concentration', 'A'),
        (192, 'A thermocouple measures temperature using the:', 'Seebeck effect', 'Hall effect', 'Photoelectric effect', 'Doppler effect', 'A'),
        (193, 'A vernier caliper can measure:', 'External, internal and depth dimensions', 'Temperature and pressure only', 'Surface roughness only', 'Electrical resistance only', 'A'),
        (194, 'The least count of a measuring instrument is its:', 'Smallest readable increment', 'Maximum capacity', 'Average calibration error', 'Operating temperature range', 'A'),
        (195, 'Statistical process control commonly uses control charts to distinguish:', 'Common-cause variation from assignable-cause signals', 'Good materials from all alloys', 'Fixed cost from variable cost only', 'Revenue from profit', 'A'),
        (196, 'Economic order quantity balances ordering cost against:', 'Inventory holding cost', 'Direct labour rate only', 'Machine depreciation only', 'Selling price', 'A'),
        (197, 'In a production system, a bottleneck is the operation that:', 'Limits the overall process capacity', 'Has the lowest unit cost in every case', 'Uses no resources', 'Always occurs at the first station', 'A'),
        (198, 'Preventive maintenance is performed primarily to:', 'Reduce the likelihood of unexpected equipment failure', 'Repair only after a breakdown', 'Increase machine downtime', 'Remove all inspection records', 'A'),
        (199, 'The purpose of a hydraulic accumulator is to:', 'Store pressurized fluid energy', 'Filter combustion gases', 'Measure shaft speed', 'Cool a furnace lining', 'A'),
        (200, 'A centrifugal pump develops pressure mainly by converting:', 'Rotational mechanical energy into fluid energy', 'Electrical energy directly into chemical energy', 'Heat into mass flow without work', 'Potential energy into vacuum only', 'A')
    ) AS q(display_order, question_text, option_a, option_b, option_c, option_d, correct_answer)
    ORDER BY q.display_order;

    GET DIAGNOSTICS v_question_count = ROW_COUNT;
    IF v_question_count <> 200 THEN
        RAISE EXCEPTION 'Expected to seed 200 questions, inserted %', v_question_count;
    END IF;
END;
$seed$;
