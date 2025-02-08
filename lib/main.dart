import 'dart:convert';
import 'package:flutter/material.dart';

// A simple encryption class that uses XOR operation with a secret key
class SimpleEncryptor {
  final String key;

  SimpleEncryptor(this.key);

  // Encrypts the input text using XOR operation and encodes it in Base64
  String encrypt(String text) {
    List<int> keyBytes = utf8.encode(key); // Convert key to bytes
    List<int> textBytes = utf8.encode(text); // Convert text to bytes

    // XOR each byte of text with corresponding key byte (repeating key if necessary)
    List<int> encryptedBytes = List.generate(textBytes.length, (i) =>
    textBytes[i] ^ keyBytes[i % keyBytes.length]);

    return base64.encode(encryptedBytes); // Convert result to Base64 for safe storage
  }

  // Decrypts the Base64 encoded encrypted text using XOR operation
  String decrypt(String encryptedText) {
    List<int> keyBytes = utf8.encode(key); // Convert key to bytes
    List<int> encryptedBytes = base64.decode(encryptedText); // Decode Base64 string back to bytes

    // XOR each encrypted byte with corresponding key byte to retrieve original text
    List<int> decryptedBytes = List.generate(encryptedBytes.length, (i) =>
    encryptedBytes[i] ^ keyBytes[i % keyBytes.length]);

    return utf8.decode(decryptedBytes); // Convert decrypted bytes back to string
  }
}

void main() {
  runApp(EncryptionApp());
}

// Main Flutter app widget
class EncryptionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EncryptionScreen(),
    );
  }
}

// Stateful widget to handle encryption and decryption
class EncryptionScreen extends StatefulWidget {
  @override
  _EncryptionScreenState createState() => _EncryptionScreenState();
}

class _EncryptionScreenState extends State<EncryptionScreen> {
  final TextEditingController textController = TextEditingController(); // Controller for user text input
  final TextEditingController keyController = TextEditingController(); // Controller for secret key input
  String encryptedText = "";
  String decryptedText = "";

  // Encrypts user input and updates UI
  void encryptText() {
    SimpleEncryptor encryptor = SimpleEncryptor(keyController.text);
    setState(() {
      encryptedText = encryptor.encrypt(textController.text);
    });
  }

  // Decrypts the encrypted text and updates UI
  void decryptText() {
    SimpleEncryptor encryptor = SimpleEncryptor(keyController.text);
    setState(() {
      decryptedText = encryptor.decrypt(encryptedText);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Encryption App'),
        backgroundColor: Color(0xFF9370DB),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE6E6FA), Color(0xFFC8A2C8)], // Lavender to Lilac gradient
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: 'Enter text',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: keyController,
              decoration: InputDecoration(
                labelText: 'Enter secret key',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              obscureText: true, // Hides the secret key for security
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: encryptText,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFBA55D3), // Medium Orchid button color
              ),
              child: Text(
                'Encrypt',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Encrypted: $encryptedText',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: decryptText,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFBA55D3), // Medium Orchid button color
              ),
              child: Text(
                'Decrypt',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Decrypted: $decryptedText',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
