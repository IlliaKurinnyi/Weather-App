import 'package:flutter/material.dart';
import 'package:fluttercctracker/widgets/Weather.dart';
import 'package:fluttercctracker/widgets/WeatherItem.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttercctracker/models/WeatherData.dart';
import 'package:fluttercctracker/models/ForecastData.dart';



void main() => runApp(new OpenWeatherWidget());


class OpenWeatherWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new OpenWeatherWidgetState();
  }
}
class WeatherApp extends StatelessWidget {
  @override Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          backgroundColor: Colors.blueGrey,
          appBar: AppBar(
            title: Text('Flutter Weather App'),
          ),
          body: Center(
              child: OpenWeatherWidget()
          )
      ),
    );
  }
}


class OpenWeatherWidgetState extends State<OpenWeatherWidget> {
  bool isLoading = false;
  WeatherData weatherData;
  ForecastData forecastData;

  @override
  void initState() {
    super.initState();

    loadWeather();
  }

  @override
  Widget build(BuildContext context) {
    return WeatherCont();
  }

  Column WeatherCont() {
    return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: weatherData != null ? Weather(weather: weatherData) : Container(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: isLoading ? CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: new AlwaysStoppedAnimation(Colors.white),
                          ) : IconButton(
                            icon: new Icon(Icons.refresh),
                            tooltip: 'Refresh',
                            onPressed: loadWeather,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 200.0,
                        child: forecastData != null ? ListView.builder(
                            itemCount: forecastData.list.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => WeatherItem(weather: forecastData.list.elementAt(index))
                        ) : Container(),
                      ),
                    ),
                  )
                ]
            );
  }

  loadWeather() async {
    setState(() {
      isLoading = true;
    });

    final lat =  49.8383;
    final lon = 24.0232;
    final weatherResponse = await http.get(
        'https://api.openweathermap.org/data/2.5/weather?APPID=714ecf9fe3544d51a7dfff044544eb94&lat=${lat
            .toString()}&lon=${lon.toString()}');
    final forecastResponse = await http.get(
        'https://api.openweathermap.org/data/2.5/forecast?APPID=714ecf9fe3544d51a7dfff044544eb94&lat=${lat
            .toString()}&lon=${lon.toString()}');

    if (weatherResponse.statusCode == 200 &&
        forecastResponse.statusCode == 200) {
      return setState(() {
        weatherData = new WeatherData.fromJson(jsonDecode(weatherResponse.body));
        forecastData = new ForecastData.fromJson(jsonDecode(forecastResponse.body));
        isLoading = false;
      });
    }

    setState(() {
      isLoading = false;
    });
  }
}