import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sangu/bloc/audio_bloc/bloc.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  AudioPlayer _player;
  StreamSubscription _audioPlayerEventsSubscription;
  String _url;

  @override
  AudioState get initialState => NoAudio();

  @override
  Stream<AudioState> mapEventToState(
    AudioEvent event,
  ) async* {
    if (event is StartAudioStream) {
      yield* _mapStartStreamToEvent(event);
    } else if (event is LoadAudio) {
      yield* _mapLoadAudioToState(event);
    } else if (event is MuteAudio) {
      yield* _mapMuteAudioToState(event);
    } else if (event is UnmuteAudio) {
      yield* _mapUnmuteAudioToState(event);
    }
  }

  Stream<AudioState> _mapStartStreamToEvent(StartAudioStream event) async* {
    _url = event.url;
    if (_url == null || _url.isEmpty) {
      yield AudioFailed();
      return;
    }

    await _player?.dispose();
    _audioPlayerEventsSubscription?.cancel();

    _player = AudioPlayer();
    _audioPlayerEventsSubscription = _player.playbackStateStream.listen(
      (state) {
        if (state == AudioPlaybackState.completed) {
          Future.delayed(const Duration(seconds: 2),
              () => add(StartAudioStream(url: event.url)));
        }
      },
    );
  }

  Stream<AudioState> _mapLoadAudioToState(LoadAudio event) async* {
    if (_url == null || _url.isEmpty) return;

    yield AudioLoading();
    yield* await _player.setUrl(_url).then(
      (duration) async* {
        print("Loaded audio duration: $duration");
        yield AudioMuted();
      },
    ).catchError(
      (error) async* {
        print("Error occurred during audio setup: $error. Trying anyway.");
        yield AudioFailed();
      },
    );
  }

  Stream<AudioState> _mapMuteAudioToState(MuteAudio event) async* {
    _player.setVolume(0);
    if (_player.playbackState != AudioPlaybackState.playing) _player.play();
    yield AudioMuted();
  }

  Stream<AudioState> _mapUnmuteAudioToState(UnmuteAudio event) async* {
    _player.setVolume(0.85);
    if (_player.playbackState != AudioPlaybackState.playing) _player.play();
    yield AudioUnmuted();
  }

  @override
  Future<void> close() {
    _audioPlayerEventsSubscription?.cancel();
    _player?.dispose();
    return super.close();
  }
}
