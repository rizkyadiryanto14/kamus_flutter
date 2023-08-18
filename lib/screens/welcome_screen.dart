import 'package:flutter/material.dart';
import 'package:kamus_new/widgets/main_page.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _showUI = false;
  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus> targets = [];

  GlobalKey welcome = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Delay the UI animation for 500 milliseconds
    Future.delayed(Duration(milliseconds: 500), () {
        _showTutorialCoachMark();
      setState(() {
        _showUI = true;
      }); 
    });
  }

  void _showTutorialCoachMark(){
    _initTarget();
    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
    )..show(context: context);
  }

  void _initTarget(){
    targets = [
      TargetFocus(
        identify: "welcome",
        keyTarget: welcome,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller){
              return CoachmarkDesc(
                  text: "Lorem",
                onNext: () {},
                onSkip: () {},
              );
            }
          )
        ]
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedOpacity(
            opacity: _showUI ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: SingleChildScrollView(
              child: Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Stack(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight / 1.6,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight / 1.6,
                          decoration: BoxDecoration(
                            color: Color(0xFF674AEF),
                            borderRadius:
                            BorderRadius.only(bottomRight: Radius.circular(70)),
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
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight / 2.666,
                        decoration: BoxDecoration(color: Color(0xFF674AEF)),
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
                            topLeft: Radius.circular(70),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Kamus En - In - Bima",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                                wordSpacing: 2,
                              ),
                            ),
                            SizedBox(height: 15),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                "Selamat datang di Aplikasi Kamus Bahasa Bima-Indonesia-Inggris\n.Terjemahkan kata yang anda ingin ketahui dengan akurat",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ),
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
                                      builder: (context) => MainPage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 80),
                                  child: Text(
                                    "Mulai Sekarang",
                                    //key: welcome,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          );
        },
      ),
    );
  }
}

class CoachmarkDesc extends StatefulWidget {
  const CoachmarkDesc({
    super.key,
    required this.text,
    this.skip = "Skip",
    this.next = "Next",
    this.onSkip,
    this.onNext
  });

  final String text;
  final String skip;
  final String next;
  final void Function()? onSkip;
  final void Function()? onNext;

  @override
  State<CoachmarkDesc> createState() => _CoachmarkDescState();
}

class _CoachmarkDescState extends State<CoachmarkDesc> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: widget.onSkip,
                child: Text(widget.skip),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                  onPressed: widget.onNext,
                  child: Text(
                    widget.next
                  ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

