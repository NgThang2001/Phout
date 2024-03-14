import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:shop/screens/FavoriteProductScreen.dart';
import '../API.dart';
import '../CustomBottomNavigationBar.dart';
import '../model/ProductModel.dart';
import 'DetailProductScrenn.dart';
import 'LoadingScreen.dart';
import 'SearchScreen.dart';

class OrderScreenController extends GetxController {
  var isLoadingCategory1 = true.obs;
  var isLoadingCategory2 = true.obs;
  var isLoadingCategory3 = true.obs;
  var isLoadingProduct = true.obs;

  bool isLoading () {
    if(
      isLoadingCategory2.value == false &&
      isLoadingCategory3.value == false &&
      isLoadingProduct.value == false
    )
    {
      return false;
    }
    else {
      return true;
    }
  }

}

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NumberFormat formatter = NumberFormat('#,###');
    var productModel = Get.put(ProductModel());
    var orderCon = Get.put(OrderScreenController());
    orderCon.isLoadingCategory1.value = true;
    orderCon.isLoadingCategory2.value = true;
    orderCon.isLoadingCategory3.value = true;
    orderCon.isLoadingProduct.value = true;
    var _showAppBarTitle = 'Danh mục'.obs;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            elevation: 0.7,
            backgroundColor: Colors.white, // Nền trắng
            automaticallyImplyLeading: false, // Ẩn nút back trên Appbar
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Phần căn trái chứa dropdown
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Stack(
                          children: [
                            Column(
                              children: [
                                AppBar(
                                  elevation: 0.1,
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  title: Row(
                                    children: [
                                      SizedBox(width: 30,),
                                      Expanded(
                                        child: Text(
                                          'Danh mục',
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.close, color: Colors.black,size: 20,),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                  automaticallyImplyLeading: false, // Ẩn nút back trên Appbar
                                ),
                                FutureBuilder<List>(
                                  future: productModel.getListCategory(),
                                  builder: (context, listCategory) {
                                    if (listCategory.hasData) {
                                      WidgetsBinding.instance!.addPostFrameCallback((_) async {
                                        orderCon.isLoadingCategory1.value = false;
                                      });
                                      return Container(
                                          alignment: Alignment.centerLeft,
                                          height: 250,
                                          child: GridView.builder(
                                            physics: BouncingScrollPhysics(),
                                            shrinkWrap: true, // Cho phép co dãn theo nội dung của GridView
                                            scrollDirection: Axis.horizontal,
                                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent: 150, // Kích thước tối đa của mỗi cột (đơn vị pixel)
                                              mainAxisSpacing: 10, // Khoảng cách giữa các dòng theo chiều dọc
                                              crossAxisSpacing: 10, // Khoảng cách giữa các cột theo chiều ngang
                                              childAspectRatio: 1.5, // Tỉ lệ giữa chiều rộng và chiều cao của mỗi item
                                            ),
                                            itemCount: listCategory.data!.length, // Số lượng mục
                                            itemBuilder: (context, index) {
                                              // Xây dựng mỗi mục ở đây
                                              var categoryName = listCategory.data![index]['name_category'];
                                              return Container(
                                                padding: EdgeInsets.all(5),
                                                child: Column(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(30), // Đặt bán kính của góc là 10 để tạo hình tròn
                                                      child: Image.network(
                                                          'http://${productModel.ipAddress}/api/getCategoryImg/${listCategory.data![index]['img_category']}',
                                                          height: 60,
                                                          width: 60,
                                                          fit: BoxFit.cover
                                                      ),
                                                    ),
                                                    SizedBox(height: 10,),
                                                    Text(
                                                      '${categoryName}',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          )
                                      );
                                    } else if (listCategory.hasError) {
                                      return Text('Error: ${listCategory.error}');
                                    }
                                    return CircularProgressIndicator();
                                  },
                                ),
                              ],
                            ),
                            Obx(() => Visibility(
                              visible: orderCon.isLoadingCategory1.value ? true : false,
                              child: LoadingScreen(),
                            ),)
                          ],
                        );
                      },
                    ).then((value) {
                      if (value != null) {
                        // Xử lý khi người dùng chọn một tùy chọn
                        print('Selected option: $value');
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Obx(() => Text(
                        '${_showAppBarTitle.value}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 18
                        ),
                      ),),
                      Icon(Icons.arrow_drop_down, color: Colors.black),
                    ],
                  ),
                ),

                // Phần căn phải chứa icon kính lúp và icon trái tim
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.to(SearchScreen());
                      },
                      icon: Icon(Icons.search, color: Colors.black,),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.to(FavoriteProductScreen());
                      },
                      icon: Icon(Icons.favorite_outline,color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: FutureBuilder<List>(
            future: productModel.getListCategory(),
            builder: (context, listCategory) {
              if (listCategory.hasData) {
                WidgetsBinding.instance!.addPostFrameCallback((_) async {
                  orderCon.isLoadingCategory2.value = false;
                });
                return InViewNotifierList(
                  physics: BouncingScrollPhysics(),
                  throttleDuration: const Duration(milliseconds: 0), // Đặt giá trị throttleDuration
                  shrinkWrap: true,
                  isInViewPortCondition: (double deltaTop, double deltaBottom, double vpHeight) {
                    return deltaTop < 30 && deltaBottom > 30;
                  },
                  itemCount: listCategory.data!.length+1,
                  builder: (context, indexCat) {
                    if(indexCat == 0 ) {
                      return InViewNotifierWidget(
                        id: '${indexCat--}',
                        builder: (context, isInView, child) {
                          print(isInView);
                          if (isInView) {
                            WidgetsBinding.instance!.addPostFrameCallback((_) {
                              _showAppBarTitle.value = 'Danh mục';
                            });
                          }
                          return Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFCF8ED),// Màu nền của container
                                        borderRadius: BorderRadius.circular(10), // Đường viền cong
                                        border: Border.all(color: Colors.transparent), // Đường viền rỗng
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5), // Màu và độ mờ của bóng đổ
                                            spreadRadius: 1, // Kích thước của bóng đổ
                                            blurRadius: 5, // Độ mờ của bóng đổ
                                            offset: Offset(0, 0), // Vị trí của bóng đổ (không di chuyển)
                                          ),
                                        ],
                                      ),
                                      alignment: Alignment.centerLeft,
                                      width: MediaQuery.sizeOf(context).width,
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            FutureBuilder<List>(
                                              future: productModel.getListCategory(),
                                              builder: (context, listCategory) {
                                                if (listCategory.hasData) {
                                                  WidgetsBinding.instance!.addPostFrameCallback((_) async {
                                                    orderCon.isLoadingCategory3.value = false;
                                                  });
                                                  return Container(
                                                      alignment: Alignment.centerLeft,
                                                      height: 250,
                                                      child: GridView.builder(
                                                        physics: BouncingScrollPhysics(),
                                                        shrinkWrap: true, // Cho phép co dãn theo nội dung của GridView
                                                        scrollDirection: Axis.horizontal,
                                                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                                          maxCrossAxisExtent: 150, // Kích thước tối đa của mỗi cột (đơn vị pixel)
                                                          mainAxisSpacing: 10, // Khoảng cách giữa các dòng theo chiều dọc
                                                          crossAxisSpacing: 10, // Khoảng cách giữa các cột theo chiều ngang
                                                          childAspectRatio: 1.5, // Tỉ lệ giữa chiều rộng và chiều cao của mỗi item
                                                        ),
                                                        itemCount: listCategory.data!.length, // Số lượng mục
                                                        itemBuilder: (context, index) {
                                                          // Xây dựng mỗi mục ở đây
                                                          var categoryName = listCategory.data![index]['name_category'];
                                                          return Container(
                                                            padding: EdgeInsets.all(5),
                                                            child: Column(
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius: BorderRadius.circular(30), // Đặt bán kính của góc là 10 để tạo hình tròn
                                                                  child: Image.network(
                                                                      'http://${productModel.ipAddress}/api/getCategoryImg/${listCategory.data![index]['img_category']}',
                                                                      height: 60,
                                                                      width: 60,
                                                                      fit: BoxFit.cover
                                                                  ),
                                                                ),
                                                                SizedBox(height: 10,),
                                                                Text(
                                                                  '${categoryName}',
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 12,
                                                                  ),
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      )
                                                  );
                                                } else if (listCategory.hasError) {
                                                  return Text('Error: ${listCategory.error}');
                                                }
                                                return CircularProgressIndicator();
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                  )
                              ),
                            ],
                          );
                        },
                      );
                    }
                    return InViewNotifierWidget(
                      id: '${indexCat--}',
                      builder: (context, isInView, child) {
                        if (isInView) {
                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            _showAppBarTitle.value = '${listCategory.data![indexCat]['name_category']}';
                          });
                        }
                        var id_category = listCategory.data![indexCat]['id_category'];
                        var name_category = listCategory.data![indexCat]['name_category'];

                        return Padding(padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              FutureBuilder<List>(
                                future: productModel.getListProductByCategory(id_category),
                                builder: (context, listProduct) {
                                  WidgetsBinding.instance!.addPostFrameCallback((_) async {
                                    orderCon.isLoadingProduct.value = false;
                                  });
                                  if (listProduct.hasData) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '${name_category}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18
                                            )
                                        ),
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
                                    return Text('Error fetching products');
                                  }
                                  return CircularProgressIndicator();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              } else if (listCategory.hasError) {
                // Log the error to console
                print('Error fetching categories: ${listCategory.error}');
                // Display an error message widget
                return Text('Error fetching categories');
              }
              return CircularProgressIndicator();
            },
          ),
          bottomNavigationBar: CustomBottomNavigationBar(),
        ),
        Obx(() => Visibility(
          visible: orderCon.isLoading() ? true : false,
          child: LoadingScreen(),
        ),)
      ],
    );
  }
}