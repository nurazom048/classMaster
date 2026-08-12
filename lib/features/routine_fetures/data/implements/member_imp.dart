import 'package:fpdart/fpdart.dart';
import '../../../../core/models/message_model.dart';
import '../models/members_models.dart';
import '../models/see_all_request_model.dart';

abstract class MemberRepositoryImp {
  // Step 4: Defined MemberRepositoryImp interface to match standard RESTful member endpoints.
  // ==========================================
  // 👥 MEMBERS MANAGEMENT (Collective)
  // ==========================================

  /// GET /:routineID/members
  /// Fetches all members in a routine with pagination
  Future<RoutineMembersModel?> getAllMembers(
    String routineID, {
    int page = 1,
    int limit = 10,
  });

  /// POST /:routineID/members
  /// Replaces: `addMemberReq` and `sendRequest`
  /// Handles both a user requesting to join (targetAccountId = null)
  /// AND an admin adding a user directly (targetAccountId provided).
  Future<Either<String, Message>> sendMemberRequest(
    String routineID, {
    String? targetAccountId,
    String? requestMessage,
  });

  // ==========================================
  // 🧑‍💻 SPECIFIC MEMBER ACTIONS
  // ==========================================

  /// PATCH /:routineID/members/:accountId
  /// Replaces: `addCaptressReq`, `removeCaptansReq`, and Notification On/Off
  /// Send `isCaptain: true/false` to promote/demote, or `notificationOn: true/false` to toggle alerts.
  Future<Message> updateMemberRole(
    String routineID,
    String accountId, {
    bool? isCaptain,
    bool? notificationOn,
  });

  /// DELETE /:routineID/members/:accountId
  /// Replaces: `removeMemberReq`, `leaveRequest`, and `removeMember`
  /// Pass the current user's accountId to leave, or another user's accountId to kick/remove them.
  Future<Either<Message, Message>> removeMember(
    String routineID,
    String accountId,
  );

  // ==========================================
  // 📩 MEMBER REQUESTS (Approve/Reject)
  // ==========================================

  /// GET /:routineID/requests
  /// Replaces: `seeAllRequest`
  Future<SeeAllRequestModel> getAllRequests(String routineID);

  /// PATCH /:routineID/requests/:requestId
  /// Replaces: `acceptRequest` and `rejectRequest`
  /// Pass `status: "ACCEPTED"` or `status: "REJECTED"`.
  /// To accept all, pass `acceptAll: true` (requestId can be empty in this case).
  Future<Message> handleRequestStatus(
    String routineID, {
    String? requestId,
    String? status, // "ACCEPTED" or "REJECTED"
    bool? acceptAll,
  });
}
