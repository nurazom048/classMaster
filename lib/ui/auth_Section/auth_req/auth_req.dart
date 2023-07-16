// ignore_for_file: unused_local_variable, avoid_print
import 'dart:io' as io;
import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:classmate/models/message_model.dart';
import 'package:classmate/ui/auth_Section/auth_controller/auth_controller.dart';

import '../../../constant/constant.dart';
import '../../../local data/local_data.dart';

class AuthReq {
  //........ Login .........//
  Future<Either<Message, String>> login({
    String? username,
    String? email,
    required String password,
  }) async {
    // print('Username$username || emailed$email');

    var loginUrl = Uri.parse('${Const.BASE_URl}/auth/login');

    try {
      final status = await OneSignal.shared.getDeviceState();
      final String? osUserID = status?.userId;
      print(
          ';;;;;;;;;;;;;;;;;;;;;;  one signal token;;;;;;;;;;;;;;;;;;;;;;;;;;;;;');
      print("osUserID : $osUserID");
      final response = await http.post(loginUrl, body: {
        "username": username ?? '',
        "email": email ?? '',
        "password": password,
        "osUserID": osUserID ?? ''
      });

      var message = json.decode(response.body)["message"];
      print(json.decode(response.body));
      final accountData = json.decode(response.body);
      print('*********************');
      print(accountData);

      //
      if (response.statusCode == 200) {
        await LocalData.setHerder(response);
        print('kkkkkkkkkkkkkkkkkkkkkkkkkkk');
        print(response.headers['authorization']);

        // print(accountData);
        // Save the auth token from the response headers
        final authToken = response.headers['authorization'];
        final refreshToken = response.headers['x-refresh-token'];
        await LocalData.saveAuthToken(authToken ?? '');
        await LocalData.saveRefreshToken(refreshToken ?? '');
        //... save token
        await AuthController.saveAccountType(
            accountData["account"]["account_type"]);
        await AuthController.saveUsername(accountData["account"]["username"]);

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: accountData["account"]["email"],
          password: password,
        );

        return right(message);
      } else if (response.statusCode == 401) {
        final accountData = json.decode(response.body);
        return left(Message(
          message: message,
          email: accountData["account"]["email"] ?? accountData['email'],
        ));
      } else if (response.statusCode == 402) {
        final pendingAccount = json.decode(response.body);
        return left(Message.fromJson(pendingAccount));
      } else {
        return left(Message(message: message));
      }
    } on io.SocketException catch (_) {
      throw Exception('Failed to load data');
    } on TimeoutException catch (_) {
      throw Exception('TimeOut Exception');
    } catch (e) {
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
    String? eiinNumber,
    String? contractInfo,
  }) async {
    try {
      //... send request
      final response =
          await http.post(Uri.parse('${Const.BASE_URl}/auth/create'), body: {
        "name": name,
        "username": username,
        "password": password,
        "email": email,
        "account_type": accountType.toLowerCase(),
        "EIIN": eiinNumber ?? '',
        "contractInfo": contractInfo ?? '',
      });

      var res = json.decode(response.body);
      print(res);
      if (response.statusCode == 200) {
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
    final Map<String, String> headers = await LocalData.getHerder();
    var url = Uri.parse('${Const.BASE_URl}/account/eddit/changepassword');

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
    final Map<String, String> headers = await LocalData.getHerder();
    final url = Uri.parse('${Const.BASE_URl}/account/eddit/forgotPassword');

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
              email: json.decode(response.body)['email']),
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
    String? eiinNumber,
    String? contractInfo,
  }) async {
    final Uri loginUrl = Uri.parse('${Const.BASE_URl}/auth/google');
    print(loginUrl);

    try {
      final response = await http.post(loginUrl, body: {
        "googleAuthToken": googleAuthToken,
        "account_type": accountType == null ? '' : accountType.toLowerCase(),
        "EIIN": eiinNumber ?? '',
        "contractInfo": contractInfo ?? '',
      });

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

        //... save token
        await LocalData.setHerder(response);
        await AuthController.saveAccountType(
            accountData["account"]["account_type"]);
        await AuthController.saveUsername(accountData["account"]["username"]);

        //

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
