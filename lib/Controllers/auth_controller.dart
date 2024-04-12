import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:footware/pages/home_page.dart';
import 'package:footware/pages/login_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// import 'package:otp_text_field_v2/otp_field_v2.dart';
import '../models/user/user.dart';

class AuthController extends GetxController {
  GetStorage box = GetStorage();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference userCollection;

  TextEditingController registerNameCtrl = TextEditingController();
  TextEditingController registerNumberCtrl = TextEditingController();

  TextEditingController loginNumberCtrl = TextEditingController();

  // OtpFieldControllerV2 otpController = OtpFieldControllerV2();
  bool otpFieldShown = false;
  int? otpSend;

  // int? otpEntered;
  User? loginUser;

  @override
  void onReady() {
    Map<String, dynamic>? user = box.read('loginUser');
    if (user != null) {
      loginUser = User.fromJson(user);
      Get.off(const HomePage());
    }
    super.onReady();
  }

  @override
  void onInit() {
    userCollection = firestore.collection('users');

    super.onInit();
  }

  addUser() {
    try {
      // if (otpSend == otpEntered) {
      if (registerNameCtrl.text.isEmpty || registerNumberCtrl.text.isEmpty) {
        Get.snackbar(
          'Error',
          'Please fill all fields',
          colorText: Colors.red,
        );
        return;
      }
      DocumentReference doc = userCollection.doc();
      User user = User(
        id: doc.id,
        name: registerNameCtrl.text,
        number: int.parse(registerNumberCtrl.text),
      );
      final userJson = user.toJson();
      doc.set(userJson);
      setValuesDefault();
      Get.snackbar(
        'Success',
        'User Registration Successfully!',
        colorText: Colors.green,
      );
      Get.to(const LoginPage());
      // } else {
      //   Get.snackbar(
      //     'Error',
      //     'Incorrect OTP entered',
      //     colorText: Colors.red,
      //   );
      // }
    } catch (e) {
      Get.snackbar(
        'Error in Registration',
        e.toString(),
        colorText: Colors.red,
      );
      print(e);
    }
  }

  // sendOtp() async {
  //   try {
  //     if (registerNameCtrl.text.isEmpty || registerNumberCtrl.text.isEmpty) {
  //       Get.snackbar(
  //         'Error',
  //         'Please fill all fields',
  //         colorText: Colors.red,
  //       );
  //       return;
  //     }
  //     final random = Random();
  //     int otp = 1000 + random.nextInt(9000);
  //     print(otp);
  //     if (otp != null) {
  //       otpFieldShown = true;
  //       otpSend = otp;
  //       Get.snackbar(
  //         'Success',
  //         'OTP Sending Successfully',
  //         colorText: Colors.green,
  //       );
  //     } else {
  //       Get.snackbar(
  //         'Error',
  //         'Error Sending OTP',
  //         colorText: Colors.red,
  //       );
  //     }
  //   } catch (e) {
  //     Get.snackbar(
  //       'Error',
  //       'Error Sending OTP',
  //       colorText: Colors.red,
  //     );
  //   } finally {
  //     update();
  //   }
  // }

  Future<void> login() async {
    try {
      String phoneNumber = loginNumberCtrl.text;
      if (phoneNumber.isNotEmpty) {
        var querySnapshot = await userCollection
            .where('number', isEqualTo: int.tryParse(phoneNumber))
            .limit(1)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          var userDoc = querySnapshot.docs.first;
          var userData = userDoc.data() as Map<String, dynamic>;
          box.write('loginUser', userData);
          loginNumberCtrl.clear();
          Get.off(const HomePage());
          Get.snackbar('Success', 'Login Successful!', colorText: Colors.green);
        } else {
          Get.snackbar('Error', 'User not found, Please register',
              colorText: Colors.red);
        }
      } else {
        Get.snackbar('Error', 'Please enter phone-number',
            colorText: Colors.red);
      }
    } catch (e) {
      print('Failed to Login $e');
      Get.snackbar('Error', 'Failed to login', colorText: Colors.red);
    }
  }

  setValuesDefault() {
    registerNameCtrl.clear();
    registerNumberCtrl.clear();
    // otpController.clear();
    otpFieldShown = false;
    update();
  }
}
