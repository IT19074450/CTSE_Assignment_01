import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:predictor_app/models/UserModel.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key? key, required this.userDetails}) : super(key: key);
  UserModel userDetails;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final firstNameEditingController = new TextEditingController();
  final lastNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final ageEditingController = new TextEditingController();

  int jobValue = 0;
  int civilValue = 0;
  String jobStatus = "Employed";
  String civilStatus = "Married";

  @override
  void initState() {
    super.initState();
    firstNameEditingController.text = widget.userDetails.firstname!;
    lastNameEditingController.text = widget.userDetails.lastname!;
    emailEditingController.text = widget.userDetails.email!;
    ageEditingController.text = widget.userDetails.age!;
    if (widget.userDetails.jobStatus! != 'Employed') {
      jobValue = 1;
      jobStatus = 'Unemployed';
    }

    if (widget.userDetails.civilStatus! != 'Married') {
      civilValue = 1;
      civilStatus = 'Single';
    }
  }

  @override
  Widget build(BuildContext context) {
    void updateProfile() async {
      FirebaseFirestore firebaseFirestoreinstance = FirebaseFirestore.instance;

      User? user = _auth.currentUser;

      try {
        await firebaseFirestoreinstance
            .collection("users")
            .doc(user!.uid)
            .update({
          'firstname': firstNameEditingController.text,
          'lastname': lastNameEditingController.text,
          'age': ageEditingController.text,
          'jobStatus': jobStatus,
          'civilStatus': civilStatus
        }).then((value) {
          Navigator.of(context).pop();
          setState(() {});
          Fluttertoast.showToast(
              msg: 'Successfuly Updated !', backgroundColor: Colors.redAccent);
        });
      } catch (e) {
        Fluttertoast.showToast(
            msg: e.toString(), backgroundColor: Colors.redAccent);
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

    //sign up button
    final UpdateButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Colors.redAccent,
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(30, 15, 20, 20),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            updateProfile();
          },
          child: Text(
            'Update',
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
                              "assets/question.png",
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
                        UpdateButton,
                        SizedBox(height: 20)
                      ])),
            ),
          )),
        ));
    ;
  }
}
