import 'dart:convert';
import 'package:classmate/features/routine/presentation/utils/popup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constant/constant.dart';
import '../../../../core/local_data/api_cache_manager.dart';
import '../../../../core/local_data/local_data.dart';
import '../../../../core/models/message_model.dart';
import '../../../home_fetures/presentation/utils/utils.dart';

import '../implements/routine_imp.dart';
import '../models/class_details_model.dart';
import '../models/class_model.dart';
import '../models/find_class_model.dart';
import '../models/weekday_list_models.dart';
import '../models/check_status_model.dart';
import '../models/routine_response_model.dart';

final routineReqProvider = Provider<RoutineRepositoryImp>(
  (ref) => RoutineRequestImpl(),
);

class RoutineRequestImpl implements RoutineRepositoryImp {
  @override
  Future<RoutineResponse> listRoutines({
    String? type,
    String? search,
    String? username,
    int? page,
    int? limit,
  }) async {
    final queryParams = <String, String>{};
    if (type != null && type.isNotEmpty) queryParams['type'] = type;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (username != null && username.isNotEmpty)
      queryParams['username'] = username;
    if (page != null) queryParams['page'] = page.toString();
    if (limit != null) queryParams['limit'] = limit.toString();

    final uri = Uri.parse(
      '${Const.BASE_URl}/routine',
    ).replace(queryParameters: queryParams);
    final headers = await LocalData.getHeader();
    final bool isOnline = await Utils.isOnlineMethod();
    final String key = "RoutineList_offline_data_$uri";
    var routineCacheBox = await Hive.openBox('routineCache');

    try {
      if (!isOnline) {
        if (routineCacheBox.containsKey(key)) {
          Get.snackbar('Offline Mode', "Loading cached data...");
          var cachedData = routineCacheBox.get(key);
          return RoutineResponse.fromJson(json.decode(cachedData));
        } else {
          throw "No cached data available.";
        }
      }

      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        await routineCacheBox.put(key, response.body);
        return RoutineResponse.fromJson(json.decode(response.body));
      } else {
        final res = json.decode(response.body);
        throw res["message"] ?? "Failed to load routines";
      }
    } catch (e) {
      if (routineCacheBox.containsKey(key)) {
        var cachedData = routineCacheBox.get(key);
        return RoutineResponse.fromJson(json.decode(cachedData));
      }
      rethrow;
    }
  }

  @override
  Future<Either<Message, Message>> createRoutine({
    required String routineName,
  }) async {
    final headers = await LocalData.getHeader();
    final uri = Uri.parse('${Const.BASE_URl}/routine');

    try {
      final response = await http.post(
        uri,
        body: jsonEncode({"name": routineName}),
        headers: headers,
      );

      final res = json.decode(response.body);
      Message message = Message.fromJson(res);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return right(
          Message(
            message: message.message,
            routineID: res['routine']?['id'],
            routineName: res['routine']?['routineName'],
          ),
        );
      } else {
        return left(message);
      }
    } catch (e) {
      return left(Message(message: e.toString()));
    }
  }

  @override
  Future<AllClassesResponse> getAllClasses(String routineID) async {
    final bool isOnline = await Utils.isOnlineMethod();
    final String path = "${Const.BASE_URl}/routine/$routineID/classes";
    final url = Uri.parse(path);
    final String key = "Class-$path";
    final isHaveCache = await MyApiCache.haveCache(key);
    final headers = await LocalData.getHeader();

    try {
      if (!isOnline && isHaveCache) {
        final getData = await MyApiCache.getData(key);
        return AllClassesResponse.fromJson(getData);
      } else {
        final response = await http.get(url, headers: headers);
        final res = json.decode(response.body);
        if (response.statusCode == 200) {
          await MyApiCache.saveLocal(key: key, response: response.body);
          return AllClassesResponse.fromJson(res);
        } else {
          throw res['message'] ?? "Failed to load classes";
        }
      }
    } catch (error) {
      if (isHaveCache) {
        final getData = await MyApiCache.getData(key);
        return AllClassesResponse.fromJson(getData);
      }
      rethrow;
    }
  }

  @override
  Future<String> createClass({
    required String routineID,
    required ClasssModel classModel,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final headers = await LocalData.getHeader();
    final url = Uri.parse('${Const.BASE_URl}/routine/$routineID/classes');

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        ...classModel.toRequestBody(),
        "startTime": endMaker(startTime.toIso8601String().toString()),
        "endTime": endMaker(endTime.toIso8601String().toString()),
      }),
    );
    final res = json.decode(response.body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return res["result"]["createdClass"]["id"];
    } else {
      throw res["message"] ?? "Failed to add class";
    }
  }

  @override
  Future<Either<String, CheckStatusModel>> classNotification({
    required String routineID,
    required bool status,
  }) async {
    final headers = await LocalData.getHeader();
    final url = Uri.parse('${Const.BASE_URl}/routine/$routineID');
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          "notificationOn": status,
          "status": status ? "on" : "off",
        }),
      );
      if (response.statusCode == 200) {
        final statusModel = CheckStatusModel.fromJson(jsonDecode(response.body));
        return right(statusModel);
      } else {
        final res = jsonDecode(response.body);
        return left(res["message"] ?? "Failed to update notification status");
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<FindClass> findClass(String classID) async {
    final headers = await LocalData.getHeader();
    final url = Uri.parse('${Const.BASE_URl}/routine/classes/$classID');
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return FindClass.fromJson(json.decode(response.body));
    } else {
      throw json.decode(response.body)["message"] ?? "Class not found";
    }
  }

  @override
  Future<void> editClass({
    required String classID,
    required String routineID,
    required DateTime startTime,
    required DateTime endTime,
    required ClasssModel classModel,
  }) async {
    final headers = await LocalData.getHeader();
    final url = Uri.parse('${Const.BASE_URl}/routine/classes/$classID');
    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode({
        ...classModel.toRequestBody(),
        "startTime": startTime.toIso8601String().substring(0, 19),
        "endTime": endTime.toIso8601String().substring(0, 19),
      }),
    );
    if (response.statusCode != 200) {
      final res = json.decode(response.body);
      throw res["message"] ?? "Failed to edit class";
    }
  }

  @override
  Future<Message> removeClass(String classID) async {
    final headers = await LocalData.getHeader();
    final url = Uri.parse('${Const.BASE_URl}/routine/classes/$classID');
    final response = await http.delete(url, headers: headers);
    final res = json.decode(response.body);
    if (response.statusCode == 200) {
      return Message.fromJson(res);
    } else {
      throw res["message"] ?? "Failed to remove class";
    }
  }

  @override
  Future<WeekdayList> getAllWeekdaysInClass(String classID) async {
    final url = Uri.parse(
      '${Const.BASE_URl}/routine/classes/$classID/weekdays',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return WeekdayList.fromJson(json.decode(response.body));
    } else {
      throw json.decode(response.body)["message"] ?? "Failed to load weekdays";
    }
  }

  @override
  Future<Either<Message, Message>> addWeekday({
    required String classID,
    required String room,
    required String day,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final headers = await LocalData.getHeader();
    final url = Uri.parse(
      '${Const.BASE_URl}/routine/classes/$classID/weekdays',
    );
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          "day": day,
          "room": room,
          "startTime": startTime.toIso8601String().substring(0, 19),
          "endTime": endTime.toIso8601String().substring(0, 19),
        }),
      );
      var res = Message.fromJson(jsonDecode(response.body));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return right(res);
      } else {
        return left(res);
      }
    } catch (e) {
      return left(Message(message: e.toString()));
    }
  }

  @override
  Future<Either<Message, WeekdayList>> deleteWeekdayById(
    String weekdayID, {
    String? classID,
  }) async {
    final headers = await LocalData.getHeader();
    final url = Uri.parse('${Const.BASE_URl}/routine/weekdays/$weekdayID');
    try {
      final response = await http.delete(url, headers: headers);
      if (response.statusCode == 200) {
        return right(WeekdayList.fromJson(jsonDecode(response.body)));
      } else {
        return left(Message.fromJson(jsonDecode(response.body)));
      }
    } catch (e) {
      return left(Message(message: e.toString()));
    }
  }

  @override
  Future<CheckStatusModel> getCurrentUserStatus(String routineID) async {
    final bool isOnline = await Utils.isOnlineMethod();
    final key = "getCurrentUserStatus$routineID";
    final bool isHaveCash = await MyApiCache.haveCache(key);
    final headers = await LocalData.getHeader();
    final url = Uri.parse('${Const.BASE_URl}/routine/$routineID');

    try {
      if (!isOnline && isHaveCash) {
        Map<String, dynamic> getData = await MyApiCache.getData(key);
        return CheckStatusModel.fromJson(getData);
      } else if (!isOnline) {
        throw "You Are Offline";
      } else {
        final response = await http.get(url, headers: headers);
        if (response.statusCode == 200) {
          await MyApiCache.saveLocal(key: key, response: response.body);
          return CheckStatusModel.fromJson(jsonDecode(response.body));
        } else {
          throw Exception(
            jsonDecode(response.body)["message"] ?? "Failed to get user status",
          );
        }
      }
    } catch (e) {
      if (isHaveCash) {
        var getData = await MyApiCache.getData(key);
        return CheckStatusModel.fromJson(getData);
      }
      rethrow;
    }
  }

  @override
  Future<Either<Message, Message>> deleteRoutineById(String routineID) async {
    final headers = await LocalData.getHeader();
    final url = Uri.parse("${Const.BASE_URl}/routine/$routineID");
    try {
      final response = await http.delete(url, headers: headers);
      final res = Message.fromJson(jsonDecode(response.body));
      if (response.statusCode == 200) {
        return right(Message(message: res.message, routineID: routineID));
      } else {
        return left(res);
      }
    } catch (e) {
      return left(Message(message: e.toString()));
    }
  }

  @override
  Future<Either<String, CheckStatusModel>> saveAndUnsaveRoutine(
    String routineID,
    String saveCondition,
  ) async {
    final headers = await LocalData.getHeader();
    final url = Uri.parse('${Const.BASE_URl}/routine/$routineID');
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({'saveCondition': saveCondition}),
      );
      if (response.statusCode == 200) {
        final statusModel = CheckStatusModel.fromJson(jsonDecode(response.body));
        return right(statusModel);
      } else {
        final res = jsonDecode(response.body);
        return left(res["message"] ?? "Failed to save/unsave routine");
      }
    } catch (e) {
      return left(e.toString());
    }
  }
}
