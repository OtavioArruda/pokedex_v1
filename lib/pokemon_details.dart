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
  })
  .onError((error, stackTrace) => throw Exception('Falha ao buscas os pokemons'));

  @override
  Widget build(BuildContext context) => PageView.builder(
      itemCount: pokemonsList.length,
      itemBuilder: (context, index) => FutureBuilder(
        future: fetchPokemonById(currentPokemonId),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 1),
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(
                    color: Colors.white,
                    // strokeAlign: BorderSide.none,
                    width: 0.5
                  )
                ),
                height: MediaQuery.of(context).size.height * 0.4,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white,
                            width: 0.5
                          )
                        )
                      ),
                      child: Text('${snapshot.data!['name']} No. ${index + 1}')
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Image(
                            width: MediaQuery.of(context).size.height * 0.2,
                            centerSlice: Rect.fromCircle(
                              center: const Offset(0, 0),
                              radius: 5
                            ),
                            image: NetworkImage('${snapshot.data!['sprites']['front_default']}')
                          )
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                width: double.infinity,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.white,
                                      width: 0.5
                                    )
                                  )
                                ),
                                child: Text('Type - ${snapshot.data!['types'].fold('', (value, element) => value == '' ? element['type']['name'] : value += ' / ${element['type']['name']}')}')
                                // child: const Text('teste'),
                              ),
                            ]
                          )
                        )
                      ]
                    )
                  ]
                )
              )
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