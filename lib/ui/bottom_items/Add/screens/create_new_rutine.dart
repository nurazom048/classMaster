import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:table/core/component/loaders.dart';
import 'package:table/core/dialogs/alert_dialogs.dart';
import 'package:table/models/message_model.dart';
import 'package:table/ui/bottom_items/Home/Full_routine/screen/viewMore/view_more_screen.dart';
import 'package:table/ui/bottom_items/Home/home_req/routine_api.dart';
import 'package:table/widgets/appWidget/app_text.dart';
import 'package:table/widgets/appWidget/buttons/cupertino_buttons.dart';
import 'package:table/widgets/heder/heder_title.dart';
import '../../../../constant/app_color.dart';
import '../../../../widgets/appWidget/TextFromFild.dart';

final createRoutineLoaderProvider = StateProvider<bool>((ref) => false);

class CreateNewRoutine extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  CreateNewRoutine({Key? key});
  final _routineNameController = TextEditingController();
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
            child: SizedBox(
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
                    controller: _routineNameController,
                    hint: "Routine name",
                    labelText: "Enter class name",
                    validator: (value) => routineNameValidator(value),
                  ),

                  //----------------------------------------------------------------//
                  const Spacer(),

                  Consumer(builder: (context, ref, _) {
                    final isLoading = ref.watch(createRoutineLoaderProvider);

                    return CupertinoButtonCustom(
                      isLoading: isLoading,
                      padding: EdgeInsets.zero,
                      text: "Create Routine",
                      color: AppColor.nokiaBlue,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _onTapToButton(context, ref);
                        }
                      },
                    );
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
    Either<Message, Message> res = await RoutineAPI.createNewRoutine(
      routineName: _routineNameController.text,
    );

    final createRoutineLoaderNotifier =
        ref.watch(createRoutineLoaderProvider.notifier);

    //
    createRoutineLoaderNotifier.update((state) => true);

    //
    res.fold(
      (error) {
        createRoutineLoaderNotifier.update((state) => false);

        return Alert.errorAlertDialog(context, error.message);
      },
      (data) async {
        if (data.routineID != null) {
          await Future.delayed(const Duration(seconds: 2));
          createRoutineLoaderNotifier.update((state) => false);
          // Wait for 5 seconds
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ViewMore(
                routineId: data.routineID!,
                routineName: data.routineName ?? 'Routine Name',
                ownerName: data.ownerName ?? 'Owner Name',
              ),
            ),
          );
        }
        return Alert.showSnackBar(context, data.message);
      },
    );
  }

  static String? routineNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Routine name is required';
    }
    if (value.trim().length > 10) {
      return 'Routine name cannot exceed 10 words';
    }
    return null;
  }
}
