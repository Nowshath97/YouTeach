export const PASSWORD_REQUIREMENTS = 'Use at least 8 characters, including one lowercase letter, one number, and one special character.';

export function isValidNewPassword(password) {
  return password.length >= 8 && /[a-z]/.test(password) && /[0-9]/.test(password) && /[^a-zA-Z0-9\s]/.test(password);
}
