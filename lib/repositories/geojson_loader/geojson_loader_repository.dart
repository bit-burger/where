import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geojson/geojson.dart';
import 'geojson_loader_repository_contract.dart';
import 'package:flutter/services.dart' show rootBundle;

class GeojsonLoaderRepository implements IGeojsonLoaderRepository {
  static final _geojsonRegExp = RegExp("\\.geojson\$");

  final Map<String, List<Polygon>> _cachedGeojson;
  final Color borderColor;
  final Color color;

  GeojsonLoaderRepository({
    required this.color,
    required this.borderColor,
  }) : _cachedGeojson = {};

  @override
  Future<List<String>> allGeojson() async {
    final rawAssetsList = await rootBundle.loadString('AssetManifest.json');
    final assetMap = jsonDecode(rawAssetsList) as Map<String, dynamic>;
    final assetList = assetMap.keys
        .map((rawAssetName) => Uri.parse(rawAssetName).pathSegments)
        .where((path) => path.length == 3)
        .where((path) => path[0] == "assets" && path[1] == "geojson")
        .map((assetPath) => assetPath[2])
        .where((assetName) => assetName.contains(_geojsonRegExp))
        .map((assetName) => assetName.substring(0, assetName.length - 8))
        .toList(growable: false);
    return assetList;
  }

  @override
  Future<List<Polygon>> getGeojson(String name) async {
    final cachedGeojson = _cachedGeojson[name];
    if (cachedGeojson != null) {
      return cachedGeojson;
    }
    final geoJson = await _getGeojson(name);
    _cachedGeojson[name] = geoJson;
    return geoJson;
  }

  @override
  void preloadGeojson(String name) async {
    if (_cachedGeojson.containsKey(name)) return;
    _cachedGeojson[name] = await _getGeojson(name);
  }

  Future<List<Polygon>> _getGeojson(String name) async {
    final geojson = GeoJson();
    final data = await rootBundle.loadString('assets/geojson/$name.geojson');
    await geojson.parse(data, verbose: false, disableStream: true);
    final geojsonPolygons = <GeoJsonPolygon>[];
    for (final geojsonMultiPolygon in geojson.multiPolygons) {
      geojsonPolygons.addAll(geojsonMultiPolygon.polygons);
    }
    geojsonPolygons.addAll(geojson.polygons);
    return geojsonPolygons
        .map((geojsonPolygon) => _geojsonToPolygon(geojsonPolygon))
        .toList(growable: false);
  }

  Polygon _geojsonToPolygon(GeoJsonPolygon geojsonPolygon) {
    return Polygon(
      label: geojsonPolygon.name,
      points: geojsonPolygon.geoSeries.first.toLatLng(ignoreErrors: true),
      holePointsList: geojsonPolygon.geoSeries.length == 1
          ? null
          : geojsonPolygon.geoSeries
              .sublist(1)
              .map((geoSerie) => geoSerie.toLatLng(ignoreErrors: true))
              .toList(growable: false),
      color: color,
      borderStrokeWidth: 2,
      borderColor: borderColor,
    );
  }
}
