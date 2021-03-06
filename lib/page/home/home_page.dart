import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weatherapp/bloc/weather_bloc.dart';
import 'package:weatherapp/model/weather.dart';
import 'package:weatherapp/widgets/custom_text.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _bloc = WeatherBloc();

  @override
  void initState() {
    super.initState();
    _bloc.loadWeather();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Weather>(
        stream: _bloc.weatherStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return WeatherWidget(
              dateInFull: _bloc.dateFormatted,
              weather: snapshot.data!,
              isNight: _bloc.isNight,
            );
          } else if (snapshot.hasError) {
            return Center(
              child: CustomText(text: "Houve um problema"),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }
        });
  }
}

class WeatherWidget extends StatelessWidget {
  const WeatherWidget(
      {Key? key,
      required this.weather,
      required this.isNight,
      required this.dateInFull})
      : super(key: key);
  final Weather weather;
  final bool isNight;
  final String dateInFull;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isNight ? const Color(0xFF202020) : Colors.white,
      body: ListView(
        children: [
          Center(
            child: CustomText(
              text: weather.results!.city!,
              color: isNight ? Colors.white : const Color(0xFF404040),
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFF404040),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
                color: isNight ? Colors.blueGrey : Colors.blue,
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    // verifyWeatherIcon(Colors.white, 70),
                    const SizedBox(height: 25),
                    CustomText(
                      text: weather.results!.description!,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 24,
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      text: dateInFull,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 25),
                    CustomText(
                      text: "${weather.results!.temp!}??",
                      color: Colors.white,
                      fontSize: 76,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 20),
                    const Divider(
                      color: Colors.white,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 90,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  WeatherIcons.windy,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                        text: "Vento",
                                        color: Colors.white,
                                        fontSize: 16),
                                    CustomText(
                                      text: weather.results!.windSpeedy!,
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const VerticalDivider(
                            color: Colors.white,
                            thickness: 1,
                            endIndent: 7,
                          ),
                          Container(
                            margin: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  WeatherIcons.humidity,
                                  size: 28,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                        text: "Umidade",
                                        color: Colors.white,
                                        fontSize: 16),
                                    CustomText(
                                      text: "${weather.results!.humidity!}%",
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 14.0),
            height: 170,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: weather.results!.forecast!.length,
              scrollDirection: Axis.horizontal,
              key: key,
              itemBuilder: (context, idx) {
                Forecast forecast = weather.results!.forecast![idx];
                return SizedBox(
                  width: 140,
                  child: Card(
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "${forecast.date} - ",
                              color: isNight
                                  ? Colors.white
                                  : const Color(0xFF404040),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            CustomText(
                              text: "${forecast.weekday}",
                              color: isNight
                                  ? Colors.white
                                  : const Color(0xFF404040),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.keyboard_arrow_up_rounded,
                                color: Colors.red),
                            CustomText(
                              text: "${forecast.max}??",
                              color: isNight
                                  ? Colors.white
                                  : const Color(0xFF404040),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            const Icon(Icons.keyboard_arrow_down_rounded,
                                color: Colors.blue),
                            CustomText(
                              text: "${forecast.min}??",
                              color: isNight
                                  ? Colors.white
                                  : const Color(0xFF404040),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                        CustomText(
                          text: "${forecast.description}",
                          color:
                              isNight ? Colors.white : const Color(0xFF404040),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        /* const SizedBox(height: 15),
                      verifyWeatherIconForeCast(
                          isNight
                              ? Colors.white
                              : const Color(0xFF404040),
                          30,
                          forecast), */
                      ],
                    ),
                    color: isNight ? const Color(0xFF303030) : Colors.grey[50],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

// class _HomePageState extends State<HomePage> {
  /* final _bloc = WeatherBloc();

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  } */

  

  /* _body() {
    return Observer(builder: (_) {
      return ListView(
        children: [
          Center(
            child: CustomText(
              text: weather.results!.city!,
              color:
                  _controller.isNight ? Colors.white : const Color(0xFF404040),
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFF404040),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
                color: _controller.isNight ? Colors.blueGrey : Colors.blue,
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    verifyWeatherIcon(Colors.white, 70),
                    const SizedBox(height: 25),
                    CustomText(
                      text: _controller.weather.results!.description!,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 24,
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      text: _controller.dateInFull,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 25),
                    CustomText(
                      text: "${_controller.weather.results!.temp!}??",
                      color: Colors.white,
                      fontSize: 76,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 20),
                    const Divider(
                      color: Colors.white,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 90,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  WeatherIcons.windy,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                        text: "Vento",
                                        color: Colors.white,
                                        fontSize: 16),
                                    CustomText(
                                      text: _controller
                                          .weather.results!.windSpeedy!,
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const VerticalDivider(
                            color: Colors.white,
                            thickness: 1,
                            endIndent: 7,
                          ),
                          Container(
                            margin: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  WeatherIcons.humidity,
                                  size: 28,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                        text: "Umidade",
                                        color: Colors.white,
                                        fontSize: 16),
                                    CustomText(
                                      text:
                                          "${_controller.weather.results!.humidity!}%",
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 14.0),
            height: 170,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: _controller.weather.results!.forecast!.length,
              scrollDirection: Axis.horizontal,
              key: widget.key,
              itemBuilder: (context, idx) {
                Forecast forecast = _controller.weather.results!.forecast![idx];
                return SizedBox(
                  width: 140,
                  child: Card(
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "${forecast.date} - ",
                              color: _controller.isNight
                                  ? Colors.white
                                  : const Color(0xFF404040),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            CustomText(
                              text: "${forecast.weekday}",
                              color: _controller.isNight
                                  ? Colors.white
                                  : const Color(0xFF404040),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.keyboard_arrow_up_rounded,
                                color: Colors.red),
                            CustomText(
                              text: "${forecast.max}??",
                              color: _controller.isNight
                                  ? Colors.white
                                  : const Color(0xFF404040),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            const Icon(Icons.keyboard_arrow_down_rounded,
                                color: Colors.blue),
                            CustomText(
                              text: "${forecast.min}??",
                              color: _controller.isNight
                                  ? Colors.white
                                  : const Color(0xFF404040),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                        CustomText(
                          text: "${forecast.description}",
                          color: _controller.isNight
                              ? Colors.white
                              : const Color(0xFF404040),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        const SizedBox(height: 15),
                        verifyWeatherIconForeCast(
                            _controller.isNight
                                ? Colors.white
                                : const Color(0xFF404040),
                            30,
                            forecast),
                      ],
                    ),
                    color: _controller.isNight
                        ? const Color(0xFF303030)
                        : Colors.grey[50],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
        ],
      );
    });
  }

  _buildPage() {
    return Observer(builder: (_) {
      if (_controller.isLoading) {
        return _buildLoading();
      } else if (_controller.isError) {
        return _buildError();
      } else {
        return _body();
      }
    });
  }

  _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  _buildError() {
    return Observer(
      builder: (_) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFF404040),
                size: 70,
              ),
              const SizedBox(height: 50),
              CustomText(
                text: _controller.message,
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey),
                ),
                onPressed: () {
                  _controller.fetchData();
                },
                child: CustomText(
                  text: 'Tentar novamente',
                  fontSize: 18,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  verifyWeatherIcon(Color color, double size) {
    return Observer(builder: (_) {
      if (_controller.weather.results!.conditionSlug == 'storm') {
        return Icon(WeatherIcons.storm_showers, color: color, size: size);
      } else if (_controller.weather.results!.conditionSlug == 'snow') {
        return Icon(WeatherIcons.snow, color: color, size: size);
      } else if (_controller.weather.results!.conditionSlug == 'hail') {
        return Icon(WeatherIcons.hail, color: color, size: size);
      } else if (_controller.weather.results!.conditionSlug == 'rain') {
        return Icon(WeatherIcons.rain, color: color, size: size);
      } else if (_controller.weather.results!.conditionSlug == 'fog') {
        return Icon(WeatherIcons.fog, color: color, size: size);
      } else if (_controller.weather.results!.conditionSlug == 'clear_day') {
        return Icon(WeatherIcons.day_sunny, color: color, size: size);
      } else if (_controller.weather.results!.conditionSlug == 'clear_night') {
        return Icon(WeatherIcons.night_clear, color: color, size: size);
      } else if (_controller.weather.results!.conditionSlug == 'cloud') {
        return Icon(WeatherIcons.cloud, color: color, size: size);
      } else if (_controller.weather.results!.conditionSlug == 'cloudly_day') {
        return Icon(WeatherIcons.day_cloudy, color: color, size: size);
      } else if (_controller.weather.results!.conditionSlug ==
          'cloudly_night') {
        return Icon(WeatherIcons.night_cloudy, color: color, size: size);
      } else {
        return Icon(Icons.report_problem_rounded, color: color, size: size);
      }
    });
  }

  // TODO: melhorar isso daqui
  verifyWeatherIconForeCast(Color color, double size, Forecast forecast) {
    if (forecast.condition == 'storm') {
      return Icon(WeatherIcons.storm_showers, color: color, size: size);
    } else if (forecast.condition == 'snow') {
      return Icon(WeatherIcons.snow, color: color, size: size);
    } else if (forecast.condition == 'hail') {
      return Icon(WeatherIcons.hail, color: color, size: size);
    } else if (forecast.condition == 'rain') {
      return Icon(WeatherIcons.rain, color: color, size: size);
    } else if (forecast.condition == 'fog') {
      return Icon(WeatherIcons.fog, color: color, size: size);
    } else if (forecast.condition == 'clear_day') {
      return Icon(WeatherIcons.day_sunny, color: color, size: size);
    } else if (forecast.condition == 'clear_night') {
      return Icon(WeatherIcons.night_clear, color: color, size: size);
    } else if (forecast.condition == 'cloud') {
      return Icon(WeatherIcons.cloud, color: color, size: size);
    } else if (forecast.condition == 'cloudly_day') {
      return Icon(WeatherIcons.day_cloudy, color: color, size: size);
    } else if (forecast.condition == 'cloudly_night') {
      return Icon(WeatherIcons.night_cloudy, color: color, size: size);
    } else {
      return Icon(Icons.report_problem_rounded, color: color, size: size);
    }
  } */
// }

