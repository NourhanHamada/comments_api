import 'dart:convert';

import 'package:comment_api/comments_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({Key? key}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {

  Future<List<CommentsModel>> getData() async {
    List<CommentsModel> commentsModel = [];
    var url = Uri.parse('https://jsonplaceholder.typicode.com/comments');
    var response = await http.get(url);
    var responseBody = jsonDecode(response.body);
    for (var i in responseBody) {
      commentsModel.add(
          CommentsModel(postId: i["postId"],
              id: i["id"],
              name: i["name"],
              email: i["email"],
              body: i["body"]));
    }
    return commentsModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        centerTitle: true,
        backgroundColor: Colors.black26,
      ),
      body: Center(
        child: FutureBuilder(
          future: getData(),
          builder: (BuildContext context,
              AsyncSnapshot<dynamic> snapshot) {
            return (snapshot.hasData) ?
            ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                child: ListTile(
                  leading: Text('${snapshot.data[index].id}'),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${snapshot.data[index].name}',
                        style: const TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                      ),
                      Text('${snapshot.data[index].email}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text('${snapshot.data[index].body}'),
                ),
              );
            },) :
            const CircularProgressIndicator(
              color: Colors.purple,
            );
          },),
      ),
    );
  }
}
