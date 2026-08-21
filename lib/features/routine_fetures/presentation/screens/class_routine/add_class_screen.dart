import 'package:classmate/core/widgets/appWidget/text_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';
import 'package:classmate/features/routine_fetures/data/datasources/routine_req.dart';
import 'package:classmate/features/routine_fetures/presentation/providers/routine_details.controller.dart';
import 'package:classmate/features/routine_fetures/presentation/utils/add_class_validation.dart';

import '../../../../../core/component/responsive.dart';
import '../../../../../core/constant/app_color.dart';
import '../../../../../core/widgets/appWidget/app_text.dart';
import '../../../../../core/widgets/appWidget/buttons/cupertino_buttons.dart';
import '../../../../../core/widgets/day_select_dropdowen.dart';
import '../../../../../core/widgets/heder/heder_title.dart';
import '../../../data/models/class_model.dart';
import '../../../data/models/find_class_model.dart';

import '../../widgets/static_widgets/set_schedule_section.dart';

class AddClassScreen extends ConsumerStatefulWidget {
  final String routineId;
  final String? routineName;
  final String? classId;
  final bool? isUpdate;

  const AddClassScreen({
    super.key,
    required this.routineId,
    this.classId,
    this.isUpdate = false,
    this.routineName,
  });

  @override
  ConsumerState<AddClassScreen> createState() => _AddClassScreenState();
}

class _AddClassScreenState extends ConsumerState<AddClassScreen> {
  // Key
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text editing controllers
  final _classNameController = TextEditingController();
  final _instructorController = TextEditingController();
  final _roomController = TextEditingController();
  final _subCodeController = TextEditingController();
  // Schedules list
  List<ClassScheduleItem> _schedules = [];

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate == true) {
      findClass();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return DesktopLayoutWrapper(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFEFF6FF),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      // Header
                      HeaderTitle(widget.routineName ?? '', context),
                      const SizedBox(height: 40),

                      if (widget.isUpdate == true) ...[
                        const AppText("Edit Mode").title(),
                        Text(
                          "Update information",
                          style: TS.heading(fontSize: 24),
                        ),
                      ] else
                        const AppText("Add Class").title(),

                      const SizedBox(height: 20),

                      // Class name
                      AppTextFromField(
                        controller: _classNameController,
                        hint: "Class name",
                        labelText: "Enter class name",
                        validator:
                            (value) => AddClassValidator.className(value),
                      ),

                      // Instructor name
                      AppTextFromField(
                        controller: _instructorController,
                        hint: "Instructor Name",
                        labelText: "Enter Instructor Name",
                        validator:
                            (value) => AddClassValidator.instructorName(value),
                      ),

                      // Subject code
                      AppTextFromField(
                        controller: _subCodeController,
                        keyboardType: TextInputType.number,
                        hint: "Subject Code",
                        labelText: "Enter Subject Code",
                        validator: (value) => AddClassValidator.subCode(value),
                      ),
                      const SizedBox(height: 20),

                      // Set Schedule Section (Redesigned Schedule Architecture)
                      SetScheduleSection(
                        key: ValueKey(_schedules.length),
                        initialSchedules: _schedules,
                        onSchedulesChanged: (updatedSchedules) {
                          setState(() {
                            _schedules = updatedSchedules;
                          });
                        },
                      ),

                      const SizedBox(height: 30),
                      CupertinoButtonCustom(
                        icon: widget.isUpdate == true ? Icons.check : null,
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        text:
                            widget.isUpdate == true
                                ? 'Update Class'
                                : "Create Class",
                        color: AppColor.nokiaBlue,
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            _onTapToButton();
                          } else {
                            Alert.showSnackBar(context, 'Fill the form');
                          }
                        },
                      ),
                      const SizedBox(height: 200),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTapToButton() async {
    if (!mounted) return;

    final repo = ref.read(routineReqProvider);

    if (_schedules.isEmpty) {
      Alert.errorAlertDialog(context, 'Please select at least one schedule day & time');
      return;
    }

    if (widget.isUpdate == true) {
      try {
        await repo.editClass(
          classID: widget.classId ?? "",
          routineID: widget.routineId,
          startTime: _schedules.first.startTime,
          endTime: _schedules.first.endTime,
          classModel: ClasssModel(
            id: '',
            routineId: widget.routineId,
            name: _classNameController.text,
            instructorName: _instructorController.text,
            roomNumber: _schedules.first.roomNumber,
            subjectCode: _subCodeController.text,
          ),
        );
        ref.refresh(routineDetailsProvider(widget.routineId));
        if (context.mounted) {
          Alert.showSnackBar(context, "Class updated successfully");
          Navigator.pop(context);
        }
      } catch (e) {
        if (context.mounted) {
          Alert.handleError(context, e.toString());
        }
      }
    } else {
      try {
        String newClassID = await repo.createClass(
          routineID: widget.routineId,
          classModel: ClasssModel(
            id: '',
            routineId: widget.routineId,
            name: _classNameController.text,
            instructorName: _instructorController.text,
            roomNumber: _schedules.first.roomNumber,
            subjectCode: _subCodeController.text,
            weekday: _schedules.first.day,
          ),
          startTime: _schedules.first.startTime,
          endTime: _schedules.first.endTime,
        );
        ref.refresh(routineDetailsProvider(widget.routineId));
        if (!mounted) return;
        Alert.showSnackBar(context, "Class added successfully");

        Navigator.pop(context);
      } catch (e) {
        if (context.mounted) {
          Alert.handleError(context, e.toString());
        }
      }
    }
  }

  Future<FindClass?> findClass() async {
    print("from find class classId: ${widget.classId}");
    try {
      final repo = ref.read(routineReqProvider);
      FindClass foundClass = await repo.findClass(widget.classId ?? "");

      setState(() {
        _classNameController.text = foundClass.classes.name;
        _instructorController.text = foundClass.classes.instructorName;
        _subCodeController.text = foundClass.classes.subjectCode;
        if (foundClass.schedules.isNotEmpty) {
          _schedules = List.from(foundClass.schedules);
        }
      });
    } catch (e) {
      Alert.handleError(context, e.toString());
    }
    return null;
  }
}
