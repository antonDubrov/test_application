import 'package:image_picker/image_picker.dart';

/// Our service for picking images
class PickerImageService {
  final ImagePicker _imagePicker = ImagePicker();

  /// Picking image from gallery
  Future<String> pickImageFromGallery() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);

    return image?.path ?? '';
  }
}
