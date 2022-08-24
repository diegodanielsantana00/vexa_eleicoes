import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:vexa_eleicoes/Controller/criptografia_controller.dart';
import 'package:vexa_eleicoes/Controller/navigator_controller.dart';
import 'package:vexa_eleicoes/Models/imei_context.dart';
import 'package:vexa_eleicoes/Views/home_screen.dart';
import 'package:vexa_eleicoes/main.dart';

bool awaitValidation = false;
bool startAds = true;
const int maxFailedLoadAttempts = 3;

class AwaitScreen extends StatefulWidget {
  const AwaitScreen({Key? key}) : super(key: key);

  @override
  _AwaitScreenState createState() => _AwaitScreenState();
}

class _AwaitScreenState extends State<AwaitScreen> {
  // ignore: prefer_const_constructors
  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: "http://foo.com/bar.html",
    nonPersonalizedAds: true,
  );

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Platform.isAndroid ? 'ca-app-pub-8356045296456606/1527656706' : 'ca-app-pub-8356045296456606/7100860669',
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
            mostrarAds();
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) => print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  @override
  void initState() {
    super.initState();
    ativarAds();

    scheduleDailyTenAMNotificationNoPremium();
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
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), image: const DecorationImage(image: AssetImage('assets/img/urna.png'))),
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

  mostrarAds() async {
    if (startAds) {
      _showInterstitialAd();
      var teste = Timer.periodic(const Duration(seconds: 65), (timer) async {
        _showInterstitialAd();
      });
      NavigatorController().navigatorToNoReturn(context, const HomeScreen(false));
      startAds = false;
    }
  }

  ativarAds() async {
    if (await IMEIContext().consultarIMEICripto(CriptografiaController().criptografarIMEI(await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: true)))) {
      _createInterstitialAd();
    } else {
      NavigatorController().navigatorToNoReturn(context, const HomeScreen(false));
    }
  }

  Future<void> scheduleDailyTenAMNotificationNoPremium() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        '🔴 AO VIVO',
        'Venha conferir o resultado da enquete até HOJE 🇧🇷',
        _nextInstanceOfTenAM(),
        const NotificationDetails(
          android: AndroidNotificationDetails('Vexa Eleições', '🔴 AO VIVO', 'Venha conferir o resultado da enquete até HOJE 🇧🇷'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  tz.TZDateTime _nextInstanceOfTenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 11);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
