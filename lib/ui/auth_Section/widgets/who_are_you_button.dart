import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/constant/app_color.dart';
import '../../../widgets/appWidget/app_text.dart';
import '../auth_ui/SignUp_Screen.dart';

class WhoAreYouButton extends StatefulWidget {
  final void Function(String)? onAccountType;

  const WhoAreYouButton({Key? key, required this.onAccountType})
      : super(key: key);

  @override
  State<WhoAreYouButton> createState() => _WhoAreYouButtonState();
}

class _WhoAreYouButtonState extends State<WhoAreYouButton> {
  String selectedRole = 'Student';

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Who Are You ?", style: TS.opensensBlue()),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedRole == "Student"
                          ? const Color(0xFF0168FF).withOpacity(0.18)
                          : const Color(0xFFEEF4FC),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: selectedRole == "Student"
                            ? const Color(0xFF0168FF)
                            : const Color(0xFFA7CBFF),
                        width: 1.0,
                      ),
                    ),
                    child: RadioListTile(
                      activeColor: AppColor.nokiaBlue,
                      title: Text(
                        "Student",
                        style: TextStyle(
                          color: selectedRole != "Student"
                              ? const Color(0xFFA7CBFF)
                              : const Color(0xFF0168FF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      value: "Student",
                      groupValue: selectedRole,
                      onChanged: (value) {
                        setState(() {
                          if (value != null) {
                            ref
                                .watch(selectAccountTypeProvider.notifier)
                                .update((state) => value);

                            selectedRole = value;
                            widget.onAccountType!.call(selectedRole);
                          }
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 3.0),
                Expanded(
                  child: Container(
                    width: 70,
                    decoration: BoxDecoration(
                      color: selectedRole == "Academy"
                          ? const Color(0xFF0168FF).withOpacity(0.18)
                          : const Color(0xFFEEF4FC),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: selectedRole == "Academy"
                            ? const Color(0xFF0168FF)
                            : const Color(0xFFA7CBFF),
                        width: 1.0,
                      ),
                    ),
                    child: RadioListTile(
                      title: Text(
                        "Academy",
                        style: TextStyle(
                          color: selectedRole != "Academy"
                              ? const Color(0xFFA7CBFF)
                              : const Color(0xFF0168FF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      value: "Academy",
                      groupValue: selectedRole,
                      onChanged: (value) {
                        setState(() {
                          if (value != null) {
                            ref
                                .watch(selectAccountTypeProvider.notifier)
                                .update((state) => value);
                            selectedRole = value;
                            widget.onAccountType!.call(selectedRole);
                          }
                        });
                        widget.onAccountType!.call(selectedRole);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
