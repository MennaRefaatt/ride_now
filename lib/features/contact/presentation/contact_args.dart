class ContactArgs {
  final String callerName;
  final String phoneNumber;
  final String receiverFCMToken;

  ContactArgs(
      {required this.callerName,
      required this.phoneNumber,
      required this.receiverFCMToken});
}
