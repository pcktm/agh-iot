import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/measurment.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/service/api.dart';

import 'package:fl_chart/fl_chart.dart';

class Plot extends StatefulWidget {
  final String id;
  const Plot({super.key, required this.id});
  @override
  _PlotState createState() => _PlotState();
}

class _PlotState extends State<Plot> {
  final List<Color> _gradientColors = [
    const Color(0xFF6FFF7C),
    const Color(0xFF0087FF),
    const Color(0xFF5620FF),
  ];
  final int _divider = 25;
  final int _leftLabelsCount = 3;

  List<FlSpot> _values = const [];
  int currentTemperature = 0;
  int currentHumidity = 0;

  double _minX = 0;
  double _maxX = 0;
  double _minY = 0;
  double _maxY = 0;
  double _leftTitlesInterval = 0;

  @override
  void initState() {
    super.initState();
    _prepareData();
  }

  Future<List<Measurement>> fetchMeasurement() async {
    // String currentLaundryId = "edf95f4a-9a30-42c6-b6bf-6c9aad405e04";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token").toString();
    return getMeasurement(token, widget.id);
  }

  void _prepareData() async {
    final List<Measurement> data = await fetchMeasurement();
    if (data.isEmpty) return;
    currentHumidity = data[data.length - 1].humidity;
    currentTemperature = data[data.length - 1].temperature;

    double minY = double.maxFinite;
    double maxY = double.minPositive;

    _values = data.map((datum) {
      if (minY > datum.humidity) minY = datum.humidity.toDouble();
      if (maxY < datum.humidity) maxY = datum.humidity.toDouble();
      return FlSpot(
        datum.createdAt.millisecondsSinceEpoch.toDouble(),
        datum.humidity.toDouble(),
      );
    }).toList();

    _minX = _values.first.x;
    _maxX = _values.last.x;
    _minY = (minY / _divider).floorToDouble() * _divider;
    _maxY = (maxY / _divider).ceilToDouble() * _divider;

    _leftTitlesInterval =
        ((_maxY - _minY) / (_leftLabelsCount - 1)).floorToDouble();

    if (!mounted) return;

    setState(() {});
  }

  LineChartBarData _lineBarData() {
    return LineChartBarData(
      spots: _values,
      gradient: LinearGradient(
        colors: _gradientColors,
      ),
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: _gradientColors,
        ),
      ),
    );
  }

  LineChartData _mainData() {
    return LineChartData(
      gridData: _gridData(),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: max(1, (_maxX - _minX) / 3),
              getTitlesWidget: bottomTitleWidgets,
            ),
            axisNameWidget: Text(
                "TEMPERATURE $currentTemperature°C   HUMIDITY $currentHumidity%",
                style: const TextStyle(fontSize: 18, color: Colors.blue)),
            axisNameSize: 30),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: _leftTitlesInterval,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        border: Border.all(color: Colors.white12, width: 1),
      ),
      minX: _minX,
      maxX: _maxX,
      minY: _minY,
      maxY: _maxY,
      lineBarsData: [_lineBarData()],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontSize: 10,
    );
    Widget text;
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    text = Text(DateFormat.Hm().format(date), style: style);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontSize: 13,
    );
    String text = "$value%";
    return Text(text, style: style, textAlign: TextAlign.center);
  }

  FlGridData _gridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      verticalInterval: 1,
      horizontalInterval: 1,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.white12,
          strokeWidth: 1,
        );
      },
      checkToShowHorizontalLine: (value) {
        return (value - _minY) % _leftTitlesInterval == 0;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_values.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        child: const Text('No measurements'),
      );
    }
    return AspectRatio(
        aspectRatio: 1.70,
        child: Padding(
            padding: const EdgeInsets.only(
                right: 18.0, left: 12.0, top: 24, bottom: 12),
            child: LineChart(_mainData())));
  }
}
