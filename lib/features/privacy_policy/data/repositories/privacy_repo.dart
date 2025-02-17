import '../data_sources/privacy_data_source.dart';

abstract class PrivacyRepository {
  Future<String> getPrivacyPolicy();
}

class PrivacyRepositoryImpl implements PrivacyRepository {
  final PrivacyDataSource privacyDataSource;
  PrivacyRepositoryImpl(this.privacyDataSource);
  @override
  Future<String> getPrivacyPolicy() => privacyDataSource.getPrivacyPolicy();
}