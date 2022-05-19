import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vexa_eleicoes/conexao.dart';

class IMEIContext {
  Future<bool> consultarIMEICripto(String imei) async {
    http.Response response = await http.get(Uri.parse('$APIRealTime/imei/$imei.json'));
    return response.body != "null";
  }

  salvarIMEI(String imei) async {
    await http.patch(Uri.parse('$APIRealTime/imei/.json'),
        body: json.encode({imei: ""}));
  }
}
