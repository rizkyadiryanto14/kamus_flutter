import 'package:flutter/material.dart';
import 'package:kamus_new/screens/contribute.dart';
import 'package:kamus_new/screens/ocr_translate.dart';
import 'package:kamus_new/screens/translate_screen_bima.dart';
import 'package:kamus_new/screens/translate_screen_indonesia.dart';
import 'package:kamus_new/screens/translate_screen_inggris.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  List pages = [
    TranslateScreenEnglish(),
    TranslateScreenIndonesia(),
    TranslateScreenBima(),
    Contribute(),
    OcrTranslate()
  ];
  int currentIndex = 0;
  void onTap(int index){
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        // unselectedFontSize: 0,
        // selectedFontSize: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        onTap: onTap,
        currentIndex: currentIndex,
        selectedItemColor: Colors.black54,
        unselectedItemColor: Colors.grey.withOpacity(0.5),
        showUnselectedLabels: false,
        showSelectedLabels: true,
        elevation: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'English'),
          BottomNavigationBarItem(icon: Icon(Icons.ac_unit_rounded), label: 'Indonesia'),
          BottomNavigationBarItem(icon: Icon(Icons.translate), label: 'Bima'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Contribut'),
          BottomNavigationBarItem(icon: Icon(Icons.image_outlined), label: 'OCR')
        ],
      ),
    );
  }
}
