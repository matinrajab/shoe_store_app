import 'dart:convert';
import 'package:shoe_store_app/config/config.dart';
import 'package:shoe_store_app/models/category_model.dart';
import 'package:http/http.dart' as http;
import 'package:shoe_store_app/models/payment_method_model.dart';
import 'package:shoe_store_app/models/payment_method_model.dart';
import 'package:shoe_store_app/models/payment_method_model.dart';

class PaymentMethodService {
  final String baseUrl = Config.baseUrl;

  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    var url = '$baseUrl/payment_methods';
    var headers = {'Content-Type': 'application/json'};

    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    if(response.statusCode == 200){
      List data = jsonDecode(response.body)['data'];
      List<PaymentMethodModel> paymentMethods = [];
      data.map((category) => paymentMethods.add(PaymentMethodModel.fromJson(category))).toList();

      return paymentMethods;
    }
    throw Exception('Gagal Get Payment Methods!');
  }
}
