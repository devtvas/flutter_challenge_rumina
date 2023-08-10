import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/login/entrar/EntrarModel.dart';

import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/TokenModel.dart';
import 'package:gpmobile/src/util/TokenServices.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'RecuperarSenhaService.dart';

class RecuperarSenhaBloc extends BlocBase {
  blocRecPorEmail(BuildContext context, int acaoNotificar,
      int acaoRecuperarSenha, String tipo, bool barraStatus) async {
    TokenModel token;
    LoginModel userGroup;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _usuarioPrefs = prefs.getString('usuario');
    // List<StatusModel> list = [];

    ProgressDialog progressDialog = new AlertDialogTemplate()
        .showProgressDialog(context, "Recuperando senha do usuário...");
    if (barraStatus == true) {
      await progressDialog.show();
    }

    await new TokenServices().getToken().then((map) async {
      token = map;

      if (token == null) {
        progressDialog.hide();
        AlertDialogTemplate()
            .showAlertDialogSimples(context, "Atencão", "Erro ao buscar token");
      } else {
        await new RecuperarSenhaServices()
            .postRecuperarPorEmail(context, token.response.token, _usuarioPrefs,
                acaoNotificar, acaoRecuperarSenha)
            .then((map) async {
          userGroup = map;
          if (userGroup == null || userGroup.response.pIntCodErro != 0) {
            //Caso não encontre usuário no datasul
            progressDialog.hide();
            if (barraStatus == true) {
              await AlertDialogTemplate().showAlertDialogSimples(
                  context, "Atencão", "Usuário ou senha inválido");
            }
            //Caso encontre, armazena dados storage Local
          } else {
            return await AlertDialogTemplate().showAlertDialogSimples(
                context, "Atencão", "$tipo enviado com sucesso!");
          }
        });
      }
      //fechar popup e voltar para tela login 26/08/21
      progressDialog.hide();
      Navigator.of(context).pop();
    });
  }
}
