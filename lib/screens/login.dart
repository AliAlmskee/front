import 'package:babel/constant.dart';
import 'package:babel/models/api_response.dart';
import 'package:babel/models/user_data.dart';
import 'package:babel/screens/home.dart';
import 'package:babel/screens/register.dart';
import 'package:babel/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService authService = AuthService();
  // Add text editing controllers
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool loading = false;
  Future<void> loginUser() async {
    final ApiResponse response = await authService.login(
      phoneNumberController.text,
      passwordController.text,
    );
    if (!mounted) return;
    if (response.error == null) {
      final UserData userData = response.data as UserData;
      saveAndRedirectToHome(userData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Welcome back, ${userData.user.name}!")),
      );
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.error}')),
      );
    }
  }

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
            Image.asset(
              'assets/images/image1.png',
              height: 250,
              width: 250,
            ),
            const SizedBox(
              height: 100,
            ),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: phoneNumberController,
              validator: (value) =>
                  value!.isEmpty ? 'Invalid phone number address' : null,
              cursorColor: Theme.of(context).primaryColor,
              decoration: inputDecoration('رقم الهاتف', Icons.phone, context),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              validator: (value) =>
                  value!.length < 6 ? 'Required at least 6 characters' : null,
              cursorColor: Theme.of(context).primaryColor,
              decoration: inputDecoration('كلمة المرور', Icons.lock, context),
            ),
            const SizedBox(
              height: 20,
            ),
            loading
                ? const Center(child: CircularProgressIndicator())
                : textButton('Login', () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        loading = !loading;
                        loginUser();
                      });
                    }
                  }, context),
            const SizedBox(
              height: 20,
            ),
            loginRegisterHintRow('ليس لديك حساب؟ ', 'إنشاء حساب', () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Register()),
                  (route) => false);
            }, context),
          ],
        ),
      ),
    );
  }
}
