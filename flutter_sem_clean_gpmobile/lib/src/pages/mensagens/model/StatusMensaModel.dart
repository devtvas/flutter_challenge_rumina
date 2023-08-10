// import 'package:stacked/stacked.dart';

import 'package:stacked/stacked.dart';

class StatusModel extends BaseViewModel{
  int id;
  String data;
  String titulo;
  String mensagem;
  int sequencia;
  String matriculasView;
  bool lido;


  StatusModel({this.id, this.data,this.titulo, this.mensagem, this.sequencia, this.lido});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['data'] = this.data;
    data['titulo'] = this.titulo;
    data['mensagem'] = this.mensagem;
    data['sequencia'] = this.sequencia;
    data['matriculasView'] = this.matriculasView;
    data['lido'] = this.lido;
    return data;
  }

  StatusModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    data = json['data'];
    titulo = json['titulo'];
    mensagem = json['mensagem'];
    sequencia = json['sequencia'];
    matriculasView = json['matriculasView'];
    lido = json['lido'];
  }
////////////////////db Sqflite///////////////////////////////////
  Map<String, dynamic> toMap() {
    //Importante! conversao para salvar no banco
    final map = <String, dynamic>{
      "id": id,
      "data": data,
      "titulo": titulo,
      "mensagem": mensagem,
      "sequencia": sequencia,
      "matriculasView": matriculasView,
      "lido": lido,
    };
    return map;
  }

  StatusModel.fromMap(Map<String, dynamic> map) {
    //Importante! conversao para buscar do banco
    id = map['id'];
    data = map['data'];
    titulo = map['titulo'];
    mensagem = map['mensagem'];
    sequencia = map['sequencia'];
    matriculasView = map['matriculasView'];
    lido = map['lido'];
  }

  @override
  String toString() {
    return "StatusModel => (id: $id,data: $data, titulo: $titulo, mensagem: $mensagem, sequencia: $sequencia,matriculasView: $matriculasView, lido: $lido)";
  }

  void updateTile(String value) {
    titulo = value;
     notifyListeners();
  }
}
