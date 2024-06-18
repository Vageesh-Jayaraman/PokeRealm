import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../geminiIntegration/getStory.dart';
import 'colorPalette.dart';

class BottomSheetContent extends StatefulWidget {
  final String character;
  final int index;

  const BottomSheetContent({super.key, required this.character, required this.index});

  @override
  State<BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  bool isAdded = false;

  void toggleIcon(StateSetter setState, String heading, String mainStory) {
    setState(() {
      isAdded = !isAdded;

      var hiveBox = Hive.box('myBox');

      if (isAdded) {
        hiveBox.put(heading, {
          'heading': heading,
          'mainStory': mainStory,
        });
      } else {
        hiveBox.delete(heading);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<String>(
          future: generateStory(character: widget.character),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 3.0,
                    valueColor: AlwaysStoppedAnimation<Color>(getColor(index: widget.index)),
                  ),
                  SizedBox(height: 16),
                  Text('Creating story...', style: TextStyle(fontSize: 16)),
                ],
              );
            } else if (snapshot.hasError) {
              return Text(
                'Error: ${snapshot.error}',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              );
            } else {
              String? story = snapshot.data;
              String? heading = story?.substring(2, story.indexOf('\n'));
              String? mainStory = story?.substring(story.indexOf('\n') + 1);
              return Column(
                children: [
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            heading ?? '',
                            style: GoogleFonts.openSans(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          IconButton(
                            onPressed: () => toggleIcon(setState, heading!, mainStory!),
                            icon: Icon(
                              isAdded ? Icons.check_circle_outline : Icons.add_circle_outline,
                              color: getColor(index: widget.index),
                              size: 30,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Text(
                    mainStory ?? '',
                    style: GoogleFonts.baskervville(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

void showScrollableModalBottomSheet(BuildContext context, int index, String name) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 500,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: getColor(index: index),
              blurRadius: 5.0,
              spreadRadius: 3.0,
            ),
          ],
        ),
        child: BottomSheetContent(character: name, index: index),
      );
    },
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
  );
}
