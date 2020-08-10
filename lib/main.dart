import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  bool textFieldStatus = true;

  Future<String> _getData() async {
    http.Response response;

    if (_search == null || _search.isEmpty) {
      return null;
    } else {
      response = await http.get(
          "http://www.transparencia.gov.br/api-de-dados/auxilio-emergencial-por-cpf-ou-nis?codigoBeneficiario=$_search&pagina=1");
      //print(response.body);
      return response.body;
    }
  }

  // sadasd96250984291asdasd

  // @override
  // void initState() {
  //   super.initState();

  //   _getData().then((text) {

  //     print(json.decode(text)[0]);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Transparência - Auxílio Emergencial"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: Text(
                "Consulte por CPF ou NIS e verifique se a pessoa se cadastrou para receber o auxílio emergencial devido ao COVID-19",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            //Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                enabled: textFieldStatus,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Digite aqui o CPF/NIS  Ex: 12345678900",
                    labelStyle:
                        TextStyle(color: Colors.black54, fontSize: 14.0),
                    border: OutlineInputBorder()),
                style: TextStyle(color: Colors.black, fontSize: 18.0),
                textAlign: TextAlign.center,
                onSubmitted: (text) {
                  setState(() {
                    _search = text;
                  });
                },
              ),
            ),
            FutureBuilder(
              future: _getData(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0),
                          child: Text("Buscando...Aguarde"),
                        ),
                        Container(
                            padding:
                                EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                            child: CupertinoActivityIndicator(
                              radius: 25.0,
                            )

                            /*CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blueAccent),
                            strokeWidth: 2.0,
                          ),*/
                            ),
                        Text(
                          "Esse processo pode demorar alguns minutos",
                          style: TextStyle(color: Colors.black38),
                        )
                      ],
                    ); // tela de carregando dados

                  default:
                    textFieldStatus = true;
                    if (_search == null || _search.isEmpty) {
                      return Column(
                        children: <Widget>[
                          //Icon(),
                          Container(
                            alignment: Alignment.topCenter,
                            height: 200.0,
                            width: 400.0,
                            child: Card(
                              elevation: 20.0,
                              color: Colors.blueAccent,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Atenção: Este APP faz uma busca no banco de dados do portal da transparência do governo federal. O Ministério da Transparência e Controladoria-Geral da União poderão alterar as APIs disponibilizadas sem prévio aviso. O que pode causar instabiliade no aplicativo.",
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            padding:
                                EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 10.0),
                          ),
                        ],
                      );
                    } else {
                      if (snapshot.hasError) {
                        return Container(
                          child: Text("Error"),
                        );
                      } else {
                        final decoded = json.decode(snapshot.data);

                        if (decoded.toString() == '[]')
                          return Container(
                            child: Container(
                                alignment: Alignment.topCenter,
                                height: 200.0,
                                width: 400.0,
                                child: Card(
                                  elevation: 20.0,
                                  color: Colors.blueAccent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "NÃO FOI ENCONTRATO NENHUM CADASTRO COM ESSE NÚMERO DE CPF/NIS !!",
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )),
                          );
                        else {
                          String _nome =
                              decoded[0]["beneficiario"]["nome"].toString();
                          String _cidade =
                              decoded[0]["municipio"]["nomeIBGE"].toString();
                          String _estado =
                              decoded[0]["municipio"]["uf"]["nome"].toString();
                          String _valor = decoded[0]["valor"].toString();
                          return Container(
                              child: Card(
                            elevation: 20.0,
                            color: Colors.blueAccent,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Text(
                                      "Beneficiário encontrado!",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Nome: $_nome",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(color: Colors.white)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Cidade: $_cidade-$_estado",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(color: Colors.white)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Valor do Benefício: R\$$_valor",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    )
                                  ],
                                )),
                          ));
                        }
                      }
                    }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
