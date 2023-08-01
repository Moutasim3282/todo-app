import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import './auth.dart';

import 'display_tasks.dart';
import 'theme/spaces.dart';

class HomePage extends StatelessWidget {
  final User? user = Auth().currentUser;

  HomePage({super.key});

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget userId() {
    return Text(user?.email ?? 'User Email');
  }

  final taskController = TextEditingController();
  final taskDescriptionController = TextEditingController();
  final CollectionReference tasks =
      FirebaseFirestore.instance.collection('Tasks');
  @override
  Widget build(BuildContext context) {
    void addTask() async {
      await tasks.add({
        'Description': taskDescriptionController.text,
        'Task': taskController.text,
        'timestamp' : DateFormat.yMMMMd().format(DateTime.now())
      });
      taskController.clear();
      taskDescriptionController.clear();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Daily Tasks'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          TextField(
            controller: taskController,
            decoration: const InputDecoration(
              hintText: 'Task ',
              hintStyle: TextStyle(
                color: Color.fromARGB(255, 155, 155, 155),
              ),
            ),
          ),
          TextField(
            controller: taskDescriptionController,
            decoration: const InputDecoration(
              hintText: 'Task Description',
              hintStyle: TextStyle(
                color: Color.fromARGB(255, 155, 155, 155),
              ),
            ),
          ),
          largeVerticalSizedBox,
          mediumVerticalSizedBox,
          ElevatedButton(
            onPressed: addTask,
            child: const Text('Add Task'),
          ),
          mediumVerticalSizedBox,
          Expanded(
              child: DisplayTasks(
            tasksCollectionReference: tasks,
          )),
          extraLargeVerticalSizedBox,
          extraLargeVerticalSizedBox,
          userId(),
          extraLargeVerticalSizedBox,
          ElevatedButton(
            onPressed: signOut,
            child: const Text('SignOut'),
          )
        ]),
      ),
    );
  }
}
