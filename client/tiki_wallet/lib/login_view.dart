import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'home_page.dart';
import 'package:tiki_wallet/services/api.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  Duration get loginTime => const Duration(milliseconds: 2250);

  var accesscode = '';

  API api = API('https://tikiwallet-backend.onrender.com/');

  bool signup = false;

  Future<String?> _authUser(LoginData data) async {
    debugPrint('Phone: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      // Add try catch authentication block
      // Return string if fail authentication
      // Return null if successfully authenticated
      var name = data.name;
      var password = data.password;

      // Create a data map to send in the request
      Map<String, dynamic> requestData = {
        'phonenumber': name,
        'password': password,
      };
      try {
        var verificationResponse = await api.login(requestData);
        if (verificationResponse.containsKey('error')) {
          return 'Login Failed: ${verificationResponse['error']}';
        } else {
          // Register User
          var name = data.name;
          var password = data.password;

          // Create a data map to send in the request
          Map<String, dynamic> requestData = {
            'phonenumber': name,
            'password': password,
          };
          api.register(requestData);
          return null;
        }
      } catch (e) {
        return 'Login Failed: ${e.toString()}';
      }
    });
  }

  Future<String?> _signupUser(SignupData data) async {
    // Check for whether phone number has been registered
    return Future.delayed(loginTime).then((_) async {
      // Add try catch sign up block
      // Return string if fail sign up
      // Return null if successfully signed up
      // Check if otp is correct
      if (data.additionalSignupData != null) {
        var otp = data.additionalSignupData!['otp'];
        Map<String, dynamic> otpData = {'otp': otp};
        try {
          var verificationResponse = await api.verify(otpData);

          if (verificationResponse.containsKey('error')) {
            return 'Failed to verify OTP: ${verificationResponse['error']}';
          } else {
            // Register User
            var name = data.name;
            var password = data.password;

            // Create a data map to send in the request
            Map<String, dynamic> requestData = {
              'phonenumber': name,
              'password': password,
            };
            api.register(requestData);
            return null;
          }
        } catch (e) {
          // Handle any exceptions that occur during verification
          return 'Failed to verify OTP: ${e.toString()}';
        }
      }
      return 'Invalid OTP';
    });
  }

  Future<String?> _genOTP(SignupData data) async {
    // Check for whether phone number has been registered
    return Future.delayed(loginTime).then((_) async {
      // Use sign up data to generate OTP
      var name = data.name;
      var password = data.password;

      // Create a data map to send in the request
      Map<String, dynamic> requestData = {
        'phonenumber': name,
        'password': password,
      };

      // Call sendVerification with the requestData
      api.sendVerification(requestData);

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
      onSwitchToAdditionalFields: _genOTP,
      additionalSignupFields: [
        // Additional sign up fields if needed
        UserFormField(
            keyName: 'OTP', displayName: 'OTP', icon: Icon(Icons.lock))
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
        //Navigate to dashboard_view

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MyHomePage(),
        ));
      },
    ));
  }
}
