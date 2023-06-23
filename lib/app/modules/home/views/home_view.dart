import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'package:get/get.dart';
import 'package:whatsapp/app/data/db_handler.dart';
import 'package:whatsapp/app/models/notes_model.dart';

// import '../controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  DBHelper? dbHelper;
  Future<List<NotesModel>>? notesList;

  String? title;

  String? emailId;
  int? age;
  String? description;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    dbHelper = DBHelper();
    loadData();
    super.initState();
  }

  loadData() async {
    notesList = dbHelper!.getNotesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<NotesModel>>(
                future: notesList,
                builder: (context, AsyncSnapshot<List<NotesModel>> snapShot) {
                  if (!snapShot.hasData) {
                    return const Text('Loading');
                  } else {
                    return ListView.builder(
                        // reverse: true,
                        // shrinkWrap: true,
                        itemCount: snapShot.data?.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              dbHelper!.update(
                                NotesModel(
                                    id: snapShot.data![index].id!,
                                    title: "SqlLite",
                                    age: Random().nextInt(60) + 18,
                                    description: "I'm Good",
                                    email: 'admin@yahoo.com'),
                              );
                              setState(() {
                                notesList = dbHelper!.getNotesList();
                              });
                            },
                            child: Dismissible(
                              key: ValueKey<int>(snapShot.data![index].id!),
                              direction: DismissDirection.endToStart,
                              onDismissed: (DismissDirection direction) {
                                setState(() {
                                  dbHelper!.delete(snapShot.data![index].id!);
                                  notesList = dbHelper!.getNotesList();
                                  snapShot.data!.remove(snapShot.data![index]);
                                });
                              },
                              background: Container(
                                color: Colors.red,
                                child: const Icon(Icons.delete_forever_rounded),
                              ),
                              child: Card(
                                child: ListTile(
                                  title: Text(
                                      '${snapShot.data![index].title.toString()} email: ${snapShot.data![index].email.toString()}'),
                                  leading:
                                      Text(snapShot.data![index].id.toString()),
                                  subtitle: Text(snapShot
                                      .data![index].description
                                      .toString()),
                                  trailing: Text(
                                      snapShot.data![index].age.toString()),
                                ),
                              ),
                            ),
                          );
                        });
                  }
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // if (title!.isNotEmpty) {}
          Get.defaultDialog(
              title: 'Add New Task',
              content: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Text';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: 'Title',
                      ),
                      onChanged: (value) {
                        title = value;

                        // setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: 11,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Text';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Email id',
                      ),
                      onChanged: (value) {
                        emailId = value;

                        // setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: 11,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Text';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Age',
                      ),
                      onChanged: (value) {
                        age = int.parse(value);

                        // setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: 11,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Text';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: 'Description',
                      ),
                      onChanged: (value) {
                        description = value;

                        // setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: 11,
                    ),
                  ],
                ),
              ),
              textConfirm: 'Save',
              textCancel: 'Cancel',
              onCancel: () {},
              onConfirm: () {
                print(title);
                if (_formKey.currentState!.validate()) {
                  dbHelper!
                      .insert(NotesModel(
                    title: title!,
                    age: age!,
                    description: description!,
                    email: emailId!,
                  ))
                      .then((value) {
                    Get.back();

                    notesList = dbHelper!.getNotesList();
                    setState(() {});
                  }).onError((error, stackTrace) {
                    print(error.toString());
                  });
                }
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
