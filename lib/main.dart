import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import "dart:async";
import "dart:convert";
import 'package:fluttertoast/fluttertoast.dart';

var request =
    Uri.parse("https://api.hgbrasil.com/finance?format=json-cors&key=f5513b3f");

void main() async {
  runApp(MaterialApp(
      home: Home(),
      theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
      )));
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
  double dolar = 0;
  double euro = 0;
  FToast? fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast!.init(context);
  }

  void clearFields() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("Limite de valor alcançado!!"),
        ],
      ),
    );

    fToast!.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 4),
    );

    // Custom Toast Position
    /*fToast.showToast(
        child: toast,
        toastDuration: Duration(seconds: 2),
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: child,
            top: 16.0,
            left: 16.0,
          );
        });*/
  }

  void _realChange(String text) {
    double real = double.parse(text);
    if (text.length > 7) {
      _showToast();
      clearFields();
    } else if (text.isEmpty) {
      clearFields();
    } else {
      dolarController.text = (real / dolar).toStringAsFixed(2);
      euroController.text = (real / euro).toStringAsFixed(2);
    }
  }

  void _dolarChange(String text) {
    double dolar = double.parse(text);
    if (text.length > 7) {
      _showToast();
      clearFields();
    } else if (text.isEmpty) {
      clearFields();
    } else {
      realController.text = (dolar * this.dolar).toStringAsFixed(2);
      euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    }
  }

  void _euroChange(String text) {
    double euro = double.parse(text);
    if (text.length > 7) {
      _showToast();
      clearFields();
    } else if (text.isEmpty) {
      clearFields();
    } else {
      realController.text = (euro * this.euro).toStringAsFixed(2);
      dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    }
  }

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
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: Text("Carregando Informações",
                        style: TextStyle(color: Colors.amber, fontSize: 25.0),
                        textAlign: TextAlign.center),
                  );
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Erro ao carregar informações!!",
                          style: TextStyle(color: Colors.red, fontSize: 30.0),
                          textAlign: TextAlign.center),
                    );
                  } //if
                  else {
                    dolar =
                        snapshot.data!["results"]["currencies"]["USD"]["buy"];
                    euro =
                        snapshot.data!["results"]["currencies"]["EUR"]["buy"];

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Icon(
                            Icons.monetization_on,
                            size: 150.0,
                            color: Colors.amber,
                          ),
                          buildTextField(
                              "Real", "R\$", realController, _realChange),
                          Divider(),
                          buildTextField(
                              "Dolar", "US\$", dolarController, _dolarChange),
                          Divider(),
                          buildTextField(
                              "Euro", "€\$", euroController, _euroChange),
                        ],
                      ),
                    );
                  } //else
              }
            } //builder
            ));
  }
}

Widget buildTextField(String label, String prefix,
    TextEditingController controller, Function(String)? change) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      enabledBorder: const OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.amber,
          width: 0.5,
        ),
      ),
      labelText: "$label",
      labelStyle: TextStyle(
        color: Colors.amber,
      ),
      border: OutlineInputBorder(),
      prefixText: "$prefix",
      prefixStyle: TextStyle(
        color: Colors.amber,
      ),
    ),
    style: TextStyle(
      color: Colors.amber,
      fontSize: 25.0,
    ),
    onChanged: change,
    keyboardType: TextInputType.number,
  );
}
