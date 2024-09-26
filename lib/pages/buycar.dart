// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// // import 'package:presto/components/cardetailcard.dart';
// class PaymentPage extends StatefulWidget {
//   final int carId;
//   const PaymentPage({super.key, required this.carId});

//   @override
//   // ignore: library_private_types_in_public_api
//   _PaymentPageState createState() => _PaymentPageState();
// }

// class _PaymentPageState extends State<PaymentPage> {
//   final _formKey = GlobalKey<FormState>();

//   // Controller per i campi di input
//   final TextEditingController _cardNumberController = TextEditingController();
//   final TextEditingController _expiryDateController = TextEditingController();
//   final TextEditingController _ccvController = TextEditingController();
//   final TextEditingController _phoneNumberController = TextEditingController();
//   String cardType = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Pagamento'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               // Numero di carta
//   TextFormField(
//                 controller: _cardNumberController,
//                 keyboardType: TextInputType.number,
//                 inputFormatters: [
//                   FilteringTextInputFormatter.digitsOnly, // Permetti solo numeri
//                   LengthLimitingTextInputFormatter(19), // Limita a 19 caratteri (16 numeri + 3 spazi)
//                   CardNumberInputFormatter(), // Formattazione con spazi
//                 ],
//                 decoration: InputDecoration(
//                   labelText: 'Numero di Carta',
//                   border: const OutlineInputBorder(),
//                   hintText: 'XXXX XXXX XXXX XXXX',
//                   // Mostra il tipo di carta in base ai primi due numeri
//                   suffixText: _getCardType(_cardNumberController.text),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Inserisci il numero di carta';
//                   }
//                   return null;
//                 },
//                 onChanged: (value) {
//                   // L'input formatter già gestisce il tipo di carta
//                 },
//               ),
//               const SizedBox(height: 16.0),

//               TextFormField(
//                 controller: _expiryDateController,
//                 keyboardType: TextInputType.datetime,
//                 inputFormatters: [
//                   // Aggiungi formattazione per MM/AA
//                   FilteringTextInputFormatter.digitsOnly,
//                   LengthLimitingTextInputFormatter(5),
//                   CustomDateFormatter(),
//                 ],
//                 decoration: const InputDecoration(
//                   labelText: 'Data di Scadenza (MM/AA)',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Inserisci la data di scadenza';
//                   }
//                   // Validazione del mese
//                   final parts = value.split('/');
//                   if (parts.length != 2) {
//                     return 'Formato non valido. Usa MM/AA';
//                   }
//                   final month = int.tryParse(parts[0]);
//                   if (month == null || month < 1 || month > 12) {
//                     return 'Il mese deve essere tra 01 e 12';
//                   }
//                   return null;
//                 },
//               ),              // Data di scadenza
        
//               const SizedBox(height: 16.0),

//               // CCV
//                TextFormField(
//                 controller: _ccvController,
//                 keyboardType: TextInputType.number,
//                 inputFormatters: [
//                   FilteringTextInputFormatter.digitsOnly, // Permetti solo numeri
//                   LengthLimitingTextInputFormatter(3), // Limita a 3 caratteri
//                 ],
//                 decoration: const InputDecoration(
//                   labelText: 'CCV',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Inserisci il CCV';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16.0),

//               // Numero di telefono
//               TextFormField(
//                 controller: _phoneNumberController,
//                 keyboardType: TextInputType.phone,
//                 decoration: const InputDecoration(
//                   labelText: 'Numero di Telefono',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Inserisci il numero di telefono';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 32.0),

//               // Pulsante di pagamento
//               ElevatedButton(
//                 onPressed: () {
//                   // Logica per elaborare il pagamento
//                 },
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 50), // Larghezza massima
//                   backgroundColor: const Color.fromRGBO(255, 155, 4, 1), 
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0))// Colore arancione
//                 ),
//                 child: const Text(
//                   'Acquista veicolo',
//                   style: TextStyle(color: Colors.black), // Colore del testo
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

// }
// class CustomDateFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
//     // Se l'input è vuoto, restituisci un valore vuoto
//     if (newValue.text.isEmpty) return newValue;

//     // Se il nuovo valore è più lungo di 5 caratteri, restituisci il valore vecchio
//     if (newValue.text.length > 5) return oldValue;

//     // Aggiungi lo '/' dopo le prime due cifre
//     String newText = newValue.text;
//     if (newText.length >= 2 && !newText.contains('/')) {
//       newText = '${newText.substring(0, 2)}/${newText.substring(2)}';
//     }

//     return TextEditingValue(
//       text: newText,
//       selection: TextSelection.collapsed(offset: newText.length),
//     );
//   }
// }
//  String _getCardType(String cardNumber) {
//     if (cardNumber.length >= 2) {
//       String prefix = cardNumber.substring(0, 2);
//       switch (prefix) {
//         case '53':
//           return 'MasterCard';
//         case '43':
//           return 'Visa';
//         case '52':
//           return 'American Express';
//       }
//     }
//     return ''; // Se nessuna corrispondenza, restituisci vuoto
//   }


// // Classe personalizzata per formattare il numero della carta
// class CardNumberInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
//     String digits = newValue.text.replaceAll(' ', ''); // Rimuovi spazi
//     StringBuffer buffer = StringBuffer();
    
//     for (int i = 0; i < digits.length; i++) {
//       if (i > 0 && i % 4 == 0) {
//         buffer.write(' '); // Aggiungi uno spazio ogni 4 caratteri
//       }
//       buffer.write(digits[i]);
//     }
    
//     return TextEditingValue(
//       text: buffer.toString(),
//       selection: TextSelection.collapsed(offset: buffer.length), // Mantieni il cursore alla fine
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentPage extends StatefulWidget {
  final int carId;
  const PaymentPage({super.key, required this.carId});

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

  String cardType = ''; // Variabile per memorizzare il tipo di carta

  @override
  void initState() {
    super.initState();
    _cardNumberController.addListener(_updateCardType); // Aggiungi listener
  }

  @override
  void dispose() {
    _cardNumberController.removeListener(_updateCardType); // Rimuovi listener
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
    return ''; // Se nessuna corrispondenza, restituisci vuoto
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagamento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Numero di carta
              TextFormField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16), // 12 numeri
                  CardNumberInputFormatter(), // Formattazione con spazi
                ],
                decoration: InputDecoration(
                  labelText: 'Numero di Carta',
                  border: const OutlineInputBorder(),
                  hintText: 'XXXX XXXX XXXX XXXX',
                  suffixText: cardType, // Visualizza il tipo di carta
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
                  LengthLimitingTextInputFormatter(3), // Massimo 3 cifre
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
                          content: const Text('Grazie del tuo acquisto, ti invieremo una mail con il dettaglio del tuo ordine.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Chiudi il dialogo
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
                  minimumSize: const Size(double.infinity, 50), // Larghezza massima
                  backgroundColor: const Color.fromRGBO(255, 155, 4, 1), // Colore arancione
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
                ),
                child: const Text(
                  'Acquista veicolo',
                  style: TextStyle(color: Colors.black), // Colore del testo
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
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String digits = newValue.text.replaceAll(' ', ''); // Rimuovi spazi
    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' '); // Aggiungi uno spazio ogni 4 caratteri
      }
      buffer.write(digits[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length), // Mantieni il cursore alla fine
    );
  }
}

// Classe personalizzata per la formattazione della data di scadenza
class CustomDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    if (newValue.text.length > 5) return oldValue;

    String newText = newValue.text;
    if (newText.length >= 2 && !newText.contains('/')) {
      newText = '${newText.substring(0, 2)}/${newText.substring(2)}';
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
