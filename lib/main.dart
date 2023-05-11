import 'package:flutter/material.dart';

import 'package:pokedex_v1/pokemon_details.dart';
import 'package:pokedex_v1/pokemon_list.dart';

void main() {
  runApp(const PokedexHome());
}

class PokedexHome extends StatefulWidget {
  const PokedexHome({super.key});

  @override
  State<PokedexHome> createState() => _PokedexHomeState();
}

class _PokedexHomeState extends State<PokedexHome> {
  int? _currentPokemonId;

  void _setCurrentPokemonId(int id) {
    setState(() {
      _currentPokemonId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: Card(
                    color: Colors.lightBlue,
                    child: SizedBox(
                      width: 100,
                      height: double.infinity,
                      child: PokemonDetails(currentPokemonId: _currentPokemonId)
                    ),
                  ),
                ),
              ),
              CustomPaint(painter: FooterAndHeader(context)),
              // Positioned(
              //   top: 0,
              //   child: Container(
              //     height: 100,
              //     width: MediaQuery.of(context).size.width,
              //     color: Colors.red
              //   )
              // ),
              // Positioned(
              //   bottom: 0,
              //   child: Container(
              //     height: 100,
              //     width: MediaQuery.of(context).size.width,
              //     color: Colors.red
              //   )
              // ),
            ],
          ),
        )
      )
    );
  }
}

class FooterAndHeader extends CustomPainter {
  final BuildContext context;

  FooterAndHeader(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.fill;

    // canvas.drawCircle(const Offset(50, 50), 20, paint);
    var rrect = RRect.fromRectAndCorners(
      Rect.fromCenter(
        center: Offset(
          MediaQuery.of(context).size.width / 2, 
          MediaQuery.of(context).size.height * 0.225 / 2
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.225
      ), 
      topLeft: const Radius.circular(40),
      topRight: const Radius.circular(40),
      bottomLeft: const Radius.circular(0),
      bottomRight: const Radius.circular(0),
    );

    var oval = Rect.fromCircle(
      center: Offset(
        MediaQuery.of(context).size.width / 2,
        MediaQuery.of(context).size.height * 0.25
      ),
      radius: MediaQuery.of(context).size.width * 0.35
    );

    var rrectPath = Path()..addRRect(rrect);

    var ovalPath = Path()..addOval(oval);

    canvas.drawPath(Path.combine(PathOperation.difference, rrectPath, ovalPath), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}