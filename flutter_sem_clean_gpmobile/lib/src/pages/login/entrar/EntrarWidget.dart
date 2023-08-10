import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:gpmobile/src/pages/login/entrar/EntrarBloc.dart';

import 'package:gpmobile/src/pages/login/recuperar_senha/RecuperarSenhaWidget.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/AtualizarPorTimer.dart';
import 'package:gpmobile/src/util/Estilo.dart';

import 'package:gradient_input_border/gradient_input_border.dart';
import 'package:gradients/gradients.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gpmobile/src/util/images.dart';
import 'package:gpmobile/src/util/constants.dart';

class EntrarWidget extends StatefulWidget {
  @override
  _EntrarWidgetState createState() => _EntrarWidgetState();
}

class _EntrarWidgetState extends State<EntrarWidget> {
//VARIAVEIS
  final usuarioCtrl = new TextEditingController();
  final senhaCtrl = new TextEditingController();

  final isWebMobile = (defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android);

  dynamic url = 'http://intranet.grupohegidio.com.br:81/app/gpmobile.apk';
  bool _passwordVisible; //BLOQUEAR VISILIBILIDADE DA SENHA
  bool statusVersao = true; //VERIFICAR STATUS DA VERSAO
  bool camposBloq = true; // CAMPOS BLOQUEADOS
  bool userSalvo = false; //VALIDAR OS DADOS

  String loginUser = "Usuário";
  String senhaUser = "Senha";
  String txtLembrarUsuario = 'Salvar meu usuário';
  int acao = 1; //acao 1 = logar

  final _atualizaPorTempo = AtualizarPorTimer(milisegundos: 500);
  Gradient _unfocusGradient = LinearGradientPainter(
    end: Alignment.topRight,
    begin: Alignment.bottomLeft,
    colors: <Color>[
      Color(0xFF2e2a4f),
      Color(0xFFC42224),
    ],
  );

  //INICIO
  @override
  void initState() {
    super.initState();

    _passwordVisible = false;

    getData().then((value) {
      userSalvo = value;
      if (userSalvo == true) {
        camposBloq = false;
      } else {
        camposBloq = true;
      }
    });

    // EntrarBloc().versaoEstaAtualizada(context).then(
    //   (value) async {
    //     if (value == false) {
    //       await AlertDialogTemplate().showAlertDialogSimples(context, "Atencão",
    //           "A versao desse aplicativo esta desatualizada, sera baixado uma nova versao! \nFavor realizar a instalacao apos o download...");
    //       statusVersao = value; //forcar atualizacao do app...

    //       if (await canLaunch(url)) {
    //         await launch(url);
    //       } else {
    //         await AlertDialogTemplate().showAlertDialogSimples(
    //             context, "Alerta", 'URL não encontrada $url');
    //       }
    //     }
    //   },
    // );
    _atualizaPorTempo.run(() {
      if (isWebMobile == true) {
        EntrarBloc().versaoEstaAtualizada(context).then(
          (value) async {
            if (value == false) {
              await AlertDialogTemplate().showAlertDialogSimples(
                  context,
                  "Atenção",
                  "A versão desse aplicativo está desatualizada, será baixado uma nova versão! \nFavor realizar a instalação após o download...");
              statusVersao = value; //forcar atualizacao do app...

              if (await canLaunch(url)) {
                await launch(url);
              } else {
                await AlertDialogTemplate().showAlertDialogSimples(
                    context, "Alerta", 'URL não encontrada $url');
              }
            }
          },
        );
      } else {
        print("web");
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

//PRINCIPAL
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //BODY
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Container(
        decoration: AppGradients.gradient,
        child: ScreenTypeLayout(
          breakpoints: ScreenBreakpoints(
            desktop: 900,
            tablet: 499,
            watch: 250,
          ), //desktop: 900, tablet: 650, watch: 250
          mobile: OrientationLayoutBuilder(
            portrait: (context) => entrarWidgetMobile(context),
            landscape: (context) => entrarWidgetMobile(context),
          ),
          tablet: entrarWidgetWeb(context),
          desktop: entrarWidgetWeb(context),
        ),
      ),
    );
  }

//MOBILE
  Widget entrarWidgetMobile(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        children: <Widget>[
          logoTop(context),
          SizedBox(height: height * 0.1), //48
          cpfColaborador(context),
          SizedBox(height: height * 0.01), //8
          password(context),
          SizedBox(width: width * 3, height: height * 0.01), //8
          salvarDados(context),
          SizedBox(height: height * 0.01), //24
          btnEntrar(context, 'mob'),
          SizedBox(width: width * 3, height: height * 0.01),
          recuperarSenha("mob"),
          // logoBotton(context),
        ],
      ),
    );
  }

//TABLET
  Widget EntrarWidgetTablet(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        children: <Widget>[
          logoTop(context),
          SizedBox(height: height * 0.1), //48
          cpfColaborador(context),
          SizedBox(height: height * 0.01), //8
          password(context),
          SizedBox(width: width * 3, height: height * 0.01), //8
          salvarDados(context),
          SizedBox(height: height * 0.01), //24
          btnEntrar(context, 'mob'),
        ],
      ),
    );
  }

  //WEB
  Widget entrarWidgetWeb(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 320,
          maxWidth: 768,
          // minHeight: double.infinity,
          // maxHeight: double.infinity,
        ),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logoTop(context),
            SizedBox(height: height * 0.1), //48
            cpfColaborador(context),
            SizedBox(height: height * 0.01), //8
            password(context),
            SizedBox(width: width * 3, height: height * 0.01), //8
            salvarDados(context),
            SizedBox(height: height * 0.01), //24
            btnEntrar(context, 'web'),
            recuperarSenha("web"),
            SizedBox(height: height * 0.01), //24
            txtAndroid(context),
            qrCode(context),
          ],
        ),
      ),
    );
  }

  //WIDGETS
  Widget logoTop(BuildContext context) {
    return new Center(
      child: Image.asset(
        imageLogoLogin,
        scale: 4.9,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget cpfColaborador(BuildContext context) {
    // final theme = Theme.of(context);
    return new Container(
      // borderRadius: 5,
      // color: Colors.red,
      child: TextField(
        controller: usuarioCtrl,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        enabled: userSalvo == false ? true : false,
        cursorColor: Colors.black45,
        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
        decoration: new InputDecoration(
          border: GradientOutlineInputBorder(
            focusedGradient: _unfocusGradient,
            unfocusedGradient: _unfocusGradient,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          labelText: loginUser,
          labelStyle: TextStyle(
            // color: Colors.black54,
            height: 2,
            fontSize: 13.0,
          ),
          filled: true,
          fillColor: Color(0xFFe7edeb),
          //fundo
          prefixIcon: Icon(
            Icons.perm_identity,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget password(BuildContext context) {
    return new Container(
      // borderRadius: 5,
      // color: theme.backgroundColor,
      child: TextFormField(
        controller: senhaCtrl,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.go,
        enableInteractiveSelection: true,
        enabled: userSalvo == false ? true : false,
        cursorColor: Colors.black45,
        obscureText: !_passwordVisible,
        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          labelStyle: TextStyle(
            // color: theme.backgroundColor,
            height: 2,
            fontSize: 13.0,
          ),
          labelText: senhaUser,
          border: GradientOutlineInputBorder(
            focusedGradient: _unfocusGradient,
            unfocusedGradient: _unfocusGradient,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          filled: true,
          fillColor: Color(0xFFe7edeb),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: Colors.grey[600],
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: () => setState(() {
              _passwordVisible = !_passwordVisible;
            }),
          ),
        ),
      ),
    );
  }

  Widget salvarDados(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: height * 0.1,
        ),
        Text(
          txtLembrarUsuario,
          style: TextStyle(color: Colors.white70),
        ),
        SizedBox(
          width: width * 0.25,
        ),
        Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              child: ConditionalSwitch.single<String>(
                context: context,
                valueBuilder: (context) => "A",
                caseBuilders: {
                  'A': (context) => new Switch(
                        // activeTrackColor: Colors.lightGreenAccent,
                        // activeColor: Colors.green,
                        // activeColor: theme.canvasColor,
                        activeTrackColor: Colors.orange[200],
                        activeColor: Colors.orange,

                        value: userSalvo,
                        onChanged: (value) async {
                          // String senhaCtrlUpperCase = senhaCtrl.text.toUpperCase();
                          if (value == true &&
                              inputText(usuarioCtrl, senhaCtrl) != "") {
                            setState(() => userSalvo = true);
                            setState(() => camposBloq = userSalvo);
                          } else {
                            setState(() => userSalvo = false);
                            setState(() => camposBloq = userSalvo);
                            setState(() => clearInputText());
                          }
                        },
                      ),
                  'B': (BuildContext context) => Text('B!'),
                },
                fallbackBuilder: (BuildContext context) => Text('None'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget btnEntrar(BuildContext context, tipoPlataforma) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: InkWell(
        onTap: () => _validarDados(tipoPlataforma),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Estilo().btnEntrar,
            borderRadius: new BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text(
              'ENTRAR',
              style: TextStyle(
                // color: theme.textTheme.headline1.color,
                fontSize: 25,
                color: Colors.white70,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget btnEntrarWeb(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        // customBorderRadius: BorderRadius.all(Radius.circular(40)),
        // color: theme.backgroundColor,
        child: MaterialButton(
          onPressed: () => _validarDados('web'),
          color: Estilo().btnEntrar,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          // elevation: 5,
          height: 50,
          child: Text(
            'ENTRAR',
            style: TextStyle(
              // color: theme.textTheme.headline1.color,
              fontSize: 25,
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  Widget logoBotton(BuildContext context) {
    return new Center(
      child: Image.asset(
        imageLogoGrupoHorizontal,
        scale: 3.9,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget txtAndroid(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        // customBorderRadius: BorderRadius.all(Radius.circular(40)),
        // color: theme.backgroundColor,
        child: Column(
          children: [
            Text(
              'Disponível para Android',
              style: TextStyle(
                // color: theme.textTheme.headline1.color,
                fontSize: 25,
                color: Colors.white70,
              ),
            ),
            // Icon(
            //   Icons.android,
            //   color: Estilo().branca,
            //   size: 50,
            // ),
          ],
        ),
      ),
    );
  }

  Widget qrCode(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        // child: Image.asset(
        //   imageQRCode,
        // ),
        child: Image.asset(imageQRCode),
        decoration: BoxDecoration(
          color: Estilo().branca,
          // border: Border.all(width: 3.0),
          borderRadius: BorderRadius.all(
              Radius.circular(5.0) //                 <--- border radius here
              ),
        ),
      ),
    );
  }

  // Widget qrCode(BuildContext context) {
  //   return new Center(
  //     child: Image.network(
  //       imageQRCode,
  //       scale: 3.9,
  //       fit: BoxFit.fill,
  //     ),
  //   );
  // }
  Widget copyright(BuildContext context) {
    return new Column(
      children: [
        Text(
          'Copyright ©2020, All Rights Reserved.',
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 12.0,
            // color: Theme.of(context).accentColor
          ),
        ),
        Text(
          'Powered by Grupo H. Egídio',
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 12.0,
            // color: Theme.of(context).accentColor),
          ),
        ),
      ],
    );
  }

  Widget recuperarSenha(plataforma) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Esqueceu a senha?",
            style:
                TextStyle(color: AppColors.white, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            width: 5,
          ),
          InkWell(
            onTap: () async {
              if (userSalvo == true) {
                switch (plataforma) {
                  case "mob":
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            RecuperarSenhaWidget()));
                    break;
                  case "web":
                    Navigator.of(context).pushNamed(RECUPERAR_SENHA);
                    break;
                  default:
                }
              } else {
                await AlertDialogTemplate().showAlertDialogSimples(context,
                    "Atencão", "Para recuperar senha, salve seu usuário!");
              }
            },
            child: Text(
              "Recuperar",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.orange[200],
                  fontSize: 19),
            ),
          )
        ],
      ),
    );
  }

  Widget logoWeb(BuildContext context) {
    return new Hero(
      tag: 'login',
      child: Column(
        children: [
          Text(
            'GP WEB',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 30,
            ),
          )
        ],
      ),
    );
  }

//METODOS
  void _validarDados(plataforma) {
    //define tipo plataforma (mobile or web)

    if (isWebMobile == true) {
      EntrarBloc().versaoEstaAtualizada(context).then((value) async {
        if (value == false) {
          await AlertDialogTemplate().showAlertDialogSimples(context, "Atencão",
              "Favor realizar a instalacao da nova versao, apos o download...");
          if (await canLaunch(url)) {
            //logica de atualizacao do app...
            await launch(url);
            //
          } else {
            await AlertDialogTemplate().showAlertDialogSimples(
                context, "Alerta", 'URL não encontrada $url');
          }
        } else {
          if (usuarioCtrl.text == null ||
              usuarioCtrl.text == "" && senhaCtrl.text == null ||
              senhaCtrl.text == "") {
            print('campo us e senha vazio');
          } else {
            await new EntrarBloc().validarUsuario(context, usuarioCtrl.text,
                senhaCtrl.text, acao, plataforma, true);
          }
        }
      });
    } else {
      print("web");
      if (usuarioCtrl.text == null ||
          usuarioCtrl.text == "" && senhaCtrl.text == null ||
          senhaCtrl.text == "") {
        print('campo us e senha vazio');
      } else {
        new EntrarBloc().validarUsuario(
            context, usuarioCtrl.text, senhaCtrl.text, acao, plataforma, true);
      }
    }
  }

  Future<bool> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      usuarioCtrl.text = prefs.getString('usuario');
      senhaCtrl.text = prefs.getString('senha');
    });
    if (prefs.getString('usuario') != '' && prefs.getString('senha') != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> setData(TextEditingController usuarioCtrl,
      TextEditingController senhaCtrl, limparCampos) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (limparCampos == true) {
        prefs.remove('usuario');
        prefs.remove('senha');
      } else {
        prefs.setString('usuario', usuarioCtrl.text);
        prefs.setString('senha', senhaCtrl.text);
      }
    });
    print(prefs.get('usuario'));
    print(prefs.get('senha'));
  }

  Future<void> clearInputText() async {
    setState(() => userSalvo = false);
    usuarioCtrl.clear();
    senhaCtrl.clear();
    setData(usuarioCtrl, senhaCtrl, true);
  }

  inputText(
      TextEditingController usuarioCtrl, TextEditingController senhaCtrl) {
    setData(usuarioCtrl, senhaCtrl, false);
    print('usuario: ${usuarioCtrl.text}, salva!');
  }
}
