-- Original SSC JE Civil Paper I practice mock.
-- Questions are newly authored from broad syllabus topics and are not taken
-- from or paraphrased from the referenced 2024 paper.
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
    WHERE name = 'Civil Engineering'
    LIMIT 1;

    IF v_branch_id IS NULL THEN
        INSERT INTO public.engineering_branches (name, code, description, is_active)
        VALUES (
            'Civil Engineering',
            CASE WHEN EXISTS (SELECT 1 FROM public.engineering_branches WHERE code = 'CE')
                 THEN 'CE-' || upper(substr(replace(gen_random_uuid()::TEXT, '-', ''), 1, 8))
                 ELSE 'CE' END,
            'Civil engineering branch',
            TRUE
        )
        RETURNING id INTO v_branch_id;
    END IF;

    INSERT INTO public.subjects (branch_id, name, code, description, display_order, is_active)
    VALUES (
        v_branch_id,
        'Civil Engineering',
        CASE WHEN EXISTS (SELECT 1 FROM public.subjects WHERE code = 'CE')
             THEN 'CE-' || upper(substr(replace(gen_random_uuid()::TEXT, '-', ''), 1, 8))
             ELSE 'CE' END,
        'Civil engineering subjects and SSC JE practice',
        0,
        TRUE
    )
    ON CONFLICT (branch_id, name) DO NOTHING;

    SELECT id INTO v_subject_id
    FROM public.subjects
    WHERE branch_id = v_branch_id AND name = 'Civil Engineering'
    LIMIT 1;

    IF v_subject_id IS NULL THEN
        RAISE EXCEPTION 'Could not create or find Civil Engineering subject';
    END IF;

    SELECT id INTO v_test_id
    FROM public.mock_tests
    WHERE title = 'Junior Engineer 2024 Civil Paper I'
    LIMIT 1;

    IF v_test_id IS NULL THEN
        INSERT INTO public.mock_tests (
            title, description, exam_type, subject_id, duration_minutes,
            total_marks, passing_marks, is_published
        )
        VALUES (
            'Junior Engineer 2024 Civil Paper I',
            'Original 200-question SSC JE Paper I style practice test covering reasoning, general awareness, and civil engineering. Each question carries one mark; incorrect answers carry 0.25 negative marks. Questions are original and are not copied from the referenced 2024 paper.',
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
        SET description = 'Original 200-question SSC JE Paper I style practice test covering reasoning, general awareness, and civil engineering. Each question carries one mark; incorrect answers carry 0.25 negative marks. Questions are original and are not copied from the referenced 2024 paper.',
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
            ELSE '[Civil Engineering] ' || q.question_text
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
        (1, 'Choose the next number: 4, 9, 19, 39, 79, ?', '119', '139', '159', '169', 'C'),
        (2, 'Choose the next number: 2, 6, 12, 20, 30, ?', '36', '40', '42', '44', 'C'),
        (3, 'Choose the next letter: B, E, I, N, T, ?', 'Z', 'A', 'B', 'C', 'B'),
        (4, 'In a code, BRICK is written as CSJDL. How is STONE written using the same rule?', 'TUPNF', 'TUPMF', 'TUPOD', 'RSMND', 'A'),
        (5, 'If NORTH is coded as OPSUI, how is SOUTH coded?', 'TPVUI', 'TPVUH', 'TPVTH', 'RNTUG', 'A'),
        (6, 'Choose the odd one out.', 'Triangle', 'Square', 'Circle', 'Cube', 'D'),
        (7, 'Choose the odd one out.', 'Copper', 'Iron', 'Aluminium', 'Granite', 'D'),
        (8, 'Blueprint is to building as recipe is to:', 'Kitchen', 'Meal', 'Cook', 'Ingredient', 'B'),
        (9, 'Thermometer is to temperature as barometer is to:', 'Wind', 'Pressure', 'Rainfall', 'Humidity', 'B'),
        (10, 'A student walks 6 m north, turns right and walks 8 m, then turns right and walks 6 m. How far is the student from the start?', '2 m', '6 m', '8 m', '20 m', 'C'),
        (11, 'Ravi faces west. He turns 90 degrees clockwise, then 180 degrees anticlockwise. Which direction does he face?', 'North', 'South', 'East', 'West', 'A'),
        (12, 'Maya is 12th from the left and 17th from the right in a row. How many people are in the row?', '27', '28', '29', '30', 'B'),
        (13, 'A is older than B. C is younger than B. D is older than A. Who is the oldest?', 'A', 'B', 'C', 'D', 'D'),
        (14, 'All bridges are structures. Some structures are temporary. Which conclusion necessarily follows?', 'All bridges are temporary', 'Some bridges are temporary', 'All bridges are structures', 'No structure is a bridge', 'C'),
        (15, 'All surveyors are engineers. No engineer is careless. Which statement follows?', 'No surveyor is careless', 'All careless people are surveyors', 'Some engineers are careless', 'No surveyor is an engineer', 'A'),
        (16, 'Some roads are narrow. All narrow roads require caution. Which conclusion follows?', 'All roads require caution', 'Some roads require caution', 'No roads require caution', 'All cautious routes are narrow', 'B'),
        (17, 'If P > Q, Q = R, and R > S, which is definitely true?', 'P > S', 'S > P', 'Q < S', 'P = R', 'A'),
        (18, 'If 3 workers complete a task in 12 days at the same rate, how many days would 6 workers need?', '3', '6', '12', '24', 'B'),
        (19, 'A clock shows 3:00. What is the smaller angle between its hands?', '45 degrees', '60 degrees', '90 degrees', '120 degrees', 'C'),
        (20, 'What is the smaller angle between the hands of a clock at 6:00?', '90 degrees', '120 degrees', '150 degrees', '180 degrees', 'D'),
        (21, 'If today is Tuesday, what day will it be 45 days later?', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'C'),
        (22, 'A month begins on a Sunday and has 31 days. On which day does it end?', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'B'),
        (23, 'Find the missing number: 3, 8, 15, 24, 35, ?', '46', '47', '48', '49', 'C'),
        (24, 'Find the missing number: 81, 27, 9, 3, ?', '0', '1', '1.5', '2', 'B'),
        (25, 'If the letters of CIVIL are arranged alphabetically, which letter is third?', 'C', 'I', 'L', 'V', 'B'),
        (26, 'How many letters are between the 5th letter from the left and the 6th letter from the right in the English alphabet?', '14', '15', '16', '17', 'B'),
        (27, 'In a family, P is the mother of Q. Q is the brother of R. How is P related to R?', 'Aunt', 'Mother', 'Sister', 'Grandmother', 'B'),
        (28, 'K is the sister of L. L is the father of M. How is K related to M?', 'Mother', 'Paternal aunt', 'Sister', 'Grandmother', 'B'),
        (29, 'Four people sit in a row. D is left of A, A is left of B, and C is right of B. Who sits second from the left?', 'D', 'A', 'B', 'C', 'B'),
        (30, 'Five boxes are stacked. Red is above blue, green is below blue, and white is above red. Which box is highest among these four?', 'Blue', 'Green', 'Red', 'White', 'D'),
        (31, 'If 1 January is a Monday in a non-leap year, what day is 1 February?', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'C'),
        (32, 'Select the pair with the same relationship: 7:49', '5:20', '6:36', '8:56', '9:72', 'B'),
        (33, 'The sum of the digits of a two-digit number is 11. Reversing its digits increases it by 27. What is the original number?', '38', '47', '56', '65', 'A'),
        (34, 'If 5 machines make 5 units in 5 minutes, how many minutes do 20 such machines take to make 20 units?', '5', '10', '20', '25', 'A'),
        (35, 'A person is 4 years older than twice the age of a child. If the person is 30, how old is the child?', '11', '13', '15', '17', 'B'),
        (36, 'Which pair completes the pattern: AZ, BY, CX, DW, ?', 'EV', 'EU', 'FV', 'EW', 'A'),
        (37, 'If every vowel in the word FOUNDATION is replaced by the next letter in the alphabet, what is the first letter of the new word?', 'F', 'G', 'O', 'P', 'A'),
        (38, 'Which number does not belong: 16, 25, 36, 48, 64?', '16', '25', '48', '64', 'C'),
        (39, 'A is 5 m east of B. C is 5 m north of A. In which direction is C from B?', 'North-east', 'North-west', 'South-east', 'South-west', 'A'),
        (40, 'A vehicle travels 60 km north, then 80 km east. What is the straight-line distance from its starting point?', '90 km', '100 km', '120 km', '140 km', 'B'),
        (41, 'In a queue, Nita is 8th from the front. There are 11 people behind her. How many are in the queue?', '18', '19', '20', '21', 'B'),
        (42, 'If all A are B and all B are C, which statement is certain?', 'All C are A', 'All A are C', 'Some C are not B', 'No A are C', 'B'),
        (43, 'Choose the word that cannot be formed from the letters of ENGINEERING.', 'GREEN', 'GENRE', 'RING', 'GANGER', 'D'),
        (44, 'If MONDAY is represented by 123456 and DAY by 456, what represents MON?', '123', '234', '345', '156', 'A'),
        (45, 'A 120 m train passes a pole in 6 seconds. What is its speed?', '60 km/h', '72 km/h', '80 km/h', '90 km/h', 'B'),
        (46, 'In a group of 40, 22 study mathematics and 18 study physics; 7 study both. How many study neither?', '5', '7', '9', '11', 'B'),
        (47, 'Which is the next pair: AB, DE, GH, JK, ?', 'LM', 'MN', 'NO', 'OP', 'B'),
        (48, 'If the 2nd day of a month is Wednesday, what day is the 23rd?', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'C'),
        (49, 'A number is multiplied by 4 and then 7 is added, giving 39. What is the number?', '6', '7', '8', '9', 'B'),
        (50, 'A person facing south turns left, then right, then right. Which direction are they facing?', 'North', 'East', 'South', 'West', 'D'),

        -- General Awareness (51-100)
        (51, 'Which part of the Indian Constitution contains the Directive Principles of State Policy?', 'Part III', 'Part IV', 'Part V', 'Part IVA', 'B'),
        (52, 'Which constitutional article provides equality before the law?', 'Article 12', 'Article 14', 'Article 19', 'Article 21', 'B'),
        (53, 'Who presides over a joint sitting of the two Houses of Parliament?', 'President', 'Vice-President', 'Speaker of the Lok Sabha', 'Prime Minister', 'C'),
        (54, 'The minimum age for membership of the Lok Sabha is:', '21 years', '25 years', '30 years', '35 years', 'B'),
        (55, 'Which body recommends the distribution of tax revenues between the Union and the States?', 'Election Commission', 'Finance Commission', 'NITI Aayog', 'Union Public Service Commission', 'B'),
        (56, 'Fundamental Duties were added to the Constitution by which amendment?', '24th Amendment', '42nd Amendment', '44th Amendment', '52nd Amendment', 'B'),
        (57, 'Which is the highest court in India?', 'High Court', 'District Court', 'Supreme Court', 'Constitutional Tribunal', 'C'),
        (58, 'The Rajya Sabha is a:', 'Temporary house dissolved every five years', 'Permanent house with one-third retiring every two years', 'House elected directly for six years', 'House nominated entirely by the President', 'B'),
        (59, 'Which river is commonly known as the Dakshin Ganga?', 'Krishna', 'Godavari', 'Kaveri', 'Narmada', 'B'),
        (60, 'Which Indian state has the longest coastline?', 'Tamil Nadu', 'Andhra Pradesh', 'Gujarat', 'Maharashtra', 'C'),
        (61, 'The Tropic of Cancer passes through how many Indian states?', '6', '7', '8', '9', 'C'),
        (62, 'Which soil type is especially associated with cotton cultivation in the Deccan region?', 'Alluvial soil', 'Black soil', 'Laterite soil', 'Desert soil', 'B'),
        (63, 'Which plateau lies between the Aravalli and Vindhya ranges?', 'Chota Nagpur Plateau', 'Malwa Plateau', 'Shillong Plateau', 'Deccan Plateau', 'B'),
        (64, 'The Sundarbans delta is formed mainly by which river system?', 'Indus and Jhelum', 'Ganga and Brahmaputra', 'Godavari and Krishna', 'Narmada and Tapi', 'B'),
        (65, 'Which mountain pass connects Srinagar with Leh by road?', 'Nathu La', 'Zoji La', 'Shipki La', 'Bum La', 'B'),
        (66, 'The Battle of Plassey took place in:', '1757', '1761', '1764', '1773', 'A'),
        (67, 'Who founded the Maurya Empire?', 'Ashoka', 'Chandragupta Maurya', 'Bindusara', 'Bimbisara', 'B'),
        (68, 'The Non-Cooperation Movement was launched in:', '1919', '1920', '1922', '1930', 'B'),
        (69, 'Who chaired the Drafting Committee of the Indian Constitution?', 'Jawaharlal Nehru', 'B. R. Ambedkar', 'Rajendra Prasad', 'Sardar Vallabhbhai Patel', 'B'),
        (70, 'The permanent settlement of Bengal was introduced by:', 'Lord Wellesley', 'Lord Cornwallis', 'Warren Hastings', 'Lord Dalhousie', 'B'),
        (71, 'Which gas is most abundant in Earth atmosphere by volume?', 'Oxygen', 'Nitrogen', 'Carbon dioxide', 'Argon', 'B'),
        (72, 'Which vitamin is formed in human skin under sunlight?', 'Vitamin A', 'Vitamin B12', 'Vitamin C', 'Vitamin D', 'D'),
        (73, 'The SI unit of electric current is:', 'Volt', 'Ampere', 'Ohm', 'Watt', 'B'),
        (74, 'Which blood cells primarily transport oxygen?', 'Platelets', 'Red blood cells', 'White blood cells', 'Lymphocytes', 'B'),
        (75, 'A solution with pH 3 is:', 'Acidic', 'Neutral', 'Basic', 'Always saline', 'A'),
        (76, 'Which instrument measures atmospheric pressure?', 'Hygrometer', 'Barometer', 'Anemometer', 'Seismograph', 'B'),
        (77, 'The speed of light in vacuum is approximately:', '3 x 10^6 m/s', '3 x 10^7 m/s', '3 x 10^8 m/s', '3 x 10^9 m/s', 'C'),
        (78, 'Which metal is liquid at ordinary room temperature?', 'Sodium', 'Mercury', 'Aluminium', 'Copper', 'B'),
        (79, 'The process by which plants lose water vapour through leaf openings is:', 'Respiration', 'Transpiration', 'Germination', 'Photosynthesis', 'B'),
        (80, 'Which organ filters blood and forms urine?', 'Liver', 'Kidney', 'Pancreas', 'Lung', 'B'),
        (81, 'The headquarters of the Reserve Bank of India is in:', 'New Delhi', 'Kolkata', 'Mumbai', 'Chennai', 'C'),
        (82, 'The Goods and Services Tax in India is primarily a:', 'Direct tax on income', 'Destination-based indirect tax', 'Tax on agricultural land only', 'Local property tax', 'B'),
        (83, 'Which institution publishes India national accounts estimates?', 'Reserve Bank of India', 'National Statistical Office', 'Finance Commission', 'Securities and Exchange Board of India', 'B'),
        (84, 'Repo rate is the rate at which:', 'Banks lend to customers', 'RBI lends short-term funds to banks against securities', 'Government lends to RBI', 'Banks lend to one another without collateral', 'B'),
        (85, 'Which organisation is responsible for conducting elections to Parliament and State Legislatures?', 'Finance Commission', 'Election Commission of India', 'Parliament Secretariat', 'Supreme Court Registry', 'B'),
        (86, 'The headquarters of UNESCO is located in:', 'Geneva', 'Paris', 'Rome', 'Vienna', 'B'),
        (87, 'The United Nations was founded in:', '1919', '1945', '1948', '1950', 'B'),
        (88, 'Which Indian mission achieved a soft landing near the lunar south polar region in 2023?', 'Chandrayaan-1', 'Chandrayaan-2', 'Chandrayaan-3', 'Mangalyaan', 'C'),
        (89, 'The ozone layer is concentrated mainly in which atmospheric layer?', 'Troposphere', 'Stratosphere', 'Mesosphere', 'Thermosphere', 'B'),
        (90, 'Which is a renewable source of energy?', 'Coal', 'Natural gas', 'Solar radiation', 'Petroleum', 'C'),
        (91, 'The Ramsar Convention is primarily concerned with the conservation of:', 'Wetlands', 'Deserts', 'Mountain glaciers', 'Coral minerals', 'A'),
        (92, 'Which national park is famous for the one-horned rhinoceros?', 'Gir National Park', 'Kaziranga National Park', 'Jim Corbett National Park', 'Keoladeo National Park', 'B'),
        (93, 'Which Indian classical dance form originated in Kerala?', 'Bharatanatyam', 'Kathak', 'Kathakali', 'Odissi', 'C'),
        (94, 'The term biodiversity refers to:', 'Variety of life at genetic, species and ecosystem levels', 'Number of rivers in a region', 'Variation in weather only', 'Amount of mineral resources', 'A'),
        (95, 'Which is the largest planet in the Solar System?', 'Earth', 'Jupiter', 'Saturn', 'Neptune', 'B'),
        (96, 'A galvanometer is used to detect:', 'Small electric currents', 'Atmospheric humidity', 'Sound intensity', 'Magnetic north only', 'A'),
        (97, 'Which Indian city is located on the banks of the Sabarmati River?', 'Jaipur', 'Ahmedabad', 'Lucknow', 'Bhopal', 'B'),
        (98, 'The Dandi March of 1930 was associated with protest against the:', 'Land revenue system', 'Salt tax', 'Partition of Bengal', 'Rowlatt Act', 'B'),
        (99, 'Which crop is generally classified as a kharif crop in India?', 'Wheat', 'Gram', 'Rice', 'Mustard', 'C'),
        (100, 'Which constitutional body audits the accounts of the Union and State governments?', 'Attorney General of India', 'Comptroller and Auditor General of India', 'Chief Election Commissioner', 'Cabinet Secretariat', 'B'),

        -- Civil Engineering (101-200)
        (101, 'The standard consistency of cement is determined using the:', 'Vicat apparatus', 'Los Angeles machine', 'Pycnometer', 'Centrifuge', 'A'),
        (102, 'Initial setting time of ordinary Portland cement should generally be at least:', '10 minutes', '30 minutes', '60 minutes', '90 minutes', 'B'),
        (103, 'The main purpose of curing concrete is to:', 'Increase cement fineness', 'Maintain moisture for hydration', 'Remove all entrapped air', 'Reduce aggregate size', 'B'),
        (104, 'A lower water-cement ratio, with adequate compaction and curing, generally produces concrete with:', 'Higher strength and lower permeability', 'Lower strength and higher permeability', 'No change in strength', 'Higher workability without admixture', 'A'),
        (105, 'The fineness modulus of aggregate is an index of its:', 'Particle shape', 'Average particle size', 'Water absorption', 'Specific gravity', 'B'),
        (106, 'Bulking of sand is primarily caused by:', 'Cement coating', 'Moisture films around particles', 'High temperature alone', 'Clay lumps only', 'B'),
        (107, 'The soundness test of cement checks its:', 'Resistance to excessive volume change', 'Initial colour', 'Compressive strength of aggregate', 'Setting temperature', 'A'),
        (108, 'A commonly used nominal mix proportion for M20 concrete is:', '1:1:2', '1:1.5:3', '1:2:4', '1:3:6', 'B'),
        (109, 'The slump test is chiefly used to assess fresh concrete:', 'Workability', 'Tensile strength', 'Durability', 'Elastic modulus', 'A'),
        (110, 'The minimum grade generally specified for reinforced concrete work under modern Indian practice is:', 'M10', 'M15', 'M20', 'M25', 'C'),
        (111, 'The reduced bearing capacity of saturated clay compared with dry soil is mainly associated with:', 'Pore water pressure', 'Higher particle density', 'Lower void ratio in every case', 'Increased grain angularity', 'A'),
        (112, 'The water content at which soil changes from plastic to liquid state is the:', 'Shrinkage limit', 'Plastic limit', 'Liquid limit', 'Optimum moisture content', 'C'),
        (113, 'The plasticity index is equal to:', 'Liquid limit minus plastic limit', 'Plastic limit minus shrinkage limit', 'Liquid limit plus plastic limit', 'Shrinkage limit minus liquid limit', 'A'),
        (114, 'For a soil sample, void ratio is defined as:', 'Volume of voids divided by volume of solids', 'Volume of water divided by total volume', 'Mass of water divided by mass of solids', 'Volume of solids divided by total volume', 'A'),
        (115, 'Darcy law for one-dimensional seepage is valid primarily for:', 'Laminar flow through soil', 'Turbulent flow through soil', 'Flow in dry sand only', 'Flow through impermeable rock', 'A'),
        (116, 'The coefficient of permeability has dimensions of:', 'Length per time', 'Length squared', 'Force per area', 'Mass per volume', 'A'),
        (117, 'The standard Proctor test is used to determine:', 'Optimum moisture content and maximum dry density', 'Liquid limit and plastic limit', 'Shear strength and cohesion', 'Permeability and porosity', 'A'),
        (118, 'A soil with a high uniformity coefficient is generally:', 'Well graded over a wide size range', 'Uniformly fine only', 'Purely cohesive', 'Non-plastic by definition', 'A'),
        (119, 'The angle of repose of a dry cohesionless soil is approximately related to its:', 'Angle of internal friction', 'Compression index', 'Liquid limit', 'Specific gravity', 'A'),
        (120, 'Consolidation settlement in saturated clay occurs mainly due to:', 'Expulsion of pore water under sustained load', 'Instantaneous crushing of all grains', 'Evaporation from the ground surface', 'Chemical cementation', 'A'),
        (121, 'A benchmark in surveying is a point of known:', 'Reduced level', 'Bearing only', 'Chainage only', 'Magnetic declination', 'A'),
        (122, 'The line of collimation of a level is the line through:', 'Optical centre and cross-hair intersection', 'Tripod head and staff base', 'Vertical axis and bubble centre', 'Objective lens and staff foot', 'A'),
        (123, 'A contour line joins points having equal:', 'Elevation', 'Slope', 'Horizontal distance', 'Bearing', 'A'),
        (124, 'The arithmetic check in levelling is:', 'Sum of backsights minus sum of foresights equals last RL minus first RL', 'Sum of staff readings equals total distance', 'Rise equals height of instrument', 'Bearing equals included angle', 'A'),
        (125, 'In a whole-circle bearing system, bearings are measured clockwise from:', 'North', 'South', 'East', 'West', 'A'),
        (126, 'The closing error of a traverse is minimized by distributing corrections according to:', 'A suitable adjustment rule such as Bowditch rule', 'The contour interval', 'The staff intercept only', 'The chain length only', 'A'),
        (127, 'In tacheometry, the stadia method is used to determine:', 'Distance and difference in elevation indirectly', 'Magnetic declination only', 'Area of a building only', 'Bearing of a vertical line', 'A'),
        (128, 'The least count of a metric chain is generally the length of:', 'One link', 'One metre', 'One chain', 'One offset', 'A'),
        (129, 'A theodolite is principally used to measure:', 'Horizontal and vertical angles', 'Soil moisture', 'Concrete slump', 'Discharge in a pipe', 'A'),
        (130, 'An instrument station whose position is fixed by intersection of sight lines is commonly established by:', 'Triangulation', 'Levelling', 'Sounding', 'Percolation', 'A'),
        (131, 'The discharge through a pipe is equal to:', 'Area multiplied by mean velocity', 'Area divided by velocity', 'Pressure multiplied by area', 'Velocity divided by area', 'A'),
        (132, 'For steady incompressible flow through a pipe, the continuity equation states that:', 'A1V1 equals A2V2', 'A1 divided by V1 equals A2 divided by V2', 'Pressure is constant everywhere', 'Velocity is independent of area', 'A'),
        (133, 'The hydrostatic pressure at depth h in a liquid of unit weight gamma is:', 'gamma h', 'gamma divided by h', 'h divided by gamma', 'gamma h squared', 'A'),
        (134, 'The centre of pressure on a vertical plane surface is generally:', 'Below its centroid', 'At the free surface', 'Above its centroid', 'At the bottom edge for all shapes', 'A'),
        (135, 'The Reynolds number for pipe flow is the ratio of:', 'Inertial forces to viscous forces', 'Pressure forces to gravity forces', 'Surface tension to elastic forces', 'Gravity forces to weight', 'A'),
        (136, 'In a venturimeter, the pressure difference is related to flow rate using:', 'Continuity and Bernoulli equations', 'Fick law only', 'Darcy-Weisbach equation only', 'Coulomb law', 'A'),
        (137, 'The Darcy-Weisbach equation is used to estimate:', 'Head loss due to pipe friction', 'Critical depth in a channel', 'Seepage through an earth dam only', 'Water hammer pressure only', 'A'),
        (138, 'In open-channel flow, critical flow occurs when the Froude number is:', 'Equal to one', 'Less than zero', 'Greater than ten', 'Always zero', 'A'),
        (139, 'A hydraulic jump is a transition from:', 'Supercritical flow to subcritical flow', 'Subcritical flow to supercritical flow', 'Laminar pipe flow to turbulent pipe flow', 'Steady flow to no flow', 'A'),
        (140, 'The most economical rectangular channel section has:', 'Width equal to twice the depth', 'Width equal to the depth', 'Width equal to four times the depth', 'Depth equal to twice the width', 'A'),
        (141, 'Duty of irrigation water is the area irrigated by:', 'A unit discharge flowing throughout the base period', 'A unit volume stored in a reservoir', 'One metre depth of rainfall', 'A canal of unit length', 'A'),
        (142, 'Delta of a crop is the:', 'Total depth of water required during the base period', 'Discharge per unit area', 'Canal bed width', 'Reservoir capacity', 'A'),
        (143, 'The principal purpose of a canal lining is to:', 'Reduce seepage and improve hydraulic efficiency', 'Increase evaporation', 'Promote weed growth', 'Reduce canal velocity to zero', 'A'),
        (144, 'A broad-crested weir is commonly used for:', 'Measuring discharge in open channels', 'Measuring soil plasticity', 'Testing cement soundness', 'Measuring wind speed', 'A'),
        (145, 'A spillway is provided at a dam to:', 'Safely pass surplus flood water', 'Store sediment permanently', 'Increase seepage under the dam', 'Measure crop duty', 'A'),
        (146, 'The phreatic line in an earth dam represents the:', 'Top flow line of seepage through the embankment', 'Bottom of the foundation', 'Maximum reservoir level', 'Centre line of the dam', 'A'),
        (147, 'The main function of a stilling basin below a spillway is to:', 'Dissipate excess energy of flowing water', 'Increase reservoir storage', 'Prevent all sediment transport upstream', 'Raise the crest level', 'A'),
        (148, 'A tube well draws water primarily from:', 'A permeable aquifer', 'An impervious clay layer only', 'A surface drain', 'A spillway crest', 'A'),
        (149, 'The duty of water is usually highest for:', 'Crops with lower water requirement under similar conditions', 'Rice under every climate', 'Flooded crops only', 'Crops with the longest base period only', 'A'),
        (150, 'A canal fall is constructed to:', 'Lower canal bed level while dissipating excess energy', 'Raise the canal water level indefinitely', 'Stop the canal discharge', 'Increase seepage into the bank', 'A'),
        (151, 'The camber provided on a road surface is primarily for:', 'Lateral drainage of rainwater', 'Increasing pavement thickness at the centre only', 'Reducing sight distance', 'Providing superelevation on a straight road', 'A'),
        (152, 'Superelevation on a horizontal curve is provided to counteract:', 'Centrifugal effect on vehicles', 'Longitudinal gradient', 'Tyre pressure', 'Rolling resistance on a tangent', 'A'),
        (153, 'Stopping sight distance consists of:', 'Lag distance plus braking distance', 'Overtaking distance plus headway', 'Wheelbase plus braking distance', 'Reaction time divided by speed', 'A'),
        (154, 'The California Bearing Ratio test is used to evaluate:', 'Subgrade strength for pavement design', 'Bitumen viscosity only', 'Aggregate soundness only', 'Road surface texture only', 'A'),
        (155, 'The Los Angeles abrasion test measures aggregate resistance to:', 'Abrasion and impact', 'Water absorption only', 'Chemical attack only', 'Polishing only', 'A'),
        (156, 'A prime coat is applied on a:', 'Granular base before a bituminous layer', 'Finished concrete pavement', 'Cement bag before storage', 'Road sign surface', 'A'),
        (157, 'The penetration test on bitumen indicates its:', 'Consistency or hardness', 'Flash point only', 'Ductility only', 'Specific gravity of aggregate', 'A'),
        (158, 'A transition curve is introduced between:', 'A straight road and a circular curve', 'Two parallel road sections only', 'A bridge and an approach embankment only', 'Two vertical curves', 'A'),
        (159, 'The main purpose of a road shoulder is to:', 'Provide lateral support and space for emergency stopping', 'Carry stormwater inside the pavement', 'Increase the central camber', 'Replace the carriageway', 'A'),
        (160, 'The grade compensation on a horizontal curve accounts for:', 'Additional tractive resistance on the curve', 'Camber of the pavement', 'Roadside drainage', 'Bitumen temperature', 'A'),
        (161, 'The biochemical oxygen demand test is commonly conducted for:', 'Five days at 20 degrees Celsius', 'One day at 0 degrees Celsius', 'Seven days at 37 degrees Celsius', 'Ten days at 25 degrees Celsius', 'A'),
        (162, 'A high BOD value in wastewater generally indicates:', 'High biodegradable organic pollution', 'Very low organic content', 'High dissolved oxygen at all times', 'Absence of microorganisms', 'A'),
        (163, 'The main purpose of sedimentation in water treatment is removal of:', 'Settleable suspended solids', 'Dissolved salts', 'Dissolved gases only', 'All microorganisms without disinfection', 'A'),
        (164, 'Chlorination of drinking water is mainly used for:', 'Disinfection', 'Softening', 'Fluoride removal', 'Colour addition', 'A'),
        (165, 'The pH of neutral water at ordinary temperature is approximately:', '5', '6', '7', '8', 'C'),
        (166, 'A trickling filter is a:', 'Attached-growth biological treatment unit', 'Rapid sand filter for drinking water', 'Chemical precipitation tank', 'Sludge drying bed only', 'A'),
        (167, 'The main purpose of a septic tank is to provide:', 'Primary treatment by settling and anaerobic digestion', 'Complete removal of dissolved salts', 'Aerobic oxidation by mechanical aerators', 'Disinfection by ultraviolet light', 'A'),
        (168, 'Hardness in water is mainly caused by salts of:', 'Calcium and magnesium', 'Sodium and potassium', 'Iron and aluminium only', 'Chlorine and fluorine', 'A'),
        (169, 'A sanitary landfill should include a liner primarily to:', 'Limit leachate migration into soil and groundwater', 'Increase rain infiltration', 'Promote open burning', 'Allow uncontrolled gas release', 'A'),
        (170, 'The activated sludge process relies mainly on:', 'Aerobic microorganisms in suspended flocs', 'Anaerobic digestion in a sealed tank only', 'Chemical coagulants alone', 'Natural evaporation', 'A'),
        (171, 'For a simply supported beam with a central point load W over span L, the maximum bending moment is:', 'WL/4', 'WL/8', 'WL/2', 'W/L', 'A'),
        (172, 'The point of contraflexure is where the bending moment:', 'Changes sign', 'Is maximum and positive', 'Equals the shear force', 'Is always zero at a support', 'A'),
        (173, 'For a beam, the rate of change of bending moment with respect to length equals:', 'Shear force', 'Load intensity', 'Deflection', 'Slope squared', 'A'),
        (174, 'The bending stress in an elastic beam is proportional to:', 'Distance from the neutral axis', 'Square of the beam length only', 'Shear force only', 'Area of the cross-section only', 'A'),
        (175, 'The neutral axis of a homogeneous beam section passes through its:', 'Centroid', 'Shear centre in every case', 'Top fibre', 'Support point', 'A'),
        (176, 'The Euler buckling load of a pin-ended column is proportional to:', '1 divided by effective length squared', 'Effective length squared', 'Column mass only', 'Eccentricity squared', 'A'),
        (177, 'A perfect two-force member in a pin-jointed truss carries:', 'Axial force only', 'Bending moment only', 'Torsion only', 'Shear and bending only', 'A'),
        (178, 'The unit of modulus of elasticity is the same as that of:', 'Stress', 'Strain', 'Poisson ratio', 'Length', 'A'),
        (179, 'Poisson ratio is the ratio of:', 'Lateral strain to longitudinal strain', 'Longitudinal strain to stress', 'Shear stress to shear strain', 'Bulk modulus to pressure', 'A'),
        (180, 'For a linearly elastic material, the area under the stress-strain curve up to elastic limit represents:', 'Resilience per unit volume', 'Toughness after fracture', 'Creep strain', 'Fatigue life', 'A'),
        (181, 'In limit state design, the characteristic strength is the value below which not more than what fraction of test results are expected to fall?', '1 percent', '5 percent', '10 percent', '25 percent', 'B'),
        (182, 'In a singly reinforced rectangular beam, the main tension reinforcement is placed near the:', 'Tension face', 'Neutral axis', 'Compression face only', 'Centroid regardless of loading', 'A'),
        (183, 'Stirrups in a reinforced concrete beam primarily resist:', 'Shear', 'Direct compression only', 'Shrinkage of cement only', 'Bearing pressure at supports only', 'A'),
        (184, 'The development length of a reinforcing bar is required to:', 'Transfer bar force to surrounding concrete through bond', 'Prevent concrete hydration', 'Reduce the cover to zero', 'Increase aggregate grading', 'A'),
        (185, 'A one-way slab generally bends mainly in the shorter direction when the ratio of longer span to shorter span is:', 'Greater than 2', 'Equal to 1', 'Less than 1', 'Exactly 1.5 only', 'A'),
        (186, 'The effective length of a column depends mainly on:', 'End restraints and bracing conditions', 'Concrete colour', 'Aggregate nominal size only', 'Column reinforcement diameter only', 'A'),
        (187, 'A doubly reinforced concrete beam has steel in:', 'Both tension and compression zones', 'The tension zone only', 'The web only', 'The compression zone only', 'A'),
        (188, 'A retaining wall is checked against overturning about its:', 'Toe', 'Heel', 'Top edge', 'Centre of gravity only', 'A'),
        (189, 'The purpose of nominal cover to reinforcement is to provide:', 'Durability, fire protection and bond protection', 'Additional live load', 'A construction joint', 'A drainage path', 'A'),
        (190, 'In a bolted steel tension member, net area is reduced by:', 'Bolt holes', 'Paint thickness', 'Member length', 'Weld electrode coating', 'A'),
        (191, 'The centre-line method of estimating is most convenient when:', 'Wall thicknesses are uniform and junctions are regular', 'Every wall has a different thickness', 'Only earthwork is measured', 'No dimensions are available', 'A'),
        (192, 'The unit of measurement for brick masonry in a building estimate is usually:', 'Cubic metre', 'Square metre only', 'Running metre only', 'Kilogram', 'A'),
        (193, 'The unit of measurement for plastering on a wall is generally:', 'Square metre', 'Cubic metre', 'Kilogram', 'Litre', 'A'),
        (194, 'A bar bending schedule is used to summarize:', 'Reinforcement shapes, lengths and quantities', 'Cement test results', 'Survey bearings only', 'Brick bond patterns only', 'A'),
        (195, 'The purpose of a preliminary estimate is to:', 'Assess approximate project cost for initial decisions', 'Certify final measured work', 'Replace structural design calculations', 'Determine concrete setting time', 'A'),
        (196, 'A critical path in a project network is the path with:', 'The longest total duration and zero total float', 'The least number of activities', 'The lowest cost in every case', 'The most resources by definition', 'A'),
        (197, 'In a bar chart programme, the horizontal axis usually represents:', 'Time', 'Cost per unit', 'Material strength', 'Work quantity only', 'A'),
        (198, 'A rate analysis for an item of work includes:', 'Materials, labour, equipment and applicable overheads', 'Material cost only', 'Land value only', 'Depreciation of the whole city', 'A'),
        (199, 'The main purpose of a damp-proof course in a building is to:', 'Prevent moisture rising through walls', 'Increase roof live load', 'Provide lateral bracing', 'Reduce foundation depth', 'A'),
        (200, 'A foundation is generally taken below ground level to:', 'Transfer loads safely to soil and reduce effects of surface variation', 'Increase unsupported wall height', 'Avoid all soil investigation', 'Make the building independent of bearing capacity', 'A')
    ) AS q(display_order, question_text, option_a, option_b, option_c, option_d, correct_answer)
    ORDER BY q.display_order;

    GET DIAGNOSTICS v_question_count = ROW_COUNT;
    IF v_question_count <> 200 THEN
        RAISE EXCEPTION 'Expected to seed 200 questions, inserted %', v_question_count;
    END IF;
END;
$seed$;
