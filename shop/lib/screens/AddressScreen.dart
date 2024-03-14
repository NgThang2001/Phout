import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop/AuthService.dart';
import 'package:shop/screens/UpdateAddressScreen.dart';
import 'package:shop/screens/LocationPickerScreen.dart';

import '../API.dart';
import '../CustomBottomNavigationBar.dart';
import '../model/AddressModel.dart';
import 'AddAddressScreen.dart';
import 'LoadingScreen.dart';

AddressModel addressModel = Get.put(AddressModel());

class AddressController extends GetxController {
  var locationCoor;
  Future<List> getAddress () async {
    List<dynamic> result = [];
    result = await addressModel.getListUserAddress(AuthService.getIdUser());
    return result;
  }
  var isLoading = true.obs;

}

class AddressScreen extends StatelessWidget {

  Data data = Get.put(Data());
  var addCon = Get.put(AddressController());

  @override
  Widget build(BuildContext context) {


    return Stack(
      children: [
        Scaffold(
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
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.to(AddAddressScreen());
                    },
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Icon(Icons.add),
                        ),
                        Expanded(
                          flex: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Thêm địa chỉ mới',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14
                                ),
                              ),
                            ],
                          ),
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
                    // endIndent: 0,
                  ),
                  SizedBox(height: 15,),
                  FutureBuilder<List>(
                    future: addCon.getAddress(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        WidgetsBinding.instance!.addPostFrameCallback((_) async {
                          addCon.isLoading.value = false;
                        });
                        if(snapshot.data!.length > 0)
                          return ListView.builder(
                            shrinkWrap: true, // Cho phép tự động wrap
                            physics: NeverScrollableScrollPhysics(), // Thêm dòng này
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              String idAddress = snapshot.data![index]['id_address'].toString();
                              String nameAdress = snapshot.data![index]['name_address'];
                              String detailAddress = snapshot.data![index]['detail_address'];
                              String receiver = snapshot.data![index]['receiver'];
                              String phone = snapshot.data![index]['phone_receiver'];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  SizedBox(height: 10,),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(UpdateAddressScreen(idAddress: idAddress));
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
                                                '$nameAdress',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14
                                                ),
                                              ),
                                              SizedBox(height: 5,),
                                              Text(
                                                '$detailAddress',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12
                                                ),
                                              ),
                                              SizedBox(height: 5,),
                                              Text(
                                                '$receiver - $phone',
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
                                          child: Icon(
                                            Icons.edit, color: Colors.orange,
                                          ),
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
                                    // endIndent: 0,
                                  ),
                                ],
                              );
                            },
                          );
                        else
                          return Text('Bạn chưa có địa chỉ nào',
                            style: TextStyle(fontSize: 15),
                          );
                      } else if (snapshot.hasError) {
                        print(snapshot.error);
                        return Text('Error: ${snapshot.error}');
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                ],
              )

          ),
          bottomNavigationBar: CustomBottomNavigationBar(),
        ),
        Obx(() => Visibility(
          visible: addCon.isLoading.value ? true : false,
          child: LoadingScreen(),
        ),)
      ],
    );
  }
}
