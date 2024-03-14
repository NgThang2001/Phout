import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shop/AuthService.dart';
import 'package:shop/model/LoginModel.dart';
import 'package:shop/screens/YourVoucherScreen.dart';
import 'package:shop/screens/LoadingScreen.dart';
import 'package:shop/screens/tet1.dart';
import '../API.dart';
import '../CustomBottomNavigationBar.dart';
import 'package:intl/intl.dart';

import '../DTO/UserDTO.dart';
import 'DetailRedeemVoucherScreen.dart';
import 'DetailVoucherScreen.dart';

class VoucherScreenController extends GetxController {
  var isLoadingUser = true.obs;
  var isLoadingListVoucher = true.obs;
  var isLoadingRedeem = true.obs;
}

class VoucherScreen extends StatelessWidget {
  Data data = Get.put(Data());
  var userModel = Get.put(UserModel());
  var voucherCon = Get.put(VoucherScreenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCF8ED), // Sử dụng mã màu hex và phương thức Color để đặt màu
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background_voucher.jpg'), // Thay đổi đường dẫn đến ảnh của bạn
                  fit: BoxFit.cover, // Đảm bảo ảnh vừa với kích thước của Container
                ),
              ),
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder<List>(
                future: userModel.getDetailUser(AuthService.getIdUser()),
                builder: (context, detailUser) {
                  if (detailUser.hasData) {
                    WidgetsBinding.instance!.addPostFrameCallback((_) async {
                      voucherCon.isLoadingUser.value = false;
                    });
                    var firstName = detailUser.data![0]['first_name'];
                    var lastName = detailUser.data![0]['last_name'];
                    var pointPhout = detailUser.data![0]['point_phout'];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${lastName} ${firstName}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),

                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, // Hình dạng là hình tròn
                            border: Border.all(
                              color: Colors.white, // Màu viền là màu trắng
                              width: 2, // Độ rộng của viền
                            ),
                            color: Colors.transparent, // Màu nền trong suốt
                          ),
                          child: Text(
                            '${pointPhout} Phout++',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 65,
                                  height: 65,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle, // Hình dạng hình tròn
                                    color: Colors.cyan, // Màu nền xanh ngọc nhạt
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.card_giftcard, color: Colors.white), // Icon màu trắng
                                    onPressed: () {
                                      // Get.to(YourWidget());
                                    },
                                  ),
                                ),
                                SizedBox(height: 5), // Khoảng cách giữa icon và text
                                Text(
                                  'Đổi Voucher',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ), // Đặt kích thước cho text
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  width: 65,
                                  height: 65,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle, // Hình dạng hình tròn
                                    color: Colors.cyan, // Màu nền xanh ngọc nhạt
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.confirmation_number, color: Colors.white), // Icon màu trắng
                                    onPressed: () {
                                      Get.to(YourVoucherScreen());
                                    },
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Voucher của bạn',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  } else if (detailUser.hasError) {
                    // Log the error to console
                    print('Error fetching categories: ${detailUser.error}');
                    // Display an error message widget
                    return Text('Error fetching categories');
                  }
                  return CircularProgressIndicator();
                },
              ),

            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Voucher của bạn',
                        style: TextStyle(
                          color: Colors.black, // Màu chữ đen
                          fontWeight: FontWeight.bold, // Chữ đậm
                          fontSize: 18,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Xử lý sự kiện khi nhấn vào nút
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFF99)), // Nền màu vàng nhạt
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0), // Bo viền container
                            ),
                          ),
                        ),
                        child: Text(
                          'Xem tất cả',
                          style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder<List>(
                    future: userModel.getListUserVoucher(AuthService.getIdUser()),
                    builder: (context, snapshot) {
                      WidgetsBinding.instance!.addPostFrameCallback((_) async {
                        voucherCon.isLoadingListVoucher.value = false;
                      });
                      if (snapshot.hasData) {
                        if(snapshot.data!.length==0)
                          return Text('Bạn chưa có voucher nào',
                            style: TextStyle(fontSize: 15),
                          );
                        return ListView.builder(
                          shrinkWrap: true, // Cho phép tự động wrap
                          physics: NeverScrollableScrollPhysics(), // Thêm dòng này
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var codeVoucher = snapshot.data![index]['code_voucher'];
                            var nameVoucher = snapshot.data![index]['name_voucher'];
                            var imgVoucher = snapshot.data![index]['img_voucher'];
                            var discount = snapshot.data![index]['discount'];

                            DateTime dateTime = DateTime.parse(snapshot.data![index]['exp_date']);
                            var expDate = DateFormat('dd/MM/yyyy').format(dateTime);
                            if(index<4)
                              return GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true, // Cho phép cuộn nội dung khi vượt qua kích thước màn hình
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // Bo góc trên của BottomSheet
                                    ),
                                    builder: (BuildContext context) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0),
                                          ),
                                        ),
                                        height: MediaQuery.of(context).size.height * 0.95,
                                        child: DetailVoucherScreen(codeVoucher: codeVoucher),
                                      );
                                    },
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ClipRRect(
                                      child: Image.network(
                                        'http://${data.ipAddress}/api/getVoucherImg/${imgVoucher}',
                                        fit: BoxFit.cover,
                                        height: 120,
                                        width: 120,
                                      ),
                                    ),
                                    Expanded(child: Container(
                                      padding: EdgeInsets.all(10),
                                      color: Colors.white,
                                      width: MediaQuery.sizeOf(context).width*50/100,
                                      height: 120,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${nameVoucher}',
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.access_time,
                                                color: Colors.grey, // Màu xám
                                                size: 14, // Kích thước icon
                                              ),
                                              SizedBox(width: 5), // Khoảng cách giữa icon và chữ
                                              Text(
                                                '${'${expDate}'}',
                                                style: TextStyle(
                                                  color: Colors.grey, // Màu xám
                                                  fontSize: 14, // Cỡ chữ
                                                ),
                                              ),
                                            ],
                                          ),

                                        ],),
                                    ),),
                                    SizedBox(height: 130)
                                  ],
                                ),
                              );
                            else
                              return SizedBox.shrink();
                          },
                        );
                      } else if (snapshot.hasError) {
                        print(snapshot.error);
                        return Text('Error: ${snapshot.error}');
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Đổi voucher',
                        style: TextStyle(
                          color: Colors.black, // Màu chữ đen
                          fontWeight: FontWeight.bold, // Chữ đậm
                          fontSize: 18,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFF99)), // Nền màu vàng nhạt
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0), // Bo viền container
                            ),
                          ),
                        ),
                        child: Text(
                          'Xem tất cả',
                          style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder<List>(
                    future: data.getListRedeemVoucher(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        WidgetsBinding.instance!.addPostFrameCallback((_) async {
                          voucherCon.isLoadingRedeem.value = false;
                        });
                        if(snapshot.data!.length==0)
                          return Text('Hiện chưa có voucher nào',
                            style: TextStyle(fontSize: 15),
                          );
                        else
                          return ListView.builder(
                            shrinkWrap: true, // Cho phép tự động wrap
                            physics: NeverScrollableScrollPhysics(), // Thêm dòng này
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              var codeVoucher = snapshot.data![index]['code_voucher'];
                              var nameVoucher = snapshot.data![index]['name_voucher'];
                              var imgVoucher = snapshot.data![index]['img_voucher'];
                              var discount = snapshot.data![index]['discount'];
                              var redeemPoint = snapshot.data![index]['redeem_point'].toString();

                              DateTime dateTime = DateTime.parse(snapshot.data![index]['exp_date']);
                              var expDate = DateFormat('dd/MM/yyyy').format(dateTime);

                              return GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true, // Cho phép cuộn nội dung khi vượt qua kích thước màn hình
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // Bo góc trên của BottomSheet
                                    ),
                                    builder: (BuildContext context) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0),
                                          ),
                                        ),
                                        height: MediaQuery.of(context).size.height * 0.95,
                                        child: DetailRedeemVoucherScreen(codeVoucher: codeVoucher),
                                      );
                                    },
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ClipRRect(
                                      child: Image.network(
                                        'http://${data.ipAddress}/api/getVoucherImg/${imgVoucher}',
                                        fit: BoxFit.cover,
                                        height: 120,
                                        width: 120,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        color: Colors.white,
                                        width: MediaQuery.sizeOf(context).width * 50 / 100,
                                        height: 120,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${nameVoucher}',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.access_time,
                                                      color: Colors.grey, // Màu xám
                                                      size: 14, // Kích thước icon
                                                    ),
                                                    SizedBox(width: 5), // Khoảng cách giữa icon và chữ
                                                    Text(
                                                      '${expDate}',
                                                      style: TextStyle(
                                                        color: Colors.grey, // Màu xám
                                                        fontSize: 14, // Cỡ chữ
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: 50,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20), // Bo tròn cả 4 góc
                                                    color: Colors.lightBlue[100], // Nền xanh nhạt
                                                  ),
                                                  child: Text(
                                                    '$redeemPoint',
                                                    style: TextStyle(
                                                      color: Colors.blue, // Màu xanh đậm
                                                      fontSize: 14, // Cỡ chữ
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 130)
                                  ],
                                ),
                              );

                            },
                          );
                      } else if (snapshot.hasError) {
                        print(snapshot.error);
                        return Text('Error: ${snapshot.error}');
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}