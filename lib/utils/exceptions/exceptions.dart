/// Exception class for handling various errors.
class WasteExceptions implements Exception {
  /// The associated error message.
  final String message;

  /// Default constructor with a generic error message.
  const WasteExceptions([
    this.message = 'An unexpected error occurred. Please try again.',
  ]);

  /// Create an authentication exception from a Firebase authentication exception code.
  factory WasteExceptions.fromCode(String code) {
    switch (code) {
      case 'email-already-in-use':
        return const WasteExceptions(
          'The email address is already registered. Please use a different email.',
        );
      case 'invalid-email':
        return const WasteExceptions(
          'The email address provided is invalid. Please enter a valid email.',
        );
      case 'weak-password':
        return const WasteExceptions(
          'The password is too weak. Please choose a stronger password.',
        );
      case 'user-disabled':
        return const WasteExceptions(
          'This user account has been disabled. Please contact support for assistance.',
        );
      case 'user-not-found':
        return const WasteExceptions('Invalid login details. User not found.');
      case 'wrong-password':
        return const WasteExceptions(
          'Incorrect password. Please check your password and try again.',
        );
      case 'INVALID_LOGIN_CREDENTIALS':
        return const WasteExceptions(
          'Invalid login credentials. Please double-check your information.',
        );
      case 'too-many-requests':
        return const WasteExceptions(
          'Too many requests. Please try again later.',
        );
      case 'invalid-argument':
        return const WasteExceptions(
          'Invalid argument provided to the authentication method.',
        );
      case 'invalid-password':
        return const WasteExceptions('Incorrect password. Please try again.');
      case 'invalid-phone-number':
        return const WasteExceptions('The provided phone number is invalid.');
      case 'operation-not-allowed':
        return const WasteExceptions(
          'The sign-in provider is disabled for your Firebase project.',
        );
      case 'session-cookie-expired':
        return const WasteExceptions(
          'The Firebase session cookie has expired. Please sign in again.',
        );
      case 'uid-already-exists':
        return const WasteExceptions(
          'The provided user ID is already in use by another user.',
        );
      case 'sign_in_failed':
        return const WasteExceptions('Sign-in failed. Please try again.');
      case 'network-request-failed':
        return const WasteExceptions(
          'Network request failed. Please check your internet connection.',
        );
      case 'internal-error':
        return const WasteExceptions('Internal error. Please try again later.');
      case 'invalid-verification-code':
        return const WasteExceptions(
          'Invalid verification code. Please enter a valid code.',
        );
      case 'invalid-verification-id':
        return const WasteExceptions(
          'Invalid verification ID. Please request a new verification code.',
        );
      case 'quota-exceeded':
        return const WasteExceptions('Quota exceeded. Please try again later.');
      default:
        return const WasteExceptions();
    }
  }
}
