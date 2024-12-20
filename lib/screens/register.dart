import 'package:babel/constant.dart';
import 'package:babel/models/api_response.dart';
import 'package:babel/models/user_data.dart';
import 'package:babel/screens/home.dart';
import 'package:babel/screens/login.dart';
import 'package:babel/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService authService = AuthService();
  // Add text editing controllers
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController(),
      phoneNumberController = TextEditingController(),
      locationController = TextEditingController(),
      passwordController = TextEditingController(),
      passwordConfirmController = TextEditingController();

  Future<void> registerUser() async {
    final requestBody = {
      "name": nameController.text,
      "phone_number": phoneNumberController.text,
      "location": locationController.text,
      "password": passwordController.text,
      "password_confirmation": passwordConfirmController.text,
    };

    final ApiResponse response = await authService.register(requestBody);
    if (!mounted) return;
    if (response.error == null) {
      final UserData userData = response.data as UserData;
      saveAndRedirectToHome(userData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Welcome, ${userData.user.name}!")),
      );
    } else {
      setState(() {
        loading = !loading;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  bool loading = false;

  void saveAndRedirectToHome(UserData userData) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('token', userData.token);
    await preferences.setInt('userId', userData.user.id);
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const Home()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(32),
          children: [
            //
            // Name Field
            TextFormField(
              controller: nameController,
              validator: (value) => value!.isEmpty ? 'Invalid name' : null,
              cursorColor: Theme.of(context).primaryColor,
              decoration: inputDecoration('Name', Icons.info, context),
            ),
            const SizedBox(
              height: 20,
            ),
            //
            // Phone Number Field
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: phoneNumberController,
              validator: (value) =>
                  value!.isEmpty ? 'Invalid Phone Number' : null,
              cursorColor: Theme.of(context).primaryColor,
              decoration: inputDecoration('Phone Number', Icons.phone, context),
            ),
            const SizedBox(
              height: 20,
            ),
            //
            // Location Field
            TextFormField(
              controller: locationController,
              validator: (value) => value!.isEmpty ? 'Invalid Location' : null,
              cursorColor: Theme.of(context).primaryColor,
              decoration:
                  inputDecoration('Location', Icons.location_city, context),
            ),
            const SizedBox(
              height: 20,
            ),
            //
            // Password Field
            TextFormField(
              controller: passwordController,
              obscureText: true,
              validator: (value) =>
                  value!.length < 6 ? 'Required at least 6 characters' : null,
              cursorColor: Theme.of(context).primaryColor,
              decoration: inputDecoration('Password', Icons.lock, context),
            ),
            const SizedBox(
              height: 20,
            ),
            //
            // Confirm Password Field
            TextFormField(
              controller: passwordConfirmController,
              obscureText: true,
              validator: (value) => value != passwordController.text
                  ? 'Confirm password does not match'
                  : null,
              cursorColor: Theme.of(context).primaryColor,
              decoration:
                  inputDecoration('Confirm Password', Icons.lock, context),
            ),
            const SizedBox(
              height: 20,
            ),
            //
            // Register Submit Button
            loading
                ? const Center(child: CircularProgressIndicator())
                : textButton('Register', () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        loading = !loading;
                        registerUser();
                      });
                    }
                  }, context),
            const SizedBox(
              height: 20,
            ),
            //
            // Login Register Hint Row
            loginRegisterHintRow('Already have an account? ', 'Login', () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Login()),
                  (route) => false);
            }, context),
          ],
        ),
      ),
    );
  }
}
