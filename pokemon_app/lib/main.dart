import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokemon_app/pokemondetail.dart';
import 'dart:convert';
import 'pokehub.dart';
import 'package:pokemon_app/pokehub.dart';

void main() => runApp(MaterialApp(
  title: "Poke Rex",
  home: HomePage(),
));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var url = "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";
  PokeHub pokeHub;


  @override
  void initState() { 
    super.initState();
    fetchData();
  }
  void freetState() { 
    super.initState();
    getData();
  }

  fetchData() async{
    var res = await http.get(url);
    var decodedjson = jsonDecode(res.body) ;
    pokeHub = PokeHub.fromJson(decodedjson);
    print(pokeHub.toJson());
    setState(() {});  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor :  Colors.redAccent[1000] ,
      appBar: AppBar(
        elevation: 0.0,
        title: Center(
          child: Text("Poke Rex",style: TextStyle(fontWeight: FontWeight.light, fontSize: 70),)
          ),
        backgroundColor: Colors.redAccent[1000],
      ),
      body: pokeHub == null?Center(child : CircularProgressIndicator() ):
      GridView.count(
        crossAxisCount: 7,
        children: 
        pokeHub.pokemon.map((poke) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>PokeDetail(
                pokemon: rock,
              )));
            },
            child: Hero(
              tag: poke.img,
              child: Card(
                elevation: 6.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:<Widget>[
                    Container(
                      height: 100,
                      width: 200,
                      decoration: BoxDecoration(
                        image : DecorationImage(image: NetworkImage(poke.img))
                      ),
                    ),
                    Text(
                      poke.name,
                      style: TextStyle(
                        fontSize: 30.0, fontWeight: FontWeight.light,
                      ),
                    )
                  ]
                ),
              ),
            ),
          ),
        )).toList(),
        )
    );
  }
}
