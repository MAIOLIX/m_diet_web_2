import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'result_display_widget.dart';
import 'models.dart';
import 'dart:convert';

class ImageCaptureWidget extends StatefulWidget {
  @override
  _ImageCaptureWidgetState createState() => _ImageCaptureWidgetState();
}

class _ImageCaptureWidgetState extends State<ImageCaptureWidget> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageData;
  String? _fileName;

  // Metodo per selezionare un'immagine dal file system
  Future<void> _pickImage() async {
    final XFile? imageFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      final bytes = await imageFile.readAsBytes();
      setState(() {
        _imageData = bytes;
        _fileName = imageFile.name;
      });
    }
  }

  // Metodo per acquisire un'immagine tramite fotocamera
  Future<void> _captureImage() async {
    // Controlla se la fotocamera è disponibile
    if (kIsWeb || Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Mostra un messaggio all'utente
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('La fotocamera non è disponibile su questa piattaforma.')),
      );
      return;
    }

    final XFile? imageFile =
        await _picker.pickImage(source: ImageSource.camera);
    if (imageFile != null) {
      final bytes = await imageFile.readAsBytes();
      setState(() {
        _imageData = bytes;
        _fileName = imageFile.name;
      });
    }
  }

  // Metodo per inviare l'immagine all'API
  Future<void> _analyzeImage() async {
    if (_imageData == null) return;

    try {
      var uri = Uri.parse('http://127.0.0.1:5000/recognize2');
      var request = http.MultipartRequest('POST', uri);
      request.files.add(
        http.MultipartFile.fromBytes(
          'immagine',
          _imageData!,
          filename: _fileName ?? 'image.png',
        ),
      );

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      // Decodifica la risposta JSON
      var jsonResponse = json.decode(responseData);
      Result result = Result.fromJson(jsonResponse);
      var customFood = FoodItem(
          name: "Custom",
          quantity: 0,
          confidence: 0,
          imageUrl: "",
          isMain: true,
          selected: false);
      List<FoodItem> listApp = [];
      listApp.add(customFood);
      var customFoodGroup = FoodGroup(foodFound: listApp);
      //result.addFoodGroup(customFoodGroup);
      // Naviga alla pagina dei risultati
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: Text('Risultati')),
            body: ResultDisplayWidget(result: result),
          ),
        ),
      );
    } catch (e) {
      print('Errore durante l\'invio dell\'immagine: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Controllo della disponibilità della fotocamera
    bool isCameraAvailable = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center, // Centra gli elementi orizzontalmente
      children: [
        // Spazio per l'anteprima dell'immagine
        Container(
          width: 300, // Imposta la larghezza desiderata
          height: 300, // Imposta l'altezza desiderata
          color: Colors.grey[300], // Colore di sfondo per il placeholder
          child: _imageData != null
              ? Image.memory(
                  _imageData!,
                  fit: BoxFit.cover,
                )
              : Center(
                  child: Text(
                    'Nessuna immagine\nselezionata',
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
        SizedBox(width: 20),
        // Colonna con i pulsanti
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Seleziona Immagine'),
            ),
            SizedBox(height: 10),
            if (isCameraAvailable)
              ElevatedButton(
                onPressed: _captureImage,
                child: Text('Scatta Foto'),
              ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _analyzeImage,
              child: Text('Analizza'),
            ),
          ],
        ),
      ],
    );
  }
}
