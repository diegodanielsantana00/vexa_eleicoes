import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:vexa_eleicoes/Controller/cpf_controller.dart';
import 'package:vexa_eleicoes/Controller/criptografia_controller.dart';
import 'package:vexa_eleicoes/Controller/navigator_controller.dart';
import 'package:vexa_eleicoes/Models/celular_context.dart';
import 'package:vexa_eleicoes/Models/cpf_context.dart';
import 'package:vexa_eleicoes/Models/imei_context.dart';
import 'package:vexa_eleicoes/Views/urna_screen.dart';

class CPFScreen extends StatefulWidget {
  const CPFScreen({Key? key}) : super(key: key);

  @override
  State<CPFScreen> createState() => _CPFScreenState();
}

var maskFormatter = MaskTextInputFormatter(mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
var maskFormatterPhone = MaskTextInputFormatter(mask: '(##) # ####-####', filter: {"#": RegExp(r'[0-9]')});

class _CPFScreenState extends State<CPFScreen> {
  final _cpfController = TextEditingController();
  final _phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => NavigatorController().navigatorBack(context),
        ),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  textCapitalization: TextCapitalization.none,
                  onChanged: (value) {
                    // ignore: invalid_use_of_protected_member
                    (context as Element).reassemble();
                  },
                  enableSuggestions: false,
                  autocorrect: false,
                  inputFormatters: [maskFormatter],
                  cursorColor: Colors.grey,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.access_time_filled_sharp, color: Colors.grey),
                    hintText: "Digite seu CPF Aqui",
                    border: InputBorder.none,
                  ),
                  controller: _cpfController,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  textCapitalization: TextCapitalization.none,
                  onChanged: (value) {
                    // ignore: invalid_use_of_protected_member
                    (context as Element).reassemble();
                  },
                  enableSuggestions: false,
                  autocorrect: false,
                  inputFormatters: [maskFormatterPhone],
                  cursorColor: Colors.grey,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.phone, color: Colors.grey),
                    hintText: "Digite seu Número aqui",
                    border: InputBorder.none,
                  ),
                  controller: _phoneController,
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: 200,
            // ignore: deprecated_member_use
            child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                color: Colors.grey[300],
                onPressed: () async {
                  if (await showProgressoBotao(context)) {
                    NavigatorController().navigatorToReturn(
                        context,
                        UrnaScreen(CriptografiaController().criptografarCPF(_cpfController.text), CriptografiaController().criptografarCelular(_phoneController.text),
                            CriptografiaController().criptografarIMEI(await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: true))));
                  } else {
                    AwesomeDialog(
                            context: context,
                            dialogType: DialogType.ERROR,
                            animType: AnimType.BOTTOMSLIDE,
                            title: 'CPF ou Número Inválido ou já votado !!',
                            desc: 'Reveja seu número de CPF ou número de celular e tente novemente, lembrando que só poderá votar apenas uma vez por dispositivo !!',
                            btnCancelOnPress: () {},
                            // btnOkOnPress: () {},
                            btnCancelText: "Ok",
                            headerAnimationLoop: false)
                        .show();
                  }
                },
                child: const Text("Continuar")),
          )
        ],
      ),
    );
  }

  Future<bool> showProgressoBotao(BuildContext context) async {
    var result = await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(getFuture(), message: const Text('Carregando...')),
    );
    return result;
  }

  Future getFuture() {
    return Future(() async {
      if (CPFController().validadorCpf(_cpfController.text) &&
          !await CPFContext().consultarCPFCripto(CriptografiaController().criptografarCPF(_cpfController.text)) &&
          !await CelularContext().consultarCelularCripto(CriptografiaController().criptografarCelular(_phoneController.text)) &&
          !await IMEIContext().consultarIMEICripto(CriptografiaController().criptografarIMEI(await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: true)))) {
        return true;
      } else {
        return false;
      }
    });
  }
}
