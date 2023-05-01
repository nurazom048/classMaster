// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'dart:convert';
//import 'package:flutter_svg/svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:table/core/dialogs/Alart_dialogs.dart';
import 'package:table/helper/constant/AppColor.dart';
import 'package:table/helper/constant/constant.dart';
import 'package:table/models/class_model.dart';
import 'package:table/ui/bottom_items/Add/request/class_request.dart';
import 'package:table/ui/bottom_items/Add/utils/add_class_validation.dart';
import 'package:table/ui/bottom_items/Add/widgets/addWeekdayButton.dart';
import 'package:table/ui/bottom_items/Add/widgets/expanded_weekday.dart';
import 'package:table/ui/bottom_items/Add/widgets/select_priode_number.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/request/weekday_req.dart';
import 'package:table/widgets/appWidget/appText.dart';
import 'package:table/widgets/appWidget/buttons/cupertinoButttons.dart';
import 'package:table/widgets/appWidget/dottted_divider.dart';
import 'package:table/widgets/daySelectDropdowen.dart';
import 'package:table/widgets/heder/hederTitle.dart';
import '../../../../models/messageModel.dart';
import '../../../../models/rutins/class/findClassModel.dart';
import '../../../../widgets/appWidget/TextFromFild.dart';
import '../../Home/full_rutin/controller/weekday_controller.dart';

class AddClassSceen extends StatefulWidget {
  final String rutinId;
  final String? rutinName;
  final String? classId;
  final bool? isEdit;
  AddClassSceen({
    super.key,
    required this.rutinId,
    this.classId,
    this.isEdit = false,
    this.rutinName,
  });

  @override
  State<AddClassSceen> createState() => _AddClassSceenState();
}

class _AddClassSceenState extends State<AddClassSceen> {
  //
  final _className = TextEditingController();
  final _instructorController = TextEditingController();
  final _roomController = TextEditingController();
  final _subCodeController = TextEditingController();
  final _startPeriodController = TextEditingController();
  final _endPeriodController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late DateTime startTime = DateTime.now();
  late DateTime endTime = DateTime.now().add(const Duration(minutes: 30));

  bool show = false;

  //.. just for ui
  late DateTime startTimeDemo = DateTime.now();
  late DateTime endTimDemo = DateTime.now();

  int _selectedDay = 1;
  DateTime? st;
  DateTime? et;
  //
  // List<Weekday>? weekdays;

  int startPriode = 1;
  int endPriode = 1;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit == true) {
      findClass();
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.rutinId);
    return Consumer(builder: (context, ref, _) {
      //! provider
      var weekdayListProvider =
          ref.watch(weekayControllerStateProvider(widget.classId ?? ''));
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
                      HeaderTitle(widget.rutinName ?? '', context),
                      const SizedBox(height: 40),
                      widget.isEdit == true
                          ? const AppText("Eddit Class   ").title()
                          : const AppText("Add Class ").title(),
                      const SizedBox(height: 20),
                      AppTextFromField(
                        controller: _className,
                        hint: "Class name",
                        labelText: "Enter class name",
                        validator: (value) =>
                            AddClassValidator.className(value),
                      ),
                      AppTextFromField(
                        controller: _instructorController,
                        hint: "Instructor Name",
                        labelText: "Enter Instructor Name",
                        validator: (value) =>
                            AddClassValidator.instructorName(value),
                      ),
                      AppTextFromField(
                        controller: _subCodeController,
                        hint: "Subject Name",
                        labelText: "Subject Name",
                        validator: (value) => AddClassValidator.subCode(value),
                      ),
                      const SizedBox(height: 20),
                      if (widget.isEdit == true) ...[
                        weekdayListProvider.when(
                            data: (data) {
                              if (data == null) {}
                              return Column(
                                children: List.generate(
                                  data.weekdays.length,
                                  (index) => Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: ExpanedWeekDay(
                                      weekday: data.weekdays[index],
                                      roomController: _roomController,
                                    ),
                                  ),
                                ),
                              );
                            },
                            error: (error, stackTrace) =>
                                Alart.handleError(context, error),
                            loading: () => Container(
                                  height: 100,
                                  width: 100,
                                  child: Text("Loding"),
                                )),

                        // Column(
                        //   children: List.generate(
                        //     weekdays?.length ?? 0,
                        //     (index) => Container(
                        //       margin: const EdgeInsets.symmetric(vertical: 5),
                        //       child: ExpanedWeekDay(
                        //         weekday: weekdays?[index],
                        //         roomController: _roomController,
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        AddWeekdayButton(onPressed: () {
                          _showAddWeekdayModal(context, widget.classId);
                        }),
                      ] else
                        Column(
                          children: [
                            DayDropdown(
                                labelText: "labelText",
                                onPressed: () {},
                                onChanged: (selectedDay) {
                                  print(selectedDay);
                                }),

                            ///.... room number

                            const SizedBox(height: 30),

                            //
                            PeriodNumberSelector(
                              hint: " Select Start Period",
                              subhit: " Select End Period",
                              lenghht: 3,
                              onStartSelacted: (number) {
                                startPriode = number;
                              },
                              onEndSelacted: (number) {
                                endPriode = number;
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
                        textt: "Create Class",
                        color: AppColor.nokiaBlue,
                        onPressed: () async {
                          print("object");
                          if (_formKey.currentState!.validate()) {
                            _onTapToButton();
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

  void _onTapToButton() {
    print("ontap");
    widget.isEdit == true
        ? ClassRequest().editClass(
            context,
            widget.classId ?? "",
            ClassModel(
              className: _className.text,
              instructorName: _instructorController.text,
              roomNumber: _roomController.text,
              subjectCode: _subCodeController.text,
              startingPeriod: startPriode,
              endingPeriod: endPriode,
              weekday: _selectedDay,
              startTime: startTime,
              endTime: startTime,
            ))
        : ClassRequest.addClass(
            widget.rutinId,
            context,
            ClassModel(
              className: _className.text,
              instructorName: _instructorController.text,
              roomNumber: _roomController.text,
              subjectCode: _subCodeController.text,
              startingPeriod: int.parse(_startPeriodController.text),
              endingPeriod: int.parse(_endPeriodController.text),
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

        _className.text = foundClass.classs.name;
        _instructorController.text = foundClass.classs.instuctorName;
        _roomController.text = foundClass.classs.room;
        _subCodeController.text = foundClass.classs.subjectCode;

        //
        setState(() {
          show = true;

          // print(json.decode(response.body));
          // weekdays = foundClass.weekdays;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      Alart.handleError(context, e.toString());
    }
  }

  //

  void _showAddWeekdayModal(BuildContext context, classId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          int _start = 1;
          int _end = 1;
          int? _number;
          final _roomCon = TextEditingController();
          final _weekdayFromKey = GlobalKey<FormState>();

          return AlertDialog(
            content: SingleChildScrollView(
              child: Form(
                key: _weekdayFromKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DayDropdown(
                        labelText: "select day",
                        onPressed: () {},
                        onChanged: (selectedDay) {
                          _number = selectedDay;
                        }),
                    const SizedBox(height: 5),
                    PeriodNumberSelector(
                      hint: " Select Start Period",
                      subhit: " Select End Period",
                      lenghht: 3,
                      onStartSelacted: (number) {
                        _start = number;
                      },
                      onEndSelacted: (number) {
                        _end = number;
                      },
                    ),
                    AppTextFromField(
                      controller: _roomCon,
                      hint: "Classroom Number",
                      labelText: "EnterClassroom Number in this day",
                      validator: (value) => AddClassValidator.roomNumber(value),
                    ),
                    const SizedBox(height: 30),
                    CupertinoButtonCustom(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      textt: "Add Weekday",
                      widget: const Text(
                        "Add Weekday",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      color: AppColor.nokiaBlue,
                      onPressed: () async {
                        print("object");
                        if (_weekdayFromKey.currentState!.validate() &&
                            _number != null) {
                          print("validate");
                          Message _res = await WeekdaRequest.addWeekday(
                              classId,
                              _number.toString(),
                              _start.toString(),
                              _end.toString());

                          Alart.showSnackBar(context, _res.message);
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
