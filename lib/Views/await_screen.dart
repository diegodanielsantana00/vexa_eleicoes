import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:vexa_eleicoes/Controller/navigator_controller.dart';
import 'package:vexa_eleicoes/Views/home_screen.dart';

bool awaitValidation = false;

class AwaitScreen extends StatefulWidget {
  const AwaitScreen({Key? key}) : super(key: key);

  @override
  _AwaitScreenState createState() => _AwaitScreenState();
}

class _AwaitScreenState extends State<AwaitScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      NavigatorController().navigatorToNoReturn(context, const HomeScreen(false));
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: HexColor('#A09D7A'),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            height: size.height * 0.4,
            width: size.height * 0.4,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
             image: const DecorationImage(image: AssetImage('assets/img/urna.png'))),
          ),
          
              SizedBox(
                height: size.width * 0.2,
                width: size.width * 0.2,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ));
  }
}
