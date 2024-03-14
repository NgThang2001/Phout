import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/main.dart';
import 'package:shop/model/LoginModel.dart';

import '../AuthService.dart';
import 'LoginScreen.dart';

class OTPController extends GetxController {
  List<TextEditingController> controllers = List.generate(
    6,
        (index) => TextEditingController(),
  );
  var isLoadingVerify = RxBool(false);

  @override
  void onClose() {
    // Giải phóng tất cả các controllers
    for (var controller in controllers) {
      controller.dispose();
    }
    super.onClose();
  }
}

class VerifyOTPScreen extends StatelessWidget {
  var verifyID;
  VerifyOTPScreen({required this.verifyID});

  final OTPController otpController = Get.put(OTPController());
  var loginScreenCon = Get.put(LoginScreenCon());
  UserModel userModel = UserModel();
  var count = 0;

  void submit() {
    count = 0;
    for (var controller in otpController.controllers) {
      controller.clear();
    }
  }

  String getTextFromControllers(List<TextEditingController> controllers) {
    return controllers.map((controller) => controller.text).join();
  }

  Future<void> verifyOTP(String verificationId, String smsCode) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    try {
      UserCredential userCredential = await auth.signInWithCredential(credential);
      User? user = userCredential.user;
      bool check = await userModel.checkUserExist(loginScreenCon.phoneNum);
      if(check==true)
        {
          otpController.isLoadingVerify.value = false;
          AuthService.setLoggedIn(true);
          Get.to(MyHomePage());
        }
      if(check==false){
        otpController.isLoadingVerify.value = false;
        Get.to(RegisterScreen());
      }
    } catch (e) {
      otpController.isLoadingVerify.value = false;
      print('Xác minh mã OTP thất bại: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Container(

            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.white.withOpacity(0.95),
                      ),
                      Positioned(
                        top: 20.0,
                        right: 20.0,
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Xác nhận mã OTP',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Text(
                                'Mã xác thực gồm 6 số đã gửi đến số điện thoại:',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 50.0),
                              Text(
                                'Nhập mã để tiếp tục',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: List.generate(
                                    6,
                                        (index) => SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: TextField(
                                        controller: otpController.controllers[index],
                                        maxLength: 1,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 18),
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            counterText: '',
                                            contentPadding: EdgeInsets.all(0)
                                        ),
                                        onChanged: (text) async {
                                          if(text!='')
                                            count++;
                                          else
                                            count--;
                                          if (text.isNotEmpty) {
                                            FocusScope.of(context).nextFocus();
                                          }
                                          if(count == 6)
                                          {
                                            otpController.isLoadingVerify.value = true;
                                            print(getTextFromControllers(otpController.controllers));
                                            var smsCode = getTextFromControllers(otpController.controllers);
                                            await verifyOTP(verifyID, smsCode);
                                            submit();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Bạn không nhận được mã?',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Xử lý khi nhấn nút "Gửi mã"
                                    },
                                    child: Text(
                                      'Gửi lại',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Obx(() => Visibility(
          visible: otpController.isLoadingVerify.value == true ? true : false,
          child: Container(
            color: Colors.black.withOpacity(0.5), // Màu đen với độ mờ 0.5
            child: Center(
              child: CircularProgressIndicator(), // Vòng tròn tiến trình
            ),
          )
        ))
      ],
    );
  }


}


class RegisterScreen extends StatelessWidget {
  UserModel userModel = UserModel();
  var firstNameCon = TextEditingController();
  var lastNameCon = TextEditingController();
  var emailCon = TextEditingController();
  var loginScreenCon = Get.put(LoginScreenCon());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Đăng ký thông tin'),
    ),
    body: SingleChildScrollView(
    physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: firstNameCon,
              decoration: InputDecoration(
                labelText: 'Tên',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: lastNameCon,
              decoration: InputDecoration(
                labelText: 'Họ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: emailCon,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TextButton(
              onPressed: () async {
                if (firstNameCon.text.isEmpty || lastNameCon.text.isEmpty || emailCon.text.isEmpty) {
                  final snackBar = SnackBar(
                    content: Text('Vui lòng điền đủ thông tin'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3), // Thời gian hiển thị
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  Map<String, dynamic> userData = {
                    'phone_number': loginScreenCon.phoneNum,
                    'first_name': firstNameCon.text,
                    'last_name': lastNameCon.text,
                    'email': emailCon.text,
                    'point_phout': 0,
                  };
                  if(await userModel.CreateUser(userData)==201)
                  {
                    bool check = await userModel.checkUserExist(loginScreenCon.phoneNum);
                    if(check==true)
                    {
                      AuthService.setLoggedIn(true);
                      Get.to(MyHomePage());
                    }
                    else
                      {
                        final snackBar = SnackBar(
                          content: Text('Có lôi xảy ra, hãy thử lại sau'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3), // Thời gian hiển thị
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Get.to(LoginScreen());
                      }
                  }
                  else
                  {
                    final snackBar = SnackBar(
                      content: Text('Đã xảy ra lỗi!'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 3), // Thời gian hiển thị
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
              },
              child: Text('Đăng ký'),
            ),
          ],
        ),
      ),
    ),
    );
  }
}

