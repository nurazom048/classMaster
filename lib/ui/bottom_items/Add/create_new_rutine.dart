import 'package:flutter/material.dart';
import 'package:table/ui/bottom_items/Home/home_req/rutinReq.dart';
import '../../../helper/constant/AppColor.dart';
import '../../../widgets/appWidget/TextFromFild.dart';
import '../../../widgets/appWidget/appText.dart';
import '../../../widgets/appWidget/buttons/cupertinoButttons.dart';
import '../../auth_Section/new Auuth_Screen/LogIn_Screen.dart';

class CreaeNewRutine extends StatelessWidget {
  CreaeNewRutine({super.key});
  final _rutineNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            HeaderTitle("Hone", context),
            const SizedBox(height: 53),
            const AppText("  Create A new \n  Routine").title(),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  //----------------------------------------------------------------//
                  AppTextFromField(
                    controller: _rutineNameController,
                    hint: "Rutine name",
                    labelText: "Enter class name",
                    validator: (value) => rutinNameValidator(value),
                  ),
                  const SizedBox(height: 100),

                  //----------------------------------------------------------------//

                  CupertinoButtonCustom(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    textt: "Create Rutine",
                    color: AppColor.nokiaBlue,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _onTapToButton();
                      }
                    },
                  ),
                  const SizedBox(height: 200),
                ],
              ),

              //
            ),
          ],
        ),
      ),
    );
  }

  void _onTapToButton() {
    RutinReqest().creatRutin(rutinName: _rutineNameController.text);
  }

  //
  static String? rutinNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Routine name is required';
    }
    return null;
  }
}
