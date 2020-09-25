import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class YourList extends StatefulWidget {
  @override
  _YourListState createState() => _YourListState();
}

class _YourListState extends State<YourList> {
  String todoTitle = "";

  createTodo() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyToDo").doc(todoTitle);
    //map
    Map<String, String> todo = {"todoTitle": todoTitle};
    documentReference.set(todo).whenComplete(() {
      print("$todoTitle created");
    });
  }

  deleteTodo(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyToDo").doc(todoTitle);
    documentReference.delete().whenComplete(() {
      print("$item deleted");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("MyToDo").snapshots(),
        builder: (context, snapshot) {
          print(snapshot.error.toString());
          if (snapshot.hasData) {
            // print(snapshot.error.toString());
            print("docs length ====${snapshot.data.docs.length}");
            return SafeArea(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot =
                      snapshot.data.documents[index];
                  return Dismissible(
                    onDismissed: (direction) {
                      deleteTodo(documentSnapshot.data()['todoTitle']);
                    },
                    key: Key(documentSnapshot.data()['todoTitle']),
                    child: Card(
                      elevation: 4,
                      margin: EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        title: Text(documentSnapshot.data()['todoTitle']),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            deleteTodo(documentSnapshot.data()['todoTitle']);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                title: Text("Add TodoList"),
                content: TextField(
                  onChanged: (String value) {
                    todoTitle = value;
                  },
                ),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      createTodo();
                      Navigator.of(context).pop();
                    },
                    child: Text("Add"),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
