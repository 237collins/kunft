import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Importez le nouveau package

class QrGeneratorPage extends StatefulWidget {
  const QrGeneratorPage({super.key});

  @override
  State<QrGeneratorPage> createState() => _QrGeneratorPageState();
}

class _QrGeneratorPageState extends State<QrGeneratorPage> {
  final TextEditingController _textController = TextEditingController(
    text: 'Hello, Flutter!',
  );

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Generator'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Enter text to generate QR code',
                  border: OutlineInputBorder(),
                ),
                onChanged: (text) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 32),
              if (_textController.text.isNotEmpty)
                // Utilisation du widget QrImageView
                QrImageView(
                  data: _textController.text,
                  size: 250,
                  backgroundColor: Colors.white,
                ),
              if (_textController.text.isEmpty)
                const Text(
                  'Enter text to see the QR code',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
