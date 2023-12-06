import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/additional_info_card.dart';
import 'package:weather_app/weather_forecast_item.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                print('refresh');
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            '149 K',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Icon(
                            Icons.cloud,
                            size: 64,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Rain',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Weather Forecast',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HourlyForecastItem(
                      icon: Icons.tornado, hour: '01:00', value: '150'),
                  HourlyForecastItem(
                      icon: Icons.sunny, hour: '02:00', value: '230'),
                  HourlyForecastItem(
                      icon: Icons.cloud, hour: '03:00', value: '250'),
                  HourlyForecastItem(
                      icon: Icons.night_shelter, hour: '04:00', value: '353'),
                  HourlyForecastItem(
                      icon: Icons.water_damage, hour: '05:00', value: '321'),
                  HourlyForecastItem(
                      icon: Icons.water_damage, hour: '06:00', value: '542'),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Additional Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AdditionalInfoCard(
                  icon: Icons.water_drop,
                  label: 'Humidity',
                  value: '90',
                ),
                AdditionalInfoCard(
                  icon: Icons.air,
                  label: 'Wind Speed',
                  value: '7.5',
                ),
                AdditionalInfoCard(
                  icon: Icons.beach_access,
                  label: 'Pressure',
                  value: '1000',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
