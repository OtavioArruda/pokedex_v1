import 'package:flutter/material.dart';

class PokemonSearch extends StatelessWidget {
  const PokemonSearch({super.key, required this.pokemonList, required this.setCurrentPokemonId});

  final List<dynamic> pokemonList;
  final Function(int) setCurrentPokemonId;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: MediaQuery.of(context).size.height * 0.4,
      child: ListView.builder(
        itemCount: pokemonList.length,
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
                child: Text("No ${index + 1}. ${pokemonList[index]['name']}"),
              ),
            ),
          ),
        )
      )
    );
  }
}