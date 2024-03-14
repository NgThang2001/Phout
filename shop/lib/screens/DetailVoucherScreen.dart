import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../API.dart';
import '../CustomBottomNavigationBar.dart';
import '../model/VoucherModel.dart';


class DetailVoucherScreen extends StatelessWidget {
  var codeVoucher;
  DetailVoucherScreen({required this.codeVoucher});

  var voucherModel = Get.put(VoucherModel());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[200],
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                padding: EdgeInsets.all(30),
                child:
                FutureBuilder<List>(
                  future: voucherModel.getVoucherDetail(codeVoucher),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var codeVoucher = snapshot.data![0]['code_voucher'];
                      var nameVoucher = snapshot.data![0]['name_voucher'];
                      var imgVoucher = snapshot.data![0]['img_voucher'];
                      var discount = snapshot.data![0]['discount'];
                      var detail = snapshot.data![0]['detail_voucher'];
                      var expDate = snapshot.data![0]['exp_date'];
                      return Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        width: double.infinity,
                        child: Column(
                          children: [
                            Text(
                              '${nameVoucher.toUpperCase()}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: 20,),
                            QrImageView(
                              data: '$codeVoucher',
                              version: QrVersions.auto,
                              size: 200,
                              gapless: false,
                            ),
                            SizedBox(height: 10,),
                            Text(
                              '$codeVoucher',
                              style: TextStyle(
                                  fontSize: 15,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: codeVoucher)); // Copy text to clipboard
                                // Show SnackBar to notify user that text has been copied
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Mã $codeVoucher đã được sao chép'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              child: Text('Sao chép'), // Button Text
                            ),
                            TextButton(
                              onPressed: () {
                                // Xử lý khi nút được nhấn
                              },
                              child: Text(
                                'Sử dụng ngay', // Văn bản của nút
                                style: TextStyle(
                                  color: Colors.white, // Màu chữ là trắng
                                ),
                              ),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                backgroundColor: Colors.black, // Màu nền là đen
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20), // Bo tròn viền
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.grey, // Màu của kẻ ngang
                              thickness: 1, // Độ dày của kẻ ngang
                              indent: 25,
                              endIndent: 25,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Ngày hết hạn:',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    '$expDate',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.grey, // Màu của kẻ ngang
                              thickness: 1, // Độ dày của kẻ ngang
                              indent: 25,
                              endIndent: 25,
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                              child: Text(
                                '$detail',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
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
          ],
        ),
    );
  }
}