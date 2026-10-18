export function isExistingSignupAccount(data, error) {
  if (['user_already_exists', 'email_exists'].includes(error?.code)) return true;
  if (error && /user already registered|email already (?:exists|registered)/i.test(error.message || '')) return true;
  return !error && !data?.session && Array.isArray(data?.user?.identities) && data.user.identities.length === 0;
}
