// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:sample_moto_tour/auth/services/auth.service.dart';
import 'package:sample_moto_tour/tools/extentions/sized_box_ext.dart';
import 'package:sample_moto_tour/tools/file_importer.dart';
import '../widgets/custom_text_field.dart';
import '../utils/validation.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
       onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
      
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                200.kH,
                const Text('Зарегистрироваться',  style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),),
                50.kH,
                  CustomTextField(
                    keyboardType: TextInputType.emailAddress,
                    icon: const Icon(Icons.email),
                    hintText: 'Электронная почта',
                    onChanged: (value) {
                      setState(() => email = value);
                    },
                    validator: (value) => validateEmail(value),
                  ),
                  CustomTextField(
                    keyboardType: TextInputType.visiblePassword,
                    icon: const Icon(Icons.key),
                    hintText: 'Пароль',
                    obscureText: true,
                    onChanged: (value) {
                      setState(() => password = value);
                    },
                    validator: (value) => validatePassword(value),
                  ),
                 20.kH,
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Создать аккаунт',  style: TextStyle(color: Colors.black),),
                      ],
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        dynamic result =
                            await _authService.register(email, password);
                        if (result != null) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MapScreen()));
                        } else {
                          // Handle registration error
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Registration failed')));
                        }
                      }
                    },
                  ),
                   
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
