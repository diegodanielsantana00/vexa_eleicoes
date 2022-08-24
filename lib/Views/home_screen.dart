// ignore_for_file: prefer_const_literals_to_create_immutables
import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vexa_eleicoes/Controller/navigator_controller.dart';
import 'package:vexa_eleicoes/Models/candidatos_context.dart';
import 'package:vexa_eleicoes/Views/cpf_screen.dart';

class HomeScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final votou;
  const HomeScreen(this.votou, {Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    var teste = Timer.periodic(const Duration(seconds: 120), (timer) {
      refresh();
    });
    dialogVote();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          title: Row(
            children: [
              const Icon(Icons.circle, color: Colors.red),
              const SizedBox(
                width: 10,
              ),
              const Text(
                "Ao Vivo",
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              color: Colors.black,
              onPressed: () {
                Share.share('Enquete eleitoral AO VIVO, Participe agora!! https://play.google.com/store/apps/details?id=com.diegodaniel.vexa_eleicoes');
              },
            ),
            IconButton(
              icon: const Icon(Icons.info_outline_rounded),
              color: Colors.black,
              onPressed: () {
                AwesomeDialog(
                        context: context,
                        dialogType: DialogType.INFO,
                        animType: AnimType.BOTTOMSLIDE,
                        title: 'Informações',
                        desc:
                            '1º Este aplicativo não tem vinculação nenhuma com qualquer instituição.\n2º Dados totalmente criptografados.\n3º não compartilhamos os dados gravados com nenhuma instituição.\n4º Aplicativo para fins educational.\n5º Números dos candidatos totalmente fictício  \n6º Para dúvidas mande um email para vexaltda@gmail.com',
                        btnOkOnPress: () {},
                        headerAnimationLoop: false)
                    .show();
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: IconButton(
                icon: const Icon(
                  Icons.warning_amber_rounded,
                  size: 27,
                ),
                color: Colors.red,
                onPressed: () {
                  AwesomeDialog(
                          context: context,
                          dialogType: DialogType.WARNING,
                          animType: AnimType.BOTTOMSLIDE,
                          title: 'Enquete',
                          desc: 'ENQUETE NÃO É PESQUISA !! Enquete não possui valor científico e não pode ser confundida com pesquisa eleitoral.',
                          btnOkOnPress: () {},
                          headerAnimationLoop: false)
                      .show();
                },
              ),
            ),
          ]),
      body: FutureBuilder<Map>(
        future: CandidatoContext().getCandidatos(),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            var numerosCandidatos = snapshot.data!.keys.toString().replaceAll("(", "").replaceAll(")", "").replaceAll(" ", "").split(",");

            var qtdVotosTotais = 0;
            for (var i = 0; i < snapshot.data!.length; i++) {
              qtdVotosTotais += int.parse(snapshot.data![numerosCandidatos[i]]["qtdvotos"].toString());
            }

            return ListView.builder(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.only(left: 16, right: 16),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.fromLTRB(0, 7, 0, 6),
                    width: size.width * 0.8,
                    height: size.height * 0.12,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.grey,
                            offset: Offset(
                              5.0,
                              5.0,
                            ),
                            blurRadius: 6.0,
                          ), //BoxShadow
                          const BoxShadow(
                            color: Colors.white,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          ), //BoxShadow
                        ],
                        color: Colors.black12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Container(
                                width: size.width * 0.2,
                                height: size.height * 0.1,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(snapshot.data![numerosCandidatos[index]]["img"] == "null" ? "assets/img/null.png" : "assets/img/${numerosCandidatos[index]}.png"),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(snapshot.data![numerosCandidatos[index]]["nome"], style: TextStyle(fontWeight: FontWeight.bold)),
                                Text("Nº " + numerosCandidatos[index]),
                                Text(snapshot.data![numerosCandidatos[index]]["partido"]),
                                Text(
                                    snapshot.data![numerosCandidatos[index]]["qtdvotos"].toString() +
                                        " " +
                                        (int.parse(snapshot.data![numerosCandidatos[index]]["qtdvotos"].toString()) >= 2 ? "Votos" : "Voto"),
                                    style: TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: size.height * 0.03,
                            width: size.width * 0.18,
                            decoration: BoxDecoration(
                              // color: HexColor('#A09D7A'),
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                                child: Text(
                              ((snapshot.data![numerosCandidatos[index]]["qtdvotos"] / qtdVotosTotais) * 100).toStringAsFixed(2) + "%",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[100]),
                            )),
                          ),
                        ),
                      ],
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return Scaffold(
                backgroundColor: Colors.red[300],
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 200.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.white,
                              size: 200,
                            ),
                            const Text(
                              "Conecte a internet",
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ));
          } else {
            children = <Widget>[
              const SizedBox(
                child: CircularProgressIndicator(color: Colors.black),
                width: 60,
                height: 60,
              ),
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
      floatingActionButton: Container(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton.extended(
          onPressed: () async {
            //         Map<Permission, PermissionStatus> statuses = await [
            //   Permission.bluetooth
            //   // Permission.,
            // ].request();

            // print(statuses);
            NavigatorController().navigatorToReturn(context, const CPFScreen());
          },
          backgroundColor: Colors.green,
          icon: const Icon(Icons.assignment_turned_in_sharp),
          label: const Text("Votar"),
        ),
      ),
    );
  }

  void dialogVote() async {
    if (widget.votou) {
      bool auxVotoDialog = true;
      while (auxVotoDialog) {
        try {
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.SUCCES,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'Voto enviado para processamento',
                  desc: 'Seu voto foi enviado para processamento, em torno de 3 mim a lista de votos será atualizada',
                  btnOkOnPress: () {},
                  // btnCancelText: "Ok",
                  headerAnimationLoop: false)
              .show();
          auxVotoDialog = false;
        } catch (e) {
          await Future.delayed(const Duration(microseconds: 30));
        }
      }
    }
  }
}
