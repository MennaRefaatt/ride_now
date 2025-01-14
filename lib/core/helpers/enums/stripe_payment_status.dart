enum StripePaymentStatus { succeeded, failed,holding, }
extension StripePaymentStatusExtension on StripePaymentStatus {
  String get name {
    switch (this) {
      case StripePaymentStatus.holding:
        return 'holding';
      case StripePaymentStatus.succeeded:
        return 'succeeded';
      case StripePaymentStatus.failed:
        return 'failed';
    }
  }
}