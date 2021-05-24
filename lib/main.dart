import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Link shortener'),
      ),
      body: MyCustomForm(),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController inputUrlController = TextEditingController();

  postReq(String longUrl) async {
    var uri = Uri.https("api-ssl.bitly.com", "v4/shorten");

    var response = await http.post(
        uri,
        headers: {
          "Authorization": 'Bearer' + ' ' + String.fromEnvironment("BITLY_ACCESS_TOKEN"),
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "group_guid":String.fromEnvironment("BITLY_GROUP_ID"),
          "long_url":longUrl
        }),
    );

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
              controller: inputUrlController,
              decoration: InputDecoration(
              labelText: "Enter URL to shorten",
              enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              )
            ),
            validator: (value) {
              if (value == null || value.isEmpty ) {
                return "Field cannot be empty";
              }
          }
          ),
          ElevatedButton(
            onPressed: () {
              if(_formKey.currentState!.validate()) {
                /* Process here */
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Processing Data...")));
                var res = postReq(inputUrlController.text);
                showDialog(
                  context: context, 
                  builder: (context) {
                    return AlertDialog(
                      content: Text(res.toString()),
                    );
                });
              }
            }, 
            child: Text('Submit form')
          ),
        ],
      ),
    );
  }
}