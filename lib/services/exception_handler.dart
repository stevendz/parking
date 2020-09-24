Map<String, String> errors = {
  "operation-not-allowed": "Anonymous accounts are not enabled",
  "weak-password": "Your password is too weak",
  "invalid-email": "Your email is invalid",
  "email-already-in-use": "Email is already in use on different account",
  "invalid-credential": "Your email is invalid",
  "wrong-password": "Your password is wrong.",
  "user-not-found": "User with this email doesn't exist.",
  "user-disabled": "User with this email has been disabled.",
  "too-many-requests": "Too many requests. Try again later.",
};
String authExceptionMessage(error) {
  return errors[error] != null ? errors[error] : "An undefined Error happened.";
}
