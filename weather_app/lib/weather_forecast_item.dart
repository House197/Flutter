import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  const HourlyForecastItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Column(
          children: [
            Text(
              '05:00',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(Icons.cloud),
            Text('300')
          ],
        ),
      ),
    );
  }
}
