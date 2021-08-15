import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_using_bloc_1/bloc_geolocation_weather/event/weather_geolocation_event.dart';
import 'package:flutter_weather_using_bloc_1/bloc_geolocation_weather/state/weather_geolocation_state.dart';
import 'package:flutter_weather_using_bloc_1/geolocator/geolocator.dart';
import 'package:flutter_weather_using_bloc_1/models/weather_geolocation.dart';
import 'package:flutter_weather_using_bloc_1/repositories/weather_repository.dart';

class WeatherGeolocationBloc extends Bloc<WeatherGeolocationEvent, WeatherGeolocationState> {
  final WeatherRepository weatherRepository;
  final LocationInfo locationInfo;

  WeatherGeolocationBloc({@required this.weatherRepository, @required this.locationInfo}) : assert(weatherRepository != null), super(WeatherStateInitial());
  @override
  Stream<WeatherGeolocationState> mapEventToState(WeatherGeolocationEvent weatherGeolocationEvent) async*{
    if(weatherGeolocationEvent is WeatherEventRequested) {
      yield WeatherStateLoading();
      try {
        final WeatherGeolocation weatherGeolocation = await weatherRepository.getResponseData(weatherGeolocationEvent.latitude, weatherGeolocationEvent.longitude);
        yield WeatherStateSuccess(weatherGeolocation: weatherGeolocation);
      }catch(exception) {
        yield WeatherStateFailure();
      }
    } else if(weatherGeolocationEvent is WeatherEventRefresh) {
      try {
        final WeatherGeolocation weatherGeolocation = await weatherRepository.getResponseData(locationInfo.latitude, locationInfo.longitude);
        yield WeatherStateSuccess(weatherGeolocation: weatherGeolocation);
      }catch(exception) {
        yield WeatherStateFailure();
      }
    }
  }
}