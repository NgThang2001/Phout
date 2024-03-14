import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../AuthService.dart';
import '../DTO/UserDTO.dart';

class ProductModel {
  var ipAddress = '192.168.1.6:3000';

  Future<List> getListUserFavorite(var idUser) async {
    final response = await http.get(Uri.parse('http://${ipAddress}/api/getListUserFavorite/${idUser}'));
    if (response.statusCode == 200) {
      List<dynamic> listUserFavorite = json.decode(response.body);
      return listUserFavorite;
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  Future<List<dynamic>> getListCategory() async {
    final response = await http.get(Uri.parse('http://${ipAddress}/api/getListCategory'));
    if (response.statusCode == 200) {
      List<dynamic> listCategory = json.decode(response.body);
      return listCategory;
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  Future<List<dynamic>> getListProductSuggest() async {
    final response = await http.get(Uri.parse('http://${ipAddress}/api/getListProductSuggest'));
    if (response.statusCode == 200) {
      List<dynamic> listProductSuggest = json.decode(response.body);
      return listProductSuggest;
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  Future<List<dynamic>> getListBanner() async {
    final response = await http.get(Uri.parse('http://${ipAddress}/api/getListBanner'));
    if (response.statusCode == 200) {
      List<dynamic> listBanner = json.decode(response.body);
      return listBanner;
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  Future<List<dynamic>> getListProductByCategory(var id_category) async {
    final response = await http.get(Uri.parse('http://${ipAddress}/api/getListProductByCategory/${id_category}'));
    if (response.statusCode == 200) {
      List<dynamic> listProductByCategory = json.decode(response.body);
      return listProductByCategory;
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  Future<List<dynamic>> searchProduct(var serachText) async {
    final response = await http.get(Uri.parse('http://${ipAddress}/api/searchProduct/${serachText}'));
    print('http://${ipAddress}/api/searchProduct/${serachText}');
    if (response.statusCode == 200) {
      List<dynamic> listProductByCategory = json.decode(response.body);
      return listProductByCategory;
    } else {
      throw Exception('Failed to load data from API');
    }
  }

}

