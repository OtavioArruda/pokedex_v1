import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class PokemonList extends StatelessWidget {
  const PokemonList({super.key, required this.setCurrentPokemonId});

  final Function(int) setCurrentPokemonId;

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
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchPokemons(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) => Card(
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () => setCurrentPokemonId(index + 1),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Container(
                    padding: const EdgeInsets.only(left: 5),
                    alignment: Alignment.centerLeft,
                    child: Text("No ${index + 1}. ${snapshot.data![index]['name']}"),
                  ),
                ),
              ),
            )
          );
        }
        else if(snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const Center(child: CircularProgressIndicator());
      }
    );
  }
}