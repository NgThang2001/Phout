import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shop/main.dart';
import 'package:shop/screens/LoginScreen.dart';

class AuthService {
  static final localStorage = GetStorage();

  static bool isLoggedIn() {
    return localStorage.read('isLoggedIn') ?? false;
  }

  static void setLoggedIn(bool value) {
    localStorage.write('isLoggedIn', value);
  }

  static void saveUserData(List<dynamic> userData) {
    localStorage.write('userData', userData);
  }

  static List<dynamic>? getUserData() {
    return localStorage.read<List<dynamic>>('userData');
  }

  static void saveIdUser(int idUser) {
    localStorage.write('idUser', idUser);
  }

  static int? getIdUser() {
    return localStorage.read<int>('idUser');
  }

}

// Sử dụng trong Widget
class Auth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: GetStorage.init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox.shrink();
        } else {
          bool isLoggedIn = AuthService.isLoggedIn();
          if (isLoggedIn) {
            return MyHomePage();
          } else {
            // Người dùng chưa đăng nhập trước đó, hiển thị giao diện đăng nhập
            return LoginScreen();
          }
        }
      },
    );
  }
}
