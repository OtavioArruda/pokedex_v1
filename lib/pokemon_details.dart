import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class PokemonDetails extends StatelessWidget {
  const PokemonDetails({super.key, required this.currentPokemonId, required this.setCurrentPokemonId, required this.pokemonsList});

  final int currentPokemonId;
  final Function(int) setCurrentPokemonId;
  final List<dynamic> pokemonsList;

  Future<dynamic> fetchPokemonById(int id) => get(Uri.https('pokeapi.co', '/api/v2/pokemon/$id'))
  .then((res) {
    if(res.statusCode == 200) {
      return json.decode(res.body);
    }
    else {
      throw Exception('Falha ao buscas os pokemons');
    }
  });

  @override
  Widget build(BuildContext context) => PageView.builder(
      itemCount: pokemonsList.length,
      itemBuilder: (context, index) => FutureBuilder(
        future: fetchPokemonById(currentPokemonId),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return Container(
              alignment: Alignment.center,
              child: Card(
                child: Container(
                  height: MediaQuery.of(context).size.height / 4,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(snapshot.data!['name'])
                    ]
                  )
                )
              ),
            );
          }

          return Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(color: Colors.black),
          );
        }
      ),
      onPageChanged: (index) => setCurrentPokemonId(index + 1),
    );
  }