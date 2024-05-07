import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/utils.dart';
import '../auth/login_view.dart';

class DataViewFirestoreDatabase extends StatefulWidget {
  const DataViewFirestoreDatabase({super.key});

  @override
  State<DataViewFirestoreDatabase> createState() =>
      _DataViewFirestoreDatabaseState();
}

class _DataViewFirestoreDatabaseState extends State<DataViewFirestoreDatabase> {
  final auth = FirebaseAuth.instance;
  final titleUpdateController = TextEditingController();
  final descUpdateController = TextEditingController();
  final firestorRef =
      FirebaseFirestore.instance.collection("UserData"); //for storing data
  final firestoreRetrieveRef = FirebaseFirestore.instance
      .collection("UserData")
      .snapshots(); //for retrieving data from firebase firestore to show

  CollectionReference updateDeleteRef =
      FirebaseFirestore.instance.collection("UserData"); //for update and delete
  // final updateDeleteRef = FirebaseFirestore.instance.collection("UserData");

  @override
  void dispose() {
    titleUpdateController.dispose();
    descUpdateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                icon: const Icon(Icons.logout_outlined)),
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: firestoreRetrieveRef,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData ||
                    snapshot.data == null ||
                    snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No data available"));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final title =
                        snapshot.data!.docs[index]['title'].toString();
                    final description =
                        snapshot.data!.docs[index]['description'].toString();
                    return ListTile(
                      onTap: () {
                        showDialogUpdateMethod(
                          context,
                          title,
                          description,
                          snapshot.data!.docs[index]['id'],
                          snapshot.data!.docs[index],
                        );
                      },
                      title:
                          Text(snapshot.data!.docs[index]['title'].toString()),
                      subtitle: Text(
                          snapshot.data!.docs[index]['description'].toString()),
                      trailing: IconButton(
                          onPressed: () {
                            updateDeleteRef
                                .doc(snapshot.data!.docs[index]['id'])
                                .delete();
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red.shade400,
                          )),
                    );
                  },
                );
              },
            )),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple.shade200,
          onPressed: () {
            showDialogueDataSaveMethod(context);
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<dynamic> showDialogUpdateMethod(
    BuildContext context,
    String title,
    String desc,
    String id,
    QueryDocumentSnapshot documentSnapshot,
  ) {
    titleUpdateController.text = title;
    descUpdateController.text = desc;
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Update Data"),
            content: SizedBox(
                height: 300,
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: TextFormField(
                          controller: titleUpdateController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: TextFormField(
                          controller: descUpdateController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        )),
                  ],
                )),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection("UserData")
                        .doc(documentSnapshot.id)
                        .update({
                      'title': titleUpdateController.text.toString(),
                      'description': descUpdateController.text.toString(),
                    }).then((value) {
                      Navigator.pop(context);
                      Utils().toastMessage("Updaed");
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    }); //for update and delete
                  },
                  child: const Text("Update"))
            ],
          );
        });
  }

  Future<dynamic> showDialogueDataSaveMethod(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text("Add Data"),
              content: SizedBox(
                height: 250,
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
                      controller: descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "What's in your mind!",
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
                    onPressed: () async {
                      final id =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      firestorRef.doc(id).set({
                        'id': id,
                        'title': titleController.text.toString(),
                        'description': descriptionController.text.toString()
                      }).then((value) {
                        Navigator.pop(context);
                        Utils().toastMessage("Data added");
                      }).onError((error, stackTrace) {
                        Utils().toastMessage(error.toString());
                      });
                    },
                    child: const Text("Save")),
              ],
            ));
  }
}
