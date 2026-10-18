export const examFamilies = ['All Exams','Engineering','State PSC','SSC','Banking','UPSC','Other Exams'];
export const examCatalog = [
 {id:'aee',name:'TGPSC AEE',family:'State PSC',tone:'purple',description:'General Studies and engineering papers',branches:true},
 {id:'cgl',name:'SSC CGL',family:'SSC',tone:'pink',description:'Tier I, Tier II, reasoning, maths and English'},
 {id:'gate',name:'GATE',family:'Engineering',tone:'indigo',description:'Civil, Mechanical, Electrical, CSE and more',branches:true},
 {id:'ese',name:'ESE / IES',family:'Engineering',tone:'blue',description:'Prelims, main papers and subject practice',branches:true},
 {id:'group2',name:'TGPSC Group 2',family:'State PSC',tone:'orange',description:'General Studies and state-specific papers'},
 {id:'sbi',name:'SBI PO',family:'Banking',tone:'teal',description:'Banking aptitude, reasoning and English'},
 {id:'ssc-je',name:'SSC JE',family:'SSC',tone:'blue',description:'Junior Engineer papers by discipline',branches:true},
 {id:'upsc',name:'UPSC',family:'UPSC',tone:'indigo',description:'General Studies and aptitude practice'},
 {id:'other',name:'Other Exams',family:'Other Exams',tone:'teal',description:'Explore more recruitment and subject tests',branches:true},
];
export function mockExamId(test) {
 const title=test.title||'';
 if(/\bssc\s*cgl\b/i.test(title))return 'cgl';
 if(/(?:tgpsc|tspsc).*group\s*(?:2|ii)\b/i.test(title))return 'group2';
 if(/(?:tgpsc|tspsc).*aee/i.test(title))return 'aee';
 if(/\bgate\b/i.test(title))return 'gate';
 if(/\b(?:ese|ies)\b/i.test(title))return 'ese';
 if(/\bsbi\s*po\b/i.test(title))return 'sbi';
 if(/\bssc\s*je\b|junior engineer/i.test(title))return 'ssc-je';
 if(/\bupsc\b/i.test(title))return 'upsc';
 // Only use explicit catalogue exam types; descriptions can name unrelated exams.
 const type=(test.exam_type||'').toUpperCase();
 return ({GATE:'gate',ESE:'ese',SSC_CGL:'cgl',SSC_JE:'ssc-je',UPSC:'upsc',SBI_PO:'sbi'})[type]||'other';
}
