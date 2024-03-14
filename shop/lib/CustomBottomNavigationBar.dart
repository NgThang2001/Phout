import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shop/main.dart';
import 'package:shop/screens/OrderScreen.dart';
import 'package:shop/screens/OthersScreen.dart';
import 'package:shop/screens/VoucherScreen.dart';

class BottomNavigationBarController extends GetxController {
  var selectedIndex = 0.obs;
}


class CustomBottomNavigationBar extends StatelessWidget {
  final BottomNavigationBarController _controller = Get.put(BottomNavigationBarController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      currentIndex: _controller.selectedIndex.value,
      onTap: (int index) {
        WidgetsBinding.instance!.addPostFrameCallback((_) async {
          _controller.selectedIndex.value = index;
        });
        switch (index) {
          case 0:
            Get.to(MyHomePage());
            break;
          case 1:
            Get.to(OrderScreen());
            break;
          case 2:
            Get.to(VoucherScreen());
            break;
          case 3:
            Get.to(OthersScreen());
            break;
        }
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fastfood),
          label: 'Đặt hàng',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.confirmation_number),
          label: 'Ưu đãi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: 'Khác',
        ),
      ],
    ));
  }
}
