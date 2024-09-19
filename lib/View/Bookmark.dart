import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_kepper/Mixinfun.dart';
import 'package:flutter/material.dart';

import '../Controller/FirestoreHelper.dart';

class BookmarkPage extends StatefulWidget {
  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> with GlobalFun {


  @override
  void initState() {
    super.initState();
    _fetchFavoriteTodos();
  }

  Future<void> _fetchFavoriteTodos() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text1('Bookmarked TODOs', 15, FontWeight.bold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirestoreHelper.firestoreHelper.fetchAllBookMarks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No bookmarks available"));
            } else {
              List<QueryDocumentSnapshot<Map<String, dynamic>>> allBookmarks = snapshot.data!.docs;

              return ListView.builder(
                itemCount: allBookmarks.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    title: Text(allBookmarks[i].data()['Bookname']),
                    subtitle: Text(allBookmarks[i].data()["Author'sname"]),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
     // body:  ListView.builder(
     //    itemCount: 5,
     //    itemBuilder: (context, index) {
     //      return ListTile(
     //        title: Text1('', 14, FontWeight.normal),
     //        subtitle: Text1('', 12, FontWeight.normal),
     //      );
     //    },
     //  ),
