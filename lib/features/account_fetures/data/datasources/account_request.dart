// ignore_for_file: avoid_print

import 'dart:io' as io;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../../../core/local_data/api_cache_manager.dart';
import '../../../../core/local_data/local_data.dart';
import '../../../home_fetures/presentation/utils/utils.dart';
import '../../domain/repositories/account_repository.dart';
import '../models/account_models.dart';
import '../../../../core/export_core.dart';

class GetAccountData {
  final AccountRepository repository;

  GetAccountData(this.repository);

  Future<Either<AppException, AccountModels>> call({String? username}) {
    return repository.getAccountData(username: username);
  }
}

class AccountRepositoryImpl implements AccountRepository {
  @override
  Future<Either<AppException, AccountModels>> getAccountData({
    String? username,
  }) async {
    try {
      final headers = await LocalData.getHeader();
      final url =
          username != null
              ? Uri.parse('${Const.BASE_URl}/account/$username')
              : Uri.parse('${Const.BASE_URl}/account/');
      final cacheKey = url.toString();

      final isOnline = await Utils.isOnlineMethod();
      final hasCache = await MyApiCache.haveCache(cacheKey);
      print('Hit on url: $cacheKey');

      // If offline, return cached data
      if (!isOnline && hasCache) {
        return Right(
          AccountModels.fromJson(await MyApiCache.getData(cacheKey)),
        );
      }

      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        print(
          'Response from account  : ${response.body}',
        ); //TODO: remove this line after testing
        await MyApiCache.saveLocal(key: cacheKey, response: response.body);

        return Right(AccountModels.fromJson(json.decode(response.body)));
      }

      return Left(
        AppException(
          message: json.decode(response.body)['message'] ?? 'Unknown error',
        ),
      );
    } on io.SocketException {
      return Left(AppException(message: 'No internet connection'));
    } on TimeoutException {
      return Left(AppException(message: 'Request timed out'));
    } catch (e) {
      return Left(AppException(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<AppException, String>> updateAccount({
    required String name,
    required String username,
    required String about,
    String? accountType,
    String? district,
    String? upazila,
    String? streetAddress,
    double? latitude,
    double? longitude,
    XFile? profileImage,
    XFile? coverImage,
  }) async {
    try {
      final headers = await LocalData.getHeader();
      final url = Uri.parse('${Const.BASE_URl}/account/edit');
      final request = http.MultipartRequest('POST', url);
      request.headers.addAll(headers);

      request.fields['name'] = name;
      request.fields['username'] = username;
      request.fields['about'] = about;
      if (accountType != null) request.fields['accountType'] = accountType;
      if (district != null) request.fields['district'] = district;
      if (upazila != null) request.fields['upazila'] = upazila;
      if (streetAddress != null) request.fields['streetAddress'] = streetAddress;
      if (latitude != null) request.fields['latitude'] = latitude.toString();
      if (longitude != null) request.fields['longitude'] = longitude.toString();

      if (profileImage != null) {
        if (kIsWeb) {
          // Web: Use bytes
          final bytes = await profileImage.readAsBytes();
          request.files.add(
            http.MultipartFile.fromBytes(
              'image',
              bytes,
              filename: profileImage.name,
            ),
          );
        } else {
          // Native: Use file path
          request.files.add(
            await http.MultipartFile.fromPath(
              'image',
              profileImage.path, // Use .path here
            ),
          );
        }
      }

      if (coverImage != null) {
        if (kIsWeb) {
          // Web: Use bytes
          final bytes = await coverImage.readAsBytes();
          request.files.add(
            http.MultipartFile.fromBytes(
              'coverImage',
              bytes,
              filename: coverImage.name,
            ),
          );
        } else {
          // Native: Use file path
          request.files.add(
            await http.MultipartFile.fromPath(
              'coverImage',
              coverImage.path, // Use .path here
            ),
          );
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return const Right("Account updated successfully");
      }

      return Left(
        AppException(
          message: 'Failed to update account: ${response.statusCode}',
        ),
      );
    } catch (e) {
      print('Error in updateAccount: $e');
      return Left(AppException(message: 'Error updating account: $e'));
    }
  }
}
