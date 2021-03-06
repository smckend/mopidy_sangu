import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:sangu/bloc/config_bloc/bloc.dart';
import 'package:sangu/client/config_client.dart';
import 'package:sangu/model/config.dart';

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  final ConfigClient configClient;

  ConfigBloc({this.configClient}) : super(NotLoaded());

  @override
  Stream<ConfigState> mapEventToState(
    ConfigEvent event,
  ) async* {
    if (event is LoadConfig) {
      yield* _mapLoadConfigToState();
    }
  }

  Stream<ConfigState> _mapLoadConfigToState() async* {
    var rawConfig = await configClient.getConfig();
    Config config = Config.fromJson(rawConfig);
    print("Loaded Config: $config");
    yield Loaded(config: config);
  }
}
