import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appName = "Startup name Generator";

    return MaterialApp(
      title: appName,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black
        )
      ),
      home: const RandomWords(),
    );
  }
}


class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {

  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18);
  final _saved = <WordPair>{};

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Name Generator'),
        actions: [
          IconButton(
            onPressed: _pushSaved, 
            icon: const Icon(Icons.list), 
            tooltip: 'Saved Suggestions'
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }

          final alreadySaved = _saved.contains(_suggestions[index]);

          return ListTile(
            title: Text(
              _suggestions[index].asPascalCase,
              style: _biggerFont,
            ),
            trailing: Icon(
              alreadySaved? Icons.favorite: Icons.favorite_border,
              color: alreadySaved? Colors.red: null,
              semanticLabel: alreadySaved? 'Remove from saved': 'Save',
            ), 
            onTap: () {
              setState(() {
                if (alreadySaved) {
                  _saved.remove(_suggestions[index]);
                } else {
                  _saved.add(_suggestions[index]);
                }
              });
            },
          );
        },
      )
    );
  }

  void _pushSaved () {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map((pair) {
            return ListTile(
              title: Text(
                pair.asPascalCase,
                style: _biggerFont,
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                _saved.remove(pair);
                });
              },
            );
          });

          final divided = tiles.isNotEmpty?
            ListTile.divideTiles(
              context: context,
              tiles: tiles).toList():
            <Widget>[]; 

          return Scaffold(
            appBar: AppBar(
              title: const Text ('Saved Sugestions'),
            ),
            body: ListView(children: divided),
          );
        }
      )
    );
  }
}