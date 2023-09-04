import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  Duration get loginTime => const Duration(milliseconds: 2250);

  var accesscode = '';

  bool signup = false;

  Future<String?> _authUser(LoginData data) async {
    debugPrint('Phone: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      // Add try catch authentication block
      // Return string if fail authentication
      // Return null if successfully authenticated
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) async {
    // Check for whether phone number has been registered
    return Future.delayed(loginTime).then((_) async {
      // Add try catch sign up block
      // Return string if fail sign up
      // Return null if successfully signed up
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) async {
    // Check if phone number has account and email valid
    // Add try catch recover password block
    // Return string if fail recover password
    // Return null if successfully signed up
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    accesscode = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FlutterLogin(
      userValidator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your phone number';
        }
        if (value.length != 8 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
          return 'Please enter a valid 8-digit phone number';
        }
        return null;
      },
      theme: LoginTheme(primaryColor: Color.fromARGB(255, 232, 134, 167)),
      logo: const AssetImage('assets/images/logo.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      additionalSignupFields: [
        // Additional sign up fields if needed
      ],
      onRecoverPassword: _recoverPassword,
      messages: LoginMessages(
          // additionalSignUpFormDescription: 'Enter Access Code',
          userHint: "Phone Number",
          signUpSuccess: 'Sign In Successful',
          recoverPasswordIntro: 'Enter your recovery email here',
          recoverPasswordDescription:
              'An email will be sent to your email addess for password reset.'),
      onSubmitAnimationCompleted: () async {
        // Navigate to Dashboard
      },
    ));
  }
}
