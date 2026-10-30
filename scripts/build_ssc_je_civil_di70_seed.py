"""Build the original SSC JE Civil DI-70 mock seed and editorial review files."""
import json
import random
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TITLE = "Junior Engineer Civil Paper I - Difficulty Index 70"
DESCRIPTION = (
    "Unofficial original 200-question SSC JE Paper-I-style Civil practice mock. "
    "Difficulty Index 70% is an editorial target: 80 Moderate and 120 Hard items. "
    "Sections: 50 Reasoning, 50 General Awareness, 100 Civil and Structural. "
    "Civil section: 75 theory/concept/application and 25 short numericals. "
    "Practice scoring: +1 correct, -0.25 incorrect, 0 unanswered; 120 minutes."
)

def item(text, options, answer, reason, topic, kind="theory"):
    return {
        "question_text": text,
        "options": options,
        "correct_answer": answer,
        "rationale": reason,
        "topic": topic,
        "type": kind,
    }

# Entries are independently authored. Difficulty is assigned by the ordered
# blueprint below, not inferred from wording or presented as a psychometric score.
REASONING = [
 item("Find the next term: 5, 11, 23, 47, 95, ?", ["181","189","191","193"], "C", "Each term is twice the previous term plus 1; 95×2+1=191.", "Number series"),
 item("Find the next letter: C, F, J, O, U, ?", ["A","B","C","D"], "B", "The forward gaps are +3,+4,+5,+6; the next is +7, wrapping after Z to B.", "Letter series"),
 item("In a code, the letters of a word are written in reverse order. How is BRIDGE written?", ["EGDIRB","EGDIBR","BRIDGE","EGDIRG"], "A", "Reversing the sequence of letters in BRIDGE gives EGDIRB.", "Coding-decoding"),
 item("A worker walks 7 m east, 4 m north, and 7 m west. Where is the worker relative to the starting point?", ["4 m north","4 m south","7 m east","11 m north"], "A", "The east and west movements cancel, leaving a 4 m north displacement.", "Direction sense"),
 item("Five students are ranked by score. J scored above K but below M; L scored below K; and N scored above M. Who must rank above J?", ["K only","M and N","L and K","N only"], "B", "The relations give N>M>J>K>L; both M and N must rank above J.", "Ranking"),
 item("All culverts are structures. No structure in the set is temporary. Which conclusion follows?", ["All culverts are temporary","No culvert is temporary","Some temporary items are culverts","No culvert is a structure"], "B", "Culverts are a subset of structures, and the stated sets of structures and temporary items do not overlap.", "Syllogism"),
 item("Three number pairs follow the same rule. Which pair breaks the rule?", ["3:10","5:26","7:50","9:80"], "D", "The rule is n mapped to n²+1: 3²+1=10, 5²+1=26 and 7²+1=50, while 9²+1=82.", "Classification"),
 item("If 8 identical pumps empty a tank in 15 hours, how long would 12 such pumps take at the same rate?", ["8 hours","10 hours","12 hours","22.5 hours"], "B", "Work is constant: 8×15=120 pump-hours; 120/12=10 hours.", "Work and time", "numerical"),
 item("At what time between 2 and 3 o'clock do the hour and minute hands first overlap?", ["2:10 10/11","2:10 5/11","2:12","2:15"], "A", "At 2:10 10/11, the minute hand has caught up with the hour hand; the standard overlap time is 2×60/11 minutes after 2.", "Clock"),
 item("Which number replaces the question mark? 2, 6, 12, 20, 30, ?", ["40","41","42","44"], "C", "Terms are n(n+1) for n=1,2,3,…; the next is 6×7=42.", "Number series"),
 item("R is the brother of S. S is the daughter of T. T is the wife of U. How is U related to R?", ["Father","Maternal uncle","Brother","Grandfather"], "A", "T is R's mother and U is T's husband, so U is R's father.", "Blood relations"),
 item("Choose the pair that follows the same rule as 6:42.", ["5:31","7:49","8:72","9:90"], "C", "The second number is n(n+1); for 8, 8×9=72.", "Analogy"),
 item("A code replaces each letter with the letter two places ahead in the alphabet. What is the code for FROG?", ["HTQI","GSPH","HTQJ","HSPJ"], "A", "F→H, R→T, O→Q and G→I, giving HTQI.", "Coding-decoding"),
 item("Four files P, Q, R and S are arranged left to right. P is left of Q, R is right of Q, and S is left of P. Which file is second from the left?", ["P","Q","R","S"], "A", "The constraints give S–P–Q–R; P is second.", "Ordering"),
 item("Select the missing pair: AZ, BY, CX, DW, ?", ["EU","EV","FV","EW"], "B", "The first letters advance and the second letters retreat: E pairs with V.", "Letter pattern"),
 item("A number is increased by 20% and then decreased by 20%. What is the net result?", ["No change","4% decrease","4% increase","2% decrease"], "B", "For an initial 100, the result is 120×0.8=96, a 4% decrease.", "Percentages", "numerical"),
 item("In the series A, C, F, J, O, ?, each step advances by one more letter than the previous step. What is the next letter?", ["T","U","V","W"], "B", "The gaps are +2,+3,+4,+5; the next gap is +6, taking O to U.", "Letter series"),
 item("A is taller than B. C is shorter than B, and D is taller than A. Who is the shortest?", ["A","B","C","D"], "C", "C is shorter than B, which is shorter than A and D.", "Comparison"),
 item("A, B and C complete a job in 12 days together. At equal individual rates, how many days would 6 such workers take?", ["4 days","6 days","8 days","18 days"], "B", "The total work is 3×12=36 worker-days; 36/6=6 days.", "Work and time", "numerical"),
 item("Which term is different from the other three?", ["Kilometre","Metre","Litre","Centimetre"], "C", "Litre measures volume; the others are units of length.", "Classification"),
 item("Find the next term: 3, 8, 18, 38, 78, ?", ["148","156","158","160"], "C", "Each term is twice the previous term plus 2; 78×2+2=158.", "Number series"),
 item("If ENGINE is coded by shifting each letter one place backwards, what is the code?", ["DMFHMD","DMFJMD","FNHJOF","DMFINE"], "A", "E→D, N→M, G→F, I→H, N→M, E→D.", "Coding-decoding"),
 item("A person faces north, turns 135° clockwise and then 90° anticlockwise. Which direction are they facing?", ["North-east","East","South-east","South"], "A", "Net turn is 45° clockwise from north, which is north-east.", "Direction sense"),
 item("In a queue of 42 people, K is 13th from the front. What is K's position from the back?", ["28th","29th","30th","31st"], "C", "Position from back = 42−13+1=30.", "Ranking"),
 item("Some bridges are steel. All steel objects conduct electricity. Which conclusion must follow?", ["All bridges conduct electricity","Some bridges conduct electricity","No bridges conduct electricity","Some conductors are not steel"], "B", "The bridges that are steel are members of the steel set, all of which conduct electricity.", "Syllogism"),
 item("Find the next number: 1, 4, 10, 22, 46, ?", ["88","90","92","94"], "D", "The rule is ×2+2, giving 46×2+2=94.", "Number series"),
 item("If a word's value is the sum of its letters' alphabet positions, what is the value of CIVIL?", ["50","52","55","57"], "C", "C(3)+I(9)+V(22)+I(9)+L(12)=55.", "Letter coding"),
 item("An operation is defined by a # b = 2a + b. What is the value of 7 # 5?", ["17","19","21","24"], "B", "Substitute a=7 and b=5: 2×7+5=19.", "Defined operations", "numerical"),
 item("Which number does not fit: 8, 27, 64, 100, 125?", ["27","64","100","125"], "C", "8, 27, 64 and 125 are consecutive cubes; 100 is not a cube.", "Classification"),
 item("If 3 March is a Monday, what day is 24 March in the same year?", ["Sunday","Monday","Tuesday","Wednesday"], "B", "The dates are 21 days apart, exactly three weeks.", "Calendar"),
 item("In a certain arrangement, every consonant is replaced by the next letter and every vowel by the previous letter. How is ROAD written?", ["SNZE","SPBC","SPAD","SQAD"], "A", "R→S, O→N, A→Z, D→E, giving SNZE.", "Coding-decoding"),
 item("Select the number that completes the sequence: 2, 5, 11, 23, 47, ?", ["91","93","95","97"], "C", "Each term is double the previous term plus 1; 47×2+1=95.", "Number series"),
 item("A is the mother of B. C is the father of A. D is the only sister of B. How is C related to D?", ["Paternal grandfather","Maternal grandfather","Uncle","Father"], "B", "C is the father of D's mother, so C is D's maternal grandfather.", "Blood relations"),
 item("A, B, C, D and E are ranked. A is above C; C is above E; B is above A; D is below E. Who ranks highest?", ["A","B","C","D"], "B", "The relations imply B>A>C>E>D.", "Ordering"),
 item("A two-digit number has digit sum 12. Reversing its digits increases the number by 18. What is the original number?", ["57","75","48","84"], "A", "Let tens digit x and units y. x+y=12 and 9(y−x)=18; hence y−x=2, x=5 and y=7.", "Digit reasoning", "numerical"),
 item("Find the next pair: BC, EF, HI, KL, ?", ["MN","NO","OP","PQ"], "B", "Each pair uses consecutive letters, with a two-letter jump between the pair starts; next is NO.", "Letter series"),
 item("A is east of B. C is north of A. D is west of C and directly north of B. Where is D relative to B?", ["North","North-east","East","Cannot be determined"], "A", "D is stated to lie directly north of B.", "Direction sense"),
 item("If all X are Y and no Y are Z, which statement is necessarily true?", ["Some X are Z","No X are Z","All Z are X","Some Y are X"], "B", "X is wholly inside Y, and Y does not overlap Z; therefore X cannot overlap Z.", "Syllogism"),
 item("Find the next term: 6, 13, 27, 55, 111, ?", ["219","221","223","225"], "C", "The terms follow ×2+1, so 111×2+1=223.", "Number series"),
 item("A 150 m train passes a stationary signal in 10 seconds. What is its speed in km/h?", ["45","50","54","60"], "C", "Speed=150/10=15 m/s; 15×3.6=54 km/h.", "Speed and distance", "numerical"),
 item("If each letter is replaced with its opposite in the alphabet (A↔Z, B↔Y, …), what does DOG become?", ["WLT","WOG","VLT","XLT"], "A", "D↔W, O↔L and G↔T, giving WLT.", "Coding-decoding"),
 item("Select the odd pair.", ["2:8","3:27","4:64","5:100"], "D", "The first three are n:n³; 5³ is 125, not 100.", "Analogy"),
 item("A clock is set correctly at 8:00 a.m. It loses 4 minutes every 2 hours. What time will it show at 8:00 p.m. that day?", ["7:24 p.m.","7:36 p.m.","7:40 p.m.","8:24 p.m."], "B", "Over 12 real hours it loses 6×4=24 minutes, so it displays 7:36 p.m.", "Clock", "numerical"),
 item("Find the next term: 4, 9, 19, 39, 79, ?", ["149","157","159","161"], "C", "Each term is twice the previous term plus 1; 79×2+1=159.", "Number series"),
 item("In a group of 60, 32 study surveying, 28 study structures and 12 study both. How many study neither?", ["8","10","12","14"], "C", "At least one =32+28−12=48; neither=60−48=12.", "Set reasoning", "numerical"),
 item("The symbols mean P@Q: P>Q; P#Q: P=Q; P$Q: P<Q. Given A@B, B#C and C$D, which relation is definitely true?", ["A>C","A>D","D>A","B>D"], "A", "A>B and B=C, therefore A>C. Since D is only known to exceed C, A and D cannot be compared.", "Symbol logic"),
 item("Find the missing term: 2, 3, 5, 9, 17, ?", ["31","32","33","34"], "C", "Successive increments are 1,2,4,8, so the next increment is 16; 17+16=33.", "Number series"),
 item("Six people sit in a row. L is immediately left of M; N is immediately right of M; P is left of L. Which must be true?", ["P is left of M","N is left of L","M is left of P","L is right of N"], "A", "The fixed local order is P–L–M–N, so P is left of M.", "Ordering"),
 item("A can finish a task in 12 days and B in 18 days. Working together at constant rates, how many days do they need?", ["6 days","7.2 days","8 days","9 days"], "B", "Combined daily rate is 1/12+1/18=5/36; time=36/5=7.2 days.", "Work and time", "numerical"),
 item("A tank is half full. After 30 L is removed, it is one-third full. What is the tank's capacity?", ["120 L","150 L","180 L","210 L"], "C", "The change from one-half to one-third is one-sixth of capacity; capacity=30×6=180 L.", "Fractions and proportional reasoning", "numerical"),
]

GA = [
 item("Which Schedule of the Constitution of India provides for allocation of seats in the Council of States?", ["Second Schedule","Third Schedule","Fourth Schedule","Fifth Schedule"], "C", "The Fourth Schedule provides for allocation of seats in the Rajya Sabha.", "Indian polity"),
 item("The right to move the Supreme Court for enforcement of Fundamental Rights is guaranteed by:", ["Article 21","Article 25","Article 32","Article 40"], "C", "Article 32 guarantees the right to move the Supreme Court for enforcement of Fundamental Rights.", "Indian polity"),
 item("A Money Bill can be introduced only in which House of Parliament?", ["Rajya Sabha","Lok Sabha","Either House","A joint sitting"], "B", "The Constitution requires a Money Bill to be introduced only in the Lok Sabha.", "Indian polity"),
 item("Who is the ex-officio Chairperson of the Rajya Sabha?", ["President of India","Vice-President of India","Prime Minister","Speaker of Lok Sabha"], "B", "The Vice-President of India is the ex-officio Chairman of the Rajya Sabha.", "Indian polity"),
 item("Fundamental Duties are listed in which Article of the Constitution?", ["Article 32","Article 51A","Article 280","Article 368"], "B", "Article 51A enumerates the Fundamental Duties.", "Indian polity"),
 item("The Union Public Service Commission and State Public Service Commissions are provided for under which constitutional Article?", ["Article 148","Article 280","Article 315","Article 324"], "C", "Article 315 provides for a Union Public Service Commission and Public Service Commissions for the States.", "Indian polity"),
 item("The power of judicial review in India is exercised by:", ["Only Parliament","Only the Election Commission","The Supreme Court and High Courts","The Finance Commission"], "C", "Constitutional courts may review laws and executive action for constitutional validity.", "Indian polity"),
 item("Which is the largest state of India by area?", ["Madhya Pradesh","Maharashtra","Rajasthan","Uttar Pradesh"], "C", "Rajasthan is India's largest state by geographical area.", "Indian geography"),
 item("The Tropic of Cancer passes through which Indian state?", ["Kerala","Jharkhand","Punjab","Himachal Pradesh"], "B", "The Tropic of Cancer crosses Jharkhand, among other Indian states.", "Indian geography"),
 item("Which river forms the Dhuandhar Falls near Jabalpur?", ["Tapi","Mahanadi","Narmada","Chambal"], "C", "Dhuandhar Falls are formed by the Narmada River near Jabalpur in Madhya Pradesh.", "Indian geography"),
 item("The Palghat Gap is a major pass through which mountain range?", ["Aravalli Range","Western Ghats","Eastern Ghats","Shivalik Range"], "B", "The Palghat (Palakkad) Gap is a major break in the Western Ghats between Kerala and Tamil Nadu.", "Indian geography"),
 item("Which is the highest peak in the Western Ghats?", ["Doddabetta","Anamudi","Agastya Mala","Kalsubai"], "B", "Anamudi, in Kerala, is the highest peak in the Western Ghats.", "Indian geography"),
 item("The Indian Standard Meridian is:", ["68°7′ E","75° E","82°30′ E","90° E"], "C", "Indian Standard Time is based on the 82°30′ east longitude meridian.", "Indian geography"),
 item("The Siachen Glacier lies in which mountain range?", ["Aravalli","Karakoram","Western Ghats","Pir Panjal"], "B", "Siachen Glacier is in the eastern Karakoram range.", "Indian geography"),
 item("Which of the following is a west-flowing river that drains into the Arabian Sea?", ["Godavari","Krishna","Narmada","Mahanadi"], "C", "The Narmada flows west through a rift valley and enters the Arabian Sea.", "Indian geography"),
 item("The Battle of Plassey was fought in:", ["1757","1761","1764","1773"], "A", "The Battle of Plassey took place in 1757.", "Indian history"),
 item("The Dandi March of 1930 was launched to protest the British:", ["Partition of Bengal","Salt laws","Rowlatt Act","Vernacular Press Act"], "B", "Gandhi's march to Dandi challenged the colonial salt monopoly and tax.", "Indian history"),
 item("The Vernacular Press Act was enacted in 1878 during the viceroyalty of:", ["Lord Ripon","Lord Lytton","Lord Curzon","Lord Canning"], "B", "The Vernacular Press Act of 1878 was enacted during Lord Lytton's viceroyalty.", "Indian history"),
 item("The Quit India Movement was launched in:", ["1919","1929","1930","1942"], "D", "The Congress launched the Quit India Movement in August 1942.", "Indian history"),
 item("The Permanent Settlement of Bengal is associated with:", ["Lord Cornwallis","Lord Dalhousie","Warren Hastings","Lord Curzon"], "A", "Cornwallis introduced the Permanent Settlement in Bengal in 1793.", "Indian history"),
 item("Which gas is released as a major product of photosynthesis?", ["Carbon dioxide","Oxygen","Nitrogen","Methane"], "B", "Oxygen is released when water is split during photosynthesis.", "General science"),
 item("The heating effect of electric current is the operating principle of a:", ["Electric fuse","Photovoltaic cell","Transformer core","Permanent magnet"], "A", "A fuse element melts when current heating raises it beyond its rated temperature, opening the circuit.", "General science"),
 item("Which vitamin is synthesized in human skin on exposure to ultraviolet radiation?", ["Vitamin A","Vitamin C","Vitamin D","Vitamin K"], "C", "UVB exposure enables the skin to synthesize vitamin D precursors.", "General science"),
 item("At standard atmospheric pressure, pure water boils at:", ["0°C","50°C","100°C","212°C"], "C", "The normal boiling point of pure water is 100°C at 1 atmosphere.", "General science"),
 item("Which blood cells are primarily responsible for oxygen transport?", ["Platelets","Red blood cells","Lymphocytes","Monocytes"], "B", "Haemoglobin in red blood cells binds and transports most blood oxygen.", "General science"),
 item("The pH of a neutral aqueous solution at 25°C is approximately:", ["0","5","7","14"], "C", "At 25°C, neutral water has equal hydrogen and hydroxide ion activities and pH about 7.", "General science"),
 item("Which instrument records ground vibrations produced by an earthquake?", ["Seismograph","Calorimeter","Hydrometer","Spectrometer"], "A", "A seismograph records ground motion associated with earthquakes.", "General science"),
 item("Which non-metal is liquid at ordinary room temperature?", ["Iodine","Bromine","Sulphur","Phosphorus"], "B", "Bromine is a non-metal that is liquid at ordinary room temperature.", "General science"),
 item("A convex lens brings parallel rays of light to a:", ["Virtual focus on the incident side","Real focus on the opposite side","Point at infinity","Principal axis only"], "B", "A converging convex lens focuses parallel paraxial rays at a real principal focus on the far side.", "General science"),
 item("Which cell organelle is the principal site of aerobic respiration?", ["Ribosome","Mitochondrion","Golgi apparatus","Lysosome"], "B", "Mitochondria host the principal stages of aerobic ATP production.", "General science"),
 item("The ozone layer that absorbs much of the Sun's ultraviolet radiation is concentrated in the:", ["Troposphere","Stratosphere","Mesosphere","Thermosphere"], "B", "Most atmospheric ozone is concentrated in the stratosphere.", "Environment"),
 item("Which gas is the principal anthropogenic contributor to long-lived radiative forcing by volume of emissions?", ["Carbon dioxide","Argon","Neon","Hydrogen"], "A", "Carbon dioxide is a major long-lived greenhouse gas emitted through fossil-fuel use and land-use change.", "Environment"),
 item("A food chain usually has the greatest available energy at the level of:", ["Primary producers","Primary consumers","Secondary consumers","Top predators"], "A", "Energy is lost at each trophic transfer, so producers contain the greatest initial energy.", "Environment"),
 item("The Convention on Biological Diversity was opened for signature at the:", ["Stockholm Conference, 1972","Rio Earth Summit, 1992","Kyoto Conference, 1997","Paris Conference, 2015"], "B", "The Convention on Biological Diversity was adopted and opened for signature at the 1992 Rio Earth Summit.", "Environment"),
 item("Which gas is a principal cause of acid rain when emitted from combustion sources?", ["Sulphur dioxide","Oxygen","Helium","Hydrogen"], "A", "Sulphur dioxide can oxidize and form sulphuric acid in atmospheric moisture.", "Environment"),
 item("The Chipko movement is most closely associated with:", ["Forest conservation","Coastal fishing rights","Urban transport","River navigation"], "A", "The movement became known for community action to protect trees and forests.", "Environment"),
 item("Which organization publishes the Human Development Report?", ["World Bank","UN Development Programme","World Trade Organization","International Labour Organization"], "B", "The Human Development Report is published by the United Nations Development Programme.", "International organisations"),
 item("The headquarters of the World Health Organization is in:", ["Geneva","Paris","New York","Rome"], "A", "WHO's headquarters is in Geneva, Switzerland.", "International organisations"),
 item("The currency of Japan is the:", ["Won","Yuan","Yen","Ringgit"], "C", "Japan's currency is the yen.", "World geography"),
 item("The headquarters of the International Court of Justice is located in:", ["Geneva","The Hague","Vienna","Brussels"], "B", "The ICJ is based at the Peace Palace in The Hague, Netherlands.", "International organisations"),
 item("The main asteroid belt of the Solar System lies predominantly between the orbits of:", ["Earth and Mars","Mars and Jupiter","Jupiter and Saturn","Saturn and Uranus"], "B", "Most main-belt asteroids orbit between Mars and Jupiter.", "Astronomy"),
 item("Which Indian classical dance form originated in Kerala and is known for elaborate facial expression and makeup?", ["Kathak","Bharatanatyam","Kathakali","Odissi"], "C", "Kathakali is a classical dance-drama tradition from Kerala, known for stylized expression and makeup.", "Culture"),
 item("The Ajanta caves are especially renowned for their ancient:", ["Buddhist paintings and sculpture","Mughal miniature paintings","Chola bronze workshops","Rock-cut Jain temples only"], "A", "Ajanta is celebrated for Buddhist cave architecture, murals and sculpture.", "Culture"),
 item("Which instrument is used to measure relative humidity?", ["Hygrometer","Barometer","Calorimeter","Potentiometer"], "A", "A hygrometer measures humidity in air.", "General science"),
 item("The law of conservation of mass in a chemical reaction states that, in a closed system:", ["Mass is created","Total mass remains constant","Atoms disappear","Volume must remain constant"], "B", "Chemical reactions rearrange matter; the total mass of a closed system is conserved.", "General science"),
 item("Which Indian institution is primarily responsible for issuing currency notes, except the one-rupee note?", ["State Bank of India","Reserve Bank of India","Ministry of Commerce","NITI Aayog"], "B", "The Reserve Bank of India issues banknotes, while the Government of India issues the one-rupee note.", "Indian economy"),
 item("The Green Revolution in India is most strongly associated with increased production of:", ["Wheat and rice","Tea and coffee","Cotton and jute","Pulses only"], "A", "High-yielding varieties and associated inputs sharply increased wheat and rice output.", "Indian economy"),
 item("Which fundamental right is protected by Article 21 of the Constitution?", ["Freedom of religion","Protection of life and personal liberty","Equality of opportunity in public employment","Right to constitutional remedies"], "B", "Article 21 states that no person shall be deprived of life or personal liberty except according to procedure established by law.", "Indian polity"),
 item("Under the Constitution, the Rajya Sabha can have a maximum of how many members?", ["238","245","250","252"], "C", "Article 80 provides for a maximum of 250 members, including nominated members.", "Indian polity"),
 item("The SI unit of frequency is the:", ["Joule","Hertz","Newton","Pascal"], "B", "Frequency is measured in hertz, equivalent to one cycle per second.", "General science"),
]

CIVIL = [
 item("In a well-graded aggregate, the particle-size distribution is characterized by:", ["A wide range of particle sizes with relatively few voids","Particles all of one size","Only fine particles","A gap in every intermediate size"], "A", "A well-graded aggregate contains a broad, continuous range of sizes that packs efficiently and reduces void space.", "Building materials"),
 item("The principal purpose of seasoning timber before use is to:", ["Reduce its moisture content to a suitable level","Increase sap content","Convert all sapwood to heartwood","Remove every knot"], "A", "Seasoning reduces moisture, improving dimensional stability and serviceability; it does not eliminate all natural defects.", "Building materials"),
 item("A concrete cube is tested in compression at 28 days. If its failure load is 600 kN and loaded face area is 150,000 mm², its compressive strength is:", ["2 MPa","4 MPa","6 MPa","9 MPa"], "B", "Stress=600,000 N/150,000 mm²=4 N/mm²=4 MPa.", "Concrete testing", "numerical"),
 item("In a cavity wall, the air space between the outer and inner leaves primarily helps to:", ["Interrupt moisture transfer and improve thermal resistance","Increase the wall's direct compressive stress","Replace wall ties","Carry the floor loads without lintels"], "A", "The cavity reduces direct transfer of rainwater and heat between the leaves; suitable ties and drainage details are still needed.", "Building construction"),
 item("Which constituent of ordinary Portland cement contributes most to early strength development?", ["Tricalcium silicate (C3S)","Dicalcium silicate (C2S)","Tetracalcium aluminoferrite (C4AF)","Gypsum"], "A", "C3S hydrates relatively rapidly and contributes substantially to early strength.", "Cement"),
 item("For a nominal cement:sand mortar mix of 1:4 by volume, which statement correctly describes the proportion?", ["One measured volume of cement is combined with four measured volumes of sand","Four volumes of cement are combined with one volume of sand","The mix contains equal cement and sand volumes","The ratio is by mass unless the aggregate is dry"], "A", "A 1:4 volumetric proportion means one volume of cement to four volumes of sand; it does not by itself specify a mass ratio.", "Building materials"),
 item("The soundness test of cement primarily assesses its resistance to:", ["Excessive delayed expansion after setting","Loss of colour during storage","Abrasion in a road surface","Segregation of coarse aggregate"], "A", "Soundness indicates whether cement undergoes unacceptable delayed expansion, often associated with excess free lime or magnesia.", "Cement"),
 item("For a given cement content and aggregate system, an excessively high water-cement ratio generally causes:", ["Lower strength and greater permeability","Higher strength and zero shrinkage","No change in durability","Immediate prevention of hydration"], "A", "Excess mixing water leaves capillary pores after hardening, typically reducing strength and increasing permeability.", "Concrete technology"),
 item("The nominal size of coarse aggregate refers to the:", ["Approximate sieve size associated with the aggregate's upper size limit","Mean size of every particle","Smallest particle present","Size of the cement grains"], "A", "Nominal maximum size is an upper grading descriptor used in specifying coarse aggregate; it does not mean all particles are identical.", "Building materials"),
 item("A concrete member is vibrated for an adequate period. The primary intended effect is to:", ["Expel entrapped air and compact the concrete","Increase the water-cement ratio","Cause deliberate segregation","Replace curing"], "A", "Proper vibration consolidates fresh concrete by removing entrapped air; over-vibration can instead cause segregation.", "Concrete construction"),

 item("In a building estimate, plastering of a wall is ordinarily measured by:", ["Square metre","Cubic metre","Kilogram","Litre"], "A", "Plastering is a surface finish and is ordinarily quantified by area.", "Estimating"),
 item("In levelling, the backsight at a benchmark of RL 100.000 m is 1.250 m. What is the height of instrument?", ["98.750 m","100.000 m","101.250 m","102.500 m"], "C", "Height of instrument = benchmark RL + backsight = 100.000+1.250=101.250 m.", "Surveying", "numerical"),
 item("In chain surveying, a check line is mainly provided to:", ["Test the accuracy of the framework and field measurements","Locate every contour point","Measure magnetic declination","Replace all tie lines"], "A", "A check line gives an independent check on the accuracy of the triangular framework.", "Surveying"),
 item("A map has a representative fraction of 1:2,000. A ground distance of 80 m is represented by:", ["2 cm","4 cm","8 cm","16 cm"], "B", "80 m is 8,000 cm; 8,000/2,000=4 cm on the map.", "Surveying", "numerical"),
 item("In plane-table surveying, an alidade is used primarily to:", ["Sight an object and draw its direction","Measure the staff intercept","Determine magnetic dip","Measure a vertical angle electronically"], "A", "The alidade provides a sighting edge for orienting and drawing rays to plotted points.", "Surveying"),
 item("In levelling, a turning point is selected primarily to:", ["Transfer the level from one instrument setup to the next","Measure a magnetic bearing","Replace the benchmark","Determine the chain length"], "A", "A turning point is a stable point on which a foresight and subsequent backsight are taken when shifting the level.", "Surveying"),
 item("The reduced level of a point determined by the height-of-instrument method is:", ["Height of instrument minus staff reading","Height of instrument plus staff reading","Staff reading minus height of instrument","Backsight minus foresight only"], "A", "For a point observed from the setup, RL = HI − staff reading.", "Surveying"),
 item("In a closed traverse, the algebraic sum of the latitude components should ideally be:", ["Zero","Equal to the perimeter","Equal to the total number of stations","Twice the northing"], "A", "A closed traverse returns to its starting point, so its net north-south displacement is zero.", "Surveying"),
 item("When levelling across an obstacle where equal backsight and foresight lengths are impractical, reciprocal levelling is used chiefly to reduce error due to:", ["Collimation, curvature and refraction","Magnetic declination only","Incorrect chain length","Staff graduation alone"], "A", "Reciprocal observations from opposite banks help cancel collimation error and reduce curvature and refraction effects.", "Surveying"),
 item("The principal purpose of a contour line on a topographic map is to join points of:", ["Equal elevation","Equal horizontal distance from the map edge","Equal soil density","Equal rainfall"], "A", "A contour joins points having the same reduced level or elevation.", "Surveying"),

 item("Compared with coarse sand, a fine-grained soil generally permits greater capillary rise because its pores are:", ["Smaller, producing greater capillary suction","Larger, producing less surface tension","Completely disconnected","Filled only with air"], "A", "Smaller pore radii produce greater capillary rise, although the rate of rise is slower in fine soils.", "Soil mechanics"),
 item("A saturated soil has total vertical stress 180 kPa and pore-water pressure 65 kPa. Its effective vertical stress is:", ["65 kPa","115 kPa","180 kPa","245 kPa"], "B", "σ′=σ−u=180−65=115 kPa.", "Soil mechanics", "numerical"),
 item("The liquid limit of a soil is the water content at the boundary between the:", ["Liquid and plastic states","Plastic and semi-solid states","Semi-solid and solid states","Dry and saturated states"], "A", "The liquid limit separates the liquid and plastic consistency states.", "Soil classification"),
 item("For a normally consolidated clay, the preconsolidation pressure is approximately:", ["Less than current effective overburden pressure","Equal to current effective overburden pressure","Greater than current effective overburden pressure","Independent of overburden history"], "B", "Normally consolidated soil has not experienced a past effective pressure greater than its current effective overburden pressure.", "Soil mechanics"),
 item("A soil sample has wet mass 180 g and dry mass 150 g. Its water content is:", ["15%","20%","30%","33.3%"], "B", "Water mass=30 g; water content=30/150×100=20%.", "Soil mechanics", "numerical"),
 item("The coefficient of permeability of a soil is most directly associated with its ability to:", ["Transmit water through interconnected voids","Resist particle crushing","Store heat","Develop cohesion under dry conditions"], "A", "Permeability describes the ease with which water flows through soil pores.", "Soil mechanics"),
 item("The degree of saturation of a soil is defined as the ratio of:", ["Volume of water to volume of voids","Volume of voids to volume of solids","Mass of water to total mass","Volume of solids to total volume"], "A", "Degree of saturation Sr=Vw/Vv; it ranges from zero for dry soil to one for fully saturated soil.", "Soil phase relations"),
 item("A saturated soil has void ratio 0.6. Its porosity is:", ["0.30","0.375","0.60","0.625"], "B", "n=e/(1+e)=0.6/1.6=0.375.", "Soil mechanics", "numerical"),
 item("The standard Proctor compaction test is used to determine the relationship between:", ["Dry density and water content at a specified compactive effort","Permeability and hydraulic gradient only","Plasticity index and liquid limit","Shear strength and elapsed time only"], "A", "The compaction curve gives dry density versus water content for a specified compactive effort, including maximum dry density and optimum moisture content.", "Soil compaction"),
 item("For a shallow foundation on cohesionless soil, increasing footing width can increase the bearing-capacity contribution associated with:", ["The soil unit-weight term, which includes footing width","The cohesion term, even when cohesion is zero","Eliminating settlement checks","Removing groundwater effects"], "A", "In classical bearing-capacity formulations the unit-weight term is proportional to footing width; settlement and groundwater effects still require consideration.", "Foundations"),

 item("In an ideal-flow energy equation, the sum of pressure head, velocity head and elevation head is constant along a streamline when:", ["The flow is steady, incompressible and losses and shaft work are negligible","The pipe is rough and all head losses are ignored","The fluid is at rest and has no pressure","The flow is unsteady and heat is added"], "A", "Bernoulli's equation applies between points on a streamline under the stated ideal assumptions, with no pump/turbine work or appreciable losses.", "Fluid mechanics"),
 item("Water flows at 2 m/s through a pipe of area 0.03 m². Its discharge is:", ["0.015 m³/s","0.06 m³/s","0.6 m³/s","1.5 m³/s"], "B", "Q=AV=2×0.03=0.06 m³/s.", "Fluid mechanics", "numerical"),
 item("In a venturimeter, the throat pressure is lower than the upstream pressure during forward flow primarily because:", ["Velocity increases as the flow area contracts","The fluid becomes compressible","The throat area is larger","Elevation is always higher at the throat"], "A", "Continuity raises velocity in the smaller throat; Bernoulli's relation associates this with lower static pressure.", "Hydraulics"),
 item("The hydraulic gradient line (HGL) at a section of a pipe represents:", ["Pressure head plus elevation head","Velocity head plus pressure head","Total energy head including velocity head","Friction head alone"], "A", "HGL is z+p/γ; the energy grade line additionally includes velocity head.", "Hydraulics"),
 item("A pump delivers 0.04 m³/s against a head of 10 m. Taking water unit weight as 9.81 kN/m³, the hydraulic power is approximately:", ["0.39 kW","3.92 kW","39.2 kW","392 kW"], "B", "P=γQH=9.81×0.04×10=3.924 kW.", "Fluid machinery", "numerical"),
 item("For a hydraulic jump in a rectangular channel, the flow changes from:", ["Supercritical to subcritical","Subcritical to supercritical","Laminar to inviscid","Uniform to zero discharge"], "A", "A hydraulic jump is an abrupt transition from supercritical to subcritical flow, with energy dissipation.", "Open-channel flow"),
 item("For a small orifice discharging under a constant head, Torricelli's ideal velocity is:", ["√(2gH)","gH²","2g/H","H/(2g)"], "A", "From Bernoulli's equation with negligible losses, exit velocity v=√(2gH).", "Hydraulics"),
 item("An ideal jet issues under a head of 5 m. Taking g=10 m/s², its velocity is:", ["5 m/s","10 m/s","15 m/s","20 m/s"], "B", "v=√(2gH)=√(2×10×5)=√100=10 m/s.", "Hydraulics", "numerical"),
 item("For fully developed laminar flow in a circular pipe, the Darcy-Weisbach friction factor is:", ["16/Re","32/Re","64/Re","Re/64"], "C", "For laminar circular-pipe flow, the Darcy friction factor is f=64/Re; the Fanning factor is one-fourth of this.", "Fluid mechanics"),
 item("In a rectangular channel, the most hydraulically efficient section for a given flow area has:", ["Hydraulic radius equal to half the flow depth","Top width equal to twice the depth","Hydraulic radius equal to the depth","Wetted perimeter equal to zero"], "A", "For the best rectangular section, width is twice depth; area=2y² and wetted perimeter=4y, so R=A/P=y/2.", "Open-channel flow"),

 item("In crop-water terminology, the kor period is the interval between:", ["Sowing and the first watering","The first and last watering","Two successive harvests","The last watering and harvesting"], "A", "The kor period is the time from sowing until the first irrigation; kor depth is the water depth applied at that irrigation.", "Irrigation"),
 item("A discharge of 1 m³/s supplies 1,000 ha continuously for a 100-day base period. The equivalent depth of water is:", ["0.0864 m","0.864 m","8.64 m","86.4 m"], "B", "Volume=1×100×86,400=8,640,000 m³; area=10,000,000 m²; depth=0.864 m.", "Irrigation", "numerical"),
 item("The base period of a crop is the time between:", ["First and last watering of the crop","Sowing and germination only","Harvest and threshing","Two successive monsoons"], "A", "Base period is the interval between the first watering and the last watering before harvest.", "Irrigation"),
 item("The relation among duty D (ha per cumec), base period B (days) and delta Δ (m) is:", ["Δ=8.64B/D","Δ=BD/8.64","Δ=8.64D/B","Δ=B/(8.64D)"], "A", "One cumec flowing for B days supplies 86,400B m³ over D hectares (10,000D m²), giving Δ=8.64B/D.", "Irrigation"),
 item("A crop has a 120-day base period and duty 1,200 ha/cumec. Its delta is:", ["0.0864 m","0.864 m","8.64 m","10.0 m"], "B", "Δ=8.64×120/1,200=0.864 m.", "Irrigation", "numerical"),
 item("A canal falls when its bed slope is:", ["Downstream in the direction of flow","Upstream in the direction of flow","Exactly horizontal","Independent of flow direction"], "A", "A canal ordinarily conveys water by gravity, so its bed and water surface fall downstream.", "Canal engineering"),
 item("A weir across a river is commonly provided to:", ["Raise the upstream water level and regulate/divert flow","Remove all sediment from the basin","Measure rainfall directly","Prevent evaporation"], "A", "A weir raises the upstream level and can help regulate or divert water; it does not remove all sediment.", "Hydraulic structures"),
 item("The principal purpose of a canal escape is to:", ["Dispose of surplus canal water safely","Admit sediment into the canal","Increase crop duty","Measure crop evapotranspiration"], "A", "An escape releases excess canal water to a natural drain or other safe outlet.", "Canal engineering"),
 item("A cross regulator in a canal is used mainly to:", ["Raise and control the upstream water level in the canal","Carry a road over a canal","Drain water beneath a canal bank","Measure sediment concentration"], "A", "A cross regulator controls canal water level and discharge by regulating flow across the canal.", "Canal engineering"),
 item("A canal has a discharge of 4 m³/s. If 25% of that discharge is lost by seepage and leakage, the delivered discharge is:", ["1 m³/s","2 m³/s","3 m³/s","5 m³/s"], "C", "Delivered flow=4×(1−0.25)=3 m³/s.", "Irrigation", "numerical"),

 item("The principal purpose of providing superelevation on a horizontal road curve is to:", ["Counteract the outward centrifugal effect on a moving vehicle","Increase stopping distance","Remove pavement camber on straight sections","Reduce the wheelbase"], "A", "Superelevation banks the pavement to help balance the lateral effect of vehicle motion on a curve.", "Transportation engineering"),
 item("On a level road, estimate stopping sight distance for speed 54 km/h, reaction time 2 s and coefficient of longitudinal friction 0.35. Use g=9.81 m/s².", ["50 m","60 m","63 m","75 m"], "C", "Speed=15 m/s. SSD=vt+v²/(2gf)=30+225/(2×9.81×0.35)=62.8 m, about 63 m.", "Highway engineering", "numerical"),
 item("On a summit (crest) vertical curve, the available sight distance is limited mainly because:", ["The road profile obstructs the driver's line of sight over the crest","The pavement crossfall reverses at the summit","The vehicle has no braking force","The curve has no vertical radius"], "A", "The crest itself blocks the line of sight; curve geometry is selected to provide the required visibility.", "Highway engineering"),
 item("The ruling gradient is the:", ["Gradient ordinarily adopted for the design of a road in a region","Steepest gradient permitted only at every location","Gradient used only on bridge decks","Crossfall provided for pavement drainage"], "A", "The ruling gradient is the desirable maximum gradient generally adopted; a steeper limiting gradient may be used where terrain constrains the alignment.", "Highway engineering"),
 item("A vehicle moves at 72 km/h for 2.5 seconds during the perception-reaction interval. The reaction distance is:", ["25 m","40 m","50 m","72 m"], "C", "72 km/h=20 m/s; reaction distance=20×2.5=50 m.", "Highway engineering", "numerical"),
 item("In flexible pavement, the wheel load is transferred to lower layers mainly through:", ["Grain-to-grain contact and load distribution through the layered system","Slab action of a rigid concrete plate only","Suspension from reinforcement bars","Hydrostatic pressure alone"], "A", "Flexible pavements distribute load through layers and aggregate contact, with stresses reducing with depth.", "Pavement engineering"),
 item("Stripping in a bituminous pavement refers to:", ["Loss of adhesion between bitumen and aggregate, often promoted by water","Permanent wheel-path depressions","Excess bitumen rising to the surface","Loss of coarse aggregate by polishing"], "A", "Stripping is the separation of bitumen film from aggregate, commonly associated with moisture susceptibility.", "Pavement engineering"),
 item("Permanent longitudinal depressions that develop in the wheel paths of a bituminous pavement are called:", ["Rutting","Bleeding","Ravelling","Polishing"], "A", "Rutting is a permanent deformation forming depressions along the wheel paths.", "Pavement engineering"),
 item("On a highway curve, the centrifugal ratio is defined as:", ["Centrifugal force divided by vehicle weight","Vehicle weight divided by centrifugal force","Friction divided by superelevation","Radius divided by speed"], "A", "The centrifugal ratio is the lateral centrifugal force divided by the vehicle's weight.", "Highway engineering"),
 item("A vehicle negotiates a curve of radius 100 m at 20 m/s. The centrifugal acceleration is:", ["2 m/s²","4 m/s²","5 m/s²","10 m/s²"], "B", "a=v²/R=20²/100=4 m/s².", "Highway engineering", "numerical"),

 item("In conventional activated-sludge treatment, return activated sludge is sent from the secondary clarifier to the aeration tank mainly to:", ["Maintain an adequate concentration of biological solids","Increase grit in the influent","Replace primary sedimentation","Disinfect the final effluent"], "A", "Return sludge recycles settled microorganisms to sustain the biomass concentration in the aeration tank.", "Environmental engineering"),
 item("A wastewater sample has BOD₅ of 150 mg/L and COD of 300 mg/L. Its BOD₅/COD ratio is:", ["0.25","0.50","2.0","450"], "B", "150/300=0.50; both quantities use the same concentration units.", "Environmental engineering", "numerical"),
 item("A facultative waste-stabilization pond typically has:", ["An aerobic upper zone and an anaerobic lower zone","Only a fully anaerobic water column","Only a sterile, oxygen-free layer","A pressurized membrane filtration zone"], "A", "Facultative ponds develop an oxygenated surface region and anaerobic conditions in deeper water and settled sludge.", "Environmental engineering"),
 item("Nitrification in wastewater treatment is the biological oxidation of:", ["Ammonium to nitrite and nitrate","Nitrate to nitrogen gas","Organic carbon to methane only","Sulphate to sulphide"], "A", "Nitrifying microorganisms oxidize ammonia/ammonium first to nitrite and then nitrate, generally under aerobic conditions.", "Environmental engineering"),
 item("A treatment plant receives 20,000 m³/day. If the average suspended-solids concentration is 250 mg/L, the incoming solids load is:", ["0.5 kg/day","5,000 kg/day","50,000 kg/day","500,000 kg/day"], "B", "20,000 m³/day×1,000 L/m³×250 mg/L=5×10⁹ mg/day=5,000 kg/day.", "Environmental engineering", "numerical"),
 item("A slow sand filter removes contaminants principally through:", ["Straining and biological activity in the filter bed, including its surface layer","Chemical coagulation by alum stored in the sand","Reverse osmosis through a membrane","Boiling water in the bed"], "A", "Slow sand filtration combines physical removal and biological action, particularly in the biologically active surface zone.", "Water treatment"),
 item("Alum is commonly added during conventional water treatment primarily to:", ["Destabilize colloidal particles so they can coagulate and form settleable flocs","Disinfect water by oxidation","Remove dissolved salts by ion exchange","Increase the dissolved oxygen concentration"], "A", "Alum coagulation destabilizes colloids and promotes floc formation for subsequent separation.", "Water treatment"),
 item("A water sample contains 2 mg/L of chlorine before contact. After the specified contact period, residual chlorine is 0.4 mg/L. The chlorine demand is:", ["0.4 mg/L","1.0 mg/L","1.6 mg/L","2.4 mg/L"], "C", "Demand=2.0−0.4=1.6 mg/L.", "Water treatment", "numerical"),
 item("The principal purpose of a grit chamber in a sewage-treatment plant is to remove:", ["Heavy inorganic particles such as sand and grit","Dissolved organic matter","Bacteria by chlorination","All floating oils"], "A", "Grit chambers settle dense inorganic particles while keeping lighter organic solids largely in suspension.", "Environmental engineering"),
 item("Daily cover over the active face of a sanitary landfill is used chiefly to control:", ["Litter, odour, vectors and fire risk","Groundwater flow into the aquifer","The density of incoming refuse","The need for leachate collection"], "A", "Daily cover helps reduce windblown litter, odour, insects and rodents, and fire risk; it does not replace a liner or leachate system.", "Environmental engineering"),

 item("A simply supported beam carries a uniformly distributed load w over its entire span L. Its maximum bending moment is:", ["wL²/8","wL²/12","wL²/2","wL/8"], "A", "For a full-span uniform load, the maximum moment occurs at midspan and equals wL²/8.", "Structural analysis"),
 item("A simply supported beam of span 6 m carries a central point load of 12 kN. Its maximum bending moment is:", ["12 kN·m","18 kN·m","24 kN·m","36 kN·m"], "B", "Mmax=PL/4=12×6/4=18 kN·m.", "Structural analysis", "numerical"),
 item("For a beam under the usual sign convention, the rate of change of shear force along the beam is related to the:", ["Negative of the load intensity","Bending stress at the neutral axis","Deflection multiplied by span","Support reaction divided by span"], "A", "The differential relation is dV/dx=−w when downward load intensity w is taken as positive.", "Structural analysis"),
 item("The bending stress at a distance y from the neutral axis in an elastic beam is given by:", ["σ=My/I","σ=MI/y","σ=Iy/M","σ=M/(Iy)"], "A", "The flexure formula is σ/y=M/I, giving σ=My/I.", "Strength of materials"),
 item("For a rectangular beam section of breadth b and depth d, the elastic section modulus about its centroidal horizontal axis is:", ["bd²/6","b²d/6","bd³/12","b³d/12"], "A", "The second moment of area is bd³/12 and the extreme-fibre distance is d/2; Z=I/(d/2)=bd²/6.", "Strength of materials"),
 item("For a homogeneous, prismatic beam in simple bending, the neutral axis passes through the:", ["Centroid of the cross-section","Shear centre in every section","Top fibre","Support reaction point"], "A", "For a homogeneous section under elastic simple bending, the neutral axis passes through the centroid.", "Strength of materials"),
 item("An influence line for a response in a structure shows how that response varies as:", ["A unit load moves across the structure","The material temperature changes at a fixed load","The cross-section is painted","The support settlement becomes permanent"], "A", "An influence line represents the variation of a response quantity at a specified point as a unit load moves over the structure.", "Structural analysis"),
 item("A 2 m long pin-ended column has E=200 GPa and second moment of area I=1×10⁻⁶ m⁴. Its Euler load is approximately:", ["49.3 kN","493.5 kN","987 kN","197.4 kN"], "B", "Pcr=π²EI/L²=π²×200×10⁹×10⁻⁶/2²≈493,480 N=493.5 kN.", "Structural stability", "numerical"),
 item("For a symmetric two-hinged arch under symmetric loading, the horizontal reactions at the two supports are:", ["Equal in magnitude and opposite in direction","Both zero for every loading","Unequal because the arch is curved","Vertical only"], "A", "Symmetry gives equal-magnitude horizontal thrusts at the supports, acting in opposite directions.", "Structural analysis"),
 item("The point of contraflexure in a beam is a point where:", ["The bending moment changes sign","The shear force is always zero","The deflection is maximum","The support reaction changes direction"], "A", "At a point of contraflexure the bending moment changes sign, so the curvature changes sense.", "Strength of materials"),

 item("An under-reinforced reinforced-concrete beam is designed so that, at ultimate flexural failure:", ["Tension steel yields before the concrete compression zone crushes","Concrete crushes before tension steel yields","Both materials remain fully elastic until sudden collapse","The neutral axis lies outside the beam in every case"], "A", "In an under-reinforced section, tensile reinforcement yields before the concrete reaches its limiting compressive strain, giving a more ductile failure sequence.", "RCC design concepts"),
 item("In a reinforced-concrete slab, distribution reinforcement is generally placed:", ["Perpendicular to the main reinforcement","Parallel to the main reinforcement only","Only at the supports","At the neutral axis of the slab"], "A", "Distribution steel runs across the main span reinforcement to distribute local effects and help control shrinkage and temperature cracking.", "RCC"),
 item("In a singly reinforced concrete beam under sagging moment, the main tension reinforcement is placed near the:", ["Bottom (tension) face","Neutral axis","Top compression face only","Section centroid irrespective of bending"], "A", "Sagging bending places the bottom fibres in tension; the principal tension steel is placed near that face with required cover.", "RCC"),
 item("A singly reinforced concrete beam has 1,000 mm² of tensile steel with design stress 250 N/mm². The tensile force in the steel is:", ["25 kN","100 kN","250 kN","2,500 kN"], "C", "T=Ast fs=1,000×250=250,000 N=250 kN.", "RCC", "numerical"),
 item("The development length of a reinforcing bar is provided to:", ["Transfer bar force to surrounding concrete through bond","Eliminate the need for anchorage","Reduce nominal cover to zero","Increase the concrete water-cement ratio"], "A", "Adequate development length enables the required bar force to be transferred through bond stresses.", "RCC"),
 item("For a simply supported one-way slab, the main reinforcement generally runs along the:", ["Shorter span","Longer span","Perimeter only","Diagonal"], "A", "A one-way slab spans and bends predominantly in the shorter direction, so main reinforcement is aligned with that span.", "RCC"),
 item("A slab panel is 3 m by 7 m and is supported on all four sides. The longer-to-shorter span ratio is:", ["1.5","2.0","2.33","3.0"], "C", "7/3≈2.33.", "RCC", "numerical"),
 item("In a doubly reinforced concrete beam, compression reinforcement is placed mainly to:", ["Increase moment capacity when depth is constrained and assist ductility/service behaviour","Replace all tensile reinforcement","Eliminate shear reinforcement","Prevent cement hydration"], "A", "Compression steel can supplement the concrete compression block when beam depth is limited and can improve deformation characteristics.", "RCC"),
 item("A retaining wall is commonly checked for overturning about its:", ["Toe","Heel","Top edge","Centre of gravity only"], "A", "The overturning moment is commonly assessed about the toe, while the resisting moment is provided mainly by the wall and soil over the heel.", "Foundation and retaining structures"),
 item("A short axially loaded concrete column has gross area 300,000 mm² and average compressive stress 10 N/mm². The corresponding axial load is:", ["300 kN","1,000 kN","3,000 kN","30,000 kN"], "C", "P=σA=10×300,000=3,000,000 N=3,000 kN.", "RCC", "numerical"),

 item("For a bolted steel tension member, the net area at a section through bolt holes is obtained by:", ["Subtracting the hole deductions from the gross section area","Adding the bolt-hole area to gross area","Ignoring all holes","Subtracting the member length"], "A", "Bolt holes reduce the effective net area available to carry tension.", "Steel design"),
 item("A steel plate 100 mm wide and 10 mm thick has one 20 mm bolt hole across the critical section. Its net area is:", ["600 mm²","800 mm²","1,000 mm²","1,200 mm²"], "B", "Net width=100−20=80 mm; net area=80×10=800 mm².", "Steel design", "numerical"),
 item("In a fillet weld, the theoretical throat thickness for an equal-leg 90° weld of leg size s is approximately:", ["0.5s","0.707s","s","1.414s"], "B", "The shortest distance from root to face for an equal-leg 90° fillet is s sin 45°≈0.707s.", "Steel design"),
 item("A laterally unsupported steel beam may fail by:", ["Lateral-torsional buckling","Only crushing of its supports","Hydration shrinkage","Piping through its web"], "A", "A slender beam without sufficient lateral restraint can buckle laterally while twisting under bending.", "Steel design"),
 item("In a simply supported steel beam, lateral restraint to the compression flange is especially effective in improving resistance to:", ["Lateral-torsional buckling","Local bearing at the support only","Tensile yielding of the bottom flange only","Corrosion"], "A", "Bracing the compression flange restrains lateral movement and twist, increasing lateral-torsional buckling resistance.", "Steel design"),
 item("The slenderness ratio of a compression member is the ratio of:", ["Effective length to least radius of gyration","Gross area to net area","Yield stress to elastic modulus","Radius of gyration to effective length"], "A", "Slenderness ratio λ=Le/r, using the relevant effective length and radius of gyration.", "Steel design"),
 item("A compression member has effective length 3 m and least radius of gyration 30 mm. Its slenderness ratio is:", ["10","30","100","300"], "C", "Convert 3 m to 3,000 mm; λ=3,000/30=100.", "Steel design", "numerical"),
 item("A gusset plate in a truss connection is used primarily to:", ["Connect members and transfer forces at a joint","Increase the member's elastic modulus","Act as a hinge with zero force transfer","Provide corrosion allowance"], "A", "A gusset plate connects intersecting truss members and transfers their joint forces through the connection.", "Steel construction"),
 item("In a steel tension member, block shear is a failure mode involving:", ["A block of material tearing along combined shear and tension planes","Only elastic buckling about the major axis","Concrete crushing under a base plate","Fatigue of the paint film"], "A", "Block shear combines shear failure along one or more planes with tension failure across another plane near a connection.", "Steel design"),
 item("A steel member is connected by bolts. The design should check the connected parts and fasteners for:", ["Relevant yielding, rupture, bearing and shear limit states","Only colour uniformity","Only member self-weight","Only thermal conductivity"], "A", "Safe connection design checks the applicable failure modes of both bolts and connected material, including shear, bearing and tension-related failures.", "Steel design"),
]

def build():
    assert len(REASONING) == 50 and len(GA) == 50 and len(CIVIL) == 100
    sections = [
        ("General Intelligence and Reasoning", REASONING, 20),
        ("General Awareness", GA, 20),
        ("General Engineering (Civil and Structural)", CIVIL, 40),
    ]
    questions = []
    number = 1
    answer_targets = []
    target_counts = [(13, 13, 12, 12), (12, 13, 13, 12), (25, 24, 25, 26)]
    rng = random.Random(20261030)
    for counts in target_counts:
        letters = [letter for letter, count in zip("ABCD", counts) for _ in range(count)]
        rng.shuffle(letters)
        answer_targets.append(letters)
    section_index = 0
    for section, rows, moderate_count in sections:
        answer_target = answer_targets[section_index]
        section_index += 1
        for i, row in enumerate(rows):
            assert len(row["options"]) == 4 and len(set(row["options"])) == 4, (number, row)
            assert row["correct_answer"] in "ABCD"
            assert all(str(row[k]).strip() for k in ("question_text", "rationale", "topic"))
            options = list(row["options"])
            original_index = "ABCD".index(row["correct_answer"])
            target_index = "ABCD".index(answer_target[i])
            options[original_index], options[target_index] = options[target_index], options[original_index]
            questions.append({
                "number": number,
                "section": section,
                "difficulty": "Moderate" if i < moderate_count else "Hard",
                **row,
                "options": options,
                "correct_answer": answer_target[i],
            })
            number += 1
    assert sum(q["difficulty"] == "Moderate" for q in questions) == 80
    assert sum(q["difficulty"] == "Hard" for q in questions) == 120
    assert {letter: sum(q["correct_answer"] == letter for q in questions) for letter in "ABCD"} == {
        "A": 50, "B": 50, "C": 50, "D": 50
    }
    civ = questions[100:]
    assert sum(q["type"] == "numerical" for q in civ) == 25
    assert len(set(q["question_text"] for q in questions)) == 200
    return questions

def sql_quote(s):
    return "'" + s.replace("'", "''") + "'"

def audit_numericals(questions):
    """Recompute all short-number answers and compare to their selected option."""
    civil = {
        103: (600_000 / 150_000, "4 MPa"),
        112: (100.000 + 1.250, "101.250 m"),
        114: (80 * 100 / 2_000, "4 cm"),
        122: (180 - 65, "115 kPa"),
        125: ((180 - 150) / 150 * 100, "20%"),
        128: (0.6 / (1 + 0.6), "0.375"),
        132: (2 * 0.03, "0.06 m³/s"),
        135: (9.81 * 0.04 * 10, "3.92 kW"),
        138: ((2 * 10 * 5) ** 0.5, "10 m/s"),
        142: (1 * 100 * 86_400 / (1_000 * 10_000), "0.864 m"),
        145: (8.64 * 120 / 1_200, "0.864 m"),
        150: (4 * (1 - 0.25), "3 m³/s"),
        152: (54 / 3.6 * 2 + (54 / 3.6) ** 2 / (2 * 9.81 * 0.35), "63 m"),
        155: (72 / 3.6 * 2.5, "50 m"),
        160: (20**2 / 100, "4 m/s²"),
        162: (150 / 300, "0.50"),
        165: (20_000 * 1_000 * 250 / 1_000_000, "5,000 kg/day"),
        168: (2 - 0.4, "1.6 mg/L"),
        172: (12 * 6 / 4, "18 kN·m"),
        178: (3.141592653589793**2 * 200e9 * 1e-6 / 2**2 / 1_000, "493.5 kN"),
        184: (1_000 * 250 / 1_000, "250 kN"),
        187: (7 / 3, "2.33"),
        190: (300_000 * 10 / 1_000, "3,000 kN"),
        192: ((100 - 20) * 10, "800 mm²"),
        197: (3_000 / 30, "100"),
    }
    reasoning = {
        8: (8 * 15 / 12, "10 hours"),
        16: (100 - 100 * 1.20 * 0.80, "4% decrease"),
        19: (3 * 12 / 6, "6 days"),
        28: ((35 - 5) / 2, "15"),
        35: (57, "57"),
        40: (150 / 10 * 3.6, "54"),
        45: (60 - (32 + 28 - 12), "12"),
        49: (1 / (1 / 12 + 1 / 18), "7.2 days"),
    }
    assert len(civil) == 25
    for number, (computed, option_text) in {**civil, **reasoning}.items():
        q = questions[number - 1]
        selected = q["options"]["ABCD".index(q["correct_answer"])]
        assert selected == option_text, (number, computed, selected, option_text)
        if isinstance(computed, float):
            token = option_text.split()[0].replace(",", "").replace("%", "")
            target = float(token)
            decimals = len(token.split(".")[1]) if "." in token else 0
            tolerance = 0.5 * (10 ** -decimals) + 1e-9
            assert abs(computed - target) <= tolerance, (number, computed, option_text)

def main():
    questions = build()
    audit_numericals(questions)
    data_path = ROOT / "supabase/data/ssc_je_civil_di70_questions.json"
    data_path.write_text(json.dumps(questions, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    payload = json.dumps([
        {
            "display_order": q["number"],
            "question_text": f'[{q["section"]}] {q["question_text"]}',
            "options": [{"value": x, "text": t} for x, t in zip("ABCD", q["options"])],
            "correct_answer": q["correct_answer"],
        } for q in questions
    ], ensure_ascii=False, indent=2)
    seed = f"""-- Generated by scripts/build_ssc_je_civil_di70_seed.py; edit the JSON source and regenerate.
-- UNOFFICIAL original practice material. No questions are copied from the supplied prior-paper PDF.
-- Run after the student learning schema and supabase/mock_simulation_functions.sql.
-- Practice settings: 120 minutes, 200 marks, +1 correct, -0.25 incorrect, 0 unanswered.
-- The 2024 paper's 50/50/100 proportions are a style reference, not a verified 2026 pattern.
DO $seed$
DECLARE
    v_branch_id UUID;
    v_subject_id UUID;
    v_test_id UUID;
    v_seed JSONB := $questions$
{payload}
$questions$::JSONB;
BEGIN
    IF to_regclass('public.engineering_branches') IS NULL OR to_regclass('public.subjects') IS NULL
       OR to_regclass('public.mock_tests') IS NULL OR to_regclass('public.mock_questions') IS NULL THEN
        RAISE EXCEPTION 'Missing mock-test tables. Run the repository mock setup and RPC migrations first.';
    END IF;
    SELECT id INTO v_branch_id FROM public.engineering_branches WHERE name='Civil Engineering' LIMIT 1;
    IF v_branch_id IS NULL THEN
        INSERT INTO public.engineering_branches(name,code,description,is_active)
        VALUES ('Civil Engineering',
          CASE WHEN EXISTS(SELECT 1 FROM public.engineering_branches WHERE code='CE')
               THEN 'CE-'||upper(substr(replace(gen_random_uuid()::text,'-',''),1,8)) ELSE 'CE' END,
          'Civil engineering branch',TRUE) RETURNING id INTO v_branch_id;
    END IF;
    INSERT INTO public.subjects(branch_id,name,code,description,display_order,is_active)
    VALUES (v_branch_id,'Civil Engineering',
      CASE WHEN EXISTS(SELECT 1 FROM public.subjects WHERE code='CE')
           THEN 'CE-'||upper(substr(replace(gen_random_uuid()::text,'-',''),1,8)) ELSE 'CE' END,
      'Civil engineering subjects and SSC JE practice',0,TRUE)
    ON CONFLICT(branch_id,name) DO NOTHING;
    SELECT id INTO v_subject_id FROM public.subjects
      WHERE branch_id=v_branch_id AND name='Civil Engineering' LIMIT 1;
    IF v_subject_id IS NULL THEN RAISE EXCEPTION 'Could not create or find Civil Engineering subject'; END IF;

    SELECT id INTO v_test_id FROM public.mock_tests WHERE title={sql_quote(TITLE)} LIMIT 1;
    IF v_test_id IS NOT NULL AND EXISTS (
      SELECT 1 FROM public.mock_questions e
      LEFT JOIN jsonb_to_recordset(v_seed) AS q(display_order int,question_text text,options jsonb,correct_answer text)
        ON q.display_order=e.display_order
      WHERE e.mock_test_id=v_test_id AND
        (q.display_order IS NULL OR e.question_text IS DISTINCT FROM q.question_text
         OR e.question_type IS DISTINCT FROM 'mcq' OR e.options IS DISTINCT FROM q.options
         OR e.correct_answer IS DISTINCT FROM q.correct_answer
         OR e.marks IS DISTINCT FROM 1 OR e.negative_marks IS DISTINCT FROM 0.25)
    ) THEN RAISE EXCEPTION 'Existing mock content conflicts with this seed; refusing to overwrite'; END IF;
    IF v_test_id IS NULL THEN
      INSERT INTO public.mock_tests(title,description,exam_type,subject_id,duration_minutes,total_marks,passing_marks,is_published)
      VALUES ({sql_quote(TITLE)},{sql_quote(DESCRIPTION)},'OTHER',v_subject_id,120,200,100,TRUE)
      RETURNING id INTO v_test_id;
    ELSE
      UPDATE public.mock_tests SET description={sql_quote(DESCRIPTION)},exam_type='OTHER',
        subject_id=v_subject_id,duration_minutes=120,total_marks=200,passing_marks=100,is_published=TRUE
      WHERE id=v_test_id;
    END IF;
    INSERT INTO public.mock_questions(mock_test_id,question_text,question_type,options,correct_answer,marks,negative_marks,display_order)
    SELECT v_test_id,q.question_text,'mcq',q.options,q.correct_answer,1,0.25,q.display_order
    FROM jsonb_to_recordset(v_seed) AS q(display_order int,question_text text,options jsonb,correct_answer text)
    WHERE NOT EXISTS(SELECT 1 FROM public.mock_questions e
      WHERE e.mock_test_id=v_test_id AND e.display_order=q.display_order);
    IF (SELECT count(*) FROM public.mock_questions WHERE mock_test_id=v_test_id)<>200
       OR (SELECT count(DISTINCT display_order) FROM public.mock_questions WHERE mock_test_id=v_test_id)<>200
    THEN RAISE EXCEPTION 'Expected 200 uniquely ordered questions'; END IF;
    RAISE NOTICE 'SSC JE Civil DI-70 mock ready: 200 questions; unofficial practice material.';
END;
$seed$;
"""
    (ROOT / "supabase/junior_engineer_civil_paper_i_di70_mock_seed.sql").write_text(seed, encoding="utf-8")

    lines = [
        "# SSC JE Civil Paper-I practice mock — Difficulty Index 70%",
        "",
        "**Unofficial and original practice material.** Not an SSC paper, official answer key, or prediction.",
        "",
        "## Editorial blueprint and validation summary",
        "",
        "- 200 MCQs: 1–50 General Intelligence and Reasoning; 51–100 General Awareness; 101–200 General Engineering (Civil and Structural).",
        "- Difficulty Index 70% is an editorial target interpolated between Easy (0), Moderate (50), and Hard (100): **80 Moderate, 120 Hard, 0 Easy**. This is not an empirically measured or official SSC metric.",
        "- Civil: **75 theory/concept/application and 25 short numericals**.",
        "- Scoring configured in the seed: +1 correct, −0.25 incorrect, 0 unanswered; 120 minutes. This is practice configuration, not a verified current-cycle rule.",
        "- The 2024 reference paper has 50/50/100 sections and is used only for broad layout/style. Current-cycle pattern details require confirmation against a relevant official notice.",
        "- Correct-option placement is balanced across the mock: 50 each of A, B, C and D.",
        "",
        "### Blueprint",
        "",
        "| Section / question range | Topics | Format mix | Target levels |",
        "|---|---|---|---|",
        "| General Intelligence and Reasoning, Q1–50 | Series, coding, direction, ranking, syllogism, ordering, calendar, arithmetic reasoning | 50 objective reasoning items, including short calculations | 20 Moderate, 30 Hard |",
        "| General Awareness, Q51–100 | Polity, geography, history, science, environment, institutions, culture, economy | 50 objective factual/concept items | 20 Moderate, 30 Hard |",
        "| Civil and Structural, Q101–110 | Materials and construction | 9 theory/application, 1 short numerical | 10 Moderate |",
        "| Civil and Structural, Q111–120 | Estimating and surveying | 8 theory/application, 2 short numericals | 10 Moderate |",
        "| Civil and Structural, Q121–130 | Soil mechanics and foundations | 7 theory/application, 3 short numericals | 10 Moderate |",
        "| Civil and Structural, Q131–140 | Fluid mechanics, hydraulics and open-channel flow | 7 theory/application, 3 short numericals | 10 Moderate |",
        "| Civil and Structural, Q141–150 | Irrigation engineering | 7 theory/application, 3 short numericals | 10 Hard |",
        "| Civil and Structural, Q151–160 | Transportation and highway engineering | 7 theory/application, 3 short numericals | 10 Hard |",
        "| Civil and Structural, Q161–170 | Environmental and water-treatment engineering | 7 theory/application, 3 short numericals | 10 Hard |",
        "| Civil and Structural, Q171–180 | Structural analysis and strength of materials | 8 theory/application, 2 short numericals | 10 Hard |",
        "| Civil and Structural, Q181–190 | RCC design concepts | 7 theory/application, 3 short numericals | 10 Hard |",
        "| Civil and Structural, Q191–200 | Steel design and connections | 8 theory/application, 2 short numericals | 10 Hard |",
        "",
        "## Source and limitations",
        "",
        "- The supplied local PDF was present and confirmed as 68 pages. It was consulted only for broad section sequence, compact stems, and four-option style; none of its items or explanations were transcribed or paraphrased.",
        "- SSC official-site access checked on 2026-10-30: the homepage/candidate route loaded, but the attempted JE notice attachment URL did not resolve and no cycle-specific JE notice/corrigendum or syllabus document was verified. **Notice date: unverified; current-cycle syllabus, section pattern, duration, marks and negative marking remain unverified.** Do not treat this mock's proportions or scoring settings as official.",
        "- No date-sensitive current-affairs fact is used. Static general-awareness facts are included for practice.",
        "- Civil topic distribution is an editorial coverage choice, not an official frequency claim. No current code-clause design threshold is tested.",
        "- Rerun `python scripts/build_ssc_je_civil_di70_seed.py` after editing the authoring banks in that script; the answer-bearing JSON, SQL seed and this review are generated outputs. No live database was accessed.",
        "",
        "## Civil coverage",
        "",
        "Building materials/construction; estimating; surveying; soil mechanics/foundations; fluid mechanics/hydraulics/open-channel flow; irrigation; highway and pavement engineering; environmental and water treatment; structural analysis/strength of materials; RCC; steel design.",
        "",
        "## Complete answer key with concise worked explanations",
        "",
    ]
    for q in questions:
        lines += [
            f'### Q{q["number"]} — {q["correct_answer"]} | {q["section"]} | {q["topic"]} | {q["difficulty"]} | {q["type"]}',
            "",
            q["question_text"],
            "",
        ]
        lines += [f"{letter}. {text}" for letter, text in zip("ABCD", q["options"])]
        lines += ["", f"**Explanation:** {q['rationale']}", ""]
    lines += ["## Compact key", ""]
    for start in range(1, 201, 20):
        subset = questions[start-1:start+19]
        lines.append(" · ".join(f'{q["number"]}:{q["correct_answer"]}' for q in subset))
    (ROOT / "supabase/data/ssc_je_civil_di70_review.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"Built {len(questions)} questions; 80 Moderate, 120 Hard; Civil 75 theory, 25 numerical.")

if __name__ == "__main__":
    main()
