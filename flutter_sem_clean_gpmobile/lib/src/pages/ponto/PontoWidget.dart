import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:gpmobile/src/pages/ponto/PontoBloc.dart';
import 'package:gpmobile/src/pages/ponto/PontoModel.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';

class PontoWidget extends StatefulWidget {
  //metodo recebe dados da tela de contra-cheque
  PontoWidget(String cmes, String cano, {Key key, this.title})
      : super(key: key) {
    pmes = cmes;
    pano = cano;
  }

  final String title;

  @override
  _PontoWidgetState createState() => _PontoWidgetState();
}

String pmes;
String pano;

class _PontoWidgetState extends State<PontoWidget> {
  SearchBar searchBar; // final controller = FloatingSearchBarController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _chavePontoMob =
      new GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _chavePontoWeb =
      new GlobalKey<ScaffoldState>();

  // ignore: deprecated_member_use
  List<TtPonto2> _periodo = new List();
  PontoModel _ponto = new PontoModel(); //criei o modelo!
  // ignore: unused_field
  bool _isButtonDisabled = true;
  bool isAscending = true;
  static const int sortData = 0;
  int sortType = sortData;
  String retPeriodo;
  String nomePeriodo;

  String mesAssinatura;
  String anoAssinatura;

  @override
  void initState() {
    super.initState();
    // ignore: unused_element
    void onSubmitted(String value) {
      setState(() => _scaffoldKey.currentState
          // ignore: deprecated_member_use
          .showSnackBar(
              new SnackBar(content: new Text('Você escreveu $value!'))));
    }

    if ((pmes == null) && (pano == null)) {
      String mes = new DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .month
          .toString()
          .padLeft(2, '0');
      String ano = new DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .year
          .toString();

      pmes = mes;
      pano = ano;
      _appBarMostrarMes(mes, ano);
      //////////////habilita botao////////////////
      PontoBloc().blocPontoAssinar(context, mes, ano, 0).then((map2) async {
        if (map2 != null && map2.response.plogAssinado == 0) {
          setState(() => _isButtonDisabled = false);
          PontoBloc().getPontoPeriodo(context, mes, ano, true).then((map) {
            //BOTAO-HABILITADO
            setState(() {
              _ponto = map;
              // ignore: deprecated_member_use
              _periodo = new List();
              _appBarMostrarMes(mes, ano);
              for (var ttPonto2 in _ponto.response.ttPonto.ttPonto2) {
                if (_ponto.response.pChrDescErro == "OK") {
                  _periodo.add(ttPonto2);
                }
              }
            });
          });
        } else {
          setState(() => _isButtonDisabled = true);
          PontoBloc().getPontoPeriodo(context, mes, ano, true).then((map) {
            //BOTAO-DESABILITADO
            setState(() {
              _ponto = map; //salva periodo da api
              // ignore: deprecated_member_use
              _periodo = new List();
              _appBarMostrarMes(mes, ano);
              for (var ttPonto2 in _ponto.response.ttPonto.ttPonto2) {
                //quebra periodos em periodo
                if (_ponto.response.pChrDescErro == "OK") {
                  _periodo.add(ttPonto2); //salva cada indice
                }
              }
            });
          });
        }
      });
      /////////////////////////////////////////////////////////////////////////////...........CONTRA-CHEQUE............////////////////////////////////////////////////////////////////////////////////////////////
    } else {
      var mes = pmes;
      var ano = pano;
      _appBarMostrarMes(pmes, pano);
      //habilita botao ( if(_isButtonDisabled == true) )
      PontoBloc().blocPontoAssinar(context, mes, ano, 0).then((map2) async {
        if (map2.response != null && map2.response.plogAssinado == 0) {
          setState(() {
            PontoBloc().getPontoPeriodo(context, mes, ano, true).then((map) {
              //BOTAO-HABILITADO!
              setState(() {
                _isButtonDisabled = false;
                _ponto = map;
                // ignore: deprecated_member_use
                _periodo = new List();
                _appBarMostrarMes(mes, ano);
                for (var ttPonto2 in _ponto.response.ttPonto.ttPonto2) {
                  if (_ponto.response.pChrDescErro == "OK") {
                    _periodo.add(ttPonto2);
                  }
                }
              });
            });
          });
        } else {
          _appBarMostrarMes(mes, ano);
          setState(() => _isButtonDisabled = true);
          PontoBloc().getPontoPeriodo(context, mes, ano, true).then((map) {
            //BOTAO-DESABILITADO!
            setState(() {
              _ponto = map;
              // ignore: deprecated_member_use
              _periodo = new List();
              _appBarMostrarMes(mes, ano);
              for (var ttPonto2 in _ponto.response.ttPonto.ttPonto2) {
                if (_ponto.response.pChrDescErro == "OK") {
                  _periodo.add(ttPonto2);
                }
              }
            });
          });
        }
      });
    }
    //fim do initState()
  }

  String _appBarMostrarMes(m, a) {
    String ano = a;
    switch (m) {
      case "01":
        nomePeriodo = "Janeiro";
        break;
      case "02":
        nomePeriodo = "Fevereiro";
        break;
      case "03":
        nomePeriodo = "Marco";
        break;
      case "04":
        nomePeriodo = "Abril";
        break;
      case "05":
        nomePeriodo = "Maio";
        break;
      case "06":
        nomePeriodo = "Junho";
        break;
      case "07":
        nomePeriodo = "Julho";
        break;
      case "08":
        nomePeriodo = "Agosto";
        break;
      case "09":
        nomePeriodo = "Setembro";
        break;
      case "10":
        nomePeriodo = "Outubro";
        break;
      case "11":
        nomePeriodo = "Novembro";
        break;
      case "12":
        nomePeriodo = "Dezembro";
        break;
      default:
        nomePeriodo = "indisponivel!";
        break;
    }

    if (ano != "") {
      nomePeriodo = nomePeriodo + "/" + ano;
    } else {
      print(nomePeriodo);
    }
    return nomePeriodo;
  }

  @override
  void dispose() {
    super.dispose();
  }

  buildBtnAssinar(valor) async {
    String envMes = mesAssinatura;
    String envAno = anoAssinatura;

    print(envMes + " - " + envAno);
    // () async {
    switch (valor) {
      //caso botao h3251abilitado, apos clicar, montar tela-assinatura de ponto...
      case false:
        setState(() {
          AlertDialogTemplate()
              .showAlertDialogConfirmReg(
            context,
            "Assinar Registro de Ponto: ",
            "Matricula",
            envMes,
            envAno,
            1,
          )
              .then(
            (ret) async {
              setState(() => _isButtonDisabled = true);
              await AlertDialogTemplate().showAlertDialogSimples(
                  context, "Atencao", "ponto assinado ok!");
            },
          );
        }); //setState
        break;
      default:
        print("btnAssinar nao habilitado");
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // This size provide us total height and width  of our screen
    // responsive pattern
    //https://stackoverflow.com/questions/49553402/flutter-screen-size
    return Material(
      child: Scaffold(
        backgroundColor: Colors.transparent,

        ///////////////////////////////////////////////////////////
        body: Container(
          decoration: AppGradients.gradient,
          child: ScreenTypeLayout(
            breakpoints:
                ScreenBreakpoints(desktop: 899, tablet: 730, watch: 279),
            mobile: OrientationLayoutBuilder(
              portrait: (context) => pontoWidgetMobile(context),
              landscape: (context) => pontoWidgetMobile(context),
            ),
            tablet: pontoWidgetWeb(),
            desktop:
                Center(child: Container(width: 1200, child: pontoWidgetWeb())),
          ),
        ),
        //////////////////////////////////////////////////////////////
        //botao flutuante ref:(https://medium.com/codechai/anatomy-of-material-buttons-in-flutter-first-part-40eb790979a6)
        floatingActionButton: _isButtonDisabled
            ? null
            : MaterialButton(
                highlightColor: Theme.of(context).backgroundColor,
                highlightElevation: 8,
                elevation: 8,
                shape: StadiumBorder(),
                child: Text(
                  "Assinar",
                  style: TextStyle(
                      color: _isButtonDisabled
                          ? Colors.black.withOpacity(0.0)
                          : Colors.white),
                ),
                color: Theme.of(context).backgroundColor,
                textColor: Estilo().textCor,
                enableFeedback: true,
                onPressed: () => buildBtnAssinar(_isButtonDisabled),
              ),
        //   onPressed: _isButtonDisabled
        //       ? null
        //       : () => AlertDialogTemplate()
        //               .showAlertDialogConfirmReg(
        //                   context, "Assinar Registro de Ponto: ", "Matricula")
        //               .then((value) async {
        //             if (value != null && value != "") {
        //               await PontoBloc()
        //                   .blocPontoAssinar(context, pmes, pano, 1)
        //                   .then((map) async {
        //                 if (map.response != null &&
        //                     map.response.plogAssinado == 1) {
        //                   setState(() => _isButtonDisabled = true);
        //                   AlertDialogTemplate().showAlertDialogSimples(
        //                       context,
        //                       "Assinatura",
        //                       "Assinatura realizada com sucesso!");
        //                 } else {
        //                   return new AlertDialogTemplate()
        //                       .showProgressDialog(context, "Campo vazio!");
        //                   // ignore: dead_code
        //                   print("****Campo vazio****");
        //                 }
        //               });
        //             } else {
        //               print("****Campo vazio****");
        //               setState(() async {
        //                 await new AlertDialogTemplate().showAlertDialogSimples(
        //                     context,
        //                     "Alerta",
        //                     "Campo matricula não pode ser vazio!");
        //               });
        //             }
        //           }),
        // ),
      ),
    );
  }

  //MOBILE
  Widget pontoWidgetMobile(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          appbar(context),
          _buildTable(width, height),
          // _buildRefDoMes(),
        ],
      ),
    );
  }

  Widget appbar(context) {
    return AppBar(
      backgroundColor: Theme.of(context).backgroundColor,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Ponto',
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        Row(
          // mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("$nomePeriodo"),
            IconButton(
              icon: Icon(
                Icons.date_range,
                size: 30,
              ),
              color: Colors.white,
              splashColor: Colors.blue,
              splashRadius: 20,
              onPressed: () => AlertDialogTemplate()
                  .showAlertDialogPeriodList(context, "Selecione um Periodo")
                  .then((map) async {
                retPeriodo = map;

                mesAssinatura = retPeriodo.substring(0, 2);
                anoAssinatura = retPeriodo.substring(3, 7);
                _appBarMostrarMes(mesAssinatura, anoAssinatura);

                if ((mesAssinatura != null || mesAssinatura != "") &&
                    (anoAssinatura != null || anoAssinatura != "")) {
                  //habilita botao ( if(_isButtonDisabled == true) )
                  PontoBloc()
                      .blocPontoAssinar(
                          context, mesAssinatura, anoAssinatura, 0)
                      .then((map2) async {
                    if (map2.response != null &&
                        map2.response.plogAssinado == 0) {
                      setState(() => _isButtonDisabled = false);
                      print("+++++++Botao Habilitado+++++++++!");
                      PontoBloc()
                          .getPontoPeriodo(
                              context, mesAssinatura, anoAssinatura, true)
                          .then((map) {
                        setState(() {
                          _ponto = map;

                          // ignore: deprecated_member_use
                          _periodo = new List();
                          for (var ttPonto2
                              in _ponto.response.ttPonto.ttPonto2) {
                            if (_ponto.response.pChrDescErro == "OK") {
                              _periodo.add(ttPonto2);
                            }
                          }
                        });
                      });
                    } else {
                      setState(() => _isButtonDisabled = true);
                      print("-------Botao desabilitado--------!");
                      PontoBloc()
                          .getPontoPeriodo(
                              context, mesAssinatura, anoAssinatura, true)
                          .then((map) {
                        setState(() {
                          _ponto = map;

                          // ignore: deprecated_member_use
                          _periodo = new List();

                          for (var ttPonto2
                              in _ponto.response.ttPonto.ttPonto2) {
                            if (_ponto.response.pChrDescErro == "OK") {
                              _periodo.add(ttPonto2);
                            }
                          }
                        });
                      });
                    }
                  });
                }
              }),
            ),
          ],
        )
      ],
    );
  }

  Positioned _buildTable(double width, double height) {
    return Positioned(
      // Table
      top: 60.0,
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Container(
        key: _chavePontoMob,
        child: HorizontalDataTable(
          leftHandSideColumnWidth: width * 0.25,
          rightHandSideColumnWidth: width * 1.46,
          isFixedHeader: true,
          headerWidgets: _getTitleWidgetMobile(),
          leftSideItemBuilder: _generateFirstColumnRowMobile,
          rightSideItemBuilder: _generateRightHandSideColumnRowMobile,
          itemCount: _periodo.length,

          //cria lista baseada no tamanho dela
          rowSeparatorWidget: const Divider(
            color: Colors.blueGrey,
            height: 3.0,
            thickness: 1.0,
          ),
          leftHandSideColBackgroundColor: Theme.of(context).canvasColor,
          rightHandSideColBackgroundColor: Theme.of(context).canvasColor,
        ),
        height: height,
      ),
    );
  }

  Positioned _buildRefDoMes() {
    return Positioned(
      top: 30.0,
      left: 150.0,
      right: 150.0,
      child: MaterialButton(
        highlightColor: Theme.of(context).backgroundColor,
        highlightElevation: 8,
        elevation: 8,
        shape: StadiumBorder(),
        child: Row(
          children: [
            Text(
              "Agosto",
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(width: 20),
            Icon(Icons.calendar_today, color: Colors.black)
          ],
        ),
        color: Colors.white,
        textColor: Estilo().textCor,
        // backgroundColor: Estilo().btnAssinar,
        enableFeedback: true,
        onPressed: () async {
          switch (_isButtonDisabled) {
            //caso botao habilitado, apos clicar, montar tela-assinatura de ponto...
            case false:
              // setState(() {
              await AlertDialogTemplate().showAlertDialogConfirmReg(
                context,
                "Assinar Registro de Ponto: ",
                "Matricula",
                pmes,
                pano,
                1,
              );
              // }); //setState
              break;
            default:
              print("btnAssinar nao habilitado");
              return null;
          }
        },
      ),
    );
  }

  List<Widget> _getTitleWidgetMobile() {
    return <Widget>[
      Container(
        // padding: EdgeInsets.all(0),
        // padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: _getTitleItemWidgetMobile1(
            'Dia' + (sortType == sortData ? (isAscending ? '↓' : '↑') : ''),
            1.5),
        // onPressed: () {
        //   sortType = sortData;
        //   isAscending = !isAscending;
        //   ponto.sortData(isAscending);
        //   setState(() {});
        // },
      ),
      Container(
        padding: EdgeInsets.all(0),
        // onPressed: () {},
        child: _getTitleItemWidgetMobile2(
          'Entrada',
          // (sortType == sortStatus ? (isAscending ? '↓' : '↑') : ''),
        ),
        // onPressed: () {
        //   sortType = sortStatus;
        //   isAscending = !isAscending;
        //   ponto.sortData(isAscending);
        //   setState(() {});
        // },
      ),
      _getTitleItemWidgetMobile3(
        'Saída-I',
      ),
      _getTitleItemWidgetMobile4(
        'Retorno-I',
      ),
      _getTitleItemWidgetMobile5(
        'Saída',
      ),
      _getTitleItemWidgetMobile6(
        'Obs',
      ),
    ];
  }

  Widget _getTitleItemWidgetMobile1(String label, double height) {
    // int dropdownValue = DynamicTheme.of(context).themeId;
    double width = MediaQuery.of(context).size.width;

    //dia
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
      child: Text(label,
          style: TextStyle(
              color: new Estilo().textCor, fontWeight: FontWeight.bold)),
      color: Estilo().prima,
      width: width * 4.9,
      height: 50,
      alignment: Alignment.centerLeft,
    );
  }

  Widget _getTitleItemWidgetMobile2(String label) {
    // int dropdownValue = DynamicTheme.of(context).themeId;
    double width = MediaQuery.of(context).size.width;
    //entrada
    return Container(
      child: Text(label,
          style: TextStyle(
              color: new Estilo().textCor, fontWeight: FontWeight.bold)),
      color: Estilo().prima,
      width: width * 0.20,
      height: 50,
      alignment: Alignment.centerLeft,
    );
  }

  Widget _getTitleItemWidgetMobile3(String label) {
    // int dropdownValue = DynamicTheme.of(context).themeId;

    double width = MediaQuery.of(context).size.width;
    //saida1
    return Container(
      child: Text(label,
          style: TextStyle(
              color: new Estilo().textCor, fontWeight: FontWeight.bold)),
      color: Estilo().prima,
      width: width * 0.2,
      height: 50,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _getTitleItemWidgetMobile4(String label) {
    // int dropdownValue = DynamicTheme.of(context).themeId;

    double width = MediaQuery.of(context).size.width;
    //retorno1
    return Container(
      child: Text(label,
          style: TextStyle(
              color: new Estilo().textCor, fontWeight: FontWeight.bold)),
      color: Estilo().prima,
      width: width * 0.20,
      height: 50,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _getTitleItemWidgetMobile5(String label) {
    // int dropdownValue = DynamicTheme.of(context).themeId;

    double width = MediaQuery.of(context).size.width;
    //saida
    return Container(
      child: Text(label,
          style: TextStyle(
              color: new Estilo().textCor, fontWeight: FontWeight.bold)),
      color: Estilo().prima,
      width: width * 0.25,
      height: 50,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _getTitleItemWidgetMobile6(String label) {
    // int dropdownValue = DynamicTheme.of(context).themeId;

    double width = MediaQuery.of(context).size.width;
    //obs
    return Container(
      child: Text(label,
          style: TextStyle(
              color: new Estilo().textCor, fontWeight: FontWeight.bold)),
      color: Estilo().prima,
      width: width * 0.61,
      height: 50,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRowMobile(BuildContext context, int index) {
    // int dropdownValue = DynamicTheme.of(context).themeId;

    double width = MediaQuery.of(context).size.width;
    DateFormat f = new DateFormat('EEE, dd/MM/yy', 'pt');
    return Container(
      child:
          Text(f.format(DateTime.parse(_periodo[index].datMarcacao)).toString(),
              style: TextStyle(
                  // color: Theme.of(context).backgroundColor,
                  color: new Estilo().textCor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
      color: Estilo().prima,
      width: width * 0.10,
      height: 50,
      padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRowMobile(
      BuildContext context, int index) {
    double width = MediaQuery.of(context).size.width;
    return new Row(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              // Icon(
              //     _periodo[index].horaIni
              //         ? Icons.notifications_off
              //         : Icons.notifications_active,
              //     color:
              //         ponto._periodo[index]. ? Colors.red : Colors.green),
              Text(
                _periodo[index].horaIni /*? '08:06' : '07:59'*/,
                style: TextStyle(
                  color: Theme.of(context).backgroundColor,
                ),
              )
            ],
          ),
          // width: MediaQuery.of(context).size.width * 0.22,
          color: new Estilo().textCor,
          // width: 90,
          width: width * 0.20,
          height: 50,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          alignment: Alignment.center,
        ),
        Container(
          child: Text(
            _periodo[index].horaAlmIni,
            style: TextStyle(
              color: Theme.of(context).backgroundColor,
            ),
          ),
          color: new Estilo().textCor,
          // width: 90,
          width: width * 0.20,
          height: 50,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(
            _periodo[index].horaAlmFim,
            style: TextStyle(
              color: Theme.of(context).backgroundColor,
            ),
          ),
          color: new Estilo().textCor,
          // width: 90,
          width: width * 0.20,
          height: 50,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(
            _periodo[index].horaFim,
            style: TextStyle(
              color: Theme.of(context).backgroundColor,
            ),
          ),
          color: new Estilo().textCor,
          // width: 90,
          width: width * 0.25,
          height: 50,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(
            _periodo[index].obs,
            style: TextStyle(
              color: Theme.of(context).backgroundColor,
            ),
          ),
          color: new Estilo().textCor,
          width: width * 0.61,
          height: 50,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }

  //TABLET
  Widget pontoWidgetTablet() {
    // int dropdownValue = DynamicTheme.of(context).themeId;
    // final corBackground =
    //     dropdownValue == 0 ? Colors.blueGrey : Colors.blueGrey;
    // Color corDivider = dropdownValue == 0 ? Colors.blueGrey : Colors.blueGrey;

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: HorizontalDataTable(
        leftHandSideColumnWidth: width * 0.25,
        rightHandSideColumnWidth: width * 1.46,
        isFixedHeader: true,
        headerWidgets: _getTitleWidgetTablet(),
        leftSideItemBuilder: _generateFirstColumnRowTablet,
        rightSideItemBuilder: _generateRightHandSideColumnRowTablet,
        itemCount: _periodo.length,

        //cria lista baseada no tamanho dela
        rowSeparatorWidget: const Divider(
          color: Colors.blueGrey,
          height: 3.0,
          thickness: 1.0,
        ),
        leftHandSideColBackgroundColor: Theme.of(context).canvasColor,
        rightHandSideColBackgroundColor: Theme.of(context).canvasColor,
      ),
      height: height,
    );
  }

  List<Widget> _getTitleWidgetTablet() {
    return <Widget>[
      Container(
        // padding: EdgeInsets.all(0),
        // padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: _getTitleItemWidgetTablet1('Dia', 1.5),
        // onPressed: () {
        //   sortType = sortData;
        //   isAscending = !isAscending;
        //   ponto.sortData(isAscending);
        //   setState(() {});
        // },
      ),
      Container(
        padding: EdgeInsets.all(0),
        // onPressed: () {},
        child: _getTitleItemWidgetTablet2(
          'Entrada',
          // (sortType == sortStatus ? (isAscending ? '↓' : '↑') : ''),
        ),
        // onPressed: () {
        //   sortType = sortStatus;
        //   isAscending = !isAscending;
        //   ponto.sortData(isAscending);
        //   setState(() {});
        // },
      ),
      _getTitleItemWidgetTablet3(
        'Saída-I',
      ),
      _getTitleItemWidgetTablet4(
        'Retorno-I',
      ),
      _getTitleItemWidgetTablet5(
        'Saída',
      ),
      _getTitleItemWidgetTablet6(
        'Obs',
      ),
    ];
  }

  Widget _getTitleItemWidgetTablet1(String label, double height) {
    // int dropdownValue = DynamicTheme.of(context).themeId;
    double width = MediaQuery.of(context).size.width;

    //dia
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
      child: Text(label,
          style: TextStyle(
              color: new Estilo().textCor, fontWeight: FontWeight.bold)),
      color: Estilo().prima,
      width: width * 4.9,
      height: 50,
      alignment: Alignment.centerLeft,
    );
  }

  Widget _getTitleItemWidgetTablet2(String label) {
    // int dropdownValue = DynamicTheme.of(context).themeId;
    double width = MediaQuery.of(context).size.width;
    //entrada
    return Container(
      child: Text(label,
          style: TextStyle(
              color: new Estilo().textCor, fontWeight: FontWeight.bold)),
      color: Estilo().prima,
      width: width * 0.20,
      height: 50,
      alignment: Alignment.centerLeft,
    );
  }

  Widget _getTitleItemWidgetTablet3(String label) {
    // int dropdownValue = DynamicTheme.of(context).themeId;

    double width = MediaQuery.of(context).size.width;
    //saida1
    return Container(
      child: Text(label,
          style: TextStyle(
              color: new Estilo().textCor, fontWeight: FontWeight.bold)),
      color: Estilo().prima,
      width: width * 0.2,
      height: 50,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _getTitleItemWidgetTablet4(String label) {
    // int dropdownValue = DynamicTheme.of(context).themeId;

    double width = MediaQuery.of(context).size.width;
    //retorno1
    return Container(
      child: Text(label,
          style: TextStyle(
              color: new Estilo().textCor, fontWeight: FontWeight.bold)),
      color: Estilo().prima,
      width: width * 0.20,
      height: 50,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _getTitleItemWidgetTablet5(String label) {
    // int dropdownValue = DynamicTheme.of(context).themeId;

    double width = MediaQuery.of(context).size.width;
    //saida
    return Container(
      child: Text(label,
          style: TextStyle(
              color: new Estilo().textCor, fontWeight: FontWeight.bold)),
      color: Estilo().prima,
      width: width * 0.25,
      height: 50,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _getTitleItemWidgetTablet6(String label) {
    // int dropdownValue = DynamicTheme.of(context).themeId;

    double width = MediaQuery.of(context).size.width;
    //obs
    return Container(
      child: Text(label,
          style: TextStyle(
              color: new Estilo().textCor, fontWeight: FontWeight.bold)),
      color: Estilo().prima,
      width: width * 0.61,
      height: 50,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRowTablet(BuildContext context, int index) {
    // int dropdownValue = DynamicTheme.of(context).themeId;

    double width = MediaQuery.of(context).size.width;
    DateFormat f = new DateFormat('EEE, dd/MM/yy', 'pt');
    return Container(
      child:
          Text(f.format(DateTime.parse(_periodo[index].datMarcacao)).toString(),
              style: TextStyle(
                  // color: Theme.of(context).backgroundColor,
                  color: new Estilo().textCor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
      color: Estilo().prima,
      width: width * 0.10,
      height: 50,
      padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRowTablet(
      BuildContext context, int index) {
    double width = MediaQuery.of(context).size.width;
    return new Row(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              // Icon(
              //     _periodo[index].horaIni
              //         ? Icons.notifications_off
              //         : Icons.notifications_active,
              //     color:
              //         ponto._periodo[index]. ? Colors.red : Colors.green),
              Text(
                _periodo[index].horaIni /*? '08:06' : '07:59'*/,
                style: TextStyle(
                  color: Theme.of(context).backgroundColor,
                ),
              )
            ],
          ),
          // width: MediaQuery.of(context).size.width * 0.22,
          color: new Estilo().textCor,
          // width: 90,
          width: width * 0.20,
          height: 50,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          alignment: Alignment.center,
        ),
        Container(
          child: Text(
            _periodo[index].horaAlmIni,
            style: TextStyle(
              color: Theme.of(context).backgroundColor,
            ),
          ),
          color: new Estilo().textCor,
          // width: 90,
          width: width * 0.20,
          height: 50,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(
            _periodo[index].horaAlmFim,
            style: TextStyle(
              color: Theme.of(context).backgroundColor,
            ),
          ),
          color: new Estilo().textCor,
          // width: 90,
          width: width * 0.20,
          height: 50,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(
            _periodo[index].horaFim,
            style: TextStyle(
              color: Theme.of(context).backgroundColor,
            ),
          ),
          color: new Estilo().textCor,
          // width: 90,
          width: width * 0.25,
          height: 50,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(
            _periodo[index].obs,
            style: TextStyle(
              color: Theme.of(context).backgroundColor,
            ),
          ),
          color: new Estilo().textCor,
          width: width * 0.61,
          height: 50,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }

  //WEB
  Widget pontoWidgetWeb() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _chavePontoWeb,
      backgroundColor: Colors.transparent,
      appBar: appbarWeb(),
      body: Container(
        child: HorizontalDataTable(
          leftHandSideColumnWidth: width * 0.09,
          rightHandSideColumnWidth: width * 0.5,
          isFixedHeader: true,
          headerWidgets: _getTitleWidgetWeb(),
          leftSideItemBuilder: _generateFirstColumnRowWeb,
          rightSideItemBuilder: _generateRightHandSideColumnRowWeb,
          itemCount: _periodo.length,

          //cria lista baseada no tamanho dela
          rowSeparatorWidget: const Divider(
            color: Colors.blueGrey,
            height: 3.0,
            thickness: 1.0,
          ),
          leftHandSideColBackgroundColor: Theme.of(context).canvasColor,
          rightHandSideColBackgroundColor: Theme.of(context).canvasColor,
        ),
        height: height,
      ),
    );
  }

  Widget appbarWeb() {
    return AppBar(
      backgroundColor: Theme.of(context).backgroundColor,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text(
        'Ponto',
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        Row(
          children: [
            Text("$nomePeriodo"),
            IconButton(
              icon: Icon(
                Icons.date_range,
                size: 30,
              ),
              color: Colors.white,
              splashColor: Colors.blue,
              splashRadius: 20,
              onPressed: () => AlertDialogTemplate()
                  .showAlertDialogPeriodList(context, "Selecione um Periodo")
                  .then((map) async {
                retPeriodo = map;

                mesAssinatura = retPeriodo.substring(0, 2);
                anoAssinatura = retPeriodo.substring(3, 7);
                _appBarMostrarMes(mesAssinatura, anoAssinatura);
                if ((mesAssinatura != null || mesAssinatura != "") &&
                    (anoAssinatura != null || anoAssinatura != "")) {
                  //habilita botao ( if(_isButtonDisabled == true) )
                  PontoBloc()
                      .blocPontoAssinar(
                          context, mesAssinatura, anoAssinatura, 0)
                      .then((map2) async {
                    if (map2.response != null &&
                        map2.response.plogAssinado == 0) {
                      setState(() => _isButtonDisabled = false);
                      print("+++++++Botao Habilitado+++++++++!");
                      PontoBloc()
                          .getPontoPeriodo(
                              context, mesAssinatura, anoAssinatura, true)
                          .then((map) {
                        setState(() {
                          _ponto = map;

                          // ignore: deprecated_member_use
                          _periodo = new List();

                          for (var ttPonto2
                              in _ponto.response.ttPonto.ttPonto2) {
                            if (_ponto.response.pChrDescErro == "OK") {
                              _periodo.add(ttPonto2);
                            }
                          }
                        });
                      });
                    } else {
                      setState(() => _isButtonDisabled = true);
                      print("-------Botao desabilitado--------!");
                      PontoBloc()
                          .getPontoPeriodo(
                              context, mesAssinatura, anoAssinatura, true)
                          .then((map) {
                        setState(() {
                          _ponto = map;

                          // ignore: deprecated_member_use
                          _periodo = new List();

                          for (var ttPonto2
                              in _ponto.response.ttPonto.ttPonto2) {
                            if (_ponto.response.pChrDescErro == "OK") {
                              _periodo.add(ttPonto2);
                            }
                          }
                        });
                      });
                    }
                  });
                }
              }),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _getTitleWidgetWeb() {
    return <Widget>[
      Container(
        // padding: EdgeInsets.all(0),
        // padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: _getTitleItemWidgetWeb1(
            'Dia' + (sortType == sortData ? (isAscending ? '↓' : '↑') : ''),
            1.5),
        // onPressed: () {
        //   sortType = sortData;
        //   isAscending = !isAscending;
        //   ponto.sortData(isAscending);
        //   setState(() {});
        // },
      ),
      Container(
        padding: EdgeInsets.all(0),
        // onPressed: () {},
        child: _getTitleItemWidgetWeb2(
          'Entrada',
          // (sortType == sortStatus ? (isAscending ? '↓' : '↑') : ''),
        ),
        // onPressed: () {
        //   sortType = sortStatus;
        //   isAscending = !isAscending;
        //   ponto.sortData(isAscending);
        //   setState(() {});
        // },
      ),
      _getTitleItemWidgetWeb3(
        'Saída-I',
      ),
      _getTitleItemWidgetWeb4(
        'Retorno-I',
      ),
      _getTitleItemWidgetWeb5(
        'Saída',
      ),
      _getTitleItemWidgetWeb6(
        'Obs',
      ),
    ];
  }

  Widget _getTitleItemWidgetWeb1(String label, double height) {
    // int dropdownValue = DynamicTheme.of(context).themeId;
    double width = MediaQuery.of(context).size.width;

    //dia
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Text(label,
          style: TextStyle(
              color: new Estilo().textCor, fontWeight: FontWeight.bold)),
      color: Estilo().prima,
      width: width * 0.11,
      height: 50,
      alignment: Alignment.centerLeft,
    );
  }

  Widget _getTitleItemWidgetWeb2(String label) {
    // int dropdownValue = DynamicTheme.of(context).themeId;
    double width = MediaQuery.of(context).size.width;
    //entrada
    return Container(
      child: Text(label,
          style: TextStyle(
              color: new Estilo().textCor, fontWeight: FontWeight.bold)),
      color: Estilo().prima,
      width: width * 0.08,
      height: 50,
      alignment: Alignment.centerLeft,
    );
  }

  Widget _getTitleItemWidgetWeb3(String label) {
    // int dropdownValue = DynamicTheme.of(context).themeId;

    double width = MediaQuery.of(context).size.width;
    //saida1
    return Container(
      child: Text(label,
          style: TextStyle(
              color: new Estilo().textCor, fontWeight: FontWeight.bold)),
      color: Estilo().prima,
      width: width * 0.08,
      height: 50,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _getTitleItemWidgetWeb4(String label) {
    // int dropdownValue = DynamicTheme.of(context).themeId;

    double width = MediaQuery.of(context).size.width;
    //retorno1
    return Container(
      child: Text(label,
          style: TextStyle(
              color: new Estilo().textCor, fontWeight: FontWeight.bold)),
      color: Estilo().prima,
      width: width * 0.08,
      height: 50,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _getTitleItemWidgetWeb5(String label) {
    // int dropdownValue = DynamicTheme.of(context).themeId;

    double width = MediaQuery.of(context).size.width;
    //saida
    return Container(
      child: Text(label,
          style: TextStyle(
              color: new Estilo().textCor, fontWeight: FontWeight.bold)),
      color: Estilo().prima,
      width: width * 0.08,
      height: 50,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _getTitleItemWidgetWeb6(String label) {
    // int dropdownValue = DynamicTheme.of(context).themeId;

    double width = MediaQuery.of(context).size.width;
    //obs
    return Container(
      child: Text(label,
          style: TextStyle(
              color: new Estilo().textCor, fontWeight: FontWeight.bold)),
      color: Estilo().prima,
      width: width * 0.18,
      height: 50,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRowWeb(BuildContext context, int index) {
    // int dropdownValue = DynamicTheme.of(context).themeId;

    double width = MediaQuery.of(context).size.width;
    DateFormat f = new DateFormat('EEE, dd/MM/yy', 'pt');
    return Container(
      child:
          Text(f.format(DateTime.parse(_periodo[index].datMarcacao)).toString(),
              style: TextStyle(
                  // color: Theme.of(context).backgroundColor,
                  color: new Estilo().textCor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
      color: Estilo().prima,
      width: width * 0.08,
      height: 50,
      padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRowWeb(BuildContext context, int index) {
    double width = MediaQuery.of(context).size.width;
    return new Row(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              // Icon(
              //     _periodo[index].horaIni
              //         ? Icons.notifications_off
              //         : Icons.notifications_active,
              //     color:
              //         ponto._periodo[index]. ? Colors.red : Colors.green),
              Text(
                _periodo[index].horaIni /*? '08:06' : '07:59'*/,
                style: TextStyle(
                  color: Theme.of(context).backgroundColor,
                ),
              )
            ],
          ),
          // width: MediaQuery.of(context).size.width * 0.22,
          color: new Estilo().textCor,
          // width: 90,
          width: width * 0.08,
          height: 50,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          alignment: Alignment.center,
        ),
        Container(
          child: Text(
            _periodo[index].horaAlmIni,
            style: TextStyle(
              color: Theme.of(context).backgroundColor,
            ),
          ),
          color: new Estilo().textCor,
          // width: 90,
          width: width * 0.08,
          height: 50,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(
            _periodo[index].horaAlmFim,
            style: TextStyle(
              color: Theme.of(context).backgroundColor,
            ),
          ),
          color: new Estilo().textCor,
          // width: 90,
          width: width * 0.08,
          height: 50,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(
            _periodo[index].horaFim,
            style: TextStyle(
              color: Theme.of(context).backgroundColor,
            ),
          ),
          color: new Estilo().textCor,
          // width: 90,
          width: width * 0.08,
          height: 50,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(
            _periodo[index].obs,
            style: TextStyle(
              color: Theme.of(context).backgroundColor,
            ),
          ),
          color: new Estilo().textCor,
          width: width * 0.18,
          height: 50,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }

  ///[METODOS]

  // }
}

Ponto ponto = Ponto();

class Ponto {
  // ignore: deprecated_member_use
  List<TtPonto2> listaPonto2 = List();

  ponto(List<TtPonto2> listaPonto) {
    listaPonto2 = listaPonto;
  }

  void sortData(bool isAscending) {
    listaPonto2.sort((a, b) {
      int aId = int.tryParse(a.datMarcacao);
      int bId = int.tryParse(b.datMarcacao);
      return (aId - bId) * (isAscending ? 1 : -1);
    });
  }
}
