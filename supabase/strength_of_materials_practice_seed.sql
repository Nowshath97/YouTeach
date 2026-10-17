-- 200 original Strength of Materials practice MCQs for Mechanical Engineering.
-- Coverage follows common Strength of Materials syllabi: stress and strain,
-- elastic constants, axial and thermal loading, shear and bending, beam
-- deflection, torsion, springs, principal stress, pressure vessels, columns,
-- energy methods, combined stress, thick cylinders, failure, fatigue, and tests.
-- Questions are newly authored and are not copied from the linked references.
-- Run after practice_question_functions.sql.

DO $seed$
DECLARE
    v_branch_id UUID;
    v_subject_id UUID;
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

    IF v_branch_id IS NULL THEN
        RAISE EXCEPTION 'Could not create or find Mechanical Engineering branch';
    END IF;

    INSERT INTO public.subjects (branch_id, name, code, description, display_order, is_active)
    VALUES (
        v_branch_id,
        'Strength of Materials',
        CASE WHEN EXISTS (SELECT 1 FROM public.subjects WHERE code = 'SOM')
             THEN 'SOM-' || upper(substr(replace(gen_random_uuid()::TEXT, '-', ''), 1, 8))
             ELSE 'SOM' END,
        'Stress, strain, material strength, beams, shafts, columns, and structural deformation',
        1,
        TRUE
    )
    ON CONFLICT (branch_id, name) DO NOTHING;

    SELECT id INTO v_subject_id
    FROM public.subjects
    WHERE branch_id = v_branch_id AND name = 'Strength of Materials'
    LIMIT 1;

    IF v_subject_id IS NULL THEN
        RAISE EXCEPTION 'Could not create or find Strength of Materials under Mechanical Engineering';
    END IF;

    INSERT INTO public.practice_questions (
        subject_id, topic_id, question_text, question_type, options,
        correct_answer, explanation, difficulty, points, display_order,
        is_published
    )
    SELECT
        v_subject_id,
        NULL,
        '[' || seed.topic_title || '] ' || seed.question_text,
        'mcq',
        jsonb_build_array(
            jsonb_build_object('value', 'A', 'text', seed.option_a),
            jsonb_build_object('value', 'B', 'text', seed.option_b),
            jsonb_build_object('value', 'C', 'text', seed.option_c),
            jsonb_build_object('value', 'D', 'text', seed.option_d)
        ),
        seed.correct_answer,
        seed.explanation,
        seed.difficulty,
        10,
        seed.display_order,
        TRUE
    FROM (
        VALUES
        -- Stress, strain, and basic loading (1-10)
        ('Stress and Strain', 'A 12 kN tensile force acts on a bar with cross-sectional area 600 mm2. What is the average normal stress?', '10 MPa', '20 MPa', '30 MPa', '72 MPa', 'B', 'Stress is P/A = 12000/600 = 20 N/mm2, or 20 MPa.', 'easy', 1),
        ('Stress and Strain', 'A 200 mm long bar extends by 0.4 mm. What is its longitudinal strain?', '0.0002', '0.002', '0.02', '0.2', 'B', 'Strain is extension/original length = 0.4/200 = 0.002.', 'easy', 2),
        ('Stress and Strain', 'A 30 kN tensile load acts on a 20 mm diameter circular rod. The approximate axial stress is:', '47.7 MPa', '75.0 MPa', '95.5 MPa', '150 MPa', 'C', 'Area is pi(20^2)/4 = 314.16 mm2; stress is 30000/314.16 = 95.5 MPa.', 'medium', 3),
        ('Stress and Strain', 'A material has a linear stress-strain curve with stress 150 MPa at strain 0.00075. Its Young modulus is:', '100 GPa', '150 GPa', '200 GPa', '250 GPa', 'C', 'E = stress/strain = 150/0.00075 = 200000 MPa = 200 GPa.', 'medium', 4),
        ('Stress and Strain', 'Which statement best describes engineering strain in a uniformly loaded bar?', 'Change in length divided by original length', 'Original length divided by change in length', 'Force divided by volume', 'Stress multiplied by area', 'A', 'Engineering strain is the change in gauge length divided by its original gauge length.', 'easy', 5),
        ('Stress and Strain', 'A bar of area 400 mm2 carries 80 kN axial compression. The average compressive stress is:', '50 MPa', '100 MPa', '200 MPa', '320 MPa', 'C', 'The compressive stress magnitude is P/A = 80000/400 = 200 MPa.', 'easy', 6),
        ('Stress and Strain', 'A 1 m long rod elongates 1 mm under tension. Its strain, expressed as a percentage, is:', '0.01%', '0.1%', '1%', '10%', 'B', 'Strain is 1/1000 = 0.001, which is 0.1 percent.', 'easy', 7),
        ('Stress and Strain', 'The stress at which a material begins to show significant permanent deformation is commonly called its:', 'Yield stress', 'Proof resilience', 'Bulk modulus', 'Fatigue limit', 'A', 'Yield stress marks the onset of appreciable plastic deformation.', 'easy', 8),
        ('Stress and Strain', 'For a brittle material, the ultimate tensile strength is generally:', 'The maximum tensile stress reached before fracture', 'Always equal to zero', 'The stress at zero strain', 'The elastic modulus', 'A', 'Ultimate tensile strength is the maximum engineering tensile stress recorded in a test.', 'easy', 9),
        ('Stress and Strain', 'A prismatic bar carries an axial load P. If its area is doubled while P is unchanged, its average axial stress becomes:', 'Twice as large', 'Half as large', 'Four times as large', 'Unchanged', 'B', 'Since stress equals P/A, doubling the area halves the stress.', 'easy', 10),

        -- Elastic constants (11-20)
        ('Elastic Constants', 'For an isotropic material, Young modulus E, shear modulus G, and Poisson ratio nu satisfy:', 'E = 2G(1 + nu)', 'E = G(1 - 2nu)', 'E = 3G(1 + nu)', 'E = G/nu', 'A', 'The isotropic elastic relation is E = 2G(1 + nu).', 'medium', 11),
        ('Elastic Constants', 'For an isotropic material, bulk modulus K is related to E and nu by:', 'K = E/[3(1 - 2nu)]', 'K = E/[2(1 + nu)]', 'K = E(1 + nu)', 'K = 3E(1 - nu)', 'A', 'The isotropic relation for bulk modulus is K = E/[3(1 - 2nu)].', 'medium', 12),
        ('Elastic Constants', 'A material has E = 200 GPa and Poisson ratio 0.25. Its shear modulus is:', '40 GPa', '60 GPa', '80 GPa', '100 GPa', 'C', 'G = E/[2(1 + nu)] = 200/[2(1.25)] = 80 GPa.', 'medium', 13),
        ('Elastic Constants', 'A rod is stretched axially and has Poisson ratio 0.30. If longitudinal strain is 0.001, the lateral strain is:', '0.0003 tensile', '0.0003 compressive', '0.003 compressive', '0.03 tensile', 'B', 'Lateral strain is -nu times longitudinal strain = -0.0003; the negative sign denotes contraction.', 'medium', 14),
        ('Elastic Constants', 'For a stable isotropic linear elastic material, Poisson ratio is normally less than:', '0', '0.25', '0.5', '1.0', 'C', 'For stable isotropic linear elasticity, nu is below 0.5; 0.5 is the incompressible limit.', 'easy', 15),
        ('Elastic Constants', 'A cube is subjected to equal normal stress in all three directions. The volumetric strain is:', '3 times the linear strain in one direction', 'Equal to zero for every material', 'The square of the normal stress', 'Independent of bulk modulus', 'A', 'Under equal triaxial stress, the three equal linear strains add to give volumetric strain.', 'medium', 16),
        ('Elastic Constants', 'A material has E = 210 GPa and nu = 0.30. Its bulk modulus is approximately:', '105 GPa', '150 GPa', '175 GPa', '210 GPa', 'C', 'K = E/[3(1 - 2nu)] = 210/[3(0.4)] = 175 GPa.', 'medium', 17),
        ('Elastic Constants', 'The ratio of shear stress to shear strain within the linear elastic range is:', 'Young modulus', 'Bulk modulus', 'Shear modulus', 'Poisson ratio', 'C', 'Shear modulus G is the ratio of shear stress to engineering shear strain in the elastic range.', 'easy', 18),
        ('Elastic Constants', 'A material has K = 100 GPa and G = 40 GPa. Its Young modulus is approximately:', '105.9 GPa', '96 GPa', '120 GPa', '160 GPa', 'A', 'E = 9KG/(3K + G) = 9(100)(40)/(300 + 40) = 105.9 GPa.', 'hard', 19),
        ('Elastic Constants', 'The modulus of rigidity is another name for:', 'Young modulus', 'Shear modulus', 'Bulk modulus', 'Tangent modulus', 'B', 'Modulus of rigidity is the conventional name for shear modulus.', 'easy', 20),

        -- Axial deformation and bars (21-30)
        ('Axial Deformation', 'A 2 m steel bar has area 500 mm2, carries 50 kN, and has E = 200 GPa. Its extension is:', '0.5 mm', '1.0 mm', '2.0 mm', '4.0 mm', 'B', 'Delta = PL/AE = 50000(2000)/(500 x 200000) = 1 mm.', 'medium', 21),
        ('Axial Deformation', 'Two axial segments in series carry the same load. Their total extension is:', 'The sum of the extension of each segment', 'The larger segment extension only', 'Always zero', 'The average stress times total length', 'A', 'Axial compatibility requires total end displacement to equal the sum of segment extensions.', 'easy', 22),
        ('Axial Deformation', 'A stepped bar has two segments in series. The axial force in each segment, in the absence of intermediate loads, is:', 'The same', 'Inversely proportional to area', 'Proportional to modulus', 'Zero in the smaller segment', 'A', 'Force equilibrium gives the same axial force through each segment of a series bar.', 'easy', 23),
        ('Axial Deformation', 'A 1 m bar with area 100 mm2 and E = 100 GPa carries 10 kN. Its extension is:', '0.1 mm', '0.5 mm', '1.0 mm', '10 mm', 'C', 'Delta = PL/AE = 10000(1000)/(100 x 100000) = 1 mm.', 'medium', 24),
        ('Axial Deformation', 'For a uniform bar under axial force P, elastic modulus E, area A, and length L, axial stiffness is:', 'AE/L', 'PL/AE', 'AL/E', 'E/(AL)', 'A', 'Axial stiffness is load divided by extension, k = AE/L.', 'easy', 25),
        ('Axial Deformation', 'A uniform elastic bar is replaced by one of equal material and length but twice the area. Under the same load, its extension is:', 'Doubled', 'Halved', 'Four times greater', 'Unchanged', 'B', 'Extension is inversely proportional to cross-sectional area for a fixed load.', 'easy', 26),
        ('Axial Deformation', 'A 1.5 m bar of area 300 mm2 and E = 150 GPa elongates under 18 kN. The elongation is:', '0.2 mm', '0.4 mm', '0.6 mm', '1.2 mm', 'C', 'Delta = PL/AE = 18000(1500)/(300 x 150000) = 0.6 mm.', 'medium', 27),
        ('Axial Deformation', 'A tensile force of 40 kN is applied to a bar with area 800 mm2. What is its normal stress?', '25 MPa', '40 MPa', '50 MPa', '80 MPa', 'C', 'Stress = 40000/800 = 50 N/mm2 = 50 MPa.', 'easy', 28),
        ('Axial Deformation', 'For a bar with linearly varying axial force N(x), the local axial stress is:', 'N(x)/A(x)', 'N(x)A(x)', 'E A(x)/N(x)', 'N(x)/E', 'A', 'At each section, average axial stress is the internal axial force divided by the local area.', 'medium', 29),
        ('Axial Deformation', 'A circular rod has diameter 10 mm and length 500 mm. Under 5 kN tension, with E = 200 GPa, its extension is approximately:', '0.08 mm', '0.16 mm', '0.32 mm', '0.64 mm', 'B', 'Area = 78.54 mm2; delta = 5000(500)/(78.54 x 200000) = 0.159 mm.', 'medium', 30),

        -- Thermal stress and compound bars (31-40)
        ('Thermal Stress and Compound Bars', 'A freely expanding bar with coefficient of thermal expansion alpha is heated by delta T. Its thermal strain is:', 'alpha delta T', 'alpha/delta T', 'delta T/alpha', 'Zero', 'A', 'Free thermal strain is alpha times the temperature change.', 'easy', 31),
        ('Thermal Stress and Compound Bars', 'A steel bar with E = 200 GPa and alpha = 12 x 10^-6 /C is fully restrained and heated by 50 C. The thermal stress magnitude is:', '12 MPa', '60 MPa', '120 MPa', '240 MPa', 'C', 'For full restraint, sigma = E alpha delta T = 200000(12 x 10^-6)(50) = 120 MPa compressive.', 'medium', 32),
        ('Thermal Stress and Compound Bars', 'A freely heated bar develops thermal stress when:', 'Its expansion is fully or partially restrained', 'Its coefficient of expansion is positive', 'Its temperature is uniform', 'Its length is measured', 'A', 'Thermal stress requires restraint against the free thermal expansion or contraction.', 'easy', 33),
        ('Thermal Stress and Compound Bars', 'A bar is cooled while its ends are rigidly fixed. The induced axial stress is generally:', 'Tensile', 'Compressive', 'Zero', 'Pure shear', 'A', 'The bar wants to contract but is restrained, so tensile stress develops.', 'medium', 34),
        ('Thermal Stress and Compound Bars', 'Two bars of equal length are fixed between rigid supports. If one bar has greater free thermal expansion, heating produces in it a tendency toward:', 'Compression relative to the other bar', 'Tension relative to the other bar', 'Zero force in both bars', 'Pure torsion', 'A', 'The bar with greater free expansion is restrained more and develops compressive thermal force.', 'hard', 35),
        ('Thermal Stress and Compound Bars', 'For two perfectly bonded axial bars loaded together, compatibility requires their:', 'Axial deformation over the common length to be equal', 'Axial force to be equal in every case', 'Stress to be equal in every case', 'Elastic modulus to be equal', 'A', 'Perfect bonding enforces equal axial strain/displacement over the bonded length.', 'medium', 36),
        ('Thermal Stress and Compound Bars', 'A freely expanding 2 m bar has alpha = 10 x 10^-6 /C and is heated by 40 C. Its expansion is:', '0.08 mm', '0.4 mm', '0.8 mm', '8 mm', 'C', 'Delta L = alpha L delta T = 10 x 10^-6(2000)(40) = 0.8 mm.', 'medium', 37),
        ('Thermal Stress and Compound Bars', 'A steel bar is fully restrained during a 30 C temperature rise. If E = 200 GPa and alpha = 11 x 10^-6 /C, the stress magnitude is:', '33 MPa', '66 MPa', '110 MPa', '220 MPa', 'B', 'Sigma = E alpha delta T = 200000(11 x 10^-6)(30) = 66 MPa.', 'medium', 38),
        ('Thermal Stress and Compound Bars', 'In an axially loaded composite bar with perfectly bonded materials, the common strain is found from:', 'Deformation compatibility', 'Equal stress assumption only', 'Equal modulus assumption', 'Neglecting force equilibrium', 'A', 'Bonding imposes compatible deformation; equilibrium then determines load sharing.', 'medium', 39),
        ('Thermal Stress and Compound Bars', 'A bar is free to expand longitudinally but is prevented from expanding laterally. The simplest direct axial thermal stress formula applies to:', 'Longitudinal restraint', 'Lateral restraint alone', 'Free expansion in all directions', 'A change in density alone', 'A', 'The one-dimensional thermal stress relation sigma = E alpha delta T corresponds to axial restraint.', 'hard', 40),

        -- Shear force and bending moment (41-50)
        ('Shear Force and Bending Moment', 'For a simply supported beam with a central point load W and span L, each support reaction is:', 'W/4', 'W/2', 'W', '2W', 'B', 'Symmetry and vertical equilibrium give equal reactions of W/2.', 'easy', 41),
        ('Shear Force and Bending Moment', 'A simply supported beam of span 4 m carries a central point load of 20 kN. Its maximum bending moment is:', '10 kN m', '20 kN m', '40 kN m', '80 kN m', 'B', 'Mmax = WL/4 = 20(4)/4 = 20 kN m.', 'medium', 42),
        ('Shear Force and Bending Moment', 'A simply supported beam with a uniformly distributed load w over its full span L has maximum bending moment:', 'wL^2/8', 'wL^2/12', 'wL^2/2', 'wL/8', 'A', 'For a full-span UDL on a simply supported beam, Mmax = wL^2/8 at midspan.', 'easy', 43),
        ('Shear Force and Bending Moment', 'For a cantilever beam carrying a point load W at its free end, the maximum bending moment magnitude is:', 'Zero', 'WL/4', 'WL/2', 'WL at the fixed end', 'D', 'The bending moment varies linearly from zero at the free end to WL at the fixed end.', 'easy', 44),
        ('Shear Force and Bending Moment', 'The slope of the bending-moment diagram with respect to beam length equals:', 'Shear force', 'Load intensity', 'Deflection', 'Young modulus', 'A', 'With the usual sign convention, dM/dx = V.', 'medium', 45),
        ('Shear Force and Bending Moment', 'A concentrated couple applied to a beam causes which change in its bending-moment diagram?', 'A sudden jump', 'A parabolic curve', 'No change', 'A linear change in shear force only', 'A', 'A point moment creates a discontinuity in bending moment equal to the applied couple.', 'medium', 46),
        ('Shear Force and Bending Moment', 'For a beam under a uniformly distributed load, the shear-force diagram varies:', 'Linearly', 'Parabolically', 'As a circle', 'As a constant only', 'A', 'Since dV/dx equals minus the load intensity, constant load produces linear shear variation.', 'easy', 47),
        ('Shear Force and Bending Moment', 'At a section where the bending moment has a local maximum or minimum, the shear force is generally:', 'Zero', 'Equal to the load intensity', 'Infinite', 'Equal to the reaction moment', 'A', 'Since dM/dx = V, a smooth local extremum in M occurs where V = 0.', 'medium', 48),
        ('Shear Force and Bending Moment', 'A simply supported beam has a point load P at distance a from the left support and b from the right, with span L = a + b. The left reaction is:', 'Pb/L', 'Pa/L', 'P/L', 'P(a + b)', 'A', 'Taking moments about the right support gives R_left L = P b.', 'medium', 49),
        ('Shear Force and Bending Moment', 'At a free end of an unloaded cantilever, the internal shear force and bending moment are:', 'Both zero', 'Shear zero and moment maximum', 'Shear maximum and moment zero', 'Both equal to the support reaction', 'A', 'The free end has no applied end force or couple in an unloaded boundary condition.', 'easy', 50),

        -- Bending stress (51-60)
        ('Bending Stress', 'The elastic flexure formula for a prismatic beam is:', 'M/I = sigma/y = E/R', 'M = EI/y', 'sigma = M I/y', 'M/I = y/sigma', 'A', 'The flexure relation is M/I = sigma/y = E/R.', 'medium', 51),
        ('Bending Stress', 'A rectangular beam has width b and depth h. Its second moment of area about the centroidal horizontal axis is:', 'bh^3/12', 'b^3h/12', 'bh^2/6', 'bh/12', 'A', 'For a rectangle about its centroidal axis parallel to its width, I = bh^3/12.', 'easy', 52),
        ('Bending Stress', 'A rectangular section has width 100 mm and depth 200 mm. Its section modulus about the strong axis is:', '3.33 x 10^5 mm3', '6.67 x 10^5 mm3', '1.00 x 10^6 mm3', '2.00 x 10^6 mm3', 'B', 'I = 100(200^3)/12 = 66.67 x 10^6 mm4; Z = I/(h/2) = 6.67 x 10^5 mm3.', 'medium', 53),
        ('Bending Stress', 'For a beam section, the maximum elastic bending stress occurs at the fibre:', 'Farthest from the neutral axis', 'On the neutral axis', 'At the centroid only', 'Nearest to the shear centre', 'A', 'Bending stress varies linearly with distance from the neutral axis and is greatest at the extreme fibre.', 'easy', 54),
        ('Bending Stress', 'The neutral axis in pure bending is the line in the cross-section where longitudinal bending stress is:', 'Zero', 'Maximum tension', 'Maximum compression', 'Equal to shear stress', 'A', 'Longitudinal bending stress is zero at the neutral axis.', 'easy', 55),
        ('Bending Stress', 'A beam section has bending moment 12 kN m and section modulus 2 x 10^5 mm3. The maximum bending stress is:', '30 MPa', '60 MPa', '120 MPa', '240 MPa', 'B', 'Convert M to 12 x 10^6 N mm; sigma = M/Z = 60 N/mm2 = 60 MPa.', 'medium', 56),
        ('Bending Stress', 'If the depth of a rectangular beam is doubled while its width is unchanged, its section modulus about the strong axis becomes:', '2 times', '4 times', '8 times', 'Unchanged', 'B', 'For a rectangle Z = bh^2/6, so doubling depth makes the section modulus four times larger.', 'medium', 57),
        ('Bending Stress', 'A beam material is linearly elastic and its bending stress at 20 mm from the neutral axis is 40 MPa. At 10 mm from that axis, the stress magnitude is:', '10 MPa', '20 MPa', '40 MPa', '80 MPa', 'B', 'Elastic bending stress is proportional to distance from the neutral axis.', 'easy', 58),
        ('Bending Stress', 'For a homogeneous beam section under pure bending, the neutral axis passes through the:', 'Centroid of the cross-section', 'Topmost point', 'Shear centre always', 'Point of maximum shear stress', 'A', 'For homogeneous material in elastic pure bending, the neutral axis passes through the centroid.', 'medium', 59),
        ('Bending Stress', 'A hollow circular shaft is used as a beam. Compared with a solid circle of the same outer diameter and material, removing central material generally:', 'Reduces second moment of area less than removing material near the outside', 'Has a large effect on second moment because material is far from the neutral axis', 'Does not affect bending stiffness', 'Increases its mass', 'A', 'Material near the neutral axis contributes relatively little to second moment of area.', 'hard', 60),

        -- Shear stress in beams (61-70)
        ('Shear Stress in Beams', 'The beam shear formula is:', 'tau = VQ/(It)', 'tau = My/I', 'tau = PL/AE', 'tau = T/J', 'A', 'The transverse shear formula is tau = VQ/(It), where Q is first moment of area and t is local width.', 'medium', 61),
        ('Shear Stress in Beams', 'In a rectangular beam section under transverse shear, the shear stress distribution over the depth is:', 'Parabolic with maximum at the neutral axis', 'Uniform and maximum at the surface', 'Linear with zero at the neutral axis', 'Zero everywhere', 'A', 'For a rectangle, shear stress is parabolic, zero at top and bottom and maximum at the neutral axis.', 'easy', 62),
        ('Shear Stress in Beams', 'For a rectangular cross-section, the maximum transverse shear stress is:', '1.5 times the average shear stress', 'Equal to the average shear stress', 'Twice the average shear stress', 'Half the average shear stress', 'A', 'For a rectangle, tau_max = 3V/(2A), while average shear is V/A.', 'medium', 63),
        ('Shear Stress in Beams', 'In an I-section beam, most of the transverse shear force is carried by the:', 'Web', 'Flanges only', 'Outer fibres only', 'Neutral axis as a line with no thickness', 'A', 'The web has substantial thickness near the neutral axis, where beam shear stress is high.', 'easy', 64),
        ('Shear Stress in Beams', 'The first moment Q in the beam shear formula is the first moment of:', 'Area above or below the level considered about the neutral axis', 'The whole area about the support', 'The beam length about its midpoint', 'The second moment of area about the centroid', 'A', 'Q is the first moment of the portion of area on one side of the layer being examined.', 'medium', 65),
        ('Shear Stress in Beams', 'At the top free surface of a rectangular beam in transverse shear, the shear stress is:', 'Zero', 'Maximum', 'Equal to V/A', 'Infinite', 'A', 'The first moment Q vanishes at the free surface, so shear stress is zero there.', 'easy', 66),
        ('Shear Stress in Beams', 'A beam carries shear force 30 kN over a rectangular area 100 mm by 200 mm. Its average shear stress is:', '0.75 MPa', '1.5 MPa', '3 MPa', '15 MPa', 'B', 'Average shear stress = V/A = 30000/(100 x 200) = 1.5 MPa.', 'easy', 67),
        ('Shear Stress in Beams', 'In a beam carrying both shear force and bending moment, transverse shear stress is usually greatest near the:', 'Neutral axis', 'Extreme top fibre', 'Extreme bottom fibre', 'Centroid of the support', 'A', 'In common symmetric sections, transverse shear stress is greatest near the neutral axis.', 'medium', 68),
        ('Shear Stress in Beams', 'The dimensions of the first moment of area Q are:', 'Length cubed', 'Length squared', 'Length to the fourth power', 'Force times length', 'A', 'Q is area times distance, giving dimensions L2 x L = L3.', 'medium', 69),
        ('Shear Stress in Beams', 'For a circular cross-section in transverse shear, the maximum shear stress occurs at the:', 'Centre of the section', 'Top surface', 'Bottom surface', 'Outer radius', 'A', 'For a solid circular section, shear stress is maximum at the centre and zero at the boundary.', 'medium', 70),

        -- Beam deflection (71-80)
        ('Beam Deflection', 'For small deflection elastic beam theory, the curvature is approximately:', 'd2y/dx2', 'dy/dx', 'y/x2', 'd3y/dx3', 'A', 'For small slopes, curvature is approximately the second derivative of deflection.', 'medium', 71),
        ('Beam Deflection', 'The Euler-Bernoulli beam equation relates bending moment to curvature as:', 'M = EI d2y/dx2', 'M = EI dy/dx', 'M = EIy', 'M = I/E d2y/dx2', 'A', 'With a consistent sign convention, M = EI times beam curvature.', 'medium', 72),
        ('Beam Deflection', 'A simply supported beam with a central point load W has maximum deflection:', 'WL^3/(48EI)', 'WL^3/(3EI)', 'WL^2/(16EI)', '5wL^4/(384EI)', 'A', 'The standard midspan deflection for a central point load is WL^3/(48EI).', 'medium', 73),
        ('Beam Deflection', 'A cantilever of length L carrying end load W has free-end deflection:', 'WL^3/(3EI)', 'WL^3/(48EI)', 'WL^2/(2EI)', 'wL^4/(8EI)', 'A', 'The end-load cantilever deflection is WL^3/(3EI).', 'easy', 74),
        ('Beam Deflection', 'A simply supported beam carrying a full-span UDL w has maximum deflection:', '5wL^4/(384EI)', 'wL^4/(8EI)', 'wL^3/(3EI)', 'wL^2/(8EI)', 'A', 'For a simply supported beam with full-span UDL, delta_max = 5wL^4/(384EI).', 'medium', 75),
        ('Beam Deflection', 'If the flexural rigidity EI of a beam doubles under the same loading, its elastic deflection is approximately:', 'Halved', 'Doubled', 'Four times', 'Unchanged', 'A', 'For fixed geometry and loading, beam deflection is inversely proportional to EI.', 'easy', 76),
        ('Beam Deflection', 'A point of contraflexure is a point where the bending moment:', 'Changes sign', 'Is always maximum', 'Equals the shear force', 'Has zero slope', 'A', 'At a point of contraflexure, the bending moment changes sign.', 'medium', 77),
        ('Beam Deflection', 'The area under the curvature diagram between two beam sections gives the change in:', 'Slope', 'Bending moment', 'Shear force', 'Axial force', 'A', 'Integrating curvature d2y/dx2 over length gives the change in slope dy/dx.', 'hard', 78),
        ('Beam Deflection', 'For a cantilever carrying a constant UDL w over its entire length, the free-end deflection is:', 'wL^4/(8EI)', 'wL^4/(384EI)', 'wL^3/(3EI)', 'wL^2/(2EI)', 'A', 'Integration of the cantilever beam equation gives delta_tip = wL^4/(8EI).', 'medium', 79),
        ('Beam Deflection', 'A beam is called statically determinate when its support reactions can be found using:', 'Equilibrium equations alone', 'Only compatibility equations', 'Material failure criteria only', 'Energy methods alone', 'A', 'A statically determinate structure has enough independent equilibrium equations to solve its reactions.', 'easy', 80),

        -- Torsion of circular shafts (81-90)
        ('Torsion of Circular Shafts', 'The elastic torsion equation for a circular shaft is:', 'T/J = tau/r = G theta/L', 'T/I = sigma/y', 'T = PL/AE', 'T/J = E/R', 'A', 'For elastic circular shafts, T/J = tau/r = G theta/L.', 'medium', 81),
        ('Torsion of Circular Shafts', 'The polar second moment of area of a solid circular shaft of diameter d is:', 'pi d^4/32', 'pi d^4/64', 'pi d^3/16', 'pi d^2/4', 'A', 'The polar moment J for a solid circle is pi d^4/32.', 'easy', 82),
        ('Torsion of Circular Shafts', 'The polar moment of area of a hollow circular shaft with outer diameter D and inner diameter d is:', 'pi(D^4 - d^4)/32', 'pi(D^4 - d^4)/64', 'pi(D^2 - d^2)/4', 'pi(D^3 - d^3)/16', 'A', 'For a hollow circle, J = pi(D^4 - d^4)/32.', 'medium', 83),
        ('Torsion of Circular Shafts', 'A shaft transmits torque T at angular speed omega. Its power is:', 'T omega', 'T/omega', 'omega/T', 'T omega squared', 'A', 'Rotational power equals torque multiplied by angular velocity.', 'easy', 84),
        ('Torsion of Circular Shafts', 'For a solid circular shaft under elastic torsion, maximum shear stress occurs at the:', 'Outer surface', 'Centre', 'Half-radius only', 'Neutral plane', 'A', 'Shear stress in a circular shaft increases linearly with radius and is maximum at the outside.', 'easy', 85),
        ('Torsion of Circular Shafts', 'For a circular shaft, angle of twist is proportional to:', 'Torque and length, and inversely proportional to GJ', 'GJ and inversely proportional to torque', 'Diameter only, independent of torque', 'Area and independent of length', 'A', 'Theta = TL/(GJ).', 'medium', 86),
        ('Torsion of Circular Shafts', 'Two circular shafts have the same material and length. The solid shaft with twice the diameter has torsional stiffness:', '2 times', '4 times', '8 times', '16 times', 'D', 'J for a solid circle is proportional to d^4, so doubling diameter gives 16 times stiffness.', 'medium', 87),
        ('Torsion of Circular Shafts', 'A hollow shaft can be more weight-efficient than a solid shaft in torsion because material near the centre:', 'Contributes relatively little to polar moment of area', 'Carries all the torque', 'Has the greatest shear stress', 'Has greater radius than the outer surface', 'A', 'Since torsional contribution depends strongly on radius, central material contributes little to J.', 'medium', 88),
        ('Torsion of Circular Shafts', 'A shaft carries 500 N m torque and rotates at 1200 rpm. Its transmitted power is approximately:', '6.28 kW', '31.4 kW', '62.8 kW', '125.7 kW', 'C', 'Omega = 2pi(1200/60) = 125.66 rad/s; power = 500 x 125.66 = 62.8 kW.', 'medium', 89),
        ('Torsion of Circular Shafts', 'In a circular shaft under pure torsion, the shear stress at radius r is:', 'Proportional to r', 'Inversely proportional to r', 'Constant over the cross-section', 'Proportional to r squared', 'A', 'The torsion relation gives tau = Tr/J, so stress varies linearly with radius.', 'medium', 90),

        -- Springs (91-100)
        ('Springs', 'A close-coiled helical spring under an axial load is primarily subjected to wire:', 'Torsion', 'Pure bending only', 'Hydrostatic compression', 'Uniform axial tension only', 'A', 'The axial force creates a torque in the spring wire, producing dominant torsional shear.', 'medium', 91),
        ('Springs', 'For a close-coiled helical spring, increasing the number of active turns while other factors stay fixed generally:', 'Increases deflection under a given load', 'Decreases deflection to zero', 'Leaves stiffness unchanged', 'Makes shear stress zero', 'A', 'Spring deflection is proportional to the number of active turns.', 'medium', 92),
        ('Springs', 'The stiffness of a spring is defined as:', 'Load divided by deflection', 'Deflection divided by load', 'Load multiplied by deflection', 'Stress divided by area', 'A', 'Spring stiffness k = W/delta.', 'easy', 93),
        ('Springs', 'A linear spring of stiffness 20 N/mm is compressed 5 mm. The stored strain energy is:', '100 N mm', '250 N mm', '500 N mm', '1000 N mm', 'B', 'U = 1/2 k delta^2 = 0.5(20)(25) = 250 N mm.', 'medium', 94),
        ('Springs', 'Two identical springs connected in parallel have an equivalent stiffness:', 'Half the stiffness of one spring', 'Equal to one spring', 'Twice the stiffness of one spring', 'Four times the stiffness of one spring', 'C', 'In parallel, stiffnesses add: k_eq = k + k = 2k.', 'easy', 95),
        ('Springs', 'Two identical springs connected in series have an equivalent stiffness:', 'Half the stiffness of one spring', 'Equal to one spring', 'Twice the stiffness of one spring', 'Four times the stiffness of one spring', 'A', 'For two equal springs in series, 1/k_eq = 2/k, so k_eq = k/2.', 'easy', 96),
        ('Springs', 'The spring index is the ratio of mean coil diameter D to:', 'Wire diameter d', 'Free length', 'Pitch angle', 'Number of coils', 'A', 'Spring index C = D/d.', 'easy', 97),
        ('Springs', 'A helical spring carries axial force W. The torque in its wire is approximately:', 'WD/2', 'Wd/2', '2W/D', 'W/D', 'A', 'The axial force acting at the mean coil radius creates torque WD/2 in the wire.', 'medium', 98),
        ('Springs', 'A spring has stiffness 50 N/mm and is compressed 4 mm. The load is:', '12.5 N', '100 N', '200 N', '800 N', 'C', 'Load W = k delta = 50 x 4 = 200 N.', 'easy', 99),
        ('Springs', 'A leaf spring carries load mainly through:', 'Bending of its leaves', 'Torsion of a circular wire', 'Hydrostatic pressure', 'Axial extension only', 'A', 'Leaf springs are flexural members that store energy through bending.', 'easy', 100),

        -- Principal stress and Mohr circle (101-110)
        ('Principal Stress and Mohr Circle', 'Principal planes in plane stress are planes on which:', 'Shear stress is zero', 'Normal stress is zero', 'Both principal stresses are zero', 'Strain is always zero', 'A', 'Principal stresses act on planes where the in-plane shear stress vanishes.', 'easy', 101),
        ('Principal Stress and Mohr Circle', 'For plane stress sigma_x = 80 MPa, sigma_y = 20 MPa, and tau_xy = 0, the principal stresses are:', '80 MPa and 20 MPa', '50 MPa and 0 MPa', '100 MPa and 0 MPa', '60 MPa and 40 MPa', 'A', 'With zero shear and aligned normal stresses, the given directions are principal planes.', 'easy', 102),
        ('Principal Stress and Mohr Circle', 'For plane stress with sigma_x = 60 MPa, sigma_y = 20 MPa, and tau_xy = 30 MPa, the average normal stress is:', '20 MPa', '30 MPa', '40 MPa', '50 MPa', 'C', 'The centre of Mohr circle is (sigma_x + sigma_y)/2 = 40 MPa.', 'medium', 103),
        ('Principal Stress and Mohr Circle', 'For sigma_x = 60 MPa, sigma_y = 20 MPa, and tau_xy = 30 MPa, the radius of Mohr circle is:', '20 MPa', '30 MPa', '36.1 MPa', '50 MPa', 'C', 'R = sqrt[((60-20)/2)^2 + 30^2] = sqrt(1300) = 36.1 MPa.', 'hard', 104),
        ('Principal Stress and Mohr Circle', 'The maximum in-plane shear stress equals:', 'The radius of Mohr circle', 'The centre of Mohr circle', 'The sum of principal stresses', 'Half the smaller principal stress', 'A', 'The Mohr-circle radius is the maximum in-plane shear stress magnitude.', 'medium', 105),
        ('Principal Stress and Mohr Circle', 'If principal stresses are 100 MPa and -20 MPa, the maximum in-plane shear stress is:', '40 MPa', '60 MPa', '80 MPa', '120 MPa', 'B', 'Maximum shear is (sigma_1 - sigma_2)/2 = (100 - (-20))/2 = 60 MPa.', 'medium', 106),
        ('Principal Stress and Mohr Circle', 'The orientation of principal planes can be found from:', 'tan(2theta) = 2tau_xy/(sigma_x - sigma_y)', 'tan(theta) = sigma_x/sigma_y', 'sin(theta) = tau_xy/E', 'cos(2theta) = G/E', 'A', 'The plane-stress transformation gives tan 2theta_p = 2tau_xy/(sigma_x - sigma_y).', 'hard', 107),
        ('Principal Stress and Mohr Circle', 'On Mohr circle, a physical rotation of the plane by theta corresponds to a rotation on the circle of:', '2theta', 'theta/2', 'theta', '4theta', 'A', 'Stress transformation equations involve twice the physical plane angle.', 'medium', 108),
        ('Principal Stress and Mohr Circle', 'At a point under pure shear stress tau with zero normal stress, the principal stresses are:', '+tau and -tau', 'Both equal tau', 'Both zero', '+2tau and -2tau', 'A', 'Pure shear transforms to equal-magnitude tensile and compressive principal stresses.', 'medium', 109),
        ('Principal Stress and Mohr Circle', 'For an element under uniaxial tension sigma with no other stresses, the maximum in-plane shear stress is:', 'sigma/4', 'sigma/2', 'sigma', '2sigma', 'B', 'The in-plane principal stresses are sigma and zero, so maximum shear is sigma/2.', 'easy', 110),

        -- Thin pressure vessels (111-120)
        ('Thin Pressure Vessels', 'For a thin-walled closed cylindrical vessel, hoop stress is:', 'pd/(2t)', 'pd/(4t)', 'pt/d', '2pt/d', 'A', 'For a thin cylinder, circumferential or hoop stress is pd/(2t).', 'medium', 111),
        ('Thin Pressure Vessels', 'For a thin-walled closed cylinder, longitudinal stress is:', 'pd/(4t)', 'pd/(2t)', '2pd/t', 'pt/(2d)', 'A', 'Longitudinal stress in a closed thin cylinder is pd/(4t).', 'medium', 112),
        ('Thin Pressure Vessels', 'The hoop stress in a thin cylindrical pressure vessel is how many times its longitudinal stress?', 'One-half', 'Equal', 'Twice', 'Four times', 'C', 'Hoop stress pd/(2t) is twice longitudinal stress pd/(4t).', 'easy', 113),
        ('Thin Pressure Vessels', 'The thin-wall approximation for a pressure vessel is appropriate when wall thickness is:', 'Small compared with the radius', 'Greater than the diameter', 'Equal to the radius', 'Independent of the vessel size', 'A', 'Thin-wall theory assumes t is small relative to radius, so through-thickness stress variation is small.', 'easy', 114),
        ('Thin Pressure Vessels', 'A thin cylinder has internal pressure 2 MPa, diameter 500 mm, and wall thickness 10 mm. Its hoop stress is:', '25 MPa', '50 MPa', '100 MPa', '200 MPa', 'B', 'Hoop stress = pd/(2t) = 2(500)/(20) = 50 MPa.', 'medium', 115),
        ('Thin Pressure Vessels', 'For a thin spherical vessel, membrane stress is:', 'pd/(4t)', 'pd/(2t)', 'pd/t', 'pt/d', 'A', 'For a sphere, membrane tensile stress is pd/(4t).', 'medium', 116),
        ('Thin Pressure Vessels', 'For equal pressure, diameter, and thickness, hoop stress in a thin cylinder compared with a thin sphere is:', 'Twice as large', 'Half as large', 'Equal', 'Four times smaller', 'A', 'Cylinder hoop stress is pd/(2t), while spherical membrane stress is pd/(4t).', 'medium', 117),
        ('Thin Pressure Vessels', 'In a thin-walled vessel, radial stress is often neglected compared with hoop stress because:', 'Its magnitude is small relative to the membrane stress', 'It is always tensile', 'It is larger than hoop stress', 'It causes no pressure', 'A', 'Thin-wall membrane stresses dominate; radial stress varies from pressure to near zero across a small wall thickness.', 'medium', 118),
        ('Thin Pressure Vessels', 'For a closed-end thin cylinder, longitudinal stress arises to balance pressure force on the:', 'End cap', 'Cylindrical side area only', 'Outside surface only', 'Wall thickness', 'A', 'The internal pressure force on the end cap is balanced by longitudinal membrane force in the shell.', 'medium', 119),
        ('Thin Pressure Vessels', 'A thin cylindrical shell is closed at both ends. If internal pressure doubles with geometry unchanged, hoop stress:', 'Doubles', 'Halves', 'Becomes four times', 'Remains unchanged', 'A', 'Hoop stress is directly proportional to internal pressure.', 'easy', 120),

        -- Columns and buckling (121-130)
        ('Columns and Buckling', 'Euler critical load for a pin-ended column is:', 'pi^2 EI/L^2', '2 pi EI/L', 'EI/L^2', 'pi EI/L^4', 'A', 'For a pin-ended ideal column, P_cr = pi^2 EI/L^2.', 'medium', 121),
        ('Columns and Buckling', 'The effective length of an ideal column fixed at both ends is:', 'L/2', 'L', '2L', 'L/sqrt(2)', 'A', 'For fixed-fixed end conditions, effective length factor is 0.5.', 'medium', 122),
        ('Columns and Buckling', 'The effective length of an ideal cantilever column is:', 'L/2', 'L', '2L', '2.5L', 'C', 'A fixed-free column has effective length 2L.', 'medium', 123),
        ('Columns and Buckling', 'Slenderness ratio of a column is effective length divided by:', 'Radius of gyration', 'Cross-sectional area', 'Section modulus', 'Wall thickness', 'A', 'Slenderness ratio lambda = effective length / least radius of gyration.', 'easy', 124),
        ('Columns and Buckling', 'For a given material and cross-section, Euler buckling load varies with column length as:', '1/L^2', '1/L', 'L', 'L^2', 'A', 'Euler load is inversely proportional to the square of effective length.', 'easy', 125),
        ('Columns and Buckling', 'A column buckles about the axis with:', 'The smaller second moment of area', 'The larger second moment of area', 'The larger cross-sectional area only', 'The larger perimeter', 'A', 'Buckling resistance is lowest about the weak axis with the smaller I or radius of gyration.', 'medium', 126),
        ('Columns and Buckling', 'Euler theory is most applicable to:', 'Long slender columns remaining elastic before buckling', 'Short blocks failing only by crushing', 'Cables under tension', 'Plastic hinges in compact beams', 'A', 'Euler theory assumes a slender elastic column and small deflection before instability.', 'easy', 127),
        ('Columns and Buckling', 'If a pin-ended column length doubles with all other properties unchanged, its Euler load becomes:', 'One-half', 'One-quarter', 'Twice', 'Four times', 'B', 'P_cr is proportional to 1/L^2; doubling length reduces the load to one-quarter.', 'medium', 128),
        ('Columns and Buckling', 'The critical buckling load of an ideal column is independent of:', 'Initial imperfection amplitude in the perfect Euler model', 'Elastic modulus', 'Second moment of area', 'Effective length', 'A', 'The ideal Euler formula contains E, I, and effective length; it assumes a perfectly straight column.', 'hard', 129),
        ('Columns and Buckling', 'A short compression member is more likely to fail by:', 'Crushing or yielding', 'Elastic buckling only', 'Fatigue in every case', 'Torsional divergence', 'A', 'Short columns tend to reach material compressive strength before elastic instability.', 'easy', 130),

        -- Strain energy and impact (131-140)
        ('Strain Energy and Impact', 'For a linearly elastic member loaded gradually, axial strain energy is:', 'P delta/2', 'P delta', '2P delta', 'P/delta', 'A', 'The load-deflection diagram is triangular, so U = 1/2 P delta.', 'easy', 131),
        ('Strain Energy and Impact', 'The strain energy per unit volume in a linearly elastic material under uniaxial stress is:', 'sigma^2/(2E)', 'sigma E/2', 'E/(2sigma)', 'sigma/E^2', 'A', 'Energy density is one-half stress times strain = sigma^2/(2E).', 'medium', 132),
        ('Strain Energy and Impact', 'Modulus of resilience is the elastic strain energy stored per unit:', 'Volume up to elastic limit', 'Mass at fracture', 'Length at yield', 'Area at ultimate load', 'A', 'Modulus of resilience is recoverable elastic energy per unit volume up to the elastic limit.', 'medium', 133),
        ('Strain Energy and Impact', 'A linear spring of stiffness k is deflected by delta. Its stored energy is:', 'k delta^2/2', 'k delta', '2k/delta', 'delta/(2k)', 'A', 'Spring strain energy is the area under its force-deflection curve, 1/2 k delta^2.', 'easy', 134),
        ('Strain Energy and Impact', 'A bar is subjected to a sudden application of a constant axial load, with no impact velocity. In the ideal elastic case, the maximum stress is:', 'Equal to the static stress', 'Twice the static stress', 'Half the static stress', 'Four times the static stress', 'B', 'A suddenly applied load can produce a maximum elastic stress twice its static value.', 'hard', 135),
        ('Strain Energy and Impact', 'Castigliano theorem can be used to find displacement by differentiating strain energy with respect to:', 'The corresponding force', 'The elastic modulus', 'The cross-sectional area', 'The density', 'A', 'For a linear elastic system, displacement in a force direction is partial derivative of strain energy with respect to that force.', 'medium', 136),
        ('Strain Energy and Impact', 'For elastic torsion of a shaft, torsional strain energy can be written as:', 'T theta/2', 'T theta', '2T/theta', 'theta/(2T)', 'A', 'For a linear torque-twist relation, the stored energy equals half torque times twist.', 'medium', 137),
        ('Strain Energy and Impact', 'A 10 kN load causes 2 mm extension in a linear elastic bar. The strain energy stored is:', '5 J', '10 J', '20 J', '40 J', 'B', 'U = P delta/2 = 10000(0.002)/2 = 10 J.', 'medium', 138),
        ('Strain Energy and Impact', 'The unit of strain energy is:', 'Joule', 'Pascal', 'Metre', 'Newton per metre', 'A', 'Strain energy is work and is measured in joules.', 'easy', 139),
        ('Strain Energy and Impact', 'Under a gradually applied load, the work input to a linearly elastic spring is:', 'Equal to the elastic energy stored', 'Always twice the energy stored', 'Always zero', 'Independent of its deflection', 'A', 'In an ideal conservative linear elastic spring, work input equals stored strain energy.', 'easy', 140),

        -- Combined stresses and eccentric loading (141-150)
        ('Combined Stresses', 'A member under axial force P and bending moment M has normal stress at a fibre y from the neutral axis:', 'P/A +/- My/I', 'P/A + VQ/It', 'T r/J only', 'P I/(Ay)', 'A', 'Axial and bending normal stresses superpose as P/A plus or minus My/I.', 'medium', 141),
        ('Combined Stresses', 'A load applied with eccentricity e to a column produces:', 'Axial force P and bending moment Pe', 'Only shear force Pe', 'Only torsion P/e', 'No moment', 'A', 'An eccentric axial load is statically equivalent to a centred force and moment Pe.', 'easy', 142),
        ('Combined Stresses', 'A rectangular section of area A carries a compressive force P with eccentricity e. The direct stress magnitude is:', 'P/A', 'Pe/A', 'A/P', 'P e', 'A', 'The uniform direct component is compressive force divided by area.', 'easy', 143),
        ('Combined Stresses', 'The bending stress caused by an eccentric compressive load is greatest at the fibre:', 'Farthest from the neutral axis', 'On the neutral axis', 'At the centroid only', 'Nearest to the centroid always', 'A', 'Bending stress magnitude is proportional to distance from the neutral axis.', 'easy', 144),
        ('Combined Stresses', 'For a rectangular section under eccentric compression, the load lies within the kern when:', 'No tensile stress develops anywhere in the section', 'The entire section is in tension', 'The bending moment is zero only', 'The axial load is zero', 'A', 'The kern is the region where eccentric compression produces compression over the entire section.', 'hard', 145),
        ('Combined Stresses', 'A circular section of radius r has kern radius:', 'r/4', 'r/2', 'r/8', 'r', 'A', 'For a solid circle, the kern radius is I/(A c) = r^2/(4r) = r/4.', 'hard', 146),
        ('Combined Stresses', 'At a point under two perpendicular normal stresses and shear stress, the principal stresses are obtained by:', 'Stress transformation or Mohr circle', 'Adding the strains only', 'Using torsion formula alone', 'Dividing load by length', 'A', 'Principal stresses follow from the plane-stress transformation equations or Mohr circle.', 'medium', 147),
        ('Combined Stresses', 'A shaft under torque and bending experiences at its surface:', 'Bending normal stress and torsional shear stress', 'Only hydrostatic stress', 'Only axial strain', 'No stress if rotating steadily', 'A', 'Bending generates normal stress while torque generates shear stress.', 'medium', 148),
        ('Combined Stresses', 'For a circular shaft under combined bending moment M and torque T, maximum principal stress depends on:', 'Both bending normal stress and torsional shear stress', 'Torque only in all cases', 'Bending only in all cases', 'Shaft length only', 'A', 'The plane-stress principal value combines the normal bending stress and torsional shear stress.', 'medium', 149),
        ('Combined Stresses', 'The principle of superposition is valid when the material response is:', 'Linear elastic and deformations are small', 'Plastic with large deformation', 'Viscoelastic at all times', 'Fracturing during loading', 'A', 'Superposition requires linearity and compatible boundary conditions, typically small-strain linear elasticity.', 'medium', 150),

        -- Thick cylinders and rotating rings (151-160)
        ('Thick Cylinders', 'For a thick cylinder under internal pressure, radial and hoop stresses vary:', 'Across the wall thickness', 'Uniformly and identically everywhere', 'Only along its length', 'Only with angular velocity', 'A', 'Thick-cylinder stress fields are nonuniform through the wall.', 'medium', 151),
        ('Thick Cylinders', 'At the inner surface of a thick cylinder subjected to internal pressure p, radial stress is approximately:', 'Compressive with magnitude p', 'Tensile with magnitude p', 'Zero', 'Equal to hoop stress', 'A', 'Radial stress at a pressurized inner boundary equals minus the internal pressure under the usual tensile-positive convention.', 'medium', 152),
        ('Thick Cylinders', 'At a traction-free outer surface of a thick cylinder, radial stress is:', 'Zero gauge stress', 'Equal to internal pressure', 'Equal to hoop stress', 'Maximum tensile stress', 'A', 'The outer boundary has no applied radial traction, so radial stress is zero there.', 'medium', 153),
        ('Thick Cylinders', 'Lame equations are used to analyze:', 'Stress distribution in thick-walled cylinders', 'Thin beams under bending', 'Open-channel flow', 'Torsion of noncircular shafts only', 'A', 'Lame theory gives radial and circumferential stresses in thick cylinders.', 'easy', 154),
        ('Thick Cylinders', 'In a thick cylinder under internal pressure, the maximum hoop stress usually occurs at the:', 'Inner surface', 'Outer surface', 'Mid-thickness for every geometry', 'End cap only', 'A', 'For the usual internal-pressure-only case, hoop stress is greatest at the inner radius.', 'medium', 155),
        ('Thick Cylinders', 'A compound cylinder is often shrink-fitted to:', 'Introduce beneficial initial compressive hoop stress at the bore', 'Remove all radial stress', 'Reduce the outside diameter to zero', 'Make the cylinder behave as a thin plate', 'A', 'Shrink fitting creates residual stresses that can reduce peak tensile hoop stress under service pressure.', 'hard', 156),
        ('Thick Cylinders', 'For a thick cylinder, the thin-wall formula becomes less accurate as:', 'Wall thickness becomes a significant fraction of radius', 'Pressure becomes zero', 'Length increases', 'Material density decreases', 'A', 'Thin-wall theory neglects through-thickness stress variation, which matters when the wall is not thin.', 'easy', 157),
        ('Thick Cylinders', 'A rotating thin ring develops hoop stress primarily because of:', 'Centrifugal force of its distributed mass', 'Hydrostatic pressure only', 'Axial compression from supports', 'Thermal conduction', 'A', 'Rotation produces radial inertia forces that are balanced by circumferential tensile stress.', 'medium', 158),
        ('Thick Cylinders', 'For a thick cylinder with internal pressure and zero external pressure, radial stress changes from approximately:', 'Minus internal pressure at the bore to zero at the outer surface', 'Zero at the bore to plus internal pressure outside', 'Uniform tension throughout', 'Zero everywhere', 'A', 'Radial stress satisfies the pressure boundary conditions at the inner and outer surfaces.', 'medium', 159),
        ('Thick Cylinders', 'The hoop stress in a pressurized thick cylinder is a:', 'Circumferential normal stress', 'Radial shear stress', 'Longitudinal shear strain', 'Hydrostatic pressure head', 'A', 'Hoop stress acts tangentially around the circumference of the cylindrical wall.', 'easy', 160),

        -- Failure theories and design (161-170)
        ('Failure Theories', 'The maximum principal stress theory is also known as:', 'Rankine theory', 'Tresca theory', 'von Mises theory', 'Coulomb-Mohr theory', 'A', 'Rankine failure theory compares the maximum principal stress with a limiting strength.', 'medium', 161),
        ('Failure Theories', 'The maximum shear stress theory is commonly called:', 'Tresca theory', 'Rankine theory', 'Beltrami theory', 'Euler theory', 'A', 'Tresca theory predicts yielding when maximum shear stress reaches the uniaxial yield shear value.', 'medium', 162),
        ('Failure Theories', 'The distortion-energy theory is commonly called:', 'von Mises theory', 'Rankine theory', 'Euler theory', 'Lame theory', 'A', 'The distortion-energy criterion is the von Mises yield criterion.', 'easy', 163),
        ('Failure Theories', 'For ductile metals under multiaxial static loading, a commonly used yield criterion is:', 'von Mises criterion', 'Maximum principal strain only', 'Euler buckling criterion', 'Griffith criterion only', 'A', 'The von Mises criterion is widely used for ductile metal yielding under multiaxial stress.', 'medium', 164),
        ('Failure Theories', 'A factor of safety against yielding is generally:', 'Yield strength divided by allowable stress', 'Allowable stress divided by yield strength', 'Load divided by displacement', 'Elastic modulus divided by strain', 'A', 'The factor of safety is the strength limit divided by the corresponding working stress.', 'easy', 165),
        ('Failure Theories', 'A ductile material under pure shear tau has von Mises equivalent stress:', 'sqrt(3) tau', 'tau/sqrt(3)', '2tau', '3tau', 'A', 'For pure shear, von Mises equivalent stress is sqrt(3) times the shear stress.', 'hard', 166),
        ('Failure Theories', 'The maximum shear stress in a uniaxial tensile test at yield is:', 'Half the tensile yield stress', 'Equal to tensile yield stress', 'Twice the tensile yield stress', 'Zero', 'A', 'In uniaxial tension, principal stresses are sigma_y and zero, so maximum shear is sigma_y/2.', 'medium', 167),
        ('Failure Theories', 'The maximum principal stress criterion is often more suitable for:', 'Brittle materials', 'Ductile metals in pure shear only', 'Rubber at large strain only', 'Ideal fluids', 'A', 'Brittle failure is often governed by tensile principal stress rather than shear yielding.', 'medium', 168),
        ('Failure Theories', 'A design allowable stress is commonly obtained by:', 'Dividing a specified strength by a factor of safety', 'Multiplying yield strength by an arbitrary factor above one', 'Adding density to strength', 'Ignoring material variability', 'A', 'Allowable stress is based on a strength limit reduced by the chosen safety factor.', 'easy', 169),
        ('Failure Theories', 'For a ductile material, yielding is associated primarily with:', 'Shear distortion of the material', 'Hydrostatic stress alone', 'Density change only', 'Elastic modulus becoming infinite', 'A', 'Ductile yielding is associated with deviatoric or distortional stress rather than pure hydrostatic pressure.', 'hard', 170),

        -- Fatigue and cyclic loading (171-180)
        ('Fatigue', 'Fatigue failure is caused primarily by:', 'Repeated or fluctuating stress cycles', 'A single zero-load event', 'Static hydrostatic pressure only', 'Thermal conductivity alone', 'A', 'Fatigue damage accumulates under repeated or fluctuating loading and may occur below static strength.', 'easy', 171),
        ('Fatigue', 'An S-N curve plots stress amplitude against:', 'Number of cycles to failure', 'Elastic modulus', 'Mean grain diameter', 'Temperature gradient only', 'A', 'An S-N diagram relates cyclic stress amplitude to fatigue life in cycles.', 'easy', 172),
        ('Fatigue', 'A fully reversed stress cycle has mean stress:', 'Zero', 'Equal to maximum stress', 'Equal to minimum stress', 'Always tensile', 'A', 'For fully reversed loading, maximum and minimum stresses are equal and opposite, giving zero mean.', 'medium', 173),
        ('Fatigue', 'A surface scratch can reduce fatigue strength because it:', 'Acts as a stress concentrator', 'Raises elastic modulus locally', 'Eliminates cyclic stress', 'Increases the section everywhere', 'A', 'Surface notches concentrate stress and can initiate fatigue cracks.', 'easy', 174),
        ('Fatigue', 'A rotating shaft under a constant transverse load experiences at a material point on its surface:', 'Alternating bending stress as the shaft rotates', 'Constant tensile stress only', 'No stress cycle', 'Only hydrostatic pressure', 'A', 'A surface point rotates between tension and compression relative to the fixed bending plane.', 'medium', 175),
        ('Fatigue', 'Shot peening can improve fatigue performance by introducing:', 'Compressive residual stress at the surface', 'Tensile residual stress at the surface', 'Large surface cracks', 'Lower surface hardness in every material', 'A', 'Shot peening creates surface compressive residual stress that delays tensile crack initiation.', 'medium', 176),
        ('Fatigue', 'A notch sensitivity factor describes how strongly fatigue strength responds to:', 'A geometric stress raiser', 'A change in density', 'A change in colour', 'A uniform hydrostatic pressure', 'A', 'Notch sensitivity measures the degree to which a material experiences the theoretical fatigue notch effect.', 'medium', 177),
        ('Fatigue', 'For many steels under suitable conditions, an endurance limit is a stress amplitude below which:', 'Fatigue life can be very large', 'Immediate yielding occurs', 'The material melts', 'Static strength is zero', 'A', 'Some steels exhibit an approximate endurance limit below which fatigue failure does not occur in conventional testing.', 'medium', 178),
        ('Fatigue', 'Corrosion fatigue results from the combined action of:', 'Cyclic stress and corrosive environment', 'Static compression and vacuum', 'Heat treatment and polishing only', 'High hardness and no load', 'A', 'A corrosive environment accelerates fatigue crack initiation and growth under cyclic stress.', 'easy', 179),
        ('Fatigue', 'Increasing tensile mean stress generally:', 'Reduces fatigue life for a given alternating stress', 'Increases fatigue life without limit', 'Has no possible effect', 'Eliminates stress amplitude', 'A', 'A tensile mean stress increases crack opening and commonly lowers fatigue strength.', 'medium', 180),

        -- Testing and material response (181-190)
        ('Mechanical Testing', 'A tensile test is commonly used to determine:', 'Elastic modulus, yield strength, and tensile strength', 'Thermal conductivity only', 'Fatigue crack growth only', 'Fracture toughness only', 'A', 'A standard tensile test produces a stress-strain curve from which these properties can be obtained.', 'easy', 181),
        ('Mechanical Testing', 'The extensometer in a tensile test measures:', 'Change in gauge length', 'Applied force only', 'Specimen mass', 'Hardness indentation diameter only', 'A', 'An extensometer measures extension over a defined gauge length.', 'easy', 182),
        ('Mechanical Testing', 'In a tensile test, necking in a ductile specimen begins around the maximum:', 'Engineering stress', 'Elastic strain', 'Poisson ratio', 'Gauge length', 'A', 'Necking begins at the maximum engineering load, which corresponds to ultimate engineering stress.', 'medium', 183),
        ('Mechanical Testing', 'The area under the engineering stress-strain curve up to fracture represents:', 'Toughness per unit volume approximately', 'Young modulus only', 'Poisson ratio', 'Yield stress only', 'A', 'The total work absorbed per unit volume to fracture is represented by the area under the full stress-strain curve.', 'medium', 184),
        ('Mechanical Testing', 'A hardness test primarily measures resistance to:', 'Localized indentation or penetration', 'Uniform thermal expansion', 'Axial extension over a metre', 'Electrical conduction', 'A', 'Hardness tests assess resistance to localized indentation, scratching, or penetration.', 'easy', 185),
        ('Mechanical Testing', 'In a Charpy impact test, the absorbed energy is determined from:', 'Loss of pendulum energy after fracture', 'Specimen density alone', 'Tensile extensometer reading only', 'Change in electrical resistance', 'A', 'The pendulum loses energy as it fractures the notched specimen; the loss estimates absorbed impact energy.', 'medium', 186),
        ('Mechanical Testing', 'A strain gauge measures strain through a change in its:', 'Electrical resistance', 'Mass', 'Density', 'Melting point', 'A', 'A bonded resistance strain gauge changes electrical resistance as it deforms.', 'easy', 187),
        ('Mechanical Testing', 'The proof stress is commonly used as a yield measure for materials that:', 'Do not show a distinct yield point', 'Are perfectly brittle with no elastic range', 'Have zero strain', 'Are fluids', 'A', 'For materials without a clear yield point, an offset proof stress is specified.', 'medium', 188),
        ('Mechanical Testing', 'A torsion test on a circular specimen can be used to estimate:', 'Shear modulus and shear strength', 'Bulk modulus only', 'Thermal expansion coefficient only', 'Density only', 'A', 'Torque and twist measurements allow determination of shear response and torsional strength.', 'medium', 189),
        ('Mechanical Testing', 'In a standard tensile test, true stress differs from engineering stress because true stress uses:', 'Instantaneous cross-sectional area', 'Original cross-sectional area', 'Original gauge length', 'Maximum load only', 'A', 'True stress divides the instantaneous load by instantaneous area.', 'medium', 190),

        -- Stress concentration, joints, and design details (191-200)
        ('Stress Concentration and Design', 'A stress concentration factor is the ratio of:', 'Peak local stress to nominal stress', 'Nominal stress to elastic modulus', 'Load to strain', 'Area to perimeter', 'A', 'K_t = maximum local stress divided by nominal reference stress.', 'easy', 191),
        ('Stress Concentration and Design', 'A circular hole in a plate under tension causes:', 'Local stress concentration at the hole boundary', 'Uniform stress everywhere', 'Zero stress at the hole edge', 'Only hydrostatic stress', 'A', 'The hole disturbs the stress field and raises local stress near its boundary.', 'easy', 192),
        ('Stress Concentration and Design', 'A larger fillet radius at a shoulder generally:', 'Reduces stress concentration', 'Increases stress concentration without limit', 'Eliminates nominal stress', 'Changes Young modulus', 'A', 'A smoother geometric transition lowers the local concentration factor.', 'medium', 193),
        ('Stress Concentration and Design', 'The nominal tensile stress in a flat plate of width b and thickness t under load P is:', 'P/(bt)', 'Pbt', 'Pt/b', 'b/(Pt)', 'A', 'The nominal stress is axial force divided by gross cross-sectional area bt.', 'easy', 194),
        ('Stress Concentration and Design', 'A bolted lap joint under axial tension transfers load primarily through:', 'Bearing and shear interaction at the fasteners and connected plates', 'Torsion of the bolt head only', 'Hydrostatic pressure', 'Thermal conduction', 'A', 'The load path involves bolt shear, plate bearing, and net-section tension depending on the joint design.', 'medium', 195),
        ('Stress Concentration and Design', 'In a riveted or bolted plate, net section area is calculated by reducing gross area for:', 'The width occupied by holes', 'The plate length', 'The material density', 'The bolt pitch squared', 'A', 'Fastener holes reduce the effective net tensile area across the critical section.', 'easy', 196),
        ('Stress Concentration and Design', 'The purpose of a gradual change in shaft diameter is to:', 'Reduce stress concentration at the shoulder', 'Increase notch severity', 'Make torque zero', 'Increase shaft density', 'A', 'A fillet and gradual transition reduce peak local stresses at a shoulder.', 'easy', 197),
        ('Stress Concentration and Design', 'A ductile material with a notch under static loading may redistribute local stress after yielding because of:', 'Plastic deformation', 'Elastic modulus increase to infinity', 'Zero strain at the notch', 'Hydrostatic compression only', 'A', 'Local yielding in ductile materials can redistribute peak stress, though fatigue may still be critical.', 'hard', 198),
        ('Stress Concentration and Design', 'A design check for a member under axial tension should compare the applied stress with:', 'An allowable stress based on strength and safety requirements', 'The material density', 'The member colour', 'The support temperature only', 'A', 'Safe design requires demand to remain within an allowable limit based on relevant strength and safety factors.', 'easy', 199),
        ('Stress Concentration and Design', 'The most effective first step to reduce stress concentration at a sharp re-entrant corner is usually to:', 'Provide a generous radius or smooth transition', 'Make the corner sharper', 'Reduce the member width abruptly', 'Add a surface scratch', 'A', 'A generous radius smooths the load path and reduces the local peak stress.', 'easy', 200)
    ) AS seed(topic_title, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, difficulty, display_order)
    WHERE NOT EXISTS (
        SELECT 1
        FROM public.practice_questions existing
        WHERE existing.subject_id = v_subject_id
          AND existing.question_text = '[' || seed.topic_title || '] ' || seed.question_text
    );

    SELECT count(*) INTO v_question_count
    FROM public.practice_questions
    WHERE subject_id = v_subject_id
      AND (
          question_text LIKE '[Stress and Strain]%'
          OR question_text LIKE '[Elastic Constants]%'
          OR question_text LIKE '[Axial Deformation]%'
          OR question_text LIKE '[Thermal Stress and Compound Bars]%'
          OR question_text LIKE '[Shear Force and Bending Moment]%'
          OR question_text LIKE '[Bending Stress]%'
          OR question_text LIKE '[Shear Stress in Beams]%'
          OR question_text LIKE '[Beam Deflection]%'
          OR question_text LIKE '[Torsion of Circular Shafts]%'
          OR question_text LIKE '[Springs]%'
          OR question_text LIKE '[Principal Stress and Mohr Circle]%'
          OR question_text LIKE '[Thin Pressure Vessels]%'
          OR question_text LIKE '[Columns and Buckling]%'
          OR question_text LIKE '[Strain Energy and Impact]%'
          OR question_text LIKE '[Combined Stresses]%'
          OR question_text LIKE '[Thick Cylinders]%'
          OR question_text LIKE '[Failure Theories]%'
          OR question_text LIKE '[Fatigue]%'
          OR question_text LIKE '[Mechanical Testing]%'
          OR question_text LIKE '[Stress Concentration and Design]%'
      )
      AND display_order BETWEEN 1 AND 200;

    IF v_question_count < 200 THEN
        RAISE EXCEPTION 'Expected 200 Strength of Materials questions, found %', v_question_count;
    END IF;
END;
$seed$;
