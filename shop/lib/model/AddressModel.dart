import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../AuthService.dart';
import '../DTO/UserDTO.dart';

class AddressModel {
  var ipAddress = '192.168.1.6:3000';

  Future<int> createAddress(Map<String, dynamic> userData) async {
    final String apiUrl = 'http://${ipAddress}/api/createAddress';
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



  Future<List> getAddressDetail(var idAddress) async {
    final response = await http.get(Uri.parse('http://${ipAddress}/api/getAddressDetail/${idAddress}'));
    if (response.statusCode == 200) {
      List<dynamic> productDetail = json.decode(response.body);
      return productDetail;
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

  Future<bool> deleteAddress(var idAddress) async {
    try {
      final response = await http.delete(
        Uri.parse('http://$ipAddress/api/deleteAddress/$idAddress'),
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

