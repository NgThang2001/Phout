import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop/screens/LocationPickerScreen.dart';

import '../API.dart';
import '../CustomBottomNavigationBar.dart';
import '../model/AddressModel.dart';
import 'AddressScreen.dart';


class UpdateAddressScreen extends StatelessWidget {
  var idAddress;
  UpdateAddressScreen({required this.idAddress});
  Data data = Get.put(Data());
  var addressModel = Get.put(AddressModel());

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black), // Màu của icon
          title: Text(
            'Sửa địa chỉ đã lưu',
            style: TextStyle(color: Colors.black), // Màu của tiêu đề
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: FutureBuilder<List>(
                future: addressModel.getAddressDetail(idAddress),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var nameAdressCon = TextEditingController();
                    var detailAddressCon = TextEditingController();
                    var buildingNameCon = TextEditingController();
                    var noteCon = TextEditingController();
                    var receiverCon = TextEditingController();
                    var phoneNumCon = TextEditingController();

                    print(snapshot.data![0]['name_address']);
                    nameAdressCon.text = snapshot.data![0]['name_address'] ?? '';
                    detailAddressCon.text = snapshot.data![0]['detail_address'] ?? '';
                    buildingNameCon.text = snapshot.data![0]['building_name'] ?? '';
                    noteCon.text = snapshot.data![0]['note'] ?? '';
                    receiverCon.text = snapshot.data![0]['receiver'] ?? '';
                    phoneNumCon.text = snapshot.data![0]['phone_receiver'] ?? '';

                    return Column(
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
                                controller: nameAdressCon,
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
                              TextField(
                                controller: detailAddressCon,
                                decoration: InputDecoration(
                                  isDense: true, // Giảm chiều cao của TextField
                                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Giảm chiều cao của TextField
                                  hintText: 'Chọn địa chỉ',
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
                              Text('Tòa nhà, số tầng',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5,),
                              TextField(
                                controller: buildingNameCon,
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
                                controller: noteCon,
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
                                controller: receiverCon,
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
                                controller: phoneNumCon,
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
                        Padding(padding: EdgeInsets.all(15),
                          child: GestureDetector(
                            onTap: () async {
                              var check = await addressModel.deleteAddress(idAddress);
                              if(check == true)
                                {
                                  Get.back();
                                }
                              else {
                                var snackBar = SnackBar(
                                  content: Text('Có lỗi xảy ra, hãy thử lại sau'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 3),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[300],
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.delete,
                                      color: Colors.red
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Xóa địa chỉ này',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 60,)
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
            Positioned(
              bottom: 0,
              left: 15,
              right: 15,
              child: TextButton(
                onPressed: () async {
                  var addCon = Get.put(AddressController());
                  await addCon.getAddress();
                  Get.back();
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
