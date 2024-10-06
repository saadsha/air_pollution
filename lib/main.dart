import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Air Pollution App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AirPollutionPage(),
    );
  }
}

class Country {
  final String name;
  final int aqi;

  Country(this.name, this.aqi);
}

class AirPollutionPage extends StatelessWidget {
  final List<Country> countries = [
    Country("United States", 50),
    Country("China", 120),
    Country("India", 150),
    Country("Germany", 40),
    Country("Japan", 70),
    Country("Brazil", 60),
    Country("Russia", 80),
    Country("France", 45),
    Country("United Kingdom", 55),
    Country("Canada", 35),
  ];

  Color getAQIColor(int aqi) {
    if (aqi <= 50) return Colors.green;
    if (aqi <= 100) return Colors.yellow;
    if (aqi <= 150) return Colors.orange;
    if (aqi <= 200) return Colors.red;
    return Colors.purple;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Air Pollution by Country'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: countries.length,
              itemBuilder: (context, index) {
                final country = countries[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(country.name, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('AQI: ${country.aqi}'),
                    trailing: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: getAQIColor(country.aqi),
                      ),
                      child: Center(
                        child: Text(
                          country.aqi.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            height: 200,
            padding: EdgeInsets.all(16),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 200,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: SideTitles(
                    showTitles: true,
                    getTextStyles: (context, value) => const TextStyle(fontSize: 10),
                    getTitles: (double value) {
                      return countries[value.toInt()].name.substring(0, 3);
                    },
                  ),
                  leftTitles: SideTitles(showTitles: false),
                ),
                borderData: FlBorderData(show: false),
                barGroups: countries.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        y: entry.value.aqi.toDouble(),
                        colors: [getAQIColor(entry.value.aqi)],
                        width: 16,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                child: Text('Show Leaderboard'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LeaderboardPage(countries: countries)),
                  );
                },
              ),
              ElevatedButton(
                child: Text('Enlighten'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AwarenessPage()),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class LeaderboardPage extends StatelessWidget {
  final List<Country> countries;

  LeaderboardPage({required this.countries});

  @override
  Widget build(BuildContext context) {
    List<Country> sortedCountries = List.from(countries)..sort((a, b) => a.aqi.compareTo(b.aqi));

    return Scaffold(
      appBar: AppBar(
        title: Text('Air Quality Leaderboard'),
      ),
      body: ListView.builder(
        itemCount: sortedCountries.length,
        itemBuilder: (context, index) {
          final country = sortedCountries[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text('${index + 1}'),
              backgroundColor: index < 3 ? Colors.yellow : Colors.blue,
            ),
            title: Text(country.name),
            trailing: Text('AQI: ${country.aqi}'),
          );
        },
      ),
    );
  }
}

class AwarenessPage extends StatelessWidget {
  final List<Map<String, String>> awarenessPoints = [
    {
      "title": "Health Impact",
      "description": "Air pollution can cause respiratory issues, heart disease, and other health problems.",
    },
    {
      "title": "Environmental Effect",
      "description": "It contributes to climate change, acid rain, and damages ecosystems.",
    },
    {
      "title": "Economic Cost",
      "description": "Air pollution leads to increased healthcare costs and reduced productivity.",
    },
    {
      "title": "Vulnerable Groups",
      "description": "Children, elderly, and those with pre-existing conditions are most at risk.",
    },
  ];

  final List<Map<String, String>> precautions = [
    {
      "title": "Check AQI Daily",
      "description": "Stay informed about local air quality levels.",
    },
    {
      "title": "Reduce Outdoor Activities",
      "description": "Limit time outdoors when air quality is poor.",
    },
    {
      "title": "Use Air Purifiers",
      "description": "Keep indoor air clean with HEPA air purifiers.",
    },
    {
      "title": "Wear Masks",
      "description": "Use N95 masks when air quality is severely poor.",
    },
    {
      "title": "Support Clean Air Policies",
      "description": "Advocate for policies that reduce air pollution.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Air Pollution Awareness'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Awareness Points', style: Theme.of(context).textTheme.headline5),
              SizedBox(height: 16),
              ...awarenessPoints.map((point) => _buildInfoCard(point)),
              SizedBox(height: 24),
              Text('Precautions', style: Theme.of(context).textTheme.headline5),
              SizedBox(height: 16),
              ...precautions.map((precaution) => _buildInfoCard(precaution)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(Map<String, String> info) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(info['title']!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 8),
            Text(info['description']!),
          ],
        ),
      ),
    );
  }
}