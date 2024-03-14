import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shop/CustomBottomNavigationBar.dart';
import 'package:shop/main.dart';

import '../AuthService.dart';
import '../DTO/UserDTO.dart';
import 'VerifyOTPScreen.dart';


class LoginScreenCon extends GetxController {
  var phoneNum;
}

class LoginScreen extends StatelessWidget {
  var bottomBarCon = Get.put(BottomNavigationBarController());
  var loginScreenCon = Get.put(LoginScreenCon());
  var textFieldLenght = 0.obs;
  var textPhoneNum = ''.obs;
  var verifyID;

  // Hàm để đăng nhập bằng số điện thoại
  Future<void> signInWithPhoneNumber(String phoneNumber) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Tự động đăng nhập người dùng nếu xác thực được hoàn tất tự động
        UserCredential userCredential =
        await auth.signInWithCredential(credential);
        print('Người dùng đã đăng nhập: ${userCredential.user!.uid}');
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Xác thực thất bại: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        verifyID = verificationId;
        // Lưu ID xác thực nơi đó để sử dụng sau này
        print('Mã xác thực đã được gửi');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Quá thời gian chờ lấy mã xác thực tự động
        print('Quá thời gian chờ lấy mã xác thực tự động');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Không đẩy lên khi bàn phím hiển thị
      body: Stack(
        children: [
          // Hình nền
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_login.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Container màu trắng chiếm 70% màn hình từ dưới lên
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.65,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text Chào mừng bạn
                  Text(
                    'Chào mừng bạn đến với Phout',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  // TextField Nhập số điện thoại
                  TextField(

                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.black),

                      prefixIcon: Container(
                        width: 80,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Text('+84', style: TextStyle(color: Colors.black)),
                            SizedBox(width: 20,),
                            Container(
                              width: 1,
                              height: 30,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),

                      hintText: 'Nhập số điện thoại',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    onChanged: (text) {
                      textFieldLenght.value = text.length;
                      textPhoneNum.value = text;
                    },
                  ),

                  SizedBox(height: 20),
                  // Button Đăng nhập
                  Obx(() =>  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: textFieldLenght.value>=9
                          ? Colors.orange
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(10), // Đặt bán kính bo tròn
                      border: Border.all(color: Colors.white, width: 1), // Đường viền
                    ),
                    child: TextButton(
                      onPressed: (textFieldLenght.value>=9) ? () {
                        bottomBarCon.selectedIndex.value = 0;
                        var num = '+84${textPhoneNum.value.replaceAll(RegExp('^0+'), '')}';
                        signInWithPhoneNumber(num);
                        loginScreenCon.phoneNum = num;
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true, // Cho phép cuộn nội dung khi vượt qua kích thước màn hình
                          builder: (BuildContext context) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.9,
                              child: VerifyOTPScreen(verifyID: verifyID),
                            );
                          },
                        );
                      } : null,
                      child: Text(
                        'Đăng nhập',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),),

                  SizedBox(height: 20),
                  // Text Hoặc
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 1,
                        color: Colors.grey[600],
                        width: 120,
                      ),
                      Text(
                        'Hoặc',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Colors.grey[600],
                        width: 120,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Button Facebook
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10), // Đặt bán kính bo tròn
                      border: Border.all(color: Colors.white, width: 1), // Đường viền
                    ),
                    child: TextButton(
                      onPressed: () {
                        // Xử lý khi nhấn nút Facebook
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/fb_icon.png'),

                          SizedBox(width: 8), // Khoảng cách giữa icon và text
                          Text(
                            'Tiếp tục bằng Facebook',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),


                  SizedBox(height: 10),
                  // Button Google
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), // Đặt bán kính bo tròn
                      border: Border.all(color: Colors.black, width: 1), // Đường viền
                    ),
                    height: 50,
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        // Xử lý khi nhấn nút Facebook
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/gg_icon.png'),
                          SizedBox(width: 8), // Khoảng cách giữa icon và text
                          Text(
                            'Tiếp tục bằng Google',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
