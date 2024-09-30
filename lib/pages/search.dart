import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:presto/components/cardetailcard.dart';

class Carhome {
  final int id;
  final String title;
  final String? image;
  final String littleDescription;
  final String gearBox;
  final int kilometers;
  final DateTime? dateOfFirstRegistration;
  final double price;

  Carhome({
    required this.id,
    required this.title,
    this.image,
    required this.littleDescription,
    required this.gearBox,
    required this.kilometers,
    this.dateOfFirstRegistration,
    required this.price,
  });

  factory Carhome.fromJson(Map<String, dynamic> json) {
    return Carhome(
      id: int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] ?? '',
      image: json['image'] != null && json['image'] is Map<String, dynamic>
          ? json['image']['url']
          : null,
      littleDescription: json['littleDescription'] ?? '',
      gearBox: json['gearBox'] ?? '',
      kilometers: int.tryParse(json['kilometers'].toString()) ?? 0,
      dateOfFirstRegistration: json['dateOfFirstRegistration'] != null
          ? DateTime.tryParse(json['dateOfFirstRegistration'])
          : null,
      price: double.tryParse(json['price'].toString()) ?? 0.0,
    );
  }

  String getFormattedDate() {
    if (dateOfFirstRegistration != null) {
      return "${dateOfFirstRegistration!.day}/${dateOfFirstRegistration!.month}/${dateOfFirstRegistration!.year}";
    }
    return '';
  }
}

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _controllerRicerca = TextEditingController();
  List<Carhome> _risultatiRicerca = [];
  bool _isLoading = false;
  String _errore = '';

  Future<List<Carhome>> cercaAuto(String query) async {
    List<Carhome> cars = [];
    try {
      // Suddividi la query in parole chiave
      final keywords = query.split(' ').map((word) => word.trim()).where((word) => word.isNotEmpty).toList();

      // Crea una stringa di query concatenando le parole chiave
      final queryString = keywords.join('&query=');

      var response = await http.get(
        Uri.parse('http://10.11.11.116:1337/api/product-search/search?query=$queryString'),
        headers: {"Content-Type": "application/json"},
      );

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
        print('Errore nella richiesta: ${response.statusCode}');
        throw Exception('Errore nel caricamento dei dati: ${response.statusCode}');
      }
    } catch (e) {
      print('Errore nella ricerca: $e');
      throw Exception('Errore durante la ricerca: $e');
    }
    return cars;
  }

  void _eseguiRicerca() async {
    setState(() {
      _isLoading = true;
      _errore = '';
    });

    if (_controllerRicerca.text.isNotEmpty) {
      try {
        final risultati = await cercaAuto(_controllerRicerca.text);
        setState(() {
          _risultatiRicerca = risultati;
        });
      } catch (e) {
        setState(() {
          _errore = e.toString();
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
        _errore = 'Inserisci un termine di ricerca';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text.rich(
          TextSpan(
            text: 'Cerca ',
            style: TextStyle(fontSize: 24, color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                text: 'Auto',
                style: TextStyle(color: Colors.orange, fontSize: 24),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _controllerRicerca,
              decoration: InputDecoration(
                hintText: 'Cerca per modello, marca, colore, ecc.',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _eseguiRicerca,
                ),
              ),
            ),
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_errore.isNotEmpty)
            Center(child: Text('Errore: $_errore'))
          else if (_risultatiRicerca.isEmpty)
            const Center(child: Text('Nessun risultato trovato')),
          Expanded(
            child: ListView.builder(
              itemCount: _risultatiRicerca.length,
              itemBuilder: (context, index) {
                final car = _risultatiRicerca[index];
                return _buildCarhome(car);
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildCarhome(Carhome car) {
    bool isFavorited = false;

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
                      Image.network('http://10.11.11.116:1337${car.image!}'),
                    
                    Positioned(
                      top: 8,
                      left: 8,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isFavorited = !isFavorited;
                          });

                          if (isFavorited) {
                            print('Aggiunto ai preferiti: ${car.title}');
                          } else {
                            print('Rimosso dai preferiti: ${car.title}');
                          }
                        },
                        child: Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: isFavorited ? const Color.fromRGBO(255, 155, 4, 1) : const Color.fromARGB(255, 4, 4, 4),
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
                      '€${NumberFormat('#,###','it_IT').format(car.price)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(255, 155, 4, 1),
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
                  'KM: ${NumberFormat('#,###','it_IT').format(car.kilometers)}',
              style: const TextStyle(fontSize: 14),
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