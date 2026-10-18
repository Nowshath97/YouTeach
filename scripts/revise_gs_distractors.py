"""Editorial distractor revisions. Correct answers and shuffled positions are retained."""
import json
from pathlib import Path
import build_aee_2026_mocks as base

ROOT = Path(__file__).resolve().parents[1]
# concept|three alternatives from the same domain (not alternative correct answers)
REVISIONS = '''spadex demonstrated technology|Autonomous rendezvous without mechanical capture|Transfer of propellant between docked spacecraft|Robotic assembly of a modular space station
skills university institutional purpose|Apprenticeship placement through an industry association without a university framework|Academic engineering research through a conventional public university framework|Vocational certification through an examination board without industry-led curricula
bhu bharati commencement|Regulation of agricultural tenancy and crop-sharing contracts|Consolidation of fragmented agricultural holdings|Acquisition of agricultural land for public infrastructure
maratha unesco serial property|A serial group of twelve fortifications, all located within Maharashtra|A serial group of twelve fortifications, mainly in Maharashtra with one in Karnataka|A serial group of twelve fortifications, mainly in Maharashtra with one in Telangana
un2025 quantum year|Standardising quantum-resistant encryption across all UN member states|Establishing a UN licensing authority for quantum computing laboratories|Restricting quantum research funding to high-energy particle physics
criminal law replacement match|Bharatiya Nyaya Sanhita - criminal procedure|Bharatiya Nagarik Suraksha Sanhita - substantive offences|Bharatiya Sakshya Adhiniyam - criminal sentencing
aditya halo milestone|The second Sun-Earth Lagrange point|The fourth Sun-Earth Lagrange point|The second Earth-Moon Lagrange point
rythu investment support purpose|Compensation assessed after crop losses from notified disasters|Interest reimbursement on eligible agricultural term loans|Procurement-linked price support after the crop is marketed
joint solar coronagraph observation 2026|India's Aditya-L1 and Europe's Solar Orbiter|India's Aditya-L1 and NASA's Parker Solar Probe|Europe's Proba-3 and NASA's Solar Dynamics Observatory
gentlemens agreement safeguards|Establish a separate Telangana state before the linguistic merger|Extend the Andhra region's service rules without regional safeguards|Place the Telangana region under a separately administered Union Territory
mulki rule regional rights|Seniority based on length of service irrespective of domicile|Reservation of legislative seats by regional population|Allocation of regional revenue by place of tax collection
salar jung reform administration|Creation of an elected legislature with a responsible ministry|Abolition of the jagirdari system throughout Hyderabad State|Introduction of universal adult franchise in Hyderabad State
nizam rule rural hierarchy|A compulsory levy payable as a share of agricultural produce|A hereditary right to collect village land revenue|A tenancy payment made in lieu of cultivating land
komaram bheem slogan|Individual land titles in exchange for surrendering community forest access|Forest conservation through exclusion of resident tribal communities|Cash compensation for relocation without community resource rights
chakali ilamma agrarian resistance|Leadership of the Mulki student agitation over public employment|Organisation of the library movement for vernacular education|Negotiation of regional safeguards during the linguistic merger
hyderabad operation constitutional outcome|Continuation as a sovereign state under an Indian defence treaty|Accession to India with the Nizam retaining independent defence powers|Conversion of Hyderabad city into a separately administered Union Territory
andhra mahasabha evolution|Functioned as the Nizam's official council for revenue settlement|Served as an association restricted to commercial arbitration|Operated as a party devoted to preserving jagirdari privileges
suravaram literary history|A dynastic chronology of the Qutb Shahi rulers|A linguistic grammar of classical Telugu|A critical commentary on Telugu devotional poetry
kaloji literary voice|Court-centred poetry celebrating dynastic authority|Devotional poetry centred on the Telugu Bhagavata rendering|Classical court epic centred on the Vijayanagara imperial ideal
pothana bhagavatam|Andhra Mahabharatamu|Panduranga Mahatmyamu|Manucharitramu
kakatiya irrigation landscape|Used isolated storage structures without catchment or settlement linkages|Primarily diverted perennial river flows through continuous large canals|Prioritised flood evacuation over seasonal agricultural water storage
ramappa lightweight roofing|Dense dressed-stone slabs in the vimana|Solid fired bricks with a high bulk density in the vimana|Massive stone corbelling supporting a dense masonry superstructure
qutb shahi architecture|Bidar and the development of the Barid Shahi capital|Bijapur and the development of the Adil Shahi capital|Ahmadnagar and the development of the Nizam Shahi capital
bonalu bathukamma distinction|Bathukamma centres on food offerings; Bonalu centres on floral arrangements|Bathukamma centres on decorated bull processions; Bonalu on floral immersion|Bathukamma centres on tribal commemorative worship at Medaram; Bonalu on floral immersion
cheriyal narrative art|Freehand textile painting organised around temple hangings|Wax-resist textile patterning for repeated decorative motifs|Metal-inlay ornamentation on darkened alloy surfaces
pochampally technique|Wax-resist dyeing of cloth after weaving|Block-printing repeated motifs on woven cloth|Supplementary-weft insertion of motifs using pre-dyed yarn
perini historical setting|Qutb Shahi court traditions of narrative dance|Asaf Jahi court traditions of devotional music|Vijayanagara temple traditions of dance-drama
sakala janula samme form|Mass rally mobilisation centred on a single Hyderabad march for Telangana statehood|Transport blockade mobilisation centred on stopping rail services for Telangana statehood|Administrative non-cooperation confined to government offices for Telangana statehood
sri krishna committee role|Frame binding service-allocation rules for two already-created successor states|Determine the interstate river-water entitlements of two successor states|Implement the final territorial boundaries of an already-approved Telangana state
reorganisation statutory distinction|The Andhra Pradesh Reorganisation Act, 2014 provided the legal basis; 1 March 2014 was the appointed day|The Andhra Pradesh Reorganisation Act, 2014 provided the legal basis; 30 July 2013 was the appointed day|The States Reorganisation Act, 1956 provided the legal basis; 2 June 2014 was the appointed day
tribal jatara community|Gond|Chenchu|Lambada
hyderabad social reform education|They mainly standardised revenue records for the state administration|They mainly provided formal training for appointments in the state army|They mainly operated as official bodies for enforcing press regulations
basic structure amendment limit|Parliament's ordinary legislative competence under the Union List|The executive's power to frame rules under an ordinary statute|The judiciary's power to review administrative discretion
article32 remedy writ|Article 226|Article 136|Article 227
dpsp enforceability distinction|Directive Principles confer directly enforceable individual remedies equivalent to Article 32|Directive Principles bind courts to invalidate every inconsistent statute without further constitutional grounds|Directive Principles operate as judicially enforceable duties of individual citizens
finance commission versus gst council|GST Council|Inter-State Council|NITI Aayog
cag accountability reporting|Executive financial control through prior approval of each spending decision|Legislative budget allocation through binding recommendations on tax rates|Administrative financial management through preparation of departmental accounts
anti defection decision authority|The Governor or President acting on the Election Commission's opinion|The Election Commission acting on a petition from the party whip|A High Court acting as the first-instance statutory tribunal
reasonable accommodation disability|Formal equality through identical examination conditions for every candidate|Compensatory preference unrelated to barriers in the examination process|Equality of outcomes through identical marks for eligible candidates
ordinance temporary legislation|Delegated rule-making under an existing statute without the force of primary legislation|Emergency constitutional amendment effective until judicial confirmation|Executive legislation that continues unless expressly repealed by the legislature
federal concurrent law conflict|The law enacted later prevails irrespective of the legislature that enacted it|State law prevails whenever its subject has a stronger local connection|Both laws remain equally enforceable and the affected person may choose either
constitutional equality protective policy|Formal equality requiring identical treatment despite relevant disadvantage|Executive discretion exempt from constitutional review once a policy is called protective|A requirement that protective measures be based solely on current household income
permanent settlement incentive|A direct state-cultivator settlement with periodically revised state demand|A village-body settlement with collective liability for assessed revenue|A landlord settlement with state demand revised annually with market prices
ryotwari mahalwari distinction|Ryotwari - village estate; Mahalwari - individual cultivator|Ryotwari - zamindar; Mahalwari - individual cultivator|Ryotwari - village estate; Mahalwari - zamindar
drain theory argument|Adverse terms of trade caused solely by changes in international commodity prices|Domestic transfers of agricultural surplus from tenants to Indian landlords|Revenue loss caused solely by collecting land taxes below their assessed value
swadeshi political economy|Promotion of imported substitutes through preferential imperial tariffs|Expansion of elected councils as a substitute for economic boycott|Reliance on petitions while discouraging national educational institutions
lucknow pact significance|Congress-League rejection of separate electorates in favour of joint electorates|Congress-League agreement to launch an immediate nationwide non-cooperation movement|Congress-League acceptance of provincial partition into sovereign states
montagu reforms dyarchy|Reserved subjects under ministers and transferred subjects under the Governor's executive councillors|Federal subjects under elected ministers and provincial subjects under the Viceroy|All provincial subjects under ministers jointly responsible to the legislature
simon commission opposition|Its exclusion of elected Indian representatives from the commission's membership while retaining nominated Indian members|Its immediate implementation of separate electorates without legislative approval|Its replacement of provincial dyarchy with immediate Dominion status
poona pact change|Reserved seats within separate electorates|Unreserved seats within joint electorates|Reserved seats filled solely by nomination
cabinet mission constitutional proposal|A strong unitary centre with provinces lacking residual powers|Two immediately sovereign states with no common Union institutions|A federation of provinces excluding princely states from the constitution-making process
social reform sati regulation|Lord Amherst|Lord Hastings|Lord Auckland
1857 annexation resentment|Subsidiary alliances guaranteeing unrestricted adoption-based succession|Permanent Settlement provisions governing revenue in Bengal|The Charter Act's opening of Indian trade to private British merchants
vernacular press restrictions|Indian-language publications regardless of whether they criticised the government, under rules identical to English newspapers|English-language publications critical of colonial administration under a separate licensing system|All periodicals through a uniform pre-publication censorship rule irrespective of language
deccan black soil properties|Kaolinitic clays with low shrink-swell potential|Iron-oxide cementation without expandable clay minerals|High silt content with negligible clay-related volume change
monsoon western ghats rainshadow|Monsoon winds lose moisture by crossing the interior plateau before reaching the western coast|Leeward ascent produces cooling while windward descent suppresses condensation|The inland pressure gradient prevents moisture-bearing air from crossing the Ghats
telangana plateau relief|An extensive alluvial plain dominated by recent river deposits|A young folded upland dominated by active crustal compression|A basaltic coastal plain dominated by tidal estuaries
laterite formation|Weak leaching under cool dry conditions|Salt accumulation under intense evaporation in arid conditions|Deposition of carbonate-rich sediments under shallow marine conditions
demographic dependency ratio|A rising working-age share accompanied by persistent unemployment|A rising working-age share accompanied by declining workforce skills|A rising working-age share accompanied by worsening worker health
himalayan peninsular rivers contrast|Himalayan flows depend mainly on winter rain, while peninsular flows depend mainly on summer snowmelt|Both river groups generally receive equal proportions of glacier melt and monsoon rainfall|Peninsular flows are less seasonal because their catchments generally contain larger glaciers
groundwater hard rock storage|Primary intergranular pores distributed evenly through unweathered granite|Unfractured rock interiors below the weathering zone|Connected pore spaces formed mainly between intact feldspar crystals
jet stream winter rainfall|Northeast monsoon depressions|Southwest monsoon onset vortices|Local pre-monsoon convective storms
contour watershed boundary geography|Valley axes connecting the lowest points along stream channels|Contours connecting points of equal elevation around each outlet|Groundwater equipotential lines inferred independently of surface relief
cropping water demand adaptation|Greater dependence on standing water throughout crop growth|Higher sensitivity to short dry spells during the growing season|Greater dependence on continuous canal releases through the crop cycle
gdp intermediate double counting|Gross sales at each stage without deducting intermediate consumption|Final sales plus the intermediate inputs embodied in those sales|Wages plus transfers without including profits and depreciation
inflation distribution fixed income|A nominal income that rises in the same proportion as the consumer price level|A nominal income that rises faster than the consumer price level|A payment fully indexed to the same consumer price measure
repo monetary transmission|Lower financing costs and increased interest-sensitive spending|Higher bank reserves automatically producing lower loan rates|Lower deposit returns automatically expanding household consumption
unemployment disguised productivity|Seasonal unemployment caused by a recurring absence of farm work|Frictional unemployment during movement between farm employers|Structural unemployment caused by a mismatch with industrial job requirements
tax progressivity incidence|Its marginal rate is positive but its average rate remains constant|Its average rate falls as taxable income rises|Its absolute tax payment rises while its average rate falls
gst input credit purpose|Reduce output liability by deducting the full purchase price rather than eligible input tax|Refund every tax paid on inputs irrespective of output liability and eligibility|Replace the output-tax liability with a tax only on business profits
irrigation externality economy|Lower production risk even when supply reliability and distribution remain unchanged|Higher productivity independent of crop choice and complementary farm inputs|Higher rural incomes through expansion of cultivated area even when water availability falls
social audit accountability|Departmental verification limited to internal vouchers and accounting entries|Independent financial certification limited to compliance with accounting standards|Technical appraisal limited to engineering specifications of completed works
multidimensional deprivation|Their deprivation must be identical once income is adjusted for household size|Their deprivation can differ only if their current bank balances differ|Their deprivation must converge whenever they face the same market prices
bank credit productive inclusion|Account ownership without affordable access to transactions or credit|Expanded loan access without assessment of suitability or repayment capacity|Digital registration without accessible mechanisms for complaints and redress
vaccine antibiotics distinction|Vaccines provide passive ready-made antibodies; antibiotics stimulate immune memory|Vaccines directly inhibit bacterial protein synthesis; antibiotics induce antigen-specific memory|Vaccines treat established bacterial infection; antibiotics prevent infection through immune priming
antibiotic resistance selection|Create immune memory against the antibiotic rather than the pathogen|Cause susceptible bacteria to become resistant through purposeful adaptation to the patient's needs|Increase resistance mainly by reducing the patient's antibody production
dna rna distinction|DNA usually contains ribose and thymine; RNA usually contains deoxyribose and uracil|DNA usually contains deoxyribose and uracil; RNA usually contains ribose and thymine|DNA usually contains ribose and uracil; RNA usually contains deoxyribose and thymine
semiconductor doping|A p-type semiconductor with electrons as majority carriers|An n-type semiconductor with holes as majority carriers|An intrinsic semiconductor with equal electron and hole concentrations
pressure cooker boiling|Lowers the boiling temperature and increases evaporation at the same temperature|Raises the boiling temperature by lowering external pressure on the liquid|Leaves the boiling temperature unchanged but reduces the food's specific heat
hard water soap|Sodium and potassium ions|Chloride and nitrate ions|Hydrogen and ammonium ions
carbon monoxide mechanism|Oxidises haemoglobin iron to form methaemoglobin as its principal mechanism|Primarily blocks oxygen entry by causing fluid secretion into the alveoli|Primarily reduces blood oxygen through rapid destruction of red blood cells
remote sensing active passive|A multispectral scanner recording reflected solar radiation|A thermal infrared radiometer recording terrestrial emission|A microwave radiometer recording natural surface emission
ai training testing leakage|Sampling variance caused solely by a small independent test set|Underfitting caused solely by an insufficiently complex model|Label imbalance caused solely by unequal numbers of classes
cybersecurity phishing|Open the supplied link and trust it if the page displays a padlock|Reply to the sender requesting confirmation before entering the password on the supplied page|Enter the password if the linked page reproduces the portal's usual branding
renewable grid intermittency|Solar output follows demand closely enough that storage mainly compensates for billing delays|Installed solar capacity measures guaranteed instantaneous output regardless of weather|Storage increases the daily solar energy input rather than shifting delivery over time
orbit microgravity misconception|Atmospheric drag balances gravity so that no force acts on the spacecraft|Centripetal acceleration is absent once orbital speed is reached|Gravity acts on the spacecraft but is screened from astronauts inside it
hazard vulnerability risk|Hazard intensity|Forecast lead time|Return period of the flood
eutrophication mechanism|Algal photosynthesis consumes oxygen during daylight faster than respiration|Nutrients lower oxygen mainly by increasing its chemical solubility|Nutrients suppress biomass production, thereby increasing decomposition demand
food chain biomagnification|Short-lived primary producers at the base of the same food chain|Primary consumers feeding only on the producers in that chain|Secondary consumers below the top predators in that chain
invasive versus endemic|An invasive alien is any introduced species, regardless of spread or ecological impact|An endemic is any threatened species, regardless of its native geographic range|An invasive alien must be globally widespread, while an endemic must be locally abundant
urban flood impervious cover|Decrease rapid runoff and lengthen catchment response time|Increase infiltration while leaving the runoff peak unchanged|Reduce the runoff coefficient while shortening catchment response time
heatwave public health adaptation|Maintain afternoon shifts and rely on drinking water only after work|Provide shaded breaks while withholding drinking water until thirst becomes severe|Replace work-rest scheduling with acclimatisation alone during extreme heat
earthquake primary secondary hazard|Ground shaking generated by seismic-wave propagation|Surface displacement along the ruptured fault|Release of accumulated strain on the fault plane
wetland ecosystem services|Flood storage while leaving habitat and water-quality functions unchanged|Habitat while leaving flood-water storage and nutrient retention unchanged|Water-quality regulation while increasing the filled site's flood storage
conditional past perfect|would find|would have find|had found
idiom contextual meaning|Must be followed without any later revision|Has been formally approved for immediate implementation|Has been postponed until a final decision is made
restrictive evidence inference|Submission was sufficient for consideration, whether or not other requirements were met|Every candidate who submitted the form was necessarily considered|Consideration was necessary before a candidate could submit the form'''

def main():
    revisions = {parts[0]: parts[1:] for line in REVISIONS.splitlines() if (parts := line.split('|'))}
    path = ROOT / 'supabase/data/aee_2026_gs_source.txt'
    lines = path.read_text(encoding='utf-8').splitlines()
    changed = []
    for index, line in enumerate(lines):
        fields = line.split('|')
        if len(fields) == 8 and fields[1] in revisions:
            fields[4:7] = revisions[fields[1]]
            # Remove explanations that discuss distractors from the previous edition.
            if fields[1] == 'sakala janula samme form':
                fields[7] = 'Sakala Janula Samme was a sustained, broad strike for Telangana statehood involving multiple occupational and social groups. A single rally, rail blockade or administrative non-cooperation campaign describes a narrower protest form rather than the mobilisation as a whole.'
            if fields[1] == '1857 annexation resentment':
                fields[7] = 'The Doctrine of Lapse challenged adoption-based succession and enabled annexations, creating resentment among affected ruling families. The other policies address different mechanisms of colonial control.'
            lines[index] = '|'.join(fields)
            changed.append(fields[1])
    assert set(changed) == set(revisions), set(revisions) - set(changed)
    path.write_text('\n'.join(lines) + '\n', encoding='utf-8')
    source = {row['topic']: row for row in base.read_rows('gs')}
    payload = []
    for suffix in ['questions', 'matching_questions']:
        bank = ROOT / f'supabase/data/aee_2026_gs_{suffix}.json'
        rows = json.loads(bank.read_text(encoding='utf-8'))
        for row in rows:
            if row['topic'] not in revisions or row['style'] == 'matching':
                continue
            revised = source[row['topic']]
            old_options = row['options']
            distractors = iter(revised['options'][1:])
            row['options'] = [dict(value=o['value'], text=revised['correct_text'] if o['value'] == row['correct_answer'] else next(distractors)) for o in old_options]
            row['explanation'] = revised['explanation']
            if suffix == 'matching_questions':
                payload.append(dict(display_order=row['number'], question_text='[' + row['subject'] + '] ' + row['question_text'],
                                    options=row['options'], correct_answer=row['correct_answer'], explanation=row['explanation']))
        bank.write_text(json.dumps(rows, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
        if suffix == 'questions':
            (base.SEEDS / 'tgpsc_aee_2026_gs_mock_01.sql').write_text(base.seed('gs', rows), encoding='utf-8')
            solutions = ['# ' + base.CONFIG['gs'][0], '', 'Editorial distractor revision; difficulty is not empirically calibrated.', '']
            for row in rows:
                solutions += [f"## {row['number']}. {row['subject']} - answer {row['correct_answer']}", row['question_text'], '', row['explanation'], '']
            (base.DOCS / 'tgpsc_aee_2026_gs_solutions.md').write_text('\n'.join(solutions) + '\n', encoding='utf-8')
    combined = '\n'.join((base.SEEDS / f'tgpsc_aee_2026_{kind}_mock_01.sql').read_text(encoding='utf-8').replace('BEGIN;\n', '', 1).removesuffix('COMMIT;\n') for kind in ['gs', 'civil'])
    (base.SEEDS / 'tgpsc_aee_civil_2026_full_mock_01.sql').write_text('-- Convenience package: TWO SEPARATE mocks.\nBEGIN;\n' + combined + '\nCOMMIT;\n', encoding='utf-8')
    title = base.quote(base.CONFIG['gs'][0])
    sql = '''-- Run after the original seeds and matching revision. Retains all question IDs and answer keys.
-- If attempts exist, refuses changed content rather than changing historical test questions.
BEGIN;
LOCK TABLE public.mock_attempts IN SHARE MODE;
LOCK TABLE public.mock_questions IN SHARE ROW EXCLUSIVE MODE;
DO $revision$
DECLARE v_test UUID; v_payload JSONB := $payload$PAYLOAD$payload$::JSONB;
BEGIN
 PERFORM pg_advisory_xact_lock(hashtext(TITLE));
 IF (SELECT count(*) FROM public.mock_tests WHERE title=TITLE)<>1 THEN
  RAISE EXCEPTION 'Expected one GS mock under its original title; reconcile titles first';
 END IF;
 SELECT id INTO v_test FROM public.mock_tests WHERE title=TITLE;
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
'''.replace('PAYLOAD', json.dumps(payload, ensure_ascii=True, indent=2)).replace('TITLE', title)
    (base.SEEDS / 'tgpsc_aee_2026_gs_distractor_revision.sql').write_text(sql, encoding='utf-8')
    (base.DOCS / 'tgpsc_aee_2026_gs_distractor_revision.md').write_text(
        '# GS distractor revision\n\nReviewed all 150 items. Revised three distractors in ' + str(len(payload)) + ' questions in the matching edition; retained its three matching questions. Numerical and other plausible options retained. Answer letters, correct answer text, question order, marks and duration remain unchanged.\n\n'
        'Apply `supabase/seeds/tgpsc_aee_2026_gs_distractor_revision.sql` after the matching revision. Unchanged reruns are allowed. Changed tests with attempts are refused; no history is deleted.\n\n'
        'Alternatives use nearby concepts, comparable timelines, and common misconceptions. This is an editorial improvement, not a measured difficulty rating. Independent subject review remains pending.\n\n'
        'Sakala Janula Samme primary record: https://www.tgtransco.com/toos_2008-2012/addl-secy-too-ms-no-22-dt-27-04-2012.pdf\n\n'
        + '\n'.join(f"- Q{row['display_order']}: {row['question_text']}" for row in payload) + '\n', encoding='utf-8')
    print(f'Revised distractors in {len(changed)} of 150 GS questions.')

if __name__ == '__main__':
    main()
