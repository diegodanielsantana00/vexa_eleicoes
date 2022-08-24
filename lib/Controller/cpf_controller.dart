
class CPFController {
  bool validadorCpf(String cpf) {
    bool retorno = false;
    var cpfConvertido = cpf.replaceAll(".", "").replaceAll("-", "").split("");
    int controllerConta = 10;
    int soma = 0;
    if (cpf.isEmpty) {return retorno;}
    for (var i = 0; i < 9; i++) {
      soma += (int.parse(cpfConvertido[i]) * controllerConta);
      controllerConta--;
    }
    int resto = (soma * 10) % 11;

    if ((resto == 10 ? 0 : resto) == int.parse(cpfConvertido[9])) {
      soma = 0;
      controllerConta = 11;
      for (var i = 0; i < 10; i++) {
        soma += (int.parse(cpfConvertido[i]) * controllerConta);
        controllerConta--;
      }
      int resto = (soma * 10) % 11;
      retorno = (resto == 10 ? 0 : resto) == int.parse(cpfConvertido[10]);
    }

    return retorno;
  }
}
