import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vexa_eleicoes/conexao.dart';

class CandidatoContext {

  Future<Map> getCandidatos() async {
    http.Response response = await http.get(Uri.parse('$APIRealTime/candidatos.json'));

    Map<dynamic, dynamic> teste = jsonDecode(response.body);
    Map<dynamic, dynamic> teste2 = <dynamic, dynamic>{};
    var numerosCandidatos = teste.keys.toString().replaceAll("(", "").replaceAll(")", "").replaceAll(" ", "").split(",");
    Map<String, int> numeroOrdernado = <String, int>{};

    for (var i = 0; i < teste.length; i++) {
      numeroOrdernado.addAll({
        numerosCandidatos[i]: teste[numerosCandidatos[i]]["qtdvotos"],
      });
    }
    var sortedKeys = numeroOrdernado.keys.toList(growable: false)..sort((k1, k2) => num.parse(numeroOrdernado[k2].toString()).compareTo(num.parse(numeroOrdernado[k1].toString())));
    LinkedHashMap sortedMap = LinkedHashMap.fromIterable(sortedKeys, key: (k) => k, value: (k) => numeroOrdernado[k]);

    for (var item in sortedMap.keys) {
      teste2.addAll({item: teste[item]});
    }
    return teste2;
  }

  Future<bool> validarNumeroCandidato(String numeroCandidato) async {
    http.Response response = await http.get(Uri.parse('$APIRealTime/candidatos/$numeroCandidato/nome.json'));
    return response.body != "null";
  }

  Future<String> getNomeCandidato(String numeroCandidato) async {
    http.Response response = await http.get(Uri.parse('$APIRealTime/candidatos/$numeroCandidato/nome.json'));
    return response.body;
  }

  
}
