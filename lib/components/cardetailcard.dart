
// ignore_for_file: library_private_types_in_public_api
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:presto/pages/buycar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:presto/models/detailcar.dart';

Future<DetailCar> fetchCarDetails(int id) async {
  try {
    var response = await http.get(Uri.parse('http://10.11.11.116:1337/api/products-detail-single/$id'));

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      if (body is Map<String, dynamic> && body.containsKey('data')) {
        var carDetails = body['data'];
        if (carDetails is Map<String, dynamic>) {
          return DetailCar.fromJson(carDetails);
        } else {
          throw Exception('Il dato non è un oggetto JSON');
        }
      } else {
        throw Exception('Oggetto JSON non contiene la chiave "data"');
      }
    } else {
      throw Exception('Errore nel caricamento dei dati: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Errore: $e');
  }
}

class CarDetailWidget extends StatefulWidget {
  final int carId;

  const CarDetailWidget({
    super.key,
    required this.carId,
  });

  @override
  _CarDetailWidgetState createState() => _CarDetailWidgetState();
}

class _CarDetailWidgetState extends State<CarDetailWidget> {
  late Future<DetailCar> detailCar;
  bool isFavorited = false;
  bool isDescriptionExpanded = false;
  bool isContactVisible = false;

  @override
  void initState() {
    super.initState();
    detailCar = fetchCarDetails(widget.carId);
  }

  Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('userId'); // Assumendo che 'userId' sia salvato dopo il login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettagli Auto'),
      ),
      body: FutureBuilder<DetailCar>(
        future: detailCar,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          if (snapshot.data!.image != null)
                            Image.network('http://10.11.11.116:1337${snapshot.data!.image!}'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              snapshot.data!.title,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            '€${snapshot.data!.price}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(255, 155, 4, 1),
                            ),
                          ),
                        ],
                      ),
                      const Divider(thickness: 1, color: Color.fromRGBO(255, 155, 4, 1)),
                      const SizedBox(height: 8),

                      _buildRowWithIcon(Icons.description, snapshot.data!.littleDescription),
                      const Divider(thickness: 1),
                      _buildRowWithIcon(Icons.speed, 'KM: ${snapshot.data!.kilometers}'),
                      const Divider(thickness: 1),
                      _buildRowWithIcon(Icons.settings, 'Cambio: ${snapshot.data!.gearBox}'),
                      const Divider(thickness: 1),
                      _buildRowWithIcon(Icons.terrain, 'Trazione: ${snapshot.data!.tractionType}'),
                      const Divider(thickness: 1),
                      _buildRowWithIcon(Icons.flash_on, 'CV: ${snapshot.data!.cv}'),
                      const Divider(thickness: 1),
                      _buildRowWithIcon(Icons.color_lens, 'Colore: ${snapshot.data!.color}'),
                      const Divider(thickness: 1),
                      _buildRowWithIcon(Icons.local_offer, 'Brend: ${snapshot.data!.brend}'),
                      const Divider(thickness: 1),
                      _buildRowWithIcon(Icons.local_gas_station, 'Alimentazione: ${snapshot.data!.fuelType}'),
                      const Divider(thickness: 1),
                      _buildRowWithIcon(Icons.directions_car, 'Classe del veicolo: ${snapshot.data!.carType}'),
                      const Divider(thickness: 1),
                      _buildRowWithIcon(Icons.credit_card, 'Targa: ${snapshot.data!.plate}'),
                      const SizedBox(height: 10),

                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color.fromRGBO(255, 144, 4, 1), width: 1.0),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: ExpansionTile(
                          leading: const Icon(Icons.list_alt),
                          title: const Text('Optional'),
                          initiallyExpanded: isDescriptionExpanded,
                          onExpansionChanged: (expanded) {
                            setState(() {
                              isDescriptionExpanded = expanded;
                            });
                          },
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                snapshot.data!.description,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                bool isLoggedIn = await isUserLoggedIn();  // Verifica se l'utente è loggato
                                if (isLoggedIn) {
                                  // Se loggato, naviga alla pagina di acquisto
                                  Navigator.push(
                                    // ignore: use_build_context_synchronously
                                    context,
                                   MaterialPageRoute(
                                          builder: (context) => PaymentPage(carId: snapshot.data!.id, carPrice: snapshot.data!.price),
                                    ),

                                  );
                                } else {
                                  // Se non loggato, reindirizza alla pagina di login
                                  // ignore: use_build_context_synchronously
                                  Navigator.pushNamed(context, '/login');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                                backgroundColor: const Color.fromRGBO(255, 155, 4, 1),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              child: const Text('Acquista'),
                            ),
                          ),
                          const SizedBox(width: 10),
                         Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Contattaci'),
                                  content: const Text(
                                    'Dal lunedì al venerdì dalle 9 alle 21 a questo numero: 080 53141105',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Chiude il dialogo
                                      },
                                      child: const Text('Chiudi'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                            backgroundColor: const Color.fromRGBO(255, 155, 4, 1),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: const Text('Contattaci'),
                        ),
                      ),

                    ],
                  ),
                ]
              ),
              ),
            )
          );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
  Widget _buildRowWithIcon(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.black54),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
