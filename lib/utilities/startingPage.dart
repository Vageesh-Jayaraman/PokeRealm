import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex/utilities/homePages.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class StartingPage extends StatefulWidget {
  const StartingPage({super.key});

  @override
  State<StartingPage> createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
  List<dynamic> _data = [];

  @override
  void initState() {
    super.initState();
    _loadJsonData();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => HomePage(data: _data),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ),
      );
    });
  }

  Future<void> _loadJsonData() async {
    final String jsonString = await rootBundle.loadString('assets/pokemons.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);
    setState(() {
      _data = jsonResponse;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.yellow.shade600,
                  Colors.yellow.shade100,

                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'PokeRealm',
                  style: GoogleFonts.noticiaText(
                    fontSize: 60,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Image.asset(
                      'assets/loading.gif',
                      scale: 0.5,
                    ),

                    Text(
                      'Loading...',
                      style: GoogleFonts.pacifico(
                        fontSize: 30,
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
                 // Loading text
              ],
            ),
          ),
        ],
      ),
    );
  }
}
