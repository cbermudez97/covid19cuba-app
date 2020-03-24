import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class FetchMapEvent extends MapEvent {
  final String map;

  const FetchMapEvent({@required this.map}): assert(map != null);

  @override
  List<Object> get props => [map];
}
