import 'package:fpdart/fpdart.dart';
import '../../../../core/models/message_model.dart';
import '../models/routine_model.dart';
import '../models/routine_response_model.dart';
import '../models/class_details_model.dart';
import '../models/class_model.dart';
import '../models/find_class_model.dart';
import '../models/weekday_list_models.dart';
import '../models/check_status_model.dart';

abstract class RoutineRepositoryImp {
  /// Maps to GET `/`
  Future<RoutineResponse> listRoutines({
    String? type,
    String? search,
    String? username,
    int? page,
    int? limit,
  });

  /// Maps to POST `/`
  Future<Either<Message, Message>> createRoutine({
    required String routineName,
  });

  /// Maps to GET `/:routineID/classes`
  Future<AllClassesResponse> getAllClasses(String routineID);

  /// Maps to POST `/:routineID/classes`
  Future<String> createClass({
    required String routineID,
    required ClasssModel classModel,
    required DateTime startTime,
    required DateTime endTime,
  });

  /// Maps to POST `/:routineID` (updates notification on/off and returns CheckStatusModel)
  Future<Either<String, CheckStatusModel>> classNotification({
    required String routineID,
    required bool status,
  });

  /// Maps to GET `/classes/:classID`
  Future<FindClass> findClass(String classID);

  /// Maps to PUT `/classes/:classID`
  Future<void> editClass({
    required String classID,
    required String routineID,
    required DateTime startTime,
    required DateTime endTime,
    required ClasssModel classModel,
  });

  /// Maps to DELETE `/classes/:classID`
  Future<Message> removeClass(String classID);

  /// Maps to GET `/classes/:classID/weekdays`
  Future<WeekdayList> getAllWeekdaysInClass(String classID);

  /// Maps to POST `/classes/:classID/weekdays`
  Future<Either<Message, Message>> addWeekday({
    required String classID,
    required String room,
    required String day,
    required DateTime startTime,
    required DateTime endTime,
  });

  /// Maps to DELETE `/weekdays/:weekdayID`
  Future<Either<Message, WeekdayList>> deleteWeekdayById(
    String weekdayID, {
    String? classID,
  });

  /// Maps to GET `/:routineID`
  Future<CheckStatusModel> getCurrentUserStatus(String routineID);

  /// Maps to DELETE `/:routineID`
  Future<Either<Message, Message>> deleteRoutineById(String routineID);

  /// Maps to POST `/:routineID` (updates save/unsave and returns CheckStatusModel)
  Future<Either<String, CheckStatusModel>> saveAndUnsaveRoutine(
    String routineID,
    String saveCondition,
  );
}
