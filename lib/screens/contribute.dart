import 'package:flutter/material.dart';
import 'package:kamus_new/api/saran_kata_service.dart';
import 'package:kamus_new/model/saran_kata_model.dart';

class Contribute extends StatefulWidget {
  const Contribute({Key? key}) : super(key: key);

  @override
  State<Contribute> createState() => _ContributeState();
}

class _ContributeState extends State<Contribute> {
  final TextEditingController _suggestionController = TextEditingController();

  String _selectedSourceLanguage = 'Bahasa Indonesia';
  String _selectedTargetLanguage = 'English';
  List<String> _sourceLanguages = ['Bahasa Indonesia', 'English', 'Bima'];

  List<String> _targetLanguages = ['English', 'Bahasa Indonesia', 'Bima'];

  final SaraKataService _saranKataService = SaraKataService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.teal,
                      Colors.lightBlue,
                    ],
                  ),
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
                        "Saran Kata",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2.7 - 20),
                  padding: EdgeInsets.symmetric(vertical: 17),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButton<String>(
                              value: _selectedSourceLanguage,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedSourceLanguage = newValue!;
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
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: DropdownButton<String>(
                              value: _selectedTargetLanguage,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedTargetLanguage = newValue!;
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
                      SizedBox(height: 16),
                      TextField(
                        controller: _suggestionController,
                        decoration: InputDecoration(
                          labelText: 'Masukkan saran kata',
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: InsertSaranKata,
                        child: Text('Kirim Saran'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _suggestionController.dispose();
    super.dispose();
  }

  void InsertSaranKata() async {
    String suggestion = _suggestionController.text;
    String sourceLang = _selectedSourceLanguage;
    String targetLang = _selectedTargetLanguage;
    print(targetLang);

    SaranKataModel? result = await _saranKataService.getSaranKata(
        sourceLang, targetLang, suggestion);

    if (result != null && result.status) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Berhasil'),
          content: Text('Saran kata telah di simpan : $suggestion'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      _suggestionController.clear();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Gagal'),
          content: Text('Gagal menyimpan saran kata.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
