// import 'dart:async';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:gradients/gradients.dart';

// import 'pages/login/LoginWidget.dart';

// class SplashWidget extends StatefulWidget {
//   @override
//   VideoState createState() => VideoState();
// }

// class VideoState extends State<SplashWidget>
//     with SingleTickerProviderStateMixin {
//   var _visible = true;

//   AnimationController animationController;
//   Animation<double> animation;

//   startTime() async {
//     var _duration = new Duration(seconds: 5);
//     return new Timer(_duration, navigationPage);
//   }

//   void navigationPage() {
//     // Navigator.of(context).pushNamed('/pages/login');
//     Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (context) => new LoginWidget()),
//         (Route<dynamic> route) => false);
//   }

//   @override
//   void initState() {
//     super.initState();

//     animationController = new AnimationController(
//         vsync: this, duration: new Duration(seconds: 10));
//     animation =
//         new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

//     animation.addListener(() => this.setState(() {}));
//     animationController.forward();

//     setState(() {
//       _visible = !_visible;
//     });
//     startTime();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     final grad = BoxDecoration(
//       gradient: LinearGradientPainter(
//         end: Alignment.topRight,
//         begin: Alignment.bottomLeft,
//         colors: <Color>[Color(0xFF2e2a4f), Color(0xFFC42224)],
//       ),
//     );
//     return Scaffold(
//       body: Container(
//         decoration: grad,
//         child: Stack(
//           fit: StackFit.expand,
//           children: <Widget>[
//             new Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 new Image.asset(
//                   // 'images/animated_loading.gif',
//                   'images/splash.png',
//                   width: width * 1,
//                   height: height * 1,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
