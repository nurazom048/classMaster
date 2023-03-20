// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/models/chackStatusModel.dart';
import 'package:table/models/seeAllRequestModel.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/request/rutin_request.dart';

class accept {
  final String rutin_id;
  final String? usernme;

  accept({required this.rutin_id, this.usernme});
}

//.... Controller...//
final chackStatusUser_provider = FutureProvider.family
    .autoDispose<CheckStatusModel, String>((ref, rutin_id) {
  return ref.read(FullRutinProvider).chackStatus(rutin_id);
});

final see_all_request_provider =
    FutureProvider.family.autoDispose<RequestModel, String>((ref, rutin_id) {
  return ref.read(FullRutinProvider).sell_all_request(rutin_id);
});
final accept_request_provider =
    FutureProvider.autoDispose.family<dynamic, accept>((ref, accept) async {
  return await ref
      .read(FullRutinProvider)
      .acceptRequest(accept.rutin_id, accept.usernme);
});
final reject_request_provider =
    FutureProvider.autoDispose.family<dynamic, accept>((ref, accept) async {
  return await ref
      .read(FullRutinProvider)
      .rejectRequest(accept.rutin_id, accept.usernme);
});
