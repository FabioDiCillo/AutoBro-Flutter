import 'package:intl/intl.dart';

class Carhome {
  final int id;
  final String title;
  final String littleDescription;
  final String kilometers;
  final String gearBox;
  final String price;
  final DateTime dateOfFirstRegistration;
  final String? image;
  bool isFavorite;
   // ignore: non_constant_identifier_names
   

  Carhome({   
     required this.id,
    required this.title,
    required this.littleDescription,
    required this.kilometers,
    required this.gearBox,
    required this.price,
    required this.dateOfFirstRegistration,
    this.image,
    this.isFavorite = true,
    // ignore: non_constant_identifier_names
    
  });

  factory Carhome.fromJson(Map<String, dynamic> json) {
    return Carhome(
      id: json['id'] ?? 0,  // Fornisci valori di default se necessario
      title: json['title'] ?? 'Nessun titolo',
      littleDescription: json['littleDescription'] ?? 'Nessuna descrizione',
      kilometers: json['kilometers'] != null ? json['kilometers'].toString() : '0',
      gearBox: json['gearBox'] ?? 'Sconosciuto',
      price: json['price'] != null ? json['price'].toString() : '0',
      dateOfFirstRegistration: json['dateOfFirstRegistration'] != null ? DateTime.parse(json['dateOfFirstRegistration']) : DateTime.now(),
      image: json['image'] ?? '',
      isFavorite: json['isFavorited']?? false,
      
    );
  }
  void setIsFavorited(bool value){
    isFavorite= value;
  }
   String getFormattedDate() {
    return DateFormat('dd/MM/yyyy').format(dateOfFirstRegistration);
  }
    double getPriceAsDouble() {
    return double.tryParse(price) ?? 0.0; // Converte il prezzo in double
  }
  
}
