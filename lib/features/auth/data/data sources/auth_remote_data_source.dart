// ignore_for_file: public_member_api_docs, sort_constructors_first

import '../../../../core/databases/api/api_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/databases/cache/secure_storage_helper.dart';
import '../../../../core/databases/cache/shared_prefs_helper.dart';
import '../../../../core/databases/params/params.dart';
import '../model/template_t_model.dart';

class AuthRemoteDataSource {
  final ApiConsumer api;
  final SecureStorageHelper secureCacheHelper;
  final SharedPrefsHelper cacheHelper;
  AuthRemoteDataSource({
    required this.api,
    required this.secureCacheHelper,
    required this.cacheHelper,
  });
  Future<TemplateTModel> login(TemplateTParams params) async {
    final response = await api.get(
      "${EndPoints.templateT}/",
      // headers: headers,
      // extra: extra,
    );
    return TemplateTModel.fromMap(response);
  }
}
