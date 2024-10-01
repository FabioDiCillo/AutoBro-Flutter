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
    return Center(
      child: CarhomeWidget(
        carId: 0,
        id: null,
        title: null,
        littleDescription: '',
        kilometers: 0,
        imageUrl: '',
        gearBox: '',
        price: 0,
        registrationDate: DateTime.now(),
      ),
    );
  }
}


