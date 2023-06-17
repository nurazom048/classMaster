import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:table/core/component/loaders.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';
import 'package:table/models/message_model.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/screen/viewMore/view_more_screen.dart';
import 'package:table/ui/bottom_items/Home/home_req/rutin_req.dart';
import 'package:table/widgets/appWidget/app_text.dart';
import 'package:table/widgets/appWidget/buttons/cupertino_butttons.dart';
import 'package:table/widgets/heder/heder_title.dart';
import '../../../../constant/app_color.dart';
import '../../../../widgets/appWidget/TextFromFild.dart';

final createRoutineLoaderProvider = StateProvider<bool>((ref) => false);

class CreaeNewRutine extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  CreaeNewRutine({Key? key});
  final _rutineNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20)
              .copyWith(bottom: 20),
          child: Form(
            key: _formKey,
            child: Container(
              height: h, // Set the height explicitly
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderTitle("Home", context, margin: EdgeInsets.zero),
                  const SizedBox(height: 40),
                  const AppText("Create A new \nRoutine").title(),
                  const SizedBox(height: 40),

                  //----------------------------------------------------------------//
                  AppTextFromField(
                    margin: EdgeInsets.zero,
                    controller: _rutineNameController,
                    hint: "Routine name",
                    labelText: "Enter class name",
                    validator: (value) => rutinNameValidator(value),
                  ),

                  //----------------------------------------------------------------//
                  const Spacer(),

                  Consumer(builder: (context, ref, _) {
                    final isLoading = ref.watch(createRoutineLoaderProvider);

                    if (isLoading == true) {
                      return Loaders.button();
                    } else {
                      return CupertinoButtonCustom(
                        padding: EdgeInsets.zero,
                        textt: "Create Routine",
                        color: AppColor.nokiaBlue,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _onTapToButton(context, ref);
                          }
                        },
                      );
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapToButton(context, WidgetRef ref) async {
    Either<Message, Message> res = await RutinReqest.creatRutin(
      rutinName: _rutineNameController.text,
    );

    final createRoutineLoderNotifier =
        ref.watch(createRoutineLoaderProvider.notifier);

    //
    createRoutineLoderNotifier.update((state) => true);

    //
    res.fold(
      (error) {
        createRoutineLoderNotifier.update((state) => false);

        return Alart.errorAlartDilog(context, error.message);
      },
      (data) async {
        if (data.routineID != null) {
          await Future.delayed(const Duration(seconds: 5));
          createRoutineLoderNotifier.update((state) => false);
          // Wait for 5 seconds
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ViewMore(
                rutinId: data.routineID!,
                rutineName: data.routineName ?? 'Routine Name',
                owenerName: data.owenerName ?? 'Owner Name',
              ),
            ),
          );
        }
        return Alart.showSnackBar(context, data.message);
      },
    );
  }

  static String? rutinNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Routine name is required';
    }
    return null;
  }
}
