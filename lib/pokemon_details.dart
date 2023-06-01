import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class PokemonDetails extends StatelessWidget {
  PokemonDetails({super.key, required this.currentPokemonId, required this.setCurrentPokemonId, required this.pokemonsList});

  final int currentPokemonId;
  final Function(int) setCurrentPokemonId;
  final List<dynamic> pokemonsList;

  final PageController _pageViewController = PageController(initialPage: 0, keepPage: false);

  Future<dynamic> fetchPokemonById(int id) => get(Uri.https('pokeapi.co', '/api/v2/pokemon/$id'))
  .then((res) {
    if(res.statusCode == 200) {
      _pageViewController.jumpToPage(id - 1);

      return json.decode(res.body);
    }
    else {
      throw Exception('Falha ao buscas os pokemons');
    }
  })
  .onError((error, stackTrace) => throw Exception('Falha ao buscas os pokemons'));

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 1),
    alignment: Alignment.center,
    child: Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 136, 211, 245),
        border: Border.all(
          color: Colors.white,
          // strokeAlign: BorderSide.none,
          width: 1
        )
      ),
      height: MediaQuery.of(context).size.height * 0.45,
      alignment: Alignment.center,
      child:  PageView.builder(
        itemCount: pokemonsList.length,
        itemBuilder: (context, index) => FutureBuilder(
          future: fetchPokemonById(currentPokemonId),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white,
                          width: 1
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
                                    width: 1
                                  )
                                )
                              ),
                              child: Text('Type - ${snapshot.data!['types'].fold('', (value, element) => value == '' ? element['type']['name'] : value += ' / ${element['type']['name']}')}')
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              width: double.infinity,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.white,
                                    width: 1
                                  )
                                )
                              ),
                              child: Text('Ability - ${snapshot.data!['abilities'][0]['ability']['name']}')
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              width: double.infinity,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.white,
                                    width: 1
                                  )
                                )
                              ),
                              child: Text('Height - ${snapshot.data!['height'] / 10} m')
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              width: double.infinity,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.white,
                                    width: 1
                                  )
                                )
                              ),
                              child: Text('Weight - ${snapshot.data!['weight'] / 10} kg')
                            ),
                          ]
                        )
                      )
                    ]
                  )
                ]
              );
            }

            return Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(color: Colors.black),
            );
          }
        ),
        onPageChanged: (index) => setCurrentPokemonId(index + 1),
        controller: _pageViewController,
      )
    )
  );
}