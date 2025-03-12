class ContactArgs {
  final String callerName;
  final String phoneNumber;
  final String receiverFCMToken;
final String receiverProfilePicture;
  ContactArgs(
      {required this.callerName,
      required this.receiverProfilePicture,
      required this.phoneNumber,
      required this.receiverFCMToken});
}
