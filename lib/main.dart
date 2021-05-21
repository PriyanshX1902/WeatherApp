import 'dart:html';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MaterialApp(
      title: 'Weather-app',
      home: Home(),
    ));

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  var temp;
  var humidity;
  var currently;
  var description;
  var wind;
  var city = "delhi";

  Future getWeather(var city) async {
    http.Response response = await http.get(Uri.parse(
        "http://api.openweathermap.org/data/2.5/weather?q=" +
            city.toString() +
            "&units=metric&appid=3aa9f0e85efd351d791bea6e1622b42c"));
    var results = jsonDecode(response.body);
    setState(() {
      this.temp = results['main']['temp'];
      this.description = results['weather'][0]['description'];
      this.currently = results['weather'][0]['main'];
      this.wind = results['wind']['speed'];
      this.humidity = results['main']['humidity'];
    });
  }

  @override
  void initState() {
    super.initState();
    this.getWeather(this.city);
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            color: Colors.red,
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 40.0, bottom: 10.0),
                    child: Text("Currently in " + city.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ))),
                Text(
                  temp != null ? temp.toString() + "\u00B0" : "Loading",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                        currently != null ? currently.toString() : "Loading",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        )))
              ],
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(20.0),
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                  title: Text("Temperature"),
                  trailing: Text(
                      temp != null ? temp.toString() + "\u00B0" : "Loading"),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.cloud),
                  title: Text("Weather"),
                  trailing: Text(
                      description != null ? description.toString() : "Loading"),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.sun),
                  title: Text("Humidity"),
                  trailing:
                      Text(humidity != null ? humidity.toString() : "Loading"),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.wind),
                  title: Text("Wind Speed"),
                  trailing: Text(
                      wind != null ? wind.toString() + "km/hr" : "Loading"),
                )
              ],
            ),
          )),
          Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                      onChanged: (text) {
                        this.city = text;
                      },
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: "Enter a City"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a city";
                        }
                      }),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        getWeather(city);
                      },
                      child: Text("Submit"),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
