import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:where/repositories/geojson_loader/geojson_loader_repository.dart';
import 'package:where/repositories/geojson_loader/geojson_loader_repository_contract.dart';
import 'package:where/where.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  GetIt.I.registerSingleton<IGeojsonLoaderRepository>(
    GeojsonLoaderRepository(color: Colors.blue, borderColor: Colors.red),
  );

  GetIt.I.get<IGeojsonLoaderRepository>().getGeojson("world_map_low_quality");

  runApp(const Where());
}
