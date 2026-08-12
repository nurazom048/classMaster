// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../../core/export_core.dart';
import '../../../../../route/route_constant.dart';
import 'package:go_router/go_router.dart';

import '../../../data/datasources/routine_req.dart';
import '../../providers/routine_list_provider.dart';
import '../../providers/routine_details.controller.dart';
import '../../../../account_fetures/domain/providers/account_providers.dart';

final createRoutineLoaderProvider = StateProvider<bool>((ref) => false);
final selectedRoutineTypeProvider = StateProvider<String>((ref) => "CLASS");
final selectedVisibilityProvider = StateProvider<String>((ref) => "PUBLIC");

class CreateNewRoutine extends ConsumerWidget {
  CreateNewRoutine({super.key});
  final _routineNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(selectedRoutineTypeProvider);
    final selectedVis = ref.watch(selectedVisibilityProvider);

    final accountData = ref.watch(accountDataProvider(null));
    final userAccount = accountData.value?.fold((l) => null, (r) => r);
    final isAcademy = userAccount?.accountType?.toLowerCase() == "academy";

    return DesktopLayoutWrapper(
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ).copyWith(bottom: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderTitle("Home", context, margin: EdgeInsets.zero),
                    const SizedBox(height: 28),
                    const AppText("Create A new \nRoutine").title(),
                    const SizedBox(height: 28),

                    // 1. Routine Name Input
                    AppTextFromField(
                      margin: EdgeInsets.zero,
                      controller: _routineNameController,
                      hint: "Enter routine name (max 150 chars)",
                      labelText: "Routine Name",
                      validator: (value) => routineNameValidator(value),
                    ),

                    const SizedBox(height: 24),

                    // 2. Routine Type Selector (Class vs Exam)
                    const Text(
                      "Routine Type",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        // Class Routine Chip
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              ref.read(selectedRoutineTypeProvider.notifier).state = "CLASS";
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                              decoration: BoxDecoration(
                                color: selectedType == "CLASS" ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selectedType == "CLASS" ? const Color(0xFF0052CC) : const Color(0xFFE2E8F0),
                                  width: selectedType == "CLASS" ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    color: selectedType == "CLASS" ? const Color(0xFF0052CC) : const Color(0xFF64748B),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Class Routine",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: selectedType == "CLASS" ? const Color(0xFF0052CC) : const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Exam Routine Chip (Locked for non-Academy users)
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (!isAcademy) {
                                Alert.showSnackBar(
                                  context,
                                  "Only Academy accounts can create Exam routines",
                                );
                                return;
                              }
                              ref.read(selectedRoutineTypeProvider.notifier).state = "EXAM";
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                              decoration: BoxDecoration(
                                color: selectedType == "EXAM" ? const Color(0xFFFFF3E0) : const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selectedType == "EXAM" ? const Color(0xFFFF5722) : const Color(0xFFE2E8F0),
                                  width: selectedType == "EXAM" ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    isAcademy ? Icons.assignment_outlined : Icons.lock_outline_rounded,
                                    color: selectedType == "EXAM"
                                        ? const Color(0xFFFF5722)
                                        : (isAcademy ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Exam Routine",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: selectedType == "EXAM"
                                          ? const Color(0xFFFF5722)
                                          : (isAcademy ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // 3. Visibility Selector (Public Feed vs For Myself)
                    const Text(
                      "Visibility",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        // Public Chip
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              ref.read(selectedVisibilityProvider.notifier).state = "PUBLIC";
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                              decoration: BoxDecoration(
                                color: selectedVis == "PUBLIC" ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selectedVis == "PUBLIC" ? const Color(0xFF16A34A) : const Color(0xFFE2E8F0),
                                  width: selectedVis == "PUBLIC" ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.public,
                                    color: selectedVis == "PUBLIC" ? const Color(0xFF16A34A) : const Color(0xFF64748B),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Public Feed",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: selectedVis == "PUBLIC" ? const Color(0xFF16A34A) : const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Private Chip (For Myself)
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              ref.read(selectedVisibilityProvider.notifier).state = "PRIVATE";
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                              decoration: BoxDecoration(
                                color: selectedVis == "PRIVATE" ? const Color(0xFFF1F5F9) : const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selectedVis == "PRIVATE" ? const Color(0xFF475569) : const Color(0xFFE2E8F0),
                                  width: selectedVis == "PRIVATE" ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.lock_outline,
                                    color: selectedVis == "PRIVATE" ? const Color(0xFF475569) : const Color(0xFF64748B),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "For Myself",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: selectedVis == "PRIVATE" ? const Color(0xFF475569) : const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Submit Button
                    CupertinoButtonCustom(
                      isLoading: ref.watch(createRoutineLoaderProvider),
                      padding: EdgeInsets.zero,
                      text: "Create Routine",
                      color: selectedType == "EXAM" ? const Color(0xFFFF5722) : AppColor.nokiaBlue,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _onTapToButton(context, ref);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapToButton(BuildContext context, WidgetRef ref) async {
    final selectedType = ref.read(selectedRoutineTypeProvider);
    final accountData = ref.read(accountDataProvider(null));
    final userAccount = accountData.value?.fold((l) => null, (r) => r);
    final isAcademy = userAccount?.accountType?.toLowerCase() == "academy";

    if (selectedType == "EXAM" && !isAcademy) {
      Alert.showSnackBar(context, "Only Academy accounts can create Exam routines");
      return;
    }

    print('🚀 [CreateRoutine] User selected routineType: $selectedType');

    final createRoutineLoaderNotifier = ref.read(
      createRoutineLoaderProvider.notifier,
    );

    createRoutineLoaderNotifier.state = true;

    final repo = ref.read(routineReqProvider);
    final res = await repo.createRoutine(
      routineName: _routineNameController.text.trim(),
      routineType: selectedType,
    );

    res.fold(
      (error) {
        createRoutineLoaderNotifier.state = false;
        return Alert.errorAlertDialog(context, error.message);
      },
      (data) async {
        ref.read(selectedRoutineTypeProvider.notifier).state = "CLASS";
        if (data.routineID != null) {
          ref.invalidate(routineListProvider);
          ref.invalidate(routineDetailsProvider(data.routineID!));
          await Future.delayed(const Duration(milliseconds: 300));
          createRoutineLoaderNotifier.state = false;
          if (context.mounted) {
            context.pushNamed(
              RouteConst.viewRoutine,
              params: {"routineID": data.routineID!},
              extra: data.routineName,
            );
          }
        } else {
          createRoutineLoaderNotifier.state = false;
        }
        if (context.mounted) return Alert.showSnackBar(context, data.message);
      },
    );
  }

  static String? routineNameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Routine name is required';
    }
    if (value.trim().length > 150) {
      return 'Routine name cannot exceed 150 characters';
    }
    return null;
  }
}
