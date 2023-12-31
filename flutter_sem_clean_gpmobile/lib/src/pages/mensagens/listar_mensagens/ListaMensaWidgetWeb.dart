//https://github.com/iang12/flutter_url_launcher_example/blob/master/lib/main.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///*[referencia tabbar] https://medium.com/flutterworld/flutter-tabbar-and-tricks-4f36e06025a4
import 'package:gpmobile/src/pages/mensagens/listar_mensagens/ListaMensaLidas.dart';
import 'package:gpmobile/src/pages/mensagens/listar_mensagens/ListaMensaNovas.dart';
import 'package:gpmobile/src/pages/mensagens/model/StatusMensaModel.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ListarMensaWidgetWeb extends StatefulWidget {
  @override
  _ListarMensaWidgetWebState createState() => _ListarMensaWidgetWebState();
}

class _ListarMensaWidgetWebState extends State<ListarMensaWidgetWeb>
    with SingleTickerProviderStateMixin {
  //
  final GlobalKey<ScaffoldState> _scaffoldKeyListarMensaWidgetWeb =
      GlobalKey<ScaffoldState>();
  int indexPage;
  int count = 0;
  StatusModel objMensaEndDrawer;
  TabController _tabController;
  //
  List<Widget> tabBarList = [
    Tab(text: "NOVAS"),
    Tab(text: "LIDAS"),
  ];

  List<Widget> childrens = <Widget>[
    new ListaMensaNovas(),
    new ListaMensaLidas(),
  ];
  //
  @override
  void initState() {
    _tabController = TabController(
      initialIndex: 0,
      length: tabBarList.length,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeyListarMensaWidgetWeb,
      body: Container(
        decoration: AppGradients.gradient,
        child: ScreenTypeLayout(
          breakpoints: ScreenBreakpoints(desktop: 899, tablet: 730, watch: 279),
          mobile: OrientationLayoutBuilder(
              // portrait: (context) => _listarMensaWidgetMobile(),
              // landscape: (context) => _listarMensaWidgetMobile(),
              ),
          tablet: _buildWeb(),
          desktop: _buildWeb(),
        ),
      ),
    );
  }

  ///*WEB
  Widget _buildWeb() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        // title: Text("MENSAGENS"),
        centerTitle: true,
        elevation: 0.7,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: tabBarList,
        ),
      ),
      body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: childrens),
    );
  }
}
