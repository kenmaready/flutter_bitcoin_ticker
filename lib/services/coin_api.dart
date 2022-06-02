import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CoinAPI {
  final String _apiKey = dotenv.env['COIN_API_KEY'];
  final String _CoinAPIBaseURL = 'rest.coinapi.io';
  final String CoinAPIExtension = '/v1/exchangerate';

  Future<Map<String, dynamic>> getData({String base, String quote}) async {
    var url = Uri.https(
        _CoinAPIBaseURL, '$CoinAPIExtension/$base/$quote', {'apikey': _apiKey});
    print('url: ${url.toString()}');
    http.Response response = await http.get(url);

    print('response: ${response.toString()}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('data: ${data.toString()}');
      return data;
    } else {
      print("Error occurred in fetching data: ${response.statusCode}");
    }
  }

  Future<double> getExchangeRate({String base, String quote}) async {
    final data = await getData(base: base, quote: quote);
    print('rate: ${data['rate'].toDouble()}');
    return data['rate'].toDouble();
  }
}
