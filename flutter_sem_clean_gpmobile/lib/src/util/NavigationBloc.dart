import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:gpmobile/src/pages/configuracoes/ConfigWidget.dart';
import 'package:gpmobile/src/pages/aniversariantes/NiverWidget.dart';
import 'package:gpmobile/src/pages/documentos/listar/ListarDocWidget.dart';
import 'package:gpmobile/src/pages/ferias/FeriasWidget.dart';
import 'package:gpmobile/src/pages/mensagens/listar_mensagens/ListaMensaWidget.dart';
import 'package:gpmobile/src/pages/mensagens/model/StatusMensaModel.dart';
import 'package:gpmobile/src/pages/myDay/MyDayWidget.dart';
import 'package:gpmobile/src/pages/ponto/PontoWidget.dart';

import '../pages/bcoHoras/BcoHorasWidget.dart';
import '../pages/contraCheque/ContraChequeWidget.dart';

class NavigationBloc extends BlocBase {
  static navegar(context, String index, List<StatusModel> listMensag) {
    //adicione if(page == 0...) para cada tela!...
    if (index == "0") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FeriasWidget()),
      );
    }
    if (index == "1") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => new BcoHorasWidget()),
      );
    }

    if (index == "2") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PontoWidget(null, null)),
      );
    }

    if (index == "3") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => new ContraChequeWidget()),
      );
    }
    if (index == "4") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyDayWidget()),
      );
    }
    if (index == "5") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NiverWidget()),
      );
    }
    if (index == "6") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ListarMensaWidget()),
      );
    }
    if (index == "7") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ListarDocWidget()),
      );
    }
    if (index == "8") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ConfigWidget()),
      );
    }
  }
}
