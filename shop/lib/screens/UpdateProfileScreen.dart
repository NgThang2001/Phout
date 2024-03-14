import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shop/AuthService.dart';
import 'package:shop/screens/LocationPickerScreen.dart';
import 'dart:io';

import '../API.dart';
import '../CustomBottomNavigationBar.dart';
import '../DTO/UserDTO.dart';


class UpdateProfileScreen extends StatelessWidget {
  Data data = Get.put(Data());

  Rx<File?> _image = Rx<File?>(null);




  @override
  Widget build(BuildContext context) {
    Rx<DateTime> _selectedDate = DateTime.now().obs;
    var firstNameCon = TextEditingController();
    var lastNameCon = TextEditingController();
    var birthDayCon = TextEditingController();
    var emailCon = TextEditingController();

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate.value,
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      );
      if (picked != null && picked != _selectedDate) {
        _selectedDate.value = picked;
        int day = picked.day;
        int month = picked.month;
        int year = picked.year;
        birthDayCon.text = '$day/$month/$year';
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black), // Màu của icon
        title: Text(
          'Cập nhật thông tin',
          style: TextStyle(color: Colors.black), // Màu của tiêu đề
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: FutureBuilder<List>(
          future: data.getUserDetail(AuthService.getIdUser()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              firstNameCon.text = snapshot.data?[0]['first_name'] ?? '';
              lastNameCon.text = snapshot.data?[0]['last_name'] ?? '';
              if(snapshot.data![0]['birth_day']!=null) {
                DateTime? dateTime = DateTime.parse(snapshot.data![0]['birth_day']);
                birthDayCon.text = DateFormat('dd/MM/yyyy').format(dateTime);
              }

              emailCon.text = snapshot.data?[0]['email'] ?? '';
              var gender = snapshot.data?[0]['gender'] ?? 'Khác';
              var imgUser = snapshot.data?[0]['img_user'] ?? 'default_avatar.png';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
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
                                  print(pickedFile?.path);
                                  if (pickedFile != null) {
                                    _image?.value = File(pickedFile.path);
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
                                    _image?.value = File(pickedFile.path);
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
                    child:  Stack(
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          child: ClipOval(
                            child: Obx(() => _image?.value == null
                                ? Image.network('http://${data.ipAddress}/api/getUserImg/$imgUser',
                              fit: BoxFit.cover,
                            )
                                : Image.network('http://${data.ipAddress}/api/getUserImg/default_avatar.jpg',
                              fit: BoxFit.cover,
                            ),)
                          ),
                        ),


                        Positioned(
                          bottom: -0,
                          right: -0,
                          child: Icon(Icons.add_a_photo),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: firstNameCon,
                    decoration: InputDecoration(
                      hintText: 'Tên',
                      hintStyle: TextStyle(
                          color: Colors.grey
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.orange, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: lastNameCon,
                    decoration: InputDecoration(
                      hintText: 'Họ',
                      hintStyle: TextStyle(
                          color: Colors.grey
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.orange, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: TextField(
                        enabled: false,
                        controller: birthDayCon,
                        decoration: InputDecoration(
                          hintText: 'Ngày sinh',
                          prefixIcon: Icon(Icons.date_range),
                          hintStyle: TextStyle(
                              color: Colors.grey
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.orange, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey, width: 1.0),
                          ),
                        ),
                      )


                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: emailCon,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(
                          color: Colors.grey
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.orange, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: gender,
                    decoration: InputDecoration(
                      hintText: 'Giới tính',
                      hintStyle: TextStyle(
                          color: Colors.grey
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.orange, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                    items: <String>['Nam', 'Nữ', 'Khác'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      // Xử lý khi người dùng chọn giới tính
                    },
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      // Xử lý cập nhật tài khoản
                    },
                    child: Text('Cập nhật tài khoản'),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.orange), // Đổi màu nền của nút
                    ),
                  ),
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
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
