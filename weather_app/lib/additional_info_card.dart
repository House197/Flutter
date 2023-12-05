import 'package:flutter/material.dart';

class AdditionalInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const AdditionalInfoCard(
      {super.key,
      required this.icon,
      required this.label,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Column(
        children: [
          Icon(
            icon,
            size: 30,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w100),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          )
        ],
      ),
    );
  }
}
