import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

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
  late int _currentPokemonId;

  void _setCurrentPokemonId(int id) {
    setState(() {
      _currentPokemonId = id;
    });
  }

  Future<List<dynamic>> fetchPokemons() => get(Uri.https('pokeapi.co', '/api/v2/pokemon', {'limit': '2000'}))
  .then((res) {
    if(res.statusCode == 200) {
      return json.decode(res.body)['results'];
    }
    else {
      throw Exception('Falha ao buscas os pokemons');
    }
  });

  @override
  void initState() {
    _currentPokemonId = 1;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                alignment: Alignment.center,
                child: Card(
                  color: Colors.lightBlue,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: FutureBuilder(
                      future: fetchPokemons(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData) {
                          return PokemonDetails(currentPokemonId: _currentPokemonId, setCurrentPokemonId: _setCurrentPokemonId, pokemonsList: snapshot.data!);
                        }
                        else if(snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }

                        return const Center(child: CircularProgressIndicator());
                      }
                    )
                    // child: PokemonDetails(currentPokemonId: _currentPokemonId)
                    // child: PokemonList(setCurrentPokemonId: _setCurrentPokemonId),
                  ),
                ),
              ),
            ),
            CustomPaint(painter: FooterAndHeader(context))
          ],
        ),
      )
    );
  }
}

class FooterAndHeader extends CustomPainter {
  final BuildContext context;

  FooterAndHeader(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    Size size = MediaQuery.of(context).size;

    Paint redPaint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.fill;

    Paint blackPaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.fill;

    RRect rrectUp = RRect.fromRectAndCorners(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 0.1125),
        width: size.width,
        height: size.height * 0.225
      ),
      topLeft: const Radius.circular(30),
      topRight: const Radius.circular(30),
      bottomLeft: const Radius.circular(0),
      bottomRight: const Radius.circular(0)
    );

    RRect rrectDown = RRect.fromRectAndCorners(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 0.8875),
        width: size.width,
        height: size.height * 0.225
      ),
      topLeft: const Radius.circular(0),
      topRight: const Radius.circular(0),
      bottomLeft: const Radius.circular(30),
      bottomRight: const Radius.circular(30)
    );

    Rect ovalUp = Rect.fromCircle(
      center: Offset(size.width / 2, size.height * 0.25),
      radius: size.width * 0.35
    );

    Rect ovalDown = Rect.fromCircle(
      center: Offset(size.width / 2, size.height * 0.75),
      radius: size.width * 0.35
    );

    Path rrectPath = Path()
    ..addRRect(rrectUp)
    ..addRRect(rrectDown);

    Path ovalPath = Path()
    ..addOval(ovalUp)
    ..addOval(ovalDown);

    canvas.drawPath(Path.combine(PathOperation.difference, rrectPath, ovalPath), redPaint);

    Rect recUp = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width * 0.49
    );

    rrectPath
    ..reset()
    ..addRect(recUp);

    ovalPath = Path.combine(PathOperation.difference, ovalPath, rrectPath);

    ovalUp = Rect.fromCircle(
      center: Offset(size.width / 2, size.height * 0.25),
      radius: size.width * 0.25
    );

    ovalDown = Rect.fromCircle(
      center: Offset(size.width / 2, size.height * 0.75),
      radius: size.width * 0.25
    );

    Path ovalInsidePath = Path()
    ..addOval(ovalUp)
    ..addOval(ovalDown);

    canvas.drawPath(Path.combine(PathOperation.difference, ovalPath, ovalInsidePath), blackPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}