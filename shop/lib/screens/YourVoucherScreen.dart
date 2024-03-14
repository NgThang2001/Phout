import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:shop/AuthService.dart';
import '../API.dart';
import '../CustomBottomNavigationBar.dart';
import '../DTO/UserDTO.dart';
import '../model/LoginModel.dart';

class YourVoucherScreen extends StatelessWidget {
  Data data = Get.put(Data());
  var userInfo = Get.put(UserInfo());
  var userModel = Get.put(UserModel());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white, // Nền trắng
        elevation: 1, // Loại bỏ đường viền dưới của app bar
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Icon back màu đen
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Phiếu ưu đãi của bạn',
          style: TextStyle(
            color: Colors.black, // Chữ màu đen
            fontWeight: FontWeight.bold, // Chữ in đậm
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: FutureBuilder<List>(
            future: userModel.getListUserVoucher(AuthService.getIdUser()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true, // Cho phép tự động wrap
                  physics: NeverScrollableScrollPhysics(), // Thêm dòng này
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var codeVoucher = snapshot.data![index]['code_voucher'];
                    var nameVoucher = snapshot.data![index]['name_voucher'];
                    var imgVoucher = snapshot.data![index]['img_voucher'];

                    DateTime dateTime = DateTime.parse(snapshot.data![index]['exp_date']);
                    var expDate = DateFormat('dd/MM/yyyy').format(dateTime);

                    return Row(
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
        ),
      ), // Thay thế YourBodyWidget bằng nội dung của màn hình của bạn
    );
  }
}