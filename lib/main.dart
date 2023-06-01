import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

import 'package:pokedex_v1/pokemon_details.dart';
import 'package:pokedex_v1/pokemon_search.dart';

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
  bool _pokemonSearchVisibility = false;
  double _searchIconTurns = 0;
  Future? _pokemonsList;

  void _setCurrentPokemonId(int id) {
    setState(() {
      _currentPokemonId = id;
    });
  }

  void _setPokemonSearchVisibility() {
    setState(() {
      _searchIconTurns += 1 / 2;
      _pokemonSearchVisibility = !_pokemonSearchVisibility;
    });
  }

  void _setPokemonSearchVisibilityAndId(int id) {
    setState(() {
      _currentPokemonId = id;
      _searchIconTurns += 1 / 2;
      _pokemonSearchVisibility = !_pokemonSearchVisibility;
    });
  }

  Future fetchPokemons() => get(Uri.https('pokeapi.co', '/api/v2/pokemon', {'limit': '2000'}))
  .then((res) {
    if(res.statusCode == 200) {
      return json.decode(res.body)['results'];
    }
    else {
      throw Exception('Falha ao buscas os pokemons');
    }
  })
  .onError((error, stackTrace) => Exception('Falha ao buscas os pokemons'));

  @override
  void initState() {
    _currentPokemonId = 1;

    _pokemonsList = fetchPokemons();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              alignment: Alignment.center,
              child: Card(
                color: const Color.fromARGB(255, 129, 234, 234),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: FutureBuilder(
                    future: _pokemonsList,
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
                ),
              ),
            ),
            FutureBuilder(
              future: _pokemonsList,
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  return AnimatedPositioned(
                    top: MediaQuery.of(context).size.height * 0.25 - MediaQuery.of(context).size.width * 0.35,
                    height: _pokemonSearchVisibility ? MediaQuery.of(context).size.height * 0.6 : 0,
                    width: MediaQuery.of(context).size.width,
                    duration: const Duration(seconds: 2),
                    curve: Curves.fastOutSlowIn,
                    child: PokemonSearch(pokemonList: snapshot.data, setCurrentPokemonId: _setPokemonSearchVisibilityAndId),
                  );
                }
                else if(snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
            CustomPaint(painter: FooterAndHeader(context)),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.25 - MediaQuery.of(context).size.width * 0.375,
              left: MediaQuery.of(context).size.width / 2 - 60 / 2,
              width: 60,
              height: 60,
              child: IconButton(
                iconSize: 60,
                padding: EdgeInsets.zero,
                icon: AnimatedRotation(
                  turns: _searchIconTurns,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: const Icon(Icons.expand_more)
                ),
                color: Colors.white,
                onPressed: () => _setPokemonSearchVisibility(),
              ),
            )
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
    ..color = const Color.fromARGB(255, 170 ,12 , 30)
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

    Rect recUp = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height * 0.55
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