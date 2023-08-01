import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/theme/spaces.dart';

class DisplayTasks extends StatefulWidget {
  final CollectionReference tasksCollectionReference;
  const DisplayTasks({super.key, required this.tasksCollectionReference});

  void deleteField(String docId) {
    tasksCollectionReference.doc().delete();
  }

  @override
  State<DisplayTasks> createState() => _DisplayTasksState();
}

class _DisplayTasksState extends State<DisplayTasks> {
  final Stream<QuerySnapshot> _tasksStream =
      FirebaseFirestore.instance.collection('Tasks').snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _tasksStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        bool isEmpty = snapshot.data!.docs.isEmpty;
        return isEmpty
            ? Column(children: [
                extraLargeVerticalSizedBox,
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text(
                    'No Tasks To Display',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(158, 158, 158, 1),
                    ),
                  ),
                  smallHorizontalSizedBox,
                  const Icon(Icons.access_time)
                ]),
                largeVerticalSizedBox,
                largeVerticalSizedBox,
                SizedBox(
                  height: 140,
                  width: 140,
                  child: Image.asset(
                    'assets/images/empty_tasks.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ])
            : ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic>? data =
                      document.data() as Map<String, dynamic>?;
                  if (data == null) {
                    return const SizedBox();
                  }

                  return Card(
                    color: Colors.white,
                    elevation: 10,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['timestamp'],
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: Color.fromARGB(255, 61, 58, 58)),
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['Task'] ?? '',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      ),
                                      extraSmallVerticalSizedBox,
                                      Text(
                                        data['Description'] ?? '',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () => widget
                                        .tasksCollectionReference
                                        .doc(document.id)
                                        .delete(),
                                    icon: const Icon(Icons.delete),
                                  ),
                                ]),
                            smallVerticalSizedBox
                          ]),
                    ),
                  );
                }).toList(),
              );
      },
    );
  }
}
