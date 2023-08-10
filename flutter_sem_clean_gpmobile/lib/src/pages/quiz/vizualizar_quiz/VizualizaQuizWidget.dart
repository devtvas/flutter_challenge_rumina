// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:gpmobile/src/pages/mensagens/model/StatusMensaModel.dart';
// import 'package:gpmobile/src/pages/mensagens/vizualizar_mensagens/PageHeroWidget.dart';
// import 'package:gpmobile/src/util/Estilo.dart';
// import 'package:responsive_builder/responsive_builder.dart';
//
// class VisualizaQuizWidget extends StatefulWidget {
//   final StatusModel heroType;
//
//   const VisualizaQuizWidget({@required this.heroType}) : super();
//
//   @override
//   _VisualizaQuizWidgetState createState() => _VisualizaQuizWidgetState();
// }
//
// class _VisualizaQuizWidgetState extends State<VisualizaQuizWidget> {
//   StatusModel _heroType;
//   double _screenWidth;
//   double _screenHeight;
//
//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//       _heroType = widget.heroType;
//     });
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _screenWidth = MediaQuery.of(context).size.width;
//     _screenHeight = MediaQuery.of(context).size.height;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     //
//     final theme = Theme.of(context);
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       body: Container(
//         decoration: AppGradients.gradient,
//         child: ScreenTypeLayout(
//             breakpoints:
//                 ScreenBreakpoints(desktop: 899, tablet: 730, watch: 279),
//             mobile: OrientationLayoutBuilder(
//               portrait: (context) => visualizaQuizWidgetMobile(),
//               landscape: (context) => visualizaQuizWidgetMobile(),
//             ),
//             tablet: Center(
//                 child: Container(width: 730, child: visualizaQuizWidgetWeb())),
//             desktop: Center(
//                 child: Container(width: 730, child: visualizaQuizWidgetWeb()))),
//       ),
//     );
//   }
//
//   Widget visualizaQuizWidgetMobile() {
//     final theme = Theme.of(context);
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         leading: IconButton(
//           onPressed: () {
//             return Navigator.pop(context);
//           },
//           icon: Icon(Icons.close),
//         ),
//       ),
//       body: DefaultTextStyle(
//         style: theme.textTheme.headline4, //ajuste tamanho do titulo
//         textAlign: TextAlign.left, //ajuste justificado do titulo
//         child: SafeArea(
//           minimum: EdgeInsets.fromLTRB(0, 120, 0, 0),
//           child: LayoutBuilder(
//             builder:
//                 (BuildContext context, BoxConstraints viewportConstraints) {
//               return SingleChildScrollView(
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(
//                     minHeight: viewportConstraints.maxHeight,
//                   ),
//                   child: IntrinsicHeight(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         Container(
//                           // color: theme.backgroundColor, // Yellow
//                           height: height * 0.08,
//                           alignment: Alignment.center,
//                           child: Icon(
//                             _heroType.icon,
//                             color: theme.selectedRowColor.withOpacity(0.8),
//                             size: 50,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         Container(
//                           // color: theme.backgroundColor, // Yellow
//                           height: height * 0.09,
//                           alignment: Alignment.center,
//                           child: Column(
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Hero(
//                                     tag: 'text_hero',
//                                     child: Text(
//                                       '${_heroType.title}',
//                                       style: TextStyle(
//                                         fontSize: 24.0,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.blueGrey[300],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     '${_heroType.data}',
//                                     style: TextStyle(
//                                         fontSize: 12, color: Colors.white),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           // A flexible child that will grow to fit the viewport but
//                           // still be at least as big as necessary to fit its contents.
//                           child: Container(
//                             // color: theme.backgroundColor, // Red
//                             width: width * 0.9,
//                             height: height * 0.1,
//                             alignment: Alignment.center,
//                             child: ListView(
//                               children: [
//                                 Text(
//                                   '${_heroType.subTitle}',
//                                   textAlign: TextAlign.start,
//                                   style: TextStyle(
//                                       color: theme.selectedRowColor
//                                           .withOpacity(0.8),
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.normal),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   //
//   visualizaQuizWidgetTablet() {}
//   //
//   visualizaQuizWidgetWeb() {
//     final theme = Theme.of(context);
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       // appBar: AppBar(
//       //   backgroundColor: Colors.transparent,
//       //   leading: IconButton(
//       //     onPressed: () {
//       //       return Navigator.pop(context);
//       //     },
//       //     icon: Icon(Icons.close),
//       //   ),
//       // ),
//       body: Center(
//         child: Container(
//           width: 730,
//           child: DefaultTextStyle(
//             style: theme.textTheme.headline4, //ajuste tamanho do titulo
//             textAlign: TextAlign.left, //ajuste justificado do titulo
//             child: SafeArea(
//               minimum: EdgeInsets.fromLTRB(0, 120, 0, 0),
//               child: LayoutBuilder(
//                 builder:
//                     (BuildContext context, BoxConstraints viewportConstraints) {
//                   return SingleChildScrollView(
//                     child: ConstrainedBox(
//                       constraints: BoxConstraints(
//                         minHeight: viewportConstraints.maxHeight,
//                       ),
//                       child: IntrinsicHeight(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: <Widget>[
//                             Container(
//                               // color: theme.backgroundColor, // Yellow
//                               height: height * 0.08,
//                               alignment: Alignment.center,
//                               child: Icon(
//                                 _heroType.icon,
//                                 color: Colors.blueGrey[300],
//                                 size: 50,
//                               ),
//                             ),
//                             SizedBox(
//                               height: 20,
//                             ),
//                             Container(
//                               // color: theme.backgroundColor, // Yellow
//                               height: height * 0.09,
//                               alignment: Alignment.center,
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         '${_heroType.title}',
//                                         style: TextStyle(
//                                           fontSize: 24.0,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.blueGrey[300],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         '${_heroType.data}',
//                                         style: TextStyle(
//                                           fontSize: 12,
//                                           color: theme.selectedRowColor,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Expanded(
//                               // A flexible child that will grow to fit the viewport but
//                               // still be at least as big as necessary to fit its contents.
//                               child: Container(
//                                 // color: AppColors.white, // Red
//                                 width: width * 0.9,
//                                 height: height * 0.1,
//                                 alignment: Alignment.center,
//                                 decoration: BoxDecoration(
//                                   color: AppColors.white,
//                                   borderRadius: BorderRadius.only(
//                                     topRight: Radius.circular(10),
//                                     topLeft: Radius.circular(10),
//                                   ),
//                                 ),
//
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: ListView(
//                                     children: [
//                                       Text(
//                                         '${_heroType.subTitle}',
//                                         textAlign: TextAlign.start,
//                                         style: TextStyle(
//                                             color: AppColors.black,
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.normal),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
