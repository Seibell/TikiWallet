import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:tiki_wallet/model/user.dart';
import 'package:tiki_wallet/pay_screen.dart';
import 'package:tiki_wallet/services/user_preferences.dart';
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

  API api = API('https://tikiwallet-backend.onrender.com');

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
        'phoneNumber': int.parse(name),
        'password': password,
      };
      var verificationResponse = await api.login(requestData);
      if (verificationResponse.containsKey('error')) {
        return '${verificationResponse['error']}';
      } else {
        var token = verificationResponse['token'];
        User user = User.fromJson(verificationResponse['user']);
        UserPreferences.setToken(token);
        UserPreferences.setAccountID(user.id);
        UserPreferences.setContact(user.phone_number);
        UserPreferences.setUsername(user.username);
        // Use token if needed
        return null;
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
      print('Registered');
      if (data.additionalSignupData != null) {
        int otp = int.parse(data.additionalSignupData!['OTP']!);
        print(otp);
        Map<String, dynamic> otpData = {
          "otp": otp,
          "phoneNumber": int.parse(data.name!)
        };
        try {
          var verificationResponse = await api.verify(otpData);
          print(verificationResponse);

          if (verificationResponse.containsKey('error')) {
            return 'Failed to verify OTP: ${verificationResponse['error']}';
          } else {
            // Register User
            var phonenumber = data.name;
            var password = data.password;
            var username = data.additionalSignupData!['username'];

            // Create a data map to send in the request
            Map<String, dynamic> requestData = {
              "phoneNumber": int.parse(phonenumber!),
              "password": password,
              "username": username
            };
            var response = await api.register(requestData);
            var token = response['token'];
            // Do smth with token. store in shared preferences
            print(token);
            if (response.containsKey('error')) {
              return '${response['error']}';
            } else {
              return null;
            }
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
      print(data);
      // Use sign up data to generate OTP
      var name = data.name;
      var password = data.password;

      // Create a data map to send in the request
      Map<String, dynamic> requestData = {
        'phoneNumber': int.parse(name!),
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
            keyName: 'username',
            displayName: 'Username',
            icon: Icon(Icons.person_2_rounded)),
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
          builder: (context) => HomeScreen(),
        ));
      },
    ));
  }
}
