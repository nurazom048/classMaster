// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/export_core.dart';
import '../../../../../route/route_constant.dart';
import '../../../../account_fetures/domain/providers/account_providers.dart';
import '../../../data/datasources/routine_req.dart';
import '../../providers/routine_details.controller.dart';
import '../../providers/routine_list_provider.dart';

final createRoutineLoaderProvider = StateProvider<bool>((ref) => false);
final selectedRoutineTypeProvider = StateProvider<String>((ref) => "CLASS");
final selectedVisibilityProvider = StateProvider<String>((ref) => "PUBLIC");

class CreateNewRoutine extends ConsumerStatefulWidget {
  final bool isEditMode;
  final String? routineId;
  final String? initialRoutineName;
  final String? initialRoutineType;
  final String? initialVisibility;
  final dynamic initialAbout;

  const CreateNewRoutine({
    super.key,
    this.isEditMode = false,
    this.routineId,
    this.initialRoutineName,
    this.initialRoutineType,
    this.initialVisibility,
    this.initialAbout,
  });

  @override
  ConsumerState<CreateNewRoutine> createState() => _CreateNewRoutineState();
}

class _CreateNewRoutineState extends ConsumerState<CreateNewRoutine> {
  late final TextEditingController _routineNameController;
  late final TextEditingController _aboutController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _routineNameController = TextEditingController(
      text: widget.initialRoutineName ?? '',
    );

    String aboutText = '';
    if (widget.initialAbout != null) {
      if (widget.initialAbout is String) {
        aboutText = widget.initialAbout;
      } else if (widget.initialAbout is Map &&
          widget.initialAbout.containsKey('text')) {
        aboutText = widget.initialAbout['text']?.toString() ?? '';
      } else {
        aboutText = widget.initialAbout.toString();
      }
    }
    _aboutController = TextEditingController(text: aboutText);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialRoutineType != null) {
        ref.read(selectedRoutineTypeProvider.notifier).state =
            widget.initialRoutineType!;
      }
      if (widget.initialVisibility != null) {
        ref.read(selectedVisibilityProvider.notifier).state =
            widget.initialVisibility!;
      }
    });
  }

  @override
  void dispose() {
    _routineNameController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    HeaderTitle(
                      widget.isEditMode ? "Routine" : "Home",
                      context,
                      margin: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 28),
                    AppText(
                      widget.isEditMode
                          ? "Update \nRoutine"
                          : "Create A new \nRoutine",
                    ).title(),
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

                    // 2. Routine Type Selector (Hidden when editing)
                    if (!widget.isEditMode) ...[
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
                                ref
                                    .read(selectedRoutineTypeProvider.notifier)
                                    .state = "CLASS";
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      selectedType == "CLASS"
                                          ? const Color(0xFFEFF6FF)
                                          : const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        selectedType == "CLASS"
                                            ? const Color(0xFF0052CC)
                                            : const Color(0xFFE2E8F0),
                                    width: selectedType == "CLASS" ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.calendar_month_outlined,
                                      color:
                                          selectedType == "CLASS"
                                              ? const Color(0xFF0052CC)
                                              : const Color(0xFF64748B),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Class Routine",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color:
                                            selectedType == "CLASS"
                                                ? const Color(0xFF0052CC)
                                                : const Color(0xFF64748B),
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
                                ref
                                    .read(selectedRoutineTypeProvider.notifier)
                                    .state = "EXAM";
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      selectedType == "EXAM"
                                          ? const Color(0xFFFFF3E0)
                                          : const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        selectedType == "EXAM"
                                            ? const Color(0xFFFF5722)
                                            : const Color(0xFFE2E8F0),
                                    width: selectedType == "EXAM" ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      isAcademy
                                          ? Icons.assignment_outlined
                                          : Icons.lock_outline_rounded,
                                      color:
                                          selectedType == "EXAM"
                                              ? const Color(0xFFFF5722)
                                              : (isAcademy
                                                  ? const Color(0xFF64748B)
                                                  : const Color(0xFF94A3B8)),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Exam Routine",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color:
                                            selectedType == "EXAM"
                                                ? const Color(0xFFFF5722)
                                                : (isAcademy
                                                    ? const Color(0xFF64748B)
                                                    : const Color(0xFF94A3B8)),
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
                    ],

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
                              ref
                                  .read(selectedVisibilityProvider.notifier)
                                  .state = "PUBLIC";
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    selectedVis == "PUBLIC"
                                        ? const Color(0xFFF0FDF4)
                                        : const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      selectedVis == "PUBLIC"
                                          ? const Color(0xFF16A34A)
                                          : const Color(0xFFE2E8F0),
                                  width: selectedVis == "PUBLIC" ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.public,
                                    color:
                                        selectedVis == "PUBLIC"
                                            ? const Color(0xFF16A34A)
                                            : const Color(0xFF64748B),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Public Feed",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color:
                                          selectedVis == "PUBLIC"
                                              ? const Color(0xFF16A34A)
                                              : const Color(0xFF64748B),
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
                              ref
                                  .read(selectedVisibilityProvider.notifier)
                                  .state = "PRIVATE";
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    selectedVis == "PRIVATE"
                                        ? const Color(0xFFF1F5F9)
                                        : const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      selectedVis == "PRIVATE"
                                          ? const Color(0xFF475569)
                                          : const Color(0xFFE2E8F0),
                                  width: selectedVis == "PRIVATE" ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.lock_outline,
                                    color:
                                        selectedVis == "PRIVATE"
                                            ? const Color(0xFF475569)
                                            : const Color(0xFF64748B),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "For Myself",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color:
                                          selectedVis == "PRIVATE"
                                              ? const Color(0xFF475569)
                                              : const Color(0xFF64748B),
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

                    // 4. About Section (Description / Notes / Instructions)
                    const Text(
                      "About Routine",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _aboutController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText:
                            "Add routine details, instructions, links, or syllabus note...",
                        hintStyle: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF94A3B8),
                        ),
                        contentPadding: const EdgeInsets.all(14),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF0052CC),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 36),

                    // 5. Submit Button
                    CupertinoButtonCustom(
                      isLoading: ref.watch(createRoutineLoaderProvider),
                      padding: EdgeInsets.zero,
                      text:
                          widget.isEditMode
                              ? "Update Routine"
                              : "Create Routine",
                      color:
                          selectedType == "EXAM"
                              ? const Color(0xFFFF5722)
                              : AppColor.nokiaBlue,
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

    final createRoutineLoaderNotifier = ref.read(
      createRoutineLoaderProvider.notifier,
    );

    createRoutineLoaderNotifier.state = true;
    final repo = ref.read(routineReqProvider);

    if (widget.isEditMode) {
      if (widget.routineId == null) {
        createRoutineLoaderNotifier.state = false;
        Alert.showSnackBar(context, "Routine ID is missing.");
        return;
      }

      final aboutText = _aboutController.text.trim();
      final res = await repo.updateRoutine(
        routineID: widget.routineId!,
        routineName: _routineNameController.text.trim(),
        about: aboutText.isNotEmpty ? aboutText : null,
      );

      res.fold(
        (error) {
          createRoutineLoaderNotifier.state = false;
          return Alert.errorAlertDialog(context, error.message);
        },
        (data) async {
          ref.invalidate(routineListProvider);
          ref.invalidate(routineDetailsProvider(widget.routineId!));
          await Future.delayed(const Duration(milliseconds: 300));
          createRoutineLoaderNotifier.state = false;
          if (context.mounted) {
            Alert.showSnackBar(
              context,
              data.message.isNotEmpty
                  ? data.message
                  : "Routine updated successfully",
            );
            Navigator.of(context).pop();
          }
        },
      );
    } else {
      if (selectedType == "EXAM" && !isAcademy) {
        createRoutineLoaderNotifier.state = false;
        Alert.showSnackBar(
          context,
          "Only Academy accounts can create Exam routines",
        );
        return;
      }

      print('🚀 [CreateRoutine] User selected routineType: $selectedType');

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
          if (context.mounted) {
            return Alert.showSnackBar(context, data.message);
          }
        },
      );
    }
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
