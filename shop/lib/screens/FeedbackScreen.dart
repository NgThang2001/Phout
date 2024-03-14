import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop/screens/UpdateAddressScreen.dart';
import 'package:shop/screens/LocationPickerScreen.dart';

import '../API.dart';
import '../CustomBottomNavigationBar.dart';
import 'AddAddressScreen.dart';
import 'dart:io';


class FeedbackScreen extends StatelessWidget {
  RxList<File> imgList = <File>[].obs;

  Data data = Get.put(Data());

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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Đối với Phout, mọi góp y của bạn đều quý giá',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              maxLines: 10,// Đặt maxLines thành null để cho phép nhập nhiều dòng
              keyboardType: TextInputType.multiline, // Đặt kiểu bàn phím thành TextInputType.multiline
              decoration: InputDecoration(
                hintText: 'Chia sẻ cảm nghĩ của bạn về ứng dụng cho Phout tại đây',
                border: OutlineInputBorder(), // Đặt bo viền cho TextField
              ),
            ),
            SizedBox(height: 10,),
            Container(
              height: 100,
              child:
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextButton(
                      onPressed: () {
                        if(imgList.length<3)
                        {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Wrap(
                                children: <Widget>[
                                  ListTile(
                                    leading: Icon(Icons.photo_library),
                                    title: Text('Chọn ảnh từ thư viện'),
                                    onTap: () async {
                                      final picker = ImagePicker();
                                      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                                      if (pickedFile != null) {
                                        // _image?.value = File(pickedFile.path);
                                        imgList.add(File(pickedFile.path));
                                        Get.back();
                                      } else {
                                        print('No image selected.');
                                      }
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.camera_alt),
                                    title: Text('Chụp ảnh mới'),
                                    onTap: () async {
                                      final picker = ImagePicker();
                                      final pickedFile = await picker.pickImage(source: ImageSource.camera);
                                      if (pickedFile != null) {
                                        imgList.add(File(pickedFile.path));
                                        Get.back();
                                      } else {
                                        print('No image selected.');
                                      }
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.cancel),
                                    title: Text('Hủy'),
                                    onTap: () {
                                      Get.back();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        else
                        {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Có lỗi'),
                                content: Text('Bạn được tải lên tối đa 3 hình ảnh'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }

                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(15)), // Thêm padding 16px cho tất cả các cạnh
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.black), // Màu chữ
                        overlayColor: MaterialStateProperty.all<Color>(Colors.transparent), // Màu nền khi nhấn
                        side: MaterialStateProperty.all<BorderSide>(BorderSide(color: Colors.grey, width: 0.3)), // Viền
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.camera), // Biểu tượng máy ảnh
                          SizedBox(height: 8), // Khoảng cách giữa biểu tượng và văn bản
                          Text('Tải lên \nhình ảnh',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ), // Văn bản "Tải lên hình ảnh"
                        ],
                      ),
                    ),),
                    SizedBox(width: 10,),
                    Expanded(
                      flex: 7,
                      child: Obx(() => ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: imgList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    color: Colors.red,
                                    width: 100,
                                    height: 100,
                                    child: Image.file(
                                      imgList[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey, // Màu nền của nút
                                        ),
                                        child: IconButton(

                                          icon: Icon(Icons.close, color: Colors.white),
                                          onPressed: () {
                                            // Xóa ảnh khỏi danh sách khi nút được nhấn
                                            imgList.removeAt(index);
                                          },
                                          
                                          iconSize: 15, // Kích thước của biểu tượng
                                        ),
                                      )

                                  ),
                                ],
                              ),


                              SizedBox(width: 10)
                            ],
                          );
                        },
                      )),
                    )




                  ],
                )

            ),




          ],
        )

      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.all(20), // Padding cho phần nội dung bên trong BottomAppBar
          child: TextButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Wrap(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.photo_library),
                        title: Text('Chọn ảnh từ thư viện'),
                        onTap: () async {
                          final picker = ImagePicker();
                          final pickedFile = await picker.pickImage(source: ImageSource.gallery);

                          if (pickedFile != null) {
                            // _image?.value = File(pickedFile.path);
                            imgList.add(File(pickedFile.path));
                            Get.back();
                          } else {
                            print('No image selected.');
                          }
                          print(imgList.length);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.camera_alt),
                        title: Text('Chụp ảnh mới'),
                        onTap: () async {
                          final picker = ImagePicker();
                          final pickedFile = await picker.pickImage(source: ImageSource.camera);
                          if (pickedFile != null) {
                            imgList.add(File(pickedFile.path));
                            Get.back();

                          } else {
                            print('No image selected.');
                          }
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.cancel),
                        title: Text('Hủy'),
                        onTap: () {
                          Navigator.pop(context); // Đóng bottom sheet khi nhấn nút "Hủy"
                        },
                      ),
                    ],
                  );
                },
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.orange), // Màu nền của nút
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Màu chữ của nút
              side: MaterialStateProperty.all<BorderSide>( // Viền của nút
                BorderSide(color: Colors.white, width: 1.0),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>( // Bo viền của nút
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(12.0)), // Padding của nút
            ),
            child: Text('Gửi phản hồi'), // Văn bản của nút
          ),
        ),
      ),

    );
  }
}
