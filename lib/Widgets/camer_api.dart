import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:this_is_tayrd/cubit/take_reading/take_reading_cubit.dart';

class AdvancedMeterReader extends StatefulWidget {
  const AdvancedMeterReader({super.key, required this.qrCode});
  final String qrCode;

  @override
  State<AdvancedMeterReader> createState() => _AdvancedMeterReaderState();
}

class _AdvancedMeterReaderState extends State<AdvancedMeterReader> {
  File? _image;
  String _reading = '';
  bool _isProcessing = false;
  ui.Image? _processedImage;
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final String _apiKey = 'AIzaSyBHFJmW764A9I332HQoTqivQYUcgTdoCQY';

  final GlobalKey _imageKey = GlobalKey();
  Offset? _startDrag;
  Offset? _currentDrag;
  Rect? _selectedRect;
  File? _originalImageFile;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    await availableCameras();
  }

  Future<void> _captureImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;

    setState(() {
      _image = File(image.path);
      _reading = '';
      _processedImage = null;
      _selectedRect = null;
    });

    _originalImageFile = await _saveOriginalImage(_image!);
  }

  Future<File> _saveOriginalImage(File image) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/meter_readings';
    await Directory(path).create(recursive: true);
    
    final fileName = '${widget.qrCode}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    return await image.copy('$path/$fileName');
  }

  Future<void> _processImage() async {
    if (_selectedRect == null) {
      _showErrorSnackbar('يجب تحديد منطقة القراءة أولاً');
      return;
    }

    if (_image == null) return;

    setState(() => _isProcessing = true);

    try {
      // معالجة الصورة المحددة
      final bytes = await _image!.readAsBytes();
      img.Image? originalImage = img.decodeImage(bytes);
      if (originalImage == null) return;

      final renderBox = _imageKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null) return;

      final widgetSize = renderBox.size;
      double scaleX = originalImage.width / widgetSize.width;
      double scaleY = originalImage.height / widgetSize.height;

      int cropX = (_selectedRect!.left * scaleX).round();
      int cropY = (_selectedRect!.top * scaleY).round();
      int cropWidth = (_selectedRect!.width * scaleX).round();
      int cropHeight = (_selectedRect!.height * scaleY).round();

      cropX = cropX.clamp(0, originalImage.width - 1);
      cropY = cropY.clamp(0, originalImage.height - 1);
      cropWidth = min(cropWidth, originalImage.width - cropX);
      cropHeight = min(cropHeight, originalImage.height - cropY);

      img.Image croppedImage = img.copyCrop(
        originalImage, 
        x: cropX,
        y: cropY,
        width: cropWidth,
        height: cropHeight
      );

      // تحسين الجودة
      img.Image processedImage = _enhanceImage(croppedImage);
      final processedBytes = img.encodeJpg(processedImage);
      
      // استخدام Google Vision API
      final visionResult = await _sendToVisionAPI(processedBytes);
      setState(() => _reading = visionResult);

      // رفع البيانات للخادم
      // if (_originalImageFile != null) {
      //   await _uploadToDatabase(_originalImageFile!, _reading);
      // }

    } catch (e) {
      _showErrorSnackbar('حدث خطأ أثناء المعالجة: ${e.toString()}');
    } finally {
      setState(() => _isProcessing = false);
    }
  }
Future<String> _sendToVisionAPI(List<int> imageBytes) async {
  final response = await http.post(
    Uri.parse('https://vision.googleapis.com/v1/images:annotate?key=$_apiKey'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "requests": [{
        "image": {"content": base64Encode(imageBytes)},
        "features": [{"type": "DOCUMENT_TEXT_DETECTION"}]
      }]
    }),
  );

  if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);
    final rawText = decoded['responses'][0]['fullTextAnnotation']['text'] as String;
    final normalized = rawText.replaceAll(',', '.'); // تحويل الفواصل إن وجدت
    return _extractReading(normalized);
  }
  return 'خطأ في التحليل';
}


String _extractReading(String text) {
  // أولاً تأكد من استبدال أي فواصل بفواصل صحيحة
  text = text.replaceAll(',', '.');
  
  // نمط عثور أساسي
  final regExp = RegExp(r'\d+(\.\d+)?');
  final matches = regExp.allMatches(text).toList();
  
  if (matches.isEmpty) return 'لم يتم التعرف على القراءة';

  // إذا لم توجد نقطة ضمن أي match لكن وجد أكثر من match، نجمع الأثنين الأقرب طولاً
  if (!matches.any((m) => m.group(1) != null) && matches.length >= 2) {
    final a = matches[0].group(0)!;
    final b = matches[1].group(0)!;
    return '$a.$b';  // مثال: "123" و "45" --> "123.45"
  }

  // خلاف ذلك، نختار الأطول (والذي يحتوي على النقطة عادة)
  return matches
      .map((m) => m.group(0)!)
      .reduce((a, b) => a.length > b.length ? a : b);
}




  img.Image _enhanceImage(img.Image image) {
     image = img.copyResize(image, width: 800);
    img.grayscale(image);
    img.adjustColor(image, contrast: 1.5);
    img.smooth(image, weight: 3);
    return image;
  }

  Future<void> _uploadToDatabase(File image, String reading) async {
    try {
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      // استبدل برابط الخادم الخاص بك
      await http.post(
        Uri.parse('https://your-server.com/api/reading'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'qr_code': widget.qrCode,
          'reading': reading,
          'image': base64Image,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );
    } catch (e) {
      _showErrorSnackbar('فشل في حفظ البيانات: ${e.toString()}');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Widget _buildImageOverlay() {
    return GestureDetector(
      key: _imageKey,
      onPanStart: (d) => setState(() {
        _startDrag = d.localPosition;
        _currentDrag = d.localPosition;
        _selectedRect = null;
      }),
      onPanUpdate: (d) => setState(() => _currentDrag = d.localPosition),
      onPanEnd: (_) => setState(() {
        if (_startDrag != null && _currentDrag != null) {
          _selectedRect = Rect.fromPoints(_startDrag!, _currentDrag!);
        }
        _startDrag = _currentDrag = null;
      }),
      child: Stack(
        children: [
          Image.file(_image!, fit: BoxFit.contain),
          
          if (_selectedRect != null)
            Positioned.fromRect(
              rect: _selectedRect!,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 2),
                ),
              ),
            ),
          
          if (_startDrag != null && _currentDrag != null)
            Positioned(
              left: min(_startDrag!.dx, _currentDrag!.dx),
              top: min(_startDrag!.dy, _currentDrag!.dy),
              width: (_startDrag!.dx - _currentDrag!.dx).abs(),
              height: (_startDrag!.dy - _currentDrag!.dy).abs(),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2),
              ),
            ),
            ),        
          if (_selectedRect == null)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: Text(
                    'اسحب لاختيار منطقة قراءة العداد\n(المنطقة الحمراء)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("نظام قراءة العدادات", 
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.blue[800],
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: _image != null 
                  
                      ? _buildImageOverlay()
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.photo_camera, size: 60, color: Colors.grey[500]),
                              Text('اضغط زر التقاط لبدء القراءة', 
                                style: TextStyle(color: Colors.grey[600], fontSize: 18)),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _ActionButton(
                    icon: Icons.camera_alt,
                    label: 'التقاط',
                    onPressed: _captureImage,
                    color: Colors.blue,
                  ),
                  _ActionButton(
                    icon: Icons.analytics,
                    label: 'تحليل',
                    onPressed: () {
                      if (_selectedRect == null) {
                        _showErrorSnackbar('الرجاء تحديد منطقة القراءة أولاً');
                      } else {
                        _processImage();
                      }
                    },
                    color: Colors.green,
                    isLoading: _isProcessing,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  _reading.isEmpty ? '-----' : _reading,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900]),
                ),
              ),
              
              if (_reading.isNotEmpty && _reading != 'لم يتم التعرف على القراءة')
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton.icon(
                    icon:const  Icon(Icons.check, color: Colors.white),
                    label:const  Text('تمت عملية القراءة بنجاح ', 
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding:const  EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    ),
                    onPressed: () {
                      BlocProvider.of<TakeReadingCubit>(context).takeCurrentReading(reading: _reading, originalImageFile: _originalImageFile);
                       
                       
                       Navigator.pop(context, _reading);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  final bool isLoading;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            backgroundColor: color,
            padding: EdgeInsets.all(20)),
          onPressed: isLoading ? null : onPressed,
          child: isLoading 
              ? CircularProgressIndicator(color: Colors.white)
              : Icon(icon, size: 30, color: Colors.white),
          ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 16))
      ],
    );
  }
}