import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/helper/app_exception.dart';
import '../../../../../core/models/message_model.dart';
import '../../data/models/check_status_model.dart';
import '../../data/models/routine_model.dart';

// =====================================================================
// 🎯 LAYER 1: ABSTRACT REPOSITORY (The Contract / Blueprint)
// =====================================================================
abstract class RoutineRepository {
  /// ✨ Creates a new routine in the database
  Future<Either<AppException, Routine>> createRoutine({
    required String routineName,
  });

  /// 🔄 Updates existing routine details
  Future<Either<AppException, String>> updateRoutine({
    required String routineId,
    required String routineName,
  });

  /// ❌ Deletes a specific routine by ID
  Future<Either<AppException, String>> deleteRoutine(String routineId);

  /// 🔍 Fetches the current status of a routine (With Cache Support)
  Future<CheckStatusModel> chalkStatus(dynamic routineId);

  /// 🗑️ Removes a specific class from a routine
  Future<Message> deleteClass(dynamic context, dynamic classId);

  /// 💾 Toggles the saved status of a routine for the user
  Future<Either<String, Message>> saveUnsavedRoutineReq(
    dynamic routineId,
    dynamic condition,
  );
}
