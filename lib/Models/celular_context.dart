import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vexa_eleicoes/conexao.dart';

class CelularContext {
  Future<bool> consultarCelularCripto(String celular) async {
    http.Response response = await http.get(Uri.parse('$APIRealTime/celular/$celular.json'));
    return response.body != "null";
  }

  salvarCelular(String celular) async {
    await http.patch(Uri.parse('$APIRealTime/celular/.json'), body: json.encode({celular: ""}));
  }
}
