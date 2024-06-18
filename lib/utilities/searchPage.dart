import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex/utilities/colorPalette.dart';
import 'package:pokedex/utilities/pokemonPage.dart';

class SearchPage extends StatefulWidget {
  final List<dynamic> data;

  const SearchPage({Key? key, required this.data}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<dynamic> searchResults = [];

  void runFilter(String enteredKeyword) {
    List<dynamic>? results = [];

    if (enteredKeyword.isEmpty) {
      results = widget.data;
    } else {
      results = widget.data
          .where((element) =>
          element['name'].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      searchResults = results ?? [];
    });
  }

  @override
  void initState() {
    searchResults = widget.data;
    super.initState();
  }

  Widget displayBox({required int index, required double screenWidth}) {
    var item = searchResults[index];
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PokemonPage(data: widget.data, index: widget.data.indexOf(item))));
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 15,5 , 10),
        margin: EdgeInsets.all(5),
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: getColor(index: widget.data.indexOf(item)).withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['id'],
                  style: GoogleFonts.robotoMono(
                      fontSize: 18, fontWeight: FontWeight.w600, height: 1.3),
                ),
                Text(
                  item['name'],
                  style: GoogleFonts.crimsonText(
                      fontSize: 35, fontWeight: FontWeight.w600, height: 1.5),
                ),
                Text(
                  'Type: ${item['typeofpokemon'].join(" | ")}',
                  style: GoogleFonts.robotoMono(
                      fontSize: 16, fontWeight: FontWeight.w800, height: 1.4),
                ),
                Text(
                  'Category: ${item['category']}',
                  style: GoogleFonts.robotoMono(
                      fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ],
            ),
            CachedNetworkImage(
              width: screenWidth*0.3,
              imageUrl: item['imageurl'],
              placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
              errorWidget: (context, url, error) => Icon(Icons.error),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: TextField(
                onChanged: (value) => runFilter(value),
                decoration: InputDecoration(
                  labelText: 'Search',
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return displayBox(index: index, screenWidth: screenWidth);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
