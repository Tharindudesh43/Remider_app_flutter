import 'package:flutter/material.dart';

class custom_textfield extends StatefulWidget {
  final TextEditingController? controller;
  String? errorText;
  String? textfieldvalue;

  custom_textfield(
      {super.key,
      this.controller,
      required this.textfieldvalue,
      this.errorText});

  @override
  State<custom_textfield> createState() => _custom_textfieldState();
}

class _custom_textfieldState extends State<custom_textfield> {
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return widget.textfieldvalue == "Password"
        ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: widget.controller,
              obscureText: isObscure,
              decoration: InputDecoration(
                errorText: widget.errorText,
                filled: true,
                fillColor: Colors.yellow.withOpacity(0.1),
                icon: const Icon(
                  color: Color.fromARGB(255, 103, 96, 45),
                  weight: 120,
                  Icons.lock,
                  size: 24,
                ),
                labelText: 'Password',
                labelStyle: const TextStyle(fontSize: 15),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                suffixIcon: IconButton(
                  icon: Icon(
                    color: Colors.black,
                    isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.yellow.withOpacity(0.1),
                  icon: const Icon(
                    color: Color.fromARGB(255, 103, 96, 45),
                    weight: 120,
                    Icons.info,
                    size: 23,
                  ),
                  errorText: widget.errorText,
                  label: Text(
                    widget.textfieldvalue!,
                    style: const TextStyle(fontSize: 15),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 1)),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2))),
            ),
          );
  }
}
