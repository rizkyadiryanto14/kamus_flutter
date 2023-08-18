import 'package:flutter/material.dart';
import 'package:kamus_new/api/translation_service_indonesia.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kamus_new/model/translation_model.dart';

class TranslateScreenBImaIndonesia extends StatefulWidget {
  const TranslateScreenBImaIndonesia({Key? key}) : super(key: key);

  @override
  State<TranslateScreenBImaIndonesia> createState() => _TranslateScreenBImaIndonesiaState();
}

class _TranslateScreenBImaIndonesiaState extends State<TranslateScreenBImaIndonesia> {
  FlutterTts flutterTts = FlutterTts();
  late stt.SpeechToText _speech;
  String _text = '';
  bool _isListening = false;
  final TextEditingController _textEditingController = TextEditingController();
  final TranslationServiceIndonesia translationService = TranslationServiceIndonesia();

  String _translationResult = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _textEditingController.addListener(() {
      setState(() {
        _text = _textEditingController.text;
      });
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.greenAccent,
                            Colors.blue,
                          ],
                        )
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2.7,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(100),
                        bottomRight: Radius.circular(100),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          top: -120,
                          child: Center(
                            child: Image.asset(
                              "images/KRongga.png",
                              fit: BoxFit.contain,
                              width: 78,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            "Bima To Indonesia",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 30,
                  margin: EdgeInsets.only(top: 328),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                        heroTag: UniqueKey(),
                        onPressed: _listen,
                        child: Icon(
                          _isListening ? Icons.mic : Icons.mic_none,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Tap to speak for input word or sentence',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 120,
                  margin: EdgeInsets.only(top: 370),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _textEditingController,
                    onChanged: (value) {
                      setState(() {
                        _text = value;
                        //_updateContainerHeight();
                      });
                    },
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 80, vertical: 13),
                      hintText: "Or type with your keyboard",
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 30,
                  margin: EdgeInsets.only(top: 493),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                        heroTag: UniqueKey(),
                        onPressed: _speak,
                        child: Icon(
                            Icons.speaker_phone_sharp
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Tap to speak for input word or sentence',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 120,
                    margin: EdgeInsets.only(top: 530),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _translationResult,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    )
                ),
              ),

              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.only(top: 565),
                  child: ElevatedButton(
                    onPressed: _translateText,
                    child: Text('Translate'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _speak() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(_translationResult);
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'notListening') {
            setState(() {
              _isListening = false;
            });
          }
        },
        onError: (error) {
          print('Speech recognition error: $error');
        },
      );

      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(
          onResult: (result) async {
            if (result.finalResult) {
              setState(() {
                _text = result.recognizedWords;
                _textEditingController.text = _text;
              });
            }
          },
        );
      }
    } else {
      setState(() {
        _isListening = false;
        _speech.stop();
      });
    }
  }

  void _translateText() async {
    if (_text.isNotEmpty) {
      try {
        TranslationModel? translation = await translationService.getTranslationReverse(_text);

        if (translation != null) {
          setState(() {
            _translationResult = translation.data;
          });
        } else {
          setState(() {
            _translationResult = 'Terjadi kesalahan saat menerjemahkan kata.';
          });
        }
      } catch (e) {
        print('Error fetching translation: $e');
        setState(() {
          _translationResult = 'Terjadi kesalahan saat menerjemahkan kata.';
        });
      }
    } else {
      setState(() {
        _translationResult = '';
      });
    }
  }
}
