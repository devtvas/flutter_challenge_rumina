import 'package:flutter/material.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:gpmobile/src/util/constants.dart';
import 'package:gpmobile/src/util/images.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashWidget extends StatelessWidget {
  const SplashWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      image: new Image.asset(
        imageLogoGrupoVertical,
        // scale: 2.9, //scale < == imagem maior
        fit: BoxFit.fill,
      ),
      loaderColor: Colors.red,
      loadingText: Text(
        "Bem Vindo, ao aplicativo GP Mobile",
        style: TextStyle(color: Colors.white),
      ),
      photoSize: 100.0, //definir tamanho da imagem...
      seconds: 5,
      navigateAfterSeconds: LOGIN,
      gradientBackground: AppGradients.splashGradient,
    );
  }
}
