import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/features/driver/driver_registration/data/data_sources/d_remote_ds.dart';

import '../../domain/repositories/d_repo_base.dart';
import '../models/driver_registration_model.dart';

class DRepoImpl implements DRepoBase {
  final DriverRegistrationRemoteDataSource remoteDataSource;
  DRepoImpl({required this.remoteDataSource});
  @override
  Future<bool> registerDriver(DriverRegistrationModel model) async {
    final result = await remoteDataSource.registerDriver(model);
    try {
      if (result) {
        return result;
      }
      safePrint("Driver registered with ID");
      safePrint(result);
      return result;
    } catch (e) {
      safePrint("Error registering driver: $e");
      return false;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchBrands() async {
    final result = await remoteDataSource.fetchBrands();
    safePrint("Fetched Brands: $result");
    return result;
  }

  @override
  Future<List<Map<String, dynamic>>> fetchColors() async {
    final result = await remoteDataSource.fetchColors();
    safePrint("Fetched Colors: $result");
    return result;
  }

  @override
  Future<List<Map<String, dynamic>>> fetchModels() async {
    final result = await remoteDataSource.fetchModels();
    safePrint("Fetched Models: $result");
    return result;
  }
}
