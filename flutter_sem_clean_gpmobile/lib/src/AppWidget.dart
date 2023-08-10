//https://blog.codemagic.io/flutter-web-getting-started-with-responsive-design/
import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/login/entrar/EntrarWidget.dart';
import 'package:gpmobile/src/pages/ponto/PontoWidget.dart';
import 'package:gpmobile/src/util/constants.dart';

import 'package:responsive_framework/responsive_framework.dart';

import 'pages/login/recuperar_senha/RecuperarSenhaWidget.dart';
import 'pages/login/trocar_senha/TrocarSenhaWidget.dart';
import 'pages/contraCheque/ContraChequeWidget.dart';
import 'pages/documentos/listar/ListarDocWidget.dart';
import 'pages/home/HomeWidget.dart';
import 'pages/mensagens/model/StatusMensaModel.dart';
import 'pages/mensagens/vizualizar_mensagens/PageHeroWidget.dart';
import 'pages/mensagens/vizualizar_mensagens/VisualizaMensaWidget.dart';
import 'splash/SplashWidget.dart';
import 'util/pdf_view.dart';

class AppWidget extends StatefulWidget {
  @override
  _AppWidgetState createState() => new _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  //
  final themeData = ThemeData(
    backgroundColor: Color(0xFFC42224),
  );
  @override
  Widget build(BuildContext context) {
    HeroType _heroType;
    StatusModel _statusModel;
    //
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      builder: (context, widget) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, widget),
          maxWidth: double.infinity,
          minWidth: 450,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.autoScale(1000, name: TABLET),
            ResponsiveBreakpoint.resize(1200, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(2460, name: "4K"),
          ],
          background: Container(color: Color(0xFFF5F5F5))),
      // home: nao precisa do atributo home: quando rotas nomeadas!
      initialRoute: SPLASH_SCREEN,
      routes: <String, WidgetBuilder>{
        SPLASH_SCREEN: (BuildContext context) => SplashWidget(),
        LOGIN: (BuildContext context) => EntrarWidget(),
        RECUPERAR_SENHA: (BuildContext context) => RecuperarSenhaWidget(),
        HOME: (BuildContext context) => HomeWidget(),
        //rotas nao utilizadas
        HOLERITE: (BuildContext context) => ContraChequeWidget(),
        PONTO: (BuildContext context) => PontoWidget(null, null),
        LISTAR_DOC: (BuildContext context) => ListarDocWidget(),
        TROCAR_SENHA: (BuildContext context) => TrocarSenhaWidget(),
        TEST: (BuildContext context) => PdfViwerWidget(),
      },

      // initialRoute: HOME,
    );
  }
}
