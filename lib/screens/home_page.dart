import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/data/image_path.dart';
import 'package:weather_app/services/location_provider.dart';
import 'package:weather_app/services/weatherservice_provider.dart';
import 'package:weather_app/utils/apptext.dart';
import 'package:weather_app/utils/deviderclass.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController citycontroller = TextEditingController();

  @override
  void initState() {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    locationProvider.detectPosition().then((_) {
      if (locationProvider.currentLocationName != null) {
        var city = locationProvider.currentLocationName!.locality;
        if (city != null) {
          Provider.of<WeatherserviceProvider>(context, listen: false)
              .fetchWeatherDataByCity(city);
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    citycontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    final weatherprovider = Provider.of<WeatherserviceProvider>(context);

    int sunriseTimeStamp = weatherprovider.weather?.sys?.sunrise ?? 0;
    int sunsetTimeStamp = weatherprovider.weather?.sys?.sunset ?? 0;

    //convert timestamp to a datetime object
    DateTime SunriseDateTime =
        DateTime.fromMillisecondsSinceEpoch(sunriseTimeStamp * 1000);
    DateTime SunsetDateTime =
        DateTime.fromMillisecondsSinceEpoch(sunsetTimeStamp * 1000);

    //frmat it as string

    String formattedSunrise = sunriseTimeStamp == 0
        ? "N/A"
        : DateFormat('hh:mm a').format(SunriseDateTime);
    String formattedSunset = sunsetTimeStamp == 0
        ? "N/A"
        : DateFormat('hh:mm a').format(SunsetDateTime);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      //extends the backgroundimg behind the appbar
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(),
      body: weatherprovider.weather != null
          ? Container(
              padding:
                  EdgeInsets.only(top: 90, left: 50, right: 50, bottom: 20),
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                //bacground image
                image: DecorationImage(
                  image: AssetImage(backgrounds[
                          weatherprovider.weather!.weather![0].main ?? "N/A"] ??
                      'assets/img/default.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Positioned(
                  //   top: 50,
                  //   left: 20,
                  //   right: 20,
                  //   child: TextField(
                  //     decoration: InputDecoration(
                  //       enabledBorder: UnderlineInputBorder(
                  //           borderSide: BorderSide(color: Colors.white)),
                  //       focusedBorder: UnderlineInputBorder(
                  //           borderSide: BorderSide(color: Colors.white)),
                  //     ),
                  //   ),
                  // ),
                  Container(
                    height: 50,
                    child: Consumer<LocationProvider>(
                        builder: (context, locationProvider, child) {
                      var placename;
                      if (locationProvider.currentLocationName != null) {
                        placename =
                            locationProvider.currentLocationName!.locality;
                      } else {
                        placename = "Unknown Location";
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_pin,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ApppText(
                                      data: placename,
                                      color: Colors.white,
                                      fw: FontWeight.bold,
                                      size: 20,
                                    ),
                                    ApppText(
                                      data: 'Current Location',
                                      color: Colors.white,
                                      size: 14,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  Align(
                    alignment: Alignment(0, -.6),
                    child: Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(icons[
                                  weatherprovider.weather!.weather![0].main ??
                                      "N/A"] ??
                              'assets/img/default.png'),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, -.1),
                    child: Container(
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ApppText(
                            data:
                                " ${weatherprovider.weather!.main!.temp!.toStringAsFixed(0)}°C ",
                            color: Colors.white,
                            size: 35,
                            fw: FontWeight.bold,
                          ),
                          ApppText(
                            data: weatherprovider.weather!.weather![0].main ??
                                "N/A",
                            color: Colors.white,
                            fw: FontWeight.w600,
                            size: 26,
                          ),
                          ApppText(
                            data: weatherprovider.weather!.name ?? "N/A",
                            color: Colors.white,
                            fw: FontWeight.w600,
                            size: 20,
                          ),
                          ApppText(
                            data:
                                //using the intl package we format the time to more hunman readeble
                                DateFormat("hh:mm a").format(DateTime.now()),
                            color: Colors.white,
                            size: 15,
                            fw: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 20,
                    right: 20,
                    child: Row(
                      children: [
                        SizedBox(
                            width: 10), // Spacing between icon and textfield
                        Expanded(
                          child: TextField(
                            cursorColor: Colors.white,
                            controller: citycontroller,
                            decoration: InputDecoration(
                              hintText: 'Search here...',
                              hintStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none, // Remove default border
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            weatherprovider
                                .fetchWeatherDataByCity(citycontroller.text);
                          },
                          icon:
                              Icon(Icons.search), // You can customize the color
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, 1),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.3),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/img/maxtemp.png',
                                    height: 50,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ApppText(
                                        data: "Temp Max",
                                        color: Colors.white,
                                        size: 17,
                                        fw: FontWeight.w600,
                                      ),
                                      ApppText(
                                        data:
                                            " ${weatherprovider.weather!.main!.tempMax!.toStringAsFixed(0)}°C",
                                        color: Colors.white,
                                        size: 14,
                                        fw: FontWeight.w600,
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/img/mintemp.png',
                                    height: 50,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ApppText(
                                        data: "Temp Min",
                                        color: Colors.white,
                                        size: 17,
                                        fw: FontWeight.w600,
                                      ),
                                      ApppText(
                                        data:
                                            " ${weatherprovider.weather!.main!.tempMin!.toStringAsFixed(0)}°C",
                                        color: Colors.white,
                                        size: 14,
                                        fw: FontWeight.w600,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                          CustomDivider(
                            color: Colors.white,
                            indent: 10,
                            endIndent: 10,
                            thickness: 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'assets/img/sunrise.png',
                                    height: 50,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ApppText(
                                        data: "Sunrise",
                                        color: Colors.white,
                                        size: 17,
                                        fw: FontWeight.w600,
                                      ),
                                      ApppText(
                                        data: formattedSunrise,
                                        color: Colors.white,
                                        size: 14,
                                        fw: FontWeight.w600,
                                      )
                                    ],
                                  )
                                ],
                              ),
                              // SizedBox(
                              //   width: 25,
                              // ),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/img/sunset.png',
                                    height: 50,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ApppText(
                                        data: "Sunset",
                                        color: Colors.white,
                                        size: 17,
                                        fw: FontWeight.w600,
                                      ),
                                      ApppText(
                                        data: formattedSunset,
                                        color: Colors.white,
                                        size: 14,
                                        fw: FontWeight.w600,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ))
          : Center(
              child: Container(
                height: 200,
                color: Colors.black.withOpacity(.3),
                child: Center(
                  child: ApppText(
                    data: "Loading weather data...",
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
    );
  }
}
