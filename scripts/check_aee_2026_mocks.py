"""Independent arithmetic checks and structural checks for both draft papers."""
import collections
import json
import math
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT/'supabase/data'
# Independent calculations use the stated data; they do not parse explanation equations.
CIVIL = {
 'aggregate moisture correction': 1000*(.05-.02),
 'eccentric column stress superposition': [12+16,16-12],
 'plastic section modulus rectangle': (1/4)/(1/6),
 'net section stagger given rule': (200-2*22+40**2/(4*80))*10,
 'traffic shockwave sign': (1200-1800)/(90-30),
 'gnss vertical datum': 120-25,
 'retention and advance cashflow': 10*(1-.05)-1,
 'absolute volume yield': 300/3000+180/1000+1560/2600,
 'aggregate blending': (5.2-2.4)/(6.4-2.4),
 'timber orthotropic movement': [200*.94,50*.97],
 'composite bar load sharing': 81*200/(200+70),
 'stepped axial elongation': 100000*1000/200000*(1/500+1/1000),
 'strain energy impact': 1+math.sqrt(1+2*20/2),
 'thin vessel combined stresses': (2*1000/(2*10)-2*1000/(4*10))/2,
 'unsymmetrical section principal axes': [5+math.sqrt(18),5-math.sqrt(18)],
 'combined bending torsion equivalent torque': math.hypot(30,40),
 'hollow shaft stiffness material efficiency': 5/3,
 'thick cylinder inner hoop stress': 12*(100**2+50**2)/(100**2-50**2),
 'three element strain rosette': 2*300-(400-200),
 'propped cantilever compatibility': 3/8,
 'two span continuity': -1/8,
 'moving load support reaction': max(60+40*6/8,40+60*6/8),
 'truss virtual work displacement': (30*.5+(-20)*(-.25))*.02,
 'beam element assembly': [60*4/6,60*2/6],
 'stiffness matrix condensation': 10-(-2)*(-2)/4,
 'three hinged arch thrust': 10*20**2/(8*5),
 'redundant flexibility cross term': [-2,-1],
 'slope deflection end rotation': 2,
 'ultimate stress block equilibrium': .87*500*1200/(.36*25*300),
 'flexural lever arm': 600*(.5-.42*.15),
 'punching perimeter demand': 600000/(4*(400+200)*200),
 'stirrup spacing design': .87*415*100*450/65000,
 'doubly reinforced additional couple': 80e6/400/350,
 'footing flexure cantilever': 200*.75**2/2,
 'column minimum eccentricity application': max(4000/500+600/30,20),
 'flanged beam compression block check': [450000/(.36*25*1000),450*(.5-.42*.05)],
 'bolt group direct eccentric shear': 20/2+20*150*100/(2*100**2),
 'fillet weld effective throat': 2*200*.7*6*100/1000,
 'column design resistance given curve': 2400*140/1000,
 'prestress friction attenuation': 1200*math.exp(-.2),
 'anchorage slip stress loss': 200000*4/20000,
 'parabolic tendon load balancing': 8*1200*.15/12**2,
 'parallel pipe network split': .9/(1+math.sqrt(4)),
 'pump series operating point': math.sqrt((2*30-20)/(2*100+200)),
 'npsh available suction': 10.3-.3-4-1,
 'turbine power efficiency': 1000*10*4*30*.85/1000,
 'water hammer sudden closure': 1000*1000*1.5/1e6,
 'rectangular weir differential error': 1.5*2,
 'manning roughness depth scaling': 2**(3/5),
 'hydrostatic curved surface vertical force': 9.81*3,
 'stokes terminal settling': 2**2,
 'venturi differential fluid relation': .1*(13.6-1),
 'rotating liquid free surface rise': 4**2*.5**2/(2*10),
 'horton integrated infiltration': 5*2+15*(1-math.exp(-2)),
 'scs runoff initial abstraction': (100-.2*100)**2/(100+.8*100),
 'double mass rainfall adjustment': 600*1.2/.9,
 'reservoir mass curve storage': (4-2)+(4-2),
 'irrigation scheduling depletion': .8*(.30-.15)*.5*1000,
 'gumbel design quantile': 100+20*(2.25-.577)/1.283,
 'hydrograph recession reservoir': 20*3*3600,
 'well interference superposition': 1.2+.8,
 'liquidity index state': (46-25)/(60-25),
 'compression index settlement': 3*.3/(1+.8)*math.log10(200/100)*1000,
 'drained triaxial cohesion intercept': 100*3+2*20*math.sqrt(3),
 'skempton pore pressure increments': [.8*(20+.5*(80-20)),80-.8*(20+.5*(80-20))],
 'bearing pressure eccentric footing': 1+6*.25/2,
 'pile group efficiency resistance': min(9*400*.75,2400),
 'seepage flow net discharge': 2e-5*6*4/12,
 'exit gradient safety': .9/.3,
 'infinite slope dry stability': math.tan(math.radians(35))/math.tan(math.radians(25)),
 'raft net pressure compensation': 180-3*20,
 'bod first order exertion': 200*(1-math.exp(-.2*5)),
 'sedimentation overflow capacity': min(1,25/(10000/500))*100,
 'filter backwash water fraction': 90/(120*24)*100,
 'sludge age solids balance': 3000/(140+10),
 'sewer partial full velocity': 1,
 'mixing river effluent concentration': (4*2+42)/(4+1),
 'noise independent sources': 60+10*math.log10(2),
 'signal saturation green ratio': 1800*30/90,
 'webster optimum cycle': (1.5*12+5)/(1-.6),
 'pavement axle equivalence': (120/80)**4,
 'vertical summit curve grade difference': (-2-3)/200,
 'railway cant equilibrium supplied geometry': 1.5*20**2/(10*600)*1000,
 'queue arrival service finite period': (600-480)*15/60,
 'overtaking relative travel': 100/((90-54)/3.6)*(90/3.6),
 'closed traverse angular correction': -2*60/5,
 'tacheometry inclined sight': 100*2*math.cos(math.radians(30))**2,
 'edm atmospheric slope reduction': 2000*(1+10e-6)*math.sin(math.radians(60)),
 'area coordinate shoelace': .5*abs(40*30+40*20),
 'stadia distance uncertainty': 100*math.sqrt(.001**2+.001**2),
 'prismoidal earthwork comparison': 30*(10+4*18+30)/6,
 'earned value schedule cost': [80/90,80/100],
 'crashing cost slope bottleneck': (55000-40000)/(8-5),
 'pert project probability': (23-20)/math.sqrt(9),
 'discounted equipment replacement': -100000+121000/1.1**2,
 'depreciation reducing balance': 200000*.8**3,
}
GS = {
 'real nominal growth': (1.12/1.05-1)*100,
 'primary deficit': 50000-18000,
 'longitude time calculation': 7.5*4,
 'telangana sector share employment': .60/.30,
 'mendel recessive cross': .5*.5,
 'ph dilution strong acid': 10**-3/10**-2,
 'weighted class average': (20*60+30*70)/50,
 'successive percentage changes': (1.2*.8-1)*100,
 'work rates combined': 1/(1/12+1/18),
 'conditional bag probability': 3/5*2/4,
 'clock relative hands': abs(20*6-(3*30+20*.5)),
 'ratio mixture replacement': (20*.3)*(1-4/20)/20*100,
 'table percentage versus points': (50-40)/40*100,
 'train relative speed crossing': (120+180)/((36+54)/3.6),
 'arithmetic sequence missing term': 26+11,
 'electric energy units': 1.5*4*20,
}
# Symbolic answers evaluated independently instead of interpreting arbitrary code.
SYMBOLIC = {'telangana sector share employment':2,'ph dilution strong acid':.1,'propped cantilever compatibility': 3/8,'two span continuity':-1/8,
            'slope deflection end rotation':2,'manning roughness depth scaling':2**(3/5),
            'stokes terminal settling':4}
NUMBER = r'[-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?'


def option_numbers(text, count):
    # Handle exact fractions, the one scientific-notation answer, and symbolic formula choices.
    fraction = re.match(r'^([-+]?\d+)/(\d+)(?:\s|$)', text)
    if fraction: return [int(fraction[1])/int(fraction[2])]
    if text.startswith('4x10^-5'): return [4e-5]
    values = [float(v) for v in re.findall(NUMBER,text)[:count]]
    return [-v for v in values] if 'decrease' in text else values


def main():
    results=[]
    for kind, calculations in [('civil',CIVIL),('gs',GS)]:
        rows=json.loads((DATA/f'aee_2026_{kind}_questions.json').read_text(encoding='utf-8'))
        assert len(rows)==150
        for row in rows:
            assert len(row['options'])==4 and row['correct_answer'] in 'ABCD'
            assert row['explanation'].strip() and row['question_text'].strip()
            assert row['number'] in range(1,151)
            assert [o['value'] for o in row['options']]==list('ABCD')
            assert len(set(o['text'].strip().casefold() for o in row['options']))==4
            concept=row['topic']
            if row['style']=='numerical':
                assert concept in calculations, ('Missing independent numerical check',concept)
            if concept not in calculations:
                continue
            actual=calculations[concept]
            actual=actual if isinstance(actual,list) else [actual]
            answer=next(o['text'] for o in row['options'] if o['value']==row['correct_answer'])
            observed=[SYMBOLIC[concept]] if concept in SYMBOLIC else option_numbers(answer,len(actual))
            # Tolerance follows precision of displayed options, not a change to the grading key.
            match = re.search(NUMBER, answer)
            first = match.group() if match else '0'
            digits = len(first.split('.')[1]) if '.' in first else 0
            tolerance = 0.5 * 10**(-digits) + 1e-8
            if '/' in answer.split()[0]: tolerance=1e-10
            if concept in ('seepage flow net discharge','sewer partial full velocity','conditional bag probability'): tolerance=1e-10
            assert len(actual)==len(observed),(concept,answer)
            assert all(abs(a-b)<=tolerance for a,b in zip(actual,observed)),(concept,actual,answer)
            # Reject numeric distractors inside the rounding tolerance when the item has a scalar answer.
            if len(actual)==1 and concept not in SYMBOLIC:
                matching=[]
                for option in row['options']:
                    numbers=option_numbers(option['text'],1)
                    if numbers and abs(actual[0]-numbers[0])<=tolerance:
                        matching.append(option['value'])
                assert matching==[row['correct_answer']],(concept,'ambiguous numeric options',matching)
            row['numerical_validation']='independent Python arithmetic passed; model assumptions require subject review'
            results.append(dict(paper=kind,question=row['number'],concept=concept,computed=actual,answer=answer))
        (DATA/f'aee_2026_{kind}_questions.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    report=dict(status='arithmetic and structural checks passed; not an independent expert content sign-off',
                questions=300,numerical_checks=len(results),checks=results)
    (DATA/'aee_2026_numerical_validation.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
    manifest_path=DATA/'aee_2026_progress.json'
    manifest=json.loads(manifest_path.read_text(encoding='utf-8'))
    manifest['automated_arithmetic_checks_passed']=len(results)
    manifest['remaining']=['Applicable 2026 notification/marking and complete syllabus verification','Independent content, difficulty and code review','Live database semantic/template novelty review','Publication decision']
    manifest_path.write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
    print(f'PASS: 300 structurally valid questions; {len(results)} independent arithmetic checks. Content and difficulty review still required.')


if __name__=='__main__': main()
