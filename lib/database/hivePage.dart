import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class HiveDisplayPage extends StatefulWidget {
  @override
  State<HiveDisplayPage> createState() => _HiveDisplayPageState();
}

class _HiveDisplayPageState extends State<HiveDisplayPage> {
  @override

  Widget build(BuildContext context) {

    Widget DisplayStory({
      required String heading,
      required String mainStory,
      required VoidCallback onDelete,
    }) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          heading,
                          style: GoogleFonts.openSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_forever_outlined),
                        color:Colors.red ,
                        onPressed: onDelete,
                      ),
                    ],
                  ),
                  Text(
                    mainStory,
                    style: GoogleFonts.baskervville(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }


    var hiveBox = Hive.box('mybox');
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Stories'),
        centerTitle: true,
      ),
      body: Builder(
        builder: (BuildContext context) {
          var storedStories = hiveBox.values.toList();
          if (storedStories.isEmpty) {
            return Center(
              child: Text('No stories saved yet.'),
            );
          }
          return ListView.builder(
            itemCount: storedStories.length,
            itemBuilder: (context, index) {
              var story = storedStories[index];
              return DisplayStory(
                heading: story['heading'],
                mainStory: story['mainStory'],
                onDelete: () {
                  setState(() {
                    hiveBox.delete(story['heading']);
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}
