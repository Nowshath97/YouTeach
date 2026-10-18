-- Run after the original seeds and matching revision. Retains all question IDs and answer keys.
-- If attempts exist, refuses changed content rather than changing historical test questions.
BEGIN;
LOCK TABLE public.mock_attempts IN SHARE MODE;
LOCK TABLE public.mock_questions IN SHARE ROW EXCLUSIVE MODE;
DO $revision$
DECLARE v_test UUID; v_payload JSONB := $payload$[
  {
    "display_order": 1,
    "question_text": "[Telangana History, Culture & State Formation] The 2011 Sakala Janula Samme was principally a:",
    "options": [
      {
        "value": "A",
        "text": "Mass rally mobilisation centred on a single Hyderabad march for Telangana statehood"
      },
      {
        "value": "B",
        "text": "Transport blockade mobilisation centred on stopping rail services for Telangana statehood"
      },
      {
        "value": "C",
        "text": "Administrative non-cooperation confined to government offices for Telangana statehood"
      },
      {
        "value": "D",
        "text": "Broad strike mobilisation in support of Telangana statehood"
      }
    ],
    "correct_answer": "D",
    "explanation": "Sakala Janula Samme was a sustained, broad strike for Telangana statehood involving multiple occupational and social groups. A single rally, rail blockade or administrative non-cooperation campaign describes a narrower protest form rather than the mobilisation as a whole."
  },
  {
    "display_order": 2,
    "question_text": "[Indian Geography & Telangana Geography] In a semi-arid plateau region, replacing a water-intensive crop with an appropriate millet can primarily improve:",
    "options": [
      {
        "value": "A",
        "text": "Greater dependence on standing water throughout crop growth"
      },
      {
        "value": "B",
        "text": "Higher sensitivity to short dry spells during the growing season"
      },
      {
        "value": "C",
        "text": "Greater dependence on continuous canal releases through the crop cycle"
      },
      {
        "value": "D",
        "text": "Adaptation to limited and variable water availability"
      }
    ],
    "correct_answer": "D",
    "explanation": "Many millets tolerate relatively dry conditions, though crop suitability still depends on soil, management and local climate."
  },
  {
    "display_order": 5,
    "question_text": "[General Science & Technology] A pressure cooker cooks food faster mainly because increased pressure:",
    "options": [
      {
        "value": "A",
        "text": "Lowers the boiling temperature and increases evaporation at the same temperature"
      },
      {
        "value": "B",
        "text": "Raises the boiling temperature by lowering external pressure on the liquid"
      },
      {
        "value": "C",
        "text": "Raises the boiling temperature of water"
      },
      {
        "value": "D",
        "text": "Leaves the boiling temperature unchanged but reduces the food's specific heat"
      }
    ],
    "correct_answer": "C",
    "explanation": "Higher pressure raises saturation temperature, permitting cooking above the normal atmospheric boiling temperature."
  },
  {
    "display_order": 9,
    "question_text": "[Indian History & National Movement] The Cabinet Mission Plan of 1946 principally sought:",
    "options": [
      {
        "value": "A",
        "text": "A constitutional arrangement for transfer of power with a proposed Union and provincial grouping"
      },
      {
        "value": "B",
        "text": "A strong unitary centre with provinces lacking residual powers"
      },
      {
        "value": "C",
        "text": "Two immediately sovereign states with no common Union institutions"
      },
      {
        "value": "D",
        "text": "A federation of provinces excluding princely states from the constitution-making process"
      }
    ],
    "correct_answer": "A",
    "explanation": "It proposed a constitution-making process and a limited Union with groupings, amid disagreement over interpretation and participation."
  },
  {
    "display_order": 10,
    "question_text": "[Indian Geography & Telangana Geography] Lateritic profiles are associated especially with:",
    "options": [
      {
        "value": "A",
        "text": "Weak leaching under cool dry conditions"
      },
      {
        "value": "B",
        "text": "Intense weathering and leaching under warm wet conditions"
      },
      {
        "value": "C",
        "text": "Salt accumulation under intense evaporation in arid conditions"
      },
      {
        "value": "D",
        "text": "Deposition of carbonate-rich sediments under shallow marine conditions"
      }
    ],
    "correct_answer": "B",
    "explanation": "Strong leaching removes soluble materials and concentrates relatively insoluble iron and aluminium compounds."
  },
  {
    "display_order": 12,
    "question_text": "[Telangana History, Culture & State Formation] Which feature of the Ramappa Temple illustrates deliberate reduction of roof weight?",
    "options": [
      {
        "value": "A",
        "text": "Dense dressed-stone slabs in the vimana"
      },
      {
        "value": "B",
        "text": "Solid fired bricks with a high bulk density in the vimana"
      },
      {
        "value": "C",
        "text": "Massive stone corbelling supporting a dense masonry superstructure"
      },
      {
        "value": "D",
        "text": "Lightweight porous bricks in the vimana"
      }
    ],
    "correct_answer": "D",
    "explanation": "UNESCO describes the temple's lightweight porous roofing bricks, often called floating bricks, as a notable construction feature."
  },
  {
    "display_order": 13,
    "question_text": "[Indian Geography & Telangana Geography] In much of the Telangana hard-rock terrain, productive groundwater is principally stored and transmitted through:",
    "options": [
      {
        "value": "A",
        "text": "Primary intergranular pores distributed evenly through unweathered granite"
      },
      {
        "value": "B",
        "text": "Unfractured rock interiors below the weathering zone"
      },
      {
        "value": "C",
        "text": "Connected pore spaces formed mainly between intact feldspar crystals"
      },
      {
        "value": "D",
        "text": "Weathered and fractured zones"
      }
    ],
    "correct_answer": "D",
    "explanation": "Fresh crystalline rock has low primary porosity; weathering and fractures provide secondary storage and flow paths."
  },
  {
    "display_order": 14,
    "question_text": "[Indian History & National Movement] Under the Permanent Settlement, the revenue demand was fixed with zamindars. A major structural consequence was:",
    "options": [
      {
        "value": "A",
        "text": "A landlord intermediary with revenue obligations and enhanced property interests"
      },
      {
        "value": "B",
        "text": "A direct state-cultivator settlement with periodically revised state demand"
      },
      {
        "value": "C",
        "text": "A village-body settlement with collective liability for assessed revenue"
      },
      {
        "value": "D",
        "text": "A landlord settlement with state demand revised annually with market prices"
      }
    ],
    "correct_answer": "A",
    "explanation": "The settlement institutionalized zamindari interests and fixed state demand, without guaranteeing cultivator welfare."
  },
  {
    "display_order": 15,
    "question_text": "[Current Affairs] Which statement correctly describes the Maratha Military Landscapes of India inscribed by UNESCO in 2025?",
    "options": [
      {
        "value": "A",
        "text": "A serial group of twelve fortifications, mainly in Maharashtra with one in Tamil Nadu"
      },
      {
        "value": "B",
        "text": "A serial group of twelve fortifications, all located within Maharashtra"
      },
      {
        "value": "C",
        "text": "A serial group of twelve fortifications, mainly in Maharashtra with one in Karnataka"
      },
      {
        "value": "D",
        "text": "A serial group of twelve fortifications, mainly in Maharashtra with one in Telangana"
      }
    ],
    "correct_answer": "A",
    "explanation": "UNESCO describes twelve fortifications, mostly in Maharashtra, with Gingee in Tamil Nadu, forming a serial military landscape."
  },
  {
    "display_order": 16,
    "question_text": "[Telangana History, Culture & State Formation] Salar Jung I is most closely associated with which nineteenth-century Hyderabad development?",
    "options": [
      {
        "value": "A",
        "text": "Administrative and revenue reforms"
      },
      {
        "value": "B",
        "text": "Creation of an elected legislature with a responsible ministry"
      },
      {
        "value": "C",
        "text": "Abolition of the jagirdari system throughout Hyderabad State"
      },
      {
        "value": "D",
        "text": "Introduction of universal adult franchise in Hyderabad State"
      }
    ],
    "correct_answer": "A",
    "explanation": "Salar Jung I's long tenure as Hyderabad's minister was marked by administrative, revenue and institutional reforms."
  },
  {
    "display_order": 18,
    "question_text": "[General Science & Technology] Adding a suitable pentavalent impurity to silicon ordinarily produces:",
    "options": [
      {
        "value": "A",
        "text": "A p-type semiconductor with electrons as majority carriers"
      },
      {
        "value": "B",
        "text": "An n-type semiconductor with electrons as majority carriers"
      },
      {
        "value": "C",
        "text": "An n-type semiconductor with holes as majority carriers"
      },
      {
        "value": "D",
        "text": "An intrinsic semiconductor with equal electron and hole concentrations"
      }
    ],
    "correct_answer": "B",
    "explanation": "A donor impurity contributes an extra electron, increasing electron concentration under ordinary doping conditions."
  },
  {
    "display_order": 19,
    "question_text": "[Indian History & National Movement] The Poona Pact of 1932 replaced the proposed separate electorates for Depressed Classes with:",
    "options": [
      {
        "value": "A",
        "text": "Reserved seats within separate electorates"
      },
      {
        "value": "B",
        "text": "Unreserved seats within joint electorates"
      },
      {
        "value": "C",
        "text": "Reserved seats filled solely by nomination"
      },
      {
        "value": "D",
        "text": "Reserved seats within joint electorates"
      }
    ],
    "correct_answer": "D",
    "explanation": "The agreement retained enhanced representation through reserved seats while adopting joint electorates."
  },
  {
    "display_order": 20,
    "question_text": "[Indian Geography & Telangana Geography] Why is the interior Deccan generally drier than the windward western coastal belt during the southwest monsoon?",
    "options": [
      {
        "value": "A",
        "text": "Monsoon winds lose moisture by crossing the interior plateau before reaching the western coast"
      },
      {
        "value": "B",
        "text": "Orographic uplift removes moisture on the windward side, leaving a rain shadow inland"
      },
      {
        "value": "C",
        "text": "Leeward ascent produces cooling while windward descent suppresses condensation"
      },
      {
        "value": "D",
        "text": "The inland pressure gradient prevents moisture-bearing air from crossing the Ghats"
      }
    ],
    "correct_answer": "B",
    "explanation": "Moist monsoon air rises over the Western Ghats; descending leeward air is relatively drier."
  },
  {
    "display_order": 22,
    "question_text": "[Telangana History, Culture & State Formation] Chakali Ilamma is remembered in Telangana history particularly for:",
    "options": [
      {
        "value": "A",
        "text": "Resistance to landlord oppression in the agrarian struggle"
      },
      {
        "value": "B",
        "text": "Leadership of the Mulki student agitation over public employment"
      },
      {
        "value": "C",
        "text": "Organisation of the library movement for vernacular education"
      },
      {
        "value": "D",
        "text": "Negotiation of regional safeguards during the linguistic merger"
      }
    ],
    "correct_answer": "A",
    "explanation": "Her resistance became an important symbol of peasant and women's participation in Telangana's agrarian struggle."
  },
  {
    "display_order": 24,
    "question_text": "[Indian Geography & Telangana Geography] A falling share of dependent ages and rising working-age share can create a demographic dividend only if accompanied by:",
    "options": [
      {
        "value": "A",
        "text": "Employment, health and skill opportunities"
      },
      {
        "value": "B",
        "text": "A rising working-age share accompanied by persistent unemployment"
      },
      {
        "value": "C",
        "text": "A rising working-age share accompanied by declining workforce skills"
      },
      {
        "value": "D",
        "text": "A rising working-age share accompanied by worsening worker health"
      }
    ],
    "correct_answer": "A",
    "explanation": "Age structure creates potential, but productive employment and human capital determine whether the potential is realized."
  },
  {
    "display_order": 26,
    "question_text": "[Telangana History, Culture & State Formation] The political consequence of the September 1948 military action in Hyderabad was:",
    "options": [
      {
        "value": "A",
        "text": "Continuation as a sovereign state under an Indian defence treaty"
      },
      {
        "value": "B",
        "text": "Accession to India with the Nizam retaining independent defence powers"
      },
      {
        "value": "C",
        "text": "Conversion of Hyderabad city into a separately administered Union Territory"
      },
      {
        "value": "D",
        "text": "Integration of Hyderabad State into the Indian Union"
      }
    ],
    "correct_answer": "D",
    "explanation": "Integration occurred in 1948; linguistic reorganisation and separate Telangana statehood occurred later, so the milestones must be distinguished."
  },
  {
    "display_order": 28,
    "question_text": "[Indian Polity & Constitution] Under the Tenth Schedule, the initial decision on a legislator's disqualification on defection grounds is ordinarily made by:",
    "options": [
      {
        "value": "A",
        "text": "The presiding officer of the relevant House"
      },
      {
        "value": "B",
        "text": "The Governor or President acting on the Election Commission's opinion"
      },
      {
        "value": "C",
        "text": "The Election Commission acting on a petition from the party whip"
      },
      {
        "value": "D",
        "text": "A High Court acting as the first-instance statutory tribunal"
      }
    ],
    "correct_answer": "A",
    "explanation": "The Speaker or Chairman decides initially, subject to the applicable scope of judicial review."
  },
  {
    "display_order": 30,
    "question_text": "[Indian Economy & Telangana Economy] Why can two households with the same income have different multidimensional deprivation levels?",
    "options": [
      {
        "value": "A",
        "text": "Their deprivation must be identical once income is adjusted for household size"
      },
      {
        "value": "B",
        "text": "They may differ in health, education and living conditions"
      },
      {
        "value": "C",
        "text": "Their deprivation can differ only if their current bank balances differ"
      },
      {
        "value": "D",
        "text": "Their deprivation must converge whenever they face the same market prices"
      }
    ],
    "correct_answer": "B",
    "explanation": "Multidimensional measures capture non-income dimensions that need not move one-for-one with income."
  },
  {
    "display_order": 32,
    "question_text": "[Telangana History, Culture & State Formation] Suravaram Pratap Reddy's 'Andhrula Sanghika Charitra' is primarily a work of:",
    "options": [
      {
        "value": "A",
        "text": "A dynastic chronology of the Qutb Shahi rulers"
      },
      {
        "value": "B",
        "text": "Social history"
      },
      {
        "value": "C",
        "text": "A linguistic grammar of classical Telugu"
      },
      {
        "value": "D",
        "text": "A critical commentary on Telugu devotional poetry"
      }
    ],
    "correct_answer": "B",
    "explanation": "The work examines the social history of Telugu-speaking people, rather than serving as a technical or legal manual."
  },
  {
    "display_order": 33,
    "question_text": "[General Science & Technology] Which statement is correct?",
    "options": [
      {
        "value": "A",
        "text": "Vaccines stimulate immune protection; antibiotics target susceptible bacteria rather than viral replication directly"
      },
      {
        "value": "B",
        "text": "Vaccines provide passive ready-made antibodies; antibiotics stimulate immune memory"
      },
      {
        "value": "C",
        "text": "Vaccines directly inhibit bacterial protein synthesis; antibiotics induce antigen-specific memory"
      },
      {
        "value": "D",
        "text": "Vaccines treat established bacterial infection; antibiotics prevent infection through immune priming"
      }
    ],
    "correct_answer": "A",
    "explanation": "The mechanisms and targets differ. Vaccines may use several platforms, while antibiotics are not general antiviral treatments."
  },
  {
    "display_order": 34,
    "question_text": "[Telangana History, Culture & State Formation] Which statement correctly distinguishes the legislative basis of Telangana's formation from its effective formation date?",
    "options": [
      {
        "value": "A",
        "text": "The Andhra Pradesh Reorganisation Act, 2014 provided the legal basis; 1 March 2014 was the appointed day"
      },
      {
        "value": "B",
        "text": "The Andhra Pradesh Reorganisation Act, 2014 provided the legal basis; 2 June 2014 was the appointed day"
      },
      {
        "value": "C",
        "text": "The Andhra Pradesh Reorganisation Act, 2014 provided the legal basis; 30 July 2013 was the appointed day"
      },
      {
        "value": "D",
        "text": "The States Reorganisation Act, 1956 provided the legal basis; 2 June 2014 was the appointed day"
      }
    ],
    "correct_answer": "B",
    "explanation": "The 2014 parliamentary Act and the appointed day are distinct legal and chronological components of state formation."
  },
  {
    "display_order": 35,
    "question_text": "[General Science & Technology] Astronauts in a low Earth orbit appear weightless primarily because:",
    "options": [
      {
        "value": "A",
        "text": "Atmospheric drag balances gravity so that no force acts on the spacecraft"
      },
      {
        "value": "B",
        "text": "They and the spacecraft are in continuous free fall together"
      },
      {
        "value": "C",
        "text": "Centripetal acceleration is absent once orbital speed is reached"
      },
      {
        "value": "D",
        "text": "Gravity acts on the spacecraft but is screened from astronauts inside it"
      }
    ],
    "correct_answer": "B",
    "explanation": "Gravity still acts strongly in low orbit. Shared free fall produces apparent weightlessness."
  },
  {
    "display_order": 38,
    "question_text": "[Current Affairs] Which pairing correctly matches a new criminal law implemented from 1 July 2024 with its primary field?",
    "options": [
      {
        "value": "A",
        "text": "Bharatiya Nyaya Sanhita - criminal procedure"
      },
      {
        "value": "B",
        "text": "Bharatiya Sakshya Adhiniyam - evidence"
      },
      {
        "value": "C",
        "text": "Bharatiya Nagarik Suraksha Sanhita - substantive offences"
      },
      {
        "value": "D",
        "text": "Bharatiya Sakshya Adhiniyam - criminal sentencing"
      }
    ],
    "correct_answer": "B",
    "explanation": "The new laws address substantive criminal law, criminal procedure and evidence respectively; Sakshya Adhiniyam concerns evidence."
  },
  {
    "display_order": 39,
    "question_text": "[Current Affairs] Telangana's Young India Skills University, established in 2024, is distinguished chiefly by:",
    "options": [
      {
        "value": "A",
        "text": "Apprenticeship placement through an industry association without a university framework"
      },
      {
        "value": "B",
        "text": "Academic engineering research through a conventional public university framework"
      },
      {
        "value": "C",
        "text": "Vocational certification through an examination board without industry-led curricula"
      },
      {
        "value": "D",
        "text": "Industry-linked skilling under a public-private partnership framework"
      }
    ],
    "correct_answer": "D",
    "explanation": "The Telangana investment portal describes industry-led curricula, practical training and a PPP legal framework for YISU."
  },
  {
    "display_order": 42,
    "question_text": "[Environment & Disaster Management] Converting an urban wetland into filled construction land can reduce:",
    "options": [
      {
        "value": "A",
        "text": "Flood-water storage, habitat and water-quality functions"
      },
      {
        "value": "B",
        "text": "Flood storage while leaving habitat and water-quality functions unchanged"
      },
      {
        "value": "C",
        "text": "Habitat while leaving flood-water storage and nutrient retention unchanged"
      },
      {
        "value": "D",
        "text": "Water-quality regulation while increasing the filled site's flood storage"
      }
    ],
    "correct_answer": "A",
    "explanation": "Wetlands provide multiple functions whose loss can worsen flooding and ecological conditions beyond the filled plot."
  },
  {
    "display_order": 43,
    "question_text": "[Indian Economy & Telangana Economy] To avoid double counting when measuring domestic output, national accounts primarily sum:",
    "options": [
      {
        "value": "A",
        "text": "Gross sales at each stage without deducting intermediate consumption"
      },
      {
        "value": "B",
        "text": "Final sales plus the intermediate inputs embodied in those sales"
      },
      {
        "value": "C",
        "text": "Value added across production stages"
      },
      {
        "value": "D",
        "text": "Wages plus transfers without including profits and depreciation"
      }
    ],
    "correct_answer": "C",
    "explanation": "Value added subtracts intermediate consumption from output, preventing repeated inclusion of the same inputs."
  },
  {
    "display_order": 44,
    "question_text": "[Current Affairs] According to Telangana's Rythu Bharosa portal, the scheme's principal agricultural purpose is:",
    "options": [
      {
        "value": "A",
        "text": "Timely working-capital assistance near the beginning of crop cycles"
      },
      {
        "value": "B",
        "text": "Compensation assessed after crop losses from notified disasters"
      },
      {
        "value": "C",
        "text": "Interest reimbursement on eligible agricultural term loans"
      },
      {
        "value": "D",
        "text": "Procurement-linked price support after the crop is marketed"
      }
    ],
    "correct_answer": "A",
    "explanation": "The scheme portal describes agricultural financial assistance and working capital. This question avoids disputed or changing eligibility and payment totals."
  },
  {
    "display_order": 45,
    "question_text": "[Indian History & National Movement] Under the Government of India Act, 1919, dyarchy in provinces divided subjects into:",
    "options": [
      {
        "value": "A",
        "text": "Reserved subjects under ministers and transferred subjects under the Governor's executive councillors"
      },
      {
        "value": "B",
        "text": "Federal subjects under elected ministers and provincial subjects under the Viceroy"
      },
      {
        "value": "C",
        "text": "Reserved and transferred categories"
      },
      {
        "value": "D",
        "text": "All provincial subjects under ministers jointly responsible to the legislature"
      }
    ],
    "correct_answer": "C",
    "explanation": "Provincial subjects were divided between reserved administration and transferred responsibilities under ministers."
  },
  {
    "display_order": 49,
    "question_text": "[Telangana History, Culture & State Formation] Kakatiya tank systems are important in environmental history mainly because they:",
    "options": [
      {
        "value": "A",
        "text": "Used isolated storage structures without catchment or settlement linkages"
      },
      {
        "value": "B",
        "text": "Connected water storage, cultivation and settlement in a seasonal-rainfall region"
      },
      {
        "value": "C",
        "text": "Primarily diverted perennial river flows through continuous large canals"
      },
      {
        "value": "D",
        "text": "Prioritised flood evacuation over seasonal agricultural water storage"
      }
    ],
    "correct_answer": "B",
    "explanation": "Tanks and connected local water management supported agriculture and settlements under variable monsoon conditions."
  },
  {
    "display_order": 50,
    "question_text": "[General Science & Technology] Hard water forms scum with soap mainly due to dissolved:",
    "options": [
      {
        "value": "A",
        "text": "Sodium and potassium ions"
      },
      {
        "value": "B",
        "text": "Chloride and nitrate ions"
      },
      {
        "value": "C",
        "text": "Hydrogen and ammonium ions"
      },
      {
        "value": "D",
        "text": "Calcium and magnesium ions"
      }
    ],
    "correct_answer": "D",
    "explanation": "Calcium and magnesium form relatively insoluble soap salts, reducing effective lathering."
  },
  {
    "display_order": 51,
    "question_text": "[Telangana History, Culture & State Formation] Why do libraries and vernacular associations figure prominently in accounts of cultural awakening in Telangana under the Nizam?",
    "options": [
      {
        "value": "A",
        "text": "They mainly standardised revenue records for the state administration"
      },
      {
        "value": "B",
        "text": "They mainly provided formal training for appointments in the state army"
      },
      {
        "value": "C",
        "text": "They mainly operated as official bodies for enforcing press regulations"
      },
      {
        "value": "D",
        "text": "They expanded reading, public discussion and collective awareness"
      }
    ],
    "correct_answer": "D",
    "explanation": "Libraries and language associations created spaces for learning and social awareness within the region's political constraints."
  },
  {
    "display_order": 52,
    "question_text": "[Telangana History, Culture & State Formation] In Telangana's twentieth-century political history, the Andhra Mahasabha is significant because it:",
    "options": [
      {
        "value": "A",
        "text": "Functioned as the Nizam's official council for revenue settlement"
      },
      {
        "value": "B",
        "text": "Served as an association restricted to commercial arbitration"
      },
      {
        "value": "C",
        "text": "Became a platform for cultural and socio-political mobilisation in Hyderabad State"
      },
      {
        "value": "D",
        "text": "Operated as a party devoted to preserving jagirdari privileges"
      }
    ],
    "correct_answer": "C",
    "explanation": "Its activities connected cultural awakening with social and political concerns in the Hyderabad region."
  },
  {
    "display_order": 53,
    "question_text": "[Indian History & National Movement] A principal reason for Indian opposition to the Simon Commission was:",
    "options": [
      {
        "value": "A",
        "text": "The absence of Indian members"
      },
      {
        "value": "B",
        "text": "Its exclusion of elected Indian representatives from the commission's membership while retaining nominated Indian members"
      },
      {
        "value": "C",
        "text": "Its immediate implementation of separate electorates without legislative approval"
      },
      {
        "value": "D",
        "text": "Its replacement of provincial dyarchy with immediate Dominion status"
      }
    ],
    "correct_answer": "A",
    "explanation": "The all-British statutory commission provoked widespread opposition, summarized in the slogan 'Simon Go Back'."
  },
  {
    "display_order": 54,
    "question_text": "[Indian Polity & Constitution] Where valid Union and state laws on a Concurrent List matter conflict, what is the general constitutional rule, subject to Article 254 exceptions?",
    "options": [
      {
        "value": "A",
        "text": "The law enacted later prevails irrespective of the legislature that enacted it"
      },
      {
        "value": "B",
        "text": "Union law prevails to the extent of repugnancy"
      },
      {
        "value": "C",
        "text": "State law prevails whenever its subject has a stronger local connection"
      },
      {
        "value": "D",
        "text": "Both laws remain equally enforceable and the affected person may choose either"
      }
    ],
    "correct_answer": "B",
    "explanation": "Article 254 supplies the general Union-law priority and qualified exceptions for certain presidentially assented state laws."
  },
  {
    "display_order": 55,
    "question_text": "[Telangana History, Culture & State Formation] Which distinction between Bathukamma and Bonalu is correct?",
    "options": [
      {
        "value": "A",
        "text": "Bathukamma centres on food offerings; Bonalu centres on floral arrangements"
      },
      {
        "value": "B",
        "text": "Bathukamma centres on floral arrangements; Bonalu includes food offerings to the goddess"
      },
      {
        "value": "C",
        "text": "Bathukamma centres on decorated bull processions; Bonalu on floral immersion"
      },
      {
        "value": "D",
        "text": "Bathukamma centres on tribal commemorative worship at Medaram; Bonalu on floral immersion"
      }
    ],
    "correct_answer": "B",
    "explanation": "The festivals have distinctive ritual forms even though both occupy important places in Telangana's cultural life."
  },
  {
    "display_order": 56,
    "question_text": "[Indian Polity & Constitution] An ordinance promulgated when the relevant legislature is not in session is best understood as:",
    "options": [
      {
        "value": "A",
        "text": "Delegated rule-making under an existing statute without the force of primary legislation"
      },
      {
        "value": "B",
        "text": "Emergency constitutional amendment effective until judicial confirmation"
      },
      {
        "value": "C",
        "text": "Temporary executive legislation subject to constitutional conditions and legislative oversight"
      },
      {
        "value": "D",
        "text": "Executive legislation that continues unless expressly repealed by the legislature"
      }
    ],
    "correct_answer": "C",
    "explanation": "Ordinance power is conditioned and temporary, with approval and lapse rules on legislative reassembly."
  },
  {
    "display_order": 58,
    "question_text": "[Telangana History, Culture & State Formation] In discussions of Telangana's agrarian history, vetti refers primarily to:",
    "options": [
      {
        "value": "A",
        "text": "A compulsory levy payable as a share of agricultural produce"
      },
      {
        "value": "B",
        "text": "A hereditary right to collect village land revenue"
      },
      {
        "value": "C",
        "text": "Compulsory unpaid labour"
      },
      {
        "value": "D",
        "text": "A tenancy payment made in lieu of cultivating land"
      }
    ],
    "correct_answer": "C",
    "explanation": "Vetti was an exploitative labour practice challenged in struggles against rural oppression."
  },
  {
    "display_order": 60,
    "question_text": "[Indian Economy & Telangana Economy] The principal economic purpose of input tax credit in a value-added tax system is to:",
    "options": [
      {
        "value": "A",
        "text": "Reduce output liability by deducting the full purchase price rather than eligible input tax"
      },
      {
        "value": "B",
        "text": "Reduce cascading by crediting eligible tax paid on inputs"
      },
      {
        "value": "C",
        "text": "Refund every tax paid on inputs irrespective of output liability and eligibility"
      },
      {
        "value": "D",
        "text": "Replace the output-tax liability with a tax only on business profits"
      }
    ],
    "correct_answer": "B",
    "explanation": "Credit offsets eligible input tax against output liability, limiting tax-on-tax effects subject to statutory rules."
  },
  {
    "display_order": 61,
    "question_text": "[Indian Polity & Constitution] Reservations and targeted inclusion measures are most appropriately assessed in relation to:",
    "options": [
      {
        "value": "A",
        "text": "Formal equality requiring identical treatment despite relevant disadvantage"
      },
      {
        "value": "B",
        "text": "Constitutional equality provisions and their permitted protective measures"
      },
      {
        "value": "C",
        "text": "Executive discretion exempt from constitutional review once a policy is called protective"
      },
      {
        "value": "D",
        "text": "A requirement that protective measures be based solely on current household income"
      }
    ],
    "correct_answer": "B",
    "explanation": "Constitutional equality includes provisions enabling specified protective and affirmative measures; legal conditions still govern their use."
  },
  {
    "display_order": 64,
    "question_text": "[Telangana History, Culture & State Formation] The slogan 'Jal, Jangal, Zameen' associated with Komaram Bheem emphasizes:",
    "options": [
      {
        "value": "A",
        "text": "Community rights over water, forests and land"
      },
      {
        "value": "B",
        "text": "Individual land titles in exchange for surrendering community forest access"
      },
      {
        "value": "C",
        "text": "Forest conservation through exclusion of resident tribal communities"
      },
      {
        "value": "D",
        "text": "Cash compensation for relocation without community resource rights"
      }
    ],
    "correct_answer": "A",
    "explanation": "The slogan expresses an interlinked claim to natural resources and land, particularly in tribal-rights struggles."
  },
  {
    "display_order": 66,
    "question_text": "[Indian Geography & Telangana Geography] A watershed boundary generally follows:",
    "options": [
      {
        "value": "A",
        "text": "Topographic divides separating drainage toward different outlets"
      },
      {
        "value": "B",
        "text": "Valley axes connecting the lowest points along stream channels"
      },
      {
        "value": "C",
        "text": "Contours connecting points of equal elevation around each outlet"
      },
      {
        "value": "D",
        "text": "Groundwater equipotential lines inferred independently of surface relief"
      }
    ],
    "correct_answer": "A",
    "explanation": "Drainage divides separate surface runoff destinations and need not coincide with administrative boundaries."
  },
  {
    "display_order": 68,
    "question_text": "[Indian Economy & Telangana Economy] Other things equal, a policy-rate increase intended to restrain demand generally works through:",
    "options": [
      {
        "value": "A",
        "text": "Higher financing costs and moderated borrowing/spending"
      },
      {
        "value": "B",
        "text": "Lower financing costs and increased interest-sensitive spending"
      },
      {
        "value": "C",
        "text": "Higher bank reserves automatically producing lower loan rates"
      },
      {
        "value": "D",
        "text": "Lower deposit returns automatically expanding household consumption"
      }
    ],
    "correct_answer": "A",
    "explanation": "Monetary transmission can raise lending costs and cool interest-sensitive demand, with lags and imperfect pass-through."
  },
  {
    "display_order": 69,
    "question_text": "[General Science & Technology] Carbon monoxide is dangerous chiefly because it:",
    "options": [
      {
        "value": "A",
        "text": "Oxidises haemoglobin iron to form methaemoglobin as its principal mechanism"
      },
      {
        "value": "B",
        "text": "Primarily blocks oxygen entry by causing fluid secretion into the alveoli"
      },
      {
        "value": "C",
        "text": "Primarily reduces blood oxygen through rapid destruction of red blood cells"
      },
      {
        "value": "D",
        "text": "Binds strongly to haemoglobin and impairs oxygen transport"
      }
    ],
    "correct_answer": "D",
    "explanation": "Carboxyhaemoglobin formation reduces effective oxygen transport; the gas can be hazardous without a visible warning."
  },
  {
    "display_order": 70,
    "question_text": "[Indian Economy & Telangana Economy] Several workers leave a farm without reducing its output. This is evidence consistent with:",
    "options": [
      {
        "value": "A",
        "text": "Seasonal unemployment caused by a recurring absence of farm work"
      },
      {
        "value": "B",
        "text": "Disguised unemployment among some workers"
      },
      {
        "value": "C",
        "text": "Frictional unemployment during movement between farm employers"
      },
      {
        "value": "D",
        "text": "Structural unemployment caused by a mismatch with industrial job requirements"
      }
    ],
    "correct_answer": "B",
    "explanation": "When some labour has negligible marginal product, reducing labour need not reduce output; this is a classic disguised-unemployment setting."
  },
  {
    "display_order": 71,
    "question_text": "[Indian Polity & Constitution] Which statement correctly distinguishes Directive Principles from Fundamental Rights?",
    "options": [
      {
        "value": "A",
        "text": "Directive Principles confer directly enforceable individual remedies equivalent to Article 32"
      },
      {
        "value": "B",
        "text": "Directive Principles guide governance but are not directly enforceable by courts in the same manner"
      },
      {
        "value": "C",
        "text": "Directive Principles bind courts to invalidate every inconsistent statute without further constitutional grounds"
      },
      {
        "value": "D",
        "text": "Directive Principles operate as judicially enforceable duties of individual citizens"
      }
    ],
    "correct_answer": "B",
    "explanation": "Part IV principles are fundamental to governance but are not judicially enforceable as such under Article 37."
  },
  {
    "display_order": 76,
    "question_text": "[Indian Geography & Telangana Geography] Deep black soils commonly develop shrinkage cracks during dry weather because they contain:",
    "options": [
      {
        "value": "A",
        "text": "Kaolinitic clays with low shrink-swell potential"
      },
      {
        "value": "B",
        "text": "Iron-oxide cementation without expandable clay minerals"
      },
      {
        "value": "C",
        "text": "Expansive clay minerals with strong wetting-drying volume changes"
      },
      {
        "value": "D",
        "text": "High silt content with negligible clay-related volume change"
      }
    ],
    "correct_answer": "C",
    "explanation": "Shrink-swell clay behaviour explains both dry-season cracking and high moisture retention."
  },
  {
    "display_order": 77,
    "question_text": "[Indian History & National Movement] Which pairing correctly identifies the principal settlement unit?",
    "options": [
      {
        "value": "A",
        "text": "Ryotwari - village estate; Mahalwari - individual cultivator"
      },
      {
        "value": "B",
        "text": "Ryotwari - zamindar; Mahalwari - individual cultivator"
      },
      {
        "value": "C",
        "text": "Ryotwari - village estate; Mahalwari - zamindar"
      },
      {
        "value": "D",
        "text": "Ryotwari - individual cultivator; Mahalwari - village estate or mahal"
      }
    ],
    "correct_answer": "D",
    "explanation": "These systems differed in the unit with which revenue settlement was made, although actual operation varied by region."
  },
  {
    "display_order": 78,
    "question_text": "[Indian Geography & Telangana Geography] Winter precipitation over northwestern India is closely associated with:",
    "options": [
      {
        "value": "A",
        "text": "Northeast monsoon depressions"
      },
      {
        "value": "B",
        "text": "Southwest monsoon onset vortices"
      },
      {
        "value": "C",
        "text": "Local pre-monsoon convective storms"
      },
      {
        "value": "D",
        "text": "Western disturbances"
      }
    ],
    "correct_answer": "D",
    "explanation": "Western disturbances are extratropical systems affecting winter weather, including Himalayan snow and northwestern rainfall."
  },
  {
    "display_order": 79,
    "question_text": "[Current Affairs] ISRO's successful SpaDeX docking on 16 January 2025 principally demonstrated which capability?",
    "options": [
      {
        "value": "A",
        "text": "Autonomous rendezvous without mechanical capture"
      },
      {
        "value": "B",
        "text": "Transfer of propellant between docked spacecraft"
      },
      {
        "value": "C",
        "text": "Rendezvous and docking of spacecraft in orbit"
      },
      {
        "value": "D",
        "text": "Robotic assembly of a modular space station"
      }
    ],
    "correct_answer": "C",
    "explanation": "ISRO reported docking SDX-01 and SDX-02 on that date. The demonstrated capability was in-space docking, not planetary landing."
  },
  {
    "display_order": 80,
    "question_text": "[Indian Economy & Telangana Economy] Unexpected inflation most directly reduces the purchasing power of:",
    "options": [
      {
        "value": "A",
        "text": "A fixed nominal income that does not adjust with prices"
      },
      {
        "value": "B",
        "text": "A nominal income that rises in the same proportion as the consumer price level"
      },
      {
        "value": "C",
        "text": "A nominal income that rises faster than the consumer price level"
      },
      {
        "value": "D",
        "text": "A payment fully indexed to the same consumer price measure"
      }
    ],
    "correct_answer": "A",
    "explanation": "With nominal income unchanged, a rise in prices buys fewer goods and services."
  },
  {
    "display_order": 81,
    "question_text": "[Current Affairs] An ISRO report in October 2026 described a joint coronagraph view of solar eruptions near their origin. Which mission pair was involved?",
    "options": [
      {
        "value": "A",
        "text": "India's Aditya-L1 and Europe's Proba-3"
      },
      {
        "value": "B",
        "text": "India's Aditya-L1 and Europe's Solar Orbiter"
      },
      {
        "value": "C",
        "text": "India's Aditya-L1 and NASA's Parker Solar Probe"
      },
      {
        "value": "D",
        "text": "Europe's Proba-3 and NASA's Solar Dynamics Observatory"
      }
    ],
    "correct_answer": "A",
    "explanation": "The ISRO report identifies observations by coronagraphs on Aditya-L1 and Proba-3. These solar observations differ from lunar, Martian and navigation missions."
  },
  {
    "display_order": 82,
    "question_text": "[Environment & Disaster Management] Two towns face the same flood depth, but one has weaker housing and fewer evacuation resources. Its greater expected loss chiefly reflects higher:",
    "options": [
      {
        "value": "A",
        "text": "Hazard intensity"
      },
      {
        "value": "B",
        "text": "Vulnerability"
      },
      {
        "value": "C",
        "text": "Forecast lead time"
      },
      {
        "value": "D",
        "text": "Return period of the flood"
      }
    ],
    "correct_answer": "B",
    "explanation": "Risk depends on hazard, exposure and vulnerability. Equal hazard intensity can cause very different losses."
  },
  {
    "display_order": 84,
    "question_text": "[Indian Economy & Telangana Economy] For a small enterprise, financial inclusion is most meaningful when formal access is accompanied by:",
    "options": [
      {
        "value": "A",
        "text": "Account ownership without affordable access to transactions or credit"
      },
      {
        "value": "B",
        "text": "Expanded loan access without assessment of suitability or repayment capacity"
      },
      {
        "value": "C",
        "text": "Affordable usable services, consumer protection and financial capability"
      },
      {
        "value": "D",
        "text": "Digital registration without accessible mechanisms for complaints and redress"
      }
    ],
    "correct_answer": "C",
    "explanation": "Opening an account is only an entry point; effective inclusion requires appropriate, safe and usable financial services."
  },
  {
    "display_order": 87,
    "question_text": "[General Science & Technology] Which pairing correctly distinguishes typical DNA from RNA?",
    "options": [
      {
        "value": "A",
        "text": "DNA usually contains ribose and thymine; RNA usually contains deoxyribose and uracil"
      },
      {
        "value": "B",
        "text": "DNA usually contains deoxyribose and uracil; RNA usually contains ribose and thymine"
      },
      {
        "value": "C",
        "text": "DNA usually contains ribose and uracil; RNA usually contains deoxyribose and thymine"
      },
      {
        "value": "D",
        "text": "DNA usually contains deoxyribose and thymine; RNA usually contains ribose and uracil"
      }
    ],
    "correct_answer": "D",
    "explanation": "The sugar and one characteristic base differ; actual structures and roles are more varied than an absolute single/double-strand rule."
  },
  {
    "display_order": 90,
    "question_text": "[Telangana History, Culture & State Formation] Cheriyal painting is especially associated with:",
    "options": [
      {
        "value": "A",
        "text": "Freehand textile painting organised around temple hangings"
      },
      {
        "value": "B",
        "text": "Narrative scrolls linked to oral storytelling"
      },
      {
        "value": "C",
        "text": "Wax-resist textile patterning for repeated decorative motifs"
      },
      {
        "value": "D",
        "text": "Metal-inlay ornamentation on darkened alloy surfaces"
      }
    ],
    "correct_answer": "B",
    "explanation": "Cheriyal scrolls organize painted episodes for narrative performance and storytelling."
  },
  {
    "display_order": 92,
    "question_text": "[Basic English] In 'The revised timetable is not set in stone', the phrase means that the timetable:",
    "options": [
      {
        "value": "A",
        "text": "Must be followed without any later revision"
      },
      {
        "value": "B",
        "text": "Can still be changed"
      },
      {
        "value": "C",
        "text": "Has been formally approved for immediate implementation"
      },
      {
        "value": "D",
        "text": "Has been postponed until a final decision is made"
      }
    ],
    "correct_answer": "B",
    "explanation": "The idiom 'set in stone' means fixed or unchangeable; negating it signals flexibility."
  },
  {
    "display_order": 94,
    "question_text": "[General Science & Technology] Stopping an antibiotic course or using antibiotics unnecessarily is a concern chiefly because inappropriate use can:",
    "options": [
      {
        "value": "A",
        "text": "Select for resistant microbial populations"
      },
      {
        "value": "B",
        "text": "Create immune memory against the antibiotic rather than the pathogen"
      },
      {
        "value": "C",
        "text": "Cause susceptible bacteria to become resistant through purposeful adaptation to the patient's needs"
      },
      {
        "value": "D",
        "text": "Increase resistance mainly by reducing the patient's antibody production"
      }
    ],
    "correct_answer": "A",
    "explanation": "Selection favours organisms that survive exposure, contributing to antimicrobial resistance; clinical treatment should follow appropriate guidance."
  },
  {
    "display_order": 96,
    "question_text": "[Indian History & National Movement] Which policy intensified resentment among several princely ruling families before the revolt of 1857?",
    "options": [
      {
        "value": "A",
        "text": "Subsidiary alliances guaranteeing unrestricted adoption-based succession"
      },
      {
        "value": "B",
        "text": "Permanent Settlement provisions governing revenue in Bengal"
      },
      {
        "value": "C",
        "text": "Doctrine of Lapse annexations"
      },
      {
        "value": "D",
        "text": "The Charter Act's opening of Indian trade to private British merchants"
      }
    ],
    "correct_answer": "C",
    "explanation": "The Doctrine of Lapse challenged adoption-based succession and enabled annexations, creating resentment among affected ruling families. The other policies address different mechanisms of colonial control."
  },
  {
    "display_order": 98,
    "question_text": "[Indian History & National Movement] The Vernacular Press Act of 1878 particularly targeted:",
    "options": [
      {
        "value": "A",
        "text": "Indian-language publications regardless of whether they criticised the government, under rules identical to English newspapers"
      },
      {
        "value": "B",
        "text": "English-language publications critical of colonial administration under a separate licensing system"
      },
      {
        "value": "C",
        "text": "Indian-language publications critical of colonial administration"
      },
      {
        "value": "D",
        "text": "All periodicals through a uniform pre-publication censorship rule irrespective of language"
      }
    ],
    "correct_answer": "C",
    "explanation": "It imposed discriminatory controls on vernacular newspapers and became a prominent issue in colonial civil-liberties debates."
  },
  {
    "display_order": 99,
    "question_text": "[Current Affairs] Aditya-L1's halo-orbit insertion on 6 January 2024 placed the observatory around:",
    "options": [
      {
        "value": "A",
        "text": "The second Sun-Earth Lagrange point"
      },
      {
        "value": "B",
        "text": "The first Sun-Earth Lagrange point"
      },
      {
        "value": "C",
        "text": "The fourth Sun-Earth Lagrange point"
      },
      {
        "value": "D",
        "text": "The second Earth-Moon Lagrange point"
      }
    ],
    "correct_answer": "B",
    "explanation": "ISRO records insertion into a halo orbit around Sun-Earth L1, enabling sustained solar observations."
  },
  {
    "display_order": 101,
    "question_text": "[General Science & Technology] A grid with a large share of solar generation particularly benefits from storage and flexible demand because:",
    "options": [
      {
        "value": "A",
        "text": "Solar output follows demand closely enough that storage mainly compensates for billing delays"
      },
      {
        "value": "B",
        "text": "Installed solar capacity measures guaranteed instantaneous output regardless of weather"
      },
      {
        "value": "C",
        "text": "Generation varies with daylight and weather"
      },
      {
        "value": "D",
        "text": "Storage increases the daily solar energy input rather than shifting delivery over time"
      }
    ],
    "correct_answer": "C",
    "explanation": "Flexibility helps balance variable generation against demand; storage shifts energy in time rather than creating it."
  },
  {
    "display_order": 102,
    "question_text": "[Telangana History, Culture & State Formation] Perini Sivatandavam is conventionally linked with which historical-cultural setting?",
    "options": [
      {
        "value": "A",
        "text": "Kakatiya-era martial dance traditions"
      },
      {
        "value": "B",
        "text": "Qutb Shahi court traditions of narrative dance"
      },
      {
        "value": "C",
        "text": "Asaf Jahi court traditions of devotional music"
      },
      {
        "value": "D",
        "text": "Vijayanagara temple traditions of dance-drama"
      }
    ],
    "correct_answer": "A",
    "explanation": "Perini is associated with the Kakatiya cultural legacy and a vigorous martial dance idiom."
  },
  {
    "display_order": 103,
    "question_text": "[Indian Polity & Constitution] A public examination provides an accessible format and reasonable adjustments for eligible disabled candidates. This most directly advances:",
    "options": [
      {
        "value": "A",
        "text": "Formal equality through identical examination conditions for every candidate"
      },
      {
        "value": "B",
        "text": "Substantive equality and reasonable accommodation"
      },
      {
        "value": "C",
        "text": "Compensatory preference unrelated to barriers in the examination process"
      },
      {
        "value": "D",
        "text": "Equality of outcomes through identical marks for eligible candidates"
      }
    ],
    "correct_answer": "B",
    "explanation": "Equal participation can require removal of barriers rather than identical treatment regardless of disability-related needs."
  },
  {
    "display_order": 105,
    "question_text": "[Environment & Disaster Management] A persistent fat-soluble pollutant tends to reach its highest concentration in:",
    "options": [
      {
        "value": "A",
        "text": "Short-lived primary producers at the base of the same food chain"
      },
      {
        "value": "B",
        "text": "Long-lived predators at higher trophic levels"
      },
      {
        "value": "C",
        "text": "Primary consumers feeding only on the producers in that chain"
      },
      {
        "value": "D",
        "text": "Secondary consumers below the top predators in that chain"
      }
    ],
    "correct_answer": "B",
    "explanation": "Persistent pollutants can accumulate in organisms and become more concentrated through feeding relationships."
  },
  {
    "display_order": 106,
    "question_text": "[Indian Polity & Constitution] The constitutional audit institution headed by the CAG primarily supports:",
    "options": [
      {
        "value": "A",
        "text": "Executive financial control through prior approval of each spending decision"
      },
      {
        "value": "B",
        "text": "Legislative budget allocation through binding recommendations on tax rates"
      },
      {
        "value": "C",
        "text": "Administrative financial management through preparation of departmental accounts"
      },
      {
        "value": "D",
        "text": "Legislative financial accountability through independent audit"
      }
    ],
    "correct_answer": "D",
    "explanation": "Audit reports support scrutiny of public finances; the CAG does not replace the executive as spending authority."
  },
  {
    "display_order": 108,
    "question_text": "[General Science & Technology] A message imitates a trusted portal and requests a password through an unfamiliar link. The safest immediate response is to:",
    "options": [
      {
        "value": "A",
        "text": "Open the supplied link and trust it if the page displays a padlock"
      },
      {
        "value": "B",
        "text": "Reply to the sender requesting confirmation before entering the password on the supplied page"
      },
      {
        "value": "C",
        "text": "Avoid the link and verify through the independently accessed official service"
      },
      {
        "value": "D",
        "text": "Enter the password if the linked page reproduces the portal's usual branding"
      }
    ],
    "correct_answer": "C",
    "explanation": "Phishing exploits impersonation. Independent verification avoids relying on the suspicious message's link or appearance."
  },
  {
    "display_order": 110,
    "question_text": "[Telangana History, Culture & State Formation] Which description best fits Kaloji Narayana Rao's literary and public contribution?",
    "options": [
      {
        "value": "A",
        "text": "Court-centred poetry celebrating dynastic authority"
      },
      {
        "value": "B",
        "text": "Poetry closely connected with people's lives and democratic concerns"
      },
      {
        "value": "C",
        "text": "Devotional poetry centred on the Telugu Bhagavata rendering"
      },
      {
        "value": "D",
        "text": "Classical court epic centred on the Vijayanagara imperial ideal"
      }
    ],
    "correct_answer": "B",
    "explanation": "Kaloji's writing and activism are associated with human experience, civil liberties and a strong Telangana cultural voice."
  },
  {
    "display_order": 111,
    "question_text": "[Telangana History, Culture & State Formation] The Gentlemen's Agreement associated with the 1956 merger was principally intended to:",
    "options": [
      {
        "value": "A",
        "text": "Provide safeguards for Telangana within the merged state"
      },
      {
        "value": "B",
        "text": "Establish a separate Telangana state before the linguistic merger"
      },
      {
        "value": "C",
        "text": "Extend the Andhra region's service rules without regional safeguards"
      },
      {
        "value": "D",
        "text": "Place the Telangana region under a separately administered Union Territory"
      }
    ],
    "correct_answer": "A",
    "explanation": "The agreement sought regional safeguards concerning matters such as employment, expenditure and administration during the merger."
  },
  {
    "display_order": 112,
    "question_text": "[Indian Economy & Telangana Economy] A tax is progressive in the income-tax sense when:",
    "options": [
      {
        "value": "A",
        "text": "Its marginal rate is positive but its average rate remains constant"
      },
      {
        "value": "B",
        "text": "Its average rate falls as taxable income rises"
      },
      {
        "value": "C",
        "text": "Its absolute tax payment rises while its average rate falls"
      },
      {
        "value": "D",
        "text": "Its average tax rate rises with taxable income"
      }
    ],
    "correct_answer": "D",
    "explanation": "Progressivity concerns how the tax burden relative to income changes across income levels, not just collection method."
  },
  {
    "display_order": 113,
    "question_text": "[General Science & Technology] An educational prediction model is tested on examples that were also used to train it. The principal evaluation problem is:",
    "options": [
      {
        "value": "A",
        "text": "Sampling variance caused solely by a small independent test set"
      },
      {
        "value": "B",
        "text": "Data leakage can overstate performance on unseen students or questions"
      },
      {
        "value": "C",
        "text": "Underfitting caused solely by an insufficiently complex model"
      },
      {
        "value": "D",
        "text": "Label imbalance caused solely by unequal numbers of classes"
      }
    ],
    "correct_answer": "B",
    "explanation": "A separate representative test set is needed to estimate generalization. Reusing training examples can inflate apparent accuracy."
  },
  {
    "display_order": 114,
    "question_text": "[Indian History & National Movement] Dadabhai Naoroji's drain theory emphasized:",
    "options": [
      {
        "value": "A",
        "text": "Adverse terms of trade caused solely by changes in international commodity prices"
      },
      {
        "value": "B",
        "text": "Domestic transfers of agricultural surplus from tenants to Indian landlords"
      },
      {
        "value": "C",
        "text": "Unrequited transfer of economic resources from India to Britain"
      },
      {
        "value": "D",
        "text": "Revenue loss caused solely by collecting land taxes below their assessed value"
      }
    ],
    "correct_answer": "C",
    "explanation": "The argument concerned economic transfers without equivalent domestic benefit, including certain home charges and remittances."
  },
  {
    "display_order": 115,
    "question_text": "[Telangana History, Culture & State Formation] The Sammakka-Saralamma Jatara at Medaram is especially associated with which tribal community?",
    "options": [
      {
        "value": "A",
        "text": "Gond"
      },
      {
        "value": "B",
        "text": "Chenchu"
      },
      {
        "value": "C",
        "text": "Koya"
      },
      {
        "value": "D",
        "text": "Lambada"
      }
    ],
    "correct_answer": "C",
    "explanation": "The Medaram festival has a strong Koya tribal association while attracting a much wider gathering."
  },
  {
    "display_order": 117,
    "question_text": "[Indian Polity & Constitution] A person directly approaches the Supreme Court to enforce a fundamental right. The principal constitutional remedy is under:",
    "options": [
      {
        "value": "A",
        "text": "Article 32"
      },
      {
        "value": "B",
        "text": "Article 226"
      },
      {
        "value": "C",
        "text": "Article 136"
      },
      {
        "value": "D",
        "text": "Article 227"
      }
    ],
    "correct_answer": "A",
    "explanation": "Article 32 guarantees the right to constitutional remedies for enforcement of fundamental rights."
  },
  {
    "display_order": 118,
    "question_text": "[Environment & Disaster Management] Which measure most directly protects outdoor workers during a heatwave?",
    "options": [
      {
        "value": "A",
        "text": "Maintain afternoon shifts and rely on drinking water only after work"
      },
      {
        "value": "B",
        "text": "Provide shaded breaks while withholding drinking water until thirst becomes severe"
      },
      {
        "value": "C",
        "text": "Rescheduled work, shaded breaks and access to safe drinking water"
      },
      {
        "value": "D",
        "text": "Replace work-rest scheduling with acclimatisation alone during extreme heat"
      }
    ],
    "correct_answer": "C",
    "explanation": "Reducing heat exposure and supporting hydration are practical protective measures; implementation should follow local health guidance."
  },
  {
    "display_order": 119,
    "question_text": "[Basic English] Choose the correct completion: 'If she had checked the units, she ___ the error.'",
    "options": [
      {
        "value": "A",
        "text": "would have found"
      },
      {
        "value": "B",
        "text": "would find"
      },
      {
        "value": "C",
        "text": "would have find"
      },
      {
        "value": "D",
        "text": "had found"
      }
    ],
    "correct_answer": "A",
    "explanation": "The third conditional combines a past-perfect condition with 'would have' plus a past participle."
  },
  {
    "display_order": 121,
    "question_text": "[Current Affairs] The UN's 2025 International Year of Quantum Science and Technology most directly sought attention to:",
    "options": [
      {
        "value": "A",
        "text": "Quantum science and its applications"
      },
      {
        "value": "B",
        "text": "Standardising quantum-resistant encryption across all UN member states"
      },
      {
        "value": "C",
        "text": "Establishing a UN licensing authority for quantum computing laboratories"
      },
      {
        "value": "D",
        "text": "Restricting quantum research funding to high-energy particle physics"
      }
    ],
    "correct_answer": "A",
    "explanation": "The UN list names 2025 as the International Year of Quantum Science and Technology, distinct from the 2026 observances."
  },
  {
    "display_order": 122,
    "question_text": "[Basic English] Read: 'Only candidates who submitted the form were considered.' Which conclusion follows?",
    "options": [
      {
        "value": "A",
        "text": "Submission was necessary for consideration, but did not guarantee it"
      },
      {
        "value": "B",
        "text": "Submission was sufficient for consideration, whether or not other requirements were met"
      },
      {
        "value": "C",
        "text": "Every candidate who submitted the form was necessarily considered"
      },
      {
        "value": "D",
        "text": "Consideration was necessary before a candidate could submit the form"
      }
    ],
    "correct_answer": "A",
    "explanation": "The statement sets a necessary condition. It does not say submission was sufficient for consideration or selection."
  },
  {
    "display_order": 123,
    "question_text": "[Environment & Disaster Management] Which is a secondary hazard that an earthquake can trigger?",
    "options": [
      {
        "value": "A",
        "text": "Ground shaking generated by seismic-wave propagation"
      },
      {
        "value": "B",
        "text": "Surface displacement along the ruptured fault"
      },
      {
        "value": "C",
        "text": "Landslides on unstable slopes"
      },
      {
        "value": "D",
        "text": "Release of accumulated strain on the fault plane"
      }
    ],
    "correct_answer": "C",
    "explanation": "Earthquake shaking can destabilize slopes, while fault rupture and shaking are primary processes."
  },
  {
    "display_order": 124,
    "question_text": "[Indian Economy & Telangana Economy] A social audit of a public employment programme primarily strengthens:",
    "options": [
      {
        "value": "A",
        "text": "Departmental verification limited to internal vouchers and accounting entries"
      },
      {
        "value": "B",
        "text": "Independent financial certification limited to compliance with accounting standards"
      },
      {
        "value": "C",
        "text": "Technical appraisal limited to engineering specifications of completed works"
      },
      {
        "value": "D",
        "text": "Community verification of implementation and expenditure"
      }
    ],
    "correct_answer": "D",
    "explanation": "Social audits bring records and beneficiary experience into public scrutiny; they complement rather than replace other audit mechanisms."
  },
  {
    "display_order": 126,
    "question_text": "[Environment & Disaster Management] Replacing permeable ground with connected paved surfaces tends to:",
    "options": [
      {
        "value": "A",
        "text": "Increase rapid runoff and shorten response time"
      },
      {
        "value": "B",
        "text": "Decrease rapid runoff and lengthen catchment response time"
      },
      {
        "value": "C",
        "text": "Increase infiltration while leaving the runoff peak unchanged"
      },
      {
        "value": "D",
        "text": "Reduce the runoff coefficient while shortening catchment response time"
      }
    ],
    "correct_answer": "A",
    "explanation": "Impervious surfaces reduce infiltration and route water rapidly; drainage capacity and rainfall still govern actual flooding."
  },
  {
    "display_order": 129,
    "question_text": "[Telangana History, Culture & State Formation] The Qutb Shahi dynasty is historically associated most directly with:",
    "options": [
      {
        "value": "A",
        "text": "Bidar and the development of the Barid Shahi capital"
      },
      {
        "value": "B",
        "text": "Bijapur and the development of the Adil Shahi capital"
      },
      {
        "value": "C",
        "text": "Ahmadnagar and the development of the Nizam Shahi capital"
      },
      {
        "value": "D",
        "text": "Golconda and the development of Hyderabad"
      }
    ],
    "correct_answer": "D",
    "explanation": "Golconda and Hyderabad are central to Qutb Shahi political and cultural history."
  },
  {
    "display_order": 130,
    "question_text": "[General Science & Technology] Which system is an active remote-sensing instrument?",
    "options": [
      {
        "value": "A",
        "text": "A multispectral scanner recording reflected solar radiation"
      },
      {
        "value": "B",
        "text": "Radar that transmits microwave pulses and records returns"
      },
      {
        "value": "C",
        "text": "A thermal infrared radiometer recording terrestrial emission"
      },
      {
        "value": "D",
        "text": "A microwave radiometer recording natural surface emission"
      }
    ],
    "correct_answer": "B",
    "explanation": "Active systems supply their own illumination; radar transmits and measures backscatter."
  },
  {
    "display_order": 131,
    "question_text": "[Indian Geography & Telangana Geography] Which physical description best characterizes most of Telangana?",
    "options": [
      {
        "value": "A",
        "text": "An extensive alluvial plain dominated by recent river deposits"
      },
      {
        "value": "B",
        "text": "An interior peninsular plateau with varied uplands and river valleys"
      },
      {
        "value": "C",
        "text": "A young folded upland dominated by active crustal compression"
      },
      {
        "value": "D",
        "text": "A basaltic coastal plain dominated by tidal estuaries"
      }
    ],
    "correct_answer": "B",
    "explanation": "Telangana lies on the Deccan Plateau rather than a coast, Himalayan belt or island chain."
  },
  {
    "display_order": 132,
    "question_text": "[Indian History & National Movement] The Swadeshi movement following Bengal's 1905 partition combined boycott with:",
    "options": [
      {
        "value": "A",
        "text": "Promotion of imported substitutes through preferential imperial tariffs"
      },
      {
        "value": "B",
        "text": "Promotion of indigenous production and national education"
      },
      {
        "value": "C",
        "text": "Expansion of elected councils as a substitute for economic boycott"
      },
      {
        "value": "D",
        "text": "Reliance on petitions while discouraging national educational institutions"
      }
    ],
    "correct_answer": "B",
    "explanation": "Swadeshi linked political protest to domestic enterprise, education and self-reliance."
  },
  {
    "display_order": 133,
    "question_text": "[Telangana History, Culture & State Formation] The committee headed by Justice B.N. Srikrishna in 2010 was appointed primarily to:",
    "options": [
      {
        "value": "A",
        "text": "Frame binding service-allocation rules for two already-created successor states"
      },
      {
        "value": "B",
        "text": "Examine issues relating to demands concerning Andhra Pradesh's statehood arrangements"
      },
      {
        "value": "C",
        "text": "Determine the interstate river-water entitlements of two successor states"
      },
      {
        "value": "D",
        "text": "Implement the final territorial boundaries of an already-approved Telangana state"
      }
    ],
    "correct_answer": "B",
    "explanation": "The committee examined the Telangana and united-Andhra Pradesh questions and submitted a report with options."
  },
  {
    "display_order": 136,
    "question_text": "[Telangana History, Culture & State Formation] Debates over Mulki rules in the former Hyderabad region primarily concerned:",
    "options": [
      {
        "value": "A",
        "text": "Seniority based on length of service irrespective of domicile"
      },
      {
        "value": "B",
        "text": "Local status and eligibility for public employment"
      },
      {
        "value": "C",
        "text": "Reservation of legislative seats by regional population"
      },
      {
        "value": "D",
        "text": "Allocation of regional revenue by place of tax collection"
      }
    ],
    "correct_answer": "B",
    "explanation": "Mulki rules concerned domicile/local status and employment protection, making them central to regional-rights debates."
  },
  {
    "display_order": 137,
    "question_text": "[Indian Economy & Telangana Economy] Public investment in reliable irrigation can affect rural development through:",
    "options": [
      {
        "value": "A",
        "text": "Lower production risk even when supply reliability and distribution remain unchanged"
      },
      {
        "value": "B",
        "text": "Reduced production risk and potential productivity gains, subject to water and distribution constraints"
      },
      {
        "value": "C",
        "text": "Higher productivity independent of crop choice and complementary farm inputs"
      },
      {
        "value": "D",
        "text": "Higher rural incomes through expansion of cultivated area even when water availability falls"
      }
    ],
    "correct_answer": "B",
    "explanation": "Irrigation can improve reliability and productivity, but benefits depend on sustainable supply, access and complementary inputs."
  },
  {
    "display_order": 139,
    "question_text": "[Environment & Disaster Management] Excess nutrient input into a lake can ultimately lower dissolved oxygen because:",
    "options": [
      {
        "value": "A",
        "text": "Algal photosynthesis consumes oxygen during daylight faster than respiration"
      },
      {
        "value": "B",
        "text": "Algal biomass decomposition consumes oxygen"
      },
      {
        "value": "C",
        "text": "Nutrients lower oxygen mainly by increasing its chemical solubility"
      },
      {
        "value": "D",
        "text": "Nutrients suppress biomass production, thereby increasing decomposition demand"
      }
    ],
    "correct_answer": "B",
    "explanation": "Nutrients stimulate growth; subsequent respiration and decomposition can create oxygen depletion."
  },
  {
    "display_order": 141,
    "question_text": "[Indian Geography & Telangana Geography] Which contrast is broadly correct?",
    "options": [
      {
        "value": "A",
        "text": "Himalayan flows depend mainly on winter rain, while peninsular flows depend mainly on summer snowmelt"
      },
      {
        "value": "B",
        "text": "Both river groups generally receive equal proportions of glacier melt and monsoon rainfall"
      },
      {
        "value": "C",
        "text": "Many Himalayan rivers have snow/glacier and rainfall inputs, while peninsular flows are more monsoon-dependent"
      },
      {
        "value": "D",
        "text": "Peninsular flows are less seasonal because their catchments generally contain larger glaciers"
      }
    ],
    "correct_answer": "C",
    "explanation": "Source regimes affect seasonality, although individual rivers and regulated flows differ."
  },
  {
    "display_order": 145,
    "question_text": "[Environment & Disaster Management] Which statement distinguishes an invasive alien species from an endemic species?",
    "options": [
      {
        "value": "A",
        "text": "An invasive alien can spread harmfully outside its native range; an endemic is native to a restricted area"
      },
      {
        "value": "B",
        "text": "An invasive alien is any introduced species, regardless of spread or ecological impact"
      },
      {
        "value": "C",
        "text": "An endemic is any threatened species, regardless of its native geographic range"
      },
      {
        "value": "D",
        "text": "An invasive alien must be globally widespread, while an endemic must be locally abundant"
      }
    ],
    "correct_answer": "A",
    "explanation": "Origin, range and ecological impact are separate properties; not every non-native species becomes invasive."
  },
  {
    "display_order": 146,
    "question_text": "[Telangana History, Culture & State Formation] Which work is associated with Bammera Pothana?",
    "options": [
      {
        "value": "A",
        "text": "Andhra Mahabharatamu"
      },
      {
        "value": "B",
        "text": "Panduranga Mahatmyamu"
      },
      {
        "value": "C",
        "text": "Manucharitramu"
      },
      {
        "value": "D",
        "text": "Andhra Mahabhagavatamu"
      }
    ],
    "correct_answer": "D",
    "explanation": "Pothana is celebrated for his Telugu rendering of the Bhagavata tradition. The distractors belong to different authors and contexts."
  },
  {
    "display_order": 147,
    "question_text": "[Indian Polity & Constitution] The basic-structure doctrine chiefly limits:",
    "options": [
      {
        "value": "A",
        "text": "Parliament's ordinary legislative competence under the Union List"
      },
      {
        "value": "B",
        "text": "Parliament's constitutional-amendment power"
      },
      {
        "value": "C",
        "text": "The executive's power to frame rules under an ordinary statute"
      },
      {
        "value": "D",
        "text": "The judiciary's power to review administrative discretion"
      }
    ],
    "correct_answer": "B",
    "explanation": "Constitutional amendments may change many provisions but cannot destroy the Constitution's basic structure."
  },
  {
    "display_order": 149,
    "question_text": "[Current Affairs] Under Telangana GO Ms No.36 dated 14 April 2025, the Bhu Bharati Act brought into force on that date principally concerns:",
    "options": [
      {
        "value": "A",
        "text": "Record of rights in land"
      },
      {
        "value": "B",
        "text": "Regulation of agricultural tenancy and crop-sharing contracts"
      },
      {
        "value": "C",
        "text": "Consolidation of fragmented agricultural holdings"
      },
      {
        "value": "D",
        "text": "Acquisition of agricultural land for public infrastructure"
      }
    ],
    "correct_answer": "A",
    "explanation": "The commencement order identifies the Telangana Bhu Bharati (Record of Rights in Land) Act, 2025."
  },
  {
    "display_order": 150,
    "question_text": "[Indian History & National Movement] The 1829 regulation prohibiting sati in the Bengal Presidency is associated with which Governor-General?",
    "options": [
      {
        "value": "A",
        "text": "Lord Amherst"
      },
      {
        "value": "B",
        "text": "William Bentinck"
      },
      {
        "value": "C",
        "text": "Lord Hastings"
      },
      {
        "value": "D",
        "text": "Lord Auckland"
      }
    ],
    "correct_answer": "B",
    "explanation": "Bentinck issued the regulation amid sustained reform advocacy, including the work of Raja Rammohan Roy."
  }
]$payload$::JSONB;
BEGIN
 PERFORM pg_advisory_xact_lock(hashtext('TGPSC AEE 2026 - General Studies Full Length Mock 01'));
 IF (SELECT count(*) FROM public.mock_tests WHERE title='TGPSC AEE 2026 - General Studies Full Length Mock 01')<>1 THEN
  RAISE EXCEPTION 'Expected one GS mock under its original title; reconcile titles first';
 END IF;
 SELECT id INTO v_test FROM public.mock_tests WHERE title='TGPSC AEE 2026 - General Studies Full Length Mock 01';
 IF (SELECT count(*) FROM public.mock_questions WHERE mock_test_id=v_test)<>150 THEN
  RAISE EXCEPTION 'Expected 150 GS questions';
 END IF;
 IF EXISTS(SELECT 1 FROM jsonb_to_recordset(v_payload) AS r(display_order INT,question_text TEXT,correct_answer TEXT)
 LEFT JOIN public.mock_questions q ON q.mock_test_id=v_test AND q.display_order=r.display_order
 WHERE q.id IS NULL OR q.question_text IS DISTINCT FROM r.question_text OR q.correct_answer IS DISTINCT FROM r.correct_answer) THEN
  RAISE EXCEPTION 'GS question identity or key differs; review before applying revision';
 END IF;
 IF EXISTS(SELECT 1 FROM public.mock_questions q JOIN jsonb_to_recordset(v_payload)
 AS r(display_order INT,options JSONB,explanation TEXT) ON q.display_order=r.display_order
 WHERE q.mock_test_id=v_test AND (q.options IS DISTINCT FROM r.options OR q.explanation IS DISTINCT FROM r.explanation)) THEN
  IF EXISTS(SELECT 1 FROM public.mock_attempts WHERE mock_test_id=v_test) THEN
   RAISE EXCEPTION 'GS mock has attempts; revision refused to preserve history. A separate edition is required';
  END IF;
  UPDATE public.mock_questions q SET options=r.options,explanation=r.explanation
  FROM jsonb_to_recordset(v_payload) AS r(display_order INT,options JSONB,explanation TEXT)
  WHERE q.mock_test_id=v_test AND q.display_order=r.display_order;
 END IF;
END; $revision$;
COMMIT;
