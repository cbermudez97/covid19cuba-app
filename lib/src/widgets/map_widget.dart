import 'dart:async';
import 'dart:developer' as dev;

import 'package:covid19cuba/src/blocs/map_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:map_controller/map_controller.dart';

import 'package:covid19cuba/src/blocs/blocs.dart';

class MapWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  MapController mapController;
  StatefulMapController statefulMapController;
  StreamSubscription<StatefulMapControllerStateChange> listener;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocProvider(
      create: (context) => MapBloc(),
      child: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          if (state is InitialMapState) {
            BlocProvider.of<MapBloc>(context)
                .add(FetchMapEvent(map: 'assets/maps/provincias.geojson'));
          }
          if (state is LoadingMapState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ErrorMapState) {
            return Center(
              child: Text(state.errorMessage),
            );
          }
          if (state is LoadedMapState) {
            mapController = MapController();
            statefulMapController =
                StatefulMapController(mapController: mapController);
            statefulMapController.onReady.then((_) async {
              await statefulMapController.fromGeoJson(
                  'assets/maps/provincias.geojson'); // I should use the state property somehow
              // Maybe directly drawing all the data from state.geo
            });
            listener = statefulMapController.changeFeed.listen((change) {
              dev.log('Something changed on the map!');
            });
            return Container(
              child: SafeArea(
                  child: Stack(children: <Widget>[
                FlutterMap(
                  mapController: mapController,
                  options: MapOptions(),
                  layers: [
                    MarkerLayerOptions(markers: statefulMapController.markers),
                    PolylineLayerOptions(
                        polylines: statefulMapController.lines),
                    PolygonLayerOptions(
                        polygons: statefulMapController.polygons)
                  ],
                ),
              ])),
            );
          }
          return Container();
        },
      ),
    );
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }
}
