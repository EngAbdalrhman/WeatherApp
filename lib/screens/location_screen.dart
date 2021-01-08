import 'package:flutter/material.dart';
import 'package:weather/screens/city_screen.dart';
import 'package:weather/utilities/constants.dart';
import '../services/weather.dart';
import 'package:shimmer/shimmer.dart';
import 'package:animate_do/animate_do.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationweather});
  final locationweather;
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weatherModel = WeatherModel();
  double temp;
  int condition;
  String cityName;
  var rondedTemp;
  String icon, msg;
  @override
  void initState() {
    super.initState();
    var s = widget.locationweather;
    updating(s);
  }

  void updating(var dataCode) {
    setState(() {
      if (dataCode == null) {
        rondedTemp = 0;
        icon = 'empty';
        cityName = '';
        msg = 'unable to get location you are ';
        return;
      }
      temp = dataCode['main']['temp'];
      cityName = dataCode['name'];
      condition = dataCode['weather'][0]['id'];
      temp -= 273.0;
      rondedTemp = temp.round();
      icon = weatherModel.getWeatherIcon(condition);
      msg = weatherModel.getMessage(rondedTemp);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/hd.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      var s = widget.locationweather;
                      updating(s);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      var name = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CityScreen();
                      }));
                      if (name != null) {
                        var wetherData = await weatherModel.getCity(name);
                        updating(wetherData);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    FadeInLeft(
                      child: Text(
                        '$rondedTemp°',
                        style: kTempTextStyle,
                      ),
                    ),
                    Text(
                      icon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.white,
                  highlightColor: Colors.grey,
                  child: Text(
                    '$msg in $cityName',
                    textAlign: TextAlign.right,
                    style: kMessageTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
