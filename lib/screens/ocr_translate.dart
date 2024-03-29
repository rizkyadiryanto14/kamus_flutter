import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kamus_new/api/api_cloud.dart';
import 'package:kamus_new/api/translation_service_inggris.dart';
import 'package:kamus_new/model/apicloud_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:kamus_new/model/translation_model.dart';
import 'package:kamus_new/utils/coachmark_desc.dart';

class OcrTranslate extends StatefulWidget {
  const OcrTranslate({Key? key}) : super(key: key);

  @override
  State<OcrTranslate> createState() => _OcrTranslateState();
}

class _OcrTranslateState extends State<OcrTranslate> {
  bool textScanning = false;
  String scannedText = "";
  XFile? _pickedFile;
  CroppedFile? _croppedImageFile;
  TextEditingController _recognizedTextController = TextEditingController();
  final TranslationService translationServiceOcr = TranslationService();
  final ApiCloudService apiCloudService = ApiCloudService();
  String _translationResult = '';
  String _selectedSourceLanguage  = 'Indonesia';
  String _selectedTargetLanguage  = 'English';
  List<String> _sourceLanguages = [
    'Indonesia',
    'English',
    'Bima'
  ];
  List<String> _targetLanguages = [
    'English',
    'Indonesia',
    'Bima'
  ];

  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus> targets = [];
  SharedPreferences? prefs;

  GlobalKey tulisangambar = GlobalKey();
  GlobalKey galery        = GlobalKey();
  GlobalKey camera        = GlobalKey();
  GlobalKey crop          = GlobalKey();


  void _initTarget(){
    targets = [
      TargetFocus(
          identify: "tulisangambar",
          keyTarget: tulisangambar,
          contents: [
            TargetContent(
                align: ContentAlign.bottom,
                builder: (context, controller){
                  return CoachmarkDesc(
                    text: "Ini merupakan fitur untuk melakukan translate gambar",
                    onNext: () {
                      controller.next();
                    },
                    onSkip: () {
                      controller.skip();
                    },
                  );
                }
            )
          ]
      ),
      TargetFocus(
          identify: "galery",
          keyTarget: galery,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
                align: ContentAlign.top,
                builder: (context, controller){
                  return CoachmarkDesc(
                    text: "Tekan tombol ini untuk mengambil gambar dari galeri",
                    onNext: () {
                      controller.next();
                    },
                    onSkip: () {
                      controller.skip();
                    },
                  );
                }
            )
          ]
      ),
      TargetFocus(
          identify: "camera",
          keyTarget: camera,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
                align: ContentAlign.top,
                builder: (context, controller){
                  return CoachmarkDesc(
                    text: "Tekan tombol ini untuk mengambil gambar dari kamera",
                    onNext: () {
                      controller.next();
                    },
                    onSkip: () {
                      controller.skip();
                    },
                  );
                }
            )
          ]
      ),
      TargetFocus(
          identify: "crop",
          keyTarget: crop,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
                align: ContentAlign.top,
                builder: (context, controller){
                  return CoachmarkDesc(
                    text: "Tekan tombol ini untuk memotong gambar",
                    onNext: () {
                      controller.next();
                    },
                    onSkip: () {
                      controller.skip();
                    },
                  );
                }
            )
          ]
      ),
    ];
  }

  void initState(){
    super.initState();
    _checkTutorialShown();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue, Colors.green],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
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
                      child: Container(
                        key: tulisangambar,
                        child: Text(
                          "Translate Gambar",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      margin: EdgeInsets.only(top: 160, left: 50),
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButton<String>(
                                  value: _selectedSourceLanguage,
                                  onChanged: (newValue){
                                    setState(() {
                                      _selectedSourceLanguage = newValue!;
                                    });
                                  },
                                  items: _sourceLanguages.map((lang){
                                    return DropdownMenuItem<String>(
                                      value: lang,
                                      child: Text(
                                          lang
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  String temp = _selectedSourceLanguage;
                                  setState(() {
                                    _selectedSourceLanguage = _selectedTargetLanguage;
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
                                    onChanged: (newValue){
                                      setState(() {
                                        _selectedTargetLanguage = newValue!;
                                      });
                                    },
                                    items: _targetLanguages.map((lang){
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
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              if (textScanning) CircularProgressIndicator(),
              if (!textScanning && _croppedImageFile == null)
                Container(
                  width: 200,
                  height: 200,
                  color: Colors.grey[300],
                ),
              if (_croppedImageFile != null)
                Image.file(
                  File(_croppedImageFile!.path),
                  width: 300,
                  height: 300,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.grey,
                      backgroundColor: Colors.white,
                      shadowColor: Colors.grey[400],
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(8.0)),
                    ),
                    onPressed: () {
                      getImage(ImageSource.gallery);
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.image,
                          size: 20,
                          color: Colors.blue,
                          key: galery,
                        ),
                        Text(
                          "Gallery",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.grey,
                      backgroundColor: Colors.white,
                      shadowColor: Colors.grey[400],
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(8.0)),
                    ),
                    onPressed: () {
                      getImage(ImageSource.camera);
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.black,
                          key: camera,
                        ),
                        Text(
                          "Camera",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
              Container(
                width: 200,
                height: MediaQuery.of(context).size.height / 2.5,
                margin: EdgeInsets.only(top: 10, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                ),
                child: Center(
                  child: Text(
                    //_translationResult,
                    _translationResult,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      textScanning = true;
      //imageFile = pickedFile;
      setState(() {
        _pickedFile = pickedFile;
        _cropImage(_pickedFile!);
      });
    }
  }

  Future<void> _cropImage(XFile pickedFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
          presentStyle: CropperPresentStyle.dialog,
          boundary: const CroppieBoundary(
            width: 520,
            height: 520,
          ),
          viewPort:
          const CroppieViewPort(width: 480, height: 480, type: 'circle'),
          enableExif: true,
          enableZoom: true,
          showZoomer: true,
        ),
      ],
    );
    if (croppedFile != null) {
      setState(() {
        _croppedImageFile = croppedFile;
        getRecognisedText(croppedFile);
      });
    }
    }

  void getRecognisedText(CroppedFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();

    scannedText = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + "\n";
        _recognizedTextController.text = scannedText;
      }
    }
    _translateText(scannedText);
    textScanning = false;
    setState(() {});
  }

  void _translateText(String textToTranslate) async {
    if (textToTranslate.isNotEmpty) {
      if(_selectedSourceLanguage == 'Bima' && _selectedTargetLanguage == 'English'){
        try {
          TranslationModel? translations = await translationServiceOcr.getTranslation(textToTranslate);
          print(translations?.data);
          if (translations != null) {
            ApiCloudModel? translationText = await apiCloudService.getApiCloud(translations.data, 'id', 'en');
            if (translationText != null) {
              setState(() {
                _translationResult = translationText.data?.translatedText ?? 'No translation result.';
              });
            } else {
              setState(() {
                _translationResult = 'An error occurred while fetching data from ApiCloud.';
              });
            }
          } else {
            setState(() {
              _translationResult = 'An error occurred while translating the text.';
            });
          }
        } catch (e) {
          print('Error fetching translation: $e');
          setState(() {
            _translationResult = 'An error occurred while translating the text.';
          });
        }
      }else if(_selectedSourceLanguage == 'English' && _selectedTargetLanguage == 'Bima'){
        try {
          TranslationModel? translation = await translationServiceOcr.getTranslation(textToTranslate);
          if (translation != null) {
            ApiCloudModel? translationText = await apiCloudService.getApiCloud(translation.data, 'id', 'en');
            if (translationText != null) {
              setState(() {
                _translationResult = translationText.data?.translatedText ?? 'Tidak ada hasil terjemahan.';
              });
            } else {
              setState(() {
                _translationResult = 'Terjadi kesalahan saat mendapatkan data dari ApiCloud.';
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
      }else if(_selectedSourceLanguage == 'Indonesia' && _selectedTargetLanguage == 'English'){
        try {
          ApiCloudModel? translationText = await apiCloudService.getApiCloud(textToTranslate, 'id', 'en');
          if(translationText != null){
            setState(() {
              _translationResult = translationText.data?.translatedText ?? 'Tidak ada hasil terjemahan.';
            });
          }else {
            setState(() {
              _translationResult = "Terjadi kesalahan saat mendapatkan Api CLoud";
            });
          }
        }catch(e) {
          print('Error fetching translation: $e');
          setState(() {
            _translationResult = 'Terjadi kesalahan saat menerjemahkan kata.';
          });
        }
      }else if(_selectedSourceLanguage == 'English' && _selectedTargetLanguage == 'Indonesia'){
        try{
          ApiCloudModel? translationText = await apiCloudService.getApiCloud(textToTranslate, 'en', 'id');
          if(translationText != null){
            setState(() {
              _translationResult = translationText.data?.translatedText ?? 'Tidak ada hasil terjemahan';
            });
          }else {
            setState(() {
              _translationResult = "Terjadi kesalahan saat mendapatkan APiCloud";
            });
          }
        }catch(e){
          print('Error fetching translation: $e');
          setState(() {
            _translationResult = 'Terjadi kesalahan saat menerjemahkan kata.';
          });
        }
      }else {
        setState(() {
          _translationResult = "Translate Tidak Ditemukan";
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
    final shown = prefs.getBool('tutorialShownOcr') ?? false;
    if(!shown){
      _showTutorialCoachMark();
    }
  }

  void _saveTutorialShown() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('tutorialShownOcr', true);
  }

  void _showTutorialCoachMark() {
    _initTarget();
    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      onFinish: () {
        _saveTutorialShown();
      }
    );
    tutorialCoachMark?.show(context: context);
  }
}