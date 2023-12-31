import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/home/HomeWidget.dart';
import 'package:gpmobile/src/pages/login/entrar/EntrarModel.dart';
import 'package:gpmobile/src/pages/login/entrar/EntrarServices.dart';

import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/TokenModel.dart';
import 'package:gpmobile/src/util/TokenServices.dart';
import 'package:gpmobile/src/util/constants.dart';
import 'package:gpmobile/src/versao/ValidaVersaoBloc.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EntrarBloc extends BlocBase {
  validarUsuario(BuildContext context, String usuario, String senhaAtual,
      int acao, String plataforma, bool barraStatus) async {
    TokenModel token;
    LoginModel userGroup;
    // List<StatusModel> list = [];

    ProgressDialog progressDialog = new AlertDialogTemplate()
        .showProgressDialog(context, "Validando usuário...");
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
        await new LoginServices()
            .postUser(context, token.response.token, usuario, senhaAtual, acao)
            .then((map) async {
          userGroup = map;
          if (userGroup == null || userGroup.response.pIntCodErro != 0) {
            //Caso não encontre usuário no datasul
            progressDialog.hide();
            if (barraStatus == true) {
              await AlertDialogTemplate().showAlertDialogSimples(
                  context, "Atencão", "Usuário ou senha inválido");
            }
            //Caso encontre armazena dados storage Local
          } else {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            //
            prefs.setString('usuario',
                userGroup.response.ttUsuario.ttUsuario[0].usuario.toString());
            //
            prefs.setString('senha',
                userGroup.response.ttUsuario.ttUsuario[0].senha.toString());
            //
            prefs.setString('nomecolaborador',
                userGroup.response.ttUsuario.ttUsuario[0].nome.toString());
            //
            prefs.setString('ambiente', "producao");
            //
            prefs.setString(
                'matricula',
                userGroup.response.ttUsuario.ttUsuario[0].matriculaFunc
                    .toString());
            //
            prefs.setString('empresa',
                userGroup.response.ttUsuario.ttUsuario[0].codEmpresa);
            //
            prefs.setString('cargo',
                userGroup.response.ttUsuario.ttUsuario[0].cargo.toString());
            //
            prefs.setString(
                'nomeEmpresa',
                userGroup.response.ttUsuario.ttUsuario[0].nomeEmpresa
                    .toString());
            //
            prefs.setString('dataAdmissao',
                userGroup.response.ttUsuario.ttUsuario[0].dataAdmissao);

            prefs.setBool('userAdmin',
                userGroup.response.ttUsuario.ttUsuario[0].userAdmin);

            // ///[true] = forçar usuario admin!
            // prefs.setBool('userAdmin', true);

            prefs.setString(
                'userTelefone',
                userGroup.response.ttUsuario.ttUsuario[0].num_telefone
                    .toString());

            prefs.setString(
                'userEmail', userGroup.response.ttUsuario.ttUsuario[0].email);

            ///
            dispose();
            progressDialog.hide();
            // Navigator.of(context).pushNamed(routeHomeWidget);

            switch (plataforma) {
              case "mob":
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => new HomeWidget()));
                break;
              case "web":
                Navigator.of(context).pushNamed(HOME);
                break;
              default:
            }
          }
        });
      }
    });
  }

  Future<bool> versaoEstaAtualizada(BuildContext context) async {
    dynamic versaoApp = ValidaVersaoBloc.getVersaoAppDp();
    dynamic ultimaVersaoLiberada;
    bool ret;
    await ValidaVersaoBloc()
        .getUltimaVersaoLiberada(context, true)
        .then((value) {
      if (value == null) {
        ultimaVersaoLiberada = 0;
      } else {
        ultimaVersaoLiberada = value;
      }
    });

    if (versaoApp < ultimaVersaoLiberada) {
      ret = false;
    } else {
      ret = true;
    }

    return ret;
  }

  Future<String> getMatricula() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _matricula = prefs.getString('matricula');
    return _matricula;
  }

  Future<String> getUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _usuario = prefs.getString('usuario');
    return _usuario;
  }

  Future<String> getSenha() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _senha = prefs.getString('senha');
    return _senha;
  }

//funcao alterar senha
  Future<TextEditingController> alterarSenha(
      BuildContext context, String novaSenha, bool) {
    //ENVIAR PARA BACK NOVA SENHA....
  }
//
  StreamController<LoginModel> _streamController = StreamController.broadcast();

  Stream<LoginModel> get selectedRoom => _streamController.stream;

  Function(LoginModel) get enterRoom => _streamController.add;

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}
