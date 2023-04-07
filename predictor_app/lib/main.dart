import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:predictor_app/Database/problems_SetDB.dart';
import 'package:predictor_app/Screens/Drawer/drawerMenu.dart';
import 'package:predictor_app/Screens/LoginAndRegistration/Login.dart';
import 'package:page_transition/page_transition.dart';
import 'Database/regularProblemDB.dart';
import 'Screens/BottomNavigation/BottomNavigation.dart';
import 'Screens/Drawer/drawerMenu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  // runApp(const ViewRegularProblem());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const MyHomePage(title: 'Predictor'),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(children: [
        Image.asset(
          'assets/logo.png',
          height: 195.0,
        ),
        const Text(
          'De Predictor',
          style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(134, 255, 0, 0),
              fontFamily: 'Abril Fatface'),
        )
      ]),
      backgroundColor: const Color.fromARGB(255, 36, 35, 35),
      // nextScreen: const LoginScreen(),
      nextScreen: const LoginScreen(),
      splashIconSize: 250,
      duration: 5000,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.leftToRightWithFade,
      animationDuration: const Duration(seconds:5),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   late DatabaseRegularProblem dbr;
//   late DatabaseProblemSet dbp;
//   List docs = [];

//   regularProblemInitialize() {
//     dbr = DatabaseRegularProblem();
//     dbr.regularProblemIntialized();
//   }

//   problemSetInitialize() {
//     dbp = DatabaseProblemSet();
//     dbp.problemSetIntialized();
//   }

//   @override
//   void initState() {
//     super.initState();
//     regularProblemInitialize();
//     problemSetInitialize();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: NavBar(),
//       backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),

//       floatingActionButton:
//           Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
//         FloatingActionButton(
//           onPressed: () {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => ViewRegularProblem(dbr: dbr)));
//           },
//           tooltip: 'Increment',
//           child: const Icon(Icons.add),
//         ),
//         FloatingActionButton(
//           onPressed: () {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => ViewProblemSet(dbp: dbp)));
//           },
//           tooltip: 'Increment',
//           child: const Icon(Icons.add),
//         ),
//       ]), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
