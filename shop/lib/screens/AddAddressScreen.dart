import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop/AuthService.dart';
import 'package:shop/main.dart';
import 'package:shop/screens/LocationPickerScreen.dart';

import '../CustomBottomNavigationBar.dart';
import '../model/AddressModel.dart';
import 'AddressScreen.dart';


class AddAddressScreenCon extends GetxController {
  late LatLng locationCoor;
  var nameAddressCon = TextEditingController();
  var detailAddressTxt =  'Chọn địa chỉ'.obs;
  var buildingNamelAddressCon = TextEditingController();
  var noteCon = TextEditingController();
  var receiverCon = TextEditingController();
  var phoneCon = TextEditingController();
}

class AddAddressScreen extends StatelessWidget {
  var controller = Get.put(AddAddressScreenCon());
  var addScreenCon = Get.put(AddressController());
  var addressModel = Get.put(AddressModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black), // Màu của icon
        title: Text(
          'Địa chỉ đã lưu',
          style: TextStyle(color: Colors.black), // Màu của tiêu đề
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tên địa chỉ',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5,),
                      TextField(
                        controller: controller.nameAddressCon,
                        decoration: InputDecoration(
                          isDense: true, // Giảm chiều cao của TextField
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Giảm chiều cao của TextField
                          hintText: 'Nhà/ Cơ quan / Gym / ...',
                          hintStyle: TextStyle(
                              fontSize: 14
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 15,),
                      Text('Địa chỉ',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5,),
                      GestureDetector(
                        onTap: () {
                          Get.to(LocationPickerScreen());
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 9, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black, width: 0.5)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Obx(() => Text(
                                  '${controller.detailAddressTxt.value}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                )),
                              ),
                              Icon(Icons.keyboard_arrow_right),
                            ],
                          ),
                        )
                      ),
                      SizedBox(height: 15,),
                      Text('Tòa nhà, số tầng',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5,),
                      TextField(
                        controller: controller.buildingNamelAddressCon,
                        decoration: InputDecoration(
                          isDense: true, // Giảm chiều cao của TextField
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Giảm chiều cao của TextField
                          hintText: 'Tòa nhà, số tầng',
                          hintStyle: TextStyle(
                              fontSize: 14
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 15,),
                      Text('Ghi chú khác',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5,),
                      TextField(
                        controller: controller.noteCon,
                        decoration: InputDecoration(
                          isDense: true, // Giảm chiều cao của TextField
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Giảm chiều cao của TextField
                          hintText: 'Ghi chú, hướng dẫn giao hàng',
                          hintStyle: TextStyle(
                              fontSize: 14
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 15,),
                      Text('Tên người nhận ',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5,),
                      TextField(
                        controller: controller.receiverCon,
                        decoration: InputDecoration(
                          isDense: true, // Giảm chiều cao của TextField
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Giảm chiều cao của TextField
                          hintText: 'Tên người nhận',
                          hintStyle: TextStyle(
                              fontSize: 14
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 15,),
                      Text('Số điện thoại',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5,),
                      TextField(
                        controller: controller.phoneCon,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(

                          isDense: true, // Giảm chiều cao của TextField
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Giảm chiều cao của TextField
                          hintText: 'Số điện thoại',
                          hintStyle: TextStyle(
                              fontSize: 14
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 60,)
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 15,
            right: 15,
            child: TextButton(
            onPressed: () async {
              if (controller.nameAddressCon.text != '' &&
                  controller.detailAddressTxt.value != '' &&
                  controller.receiverCon.text != '' &&
                  controller.locationCoor != null &&
                  controller.phoneCon.text != '' )
                  {
                    Map<String, dynamic> addressData = {
                      'name_address' :  controller.nameAddressCon.text,
                      'detail_address' :  controller.detailAddressTxt.value,
                      'building_name' :  controller.buildingNamelAddressCon.text ?? '',
                      'note' :  controller.noteCon.text ?? '',
                      'receiver' :  controller.receiverCon.text,
                      'phone_receiver' :  controller.phoneCon.text,
                      'id_user' :  AuthService.getIdUser(),
                      'lat' :  controller.locationCoor.latitude,
                      'lng' :  controller.locationCoor.longitude,
                    };
                    var createSTT = await addressModel.createAddress(addressData);
                    if(createSTT==201)
                      {
                      controller.nameAddressCon.clear();
                      controller.detailAddressTxt.value = 'Chọn địa chỉ';
                      controller.buildingNamelAddressCon.clear();
                      controller.noteCon.clear();
                      controller.receiverCon.clear();
                      controller.phoneCon.clear();
                      controller.locationCoor = LatLng(0, 0);
                      Get.off(AddressScreen());
                    }
                    else
                    {
                      final snackBar = SnackBar(
                        content: Text('Có lỗi xảy ra'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 3),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  } else {
                final snackBar = SnackBar(
                  content: Text('Hãy điền đầy đủ thông tin'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 3),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            child: Text(
              'Xong',
              style: TextStyle(
                color: Colors.white, // Màu chữ là trắng
                fontSize: 16
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.orange, // Màu nền của nút là cam
              padding: EdgeInsets.all(15),
            ),
          ),)
        ],
      )

    );
  }
}
