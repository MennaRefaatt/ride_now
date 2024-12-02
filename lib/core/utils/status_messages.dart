
enum StatusMessages {
  loggedInSuccessfully,
  loginFailed,
  registrationSuccessful,
  registrationFailed,
  homeFailed,
}

extension StatusMessagesExtension on StatusMessages {
  String get message {
    switch (this) {
      case StatusMessages.loggedInSuccessfully:
        return "Loggedin Successfuly";
      case StatusMessages.loginFailed:
        return "Login Failed";
      case StatusMessages.registrationSuccessful:
        return "Loggedin Successfuly";
      case StatusMessages.registrationFailed:
        return "Registration Failed";
      case StatusMessages.homeFailed:
        return "unauthorized";
      default:
        return "";
    }
  }
}
