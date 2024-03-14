import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shop/AuthService.dart';
import 'package:shop/main.dart';
import 'package:shop/model/LoginModel.dart';
import 'package:shop/model/VoucherModel.dart';
import 'package:shop/screens/AddressScreen.dart';
import 'package:shop/screens/QRScanScreen.dart';

import '../API.dart';
import 'DetailVoucherScreen.dart';
import 'LoadingScreen.dart';





var userModel = Get.put(UserModel());
var voucherModel = Get.put(VoucherModel());

NumberFormat formatter = NumberFormat('#,###');

class OrderConfirmationScreenController extends GetxController {
  var isLoadingAddress = true.obs;
  var isLoadingProductOrder = true.obs;
  var isLoadingListAddress = true.obs;
  var isLoadingListVoucher = true.obs;
  var isLoadingVoucherDetail = true.obs;


  RxString nameAddressSelect = RxString('');
  RxString detailAddressSelect = RxString('');
  Rx<Barcode?> result = new Rx<Barcode?>(null);
  var codeVoucherCon = TextEditingController();
  RxDouble discountVoucher = (0.0).obs;
  var addressCoor;
  var phoutCoor = LatLng(21.0195796, 106.814874);
  var deliveryAmount = 0.obs;
  var totalAmount = Rx<double>(0.0);
  var totalAmountProduct = 0.obs;
  var totalProdut = 0.obs;
  var myDouble = Rx<double>(0.0);


  Future<void> calculateAmount () async {
    // Tính khoảng cách giữa hai điểm (đơn vị là mét)
    final distance = await Geolocator.distanceBetween(
      phoutCoor.latitude,
      phoutCoor.longitude,
      addressCoor.latitude,
      addressCoor.longitude,
    );
    deliveryAmount.value = (distance/1000 * 5000).round();
    totalAmount.value = totalAmountProduct.value.toDouble() + deliveryAmount.value;
    if(discountVoucher.value!=0) {
      totalAmount.value=totalAmount.value - (totalAmount.value*discountVoucher.value) ;
    }
    print(totalAmount.value.toString());
  }

  bool isLoading () {
    if(isLoadingAddress.value == true && isLoadingProductOrder.value == true)
      return true;
    else
      return false;
  }



}

class OrderConfirmationScreen extends StatelessWidget {
  var info = Get.put(OrderConfirmationScreenController());


  @override
  Widget build(BuildContext context) {
    info.isLoadingAddress.value = true;
    info.isLoadingProductOrder.value = true;
    info.totalAmount.value = (0.0);
    info.totalAmountProduct.value = 0;
    info.totalProdut.value = 0;
    return Stack(
      children: [
        Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.symmetric(),
                    ),
                    onPressed: () async {
                      var check = await userModel.deletAllUserCart(AuthService.getIdUser());
                      if(check == true)
                        {
                          var homeCon = Get.put(HomeControler());
                          await homeCon.getData();
                          Get.back();
                        }
                      else {
                        var snackBar = SnackBar(
                          content: Text('Có lỗi xảy ra'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Text(
                      'Xóa',
                      style: TextStyle(
                          fontSize: 17
                      ),
                    ),
                  ),
                  Text(
                    'Xác nhận đơn hàng',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    style: IconButton.styleFrom(
                      minimumSize: Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.symmetric(),
                    ),
                    icon: Icon(Icons.close, size: 22,),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ],
              ),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey, width: 0.01,)
                        ),
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Địa chỉ giao hàng',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            FutureBuilder<List>(
                              future: userModel.getNewestUserAddress(AuthService.getIdUser()),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  WidgetsBinding.instance!.addPostFrameCallback((_) async {
                                    info.isLoadingAddress.value = false;
                                  });
                                  info.nameAddressSelect.value = snapshot.data![0]['name_address'].toString();
                                  info.detailAddressSelect.value = snapshot.data![0]['detail_address'].toString();
                                  info.addressCoor = LatLng(double.parse(snapshot.data![0]['lat']), double.parse(snapshot.data![0]['lng'])) ;
                                  return  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // Bo góc trên của BottomSheet
                                        ),
                                        builder: (BuildContext context) {
                                          return Container(
                                            height: MediaQuery.of(context).size.height*0.9,
                                            child: ListAddress(),
                                          );
                                        },
                                      );
                                    },
                                    child:  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Obx(() =>  Text(
                                          '${info.nameAddressSelect.value}',
                                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                        ),),
                                        Stack(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(right: 50),
                                              child: Obx(() => Text(
                                                '${info.detailAddressSelect.value}',
                                                style: TextStyle(fontSize: 16,
                                                ),
                                              ),),
                                            ),
                                            Positioned(
                                              right: 0,
                                              child: Icon(
                                                Icons.keyboard_arrow_right,
                                                size: 24,
                                            ))
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),

                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey, width: 0.01,)
                        ),
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sản phẩm đã chọn',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey, width: 0.01,)
                                  ),
                                  child: TextButton(
                                    onPressed: () { Get.back(); },
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                                    ),
                                    child: Text(
                                      '+ Thêm',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.orange,
                                      ),
                                    ),

                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            FutureBuilder<List>(
                              future: userModel.getListUserCart(AuthService.getIdUser()),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  Map<int, int> checkID = {};
                                  RxMap<int, int> quantityTotal = <int, int>{}.obs;
                                  WidgetsBinding.instance!.addPostFrameCallback((_) async {
                                    info.isLoadingProductOrder.value = false;
                                  });
                                  return  ListView.builder(
                                    shrinkWrap: true, // Cho phép tự động wrap
                                    physics: NeverScrollableScrollPhysics(), // Thêm dòng này
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      var idProduct = snapshot.data![index]['id_product'];
                                      var nameProduct = snapshot.data![index]['name_product'];
                                      var priceProduct = snapshot.data![index]['price_product'];
                                      var note = snapshot.data![index]['note_cart'] ?? '';
                                      var quantityProduct = snapshot.data![index]['quantity'];
                                      if (checkID.containsKey(idProduct)) {
                                        checkID[idProduct] = checkID[idProduct]! + 1;
                                        quantityTotal[idProduct] = quantityTotal[idProduct]! + quantityProduct as int;
                                      } else {
                                        checkID[idProduct] = 1;
                                        quantityTotal[idProduct] = quantityProduct;
                                      }
                                      WidgetsBinding.instance!.addPostFrameCallback((_) async {
                                        info.totalAmountProduct.value = info.totalAmountProduct.value + (priceProduct*quantityProduct) as int;
                                        info.totalProdut.value = info.totalProdut.value + quantityProduct as int;
                                        // await info.calculateAmount();
                                      });
                                      info.calculateAmount();
                                      if(checkID[idProduct]==1) {
                                        return Column(
                                          children: [
                                            SizedBox(height: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    IconButton(
                                                      style: IconButton.styleFrom(
                                                          minimumSize: Size(0, 0),
                                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                          padding: EdgeInsets.all(0)
                                                      ),
                                                      onPressed: () {},
                                                      icon: Icon(Icons.remove_circle),),
                                                    SizedBox(width: 20),
                                                    Container(
                                                      alignment: Alignment.centerLeft,
                                                      height: 30,
                                                      width: MediaQuery.of(context).size.width * 0.6,
                                                      child: Obx(() => Text(
                                                        'x${quantityTotal[idProduct].toString()} $nameProduct',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold),
                                                      ),),
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  formatter.format(priceProduct).replaceAll(',', '.'),
                                                  style: TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                            Visibility(
                                              visible: note == '' ? false : true,
                                              child: Text(
                                                '$note'
                                            ),),
                                            SizedBox(height: 10,),
                                            Divider(
                                              color: Colors.grey,
                                              thickness: 0.3,
                                            ),
                                          ],
                                        );
                                      }
                                      else
                                        return SizedBox.shrink();
                                    },
                                  );
                                }
                              },
                            ),


                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey, width: 0.01,)
                        ),
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tổng cộng',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Thành tiền',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Obx(() => Text(
                                  '${formatter.format(info.totalAmountProduct.value).replaceAll(',', '.')}đ',
                                  style: TextStyle(fontSize: 16),
                                ),)
                              ],
                            ),
                            SizedBox(height: 10),
                            Divider(
                              color: Colors.grey,
                              thickness: 0.3,
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Phí giao hàng',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Obx(() => Text(
                                  '${formatter.format(info.deliveryAmount.value).replaceAll(',', '.')}đ',
                                  style: TextStyle(fontSize: 16),
                                ),),
                              ],
                            ),
                            SizedBox(height: 10),
                            Divider(
                              color: Colors.grey,
                              thickness: 0.3,
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // Bo góc trên của BottomSheet
                                  ),
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: MediaQuery.of(context).size.height*0.9,
                                      child: ListVoucher(),
                                    );
                                  },
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Chọn khuyến mãi',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Row(
                                    children: [
                                      Obx(() => Visibility(
                                          visible: info.discountVoucher.value > 0 ? true : false,
                                          child: Container(
                                            height: 25,
                                            width: 90,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage('assets/images/voucher_outline.jpg'), // Đường dẫn đến file ảnh icon
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            child: Obx(() => Text(
                                              '-${(info.discountVoucher.value*100).round()}%',
                                              style: TextStyle(
                                                  fontSize: 10
                                              ),
                                            )),
                                          ))),
                                      Icon(
                                        Icons.keyboard_arrow_right,
                                        size: 24,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Divider(
                              color: Colors.grey,
                              thickness: 0.3,
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Số tiền thanh toán',
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                ),
                                Obx(() =>
                                    Text(
                                      '${formatter.format(info.totalAmount.value).replaceAll(',', '.')}',
                                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                    ),)
                              ],
                            ),

                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      // Container(
                      //   width: double.infinity,
                      //   decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       border: Border.all(color: Colors.grey, width: 0.01,)
                      //   ),
                      //   padding: EdgeInsets.all(20),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         'Thanh toán',
                      //         style: TextStyle(
                      //           fontSize: 20,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //       SizedBox(height: 20),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Row(
                      //             children: [
                      //               Icon(Icons.edit),
                      //               SizedBox(width: 10),
                      //               Text(
                      //                 'VN PAY',
                      //                 style: TextStyle(fontSize: 16),
                      //               ),
                      //             ],
                      //           ),
                      //           Icon(
                      //             Icons.keyboard_arrow_right,
                      //             size: 24,
                      //           )
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      SizedBox(height: 100,)

                    ],
                  ),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      height: 80,
                      color: Colors.orange,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => Text('${info.totalProdut.value} Sản phẩm',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16
                                ),
                              ),),
                              Obx(() => Text('${formatter.format(info.totalAmount.value).replaceAll(',', '.')}đ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),
                              ),)
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TextButton(

                              onPressed: () async {
                                var checkCart = await userModel.deletAllUserCart(AuthService.getIdUser());
                                var checkVoucher = true;
                                if(info.codeVoucherCon.text.isNotEmpty) {
                                  checkVoucher = await userModel.deleteUserVoucher(AuthService.getIdUser(), info.codeVoucherCon.text);
                                }
                                if(checkCart == true && checkVoucher == true)
                                {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Đặt hàng thành công!'),
                                        content: Text('Cảm ơn bạn đã đặt hàng.'),
                                      );
                                    },
                                  );
                                  // Tự động đóng dialog sau 3 giây
                                  Future.delayed(Duration(seconds: 1), () async {
                                    Get.back();
                                    var homeCon = Get.put(HomeControler());
                                    await homeCon.getData();
                                    Get.back();
                                  });

                                }
                                else {
                                  var snackBar = SnackBar(
                                    content: Text('Có lỗi xảy ra'),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 3),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              },
                              child: Text('ĐẶT HÀNG',
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                ),
              ],
            )
        ),
        Obx(() => Visibility(
          visible: info.isLoading() ? true : false,
          child: LoadingScreen(),
        ),)
      ],
    );
  }
}

class ListAddress extends StatelessWidget {
  var info = Get.put(OrderConfirmationScreenController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              AppBar(
                leading: IconButton(
                  icon: Icon(Icons.keyboard_arrow_left),
                  onPressed: () {
                    Get.back();
                  },
                ),
                centerTitle: true,
                title: Text(
                  'Chọn địa chỉ giao hàng',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
              ),
              FutureBuilder<List>(
                future: userModel.getListUserAddress(AuthService.getIdUser()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    WidgetsBinding.instance!.addPostFrameCallback((_) async {
                      info.isLoadingListAddress.value = false;
                    });
                    return ListView.builder(
                      shrinkWrap: true, // Cho phép tự động wrap
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        String idAddress = snapshot.data![index]['id_address'].toString();
                        String nameAdress = snapshot.data![index]['name_address'] ?? '';
                        String detailAddress = snapshot.data![index]['detail_address']?? '';
                        String receiver = snapshot.data![index]['receiver']?? '';
                        String phoneNum = snapshot.data![index]['receiver_phone']?? '';
                        var addressCoor = LatLng(double.parse(snapshot.data![index]['lat']), double.parse(snapshot.data![index]['lng']));
                        return GestureDetector(
                          onTap: () async {
                            info.nameAddressSelect.value = nameAdress;
                            info.detailAddressSelect.value = detailAddress;
                            info.addressCoor = addressCoor;
                            info.totalAmount.value -= info.deliveryAmount.value;
                            await info.calculateAmount();
                            // print(info.deliveryAmount.value);
                            // print(info.totalAmount.value);
                            // info.totalAmount.value += info.deliveryAmount.value;
                            // print(info.totalAmount.value);
                            Get.back();
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Icon(Icons.location_on_outlined),
                                  ),
                                  Expanded(
                                    flex: 8,
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
                                          '$receiver - $phoneNum',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text('Error: ${snapshot.error}');
                  }
                  return CircularProgressIndicator();
                },
              )
            ],
          ),
        ),
        Obx(() => Visibility(
          visible: info.isLoadingListAddress.value ? true : false,
          child: LoadingScreen(),
        ),)
      ],
    );
  }

}

class ListVoucher extends StatelessWidget {
  var info = Get.put(OrderConfirmationScreenController());
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.keyboard_arrow_left),
              onPressed: () {
                Get.back();
              },
            ),
            centerTitle: true,
            title: Text(
              'Chọn khuyến mãi',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),
            ),
          ),
          body: Column(
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 90,),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                        child: FutureBuilder<List>(
                          future: userModel.getListUserVoucher(AuthService.getIdUser()),
                          builder: (context, snapshot) {
                            WidgetsBinding.instance!.addPostFrameCallback((_) async {
                              info.isLoadingListVoucher.value = false;
                            });
                            if (snapshot.hasData) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  var codeVoucher = snapshot.data![index]['code_voucher'];
                                  var nameVoucher = snapshot.data![index]['name_voucher'];
                                  var imgVoucher = snapshot.data![index]['img_voucher'];
                                  DateTime dateTime = DateTime.parse(snapshot.data![index]['exp_date']);
                                  var expDate = DateFormat('dd/MM/yyyy').format(dateTime);

                                  return GestureDetector(
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
                                            height: MediaQuery.of(context).size.height * 0.8,
                                            child: DetailVoucher(codeVoucher: codeVoucher),
                                          );
                                        },
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ClipRRect(
                                          child: Image.network(
                                            'http://${voucherModel.ipAddress}/api/getVoucherImg/${imgVoucher}',
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
                                    ),
                                  );

                                },
                              );
                            } else if (snapshot.hasError) {
                              print(snapshot.error);
                              return Text('Error: ${snapshot.error}');
                            }
                            return CircularProgressIndicator();
                          },
                        ),)
                    ],
                  ),
                  Positioned(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: TextField(
                        controller: info.codeVoucherCon,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: IconButton(
                            onPressed: () {
                              Get.to(QRScanScreen());
                            },
                            icon: Icon(Icons.qr_code_scanner),
                          ),
                          hintText: 'Nhập mã khuyến mãi',
                          suffixIcon: TextButton(
                            onPressed: () async {
                              var check = await voucherModel.checkUseVoucherExist(AuthService.getIdUser(), info.codeVoucherCon.text);
                              if(check == true){
                                var detailVoucher = await voucherModel.getVoucherDetail(info.codeVoucherCon.text);
                                if(detailVoucher.isEmpty!=true)
                                {
                                  info.discountVoucher.value = double.parse(detailVoucher[0]['discount']);
                                  info.calculateAmount();
                                  Get.back();
                                }
                                else{
                                  var snackBar = SnackBar(
                                    content: Text('Voucher không hợp lệ'),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 3),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              }
                              else {
                                var snackBar = SnackBar(
                                  content: Text('Bạn không có voucher này'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 3),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }


                            },
                            style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    bottomRight: Radius.circular(5),
                                  ), // Đặt bán kính bo tròn tại đây
                                ),
                                minimumSize: Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                backgroundColor: Colors.orange
                            ),
                            child: Text(
                              'Áp dụng',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),

                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Obx(() => Visibility(
          visible: info.isLoadingListVoucher.value ? true : false,
          child: LoadingScreen(),
        ),)
      ],
    );
  }

}

class DetailVoucher extends StatelessWidget {
  var codeVoucher;
  DetailVoucher({required this.codeVoucher});

  var info = Get.put(OrderConfirmationScreenController());

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.grey[200],
          body: Stack(
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.all(30),
                  child:
                  FutureBuilder<List>(
                    future: voucherModel.getVoucherDetail(codeVoucher),
                    builder: (context, snapshot) {
                      WidgetsBinding.instance!.addPostFrameCallback((_) async {
                        info.isLoadingVoucherDetail.value = false;
                      });
                      if (snapshot.hasData) {
                        var codeVoucher = snapshot.data![0]['code_voucher'];
                        var nameVoucher = snapshot.data![0]['name_voucher'];
                        var detail = snapshot.data![0]['detail_voucher'];
                        DateTime dateTime = DateTime.parse(snapshot.data![0]['exp_date']);
                        var expDate = DateFormat('dd/MM/yyyy').format(dateTime);

                        return Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          width: double.infinity,
                          child: Column(
                            children: [
                              Text(
                                '${nameVoucher.toUpperCase()}',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(height: 20,),
                              QrImageView(
                                data: '$codeVoucher',
                                version: QrVersions.auto,
                                size: 200,
                                gapless: false,
                              ),
                              SizedBox(height: 10,),
                              Text(
                                '$codeVoucher',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: codeVoucher)); // Copy text to clipboard
                                  // Show SnackBar to notify user that text has been copied
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Mã $codeVoucher đã được sao chép'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                child: Text('Sao chép'), // Button Text
                              ),
                              Divider(
                                color: Colors.grey, // Màu của kẻ ngang
                                thickness: 1, // Độ dày của kẻ ngang
                                indent: 25,
                                endIndent: 25,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Ngày hết hạn:',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      '$expDate',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.grey, // Màu của kẻ ngang
                                thickness: 1, // Độ dày của kẻ ngang
                                indent: 25,
                                endIndent: 25,
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                child: Text(
                                  '$detail',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
        ),
        Obx(() => Visibility(
          visible: info.isLoadingVoucherDetail.value ? true : false,
          child: LoadingScreen(),
        ),)
      ],
    );
  }
}

class QRScanScreen extends StatelessWidget {
  var info = Get.put(OrderConfirmationScreenController());


  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
                child: Obx(() => (info.result.value != null)
                    ? Text(
                  'Result: ${info.result.value!.code}',
                  style: TextStyle(fontSize: 20),
                )
                    : Text(
                  'Scan a QR code',
                  style: TextStyle(fontSize: 20),
                ),)
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      info.result.value = scanData;
      info.codeVoucherCon.text = scanData.code.toString();
      Get.back();
    });
  }
}