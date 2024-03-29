import 'package:flutter/material.dart';

class PokemonSearch extends StatefulWidget {
  const PokemonSearch({super.key, required this.pokemonList, required this.setCurrentPokemonId});

  final List<dynamic> pokemonList;
  final Function(int) setCurrentPokemonId;

  @override
  _PokemonSearchState createState() => _PokemonSearchState();
}

class _PokemonSearchState extends State<PokemonSearch> {
  List<PokemonInfo> pokemonInfoList = [];
  List<PokemonInfo> filteredPokemonsList = [];
  String _textFieldInp = '';

  @override
  void initState() {
    super.initState();
    pokemonInfoList = generatePokemonInfoList(widget.pokemonList);
  }

  List<PokemonInfo> generatePokemonInfoList(List<dynamic> pokemonList) {
    List<PokemonInfo> pokemonInfoList = [];
    filteredPokemonsList = pokemonInfoList;
    int previousId = 0;

    for (var pokemon in pokemonList) {
      final String name = pokemon['name'];
      final int id = previousId + 1;

      PokemonInfo pokemonInfo = PokemonInfo(name: name, id: id);
      pokemonInfoList.add(pokemonInfo);

      previousId = id;
    }

    return pokemonInfoList;
  }

  void filterPokemonsList(String input) {
    setState(() {
      filteredPokemonsList = pokemonInfoList.where((pokemon) => pokemon.name.toLowerCase().contains(input.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.width * 0.35,
      ),
      child: Column(
        children: [
          TextField(
            style: TextStyle(
              color: Color.fromARGB(255, 0, 195, 255),
              fontSize: 15.0,
            ),
            decoration: InputDecoration(
              labelText: 'Buscar Pokemon...',
              contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
              labelStyle: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 202, 244, 255),
                ),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _textFieldInp = value;
                filterPokemonsList(value);
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPokemonsList.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => widget.setCurrentPokemonId(filteredPokemonsList[index].id),
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
                          child: Chip(label: Text('No ${filteredPokemonsList[index].id}'))
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(
                            style: const TextStyle(fontSize: 18),
                            filteredPokemonsList[index].name
                          )
                        ),
                      ],
                    ),
                  )
                ),
              )
            )
          ),
        ],
      ),
    );
  }
}
class PokemonInfo {
  final String name;
  final int id;
  PokemonInfo({required this.name, required this.id});
}
