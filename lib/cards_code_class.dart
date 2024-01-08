import 'package:flutter/material.dart';

// longer code so card 1 (hourly) will be in this class
class HourlyForecast extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;
  const HourlyForecast(
    {super.key,
    required this.icon,
    required this.temp,
    required this.time,
  
  
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // wrapped with sized box so it can take more space than text
      width: 100,
      child: Card(
        elevation: 6,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              // three widgets
              // time
              // icon
              // temp
              Text(
                
                time,
                maxLines:1,
                overflow:TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Icon(
                icon,
                size: 32,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                temp,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// widget of card 2
class card2_widget_code extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const card2_widget_code({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
