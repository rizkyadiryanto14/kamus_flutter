import 'package:flutter/material.dart';

class Contribute extends StatefulWidget {
  const Contribute({super.key});

  @override
  State<Contribute> createState() => _ContributeState();
}

class _ContributeState extends State<Contribute> {
  final TextEditingController _suggestionController = TextEditingController();
  String _selectedSourceLanguage = 'Bahasa Indonesia';
  String _selectedTargetLanguage = 'English';
  List<String> _sourceLanguages = [
    'Bahasa Indonesia',
    'English',
    'Bima'
  ];
  List<String> _targetLanguages = [
    'English',
    'Bahasa Indonesia',
    'Bima'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saran Kata'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        child: Text(lang),
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
                  icon: Icon(Icons.swap_horiz),
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
                        child: Text(lang),
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
              onPressed: () {
                String suggestion = _suggestionController.text;
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Berhasil'),
                    content: Text('Saran kata telah disimpan: $suggestion'),
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
                // Reset textfield setelah sukses mengirimkan saran kata
                _suggestionController.clear();
              },
              child: Text('Kirim Saran'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _suggestionController.dispose();
    super.dispose();
  }
}
