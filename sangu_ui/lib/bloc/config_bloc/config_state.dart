import 'package:equatable/equatable.dart';
import 'package:sangu/model/config.dart';

abstract class ConfigState extends Equatable {
  const ConfigState();
}

class NotLoaded extends ConfigState {
  @override
  List<Object> get props => [];
}

class Loaded extends ConfigState {
  final Config config;

  Loaded({this.config});

  @override
  List<Object> get props => [config];

  @override
  String toString() => "Loaded { $config }";
}
