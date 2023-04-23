import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_parcial03/modelo/gifgiphy.dart';
import 'package:flutter_parcial03/temas/colores.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const Principal());
}

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
   int MenuActivo = 0;
  late Future<List<Gifgiphy>> _listadogiphy;

  Future<List<Gifgiphy>> _getgiphy() async {
    final response = await http.get(Uri.parse(
        "https://reqres.in/api/users?page=2"));

    List<Gifgiphy> gif = [];
    if (response.statusCode == 200) {
      String bodys = utf8.decode(response.bodyBytes);
      //print(bodys);

      final jsonData = jsonDecode(bodys);
      // print(jsonData["data"][0]["username"]);
      for (var item in jsonData["data"]) {
        gif.add(Gifgiphy(item["first_name"], item["avatar"]));
      }
      return gif;
    } else {
      throw Exception("Falla en conectarse");
    }
  }

  @override
  void initState() {
    super.initState();
    _listadogiphy = _getgiphy();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: bgColor,
             centerTitle: true,
            title:Container(
          width: 155,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: white.withOpacity(0.05)),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      MenuActivo = 0;
                    });
                  },
                  child: Container(
                    width: 75,
                    height: 28,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: MenuActivo == 0
                            ? white.withOpacity(0.3)
                            : Colors.transparent),
                    child: Center(
                      child: Text(
                        "Datos",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      MenuActivo = 1;
                    });
                  },
                  child: Container(
                    width: 75,
                    height: 28,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: MenuActivo == 1
                            ? white.withOpacity(0.3)
                            : Colors.transparent),
                    child: Center(
                      child: Text(
                        "Apellidos",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
          ),
          body: FutureBuilder(
            future: _listadogiphy,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // print(snapshot.data);
                return GridView.count(
                  crossAxisCount: 2,
                  children: _listadogiphys(snapshot.requireData),
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Text("Soy error");
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
    );
  }

  List<Widget> _listadogiphys(List<Gifgiphy> data) {
    List<Widget> gifs = [];
    for (var gif in data) {
      gifs.add(Card(
          child: Column(
        children: [
          Expanded(
            child: Image.network(
              gif.url,
              fit: BoxFit.fill,
            ),
          ),
          /*    Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(gif.nombre),
          ),*/
        ],
      )));
    }
    return gifs;
  }
}