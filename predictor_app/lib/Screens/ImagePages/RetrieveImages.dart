import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:predictor_app/Screens/Drawer/drawerMenu.dart';
import 'package:predictor_app/Screens/ImagePages/UploadImage.dart';

class RetreiveImages extends StatefulWidget {
  const RetreiveImages({Key? key}) : super(key: key);

  @override
  State<RetreiveImages> createState() => _RetreiveImagesState();
}

class _RetreiveImagesState extends State<RetreiveImages> {
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseStorage storage = FirebaseStorage.instance;
  late String reference;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
  }

  Future<List<Map<String, dynamic>>> loadImages() async {
    List<Map<String, dynamic>> files = [];

    final ListResult result = await storage.ref('images').list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
        "uploaded_by": fileMeta.customMetadata?['uploaded_by'] ?? 'Nobody',
        'timestamp': FieldValue.serverTimestamp() //added new
      });
    });

    return files;
  }

  Future<void> DeleteImage() async {
    await storage.ref(reference).delete();
    // Rebuild the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final AlertDialog dialog = AlertDialog(
      title: Text('Cofirm Deletion?'),
      content: Text("This Image will be deleted permenently."),
      actions: [
        Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(30),
            color: Colors.grey[200],
            child: MaterialButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            )),
        Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(30),
            color: Colors.redAccent,
            child: MaterialButton(
              onPressed: () {
                DeleteImage();
                Navigator.pop(context, "Delete");
                Fluttertoast.showToast(
                    msg: 'Successfuly Deleted !',
                    backgroundColor: Colors.green);
              },
              child: const Text(
                'Delete',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            )),
      ],
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => UploadImage(),
                fullscreenDialog: true,
              )).then((value) => setState(() {}));
        },
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: loadImages(),
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> image =
                            snapshot.data![index];

                        return Card(
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              Image.network(image['url']),
                              if (image['uploaded_by'] == user!.uid)
                                ButtonBar(
                                  alignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        //DeleteImage(image['path']
                                        reference = image['path'];
                                        showDialog<void>(
                                            context: context,
                                            builder: (context) => dialog);
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ],
                                )
                            ],
                          ),
                        );

                        ///
                      },
                    );
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
