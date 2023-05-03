// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:table/core/dialogs/Alart_dialogs.dart';
import 'package:table/helper/constant/AppColor.dart';
import 'package:table/helper/constant/constant.dart';
import 'package:table/models/class_model.dart';
import 'package:table/ui/bottom_items/Add/request/class_request.dart';
import 'package:table/ui/bottom_items/Add/utils/add_class_validation.dart';
import 'package:table/ui/bottom_items/Add/utils/weekdayUtils.dart';
import 'package:table/ui/bottom_items/Add/widgets/addWeekdayButton.dart';
import 'package:table/ui/bottom_items/Add/widgets/select_priode_number.dart';
import 'package:table/widgets/appWidget/appText.dart';
import 'package:table/widgets/appWidget/buttons/cupertinoButttons.dart';
import 'package:table/widgets/daySelectDropdowen.dart';
import 'package:table/widgets/heder/hederTitle.dart';
import '../../../../models/rutins/class/findClassModel.dart';
import '../../../../widgets/appWidget/TextFromFild.dart';
import '../../Home/full_rutin/controller/weekday_controller.dart';
import '../widgets/wekkday_view.dart';

class AddClassScreen extends StatefulWidget {
  final String routineId;
  final String? routineName;
  final String? classId;
  final bool? isEdit;

  AddClassScreen({
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

                      // weekday
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
                                    child: weekdayView(
                                      weekday: data.weekdays[index],

                                      // delete weekday
                                      onTap: () => _deleteOntap(
                                          data.weekdays[index].id, ref),
                                    ),
                                  ),
                                ),
                              );
                            },
                            error: (error, stackTrace) =>
                                Alart.handleError(context, error),
                            loading: () => const SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: const Text("Loding"),
                                )),
                        AddWeekdayButton(onPressed: () {
                          WeekdayUtils.addWeekday(context, widget.classId);
                        }),
                      ] else
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
                              lenghht: 3,
                              onStartSelacted: (number) {
                                startPeriod = number;
                              },
                              onEndSelacted: (number) {
                                endPeriod = number;
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
  }

  _deleteOntap(String id, WidgetRef ref) {
    print(id);
    ref
        .read(weekayControllerStateProvider(widget.classId ?? '').notifier)
        .deleteWeekday(context, id);
  }
  //
}