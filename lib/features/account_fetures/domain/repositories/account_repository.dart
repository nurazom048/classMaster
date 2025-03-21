import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/export_core.dart';
import '../../data/models/account_models.dart';

abstract class AccountRepository {
  Future<Either<AppException, AccountModels>> getAccountData(
      {String? username});
  Future<Either<AppException, String>> updateAccount({
    required String name,
    required String username,
    required String about,
    XFile? profileImage, // Changed from String? to XFile?
    XFile? coverImage, // Changed from String? to XFile?
  });
}
