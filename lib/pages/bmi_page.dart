import 'package:bmicalculator/pages/widgets/info_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bmicalculator/pages/history_page.dart';

class BMIPage extends StatefulWidget {
  BMIPage({super.key});

  @override
  State<BMIPage> createState() => _BMIPageState();
}

class _BMIPageState extends State<BMIPage> {
  double? w, h;
  int _age = 25, _weight = 55, _height = 75, _gender = 0;

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return CupertinoPageScaffold(
        child: Center(
      child: SizedBox(
          height: h! * 0.85,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _ageSelectContainer(),
                  _weightSelectContainer(),
                ],
              ),
              _heightSelectContainer(),
              _genderSelecter(),
              _calculateBMIButton()
            ],
          )),
    ));
  }

  Widget _ageSelectContainer() {
    return InfoCard(
        width: w! * 0.45,
        height: h! * 0.20,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Age yr",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            Text(
              _age.toString(),
              style: const TextStyle(
                  fontSize: 45,
                  color: Colors.black,
                  fontWeight: FontWeight.w700),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  child: CupertinoDialogAction(
                    onPressed: () {
                      setState(() {
                        _age--;
                      });
                    },
                    textStyle: const TextStyle(fontSize: 25, color: Colors.red),
                    child: const Text("-"),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: CupertinoDialogAction(
                    onPressed: () {
                      setState(() {
                        _age++;
                      });
                    },
                    textStyle:
                        const TextStyle(fontSize: 25, color: Colors.blue),
                    child: const Text("+"),
                  ),
                )
              ],
            ),
          ],
        ));
  }

  Widget _weightSelectContainer() {
    return InfoCard(
        width: w! * 0.45,
        height: h! * 0.20,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Weight Kg",
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              _weight.toString(),
              style: const TextStyle(
                  fontSize: 45,
                  color: Colors.black,
                  fontWeight: FontWeight.w700),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  child: CupertinoDialogAction(
                    onPressed: () {
                      setState(() {
                        _weight--;
                      });
                    },
                    textStyle: const TextStyle(fontSize: 25, color: Colors.red),
                    child: const Text("-"),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: CupertinoDialogAction(
                    onPressed: () {
                      setState(() {
                        _weight++;
                      });
                    },
                    textStyle:
                        const TextStyle(fontSize: 25, color: Colors.blue),
                    child: const Text("+"),
                  ),
                )
              ],
            ),
          ],
        ));
  }

  Widget _heightSelectContainer() {
    return InfoCard(
      width: w! * 0.90,
      height: h! * 0.15,
      child: Column(
        children: [
          const Text(
            "Height in",
            style: TextStyle(
                fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          Text(
            _height.toString(),
            style: const TextStyle(
                fontSize: 45, color: Colors.black, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            width: w! * 0.80,
            child: CupertinoSlider(
                min: 10,
                max: 84,
                divisions: 74,
                value: _height.toDouble(),
                onChanged: (_value) {
                  setState(() {
                    _height = _value.toInt();
                  });
                }),
          )
        ],
      ),
    );
  }

  Widget _genderSelecter() {
    return InfoCard(
      width: w! * 0.90,
      height: h! * 0.11,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Gender",
            style: TextStyle(
                fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          CupertinoSlidingSegmentedControl(
              groupValue: _gender,
              children: const {0: Text("Male"), 1: Text("Female")},
              onValueChanged: (_value) {
                setState(() {
                  _gender = _value as int;
                });
              })
        ],
      ),
    );
  }

  Widget _calculateBMIButton() {
    double _heightinmeters = _height * 0.0254;
    return Container(
      height: h! * 0.07,
      child: CupertinoButton.filled(
        onPressed: () {
          if (_height > 0 && _weight > 0 && _age > 0) {
            double _bmi = _weight / (_heightinmeters * _heightinmeters);

            _showresults(_bmi);
          }
        },
        child: const Text("Calculate BMI"),
      ),
    );
  }
  

  void _showresults(double _bmi) {
    String? _status;
    if (_bmi < 18.5) {
      _status = "Underweight";
    } else if (_bmi >= 18.5 && _bmi < 25) {
      _status = "Normal";
    } else if (_bmi >= 25 && _bmi < 30) {
      _status = "Overweight";
    } else if (_bmi > 30) {
      _status = "Obesity";
    }
    showCupertinoDialog(
        context: context,
        builder: (BuildContext _context) {
          return CupertinoAlertDialog(
            title: Text(_status!),
            content: Text(_bmi.toStringAsFixed(2)),
            actions: [
              CupertinoDialogAction(
                child: const Text("Ok"),
                onPressed: () {
                  _saveResult(_bmi.toString(), _status!);
                  Navigator.pop(_context);
                },
              )
            ],
          );
        });
  }

  void _saveResult(String _bmi, String _status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bmi_date', DateTime.now().toString());
    await prefs.setStringList(
      'bmi_data',
      <String>[_bmi, _status],
    );
    print('Data saved: $_bmi, $_status');
    setState(() {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    print('Data loaded: ${prefs.getString('bmi_date')}');
    // Rest of the loading logic...
  }
}
