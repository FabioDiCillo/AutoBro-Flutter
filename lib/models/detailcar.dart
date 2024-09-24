
import 'package:intl/intl.dart';

class DetailCar{
  final int id;
  final String title;
  final String kilometers;
  final String gearBox;
  final String price;
  final DateTime dateOfFirstRegistration;
  final String? image;
  final String description;
  final String fuelType;
  final String brend;
  final String color;
  final String cv;
  final String plate;
  final String tractionType;
  final String carType;
  final String littleDescription;

  const DetailCar({
    required this.id,
    required this.title,
    required this.kilometers,
    required this.gearBox,
    required this.price,
    required this.dateOfFirstRegistration,
    this.image,
    required this.description,
    required this.fuelType,
    required this.brend,
    required this.color,
    required this.cv,
    required this.plate,
    required this.tractionType,
    required this.carType,
    required this.littleDescription,
  })  ;

  factory DetailCar.fromJson(Map<String, dynamic> json) {
    return DetailCar(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Nessun titolo',
       kilometers: json['kilometers'] != null ? json['kilometers'].toString() : '0',
        gearBox: json['gearBox'] ?? 'Sconosciuto',
      price: json['price'] != null ? json['price'].toString() : '0',
      dateOfFirstRegistration: json['dateOfFirstRegistration'] != null ? DateTime.parse(json['dateOfFirstRegistration']) : DateTime.now(),
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      fuelType: json['fuelType'] ?? '',
      brend: json['brend'] ?? '',
      color: json['color'] ?? '',
      cv: json['cv'] ?? '',
      plate: json['plate'] ?? '',
      tractionType: json['tractionType'] ?? '',
      carType: json['carType'] ?? '',
      littleDescription: json['littleDescription'] ?? '',
    );
  }
  String getFormattedDate() {
    return DateFormat('dd/MM/yyyy').format(dateOfFirstRegistration);
  }
}