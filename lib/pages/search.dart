import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String searchText = '';
  String? selectedBrend;
  String? selectedColor;
  String? selectedTraction;
  String? selectedFuelType;
  String? selectedGearBox;
  String? selectedCarType;

  bool _isLoading = false;
  String _errore = '';
  List<Carhome> _risultatiRicerca = []; // Change to List<Carhome>

  // Filter options
  final List<String> brendOptions = ['Abarth', 'Alfa Romeo', 'Audi', 'BMW', 'Citroën', 'Cupra', 'Dacia', 'DS Automobiles', 'EVO', 'Fiat', 'Ford', 'Honda', 'Hyundai', 'Jaguar', 'Jeep', 'Kia', 'Lancia', 'Land Rover', 'Lexus', 'MG', 'MINI', 'Mazda', 'Mercedes-Benz', 'Mitsubishi', 'Nissan', 'Opel', 'Peugeot', 'Renault', 'Seat', 'Skoda', 'Smart', 'SsangYong', 'Subaru', 'Suzuki', 'Toyota', 'Volkswagen', 'Volvo'];
  final List<String> colorOptions = ['Nero', 'Grigio', 'Bianco', 'Argento', 'Blu', 'Rosso', 'Marrone', 'Verde', 'Beige', 'Arancione', 'Oro', 'Giallo', 'Viola'];
  final List<String> tractionOptions = ['4X4', 'Anteriore', 'Posteriore'];
  final List<String> fuelTypeOptions = ['Ibrido', 'Diesel', 'Elettrico', 'Benzina', 'Gpl', 'Metano'];
  final List<String> gearBoxOptions = ['Automatico', 'Manuale'];
  final List<String> carTypeOptions = ['SUV', 'Station Wagon', 'Berlina', 'Van / Minibus', 'Coupé', 'Cabriolet', 'Pickup', 'Familiare', 'City Car', 'Compatta', 'Monovolume', 'Fuoristrada', 'Sportiva', 'Crossover', 'Altro'];

  void _cancellaFiltri() {
    setState(() {
      searchText = '';
      selectedBrend = null;
      selectedColor = null;
      selectedTraction = null;
      selectedFuelType = null;
      selectedGearBox = null;
      selectedCarType = null;
    });
  }

  void _eseguiRicerca() async {
    Future<List<Carhome>> cercaAuto() async {
      List<Carhome> cars = [];
      try {
        String queryString = '';
        if (selectedBrend != null) queryString += 'brend=$selectedBrend&';
        if (selectedColor != null) queryString += 'color=$selectedColor&';
        if (selectedTraction != null) queryString += 'traction=$selectedTraction&';
        if (selectedFuelType != null) queryString += 'fuelType=$selectedFuelType&';
        if (selectedGearBox != null) queryString += 'gearBox=$selectedGearBox&';
        if (selectedCarType != null) queryString += 'carType=$selectedCarType&';
        if (searchText.isNotEmpty) queryString += 'query=$searchText&';

        queryString = queryString.isNotEmpty
            ? queryString.substring(0, queryString.length - 1)
            : queryString;

        var response = await http.get(
          Uri.parse('http://10.11.11.116:1337/api/product-search/search?$queryString'),
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
            }
          } else {
            throw Exception('Oggetto JSON non contiene la chiave "data"');
          }
        } else {
          throw Exception('Errore nel caricamento dei dati: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('Errore durante la ricerca: $e');
      }
      return cars;
    }

    setState(() {
      _isLoading = true;
      _errore = '';
    });

    try {
      final risultati = await cercaAuto();
      if (risultati.isEmpty) {
        setState(() {
          _errore = 'Nessun veicolo presente'; // Show no vehicle message
        });
      }
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Filtri di Ricerca', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
               TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cerca auto...',
                prefixIcon: Icon(Icons.search), // Added search icon
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Brend'),
                value: selectedBrend,
                items: brendOptions.map((brend) {
                  return DropdownMenuItem(
                    value: brend,
                    child: Text(brend),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedBrend = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Colore'),
                value: selectedColor,
                items: colorOptions.map((color) {
                  return DropdownMenuItem(
                    value: color,
                    child: Text(color),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedColor = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Traction'),
                value: selectedTraction,
                items: tractionOptions.map((traction) {
                  return DropdownMenuItem(
                    value: traction,
                    child: Text(traction),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTraction = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Tipo di Carburante'),
                value: selectedFuelType,
                items: fuelTypeOptions.map((fuelType) {
                  return DropdownMenuItem(
                    value: fuelType,
                    child: Text(fuelType),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedFuelType = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Cambio'),
                value: selectedGearBox,
                items: gearBoxOptions.map((gearBox) {
                  return DropdownMenuItem(
                    value: gearBox,
                    child: Text(gearBox),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGearBox = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Tipo di Auto'),
                value: selectedCarType,
                items: carTypeOptions.map((carType) {
                  return DropdownMenuItem(
                    value: carType,
                    child: Text(carType),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCarType = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _eseguiRicerca();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Text('Applica', style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _cancellaFiltri();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Text('Cancella', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
           
            const SizedBox(height: 16),
            if (_isLoading) const CircularProgressIndicator(),
            if (_errore.isNotEmpty) Text(_errore, style: const TextStyle(color: Colors.red)),
            Expanded(
              child: ListView.builder(
                itemCount: _risultatiRicerca.length,
                itemBuilder: (context, index) {
                  final car = _risultatiRicerca[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (car.image != null)
                            Image.network('http://10.11.11.116:1337${car.image!}'),
                          Text(car.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(car.littleDescription),
                          const SizedBox(height: 8),
                          Text('Km: ${car.kilometers}'),
                          const SizedBox(height: 8),
                          Text(car.gearBox),
                          const SizedBox(height: 8),
                          Text(car.dateOfFirstRegistration?.toLocal().toString().split(' ')[0] ?? 'N/A'),
                          const SizedBox(height: 8),
                          Text(
                            '€ ${car.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d+)(\d{3})'), (Match m) => '${m[1]}.${m[2]}')}', // Price formatting
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromRGBO(255, 144, 4, 1)),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CarDetailWidget(carId: car.id, car: car),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              child: const Text('Visualizza Auto', style: TextStyle(color: Colors.black)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}