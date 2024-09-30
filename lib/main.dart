// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'homepage.dart';
import 'pages/login.dart';
import 'pages/buycar.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'La tua App',
      initialRoute: '/',
      routes: {
        '/': (context) => const Homepage(username: ''),
        '/login': (context) => const LoginPage(),
        '/buycar': (context) => const PaymentPage(
              carId: 0,
              carPrice: '0',
            ),
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
