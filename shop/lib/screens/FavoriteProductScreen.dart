import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shop/AuthService.dart';
import 'package:shop/main.dart';
import '../API.dart';
import '../CustomBottomNavigationBar.dart';
import '../model/ProductModel.dart';
import 'DetailProductScrenn.dart';

class FavoriteProductScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    Data data = Get.put(Data());
    var productModel = Get.put(ProductModel());


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
          'Sản phẩm yêu thích',
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
            future: productModel.getListUserFavorite(AuthService.getIdUser()),
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
                                          Text(priceProduct.toString(),
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
                          );
                          },
                      ),
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