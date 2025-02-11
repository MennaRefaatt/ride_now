import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/features/driver/driver_registration/data/data_sources/d_remote_ds.dart';
import '../../domain/repositories/d_repo_base.dart';
import '../models/driver_registration_model.dart';
import '../models/brand_model.dart';
import '../models/color_model.dart';
import '../models/model_model.dart';

class DRepoImpl implements DRepoBase {
  final DriverRegistrationRemoteDataSource remoteDataSource;

  DRepoImpl({required this.remoteDataSource});

  @override
  Future<bool> registerDriver(DriverRegistrationModel model) async {
    try {
      final result = await remoteDataSource.registerDriver(model);
      safePrint("Driver registered with ID: $result");
      return result;
    } catch (e) {
      safePrint("Error registering driver: $e");
      return false;
    }
  }

  @override
  Future<List<BrandModel>> fetchBrands() async {
    final result = await remoteDataSource.fetchBrands();
    safePrint("Fetched Brands: $result");
    return result;
  }

  @override
  Future<List<ColorModel>> fetchColors() async {
    final result = await remoteDataSource.fetchColors();
    safePrint("Fetched Colors: $result");
    return result;
  }

  @override
  Future<List<ModelModel>> fetchModels() async {
    final result = await remoteDataSource.fetchModels();
    safePrint("Fetched Models: $result");
    return result;
  }
}
