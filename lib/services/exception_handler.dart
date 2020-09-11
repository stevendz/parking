String sigupExceptionMessage(error) {
  switch (error) {
    case "operation-not-allowed":
      return "Anonymous accounts are not enabled";
      break;
    case "weak-password":
      return "Your password is too weak";
      break;
    case "invalid-email":
      return "Your email is invalid";
      break;
    case "email-already-in-use":
      return "Email is already in use on different account";
      break;
    case "invalid-credential":
      return "Your email is invalid";
      break;
    default:
      return "An undefined Error happened.";
  }
}

String signinExceptionMessage(error) {
  switch (error) {
    case "invalid-email":
      return "Your email address appears to be malformed.";
      break;
    case "wrong-password":
      return "Your password is wrong.";
      break;
    case "user-not-found":
      return "User with this email doesn't exist.";
      break;
    case "user-disabled":
      return "User with this email has been disabled.";
      break;
    case "too-many-requests":
      return "Too many requests. Try again later.";
      break;
    case "operation-not-allowed":
      return "Signing in with Email and Password is not enabled.";
      break;
    default:
      return "An undefined Error happened.";
  }
}
