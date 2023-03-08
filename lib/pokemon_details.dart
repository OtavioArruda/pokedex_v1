import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class PokemonDetails extends StatelessWidget {
  const PokemonDetails({super.key, required this.currentPokemonId});

  final int? currentPokemonId;

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
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        currentPokemonId != null
        ? FutureBuilder(
            future: fetchPokemonById(currentPokemonId!),
            builder: (context, snapshot) {
              if(snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              else if(snapshot.connectionState != ConnectionState.done) {
                return const Expanded(
                  flex: 1,
                  child: Center(child: CircularProgressIndicator())
                );
              }
              else if(snapshot.hasData) {
                List<Widget> typeChips = snapshot.data!['types'].map<Widget>((e) => Chip(label: Text(e['type']['name']))).toList();

                return Column(
                  children: [
                    Text('${snapshot.data!['name']}'),
                    Image(
                      width: 200,
                      centerSlice: const Rect.fromLTRB(15, 15, 175, 175),
                      image: NetworkImage('${snapshot.data!['sprites']['front_default']}')
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: typeChips
                    )
                  ],
                );
              }

              return const Expanded(
                flex: 1,
                child: Center(child: CircularProgressIndicator())
              );
            },
          )
        : const Expanded(flex:1, child: Center(child: Text('No data'))),
      ]
    );
  }
}