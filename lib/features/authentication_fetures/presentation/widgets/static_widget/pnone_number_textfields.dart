import 'package:flutter/material.dart';

class PhoneNumberTextField extends StatelessWidget {
  final TextEditingController countryController;
  final TextEditingController phoneNumberController;
  final String? Function(String?)? validator;

  const PhoneNumberTextField({super.key, 
    required this.countryController,
    required this.phoneNumberController,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: TextField(
              controller: countryController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 10),
              ),
            ),
          ),
          const Text(
            "|",
            style: TextStyle(fontSize: 33, color: Colors.grey),
          ),
          Expanded(
            child: TextFormField(
              validator: validator,
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              autofocus: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Phone",
                contentPadding: EdgeInsets.only(left: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
