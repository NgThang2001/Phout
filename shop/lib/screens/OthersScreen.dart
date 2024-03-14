
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:shop/AuthService.dart';
import 'package:shop/screens/DetailProductScrenn.dart';
import 'package:shop/screens/LoginScreen.dart';
import 'package:shop/screens/OrderScreen.dart';
import 'package:shop/screens/SearchScreen.dart';
import 'package:shop/screens/SelectProduct.dart';
import 'package:shop/screens/LocationPickerScreen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../CustomBottomNavigationBar.dart';
import '../model/LoginModel.dart';
import 'AddressScreen.dart';
import 'FeedbackScreen.dart';
import 'NotificationScreen.dart';
import 'UpdateProfileScreen.dart';
import 'YourVoucherScreen.dart';

class OthersScreen extends StatelessWidget {
  var userModel = Get.put(UserModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCF8ED), // Sử dụng mã màu hex và phương thức Color để đặt màu
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
              automaticallyImplyLeading: false, // Ẩn nút back trên Appbar
              floating: true,
              snap: true,
              backgroundColor: Color(0xFFFCF8ED),
              title: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Khác',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(YourVoucherScreen());
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.confirmation_number_outlined, // Chọn biểu tượng voucher từ thư viện icon của Flutter
                                      size: 25,
                                      color: Colors.orange,// Kích thước của biểu tượng
                                    ),
                                    FutureBuilder<List>(
                                        future: userModel.getListUserVoucher(AuthService.getIdUser()),
                                        builder: (context, listUserVoucher){
                                          if (listUserVoucher.hasData)
                                          {
                                            var totalVoucher = listUserVoucher.data!.length.obs;
                                            return Obx(() => Text('  $totalVoucher', style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15
                                            ),),);
                                          }
                                          else if (listUserVoucher.hasError) {
                                            // Log the error to console
                                            print('Error fetching categories: ${listUserVoucher.error}');
                                            // Display an error message widget
                                            return Text('Error fetching categories');
                                          }
                                          return CircularProgressIndicator();
                                        }
                                    ),

                                  ],
                                ),
                              ),
                            )
                        ),
                        SizedBox(width: 10,),
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: GestureDetector(
                                  onTap: () {
                                    Get.to(NotificationScreen());
                                  },
                                  child:Stack(
                                    children: [
                                      Icon(
                                        Icons.notifications_none_outlined,
                                        size: 25,
                                        color: Colors.black,
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle
                                          ),
                                          child: FutureBuilder<List>(
                                              future: userModel.getListUserNotification(AuthService.getIdUser()),
                                              builder: (context, userNotification){
                                                if (userNotification.hasData)
                                                {
                                                  var totalNotifi = userNotification.data!.length.obs;
                                                  return Obx(() => Text(
                                                    '$totalNotifi',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 8
                                                    ),
                                                  ),);
                                                }
                                                else if (userNotification.hasError) {
                                                  // Log the error to console
                                                  print('Error fetching categories: ${userNotification.error}');
                                                  // Display an error message widget
                                                  return Text('Error fetching categories');
                                                }
                                                return CircularProgressIndicator();
                                              }
                                          ),

                                        ),
                                      ),
                                    ],
                                  )

                              ),
                            )
                        ),
                      ],
                    ),
                  ],
                ),
              )
          ), // SliverAppBar
        ],
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.all(10),
                child: Text('Tài khoản',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18
                  ),
                ),),
              Padding(padding: EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      GestureDetector(
                        onTap: (){
                          Get.to(UpdateProfileScreen());
                        },
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Icon(Icons.person_4_outlined),
                            ),
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Thông tin cá nhân',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Icon(Icons.keyboard_arrow_right),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Divider(
                        color: Colors.grey,
                        thickness: 0.6, // Độ dày của đường kẻ
                        height: 1, // Chiều cao của đường kẻ
                        indent: 30, // Khoảng cách từ cạnh trái
                      ),
                      SizedBox(height: 10,),
                      GestureDetector(
                        onTap: (){
                          Get.to(AddressScreen());
                        },
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Icon(Icons.location_on_outlined),
                            ),
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Địa chỉ đã lưu',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Icon(Icons.keyboard_arrow_right),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Divider(
                        color: Colors.grey,
                        thickness: 0.6, // Độ dày của đường kẻ
                        height: 1, // Chiều cao của đường kẻ
                        indent: 30, // Khoảng cách từ cạnh trái
                      ),
                      SizedBox(height: 10,),
                      GestureDetector(
                        onTap: (){
                          AuthService.setLoggedIn(false);
                          Get.to(LoginScreen());
                        },
                        child: const Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Icon(Icons.logout ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Đăng xuất',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Icon(Icons.keyboard_arrow_right),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(10),
                child: Text('Liên hệ và góp ý',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18
                  ),
                ),),
              Padding(padding: EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      GestureDetector(
                        onTap: () async {
                          final Uri tel = Uri.parse('tel:+84385992183');

                          if (await canLaunchUrl(tel)) {
                            await launchUrl(tel);
                          } else {
                            throw 'Could not launch $tel';
                          }
                        },
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Icon(Icons.phone_outlined),
                            ),
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tổng đài',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    '0385992183',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Icon(Icons.keyboard_arrow_right),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Divider(
                        color: Colors.grey,
                        thickness: 0.6, // Độ dày của đường kẻ
                        height: 1, // Chiều cao của đường kẻ
                        indent: 30, // Khoảng cách từ cạnh trái
                      ),
                      SizedBox(height: 10,),
                      SizedBox(height: 15,),
                      GestureDetector(
                        onTap: () async {
                          final Uri _emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: 'ngthang19012001@gmail.com',
                          );

                          if (await canLaunchUrl(_emailLaunchUri)) {
                            await launchUrl(_emailLaunchUri);
                          } else {
                            throw 'Could not launch email';
                          }
                        },
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Icon(Icons.mail_outline),
                            ),
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    'ngthang19012001@gmail.com',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Icon(Icons.keyboard_arrow_right),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Divider(
                        color: Colors.grey,
                        thickness: 0.6, // Độ dày của đường kẻ
                        height: 1, // Chiều cao của đường kẻ
                        indent: 30, // Khoảng cách từ cạnh trái
                      ),
                      SizedBox(height: 10,),
                      SizedBox(height: 15,),
                      GestureDetector(
                        onTap: () async {
                          final Uri _url = Uri.parse('https://facebook.com/ndthang1901');

                          if (await canLaunchUrl(_url)) {
                            await launchUrl(_url);
                          } else {
                            throw 'Could not launch $_url';
                          }
                        },
                        child:  Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Icon(Icons.facebook),
                            ),
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Facebook',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    'facebook.com/ndthang1901',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Icon(Icons.keyboard_arrow_right),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15,),
                      Divider(
                        color: Colors.grey,
                        thickness: 0.6, // Độ dày của đường kẻ
                        height: 1, // Chiều cao của đường kẻ
                        indent: 30, // Khoảng cách từ cạnh trái
                      ),
                      SizedBox(height: 15,),
                      GestureDetector(
                        onTap: () {
                          Get.to(FeedbackScreen());
                        },
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Icon(Icons.feedback_outlined),
                            ),
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Gửi góp ý về ứng dụng',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Icon(Icons.keyboard_arrow_right),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),)


            ],
          ),
        ),
      ),

      bottomNavigationBar: CustomBottomNavigationBar(),
    );

  }

}
