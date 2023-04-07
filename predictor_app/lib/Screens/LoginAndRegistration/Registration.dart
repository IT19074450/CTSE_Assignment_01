import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:predictor_app/Screens/LoginAndRegistration/Login.dart';
import 'package:predictor_app/models/UserModel.dart';
import '';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final firstNameEditingController = new TextEditingController();
  final lastNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();
  final ageEditingController = new TextEditingController();

  int jobValue = 0;
  int civilValue = 0;
  String jobStatus = "Employed";
  String civilStatus = "Married";

  @override
  Widget build(BuildContext context) {
    void signUp(String email, String password) async {
      postDetailsToFireStore() async {
        FirebaseFirestore firebaseFirestoreinstance =
            FirebaseFirestore.instance;

        User? user = _auth.currentUser;

        UserModel userModel = UserModel();

        userModel.email = user!.email;
        userModel.uid = user.uid;
        userModel.firstname = firstNameEditingController.text;
        userModel.lastname = lastNameEditingController.text;
        userModel.age = ageEditingController.text;
        userModel.jobStatus = jobStatus;
        userModel.civilStatus = civilStatus;

        await firebaseFirestoreinstance
            .collection('users')
            .doc(user.uid)
            .set(userModel.toMap());

        Fluttertoast.showToast(
            msg: "Account created Successfully !",
            backgroundColor: Colors.redAccent);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false);
      }

      if (_formKey.currentState!.validate()) {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFireStore()})
            .catchError((err) {
          Fluttertoast.showToast(
              msg: err.message, backgroundColor: Colors.redAccent);
        });
      }
    }

    //firstname field
    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{4,}$');

        if (value!.isEmpty) {
          return ("First name is required");
        }

        if (!regex.hasMatch(value)) {
          return ("Please Enter valid Name(Min. 4 Characters)");
        }

        return null;
      },
      keyboardType: TextInputType.name,
      onSaved: (value) {
        firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "First Name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    //lastname field
    final lastNameField = TextFormField(
      autofocus: false,
      controller: lastNameEditingController,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{4,}$');

        if (value!.isEmpty) {
          return ("Last name is required");
        }

        if (!regex.hasMatch(value)) {
          return ("Please Enter valid Name(Min. 4 Characters)");
        }

        return null;
      },
      keyboardType: TextInputType.name,
      onSaved: (value) {
        lastNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Last Name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    //email field
    final emaiField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Email is required");
        }

        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Enter a valid email");
        }

        return null;
      },
      onSaved: (value) {
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    //age field
    final ageField = TextFormField(
      autofocus: false,
      controller: ageEditingController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Age is required");
        }

        return null;
      },
      onSaved: (value) {
        ageEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.pin),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Age",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordEditingController,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');

          if (value!.isEmpty) {
            return ("Password is required");
          }

          if (!regex.hasMatch(value)) {
            return ("Please Enter valid Password(Min. 6 Characters)");
          }

          return null;
        },
        obscureText: true,
        onSaved: (value) {
          passwordEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.vpn_key),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Password",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));

    //confirmPassword field
    final confirmPasswordField = TextFormField(
        autofocus: false,
        controller: confirmPasswordEditingController,
        validator: (value) {
          if (confirmPasswordEditingController.text.length < 6 ||
              passwordEditingController.text != value) {
            return ("Password doesn't match");
          }

          return null;
        },
        obscureText: true,
        onSaved: (value) {
          confirmPasswordEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.vpn_key),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Confirm Password",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));

    //sign up button
    final signUpButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Colors.redAccent,
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(30, 15, 20, 20),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signUp(emailEditingController.text, passwordEditingController.text);
          },
          child: Text(
            'Sign Up',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ));

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.red,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
              child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 200,
                            child: Image.asset(
                              "assets/logo1.png",
                              fit: BoxFit.contain,
                            )),
                        firstNameField,
                        SizedBox(height: 20),
                        lastNameField,
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: const Text(
                                  'Employed',
                                  style: TextStyle(color: Colors.black),
                                ),
                                leading: Radio(
                                  value: 0,
                                  groupValue: jobValue,
                                  activeColor: Colors.redAccent,
                                  onChanged: (int? value) {
                                    setState(() {
                                      jobValue = 0;
                                      jobStatus = 'Employed';
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: const Text(
                                  'Unemployed',
                                  style: TextStyle(color: Colors.black),
                                ),
                                leading: Radio(
                                  value: 1,
                                  groupValue: jobValue,
                                  activeColor: Colors.redAccent,
                                  onChanged: (int? value) {
                                    setState(() {
                                      jobValue = 1;
                                      jobStatus = 'Unemployed';
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        ageField,
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: const Text(
                                  'Married',
                                  style: TextStyle(color: Colors.black),
                                ),
                                leading: Radio(
                                  value: 0,
                                  groupValue: civilValue,
                                  activeColor: Colors.redAccent,
                                  onChanged: (int? value) {
                                    setState(() {
                                      civilValue = 0;
                                      civilStatus = 'Married';
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: const Text(
                                  'Single',
                                  style: TextStyle(color: Colors.black),
                                ),
                                leading: Radio(
                                  value: 1,
                                  groupValue: civilValue,
                                  activeColor: Colors.redAccent,
                                  onChanged: (int? value) {
                                    setState(() {
                                      civilValue = 1;
                                      civilStatus = 'Single';
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        emaiField,
                        SizedBox(height: 20),
                        passwordField,
                        SizedBox(height: 20),
                        confirmPasswordField,
                        SizedBox(height: 20),
                        signUpButton,
                        SizedBox(height: 20)
                      ])),
            ),
          )),
        ));
    ;
  }
}
