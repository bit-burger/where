import 'package:flutter_map/flutter_map.dart';

abstract class IGeojsonLoaderRepository {
  Future<List<String>> allGeojson();
  Future<List<Polygon>> getGeojson(String name);
  void preloadGeojson(String name);
}
