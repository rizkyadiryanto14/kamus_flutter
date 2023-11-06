import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kamus_new/api/api_cloud.dart';
import 'package:kamus_new/api/translation_service_inggris.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:kamus_new/model/translation_model.dart';
import 'package:kamus_new/model/apicloud_model.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kamus_new/api/api_cloud_reverse.dart';
import 'package:kamus_new/api/translation_service_indonesia.dart';
import 'package:flutter/services.dart';
import 'package:kamus_new/utils/coachmark_desc.dart';

class TranslateScreen extends StatefulWidget {
  const TranslateScreen({Key? key}) : super(key: key);

  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  FlutterTts? flutterTts;
  stt.SpeechToText? _speech;
  String _text = '';
  bool _isListening = false;
  final TextEditingController _textEditingController = TextEditingController();
  final TranslationService translationService = TranslationService();
  final ApiCloudService apiCloudService = ApiCloudService();
  final TranslationServiceIndonesia translationServiceIndonesia =
      TranslationServiceIndonesia();
  final ApiCloudServiceReverse apiCloudServiceReverse =
      ApiCloudServiceReverse();
  String _translationResult = '';
  String _selectedSourceLanguage = 'Indonesia';
  String _selectedTargetLanguage = 'English';
  List<String> _sourceLanguages = ['Indonesia', 'English', 'Bima'];
  List<String> _targetLanguages = ['English', 'Indonesia', 'Bima'];

  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus> targets = [];

  SharedPreferences? prefs;
  GlobalKey spechtotext = GlobalKey();
  GlobalKey input = GlobalKey();
  GlobalKey output = GlobalKey();
  GlobalKey microphone = GlobalKey();
  GlobalKey Buttontranslate = GlobalKey();
  GlobalKey sourceLang = GlobalKey();
  GlobalKey targetlang = GlobalKey();
  GlobalKey reverse = GlobalKey();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _checkTutorialShown();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    flutterTts?.stop();
    _speech?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.blue,
                Colors.teal,
              ],
            ),
          ),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
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
                        "Translate Pages",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      margin: EdgeInsets.only(top: 140, left: 50),
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButton<String>(
                                  value: _selectedSourceLanguage,
                                  key: sourceLang,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedSourceLanguage = newValue!;
                                      print(_selectedSourceLanguage);
                                    });
                                  },
                                  items: _sourceLanguages.map((lang) {
                                    return DropdownMenuItem<String>(
                                      value: lang,
                                      child: Text(
                                        lang,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              IconButton(
                                key: reverse,
                                onPressed: () {
                                  String temp = _selectedSourceLanguage;
                                  setState(() {
                                    _selectedSourceLanguage =
                                        _selectedTargetLanguage;
                                    _selectedTargetLanguage = temp;
                                  });
                                },
                                icon: Icon(
                                  Icons.swap_horiz,
                                  color: Colors.black,
                                ),
                              ),
                              Expanded(
                                child: DropdownButton<String>(
                                  value: _selectedTargetLanguage,
                                  key: targetlang,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedTargetLanguage = newValue!;
                                      print(_selectedTargetLanguage);
                                    });
                                  },
                                  items: _targetLanguages.map((lang) {
                                    return DropdownMenuItem<String>(
                                      value: lang,
                                      child: Text(
                                        lang,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 30,
                margin: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      heroTag: UniqueKey(),
                      onPressed: _listen,
                      child: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        key: spechtotext,
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
              Container(
                key: input,
                width: MediaQuery.of(context).size.width * 0.8,
                height: 120,
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(1),
                  child: Column(
                    children: [
                      TextField(
                        controller: _textEditingController,
                        onChanged: (value) {
                          setState(() {
                            _text = value;
                          });
                        },
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 80, vertical: 13),
                          hintText: "Or type with your keyboard",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 30,
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      heroTag: UniqueKey(),
                      onPressed: _speak,
                      child: Icon(
                        Icons.speaker_phone_sharp,
                        key: microphone,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Tap to listen to the translated results',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Container(
                key: output,
                width: MediaQuery.of(context).size.width * 0.8,
                height: 120,
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              _translationResult,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: IconButton(
                        icon: Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: _translationResult));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Copied to clipboard")),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  onPressed: _translateText,
                  child: Text('Translate', key: Buttontranslate),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _speak() async {
    await flutterTts!.setLanguage("en-US");
    await flutterTts!.setPitch(1.0);
    await flutterTts!.setSpeechRate(0.5);
    // Add input validation and sanitization
    var safeText = _sanitizeInput(_translationResult);

    await flutterTts!.speak(safeText);
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech!.initialize(
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
        _speech!.listen(
          onResult: (result) async {
            if (result.finalResult) {
              setState(() {
                _text = result.recognizedWords;
                _textEditingController.text = _sanitizeInput(_text);
              });
            }
          },
        );
      }
    } else {
      setState(() {
        _isListening = false;
        _speech!.stop();
      });
    }
  }

  // Add input sanitization
  String _sanitizeInput(String input) {
    // sanitize and validate input here
    return input;
  }

  void _translateText() async {
    if (_text.isNotEmpty) {
      if (_selectedSourceLanguage == 'English' &&
          _selectedTargetLanguage == 'Bima') {
        try {
          ApiCloudModel? translationText =
              await apiCloudServiceReverse.getApiCloudReverse(_text);
          if (translationText != null) {
            String translatedText = translationText.data?.translatedText ?? '';
            TranslationModel? translation = await translationServiceIndonesia
                .getTranslationReverse(translatedText);
            if (translationText != null) {
              setState(() {
                _translationResult = translation!.data;
                print(_translationResult);
              });
            } else {
              setState(() {
                _translationResult =
                    'Terjadi kesalahan saat mendapatkan data dari ApiCloud.';
              });
            }
          }
        } catch (e) {
          print('Error Fetching translation : $e');
          setState(() {
            _translationResult = 'Terjadi kesalahan saat menerjemahkan kata.';
          });
        }
      } else if (_selectedSourceLanguage == 'Bima' &&
          _selectedTargetLanguage == 'English') {
        try {
          TranslationModel? translation =
              await translationService.getTranslation(_text);
          if (translation != null) {
            ApiCloudModel? translationText =
                await apiCloudService.getApiCloud(translation.data, 'id', 'en');
            if (translationText != null) {
              setState(() {
                _translationResult = translationText.data?.translatedText ??
                    'Tidak ada hasil terjemahan.';
              });
            } else {
              setState(() {
                _translationResult =
                    'Terjadi kesalahan saat mendapatkan data dari ApiCloud.';
              });
            }
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
      } else if (_selectedSourceLanguage == 'Indonesia' &&
          _selectedTargetLanguage == 'English') {
        try {
          ApiCloudModel? translationText =
              await apiCloudService.getApiCloud(_text, 'id', 'en');
          if (translationText != null) {
            setState(() {
              _translationResult = translationText.data?.translatedText ??
                  'Tidak ada hasil terjemahan.';
            });
          } else {
            setState(() {
              _translationResult =
                  "Terjadi kesalahan saat mendapatkan Api CLoud";
            });
          }
        } catch (e) {
          print('Error fetching translation: $e');
          setState(() {
            _translationResult = 'Terjadi kesalahan saat menerjemahkan kata.';
          });
        }
      } else if (_selectedSourceLanguage == 'English' &&
          _selectedTargetLanguage == 'Indonesia') {
        try {
          ApiCloudModel? translationText =
              await apiCloudService.getApiCloud(_text, 'en', 'id');
          if (translationText != null) {
            setState(() {
              _translationResult = translationText.data?.translatedText ??
                  'Tidak ada hasil terjemahan';
            });
          } else {
            setState(() {
              _translationResult =
                  "Terjadi kesalahan saat mendapatkan APiCloud";
            });
          }
        } catch (e) {
          print('Error fetching translation: $e');
          setState(() {
            _translationResult = 'Terjadi kesalahan saat menerjemahkan kata.';
          });
        }
      } else if (_selectedSourceLanguage == 'Bima' &&
          _selectedTargetLanguage == 'Indonesia') {
        try {
          TranslationModel? translation =
              await translationService.getTranslation(_text);
          if (translation != null) {
            setState(() {
              _translationResult = translation.data;
            });
          } else {
            _translationResult = "Translate tidak ditemukan";
          }
        } catch (e) {
          print('Error fetching translation: $e');
          setState(() {
            _translationResult = 'Terjadi kesalahan saat menerjemahkan kata.';
          });
        }
      } else if (_selectedSourceLanguage == 'Indonesia' &&
          _selectedTargetLanguage == 'Bima') {
        try {
          TranslationModel? translation =
              await translationServiceIndonesia.getTranslationReverse(_text);
          if (translation != null) {
            setState(() {
              _translationResult = translation.data;
            });
          } else {
            setState(() {
              _translationResult = "Translate tidak ditemukan";
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
          _translationResult = 'Bahasa Tidak Ditemukan';
        });
      }
    } else {
      setState(() {
        _translationResult = '';
      });
    }
  }

  Future<void> _checkTutorialShown() async {
    final prefs = await SharedPreferences.getInstance();
    final shown = prefs.getBool('tutorialShown') ?? false;

    if (!shown) {
      _showTutorialCoachMark();
    }
  }

  void _saveTutorialShown() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'tutorialShown';

    prefs.setBool(key, true);
  }

  void _showTutorialCoachMark() {
    _initTarget();
    tutorialCoachMark = TutorialCoachMark(
        targets: targets,
        onFinish: () {
          _saveTutorialShown();
        });
    tutorialCoachMark?.show(context: context);
  }

  void _initTarget() {
    targets = [
      TargetFocus(identify: "sourceLang", keyTarget: sourceLang, contents: [
        TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text:
                    "Tekan tombol dropdown berikut untuk memilih sumber bahasa",
                onNext: () {
                  controller.next();
                },
                onSkip: () {
                  controller.skip();
                },
              );
            }),
      ]),
      TargetFocus(identify: "reverse", keyTarget: reverse, contents: [
        TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text:
                    "Tekan icon berikut untuk membalik sumber dan tujuan bahasa",
                onNext: () {
                  controller.next();
                },
                onSkip: () {
                  controller.skip();
                },
              );
            })
      ]),
      TargetFocus(identify: "targetLang", keyTarget: targetlang, contents: [
        TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: "Tekan dropdown berikut untuk memilih target bahasa",
                onNext: () {
                  controller.next();
                },
                onSkip: () {
                  controller.skip();
                },
              );
            })
      ]),
      TargetFocus(identify: "spechtotext", keyTarget: spechtotext, contents: [
        TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: "Tekan tombol microphone untuk merekan suara",
                onNext: () {
                  controller.next();
                },
                onSkip: () {
                  controller.skip();
                },
              );
            })
      ]),
      TargetFocus(
          identify: "input",
          keyTarget: input,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
                align: ContentAlign.bottom,
                builder: (context, controller) {
                  return CoachmarkDesc(
                    text: """
Ketik pada kotak box berikut untuk mengambil inputan dari keyboard, hasil dari pesan suara akan tampil pada bagian ini juga """,
                    onNext: () {
                      controller.next();
                    },
                    onSkip: () {
                      controller.skip();
                    },
                  );
                })
          ]),
      TargetFocus(identify: "microphone", keyTarget: microphone, contents: [
        TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: "Tekan tombol berikut untuk membunyikan hasil translate",
                onNext: () {
                  controller.next();
                },
                onSkip: () {
                  controller.skip();
                },
              );
            })
      ]),
      TargetFocus(
          identify: "output",
          keyTarget: output,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
                align: ContentAlign.top,
                builder: (context, controller) {
                  return CoachmarkDesc(
                    text: "Hasil Translate akan tampil pada bagian ini",
                    onNext: () {
                      controller.next();
                    },
                    onSkip: () {
                      controller.skip();
                    },
                  );
                })
          ]),
      TargetFocus(
          identify: "Buttontranslate",
          keyTarget: Buttontranslate,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
                align: ContentAlign.top,
                builder: (context, controller) {
                  return CoachmarkDesc(
                    text: "Tekan tombol ini untuk memulai translate",
                    onNext: () {
                      controller.next();
                    },
                    onSkip: () {
                      controller.skip();
                    },
                  );
                })
          ]),
    ];
  }
}
