import 'dart:convert';
import 'package:classmate/ui/bottom_items/Home/Full_routine/widgets/select_time.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';
import 'package:classmate/models/class_model.dart';
import 'package:classmate/ui/bottom_items/Add/request/class_request.dart';
import 'package:classmate/ui/bottom_items/Add/utils/add_class_validation.dart';
import 'package:classmate/widgets/appWidget/app_text.dart';
import 'package:classmate/widgets/day_select_dropdowen.dart';

import 'package:classmate/widgets/heder/heder_title.dart';
import '../../../../constant/app_color.dart';
import '../../../../constant/constant.dart';
import '../../../../models/Routine/class/find_class_model.dart';
import '../../../../widgets/appWidget/TextFromFild.dart';
import '../../../../widgets/appWidget/buttons/cupertino_buttons.dart';
import '../widgets/show_weekday_widgets.dart';

class AddClassScreen extends StatefulWidget {
  final String routineId;
  final String? routineName;
  final String? classId;
  final bool? isEdit;
  final bool? isUpdate;

  const AddClassScreen({
    super.key,
    required this.routineId,
    this.classId,
    this.isEdit = false,
    this.isUpdate = false,
    this.routineName,
  });

  @override
  State<AddClassScreen> createState() => _AddClassScreenState();
}

class _AddClassScreenState extends State<AddClassScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool showStartTime = false;
  bool showEndTime = false;
  DateTime? st;
  DateTime? et;

  // Text editing controllers
  final _classNameController = TextEditingController();
  final _instructorController = TextEditingController();
  final _roomController = TextEditingController();
  final _subCodeController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Default start and end times
  late DateTime startTime = DateTime.now();
  late DateTime endTime = DateTime.now().add(const Duration(minutes: 30));

  // Selected day of the week
  int? _selectedDay;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit == true || widget.isUpdate == true) {
      findClass();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    print(widget.routineId);
    return Consumer(builder: (context, ref, _) {
      return Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFEFF6FF),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      // Header
                      HeaderTitle(widget.routineName ?? '', context),
                      const SizedBox(height: 40),

                      if (widget.isEdit == true)
                        const AppText("Edit Class").title()
                      else if (widget.isUpdate == true)
                        const AppText("Update Class").title()
                      else
                        const AppText("Add Class").title(),

                      const SizedBox(height: 20),

                      // Class name
                      AppTextFromField(
                        controller: _classNameController,
                        hint: "Class name",
                        labelText: "Enter class name",
                        validator: (value) =>
                            AddClassValidator.className(value),
                      ),

                      // Instructor name
                      AppTextFromField(
                        controller: _instructorController,
                        hint: "Instructor Name",
                        labelText: "Enter Instructor Name",
                        validator: (value) =>
                            AddClassValidator.instructorName(value),
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

                      if (widget.isUpdate == true && widget.classId != null)
                        ShowWeekdayWidgets(classId: widget.classId!)
                      else if (widget.isEdit == true && widget.classId != null)
                        ShowWeekdayWidgets(classId: widget.classId!)
                      else
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          height: 480,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DayDropdown(
                                labelText: "Tap Here",
                                onPressed: () {},
                                onChanged: (selectedDay) {
                                  _selectedDay = selectedDay;
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 20)
                                    .copyWith(bottom: 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Header
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SelectTime(
                                          width: size.width * 0.40,
                                          timeText: 'Start Time',
                                          time: startTime,
                                          show: showStartTime,
                                          onTap: () {
                                            _selectStartTime(
                                                _scaffoldKey.currentContext ??
                                                    context);
                                          },
                                        ),
                                        SelectTime(
                                          width: size.width * 0.40,
                                          timeText: 'End Time',
                                          time: endTime,
                                          show: showEndTime,
                                          onTap: () => _selectEndTime(
                                              _scaffoldKey.currentContext ??
                                                  context),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              AppTextFromField(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 22)
                                        .copyWith(top: 0),
                                controller: _roomController,
                                hint: "Classroom Number",
                                labelText: "Enter Classroom Number in this day",
                                validator: (value) =>
                                    AddClassValidator.roomNumber(value),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 30),
                      CupertinoButtonCustom(
                        icon: widget.isUpdate == true ? Icons.check : null,
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        text: widget.isUpdate == true
                            ? 'Update Class'
                            : widget.isEdit == true
                                ? "Edit Class"
                                : "Create Class",
                        color: AppColor.nokiaBlue,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _onTapToButton(ref);
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
      );
    });
  }

  void _onTapToButton(WidgetRef ref) async {
    if (!mounted) return;

    if (widget.isEdit == true || widget.isUpdate == true) {
      ClassRequest().editClass(
          context,
          ref,
          widget.classId ?? "",
          widget.routineId,
          startTime,
          endTime,
          ClassModel(
            className: _classNameController.text,
            instructorName: _instructorController.text,
            roomNumber: _roomController.text,
            subjectCode: _subCodeController.text,
            weekday: _selectedDay!,
            startTime: startTime,
            endTime: endTime,
          ));
    } else {
      if (_selectedDay == null) {
        Alert.errorAlertDialog(context, 'Select day');
      } else {
        String? newclassID = await ClassRequest.addClass(
          ref,
          widget.routineId,
          context,
          ClassModel(
            className: _classNameController.text,
            instructorName: _instructorController.text,
            roomNumber: _roomController.text,
            subjectCode: _subCodeController.text,
            weekday: _selectedDay!,
            startTime: startTime,
            endTime: endTime,
          ),
          endTime,
          startTime,
        );

        if (newclassID == null) {
          Alert.showSnackBar(context, 'Something went wrong');
        } else {
          if (!mounted) return;

          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                  )),
                  child: AddClassScreen(
                    routineId: widget.routineId,
                    classId: newclassID,
                    isUpdate: true,
                  ),
                );
              },
            ),
          );
        }
      }
    }
  }

  Future<FindClass?> findClass() async {
    print("classId: ${widget.classId}");
    Uri uri = Uri.parse('${Const.BASE_URl}/class/find/class/${widget.classId}');
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        FindClass foundClass = FindClass.fromJson(json.decode(response.body));
        setState(() {
          _classNameController.text = foundClass.classes.name;
          _instructorController.text = foundClass.classes.instuctorName;
          _subCodeController.text = foundClass.classes.subjectcode;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      Alert.handleError(context, e.toString());
    }
    return null;
  }

  void _selectStartTime(context) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(startTime),
    ).then((value) {
      if (value != null) {
        setState(() {
          showStartTime = true;
          startTime = DateTime(startTime.year, startTime.month, startTime.day,
              value.hour, value.minute);
        });
      }
    });
  }

  void _selectEndTime(context) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(endTime),
    ).then((value) {
      if (value != null) {
        DateTime selectedEndTime = DateTime(
            endTime.year, endTime.month, endTime.day, value.hour, value.minute);

        if (selectedEndTime.isAfter(startTime)) {
          setState(() {
            showEndTime = true;
            endTime = selectedEndTime;
          });
        } else {
          Alert.showSnackBar(context, 'End time must be after start time');
        }
      }
    });
  }
}
