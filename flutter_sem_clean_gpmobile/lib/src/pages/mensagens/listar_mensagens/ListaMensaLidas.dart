//https://github.com/iang12/flutter_url_launcher_example/blob/master/lib/main.dart

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:gpmobile/src/pages/mensagens/editar_mensagens/EditarMensaWidget.dart';
import 'package:gpmobile/src/pages/mensagens/enviar_mensagens/EnviarMensaBloc.dart';
import 'package:gpmobile/src/pages/mensagens/enviar_mensagens/EnviarMensaWidget.dart';
import 'package:gpmobile/src/pages/mensagens/model/StatusMensaModel.dart';
import 'package:gpmobile/src/pages/mensagens/vizualizar_mensagens/PageHeroWidget.dart';
import 'package:gpmobile/src/pages/mensagens/vizualizar_mensagens/VisualizaMensaWidget.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:gpmobile/src/util/SharedPreferencesBloc.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ListaMensaBloc.dart';

class ListaMensaLidas extends StatefulWidget {
  const ListaMensaLidas({
    Key key,
  }) : super(key: key);

  @override
  _ListaMensaLidasState createState() => _ListaMensaLidasState();
}

class _ListaMensaLidasState extends State<ListaMensaLidas> {
  //
  StatusModel objMensaEndDrawer;
  //
  String titulo;
  String mensg;
  String data;
  String matriculasView;
  String origemClick = "";
  //
  int sequencia;
  int indexPage;
  int count = 0;
  //
  List statusModel = <StatusModel>[];
  List<StatusModel> listaFinal = [];
  List mainList = new List();
  //
  bool lido;
  bool _userAdmin;
  bool _habilitaButton = false;
  //
  final GlobalKey<ScaffoldState> _tabKeyListaMensaLidas =
      GlobalKey<ScaffoldState>();
  //
  Random random = Random();
  MultiSelectController controller;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  //
  @override
  void initState() {
    // mainList.add({"key": "1"});
    // _animationController = AnimationController(vsync: this);
    controller = MultiSelectController();
    controller.disableEditingWhenNoneSelected = true;
    controller.set(listaFinal.length);

    setState(() {
      SharedPreferencesBloc().buscaParametroBool("userAdmin").then((retorno2) {
        _userAdmin = retorno2;

        if (_userAdmin == false) {
          setState(() {
            _habilitaButton = _userAdmin;
          });
        } else {
          setState(() {
            _habilitaButton = _userAdmin;
          });
        }
      });
    });
    super.initState();
    // _atualizaPorTempo.run(() {
    //inicio
    SharedPreferences.getInstance().then((prefs) {
      ListaMensaBloc().getMessageBack(context, true).then((map2) {
        List<StatusModel> listaMapeada = map2;
        setState(() {
          if (map2 != null) {
            listaFinal = listaMapeada;
            for (StatusModel mensagem in listaFinal) {
              for (String matricula in mensagem.matriculasView.split(",")) {
                if (matricula == prefs.getString('matricula')) {
                  mensagem.lido = true;
                }
              }
            }
          }
        });
      });
    });
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _tabKeyListaMensaLidas,
      body: Container(
        decoration: AppGradients.gradient,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 599) return listaMensaLidasWeb();
            if (constraints.maxWidth > 599) listaMensaLidasWeb();
            return listaMensaLidasWeb();
          },
        ),
      ),
      endDrawer: ConditionalSwitch.single<String>(
          context: context,
          valueBuilder: (BuildContext context) => origemClick,
          caseBuilders: {
            'viewMensa': (BuildContext context) =>
                // new VisualizaMensaWidget(objMensaEndDrawer),
                new VisualizaMensaWidget(
                    HeroType(
                        data: objMensaEndDrawer.data,
                        titulo: objMensaEndDrawer.titulo,
                        mensagem: objMensaEndDrawer.mensagem),
                    objMensaEndDrawer),
            'createMensa': (BuildContext context) => EnviarMensaWidget(),
            // 'EnviarMensaWidget': (BuildContext context) => ProductCard(),
            'editMensa': (BuildContext context) =>
                new EditarMensaWidget(objMensaEndDrawer),
          },
          fallbackBuilder: (BuildContext context) {
            return Card(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  // const Icon(Icons.close, size: 60, color: Colors.red),
                  IconButton(
                    // color: Colors.red,
                    onPressed: closeEndDrawer,
                    icon: Icon(Icons.close, size: 60, color: Colors.red),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  const Text(
                    'Erro: Favor contactar o departameto de tecnologia!!!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }),
      endDrawerEnableOpenDragGesture: false,
    );
  }

  //WEB
  Widget listaMensaLidasWeb() {
    //
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
//
    final txtAppBarTitle = (controller.isSelecting)
        ? Text('Selecionado(s) ${controller.selectedIndexes.length}  ')
        : Text(
            "MENSAGENS LIDAS",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),
          );
    //
    final btnAddMensa = _habilitaButton == false
        ? new IconButton(
            icon: Icon(Icons.add_comment,
                size: 30, color: Colors.amber.withOpacity(0.0)),
            splashColor: Colors.blue,
            splashRadius: 20,
            onPressed: null)
        : new IconButton(
            icon: Icon(
              Icons.add_comment,
              color: AppColors.iconSemFundo,
              size: 30,
            ),
            splashColor: Colors.blue,
            splashRadius: 20,
            onPressed: () {
              setState(() {
                origemClick = "createMensa";
                _openEndDrawer(9999);
              });
            },
          );
    //
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        title: txtAppBarTitle,
        actions: [
          btnAddMensa,
          // btnRefresh,
        ],
      ),
      //
      body: listaFinal.isEmpty
          ? Center(
              child: Text(
                'Lista vazia no momento!',
                style: TextStyle(
                  color: AppColors.txtSemFundo,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : SmartRefresher(
              header: WaterDropHeader(waterDropColor: Colors.green),
              controller: _refreshController,
              onRefresh: _onRefresh,
              //
              child: ListView.builder(
                itemCount: listaFinal.length,
                itemBuilder: (BuildContext context, int index) {
                  StatusModel objMensaWeb = listaFinal[index];

                  return MultiSelectItem(
                    isSelecting: controller.isSelecting,
                    onSelected: () {
                      setState(() {
                        controller.toggle(index);
                      });
                    },
                    child: Column(
                      children: [
                        //acao click!
                        GestureDetector(
                          onTap: () => _visualizarMensaWeb(objMensaWeb, index),
                          child: Container(
                            margin: new EdgeInsets.fromLTRB(10, 0, 10, 0),
                            width: width * 0.89, // 0.29 web
                            height: 55.0, //height * 0.07

                            // child: Card(
                            //   clipBehavior: Clip.antiAlias,
                            //   shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(8.0)),
                            //   color: controller.isSelected(index)
                            //       ? AppColors.black
                            //       : AppColors.white,
                            //   child:
                            decoration: BoxDecoration(
                              // color: _selectedColorRight,
                              // gradient: AppGradients.linear2,
                              border: Border.fromBorderSide(
                                BorderSide(
                                  color: AppColors.border,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(5),
                              color: controller.isSelected(index)
                                  ? AppColors.black
                                  : AppColors.white,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                // Container(
                                //   color: AppColors.primary,
                                //   width: 10.0,
                                // ),
                                // SizedBox(
                                //   width: 10.0,
                                // ),
                                Expanded(
                                  child: AbsorbPointer(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: objMensaWeb.lido == false
                                              ? Icon(
                                                  Icons.messenger,
                                                  color: Colors.green,

                                                  // : Colors.purple[200] ,
                                                  size: 30,
                                                )
                                              : Icon(
                                                  Icons.messenger,
                                                  color:
                                                      objMensaWeb.lido == false
                                                          ? null
                                                          : Colors.grey,
                                                  size: 30,
                                                ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 120, 0),
                                            child: Text(
                                              objMensaWeb.titulo,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight:
                                                    objMensaWeb.lido == false
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                color: objMensaWeb.lido == false
                                                    ? null
                                                    : Colors.grey,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            objMensaWeb.data.split(' ').first ==
                                                    periodoAtualGeral
                                                        .toString() //true == horas
                                                ? objMensaWeb.data
                                                    .split(' ')
                                                    .last
                                                    .substring(0, 5) //horas
                                                : objMensaWeb.data
                                                    .split(' ')
                                                    .first, //dias
                                            style: TextStyle(
                                              fontWeight:
                                                  objMensaWeb.lido == false
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                              color: objMensaWeb.lido == false
                                                  ? null
                                                  : Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // ),
                        SizedBox(height: 10),
                      ],
                    ),

                    //   actionPane: SlidableDrawerActionPane(),
                  );
                },
              ),
            ),
      //
      floatingActionButton: (controller.isSelecting)
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //1
                IconButton(
                  icon: Icon(
                    Icons.design_services_rounded,
                    color: AppColors.darkRed,
                    size: 30,
                  ),
                  onPressed: undoSelect,
                ),
                //2
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: AppColors.darkRed,
                    size: 30,
                  ),
                  onPressed: () => editWeb(),
                ),
                //3
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: AppColors.darkRed,
                    size: 30,
                  ),
                  onPressed: delete,
                ),
              ],
            )
          : null,
    );
  }

////////////////////////////////////////////////////////////////////////////////
  ///[MOBILE]
  void acaoClick(StatusModel obj) {
    //
    abrirMensa(obj);
    //
    setState(() {
      // refreshAction();
    });
  }

  void edit() {
    var list = controller.selectedIndexes;
    list.sort((b, a) =>
        a.compareTo(b)); //reoder from biggest number, so it wont error
    list.forEach((element) {
      StatusModel objMensa = listaFinal[element];
      editarMensa(objMensa);
    });
  }

  void delete() {
    var list = controller.selectedIndexes;
    //reoder from biggest number, so it wont error
    list.forEach((element) async {
      final objMensa = listaFinal[element];
      //action delete obj
      await exlcuirMensa(objMensa);
    });

    setState(() {
      controller.deselectAll();
      // controller.set(listaFinal.length);
    });
  }

  abrirMensa(objAbrirMensa) {
    setState(() {
      ListaMensaBloc().actionOpenMsg(context, objAbrirMensa, true);
    });
    // refreshAction();
  }

  editarMensa(objMensa) {
    setState(() {
      Navigator.of(context).push(
        PageRouteBuilder(
          fullscreenDialog: true,
          transitionDuration: Duration(milliseconds: 500),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return EditarMensaWidget(objMensa);
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return Align(
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        ),
      );
    });
  }

  exlcuirMensa(objMensa) {
    Alert(
      buttons: [
        DialogButton(
          onPressed: () async {
            titulo = objMensa.titulo;
            mensg = objMensa.mensagem;
            data = objMensa.data;
            sequencia = objMensa.sequencia;
            //
            if (sequencia != null) {
              await new EnviarMensaBloc().postEnviarMensagem(
                  context, titulo, mensg, data, 3, sequencia, null, true);
              Navigator.of(context).pop();
            }
            refreshAction();
          },
          child: Text('OK'),
          color: AppColors.green,
        )
      ],
      context: context,
      title: 'Mensagem excluida com sucesso!',
      useRootNavigator: true,
    ).show();
  }

  Future<bool> undoSelect() async {
    //block app from quitting when selecting
    var before = !controller.isSelecting;
    setState(() {
      controller.deselectAll();
    });
    return before;
  }

////////////////////////////////////////////////////////////////////////////////
  ///[WEB]

  void _visualizarMensaWeb(objMensa, pageIndex) {
    setState(() {
      //
      String tituloViewMensa = objMensa.titulo;
      String mensgViewMensa = objMensa.mensagem;
      String dataViewMensa = objMensa.data;
      int sequenciaViewMensa = objMensa.sequencia;
      bool lidoViewMensa = objMensa.lido = true; //objMensa.lido true == lido!

      EnviarMensaBloc()
          .postEnviarMensagem(context, tituloViewMensa, mensgViewMensa,
              dataViewMensa, 2, sequenciaViewMensa, objMensa, lidoViewMensa)
          .then((map) async {
        setState(() {
          origemClick = "viewMensa";
          objMensaEndDrawer = objMensa;
          _openEndDrawer(pageIndex);
        });
      });
    });
  }

  void editWeb() {
    var list = controller.selectedIndexes;
    list.sort((b, a) =>
        a.compareTo(b)); //reoder from biggest number, so it wont error
    list.forEach((element) {
      StatusModel objMensa = listaFinal[element];
      setState(() {
        origemClick = "editMensa";
        objMensaEndDrawer = objMensa;
        _openEndDrawer(element);
      });
    });
  }

  //METODOS COMPARTILHADOS
  Future<int> _openEndDrawer(i) async {
    indexPage = i;
    _tabKeyListaMensaLidas.currentState.openEndDrawer();
    return indexPage;
  }

  void closeEndDrawer() {
    setState(() {
      count = count - 1;
      Navigator.of(context).pop();
    });
  }

  _onRefresh() {
    // monitor network fetch
    refreshAction();
    print('atualizando Box');
    // if failed,use refreshFailed()
    Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  Future<void> refreshAction() async => setState(() {
        SharedPreferences.getInstance().then((prefs) {
          ListaMensaBloc().getMessageBack(context, true).then((map1) {
            List<StatusModel> listaMapeada = map1;
            setState(() {
              if (map1 != null) {
                listaFinal = listaMapeada;
                // if (map1 != null) {
                for (StatusModel mensagem in listaFinal) {
                  for (String matricula in mensagem.matriculasView.split(",")) {
                    if (matricula == prefs.getString('matricula'))
                      mensagem.lido = true;
                  }
                }
              }
            });
          }); //ms
        });
      });
}
