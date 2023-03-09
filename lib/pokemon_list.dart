import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:clickable_list_wheel_view/clickable_list_wheel_widget.dart';
import 'package:clickable_list_wheel_view/measure_size.dart';

class PokemonList extends StatelessWidget {
  PokemonList({super.key, required this.setCurrentPokemonId});

  final Function(int) setCurrentPokemonId;
  final _scrollController = ScrollController();
  final int _pokemonLimit = 1000;

  Future<List<dynamic>> fetchPokemons() => get(Uri.https('pokeapi.co', '/api/v2/pokemon', {'limit': _pokemonLimit.toString()}))
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
          // return ListView.builder(
          //   itemCount: snapshot.data!.length,
          //   itemBuilder: (context, index) => Card(
          //     clipBehavior: Clip.hardEdge,
          //     child: InkWell(
          //       splashColor: Colors.blue.withAlpha(30),
          //       onTap: () => setCurrentPokemonId(index + 1),
          //       child: SizedBox(
          //         width: 50,
          //         height: 50,
          //         child: Container(
          //           padding: const EdgeInsets.only(left: 5),
          //           alignment: Alignment.centerLeft,
          //           child: Text("No ${index + 1}. ${snapshot.data![index]['name']}"),
          //         ),
          //       ),
          //     ),
          //   )
          // );

          return ClickableListWheelScrollView(
            scrollController: _scrollController,
            loop: true,
            itemHeight: 50,
            itemCount: snapshot.data!.length,
            onItemTapCallback: (index) => {
              if(index < 0) {
                setCurrentPokemonId(_pokemonLimit + 1 + index + (index.abs() / _pokemonLimit).floor() * _pokemonLimit)
              }
              else {
                setCurrentPokemonId(index + 1 - (index / _pokemonLimit).floor() * _pokemonLimit)
              }
            },
            child: ListWheelScrollView.useDelegate(
              controller: _scrollController,
              diameterRatio: 2.5,
              useMagnifier: true,
              magnification: 1.15,
              itemExtent: 50,
              childDelegate: ListWheelChildLoopingListDelegate(
                children: snapshot.data!.asMap().entries.map((e) => Card(
                  clipBehavior: Clip.hardEdge,
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Container(
                      padding: const EdgeInsets.only(left: 5),
                      alignment: Alignment.centerLeft,
                      child: Text("No ${e.key + 1}. ${e.value['name']}"),
                    ),
                  ),
                )).toList(),
              )
            ),
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