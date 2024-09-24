import 'package:flutter/widgets.dart';
import 'package:presto/components/carcard.dart';

class Home extends StatefulWidget {
  const Home({super.key});
 
  @override
  State<Home> createState() => _HomeState();
}
 
class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: CarhomeWidget());

  }
}


