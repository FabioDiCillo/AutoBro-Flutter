// ignore_for_file: non_constant_identifier_names, use_key_in_widget_constructors, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:presto/components/cardetailcard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Favorite {
  int id;
  int favourite_veichle;

  Favorite({required this.id, required this.favourite_veichle});

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'],
      favourite_veichle: json['favourite_veichle'],
    );
  }
}

Future<List<Map<String, dynamic>>> fetchFavoriteVehicles(
    int favourite_veichle) async {
  List<Map<String, dynamic>> vehicles = [];
  final url = Uri.parse(
      'http://10.11.11.116:1337/api/favourite-veichles-detail/$favourite_veichle');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      if (body is Map<String, dynamic>) {
        if (body.containsKey('products')) {
          vehicles = List<Map<String, dynamic>>.from(body['products']);
        } else {
          throw Exception('Oggetto JSON non contiene la chiave "products"');
        }
      } else {
        throw Exception('Oggetto JSON non è valido');
      }
    } else if (response.statusCode == 404) {
      throw Exception(
          'Veicolo preferito non trovato per ID: $favourite_veichle');
    } else {
      print('Corpo della risposta: ${response.body}');
      throw Exception(
          'Errore nel caricamento dei dati: ${response.statusCode}');
    }
  } catch (e) {
    print('Errore nella ricerca delle auto preferite: $e');
  }
  return vehicles;
}

class FavoriteVehiclesWidget extends StatefulWidget {
  @override
  _FavoriteVehiclesWidgetState createState() => _FavoriteVehiclesWidgetState();
}

class _FavoriteVehiclesWidgetState extends State<FavoriteVehiclesWidget> {
  late Future<List<Map<String, dynamic>>> favoriteVehicles;

  @override
  void initState() {
    super.initState();
    favoriteVehicles = _loadUserIdAndFetchFavorites();
  }

  Future<List<Map<String, dynamic>>> _loadUserIdAndFetchFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    if (userId != null) {
      return fetchFavoriteVehicles(userId);
    } else {
      throw Exception('Utente non autenticato');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: favoriteVehicles,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final vehicle = snapshot.data![index];
              return _buildVehicleCard(vehicle);
            },
          );
        } else if (snapshot.hasError) {
          return const Center(
              child: Text('Effettua il login per visualizzare i preferiti'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildVehicleCard(Map<String, dynamic> vehicle) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (vehicle['image'] != null)
              Image.network('http://10.11.11.116:1337${vehicle['image']}'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    vehicle['title'],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  '€${vehicle['price'] != null ? NumberFormat('#,###', 'it_IT').format(int.tryParse(vehicle['price'].toString()) ?? 0) : 'N/A'}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(255, 155, 4, 1),
                  ),
                )
              ],
            ),
            const SizedBox(height: 4),
            Text(
              vehicle['littleDescription'],
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 4),
            Text(
              'KM: ${vehicle['kilometers'] != null ? NumberFormat('#,###', 'it_IT').format(int.tryParse(vehicle['kilometers'].toString()) ?? 0) : 'N/A'}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(vehicle['gearBox'], style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Text(vehicle['dateOfFirstRegistration'],
                style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarDetailWidget(
                        carId: vehicle['id']), // Passa l'ID della macchina
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
  }
}
