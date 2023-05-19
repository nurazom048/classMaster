//_________________________
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/home_req/home_req.dart';

import '../../../../models/rutins/list_of_save_rutin.dart';

final uploadedRutinsControllerProvider =
    FutureProvider.autoDispose<ListOfUploadedRutins>((ref) {
  return ref.read(home_req_provider).uplodedRutins();
});
