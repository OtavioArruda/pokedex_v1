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
        // appBar: AppBar(
        //   title: const Text('Hello World!'),
        // ),
        body: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 10),
                child: PokemonList(setCurrentPokemonId: _setCurrentPokemonId)
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20, right: 10, bottom: 20),
                child: Card(
                  child: SizedBox(
                    width: 100,
                    height: double.infinity,
                    child: PokemonDetails(currentPokemonId: _currentPokemonId,)
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}