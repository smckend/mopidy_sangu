import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:sangu/bloc/config_bloc/bloc.dart';
import 'package:sangu/client/config_client.dart';
import 'package:sangu/model/config.dart';

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  final ConfigClient configClient;

  ConfigBloc({this.configClient});

  @override
  ConfigState get initialState => NotLoaded();

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
    print("Got config: $config");
    yield Loaded(config: config);
  }
}
