// import 'package:flutter/material.dart';
// import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
// import 'package:gpmobile/src/pages/mensagens/listar_mensagens/ListaMensaBloc.dart';
// import 'package:gpmobile/src/pages/mensagens/vizualizar_mensagens/PageHeroWidget.dart';
// import 'package:gpmobile/src/pages/mensagens/model/StatusMensaModel.dart';
// import 'package:gpmobile/src/pages/quiz/add_quiz/AddQuizWidget.dart';
// import 'package:gpmobile/src/pages/quiz/listar_quiz/quiz_card_widget.dart';
// import 'package:gpmobile/src/pages/quiz/vizualizar_quiz/VizualizaQuizWidget.dart';
// import 'package:gpmobile/src/util/Estilo.dart';
// import 'package:responsive_builder/responsive_builder.dart';

// import 'home_controller.dart';

// class ListarQuizWidget extends StatefulWidget {
//   // List<QuizModel> listaFinal = [];
//   List<StatusModel> listaFinal = [];

//   ListarQuizWidget(List<StatusModel> listQuiz, {Key key}) : super(key: key) {
//     listaFinal = listQuiz;
//   }
//   // ListarQuizWidget({Key key}) : super(key: key);

//   @override
//   _ListarQuizWidgetState createState() => _ListarQuizWidgetState();
// }

// class _ListarQuizWidgetState extends State<ListarQuizWidget> {
//   List<Widget> gridDelegate = [];
//   final GlobalKey<ScaffoldState> _scaffoldKeyListarQuizWidget =
//       GlobalKey<ScaffoldState>();
//   int indexPage;
//   int count = 0;
//   String origemClick = "AddQuizWidget";
//   final controller = HomeController();
//   // var listaFinal = [
//   //   //lista retorno do back
//   //   'Questão com \n2 respostas',
//   //   'Questão com \n4 respostas',
//   //   'Questão com \n2 respostas',
//   //   'Questão com \n4 respostas',
//   //   'Questão com \n2 respostas',
//   //   'Questão com \n4 respostas',
//   //   'Questão com \n2 respostas',
//   //   'Questão com \n4 respostas',
//   //   'Questão com \n2 respostas',
//   //   'Questão com \n4 respostas',
//   // ];

//   @override
//   void initState() {
//     setState(() {});
//     super.initState();
//     //Msg Back
//     ListaMensaBloc().getBlocMensa(context, true).then((map1) {
//       List listaInvertida = map1.reversed.toList();
//       setState(() {
//         if (map1 != null) {
//           widget.listaFinal = listaInvertida;
//           ListaMensaBloc().getListaMensaLida(context, true).then((map1) {
//             if (map1 != null) {
//               for (String idMensagem in map1) {
//                 for (StatusModel objMensagBancoDataSul in widget.listaFinal) {
//                   if (objMensagBancoDataSul.data == idMensagem) {
//                     objMensagBancoDataSul.lido = true;
//                   }
//                 }
//               }
//             }
//           });
//         }
//       });
//     }); //ms
//   }

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       key: _scaffoldKeyListarQuizWidget,
//       body: Container(
//         decoration: AppGradients.gradient,
//         child: ScreenTypeLayout(
//           breakpoints: ScreenBreakpoints(desktop: 799, tablet: 650, watch: 250),
//           mobile: OrientationLayoutBuilder(
//             portrait: (context) => listarQuizWidgetMobile(context),
//             landscape: (context) => listarQuizWidgetMobile(context),
//           ),
//           tablet: listarQuizWidgetMobile(context),
//           desktop: listarQuizWidgetMobile(context),
//         ),
//       ),
//       endDrawer: ConditionalSwitch.single<String>(
//         context: context,
//         valueBuilder: (BuildContext context) => origemClick,
//         caseBuilders: {
//           'visualizaMensa': (BuildContext context) => VisualizaQuizWidget(
//                 heroType: HeroType(
//                   title: widget.listaFinal[indexPage].titulo,
//                   subTitle: "Home",
//                   data: "Home",
//                 ),
//               ),
//           'AddQuizWidget': (BuildContext context) => AddQuizWidget(),
//         },
// //fallbackBuilder, se o indexPage == null
//         fallbackBuilder: (BuildContext context) {
//           return Card(
//             semanticContainer: false,
//             color: Colors.white,
//             child: Row(
//               children: <Widget>[
//                 // const Icon(Icons.close, size: 60, color: Colors.red),
//                 IconButton(
//                   // color: Colors.red,
//                   onPressed: closeEndDrawer,
//                   icon: Icon(Icons.close, size: 50, color: Colors.red),
//                 ),
//                 const SizedBox(
//                   width: 10.0,
//                 ),
//                 const Text(
//                   'tela vazia!!!',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//       //bloqueia acesso ao Drawer no mobile and web
//       endDrawerEnableOpenDragGesture: false,
//     );
//   }

// //WIDGETS
//   Widget appBar(BuildContext context) {
//     return AppBar(
//       backgroundColor: Colors.transparent,
//       actions: <Widget>[
//         new IconButton(
//           icon: Icon(
//             Icons.post_add_rounded,
//             size: 30,
//           ),
//           splashColor: Colors.blue,
//           splashRadius: 20,
//           onPressed: () {
//             setState(() {
//               origemClick = "AddQuizWidget";
//               _openEndDrawer(9999);
//             });
//           },
//         )
//       ],
//      
//       toolbarHeight: 50.0,
//       elevation: 0,
//       centerTitle: true,
//       title: Text(
//         "Lista de Questoes Cadastradas",
//         style: TextStyle(
//           color: Colors.white,
//           // fontSize: 20,
//           fontWeight: FontWeight.w500,
//         ),
//         // textAlign: TextAlign.left,
//       ),
//     );
//   }

//   Widget listarQuizWidgetMobile(context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;

//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       appBar: appBar(context),
//       body:
//           // widget.listaFinal.isEmpty
//           //     ? Center(child: Text('Não há quiz no momento!'))
//           //     : Expanded(
//           //         child: GridView.count(
//           //           crossAxisSpacing: 16,
//           //           mainAxisSpacing: 16,
//           //           crossAxisCount: 2,
//           //           children: controller.quizzes
//           //               .map((e) => QuizCardWidget(
//           //                     title: e.titulo,
//           //                     completed: "${e.data} de ${e.data.length}",
//           //                     percent: 10,
//           //                   ))
//           //               .toList(),
//           //         ),
//           //       )

//           GridView.builder(
//         gridDelegate:
//             SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200),
//         itemCount: widget.listaFinal.length,
//         itemBuilder: (BuildContext context, int index) {
//           final objQuiz = widget.listaFinal[index];
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               width: width * 0.89, // 0.29 web
//               height: height * 0.35, // null
//               decoration: BoxDecoration(
//                 border: Border.fromBorderSide(
//                   BorderSide(
//                     color: AppColors.border,
//                   ),
//                 ),
//                 borderRadius: BorderRadius.circular(10),
//                 color: Estilo().fillColor,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       new Text('Quiz nº'),
//                       new Text('$index'),
//                     ],
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       setState(() {
//                         origemClick = "visualizaMensa";
//                         _openEndDrawer(index);
//                         print("mensagem abrir $index");
//                       });
//                     },
//                     child: Text(objQuiz.titulo),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   //metodos

//   // void _openDrawer() {
//   //   _scaffoldKeyListarQuizWidget.currentState.openEndDrawer();
//   // }

// //ENDDRAWER
//   Future<void> _openEndDrawer(i) async {
//     indexPage = i;
//     _scaffoldKeyListarQuizWidget.currentState.openEndDrawer();
//   }

//   void closeEndDrawer() {
//     setState(() {
//       count = count - 1;
//       Navigator.of(context).pop();
//     });
//   }
// }
