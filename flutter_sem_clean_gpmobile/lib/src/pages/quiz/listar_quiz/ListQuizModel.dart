// import 'package:http/http.dart';

class QuizModel {
  int id;
  String data;
  String titulo;
  String mensagem;
  bool lido;

  QuizModel({this.id, this.data,this.titulo, this.mensagem, this.lido});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['data'] = this.data;
    data['titulo'] = this.titulo;
    data['mensagem'] = this.mensagem;
    data['lido'] = this.lido;
    return data;
  }

  QuizModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    data = json['data'];
    titulo = json['titulo'];
    mensagem = json['mensagem'];
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
      "lido": lido,
    };
    return map;
  }

  QuizModel.fromMap(Map<String, dynamic> map) {
    //Importante! conversao para buscar do banco
    id = map['id'];
    data = map['data'];
    titulo = map['titulo'];
    mensagem = map['mensagem'];
    lido = map['lido'];
  }

  @override
  String toString() {
    return "QuizModel => (id: $id,data: $data, titulo: $titulo, mensagem: $mensagem, lido: $lido)";
  }
}
