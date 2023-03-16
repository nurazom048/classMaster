// ignore_for_file: non_constant_identifier_names

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/models/membersModels.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/request/members_request.dart';

final rutin_member_provider = Provider((ref) => membersRequest());

//
final all_members_provider =
    FutureProvider.family.autoDispose<MembersModel?, String>((ref, rutin_id) {
  return ref.read(rutin_member_provider).all_members(rutin_id);
});
