// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers, avoid_print

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';
import 'package:table/models/class_model.dart';
import 'package:table/ui/bottom_items/Add/request/class_request.dart';
import 'package:table/ui/bottom_items/Add/screens/add_priode.dart';
import 'package:table/ui/bottom_items/Add/utils/add_class_validation.dart';
import 'package:table/ui/bottom_items/Add/widgets/select_priode_number.dart';
import 'package:table/widgets/appWidget/app_text.dart';
import 'package:table/widgets/day_select_dropdowen.dart';

import 'package:table/widgets/heder/heder_title.dart';
import '../../../../constant/app_color.dart';
import '../../../../constant/constant.dart';
import '../../../../models/rutins/class/find_class_model.dart';
import '../../../../widgets/appWidget/TextFromFild.dart';
import '../../../../widgets/appWidget/buttons/cupertino_butttons.dart';
import '../../Home/full_rutin/screen/viewMore/class_list.dart';
import '../widgets/show_wekday_widgets.dart';

class AddClassScreen extends StatefulWidget {
  final String routineId;
  final String? routineName;
  final String? classId;
  final bool? isEdit;

  const AddClassScreen({super.key, 
    required this.routineId,
    this.classId,
    this.isEdit = false,
    this.routineName,
  });

  @override
  State<AddClassScreen> createState() => _AddClassScreenState();
}

class _AddClassScreenState extends State<AddClassScreen> {
  // Text editing controllers
  final _classNameController = TextEditingController();
  final _instructorController = TextEditingController();
  final _roomController = TextEditingController();
  final _subCodeController = TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Default start and end times
  late DateTime startTime = DateTime.now();
  late DateTime endTime = DateTime.now().add(const Duration(minutes: 30));

  //.. just for ui
  late DateTime startTimeDemo = DateTime.now();
  late DateTime endTimeDemo = DateTime.now();

  // Selected day of the week
  int _selectedDay = 1;

  // Start and end time variables
  DateTime? st;
  DateTime? et;

  // Start and end period variables
  int startPeriod = 1;
  int endPeriod = 1;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit == true) {
      findClass();
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.routineId);
    return Consumer(builder: (context, ref, _) {
      return Scaffold(
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

                      widget.isEdit == true
                          ? const AppText("Edit Class").title()
                          : const AppText("Add Class").title(),
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
                        hint: "Subject Code",
                        labelText: "Enter Subject Code",
                        validator: (value) => AddClassValidator.subCode(value),
                      ),
                      const SizedBox(height: 20),

                      //! weekday list when eddit
                      if (widget.isEdit == true && widget.classId != null)
                        ShowWeekdayWidgets(classId: widget.classId!)
                      else
                        Column(
                          children: [
                            DayDropdown(
                              labelText: "Tap Here",
                              onPressed: () {},
                              onChanged: (selectedDay) {
                                _selectedDay = selectedDay;
                              },
                            ),

                            ///.... room number
                            const SizedBox(height: 30),

                            PeriodNumberSelector(
                              hint: " Select Start Period",
                              subhit: " Select End Period",
                              lenghht: ref.read(totalPriodeCountProvider),
                              onStartSelacted: (number) {
                                startPeriod = number;
                              },
                              onEndSelacted: (number) {
                                endPeriod = number;
                              },
                              ontapToadd: () {
                                Get.to(
                                    AppPriodePage(
                                        rutinId: widget.routineId,
                                        totalPriode:
                                            ref.read(totalPriodeCountProvider)),
                                    transition: Transition.rightToLeft);
                              },
                            ),

                            //
                            AppTextFromField(
                              controller: _roomController,
                              hint: "Classroom Number",
                              labelText: "EnterClassroom Number in this day",
                              validator: (value) =>
                                  AddClassValidator.roomNumber(value),
                            ),
                          ],
                        ),
                      const SizedBox(height: 30),
                      CupertinoButtonCustom(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        textt: widget.isEdit == true
                            ? "Eddit Class"
                            : "Create Class",
                        color: AppColor.nokiaBlue,
                        onPressed: () async {
                          print("object");
                          if (_formKey.currentState!.validate()) {
                            _onTapToButton(ref);
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

  void _onTapToButton(WidgetRef ref) {
    print("ontap");
    widget.isEdit == true
        ? ClassRequest().editClass(
            context,
            ref,
            widget.classId ?? "",
            widget.routineId,
            ClassModel(
              className: _classNameController.text,
              instructorName: _instructorController.text,
              roomNumber: _roomController.text,
              subjectCode: _subCodeController.text,
              startingPeriod: startPeriod,
              endingPeriod: endPeriod,
              weekday: _selectedDay,
              startTime: startTime,
              endTime: startTime,
            ))
        : ClassRequest.addClass(
            ref,
            widget.routineId,
            context,
            ClassModel(
              className: _classNameController.text,
              instructorName: _instructorController.text,
              roomNumber: _roomController.text,
              subjectCode: _subCodeController.text,
              startingPeriod: startPeriod,
              endingPeriod: endPeriod,
              weekday: _selectedDay,
              startTime: startTime,
              endTime: startTime,
            ));
  }

  //
  // find class
  Future<FindClass?> findClass() async {
    print("classId: ${widget.classId}");
    Uri uri = Uri.parse('${Const.BASE_URl}/class/find/class/${widget.classId}');
    try {
      final response = await http.get(uri);

      //.. responce
      if (response.statusCode == 200) {
        print(response.body);
        FindClass foundClass = FindClass.fromJson(json.decode(response.body));

        //
        setState(() {
          _classNameController.text = foundClass.classs.name;
          _instructorController.text = foundClass.classs.instuctorName;
          _subCodeController.text = foundClass.classs.subjectcode;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      Alart.handleError(context, e.toString());
    }
    return null;
  }

  //
}
