import 'package:flutter/material.dart';
import 'package:kamus_new/screens/contribute.dart';
import 'package:kamus_new/screens/ocr_translate.dart';
import 'package:kamus_new/screens/translate_screen.dart';
import 'package:kamus_new/screens/kamus.dart';


class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List pages = [TranslateScreen(), Contribute(), OcrTranslate(), KamusScreen()];
  int currentIndex = 0;
  void onTap(int index) {
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
          BottomNavigationBarItem(
              icon: Icon(Icons.translate), label: 'Translate'),
          BottomNavigationBarItem(
              icon: Icon(Icons.people), label: 'Contribute'),
          BottomNavigationBarItem(
              icon: Icon(Icons.image_outlined), label: 'OCR'),
          BottomNavigationBarItem(icon: Icon(Icons.book_online), label: 'Kamus')
        ],
      ),
    );
  }
}
