import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:classmate/features/account_fetures/data/datasources/account_request.dart';
import '../../../../core/export_core.dart';
import '../../data/models/account_models.dart';
import '../../data/models/account_update.dart'; // Adjust path if separate file

// Repository provider
final accountRepositoryProvider = Provider<AccountRepositoryImpl>(
  (ref) => AccountRepositoryImpl(),
);

// FutureProvider for fetching account data
final accountDataProvider =
    FutureProvider.family<Either<AppException, AccountModels>, String?>(
  (ref, username) =>
      ref.watch(accountRepositoryProvider).getAccountData(username: username),
);

// FutureProvider for updating account data
final updateAccountProvider =
    FutureProvider.family<Either<AppException, String>, AccountUpdate>(
  (ref, updateData) => ref.watch(accountRepositoryProvider).updateAccount(
        name: updateData.name,
        username: updateData.username,
        about: updateData.about,
        profileImage: updateData.profileImage,
        coverImage: updateData.coverImage,
      ),
);
