import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './Api.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({Key? key}) : super(key: key);

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  UploadTask? task;
  File? file;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Future uploadFile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'images/$fileName';

    task = FirebaseApi.uploadFile(destination, file!, user!.uid);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
  }

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("Upload Image"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ButtonWidget(
                //   text: 'Select File',
                //   icon: Icons.attach_file,
                //   onClicked: selectFile,
                // ),
                if (file != null)
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(file!)),
                if (file != null) SizedBox(height: 10.0),
                Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.redAccent,
                    child: MaterialButton(
                      padding: EdgeInsets.fromLTRB(30, 15, 20, 20),
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: () {
                        selectFile();
                      },
                      child: const Text(
                        'Select File',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                SizedBox(height: 8),
                Text(
                  fileName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 48),
                // ButtonWidget(
                //   text: 'Upload File',
                //   icon: Icons.cloud_upload_outlined,
                //   onClicked: uploadFile,
                // ),
                Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.redAccent,
                    shadowColor: Colors.blueGrey,
                    child: MaterialButton(
                      padding: EdgeInsets.fromLTRB(30, 15, 20, 20),
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: () {
                        uploadFile();
                        Fluttertoast.showToast(
                            msg: 'Successfuly Uploaded !',
                            backgroundColor: Colors.green);
                      },
                      child: const Text(
                        'Upload File',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                SizedBox(height: 20),
                task != null ? buildUploadStatus(task!) : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            if (double.parse(percentage) == 100.00) {
              Navigator.of(context).pop();
              setState(() {});
            }

            return Text(
              '$percentage %',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );
}
