import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Temperature Converter',
      debugShowCheckedModeBanner: false,
      home: TemperatureConverterPage(),
    );
  }
}

class TemperatureConverterPage extends StatefulWidget {
  const TemperatureConverterPage({super.key});

  @override
  State<TemperatureConverterPage> createState() =>
      _TemperatureConverterPageState();
}

class _TemperatureConverterPageState extends State<TemperatureConverterPage> {
  final TextEditingController _tempController = TextEditingController();
  String _result = '';
  bool _isCelsiusToFahrenheit = true;

  void _convertTemperature() {
    String input = _tempController.text.trim();
    if (input.isEmpty) {
      showSnackBar(context, "Please enter a temperature");
      return;
    }

    double value = double.tryParse(input) ?? double.nan;
    if (value.isNaN) {
      showSnackBar(context, "Invalid number");
      return;
    }

    setState(() {
      if (_isCelsiusToFahrenheit) {
        double fahrenheit = (value * 9 / 5) + 32;
        _result = "$value°C = ${fahrenheit.toStringAsFixed(2)}°F";
      } else {
        double celsius = (value - 32) * 5 / 9;
        _result = "$value°F = ${celsius.toStringAsFixed(2)}°C";
      }
    });
  }

  void showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _switchConversion() {
    setState(() {
      _isCelsiusToFahrenheit = !_isCelsiusToFahrenheit;
      _tempController.clear();
      _result = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    String inputLabel =
        _isCelsiusToFahrenheit ? "Celsius (°C)" : "Fahrenheit (°F)";
    String buttonLabel =
        _isCelsiusToFahrenheit ? "Convert to Fahrenheit" : "Convert to Celsius";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Temperature Converter"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            onPressed: _switchConversion,
            icon: const Icon(Icons.swap_horiz),
            tooltip: "Switch Conversion",
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Center(
                child: Text(
                  "Converter App",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.thermostat),
              title: const Text("Temperature"),
              onTap: () => showSnackBar(context, "Already on Temperature Page"),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About"),
              onTap:
                  () => showSnackBar(context, "Simple Temperature Converter"),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _tempController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: inputLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertTemperature,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              child: Text(buttonLabel),
            ),
            const SizedBox(height: 20),
            Text(
              _result,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}