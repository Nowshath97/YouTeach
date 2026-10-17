# Civil Mock 2 - editorial review and answer key

Original unofficial Civil-only AEE-style practice: 100 questions, 100 minutes, 200 marks. Mixed order: 40 theory, 30 short numericals, 20 multiple-statement combinations and 10 matching questions. No General Studies. Choose ONE coded answer per question, including the correct combination for multiple statements and matching. Scoring: +2 correct; 0 wrong or unanswered. The 100-mark practice benchmark is not an official qualifying cutoff. Inspired by the variety of AEE/ESE objective formats; not an official paper or a claim of ESE-equivalent difficulty.

## Scope and references

- Original authored questions; not transcriptions of the commercial solved-paper PDF.
- Format reference: user-provided AEE Civil.pdf, sampled physical pages 3, 9, 19 and 29.
- Several correct statements are answered through a single combination choice, not separate checkboxes.
- Questions are deliberately interleaved in one Civil Engineering section; topic tags below are private.
- Difficulty tags are editorial estimates, not calibrated candidate ability measurements.
- 10 questions per subject; 40 theory, 30 short numericals, 20 statement combinations, 10 matching.
- This mix tests breadth and common misconceptions. It is not a validated psychometric assessment.
- No current code-clause thresholds or recruitment rules are assumed.
- NPTEL effective stress and seepage: https://archive.nptel.ac.in/content/storage2/courses/105103097/web/chap5final/s3.htm
- NPTEL critical gradient: https://archive.nptel.ac.in/content/storage2/courses/105103097/web/chap5final/s5.htm
- UPSC ESE objective-paper context: https://www.upsc.gov.in/examinations/Engineering%20Services%20%28Preliminary%29%20Examination%2C%202026

## Installation

Run `supabase/aee_civil_mock_2_seed.sql` in Supabase SQL Editor. This creates a published test; it does not replace Mock 1. No live database was accessed by this generator. Keep source, JSON and this answer key outside public browser assets.

## Answers

### Q1 - B | Environmental engineering | theory

The most direct purpose of returning activated sludge from the secondary clarifier to the aeration tank is to:

A. Raise the influent grit concentration
B. Maintain an adequate biological solids concentration in the reactor
C. Eliminate the need to waste excess sludge
D. Replace aeration by sedimentation

**Reason:** Return sludge recycles the settled biomass; excess biomass still requires controlled wasting.

### Q2 - D | Hydrology and irrigation | theory

The rational formula Q=CIA is most appropriately used when the design rainfall duration is at least the:

A. Return period
B. Reservoir detention time
C. Base period of the crop
D. Time of concentration of the catchment

**Reason:** At the time of concentration the entire catchment can contribute to outlet runoff, subject to rational-method assumptions.

### Q3 - A | Transportation engineering | theory

Compared with spot speed, journey speed over a road section includes:

A. All travel time, including stopped delays
B. Only time spent in motion
C. Only the speed at the midpoint
D. Only the highest observed vehicle speed

**Reason:** Journey speed equals route distance divided by total journey time, including delays.

### Q4 - A | Hydrology and irrigation | short numerical

An irrigation outlet supplies 1 m^3/s continuously for a 100-day base period to 1000 ha. The equivalent water depth is:

A. 0.864 m
B. 8.64 m
C. 0.0864 m
D. 86.4 m

**Reason:** Volume=8640000 m^3 and area=10000000 m^2, so depth=0.864 m.

### Q5 - A | Environmental engineering | statement combination

For conventional biological wastewater treatment, consider:
1. Nitrification oxidizes ammonium to nitrite and nitrate under aerobic conditions.
2. Denitrification can convert nitrate to nitrogen gas under anoxic conditions.
3. Denitrification always requires free dissolved oxygen as its terminal electron acceptor.
Which statements are correct?

A. 1 and 2 only
B. 1 and 3 only
C. 2 only
D. 1, 2 and 3

**Reason:** Denitrifiers use oxidized nitrogen rather than free oxygen as the terminal electron acceptor in anoxic conditions.

### Q6 - A | Materials and construction | theory

Seasoning of timber is mainly intended to:

A. Reduce moisture content to a suitable service level
B. Convert sapwood into heartwood
C. Eliminate every natural defect
D. Increase its free-water content

**Reason:** Seasoning reduces moisture, improving dimensional stability and suitability for use.

### Q7 - C | Materials and construction | statement combination

Regarding curing of concrete, consider:
1. It helps maintain moisture for cement hydration.
2. It can reduce early drying and associated shrinkage cracking.
3. It makes the original water-cement ratio irrelevant to strength.
Which statements are correct?

A. 2 only
B. 1, 2 and 3
C. 1 and 2 only
D. 1 and 3 only

**Reason:** Curing supports hydration and limits premature drying; it does not erase the effect of mix proportions.

### Q8 - B | Geotechnical engineering | statement combination

For Rankine earth pressure in dry cohesionless soil with a horizontal surface and a smooth vertical wall, consider:
1. Ka=(1-sin phi)/(1+sin phi).
2. Kp=1/Ka.
3. Active pressure is mobilized by wall movement towards the backfill.
Which statements are correct?

A. 1 only
B. 1 and 2 only
C. 1, 2 and 3
D. 2 and 3 only

**Reason:** Active conditions require movement away from the backfill; movement into it mobilizes passive conditions.

### Q9 - C | Fluid mechanics and hydraulics | short numerical

Water flows at 2 m/s in a 200 mm diameter pipe. If the pipe narrows to 100 mm diameter with unchanged discharge, the speed becomes:

A. 1 m/s
B. 4 m/s
C. 8 m/s
D. 0.5 m/s

**Reason:** Area is proportional to diameter squared; quartering area quadruples velocity.

### Q10 - A | Geotechnical engineering | theory

For saturated clay under rapid loading with negligible drainage, the commonly used laboratory test simulating an undrained response without prior consolidation is:

A. Unconsolidated undrained triaxial test
B. Constant-head permeability test
C. Direct shear test with unrestricted drainage
D. Consolidated drained triaxial test

**Reason:** The UU test permits neither consolidation before shear nor drainage during shear.

### Q11 - B | Transportation engineering | short numerical

Using e+f=v^2/(gR), v=20 m/s, R=200 m, g=10 m/s^2 and superelevation e=0.08, the required side-friction factor is:

A. 0.28
B. 0.12
C. 0.08
D. 0.20

**Reason:** v^2/(gR)=0.20; f=0.20-0.08=0.12.

### Q12 - C | Structural mechanics | theory

For a homogeneous isotropic linearly elastic material, which pair can be chosen as independent elastic constants away from singular limiting cases?

A. E and axial stress
B. Shear stress and shear strain
C. E and G
D. Poisson ratio and axial strain

**Reason:** Any two independent elastic constants determine the remaining constants; for example E=2G(1+nu).

### Q13 - B | Transportation engineering | theory

Superelevation on a horizontal road curve primarily helps counteract:

A. Vertical settlement of the subgrade
B. The lateral acceleration required for turning
C. Only headlight glare
D. Longitudinal thermal expansion

**Reason:** The banked cross-section provides a component of normal force towards the curve centre, reducing reliance on side friction.

### Q14 - A | Fluid mechanics and hydraulics | theory

For a rectangular channel carrying a given discharge, specific energy is minimum when:

A. The Froude number equals one
B. The depth tends to zero
C. The velocity is zero
D. The Froude number is always much greater than one

**Reason:** At critical depth, dE/dy=0 and V^2/(gy)=1.

### Q15 - C | Fluid mechanics and hydraulics | short numerical

Using Darcy friction factor f=0.02, pipe length L=100 m, diameter D=0.20 m, speed V=2 m/s and g=10 m/s^2, friction head loss is:

A. 0.2 m
B. 1 m
C. 2 m
D. 20 m

**Reason:** hf=f(L/D)V^2/(2g)=0.02x500x4/20=2 m; f is explicitly the Darcy factor.

### Q16 - A | Hydrology and irrigation | short numerical

A 3-hour storm has constant intensity 12 mm/h. With a constant phi-index of 4 mm/h and no separate initial loss, rainfall excess depth is:

A. 24 mm
B. 48 mm
C. 12 mm
D. 36 mm

**Reason:** Excess=(12-4)x3=24 mm.

### Q17 - D | Environmental engineering | theory

In a conventional wastewater treatment train, grit removal is normally placed:

A. After sludge drying only
B. Inside the receiving river
C. After final disinfection only
D. Ahead of biological treatment to protect equipment and downstream units

**Reason:** Dense mineral particles are removed early to reduce abrasion and deposition.

### Q18 - D | Fluid mechanics and hydraulics | theory

Hydraulic jump in a horizontal rectangular channel is a transition from:

A. Uniform flow to static water without dissipation
B. Subcritical to supercritical flow with energy gain
C. Laminar pipe flow to turbulent pipe flow
D. Supercritical to subcritical flow with energy dissipation

**Reason:** A hydraulic jump dissipates specific energy while conserving momentum approximately over the short reach.

### Q19 - D | Structural mechanics | statement combination

Consider Euler buckling of an initially straight slender elastic column.
1. Critical load is proportional to EI.
2. Critical load is inversely proportional to effective length squared.
3. Doubling effective length doubles critical load.
Which statements are correct?

A. 1, 2 and 3
B. 2 and 3 only
C. 1 only
D. 1 and 2 only

**Reason:** Pcr=pi^2 EI/Le^2; statement 3 contradicts the inverse-square dependence.

### Q20 - D | Structural mechanics | theory

At a free end of a beam, a concentrated couple is applied but there is no transverse force. Immediately inside the end, the internal actions are:

A. Nonzero shear and zero moment
B. Nonzero shear and nonzero moment
C. Zero moment and zero shear
D. Nonzero moment and zero shear

**Reason:** End equilibrium requires a balancing bending moment; no transverse end force is present to produce shear.

### Q21 - B | Materials and construction | short numerical

A nominal dry-volume mix is proportioned 1:2:4 by volume. In 1.4 m^3 of dry ingredients, the cement volume is:

A. 0.35 m^3
B. 0.20 m^3
C. 0.70 m^3
D. 0.40 m^3

**Reason:** Cement fraction=1/(1+2+4)=1/7; volume=1.4/7=0.20 m^3. No wet-volume conversion is requested.

### Q22 - C | Geotechnical engineering | short numerical

Take water unit weight as 10 kN/m^3. A saturated soil has unit weight 20 kN/m^3 and water table at ground level. At 3 m depth, effective vertical stress is:

A. 10 kPa
B. 60 kPa
C. 30 kPa
D. 90 kPa

**Reason:** sigma'=gamma' z=(20-10)x3=30 kPa.

### Q23 - B | Structural mechanics | theory

A pin-jointed plane truss has m=2j-3. Which conclusion is justified without examining its geometry?

A. It is necessarily indeterminate
B. The member count satisfies a necessary condition for a stable determinate truss
C. Every member carries nonzero force
D. It is necessarily stable

**Reason:** The counting condition alone does not exclude mechanisms or improper member arrangements.

### Q24 - D | Structural mechanics | short numerical

A solid circular shaft diameter is doubled while its transmitted torque remains unchanged. Maximum torsional shear stress becomes:

A. One-fourth
B. Twice
C. One-half
D. One-eighth

**Reason:** For a solid circular shaft, tau_max=16T/(pi d^3); doubling d reduces stress to one-eighth.

### Q25 - B | Surveying and geomatics | short numerical

A benchmark RL is 100.000 m. Backsight is 1.250 m and foresight to a new point is 2.000 m. The new RL is:

A. 103.250 m
B. 99.250 m
C. 98.750 m
D. 100.750 m

**Reason:** HI=101.250 m; new RL=101.250-2.000=99.250 m.

### Q26 - C | Environmental engineering | short numerical

A treatment unit removes 80% of an influent suspended-solids concentration of 250 mg/L. The effluent concentration is:

A. 100 mg/L
B. 200 mg/L
C. 50 mg/L
D. 20 mg/L

**Reason:** Remaining concentration=250(1-0.8)=50 mg/L.

### Q27 - B | Fluid mechanics and hydraulics | theory

A horizontal venturimeter has steady incompressible flow and negligible losses. Compared with the inlet, its throat has:

A. Higher speed and higher pressure
B. Higher speed and lower pressure
C. Lower speed and lower pressure
D. Lower speed and higher pressure

**Reason:** Continuity increases velocity at the smaller area; Bernoulli then gives lower static pressure.

### Q28 - D | Construction planning and estimation | matching

Match each planning/economic term to its meaning.
P. Crashing
Q. Resource levelling
R. Depreciation
S. Salvage value
1. Residual value at disposal; 2. Allocating asset cost over useful life; 3. Reducing activity duration at additional direct cost; 4. Adjusting schedule to address resource limits

A. P-3, Q-2, R-4, S-1
B. P-4, Q-3, R-2, S-1
C. P-1, Q-4, R-3, S-2
D. P-3, Q-4, R-2, S-1

**Reason:** Crashing trades cost for time, levelling addresses resource availability, depreciation allocates cost, and salvage is end-of-use value.

### Q29 - A | Geotechnical engineering | theory

For normally consolidated saturated clay, which change most directly explains primary consolidation under sustained additional load?

A. Dissipation of excess pore pressure with increasing effective stress
B. Water entering the pores at constant effective stress
C. Immediate crushing of all soil grains
D. Evaporation of all bound water

**Reason:** Initially the added load creates excess pore pressure; drainage transfers it to the skeleton and produces compression.

### Q30 - C | Transportation engineering | short numerical

A vehicle travels 100 km in 2 h including all stops. Its journey speed is:

A. 100 km/h
B. 25 km/h
C. 50 km/h
D. 200 km/h

**Reason:** Journey speed=100/2=50 km/h.

### Q31 - C | Fluid mechanics and hydraulics | matching

Match each dimensionless number with the dominant force ratio it represents.
P. Reynolds
Q. Froude (squared)
R. Weber
S. Mach
1. Inertia/surface tension; 2. Flow speed/sound speed; 3. Inertia/viscosity; 4. Inertia/gravity

A. P-3, Q-1, R-4, S-2
B. P-4, Q-3, R-1, S-2
C. P-3, Q-4, R-1, S-2
D. P-1, Q-4, R-3, S-2

**Reason:** Re compares inertia and viscosity; Fr^2 compares inertia and gravity; We compares inertia and surface tension; Mach compares speeds.

### Q32 - A | Transportation engineering | short numerical

A vehicle moves at 54 km/h. With reaction time 2 s, the distance travelled before braking begins is:

A. 30 m
B. 15 m
C. 54 m
D. 108 m

**Reason:** 54 km/h=15 m/s; reaction distance=15x2=30 m.

### Q33 - A | Materials and construction | statement combination

For supplementary cementitious materials in concrete, consider:
1. A pozzolan can react with calcium hydroxide in the presence of moisture to form additional cementitious products.
2. Suitable fly ash can improve later-age properties when mix design and curing are adequate.
3. Every fly ash guarantees higher one-day strength than every Portland-cement-only mix.
Which statements are correct?

A. 1 and 2 only
B. 1 only
C. 2 and 3 only
D. 1, 2 and 3

**Reason:** Pozzolanic reactions and later-age benefits depend on material and curing; a universal early-strength guarantee is false.

### Q34 - D | Geotechnical engineering | short numerical

A saturated sand has Gs=2.65 and void ratio e=0.65. Its critical upward hydraulic gradient is:

A. 1.65
B. 2.54
C. 0.65
D. 1.00

**Reason:** icr=(Gs-1)/(1+e)=1.65/1.65=1.

### Q35 - A | Hydrology and irrigation | statement combination

For crop irrigation requirements, consider:
1. Effective rainfall can reduce the net irrigation requirement.
2. If application efficiency is less than one, gross irrigation requirement exceeds net requirement.
3. Increasing conveyance losses reduces the diversion required for a fixed field demand.
Which statements are correct?

A. 1 and 2 only
B. 2 and 3 only
C. 1, 2 and 3
D. 1 only

**Reason:** Losses require additional diversion; they cannot reduce the water needed at the headworks for the same field supply.

### Q36 - D | Environmental engineering | short numerical

Chlorine dose is 3.0 mg/L and measured residual after the specified contact time is 0.5 mg/L. Chlorine demand is:

A. 1.5 mg/L
B. 3.5 mg/L
C. 6.0 mg/L
D. 2.5 mg/L

**Reason:** Demand equals dose minus residual at the specified contact time.

### Q37 - C | Hydrology and irrigation | theory

An unconfined aquifer is distinguished from a confined aquifer by the presence of:

A. Zero specific yield
B. Water pressure necessarily above atmospheric at its upper saturated boundary
C. A free water table forming its upper saturated boundary
D. An impermeable upper boundary everywhere

**Reason:** At the phreatic surface pore water pressure is atmospheric; unconfined aquifers release water mainly by drainage.

### Q38 - A | Surveying and geomatics | matching

Match each surveying method/instrument to its characteristic observation.
P. Spirit level
Q. Theodolite
R. EDM
S. GNSS receiver
1. Satellite-based positioning observations; 2. Horizontal and vertical angles; 3. Electromagnetic distance measurement; 4. Staff readings along a horizontal line of sight

A. P-4, Q-2, R-3, S-1
B. P-2, Q-4, R-3, S-1
C. P-1, Q-2, R-4, S-3
D. P-4, Q-3, R-2, S-1

**Reason:** The instruments principally provide levelling readings, angles, electronic distances and satellite observations respectively.

### Q39 - B | Materials and construction | short numerical

A concrete cube of loaded face 150 mm x 150 mm fails at 675 kN. Compressive strength is:

A. 3 MPa
B. 30 MPa
C. 45 MPa
D. 15 MPa

**Reason:** Strength=675000/22500=30 N/mm^2=30 MPa.

### Q40 - C | Concrete and steel structures | short numerical

A concentric prestressing force of 600 kN acts on a concrete section of area 0.12 m^2. Ignoring losses and external loads, the uniform concrete stress is:

A. 50 MPa tension
B. 0.5 MPa compression
C. 5 MPa compression
D. 5 MPa tension

**Reason:** P/A=600/0.12=5000 kN/m^2=5 MPa, compressive.

### Q41 - C | Fluid mechanics and hydraulics | theory

For a body fully submerged in a static liquid, buoyancy acts vertically upward through the:

A. Lowest point of the body
B. Metacentre in all cases
C. Centroid of the displaced liquid volume
D. Centre of gravity of the body in all cases

**Reason:** The hydrostatic resultant acts through the centre of buoyancy, the displaced-volume centroid.

### Q42 - B | Materials and construction | theory

For otherwise comparable, properly compacted and cured concrete, reducing the water-cement ratio generally:

A. Has no effect on pore structure
B. Increases strength, provided adequate workability and compaction are maintained
C. Always decreases strength
D. Eliminates the need for curing

**Reason:** Lower water-cement ratio generally reduces capillary porosity, but poor compaction can negate the benefit.

### Q43 - C | Surveying and geomatics | short numerical

A distance measured as 500.0 m with a nominal 20 m tape is corrected for tape length only. The tape's actual length is 20.02 m. The corrected distance is:

A. 499.5 m
B. 500.02 m
C. 500.5 m
D. 499.98 m

**Reason:** True distance=measured distance x actual/nominal=500x20.02/20=500.5 m.

### Q44 - B | Construction planning and estimation | theory

In a deterministic CPM network, the critical path is the path with the:

A. Lowest total cost necessarily
B. Longest total duration
C. Largest total float
D. Fewest activities

**Reason:** Project completion time is governed by the longest-duration start-to-finish path.

### Q45 - A | Construction planning and estimation | theory

In equipment economic analysis, a cost already incurred and unrecoverable regardless of the present decision is a:

A. Sunk cost
B. Salvage value
C. Opportunity cost of a currently usable asset
D. Marginal future operating cost

**Reason:** Sunk costs do not change between current alternatives; relevant future and opportunity costs do.

### Q46 - C | Environmental engineering | short numerical

A tank volume is 600 m^3 and flow is 2400 m^3/day. The nominal hydraulic detention time is:

A. 4 h
B. 12 h
C. 6 h
D. 24 h

**Reason:** V/Q=0.25 day=6 h; nominal time ignores short circuiting.

### Q47 - B | Materials and construction | theory

An air-entraining admixture in properly proportioned concrete is particularly useful for improving:

A. Steel yield strength
B. Freeze-thaw durability
C. Cement specific gravity
D. Resistance to all acids without limitation

**Reason:** Small well-distributed entrained air voids relieve pressure generated during freezing; they do not make concrete universally acid resistant.

### Q48 - B | Geotechnical engineering | theory

Terzaghi effective stress in saturated soil is:

A. Pore water pressure minus total stress
B. Total stress minus pore water pressure
C. Total stress plus pore water pressure
D. Always equal to total stress

**Reason:** The effective normal stress is sigma'=sigma-u.

### Q49 - C | Transportation engineering | theory

A transition curve between a tangent and circular highway curve provides:

A. An instantaneous jump from zero to full curvature
B. Constant curvature throughout its length
C. A gradual change in curvature and lateral acceleration
D. A substitute for every vertical curve

**Reason:** A transition introduces curvature gradually, allowing controlled lateral-acceleration change and superelevation development.

### Q50 - D | Structural mechanics | matching

Match each ideal beam/loading case to its maximum bending-moment magnitude.
P. Cantilever, tip force W
Q. Simply supported beam, central force W
R. Simply supported beam, full-span UDL w
S. Cantilever, full-span UDL w
1. wL^2/8; 2. WL; 3. wL^2/2; 4. WL/4

A. P-1, Q-3, R-2, S-4
B. P-2, Q-4, R-3, S-1
C. P-4, Q-2, R-1, S-3
D. P-2, Q-4, R-1, S-3

**Reason:** End or support equilibrium gives WL, WL/4, wL^2/8 and wL^2/2 respectively.

### Q51 - B | Concrete and steel structures | statement combination

For singly reinforced concrete flexural sections, consider:
1. Increasing steel beyond the balanced amount can cause concrete crushing before steel yielding.
2. Under-reinforced sections generally offer greater ductility than over-reinforced sections.
3. Every over-reinforced beam must fail by shear.
Which statements are correct?

A. 1 only
B. 1 and 2 only
C. 2 and 3 only
D. 1, 2 and 3

**Reason:** Over-reinforcement concerns flexural failure sequence, not an inevitable shear failure.

### Q52 - C | Transportation engineering | matching

Match the road feature or test to its primary purpose.
P. Camber
Q. CBR test
R. Los Angeles abrasion test
S. Marshall stability test
1. Bituminous mix load resistance; 2. Surface drainage; 3. Subgrade penetration resistance index; 4. Aggregate resistance to abrasion and impact

A. P-2, Q-4, R-3, S-1
B. P-3, Q-2, R-4, S-1
C. P-2, Q-3, R-4, S-1
D. P-1, Q-3, R-2, S-4

**Reason:** Camber drains surface water; CBR characterizes penetration resistance; Los Angeles tests aggregate degradation; Marshall evaluates a bituminous mix.

### Q53 - C | Geotechnical engineering | theory

In a standard Proctor compaction test, the maximum dry density and optimum water content correspond to:

A. The liquid limit and plastic limit respectively
B. A fully saturated specimen in every soil
C. The peak of the dry-density versus water-content curve for the specified compactive effort
D. Zero air voids in every specimen

**Reason:** The optimum is defined for the particular compactive effort; the test curve remains below the zero-air-voids line.

### Q54 - C | Environmental engineering | statement combination

For municipal water treatment, consider:
1. Filtration helps remove suspended particles and associated microorganisms.
2. A clear-looking water sample is necessarily microbiologically safe.
3. Disinfection aims to inactivate pathogenic organisms.
Which statements are correct?

A. 1, 2 and 3
B. 2 and 3 only
C. 1 and 3 only
D. 1 only

**Reason:** Clarity does not establish pathogen absence; filtration and disinfection perform complementary functions.

### Q55 - A | Geotechnical engineering | matching

Match the test with its principal output.
P. Oedometer
Q. Standard Proctor
R. Constant-head permeability
S. Casagrande liquid-limit device
1. Coefficient of permeability; 2. Liquid limit; 3. One-dimensional compressibility; 4. Compaction curve

A. P-3, Q-4, R-1, S-2
B. P-2, Q-4, R-3, S-1
C. P-4, Q-3, R-1, S-2
D. P-3, Q-1, R-4, S-2

**Reason:** Oedometer measures constrained compression; Proctor measures compaction response; constant head measures permeability; Casagrande device measures liquid limit.

### Q56 - B | Materials and construction | theory

A concrete slump test is primarily an indication of:

A. Cement fineness directly
B. Consistency of fresh concrete
C. 28-day compressive strength directly
D. Aggregate crushing strength

**Reason:** Slump indicates consistency; it is not a direct measurement of strength or all aspects of workability.

### Q57 - B | Transportation engineering | statement combination

For stopping sight distance on a level road, consider:
1. It includes reaction distance and braking distance.
2. At fixed friction and reaction time, increasing speed increases stopping sight distance.
3. Braking distance is independent of speed.
Which statements are correct?

A. 1 and 3 only
B. 1 and 2 only
C. 1, 2 and 3
D. 2 only

**Reason:** Reaction distance varies with speed and ideal braking distance with speed squared.

### Q58 - C | Construction planning and estimation | short numerical

Two parallel paths have durations 14 days and 11 days. If only the 14-day path is shortened by 5 days, with no other paths or constraints, the new project duration is:

A. 14 days
B. 6 days
C. 11 days
D. 9 days

**Reason:** The shortened path is 9 days, but the other path remains 11 days and becomes critical.

### Q59 - B | Materials and construction | short numerical

A wet sand volume is 1.25 m^3 and its equivalent unbulked volume is 1.00 m^3. Percentage bulking is:

A. 80%
B. 25%
C. 125%
D. 20%

**Reason:** Bulking=(wet bulk volume-unbulked volume)/unbulked volume x100=25%.

### Q60 - C | Transportation engineering | theory

On an idealized Greenshields speed-density model, maximum traffic flow occurs at:

A. Free-flow speed
B. Zero density
C. Half the jam density
D. Jam density

**Reason:** q=uf k(1-k/kj), whose maximum is at k=kj/2 and speed uf/2.

### Q61 - C | Hydrology and irrigation | short numerical

A catchment of 2 km^2 receives runoff depth of 15 mm. The runoff volume is:

A. 3000 m^3
B. 300 m^3
C. 30000 m^3
D. 300000 m^3

**Reason:** Volume=2x10^6 x0.015=30000 m^3.

### Q62 - B | Fluid mechanics and hydraulics | short numerical

In a wide rectangular channel, depth y=1 m and speed V=4 m/s. Taking g=10 m/s^2, the flow is:

A. Subcritical, Fr approximately 0.40
B. Supercritical, Fr approximately 1.26
C. Subcritical, Fr approximately 0.79
D. Critical, Fr=1

**Reason:** Fr=V/sqrt(gy)=4/sqrt(10)=1.265, which exceeds one.

### Q63 - D | Fluid mechanics and hydraulics | statement combination

For fully developed laminar flow of a Newtonian liquid through a horizontal circular pipe, consider:
1. The velocity profile is parabolic.
2. Centreline speed is twice the mean speed.
3. Darcy friction factor is 64/Re.
Which statements are correct?

A. 1 only
B. 2 and 3 only
C. 1 and 2 only
D. 1, 2 and 3

**Reason:** Hagen-Poiseuille flow has a parabolic profile, umax=2V and Darcy f=64/Re.

### Q64 - A | Fluid mechanics and hydraulics | statement combination

For steady incompressible ideal flow along a streamline, consider:
1. Bernoulli head is the sum of pressure, velocity and elevation heads.
2. Bernoulli may be applied across a pump without adding its supplied head.
3. A local increase in velocity head can accompany a decrease in pressure head.
Which statements are correct?

A. 1 and 3 only
B. 1, 2 and 3
C. 1 only
D. 2 and 3 only

**Reason:** A pump adds energy and needs a pump-head term; statement 2 omits that term.

### Q65 - B | Construction planning and estimation | statement combination

For deterministic CPM schedules, consider:
1. More than one critical path can exist.
2. Shortening a noncritical activity necessarily shortens the project.
3. An activity on a critical path has zero total float when project completion is set to the earliest possible finish.
Which statements are correct?

A. 1 only
B. 1 and 3 only
C. 2 and 3 only
D. 1, 2 and 3

**Reason:** Noncritical work can be shortened without affecting the governing path; multiple critical paths are possible under the stated completion convention.

### Q66 - A | Geotechnical engineering | statement combination

For one-dimensional primary consolidation with unchanged cv and the same target degree of consolidation, consider:
1. Required time is proportional to drainage-path length squared.
2. For a layer of thickness H, double drainage gives a drainage path H/2.
3. Changing from single to double drainage doubles the required time.
Which statements are correct?

A. 1 and 2 only
B. 1, 2 and 3
C. 1 and 3 only
D. 2 only

**Reason:** Tv=cv t/Hdr^2. Double drainage halves Hdr and quarters the required time.

### Q67 - D | Concrete and steel structures | theory

Stirrups in a reinforced concrete beam principally help resist:

A. Elastic shortening of prestressing tendons
B. Shrinkage of coarse aggregate only
C. Uniform axial compression only
D. Diagonal tension associated with shear

**Reason:** Stirrups cross diagonal shear cracks and carry the associated tensile force.

### Q68 - B | Construction planning and estimation | statement combination

For construction cost estimates, consider:
1. Rate analysis includes appropriate material, labour and equipment components.
2. Contingency is an allowance for uncertainty rather than a measured quantity of a known work item.
3. Salvage value is necessarily equal to the original purchase price.
Which statements are correct?

A. 1, 2 and 3
B. 1 and 2 only
C. 1 and 3 only
D. 2 only

**Reason:** Rate analysis builds unit costs; contingency covers uncertainty; salvage is residual disposal value and need not equal original cost.

### Q69 - C | Surveying and geomatics | theory

For a plane closed traverse adjusted by the Bowditch rule, coordinate corrections are distributed in proportion to:

A. The reciprocals of the side lengths
B. The squares of the latitudes only
C. The lengths of traverse sides
D. The squares of the departures only

**Reason:** The compass rule distributes both latitude and departure closure corrections in proportion to side length.

### Q70 - B | Construction planning and estimation | theory

Free float of an activity is the delay permitted without delaying:

A. Only the latest project completion date
B. The earliest start of any immediately succeeding activity
C. Its own earliest start
D. The project under all possible future changes

**Reason:** Free float protects successors' earliest starts, whereas total float concerns the project completion deadline.

### Q71 - C | Materials and construction | matching

Match each material/test pair with the measured property.
P. Vicat initial-setting test
Q. Le Chatelier test on cement
R. Aggregate impact test
S. Sieve analysis
1. Particle-size distribution; 2. Initial setting behaviour; 3. Soundness associated with expansion; 4. Resistance to sudden impact

A. P-1, Q-3, R-2, S-4
B. P-3, Q-2, R-4, S-1
C. P-2, Q-3, R-4, S-1
D. P-2, Q-4, R-3, S-1

**Reason:** Vicat assesses setting, Le Chatelier expansion/soundness, aggregate impact toughness, and sieving size distribution.

### Q72 - B | Surveying and geomatics | theory

Local attraction in compass surveying is suspected when the forward and back bearings of a line differ by an amount other than:

A. 360 degrees
B. 180 degrees
C. 45 degrees
D. 90 degrees

**Reason:** In the absence of observation error and local attraction, whole-circle forward and back bearings differ by 180 degrees.

### Q73 - C | Concrete and steel structures | theory

Which prestress loss can occur both in a pretensioned member and in a post-tensioned member after prestress transfer?

A. Friction at a curved post-tensioning duct only
B. Anchorage wedge draw-in only
C. Concrete creep
D. Slip of a temporary pretensioning bed before transfer only

**Reason:** Concrete creep causes time-dependent shortening after transfer in both systems; duct friction is specific to post-tensioning.

### Q74 - B | Surveying and geomatics | statement combination

In ordinary differential levelling, consider:
1. Sum of backsights minus sum of foresights equals last RL minus first RL.
2. An intermediate sight changes the height of instrument.
3. A change point is used to transfer elevation between instrument setups.
Which statements are correct?

A. 1, 2 and 3
B. 1 and 3 only
C. 1 only
D. 2 and 3 only

**Reason:** An intermediate sight does not establish a new setup or height of instrument; the arithmetic check and change-point role are correct.

### Q75 - A | Hydrology and irrigation | statement combination

For a linear unit-hydrograph model of a fixed catchment, consider:
1. Direct runoff ordinates scale with effective rainfall depth.
2. Hydrographs from successive effective-rainfall pulses may be superposed.
3. A 2-hour and a 6-hour unit hydrograph must have identical peak ordinates.
Which statements are correct?

A. 1 and 2 only
B. 1, 2 and 3
C. 1 and 3 only
D. 2 only

**Reason:** Linearity gives scaling and superposition; changing duration generally changes peak and shape.

### Q76 - B | Structural mechanics | short numerical

A simply supported beam of span 6 m carries a central point load of 24 kN. The maximum bending moment is:

A. 72 kN m
B. 36 kN m
C. 18 kN m
D. 144 kN m

**Reason:** Mmax=PL/4=24x6/4=36 kN m.

### Q77 - A | Construction planning and estimation | short numerical

An excavation is 12 m long, 2 m wide and uniformly 1.5 m deep. Its in-situ volume is:

A. 36 m^3
B. 24 m^3
C. 48 m^3
D. 18 m^3

**Reason:** Volume=12x2x1.5=36 m^3 before bulking or shrinkage.

### Q78 - C | Concrete and steel structures | theory

In an axially loaded tension plate with bolt holes, the net section used for rupture resistance is obtained by:

A. Using the gross area in every case
B. Adding bolt areas to the gross area
C. Deducting hole effects along the governing failure path
D. Ignoring staggered paths in every case

**Reason:** Holes reduce the effective net material; stagger corrections and the governing path must be considered.

### Q79 - B | Geotechnical engineering | short numerical

A soil has void ratio e=0.50. Its porosity is approximately:

A. 25.0%
B. 33.3%
C. 66.7%
D. 50.0%

**Reason:** n=e/(1+e)=0.5/1.5=1/3.

### Q80 - A | Surveying and geomatics | theory

A contour line joins points having equal:

A. Elevation relative to a common datum
B. Slope
C. Magnetic bearing
D. Horizontal distance from a station

**Reason:** Contours are loci of equal elevation.

### Q81 - D | Structural mechanics | statement combination

At a two-dimensional stress state under pure shear of magnitude tau, consider:
1. The principal stresses are +tau and -tau.
2. Principal planes are inclined at 45 degrees to the original planes.
3. The maximum in-plane shear stress is 2tau.
Which statements are correct?

A. 2 only
B. 1, 2 and 3
C. 1 and 3 only
D. 1 and 2 only

**Reason:** Mohr circle is centred at zero with radius tau. Principal planes rotate 45 degrees; maximum in-plane shear is tau.

### Q82 - A | Hydrology and irrigation | matching

Match each hydrologic term to its meaning.
P. Hyetograph
Q. Hydrograph
R. Isohyet
S. Flow-duration curve
1. Equal-rainfall contour; 2. Discharge against time; 3. Percentage of time a discharge is equalled or exceeded; 4. Rainfall intensity against time

A. P-4, Q-2, R-1, S-3
B. P-4, Q-2, R-3, S-1
C. P-2, Q-4, R-1, S-3
D. P-1, Q-3, R-4, S-2

**Reason:** A hyetograph describes rainfall timing, a hydrograph discharge timing, an isohyet rainfall distribution, and a duration curve exceedance frequency.

### Q83 - D | Hydrology and irrigation | theory

A unit hydrograph represents direct runoff from:

A. Unit total rainfall of any spatial distribution
B. Only groundwater runoff
C. One second of rainfall at any intensity
D. One unit depth of effective rainfall uniformly distributed over the catchment for a specified duration

**Reason:** Both unit effective rainfall depth and specified storm duration are essential to the unit-hydrograph definition.

### Q84 - A | Hydrology and irrigation | theory

The main purpose of a canal cross regulator is to:

A. Control upstream canal water level and regulate flow
B. Prevent any seepage through canal banks
C. Measure groundwater salinity
D. Remove all sediment from a reservoir

**Reason:** A cross regulator controls water level in the parent canal, assisting distribution and off-take supply.

### Q85 - B | Surveying and geomatics | short numerical

A line has whole-circle bearing 135 degrees. Its reduced bearing is:

A. S45W
B. S45E
C. N45W
D. N45E

**Reason:** A bearing between 90 and 180 degrees lies in the southeast quadrant; 180-135=45 degrees.

### Q86 - B | Concrete and steel structures | theory

An under-reinforced singly reinforced concrete beam is preferred because its flexural failure is normally preceded by:

A. Sudden concrete crushing without warning
B. Yielding of tension steel and appreciable deformation
C. Loss of all bond at service load
D. Failure of compression steel only

**Reason:** Tension steel yields before concrete reaches its ultimate compression strain, giving ductile warning.

### Q87 - D | Concrete and steel structures | matching

Match the structural phenomenon to its description.
P. Bond
Q. Creep of concrete
R. Relaxation of prestressing steel
S. Lateral-torsional buckling
1. Stress reduction at approximately constant strain; 2. Lateral movement with twist of a beam; 3. Stress transfer between steel and surrounding concrete; 4. Time-dependent strain under sustained stress

A. P-2, Q-4, R-3, S-1
B. P-3, Q-1, R-4, S-2
C. P-4, Q-3, R-1, S-2
D. P-3, Q-4, R-1, S-2

**Reason:** Bond transfers stress; creep increases strain with time; relaxation reduces stress at held strain; lateral-torsional buckling involves twist.

### Q88 - C | Construction planning and estimation | theory

For an item-rate construction contract, payment for measured work is generally based on:

A. A single fixed sum regardless of quantities
B. Only the number of workers employed
C. Executed quantities multiplied by applicable agreed unit rates
D. Only the contractor's purchase invoices

**Reason:** Measured quantities and contractual unit rates establish item payments, subject to the contract provisions.

### Q89 - C | Environmental engineering | theory

The principal purpose of coagulation in conventional surface-water treatment is to:

A. Increase turbidity deliberately
B. Convert all dissolved salts into gases
C. Destabilize fine colloidal particles
D. Replace disinfection completely

**Reason:** Coagulants destabilize colloids so that subsequent flocculation and separation can remove them.

### Q90 - C | Concrete and steel structures | short numerical

For a rectangular concrete section, b=250 mm and effective depth d=400 mm. A shear force of 100 kN gives nominal shear stress V/(bd) of:

A. 10 MPa
B. 100 MPa
C. 1.0 MPa
D. 0.1 MPa

**Reason:** 100000/(250x400)=1 N/mm^2=1 MPa.

### Q91 - B | Construction planning and estimation | short numerical

PERT estimates for an activity are optimistic=2 days, most likely=5 days and pessimistic=8 days. Expected duration is:

A. 4 days
B. 5 days
C. 8 days
D. 6 days

**Reason:** Expected duration=(a+4m+b)/6=(2+20+8)/6=5 days.

### Q92 - C | Concrete and steel structures | statement combination

For a laterally unsupported steel beam in bending, consider:
1. The compression flange can move laterally and the section can twist.
2. Adequate lateral restraint can increase lateral-torsional buckling resistance.
3. Increasing unbraced length always increases lateral-torsional buckling resistance, other factors unchanged.
Which statements are correct?

A. 2 only
B. 1, 2 and 3
C. 1 and 2 only
D. 1 and 3 only

**Reason:** Lateral-torsional buckling combines lateral deflection and twist; increasing unbraced length generally reduces resistance.

### Q93 - D | Transportation engineering | statement combination

For basic traffic-stream variables measured consistently, consider:
1. Flow equals density multiplied by space-mean speed.
2. Time-mean speed is generally at least as large as space-mean speed.
3. The arithmetic mean of individual speeds at a point is always the space-mean speed.
Which statements are correct?

A. 2 and 3 only
B. 1 only
C. 1, 2 and 3
D. 1 and 2 only

**Reason:** The fundamental relation uses space-mean speed; the arithmetic point-speed mean is time-mean speed.

### Q94 - A | Structural mechanics | short numerical

A steel bar is fully restrained against axial thermal expansion. E=200 GPa, alpha=12x10^-6 per degree C and temperature rise=25 degrees C. Ignoring buckling, the induced stress is:

A. 60 MPa compressive
B. 30 MPa compressive
C. 60 MPa tensile
D. 30 MPa tensile

**Reason:** Restrained heating induces compression of magnitude E alpha deltaT=200000x12x10^-6x25=60 MPa.

### Q95 - A | Environmental engineering | matching

Match each wastewater unit to its principal function.
P. Bar screen
Q. Grit chamber
R. Primary clarifier
S. Aeration tank in activated sludge
1. Biological oxidation; 2. Removal of coarse floating debris; 3. Gravity removal of settleable solids; 4. Removal of dense mineral particles

A. P-2, Q-4, R-3, S-1
B. P-4, Q-2, R-3, S-1
C. P-2, Q-3, R-4, S-1
D. P-1, Q-4, R-2, S-3

**Reason:** Screening removes coarse matter, grit chambers dense mineral grit, primary settling settleable solids, and aeration supports biological oxidation.

### Q96 - B | Environmental engineering | theory

If a wastewater sample is diluted for a BOD test, which feature is necessary for an interpretable oxygen-depletion result?

A. A bottle open to the atmosphere throughout incubation
B. Adequate initial dissolved oxygen and measurable residual oxygen after incubation
C. No correction even when a seeded dilution blank consumes oxygen
D. Complete oxygen depletion in every bottle

**Reason:** The result requires adequate oxygen depletion while retaining residual DO, with applicable blank and seed corrections.

### Q97 - B | Surveying and geomatics | theory

Balancing backsight and foresight distances in differential levelling chiefly reduces the effect of:

A. Wrong benchmark identification
B. Collimation error and approximately equal curvature/refraction effects
C. Staff-reading blunders of any magnitude
D. All benchmark settlement

**Reason:** Equal sight lengths cancel errors that depend similarly on sight distance; they do not cure blunders or datum errors.

### Q98 - D | Structural mechanics | theory

For a linearly elastic prismatic beam in pure bending, the neutral axis passes through the:

A. Top fibre
B. Point of maximum tensile stress
C. Shear centre only
D. Centroid of the cross-section

**Reason:** With zero axial force, the integral of bending stress over the section vanishes at the centroidal axis.

### Q99 - D | Concrete and steel structures | short numerical

For a reinforcing bar, use Ld=phi sigma_s/(4 tau_bd). If phi=16 mm, sigma_s=300 MPa and tau_bd=1.5 MPa, Ld is:

A. 1200 mm
B. 400 mm
C. 600 mm
D. 800 mm

**Reason:** Ld=16x300/(4x1.5)=800 mm.

### Q100 - B | Surveying and geomatics | statement combination

For conventional map contours of ordinary terrain without overhangs, consider:
1. Close spacing indicates a steep slope.
2. Widely spaced contours indicate a gentle slope.
3. Distinct-elevation contours normally intersect each other.
Which statements are correct?

A. 2 only
B. 1 and 2 only
C. 1, 2 and 3
D. 1 and 3 only

**Reason:** For a fixed contour interval, slope increases as horizontal contour spacing decreases; ordinary contours of different elevations do not cross.
