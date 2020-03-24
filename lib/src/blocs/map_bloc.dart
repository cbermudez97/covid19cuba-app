import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geojson/geojson.dart';

import 'package:covid19cuba/src/blocs/events/events.dart';
import 'package:covid19cuba/src/blocs/states/states.dart';

export 'events/events.dart';
export 'states/states.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  @override
  MapState get initialState => InitialMapState();

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    if(event is FetchMapEvent) {
      yield LoadingMapState();
      try{
        final geo = GeoJson();
        geo.endSignal.listen((_) => geo.dispose());
        final data = await rootBundle
            .loadString(event.map);
        await geo.parse(data, verbose: true);
        yield LoadedMapState(geoJson: geo);
      } catch(e){
        yield ErrorMapState(errorMessage: e.toString());
      }
    }
  }
}
