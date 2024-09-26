// import 'package:flutter/material.dart';
// import 'homepage.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatefulWidget {   
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     super.initState(); 
//   }

// @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       // title: 'Flutter Demo',
//       // theme: ThemeData(
//       //   primarySwatch: Colors.blue,
//       // ),
//       home: Homepage(username: '',), 
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'pages/login.dart'; // Assicurati che il percorso sia corretto
import 'pages/buycar.dart'; // Assicurati che il percorso sia corretto

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'La tua App', // Opzionale: aggiungi un titolo
      initialRoute: '/',
      routes: {
        '/': (context) => const Homepage(username: ''), // Assicurati che la tua Homepage sia corretta
        '/login': (context) => const LoginPage(), // Aggiungi la tua LoginPage qui
        '/buycar': (context) => const PaymentPage(carId: 0), // Aggiungi la tua PaymentPage qui con carId di default
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (context) => UnknownPage());
      },
    );
  }
}

class UnknownPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('404')),
      body: const Center(child: Text('Pagina non trovata')),
    );
  }
}
