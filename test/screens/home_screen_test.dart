import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mocktail/mocktail.dart';
import 'package:test_application/screens/home_screen.dart';
import 'package:test_application/services/picker_image_service.dart';

class MockPickerImageService extends Mock implements PickerImageService {}

class MockImagePicker extends Mock implements ImagePicker {}

class MockXFile extends Mock implements XFile {}

void main() {
  late PickerImageService pickerImageService;
  late ImagePicker imagePicker;
  setUpAll(() {
    pickerImageService = MockPickerImageService();
    imagePicker = MockImagePicker();
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    await tester.pumpAndSettle();

    final firstButton =
        find.byKey(const ValueKey(HomeScreen.pickFirstImageButtonKey));
    final secondButton =
        find.byKey(const ValueKey(HomeScreen.piskSecondImageButtonKey));

    expect(firstButton, findsOneWidget);
    expect(secondButton, findsOneWidget);

    final XFile mockImage = MockXFile();
    when(() => mockImage.path).thenReturn('path');

    when(() => imagePicker.pickImage(source: ImageSource.gallery))
        .thenAnswer((_) => Future<XFile?>.value(mockImage));
    when(
      () => pickerImageService.pickImageFromGallery(),
    ).thenAnswer((_) => Future<String>.value(mockImage.path));

    await tester.tap(firstButton);
    await tester.pumpAndSettle();
  });
}
