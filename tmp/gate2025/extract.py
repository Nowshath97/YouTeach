import re,json,hashlib
from pathlib import Path
import pymupdf
papers=[]
for code,branch,bcode in [('ME','Mechanical Engineering','ME'),('EE','Electrical Engineering','EE'),('CE1','Civil Engineering','CE')]:
 doc=pymupdf.open(f'tmp/gate2025/{code}.pdf')
 pages={}
 for i,page in enumerate(doc):
  text=page.get_text()
  for match in re.finditer(r'(?m)^\s*Q\.\s*(\d+)\s',text):
   # Section headings say Q.1 - Q.5; real question labels are standalone text blocks.
   end=text[match.end():match.end()+50]
   if re.match(r'[\u2013\u2014-]\s*Q\.',end.strip()): continue
   n=int(match[1])
   if 1<=n<=65: pages.setdefault(n,i+1)
 print(code,'page mapping',len(pages),'missing',sorted(set(range(1,66))-set(pages)))
 key_text=Path(f'tmp/gate2025/{code}_key.txt').read_text(encoding='utf-8')
 keys=[]
 for line in key_text.splitlines():
  m=re.fullmatch(r'\s*(\d+)\s+(\d+)\s+(MCQ|MSQ|NAT)\s+([A-Z0-9-]+)\s+(.+?)\s+([12])\s*',line)
  if not m: continue
  number,session,kind,section,answer,marks=m.groups();number=int(number);marks=int(marks)
  config={'kind':kind}
  if kind=='NAT':
   config['ranges']=[list(map(float,re.fullmatch(r'\s*(-?[\d.]+)\s+to\s+(-?[\d.]+)\s*',part).groups())) for part in answer.split('OR')]
  else:
   config['answers']=sorted(answer.replace(' ','').split(';'))
   assert all(a in 'ABCD' and len(a)==1 for a in config['answers'])
  keys.append({'number':number,'session':int(session),'response_type':kind,'section':section,'marks':marks,'key':config,'pdf_page':pages[number]})
 assert [k['number'] for k in keys]==list(range(1,66)),code
 assert sum(k['marks'] for k in keys)==100
 papers.append({'code':code,'branch':branch,'branch_code':bcode,'title':f'GATE 2025 {branch}'+(' - Session 1' if code=='CE1' else ''),'paper_url':f'https://gate2025.iitr.ac.in/doc/2025/2025_QP/{code}.pdf','key_url':f'https://gate2025.iitr.ac.in/doc/2025/2025_Key/{code}_Keys.pdf','paper_sha256':hashlib.sha256(Path(f'tmp/gate2025/{code}.pdf').read_bytes()).hexdigest(),'key_sha256':hashlib.sha256(Path(f'tmp/gate2025/{code}_key.pdf').read_bytes()).hexdigest(),'questions':keys})
Path('supabase/data/gate_2025_official_papers.json').write_text(json.dumps(papers,indent=2)+'\n',encoding='utf-8')
