import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:presto/models/carhome.dart';
import 'package:presto/components/cardetailcard.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Carhome>> cercaAuto(String query) async {
  List<Carhome> cars = [];
  try {
    var response = await http.get(Uri.parse('http://10.11.11.124:1337/api/products-detail'));

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      if (body is Map<String, dynamic> && body.containsKey('data')) {
        var carList = body['data'];
        if (carList is List) {
          for (var item in carList) {
            if (item is Map<String, dynamic>) {
              cars.add(Carhome.fromJson(item));
            }
          }
        } else {
          throw Exception('La chiave "data" non contiene una lista');
        }
      } else {
        throw Exception('Oggetto JSON non contiene la chiave "data"');
      }
    } else {
      throw Exception('Errore nel caricamento dei dati: ${response.statusCode}');
    }
  } catch (e) {
    print('Errore nella ricerca: $e');
  }
  return cars;
}

class CarhomeWidget extends StatefulWidget {
  const CarhomeWidget({Key? key}) : super(key: key);

  @override
  _CarhomeWidgetState createState() => _CarhomeWidgetState();
}

class _CarhomeWidgetState extends State<CarhomeWidget> {
  late Future<List<Carhome>> cars;

  @override
  void initState() {
    super.initState();
    cars = cercaAuto('');
    
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Carhome>>(
      future: cars,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final car = snapshot.data![index];
              return _buildCarhome(car);
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

 Widget _buildCarhome(Carhome car) {
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  if (car.image != null)
                    Image.network('http://10.11.11.124:1337${car.image!}'),

                  Positioned(
                      top: 8,
                      left: 8,
                      child: GestureDetector(
                        onTap: () async {
                          if (await isUserLoggedIn()) {
                            // Cambia lo stato del preferito lato server
                            bool newFavoriteStatus = await toggleFavorite(car.id, car.isFavorite);

                            // Aggiorna lo stato localmente
                            setState(() {
                              car.setIsFavorited(newFavoriteStatus); 
                            });
                          } else {
                            // Se non è loggato, reindirizza alla pagina di login
                            Navigator.pushNamed(context, '/login');
                          }
                        },
                        child: Icon(
                          car.isFavorite ? Icons.favorite : Icons.favorite_border, // Icona piena o vuota
                          color: car.isFavorite 
                              ? const Color.fromRGBO(255, 155, 4, 1) // Colore arancione se nei preferiti
                              : const Color.fromARGB(255, 4, 4, 4),  // Colore nero se non è nei preferiti
                          size: 30,
                        ),
                      ),
                  ),

                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    car.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '€${car.price}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(255, 155, 4, 1), // Arancione per il prezzo
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                car.littleDescription,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 4),
              Text(
                'Km: ${car.kilometers}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 4),
              Text(
                car.gearBox,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 4),
              Text(
                car.getFormattedDate(),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CarDetailWidget(carId: car.id),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: const Color.fromRGBO(255, 155, 4, 1),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Visualizza Auto',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

}

Future<bool> isUserLoggedIn() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId'); // Ottieni l'ID utente
    print('User ID trovato: $userId');
    return userId != null;
  } catch (e) {
    print('Errore durante il caricamento di SharedPreferences: $e');
    return false;
  }
}

Future<bool> toggleFavorite(int carId, bool isCurrentlyFavorited) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? userId = prefs.getInt('userId');

  if (userId == null) return false;

  final url = Uri.parse('http://10.11.11.124:1337/api/favourites/manage');
  String action = isCurrentlyFavorited ? "remove" : "add";

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'loggedUserId': userId,
        'productId': carId,
        'action': action,
      }),
    );

    if (response.statusCode == 200) {
      // Considera il cambiamento di stato in base all'azione
      bool newFavoriteStatus = !isCurrentlyFavorited;
      print(newFavoriteStatus ? 'Aggiunto ai preferiti' : 'Rimosso dai preferiti');
      return newFavoriteStatus;
    } else {
      print('Errore durante l\'aggiornamento dei preferiti: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Errore durante l\'aggiornamento dei preferiti: $e');
    return false;
  }
}



