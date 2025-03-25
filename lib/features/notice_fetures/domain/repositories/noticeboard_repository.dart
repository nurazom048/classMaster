import 'package:fpdart/fpdart.dart';
import '../../../../../core/models/message_model.dart';
import '../../../routine_Fetures/data/models/check_status_model.dart';

abstract class NoticeboardRepository {
  Future<Either<Message, Message>> leaveMember(String noticeBoard);
  Future<CheckStatusModel> checkStatus(String academyID);
  Future<Either<String, Message>> sendRequest(String noticeBoardId);
  Future<Either<String, Message>> notificationOff(String routineID);
  Future<Either<String, Message>> notificationOn(String routineID);
}
