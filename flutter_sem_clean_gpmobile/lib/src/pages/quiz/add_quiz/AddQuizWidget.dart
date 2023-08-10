import 'package:flutter/material.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AddQuizWidget extends StatefulWidget {
  const AddQuizWidget({Key key}) : super(key: key);

  @override
  _AddQuizWidgetState createState() => _AddQuizWidgetState();
}

class _AddQuizWidgetState extends State<AddQuizWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: AppGradients.gradient,
        child: ScreenTypeLayout(
          breakpoints: ScreenBreakpoints(desktop: 799, tablet: 650, watch: 250),
          mobile: OrientationLayoutBuilder(
            portrait: (context) => addQuizWidgetMobile(context),
            landscape: (context) => addQuizWidgetMobile(context),
          ),
          tablet: addQuizWidgetWeb(context),
          desktop: addQuizWidgetWeb(context),
        ),
      ),
    );
  }

//WIDGETS
  Widget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: () {
          return Navigator.pop(context);
        },
        icon: Icon(Icons.close),
      ),
      toolbarHeight: 50.0,
      elevation: 0,
      centerTitle: true,
      title: Text(
        "Preencher Campos",
        style: TextStyle(
          color: Colors.white,
          // fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        // textAlign: TextAlign.left,
      ),
    );
  }

  Widget addQuizWidgetMobile(context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar(context),
        body: Container());
  }

  Widget addQuizWidgetWeb(context) {
    return Scaffold(body: Container());
  }
}
