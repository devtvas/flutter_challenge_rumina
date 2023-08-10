import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gpmobile/src/pages/documentos/enviar/Base64Model.dart'
    as Base64Model;
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/prefer_universal/io.dart';

import 'EnviarDocBloc.dart';

class EnviarDocWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppGradients.gradient,
        child: CardEnviarDocWidget(),
      ),
    );
  }
}

class CardEnviarDocWidget extends StatefulWidget {
  @override
  _CardEnviarDocWidgetState createState() => new _CardEnviarDocWidgetState();
}

//https://github.com/TanishSawant/FlutterFilePicker/blob/master/lib/src/file_picker_example.dart
class _CardEnviarDocWidgetState extends State<CardEnviarDocWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKeyCardEnviarDocWidget =
      GlobalKey<ScaffoldState>();
  var encodedFile;
  var decodedFile;
  ///////////////////////METODOS///////////////////////////////
  String _fileName = 'Selecione um documento...';
  // String _path = '...';
  bool _loadingPath;
  // FileType _pickingType;
  TextEditingController _description = new TextEditingController();
  // Future<Directory> _appDocDir;
  bool campoVazio;
  // var _arqBase64;

  @override
  void initState() {
    super.initState();
    //initPDF();
    setState(() {
      _loadingPath = false;
      campoVazio = false;
    });
  }

  Future<void> _selectFile() async {
    //selecionar o arq
    FilePickerResult selectFile =
        await FilePicker.platform.pickFiles(withData: true);
    //mostrar na tela
    PlatformFile file;
    if (selectFile != null) {
      file = selectFile.files.first;
      _fileName = file.name;
    } else {
      _fileName = 'Arquivo não encontrado!';
    }
    //add a uma lista de inteiros
    //   _file = selectFile.files.single;
    List<int> updatedContent = file.bytes;
    //realizar o encode
    encodedFile = base64.encode(updatedContent);
    setState(() {
      return _fileName;
    });
  }

  void sendFile() async {
    if (encodedFile != null) {
      String _arqBase64 = encodedFile;
      print("***ARQ***${_arqBase64.codeUnits}");

      Base64Model.Base64Model image64 = new Base64Model.Base64Model(
          request: new Base64Model.Request(lchrArquivoBase64: _arqBase64));
      if (_arqBase64 != null) {
        setState(() {
          EnviarDocBloc().postArquivos(
              context, _description.text, image64, _fileName, true);
        });
      } else {
        print("ERROR");
      }
    }
  }

////////////////////////////WIDGETS///////////////////////////////////
  @override
  Widget build(BuildContext context) {
    //
    final _titulo = TextFormField(
      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.red),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusColor: Colors.grey,
        labelText: "Título/Descrição ...",
        icon: Icon(Icons.text_fields_rounded, size: 30, color: Colors.grey),
        labelStyle: TextStyle(
            height: 2,
            fontSize: 16.0,
            color: Colors.grey,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold),
        filled: true,
        fillColor: Estilo().fillColor,
      ),
      controller: _description,
      cursorColor: Colors.grey,
      maxLines: 1,
      maxLength: 25,
    );

    final descricao = TextFormField(
      onTap: () => _selectFile(),
      maxLines: 2,
      showCursor: false,
      decoration: InputDecoration(
        prefixStyle: TextStyle(
            // color: Theme.of(context).backgroundColor,
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        hintText: _fileName, //descricao
        icon: Icon(
            // Icons.cloud_upload_sharp,
            Icons.upload_sharp,
            // Icons.upload_file,
            size: 30,
            color: Colors.grey),
        hintStyle: TextStyle(
          color: Colors.grey,
          //  fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
        filled: true,
        fillColor: Estilo().fillColor,
      ),
      // enabled: false,
    );

    final botaoEnviarDoc = new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      //align buttoms to the right
      children: <Widget>[
        Container(
          child: (_titulo.controller == null ||
                  _titulo.controller == "" && _description.text == null ||
                  _description.text == "")
              ? null
              : MaterialButton(
                  onPressed: () async {
                    campoVazio = !campoVazio;
                    if (_titulo.controller == null ||
                        _titulo.controller == "" && _description.text == null ||
                        _description.text == "") {
                    } else {
                      sendFile();
                      _description.clear();
                      _fileName = null;
                    }
                  },
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
        ),

        // Add more buttons here
      ],
    );

///////////////////////PRINCIPAL///////////////////////////////

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0,
        //
        centerTitle: true,
        title: Text(
          "Novo Documento",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            _titulo,
            SizedBox(height: 20.0),
            descricao,
            SizedBox(height: 8.0),
            botaoEnviarDoc,
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
