//https://material.io/resources/color/#!/?view.left=0&view.right=0&primary.color=7B1FA2&secondary.color=8c4a9c (5/6)
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/widgets.dart';
import 'package:gradients/gradients.dart';

class AppColors {
  //
  static final Color primary = Color(0xFFC42224);
  static final Color purple = Color(0xFF8257E5);
  static final Color white = Color(0xFFFFFFFF);
  static final Color black = Color(0xFF514766);
  static final Color grey = Color(0xFF6E6680);
  static final Color lightGrey = Color(0xFFA6A1B2);
  static final Color border = Color(0xFFE1E1E6);
  static final Color chartSecondary = Color(0xFFE1E6E3);
  static final Color chartPrimary = darkGreen;

  //Txt
  static final Color txtSemFundo = Color(0xFFE1E1E6);

  //Icons
  static final Color iconSemFundo = Color(0xFFE1E1E6);

  //Greens
  static final Color lightGreen = Color(0xFFE1F5EC);
  static final Color green = Color(0xFFB8DBCB);
  static final Color darkGreen = Color(0xFF04D361);

  //Reds
  static final Color lightRed = Color(0xFFF5E9EC);
  static final Color red = Color(0xFFE5C5CF);
  static final Color darkRed = Color(0xFFCC3750);

  //LevelButton
  static final Color levelButtonFacil = Color(0xFFEBEBFC);
  static final Color levelButtonMedio = lightGreen;
  static final Color levelButtonDificil = Color(0xFFF5EFE9);
  static final Color levelButtonPerito = lightRed;

  static final Color levelButtonBorderFacil = Color(0xFFCECEF5);
  static final Color levelButtonBorderMedio = green;
  static final Color levelButtonBorderDificil = Color(0xFFE5D5C5);
  static final Color levelButtonBorderPerito = red;
  static final Color levelButtonTextFacil = Color(0xFF6363DB);
  static final Color levelButtonTextMedio = darkGreen;
  static final Color levelButtonTextDificil = Color(0xFFE8891C);
  static final Color levelButtonTextPerito = darkRed;
}

class ThemeHolerite {
  //BRANCO
  //primaColor = card, ref, botoes
  Color primaColor = new Color(0xFFe7edeb);
  //titleColor1 = titulo branco
  Color titleColor1 = new Color(0xFFe7edeb);
  //titleColor2 = titulo preto
  Color titleColorBlack = new Color(0xFF2e2a4f);
  //titleColor1 = titulo branco
  Color valorPositivo = new Color(0xFF0E8744); //0xFF04D361
  //titleColor2 = titulo preto
  Color valorNegativo = new Color(0xFFCC3750);

  //TRANSPARENT
  //primaColor = card, ref, botoes
  Color primaColorT = new Color(0xFFe7edeb);
  //titleColor1 = titulo branco
  Color titleColorBrancoT = new Color(0xFFe7edeb);
  //titleColor2 = titulo preto
  Color titleColorBlackT = new Color(0xFF2e2a4f);
  //titleColor1 = titulo branco
  Color valorPositivoT = new Color(0xFF04D361); //0xFF04D361
  //titleColor2 = titulo preto
  Color valorNegativoT = new Color(0xffEF5350);

  double isElevationT() {
    return 5;
  }
}

class Estilo {
  /* Secondary */
  Color prima = new Color(0xFF2e2a4f);
  /* Secondary */
  Color secon = new Color(0xFFC42224);
  /* Third */
  Color third = new Color(0xaae0e0e0);

  /* GERAL */
  Color branca = new Color(0xffFFFFFF); //rightHandSideColBackgroundColor:
  Color gray = new Color(0xffe0e0e0); //rightHandSideColBackgroundColor:
  Color textCor = new Color(0xffFFFFFF); // cores dos textos
  Color iconsCor = new Color(0xffFFFFFF); // cores dos icones
  Color splashCor = new Color(0xff2196f3); // cores dos icones
  Color appbar = new Color(0xaa6506FF);
  Color body = new Color(0xcc6506FF);
  Color footer = new Color(0xaa6506FF);
  Color fillColor = new Color(0xFFe7edeb);
  Color textCorDark = new Color(0xFF2e2a4f);

  /* Tela login*/
  Color btnEntrar = new Color(0xFFC42224); // botao login (CONTAINER)
  Color btnRegistrar = new Color(0xFF2e2a4f); // botao login (CONTAINER)
  Color btnBaixarApp = new Color(0xFF2e2a4f); // botao login (CONTAINER)

  /* Tela Home*/
  Color btnLogoff = new Color(0xff9E71EB); // ola, colaborador (CONTAINER)
  Color grayH = new Color(0xaae0e0e0); // ola, colaborador (CONTAINER)
  Color titleCorH = new Color(0xffFFFFFF); // cores titulo dos cards
  Color subTitleCorH = new Color(0xffFFFFFF); // cores subtitulo dos cards

  // /* Tela Perfil*/
  // Color appBarP = new Color(0xff6a1b9a); // appbar
  // Color bodyP = new Color(0xff6a1b9a); // corpo da tela
  // Color grayP = new Color(0xaae0e0e0); //
  Color userCorP = new Color(0xffFFFFFF); // cores nome usuario
  // Color dividerP = new Color(0xffb2dfdb); // cores divisor
  Color iconsP = new Color(0xaa004d40); // cores icones dos cards

  /*Tela Contra-Cheque */
  Color expandButtonCor = new Color(0xcc9E71EB);
  Color iconsCorC = new Color(0xff000000);
  Color statusPositiv = new Color(0xff91ff35);
  Color statusNegativ = new Color(0xffFFD7B0);
  Color eventPositiv = new Color(0xff4caf50);
  Color eventNegativ = new Color(0xffEF5350);
  Color eventOutros = new Color(0xff2196f3);
  Color ref = new Color(0xcc9E71EB);
  Color popUpCircle = new Color(0xffff5252);
  Color popUpIcon = new Color(0xffffffff);
  Color btnOK = new Color(0xaa6506FF);

  /* Tela Ponto*/
  Color colunaA = new Color(0xaa000000);
  Color colunaF = new Color(0xcc9E71EB); //leftHandSideColBackgroundColor:
  Color linha = new Color(0xcc9E71EB); //cor das linhas de divisao
  Color btnAssinar = new Color(0xaa6506FF); //cor das linhas
  Color popUpOk = new Color(0xff9E71EB); //cor das linhas
  Color popUpCancelar = new Color(0xff9E71EB); //cor das linhas
  // Color btnAssinar = new Color(0xaa6506FF); //cor das linhas

  // /* Tela Config*/

  Color btnVoltar = new Color(0xffFFFFFF); //cor das linhas
  Color textCorWhite = new Color(0xfffffff1); //cor das linhas
  Color textCorBlack = new Color(0x61000000); //cor das linhas

  double isElevation() {
    return 20;
  }
}

class AppGradients {
  static final gradient = BoxDecoration(
    gradient: LinearGradientPainter(
      end: Alignment.topRight,
      begin: Alignment.bottomLeft,
      colors: <Color>[
        Color(0xFF2e2a4f),
        Color(0xFFC42224),
      ],
    ),
  );

  static final appBarGradient = BoxDecoration(
    gradient: LinearGradient(
      end: Alignment.bottomLeft,
      begin: Alignment.topRight,
      // end: Alignment.topRight,
      // begin: Alignment.bottomLeft,
      colors: <Color>[
        Color(0xFF2e2a4f),
        Color(0xFFC42224),
      ],
    ),
  );

  static final linear2 = LinearGradient(
    colors: [
      Color(0xFFC42224),
      Color(0xFF2e2a4f),
    ],
    stops: [0.0, 0.695],
    transform: GradientRotation(2.13959913 * pi),
  );

  static final linear = LinearGradient(
    colors: [
      Color(0xFF57B6E5),
      Color.fromRGBO(130, 87, 229, 0.695),
    ],
    stops: [0.0, 0.695],
    transform: GradientRotation(2.13959913 * pi),
  );

  static final splashGradient = LinearGradient(
    end: Alignment.topRight,
    begin: Alignment.bottomLeft,
    colors: <Color>[
      Color(0xFF2e2a4f),
      Color(0xFFC42224),
    ],
  );
}

class AppTextStyles {
  static final TextStyle title = GoogleFonts.notoSans(
    color: AppColors.white,
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle titleBold = GoogleFonts.notoSans(
    color: AppColors.white,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle heading = GoogleFonts.notoSans(
    color: AppColors.black,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle heading40 = GoogleFonts.notoSans(
    color: AppColors.black,
    fontSize: 40,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle heading15 = GoogleFonts.notoSans(
    color: AppColors.black,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle body = GoogleFonts.notoSans(
    color: AppColors.grey,
    fontSize: 13,
    fontWeight: FontWeight.normal,
  );

  static final TextStyle bodyBold = GoogleFonts.notoSans(
    color: AppColors.grey,
    fontSize: 13,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle bodylightGrey = GoogleFonts.notoSans(
    color: AppColors.lightGreen,
    fontSize: 13,
    fontWeight: FontWeight.normal,
  );
  static final TextStyle bodyDarkGreen = GoogleFonts.notoSans(
    color: AppColors.darkGreen,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle bodyDarkRed = GoogleFonts.notoSans(
    color: AppColors.darkRed,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle body20 = GoogleFonts.notoSans(
    color: AppColors.grey,
    fontSize: 20,
    fontWeight: FontWeight.normal,
  );
  static final TextStyle bodyLightGrey20 = GoogleFonts.notoSans(
    color: AppColors.lightGrey,
    fontSize: 20,
    fontWeight: FontWeight.normal,
  );

  static final TextStyle bodyWhite20 = GoogleFonts.notoSans(
    color: AppColors.white,
    fontSize: 20,
    fontWeight: FontWeight.normal,
  );
  static final TextStyle body11 = GoogleFonts.notoSans(
    color: AppColors.grey,
    fontSize: 11,
    fontWeight: FontWeight.normal,
  );
}
