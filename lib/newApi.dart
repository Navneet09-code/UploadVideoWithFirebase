import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class newApidata extends StatefulWidget {
  const newApidata({super.key});

  @override
  State<newApidata> createState() => _newApidataState();
}

class _newApidataState extends State<newApidata> {
  late Future<List<ApiData1>> apiDataList;
  late Future<List<UserApiData>> userdataList;

 Future<List<UserApiData>>userDataApi()async{
   final responseApiData = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
   if(responseApiData.statusCode==200){
     List userApiList = jsonDecode(responseApiData.body);
     print("Body = ${userApiList}");
     return userApiList.map((e) => UserApiData.fromJson(e)).toList();
   }else{
     throw Exception("No data found");
   }
 }

  Future<List<ApiData1>> intData() async{
    final responce = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if(responce.statusCode==200){
      List jsonDataList = jsonDecode(responce.body);
      return jsonDataList.map((e) => ApiData1.fromJson(e)).toList();

    }else{
      throw Exception("NO data flund");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiDataList = intData();
    userdataList= userDataApi();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Data"),centerTitle: true,),
      body: Container(
        child: FutureBuilder<List<UserApiData>>(
          future: userdataList,
          builder: (context,snapshot){

            if(snapshot.connectionState ==ConnectionState.waiting){
              return CircularProgressIndicator();
            } else if (snapshot.hasError){
              return Text("Error ${snapshot.hasError}");
            }else if(!snapshot.hasData || snapshot.data!.isEmpty){
              return Text("Data not Found");
            }else{
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                  itemBuilder: (context,index){
                return Container(
                  child: Column(
                    children: [
                      Text(" Id :- ${snapshot.data![index].id}"),
                      Text(" Name :- ${snapshot.data![index].name}"),
                      Text(" User Name :- ${snapshot.data![index].username}"),
                      Text(" Email :- ${snapshot.data![index].email}"),
                      Text(" Address :- ${snapshot.data![index].address!.street}"),
                      Text(" Zip Code :- ${snapshot.data![index].address!.zipcode}"),
                      Text(" lat :- ${snapshot.data![index].address!.geo!.lat}"),
                      Text(" lng :- ${snapshot.data![index].address!.geo!.lng }"),
                      Text(" Complay Name :- ${snapshot.data![index].compony!.name }"),
                      Text(" Skill :- ${snapshot.data![index].compony!.catchPhrase }"),
                      Text(" Web Site :- ${snapshot.data![index].website }"),

                    ],
                  ),
                );
              });
            }
          },
        ),
      ),
    );
  }
}
class ApiData1{
  final int? userId;
  final int? id;
  final String? title;
  final String? body;
  ApiData1({required this.userId,required this.id,required this.title,required this.body});
  factory ApiData1.fromJson(Map<String,dynamic>json){
    return ApiData1(userId: json['userId'], id: json["id"], title: json["title"], body: json["body"]);
  }
}
class UserApiData{
  final int? id;
  final String? name;
  final String? username;
  final String? email;
  final Address? address;
  final String? phone;
  final String? website;
  final Compony? compony;
  UserApiData({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.address,
    required this.phone,
    required this.website,
    required this.compony});
  factory UserApiData.fromJson(Map<String,dynamic>json){
      return UserApiData(
          id: json["id"],
          name: json["name"],
          username: json["username"],
          email: json["email"],
          address:Address.fromJson(json["address"]),
          phone: json["phone"],
          website: json["website"],
          compony: Compony.fromJson(json["company"]));
  }

}
class Address{
  final String? street;
  final String? suite;
  final String? city;
  final String? zipcode;
  final Geo? geo;
   Address({required this.street,required this.suite,required this.city,required this.zipcode,required this.geo});
   factory Address.fromJson(Map<String,dynamic>json){
     return Address(
         street: json["street"],
         suite: json["suite"],
         city: json["city"],
         zipcode: json["zipcode"],
         geo:Geo.fromJson(json["geo"]));
   }
}
class Geo{
  final String? lat;
  final String? lng;
  Geo({required this.lat,required this.lng});
  factory Geo.fromJson(Map<String,dynamic>json){
    return Geo(lat: json["lat"], lng: json["lng"]);
  }
}
class Compony{
  final String? name;
  final String? catchPhrase;
  final String? bs;
  Compony({required this.name,required this.catchPhrase,required this.bs});
  factory Compony.fromJson(Map<String,dynamic>json){
    return Compony(name: json["name"], catchPhrase: json["catchPhrase"], bs: json["bs"]);
  }
}
