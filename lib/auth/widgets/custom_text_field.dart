import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget icon;
  final Function(String) onChanged;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.obscureText = false,
    required this.onChanged,
    required this.validator,
    required this.icon, required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelStyle: const TextStyle(color: Colors.black),
            prefixIcon: icon,
            hintText:hintText ,
            hintStyle: const TextStyle(color: Colors.black),
            prefixIconColor: Colors.black ,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
          
          ),
          obscureText: obscureText,
          onChanged: onChanged,
          validator: validator,
        ),
      ),
    );
  }
}
