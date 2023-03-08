import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

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

  void setCurrentPokemonId(int id) {
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
                child: FutureBuilder(
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

                    return const CircularProgressIndicator();
                  }
                ),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _currentPokemonId != null
                        ? FutureBuilder(
                            future: fetchPokemonById(_currentPokemonId!),
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
                                      centerSlice: Rect.fromLTRB(15, 15, 175, 175),
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
                    ),
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