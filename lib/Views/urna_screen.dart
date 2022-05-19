// ignore_for_file: prefer_typing_uninitialized_variables, use_key_in_widget_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:vexa_eleicoes/Controller/navigator_controller.dart';
import 'package:vexa_eleicoes/Models/candidatos_context.dart';
import 'package:vexa_eleicoes/Models/celular_context.dart';
import 'package:vexa_eleicoes/Models/cpf_context.dart';
import 'package:vexa_eleicoes/Models/fila_context.dart';
import 'package:vexa_eleicoes/Models/imei_context.dart';
import 'package:vexa_eleicoes/Views/home_screen.dart';

class UrnaScreen extends StatefulWidget {
  final cpf;
  final celular;
  final imei;
  const UrnaScreen(this.cpf, this.celular, this.imei);
  @override
  State<UrnaScreen> createState() => _UrnaScreenState();
}

class _UrnaScreenState extends State<UrnaScreen> {
  final _digito1Controller = TextEditingController();
  final _digito2Controller = TextEditingController();
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
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _textFieldOTP(true, false, context, _digito1Controller),
                    const SizedBox(
                      width: 22,
                    ),
                    _textFieldOTP(false, true, context, _digito2Controller),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                        AwesomeDialog(
                                context: context,
                                dialogType: DialogType.QUESTION,
                                animType: AnimType.BOTTOMSLIDE,
                                title: 'Confirmação de escolha',
                                desc: 'Número ${_digito1Controller.text + _digito2Controller.text} \nCandidato: ' +
                                    await CandidatoContext().getNomeCandidato(_digito1Controller.text + _digito2Controller.text),
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {
                                  FILAContext().salvarFILA(widget.celular, _digito1Controller.text + _digito2Controller.text);
                                  IMEIContext().salvarIMEI(widget.imei);
                                  CelularContext().salvarCelular(widget.celular);
                                  CPFContext().salvarCPF(widget.cpf);
                                  NavigatorController().navigatorToNoReturn(context, HomeScreen(true));
                                },
                                btnCancelText: "Cancelar",
                                headerAnimationLoop: false)
                            .show();
                      } else {
                        AwesomeDialog(
                                context: context,
                                dialogType: DialogType.ERROR,
                                animType: AnimType.BOTTOMSLIDE,
                                title: 'Candidato Inválido',
                                desc: 'Número ${_digito1Controller.text + _digito2Controller.text} é um número invalido.',
                                btnCancelOnPress: () {},
                                // btnOkOnPress: () {},
                                btnCancelText: "Ok",
                                headerAnimationLoop: false)
                            .show();
                      }
                    },
                    child: const Text("Votar")),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> showProgressoBotao(BuildContext context) async {
    var result = await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(getFuture(), message: const Text('Buscando Candidato...')),
    );
    return result;
  }

  Future getFuture() {
    return Future(() async {
      if (_digito1Controller.text.isNotEmpty && _digito2Controller.text.isNotEmpty && await CandidatoContext().validarNumeroCandidato(_digito1Controller.text + _digito2Controller.text)) {
        return true;
      } else {
        return false;
      }
    });
  }
}

Widget _textFieldOTP(bool first, last, context, digito) {
  return SizedBox(
    height: 85,
    child: AspectRatio(
      aspectRatio: 1.0,
      child: TextField(
        autofocus: true,
        onChanged: (value) {
          if (value.length == 1 && last == false) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && first == false) {
            FocusScope.of(context).previousFocus();
          }
        },
        showCursor: false,
        readOnly: false,
        controller: digito,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          counter: const Offstage(),
          enabledBorder: OutlineInputBorder(borderSide: const BorderSide(width: 2, color: Colors.black12), borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(borderSide: const BorderSide(width: 2, color: Colors.brown), borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ),
  );
}
