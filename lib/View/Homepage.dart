import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_kepper/Controller/Themecontroller.dart';
import 'package:firebase_kepper/Mixinfun.dart';
import 'package:firebase_kepper/View/Bookmark.dart';
import 'package:firebase_kepper/View/Profilepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Controller/BookmarkProvider.dart';
import '../Controller/FirestoreHelper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with GlobalFun {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkProvider = Provider.of<BookmarkProvider>(context);
    final themeController = Provider.of<ThemeController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text1('TODO List', 15, FontWeight.bold),
        actions: [
          IconButton(
              onPressed: () => themeController.toggleTheme(),
              icon: Icon(themeController.isDarkTheme
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined)),
          IconButton(onPressed: () => showbookdialog(), icon: Icon(Icons.add)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ));
              },
              icon: Icon(Icons.person)),
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => BookmarkPage()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: FirestoreHelper.firestoreHelper.fetchAllBooks(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No books available"));
            }

            // Extract the data only after ensuring it is available
            List<QueryDocumentSnapshot<Map<String, dynamic>>> allBooks =
                snapshot.data!.docs;

            return ListView.builder(
              itemCount: allBooks.length,
              itemBuilder: (context, i) {
                return ListTile(
                  title: Text("${allBooks[i].data()['Bookname']}"),
                  subtitle: Text("${allBooks[i].data()["Author'sname"]}"),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showUpdateDialog(
                            context,
                            allBooks[i].id,
                            allBooks[i].data()['Bookname'],
                            allBooks[i].data()["Author'sname"],
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          FirestoreHelper.firestoreHelper
                              .deleteBook(docId: allBooks[i].id)
                              .then((_) {
                            FirestoreHelper.firestoreHelper.deleteBookMarks(
                              bookname: allBooks[i].data()['Bookname'],
                              authorname: allBooks[i].data()["Author'sname"],
                            );
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Error deleting book: $error")),
                            );
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          bookmarkProvider.isBookmarked(allBooks[i].id)?Icons.favorite:Icons.favorite_border,
                          color: bookmarkProvider.isBookmarked(allBooks[i].id)
                              ? Colors.red
                              : null,
                        ),
                        onPressed: () {
                          bookmarkProvider.toggleBookmark(
                            allBooks[i].id,
                            allBooks[i].data()['Bookname'],
                            allBooks[i].data()["Author'sname"],
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void showbookdialog() {
    final TextEditingController bookController = TextEditingController();
    final TextEditingController authorController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Book"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: bookController,
                decoration: InputDecoration(labelText: 'Book Name'),
              ),
              TextField(
                controller: authorController,
                decoration: InputDecoration(labelText: 'Author Name'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String bookname = bookController.text.trim();
                String authorname = authorController.text.trim();

                if (bookname.isNotEmpty && authorname.isNotEmpty) {
                  await FirestoreHelper.firestoreHelper
                      .addBooks(bookname: bookname, authorname: authorname);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Book added successfully!")));
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text("Please enter both book and author names.")));
                }
              },
              child: Text("Add Book"),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateDialog(BuildContext context, String docId, String oldBookname,
      String oldAuthorname) {
    final TextEditingController bookController =
        TextEditingController(text: oldBookname);
    final TextEditingController authorController =
        TextEditingController(text: oldAuthorname);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update Book"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: bookController,
                decoration: InputDecoration(labelText: 'Book Name'),
              ),
              TextField(
                controller: authorController,
                decoration: InputDecoration(labelText: 'Author Name'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                String newBookname = bookController.text.trim();
                String newAuthorname = authorController.text.trim();

                if (newBookname.isNotEmpty && newAuthorname.isNotEmpty) {
                  FirestoreHelper.firestoreHelper
                      .updateBook(
                    bookname: newBookname,
                    authorname: newAuthorname,
                    docId: docId,
                  )
                      .then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text("Book and bookmarks updated successfully!")));
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text("Please enter both book and author names.")));
                }
              },
              child: Text("Save changes"),
            ),
          ],
        );
      },
    );
  }
}
