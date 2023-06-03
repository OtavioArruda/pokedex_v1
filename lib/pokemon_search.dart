import 'package:flutter/material.dart';

class PokemonSearch extends StatelessWidget {
  const PokemonSearch({
    super.key, 
    required this.pokemonList, 
    required this.setCurrentPokemonId
  });

  final List<dynamic> pokemonList;
  final Function(int) setCurrentPokemonId;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      margin: const EdgeInsets.symmetric(horizontal: 9),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.width * 0.35,
        bottom: 10
      ),
      child: ListView.builder(
        itemCount: pokemonList.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => setCurrentPokemonId(index + 1),
          child: Container(
            height: 50,
            padding: const EdgeInsets.only(left: 5),
            margin: const EdgeInsets.symmetric(vertical: 2),
            alignment: Alignment.center,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius:BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30)
                ),
                color: Colors.white
              ),
              child: Row(

                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Chip(label: Text('No ${index + 1}'))
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Text(
                      style: const TextStyle(fontSize: 18),
                      '${pokemonList[index]['name']}'
                    )
                  ),
                ],
              ),
            )
          ),
        )
      )
    );
  }
}