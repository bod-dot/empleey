import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:this_is_tayrd/Views/Pages/take_reading_screen.dart';
import 'package:this_is_tayrd/Widgets/custom_button.dart';
import 'package:this_is_tayrd/helper/constans.dart';

class AdvancedMeterReader extends StatefulWidget {
   const AdvancedMeterReader({super.key, required this.qrCode});
  final int qrCode ;

  @override
  State<AdvancedMeterReader> createState() => _AdvancedMeterReaderState();
}

class _AdvancedMeterReaderState extends State<AdvancedMeterReader> {
  File? _image;
  String _reading = '';
  bool _isProcessing = false;
  ui.Image? _processedImage;
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  // المتغيرات الخاصة بتحديد منطقة القراءة
  final GlobalKey _imageKey = GlobalKey();
  Offset? _startDrag;
  Offset? _currentDrag;
  Rect? _selectedRect;

  Future<void> _captureImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;

    setState(() {
      _image = File(image.path);
      _reading = '';
      _processedImage = null;
      _selectedRect = null;
    });
  }

  Future<void> _processImage() async {
    if (_image == null) return;

    setState(() => _isProcessing = true);

    try {
      final bytes = await _image!.readAsBytes();
      img.Image? originalImage = img.decodeImage(bytes);
      if (originalImage == null) return;

      // إذا كانت هناك منطقة محددة، يتم قص الصورة لتلك المنطقة
      if (_selectedRect != null) {
        final renderBox = _imageKey.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final widgetSize = renderBox.size;
          double scaleX = originalImage.width / widgetSize.width;
          double scaleY = originalImage.height / widgetSize.height;
          int cropX = (_selectedRect!.left * scaleX).round();
          int cropY = (_selectedRect!.top * scaleY).round();
          int cropWidth = (_selectedRect!.width * scaleX).round();
          int cropHeight = (_selectedRect!.height * scaleY).round();
          // التأكد من أن أبعاد القص ضمن حدود الصورة
          cropX = cropX.clamp(0, originalImage.width - 1);
          cropY = cropY.clamp(0, originalImage.height - 1);
          if (cropX + cropWidth > originalImage.width) {
            cropWidth = originalImage.width - cropX;
          }
          if (cropY + cropHeight > originalImage.height) {
            cropHeight = originalImage.height - cropY;
          }
          originalImage = img.copyCrop(originalImage, x: cropX,y:  cropY,width:  cropWidth,height:  cropHeight);
        }
      }

      // تحسين الصورة قبل التحليل
      img.Image processedImage = _enhanceImage(originalImage);
      final processedBytes = img.encodeJpg(processedImage);

      final inputImage = InputImage.fromFilePath(
        _image!.path
      );

      final recognizedText = await _textRecognizer.processImage(inputImage);
      _reading = _refineReading(recognizedText.text);

      final codec = await ui.instantiateImageCodec(processedBytes);
      final frameInfo = await codec.getNextFrame();
      setState(() => _processedImage = frameInfo.image);
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  img.Image _enhanceImage(img.Image image) {
    img.grayscale(image);
    img.adjustColor(image, contrast: 1.5);
    img.smooth(image, weight: 3);
    return image;
  }

  String _refineReading(String rawText) {
    final patterns = [
      RegExp(r'\d{4,6,8}'), // قراءة مكونة من 4 إلى 6 أرقام
      RegExp(r'\d+\.\d{2}'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(rawText);
      if (match != null) return match.group(0)!;
    }

    return 'لم يتم التعرف على القراءة';
  }

  // دالة متابعة يمكن تعديلها لتوجه المستخدم إلى الصفحة التالية
  void continueAction() {
    // مثال: عرض رسالة متابعة
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('متابعة العملية...')),
    );
  }

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }

  Widget _buildImageSelector() {
    return GestureDetector(
      key: _imageKey,
      onPanStart: (details) {
        setState(() {
          _startDrag = details.localPosition;
          _currentDrag = details.localPosition;
          _selectedRect = null;
        });
      },
      onPanUpdate: (details) {
        setState(() {
          _currentDrag = details.localPosition;
        });
      },
      onPanEnd: (details) {
        setState(() {
          if (_startDrag != null && _currentDrag != null) {
            _selectedRect = Rect.fromPoints(_startDrag!, _currentDrag!);
          }
          _startDrag = null;
          _currentDrag = null;
        });
      },
      child: Stack(
        children: [
          
          Positioned.fill(
            child: Image.file(
              _image!,
              fit: BoxFit.contain,
            ),
          ),
          if (_selectedRect != null)
            Positioned(
              left: _selectedRect!.left,
              top: _selectedRect!.top,
              width: _selectedRect!.width,
              height: _selectedRect!.height,
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
          actions: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
          automaticallyImplyLeading: false,
          title: const Text("قارئ العداد الذكي",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
          centerTitle: true,
        ),
        body: Directionality(
          textDirection: TextDirection.ltr,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
            
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _image != null 
                      ? _buildImageSelector()
                      : const Center(child: Icon(Icons.photo_camera, size: 60)),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      label:const   Text("التقاط صورة",style: TextStyle(color: kColorPrimer,fontSize: 18),),
                      onPressed: _captureImage,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        iconColor: kColorPrimer
                        
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: _isProcessing 
                          ? const CircularProgressIndicator()
                          : const Icon(Icons.analytics),
                      label: Text(_isProcessing ? "جارِ التحليل..." : "تحليل الصورة",style:const  TextStyle(color: kColorPrimer,fontSize: 18),),
                      onPressed: !_isProcessing && _image != null ? _processImage : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16)
                        ,
                          iconColor: kColorPrimer
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    _reading.isEmpty ? "-----" : _reading,
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ),
                // زر المتابعة يظهر فقط إذا كانت القراءة موجودة وغير فارغة
                if (_reading.isNotEmpty && _reading != 'لم يتم التعرف على القراءة')
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child:Custombutton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>  TakeReadingScreen()));
                    }, lable: "متابعة")
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
