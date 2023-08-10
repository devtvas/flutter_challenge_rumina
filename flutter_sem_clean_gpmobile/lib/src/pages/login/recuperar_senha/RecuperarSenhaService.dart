import 'dart:convert';

//import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:gpmobile/src/pages/login/entrar/EntrarModel.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/BuscaUrl.dart';

import 'package:http/http.dart' as http;

class RecuperarSenhaServices {
  var _userGrou;

  Future<LoginModel> postRecuperarPorEmail(BuildContext context, String token,
      String usuario, int acaoNotificar, int acaoRecuperarSenha) async {
    try {
      final response = await http.post(
        await new BuscaUrl().url("login") + token,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'request': {
            'ttParam': {
              'ttParam': [
                {
                  'usuario': usuario, //cpf
                  'notificar': acaoNotificar, //1
                  'acao': acaoRecuperarSenha //2
                }
              ]
            }
          }
        }),
      );

      if (response.statusCode == 200) {
        var descodeJson = jsonDecode(response.body);
        _userGrou = LoginModel.fromJson(descodeJson);
        return _userGrou;
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

  ///[SMS]
  Future<LoginModel> postRecuperarPorSms(BuildContext context, String token,
      String usuario, int notificar, int acaoRecuperarSenha) async {
    try {
      final response = await http.post(
        await new BuscaUrl().url("login") + token,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'request': {
            'ttParam': {
              'ttParam': [
                {
                  'usuario': usuario, //cpf
                  'notificar': notificar, //1
                  'acao': acaoRecuperarSenha //2
                }
              ]
            }
          }
        }),
      );

      if (response.statusCode == 200) {
        var descodeJson = jsonDecode(response.body);
        _userGrou = LoginModel.fromJson(descodeJson);
        return _userGrou;
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
