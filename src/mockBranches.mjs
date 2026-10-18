export const ALL_BRANCHES = 'All branches';
export const GENERAL_BRANCH = 'General & Aptitude';
export const UNCATEGORIZED_BRANCH = 'Uncategorized';
export const DEFAULT_BRANCH = 'Civil Engineering';
export const SSC_CGL_SECTION = 'SSC CGL';
const standardBranches = ['Civil Engineering', 'Mechanical Engineering', 'Electrical Engineering', 'Electronics and Communication Engineering', 'Computer Science'];
const normalizeBranch = name => /^(ssc\s*cgl|general studies|general aptitude|general abilities|general & aptitude)$/i.test(name) ? GENERAL_BRANCH : name;

export function getMockBranch(test, subjects, branches) {
  const subject = subjects.find(item => item.id === test.subject_id);
  const branch = branches.find(item => item.id === subject?.branch_id);
  if (/\bssc\s*cgl\b/i.test(test.title || '') || /^ssc\s*cgl$/i.test(branch?.name || '')) return SSC_CGL_SECTION;
  if (branch) return normalizeBranch(branch.name);
  // Older catalogue entries may not have subject_id. Use only explicit titles,
  // never generic descriptions which can mention unrelated engineering papers.
  const title = test.title || '';
  if (/\bcivil\b/i.test(title)) return 'Civil Engineering';
  if (/\bmechanical\b/i.test(title)) return 'Mechanical Engineering';
  if (/\belectronics\b/i.test(title)) return 'Electronics and Communication Engineering';
  if (/\belectrical\b/i.test(title)) return 'Electrical Engineering';
  if (/\bcomputer science\b/i.test(title)) return 'Computer Science';
  if (/ssc\s*cgl|general studies|general aptitude|general abilities/i.test(title)) return GENERAL_BRANCH;
  return UNCATEGORIZED_BRANCH;
}

export function getBranchOptions(tests, subjects, branches) {
  const names = new Set([...standardBranches, ...branches.map(branch => normalizeBranch(branch.name)), ...tests.map(test => getMockBranch(test, subjects, branches))]);
  names.delete(GENERAL_BRANCH);
  names.delete(UNCATEGORIZED_BRANCH);
  names.delete(SSC_CGL_SECTION);
  return [ALL_BRANCHES, ...names, GENERAL_BRANCH, ...(tests.some(test => getMockBranch(test, subjects, branches) === UNCATEGORIZED_BRANCH) ? [UNCATEGORIZED_BRANCH] : [])];
}

export function matchesMockBranch(test, selectedBranch, subjects, branches) {
  const branch = getMockBranch(test, subjects, branches);
  if (branch === SSC_CGL_SECTION || selectedBranch === SSC_CGL_SECTION) return branch === selectedBranch;
  return selectedBranch === ALL_BRANCHES || branch === selectedBranch || (branch === GENERAL_BRANCH && selectedBranch !== UNCATEGORIZED_BRANCH);
}
