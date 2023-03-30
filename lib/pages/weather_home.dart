import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/helper_function.dart';
import 'package:weather_app/weather_provider.dart';

class WeatherHome extends StatefulWidget {
  static const String routeName = '/';
  const WeatherHome({Key? key}) : super(key: key);

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  late WeatherProvider _weatherProvider;
  bool _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      _weatherProvider = Provider.of<WeatherProvider>(context);
      _getPosition();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  _getPosition() {
    determinePosition().then((position) {
      setState(() {
        final latitude = position.latitude;
        final longitude = position.longitude;

        _weatherProvider.setNewLatLng(latitude, longitude);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      backgroundColor: Color(0xFF485361),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF485361),
        title: Text("Weather"),
        actions: [],
      ),
      body: _weatherProvider.hasDataLoaded
          ? ListView(
              padding: EdgeInsets.all(20),
              children: [
                _currentSection(),
                SizedBox(
                  height: 30,
                ),
                _forcastSection(),
                // _forcastSection2(),
                SizedBox(
                  height: 30,
                ),
                _sunRiseSet(),
              ],
            )
          : Center(
              child: SpinKitThreeBounce(
              color: Colors.white,
            )),
    );
  }

  Widget _currentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${_weatherProvider.currentResponse!.main!.temp!.round()}\u00B0",
              style: txtTempBig80Style,
            ),
            Image.network(
              '$iconPrefix${_weatherProvider.currentResponse!.weather!.first.icon}$iconSuffix',
              width: 120,
              height: 120,
              color: Colors.white70,
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "${_weatherProvider.currentResponse!.name},${_weatherProvider.currentResponse!.sys!.country}",
              style: txtAddressStyle,
            ),
            Icon(
              Icons.location_on,
              color: Colors.white,
            ),
          ],
        ),
        Row(
          children: [
            Text(
              '${_weatherProvider.currentResponse!.main!.temp!.round()}\u00B0 /',
              style: txtTempNormal16Style,
            ),
            Text(
              '${_weatherProvider.currentResponse!.main!.tempMin!.round()}\u00B0  ',
              style: txtTempNormal16Style,
            ),
            Text(
              'Feels like ${_weatherProvider.currentResponse!.main!.feelsLike!.round()}\u00B0',
              style: txtTempNormal16Style,
            ),
          ],
        ),
        Row(
          children: [
            Text(
              getFormattedDate(
                  _weatherProvider.currentResponse!.dt!, "MMM dd,yyyy   "),
              style: txtTempNormal16Style,
            ),
            Text(
              getFormattedDate(
                  _weatherProvider.currentResponse!.dt!, "E, hh:mm a"),
              style: txtTempNormal16Style,
            ),
          ],
        ),
      ],
    );
  }

  Widget _forcastSection() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white24, borderRadius: BorderRadius.circular(20)),
      height: 180,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _weatherProvider.forcastResponse!.list!.length,
          itemBuilder: (context, index) {
            final item = _weatherProvider.forcastResponse!.list![index];
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    getFormattedDate(item.dt!, "hh:mm a"),
                    style: txtDateStyle,
                  ),
                  Image.network(
                    '$iconPrefix${item.weather!.first.icon}$iconSuffix',
                    width: 40,
                    height: 40,
                  ),
                  Text(
                    '${item.main!.temp!.round()}\u00B0',
                    style: txtTempNormal16Style,
                  ),
                  Text(
                    item.weather!.first.description!,
                    style: txtDefaultStyle,
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget _forcastSection2() {
    return Container(
      height: 300,
      color: Colors.white24,
      child: ListView.builder(
          itemCount: _weatherProvider.forcastResponse!.list!.length,
          itemBuilder: (context, index) {
            final item = _weatherProvider.forcastResponse!.list![index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Text(
                  getFormattedDate(item.dt!, "EEE"),
                  style: txtDateStyle,
                ),
                title: Image.network(
                  '$iconPrefix${item.weather!.first.icon}$iconSuffix',
                  width: 40,
                  height: 40,
                ),
                trailing: Text(
                  '${item.main!.temp!.round()}\u00B0',
                  style: txtTempNormal16Style,
                ),
              ),
            );
          }),
    );
  }

  Widget _sunRiseSet() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white24, borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.symmetric(vertical: 12),
      height: 120,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                "Sunrise",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              Text(
                getFormattedDate(
                    _weatherProvider.currentResponse!.sys!.sunrise!, "hh:mm a"),
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              Text(
                "🌅",
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                "Sunset",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              Text(
                getFormattedDate(
                    _weatherProvider.currentResponse!.sys!.sunset!, "hh:mm a"),
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              Text(
                "🌇",
                style: TextStyle(fontSize: 30),
              )
            ],
          )
        ],
      ),
    );
  }
}
