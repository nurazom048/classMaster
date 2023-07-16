// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/constant/app_color.dart';
import '../../../widgets/appWidget/app_text.dart';
import '../auth_ui/SignUp_Screen.dart';

class WhoAreYouButton extends ConsumerWidget {
  final void Function(String)? onAccountType;
  String selectedRole = 'Student';

  WhoAreYouButton({Key? key, required this.onAccountType}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectAccountTypeNotifier =
        ref.watch(selectAccountTypeProvider.notifier);
    final selected = ref.watch(selectAccountTypeProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Who Are You ?", style: TS.opensensBlue()),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    selectAccountTypeNotifier.update((state) => 'Student');
                    selectedRole = 'Student';
                    onAccountType?.call(selectedRole);
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: borderColor('Student', selected),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        radio('Student', selected),
                        const SizedBox(width: 7),
                        Text(
                          "Student",
                          style: TextStyle(
                            color: textColor('Student', selected),
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20.0),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    selectAccountTypeNotifier.update((state) => 'Academy');
                    selectedRole = 'Academy';
                    onAccountType?.call(selectedRole);
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: borderColor('Academy', selected),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        radio('Academy', selected),
                        const SizedBox(width: 7),
                        Text(
                          "Academy",
                          style: TextStyle(
                            color: textColor('Academy', selected),
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color textColor(String value, String selected) {
    return selected == value ? AppColor.nokiaBlue : const Color(0xFFA7CBFF);
  }

  Color borderColor(String value, String selected) {
    return selected == value ? AppColor.nokiaBlue : const Color(0xFFA7CBFF);
  }

  Widget radio(String value, String selected) {
    final isSelected = selected == value;

    return CircleAvatar(
      radius: 13,
      backgroundColor:
          isSelected ? AppColor.nokiaBlue : const Color(0xFFA7CBFF),
      child: CircleAvatar(
        radius: 12,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 7,
          backgroundColor:
              isSelected ? AppColor.nokiaBlue : const Color(0xFFA7CBFF),
        ),
      ),
    );
  }
}
