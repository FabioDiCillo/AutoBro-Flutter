// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class PaymentPage extends StatefulWidget {
  final int carId;
  final String carPrice;

  const PaymentPage({
    super.key,
    required this.carId,
    required this.carPrice,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller per i campi di input
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _ccvController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String cardType = '';
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _cardNumberController.addListener(_updateCardType);

    _calculateTotal();
  }

  @override
  void dispose() {
    _cardNumberController.removeListener(_updateCardType);
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _ccvController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _updateCardType() {
    setState(() {
      cardType = _getCardType(_cardNumberController.text);
    });
  }

  void _calculateTotal() {
    String carPriceString = widget.carPrice;

    carPriceString = carPriceString.replaceAll('.', '').replaceAll(',', '.');

    double carPrice = double.tryParse(carPriceString) ?? 0.0;

    totalAmount = 500 + carPrice;
  }

  String formatPrice(double price) {
    final formatter =
        NumberFormat("#,###", "it_IT"); // "it_IT" per il formato italiano
    return formatter.format(price);
  }

  String _getCardType(String cardNumber) {
    if (cardNumber.length >= 2) {
      String prefix = cardNumber.substring(0, 2);
      switch (prefix) {
        case '53':
          return 'MasterCard';
        case '43':
          return 'Visa';
        case '52':
          return 'American Express';
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagamento'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // indirizzo di consegna
              TextFormField(
                controller: _addressController,
                keyboardType: TextInputType.streetAddress,
                decoration: const InputDecoration(
                  labelText: 'Indirizzo di consegna',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci un indirizzo di consegna';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              // Numero di carta
              TextFormField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  CardNumberInputFormatter(),
                ],
                decoration: InputDecoration(
                  labelText: 'Numero di Carta',
                  border: const OutlineInputBorder(),
                  hintText: 'XXXX XXXX XXXX XXXX',
                  suffixText: cardType,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci il numero di carta';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Data di scadenza
              TextFormField(
                controller: _expiryDateController,
                keyboardType: TextInputType.datetime,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                  CustomDateFormatter(),
                ],
                decoration: const InputDecoration(
                  labelText: 'Data di Scadenza (MM/AA)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci la data di scadenza';
                  }
                  final parts = value.split('/');
                  if (parts.length != 2) {
                    return 'Formato non valido. Usa MM/AA';
                  }
                  final month = int.tryParse(parts[0]);
                  if (month == null || month < 1 || month > 12) {
                    return 'Il mese deve essere tra 01 e 12';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // CCV
              TextFormField(
                controller: _ccvController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                decoration: const InputDecoration(
                  labelText: 'CCV',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci il CCV';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Numero di telefono
              TextFormField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Numero di Telefono',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci il numero di telefono';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32.0),

              // Visualizza il prezzo totale
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Prezzo Auto:',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      '${widget.carPrice} €',
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Passaggio:',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      '500 €',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Totale:',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Text(
                      '${formatPrice(totalAmount)} €', // Formattato correttamente
                      style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(255, 144, 4, 1)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32.0),
              // Pulsante di pagamento
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Logica per elaborare il pagamento

                    // Mostra il pop-up di conferma
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Acquisto Completato'),
                          content: const Text(
                              'Grazie del tuo acquisto, ti invieremo una mail con il dettaglio del tuo ordine.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color.fromRGBO(255, 155, 4, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0)),
                ),
                child: const Text(
                  'Acquista veicolo',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Classe personalizzata per formattare il numero della carta
class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String digits = newValue.text.replaceAll(' ', '');
    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      int index = i + 1;
      if (index % 4 == 0 && index != digits.length) {
        buffer.write(' '); // Aggiungi uno spazio ogni 4 cifre
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

// Classe personalizzata per formattare la data di scadenza
class CustomDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String digits = newValue.text.replaceAll('/', '');
    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      if (i == 1 && i != digits.length - 1) {
        buffer.write('/');
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
