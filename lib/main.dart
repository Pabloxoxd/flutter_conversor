import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import "dart:async";
import "dart:convert";

var request = Uri.parse(
    "https://api.hgbrasil.com/finance?format=json-cors&key=f5513b3f");

void main() async {
  runApp(MaterialApp(
      home: Home()
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return (json.decode(response.body));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  double doolar = 0;
  double euro = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: Text("Conversor de Moedas"),
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text("Carregando Informações",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25.0),
                  textAlign: TextAlign.center
              ),
            );
            default:
              if(snapshot.hasError){
                return Center(
                    child: Text("Erro ao carregar informações!!",
                    style: TextStyle(
                    color: Colors.red,
                    fontSize: 30.0),
                        textAlign: TextAlign.center
                    ),
                );
              } //if
              else {
                dollar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                dollar = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Icon(Icons.monetization_on,
                      size: 150.0, color: Colors.amber,)
                    ],
                  ),
                );
              } //else
           }
        } //builder
      )
    );
  }
}






