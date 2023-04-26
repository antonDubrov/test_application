import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_application/services/picker_image_service.dart';

///Our main page with main content
class HomeScreen extends StatefulWidget {
  /// Key for pickFirstImage button
  static const String pickFirstImageButtonKey = 'pickFirstImageButtonKey';

  /// Key for pickSecondImage button
  static const String piskSecondImageButtonKey = 'piskSecondImageButtonKey';

  /// Default constructor of HomeScreen class
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PickerImageService _pickerImageService = PickerImageService();

  String _firstImagePath = '';
  String _secondImagePath = '';
  static const double _imageSize = 150;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Comparison Example'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (_firstImagePath != '')
                    Image.file(
                      File(_firstImagePath),
                      width: _imageSize,
                      height: _imageSize,
                    ),
                  ElevatedButton(
                    key: const ValueKey(HomeScreen.pickFirstImageButtonKey),
                    onPressed: () async {
                      final imagePath =
                          await _pickerImageService.pickImageFromGallery();
                      setState(() => _firstImagePath = imagePath);
                    },
                    child: const Text('Pick Image 1'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (_secondImagePath != '')
                    Image.file(
                      File(_secondImagePath),
                      width: _imageSize,
                      height: _imageSize,
                    ),
                  ElevatedButton(
                    key: const ValueKey(HomeScreen.piskSecondImageButtonKey),
                    onPressed: () async {
                      final imagePath =
                          await _pickerImageService.pickImageFromGallery();
                      setState(() => _secondImagePath = imagePath);
                    },
                    child: const Text('Pick Image 2'),
                  ),
                ],
              ),
            ),
            if (_firstImagePath != '' && _secondImagePath != '')
              ElevatedButton(
                onPressed: () async {
                  final comparisonResult = await _compareImages(
                    File(_firstImagePath),
                    File(_secondImagePath),
                  );
                  _showModal(comparisonResult: comparisonResult);
                },
                child: const Text('Compare Images'),
              ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _compareImages(File image1, File image2) async {
    final fileName1 = image1.path.split('/').last.split('.').first;
    final fileName2 = image2.path.split('/').last.split('.').first;

    final format1 = image1.path.split('.').last;
    final format2 = image2.path.split('.').last;

    final bytes1 = await image1.readAsBytes();
    final bytes2 = await image2.readAsBytes();

    var isBytesSimilar = true;
    if (bytes1.length != bytes2.length) {
      isBytesSimilar = false;
    } else {
      for (var i = 0; i < bytes1.length; i++) {
        if (bytes1[i] != bytes2[i]) {
          isBytesSimilar = false;
          break;
        }
      }
    }

    final decodedFirstImage = await decodeImageFromList(bytes1);
    final decodedSecondImage = await decodeImageFromList(bytes2);
    final height1 = decodedFirstImage.height;
    final height2 = decodedSecondImage.height;
    final width1 = decodedFirstImage.width;
    final width2 = decodedSecondImage.width;

    return <String, dynamic>{
      'fileName1': fileName1,
      'fileName2': fileName2,
      'format1': format1,
      'format2': format2,
      'height1': height1,
      'height2': height2,
      'width1': width1,
      'width2': width2,
      'isBytesSimilar': isBytesSimilar,
    };
  }

  void _showModal({required Map<String, dynamic> comparisonResult}) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Image Comparison Result'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Image 1: ${comparisonResult['fileName1']}'),
            Text('Format: ${comparisonResult['format1']}'),
            Text(
              '''
Dimensions: ${comparisonResult['width1']} x ${comparisonResult['height1']}
               ''',
            ),
            const SizedBox(height: 16),
            Text('Image 2: ${comparisonResult['fileName2']}'),
            Text('Format: ${comparisonResult['format2']}'),
            Text('''
Dimensions: ${comparisonResult['width2']} x ${comparisonResult['height2']}
               '''),
            const SizedBox(height: 16),
            Text(
              comparisonResult['isBytesSimilar'] as bool
                  ? 'Images are similar'
                  : 'Images are not similar',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }
}
