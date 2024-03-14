import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../API.dart';
import 'DetailProductScrenn.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<List> getData() async {
      Data data = Get.put(Data());
      List<dynamic> result = await data.getDATA();
      return result;
    }
    Data data = Get.put(Data());


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
            'Thông báo',
            style: TextStyle(
              color: Colors.black, // Chữ màu đen
              fontWeight: FontWeight.bold, // Chữ in đậm
            ),
          ),
        ),
        body:  SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: FutureBuilder<List>(
                future: data.getListProduct(),
                builder: (context, listProduct) {
                  if (listProduct.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: ListView.builder(
                            shrinkWrap: true, // Cho phép co dãn theo nội dung của GridView
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: listProduct.data!.length,
                            itemBuilder: (context, indexProduct) {
                              var imgProduct = listProduct.data![indexProduct]['img_product'];
                              var nameProduct = listProduct.data![indexProduct]['name_product'];
                              var priceProduct = listProduct.data![indexProduct]['price_product'];
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: GestureDetector(
                                  onTap: () {

                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(height: 100,),
                                      Container(
                                        width: 90,
                                        height: 90,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10), // Bo viền
                                          border: Border.all(color: Colors.black, width: 1), // Viền đen kích thước 1px
                                        ),
                                        child: Image.asset(
                                          'assets/images/mon1.jpg', // Đường dẫn tới hình ảnh
                                          width: 90,
                                          height: 90,
                                          fit: BoxFit.cover, // Đảm bảo hình ảnh vừa khớp với kích thước của Container
                                        ),
                                      ),
                                      SizedBox(width: 10), // Khoảng cách giữa hình ảnh và các đoạn văn bản
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Chào bạn mới',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Chào mừng bạn đến với Phout',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(height: 15,),
                                          Text(
                                            '19/01/2024',
                                            style: TextStyle(
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                ),
                              );                              },
                          )

                          ,
                        )
                      ],
                    );
                  } else if (listProduct.hasError) {
                    // Log the error to console
                    print('Error fetching products: ${listProduct.error}');
                    // Display an error message widget
                    return Text('Error fetching products');
                  }
                  return CircularProgressIndicator();
                },
              ),
            )
        )
    );
  }
}