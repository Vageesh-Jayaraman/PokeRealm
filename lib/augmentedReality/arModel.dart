import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class DisplayAR extends StatefulWidget {
  final String pokemon;
  const DisplayAR({super.key, required this.pokemon});

  @override
  State<DisplayAR> createState() => _DisplayARState();
}

class _DisplayARState extends State<DisplayAR> {
  @override
  Widget build(BuildContext context) {
    print(widget.pokemon);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.pokemon),
      ),
      body: ModelViewer(
        src: 'assets/models/${widget.pokemon}.glb',
        alt: 'A 3D model of an astronaut',
        ar: true,
        autoRotate: true,
        disableZoom: true,
      ),
    );
  }
}
