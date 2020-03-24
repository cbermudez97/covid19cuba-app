import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:geojson/geojson.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object> get props => [];
}

class InitialMapState extends MapState {}

class LoadingMapState extends MapState {}

class LoadedMapState extends MapState {
  final GeoJson geoJson;

  const LoadedMapState({@required this.geoJson}) : assert(geoJson != null);

  @override
  List<Object> get props => [geoJson];
}

class ErrorMapState extends MapState {
  final String errorMessage;

  const ErrorMapState({@required this.errorMessage})
      : assert(errorMessage != null);

  @override
  List<Object> get props => [errorMessage];
}
