-- Original Engineering Materials practice questions for the JobForSure question bank.
-- Run after practice_question_functions.sql. Missing branch/subject catalog rows
-- are created automatically.

DO $seed$
DECLARE
    v_branch_id UUID;
    v_subject_id UUID;
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM public.engineering_branches
        WHERE name = 'Mechanical Engineering'
    ) THEN
        INSERT INTO public.engineering_branches (name, code, description, is_active)
        VALUES (
            'Mechanical Engineering',
            CASE
                WHEN EXISTS (
                    SELECT 1 FROM public.engineering_branches WHERE code = 'ME'
                ) THEN 'ME-' || upper(substr(replace(gen_random_uuid()::TEXT, '-', ''), 1, 8))
                ELSE 'ME'
            END,
            'Mechanical engineering branch',
            TRUE
        );
    END IF;

    SELECT id INTO v_branch_id
    FROM public.engineering_branches
    WHERE name = 'Mechanical Engineering';

    IF v_branch_id IS NULL THEN
        RAISE EXCEPTION 'Could not create or find the Mechanical Engineering branch';
    END IF;

    INSERT INTO public.subjects (
        branch_id, name, code, description, display_order, is_active
    ) VALUES (
        v_branch_id, 'Engineering Materials', 'EM',
        'Engineering materials, properties, processing, and selection', 0, TRUE
    )
    ON CONFLICT (branch_id, name) DO NOTHING;

    SELECT s.id INTO v_subject_id
    FROM public.subjects s
    JOIN public.engineering_branches b ON b.id = s.branch_id
    WHERE b.name = 'Mechanical Engineering'
      AND s.name = 'Engineering Materials';

    IF v_subject_id IS NULL THEN
        RAISE EXCEPTION 'Create the Engineering Materials subject under Mechanical Engineering before seeding questions';
    END IF;

    INSERT INTO public.practice_questions (
        subject_id, topic_id, question_text, question_type, options,
        correct_answer, explanation, difficulty, points, display_order,
        is_published
    )
    SELECT
        v_subject_id,
        NULL,
        seed.question_text,
        'mcq',
        seed.options,
        seed.correct_answer,
        seed.explanation,
        seed.difficulty,
        10,
        seed.display_order,
        TRUE
    FROM (
        VALUES
        (
            'How many atoms are associated with one conventional face-centered cubic unit cell?',
            jsonb_build_array(jsonb_build_object('value', 'A', 'text', '2'), jsonb_build_object('value', 'B', 'text', '4'), jsonb_build_object('value', 'C', 'text', '6'), jsonb_build_object('value', 'D', 'text', '8')),
            'B',
            'A face-centered cubic cell has 8 corner atoms contributing 1 atom in total, plus 6 face-centered atoms contributing 3, for 4 atoms total.',
            'easy', 1
        ),
        (
            'What is the coordination number of a close-packed hexagonal crystal structure?',
            jsonb_build_array(jsonb_build_object('value', 'A', 'text', '6'), jsonb_build_object('value', 'B', 'text', '8'), jsonb_build_object('value', 'C', 'text', '10'), jsonb_build_object('value', 'D', 'text', '12')),
            'D',
            'In a close-packed hexagonal structure, each atom has 12 nearest neighbors.',
            'easy', 2
        ),
        (
            'Which change is most directly associated with cold working a ductile metal?',
            jsonb_build_array(jsonb_build_object('value', 'A', 'text', 'Lower dislocation density'), jsonb_build_object('value', 'B', 'text', 'Higher strength and lower ductility'), jsonb_build_object('value', 'C', 'text', 'Complete removal of residual stress'), jsonb_build_object('value', 'D', 'text', 'Lower hardness with unchanged ductility')),
            'B',
            'Plastic deformation increases dislocation density, which raises strength and hardness while usually reducing ductility.',
            'medium', 3
        ),
        (
            'During recrystallization of a cold-worked metal, what primarily forms?',
            jsonb_build_array(jsonb_build_object('value', 'A', 'text', 'New, relatively strain-free grains'), jsonb_build_object('value', 'B', 'text', 'A continuous liquid film'), jsonb_build_object('value', 'C', 'text', 'Only larger existing dislocations'), jsonb_build_object('value', 'D', 'text', 'A polymer cross-linked network')),
            'A',
            'Recrystallization forms new, low-dislocation-density grains that replace the deformed microstructure.',
            'medium', 4
        ),
        (
            'Why is quenched steel commonly tempered afterward?',
            jsonb_build_array(jsonb_build_object('value', 'A', 'text', 'To increase brittleness'), jsonb_build_object('value', 'B', 'text', 'To reduce brittleness and improve toughness'), jsonb_build_object('value', 'C', 'text', 'To melt the surface layer'), jsonb_build_object('value', 'D', 'text', 'To restore the original casting shape')),
            'B',
            'Tempering reduces some of the brittleness and residual stresses of as-quenched steel while improving toughness.',
            'easy', 5
        ),
        (
            'What enables many stainless steels to resist corrosion in ordinary environments?',
            jsonb_build_array(jsonb_build_object('value', 'A', 'text', 'A chromium-rich passive surface film'), jsonb_build_object('value', 'B', 'text', 'A thick graphite coating'), jsonb_build_object('value', 'C', 'text', 'A high sulfur content'), jsonb_build_object('value', 'D', 'text', 'A porous oxide scale that continually flakes off')),
            'A',
            'Chromium in stainless steel supports formation of a thin, adherent passive oxide film that slows further corrosion.',
            'easy', 6
        ),
        (
            'Why does flake graphite make gray cast iron comparatively weak in tension?',
            jsonb_build_array(jsonb_build_object('value', 'A', 'text', 'The flakes act as stress concentrators'), jsonb_build_object('value', 'B', 'text', 'The flakes dissolve all carbon'), jsonb_build_object('value', 'C', 'text', 'The flakes prevent solidification'), jsonb_build_object('value', 'D', 'text', 'The flakes eliminate grain boundaries')),
            'A',
            'Graphite flakes create local stress concentrations and provide easy paths for crack initiation under tensile loading.',
            'medium', 7
        ),
        (
            'Which addition is commonly used to promote spheroidal graphite in ductile cast iron?',
            jsonb_build_array(jsonb_build_object('value', 'A', 'text', 'Magnesium'), jsonb_build_object('value', 'B', 'text', 'Sulfur'), jsonb_build_object('value', 'C', 'text', 'Lead'), jsonb_build_object('value', 'D', 'text', 'Tin')),
            'A',
            'Small magnesium additions to the melt promote nodular rather than flake-shaped graphite, with suitable melt treatment.',
            'medium', 8
        ),
        (
            'Fatigue failure is most closely associated with which loading condition?',
            jsonb_build_array(jsonb_build_object('value', 'A', 'text', 'Repeated or fluctuating stress cycles'), jsonb_build_object('value', 'B', 'text', 'A single static load below yield only'), jsonb_build_object('value', 'C', 'text', 'Uniform heating without stress'), jsonb_build_object('value', 'D', 'text', 'Hydrostatic pressure with no cycling')),
            'A',
            'Fatigue cracks initiate and grow under repeated or fluctuating stresses, sometimes below the static tensile strength.',
            'easy', 9
        ),
        (
            'Creep is the time-dependent deformation of a material under sustained stress, especially at what condition?',
            jsonb_build_array(jsonb_build_object('value', 'A', 'text', 'Elevated temperature'), jsonb_build_object('value', 'B', 'text', 'Zero temperature'), jsonb_build_object('value', 'C', 'text', 'A vacuum only'), jsonb_build_object('value', 'D', 'text', 'A single impact')),
            'A',
            'Creep becomes particularly important for materials carrying sustained loads at elevated temperatures.',
            'easy', 10
        ),
        (
            'What does a Charpy impact test primarily compare?',
            jsonb_build_array(jsonb_build_object('value', 'A', 'text', 'Energy absorbed by a notched specimen during impact'), jsonb_build_object('value', 'B', 'text', 'Electrical conductivity at room temperature'), jsonb_build_object('value', 'C', 'text', 'Hardness under a static indentation'), jsonb_build_object('value', 'D', 'text', 'Thermal expansion of an unnotched bar')),
            'A',
            'The Charpy test measures impact energy absorbed as a pendulum fractures a notched specimen.',
            'easy', 11
        ),
        (
            'Brass is principally a copper-zinc alloy. In common alpha brass, zinc atoms mainly form which type of solid solution?',
            jsonb_build_array(jsonb_build_object('value', 'A', 'text', 'Interstitial'), jsonb_build_object('value', 'B', 'text', 'Substitutional'), jsonb_build_object('value', 'C', 'text', 'Ionic'), jsonb_build_object('value', 'D', 'text', 'Covalent network')),
            'B',
            'Copper and zinc atoms have comparable metallic sizes, so zinc mainly substitutes for copper atoms in the lattice.',
            'medium', 12
        ),
        (
            'What is a defining processing characteristic of a thermoplastic polymer?',
            jsonb_build_array(jsonb_build_object('value', 'A', 'text', 'It can soften on heating and be reshaped repeatedly'), jsonb_build_object('value', 'B', 'text', 'It must decompose before it softens'), jsonb_build_object('value', 'C', 'text', 'It is always a metallic conductor'), jsonb_build_object('value', 'D', 'text', 'It cannot be molded after polymerization')),
            'A',
            'Thermoplastics soften when heated and can generally be reshaped; this differs from permanently cross-linked thermosets.',
            'easy', 13
        ),
        (
            'Why are continuous carbon fibers used in some lightweight structural composites?',
            jsonb_build_array(jsonb_build_object('value', 'A', 'text', 'They can provide high stiffness and strength for their mass along the fiber direction'), jsonb_build_object('value', 'B', 'text', 'They make the composite isotropic in every layup'), jsonb_build_object('value', 'C', 'text', 'They eliminate the need for a matrix'), jsonb_build_object('value', 'D', 'text', 'They always increase ductility in every direction')),
            'A',
            'Carbon fibers can deliver high specific stiffness and strength in their direction; composite properties depend on fiber orientation and matrix.',
            'medium', 14
        ),
        (
            'How does shot peening improve the fatigue performance of many metal components?',
            jsonb_build_array(jsonb_build_object('value', 'A', 'text', 'It introduces beneficial compressive residual stress near the surface'), jsonb_build_object('value', 'B', 'text', 'It removes all grain boundaries'), jsonb_build_object('value', 'C', 'text', 'It converts the whole part into a liquid'), jsonb_build_object('value', 'D', 'text', 'It increases tensile residual stress at the surface')),
            'A',
            'Shot impacts plastically deform the surface and introduce compressive residual stresses that can delay fatigue-crack initiation.',
            'medium', 15
        )
    ) AS seed(question_text, options, correct_answer, explanation, difficulty, display_order)
    WHERE NOT EXISTS (
        SELECT 1
        FROM public.practice_questions existing
        WHERE existing.subject_id = v_subject_id
          AND existing.question_text = seed.question_text
    );

    INSERT INTO public.practice_questions (
        subject_id, topic_id, question_text, question_type, options,
        correct_answer, explanation, difficulty, points, display_order,
        is_published
    )
    SELECT
        v_subject_id,
        topic.id,
        seed.question_text,
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
        -- Crystal structure and diffusion (16-30)
        ('Crystal Structures', 'How many atoms are contained in a conventional body-centered cubic unit cell?', '1', '2', '4', '8', 'B', 'The eight corner contributions total one atom, and the body-center atom contributes one more.', 'easy', 16),
        ('Crystal Structures', 'What is the approximate atomic packing factor of an ideal body-centered cubic structure?', '0.52', '0.68', '0.74', '0.91', 'B', 'The ideal BCC atomic packing factor is approximately 0.68.', 'medium', 17),
        ('Crystal Structures', 'What is the approximate atomic packing factor of an ideal face-centered cubic structure?', '0.34', '0.52', '0.68', '0.74', 'D', 'FCC is close packed and has an atomic packing factor of about 0.74.', 'easy', 18),
        ('Crystal Structures', 'How many nearest neighbors surround an atom in a BCC lattice?', '4', '6', '8', '12', 'C', 'Each BCC atom has eight nearest neighbors.', 'easy', 19),
        ('Crystal Structures', 'Which stacking sequence describes close-packed FCC layers?', 'ABAB', 'ABCABC', 'AABB', 'ABBC', 'B', 'FCC close-packed planes repeat in an ABCABC sequence.', 'medium', 20),
        ('Crystal Structures', 'Which slip system is commonly active in BCC metals?', '{100}<100>', '{110}<111>', '{111}<110>', '{0001}<11-20>', 'B', 'A common BCC slip family is {110}<111>; other families may also operate depending on conditions.', 'medium', 21),
        ('Crystal Structures', 'What is the ideal axial ratio c/a for a close-packed hexagonal structure?', '1.225', '1.414', '1.633', '2.000', 'C', 'The ideal HCP c/a ratio is approximately 1.633.', 'medium', 22),
        ('Crystal Structures', 'Carbon occupies which type of lattice site when dissolved in ferrite?', 'Interstitial', 'Substitutional', 'Vacancy', 'Grain-boundary only', 'A', 'The relatively small carbon atoms occupy interstitial sites in iron.', 'easy', 23),
        ('Crystal Structures', 'In a substitutional solid solution, solute atoms primarily do what?', 'Occupy interstitial spaces', 'Replace solvent atoms on lattice sites', 'Form pores', 'Remove dislocations', 'B', 'Substitutional solute atoms replace host atoms at normal lattice positions.', 'easy', 24),
        ('Crystal Structures', 'For a BCC unit cell with lattice parameter a and atomic radius r, which relation applies?', 'a = 2r', 'a = 4r', 'sqrt(3)a = 4r', 'sqrt(2)a = 4r', 'C', 'Atoms touch along the BCC body diagonal, whose length is sqrt(3)a = 4r.', 'medium', 25),
        ('Crystal Structures', 'For an FCC unit cell with lattice parameter a and atomic radius r, which relation applies?', 'a = 4r', 'sqrt(2)a = 4r', 'sqrt(3)a = 4r', 'a = 2sqrt(3)r', 'B', 'Atoms touch along an FCC face diagonal, so sqrt(2)a = 4r.', 'medium', 26),
        ('Crystal Structures', 'A grain boundary is best classified as which kind of crystal defect?', 'Point defect', 'Line defect', 'Planar defect', 'Volume defect', 'C', 'A grain boundary is a two-dimensional interface between differently oriented grains.', 'easy', 27),
        ('Crystal Structures', 'According to the Hall-Petch trend, reducing average grain size generally does what to yield strength?', 'Decreases it', 'Increases it', 'Leaves it exactly unchanged', 'Makes it zero', 'B', 'Grain boundaries impede dislocation motion, so finer grains commonly increase yield strength.', 'medium', 28),
        ('Crystal Structures', 'A material whose measured properties vary with direction is described as:', 'Isotropic', 'Amorphous', 'Anisotropic', 'Eutectic', 'C', 'Anisotropic materials have direction-dependent properties.', 'easy', 29),
        ('Crystal Structures', 'Which technique is commonly used to identify crystalline phases from diffraction peaks?', 'X-ray diffraction', 'Liquid penetrant testing', 'Brinell testing', 'Ultrasonic thickness gauging', 'A', 'X-ray diffraction patterns can be compared with crystal structures and phase reference data.', 'easy', 30),

        -- Defects, bonding, and microstructure (31-45)
        ('Defects and Bonding', 'A missing atom at a normal lattice site is called a:', 'Vacancy', 'Dislocation', 'Twin boundary', 'Precipitate', 'A', 'A vacancy is a point defect created by an unoccupied lattice site.', 'easy', 31),
        ('Defects and Bonding', 'An extra half-plane of atoms terminating inside a crystal is associated with which dislocation?', 'Screw', 'Edge', 'Perfect vacancy', 'Twin', 'B', 'An edge dislocation can be visualized as an extra half-plane ending within the crystal.', 'medium', 32),
        ('Defects and Bonding', 'A screw dislocation is characterized by a Burgers vector that is generally:', 'Parallel to the dislocation line', 'Perpendicular to the dislocation line', 'Always zero', 'Normal to every grain boundary', 'A', 'For a screw dislocation the Burgers vector is parallel to the dislocation line.', 'medium', 33),
        ('Defects and Bonding', 'Which bonding type is dominant in most pure metals?', 'Metallic', 'Ionic', 'Hydrogen', 'Van der Waals only', 'A', 'Metallic bonding involves delocalized valence electrons shared through the solid.', 'easy', 34),
        ('Defects and Bonding', 'Which bonding type is commonly associated with strong, brittle engineering ceramics?', 'Metallic only', 'Ionic and/or covalent', 'Hydrogen only', 'No interatomic bonding', 'B', 'Many ceramics have strong ionic, covalent, or mixed bonding.', 'easy', 35),
        ('Defects and Bonding', 'Diffusion is the net transport of atoms driven primarily by:', 'A concentration or chemical-potential gradient', 'Gravity alone in every solid', 'Magnetic domains only', 'Elastic modulus', 'A', 'A concentration or chemical-potential gradient provides the driving force for diffusion.', 'easy', 36),
        ('Defects and Bonding', 'Raising temperature usually increases solid-state diffusion because it:', 'Lowers atomic vibration to zero', 'Raises the fraction of atoms able to overcome activation barriers', 'Eliminates all vacancies', 'Stops atomic motion', 'B', 'Higher temperature increases the fraction of atoms with sufficient energy for jumps.', 'medium', 37),
        ('Defects and Bonding', 'Which atoms generally diffuse faster through a metal lattice?', 'Small interstitial atoms', 'Large substitutional atoms', 'All atoms at identical rates', 'Atoms fixed at grain centers', 'A', 'Small interstitial atoms can migrate between interstitial sites without requiring a host vacancy.', 'medium', 38),
        ('Defects and Bonding', 'In Fick first law, diffusion flux is proportional to:', 'The negative concentration gradient', 'The square of grain size only', 'Young modulus', 'The melting point only', 'A', 'Fick first law relates flux to the negative concentration gradient: J = -D grad C.', 'medium', 39),
        ('Defects and Bonding', 'A precipitate in a metal alloy is:', 'A second phase formed within a parent matrix', 'A missing lattice plane', 'A surface scratch only', 'A measurement artifact', 'A', 'Precipitates are particles of a second phase dispersed in a matrix.', 'easy', 40),
        ('Defects and Bonding', 'A coherent precipitate maintains which relationship with its matrix?', 'A crystallographic orientation and approximate lattice matching across the interface', 'No contact with the matrix', 'A continuous liquid layer', 'A random macroscopic shape only', 'A', 'Coherent precipitates have a matching crystallographic relationship with the surrounding matrix.', 'medium', 41),
        ('Defects and Bonding', 'Cold work increases metal strength mainly by increasing:', 'Dislocation interactions and density', 'Equilibrium vacancy size', 'Grain-boundary liquid fraction', 'Atomic mass', 'A', 'A higher dislocation density makes further dislocation motion more difficult.', 'medium', 42),
        ('Defects and Bonding', 'During recovery after cold work, which change can occur before new grains form?', 'Residual stress reduction and dislocation rearrangement', 'Complete melting', 'Formation of a polymer network', 'Conversion of all grains to liquid', 'A', 'Recovery reduces stored energy and residual stresses without requiring full recrystallization.', 'medium', 43),
        ('Defects and Bonding', 'A twin boundary separates regions related by:', 'A mirror-like crystallographic orientation relationship', 'A liquid-solid interface', 'A pore from a crack', 'A matrix from a fiber only', 'A', 'Twin-related crystal regions have a specific mirrored orientation across the twin plane.', 'medium', 44),
        ('Defects and Bonding', 'Which type of defect is a dislocation?', 'Point defect', 'Line defect', 'Planar defect', 'Volume defect', 'B', 'Dislocations are one-dimensional or line defects in a crystal.', 'easy', 45),

        -- Mechanical properties (46-60)
        ('Mechanical Properties', 'Young modulus is the slope of which portion of a uniaxial stress-strain curve?', 'Initial linear elastic portion', 'Necking portion only', 'Fracture surface only', 'Plastic plateau after fracture', 'A', 'Young modulus is the slope of the linear elastic stress-strain region.', 'easy', 46),
        ('Mechanical Properties', 'Engineering stress is calculated using load divided by:', 'Original cross-sectional area', 'Instantaneous neck area only', 'Gauge length', 'Volume', 'A', 'Engineering stress uses the original specimen cross-sectional area.', 'easy', 47),
        ('Mechanical Properties', 'Engineering tensile strain is the change in gauge length divided by:', 'Original gauge length', 'Final cross-sectional area', 'Applied load', 'Young modulus', 'A', 'Engineering strain is elongation divided by the original gauge length.', 'easy', 48),
        ('Mechanical Properties', 'For a ductile metal, yield strength marks the onset of significant:', 'Plastic deformation', 'Thermal expansion only', 'Electrical conduction', 'Diffusionless melting', 'A', 'Yield strength indicates the onset of measurable permanent deformation.', 'easy', 49),
        ('Mechanical Properties', 'The 0.2 percent offset method is commonly used when a material has:', 'No sharply defined yield point', 'No elastic response', 'No measurable strain', 'Only compressive strength', 'A', 'An offset line estimates yield strength for materials without a distinct yield point.', 'medium', 50),
        ('Mechanical Properties', 'Ductility in a tensile test is commonly estimated from:', 'Percent elongation or reduction in area at fracture', 'Electrical resistivity only', 'Density change only', 'Thermal conductivity', 'A', 'Ductility describes plastic deformation before fracture and is commonly reported by elongation or area reduction.', 'easy', 51),
        ('Mechanical Properties', 'Material toughness is related to the area under the stress-strain curve up to:', 'Fracture', 'The first elastic increment only', 'Zero stress before loading', 'The melting point', 'A', 'The total area under the curve to fracture represents energy absorbed per unit volume.', 'medium', 52),
        ('Mechanical Properties', 'Resilience measures energy absorbed within which deformation range?', 'Elastic range', 'Fully molten range', 'Unloaded state only', 'Crack propagation only', 'A', 'Resilience is elastic energy stored and recoverable on unloading.', 'easy', 53),
        ('Mechanical Properties', 'Hardness testing primarily measures resistance to:', 'Localized indentation or penetration', 'Uniform heating', 'Magnetic reversal', 'Chemical dissolution only', 'A', 'Indentation hardness tests assess resistance to localized plastic deformation.', 'easy', 54),
        ('Mechanical Properties', 'Poisson ratio is the negative ratio of:', 'Lateral strain to longitudinal strain', 'Stress to force', 'Load to area', 'Toughness to hardness', 'A', 'Poisson ratio is minus transverse strain divided by axial strain in uniaxial loading.', 'medium', 55),
        ('Mechanical Properties', 'The maximum engineering stress reached in a tensile test is the:', 'Ultimate tensile strength', 'Modulus of resilience', 'Elastic limit only', 'Fatigue threshold', 'A', 'Ultimate tensile strength is the peak engineering stress in a tensile test.', 'easy', 56),
        ('Mechanical Properties', 'Necking in a conventional tensile specimen commonly begins near the:', 'Ultimate tensile strength', 'Zero-load state', 'End of elastic strain only', 'First temperature rise', 'A', 'Diffuse necking typically begins at or near the maximum engineering load.', 'medium', 57),
        ('Mechanical Properties', 'A material described as brittle generally fractures with:', 'Limited plastic deformation', 'Very large uniform elongation', 'No crack formation', 'Infinite toughness', 'A', 'Brittle fracture usually occurs with relatively little preceding plastic deformation.', 'easy', 58),
        ('Mechanical Properties', 'Stiffness of a component depends on material modulus and also on:', 'Geometry and dimensions', 'Color only', 'Chemical symbol only', 'Surface polish only', 'A', 'Component stiffness depends on both elastic modulus and geometry.', 'easy', 59),
        ('Mechanical Properties', 'If elastic modulus is high, the material is generally:', 'More resistant to elastic strain at a given stress', 'More ductile in every condition', 'Always tougher', 'Always harder', 'A', 'A larger modulus produces lower elastic strain for the same uniaxial stress.', 'medium', 60),

        -- Phase diagrams and iron-carbon system (61-75)
        ('Phase Diagrams', 'A eutectic reaction on cooling is represented by:', 'Liquid to two solid phases', 'One solid to two liquids', 'Two solids to one gas', 'One solid to one liquid only', 'A', 'At a eutectic point, liquid transforms into two solid phases at a fixed composition and temperature.', 'medium', 61),
        ('Phase Diagrams', 'A eutectoid reaction is a transformation from:', 'One solid phase to two solid phases', 'Liquid to one solid phase', 'Two liquids to one gas', 'Gas to liquid and solid', 'A', 'A eutectoid reaction converts one solid phase into two different solid phases.', 'medium', 62),
        ('Phase Diagrams', 'Steel with carbon content below the eutectoid composition is called:', 'Hypoeutectoid steel', 'Hypereutectoid steel', 'Eutectic cast iron', 'Austenitic stainless steel', 'A', 'Hypoeutectoid steels contain less carbon than the eutectoid composition.', 'easy', 63),
        ('Phase Diagrams', 'Steel with carbon content above the eutectoid composition is called:', 'Hypoeutectoid steel', 'Hypereutectoid steel', 'Pure ferrite', 'Ductile iron', 'B', 'Hypereutectoid steels contain more carbon than the eutectoid composition.', 'easy', 64),
        ('Phase Diagrams', 'The liquidus line separates the fully liquid region from:', 'Liquid plus solid region', 'Two gas phases', 'A single solid solution only', 'The vacuum region', 'A', 'Above the liquidus the alloy is fully liquid; below it solidification begins.', 'medium', 65),
        ('Phase Diagrams', 'The solidus line marks the boundary below which an alloy is:', 'Completely solid at equilibrium', 'Completely liquid at equilibrium', 'Always gaseous', 'Always amorphous', 'A', 'Below the solidus temperature boundary, the equilibrium alloy is fully solid.', 'medium', 66),
        ('Phase Diagrams', 'A tie line in a two-phase region is used to determine:', 'Equilibrium phase compositions', 'Young modulus directly', 'Grain orientation only', 'Hardness scale', 'A', 'The ends of a tie line give the compositions of coexisting phases.', 'medium', 67),
        ('Phase Diagrams', 'The lever rule is used to estimate:', 'Relative amounts of phases in a two-phase region', 'The number of atoms in a BCC cell', 'Corrosion current density only', 'Fracture toughness', 'A', 'The lever rule calculates phase fractions from tie-line segment lengths.', 'medium', 68),
        ('Phase Diagrams', 'Pearlite is a microconstituent consisting primarily of:', 'Ferrite and cementite', 'Ferrite and graphite only', 'Austenite and liquid', 'Martensite and polymer', 'A', 'Pearlite is a lamellar mixture of ferrite and cementite.', 'easy', 69),
        ('Phase Diagrams', 'Cementite is the iron carbide with approximate formula:', 'FeC', 'Fe2C', 'Fe3C', 'Fe4C', 'C', 'Cementite is Fe3C and contains about 6.67 weight percent carbon.', 'easy', 70),
        ('Phase Diagrams', 'Ferrite in plain carbon steel has which crystal structure?', 'Body-centered cubic', 'Face-centered cubic', 'Hexagonal close-packed', 'Diamond cubic', 'A', 'Alpha ferrite has a BCC crystal structure.', 'easy', 71),
        ('Phase Diagrams', 'Austenite in steel has which crystal structure?', 'Body-centered cubic', 'Face-centered cubic', 'Hexagonal close-packed', 'Simple cubic', 'B', 'Gamma iron, or austenite, has an FCC crystal structure.', 'easy', 72),
        ('Phase Diagrams', 'In the metastable iron-cementite diagram, the eutectoid product forms from:', 'Austenite', 'Liquid iron only', 'Ferrite only', 'Graphite only', 'A', 'At the eutectoid reaction, austenite transforms into ferrite and cementite.', 'medium', 73),
        ('Phase Diagrams', 'A single-phase region in a binary phase diagram contains:', 'One equilibrium phase', 'Exactly two equilibrium phases', 'Only liquid and gas', 'No material', 'A', 'A single-phase field represents one stable phase for the specified conditions.', 'easy', 74),
        ('Phase Diagrams', 'A phase diagram is most directly used to relate equilibrium phases to:', 'Temperature and composition', 'Time and sound pressure only', 'Surface roughness and color', 'Electrical current and voltage only', 'A', 'Binary phase diagrams show stable phases as a function of temperature and composition.', 'easy', 75),

        -- Heat treatment and surface treatment (76-90)
        ('Heat Treatment', 'Full annealing of many steels is followed by cooling:', 'Slowly in the furnace', 'By immediate water quenching only', 'In liquid nitrogen', 'By electrical discharge', 'A', 'Slow furnace cooling promotes a relatively soft microstructure and reduces thermal gradients.', 'easy', 76),
        ('Heat Treatment', 'After austenitizing, normalizing steel usually involves cooling in:', 'Still air', 'A salt bath below zero only', 'The furnace at an extremely slow rate', 'Molten lead', 'A', 'Normalizing commonly cools austenitized steel in still air.', 'easy', 77),
        ('Heat Treatment', 'Rapid quenching of austenitized steel is intended to promote formation of:', 'Martensite', 'Coarse pearlite only', 'Graphite flakes', 'A polymer phase', 'A', 'Sufficiently rapid cooling can transform austenite into hard martensite.', 'easy', 78),
        ('Heat Treatment', 'Martensite forms primarily by which transformation mechanism?', 'Diffusionless shear transformation', 'Slow long-range carbon diffusion only', 'Evaporation', 'Solidification from a liquid', 'A', 'Martensitic transformation is diffusionless and involves coordinated lattice shear.', 'medium', 79),
        ('Heat Treatment', 'Tempering is generally performed after hardening to improve:', 'Toughness and dimensional stability', 'Brittleness only', 'Carbon content of the whole part', 'Melting point', 'A', 'Tempering reduces quench brittleness and residual stress while improving toughness.', 'easy', 80),
        ('Heat Treatment', 'Austempering is designed to produce which steel microstructure?', 'Bainite', 'Graphite', 'Delta ferrite only', 'Liquid austenite', 'A', 'Austempering uses an isothermal transformation route to form bainite.', 'medium', 81),
        ('Heat Treatment', 'Martempering can help reduce distortion by:', 'Reducing temperature gradients before martensitic transformation', 'Increasing carbon to 6.67 percent', 'Keeping the part molten longer', 'Eliminating all phase transformations', 'A', 'Equalizing temperature before transformation reduces thermal gradients and associated distortion.', 'medium', 82),
        ('Heat Treatment', 'Spheroidizing is commonly used to improve the machinability of:', 'High-carbon steels', 'Pure copper only', 'Glass ceramics', 'Elastomers', 'A', 'Spheroidized carbides in a ferrite matrix improve machinability of many high-carbon steels.', 'medium', 83),
        ('Heat Treatment', 'Carburizing enriches the surface of a steel component primarily with:', 'Carbon', 'Nitrogen only', 'Chromium only', 'Aluminum only', 'A', 'Carburizing introduces carbon into the surface of low-carbon steel at elevated temperature.', 'easy', 84),
        ('Heat Treatment', 'Nitriding introduces which element into the steel surface?', 'Nitrogen', 'Sulfur', 'Copper', 'Tin', 'A', 'Nitriding diffuses nitrogen into a steel surface to form hard nitrides.', 'easy', 85),
        ('Heat Treatment', 'Induction hardening heats a surface mainly by:', 'Induced electrical currents from an alternating magnetic field', 'Direct chemical plating only', 'Solar radiation only', 'Manual abrasion', 'A', 'An alternating magnetic field induces currents that rapidly heat conductive surface layers.', 'medium', 86),
        ('Heat Treatment', 'Flame hardening is most suitable for a steel that has:', 'Enough carbon to form a hard surface on quenching', 'No carbon and no hardenable alloy', 'A fully polymeric structure', 'A melting point below room temperature', 'A', 'Flame hardening relies on local austenitizing and quenching of hardenable steel.', 'medium', 87),
        ('Heat Treatment', 'Solution heat treatment of a precipitation-hardening alloy aims to:', 'Dissolve soluble phases into a single solid solution', 'Create graphite flakes', 'Remove all alloying elements', 'Melt only the grain boundaries', 'A', 'Solution treatment dissolves soluble precipitates so a supersaturated solution can be formed on quenching.', 'medium', 88),
        ('Heat Treatment', 'Artificial aging after solution treatment is used to:', 'Form strengthening precipitates at a controlled temperature', 'Remove all solute atoms from the alloy', 'Convert metal to glass', 'Cause complete melting', 'A', 'Aging precipitates strengthen the matrix by impeding dislocation motion.', 'medium', 89),
        ('Heat Treatment', 'Stress-relief heat treatment is primarily used to reduce:', 'Residual stresses', 'Atomic number', 'Part dimensions to zero', 'Electrical charge', 'A', 'Stress relief reduces residual stresses without necessarily changing the alloy composition.', 'easy', 90),

        -- Ferrous alloys and cast irons (91-105)
        ('Ferrous Alloys', 'Mild steel is generally classified as:', 'Low-carbon steel', 'High-carbon steel', 'White cast iron', 'Tool ceramic', 'A', 'Mild steel is a common name for low-carbon steel.', 'easy', 91),
        ('Ferrous Alloys', 'Compared with low-carbon steel, high-carbon steel can generally achieve:', 'Higher hardness after suitable heat treatment', 'No strength at all', 'A lower carbon fraction', 'A polymeric structure', 'A', 'Higher carbon content supports greater hardness and strength after appropriate processing.', 'easy', 92),
        ('Ferrous Alloys', 'Gray cast iron contains graphite primarily in the form of:', 'Flakes', 'Spheroids only', 'A continuous liquid', 'Intermetallic plates of Fe3C only', 'A', 'Gray iron graphite appears as flakes in the matrix.', 'easy', 93),
        ('Ferrous Alloys', 'Ductile cast iron is characterized by graphite in which shape?', 'Spheroidal nodules', 'Long continuous flakes only', 'Austenite needles only', 'Dissolved gas bubbles', 'A', 'Ductile iron contains graphite nodules, commonly produced with magnesium treatment.', 'easy', 94),
        ('Ferrous Alloys', 'White cast iron is hard and brittle mainly because much of its carbon is present as:', 'Cementite', 'Free graphite flakes', 'Copper', 'Aluminum oxide', 'A', 'Rapid solidification and composition can favor cementite rather than graphite.', 'medium', 95),
        ('Ferrous Alloys', 'Malleable cast iron is commonly produced by annealing:', 'White cast iron', 'Pure aluminum', 'Austenitic stainless steel', 'Brass', 'A', 'Malleable iron is produced by heat treating white cast iron to form temper carbon.', 'medium', 96),
        ('Ferrous Alloys', 'Cast iron generally contains more carbon than:', 'Steel', 'Graphite', 'Cementite', 'Carbon fiber', 'A', 'Cast irons typically have higher carbon content than steels.', 'easy', 97),
        ('Ferrous Alloys', 'Which characteristic is a common advantage of gray cast iron in machine bases?', 'Good vibration damping', 'Very high tensile ductility', 'Transparent optical behavior', 'Shape memory at room temperature', 'A', 'Graphite flakes help gray iron damp vibration.', 'easy', 98),
        ('Ferrous Alloys', 'Which cast iron type generally offers better tensile ductility than gray iron?', 'Ductile iron', 'White iron', 'Chilled iron', 'Mottled iron', 'A', 'Nodular graphite produces less severe stress concentration than flakes.', 'easy', 99),
        ('Ferrous Alloys', 'Which alloy family is selected when elevated-temperature oxidation resistance is important?', 'Heat-resistant steels', 'Unalloyed gray iron only', 'Pure lead', 'Low-density foams only', 'A', 'Heat-resistant steels are designed to retain useful properties at elevated temperatures.', 'medium', 100),
        ('Ferrous Alloys', 'In stainless steel, chromium content supports corrosion resistance by promoting:', 'A passive oxide film', 'A graphite network', 'A lubricating oil layer', 'A liquid salt film', 'A', 'Chromium enables formation of an adherent passive chromium-rich oxide.', 'easy', 101),
        ('Ferrous Alloys', 'Austenitic stainless steels are commonly strengthened substantially by:', 'Cold working', 'Quenching to ordinary carbon-steel martensite only', 'Adding graphite flakes', 'Furnace cooling from a liquid', 'A', 'Austenitic stainless steels are commonly strengthened by cold work.', 'medium', 102),
        ('Ferrous Alloys', 'Which alloy addition is commonly used to improve hardenability in steel?', 'Molybdenum', 'Sodium chloride', 'Lead glass', 'Sulfuric acid', 'A', 'Molybdenum is a common hardenability-enhancing alloy addition.', 'medium', 103),
        ('Ferrous Alloys', 'In high-speed tool steels, tungsten or molybdenum primarily helps maintain:', 'Hot hardness', 'Electrical insulation', 'Low melting point', 'High optical transparency', 'A', 'Strong alloy carbides support hot hardness during cutting.', 'medium', 104),
        ('Ferrous Alloys', 'Hadfield steel is notable for high manganese content and strong:', 'Work hardening under impact or abrasion', 'Brittleness without deformation', 'Electrical conductivity', 'Thermal expansion suppression', 'A', 'High-manganese Hadfield steel work hardens strongly under impact and abrasion.', 'medium', 105),

        -- Non-ferrous alloys (106-120)
        ('Non-Ferrous Alloys', 'Brass is primarily an alloy of:', 'Copper and zinc', 'Copper and tin', 'Nickel and chromium', 'Iron and carbon', 'A', 'Brass is principally a copper-zinc alloy.', 'easy', 106),
        ('Non-Ferrous Alloys', 'Traditional bronze is primarily an alloy of:', 'Copper and tin', 'Copper and zinc', 'Iron and nickel', 'Aluminum and magnesium', 'A', 'Bronze is commonly copper-tin, though other bronze compositions exist.', 'easy', 107),
        ('Non-Ferrous Alloys', 'Duralumin is based primarily on:', 'Aluminum', 'Magnesium', 'Nickel', 'Titanium', 'A', 'Duralumin is an aluminum alloy strengthened with additions including copper.', 'easy', 108),
        ('Non-Ferrous Alloys', 'Magnalium is an alloy based mainly on aluminum and:', 'Magnesium', 'Lead', 'Tin', 'Cobalt', 'A', 'Magnalium is an aluminum-magnesium alloy.', 'easy', 109),
        ('Non-Ferrous Alloys', 'Monel alloys are based mainly on:', 'Nickel and copper', 'Aluminum and silicon', 'Iron and carbon', 'Copper and tin', 'A', 'Monel is a nickel-copper alloy family.', 'easy', 110),
        ('Non-Ferrous Alloys', 'Nichrome is commonly used in heating elements because it has:', 'High electrical resistivity and oxidation resistance', 'Zero electrical resistance at room temperature', 'Very low melting temperature', 'High solubility in water', 'A', 'Nickel-chromium alloys have useful electrical resistance and oxidation behavior at elevated temperature.', 'easy', 111),
        ('Non-Ferrous Alloys', 'Invar is selected for precision components primarily because it has:', 'Low thermal expansion', 'Very high density only', 'High carbon content', 'A porous structure', 'A', 'Invar is known for a low coefficient of thermal expansion over a useful temperature range.', 'easy', 112),
        ('Non-Ferrous Alloys', 'Beryllium copper is used for springs and electrical contacts because it can combine conductivity with:', 'High strength after age hardening', 'Very low melting point', 'High brittleness only', 'Complete electrical insulation', 'A', 'Age-hardened beryllium copper combines useful conductivity with high strength.', 'medium', 113),
        ('Non-Ferrous Alloys', 'Which characteristic makes titanium alloys attractive for aircraft structures?', 'High specific strength', 'Very low strength-to-weight ratio', 'Poor corrosion resistance in all environments', 'Very low melting point', 'A', 'Titanium alloys offer high strength relative to density and good corrosion resistance.', 'easy', 114),
        ('Non-Ferrous Alloys', 'Aluminum has which common crystal structure at room temperature?', 'FCC', 'BCC', 'HCP', 'Simple cubic', 'A', 'Aluminum has a face-centered cubic crystal structure.', 'easy', 115),
        ('Non-Ferrous Alloys', 'Magnesium has which common crystal structure at room temperature?', 'HCP', 'FCC', 'BCC', 'Diamond cubic', 'A', 'Magnesium is hexagonal close-packed at room temperature.', 'easy', 116),
        ('Non-Ferrous Alloys', 'Age hardening strengthens an alloy mainly through:', 'Fine precipitates that impede dislocations', 'Removal of all grain boundaries', 'Formation of macroscopic pores', 'Complete recrystallization only', 'A', 'Fine precipitates obstruct dislocation motion and increase strength.', 'medium', 117),
        ('Non-Ferrous Alloys', 'Which copper alloy is commonly selected for good electrical conductivity?', 'High-purity copper', 'Brass with high zinc content', 'White cast iron', 'High-speed steel', 'A', 'High-purity copper has excellent electrical conductivity.', 'easy', 118),
        ('Non-Ferrous Alloys', 'Which property is a common advantage of aluminum alloys over steels?', 'Lower density', 'Higher density', 'Higher elastic modulus in every grade', 'No thermal expansion', 'A', 'Aluminum alloys have lower density than steels, benefiting weight-sensitive designs.', 'easy', 119),
        ('Non-Ferrous Alloys', 'Which alloying element is important to precipitation strengthening in many aluminum alloys?', 'Copper', 'Sulfur', 'Lead glass', 'Sodium chloride', 'A', 'Copper is a key strengthening addition in several age-hardenable aluminum alloy families.', 'medium', 120),

        -- Corrosion and protection (121-135)
        ('Corrosion', 'At an anodic site during electrochemical corrosion, the metal generally:', 'Oxidizes and releases electrons', 'Consumes electrons by reduction', 'Becomes a polymer', 'Cannot react', 'A', 'Anodic metal dissolution is an oxidation reaction that releases electrons.', 'easy', 121),
        ('Corrosion', 'At a cathodic site in an aqueous corrosion cell, which process occurs?', 'Reduction', 'Metal oxidation only', 'Melting', 'Sublimation', 'A', 'The cathodic reaction consumes electrons through reduction.', 'easy', 122),
        ('Corrosion', 'Galvanic corrosion requires electrical contact between dissimilar metals and:', 'An electrolyte', 'A vacuum only', 'A polymer mold', 'A magnetic field only', 'A', 'A galvanic cell requires an electronic path and an ionic path through an electrolyte.', 'easy', 123),
        ('Corrosion', 'In a galvanic couple, the more active metal generally acts as the:', 'Anode', 'Cathode', 'Insulator', 'Reference electrode only', 'A', 'The more active member tends to oxidize and corrode as the anode.', 'medium', 124),
        ('Corrosion', 'Pitting corrosion is best described as:', 'Localized attack forming small cavities', 'Uniform thinning over the entire surface', 'A reversible elastic strain', 'A bulk phase transformation', 'A', 'Pitting creates localized cavities after passive-film breakdown.', 'easy', 125),
        ('Corrosion', 'Crevice corrosion is often promoted by:', 'Restricted electrolyte exchange in a narrow gap', 'A perfectly dry clean surface', 'Uniform open-air flow only', 'Low mechanical stress only', 'A', 'Stagnant solution in crevices can create local chemistry differences that accelerate attack.', 'medium', 126),
        ('Corrosion', 'A passive film protects a metal when it is:', 'Thin, adherent, and able to limit further reaction', 'Thick, porous, and continuously detached', 'Completely absent', 'A liquid layer of molten metal', 'A', 'A stable passive film slows further electrochemical dissolution.', 'easy', 127),
        ('Corrosion', 'Sacrificial-anode protection works by electrically connecting the structure to a metal that is:', 'More active and preferentially corrodes', 'More noble and never oxidizes', 'A perfect insulator', 'A ceramic coating', 'A', 'The more active sacrificial anode oxidizes in preference to the protected structure.', 'easy', 128),
        ('Corrosion', 'Impressed-current cathodic protection uses:', 'An external DC power source', 'Only a paint pigment', 'A mechanical spring', 'A thermal barrier alone', 'A', 'An external DC source supplies current to keep the protected structure cathodic.', 'medium', 129),
        ('Corrosion', 'Stress-corrosion cracking generally requires tensile stress and:', 'A specific corrosive environment', 'Pure vacuum only', 'Zero temperature only', 'No material defects of any kind', 'A', 'SCC results from the combined action of tensile stress and a susceptible environment.', 'medium', 130),
        ('Corrosion', 'Intergranular corrosion preferentially attacks:', 'Grain-boundary regions', 'The center of every grain uniformly', 'Only polymer fibers', 'The bulk liquid phase', 'A', 'Intergranular corrosion proceeds preferentially along grain boundaries.', 'easy', 131),
        ('Corrosion', 'Erosion-corrosion is accelerated by:', 'A moving corrosive fluid that removes protective films', 'A static dry atmosphere only', 'A sealed vacuum', 'Low flow with no chemistry', 'A', 'Fluid motion can remove films and expose fresh metal to corrosive attack.', 'medium', 132),
        ('Corrosion', 'Which is a common method of reducing atmospheric corrosion of steel?', 'Applying a suitable protective coating', 'Increasing crevice area', 'Removing all alloying control', 'Connecting steel to a more active metal without design', 'A', 'Coatings separate steel from moisture and aggressive species when properly applied and maintained.', 'easy', 133),
        ('Corrosion', 'A corrosion inhibitor is added to an environment to:', 'Reduce the corrosion reaction rate', 'Increase metal dissolution intentionally', 'Raise the metal carbon content', 'Change the crystal structure to FCC', 'A', 'Inhibitors slow corrosion through adsorption or changes to electrochemical reactions.', 'easy', 134),
        ('Corrosion', 'A corrosion rate from mass-loss testing is commonly normalized by exposed area and:', 'Exposure time', 'Elastic modulus', 'Grain orientation only', 'Impact energy', 'A', 'Mass-loss corrosion rates are commonly expressed per area per unit time.', 'medium', 135),

        -- Fatigue, fracture, and creep (136-150)
        ('Failure and Fracture', 'Fatigue damage develops under:', 'Repeated or fluctuating loading', 'A single unloaded state', 'Uniform temperature with no stress', 'Static pressure only in every case', 'A', 'Fatigue is progressive damage caused by cyclic or fluctuating stress.', 'easy', 136),
        ('Failure and Fracture', 'A fatigue crack often initiates at a surface because the surface can contain:', 'Stress concentrations and defects', 'No atoms', 'Only liquid phases', 'Perfectly uniform zero stress', 'A', 'Surface scratches, notches, and inclusions can raise local cyclic stress.', 'medium', 137),
        ('Failure and Fracture', 'An S-N curve plots cyclic stress amplitude against:', 'Number of cycles to failure', 'Grain size only', 'Temperature coefficient only', 'Electrical current', 'A', 'S-N curves relate stress amplitude to cycles endured before fatigue failure.', 'easy', 138),
        ('Failure and Fracture', 'A notch generally reduces fatigue life because it:', 'Raises local stress concentration', 'Eliminates cyclic stress', 'Increases the load-bearing area without limit', 'Stops crack initiation in every alloy', 'A', 'A notch amplifies local stress and can become a fatigue-crack initiation site.', 'easy', 139),
        ('Failure and Fracture', 'The endurance limit is a stress amplitude below which some materials can survive:', 'A very large number of cycles under specified conditions', 'Only one cycle', 'No load at all', 'Only a tensile impact', 'A', 'Some materials, especially certain steels, show an approximate endurance limit under defined test conditions.', 'medium', 140),
        ('Failure and Fracture', 'Creep is most significant when a component experiences sustained stress at:', 'Elevated temperature over time', 'Room temperature for one instant only', 'Zero stress', 'A single impact only', 'A', 'Creep is time-dependent deformation and is accelerated at elevated homologous temperature.', 'easy', 141),
        ('Failure and Fracture', 'The secondary stage of a typical creep curve has approximately:', 'A steady creep rate', 'A zero strain rate in all materials', 'Instantaneous fracture at the start', 'A decreasing temperature by definition', 'A', 'Secondary creep is characterized by a roughly constant strain rate.', 'medium', 142),
        ('Failure and Fracture', 'Tertiary creep is characterized by:', 'An accelerating creep rate before rupture', 'A constant zero strain', 'Only elastic recovery', 'A phase diagram tie line', 'A', 'Necking, damage, and increasing strain rate lead to tertiary creep rupture.', 'medium', 143),
        ('Failure and Fracture', 'Fracture toughness describes resistance to:', 'Crack extension under a specified loading mode', 'Uniform thermal expansion', 'Indentation only', 'Electrical oxidation only', 'A', 'Fracture toughness quantifies resistance to crack propagation under defined conditions.', 'medium', 144),
        ('Failure and Fracture', 'A ductile fracture surface commonly shows which microscopic feature?', 'Dimples from microvoid coalescence', 'Only perfectly flat cleavage facets', 'A polished grain-free plane', 'A ceramic glaze', 'A', 'Ductile overload commonly produces dimples as microvoids grow and coalesce.', 'medium', 145),
        ('Failure and Fracture', 'Cleavage fracture is commonly associated with:', 'Limited plastic deformation and relatively flat facets', 'Very large uniform elongation', 'A viscous liquid flow', 'A polymer melt only', 'A', 'Cleavage is a brittle fracture mode with limited plastic deformation.', 'medium', 146),
        ('Failure and Fracture', 'The ductile-to-brittle transition is especially important for some:', 'BCC steels at low temperature', 'FCC copper at all temperatures', 'Elastomers above glass transition only', 'Glasses in liquid form', 'A', 'Many BCC steels show a temperature-dependent transition from ductile to brittle impact behavior.', 'medium', 147),
        ('Failure and Fracture', 'Shot peening can improve fatigue resistance by introducing:', 'Compressive residual stress near the surface', 'Tensile residual stress at every surface point', 'A liquid coating', 'A larger notch radius only', 'A', 'Surface compression opposes tensile crack opening and can delay fatigue initiation.', 'medium', 148),
        ('Failure and Fracture', 'Cumulative fatigue damage in a simple Miner rule is estimated by summing:', 'Fractions of life used at each stress level', 'Elastic moduli', 'Grain boundary angles', 'Corrosion potentials only', 'A', 'Miner linear damage sums cycle counts divided by life at each stress level.', 'medium', 149),
        ('Failure and Fracture', 'A brittle fracture can occur below yield stress when a component contains:', 'A sufficiently severe crack or flaw', 'No stress raiser and no load', 'Only a soft polymer phase', 'A perfectly uniform temperature', 'A', 'A crack can amplify local stress and cause unstable fracture before nominal yielding.', 'medium', 150),

        -- Testing and characterization (151-165)
        ('Testing and Characterization', 'Rockwell hardness is primarily determined from:', 'Indentation depth under specified loads', 'Mass loss after corrosion', 'Pendulum rebound only', 'Electrical resistance', 'A', 'Rockwell hardness measures residual indentation depth under specified minor and major loads.', 'easy', 151),
        ('Testing and Characterization', 'The Brinell hardness test uses a:', 'Hard spherical indenter', 'Sharp diamond cone only', 'Notched pendulum', 'Ultrasonic transducer', 'A', 'Brinell testing uses a spherical indenter and measures the resulting impression.', 'easy', 152),
        ('Testing and Characterization', 'The Vickers hardness test uses an indenter shaped as a:', 'Diamond square-based pyramid', 'Steel ball only', 'Cylindrical roller', 'Notched bar', 'A', 'The Vickers indenter is a square-based diamond pyramid.', 'easy', 153),
        ('Testing and Characterization', 'A tensile test most directly provides:', 'Stress-strain behavior under uniaxial loading', 'A phase diagram at equilibrium', 'Corrosion rate in saltwater', 'Crystal structure from diffraction', 'A', 'A tensile test measures load and extension to obtain engineering stress-strain behavior.', 'easy', 154),
        ('Testing and Characterization', 'A Charpy test evaluates impact behavior using a specimen that is usually:', 'Notched', 'Unloaded and unnotched only', 'Fully molten', 'Transparent', 'A', 'The Charpy impact specimen contains a notch to create a controlled stress concentration.', 'easy', 155),
        ('Testing and Characterization', 'Liquid penetrant inspection is suitable for finding:', 'Surface-breaking discontinuities in nonporous materials', 'Deep internal flaws in any thick component', 'Only magnetic domains', 'Grain size without preparation', 'A', 'Penetrant enters surface-connected flaws and reveals them after developer application.', 'easy', 156),
        ('Testing and Characterization', 'Magnetic-particle inspection is limited primarily to:', 'Ferromagnetic materials', 'All transparent polymers', 'Pure ceramics only', 'Every nonmagnetic alloy', 'A', 'The method relies on magnetic flux leakage and is used on ferromagnetic materials.', 'easy', 157),
        ('Testing and Characterization', 'Ultrasonic inspection detects flaws by analyzing:', 'Reflected high-frequency sound waves', 'Visible-light color only', 'Mass loss in acid', 'Magnetic permeability only', 'A', 'Ultrasonic testing interprets sound-wave reflections from interfaces and discontinuities.', 'easy', 158),
        ('Testing and Characterization', 'Radiographic testing reveals internal discontinuities through differences in:', 'Radiation attenuation', 'Surface hardness only', 'Grain boundary color only', 'Electrical resistance only', 'A', 'Internal density or thickness changes alter the transmitted radiation intensity.', 'medium', 159),
        ('Testing and Characterization', 'Before optical metallography, a specimen surface is commonly ground, polished, and then:', 'Etched', 'Quenched in oil without cleaning', 'Coated with thick paint', 'Fractured in tension', 'A', 'Etching creates contrast between phases and grain boundaries after polishing.', 'easy', 160),
        ('Testing and Characterization', 'Scanning electron microscopy forms images primarily by detecting signals from:', 'An electron beam interacting with the specimen', 'A sound beam in water', 'A pendulum strike', 'A chemical titration', 'A', 'SEM scans an electron beam and detects emitted or backscattered signals.', 'medium', 161),
        ('Testing and Characterization', 'Transmission electron microscopy generally requires specimens that are:', 'Very thin to transmit electrons', 'Several centimeters thick', 'Opaque only to visible light', 'Fully liquid', 'A', 'TEM electrons must pass through a sufficiently thin specimen.', 'easy', 162),
        ('Testing and Characterization', 'X-ray diffraction is useful for identifying:', 'Crystalline phases and lattice spacings', 'Impact energy only', 'Surface roughness only', 'Tensile elongation only', 'A', 'Diffraction peak positions and intensities relate to crystal structure and phases.', 'easy', 163),
        ('Testing and Characterization', 'A metallographic grain-size number generally increases as the grains become:', 'Finer', 'Coarser', 'Fully molten', 'More porous only', 'A', 'Higher ASTM grain-size numbers correspond to a greater number of finer grains per area.', 'medium', 164),
        ('Testing and Characterization', 'A calibration standard is used in testing to:', 'Check measurement accuracy against a known reference', 'Increase specimen carbon content', 'Create fatigue cracks', 'Replace all uncertainty analysis', 'A', 'Calibration compares an instrument response with a known reference value.', 'easy', 165),

        -- Polymers, ceramics, and composites (166-180)
        ('Polymers and Composites', 'A thermoplastic polymer can generally be:', 'Softened and reshaped by heating', 'Remelted only by chemical decomposition', 'Used only below absolute zero', 'Converted into a metal by quenching', 'A', 'Thermoplastics soften on heating and can often be reshaped repeatedly.', 'easy', 166),
        ('Polymers and Composites', 'A thermosetting polymer is characterized by:', 'A cross-linked network that does not melt and flow on reheating', 'Linear chains that always dissolve in water', 'Metallic bonding', 'A BCC crystal lattice', 'A', 'Curing forms a cross-linked network; reheating generally causes degradation rather than remelting.', 'easy', 167),
        ('Polymers and Composites', 'An elastomer can sustain large reversible deformation mainly because of:', 'Flexible polymer chains and network structure', 'A dense FCC metal lattice', 'Graphite flakes', 'High ceramic porosity', 'A', 'Flexible chains between cross-links can uncoil and recover when the load is removed.', 'medium', 168),
        ('Polymers and Composites', 'The glass-transition temperature marks a change between glassy and:', 'Rubbery response in an amorphous polymer', 'Liquid iron and ferrite', 'BCC and HCP metal structures', 'Corroded and passivated states', 'A', 'Above Tg, amorphous polymer segments gain mobility and the response becomes more rubbery.', 'easy', 169),
        ('Polymers and Composites', 'Many engineering ceramics have high compressive strength but low tensile strength because:', 'Flaws can open and grow under tensile loading', 'They contain no atomic bonds', 'They are always porous liquids', 'Their grains cannot carry compression', 'A', 'Tensile stress opens flaws in brittle ceramics, while compression tends to close them.', 'medium', 170),
        ('Polymers and Composites', 'Sintering of ceramic or metal powder compacts primarily involves:', 'Diffusion-driven bonding between particles below the melting point', 'Complete vaporization of the compact', 'Electroplating every particle', 'Room-temperature elastic recovery only', 'A', 'Sintering bonds powder particles through diffusion and reduces porosity, usually without full melting.', 'medium', 171),
        ('Polymers and Composites', 'In a fiber-reinforced composite, the matrix primarily:', 'Transfers load between fibers and protects them', 'Provides all stiffness in every direction', 'Eliminates the need for fibers', 'Acts as a void', 'A', 'The matrix binds the reinforcement, transfers load, and protects fibers from the environment.', 'easy', 172),
        ('Polymers and Composites', 'A unidirectional fiber composite is usually strongest along the:', 'Fiber direction', 'Through-thickness direction in every case', 'Direction normal to all fibers', 'Direction of gravity only', 'A', 'Continuous fibers carry load most effectively along their length.', 'easy', 173),
        ('Polymers and Composites', 'A laminate made from oriented plies can have direction-dependent properties. This is called:', 'Anisotropy', 'Isotropy', 'Passivation', 'Eutecticity', 'A', 'Ply orientation makes many composites anisotropic.', 'easy', 174),
        ('Polymers and Composites', 'Adding short fibers to a polymer usually aims to improve:', 'Stiffness or strength', 'Transparency in every case', 'Solubility in water', 'The polymer melting point to infinity', 'A', 'Fibers reinforce the matrix and can increase stiffness and strength.', 'easy', 175),
        ('Polymers and Composites', 'Voids in a fiber composite are generally undesirable because they can:', 'Reduce strength and provide crack-initiation sites', 'Increase matrix-fiber bonding without limit', 'Eliminate anisotropy', 'Act as continuous reinforcement', 'A', 'Porosity can reduce load transfer and act as stress concentrators.', 'medium', 176),
        ('Polymers and Composites', 'Alumina is commonly used in engineering applications because it has:', 'High hardness and wear resistance', 'Very high ductility at room temperature', 'A low melting temperature like wax', 'High electrical conductivity like copper', 'A', 'Alumina is a hard, wear-resistant ceramic with useful thermal and electrical properties.', 'easy', 177),
        ('Polymers and Composites', 'Silicon carbide is valued in abrasive and high-temperature uses for its:', 'Hardness and high-temperature capability', 'Low hardness and low melting point', 'High ductility in tension', 'Solubility in water', 'A', 'Silicon carbide is a hard ceramic with good high-temperature performance.', 'easy', 178),
        ('Polymers and Composites', 'A glass is generally described as:', 'Amorphous, lacking long-range crystalline order', 'A perfect FCC crystal', 'A metallic solid solution', 'A single giant grain of ferrite', 'A', 'Common glasses are amorphous materials without long-range periodic order.', 'easy', 179),
        ('Polymers and Composites', 'A ceramic-matrix composite can improve fracture resistance by using fibers to:', 'Bridge and deflect cracks', 'Remove all grain boundaries', 'Increase brittleness intentionally', 'Melt the matrix during service', 'A', 'Fiber bridging and crack deflection can increase damage tolerance.', 'medium', 180),

        -- Manufacturing, joining, and material selection (181-200)
        ('Manufacturing and Selection', 'Powder metallurgy commonly combines powder compaction with:', 'Sintering', 'Electrolytic refining only', 'Quenching a liquid polymer', 'Shot peening only', 'A', 'Powder metallurgy compacts powder and then sinters it to bond particles.', 'easy', 181),
        ('Manufacturing and Selection', 'Forging shapes metal primarily through:', 'Plastic deformation under compressive forces', 'Selective chemical dissolution only', 'Radiation attenuation', 'Polymerization', 'A', 'Forging uses compressive forces to plastically shape metal.', 'easy', 182),
        ('Manufacturing and Selection', 'Rolling reduces or changes the cross section by passing material between:', 'Rotating rolls', 'A notched pendulum', 'A furnace atmosphere only', 'A diffraction grating', 'A', 'Rolling plastically deforms stock between rotating rolls.', 'easy', 183),
        ('Manufacturing and Selection', 'Extrusion forces a billet through a die to produce:', 'A long product with a die-defined cross section', 'A single spherical casting only', 'A polished metallographic mount', 'A corrosion pit', 'A', 'Extrusion creates long products with a cross section matching the die opening.', 'easy', 184),
        ('Manufacturing and Selection', 'In sand casting, the mold cavity is filled with:', 'Molten material that solidifies to shape', 'Cold powder compact only', 'A polymer solution only', 'A tensile specimen under load', 'A', 'Casting pours molten material into a mold and allows it to solidify.', 'easy', 185),
        ('Manufacturing and Selection', 'The heat-affected zone in a weld is the region that:', 'Was not melted but experienced a thermal cycle', 'Was removed as machining chips', 'Remained at ambient temperature throughout', 'Is always the filler metal only', 'A', 'The HAZ is adjacent to the weld and changes microstructure due to heat without melting.', 'medium', 186),
        ('Manufacturing and Selection', 'Additive manufacturing builds a part primarily by:', 'Adding material in successive layers', 'Removing all material from a billet', 'Casting in a permanent mold only', 'Cold rolling a sheet only', 'A', 'Additive manufacturing forms parts by depositing or consolidating material layer by layer.', 'easy', 187),
        ('Manufacturing and Selection', 'A material selection chart can compare strength against density to evaluate:', 'Specific strength', 'Corrosion current only', 'Grain boundary angle', 'Hardness scale conversion', 'A', 'Specific strength is strength divided by density and is useful in weight-sensitive design.', 'medium', 188),
        ('Manufacturing and Selection', 'For a weight-limited elastic structure, which ratio is often useful for material screening?', 'Elastic modulus divided by density', 'Density divided by melting point', 'Hardness multiplied by color', 'Poisson ratio divided by corrosion rate', 'A', 'Specific stiffness is commonly represented by elastic modulus divided by density.', 'medium', 189),
        ('Manufacturing and Selection', 'A material for a rotating shaft should be screened for fatigue strength because the shaft often experiences:', 'Cyclic bending or torsional stress', 'No stress during operation', 'Only static hydrostatic pressure', 'A constant liquid phase', 'A', 'Rotating shafts commonly see cyclic stresses that can cause fatigue.', 'easy', 190),
        ('Manufacturing and Selection', 'When two joined materials have very different thermal-expansion coefficients, temperature changes can cause:', 'Thermal mismatch stresses', 'A guaranteed reduction in stress to zero', 'The same strain in all cases', 'No dimensional change', 'A', 'Different free thermal strains are constrained at the joint and create mismatch stresses.', 'medium', 191),
        ('Manufacturing and Selection', 'A corrosion-resistant material should be selected with attention to:', 'The service environment and possible galvanic couples', 'Color alone', 'Density alone', 'The manufacturing drawing number only', 'A', 'Corrosion depends on environment, electrochemical compatibility, and service conditions.', 'easy', 192),
        ('Manufacturing and Selection', 'Which factor is essential when selecting a material for a high-temperature component?', 'Creep resistance at service temperature', 'Room-temperature color only', 'Magnetic permeability only', 'Surface polish only', 'A', 'Long-term elevated-temperature loading requires consideration of creep behavior.', 'easy', 193),
        ('Manufacturing and Selection', 'A design requiring a tough component under impact should avoid choosing solely on the basis of:', 'Hardness', 'Fracture toughness', 'Impact energy', 'Service-temperature ductility', 'A', 'Hardness alone does not establish impact toughness or resistance to fracture.', 'medium', 194),
        ('Manufacturing and Selection', 'A common purpose of a diffusion barrier coating is to:', 'Limit interdiffusion between adjoining materials', 'Increase crack growth deliberately', 'Reduce every material to a powder', 'Create a liquid phase at room temperature', 'A', 'Diffusion barriers slow transport of atoms across interfaces.', 'medium', 195),
        ('Manufacturing and Selection', 'A shape-memory alloy can recover a trained shape after a suitable thermal cycle because of:', 'A reversible martensitic transformation', 'A permanent melting event', 'Graphite flake growth', 'Uniform corrosion', 'A', 'Shape-memory behavior is associated with reversible martensitic transformations.', 'medium', 196),
        ('Manufacturing and Selection', 'A piezoelectric material can generate an electrical response when:', 'Mechanically stressed', 'Placed in a vacuum without stress', 'Its grain boundaries are removed', 'It is immersed in oil only', 'A', 'Piezoelectric materials couple mechanical stress and electrical polarization.', 'easy', 197),
        ('Manufacturing and Selection', 'Which design approach can reduce material waste in a component?', 'Use geometry and process planning suited to near-net-shape manufacturing', 'Add unnecessary machining stock', 'Specify the heaviest alloy available', 'Ignore manufacturing tolerances', 'A', 'Near-net-shape processes and good design reduce material removed as scrap.', 'easy', 198),
        ('Manufacturing and Selection', 'A life-cycle material assessment considers impacts across:', 'Material extraction, processing, use, and end of life', 'Only the purchase price', 'Only the color during use', 'Only the initial tensile test', 'A', 'Life-cycle assessment evaluates impacts across multiple stages from extraction to disposal or recycling.', 'easy', 199),
        ('Manufacturing and Selection', 'The most suitable engineering material is generally selected by balancing:', 'Performance, environment, manufacturing, cost, and safety', 'Hardness alone', 'Density alone', 'Availability alone', 'A', 'Material selection is a multi-constraint decision involving service, processing, cost, and safety.', 'easy', 200)
    ) AS seed(topic_title, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, difficulty, display_order)
    LEFT JOIN LATERAL (
        SELECT t.id
        FROM public.topics t
        WHERE t.subject_id = v_subject_id
          AND lower(t.title) = lower(seed.topic_title)
        ORDER BY t.display_order, t.id
        LIMIT 1
    ) AS topic ON TRUE
    WHERE NOT EXISTS (
        SELECT 1
        FROM public.practice_questions existing
        WHERE existing.subject_id = v_subject_id
          AND existing.question_text = seed.question_text
    );
END;
$seed$;