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
import 'package:gpmobile/src/util/AtualizarPorTimer.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:gpmobile/src/util/SharedPreferencesBloc.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ListaMensaBloc.dart';

class ListaMensaNovas extends StatefulWidget {
  @override
  _ListaMensaNovasState createState() => _ListaMensaNovasState();
}

class _ListaMensaNovasState extends State<ListaMensaNovas> {
  ListaMensaBloc _listaMensaBloc = new ListaMensaBloc();
  List<StatusModel> listaGlobal;
  List<StatusModel> listaFinal2 = new List();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  //
  final _atualizaPorTempo = AtualizarPorTimer(milisegundos: 250);
  //
  // List heroType = <HeroType>[];
  List statusModel = <StatusModel>[];
  StatusModel objMensaEndDrawer;

  //
  String titulo;
  String mensg;
  String data;
  int sequencia;
  String matriculasView;
  bool lido;
  List<StatusModel> listaFinal = [];
  //
  bool _userAdmin;
  bool _habilitaButton = false;
  //
  final GlobalKey<ScaffoldState> _scaffoldKeyListaMensaNovas =
      GlobalKey<ScaffoldState>();
  int indexPage;
  int count = 0;
  String origemClick = "";
  //

  List mainList = new List();
  Random random = Random();
  MultiSelectController controller;
  //
  @override
  void initState() {
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

    //Msg Back
    SharedPreferences.getInstance().then((prefs) {
      _listaMensaBloc.getMessageBack(context, true).then((map1) {
        // StatusModelMok().list().then((map1) {
        setState(() {
          if (map1 != null) {
            listaGlobal = map1;

            if (map1 != null && map1.length > 0) {
              for (StatusModel indexList in listaGlobal) {
                for (String matricula in indexList.matriculasView.split(",")) {
                  if (matricula == prefs.getString('matricula'))
                    indexList.lido = true;
                }
                setState(() {
                  listaFinal.add(indexList);
                });
              }
            } else {
              for (StatusModel mensBack1 in listaGlobal) {
                setState(() {
                  listaFinal.add(mensBack1);
                });
              }
            }
            setState(() {
              listaFinal2.clear();
              listaFinal2
                  .addAll(listaFinal.where((element) => element.lido == false));
            });
          }
        });
      }); //ms
    });
  }

  ///////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeyListaMensaNovas,
      body: Container(
        decoration: AppGradients.gradient,
        child: ScreenTypeLayout(
          breakpoints: ScreenBreakpoints(desktop: 899, tablet: 730, watch: 279),
          mobile: OrientationLayoutBuilder(
            portrait: (context) => _ListaMensaNovasMobile(),
            landscape: (context) => _ListaMensaNovasMobile(),
          ),
          tablet: _ListaMensaNovasWeb(),
          desktop: _ListaMensaNovasWeb(),
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
  ///////////////////////////////////////////////////////////

  //MOBILE
  Widget _ListaMensaNovasMobile() {
    //
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    //
    final txtAppBarTitle = (controller.isSelecting)
        ? Text('Selecionado(s) ${controller.selectedIndexes.length}  ')
        : Text(
            "MENSAGENS NOVAS",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          );
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
              int pageRandom = random.nextInt(100); // from 0 upto 99 included
              setState(() {
                origemClick = "createMensa";
                _openEndDrawer(pageRandom);
              });
            },
          );

    final btnRefresh = new IconButton(
      icon: Icon(
        Icons.autorenew,
        color: AppColors.iconSemFundo,
        size: 30,
      ),
      onPressed: refreshAction,
      // onPressed: () => _listaMensaBloc.refreshList(context),
    );
    //
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: txtAppBarTitle,
        actions: [
          btnAddMensa,
          // btnRefresh
        ],
      ),

      body: listaFinal2.isEmpty
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
                itemCount: listaFinal2.length,
                itemBuilder: (BuildContext context, int index) {
                  StatusModel objMensaMob = listaFinal2[index];

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
                          onTap: () => acaoClick(objMensaMob),
                          child: Container(
                              margin: new EdgeInsets.fromLTRB(10, 0, 10, 0),
                              width: width * 0.89, // 0.29 web
                              height: 55.0, //height * 0.07

                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                color: controller.isSelected(index)
                                    ? AppColors.black
                                    : AppColors.white,
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
                                              child: objMensaMob.lido == false
                                                  ? Icon(
                                                      Icons.messenger,
                                                      color: Colors.green,

                                                      // : Colors.purple[200] ,
                                                      size: 30,
                                                    )
                                                  : Icon(
                                                      Icons.messenger,
                                                      color: objMensaMob.lido ==
                                                              false
                                                          ? null
                                                          : Colors.grey,
                                                      size: 30,
                                                    ),
                                            ),
                                            Expanded(
                                              flex: 5,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 120, 0),
                                                child: Text(
                                                  objMensaMob.titulo,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight:
                                                        objMensaMob.lido ==
                                                                false
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                    color: objMensaMob.lido ==
                                                            false
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
                                                objMensaMob.data
                                                            .split(' ')
                                                            .first ==
                                                        periodoAtualGeral
                                                            .toString() //true == horas
                                                    ? objMensaMob.data
                                                        .split(' ')
                                                        .last
                                                        .substring(0, 5) //horas
                                                    : objMensaMob.data
                                                        .split(' ')
                                                        .first, //dias
                                                style: TextStyle(
                                                  fontWeight:
                                                      objMensaMob.lido == false
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                  color:
                                                      objMensaMob.lido == false
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
                              )),
                        ),
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
                  onPressed: edit,
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

  //WEB
  Widget _ListaMensaNovasWeb() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
//
    final txtAppBarTitle = (controller.isSelecting)
        ? Text('Selecionado(s) ${controller.selectedIndexes.length}  ')
        : Text(
            "MENSAGENS NOVAS",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
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

    final btnRefresh = new IconButton(
        icon: Icon(
          Icons.autorenew,
          color: AppColors.iconSemFundo,
          size: 30,
        ),
        onPressed: refreshAction);
    //

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
      body: listaFinal2.isEmpty
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
              child: ListView.builder(
                  itemCount: listaFinal2.length,
                  itemBuilder: (BuildContext context, int index) =>
                      MultiSelectItem(
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
                              onTap: () => _visualizarMensaWeb(
                                  listaFinal2[index], index),
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
                                              child: listaFinal2[index].lido ==
                                                      false
                                                  ? Icon(
                                                      Icons.messenger,
                                                      color: Colors.green,

                                                      // : Colors.purple[200] ,
                                                      size: 30,
                                                    )
                                                  : Icon(
                                                      Icons.messenger,
                                                      color: listaFinal2[index]
                                                                  .lido ==
                                                              false
                                                          ? null
                                                          : Colors.grey,
                                                      size: 30,
                                                    ),
                                            ),
                                            Expanded(
                                              flex: 5,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 120, 0),
                                                child: Text(
                                                  listaFinal2[index].titulo,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight:
                                                        listaFinal2[index]
                                                                    .lido ==
                                                                false
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                    color: listaFinal2[index]
                                                                .lido ==
                                                            false
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
                                                listaFinal2[index]
                                                            .data
                                                            .split(' ')
                                                            .first ==
                                                        periodoAtualGeral
                                                            .toString() //true == horas
                                                    ? listaFinal2[index]
                                                        .data
                                                        .split(' ')
                                                        .last
                                                        .substring(0, 5) //horas
                                                    : listaFinal2[index]
                                                        .data
                                                        .split(' ')
                                                        .first, //dias
                                                style: TextStyle(
                                                  fontWeight:
                                                      listaFinal2[index].lido ==
                                                              false
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                  color:
                                                      listaFinal2[index].lido ==
                                                              false
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
                        // child: Card(
                        //   color: controller.isSelected(index)
                        //       ? AppColors.black
                        //       : AppColors.white,
                        //   child: ListTile(
                        //     //acao do click
                        //     onTap: () {
                        //       _visualizarMensaWeb(objMensaWeb, index);
                        //     },
                        //     leading: objMensaWeb.lido == false
                        //         ? Icon(
                        //             Icons.messenger,
                        //             color: Colors.green,
                        //             size: 30,
                        //           )
                        //         : Icon(
                        //             Icons.messenger,
                        //             color: objMensaWeb.lido == false
                        //                 ? null
                        //                 : Colors.grey,
                        //             size: 30,
                        //           ),
                        //     title: Row(
                        //       // mainAxisAlignment: MainAxisAlignment.start,
                        //       children: [
                        //         Flexible(
                        //           flex: 1,
                        //           child: Text(
                        //             objMensaWeb.titulo,
                        //             overflow: TextOverflow.clip,
                        //             style: TextStyle(
                        //               fontWeight: objMensaWeb.lido == false
                        //                   ? FontWeight.bold
                        //                   : FontWeight.normal,
                        //               color: objMensaWeb.lido == false
                        //                   ? null
                        //                   : Colors.grey,
                        //               fontSize: 15,
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //     trailing: Text(
                        //       objMensaWeb.data.split(' ').first ==
                        //               periodoAtualGeral.toString() //true == horas
                        //           ? objMensaWeb.data
                        //               .split(' ')
                        //               .last
                        //               .substring(0, 5) //horas
                        //           : objMensaWeb.data.split(' ').first, //dias
                        //       style: TextStyle(
                        //         fontWeight: objMensaWeb.lido == false
                        //             ? FontWeight.bold
                        //             : FontWeight.normal,
                        //         color:
                        //             objMensaWeb.lido == false ? null : Colors.grey,
                        //         fontSize: 12,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      )),
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
                  onPressed: editWeb,
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
      _listaMensaBloc.actionOpenMsg(context, objAbrirMensa, true);
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
  void editWeb() {
    var list = controller.selectedIndexes;
    list.sort((b, a) =>
        a.compareTo(b)); //reoder from biggest number, so it wont error
    list.forEach((element) {
      setState(() {
        origemClick = "editMensa";
        _openEndDrawer(element);
      });
    });
  }

  void _visualizarMensaWeb(objMensa, pageIndex) {
    // HeroType heroType;

    setState(() {
      //
      String tituloViewMensa = objMensa.titulo;
      String mensgViewMensa = objMensa.mensagem;
      String dataViewMensa = objMensa.data;
      int sequenciaViewMensa = objMensa.sequencia;
      bool lidoViewMensa = objMensa.lido = true; //objMensa.lido true == lido!
      //
      //atualiza status datasul

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

      // _listaMensaBloc()
      //     .gravaStatus(context, tituloViewMensa, mensgViewMensa, dataViewMensa,
      //     matriculasView, sequenciaViewMensa, lidoViewMensa, false)
      //     .then((map) async {
      //   setState(() {
      //     origemClick = "view";
      //     _openEndDrawer(pageIndex);
      //   });
      // });
    });
  }

  //METODOS COMPARTILHADOS
  Future<int> _openEndDrawer(i) async {
    indexPage = i;
    _scaffoldKeyListaMensaNovas.currentState.openEndDrawer();
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

  refreshAction() {
    setState(() {
      //Msg Back
      SharedPreferences.getInstance().then((prefs) {
        _listaMensaBloc.getMessageBack(context, true).then((map1) {
          // StatusModelMok().list().then((map1) {
          setState(() {
            listaFinal.clear();
            listaFinal2.clear();
            listaGlobal.clear();
            if (map1 != null) {
              listaGlobal = map1;

              if (map1 != null && map1.length > 0) {
                for (StatusModel indexList in listaGlobal) {
                  for (String matricula
                      in indexList.matriculasView.split(",")) {
                    if (matricula == prefs.getString('matricula'))
                      indexList.lido = true;
                  }
                  setState(() {
                    listaFinal.add(indexList);
                  });
                }
              } else {
                for (StatusModel mensBack1 in listaGlobal) {
                  setState(() {
                    listaFinal.add(mensBack1);
                  });
                }
              }
              setState(() {
                listaFinal2.clear();
                listaFinal2.addAll(
                    listaFinal.where((element) => element.lido == false));
              });
            }
          });
        }); //ms
      });
    });
  }
}
