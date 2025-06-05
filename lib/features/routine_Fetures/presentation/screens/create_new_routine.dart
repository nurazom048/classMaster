// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/export_core.dart';
import '../../../../route/route_constant.dart';
import '../../../home_fetures/data/datasources/routine_api.dart';
import 'package:go_router/go_router.dart';

final createRoutineLoaderProvider = StateProvider<bool>((ref) => false);

class CreateNewRoutine extends StatelessWidget {
  CreateNewRoutine();
  final _routineNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ).copyWith(bottom: 20),
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
                    hint: "Routine name (in short)",
                    labelText: "Enter Routine Short name",
                    validator: (value) => routineNameValidator(value),
                  ),

                  //----------------------------------------------------------------//
                  const Spacer(),

                  Consumer(
                    builder: (context, ref, _) {
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
                    },
                  ),
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

    final createRoutineLoaderNotifier = ref.watch(
      createRoutineLoaderProvider.notifier,
    );

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
          GoRouter.of(context).pushNamed(
            RouteConst.viewRoutine,
            params: {"routineID": data.routineID!},
            extra: data.routineName,
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
    if (value.trim().length > 11) {
      return 'Routine name cannot exceed 11 words';
    }
    return null;
  }
}
