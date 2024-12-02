import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_now/core/helpers/safe_print.dart';

class LicensePlateScanner extends StatefulWidget {
  const LicensePlateScanner({super.key});

  @override
  _LicensePlateScannerState createState() => _LicensePlateScannerState();
}

class _LicensePlateScannerState extends State<LicensePlateScanner> {
  File? _selectedImage;
  String _licensePlate = "لم يتم العثور على الرقم";

  final ImagePicker _picker = ImagePicker();

  final Map<String, String> letterMap = {
    'A': 'ا', // English A -> Arabic ا
    'B': 'ب', // English B -> Arabic ب
    'C': 'ج', // English C -> Arabic ج
    'D': 'د', // English D -> Arabic د
    'E': 'ه', // English E -> Arabic ه
    'F': 'ف', // English F -> Arabic ف
    'G': 'غ', // English G -> Arabic غ
    'H': 'ح', // English H -> Arabic ح
    'I': 'ي', // English I -> Arabic ي
    'J': 'ج', // English J -> Arabic ج
    'K': 'ك', // English K -> Arabic ك
    'L': 'ل', // English L -> Arabic ل
    'M': 'م', // English M -> Arabic م
    'N': 'ن', // English N -> Arabic ن
    'O': 'و', // English O -> Arabic و
    'P': 'ب', // English P -> Arabic ب
    'Q': 'ق', // English Q -> Arabic ق
    'R': 'ر', // English R -> Arabic ر
    'S': 'س', // English S -> Arabic س
    'T': 'ط', // English T -> Arabic ط
    'U': 'ع', // English U -> Arabic ع
    'V': 'ف', // English V -> Arabic ف
    'W': 'و', // English W -> Arabic و
    'X': 'ك', // English X -> Arabic ك
    'Y': 'ي', // English Y -> Arabic ي
    'Z': 'ز', // English Z -> Arabic ز
  };


  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
      _scanText(File(image.path));
    }
  }

  Future<void> _scanText(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer();

    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      List<String> letters = [];
      List<String> numbers = [];

      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          String text = line.text.trim();
          safePrint("Raw recognized text: $text");

          for (int i = 0; i < text.length; i++) {
            final char = text[i];
            if (letterMap.containsKey(char)) {
              letters.add(letterMap[char]!); // Add corresponding Arabic letter
              safePrint("Letter added: ${letterMap[char]}");
            }
          }

          // Extract numbers
          RegExp(r'\d+').allMatches(text).forEach((match) {
            numbers.add(match.group(0)!);  // Add found numbers to numbers list
            safePrint("Number added: ${match.group(0)}");
          });
        }
      }

      // Debugging: Print the letters and numbers
      safePrint("Letters: $letters");
      safePrint("Numbers: $numbers");

      // Combine the numbers and letters
      String formattedPlate = [
        ...numbers.reversed, // Reverse the order of numbers
        ...letters, // Append mapped letters
      ].join(" ");

      // Convert numbers to Arabic numerals
      formattedPlate = convertNumbersToArabic(formattedPlate);

      setState(() {
        _licensePlate = formattedPlate.isNotEmpty
            ? formattedPlate
            : "لم يتم التعرف على رقم لوحة السيارة";
      });
    } catch (e) {
      setState(() {
        _licensePlate = "حدث خطأ أثناء قراءة النص: $e";
      });
    }
  }

  String convertNumbersToArabic(String input) {
    const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return input.replaceAllMapped(RegExp(r'[0-9]'), (match) {
      return arabicNumbers[int.parse(match.group(0)!)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ماسح لوحة السيارة")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_selectedImage != null)
              Image.file(
                _selectedImage!,
                height: 200,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text("اختيار صورة من المعرض"),
            ),
            const SizedBox(height: 16),
            Text(
              "رقم اللوحة: $_licensePlate",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
