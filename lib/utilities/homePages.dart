import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pokedex/database/hivePage.dart';
import 'package:pokedex/utilities/pokemonPage.dart';
import 'package:pokedex/utilities/searchPage.dart';

class HomePage extends StatefulWidget {
  final List<dynamic> data;

  HomePage({required this.data});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int bottomIndex = 0;

  @override
  Widget build(BuildContext context) {
    void changeIndex({required int index}) {
      setState(() {
        bottomIndex = index;
      });
    }

    Widget bottomNavigationBar() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GNav(
          gap: 2,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.grey.withOpacity(0.2),
          padding: EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          onTabChange: (index) {
            changeIndex(index: index);
          },
          tabs: [
            GButton(
              icon: Icons.my_library_books_rounded,
              text: ' Cards',
            ),
            GButton(
              icon: Icons.search,
              text: 'Search',
            ),
            GButton(
              icon: Icons.text_snippet,
              text: 'Collections',
            ),
          ],
        ),
      );
    }

    return Scaffold(
      bottomNavigationBar: bottomNavigationBar(),
      body: widget.data.isEmpty
          ? Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    if (bottomIndex == 0) {
      return PageView.builder(
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          return PokemonPage(data: widget.data, index: index);
        },
      );
    } else if (bottomIndex == 1) {
      return SearchPage(data: widget.data);
    } else {
      return HiveDisplayPage();
    }
  }
}