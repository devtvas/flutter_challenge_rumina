import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/util/Estilo.dart';

import 'package:gpmobile/src/util/images.dart';

class IntroWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;

    final cardImage = new Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      alignment: Alignment.topCenter,
      child: Image.asset(
        imageLogoGrupoVertical,
        width: width * 0.1,
        height: height * 0.1,
        filterQuality: FilterQuality.high,
        // width: 2,
        // height: 2,
      ),
    );

    return SingleChildScrollView(
      child: Container(
        decoration: AppGradients.gradient,
        width: 500,
        height: 800,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Bem Vindo!",
              style: TextStyle(color: Colors.white70, fontSize: 50),
            ),
            cardImage,
          ],
        ),
      ),
    );
  }
}
