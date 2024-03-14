import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../AuthService.dart';
import '../DTO/UserDTO.dart';

class VoucherModel {
  var ipAddress = '192.168.1.6:3000';

  Future<List> getVoucherDetail(var codeVoucher) async {
    final response = await http.get(Uri.parse('http://${ipAddress}/api/getVoucherDetail/${codeVoucher}'));
    if (response.statusCode == 200) {
      List<dynamic> productDetail = json.decode(response.body);
      return productDetail;
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  Future<bool> checkUseVoucherExist(var idUser, var code_voucher) async {
    final response = await http.get(Uri.parse('http://${ipAddress}/api/checkUseVoucherExist/$idUser/$code_voucher'));
    if (response.statusCode == 200) {
      List<dynamic> user = json.decode(response.body);
      if(user.isNotEmpty) {
        return true;
      }
      else {
        return false;
      }
    } else {
      print('http://${ipAddress}/api/checkUseVoucherExist/${idUser}/${code_voucher}');
      throw Exception('Failed to load data from API');
    }
  }


}

