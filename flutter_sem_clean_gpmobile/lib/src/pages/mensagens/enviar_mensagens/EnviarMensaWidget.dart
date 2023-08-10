import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/mensagens/model/StatusMensaModel.dart';

import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'dart:ui';
import '../vizualizar_mensagens/PageHeroWidget.dart';
import 'EnviarMensaBloc.dart';

class EnviarMensaWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EnviarMensaWidgetState();
  }
}

/// {@template custom_rect_tween}
/// Linear RectTween with a [Curves.easeOut] curve.
///
/// Less dramatic that the regular [RectTween] used in [Hero] animations.
/// {@endtemplate}
class CustomRectTween extends RectTween {
  /// {@macro custom_rect_tween}
  CustomRectTween({
    @required Rect begin,
    @required Rect end,
  }) : super(begin: begin, end: end);

  @override
  Rect lerp(double t) {
    final elasticCurveValue = Curves.easeOut.transform(t);
    return Rect.fromLTRB(
      lerpDouble(begin.left, end.left, elasticCurveValue),
      lerpDouble(begin.top, end.top, elasticCurveValue),
      lerpDouble(begin.right, end.right, elasticCurveValue),
      lerpDouble(begin.bottom, end.bottom, elasticCurveValue),
    );
  }
}

class _EnviarMensaWidgetState extends State<EnviarMensaWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _chaveEnviarMensaMob =
      GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _chaveEnviarMensaWeb =
      GlobalKey<ScaffoldState>();
  final _formKeyEnviarMensaMob = GlobalKey<FormState>();
  final _formKeyEnviarMensaWeb = GlobalKey<FormState>();

  TextEditingController _tituloController = new TextEditingController();
  TextEditingController _descricaoController = new TextEditingController();
  dynamic dataFormatada =
      DateFormat('dd/MM/yyyy kk:mm:ss').format(DateTime.now());
  String campoDescricaoVazio = 'Campo não pode ser vazio!...';
  bool campoVazio;
  bool isVisible = true;
  StatusModel objMensa;
  Future<void> chamarBotao() async {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    isVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: AppGradients.gradient,
        child: ScreenTypeLayout(
          breakpoints: ScreenBreakpoints(desktop: 899, tablet: 730, watch: 279),
          mobile: OrientationLayoutBuilder(
            portrait: (context) => _enviarMensaWidgetMobile(),
            landscape: (context) => _enviarMensaWidgetMobile(),
          ),
          tablet: _enviarMensaWidgetWeb(context),
          desktop: _enviarMensaWidgetWeb(context),
        ),
      ),
    );
  }

  Widget _enviarMensaWidgetMobile() {
    // String descricao = _descricao.text;

    final txtEnviarTitleMob = Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
        child: Container(
            child: TextFormField(
          validator: (value) {
            if (_tituloController.value.text == null ||
                _tituloController.value.text == "") {
              return 'Campo não pode ser vazio!';
            }
            return null;
          },
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Colors.red),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusColor: Colors.grey,
            labelText: "Título Mensagem ...",
            icon: Icon(Icons.text_fields_rounded, size: 30, color: Colors.grey),
            labelStyle: TextStyle(
                height: 2,
                fontSize: 16.0,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold),
            filled: true,
            fillColor: Colors.white,
            errorStyle: TextStyle(
                height: 2,
                fontSize: 16.0,
                color: Color(0xFFC42224),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold),
          ),
          controller: _tituloController,
          cursorColor: Colors.grey,
          maxLines: 1,
          maxLength: 25,
        )));

    final txtEnviarDescriptionMob = Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Container(
        child: TextFormField(
          // The validator receives the text that the user has entered.
          validator: (value) {
            if (_descricaoController.value.text == null ||
                _descricaoController.value.text == "") {
              return 'Campo não pode ser vazio!';
            }
            return null;
          },
          controller: _descricaoController,
          minLines: 4,
          maxLines: 15,
          autocorrect: false,
          decoration: InputDecoration(
            labelText: "Descrição Mensagem ...",
            icon: Icon(Icons.description, size: 30, color: Colors.grey),
            labelStyle: TextStyle(
                height: 2,
                fontSize: 16.0,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold),
            filled: true,
            fillColor: Colors.white,
            errorStyle: TextStyle(
                height: 2,
                fontSize: 16.0,
                color: Color(0xFFC42224),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold),
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(10.0),
              borderSide: new BorderSide(),
            ),
          ),
        ),
      ),
    );

    final btnEnviarMensaMob = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      //align buttoms to the right
      children: <Widget>[
        Container(
          child:
              //  (_tituloController == null ||
              //         _tituloController.text == "" &&
              //             _descricaoController == null ||
              //         _descricaoController.text == "")
              //     ? null
              //     :
              MaterialButton(
            onPressed: onPressedSalvarMensaMob,
            highlightColor: Colors.lightBlueAccent,
            highlightElevation: 8,
            elevation: 18,
            shape: StadiumBorder(),
            child: Text(
              "Salvar",
              style: TextStyle(
                color: Estilo().branca,
              ),
            ),
            color: Theme.of(context).backgroundColor,
            enableFeedback: true,
          ),
        )
      ],
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Nova Mensagem'),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
          key: _formKeyEnviarMensaMob,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              txtEnviarTitleMob,
              SizedBox(height: 18.0),
              txtEnviarDescriptionMob,
              SizedBox(height: 8.0),
              btnEnviarMensaMob,
              SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _enviarMensaWidgetWeb(context) {
    //VARIAVEIS
    final txtEnviarTitleWeb = Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Container(
        child: TextFormField(
          // The validator receives the text that the user has entered.
          validator: (value) {
            if (_tituloController.value.text == null ||
                _tituloController.value.text == "") {
              return 'Campo não pode ser vazio!';
            }
            return null;
          },
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Colors.red),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusColor: Colors.grey,
            labelText: "Título Mensagem ...",
            icon: Icon(Icons.text_fields_rounded, size: 30, color: Colors.grey),
            labelStyle: TextStyle(
                height: 2,
                fontSize: 16.0,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold),
            filled: true,
            fillColor: Colors.white,
            errorStyle: TextStyle(
                height: 2,
                fontSize: 16.0,
                color: Color(0xFFC42224),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold),
          ),
          controller: _tituloController,
          cursorColor: Colors.grey,
          maxLines: 1,
          maxLength: 25,
        ),
      ),
    );
    final txtEnviarDescriptionWeb = Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Container(
        child: TextFormField(
          // The validator receives the text that the user has entered.
          validator: (value) {
            if (_descricaoController.value.text == null ||
                _descricaoController.value.text == "") {
              return 'Campo não pode ser vazio!';
            }
            return null;
          },
          controller: _descricaoController,
          minLines: 4,
          maxLines: 15,
          autocorrect: false,
          decoration: InputDecoration(
            labelText: "Descrição Mensagem ...",
            icon: Icon(Icons.description, size: 30, color: Colors.grey),
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(10.0),
              borderSide: new BorderSide(),
            ),
            labelStyle: TextStyle(
                height: 2,
                fontSize: 16.0,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold),
            filled: true,
            fillColor: Colors.white,
            errorStyle: TextStyle(
              height: 2,
              fontSize: 16.0,
              color: Color(0xFFC42224),
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
    final btnEnviarMensaWeb = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          child: MaterialButton(
            onPressed: onPressedSalvarMensaWeb,
            highlightColor: Colors.lightBlueAccent,
            highlightElevation: 8,
            elevation: 18,
            shape: StadiumBorder(),
            child: Text(
              "Salvar",
              style: TextStyle(
                color: Estilo().branca,
              ),
            ),
            color: Theme.of(context).backgroundColor,
            enableFeedback: true,
          ),
        )
      ],
    );
//ESQUELETO
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Nova Mensagem'),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
          key: _formKeyEnviarMensaWeb,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              txtEnviarTitleWeb,
              SizedBox(height: 18.0),
              txtEnviarDescriptionWeb,
              SizedBox(height: 8.0),
              btnEnviarMensaWeb,
              SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }

///////////// * [METODOS] /////////////////
  onPressedSalvarMensaMob() async {
    //campos preenchidos...
    if (_formKeyEnviarMensaMob.currentState.validate()) {
      //salvar dados
      await new EnviarMensaBloc().postEnviarMensagem(
          context,
          _tituloController.text,
          _descricaoController.text,
          dataFormatada,
          1,
          0,
          null,
          true);
      //chamar pop-up
      await AlertDialogTemplate().showAlertDialogSimplesEnviarMensa(
          context, "", "Mensagem enviada com sucesso!");
      //limpar tela
      _tituloController.clear();
      _descricaoController.clear();
    }
  }

  onPressedSalvarMensaWeb() async {
    //campos preenchidos...
    if (_formKeyEnviarMensaWeb.currentState.validate()) {
      //salvar dados
      await new EnviarMensaBloc().postEnviarMensagem(
          context,
          _tituloController.text,
          _descricaoController.text,
          dataFormatada,
          1,
          0,
          null,
          true);
      //chamar pop-up
      await AlertDialogTemplate().showAlertDialogSimplesEnviarMensa(
          context, "", "Mensagem enviada com sucesso!");
      //limpar campos
      _tituloController.clear();
      _descricaoController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Campo não pode ser vazio!')),
      );
    }
  }

  // Future<void> showAlertEnviarMensa(
  //     BuildContext context, String titulo, String mensagem) {
  //   return Alert(
  //     buttons: [
  //       DialogButton(
  //         child: Text(
  //           "Confirmar",
  //           style: TextStyle(color: Colors.white, fontSize: 18),
  //         ),
  //         onPressed: () => onpressed(),
  //         color: Color.fromRGBO(0, 179, 134, 1.0),
  //       ),
  //       DialogButton(
  //         child: Text(
  //           "Cancelar",
  //           style: TextStyle(color: Colors.white, fontSize: 18),
  //         ),
  //         onPressed: () => Navigator.pop(context),
  //         gradient: AppGradients.linear2,
  //       ),
  //     ],
  //     context: context,
  //     title: 'Você tem certeza que deseja enviar a mensagem?',
  //   ).show();
  // }

  String validaCampos(value) {
    if (_tituloController.value.text == null ||
        _tituloController.value.text == "" &&
            _descricaoController.value.text == null ||
        _descricaoController.value.text == "") {
      return campoDescricaoVazio;
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
