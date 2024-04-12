import 'package:flutter/material.dart';
import 'package:footware/Controllers/auth_controller.dart';
import 'package:footware/pages/login_page.dart';

// import 'package:footware/widgets/otp_txt_field.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (ctrl) {
      return Scaffold(
        body: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.blueGrey[50]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Create Your Account!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: ctrl.registerNameCtrl,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.perm_contact_cal_rounded),
                  labelText: 'Your Name',
                  hintText: 'Enter Your Name',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: ctrl.registerNumberCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.phone_android),
                  labelText: 'Mobile Number',
                  hintText: 'Enter Your Mobile Number',
                ),
              ),
              // const SizedBox(
              //   height: 20,
              // ),
              // OtpTxtField(
              //   otpController: ctrl.otpController,
              //   visble: ctrl.otpFieldShown,
              //   onComplete: (otp) {
              //     ctrl.otpEntered = int.tryParse(otp ?? '0000');
              //   },
              // ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  ctrl.addUser();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text('Register'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  Get.to(const LoginPage());
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      );
    });
  }
}
