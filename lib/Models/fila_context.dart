import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vexa_eleicoes/conexao.dart';

class FILAContext {
  salvarFILA(String celular, String voto) async {
    await http.patch(Uri.parse('$APIRealTime/fila/$celular.json'),
        body: json.encode({"voto": voto}));
  }
}
