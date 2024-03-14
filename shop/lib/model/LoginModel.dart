import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../AuthService.dart';
import '../DTO/UserDTO.dart';

class UserModel {
  var ipAddress = '192.168.1.6:3000';

  Future<int> CreateUser(Map<String, dynamic> userData) async {
    final String apiUrl = 'http://${ipAddress}/api/createUser';
    // Gửi yêu cầu POST
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userData),
    );
    return response.statusCode;
  }

  Future<int> UpdateUser(String idUser, Map<String, dynamic> userData) async {
    print(jsonEncode(userData));
    final String apiUrl = 'http://${ipAddress}/api/updateUser/$idUser'; // Địa chỉ API của bạn
    // Gửi yêu cầu PUT
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userData),
    );
    return response.statusCode;
  }

  Future<bool> checkUserExist(String phoneNumber) async {
    var userInfo = Get.put(UserInfo());
    final response = await http.get(Uri.parse('http://${ipAddress}/api/checkUserExist/${phoneNumber}'));
    if (response.statusCode == 200) {
      List<dynamic> user = json.decode(response.body);
      if(user.isNotEmpty) {
        // userInfo.id_user = user[0]['id_user'];
        // userInfo.phone_number =user[0]['phone_number'];
        // userInfo.first_name = user[0]['first_name'];
        // userInfo.last_name = user[0]['last_name'];
        // userInfo.email = user[0]['email'];
        // userInfo.point_phout = user[0]['point_phout'];
        AuthService.saveIdUser(user[0]['id_user']);
        return true;
      }
      else {
        return false;
      }
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  Future<List> getDetailUser(var idUser) async {
    final response = await http.get(Uri.parse('http://${ipAddress}/api/getDetailUser/${idUser}'));
    if (response.statusCode == 200) {
      print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  Future<List> getListUserNotification(var idUser) async {
    final response = await http.get(Uri.parse('http://${ipAddress}/api/getListUserNotification/${idUser}'));
    if (response.statusCode == 200) {
      List<dynamic> listUserCart = json.decode(response.body);
      return listUserCart;
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  Future<List> getListUserVoucher(var idUser) async {
    final response = await http.get(Uri.parse('http://${ipAddress}/api/getListUserVoucher/${idUser}'));
    if (response.statusCode == 200) {
      List<dynamic> productDetail = json.decode(response.body);
      return productDetail;
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  Future<int> createCartUser(Map<String, dynamic> cartData) async {
    final String apiUrl = 'http://${ipAddress}/api/createCartUser';
    // Gửi yêu cầu POST
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(cartData),
    );
    return response.statusCode;
  }

  Future<List> getListUserCart(var idUser) async {
    final response = await http.get(Uri.parse('http://${ipAddress}/api/getListUserCart/${idUser}'));
    if (response.statusCode == 200) {
      List<dynamic> listUserCart = json.decode(response.body);
      return listUserCart;
    } else {
      throw Exception('Failed to load data from API');
    }
  }
  Future<List> getListUserAddress(var idUser) async {
    final response = await http.get(Uri.parse('http://${ipAddress}/api/getListUserAddress/${idUser}'));
    if (response.statusCode == 200) {
      List<dynamic> productDetail = json.decode(response.body);
      return productDetail;
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  Future<List> getNewestUserAddress(var idUser) async {
    final response = await http.get(Uri.parse('http://${ipAddress}/api/getNewestUserAddress/${idUser}'));
    if (response.statusCode == 200) {
      List<dynamic> productDetail = json.decode(response.body);
      return productDetail;
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  Future<bool> deletAllUserCart(var idUser) async {
    try {
      final response = await http.delete(
        Uri.parse('http://$ipAddress/api/deleteAllUserCart/$idUser'),
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print('Error deleting user cart: $error');
      return false;
    }
  }

  Future<bool> deleteUserVoucher(var idUser, var codeVoucher) async {
    try {
      final response = await http.delete(
        Uri.parse('http://$ipAddress/api/deleteUserVoucher/$idUser/$codeVoucher'),
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print('Error deleting user cart: $error');
      return false;
    }
  }

}

