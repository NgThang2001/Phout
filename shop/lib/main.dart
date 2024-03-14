import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:intl/intl.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:shop/AuthService.dart';
import 'package:shop/model/LoginModel.dart';
import 'package:shop/model/ProductModel.dart';
import 'package:shop/screens/DetailProductScrenn.dart';
import 'package:shop/screens/FavoriteProductScreen.dart';
import 'package:shop/screens/LoginScreen.dart';
import 'package:shop/screens/NotificationScreen.dart';
import 'package:shop/screens/OrderConfirmScreen.dart';
import 'package:shop/screens/OrderScreen.dart';
import 'package:shop/screens/SearchScreen.dart';
import 'package:shop/screens/SelectProduct.dart';
import 'package:shop/screens/SplashScreen.dart';
import 'package:shop/screens/VerifyOTPScreen.dart';
import 'package:shop/screens/YourVoucherScreen.dart';
import 'package:shop/screens/LoadingScreen.dart';
import 'package:shop/screens/tet1.dart';

import 'API.dart';
import 'CustomBottomNavigationBar.dart';
import 'DTO/UserDTO.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized(); // Đảm bảo Flutter binding đã được khởi tạo
  Platform.isAndroid
      ? await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyBwewILZ66MNNKjEx_2i_Kw5YK_bCp1AaU',
        appId: '1:695396938254:android:a418b4da528e0563c8c25f',
        messagingSenderId: '695396938254',
        projectId: 'phout-25f49',
      )
  )
      : await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Simple Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}



HomeControler homeCon = Get.put(HomeControler());
var userInfo = Get.put(UserInfo());
var userModel = Get.put(UserModel());
var productModel = Get.put(ProductModel());
NumberFormat formatter = NumberFormat('#,###');

Data data = Get.put(Data());

class HomeControler extends GetxController {
  var isLoadingAppBarName = true.obs;
  var isLoadingAppBarVoucher = true.obs;
  var isLoadingAppBarNotifi = true.obs;
  var isLoadingSlide = true.obs;
  var isLoadingSuggest = true.obs;
  var isLoadingCategory1 = true.obs;
  var isLoadingCategory2 = true.obs;
  var isLoadingListProduct = true.obs;
  var isLoadingCart = true.obs;
  var quantityProduct = 0.obs;
  var totalPrice = 0.obs;

  Future<void> getData() async {
    quantityProduct.value = 0;
    totalPrice.value = 0;
    await userModel.getListUserCart(AuthService.getIdUser());
    var users = await userModel.getListUserCart(AuthService.getIdUser());
    for(var dt in users){
      quantityProduct.value +=  dt['quantity'] as int;
      totalPrice.value += (dt['quantity'] * dt['price_product']) as int;
    }
  }

  bool isLoading () {
    if(
      isLoadingAppBarName.value == false &&
      isLoadingAppBarVoucher.value == false &&
      isLoadingAppBarNotifi.value == false &&
      isLoadingSlide.value == false &&
      isLoadingSuggest.value == false &&
      isLoadingCategory1.value == false &&
      isLoadingCategory2.value == false &&
      isLoadingListProduct.value == false
    )
    {
      return false;
    }
    else {
      return true;
    }
  }

  bool check () {
    return true;
  }

  @override
  void onInit() {
    super.onInit();
  }


}

class MyHomePage extends StatelessWidget {
  var _showAppBarTitle = 'Chao xìn'.obs;
  var getUser = AuthService.getIdUser();
  var userName = ''.obs;

  @override
  Widget build(BuildContext context) {
    homeCon.isLoadingAppBarName = true.obs;
    homeCon.isLoadingAppBarVoucher = true.obs;
    homeCon.isLoadingAppBarNotifi = true.obs;
    homeCon.isLoadingSlide = true.obs;
    homeCon.isLoadingSuggest = true.obs;
    homeCon.isLoadingCategory1 = true.obs;
    homeCon.isLoadingCategory2 = true.obs;
    homeCon.isLoadingListProduct = true.obs;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Color(0xFFFCF8ED), // Sử dụng mã màu hex và phương thức Color để đặt màu
          body: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                    automaticallyImplyLeading: false, // Ẩn nút back trên Appbar
                    floating: true,
                    snap: true,
                    backgroundColor: Color(0xFFFCF8ED),
                    title: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FutureBuilder<List>(
                              future: userModel.getDetailUser(AuthService.getIdUser()),
                              builder: (context, detailUser){
                                if (detailUser.hasData)
                                {
                                  WidgetsBinding.instance!.addPostFrameCallback((_) async {
                                    homeCon.isLoadingAppBarName.value = false;
                                  });
                                  userName.value = detailUser.data![0]['first_name'];
                                  _showAppBarTitle.value = 'Xin chào ${userName.value}';
                                  return Obx(() => Text('${_showAppBarTitle.value}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),),);
                                }
                                else if (detailUser.hasError) {
                                  // Log the error to console
                                  print('Error fetching categories: ${detailUser.error}');
                                  // Display an error message widget
                                  return Text('Error fetching categories');
                                }
                                return CircularProgressIndicator();
                              }
                          ),
                          Row(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(YourVoucherScreen());
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.confirmation_number_outlined, // Chọn biểu tượng voucher từ thư viện icon của Flutter
                                            size: 25,
                                            color: Colors.orange,// Kích thước của biểu tượng
                                          ),
                                          FutureBuilder<List>(
                                              future: userModel.getListUserVoucher(AuthService.getIdUser()),
                                              builder: (context, listUserVoucher){
                                                if (listUserVoucher.hasData)
                                                {
                                                  WidgetsBinding.instance!.addPostFrameCallback((_) async {
                                                    homeCon.isLoadingAppBarVoucher.value = false;
                                                  });                                              var totalVoucher = listUserVoucher.data!.length.obs;
                                                  return Obx(() => Text('  $totalVoucher', style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15
                                                  ),),);
                                                }
                                                else if (listUserVoucher.hasError) {
                                                  // Log the error to console
                                                  print('Error fetching categories: ${listUserVoucher.error}');
                                                  // Display an error message widget
                                                  return Text('Error fetching categories');
                                                }
                                                return CircularProgressIndicator();
                                              }
                                          ),

                                        ],
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(width: 10,),
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: GestureDetector(
                                        onTap: () {
                                          Get.to(NotificationScreen());
                                        },
                                        child:Stack(
                                          children: [
                                            Icon(
                                              Icons.notifications_none_outlined,
                                              size: 25,
                                              color: Colors.black,
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: Container(
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    shape: BoxShape.circle
                                                ),
                                                child: FutureBuilder<List>(
                                                    future: userModel.getListUserNotification(AuthService.getIdUser()),
                                                    builder: (context, userNotification){
                                                      if (userNotification.hasData)
                                                      {
                                                        WidgetsBinding.instance!.addPostFrameCallback((_) async {
                                                          homeCon.isLoadingAppBarNotifi.value = false;
                                                        });
                                                        var totalNotifi = userNotification.data!.length.obs;
                                                        return Obx(() => Text(
                                                          '$totalNotifi',
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 8
                                                          ),
                                                        ),);
                                                      }
                                                      else if (userNotification.hasError) {
                                                        // Log the error to console
                                                        print('Error fetching categories: ${userNotification.error}');
                                                        // Display an error message widget
                                                        return Text('Error fetching categories');
                                                      }
                                                      return CircularProgressIndicator();
                                                    }
                                                ),

                                              ),
                                            ),
                                          ],
                                        )

                                    ),
                                  )
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                ), // SliverAppBar
              ],
              body: Stack(
                children: [
                  FutureBuilder<List>(
                    future: productModel.getListCategory(),
                    builder: (context, listCategory) {
                      if (listCategory.hasData) {
                        WidgetsBinding.instance!.addPostFrameCallback((_) async {
                          homeCon.isLoadingCategory1.value = false;
                        });
                        return InViewNotifierList(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          isInViewPortCondition: (double deltaTop, double deltaBottom, double vpHeight) {
                            return deltaTop < 100 && deltaBottom > 100;
                          },
                          itemCount: listCategory.data!.length+1,
                          builder: (context, indexCat) {
                            if(indexCat == 0 ) {
                              return InViewNotifierWidget(
                                id: '${indexCat--}',
                                builder: (context, isInView, child) {
                                  if (isInView) {
                                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                                      _showAppBarTitle.value = 'Xin chào ${userName.value}';
                                    });
                                  }
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child: FutureBuilder<List>(
                                          future: productModel.getListBanner(),
                                          builder: (context, listBanner) {
                                            if (listBanner.hasData) {
                                              WidgetsBinding.instance!.addPostFrameCallback((_) async {
                                                homeCon.isLoadingSlide.value = false;
                                              });
                                              return ImageSlideshow(
                                                autoPlayInterval: 3000,
                                                isLoop: true,
                                                width: double.infinity,
                                                height: 200,
                                                initialPage: 0,
                                                indicatorColor: Colors.blue,
                                                indicatorBackgroundColor: Colors.grey,
                                                children: listBanner.data!.map((item) {
                                                  return
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(10),
                                                      child: Image.network(
                                                          'http://${data.ipAddress}/api/getBannerImg/${item['img_banner']}',
                                                          fit: BoxFit.cover),
                                                    );

                                                }).toList(),
                                              );
                                            } else if (listBanner.hasError) {
                                              print(listBanner.error);
                                              return Text('Error: ${listBanner.error}');
                                            }
                                            return CircularProgressIndicator();
                                          },
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                  'Gợi ý cho bạn',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18
                                                  )
                                              ),
                                              SizedBox(height: 15,),
                                              FutureBuilder<List>(
                                                future: productModel.getListProductSuggest(),
                                                builder: (context, listProductSuggest) {
                                                  if (listProductSuggest.hasData) {
                                                    WidgetsBinding.instance!.addPostFrameCallback((_) async {
                                                      homeCon.isLoadingSuggest.value = false;
                                                    });
                                                    return Container(
                                                      height: 240,
                                                      child: ListView.builder(
                                                        physics: BouncingScrollPhysics(),
                                                        scrollDirection: Axis.horizontal,
                                                        itemCount: listProductSuggest.data!.length,
                                                        itemBuilder: (context, indexSuggest) {
                                                          String idProduct = listProductSuggest.data![indexSuggest]['id_product'].toString();
                                                          String nameProduct = listProductSuggest.data![indexSuggest]['name_product'];
                                                          String imgProduct = listProductSuggest.data![indexSuggest]['img_product'];
                                                          var priceProduct = listProductSuggest.data![indexSuggest]['price_product'];
                                                          return Row(
                                                            children: [
                                                              Container(
                                                                  width: 135,
                                                                  child: Column(
                                                                    children: [
                                                                      GestureDetector(
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
                                                                        child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            ClipRRect(
                                                                              borderRadius: BorderRadius.circular(10), // Bo tròn góc của hình ảnh
                                                                              child: Image.network(
                                                                                'http://${data.ipAddress}/api/getProductImg/${imgProduct}',
                                                                                height: 135,
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 5,),
                                                                            Text(
                                                                              '${nameProduct}',
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.bold
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 5,),
                                                                            Text(
                                                                              '${formatter.format(priceProduct).replaceAll(',', '.').toString()}đ',
                                                                              style: TextStyle(color: Colors.grey[700]),
                                                                            ),
                                                                            SizedBox(height: 10,),
                                                                            Container(
                                                                              height: 40,
                                                                              alignment: Alignment.center,
                                                                              decoration: BoxDecoration(
                                                                                color: Color(0xFFFFCC99), // Đặt màu nền cho Container từ mã hex màu
                                                                                borderRadius: BorderRadius.circular(8), // Bo góc của Container
                                                                              ),
                                                                              child: Text(
                                                                                'Chọn',
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Colors.orange,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ), // Widget mà bạn muốn áp dụng GestureDetector
                                                                      ),


                                                                    ],
                                                                  )
                                                              ),
                                                              SizedBox(width: 10,)
                                                            ],
                                                          );

                                                        },
                                                      ),
                                                    );
                                                  } else if (listProductSuggest.hasError) {
                                                    return Text('Error: ${listProductSuggest.error}');
                                                  }
                                                  return CircularProgressIndicator();
                                                },
                                              ),

                                            ],
                                          )
                                      ),
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
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                Get.to(SearchScreen());
                                                              },
                                                              child: TextField(
                                                                decoration: InputDecoration(
                                                                  enabled: false,
                                                                  filled: true, // Cho phép điền màu nền
                                                                  fillColor: Colors.grey[150], // Màu nền của TextField
                                                                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                                                                  hintText: 'Tìm kiếm...', // Text hiển thị khi không có text
                                                                  prefixIcon: Icon(Icons.search), // Icon tìm kiếm ở đầu
                                                                  border: OutlineInputBorder(
                                                                    borderRadius: BorderRadius.circular(10), // Bo tròn góc với bán kính 10.0
                                                                  ), // Viền của TextField
                                                                ),
                                                              ),
                                                            )
                                                        ),
                                                        SizedBox(width: 15,),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            color: Color(0xFFF7F1E0), // Màu #f7f1e0
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                          child: IconButton(
                                                            color: Colors.orange,
                                                            icon: Icon(Icons.favorite_outline), // Biểu tượng trái tim
                                                            onPressed: () {
                                                              // Get.to(FavoriteProductScreen());
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 15,),
                                                    FutureBuilder<List>(
                                                      future: productModel.getListCategory(),
                                                      builder: (context, listCategory) {
                                                        if (listCategory.hasData) {
                                                          WidgetsBinding.instance!.addPostFrameCallback((_) async {
                                                            homeCon.isLoadingCategory2.value = false;
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
                                                                              'http://${data.ipAddress}/api/getCategoryImg/${listCategory.data![index]['img_category']}',
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
                                          if (listProduct.hasData) {
                                            WidgetsBinding.instance!.addPostFrameCallback((_) async {
                                              homeCon.isLoadingListProduct.value = false;
                                            });
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
                                                  child: GridView.builder(
                                                    shrinkWrap: true, // Cho phép co dãn theo nội dung của GridView
                                                    physics: NeverScrollableScrollPhysics(),
                                                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                                      maxCrossAxisExtent: 200, // Kích thước tối đa của mỗi cột (đơn vị pixel)
                                                      mainAxisSpacing: 10, // Khoảng cách giữa các cột theo chiều dọc
                                                      crossAxisSpacing: 10, // Khoảng cách giữa các cột theo chiều ngang
                                                      childAspectRatio: 3/4, // Ví dụ: tỉ lệ 3:4

                                                    ),
                                                    itemCount: listProduct.data!.length,
                                                    itemBuilder: (context, indexProduct) {
                                                      var idProduct = listProduct.data![indexProduct]['id_product'].toString();
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
                                                                borderRadius: BorderRadius.circular(30),
                                                              ),
                                                              builder: (BuildContext context) {
                                                                return Container(
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.red,
                                                                    borderRadius: BorderRadius.only(
                                                                      topLeft: Radius.circular(20.0),
                                                                      topRight: Radius.circular(20.0),
                                                                    ),
                                                                  ),
                                                                  height: MediaQuery.of(context).size.height * 0.95,
                                                                  child: DetailProductScreen(idProduct: idProduct),
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: Column(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius: BorderRadius.circular(10), // Bo tròn góc của hình ảnh
                                                                child: Image.network(
                                                                  'http://${data.ipAddress}/api/getProductImg/${imgProduct}',
                                                                  fit: BoxFit.cover,
                                                                  height: 200,
                                                                  width: 200,
                                                                ),
                                                              ),
                                                              SizedBox(width: 10,),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    flex: 8, // Đặt flex thành 2 cho container này (tương đương 20%)
                                                                    child: Container(
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          SizedBox(height: 10),
                                                                          Text(
                                                                            '${nameProduct}',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            '${formatter.format(priceProduct).replaceAll(',', '.').toString()}đ',
                                                                            style: TextStyle(color: Colors.grey[700]),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2, // Đặt flex thành 8 cho container này (tương đương 80%)
                                                                    child: Container(
                                                                      width: 30,
                                                                      height: 30,
                                                                      decoration: BoxDecoration(
                                                                        shape: BoxShape.circle,
                                                                        color: Colors.orange,
                                                                      ),
                                                                      child: Icon(
                                                                        Icons.add,
                                                                        color: Colors.white,
                                                                        size: 15,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
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
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
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
                              child: OrderConfirmationScreen(),
                            );
                          },
                        );
                      },
                      child: Cart(),
                    ),
                  ),

                ],
              )

          ),

          bottomNavigationBar: CustomBottomNavigationBar(),
        ),
        Obx(() => Visibility(
          visible: homeCon.isLoading() ? true : false,
          child: LoadingScreen(),
        ),)
      ],
    );

  }
}


class Cart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      homeCon.getData();
    });
    homeCon.isLoadingCart = true.obs;
    return Obx(() => Visibility(
        visible: homeCon.quantityProduct.value > 0 ? true : false,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Obx(() => Text('${homeCon.quantityProduct.value}',
                  style: TextStyle(
                      color: Colors.orange
                  ),
                ),),
              ),
              SizedBox(width: 10,),
              Obx(() =>
                Text('${formatter.format(homeCon.totalPrice.value).replaceAll(',', '.')}đ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),),
            ],
          ),
        )));
  }

}



































































