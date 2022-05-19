import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vexa_eleicoes/conexao.dart';

class CPFContext {
  Future<bool> consultarCPFCripto(String cpf) async {
    http.Response response = await http.get(Uri.parse('$APIRealTime/cpf/$cpf.json'));
    return response.body != "null";
  }

  salvarCPF(String cpf) async {
    await http.patch(Uri.parse('$APIRealTime/cpf/.json'), body: json.encode({cpf: ""}));
  }
}
