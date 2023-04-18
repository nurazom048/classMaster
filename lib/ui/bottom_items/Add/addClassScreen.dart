// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/gestures.dart';
//import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/ui/bottom_items/Add/request/class_request.dart';
import 'package:table/ui/bottom_items/Add/utils/add_class_validation.dart';
import 'package:table/widgets/appWidget/appText.dart';
import 'package:table/widgets/text%20and%20buttons/mytext.dart';
import '../../../core/dialogs/Alart_dialogs.dart';
import '../../../helper/constant/AppColor.dart';
import '../../../helper/constant/constant.dart';
import '../../../models/class_model.dart';
import '../../../widgets/appWidget/TextFromFild.dart';
import '../../../widgets/appWidget/buttons/cupertinoButttons.dart';
import '../../../widgets/daySelectDropdowen.dart';
import '../../../widgets/heder/hederTitle.dart';

class AddClassSceen extends StatefulWidget {
  final String rutinId;
  final String? rutinName;
  final String? classId;
  final bool? isEdit;
  const AddClassSceen(
      {super.key,
      required this.rutinId,
      this.classId,
      this.isEdit = false,
      this.rutinName});

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
  late DateTime endTime = DateTime.now().add(Duration(minutes: 30));

  bool show = false;

  //.. just for ui
  late DateTime startTimeDemo = DateTime.now();
  late DateTime endTimDemo = DateTime.now();

  int _selectedDay = 1;
  DateTime? st;
  DateTime? et;
  //

  @override
  void initState() {
    super.initState();
    if (widget.isEdit == true) {
      findClass();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FF),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            primary: true,
            // physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              HeaderTitle(widget.rutinName ?? '', context),
              SizedBox(height: 40),

              const AppText("  Add Class").title(),

              AppTextFromField(
                controller: _className,
                hint: "Class name",
                labelText: "Enter class name",
                validator: (value) => AddClassValidator.className(value),
              ),
              AppTextFromField(
                controller: _instructorController,
                hint: "Instructor Name",
                labelText: "Enter Instructor Name",
                validator: (value) => AddClassValidator.instructorName(value),
              ),

              AppTextFromField(
                controller: _subCodeController,
                hint: "Subject Name",
                labelText: "Subject Name",
                validator: (value) => AddClassValidator.subCode(value),
              ),

              DayDropdown(
                  labelText: "labelText",
                  onPressed: () {},
                  onChanged: (selected_day) {
                    print(selected_day);
                  }),

              ///.... room number
              AppTextFromField(
                controller: _instructorController,
                hint: "Classroom Number",
                labelText: "EnterClassroom Number in this day",
                validator: (value) => AddClassValidator.roomNumber(value),
              ),
              AppTextFromField(
                controller: _instructorController,
                hint: "Classroom Number",
                labelText: "EnterClassroom Number in this day",
                validator: (value) => AddClassValidator.roomNumber(value),
              ),

              const MyText("Start and end Time"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.2,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      controller: _startPeriodController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(
                            color: Colors.black12,
                          ),
                        ),
                        hintText: "Start period",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Start period cannot be empty";
                        } else if (int.tryParse(value) == null ||
                            int.parse(value) <= 0) {
                          return "Start period must be a positive integer";
                        } else {
                          int start = int.parse(value);
                          int end =
                              int.tryParse(_endPeriodController.text) ?? 0;
                          if (start > end) {
                            return "Start period must be less than end period";
                          }
                          return null;
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.2,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      controller: _endPeriodController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(
                            color: Colors.black12,
                          ),
                        ),
                        hintText: "End period",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "End period cannot be empty";
                        } else if (int.tryParse(value) == null ||
                            int.parse(value) <= 0) {
                          return "End period must be a positive integer";
                        } else {
                          int start =
                              int.tryParse(_startPeriodController.text) ?? 0;
                          int end = int.parse(value);
                          if (start > end) {
                            return "End period must be greater than start period";
                          }
                          return null;
                        }
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              CupertinoButtonCustom(
                textt: "Create Class",
                color: AppColor.nokiaBlue,
                onPressed: () async {
                  if (_formKey.currentState!.validate() &&
                      st != null &&
                      et != null) {
                    _onTapToButton();
                  }
                },
              ),
              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }

  void _onTapToButton() {
    widget.isEdit == true
        ? ClassRequest().editClass(
            context,
            widget.classId ?? "",
            ClassModel(
              className: _className.text,
              instructorName: _instructorController.text,
              roomNumber: _roomController.text,
              subjectCode: _subCodeController.text,
              startingPeriod: int.parse(_startPeriodController.text),
              endingPeriod: int.parse(_endPeriodController.text),
              weekday: _selectedDay,
              startTime: st!,
              endTime: et!,
            ))
        : ClassRequest().addClass(
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
              startTime: st!,
              endTime: et!,
            ));
  }

  //
  // find class
  Future<void> findClass() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    try {
      final response = await http.get(
          Uri.parse('${Const.BASE_URl}/class/find/class/${widget.classId}'),
          headers: {'Authorization': 'Bearer $getToken'});

      //.. responce
      if (response.statusCode == 200) {
        var decodedres = json.decode(response.body);
        //
        _className.text = json.decode(response.body)["classs"]["name"];
        _instructorController.text =
            json.decode(response.body)["classs"]["instuctor_name"];
        _roomController.text = json.decode(response.body)["classs"]["room"];
        _subCodeController.text =
            json.decode(response.body)["classs"]["subjectcode"];

        //
        setState(() {
          _selectedDay = json.decode(response.body)["classs"]["weekday"];
          startTime = DateTime.parse(
              json.decode(response.body)["classs"]["start_time"]);
          endTime =
              DateTime.parse(json.decode(response.body)["classs"]["end_time"]);

          //
          startTimeDemo = DateTime.parse(
              json.decode(response.body)["classs"]["start_time"]);
          endTimDemo =
              DateTime.parse(json.decode(response.body)["classs"]["end_time"]);

          show = true;

          //
          _startPeriodController.text =
              json.decode(response.body)["classs"]["start"].toString();
          _endPeriodController.text =
              json.decode(response.body)["classs"]["end"].toString();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      Alart.handleError(context, e.toString());
    }
  }
}

///
///
