import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
class apiCalling extends StatefulWidget {
  const apiCalling({super.key});

  @override
  State<apiCalling> createState() => _apiCallingState();
}

class _apiCallingState extends State<apiCalling> {
  List apiData1=[];
  late Future<List<Post>> futurePosts;


  Future<void>apiData()async{
    final responceData = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));

    if(responceData.statusCode==200){

      setState(() {
        apiData1=jsonDecode(responceData.body);

        log(" api data ${apiData1}");
      });
    }else{
      print("Error Api");
    }
  }

  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiData();
    futurePosts = fetchPosts();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Api Data"),centerTitle: true,),
      body: Container(
        child: Center(
          child: FutureBuilder<List<Post>>(
            future: futurePosts,
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting){
                return CircularProgressIndicator();
              }else if(snapshot.hasError ){
                return Text("Error ${snapshot.hasError}");
              }else if(!snapshot.hasData || snapshot.data!.isEmpty){
                return Text("No data found");
              }else{
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                    itemBuilder: (context,index){
                  return Column(
                    children: [
                      Text(" User Id ${snapshot.data![index].id}"),
                    ],
                  );
                });
              }

            },
          )
        ),
      ),
    );
  }
}
class apiResponce{
  String? userId;
  String? id;
  String? title;
  String? body;
  apiResponce({required this.userId,required this.id,required this.title,required this.body});
  apiResponce.fromjson(Map<String,dynamic> json){
    userId =json['userId'];
    id =json['id'];
    title = json['title'];
    body = json['body'];
   Map<String,dynamic> toJson(){
     Map<String,dynamic> data= new Map<String,dynamic>();
     data['userId']=this.userId;
     data['id']=this.id;
     data['title'] = this.title;
     data['body']=this.body;
     return data;
   }
  }

}
class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
class emp{
  String? name;
  String? age;
  String? work;
  emp({required this.name,required this.age,required this.work});
  factory emp.fromJson(Map<String,dynamic>json){
    return emp(
      name: json['name'],
      age: json['age'],
      work: json["work"]
    );
  }
}