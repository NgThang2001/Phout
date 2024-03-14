import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shop/AuthService.dart';
import 'package:shop/main.dart';
import '../API.dart';
import '../CustomBottomNavigationBar.dart';
import '../model/LoginModel.dart';


class DetailProductScreen extends StatelessWidget {
  var idProduct;
  DetailProductScreen({required this.idProduct});
  RxInt quantity = 1.obs;
  Data data = Get.put(Data());
  var userModel = Get.put(UserModel());
  var noteCon = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              decoration: BoxDecoration(

                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              child:
              FutureBuilder<List>(
                future: data.getProductDetail(idProduct),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var imgProduct = snapshot.data![0]['img_product'];
                    var nameProduct = snapshot.data![0]['name_product'];
                    var priceProduct = snapshot.data![0]['price_product'];
                    var desProduct = snapshot.data![0]['des_product'];
                    return Column(
                      children: [
                        ClipRRect(

                          child: Image.network(
                            'http://${data.ipAddress}/api/getProductImg/${imgProduct}',
                            height: 400,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(nameProduct,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        // In the screen you're navigating to:
                                        var data = Get.parameters['data'];
                                        print(data);
                                      },
                                      icon: Icon(Icons.favorite_outline),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${formatter.format(priceProduct).replaceAll(',', '.').toString()}đ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Text(
                                  desProduct,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            )
                        ),
                        Container(
                          height: 10,
                          color: Colors.grey[200],
                        ),
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text('Ghi chú',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 20,),
                                TextField(
                                  controller: noteCon,
                                  decoration: InputDecoration(
                                    hintText: 'Thêm ghi chú',
                                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13), // Thiết lập màu cho hint
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(color: Colors.grey), // Thiết lập màu cho viền
                                    ),
                                    contentPadding: EdgeInsets.all(10), // Điều chỉnh độ cao
                                  ),
                                ),
                              ],
                            )
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(width: 0.5, color: Colors.black), // Chỉ hiển thị viền phía trên, bạn có thể thay đổi màu sắc và độ dày theo ý muốn
          ),
        ),
        padding: EdgeInsets.all(10),
        child: Container(

          height: 55, // Độ cao của container
          child: Row(
            children: [
              Container(
                width: 35, // Chiều rộng của Container
                height: 35, // Chiều cao của Container
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // Hình dạng của Container là hình tròn
                  color: Colors.yellow, // Màu nền của Container là màu vàng
                ),
                child: Center(
                  child: IconButton(
                    icon: Icon(Icons.remove, color: Colors.orange, size: 15,), // Biểu tượng là dấu trừ và màu cam
                    onPressed: () {
                      quantity--;
                      if(quantity.value<1)
                        quantity.value = 1;
                    },
                  ),
                ),
              ),
              Obx(() => Text(
                '\t ${quantity} \t',
                style: TextStyle(
                    fontSize: 15
                ),

              ),),
              Container(
                width: 35, // Chiều rộng của Container
                height: 35, // Chiều cao của Container
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // Hình dạng của Container là hình tròn
                  color: Colors.yellow, // Màu nền của Container là màu vàng
                ),
                child: Center(
                  child: IconButton(
                    icon: Icon(Icons.add, color: Colors.orange, size: 15,), // Biểu tượng là dấu trừ và màu cam
                    onPressed: () {
                      quantity++;
                    },
                  ),
                ),
              ),
              SizedBox(width: 40,),
              Expanded(
                  child: TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(15)), // Đặt padding cho TextButton
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrangeAccent), // Màu nền của TextButton
                    ),
                    onPressed: () async {
                      Map<String, dynamic> cartData = {
                        'id_user' : AuthService.getIdUser(),
                        'id_product' : idProduct,
                        'note_cart' : noteCon.text ?? '',
                        'quantity' : quantity.value
                      };
                      var createStt = await userModel.createCartUser(cartData);
                      if(createStt == 201)
                        {
                          var homeCon = Get.put(HomeControler());
                          homeCon.getData();
                          Get.back();
                        }
                      else {
                        final snackBar = SnackBar(
                          content: Text('Đã xảy ra lỗi, hãy thử lại'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Text(
                      'Chọn - ${quantity}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
              ),
            ],
          ),
        ),
      )
    );
  }
}