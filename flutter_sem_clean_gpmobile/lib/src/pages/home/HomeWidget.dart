import 'dart:async';
import 'dart:core';

import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/mensagens/listar_mensagens/ListaMensaWidgetWeb.dart';
import 'package:gpmobile/src/pages/mensagens/vizualizar_mensagens/PageHeroWidget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:clay_containers_plus/widgets/clay_containers.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:gpmobile/src/pages/aniversariantes/NiverWidget.dart';
import 'package:gpmobile/src/pages/bcoHoras/BcoHorasWidget.dart';
import 'package:gpmobile/src/pages/configuracoes/ConfigWidget.dart';
import 'package:gpmobile/src/pages/documentos/listar/ListarDocWidget.dart';
import 'package:gpmobile/src/pages/contraCheque/ContraChequeWidget.dart';
import 'package:gpmobile/src/pages/ferias/FeriasWidget.dart';
import 'package:gpmobile/src/pages/mensagens/listar_mensagens/ListaMensaBloc.dart';
import 'package:gpmobile/src/pages/mensagens/model/StatusMensaModel.dart';
import 'package:gpmobile/src/pages/mensagens/vizualizar_mensagens/VisualizaMensaWidget.dart';
import 'package:gpmobile/src/pages/myDay/MyDayWidget.dart';
import 'package:gpmobile/src/pages/ponto/PontoWidget.dart';
import 'package:gpmobile/src/routes/routes.dart';

import 'package:gpmobile/src/util/NavigationBloc.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/SharedPreferencesBloc.dart';
import 'package:gpmobile/src/util/images.dart';
import 'package:gpmobile/src/widgets/navigation_item.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial/tutorial.dart';
import 'HomeBloc.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();

  // HomeWidget(this.listaFinal2);
}

class _HomeWidgetState extends State<HomeWidget>
    with SingleTickerProviderStateMixin {
  // List<StatusModel> listaFinal2 = new List();
  ListaMensaBloc listaMensaBloc = ListaMensaBloc();
  //
  String nomeColaborador = '';
  String empresa = '';
  String matricula = '';
  String cargo = '';
  String nomeEmpresa = '';
  double topContainer = 0;
  bool closeTopContainer = false;
  //
  List<StatusModel> listMensagensback1 = new List();
  List<StatusModel> listMensagensBanco2 = new List();
  List<StatusModel> listaFinal = new List();
  List<StatusModel> listaFinal2 = new List();
  List<TutorialItens> itens = []; //criar lista de tutoriais
  // List heroType = List<HeroType>();
  List<StatusModel> listaGlobal;
  //
  String titulo;
  String mensagem;
  String data;
  bool lido;
  //CONTROLLERS
  ScrollController controller = ScrollController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  EasyRefreshController _controller;
  TabController _tabController;
  //
  int _seletedItem;
  int index = 1;
  int _page = 0;
  int _count = 0;
  //
  bool _userAdmin;
  bool _habilitaButton = false;
  //
  var _loading = false;
  var _pagesController = PageController();
  var _chaveHomeWeb = GlobalKey<ScaffoldState>(); //chave de acesso ao widget
  var keyBotaoSair = GlobalKey(); //chave de acesso ao widget
  var keyHomeBoxMensagens = GlobalKey(); //chave de acesso ao widget
  var keyHomeBotoes = GlobalKey(); //chave de acesso ao widget

  //INICIO
  @override
  void initState() {
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
    _controller = EasyRefreshController();
    _pagesController = PageController(
      keepPage: false,
      initialPage: 0,
    );

    setState(() {
      SharedPreferencesBloc().buscaParametroBool("userAdmin").then((retorno) {
        _userAdmin = retorno;

        if (_userAdmin == false) {
          _habilitaButton = _userAdmin;
        } else {
          _habilitaButton = _userAdmin;
        }
      });
    });

    listMensagensback1 = new List();
    listaFinal = new List();

    setState(() {
      _seletedItem = index;
    });

    Timer(
        Duration(seconds: 1),
        () => setState(() {
              HomeBloc().getNomeColaborador().then((map) async {
                nomeColaborador = map;
              });
              HomeBloc().getCargo().then((map) async {
                cargo = map;
              });
              HomeBloc().getNomeEmpresa().then((map) async {
                nomeEmpresa = map;
              });
              HomeBloc().getMatricula().then((map) async {
                matricula = map;
              });
              //
              HomeBloc().getEmpresa().then((map) async {
                empresa = map;
              });
            }));

    controller.addListener(() {
      double value = controller.offset / 119;
      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });

    //Msg Back
    SharedPreferences.getInstance().then((prefs) {
      listaMensaBloc.getMessageBack(context, true).then((map1) {
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
    super.initState();
  }

  final _scaffoldKeyHomeWidget = GlobalKey<ScaffoldState>();
  void _closeDrawer() {
    if (_scaffoldKeyHomeWidget.currentState.isDrawerOpen) {
      Navigator.of(context).pop();
    }
  }
  // void _closeDrawer() {
  //   Navigator.of(context).pop();
  // }

  @override
  void dispose() {
    // _pagesController.dispose();
    super.dispose();
  }

  //esse metodo muito importante para nao gerar erros na transicao das telas!!!
  void _openPageChanged(int page) {
    setState(() {
      _pagesController.jumpToPage(_seletedItem);
      var a = _seletedItem;
      switch (a) {
        case 0:
          {
            print("Home");
          }
          break;
        case 1:
          {
            print("Férias");
          }
          break;
        case 2:
          {
            print("Banco Horas");
          }
          break;
        case 3:
          {
            print("Ponto");
          }
          break;
        case 4:
          {
            print("Holerite");
          }
          break;
        case 5:
          {
            print("Meu Dia");
          }
          break;
        case 6:
          {
            print("Aniversariantes");
          }
          break;
        case 7:
          {
            print("Mensagens");
          }
          break;
        case 8:
          {
            print("Modo Noturno");
          }
          break;
        case 9:
          {
            print("Sobre o App");
          }
          break;
      }
    });
  }

//PRINCIPAL
  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      key: _scaffoldKeyHomeWidget,
      body: Container(
        decoration: AppGradients.gradient,
        child: ScreenTypeLayout(
          breakpoints: ScreenBreakpoints(desktop: 799, tablet: 730, watch: 279),
          mobile: OrientationLayoutBuilder(
            portrait: (context) => homeMobile(),
            landscape: (context) => homeMobile(),
          ),
          tablet: homeWeb(),
          desktop: homeWeb(),
        ),
      ),
    );
  }

//MOBILE////////////////////////////////////////////////////////////////////////
  Widget homeMobile() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.4), // here the desired height
        child: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: height * 0.02, vertical: height * 0.02),
                        child: _buttonLogoffWeb(context, 'web'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: _nomeUsuario(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _dadosUsuario(context),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // elevation: 0.0,
          // backgroundColor: Theme.of(context).backgroundColor,
        ),
      ),
      body: Container(
        // decoration: AppGradients.gradient,
        height: height * 2, //1.2
        // key: keyHomeBoxMensagens,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: _boxMensageMobile(context),
        ),
      ),
      bottomNavigationBar: Padding(
        key: keyHomeBotoes,
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: footerMenuMobile(),
      ),
    );
  }

  // Widget _boxMensageMobile(BuildContext context) {
  //   // double width = MediaQuery.of(context).size.width;
  //   // double height = MediaQuery.of(context).size.width;
  //   return Scaffold(
  //     backgroundColor: Colors.transparent,
  //     appBar: AppBar(
  //       backgroundColor: Colors.transparent,
  //       automaticallyImplyLeading: false,
  //       // title: Text("MENSAGENS"),
  //       centerTitle: true,
  //       elevation: 0.7,
  //       bottom: TabBar(
  //         controller: _tabController,
  //         indicatorColor: Colors.white,
  //         tabs: <Widget>[
  //           Tab(text: "NOVAS"),
  //           Tab(text: "LIDAS"),
  //         ],
  //       ),
  //       // actions: <Widget>[
  //       //   Icon(Icons.search),
  //       //   Padding(
  //       //     padding: const EdgeInsets.symmetric(horizontal: 5.0),
  //       //   ),
  //       //   Icon(Icons.more_vert)
  //       // ],
  //     ),
  //     body: TabBarView(
  //       controller: _tabController,
  //       children: <Widget>[
  //         ///*[NOVAS]
  //         new ListaMensaNovas(),

  //         ///*[LIDAS]
  //         new ListaMensaLidas(),
  //       ],
  //     ),
  //     // floatingActionButton: showFab
  //     //     ? FloatingActionButton(
  //     //         backgroundColor: Theme.of(context).accentColor,
  //     //         child: Icon(
  //     //           Icons.message,
  //     //           color: Colors.white,
  //     //         ),
  //     //         onPressed: () => print("open chats"),
  //     //       )
  //     //     : null,
  //   );
  // }

  Widget _boxMensageMobile(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.transparent,
      child: listaFinal2.isEmpty
          ? Center(
              child: Image.asset(
                imageLogoGrupoHorizontal,
                width: width * 0.5,
                height: height * 0.5,
                filterQuality: FilterQuality.high,
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
                  final objMensa = listaFinal2[index];

                  return Card(
                    child: ListTile(
                      //ACAO ABRIR MENSAGEM
                      onTap: () {
                        listaMensaBloc.actionOpenMsg(context, objMensa, true);
                        // _atualizarBox();
                        // _updateBoxMessage();
                      },
                      leading: objMensa.lido == false
                          ? Icon(
                              Icons.messenger,
                              color: Colors.green,
                              size: 30,
                            )
                          : Icon(
                              Icons.messenger,
                              color:
                                  objMensa.lido == false ? null : Colors.grey,
                              size: 30,
                            ),
                      title: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Text(
                              objMensa.titulo,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: objMensa.lido == false
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color:
                                    objMensa.lido == false ? null : Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        objMensa.data.split(' ').first ==
                                periodoAtualGeral.toString() //true == horas
                            ? objMensa.data
                                .split(' ')
                                .last
                                .substring(0, 5) //horas
                            : objMensa.data.split(' ').first, //dias
                        style: TextStyle(
                          fontWeight: objMensa.lido == false
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: objMensa.lido == false ? null : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                },
              ),
//
            ),
    );
  }

  Widget _buttonLogoffMobile(BuildContext context, tipoDispositivo) {
    return new Container(
      child: new Row(
        // mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
            child: ClayContainer(
              borderRadius: 5,
              // alignment: Alignment.centerRight,
              // emboss: true,
              // depth: 10,
              width: 30,
              height: 30,
              // duration: duration,
              color: Theme.of(context).backgroundColor,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: new IconButton(
                  // color: Theme.of(context).unselectedWidgetColor.withOpacity(0.9),
                  onPressed: () => AlertDialogTemplate()
                      .showAlertDialogLogoff(context, "Atenção",
                          "Deseja sair do aplicativo?", tipoDispositivo)
                      .then(
                        (map) async {},
                      ),
                  icon: Icon(
                    Icons.logout,
                    size: 18,
                    color: ThemeData.light().buttonColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget footerMenuMobile() {
    // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      // color: Colors.transparent,
      // decoration: AppGradients.gradient,
      padding: EdgeInsets.symmetric(
        horizontal: 5.0,
        vertical: 5.0,
      ),
      // height: height * 0.14,
      height: 110.0,
      child: ListView.separated(
          separatorBuilder: (context, index) => SizedBox(
                width: 5,
              ),
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          itemCount: cardItensMobile.length,
          itemBuilder: (context, index) {
            //
            MenuItemWidget objCard = cardItensMobile[index];
            //
            return Container(
              width: width * 0.225, //225
              child: MaterialButton(
                color: Theme.of(context).cardColor,
                onPressed: () => openPage(index),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      objCard.iconData,
                      color: Colors.grey,
                      // textDirection: TextDirection.,
                      size: 30,
                    ),
                    Text(
                      objCard.text,
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 11),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  List<BottomMenuItemWidget> cardItensMobile = [
    MenuItemWidget(
      text: "Férias",
      iconData: Icons.flight,
    ),
    // [1]
    MenuItemWidget(
      text: "Banco \nHoras",
      // iconData: Icons.access_alarms,
      iconData: Icons.watch_later_rounded,
    ),
    // [2]
    MenuItemWidget(
      text: "Ponto",
      iconData: Icons.touch_app,
    ),
    // [3]
    MenuItemWidget(
      text: "Holerite",
      iconData: Icons.request_page,
    ),
    // [4]
    MenuItemWidget(
      text: "Meu Dia",
      iconData: Icons.event_available_rounded,
    ),

    // [5]
    MenuItemWidget(
      text: "Aniver.",
      iconData: Icons.cake,
    ),
    // [6]
    MenuItemWidget(
      text: "Mens.",
      iconData: Icons.messenger,
    ),
    // // [7]
    MenuItemWidget(text: "Doc", iconData: Icons.image_rounded),
    // [8]
    MenuItemWidget(
      text: "Config. ",
      iconData: Icons.settings,
    ),
  ];

  //WEB/////////////////////////////////////////////////////////////////////////
  Widget homeWeb() {
    // final GlobalKey<State> cartKey = GlobalKey();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _chaveHomeWeb,
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          // decoration: BoxDecoration(color: Colors.transparent),
          child: Row(
            children: [
              _buildColunaEsquerda(context),
              _buildColunaDireita(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Center(
        heightFactor: 1,
        child: footerMenuWeb(),
      ),
    );
  }

  Expanded _buildColunaEsquerda(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;
    return Expanded(
      // flex: widget.isMedium ? 1 : 3,
      flex: 1,
      child: Material(
        child: Card(
          margin: EdgeInsets.zero,
          // color: Theme.of(context).backgroundColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.white12,
            ),
          ),
          child: Container(
            decoration: AppGradients.gradient,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //       horizontal: height * 0.01, vertical: height * 0.03),
                    //   child: _botaoHelpWeb(context),
                    // ),
                    Padding(
                      key: keyBotaoSair,
                      padding: EdgeInsets.symmetric(
                          horizontal: height * 0.01, vertical: height * 0.03),
                      child: _buttonLogoffWeb(context, 'web'),
                    ),
                    // _buttonLogoffWeb(context),
                  ],
                ),

                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _nomeUsuario(context),
                      _dadosUsuario(context),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),

                // Chats list
                Expanded(
                  child: _boxMensageWeb(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded _buildColunaDireita() {
    List<StatusModel> listMensag = [];
    StatusModel objBoxMensa;

    var _pages = [
      new ListarMensaWidgetWeb(), //0
      new FeriasWidget(), //1
      new BcoHorasWidget(), //2
      new PontoWidget(null, null), //3
      new ContraChequeWidget(), //4
      new MyDayWidget(), //5
      new NiverWidget(), //6
      // new ListarMensaWidget(), //7
      new ListarDocWidget(), //8
      new ConfigWidget(), //9
      new VisualizaMensaWidget(
          HeroType(data: data, titulo: titulo, mensagem: mensagem),
          objBoxMensa),
    ];

    return Expanded(
      // flex: widget.isMedium ? 2 : 8,
      flex: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: Row(
          children: [
            // Appbar
            // _chatAppbar(),
            // Body

            // Expanded(
            //   flex: 1,
            //   child: NavigationItem(
            //     selected: index == 0,
            //     title: "Home",
            //     routeName: routeHomeWidget,
            //     onHighlight: onHighLight,
            //   ),
            // ),
            // Expanded(
            //   flex: 1,
            //   child: NavigationItem(
            //     selected: true,
            //     title: "Ferias",
            //     routeName: routeFeriasWidget,
            //     onHighlight: onHighLight,
            //   ),
            // ),

            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Container(
                  width: 1200,
                  height: 800,
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pagesController,
                    onPageChanged: _openPageChanged,
                    children: _pages,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chatAppbar() {
    return Card(
      margin: EdgeInsets.zero,
      color: const Color(0xFF2A2F32),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.orange,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'User name',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _botaoHelpWeb(BuildContext context) {
    return new Container(
      // color: Colors.transparent,
      // width: 60,
      // height: 50,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: new ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                  // elevation: MaterialStateProperty.all<double>(1.5),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.transparent))),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.transparent)),
              child: Icon(
                Icons.info_outline,
                size: 20,
                color: ThemeData.light().buttonColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonLogoffWeb(BuildContext context, tipoDispositivo) {
    return Container(
      child: new ElevatedButton(
        onPressed: () => AlertDialogTemplate()
            .showAlertDialogLogoff(context, "Atenção",
                "Deseja sair do aplicativo?", tipoDispositivo)
            .then(
              (map) async {},
            ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.transparent))),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        ),
        child: Icon(
          Icons.logout,
          size: 18,
          color: ThemeData.light().buttonColor,
        ),
      ),
    );
  }

  // Widget _boxMensageWeb(BuildContext context) {
  //   int page = 10; //abrir visualiza mensagens
  //   //
  //   return Scaffold(
  //     backgroundColor: Colors.transparent,
  //     body: Container(
  //       child: listaFinal2.isEmpty
  //           ? Center(
  //               child: Text(
  //               'Não há mensagens no momento!',
  //               style: TextStyle(color: Theme.of(context).cardColor),
  //             ))
  //           : Center(
  //               child: Container(
  //                 decoration: AppGradients.gradient,
  //                 width: 730,
  //                 child: SmartRefresher(
  //                   header: WaterDropHeader(
  //                     waterDropColor: Colors.green,
  //                   ),
  //                   controller: _refreshController,
  //                   onRefresh: _onRefresh,
  //                   // onLoading: _onLoading,
  //                   child: ListView.builder(
  //                     itemCount: listaFinal2.length,
  //                     itemBuilder: (BuildContext context, int index) {
  //                       final objMensa = listaFinal2[index];
  //                       return Slidable(
  //                         secondaryActions: <Widget>[],
  //                         child: Card(
  //                           child: ListTile(
  //                             //ACAO ABRIR MENSAGEM
  //                             onTap: () {
  //                               setState(() {
  //                                 listaMensaBloc.actionOpenMsg(
  //                                     context, objMensa, true);

  //                                 openPageWeb(page);
  //                                 return null;
  //                               });
  //                             },
  //                             leading: objMensa.lido == false
  //                                 ? Icon(
  //                                     Icons.messenger,
  //                                     color: Colors.green,
  //                                     size: 30,
  //                                   )
  //                                 : Icon(
  //                                     Icons.messenger,
  //                                     color: objMensa.lido == false
  //                                         ? null
  //                                         : Colors.grey,
  //                                     size: 30,
  //                                   ),
  //                             title: Row(
  //                               children: [
  //                                 Flexible(
  //                                   flex: 1,
  //                                   child: Text(
  //                                     objMensa.titulo,
  //                                     overflow: TextOverflow.clip,
  //                                     style: TextStyle(
  //                                       fontWeight: objMensa.lido == false
  //                                           ? FontWeight.bold
  //                                           : FontWeight.normal,
  //                                       color: objMensa.lido == false
  //                                           ? null
  //                                           : Colors.grey,
  //                                       fontSize: 15,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                             trailing: Text(
  //                               objMensa.data.split(' ').first ==
  //                                       periodoAtualGeral
  //                                           .toString() //true == horas
  //                                   ? objMensa.data
  //                                       .split(' ')
  //                                       .last
  //                                       .substring(0, 5) //horas
  //                                   : objMensa.data.split(' ').first, //dias
  //                               style: TextStyle(
  //                                 fontWeight: objMensa.lido == false
  //                                     ? FontWeight.bold
  //                                     : FontWeight.normal,
  //                                 color: objMensa.lido == false
  //                                     ? null
  //                                     : Colors.grey,
  //                                 fontSize: 12,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         actionPane: SlidableDrawerActionPane(),
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               ),
  //             ),
  //     ),
  //   );
  // }

  Widget _boxMensageWeb(BuildContext context) {
    ///[alteracao 13/08]

    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.width;
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
    return Container(
      color: Colors.transparent,
      // decoration: AppGradients.gradient,
      width: 500,
      height: 800,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Bem Vindo!",
            style: TextStyle(color: Colors.white70, fontSize: 50),
          ),
          cardImage,
        ],
      ),
    );

    ///[alteracao 13/08]
  }

  Widget footerMenuWeb() {
    // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 5.0,
        vertical: 1.0,
      ),
      // height: height * 0.14,
      height: 110.0,
      child: ListView.separated(
          separatorBuilder: (context, index) => SizedBox(
                width: 5,
              ),
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          itemCount: cardItensWeb.length,
          itemBuilder: (context, index) {
            //
            MenuItemWidget objCard = cardItensWeb[index];
            //
            return Container(
              width: width * 0.202, //0.102 alterar largura do carrosel
              child: MaterialButton(
                color: Theme.of(context).cardColor,
                onPressed: () => openPageWeb(index),
                // onPressed: () => onHighLight('/routeHomeWidget'),
                // onPressed: () => navKey.currentState.pushNamed('/feriasWidget'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      // Icons.ac_unit,
                      objCard.iconData,
                      color: Colors.grey,
                      // textDirection: TextDirection.rtl,
                      size: 30,
                    ),
                    Text(
                      objCard.text,
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 11),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  //COMPARTILHADO//////////////////////////////////////////////////////////////////////

  Widget _nomeUsuario(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          nomeColaborador,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Estilo().branca,
              fontWeight: FontWeight.bold,
              fontSize: 17,
              fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  Widget _dadosUsuario(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            "Cargo: " + cargo,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? Color(0xB3ffffff)
                    : Color(0xB3ffffff),
                fontWeight: FontWeight.bold,
                fontSize: 12),
          ),
          Text(
            "Empresa: " + nomeEmpresa,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? Color(0xB3ffffff)
                    : Color(0xB3ffffff),
                fontWeight: FontWeight.bold,
                fontSize: 12),
          ),
          new Text(
            "Matrícula: " + matricula,
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? Color(0xB3ffffff)
                    : Color(0xB3ffffff),
                fontWeight: FontWeight.bold,
                fontSize: 12),
          ),
        ],
      ),
    );
  }

  //METODOS/////////////////////////////////////////////////////////////////////

  void onHighLight(String route) {
    switch (route) {
      case routeHomeWidget:
        changePage(0);
        break;
      case routeFeriasWidget:
        changePage(1);
        break;
      case routeBcoHorasWidget:
        changePage(2);
        break;
      case routePontoWidget:
        changePage(3);
        break;
      case routeMyDayWidget:
        changePage(4);
        break;
      case routeNiverWidget:
        changePage(5);
        break;
      case routeEnviarMensaWidget:
        changePage(6);
        break;
      case routeListarDocWidget:
        changePage(7);
        break;
      case routeConfigWidget:
        changePage(8);
        break;
      case routeModoNoturno:
        changePage(9);
        break;
      case routeSobreWidget:
        changePage(10);
        break;

      // default:
    }
  }

  void changePage(int newIndex) {
    //mudar page por index
    setState(() {
      index = newIndex;
    });
  }

  void openPage(value) {
    //mudar page por index
    setState(() {
      NavigationBloc.navegar(context, "$value", listaFinal2);
    });
  }

  Future<String> openPageWeb(int value) {
    //mudar page por index
    //Geovane 2
    if (mounted) {
      setState(() {
        _seletedItem = value;
        _pagesController.animateToPage(_seletedItem,
            duration: Duration(milliseconds: 200), curve: Curves.linear);

        // NavigationBloc.navegar(context, "$value", listaFinal);
      });
    }
  }

  // openPageWeb(int value) {
  //   //mudar page por index
  //   if (mounted) {
  //     setState(() {
  //       _seletedItem = value;
  //       _pagesController.animateToPage(_seletedItem,
  //           duration: Duration(milliseconds: 200), curve: Curves.linear);
  //     });
  //   }
  // }
  // void _onLoading() async {
  //   // monitor network fetch
  //   // await Future.delayed(Duration(milliseconds: 1000));
  //   // if failed,use loadFailed(),if no data return,use LoadNodata()
  //
  //   listaMensaBloc.atualizaListaDeMensagens(context).then((v) async {
  //     if (v != null) widget.listaFinal2 = v;
  //   });
  //   if (mounted) setState(() {});
  //   _refreshController.loadComplete();
  // }

  _onRefresh() {
    // monitor network fetch
    atualizarBox();
    print('atualizando Box');
    // if failed,use refreshFailed()
    Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  // Future<List<StatusModel>> _getData() async {
  //   if (mounted) {
  //     setState(() {
  //       listaMensaBloc.atualizaListaDeMensagens(context).then((v) async {
  //         if (v != null) widget.listaFinal2 = v;
  //       });
  //     });
  //   }
  //   return widget.listaFinal2;
  // }

  // void _refresh() async {
  //   setState(() => _loading = true);
  //   await _getData();
  //   if (mounted) setState(() => _loading = false);
  // }

  // Future<void> _atualizarBox_animationBoxMessage() => Future.delayed(
  //       const Duration(seconds: 2),
  //       () => _refreshController.refreshCompleted(),
  //     );

  atualizarBox() {
    SharedPreferences.getInstance().then((prefs) {
      listaMensaBloc.getMessageBack(context, true).then((map1) {
        // StatusModelMok().list().then((map1) {
        setState(() {
          listaFinal.clear();
          listaFinal2.clear();
          listaGlobal.clear();
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

  // Future<void> atualizaLista() async {
  //   //Msg Back
  //   SharedPreferences.getInstance().then((prefs) {
  //     listaMensaBloc.getMessageBack(context, true).then((map1) {
  //       setState(() {
  //         if (map1 != null) {
  //           listaGlobal = map1;
  //
  //           if (map1 != null && map1.length > 0) {
  //             for (StatusModel indexList in listaGlobal) {
  //               for (String matricula in indexList.matriculasView.split(",")) {
  //                 if (matricula == prefs.getString('matricula'))
  //                   indexList.lido = true;
  //               }
  //               setState(() {
  //                 listaFinal.add(indexList);
  //               });
  //             }
  //           } else {
  //             for (StatusModel mensBack1 in listaGlobal) {
  //               setState(() {
  //                 listaFinal.add(mensBack1);
  //               });
  //             }
  //           }
  //           setState(() {
  //             widget.listaFinal2.clear();
  //             widget.listaFinal2
  //                 .addAll(listaFinal.where((element) => element.lido == false));
  //           });
  //         }
  //       });
  //     }); //ms
  //   });
  // }

  //////////////////////////////////////////////////////////////////////////////
  List<Widget> cardItensDesktop = [
    NavigationItem(
      title: 'Home',
      routeName: routeHomeWidget,
      selected: true, onHighlight: null,
      // onHighlight: ,
    ),
  ];

  List<BottomMenuItemWidget> cardItensWeb = [
    //[0]
    MenuItemWidget(
      text: "Mens.",
      iconData: Icons.messenger,
    ),
    // [1]
    MenuItemWidget(
      text: "Férias",
      iconData: Icons.flight,
    ),
    // [2]
    MenuItemWidget(
      text: "Banco \nHoras",
      // iconData: Icons.access_alarms,
      iconData: Icons.watch_later_rounded,
    ),
    // [3]
    MenuItemWidget(
      text: "Ponto",
      iconData: Icons.touch_app,
    ),
    // [4]
    MenuItemWidget(
      text: "Holerite",
      iconData: Icons.request_page,
    ),
    // [5]
    MenuItemWidget(
      text: "Meu Dia",
      iconData: Icons.event_available_rounded,
    ),
    // [6]
    MenuItemWidget(
      text: "Aniver.",
      iconData: Icons.cake,
    ),
    // [7]
    // MenuItemWidget(
    //   text: "Mens.",
    //   iconData: Icons.messenger,
    // ),
    // [8]
    MenuItemWidget(text: "Doc", iconData: Icons.image_rounded),
    //[9]
    MenuItemWidget(
      text: "Config. ",
      iconData: Icons.settings,
    ),
  ];
}

abstract class BottomMenuItemWidget {
  Widget buildWidget(double diffPosition);
}

class MenuItemWidget extends BottomMenuItemWidget {
  final IconData iconData;
  final double sizeIcon;
  final String text;
  final Color selectedBgColor;
  final Color noSelectedBgColor;
  final Color selectedIconTextColor;
  final Color noSelectedIconTextColor;

  MenuItemWidget(
      {this.iconData,
      this.sizeIcon,
      this.text,
      this.selectedIconTextColor = Colors.white,
      this.noSelectedIconTextColor = Colors.grey,
      this.selectedBgColor = Colors.deepPurple,
      this.noSelectedBgColor = Colors.white});

  @override
  Widget buildWidget(double diffPosition) {
    double iconOnlyOpacity = 1.0;
    double iconTextOpacity = 0;

    if (diffPosition < 1) {
      iconOnlyOpacity = diffPosition;
      iconTextOpacity = 1 - diffPosition;
    } else {
      iconOnlyOpacity = 1.0;
      iconTextOpacity = 0;
    }

    return Container(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: iconTextOpacity,
            child: Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 4),
                        blurRadius: 6)
                  ],
                  color: selectedIconTextColor,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Icon(
                        iconData,
                        size: sizeIcon,
                        color: selectedIconTextColor,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.fill,
                    child: Text(
                      text,
                      style:
                          TextStyle(fontSize: 15, color: selectedIconTextColor),
                    ),
                  )
                ],
              ),
            ),
          ),
          Opacity(
            opacity: iconOnlyOpacity,
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 4),
                        blurRadius: 6),
                  ],
                  color: selectedIconTextColor,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              padding: EdgeInsets.all(10),
              child: FittedBox(
                fit: BoxFit.fill,
                child: Icon(
                  iconData,
                  color: selectedIconTextColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class BoxMensageMobile extends StatefulWidget{
//   @override
//   _BoxMensageMobileState createState() => _BoxMensageMobileState();
// }
//
// class _BoxMensageMobileState extends State<BoxMensageMobile> {
//   List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];
//
//   RefreshController _refreshController =
//   RefreshController(initialRefresh: false);
//
//   void _onRefresh() async {
//     // monitor network fetch
//     await Future.delayed(Duration(milliseconds: 1000));
//     // if failed,use refreshFailed()
//     _refreshController.refreshCompleted();
//   }
//
//   void _onLoading() async {
//     // monitor network fetch
//     await Future.delayed(Duration(milliseconds: 1000));
//     // if failed,use loadFailed(),if no data return,use LoadNodata()
//     items.add((items.length + 1).toString());
//     if (mounted) setState(() {});
//     _refreshController.loadComplete();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: SmartRefresher(
//         enablePullDown: true,
//         enablePullUp: true,
//         header: WaterDropHeader(),
//         // footer: CustomFooter(
//         //   builder: (BuildContext context, LoadStatus mode) {
//         //     Widget body;
//         //     if (mode == LoadStatus.idle) {
//         //       body = Text("pull up load");
//         //     } else if (mode == LoadStatus.loading) {
//         //       body = CupertinoActivityIndicator();
//         //     } else if (mode == LoadStatus.failed) {
//         //       body = Text("Load Failed!Click retry!");
//         //     } else if (mode == LoadStatus.canLoading) {
//         //       body = Text("release to load more");
//         //     } else {
//         //       body = Text("No more Data");
//         //     }
//         //     return Container(
//         //       height: 55.0,
//         //       child: Center(child: body),
//         //     );
//         //   },
//         // ),
//         controller: _refreshController,
//         onRefresh: _onRefresh,
//         onLoading: _onLoading,
//         child: ListView.builder(
//           itemCount: items.length,
//           itemExtent: 100.0,
//           itemBuilder: (c, i) => Card(child: Center(child: Text(items[i]))),
//         ),
//       ),
//     );
//   }
// }
