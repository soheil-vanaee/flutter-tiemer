import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(StopwatchApp());
}

class StopwatchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stopwatch App',
      theme: ThemeData.light(), // Default theme is dark
      home: StopwatchScreen(),
    );
  }
}

class StopwatchScreen extends StatefulWidget {
  @override
  _StopwatchScreenState createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  late int _selectedTime;
  late int _remainingTime;
  late bool _isRunning;
  late Timer _timer;
  bool _isDarkTheme = true; // Default theme is dark

  @override
  void initState() {
    super.initState();
    _selectedTime = 60; // Default time is 60 seconds
    _remainingTime = _selectedTime;
    _isRunning = false;
  }

  void _startStopwatch() {
    setState(() {
      _isRunning = true;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_remainingTime > 0) {
          setState(() {
            _remainingTime--;
          });
        } else {
          _timer.cancel();
          _isRunning = false;
        }
      });
    });
  }

  void _pauseStopwatch() {
    setState(() {
      _isRunning = false;
      _timer.cancel();
    });
  }

  void _resetStopwatch() {
    setState(() {
      _remainingTime = _selectedTime;
      _isRunning = false;
      _timer.cancel();
    });
  }

  Future<void> _showTimeSelectionDialog(BuildContext context) async {
    int? selectedTime = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Time'),
          content: TextFormField(
            keyboardType: TextInputType.number,
            initialValue: _selectedTime.toString(),
            onChanged: (value) {
              setState(() {
                _selectedTime = int.tryParse(value) ?? 0;
              });
            },
            decoration: InputDecoration(
              labelText: 'Enter Time (seconds)',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(_selectedTime);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    if (selectedTime != null) {
      setState(() {
        _selectedTime = selectedTime;
        _remainingTime = selectedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = _remainingTime / _selectedTime;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: CircularProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[300],
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                    strokeWidth: 12,
                  ),
                ),
                Text(
                  '$_remainingTime',
                  style: TextStyle(fontSize: 36),
                ),
              ],
            ),
            SizedBox(height: 120),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isRunning ? _pauseStopwatch : _startStopwatch,
                  child: Text(_isRunning ? 'Pause' : 'Start'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent,
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _resetStopwatch,
                  child: Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
            SizedBox(height: 60),
            TextButton(
              onPressed: () => _showTimeSelectionDialog(context),
              child: Text(
                'Select Time',
                style: TextStyle(fontSize: 18, color: Colors.blueAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
