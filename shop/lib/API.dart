import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:shop/screens/OrderScreen.dart';

class Data extends GetxController {
  var ipAddress = '192.168.1.6:3000';

  Future<List> getNewestUserAddress(var idUser) async {
    final response = await http.get(Uri.parse('http://${ipAddress}/api/getNewestUserAddress/${idUser}'));
    if (response.statusCode == 200) {
      List<dynamic> productDetail = json.decode(response.body);
      return productDetail;
    } else {
      throw Exception('Failed to load data from API');
    }
  }





  Future<List> getAddressDetail(var idAddress) async {
    final response = await http.get(Uri.parse('http://${ipAddress}/api/getListAddress/${idAddress}'));
    if (response.statusCode == 200) {
      List<dynamic> productDetail = json.decode(response.body);
      return productDetail;
    } else {
      throw Exception('Failed to load data from API');
    }
  }



  Future<List> getUserDetail(var idUser) async {
    final response = await http.get(Uri.parse('http://${ipAddress}/api/getUserDetail/${idUser}'));
    if (response.statusCode == 200) {
      List<dynamic> productDetail = json.decode(response.body);
      return productDetail;
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  Future<List> getRedeemVoucherDetail(var codeRedeemVoucher) async {
    final response = await http.get(Uri.parse('http://${ipAddress}/api/getRedeemVoucherDetail/${codeRedeemVoucher}'));
    if (response.statusCode == 200) {
      List<dynamic> productDetail = json.decode(response.body);
      return productDetail;
    } else {
      throw Exception('Failed to load data from API');
    }
  }


  Future<List<dynamic>> getListRedeemVoucher() async {
    final response = await http.get(Uri.parse('http://${ipAddress}/api/getListRedeemVoucher'));
    if (response.statusCode == 200) {
      List<dynamic> listCategory = json.decode(response.body);
      return listCategory;
    } else {
      throw Exception('Failed to load data from API');
    }
  }



  var voucherQuantity = 0;
  Future<List<dynamic>> getListVoucher() async {
    final response = await http.get(Uri.parse('http://${ipAddress}/api/getListVoucher'));
    if (response.statusCode == 200) {
      List<dynamic> listCategory = json.decode(response.body);
      voucherQuantity = listCategory.length;
      return listCategory;
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  Future<List> getProductDetail(var idProduct) async {
    final response = await http.get(Uri.parse('http://${ipAddress}/api/getProductDetail/${idProduct}'));
    if (response.statusCode == 200) {
      List<dynamic> productDetail = json.decode(response.body);
      return productDetail;
    } else {
      throw Exception('Failed to load data from API');
    }
  }






  Future<List<dynamic>> getListProduct() async {
    final response = await http.get(Uri.parse('http://${ipAddress}/api/getListProduct'));
    if (response.statusCode == 200) {
      List<dynamic> listProduct = json.decode(response.body);
      return listProduct;
    } else {
      throw Exception('Failed to load data from API');
    }
  }






  Future<List<dynamic>> fetchData() async {
    final response = await http.get(Uri.parse('http://${ipAddress}/api/test'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data from API');
    }
  }
  void test() async {
    // Gọi fetchData trong một hàm bất đồng bộ (asynchronous)
    List<dynamic> data = await fetchData();

    // Sau khi fetchData hoàn thành, bạn có thể xử lý dữ liệu ở đây
  }

  Future<List> getDATA() async {
    // Gọi fetchData trong một hàm bất đồng bộ (asynchronous)
    List<dynamic> data = await fetchData();

    // Sau khi fetchData hoàn thành, bạn có thể xử lý dữ liệu ở đây
    return data;
  }

  Future<List<dynamic>> fetchProductDetail() async {
    final response = await http.get(Uri.parse('http://192.168.1.6:3000/api/test1'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data from API');
    }
  }
  // Future<List> getProductDetail() async {
  //   // Gọi fetchData trong một hàm bất đồng bộ (asynchronous)
  //   List<dynamic> productDetail = await fetchProductDetail();
  //
  //   // Sau khi fetchData hoàn thành, bạn có thể xử lý dữ liệu ở đây
  //   return productDetail;
  // }

  Future<List<dynamic>> fetchListProduct() async {
    final response = await http.get(Uri.parse('http://192.168.1.6:3000/api/test3/1'));
    if (response.statusCode == 200) {
      List<dynamic> ListProduct = json.decode(response.body);
      return ListProduct;
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  Future<List<dynamic>> fetchListCategory() async {
    final response = await http.get(Uri.parse('http://192.168.1.6:3000/api/test_category'));
    if (response.statusCode == 200) {
      List<dynamic> ListCategory = json.decode(response.body);
      return ListCategory;
    } else {
      throw Exception('Failed to load data from API');
    }
  }


}