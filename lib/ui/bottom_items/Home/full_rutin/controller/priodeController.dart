// ignore_for_file: camel_case_types

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/widgets/Alart.dart';
import '../request/priodeREquest/priode_request.dart';

//.. prvider...//
final priodeController = StateNotifierProvider.autoDispose(
    (ref) => priodeClassController(ref.watch(priodeRequestProvider)));

//
//...class....//
class priodeClassController extends StateNotifier {
  priodeRequest priodereq;

  priodeClassController(this.priodereq) : super(null);

  //....deletePriode
  void deletePriode(WidgetRef ref, BuildContext context, String priodeId) {
    var deleteRes = ref.watch(deletePriodeProvider(priodeId));

    deleteRes.when(
      data: (data) => Alart.showSnackBar(context, data?.message),
      error: (error, stackTrace) => Alart.handleError(context, error),
      loading: () {},
    );
  }
}
