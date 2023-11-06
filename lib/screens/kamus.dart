import 'package:flutter/material.dart';
import 'package:kamus_new/api/api_kamusperkata.dart';
import 'package:kamus_new/model/kamus_perkata_model.dart';

class KamusScreen extends StatefulWidget {
  const KamusScreen({super.key});

  @override
  State<KamusScreen> createState() => _KamusScreenState();
}

class _KamusScreenState extends State<KamusScreen> {
  final TextEditingController kamus = TextEditingController();
  late Future<List<Translation>> futureTranslations;

  @override
  void initState() {
    super.initState();
    futureTranslations = ApiService.fetchTranslations();
  }

  void search(String query) {
    setState(() {
      futureTranslations = ApiService.fetchTranslations(keyword: query);
    });
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
              end: Alignment.topLeft,
              colors: [Colors.blue, Colors.tealAccent],
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
                          'images/KRongga.png',
                          fit: BoxFit.contain,
                          width: 78,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Kamus Pages",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: EdgeInsets.symmetric(vertical: 17),
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        TextField(
                          controller: kamus,
                          onChanged: search,
                          decoration: InputDecoration(
                              labelText: 'Masukan Kata',
                              labelStyle: TextStyle(
                                  color: const Color.fromARGB(
                                      255, 232, 189, 189))),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 2.3, // Adjust this value as needed
                          child: FutureBuilder<List<Translation>>(
                            future: futureTranslations,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: ListTile(
                                        title: Text(
                                            'Bahasa Bima: ${snapshot.data![index].bahasaBima}'
                                        ),
                                        subtitle: Text(
                                          'Bahasa Indonesia: ${snapshot.data![index].bahasaIndonesia}\n'
                                              'Bahasa Inggris: ${snapshot.data![index].bahasaInggris}',
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              }

                              return CircularProgressIndicator();
                            },
                          ),
                        ),
                      ],
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
}
