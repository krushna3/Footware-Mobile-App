import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:footware/Controllers/auth_controller.dart';
import 'package:footware/models/user/user.dart';
import 'package:footware/pages/home_page.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PurchaseController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference ordersCollection;

  TextEditingController addressController = TextEditingController();

  @override
  void onInit() {
    ordersCollection = firestore.collection('orders');

    super.onInit();
  }

  double orderPrice = 0;
  String itemName = '';
  String orderAddress = '';

  submitOrder({
    required double price,
    required String item,
    required String description,
  }) {
    orderPrice = price;
    itemName = item;
    orderAddress = addressController.text;

    if (orderAddress.isEmpty) {
      Get.snackbar('Error', 'Please Provide the billing address',
          colorText: Colors.red);
      return;
    }
    Razorpay _razorpay = Razorpay();

    var options = {
      'key': 'rzp_test_yzDsiMmY2t6I0A',
      'amount': price * 100,
      'name': item,
      'description': description,
    };

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    orderSuccess(transactionid: response.paymentId);
    Get.snackbar('Success', 'Payment Successful', colorText: Colors.green);
    addressController.clear();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar('Error', '${response.message}', colorText: Colors.red);
  }

  Future<void> orderSuccess({required String? transactionid}) async {
    User? loginUse = Get.find<AuthController>().loginUser;
    try {
      if (transactionid != null) {
        DocumentReference docRef = await ordersCollection.add({
          'customer': loginUse?.name ?? '',
          'phone': loginUse?.number ?? '',
          'item': itemName,
          'price': orderPrice,
          'address': orderAddress,
          'transactionid': transactionid,
          'dateTime': DateTime.now().toString(),
        });
        // print('Order Created Successfully ${docRef.id}');
        showOrderSuccessDialog(docRef.id);
        // Get.snackbar('Success', 'Order Created Successfully ${docRef.id}',colorText: Colors.green);
      } else {
        Get.snackbar('Error', 'Please fill all fields.', colorText: Colors.red);
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', '${e}', colorText: Colors.red);
    }
  }

  void showOrderSuccessDialog(String Orderid) {
    Get.defaultDialog(
      title: 'Order Success!',
      content: Text('Your order id is $Orderid'),
      confirm: ElevatedButton(
          onPressed: () {
            Get.to(const HomePage());
          },
          child: const Text('Close')),
    );
  }
}
