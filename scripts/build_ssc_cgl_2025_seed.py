"""Normalize the user-supplied Similar-Based paper; never invent damaged content."""
import argparse
import hashlib
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TITLE = 'SSC CGL Tier-I Similar-Based Paper 12 Sept, 2025 Shift 2'
# Option boundaries were lost in the copied text; reviewed English option order.
OPTION_ROWS = '''Intelligence|Knowledge|Honesty|Patience
WXC|XBF|VBD|WBG
IEN|HFL|JFN|JEM
Compound|Cell|Organ|Substance
108|115|120|126
143|147|151|155
Only I follows|Only II follows|Both I and II follow|Neither I nor II follows
Only I and II are implicit|Only II and III are implicit|Only I is implicit|All are implicit
One|Two|Three|Four
1 and 3|1 and 4|2 and 4|3 and 4
10|11|12|13
XZA|XAB|XYZ|XAC
18|19|20|21
ENALERR|NERLERA|AERLNER|AERNLER
PAN|TAN|CAN|CPU
Father|Uncle|Brother|Cousin
2744|4096|1331|2197
6|11|27|39
42573|42576|34725|25374
36|32|34|30
Son|Brother|Cousin|Nephew
Wife|Sister|Mother|Aunt
60, 84|56, 88|64, 80|58, 86
1.4|1.8|2|3
420|410|435|440
Both A and R are true, and R is the correct explanation of A.|Both A and R are true, but R is not the correct explanation of A.|A is true, but R is false.|A is false, but R is true.
Harshavardhana|Samudragupta|Chandragupta Maurya|Pulakeshin II
Ragas developed from ancient Jatis.|Jatis originated from medieval Ragas.|Folk scales evolved into Jatis in the modern period.|Tala system gave rise to Ragas during the Vedic period.
Only 1 is correct|Only 2 is correct|Both 1 and 2 are correct|Neither 1 nor 2 is correct
Asian Games, Hangzhou|President’s Cup, Indonesia|World Boxing Championships, New Delhi|Commonwealth Games, Birmingham
Company’s military and trade control|Company’s constitution in Britain and territorial rule in India|Company’s foreign relations and army recruitment|Company’s financial management and shipping trade
Only 1 is correct|Only 2 is correct|Both 1 and 2 are correct|Neither 1 nor 2 is correct
30|40|50|60
Only 1 is correct|Only 2 is correct|Both 1 and 2 are correct|Neither 1 nor 2 is correct
Piyush Goyal|Hardeep Singh Puri|Narendra Modi|S. Jaishankar
Rockslide|Rockfall|Slump|Debris fall
People per house|People per square kilometre|People per village|People per family
Both A and R are true, and R is the correct explanation of A.|Both A and R are true, but R is not the correct explanation of A.|A is true, but R is false.|A is false, but R is true.
Create lighter and stronger structures|Improve pilot control systems|Enhance thrust generation|Develop new thermal shields
Store genetic material|Produce energy|Carry out intracellular digestion|Form proteins
1 and 3 only|1 only|1 and 2 only|2 and 3 only
Increase by about 2%|Decrease by about 1%|Remain unchanged|Decrease by about 2%
15 days|30 days|60 days|90 days
18–30 years|18–40 years|21–45 years|25–50 years
Both A and R are true, and R is the correct explanation of A.|Both A and R are true, but R is not the correct explanation of A.|A is true, but R is false.|A is false, but R is true.
Tokyo and Beijing|London and New York|Paris and Rome|Berlin and Moscow
They manufacture heavy machinery.|They use light materials to produce consumer goods.|They process ores and metals.|They deal with power generation equipment.
Three legislative lists|Election procedures|Emergency provisions|Judicial structure
Climate change mitigation|Carbon sequestration|Geoengineering|Climate change adaptation
Mass|Gravitational pull|Orbital velocity|Atmospheric pressure
x = y|x > y|x|y > x
3|5|7|9
67/29|41/17|45/19|47/20
₹15,000|₹20,000|₹25,000|₹30,000
₹26,500|₹28,000|₹38,500|₹36,000
₹4.2 lakh|₹2.2 lakh|₹2.8 lakh|₹2.7 lakh
₹820|₹832|₹845|₹850
1:2|2:1|5:2|2:5
₹3,000|₹4,000|₹3,689|₹3,600
Loss of 9.2%|Profit of 9.29%|Profit of 10%|Loss of 10%
200|240|300|360
25 days|18 days|16 days|12 days
35 litres|25 litres|50 litres|20 litres
24 days|30 days|35 days|40 days
900 m|1200 m|1500 m|1800 m
139 m²|135 m²|142 m²|150 m²
225º|180º|240º|360º
(2, 2)|(5, 4)|(1, 2)|(3, 6)
6 radians|3 radians|2 radians|4 radians
1/2|√3/2|√2/2|3/4
8√7/7|7√7/8|7√7/9|9√7/7
3:5|5:3|13:4|9:25
3√3|5√3|7√3|9√3
36°|72°|108°|144°
5/13|12/13|13/12|13/5
Demean|Accept|Abdicate|Apply
To move slowly|To work continuously|To command|To follow
Weak|Mutiny|Incredible|Strong
Supercilious|Prerequisite|Assassination|Priviledge
Otorhinolaryngologist|Otorhinolaryngeologist|Ortorhinolaryngologist|Otorhinolaryngologest
nor|or|and|nor did
at which|on which|when|whereupon
pervasive|dislodge|persuasion|inculcate
(1)|(2)|(3)|(4)
(1)|(2)|(3)|(4)
Classified laboratory data can seldom being obtained without approval.|Classified laboratory data could seldom be obtained without approval.|Classified laboratory data can seldom be obtained without approval.|Classified laboratory data are seldom able to be obtained without approval.
The exorbitant hall featured gules and argent prominently.|The cook prepared a sauce of deep gules and cumin.|The gules border symbolised martial lineage.|The hermit explained the symbolism of gules to the followers.
The office delivers the lunch every morning.|Someone delivers the lunch to the office every morning.|The office has delivered the lunch every morning.|The lunch delivers itself to the office every morning.
than the bus left|then the bus left|when the bus had left|than did the bus left
asked the reportee that submit the document|requested the reportee to submit document|asked the reportee to submit the document|told to the reportee submit document
He said that he had seen him the previous week.|He said that he has seen him last week.|He said that he was seeing him last week.|He said that he had saw him the previous week.
"Discipline should be maintained in the classroom," said the teacher.|"You will maintain discipline in the classroom," the teacher said.|"Maintain discipline in the classroom," said the teacher.|"Must you maintain discipline in the classroom?" asked the teacher.
3, 2, 1, 4|2, 4, 1, 3|1, 4, 3, 2|3, 4, 2, 1
2, 1, 3, 4|1, 2, 3, 4|4, 1, 2, 3|2, 3, 1, 4
Ascetic|Misogynist|Mythical|Sceptical
Promoting entertainment|Replacing newspapers|Facilitating free flow of information|Organizing trade unions
Its affordability|Its visual design|Its ability to spread both truth and misinformation|Its international reach
Editorial boards|Gatekeeping journalism|Viral reach and grassroots mobilization|Institutional press
Enhanced meme culture|Legalizing all content|Algorithmic transparency and media literacy|Global censorship policies
Political advertisements|How platforms are funded|Societal intent and ethical usage|Popularity of influencers'''

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('source', type=Path)
    args = parser.parse_args()
    raw = args.source.read_text(encoding='utf-8-sig')
    parts = re.split(r'Que\.\s*(\d+)\s*', raw)
    groups = {}
    for i in range(1, len(parts), 2):
        groups.setdefault(int(parts[i]), []).append(parts[i+1])
    rows = [line.split('|') for line in OPTION_ROWS.splitlines()]
    assert len(rows) == 100 and all(len(row) == 4 for row in rows)
    questions = []
    for number in range(1, 101):
        source = ' '.join(groups[number])
        keys = re.findall(r'Correct Option\s*-\s*([1-4])', source)
        assert keys and len(set(keys)) == 1, number
        english = re.split(r'[\u0900-\u097f]', source)[0]
        english = re.sub(r'Correct Option\s*-\s*[1-4]', '', english).strip()
        english = re.sub(r'^1\.\s*', '', english)
        options = rows[number-1]
        # The four labels frequently precede all four option texts.
        english = re.split(r'1\.\s*2\.\s*3\.\s*4\.', english)[0]
        if options[0] in english:
            english = english[:english.index(options[0])]
        english = re.sub(r'(?:\s+[1-4]\.)+\s*$', '', english).strip()
        english = re.sub(r'\s+', ' ', english)
        section = ['General Intelligence and Reasoning', 'General Awareness', 'Quantitative Aptitude', 'English Comprehension'][(number-1)//25]
        questions.append(dict(number=number, section=section, question_text=english,
                              options=options, correct_answer='ABCD'[int(keys[0])-1]))
    overrides = {
        10: 'Which of the following addresses are identical to each other?\n1. Neha Sharma, 21/A, Green Park, Delhi, 110016\n2. Neha Sharma, 21-A, Green Park, Delhi, 110016\n3. Neha Sharma, 21-A, Green Park, New Delhi, 110016\n4. Neha Sharma, 21-A, Green Park, Delhi, 110016',
        11: 'Each of the letters in the word PLASTIC is arranged alphabetically. How many letters are there between the first from the left and the fourth from the right in the new arrangement?',
        13: 'In a row of 60 books, Book X is 18th from left and Book Y is 22nd from right. How many books are between them?',
        17: 'One number is not like the others: 1331, 2197, 2744, 4096',
        18: 'Find the number that breaks the pattern: 3, 6, 11, 18, 27, 39, 51',
        23: 'Two numbers are in the ratio 5:7 and their sum is 144. Find the numbers.',
        24: 'If 12 + 8 = A and 1/5 = B, and A % B = (A × B) − 1, then what is A % B?',
        25: 'If the sum of 25 and 35 is multiplied by 7, what is the result?',
        33: 'Under the SLKIC component of Khelo India, how many Kendriya Vidyalayas were adopted with KVS partnership?',
        52: 'The number of red, blue, and green marbles in a bag is in the ratio 3 : 4 : 6. If 20 red marbles, 15 blue marbles, and an unknown number of green marbles are added to the bag, the ratio of red, blue, and green marbles becomes 4 : 5 : 7. Determine the number of green marbles added.',
        55: "A and B contribute to a business investment in the ratio 3:5. They earn a profit of ₹64,000. A is a working partner and receives 10% of the profit extra. What is A's total share?",
        56: 'In a team of 75 employees, the average monthly sales per employee is ₹ 1.8 lakh. If 30 junior employees average ₹ 1.2 lakh each, what is the average monthly sales figure (in ₹ lakh) for the senior employees?',
        53: 'Evaluate the continued fraction:',
        67: 'What is (5π)/4 radians in degrees?',
        68: 'The line y = -x + 4 passes through which of the following points?',
        69: 'What is the central angle of a sector with an arc length of 10 cm in a circle of radius 5 cm?',
        70: 'If tan(90º – A) = √3, what is sin A?',
        71: 'If x = √7, determine the value of x + 1/x.',
        72: 'Two triangles are similar with sides in the ratio 3:5. What is the ratio of their areas?',
        73: 'If x = [REVIEW REQUIRED: radical/fraction layout lost in pasted text], determine the value of x² + x - 9. Source tokens: 2+ 3√ 2−√3 − −−− √.',
        74: 'The angles of a cyclic quadrilateral are in the ratio 1:2:3:4. What is the measure of the smallest angle?',
        75: 'If sec A = 13/5 and A is acute, find sin A.',
        84: 'Spot the error in the sentence. Many instances that seem like cooperation (1)/ between government regulators and private actors (2)/ are, in truth, merely accidental intersections (3)/ arising from divergent responsibilities. (4)',
        85: 'Spot the error in the sentence: That the architecture omits mechanisms for retroactive interoperability (1)/ is of lesser consequence than the presumption (2)/ that every ancillary apparatus will, absent compulsion, (3)/ adheres to the principal edict in its prescribed form. (4)',
    }
    for n, stem in overrides.items():
        questions[n-1]['question_text'] = stem
    questions[86]['question_text'] = questions[86]['question_text'].replace("king's gules", "king's **gules**")
    # Each question is rendered independently, so repeat the shared passage.
    passage = questions[95]['question_text'].split('How does social media primarily')[0]
    for q in questions[96:]:
        q['question_text'] = passage + '\n\n' + q['question_text']
    for q in questions:
        assert q['question_text'] and not re.search(r'Correct Option|[\u0900-\u097f]', q['question_text']), q['number']
    data = dict(title=TITLE, source_sha256=hashlib.sha256(args.source.read_bytes()).hexdigest(),
                source_label='User-supplied bilingual pasted text; English transcription; supplied keys retained, unverified.',
                duration_minutes=60, marks=2, negative_marks=0.5, is_published=True, questions=questions)
    (ROOT/'supabase/data/ssc_cgl_2025_09_12_shift_2.json').write_text(json.dumps(data, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    payload = [dict(display_order=q['number'], question_text=f"[{q['section']}] {q['question_text']}",
                    question_type='mcq', options=[dict(value=a, text=t) for a,t in zip('ABCD',q['options'])],
                    correct_answer=q['correct_answer'],marks=2,negative_marks=0.5) for q in questions]
    payload[52]['options'][0]['question_image'] = {'url': '/images/ssc-cgl/q53-equation.svg', 'alt': 'Evaluate the continued fraction: x = 2 + 1/(3 + 1/(4 + 1/2))', 'replaces_text': True}
    payload[72]['options'][0]['question_image'] = {'url': '/images/ssc-cgl/q73-question.svg', 'replaces_text': True, 'alt': 'If x = sqrt((2 + sqrt(3))/(2 - sqrt(3))), determine x squared + x - 9.'}
    # Reuse the existing-schema importer, with no dependency on GATE grading.
    template=(ROOT/'scripts/build_gate_2025_mock_seeds.py').read_text(encoding='utf-8')
    start=template.index('    FOR v_paper IN SELECT')
    end=template.index("\n'''",start)
    tail=template[start:end]
    tail=tail.replace("180,100,(v_paper->>'cutoff')::NUMERIC,TRUE", "60,200,0,TRUE")
    tail=tail.replace("'GATE',v_subject_id", "'OTHER',v_subject_id")
    tail=tail.replace('is_published=TRUE', 'is_published=TRUE').replace("duration_minutes=180,total_marks=100,passing_marks=(v_paper->>'cutoff')::NUMERIC", 'duration_minutes=60,total_marks=200,passing_marks=0')
    tail=tail.replace('v_count<>65', 'v_count<>100').replace(')<>100 THEN', ')<>200 THEN').replace('65 questions/100 marks','100 questions/200 marks')
    paper=dict(title=TITLE,branch='SSC CGL',description='User-supplied Similar-Based practice paper, not verified as an official SSC previous-year paper. English transcription, 100 questions in four sections. Q51 option 3 and Q87 highlighting confirmed by user; Q53/Q73 formulas restored from screenshots. Supplied answer keys retained as agreed. Practice settings: 60 minutes, +2 correct, -0.5 wrong, 0 unanswered. No qualifying cutoff is asserted.',questions=payload)
    sql='''-- Generated by scripts/build_ssc_cgl_2025_seed.py; existing tables only.
-- Source clarifications: see supabase/data/ssc_cgl_2025_09_12_shift_2_review.md.
-- Keep answer-bearing seed/JSON files out of public browser assets.
DO $seed$
DECLARE
    v_papers JSONB := $papers$
'''+json.dumps([paper],ensure_ascii=False,indent=2)+'''
$papers$::JSONB;
    v_paper JSONB;
    v_questions JSONB;
    v_test_id UUID;
    v_subject_id UUID;
    v_count INT;
BEGIN
    IF to_regclass('public.mock_tests') IS NULL OR to_regclass('public.mock_questions') IS NULL THEN
        RAISE EXCEPTION 'Existing mock tables are required; this seed creates no tables.';
    END IF;
'''+tail+'\n'
    (ROOT/'supabase/ssc_cgl_2025_09_12_shift_2_mock_seed.sql').write_text(sql,encoding='utf-8')
    print('Generated publishable mock: 100 questions / 200 marks, four sections.')

if __name__ == '__main__':
    main()
