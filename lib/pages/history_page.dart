import 'package:bmicalculator/pages/widgets/info_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  double? w, h;
  String? _date, _bmi, _status;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return CupertinoPageScaffold(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
        _dataCard(),
        _refreshButton()
        ])),
    );
  }

  Widget _dataCard() {
    if (_date != null && _status != null && _bmi != null) {
      return InfoCard(
        width: w! * 0.75,
        height: h! * 0.25,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _statusText(_status!),
            _dateText(_date!),
            _bmiText(_bmi!),
          ],
        ),
      );
    } else {
      return const CupertinoActivityIndicator(
        color: Colors.blue,
      );
    }
  }

  Widget _statusText(String _status) {
    return Text(
      _status,
      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w500, color: Colors.black),
    );
  }

  Widget _dateText(String _date) {
    DateTime _parseDate = DateTime.parse(_date);
    return Text(
      '${_parseDate.hour}:${_parseDate.minute}  ${_parseDate.day}/${_parseDate.month}/${_parseDate.year}',
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
    );
  }

  Widget _bmiText(String _bmi) {
    return Text(
      double.parse(_bmi).toStringAsFixed(2),
      style: const TextStyle(fontSize: 60, fontWeight: FontWeight.w600, color: Colors.black),
    );
  }

    Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _date = prefs.getString('bmi_date');
      final data = prefs.getStringList('bmi_data');
      _status = data?[1];
      _bmi = data?[0];
    });
  }
  void _updateData() {
    // Manually trigger a refresh by reloading the data
    _loadData();
  }

  Widget _refreshButton() {
  return CupertinoButton(
    onPressed: () {
      _updateData(); // Call the refresh function
    },
    child: const Text('Refresh'),
  );
}
}
