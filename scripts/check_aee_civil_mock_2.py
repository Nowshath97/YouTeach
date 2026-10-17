"""Independent calculation checks against the final shuffled answer choices."""
import json
import math
from pathlib import Path

rows = json.loads((Path(__file__).resolve().parents[1] / 'supabase/data/aee_civil_mock_2_questions.json').read_text())


def selected(prefix):
    matches = [q for q in rows if q['question_text'].startswith(prefix)]
    assert len(matches) == 1, prefix
    q = matches[0]
    return q['options']['ABCD'.index(q['correct_answer'])]


cases = [
    ('A simply supported beam of span', 24*6/4, '36 kN m'),
    ('A solid circular shaft diameter', 1/2**3, 'One-eighth'),
    ('A steel bar is fully restrained', 200000*12e-6*25, '60 MPa compressive'),
    ('For a rectangular concrete section', 100000/(250*400), '1.0 MPa'),
    ('For a reinforcing bar', 16*300/(4*1.5), '800 mm'),
    ('A concentric prestressing force', 600/.12/1000, '5 MPa compression'),
    ('A soil has void ratio', 100*.5/1.5, '33.3%'),
    ('Take water unit weight', (20-10)*3, '30 kPa'),
    ('A saturated sand has Gs', (2.65-1)/(1+.65), '1.00'),
    ('Water flows at 2 m/s', 2*(200/100)**2, '8 m/s'),
    ('Using Darcy friction factor', .02*(100/.2)*2**2/(2*10), '2 m'),
    ('In a wide rectangular channel', 4/math.sqrt(10), 'Supercritical, Fr approximately 1.26'),
    ('A catchment of 2 km', 2e6*.015, '30000 m^3'),
    ('An irrigation outlet supplies', 100*86400/(1000*10000), '0.864 m'),
    ('A 3-hour storm', (12-4)*3, '24 mm'),
    ('A treatment unit removes', 250*(1-.8), '50 mg/L'),
    ('A tank volume', 600/2400*24, '6 h'),
    ('Chlorine dose', 3-.5, '2.5 mg/L'),
    ('A vehicle travels 100 km', 100/2, '50 km/h'),
    ('A vehicle moves at 54', 54/3.6*2, '30 m'),
    ('Using e+f=', 20**2/(10*200)-.08, '0.12'),
    ('A benchmark RL', 100+1.25-2, '99.250 m'),
    ('A line has whole-circle', 180-135, 'S45E'),
    ('A distance measured as', 500*20.02/20, '500.5 m'),
    ('A nominal dry-volume', 1.4/(1+2+4), '0.20 m^3'),
    ('A wet sand volume', (1.25/1-1)*100, '25%'),
    ('A concrete cube', 675000/150**2, '30 MPa'),
    ('An excavation is', 12*2*1.5, '36 m^3'),
    ('PERT estimates', (2+4*5+8)/6, '5 days'),
    ('Two parallel paths', max(14-5,11), '11 days'),
]
expected = [36,.125,60,1,800,5,100/3,30,1,8,2,4/math.sqrt(10),30000,.864,24,50,6,2.5,50,30,.12,99.25,45,500.5,.2,25,30,36,5,11]
assert len(cases) == len(expected) == 30
for (prefix, actual, choice), target in zip(cases, expected):
    assert math.isclose(actual, target, rel_tol=1e-10, abs_tol=1e-10), (prefix, actual, target)
    assert selected(prefix) == choice, (prefix, selected(prefix), choice)
print('PASS: all 30 numerical keys verified against independently calculated values and final shuffled options.')
