import 'package:equatable/equatable.dart';

abstract class ConfigEvent extends Equatable {
  const ConfigEvent();
}

class LoadConfig extends ConfigEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => "LoadConfig";
}
