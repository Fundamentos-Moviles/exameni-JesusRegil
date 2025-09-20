import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget { 
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BuscaMinas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: const MyHomePage(title: 'BuscaMinas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late Set<int> bombs;  // 1..18
  late List<int> numbers;   // 1..18
  late List<Color> colors;  // 18 colores (1 por celda)
  final _rand = Random();  

  @override
  void initState() {
    super.initState();
    numbers = List.generate(36, (i) => (i+1));
    bombs = <int>{};
    while (bombs.length < 8) {
    bombs.add(_rand.nextInt(36)); // 0..35
   }
    colors  = List.generate(36, (_) => Colors.grey); 
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
  automaticallyImplyLeading: false, // para que no meta back button
  flexibleSpace: Stack(
    alignment: Alignment.center,
    children: [
      // título a la izquierda
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            widget.title,
            style: const TextStyle(fontSize: 30),
          ),
        ),
      ),

      // ícono centrado
      IconButton(
        icon: const Icon(Icons.refresh, size: 28),
        onPressed: _resetGame,
      ),
    ],
  ),
),


    body: Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,     // 3 columnas
          mainAxisSpacing: 8,    // espacio vertical entre celdas
          crossAxisSpacing: 8,   // espacio horizontal entre celdas
          childAspectRatio: 0.8,
        ),
        itemCount: 36,           // 6 x 6 = 36 celdas
        itemBuilder: (context, index) {
           return InkWell(
             borderRadius: BorderRadius.circular(50),
             onTap: () => _onTap(index), 
              child: Ink(
                decoration: BoxDecoration(
                  color: colors[index],
                  borderRadius: BorderRadius.circular(20),
                ),
                 child: Center(
                 
                ),
              ),
           );
        },
      ),
    ),
  );
}

 void _onTap(int index) {
  if (bombs.contains(index)) {
    setState(() {
      colors[index] = Colors.red;
    });

    // mostrar mensaje de derrota y reiniciar después
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("¡Perdiste!"),
        content: const Text("Tocaste una bomba 💣"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: const Text("Reintentar"),
          ),
        ],
      ),
    );
  } else {
    setState(() {
      colors[index] = Colors.green;
    });
  }
}

  void _resetGame() {
  setState(() {
    // Generar bombas nuevas
    bombs = <int>{};
    while (bombs.length < 8) {
      bombs.add(_rand.nextInt(36)); // valores entre 0 y 35
    }

    // Reiniciar colores de todas las celdas a gris
    colors = List.generate(36, (_) => Colors.grey);
  });
}
}