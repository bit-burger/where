import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import 'package:where/repositories/geojson_loader/geojson_loader_repository_contract.dart';

class TestMap extends StatefulWidget {
  const TestMap({super.key});

  @override
  State<TestMap> createState() => _TestMapState();
}

class _TestMapState extends State<TestMap> {
  late final Future<List<Polygon>> _mapPolygons;

  @override
  void initState() {
    _mapPolygons = GetIt.I
        .get<IGeojsonLoaderRepository>()
        .getGeojson("world_map_low_quality");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Polygon>>(
      future: _mapPolygons,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        return SizedBox.expand(
          child: FlutterMap(
            layers: [
              PolygonLayerOptions(
                polygonCulling: true,
                polygons: snapshot.requireData,
              ),
            ],
            options: MapOptions(
              center: LatLng(0.0, 0.0),
              zoom: 5,
              maxBounds: LatLngBounds(
                LatLng(90, 180),
                LatLng(-80, -180),
              ),
              interactiveFlags: InteractiveFlag.all &
                  ~InteractiveFlag.rotate &
                  ~InteractiveFlag.flingAnimation,
            ),
          ),
        );
      },
    );
  }
}
