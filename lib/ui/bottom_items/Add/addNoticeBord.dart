import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/widgets/text%20and%20buttons/butonCustom.dart';
import '../../../widgets/MyTextFields.dart';

class AddNoticeBord extends ConsumerWidget {
  const AddNoticeBord({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController controller = TextEditingController();

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8),
          child: Column(
            children: [
              ///.... room number
              MyTextField(
                name: "Notice Bord Name",
                controller: controller,
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return ' Name is Required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 60),

              const SizedBox(height: 60),
              ButtomCustom(text: const Text("Add"), onPressed: () {})
            ],
          ),
        ),
      ),
    );
  }
}

class NoticeBordWiget extends StatelessWidget {
  final Widget text;
  const NoticeBordWiget({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(color: Colors.black26),
      height: 200,
      width: MediaQuery.of(context).size.width / 2,
      child: Padding(padding: const EdgeInsets.all(8.0), child: text),
    );
  }
}
