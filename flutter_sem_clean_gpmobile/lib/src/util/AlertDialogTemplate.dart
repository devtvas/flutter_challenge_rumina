import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//https://androidkt.com/flutter-alertdialog-example/
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gpmobile/src/pages/configuracoes/ConfigWidget.dart';
import 'package:gpmobile/src/pages/login/entrar/EntrarWidget.dart';
import 'package:gpmobile/src/pages/login/recuperar_senha/RecuperarSenhaBloc.dart';
import 'package:gpmobile/src/pages/ponto/PontoBloc.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

//https://www.youtube.com/watch?v=58_IM0OTU2M

NumberFormat f = new NumberFormat("00");
DateTime dataAtualMais1 =
    DateTime(DateTime.now().year, DateTime.now().month + 1, 1);
DateTime dataAtual = new DateTime.now();
DateTime dataAtualMenos1 =
    DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
DateTime dataAtualMenos2 =
    DateTime(DateTime.now().year, DateTime.now().month - 2, 1);
DateTime dataAtualMenos3 =
    DateTime(DateTime.now().year, DateTime.now().month - 3, 1);
DateTime dataAtualMenos4 =
    DateTime(DateTime.now().year, DateTime.now().month - 4, 1);
DateTime dataAtualMenos5 =
    DateTime(DateTime.now().year, DateTime.now().month - 5, 1);
DateTime dataAtualMenos6 =
    DateTime(DateTime.now().year, DateTime.now().month - 6, 1);
DateTime dataAtualMenos7 =
    DateTime(DateTime.now().year, DateTime.now().month - 7, 1);

// DateTime dataAtual = new DateTime.now();
// DateTime dataAtualMenos1 = dataAtual.add(const Duration(days: -30));
// DateTime dataAtualMenos2 = dataAtual.add(const Duration(days: -60));
// DateTime dataAtualMenos3 = dataAtual.add(const Duration(days: -90));
// DateTime dataAtualMenos4 = dataAtual.add(const Duration(days: -120));
// DateTime dataAtualMenos5 = dataAtual.add(const Duration(days: -150));
// DateTime dataAtualMenos6 = dataAtual.add(const Duration(days: -180));

dynamic periodoAtualGeral = f.format(dataAtual.day).toString() +
    "/" +
    f.format(dataAtual.month).toString() +
    "/" +
    dataAtual.year.toString();

String periodoAtualMais1 = f.format(dataAtualMais1.month).toString() +
    "/" +
    dataAtualMenos1.year.toString();

String periodoAtual =
    f.format(dataAtual.month).toString() + "/" + dataAtual.year.toString();

String periodoAtualMenos1 = f.format(dataAtualMenos1.month).toString() +
    "/" +
    dataAtualMenos1.year.toString();
String periodoAtualMenos2 = f.format(dataAtualMenos2.month).toString() +
    "/" +
    dataAtualMenos2.year.toString();
String periodoAtualMenos3 = f.format(dataAtualMenos3.month).toString() +
    "/" +
    dataAtualMenos3.year.toString();
String periodoAtualMenos4 = f.format(dataAtualMenos4.month).toString() +
    "/" +
    dataAtualMenos4.year.toString();
// String periodoAtualMenos5 = f.format(dataAtualMenos5.month).toString() +
//     "/" +
//     dataAtualMenos5.year.toString();

enum ConfirmAction { CANCELAR, OK }
enum ConfirmActionHome { CANCELAR, SAIR }

class AlertDialogTemplate extends State<StatefulWidget>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return null;
  }

//GERAL
  ProgressDialog showProgressDialog(BuildContext context, String mensagem) {
    ProgressDialog progressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);

    progressDialog.style(
        message: mensagem,
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: SpinKitRipple(
          // color: Color(0xff9E71EB),
          color: Color(0xFFC42224),
          size: 70.0,
          controller: AnimationController(
              vsync: this, duration: const Duration(milliseconds: 1200)),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w600));

    return progressDialog;
  }

//////////////////////////////////////////////////////////////////////
//   Future<void> showAlertDialogWithIcon(
//       BuildContext context, , String mensagem) {
//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Row(
//             children: [(iconImage)],
//           ),
//           content: Text(
//             mensagem,
//             style: TextStyle(fontSize: 12),
//           ),
//           actions: <Widget>[
//             FlatButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               color: Estilo().btnOK,
//             ),
//           ],
//         );
//       },
//     );
//   }

  // ////////////////////////////////////////////////////////////////////////
  // Future<void> showAlertDialogVersao(
  //     BuildContext context, String titulo, String mensagem) {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(
  //           titulo,
  //           style: TextStyle(fontSize: 15),
  //         ),
  //         content: Text(
  //           mensagem,
  //           style: TextStyle(fontSize: 12),
  //         ),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text('OK'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               //metodo de atualiza
  //             },
  //             color: Theme.of(context).backgroundColor,
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  // ////////////////////////////////////////////////////////////////////////
  Future<void> showAlertDialogSimples(
      BuildContext context, String titulo, String mensagem) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final corBackground = Colors.white70.withOpacity(1);
        return AlertDialog(
          backgroundColor: corBackground,
          title: Text(
            titulo,
            style: TextStyle(fontSize: 15),
          ),
          content: Text(
            mensagem,
            style: TextStyle(fontSize: 12),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Theme.of(context).backgroundColor,
            ),
          ],
        );
      },
    );
  }

//25/08/2021
  Future<void> showAlertDialogTrocarSenha(
      BuildContext context, String titulo, String mensagem) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final corBackground = Colors.white70.withOpacity(1);
        return AlertDialog(
          backgroundColor: corBackground,
          title: Text(
            titulo,
            style: TextStyle(fontSize: 15),
          ),
          content: Text(
            mensagem,
            style: TextStyle(fontSize: 12),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Theme.of(context).backgroundColor,
            ),
          ],
        );
      },
    );
  }

//
  Future<void> showAlertDialogSenhaRecuperada(
      BuildContext context, String titulo, String mensagem, String type) {
    int _notificacao = 1; // int _notificacao = 1;
    int _acaoRecuperSenha = 2; // int _acaoRecuperSenha = 2;
    //chamar bloc passando parametros
    enviarEmail() async {
      await new RecuperarSenhaBloc()
          .blocRecPorEmail(context, _notificacao, _acaoRecuperSenha, '', true);
    }

    enviarSMS() async {
      // await new EntrarBloc().validarUsuario(
      //     context, usuarioController.text, senhaCtrl.text, acao, true);
    }
    // abrirGmail() async {

    //   final Uri params = Uri(
    //     scheme: 'mailto',
    //     path: 'tarcisio.word@gmail.com',
    //     query:
    //         'subject=Recuperacao de senha&body=sua senha é: ${minhaSenha.toString()}',
    //   );
    //   String url = params.toString();
    //   if (await canLaunch(url)) {
    //     await launch(url);
    //   } else {
    //     print('Could not launch $url');
    //   }
    // }

    // enviarSms() async {
    //   var url = "sms:62997004940?body= sua senha é: ${minhaSenha.toString()}";
    //   if (await canLaunch(url)) {
    //     await launch(url);
    //   } else {
    //     throw 'Could not launch $url';
    //   }
    // }

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final corBackground = Colors.white70.withOpacity(1);
        return AlertDialog(
          backgroundColor: corBackground,
          title: Text(
            titulo,
            style: TextStyle(fontSize: 15),
          ),
          content: Text(
            mensagem,
            style: TextStyle(fontSize: 12),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                switch (type) {
                  //type ? email : sms
                  case "email":
                    Navigator.of(context).pop(enviarEmail());
                    break;
                  case "sms":
                    Navigator.of(context).pop(enviarSMS());
                    break;
                  default:
                }

                // Navigator.of(context)
                //     .pop(Share.share('verifique a caixa de email...'));
              },
              color: Theme.of(context).backgroundColor,
            ),
          ],
        );
      },
    );
  }

  ////////////////////////////////////////////////////////////////////////////
  //TELA ENVIAR-MENSAGENS
  Future<void> showAlertDialogSimplesEnviarMensa(
      BuildContext context, String titulo, String mensagem) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final corTitulo = Color(0xff757575);
        final corBackground = Colors.white70.withOpacity(1);
        return AlertDialog(
          backgroundColor: corBackground,
          title: Text(
            titulo,
            style: TextStyle(fontSize: 15, color: corTitulo),
          ),
          content: Text(
            mensagem,
            style: TextStyle(fontSize: 15, color: corTitulo),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.white.withOpacity(0.15)),
              ),
            )
          ],
        );
      },
    );
  }

  ////////////////////////////////////////////////////////////////////////////

//TELA HOME
  Future<ConfirmActionHome> showAlertDialogLogoff(BuildContext context,
      String titulo, String subtitulo, String plataforma) async {
    return showDialog<ConfirmActionHome>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!

      builder: (BuildContext context) {
        // int dropdownValue = DynamicTheme.of(context).themeId;
        final corBackground = Colors.white70.withOpacity(1);
        return AlertDialog(
          backgroundColor: corBackground,
          title: Text(
            titulo,
            style: TextStyle(fontSize: 15),
          ),
          content: Text(
            subtitulo,
            style: TextStyle(fontSize: 15),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text(
                'CANCELAR',
                style: TextStyle(fontSize: 12),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: const Text(
                'SAIR',
                style: TextStyle(fontSize: 12),
              ),
              onPressed: () {
                // Navigator.of(context).pushAndRemoveUntil(
                //     MaterialPageRoute(builder: (context) => EntrarWidget()),
                //     (Route<dynamic> route) => false);

                ///[new] 27/08
                switch (plataforma) {
                  case "mob":
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => EntrarWidget()),
                        (Route<dynamic> route) => false);
                    break;
                  case "web":
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(LOGIN, (route) => false);
                    break;
                  default:
                }
              },
            )
          ],
        );
      },
    );
  }

  //TELA FERIAS
  Future<void> showAlertDialogFerias(
      BuildContext context, String titulo, String mensagem) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final corBackground = Colors.white70.withOpacity(1);
        return AlertDialog(
          // buttonPadding: EdgeInsets.fromLTRB(24, 24, 24, 50),
          contentPadding: EdgeInsets.fromLTRB(24, 24, 24, 50),
          backgroundColor: corBackground,
          title: Text(
            titulo,
            style: TextStyle(fontSize: 15),
          ),
          content: Text(
            mensagem,
            style: TextStyle(fontSize: 12),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Theme.of(context).backgroundColor,
            ),
          ],
        );
      },
    );
  }

//TELA-PONTO ()
  Future<ProgressDialog> showProgressDialogPonto(
      BuildContext context, String mensagem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String dateAdmission = prefs.getString('dataAdmissao');

    ProgressDialog progressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);

    progressDialog.style(
        message: mensagem,
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: SpinKitRipple(
          color: Color(0xff9E71EB),
          size: 70.0,
          controller: AnimationController(
              vsync: this, duration: const Duration(milliseconds: 1200)),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w600));

    return progressDialog;
  }

//TELA PONTO
  Future<void> showAlertDialogFloating(
      BuildContext context, String titulo, String mensagem) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            titulo,
            style: TextStyle(fontSize: 15),
          ),
          content: Text(
            mensagem,
            style: TextStyle(fontSize: 12),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Estilo().appbar,
            ),
          ],
        );
      },
    );
  }

  //TELA PONTO
  Future<String> showAlertDialogConfirmReg(BuildContext context, String titulo,
      String descController, String pmes, String pano, int plogAssinado) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String matriculaAtual = prefs.getString('matricula');
    String mes = pmes;
    String ano = pano;
    int logAssinado = plogAssinado;
    final crtlAssinatura = new TextEditingController();
    String matriculaInformada = crtlAssinatura.text;
    String campoVazio = 'Campo não pode ser vazio!';
    String campoSenhaErrada = 'Matrícula errada!';

    ///[metodos]

    dynamic validarAssinaturaPonto(value) {
      if (value.isEmpty) {
        return campoVazio;
      } else if (value != matriculaAtual) {
        return campoSenhaErrada;
      }
      return null;
    }

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: AlertDialog(
            title: Text(titulo),
            content: new Row(
              children: <Widget>[
                new Expanded(
                  child: new TextFormField(
                    controller: crtlAssinatura,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: descController,
                      labelStyle: TextStyle(color: Estilo().popUpOk),
                      fillColor: Color(0xFFDBEDFF),
                      focusedBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                        borderSide: new BorderSide(color: Estilo().popUpOk),
                      ),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                        borderSide: new BorderSide(color: Estilo().popUpOk),
                      ),
                    ),
                    onChanged: (value) {
                      matriculaInformada = value;
                    },
                    validator: (value) => validarAssinaturaPonto(value),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                  child: Text(
                    'Ok',
                    style: TextStyle(
                      color: Colors.white60,
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      //forca validacao de matricula!!
                      if (matriculaInformada == matriculaAtual) {
                        await PontoBloc()
                            .blocPontoAssinar(context, mes, ano, logAssinado)
                            .then(
                          (map) async {
                            if (map.response != null &&
                                map.response.plogAssinado == 1) {
                              Navigator.of(context).pop();
                            }
                          },
                        );
                        return true;
                      }
                      // else {
                      //   return AlertDialogTemplate().showAlertDialogSimples(
                      //       context, "Matrícula errada!", "matricula informada$matriculaInformada");
                      // }
                    }
                  }),
              TextButton(
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    color: Estilo().popUpCancelar,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  //TELA PONTO, TELA CONTRA-CHEQUE
  Future<String> showAlertDialogPeriodList(
      BuildContext context, String titulo) async {
    return await showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          final corBackground = Colors.white70.withOpacity(1);
          final corTitulo = Color(0xff212121);
          final corPeriodo = Color(0xff757575);
          return SimpleDialog(
            backgroundColor: corBackground,
            title: Text(
              titulo,
              style: TextStyle(
                fontSize: 20.0,
                // color: Color(0xcc6506FF),
                // color: Colors.orangeAccent,
                // color: Colors.green.withOpacity(0.9),
                color: corTitulo,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, periodoAtualMais1);
                },
                child: Text("$periodoAtualMais1",
                    style: TextStyle(
                        color: corPeriodo, fontWeight: FontWeight.bold)),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, periodoAtual);
                },
                child: Text("$periodoAtual",
                    style: TextStyle(
                        color: corPeriodo, fontWeight: FontWeight.bold)),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, periodoAtualMenos1);
                },
                child: Text("$periodoAtualMenos1",
                    style: TextStyle(
                        color: corPeriodo, fontWeight: FontWeight.bold)),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, periodoAtualMenos2);
                },
                child: Text("$periodoAtualMenos2",
                    style: TextStyle(
                        color: corPeriodo, fontWeight: FontWeight.bold)),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, periodoAtualMenos3);
                },
                child: Text("$periodoAtualMenos3",
                    style: TextStyle(
                        color: corPeriodo, fontWeight: FontWeight.bold)),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, periodoAtualMenos4);
                },
                child: Text("$periodoAtualMenos4",
                    style: TextStyle(
                        color: corPeriodo, fontWeight: FontWeight.bold)),
              ),
              // SimpleDialogOption(
              //   onPressed: () {
              //     Navigator.pop(context, periodoAtualMenos5);
              //   },
              //   child: Text("$periodoAtualMenos5"),
              // )
            ],
          );
        });
  }

  //TELA CONTRA-CHEQUE
  Future<ConfirmAction> showAlertDialogPDF(
      BuildContext context, String titulo, String mensagem) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        final corBackground = Colors.white70.withOpacity(1);
        return AlertDialog(
          backgroundColor: corBackground,
          title: Text(
            titulo,
            style: TextStyle(fontSize: 15),
          ),
          content: Text(
            mensagem,
            style: TextStyle(fontSize: 15),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text(
                'CANCELAR',
                style: TextStyle(fontSize: 12),
              ),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCELAR);
              },
            ),
            FlatButton(
              child: const Text(
                'OK',
                style: TextStyle(fontSize: 12),
              ),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.OK);
              },
            )
          ],
        );
      },
    );
  }

  //TELA CONTRA-CHEQUE ref(https://medium.com/flutter-community/make-text-styling-more-effective-with-richtext-widget-b0e0cb4771ef)
  Future<ConfirmAction> showAlertDialogAssPonto(
      BuildContext context, String titulo, String subA, String subB) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white70.withOpacity(0.9),
          title: Text(
            titulo,
            style: TextStyle(color: Color(0xff757575), fontSize: 18),
          ),
          content: Container(
              // color: Colors.black,
              // padding: EdgeInsets.all(10),
              constraints: BoxConstraints.expand(width: 100, height: 80),
              child: Center(
                  child: RichText(
                text: TextSpan(
                    text: subA,
                    style: TextStyle(
                      // color: Theme.of(context).accentColor,
                      color: Colors.green,

                      fontSize: 18,
                      // fontWeight: FontWeight.bold
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: subB,
                          style: TextStyle(
                            color: Color(0xff757575),
                            fontSize: 18,
                            // fontWeight: FontWeight.bold
                          )),
                    ]),
              ))),
          actions: <Widget>[
            FlatButton(
              child: const Text(
                'CANCELAR',
                style: TextStyle(
                  color: Color(0xff757575),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCELAR);
              },
            ),
            FlatButton(
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.OK);
              },
              // color: Theme.of(context).textTheme.subtitle1.backgroundColor,
              color: Color(0xff757575),
            )
          ],
        );
      },
    );
  }

//TELA ABOUT
  Future<ConfirmActionHome> showAlertDialogLogoffAbout(
      BuildContext context, String titulo, String subtitulo) async {
    return showDialog<ConfirmActionHome>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!

      builder: (BuildContext context) {
        final corBackground = Colors.white70.withOpacity(1);
        return AlertDialog(
          backgroundColor: corBackground,
          title: Text(
            titulo,
            style: TextStyle(fontSize: 15),
          ),
          content: Text(
            subtitulo,
            style: TextStyle(fontSize: 15),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text(
                'CANCELAR',
                style: TextStyle(fontSize: 12),
              ),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => ConfigWidget()),
                    (Route<dynamic> route) => false);
              },
            ),
            FlatButton(
              child: const Text(
                'SAIR',
                style: TextStyle(fontSize: 12),
              ),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => EntrarWidget()),
                    (Route<dynamic> route) => false);
              },
            )
          ],
        );
      },
    );
  }
// //
// Future<String> showAlertDialogBoxField(BuildContext context, String titulo,
//     String tituloField, mensagemAjuda) async {
//   TextEditingController teamName = new TextEditingController();
//   return showDialog<String>(
//     context: context,
//     barrierDismissible:
//         false, // dialog is dismissible with a tap on the barrier
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text(titulo),
//         content: new Row(
//           children: <Widget>[
//             new Expanded(
//               child: Container(
//                 child: TextField(
//                   controller: teamName,
//                   minLines: 4,
//                   maxLines: 15,
//                   autocorrect: false,
//                   decoration: InputDecoration(
//                     labelText: 'Narrativa',
//                     labelStyle: TextStyle(color: Colors.blueGrey),
//                     filled: true,
//                     fillColor: Color(0xFFDBEDFF),
//                     focusedBorder: new OutlineInputBorder(
//                       borderRadius: new BorderRadius.circular(10.0),
//                       borderSide: new BorderSide(color: Colors.blueGrey),
//                     ),
//                     border: new OutlineInputBorder(
//                       borderRadius: new BorderRadius.circular(10.0),
//                       borderSide: new BorderSide(color: Colors.blueGrey),
//                     ),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//         actions: <Widget>[
//           FlatButton(
//             child: Text('Ok'),
//             onPressed: () {
//               Navigator.of(context).pop(teamName.text);
//             },
//           ),
//           FlatButton(
//             child: Text('Cancelar'),
//             onPressed: () {
//               Navigator.of(context).pop(null);
//             },
//           ),
//         ],
//       );
//     },
//   );
// }

//OUTRAS IDEIAS FUTURAS
//  Future<String> showAlertDialogApontamento(BuildContext context, Ttom2 ordem, String titulo, String tituloField, mensagemAjuda) async {
//    final format = {
//      InputType.both: DateFormat("dd/MM/yyyy '-' h:mm:ssa"),
//      InputType.date: DateFormat("dd/MM/yyyy"),
//      InputType.time: DateFormat("HH:mm:ss"),
//    };
//    InputType inputType = InputType.both;
//    InputType inputTypeData = InputType.date;
//    InputType inputTypeHora = InputType.time;
//    DateTime dateIni;
//    DateTime dateFim;
//
//    String dtini;
//    String dtfim;
//    String hrIni;
//    String hrFim;
//
//    TextEditingController teamName = new TextEditingController();
//    return showDialog<String>(
//      context: context,
//      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
//      builder: (BuildContext context) {
//        return AlertDialog(
//          title: Text(titulo),
//          content: new Container(
//            height: MediaQuery.of(context).size.height -460,
//            child: Column(
//              children: <Widget>[
//                Container(
//                  child: Container(
//                        height: 55,
//                        child: DateTimePickerFormField(
//                          inputType: inputType,
//                          format: format[inputType],
//                          editable: true,
//                          decoration: InputDecoration(
//                            labelText: 'Data/Hora Inicio',
//                            fillColor: Colors.black26,
//                            border: new OutlineInputBorder(
//                              borderRadius: new BorderRadius.circular(10.0),
//                              borderSide: new BorderSide(color: Colors.white,
//                              ),
//                            ),
//                            focusedBorder: new OutlineInputBorder(
//                              borderRadius: new BorderRadius.circular(10.0),
//                              borderSide: new BorderSide(color: Colors.black26,
//                              ),
//                            ),
//                          ),
//                          onChanged: (date) {
//                            dateIni = date;
////                            dtini = dateIni.day.toString() + "/" + dateIni.month.toString() + "/" + dateIni.year.toString();
////                            hrIni = DateFormat("HH:mm:ss").format(dateIni);
//                          },
//                        ),
//                      ),
//                ),
//                Container(
//                  child: Container(
//                        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
//                        height: 55,
//                        child: DateTimePickerFormField(
//                          inputType: inputType,
//                          format: format[inputType],
//                          editable: true,
//                          decoration: InputDecoration(
//                            labelText: 'Data/Hora Fim',
//                            fillColor: Colors.black26,
//                            border: new OutlineInputBorder(
//                              borderRadius: new BorderRadius.circular(10.0),
//                              borderSide: new BorderSide(color: Colors.white,
//                              ),
//                            ),
//                            focusedBorder: new OutlineInputBorder(
//                              borderRadius: new BorderRadius.circular(10.0),
//                              borderSide: new BorderSide(color: Colors.black26,
//                              ),
//                            ),
//                          ),
//                          onChanged: (date) {
//                            dateFim = date;
////                            hrFim = DateFormat("HH:mm:ss").format(dateFim);
//                          },
//                        ),
//                      ),
//                ),
//                Container(
//                  child: Container(
//                    margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
//                    height: 130,
//                    child: TextField(
//                      controller: teamName,
//                      minLines: 4,
//                      maxLines: 15,
//                      autocorrect: false,
//                      decoration: InputDecoration(
//                        labelText: 'Narrativa',
//                        labelStyle: TextStyle(color: Colors.blueGrey),
//                        filled: true,
//                        fillColor: Color(0xFFDBEDFF),
//                        focusedBorder: new  OutlineInputBorder(
//                          borderRadius: new BorderRadius.circular(10.0),
//                          borderSide: new BorderSide(color: Colors.blueGrey),
//                        ),
//                        border: new OutlineInputBorder(
//                          borderRadius: new BorderRadius.circular(10.0),
//                          borderSide: new BorderSide(color: Colors.blueGrey),
//                        ),
//                      ),
//                    ),
//                  ),
//                )
//              ],
//            ),
//          ),
//          actions: <Widget>[
//            FlatButton(
//              child: Text('Ok'),
//              onPressed: () async {
//                if(dateIni == null || dateFim == null){
//                  AlertDialogTemplate().showAlertDialogSimples(context,"Alerta", "Data/Hora de inicio e hora fim não podem ser VAZIAS!");
//                }
//                else{
//                  //Apontamento
//                  if(dateIni.millisecondsSinceEpoch > dateFim.millisecondsSinceEpoch){
//                    AlertDialogTemplate().showAlertDialogSimples(context, "Alerta", "Data/hora de inicio deve ser MENOR que Data/hora fim!");
//                  }
//                  else{
//                    if(dateFim.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch) {
//                      AlertDialogTemplate().showAlertDialogSimples(context,"Alerta", "Data/Hora final não pode ser MAIOR que Data/hora atual!");
//                    }
//                    else{
//                      await OrdensBloc().realizaApontamentoManualPeriodo(context, ordem.nrOM.toString(), DateFormat("yyyy-MM-dd").format(dateIni).toString(),DateFormat("yyyy-MM-dd").format(dateFim).toString(), DateFormat("HH:mm:ss").format(dateIni).toString(), DateFormat("HH:mm:ss").format(dateFim).toString(), teamName.text).then((ret){
//                        if(ret.response.pIntCodErro == 0){
//                          Navigator.of(context).pop("true");
//                        }
//                      });
//                    }
//                  }
//                }
//              },
//            ),
//            FlatButton(
//              child: Text('Cancelar'),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }

}
