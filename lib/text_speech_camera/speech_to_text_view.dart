import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sound_stream/sound_stream.dart';
import 'package:google_speech/google_speech.dart';


import 'language.dart';

class SpeechToTextView extends StatefulWidget {
  final VoidCallback onRecordPressed;
  final VoidCallback onClearPressed;
  final VoidCallback onStopPressed;
  final SpeechToTextCallback onDonePressed;

  const SpeechToTextView(
      {Key? key,
    required  this.onRecordPressed,
    required  this.onClearPressed,
     required this.onStopPressed,
     required this.onDonePressed})
      : super(key: key);

  @override
  _SpeechToTextViewState createState() => _SpeechToTextViewState();
}

class _SpeechToTextViewState extends State<SpeechToTextView> {
  final RecorderStream _recorder = RecorderStream();
  bool _recognizing = false;
  String _lastWords = '';
  StreamSubscription<List<int>>? _audioStreamSubscription;
  BehaviorSubject<List<int>>? _audioStream;
  String _lastError = '';
  Language _currentLanguage = Language.english;
  List<Language> _languages = [Language.english, Language.estonian];

  @override
  Widget build(BuildContext context) {
    return buildBody();
  }

  Widget buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6.0),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 12.0,
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Center(
                child: _lastWords.isNotEmpty
                    ? creatorWords()
                    : _lastError.isEmpty
                        ? creatorHint()
                        : Text(_lastError,
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: Colors.redAccent),
                            textAlign: TextAlign.center)),
            Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DropdownButton(
                      onChanged: (selectedVal) => _switchLang(selectedVal),
                      value: _currentLanguage.code,
                      items: _languages
                          .map(
                            (localeName) => DropdownMenuItem(
                              value: localeName.code,
                              child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.55,
                                  child: Text(
                                    localeName.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  )),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ))
          ]),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FloatingActionButton(
                  mini: true,
                  heroTag: 'tag1',
                  backgroundColor: Colors.deepOrange,
                  onPressed: () {
                    setState(() {
                      _lastWords = '';
                    });
                    if (widget.onClearPressed != null) {
                      widget.onClearPressed();
                    }
                  },
                  child: const Icon(Icons.cancel),
                ),
                FloatingActionButton(
                  onPressed: () {
                    if (_recognizing) {
                      if (widget.onStopPressed != null) {
                        widget.onStopPressed();
                      }
                      _stopListening();
                    } else {
                      if (widget.onRecordPressed != null) {
                        widget.onRecordPressed();
                      }
                      _startListening();
                    }
                  },
                  heroTag: 'tag2',
                  backgroundColor: Colors.pink,
                  child: _recognizing
                      ? const Icon(
                          Icons.stop,
                          color: Colors.black,
                        )
                      : const Icon(Icons.fiber_manual_record),
                ),
                FloatingActionButton(
                  mini: true,
                  heroTag: 'tag3',
                  backgroundColor: complete ? Colors.greenAccent : Colors.grey,
                  onPressed: () {
                    if (complete) {
                      _stopListening();
                      if (widget.onDonePressed != null) {
                        widget.onDonePressed(_lastWords);
                      }
                    }
                  },
                  child: const Icon(Icons.done),
                ),
              ],
            )),
      ],
    );
  }

  void _startListening() async {
    _audioStream = BehaviorSubject<List<int>>();
    _audioStreamSubscription = _recorder.audioStream.listen((event) {
      _audioStream!.add(event);
    });

    await _recorder.start();

    setState(() {
      _recognizing = true;
    });
    // TODO Fill in your own key
    final serviceAccount = ServiceAccount.fromString(
        await rootBundle.loadString("ADD YOUR KEY HERE"));
    final speechToText = SpeechToText.viaServiceAccount(serviceAccount);
    final config = _getConfig();

    final responseStream = speechToText.streamingRecognize(
        StreamingRecognitionConfig(config: config, interimResults: true),
        _audioStream!);

    responseStream.listen((data) {
      setState(() {
        _lastWords =
            data.results.map((e) => e.alternatives.first.transcript).join('\n');
      });
    }, onDone: () {
      setState(() {
        _recognizing = false;
      });
    }, onError: (e) {
      setState(() {
        _recognizing = false;
        _lastError = e.toString();
      });
      print('Speech response error:$e');
    });
  }

  RecognitionConfig _getConfig() => RecognitionConfig(
      encoding: AudioEncoding.LINEAR16,
      enableAutomaticPunctuation: true,
      sampleRateHertz: 16000,
      languageCode: _currentLanguage.code);

  void _stopListening() async {
    await _recorder.stop();
    await _audioStreamSubscription?.cancel();
    await _audioStream?.close();
    setState(() {
      _recognizing = false;
    });
  }

  void _switchLang(selectedVal) {
    if (selectedVal is String) {
      setState(() {
        _currentLanguage =
            _languages.firstWhere((element) => element.code == selectedVal);
      });
      // ignore: avoid_print
      print(selectedVal);
    }
  }

  bool get complete {
    return _lastWords.isNotEmpty;
  }

  Widget creatorHint() {
    return Text(
      'Welcome! Press the red button to record something!',
      style: Theme.of(context)
          .textTheme
          .headline6!
          .copyWith(fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget creatorWords() {
    return Text(
      _lastWords,
      style: Theme.of(context)
          .textTheme
          .headline6!
          .copyWith(fontWeight: FontWeight.bold, color: Colors.blue),
      textAlign: TextAlign.center,
      overflow: TextOverflow.visible,
    );
  }
}

typedef SpeechToTextCallback = void Function(String spokenWords);
