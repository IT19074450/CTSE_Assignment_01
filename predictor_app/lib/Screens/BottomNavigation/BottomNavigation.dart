import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:predictor_app/Database/feedbackDB.dart';
import 'package:predictor_app/Database/regularProblemDB.dart';
import 'package:predictor_app/Screens/Drawer/drawerMenu.dart';
import 'package:predictor_app/Screens/ImagePages/RetrieveImages.dart';
import 'package:predictor_app/Screens/LoginAndRegistration/Login.dart';
import 'package:predictor_app/Screens/Profile/Profile.dart';
import 'package:predictor_app/models/UserModel.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 3;
  late DatabaseRegularProblem db =
      DatabaseRegularProblem().regularProblemIntialized();
  late DatabaseFeedBack dbf = DatabaseFeedBack().feedBackIntialized();
  var appbarNames = ['Home', 'Problems', 'Motivation', 'Profile'];
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? loggedInUser = UserModel();
  FirebaseFirestore firebaseFirestoreinstance = FirebaseFirestore.instance;

  @override
  void initState() {
    
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() => db = DatabaseRegularProblem().regularProblemIntialized());
      // setState(() => dbf = DatabaseFeedBack().feedBackIntialized());
    });
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Fluttertoast.showToast(
        msg: "Successfully Logout !", backgroundColor: Colors.redAccent);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  final screens = [
    
    const RetreiveImages(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            // Remove padding
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                    "${loggedInUser!.firstname} ${loggedInUser!.lastname}"),
                accountEmail: Text("${loggedInUser!.email}"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/profile.jpg',
                      fit: BoxFit.cover,
                      width: 90,
                      height: 90,
                    ),
                  ),
                ),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          'https://images.unsplash.com/photo-1541450805268-4822a3a774ca?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80.jpg')),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text('Predictor'),
                onTap: () => setState(() => _currentIndex = 0),
              ),
              ListTile(
                leading: const Icon(Icons.sync_problem_outlined),
                title: const Text('Regular Problems'),
                onTap: () => setState(() => _currentIndex = 1),
              ),
              ListTile(
                leading: const Icon(Icons.psychology_outlined),
                title: const Text('Motivation'),
                onTap: () => setState(() => _currentIndex = 2),
              ),
             
              ListTile(
                leading: const Icon(Icons.person_outlined),
                title: const Text('Profile'),
                onTap: () => setState(() => _currentIndex = 3),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: const Text('Logout'),
                onTap: () => logout(context),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text("${appbarNames[_currentIndex]}"),
          centerTitle: true,
          backgroundColor: Colors.redAccent,
          elevation: 0.0,
        ),
        body: screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(.6),
          selectedFontSize: 14,
          onTap: (value) {
            // Respond to item press.
            setState(() => _currentIndex = value);
          },
          items: const [
            BottomNavigationBarItem(
              label: 'Prediction',
              icon: Icon(Icons.home),
              backgroundColor: Colors.red,
            ),
            BottomNavigationBarItem(
              label: 'Problems',
              icon: Icon(Icons.sync_problem_outlined),
              backgroundColor: Colors.red,
            ),
            BottomNavigationBarItem(
              label: 'Motivation',
              icon: Icon(Icons.psychology),
              backgroundColor: Colors.red,
            ),
            BottomNavigationBarItem(
              label: 'Profile',
              icon: Icon(Icons.assignment_ind),
              backgroundColor: Colors.red,
            ),
          ],
        ));
  }
}
