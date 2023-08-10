import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/mensagens/model/StatusMensaModel.dart';
import 'package:gpmobile/src/pages/mensagens/vizualizar_mensagens/PageHeroWidget.dart';
import 'package:gpmobile/src/pages/mensagens/vizualizar_mensagens/VisualizaMensaWidget.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/GenericLogsModel.dart';
import 'package:gpmobile/src/util/TokenModel.dart';
import 'package:gpmobile/src/util/TokenServices.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ListaMensaService.dart';

class ListaMensaBloc extends BlocBase {
  /////////////////////////////////////////////////////////////////////
  Future<List<StatusModel>> getMessageBack(
      BuildContext context, bool barraStatus) async {
    /// *[VARIAVEIS]
    String sistema = "DATASUL";
    String modulo = "APP_DP";
    String programa = "MENSAGERIA";
    String rotina = "ENVIAR MENSAGEM";
    int intTipoRetonoRegistros = 2;
    String dtIniFiltro = "01/01/2021";
    String dtFimFiltro = "01/12/9999";
    List<StatusModel> listaMensBack = new List();
    TokenModel token;
    GenericLogsModel _blocMensagens;
    
    ProgressDialog progressDialog = new AlertDialogTemplate()
        .showProgressDialog(context, "Carregando tabela de mensagens!");

    //
    if (barraStatus == true) {
      // Future.delayed(Duration(microseconds: 2000)).then((value) {
      // progressDialog.show();
      // });

      await new TokenServices().getToken().then((map) async {
        //geovane2
        token = map;

        if (token == null) {
          AlertDialogTemplate().showAlertDialogSimples(
              context, "Atencao", "Erro ao buscar token!");
          progressDialog.hide();
          return null;
        } else {
          await new VisualizarMensaService()
              .getMensaService(
            context,
            token.response.token,
            sistema,
            modulo,
            programa,
            rotina,
            intTipoRetonoRegistros,
            dtIniFiltro,
            dtFimFiltro,
            // intSequencia
          )
              .then((map) async {
            _blocMensagens = map;
            progressDialog.hide();
            if (_blocMensagens.response == null ||
                _blocMensagens.response.pIntCodErro != 0 &&
                    _blocMensagens.response.pIntCodErro != 2) {
              //Caso não encontre usuário

              if (barraStatus == true) {
                await AlertDialogTemplate().showAlertDialogSimples(
                    context,
                    "Atencao",
                    "Erro ao buscar Tabela de mensagens! \nerro:" +
                        _blocMensagens.response.pChrDescErro);
              }
              return null;
            } else {
              //instanciei o objeto para acessar os atributos da mesma...
              for (TtLog2 ttMov2 in _blocMensagens.response.ttLog.ttLog2) {
                StatusModel mensStatus = new StatusModel();
                mensStatus.titulo = ttMov2.chrTexto.split('*-*')[0];
                mensStatus.mensagem = ttMov2.chrTexto.split('*-*')[1];
                mensStatus.data = ttMov2.chrTexto.split('*-*')[2];
                mensStatus.matriculasView = ttMov2.chrTexto
                    .split('*-*')[3]; //receber todas as amtriculas
                mensStatus.sequencia = ttMov2.intSequencia;
                mensStatus.lido = false;
                listaMensBack.add(mensStatus);
              }

              //retorno da nova lista populada
            }
          });
          progressDialog.hide();
        }
      });
    }
    return listaMensBack;
  }

  ////////////////////////////////////////////////////////////////////////////////////////////
  Future<List<String>> getListaMensaLida(
      BuildContext context, bool barraStatus) async {
    List<String> listMenBanco = [];
    final prefs = await SharedPreferences.getInstance();
    listMenBanco = prefs.getStringList('listaMensagensLidas') ?? [];
    return listMenBanco;
  }

  ////////////////////////////////////////////////////////////////////////////////////////////

  // update 05/08
  Future<bool> actionOpenMsg(
      BuildContext context, StatusModel objMensa, _barraStatus) async {
    if (_barraStatus == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => new VisualizaMensaWidget(
          HeroType(data: objMensa.data, titulo: objMensa.titulo, mensagem: objMensa.mensagem),
          objMensa),
        ),
      );
    }
    return _barraStatus;
  }

  Future<List<StatusModel>> atualizaListaDeMensagens(context) async {
    List<StatusModel> listaGlobalAtualiza;
    List<StatusModel> listaFinal = new List();
    List<StatusModel> listaFinal2 = new List();
    SharedPreferences.getInstance().then((prefs) {
      ListaMensaBloc().getMessageBack(context, true).then((map1) {
        // StatusModelMok().list().then((map1) {
        // setState(() {
        if (map1 != null) {
          listaGlobalAtualiza = map1;

          if (map1 != null && map1.length > 0) {
            for (StatusModel indexList in listaGlobalAtualiza) {
              for (String matricula in indexList.matriculasView.split(",")) {
                if (matricula == prefs.getString('matricula'))
                  indexList.lido = true;
              }
              // setState(() {
              listaFinal.add(indexList);
              // });
            }
          } else {
            for (StatusModel mensBack1 in listaGlobalAtualiza) {
              // setState(() {
              listaFinal.add(mensBack1);
              // });
            }
          }
          // setState(() {
          listaFinal2.clear();
          ListaMensaBloc().addListener(() {
            listaFinal2
                .addAll(listaFinal.where((element) => element.lido == false));
          });
          // listaFinal2
          //     .addAll(listaFinal.where((element) => element.lido == false));
          // });
        }
        // });
        return listaFinal2;
      });
    });
  }

  Future<void> atualizarStatus(context) async {
    print('mensagem da listMensaBloc');
    List<StatusModel> listaFinal = [];
    SharedPreferences.getInstance().then((prefs) {
      ListaMensaBloc().getMessageBack(context, true).then((map1) {
        if (map1 != null) {
          listaFinal = map1;
          // if (map1 != null) {
          for (StatusModel mensagem in listaFinal) {
            for (String matricula in mensagem.matriculasView.split(",")) {
              if (matricula == prefs.getString('matricula')) {
                mensagem.lido = true;
              }
            }
          }
          // }
        }
      });
    });
  }

  Future<void> atualizarStatusWeb(context) {
    List<StatusModel> listaFinal = [];
    print("Atualizando tela de mensagens!!!");
    SharedPreferences.getInstance().then((prefs) {
      ListaMensaBloc().getMessageBack(context, true).then((map1) {
        if (map1 != null) {
          listaFinal = map1;
          if (map1 != null) {
            for (StatusModel mensagem in listaFinal) {
              for (String matricula in mensagem.matriculasView.split(",")) {
                if (matricula == prefs.getString('matricula')) {
                  mensagem.lido = true;
                }
              }
            }
          }
        }
      });
    });
  }

  Future<List<StatusModel>> refreshList(context) async {
    List<StatusModel> listaMapeada = [];
    SharedPreferences.getInstance().then((prefs) {
      ListaMensaBloc().getMessageBack(context, true).then((mapRefList) {
        if (mapRefList != null) {
          listaMapeada = mapRefList;
          for (StatusModel statusModel in listaMapeada) {
            for (String matricula in statusModel.matriculasView.split(",")) {
              if (matricula == prefs.getString('matricula')) {
                statusModel.lido = true;
              }
            }
          }
        }
        return listaMapeada;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
