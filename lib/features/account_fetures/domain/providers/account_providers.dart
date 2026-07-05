import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:classmate/features/account_fetures/data/datasources/account_request.dart';
import '../../../../core/export_core.dart';
import '../../data/models/account_models.dart';

// Repository provider
final accountRepositoryProvider = Provider<AccountRepositoryImpl>(
  (ref) => AccountRepositoryImpl(),
);

// FutureProvider for fetching account data
final accountDataProvider =
    FutureProvider.family<Either<AppException, AccountModels>, String?>(
      (ref, username) => ref
          .watch(accountRepositoryProvider)
          .getAccountData(username: username),
    );

// FutureProvider for updating account data
final updateAccountProvider =
    FutureProvider.family<Either<AppException, String>, AccountEditModel>(
      (ref, updateData) => ref
          .watch(accountRepositoryProvider)
          .updateAccount(
            name: updateData.name,
            username: updateData.username,
            about: updateData.about,
            accountType: updateData.accountType,
            district: updateData.district,
            upazila: updateData.upazila,
            streetAddress: updateData.streetAddress,
            latitude: updateData.latitude,
            longitude: updateData.longitude,
            profileImage: updateData.image,
            coverImage: updateData.coverImage,
          ),
    );
