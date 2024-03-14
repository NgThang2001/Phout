import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../model/ProductModel.dart';
import 'DetailProductScrenn.dart';
import 'OrderConfirmScreen.dart';

class SearchScreen extends StatelessWidget {
  NumberFormat formatter = NumberFormat('#,###');
  final FocusNode _focusNode = FocusNode();
  var productModel = Get.put(ProductModel());
  var searchText = ' '.obs;
  var textController = TextEditingController();
  // Future<List> search () async {
  //   return await productModel.searchProduct(searchText);
  // }

  var count = 0;


  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance!.addPostFrameCallback((_) => _focusNode.requestFocus());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0,
        automaticallyImplyLeading: false, // Ẩn nút back mặc định
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0), // Khoảng cách từ mép sang TextField
          child: TextField(
            controller: textController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              filled: true, // Cho phép điền màu nền
              fillColor: Colors.grey[100], // Màu nền của TextField
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              hintText: 'Tìm kiếm...', // Text hiển thị khi không có text
              prefixIcon: Icon(Icons.search), // Icon tìm kiếm ở đầu
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10), // Bo tròn góc với bán kính 10.0
              ),
            ),
            onChanged: (String text) {
              searchText.value = text ?? ' ';
              print(text);
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Đóng màn hình tìm kiếm và quay lại trang trước
              Get.back();
            },
            child: Text(
              'Hủy',
              style: TextStyle(
                color: Colors.orange, // Màu chữ của nút "Hủy"
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child:Obx(() => FutureBuilder<List>(
                  future: productModel.searchProduct(searchText.value),
                  builder: (context, listProduct) {
                    if (listProduct.hasData) {
                      if(listProduct.data!.length == 0)
                        return SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15,),
                          Container(
                            child: ListView.builder(
                              shrinkWrap: true, // Cho phép co dãn theo nội dung của GridView
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: listProduct.data!.length,
                              itemBuilder: (context, indexProduct) {
                                var idProduct = listProduct.data![indexProduct]['id_product'];
                                var imgProduct = listProduct.data![indexProduct]['img_product'];
                                var nameProduct = listProduct.data![indexProduct]['name_product'];
                                var priceProduct = listProduct.data![indexProduct]['price_product'];
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true, // Cho phép cuộn nội dung khi vượt qua kích thước màn hình
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // Bo góc trên của BottomSheet
                                        ),
                                        builder: (BuildContext context) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                topRight: Radius.circular(10.0),
                                              ),
                                            ),
                                            height: MediaQuery.of(context).size.height * 0.95,
                                            child: DetailProductScreen(idProduct: idProduct),
                                          );
                                        },
                                      );
                                    },
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 145,),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10), // Bo tròn góc của hình ảnh
                                          child: Image.network(
                                            'http://${productModel.ipAddress}/api/getProductImg/${imgProduct}',
                                            fit: BoxFit.cover,
                                            height: 135,
                                            width: 135,
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Expanded(
                                            flex: 8,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 10,),
                                                Text(nameProduct,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold
                                                  ) ,
                                                ),
                                                Text(
                                                  '${formatter.format(priceProduct).replaceAll(',', '.').toString()}đ',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ) ,
                                                )
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 30,),
                                                Container(
                                                  width: 35,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle, // Hình dạng hình tròn
                                                    color: Colors.orange, // Màu nền trắng
                                                  ),
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 20,
                                                    color: Colors.white, // Màu cam cho biểu tượng
                                                  ),
                                                )],
                                            )
                                        ),

                                      ],
                                    ), // Widget mà bạn muốn áp dụng GestureDetector
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
                      return Text('Error fetching products ${listProduct.error}');
                    }
                    return Center(child: CircularProgressIndicator(),);
                  },
                )),
              )
          ),
          // Positioned(
          //   bottom: 10,
          //   right: 10,
          //   child: GestureDetector(
          //     onTap: () {
          //       showModalBottomSheet(
          //         context: context,
          //         isScrollControlled: true,
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // Bo góc trên của BottomSheet
          //         ),
          //         builder: (BuildContext context) {
          //           return Container(
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.only(
          //                 topLeft: Radius.circular(10.0),
          //                 topRight: Radius.circular(10.0),
          //               ),
          //             ),
          //             height: MediaQuery.of(context).size.height * 0.95,
          //             child: OrderConfirmationScreen(),
          //           );
          //         },
          //       );
          //     },
          //     child: Cart(),
          //   ),
          // ),
        ],
      )
    );
  }
}
