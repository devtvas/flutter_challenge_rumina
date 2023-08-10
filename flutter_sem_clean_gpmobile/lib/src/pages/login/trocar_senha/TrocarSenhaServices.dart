import 'dart:convert';

//import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:gpmobile/src/pages/login/entrar/EntrarModel.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/BuscaUrl.dart';

import 'package:http/http.dart' as http;

class TrocarSenhaServices {
  var _trocarServices;

  Future<LoginModel> postTrocaDeSenha(
    BuildContext context,
    String token,
    String postUsuario,
    String postNovaSenha,
    int postNotificar,
    int postTrocarSenha,
  ) async {
    try {
      final response = await http.post(
        await new BuscaUrl().url("login") + token,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "request": {
            "ttParam": {
              "ttParam": [
                {
                  "usuario": postUsuario,
                  "senhaNova": postNovaSenha,
                  "notificar": postNotificar,
                  "acao": postTrocarSenha
                }
              ]
            }
          }
        }),
      );
      if (response.statusCode == 200) {
        var descodeJson = jsonDecode(response.body);
        _trocarServices = LoginModel.fromJson(descodeJson);
        return _trocarServices;
      } else {
        await new AlertDialogTemplate().showAlertDialogSimples(
            context,
            "Error",
            "Error ao buscar usuario! \n" +
                "Código Erro: " +
                response.statusCode.toString());
        return null;
      }
    } catch (e) {
      await new AlertDialogTemplate().showAlertDialogSimples(
          context, "Error", "Error ao buscar usuario! \n " + e.toString());
      return null;
    }
  }
}
