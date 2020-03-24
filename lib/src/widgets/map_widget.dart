import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/services.dart' show rootBundle;
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

  void loadData() async {
      final data =
      await rootBundle.loadString('assets/maps/provincias.geojson');
      await statefulMapController.fromGeoJson(data,
          verbose: true);
  }

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
            statefulMapController.onReady.then((_) => loadData());
            listener = statefulMapController.changeFeed.listen((change) {});
            return Container(
              child: SafeArea(
                  child: Stack(children: <Widget>[
                FlutterMap(
                  mapController: mapController,
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
    if (listener != null) listener.cancel();
    super.dispose();
  }
}
