import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/secrets.dart';
import 'cards_code_class.dart';
import 'package:http/http.dart' as http;
 
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'Chennai';
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIkey'),
      );
      final data = jsonDecode(res.body);

      if ((data['cod'] != '200')) {
        throw 'An unexpected error occured';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weather App',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),
        ),
        centerTitle: true,
        actions: [
          
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              });
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        // alter to take future values
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator.adaptive()); // for loading
            // center used to center the loading indicator
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentWind = currentWeatherData['wind']['speed'];
          final currentHumidity = currentWeatherData['main']['humidity'];
          final feelTemp = currentWeatherData['main']['feels_like'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              // controls all widgets
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    elevation: 10,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10,
                          sigmaY: 10,
                        ),
                        child: Padding(
                          // to give space between upper boundry and temp.
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            // control card main
                            children: [
                              Text(
                                '${(currentTemp - 273.15).toStringAsFixed(2)} °C ',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Text(
                                'feels like ${(feelTemp - 273.15).toStringAsFixed(2)} °C ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // to give space between temp. and icon
                              SizedBox(
                                height: 20,
                              ),
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 70,
                              ),
                              // to give space between icon and rain
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                currentSky,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // to give space between cards
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Hourly Forecast',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // weather forecast cards 1
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       // we put the cards in a separate class
                //       for (int i = 0; i < 5;i++)
                //         HourlyForecast(
                //           time: data['list'][i+1]['dt'].toString(),
                //           icon: data['list'][i+1]['weather'][0]['main']=='Clouds'|| data['list'][i+1]['weather'][0]['main']=='Rain'? Icons.cloud: Icons.sunny,
                //           temp: '${((data['list'][i+1]['main']['temp'])- 273.15).toStringAsFixed(2)} °C '
                //         ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                      itemCount: 5,
                      scrollDirection:
                          Axis.horizontal, // to scroll in horizontal direction

                      itemBuilder: (context, index) {
                        final hourlyForecast = data['list'][index + 1];
                        final time = DateTime.parse(hourlyForecast['dt_txt']);
                        return HourlyForecast(
                          icon: hourlyForecast['weather'][0]['main'] ==
                                      'Clouds' ||
                                  hourlyForecast['weather'][0]['main'] == 'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                          temp:
                              '${((hourlyForecast['main']['temp']) - 273.15).toStringAsFixed(2)} °C ',
                          // format 13:00 hm is hour minute
                          time: DateFormat.Hm().format(time),
                        );
                      }),
                ),

                // card 2
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  // below line will give equal spaces to widgets
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // now all three has separete icons
                  // passing values for all different widgets
                  children: [
                    card2_widget_code(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: currentHumidity.toString(),
                    ),
                    card2_widget_code(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: currentWind.toString(),
                    ),
                    card2_widget_code(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: currentPressure.toString(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                // i just want to write made with love by shubham
                Column(
                  children: [
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Made With ',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 25,
                          )
                        ],
                      ),
                    ),
                    Center(
                        child: Text(
                      'By Shubham ',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ))
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
