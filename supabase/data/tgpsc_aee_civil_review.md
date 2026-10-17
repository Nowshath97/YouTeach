# TGPSC AEE Civil Exam: source and answer review

Unofficial practice version based on the uploaded TSPSC AEE Civil Paper II, 22 January 2023 (paper code 22122). 150 questions: 108 transcribed with notation/wording normalization and 42 explicitly labeled concept adaptations or corrections. Answers are independently derived, not an official answer key. Practice scoring: +2 correct, 0 wrong or unanswered; 150-minute duration. The 150-mark practice benchmark is not an official qualifying cutoff.

## Source and use

- Local source: `MockTests/tspsc civil aee.pdf`, 22 pages. Questions occupy physical PDF pages 3-22; printed page numbers differ.
- Order and question numbers correspond to the uploaded booklet, not an internet master-booklet answer key.
- Transcribed means original question content and option order retained, with spelling, notation, layout and light wording normalization. It does not mean a facsimile.
- Adapted means a clarified assumption, corrected choice, text replacement for a diagram, or a similar concept question. These are labeled in the candidate interface.
- No handwritten ticks were treated as authority. All keys below are unofficial derived practice answers.
- This is a preparation exercise, not a declaration of current recruitment rules or official cutoffs.
- Run `supabase/tgpsc_aee_civil_mock_seed.sql` in Supabase SQL Editor after `supabase/mock_test_setup.sql` and `supabase/mock_simulation_functions.sql`. No credentials or live database were used to create it.
- Regenerate with `python scripts/build_tgpsc_aee_civil_seed.py` after editing the JSON source. The JSON and this document contain keys and must not be served as browser assets.

## Supporting references checked

- IIT Madras / NPTEL: design bond stresses reproduced from IS 456:2000: https://archive.nptel.ac.in/content/storage2/courses/105106117/pdf/7_Transmission_of_Prestress/Section7.1.pdf
- Government engineering tender: assumed concrete strength deviations: https://kmda.wb.gov.in/upload_file/tender/51_SE_C-III_RB_KMDA.pdf
- NPTEL: Muskingum routing: https://archive.nptel.ac.in/content/storage2/courses/105101002/modules/module5/lec3/1.7.html

## Adaptation index

Q2, Q5, Q8, Q10, Q18, Q19, Q25, Q30, Q32, Q39, Q42, Q49, Q52, Q63, Q66, Q73, Q76, Q80, Q82, Q84, Q85, Q88, Q90, Q95, Q101, Q102, Q111, Q112, Q117, Q120, Q122, Q124, Q125, Q127, Q129, Q135, Q141, Q142, Q143, Q146, Q148, Q150

## Answer reasoning

### Q1 - B (transcribed; PDF page 3)

Free-flow speed is approached at negligible density; maximum flow occurs at a lower speed.

### Q2 - C (adapted; PDF page 3)

Slope-deflection gives an end-moment magnitude of 6EI delta/L² at each end. Direction in the scan is replaced by an unambiguous magnitude question.

### Q3 - D (transcribed; PDF page 3)

Darcy flow in sand is conventionally taken as laminar for a grain-based Reynolds number below approximately one.

### Q4 - D (transcribed; PDF page 3)

Wedging separates stratified stone with less damage than blasting.

### Q5 - C (adapted; PDF page 3)

Direct prestress and downward eccentricity compress the bottom; sagging live-load bending tensions it. The source matching question is replaced by its stress-superposition relation.

### Q6 - B (transcribed; PDF page 3)

A Froude number between about 4.5 and 9 produces a steady or stable jump.

### Q7 - A (transcribed; PDF page 3)

Salvage value is the estimated remaining value without dismantling; scrap value refers to dismantled materials.

### Q8 - B (adapted; PDF page 4)

There are three potentially nonzero independent in-plane components and two potentially nonzero principal stresses; the out-of-plane principal stress is zero. The phrase nonzero is added to avoid counting the zero third principal stress.

### Q9 - C (transcribed; PDF page 4)

Using design steel stress 0.87fy and deformed-bar bond stress 1.2 x 1.6 = 1.92 N/mm², Ld = 12 x 0.87 x 415/(4 x 1.92) = 564 mm approximately.

### Q10 - C (adapted; PDF page 4)

Current gravimetric water content = 14/136 = 0.10294. Required water depth = (0.20 - 0.10294) x 1.6 x 900 = 139.8 mm. The source density wording is clarified.

### Q11 - A (transcribed; PDF page 4)

Le-Chatelier expansion primarily detects unsoundness due to free lime; the autoclave test also detects magnesia effects.

### Q12 - C (transcribed; PDF page 4)

ic = (Gs - 1)(1 - n) = 1.64 x 0.55 = 0.902, closest to 0.901.

### Q13 - B (transcribed; PDF page 4)

For constant EI, moment is proportional to y'', shear to y''', loading to y'''', and slope is y'. Signs depend on convention.

### Q14 - A (transcribed; PDF page 4)

Darcy velocity equals porosity times seepage velocity: 0.40 x 0.30 = 0.12 m/s.

### Q15 - B (transcribed; PDF page 5)

ax = u du/dx + v du/dy = 6 x 4 + (-8) x 4 = -8.

### Q16 - D (transcribed; PDF page 5)

Granite is used in bridges, limestone in cement, marble for ornamental work, and slate for flooring.

### Q17 - A (transcribed; PDF page 5)

PHF = 1200/(12 x 150) = 0.6667.

### Q18 - A (adapted; PDF page 5)

Under Froude similarity, Q scales with L^(5/2), taking k as the model-to-prototype length ratio as in the printed choices.

### Q19 - A (adapted; PDF page 5)

Reciprocal flexibility coefficients are equal: delta_AB = delta_BA. Equal unit loads and corresponding directions are made explicit to remove ambiguity in the scan.

### Q20 - C (transcribed; PDF page 5)

Geodetic surveying accounts for earth curvature.

### Q21 - C (transcribed; PDF page 5)

The sequent depth is 2 m. Using the approximate jump length 6y2 gives 12 m.

### Q22 - D (transcribed; PDF page 6)

PERT is conventionally event-oriented; CPM is activity-oriented.

### Q23 - D (transcribed; PDF page 6)

Lacey slope S = f^(5/3)/(3340 Q^(1/6)); with f = 1.1 and Q = 100, S = 1/6138.92, closest to 1/6140.

### Q24 - B (transcribed; PDF page 6)

Simpson's rule gives (20/3)[2.35 + 5.65 + 4(6.50 + 6.65 + 6.20 + 6.50) + 2(5.40 + 7.85 + 2.35)] = 950.67 m², closest to 950 (option B).

### Q25 - D (adapted; PDF page 6)

K_CB = 4(2EI)/6 and K_CD = 4EI/4. DF_CB = (4/3)/(4/3 + 1) = 4/7 = 0.571. The source diagram is described in words.

### Q26 - A (transcribed; PDF page 6)

For bearings between 180° and 270°, the quadrantal bearing is S(theta - 180°)W.

### Q27 - D (transcribed; PDF page 6)

Runoff volume = 0.5 x 20 x 3600 x 300 = 10.8 million m³. Dividing by 0.01 m of runoff gives 1080 km².

### Q28 - B (transcribed; PDF page 6)

The statements describe conventional manufacture of air-entraining and extra rapid-hardening cements.

### Q29 - B (transcribed; PDF page 6)

For Greenshields flow, k_j = 120, k_c = 60 and q_max = 100 x 120/4 = 3000.

### Q30 - A (adapted; PDF page 7)

The force method solves compatibility for redundants; the displacement method solves joint equilibrium for displacements. This clarifies overlapping statements in the source.

### Q31 - D (transcribed; PDF page 7)

The intercepted mass rate is density times area times relative speed V - u.

### Q32 - D (adapted; PDF page 7)

Adding half the wall breadth at each end gives L + b. The original verbal choices include equivalent descriptions, so distinct algebraic options are used.

### Q33 - D (transcribed; PDF page 7)

Ns = N sqrt(Q)/H^(3/4) = 1450 sqrt(44)/36^0.75 = 654.44.

### Q34 - C (transcribed; PDF page 7)

k = cv mv gamma_w = (4.8 x 10^-6/60) x 1.02 x 10^-3 x 9.81 = 8.0 x 10^-10 m/s.

### Q35 - A (transcribed; PDF page 7)

Abrasion testing evaluates resistance to surface wear from rubbing or grinding.

### Q36 - D (transcribed; PDF page 7)

Q = 54 m³/h; area = Q/(0.8 x 4) = 16.875 m², giving d = sqrt(4A/pi) = 4.64 m.

### Q37 - A (transcribed; PDF page 7)

Thermal tensile stress = E alpha deltaT = 70 MPa; area = pi(150² - 125²)/4 = 1718.75pi mm², so force = 120.3125pi kN.

### Q38 - D (transcribed; PDF page 8)

A steep-to-mild transition can force supercritical flow to become subcritical through a hydraulic jump.

### Q39 - A (adapted; PDF page 8)

Fixed ends have prescribed zero rotation. All three supports in B have unknown rotations; the five roller supports in C do also. The ambiguous space-frame matching entry is omitted, keeping the beam kinematic-indeterminacy concept.

### Q40 - C (transcribed; PDF page 8)

A cube-rate estimate includes building height as well as floor area.

### Q41 - D (transcribed; PDF page 8)

Settlement = H(e0 - e1)/(1 + e0) = 8 x 0.4/2.2 = 1.455 m.

### Q42 - A (adapted; PDF page 8)

U = integral T²/(2GJ) dx = T²L/(2GJ). The printed integral options are replaced by equivalent unambiguous closed forms.

### Q43 - B (transcribed; PDF page 8)

Off-tracking is approximately l²/(2R) = 36/120 = 0.30 m.

### Q44 - D (transcribed; PDF page 8)

Raw materials are crushed, proportioned and blended, burned to clinker, then ground with gypsum.

### Q45 - D (transcribed; PDF page 9)

f = 1.76 sqrt(d_mm), so d = (1/1.76)² = 0.323 mm.

### Q46 - D (transcribed; PDF page 9)

The routing coefficients sum to one, giving C2 = 1 - (-0.3) - 0.6 = 0.7.

### Q47 - B (transcribed; PDF page 9)

Superplasticizers provide substantial water reduction while retaining workability.

### Q48 - B (transcribed; PDF page 9)

R = V²/[127(e + f)] = 10000/[127 x 0.22] = 357.9 m.

### Q49 - C (adapted; PDF page 9)

P = 1 - (1 - 1/80)^80 = 0.6344. The scan's choices do not contain this value; option C is corrected for practice.

### Q50 - A (transcribed; PDF page 9)

RL(Q) = 980.450 + 1.5 - 2500 tan(7°15') - 3.5 + 0.0673(2.5)² = 660.83 m approximately.

### Q51 - C (transcribed; PDF page 9)

Vapour cavities form when local absolute pressure falls to the liquid's vapour pressure.

### Q52 - B (adapted; PDF page 9)

Isotropy concerns direction at a point; homogeneity concerns position. The source options conflate these ideas.

### Q53 - D (transcribed; PDF page 10)

Mass continuity gives v2 = 3 x 8 x 0.5/(4 x 1) = 3 m/s.

### Q54 - B (transcribed; PDF page 10)

A lump-sum contract pays an agreed total for the defined scope rather than remeasuring each item for payment.

### Q55 - D (transcribed; PDF page 10)

Braking distance is proportional to 1/(fr + grade). Reduction relative to the original is 1 - (fr + 0.01G)/(fr + 0.02G).

### Q56 - B (transcribed; PDF page 10)

For a fixed activity duration, total float equals LS - ES = LF - EF.

### Q57 - C (transcribed; PDF page 10)

ic = (2.65 - 1)(1 - 0.35) = 1.0725. From 2 = ic(1.25 + H)/1.85, H = 2.20 m.

### Q58 - A (transcribed; PDF page 10)

Continuity makes throat velocity larger; Bernoulli makes throat pressure lower. A and D are false.

### Q59 - D (transcribed; PDF page 10)

Subtract stresses from uniformly loaded disks of radii 4 and 3 m: q[(1 + (3/4)²)^(-3/2) - (1 + (4/4)²)^(-3/2)] = 31.69 kPa.

### Q60 - D (transcribed; PDF page 11)

Soluble salts cause efflorescence. Moderate coverage is above slight coverage and up to 50%; less than 10% is slight.

### Q61 - A (transcribed; PDF page 11)

Lacey's normal scour depth is measured below the high-flood water level.

### Q62 - C (transcribed; PDF page 11)

A Pitot arrangement obtains local velocity from stagnation and static pressure difference.

### Q63 - C (adapted; PDF page 11)

The centre is the average principal stress and radius is half their difference. Principal stresses are specified because the printed wording says only normal stresses.

### Q64 - B (transcribed; PDF page 11)

The centre-line method is for quantities in walls and similar building work, rather than highway cross-section earthwork volumes.

### Q65 - A (transcribed; PDF page 11)

Delta = 8.64B/D = 8.64 x 150/1500 = 0.864 m = 86.4 cm.

### Q66 - C (adapted; PDF page 11)

dV/dx = -w: a point force produces a jump and constant shear, a pure couple produces no shear, UDL gives linear shear, and triangular loading gives parabolic shear. Diagram information is expressed in words.

### Q67 - B (transcribed; PDF page 11)

The factor beta accounts for nonuniform velocity when replacing the momentum-flux integral with a mean-velocity expression.

### Q68 - C (transcribed; PDF page 12)

Honeycombing leaves voids; bleeding brings water up; cooling causes thermal shrinkage; segregation separates components.

### Q69 - B (transcribed; PDF page 12)

Under Froude similarity, power scales as L^(7/2). Thus 0.5 x 50^3.5 kW = 441.94 MW.

### Q70 - D (transcribed; PDF page 12)

M/I = E/R, hence R = EI/M.

### Q71 - B (transcribed; PDF page 12)

For ideal undrained cohesive soil, Hc = 4c/gamma = 120/20 = 6 m.

### Q72 - C (transcribed; PDF page 12)

For comparable materials and adequate compaction and curing, water-cement ratio strongly controls concrete strength.

### Q73 - C (adapted; PDF page 12)

The stiffness method uses joint displacements as primary unknowns. This replaces ambiguous terminology in the printed matching question.

### Q74 - B (transcribed; PDF page 12)

Classical PERT models uncertain individual activity durations using a beta distribution.

### Q75 - C (transcribed; PDF page 13)

Using dy/dx = (S0 - Sf)/(1 - Fr²), M2, A2 and H2 profiles have negative depth gradients.

### Q76 - C (adapted; PDF page 13)

Block-shear resistance combines shear yielding or rupture with tension rupture or yielding. This replaces the code-table recall question without assuming an unverified edition-specific value.

### Q77 - C (transcribed; PDF page 13)

Density is the reciprocal of spacing: 1000/20 = 50 veh/km.

### Q78 - A (transcribed; PDF page 13)

Surface heating causes buoyant moist air to rise, expand, cool and condense.

### Q79 - A (transcribed; PDF page 13)

Entrapped air voids are largest, followed by intentionally entrained bubbles, capillary pores, and gel pores.

### Q80 - B (adapted; PDF page 13)

Tangential momentum gives sin(theta) = (Q1 - Q2)/(Q1 + Q2) = 1/2, so theta = 30°. The angle reference and assumptions are clarified.

### Q81 - A (transcribed; PDF page 13)

The one-dimensional Saint-Venant system consists of conservation of mass and momentum.

### Q82 - C (adapted; PDF page 13)

Ordering the specified values gives 0.25 < 0.31 < 0.33 < 0.35. Values are supplied because alloy-dependent ranges can overlap.

### Q83 - C (transcribed; PDF page 14)

False set caused by gypsum recrystallization can be relieved by remixing without adding water.

### Q84 - D (adapted; PDF page 14)

Compensation = min(1.30, 0.75) = 0.75%; compensated gradient = 7 - 0.75 = 6.25%. The design expression is supplied explicitly.

### Q85 - D (adapted; PDF page 14)

A siphon aqueduct carries the canal above a drain that must flow through pressure barrels. The source level-only choices overlap, so the hydraulic arrangements are stated distinctly.

### Q86 - C (transcribed; PDF page 14)

sigma_x, sigma_y, tau_xy and the constrained out-of-plane normal stress sigma_z can be nonzero.

### Q87 - D (transcribed; PDF page 14)

True distance = 333 x 100/25 = 1332 m.

### Q88 - D (adapted; PDF page 14)

EGL is HGL plus velocity head v²/(2g); that head is lost as the jet mixes in the reservoir. The location is clarified.

### Q89 - C (transcribed; PDF page 14)

Clay: Sf = Sp(Bf/Bp) = 45 mm. Sand: Sf = Sp[Bf(Bp + 0.3)/(Bp(Bf + 0.3))]² = 29.4 mm. Difference = 15.6 mm.

### Q90 - D (adapted; PDF page 14)

30 + 1.65 x 5 = 38.25 MPa. The governing expression is supplied rather than presenting a potentially incomplete code requirement.

### Q91 - C (transcribed; PDF page 15)

The assumed standard deviation for M15 is 3.5 MPa; 6-15 m? requires two samples; basic cantilever ratio is 7; M35 plain-bar tension bond stress is 1.7 MPa. A and D are incorrect.

### Q92 - D (transcribed; PDF page 15)

For Greenshields flow, qmax = uf kj/4 = 3000 veh/h and speed at capacity is uf/2 = 50 km/h.

### Q93 - D (transcribed; PDF page 15)

Flexural rigidity is the product EI.

### Q94 - D (transcribed; PDF page 15)

An adverse pressure gradient, dp/dx > 0, decelerates the boundary layer and can cause separation.

### Q95 - D (adapted; PDF page 15)

At the equal-height mercury interfaces, p_oil + rho_oil gh = p_water + rho_water gh. Thus p_oil > p_water. The scanned diagram is described in words.

### Q96 - B (transcribed; PDF page 15)

Q = 20/800 = 0.025 m³/s and H = 8.8 m. Input power = 9.81QH/0.60 = 3.597 kW, approximately 3.59 kW.

### Q97 - D (transcribed; PDF page 16)

The conventional sequence is unsoiling, digging, cleaning, weathering, blending and tempering.

### Q98 - C (transcribed; PDF page 16)

Running speed excludes stopped delays; journey speed includes them. For a trip with delays, running speed is higher.

### Q99 - B (transcribed; PDF page 16)

Topographic surveys map both natural and constructed surface features.

### Q100 - A (transcribed; PDF page 16)

The respective numbers are 6, 4, 3 and 1.

### Q101 - A (adapted; PDF page 16)

An = (300 - 2 x 22) x 6 = 1536 mm². The source staggered bolt diagram is replaced with a specified straight net section covering the same net-area concept.

### Q102 - B (adapted; PDF page 16)

The printed right-hand descriptions do not produce a valid full matching. They are corrected to the actual functions of these surveying methods.

### Q103 - D (transcribed; PDF page 17)

Conventional warning signs are triangular, information signs rectangular, yield signs inverted triangles, prohibitory signs circular and stop signs octagonal.

### Q104 - A (transcribed; PDF page 17)

sin(phi) = (900 - 250)/(900 + 250) = 650/1150. Then tau = 100 tan(phi) = 68.5 kN/m².

### Q105 - D (transcribed; PDF page 17)

Chlorides damage passivity and carbonation by CO2 reduces alkalinity around steel.

### Q106 - B (transcribed; PDF page 17)

yc = (q²/g)^(1/3) with q = 8/4 = 2 m²/s, giving (0.4)^(1/3) m.

### Q107 - A (transcribed; PDF page 17)

cu = 110 kPa; ultimate capacity = 9cu Ap + alpha cu perimeter L. Thus 1125 = 247.5 + 132L, giving L = 6.647 m.

### Q108 - D (transcribed; PDF page 17)

Plain-bar tension bond stress for M30 is 1.5 MPa. Applying 1.6 for deformed bars and 1.25 for compression gives 3 MPa. Ld/d = (0.75 x 415)/(4 x 3) = 25.94.

### Q109 - A (transcribed; PDF page 17)

Additional water per bulk volume = gamma_w(e - wGs)/(1 + e) = 9.81(0.72 - 0.54)/1.72 = 1.027 kN/m³, closest to 1.025.

### Q110 - D (transcribed; PDF page 17)

sigma_z = [3Q/(2pi z²)]/[1 + (r/z)²]^(5/2) = 10.58 kPa.

### Q111 - C (adapted; PDF page 17)

Chlorides promote corrosion, sugar may retard setting, and entrained air protects against freeze-thaw damage. Carbonation reduces alkalinity. The scan's water chloride unit is ambiguous and is not used as a limit.

### Q112 - C (adapted; PDF page 18)

A third hinge at midspan forms a mechanism; Mp = WL/4 = 60 kN m. This replaces the scanned unequal-height portal mechanism with a directly specified plastic-collapse question.

### Q113 - A (transcribed; PDF page 18)

We = nl²/(2R) + V/(9.5 sqrt(R)) = 3 x 36/1800 + 100/(9.5 x 30) = 0.411 m.

### Q114 - B (transcribed; PDF page 18)

Annual exceedance probability is 1/50. All three years: (1/50)³ = 8 x 10^-6.

### Q115 - C (transcribed; PDF page 18)

Cauchy stress is a second-order tensor.

### Q116 - C (transcribed; PDF page 18)

Taking P and Q as unaffected since PQ and QP differ by 180°, station R has a -1° error. Using RS gives a -2° error at S. The discrepancies are consistent with R and S being affected.

### Q117 - A (adapted; PDF page 18)

The three criteria give 96, 68 and 86.4 m. The maximum is 96 m. The formula is supplied and the missing correct printed option is repaired.

### Q118 - A (transcribed; PDF page 18)

The conventional approximate nominal cement:sand:coarse aggregate proportion for M20 is 1:1.5:3.

### Q119 - A (transcribed; PDF page 18)

The energy equation gives dE/dx = S0 - Sf, where E is measured relative to the bed.

### Q120 - D (adapted; PDF page 18)

Ka = tan²(45° - 7.5°) = 0.5888; zc = 2c/(gamma sqrt(Ka)) = 2.172 m. Pa = 0.5 Ka gamma(8 - zc)² = 180.0 kN/m. The printed options and thrust units are corrected.

### Q121 - A (transcribed; PDF page 19)

Earnest money backs a bid, security backs performance, arbitration settles disputes, and a tender is a formal offer.

### Q122 - A (adapted; PDF page 19)

Diurnal variation is the daily variation of magnetic declination. The source's absolute seasonal and geographic generalizations are replaced by the definition.

### Q123 - C (transcribed; PDF page 19)

An IUH is the response to a unit effective rainfall depth applied over an infinitesimal duration.

### Q124 - B (adapted; PDF page 19)

The conventional flexural redundancy counts are 0, 1, 2 and 3 respectively for C, A, B and D. Assumptions on axial redundancies are made explicit.

### Q125 - D (adapted; PDF page 19)

There are two top-joint rotations and one common lateral translation, giving three degrees of freedom. The source geometry and modelling assumptions are stated in words.

### Q126 - C (transcribed; PDF page 19)

An isogonic line joins points of equal magnetic declination; zero declination defines an agonic line.

### Q127 - C (adapted; PDF page 19)

Substituting d = 1.28 m gives Ge approximately 0.200. The design equation is supplied to make the idealization explicit.

### Q128 - B (transcribed; PDF page 20)

The in-plane principal stresses are +tau_xy and -tau_xy.

### Q129 - B (adapted; PDF page 20)

k = Q ln(R/r)/(2pi b s) = 0.02 ln(1000)/(2pi x 5 x 2) = 0.001 ln(1000)/pi. Parentheses are clarified from the scan.

### Q130 - A (transcribed; PDF page 20)

The most efficient symmetric triangular section has side slopes 1H:1V, giving a 90° vertex angle.

### Q131 - C (transcribed; PDF page 20)

Systematic errors accumulate, whereas random effects tend to reduce in a mean. Temperature errors require systematic correction.

### Q132 - D (transcribed; PDF page 20)

True length = measured length x actual chain length/nominal length = 300 x 25.15/25 = 301.8 m.

### Q133 - D (transcribed; PDF page 20)

The conventional progression is very low workability for mechanically compacted roads, low for mass concrete, medium for reinforced work and high for congested reinforcement.

### Q134 - C (transcribed; PDF page 20)

Height of instrument = 103.715 m. RL = HI - (-3.735) = 107.450 m.

### Q135 - B (adapted; PDF page 21)

A restrained abutment does not undergo the displacement needed for active pressure. The restraint assumption is added because the original generic abutment question is ambiguous.

### Q136 - A (transcribed; PDF page 21)

For the specified unit rainfall intensity, the IUH ordinate is dQ/dt = t^-2 + 4t^-3, which equals 5 at t = 1.

### Q137 - D (transcribed; PDF page 21)

Centre-line dimensions are 6.35 and 5.35 m. Perimeter = 2(6.35 + 5.35) = 23.4 m.

### Q138 - C (transcribed; PDF page 21)

Velocity = 10/(2 x 2) = 2.5 m/s. E = 2 + 2.5²/(2 x 9.81) = 2.319 m, approximately 2.3 m.

### Q139 - C (transcribed; PDF page 21)

Lag distance = 20 x 2 = 40 m; braking distance using g = 10 m/s² is 20²/(2 x 10 x 0.30) = 66.67 m. Total = 106.67 m.

### Q140 - D (transcribed; PDF page 21)

The buoyant force acts through the centroid of the displaced fluid volume.

### Q141 - B (adapted; PDF page 21)

A tape whose actual length differs consistently from its nominal length biases every measured segment. The source mixes overlapping mistake/blunder terminology, so a definite error-classification question is used.

### Q142 - A (adapted; PDF page 21)

Homogeneity concerns invariance with position; it does not require isotropy. The printed tensor-direction options are replaced by a precise definition.

### Q143 - B (adapted; PDF page 21)

The vertical projection is sqrt(4.935² - 0.20²) = 4.93095 m. The source asks for error but offers corrected readings, so the requested quantity is clarified.

### Q144 - D (transcribed; PDF page 22)

Effective stress is submerged soil weight: (20 - 10) x 4 = 40 kPa. The overlying water adds equal total and pore pressures.

### Q145 - D (transcribed; PDF page 22)

Low-heat cement uses lower C3A and greater C2S. Rapid-hardening cement generally has higher C3S and finer grinding.

### Q146 - C (adapted; PDF page 22)

Solid volume = 430/2.70 = 159.259 cm³, so void volume = 90.741 cm³. Water content at saturation = 90.741/430 x 100 = 21.10%. The missing correct option is supplied.

### Q147 - D (transcribed; PDF page 22)

Rainfall intensity is 2.4/8 = 0.3 cm/h, below the phi-index, so there is no rainfall excess.

### Q148 - C (adapted; PDF page 22)

The conventional sequence is old guarantee, state construction, modified guarantee, nationalization, then post-independence integration and regrouping. Indian railways are specified because the printed stem omits the subject.

### Q149 - D (transcribed; PDF page 22)

For optimal side slope 1H:1V, area = y² and wetted perimeter = 2sqrt(2)y. Thus R = y/[2sqrt(2)].

### Q150 - B (adapted; PDF page 22)

Both ends restrain lateral displacement and rotation, so effective length is L/2 and Pcr = 4pi²EI/L². The top-guide restraints in the source diagram are made explicit.
