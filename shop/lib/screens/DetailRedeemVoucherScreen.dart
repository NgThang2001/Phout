import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../API.dart';
import '../CustomBottomNavigationBar.dart';


class DetailRedeemVoucherScreen extends StatelessWidget {
  var codeVoucher;
  DetailRedeemVoucherScreen({required this.codeVoucher});

  var pointRedeem = ''.obs;
  Data data = Get.put(Data());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  child:
                  FutureBuilder<List>(
                    future: data.getRedeemVoucherDetail(codeVoucher),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var codeVoucher = snapshot.data![0]['code_voucher'];
                        var nameVoucher = snapshot.data![0]['name_voucher'];
                        var imgVoucher = snapshot.data![0]['img_voucher'];
                        var discount = snapshot.data![0]['discount'];
                        var detail = snapshot.data![0]['detail_redeem'];
                        var point = snapshot.data![0]['redeem_point'].toString();
                        pointRedeem.value = point;
                        return Column(
                          children: [
                            Stack(
                              clipBehavior: Clip.none, // Loại bỏ việc cắt bớt
                              children: [
                                ClipRRect(

                                  child: Image.network(
                                    'http://${data.ipAddress}/api/getVoucherImg/${imgVoucher}',
                                    height: 400,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  bottom: -60,
                                  left: 15,
                                  right: 15,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(20),
                                          child: Image.network(
                                            'http://${data.ipAddress}/api/getVoucherImg/${imgVoucher}',
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Container(
                                          height: 120,
                                          padding: EdgeInsets.all(25),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn các widget chân chất của Column
                                            children: [
                                              Text(nameVoucher,
                                                style: TextStyle(
                                                    fontSize: 16
                                                ),
                                              ),
                                              Text(nameVoucher,
                                                style: TextStyle(
                                                    fontSize: 16
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 60,),
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Quy đổi với',
                                          style: TextStyle(
                                              fontSize: 16
                                          ),
                                        ),
                                        Text('$point Phout++',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text('Thời hạn quy đổi',
                                          style: TextStyle(
                                              fontSize: 16
                                          ),
                                        ),
                                        Text('$point Phout++',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child:  Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Quy đổi với',
                                      style: TextStyle(
                                          fontSize: 16
                                      ),
                                    ),
                                    Text('$detail',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      }
                      else if (snapshot.hasError) {
                        print(snapshot.error);
                        return Text('Error: ${snapshot.error}');
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                ),
                SizedBox(height: 100,)
              ],
            )
          ),
          Positioned(
            top: 15,
            right: 15,
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.5),
              ),
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white, size: 18,),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            right: 20,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.orange,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Obx(() => Text(
                      'Đổi ${pointRedeem.value} Phout++ \nlấy voucher này',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),)
                  ),
                  TextButton(
                    onPressed: () {
                      // Xử lý khi nút được nhấn
                    },
                    child: Text(
                      'Đổi Voucher', // Văn bản của nút
                      style: TextStyle(
                        color: Colors.orange, // Màu chữ là màu cam
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white, // Màu nền là trắng
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Bo tròn cả 4 góc
                        side: BorderSide(color: Colors.orange), // Viền màu cam
                      ),
                    ),
                  )

                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}