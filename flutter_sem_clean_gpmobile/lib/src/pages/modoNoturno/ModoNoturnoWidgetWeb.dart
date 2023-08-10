// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import 'package:clay_containers_plus/widgets/clay_containers.dart';
// import 'package:dynamic_themes/dynamic_themes.dart';
// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:gpmobile/src/util/Estilo.dart';
//
// import '../../../main.dart';
//
// class ModoNoturnoWidgetWeb extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _AboutConfigState();
// }
//
// class _AboutConfigState extends State<ModoNoturnoWidgetWeb> {
//   int dropdownValue = 0;
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     dropdownValue = DynamicTheme.of(context).themeId;
//     return Scaffold(
//       backgroundColor: theme.backgroundColor,
//       appBar: AppBar(
//         elevation: 0.0,
//         title: Text(
//           'Modo Noturno',
//           style: TextStyle(
//             color: Estilo().gray,
//           ),
//         ),
//        
//         centerTitle: true,
//         backgroundColor: theme.backgroundColor,
//       ),
//       body: SizedBox.expand(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ClayContainer(
//               borderRadius: 10,
//               color: theme.backgroundColor,
//               child: IconButton(
//                 autofocus: true,
//                 // visualDensity: VisualDensity(horizontal: 1.0, vertical: 2.0),
//                 icon: dropdownValue == 0
//                     ? Icon(MaterialIcons.wb_sunny, color: Colors.amber)
//                     : Icon(Icons.brightness_3_sharp, color: Colors.grey, ),
//                 // ),
//                 iconSize: 100,
//                 // splashColor: Colors.black54,
//                 splashRadius: 0.1,
//                 // highlightColor: Colors.amber.withOpacity(.5),
//                 // enableFeedback: true,
//                 onPressed: () {
//                   DynamicTheme.of(context).setTheme(
//                     dropdownValue == 0
//                         ? AppThemes.DarkMode
//                         : AppThemes.LightMode,
//                   );
//                 },
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(top: 80),
//               child: RichText(
//                 text: TextSpan(
//                   text: 'Modo noturno: ',
//                   style: TextStyle(
//                     color: Estilo().gray,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 25,
//                   ),
//                   children: <TextSpan>[
//                     TextSpan(
//                       text: dropdownValue == 0 ? 'desabilitado' : 'habilitado',
//                       style: TextStyle(
//                         // color: Estilo().gray,
//                         color:
//                             dropdownValue == 0 ? Colors.amber : Estilo().gray,
//                         fontSize: 25,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
