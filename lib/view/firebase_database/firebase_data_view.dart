// ignore_for_file: unused_import, unused_field, avoid_print, prefer_typing_uninitialized_variables

import 'dart:ffi';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_firestore/utils/utils.dart';
import 'package:firebase_firestore/view/auth/login_view.dart';
import 'package:firebase_firestore/widgets/roundbutton_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class DataViewFirebaseDatabase extends StatefulWidget {
  const DataViewFirebaseDatabase({super.key});

  @override
  State<DataViewFirebaseDatabase> createState() =>
      _DataViewFirebaseDatabaseState();
}

class _DataViewFirebaseDatabaseState extends State<DataViewFirebaseDatabase> {
  final searchController = TextEditingController();
  final titleController = TextEditingController();
  final descritionController = TextEditingController();
  final titleUpdateController = TextEditingController();
  final descUpdateController = TextEditingController();

  final auth = FirebaseAuth.instance;
  final databaseRef = FirebaseDatabase.instance.ref("PostData");

  File? _image;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance; // for image storing
  Future getGalleryImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("Image selection canceled");
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descritionController.dispose();
    searchController.dispose();
    titleUpdateController.dispose();
    descUpdateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.deepPurple.shade100,
        appBar: AppBar(
          backgroundColor: Colors.deepPurple.shade200,
          automaticallyImplyLeading: false,
          actions: [
            IconButton.filled(
                color: Colors.white,
                onPressed: () async {
                  await auth.signOut().then((value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginView()));
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                  });
                },
                icon: const Icon(Icons.logout_outlined))
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                    hintText: "Search here",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8))),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            Expanded(
                child: StreamBuilder(
                    stream: databaseRef.onValue,
                    builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                      List<dynamic> list = [];
                      if (!snapshot.hasData) {
                        const Center(child: CircularProgressIndicator());
                      } else {
                        Map<dynamic, dynamic> map =
                            snapshot.data!.snapshot.value as dynamic;

                        list.clear();
                        list = map.values.toList();
                      }
                      return ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final searchQuery =
                                searchController.text.toString();
                            final title = list[index]['title'].toString();
                            final description =
                                list[index]['description'].toString();

                            if (searchQuery.isEmpty ||
                                title.contains(searchQuery) ||
                                description.contains(searchQuery)) {
                              return ListTile(
                                title: Text(list[index]['title'].toString()),
                                subtitle:
                                    Text(list[index]['description'].toString()),
                                trailing: PopupMenuButton(
                                    icon: const Icon(Icons.more_vert),
                                    itemBuilder: (context) => [
                                          PopupMenuItem(
                                            value: 1,
                                            onTap: () {
                                              showDialogUpdateData(
                                                  title,
                                                  description,
                                                  list[index]['id']);
                                            },
                                            child: const ListTile(
                                              leading: Icon(Icons.edit),
                                              title: Text("EDIT"),
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 1,
                                            onTap: () {
                                              databaseRef
                                                  .child(list[index]['id'])
                                                  .remove()
                                                  .then((value) {
                                                Utils().toastMessage(
                                                    "Data has been deleted!");
                                              }).onError((error, stackTrace) {
                                                Utils().toastMessage(
                                                    error.toString());
                                              });
                                            },
                                            child: const ListTile(
                                              leading: Icon(Icons.delete),
                                              title: Text("DELETE"),
                                            ),
                                          )
                                        ]),
                              );
                            } else {
                              return Container();
                            }
                          });
                    })),
            //FirebaseAnimationList code which works same as above
            // Expanded(
            //   child: FirebaseAnimatedList(
            //       query: databaseRef,
            //       defaultChild: const Align(
            //         alignment: Alignment.center,
            //         child: Text(
            //           "Empty",
            //           style:
            //               TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
            //         ),
            //       ),
            //       itemBuilder: (context, snapshot, animation, index) {
            //         return ListTile(
            //           title: Text(snapshot.child('title').value.toString()),
            //           subtitle:
            //               Text(snapshot.child('description').value.toString()),
            //         );
            //       }),
            // ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialogueDataSaveMethod(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<dynamic> showDialogueDataSaveMethod(BuildContext context) {
    bool loading = false;
    var newUrl;
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text("Add Data"),
              content: SizedBox(
                height: 300,
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: "Title!",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: descritionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "What's in your mind!",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              getGalleryImage();
                            });
                          },
                          child: Container(
                            height: 50,
                            width: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade600),
                            child: _image != null
                                ? Image.file(_image!.absolute)
                                : const Center(
                                    child: Icon(
                                    Icons.upload,
                                    size: 32,
                                    color: Colors.white,
                                  )),
                          ),
                        ),
                        RoundButtonWidget(
                            title: "Upload",
                            width: 100,
                            loading: loading,
                            onTap: () async {
                              setState(() {
                                loading = true;
                              });
                              final imageId = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();
                              if (_image != null) {
                                firebase_storage.Reference ref =
                                    firebase_storage.FirebaseStorage.instance
                                        .ref('/images/$imageId');
                                firebase_storage.UploadTask uploadTask =
                                    ref.putFile(_image!.absolute);

                                Future.value(uploadTask).then((value) async {
                                  setState(() {
                                    loading = false;
                                  });
                                  newUrl = await ref.getDownloadURL();
                                  Utils().toastMessage("File uploaded!");

                                  ///below commented code is to fetch that image
                                  //   databaseRef.child(Image_id).set({
                                  //     'id': Image_id,
                                  //     'url': newUrl.toString()
                                  //   }).then((value) {
                                  //     setState(() {
                                  //       loading = false;
                                  //     });
                                  //     Utils().toastMessage("Uploaded");
                                  //   }).onError((error, stackTrace) {
                                  //     setState(() {
                                  //       loading = false;
                                  //     });
                                  //     Utils().toastMessage(error.toString());
                                  //   });
                                  // }).onError((error, stackTrace) {
                                  //   setState(() {
                                  //     loading = false;
                                  //   });
                                  //   Utils().toastMessage(error.toString());
                                }).onError((error, stackTrace) {
                                  Utils().toastMessage(error.toString());
                                  setState(() {
                                    loading = false;
                                  });
                                });
                              } else {
                                Utils().toastMessage("Images is not picked");
                              }
                            }),
                      ],
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel")),
                TextButton(
                    onPressed: () async {
                      final id =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      await databaseRef.child(id).set({
                        'id': id,
                        'title': titleController.text.toString(),
                        'description': descritionController.text.toString(),
                        'url': newUrl != null
                            ? newUrl.toString()
                            : newUrl = "no image uploaded!".toString()
                      }).then((value) {
                        Utils().toastMessage("Data Added");
                        Navigator.pop(context);
                      }).onError((error, stackTrace) {
                        Utils().toastMessage(error.toString());
                      });
                    },
                    child: const Text("Save")),
              ],
            ));
  }

  Future<dynamic> showDialogUpdateData(
      String title, String desc, String id) async {
    titleUpdateController.text = title;
    descUpdateController.text = desc;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Update Data"),
          content: SizedBox(
            height: 250,
            child: Column(
              children: [
                TextFormField(
                  controller: titleUpdateController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: descUpdateController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  databaseRef.child(id).update({
                    'title': titleUpdateController.text.toString(),
                    'description': descUpdateController.text.toString(),
                  }).then((value) {
                    Utils().toastMessage("Data Updated!");
                    Navigator.pop(context);
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                  });
                },
                child: const Text("Update")),
          ],
        );
      },
    );
  }
}
