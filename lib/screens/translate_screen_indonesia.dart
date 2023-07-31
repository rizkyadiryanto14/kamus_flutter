import 'package:flutter/material.dart';
import 'package:kamus_new/api/translation_service.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:kamus_new/model/translation_model.dart';


class TranslateScreenIndonesia extends StatefulWidget {
  const TranslateScreenIndonesia({Key? key}) : super(key: key);

  @override
  State<TranslateScreenIndonesia> createState() => _TranslateScreenIndonesiaState();
}

class _TranslateScreenIndonesiaState extends State<TranslateScreenIndonesia> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  final TextEditingController _textEditingController = TextEditingController();
  final TranslationService translationService = TranslationService();

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
      body: Container(
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
                    color: Color.fromARGB(255, 233, 98, 71),
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
                            "images/kamus.png",
                            fit: BoxFit.contain,
                            width: 90,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Indonesia To English",
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
                      onPressed: _listen,
                      child: Icon(_isListening ? Icons.mic : Icons.mic_none),
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
                height: 30,
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
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 80, vertical: 13),
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
                margin: EdgeInsets.only(top: 420),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    _translationResult,
                    style: TextStyle(
                      fontSize: 16
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(top: 160),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Translate'),
                ),
              ),
            )
          ],
        ),
      ),
    );
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
          onResult: (result) {
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
}

