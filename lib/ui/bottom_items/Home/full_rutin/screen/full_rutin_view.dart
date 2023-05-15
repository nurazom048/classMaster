// ignore_for_file: avoid_print, non_constant_identifier_names, must_be_immutable, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/server/rutinReq.dart';
import 'package:table/widgets/progress_indicator.dart';
import '../../../../../core/dialogs/alart_dialogs.dart';
import '../../../../../sevices/notification services/awn_package.dart';
import '../widgets/rutin_box/rutine_boox.dart';
import '../utils/rutin_dialog.dart';

class FullRutineView extends StatefulWidget {
  const FullRutineView(
      {super.key, required this.rutinId, required this.rutinName});
  final String rutinId;
  final String rutinName;

  @override
  State<FullRutineView> createState() => _FullRutineViewState();
}

class _FullRutineViewState extends State<FullRutineView> {
  @override
  void initState() {
    super.initState();

    AwsomNotificationSetup.takePermiton(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer(builder: (context, ref, _) {
          //? Provider
          final rutinDetals =
              ref.watch(rutins_detalis_provider(widget.rutinId));
          return Column(
            children: [
              //  CustomTopBar(rutinName),
              rutinDetals.when(
                data: (data) {
                  return RutinBox(
                    rutinId: widget.rutinId,
                    rutinNmae: widget.rutinName,
                    accountData: data!.owner,
                    sun: data.classes.sunday,
                    mon: data.classes.monday,
                    tue: data.classes.tuesday,
                    wed: data.classes.wednesday,
                    thu: data.classes.thursday,
                    fri: data.classes.friday,
                    sat: data.classes.saturday,
                    //
                    onTapMore: () {
                      RutinDialog.ChackStatusUser_BottomSheet(
                          context, widget.rutinId, widget.rutinName);
                    },
                  );
                },
                error: (error, stackTrace) => Alart.handleError(context, error),
                loading: () => const Progressindicator(),
              )
            ],
          );
        }),
      ),
    );
  }
}
