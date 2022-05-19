import 'dart:convert';
import 'package:crypto/crypto.dart';

class CriptografiaController {
  String criptografarCPF(String cpf) {
    var cpfConvertido = cpf.replaceAll(".", "").replaceAll("-", "").split("");
    var etapa1Criptografia = [];
    var CPFCripto = "";

    for (var i = 0; i < cpfConvertido.length; i++) {
      switch (int.parse(cpfConvertido[i])) {
        case 1:
          etapa1Criptografia.add("k");
          break;
        case 2:
          etapa1Criptografia.add("#");
          break;
        case 3:
          etapa1Criptografia.add("©");
          break;
        case 4:
          etapa1Criptografia.add("ƒ");
          break;
        case 5:
          etapa1Criptografia.add("`");
          break;
        case 6:
          etapa1Criptografia.add("|");
          break;
        case 7:
          etapa1Criptografia.add(".");
          break;
        case 8:
          etapa1Criptografia.add("ß");
          break;
        case 9:
          etapa1Criptografia.add("3");
          break;
        case 0:
          etapa1Criptografia.add("¬");
          break;
      }
    }

    for (var i = 0; i < etapa1Criptografia.length; i++) {
      CPFCripto += etapa1Criptografia[i];
    }

    return md5.convert(utf8.encode(CPFCripto)).toString();
  }

  String criptografarCelular(String cpf) {
    var celularConvertido = cpf.replaceAll("(", "").replaceAll(")", "").replaceAll(" ", "").replaceAll("-", "").split("");
    var etapa1Criptografia = [];
    var CelularCripto = "";

    for (var i = 0; i < celularConvertido.length; i++) {
      switch (int.parse(celularConvertido[i])) {
        case 1:
          etapa1Criptografia.add("a");
          break;
        case 2:
          etapa1Criptografia.add("7");
          break;
        case 3:
          etapa1Criptografia.add("©");
          break;
        case 4:
          etapa1Criptografia.add("ƒ");
          break;
        case 5:
          etapa1Criptografia.add("`");
          break;
        case 6:
          etapa1Criptografia.add("|");
          break;
        case 7:
          etapa1Criptografia.add("§");
          break;
        case 8:
          etapa1Criptografia.add("ß");
          break;
        case 9:
          etapa1Criptografia.add("3");
          break;
        case 0:
          etapa1Criptografia.add("¬");
          break;
      }
    }

    for (var i = 0; i < etapa1Criptografia.length; i++) {
      CelularCripto += etapa1Criptografia[i];
    }

    return md5.convert(utf8.encode(CelularCripto)).toString();
  }

  String criptografarIMEI(String imei) {
    return md5.convert(utf8.encode(imei)).toString();
  }
}
