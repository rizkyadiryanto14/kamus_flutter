import 'package:flutter/material.dart';
import 'package:kamus_new/widgets/main_page.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _showUI = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _showUI = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedOpacity(
            opacity: _showUI ? 1.0 : 0.0,
            duration: Duration(milliseconds: 100),
            child: SingleChildScrollView(
              child: Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Stack(
                  children: [
                    Container(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight / 1.6,
                      decoration: BoxDecoration(
                        color: Color(0xFF674AEF),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(70)
                        )
                      ),
                      child: Center(
                        child: Image.asset(
                          "images/KRongga_Text.png",
                          scale: 0.9,
                          width: 290,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight / 2.666,
                        padding: EdgeInsets.only(top: 30, bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(70)
                          )
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Kamus En - In - Bima",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                                wordSpacing: 2
                              )
                            ),
                            SizedBox(height: 15),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                "Selamat datang di Aplikasi Kamus Bahasa Bima-Indonesia-Inggris\n.Terjemahkan kata yang anda ingin ketahui dengan akurat",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black.withOpacity(0.6)
                                )
                              )
                            ),
                            SizedBox(height: 20),
                            Material(
                              color: Color(0xFF674AEF),
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MainPage()
                                    )
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                                  child: Text(
                                    "Mulai Sekarang",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1
                                    )
                                  )
                                )
                              )
                            )
                          ],
                        )
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}