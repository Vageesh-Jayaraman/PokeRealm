import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pokedex/augmentedReality/availableModels.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokedex/utilities/colorPalette.dart';
import 'package:pokedex/utilities/showBottomSheet.dart';

import '../augmentedReality/arModel.dart';

class PokemonPage extends StatefulWidget {
  final List data;
  final int index;

  PokemonPage({required this.data, required this.index});

  @override
  _PokemonPageState createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final item = widget.data[widget.index];
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    String name = item["name"];
    String id = item["id"];
    String imageUrl = item["imageurl"];
    String desc = item["xdescription"];
    List types = item["typeofpokemon"];
    List evolutions = item["evolutions"];

    String getEvolutionImageUrl(String evolutionId) {
      final evolutionItem = widget.data.firstWhere(
          (element) => element["id"] == evolutionId,
          orElse: () => null);
      return evolutionItem != null ? evolutionItem["imageurl"] : '';
    }

    Widget buildStatBar(String label, int value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.sourceSans3(
                fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 5),
          GlowingOverscrollIndicator(
            axisDirection: AxisDirection.right,
            color: getColor(index: widget.index),
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: Colors.grey[850],
              valueColor:
                  AlwaysStoppedAnimation<Color>(getColor(index: widget.index)),
            ),
          ),
          SizedBox(height: 10),
        ],
      );
    }

    TableRow rowContents({required String left, required String right}) {
      return TableRow(children: [
        TableCell(
            child: Text(
          left,
          style: GoogleFonts.sourceSans3(
              fontSize: 18, fontWeight: FontWeight.w500),
        )),
        TableCell(
            child: Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Text(
              right,
              style: GoogleFonts.sourceSans3(
                  fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        )
      ]);
    }

    TableRow showGenderPercentage(
        {required String left, required String male, required String female}) {
      return TableRow(children: [
        TableCell(
            child: Text(
          left,
          style: GoogleFonts.sourceSans3(
              fontSize: 18, fontWeight: FontWeight.w500),
        )),
        TableCell(
            child: Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.male,
              color: Colors.blue,
              size: 20,
            ),
            Text(
              male,
              style: GoogleFonts.sourceSans3(
                  fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Icon(
              Icons.female,
              color: Colors.pinkAccent,
              size: 20,
            ),
            Text(
              female,
              style: GoogleFonts.sourceSans3(
                  fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        )
        )
      ]);
    }


    Widget showAbout() {
      return Column(
        children: [
          Center(
            child: Text(
              'Overview',
              style: GoogleFonts.sourceSans3(
                  fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: getDarkColor(index: widget.index),
                          blurRadius: 5.0,
                          spreadRadius: 3.0,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(10),
                    child: Text(desc,
                        style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: getColor(index: widget.index)))),
                Container(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Table(
                        columnWidths: {
                          0: IntrinsicColumnWidth(flex: 0.1),
                          1: IntrinsicColumnWidth()
                        },
                        border: TableBorder(
                          verticalInside: BorderSide(
                              color: getColor(index: widget.index), width: 2),
                          top: BorderSide.none,
                          bottom: BorderSide.none,
                          right: BorderSide.none,
                        ),
                        children: [
                          rowContents(left: 'Height', right: item["height"]),
                          rowContents(left: 'Weight', right: item["weight"]),
                          rowContents(left: 'Category', right: item["category"]),
                          rowContents(
                              left: 'Egg Groups', right: item["egg_groups"]),
                          if (item["male_percentage"] != null &&
                              item["female_percentage"] != null)
                            showGenderPercentage(
                                left: 'Gender',
                                male: item["male_percentage"],
                                female: item["female_percentage"]),
                          rowContents(
                              left: 'Abilities',
                              right: item["abilities"].join(" | ")),
                        ],
                      ),
                    )
                ),

              ],
            ),
          ),
        ],
      );
    }

    Widget showStats() {
      return Column(
        children: [
          Center(
            child: Text(
              'Stats',
              style: GoogleFonts.sourceSans3(
                  fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildStatBar('HP', item["hp"]),
                buildStatBar('Attack', item["attack"]),
                buildStatBar('Defense', item["defense"]),
                buildStatBar('Special Attack', item["special_attack"]),
                buildStatBar('Special Defense', item["special_defense"]),
                buildStatBar('Speed', item["speed"]),
              ],
            ),
          ),
        ],
      );
    }

    Widget showEvolutions() {
      return Column(
        children: [
          Center(
            child: Text(
              'Evolutions',
              style: GoogleFonts.sourceSans3(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: evolutions.map((evolutionId) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Center(
                    child: CachedNetworkImage(
                      width: screenWidth*0.5,
                      imageUrl: getEvolutionImageUrl(evolutionId),
                      placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      );
    }

    Widget namedIcon({required IconData icon, required int index}) {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Icon(icon, size: 20),
          decoration: BoxDecoration(
              color: selectedIndex == index
                  ? getDarkColor(index: widget.index).withOpacity(0.7)
                  : Colors.black.withOpacity(0.15),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: getColor(index: widget.index))),
        ),
      );
    }

    Widget glowingGradientButton({
      required Function onPressed,
      required IconData icon,
      double size = 56.0,
    }) {
      return FloatingActionButton(
        tooltip: "Generate story",
        onPressed: () => onPressed(),
        backgroundColor: Colors.transparent,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size / 2),
            gradient: RadialGradient(
              colors: [
                Colors.blue,
                Colors.purple,
                Colors.lightBlue,
              ],
              center: Alignment.center,
              radius: 1,
            ),
            border: Border.all(
              color: Colors.white,
              width: 2.0,
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      );
    }

    return Scaffold(
      floatingActionButton: glowingGradientButton(
        onPressed: () {
          setState(() {
            showScrollableModalBottomSheet(context, widget.index, name);
          });
        },
        icon: Icons.my_library_books,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(alignment: Alignment.bottomRight, children: [
                CachedNetworkImage(
                  width: screenWidth*0.9,
                  imageUrl: imageUrl,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                if (avilableModels.contains(name.toLowerCase()))
                  IconButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          return getDarkColor(index: widget.index);
                        }),
                      ),
                      color: getColor(index: widget.index),
                      onPressed: () {
                        setState(() {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DisplayAR(pokemon: name.substring(0, 1).toUpperCase() + name.substring(1),)));
                        });
                      },
                      icon: Icon(Icons.view_in_ar_rounded))
              ]),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                  child: Text(
                    id,
                    style: GoogleFonts.robotoMono(
                        fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  decoration: BoxDecoration(
                    color: getDarkColor(index: widget.index).withOpacity(0.7),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              Center(
                child: Text(name,
                    style: GoogleFonts.crimsonText(
                        fontSize: 45, fontWeight: FontWeight.w600)),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Type: ${types.join(" | ")}',
                      style: GoogleFonts.robotoMono(
                          fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              Container(
                height: 60,
                margin: EdgeInsets.all(20),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      namedIcon(icon: FontAwesomeIcons.info, index: 0),
                      namedIcon(icon: FontAwesomeIcons.chartBar, index: 1),
                      namedIcon(icon: FontAwesomeIcons.exchangeAlt, index: 2),
                    ],
                  ),
                ),
              ),
              if (selectedIndex == 0) showAbout(),
              if (selectedIndex == 1) showStats(),
              if (selectedIndex == 2) showEvolutions(),
            ],
          ),
        ),
      ),
    );
  }
}
