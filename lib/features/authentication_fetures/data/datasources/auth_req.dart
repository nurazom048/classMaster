// ignore_for_file: unused_local_variable, avoid_print
import 'dart:io' as io;
import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../../../../core/export_core.dart';
import '../../../../core/helper/helper_fun.dart';
import '../../../../core/local data/local_data.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb

class AuthReq {
  //........ Login .........//
  Future<Either<Message, String>> login({
    String? username,
    String? email,
    required String password,
  }) async {
    var loginUrl = Uri.parse('${Const.BASE_URl}/auth/login');

    try {
      String? oneSignalUserId;
      if (!kIsWeb) {
        // final status = await OneSignal.shared.getDeviceState();
        // oneSignalUserId = status?.userId;
      }

      final body = {
        "username": username ?? '',
        "email": email ?? '',
        "password": password,
      };

      final response = await http.post(loginUrl, body: body);
      final responseBody = json.decode(response.body);

      print(responseBody);

      final message = responseBody["message"];
      if (message == null || message is! String) {
        throw Exception("Invalid or missing 'message' in response");
      }

      if (response.statusCode == 200) {
        final accountData = responseBody["account"];
        if (accountData == null || accountData is! Map<String, dynamic>) {
          throw Exception("Invalid 'account' data in response");
        }

        final email = accountData["accountData"]?["email"];
        if (email == null || email is! String) {
          throw Exception("Invalid or missing email in account data");
        }

        await LocalData.setHerder(response);
        await LocalData.saveAuthToken(response.headers['authorization'] ?? '');
        await LocalData.saveRefreshToken(
          response.headers['x-refresh-token'] ?? '',
        );
        await LocalData.saveAccountType(accountData["accountType"]);
        await LocalData.saveUsername(accountData["username"]);

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        return right(message);
      } else if (response.statusCode == 401) {
        final email =
            responseBody['email'] ?? responseBody["account"]?["email"];
        return left(Message(message: message, email: email));
      } else if (response.statusCode == 402) {
        return left(Message.fromJson(responseBody));
      } else {
        return left(Message(message: message));
      }
    } on io.SocketException catch (_) {
      throw Exception('Failed to load data');
    } on TimeoutException catch (_) {
      throw Exception('Timeout Exception');
    } catch (e) {
      print(e);
      return left(Message(message: e.toString()));
    }
  }

  //  create a new account
  static Future<Either<Message, Message>> createAccount(
    context, {
    required name,
    required username,
    required password,
    required email,
    required String accountType,
    String? contractInfo,
  }) async {
    final uri = Uri.parse('${Const.BASE_URl}/auth/create');
    try {
      //... send request
      final response = await http.post(
        uri,
        body: {
          "name": name,
          "username": username,
          "password": password,
          "email": email,
          "accountType": Multiple.getAccountType(accountType),
          "contractInfo": contractInfo ?? '',
        },
      );

      var res = json.decode(response.body);
      print(res);
      if (response.statusCode == 200) {
        // Delete signup info from Hive
        var signUpInfoHive = Hive.box('signUpInfo');
        await signUpInfoHive.clear(); // Clears all stored signup data
        print("Signup data deleted from Hive");
        await LocalData.setHerder(response);

        return right(Message.fromJson(res));
      } else {
        return right(Message.fromJson(res));
      }
    } catch (e) {
      print(e.toString());
      return left(Message(message: e.toString()));
    }
  }

  //***************  Account data  *************//
  Future<Either<String, Message>> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    final Map<String, String> headers = await LocalData.getHeader();
    var url = Uri.parse('${Const.BASE_URl}/account/edit/change_password');

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: {"oldPassword": oldPassword, "newPassword": newPassword},
      );
      print(jsonDecode(response.body));

      Message message = Message.fromJson(json.decode(response.body));
      if (response.statusCode == 200) {
        await LocalData.setHerder(response);

        return right(message);
      } else {
        return left(message.message);
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  //

  Future<Either<String, Message>> forgetPassword({
    String? email,
    String? username,
    String? phone,
  }) async {
    final Map<String, String> headers = await LocalData.getHeader();
    final url = Uri.parse('${Const.BASE_URl}/account/edit/forgotPassword');

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: {
          "email": email.toString(),
          "username": username.toString(),
          "phone": phone.toString(),
        },
      );

      Message message = Message.fromJson(json.decode(response.body));

      print("....................................");
      print(jsonDecode(response.body));

      print(json.decode(response.body));
      if (response.statusCode == 200) {
        await LocalData.setHerder(response);

        return right(
          Message(
            message: message.message,
            email: json.decode(response.body)['email'],
          ),
        );
      } else {
        return left(message.message);
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  //........ Login .........//
  Future<Either<Message, String>> continueWithGoogle({
    required String googleAuthToken,
    String? accountType,
    String? contractInfo,
  }) async {
    final Uri loginUrl = Uri.parse('${Const.BASE_URl}/auth/google');
    print(loginUrl);

    try {
      final response = await http.post(
        loginUrl,
        body: {
          "googleAuthToken": googleAuthToken,
          "account_type": Multiple.getAccountType(accountType),
          "contractInfo": contractInfo ?? '',
        },
      );

      Message message = Message(message: json.decode(response.body)['message']);
      final accountData = json.decode(response.body);
      print('*********************');
      print(accountData);
      if (response.statusCode == 201) {
        left(Message(message: json.decode(response.body)['message']));
      }
      //
      if (response.statusCode == 200) {
        await LocalData.setHerder(response);
        // print('kkkkkkkkkkkkkkkkkkkkkkkkkkk');
        // print(response.headers['authorization']);

        // print(accountData);
        // Save the auth token from the response headers
        final authToken = response.headers['authorization'];
        final refreshToken = response.headers['x-refresh-token'];
        await LocalData.saveAuthToken(authToken ?? '');
        await LocalData.saveRefreshToken(refreshToken ?? '');
        //... save token
        print(accountData["account"]["account_type"]);
        await LocalData.saveAccountType(accountData["account"]["account_type"]);
        await LocalData.saveUsername(accountData["account"]["username"]);

        return right(message.message);
      } else {
        return left(message);
      }
    } on io.SocketException catch (_) {
      throw Exception('Failed to load data');
    } on TimeoutException catch (_) {
      throw Exception('TimeOut Exception');
    } catch (e) {
      return left(Message(message: e.toString()));
    }
  }
}

final authReqProvider = Provider((ref) => AuthReq());
