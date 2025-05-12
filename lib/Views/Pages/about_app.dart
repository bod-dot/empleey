import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../helper/constans.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  @override
  void initState() {
     SystemChrome.setSystemUIOverlayStyle(
      const   SystemUiOverlayStyle(
          statusBarColor: Colors.black, // اللون المطلوب
          statusBarIconBrightness: Brightness.light, // لون الأيقونات (فاتح/داكن)
          systemNavigationBarColor: Colors.white, // لون شريط التنقل (اختياري)
        ),
      );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end, // محاذاة الأطفال من اليمين
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  gradient:const  LinearGradient(
                    colors: [kColorSecond, kColorPrimer],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                          IconButton(onPressed: (){
                              Navigator.pop(context);

                          }, icon:const  Icon(Icons.arrow_back,color: Colors.white,)),
                    const SizedBox(width: 15),
                    Text(
                      'المحصِّل الميداني',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 2,
                            color: Colors.black.withOpacity(0.2),
                            offset:const Offset(1, 1),
                          ),
                          
                        ],
                      ),
                    ),
                     const Icon(Icons.camera_alt_rounded, color: kColorFoured, size: 30),
                  ],
                ),
              ),
    
              const SizedBox(height: 30),
    
              // About Content
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: kColorFoured, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset:const Offset(0, 3),
                    ),
                  ],
                ),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'فكرة التطبيق',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: kColorPrimer,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      
                      const SizedBox(height: 15),
                      
                      RichText(
                        textAlign: TextAlign.right,
                        text: TextSpan(
                          style:const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            height: 1.6,
                          ),
                          children: [
                          const  TextSpan(
                              text: 'يُعد تطبيق المُحصِّل أداة ذكية تهدف إلى تسهيل عملية قراءة عدادات الكهرباء ميدانيًا، من خلال تصوير العداد وتحليل الصورة باستخدام تقنيات الذكاء الاصطناعي لاستخراج القراءة بدقة.\n',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: kColorPrimer,
                                fontSize: 17,
                              ),
                            ),
                           const TextSpan(
                              text: 'آلية العمل:\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kColorSecond,
                              ),
                            ),
                            FeatureText(text: 'التقاط صورة العداد باستخدام كاميرا الجوال'),
                            FeatureText(text: 'معالجة الصورة بخصائص التعرف البصري (OCR)'),
                            FeatureText(text: 'تحليل البيانات  '),
                            FeatureText(text: 'تحديث السجلات تلقائيًا في النظام المركزي'),
                         const   TextSpan(text: '\n'),
                           const TextSpan(
                              text: 'مزايا الاستخدام:\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kColorSecond,
                              ),
                            ),
                           FeatureText(text: 'توفير 70% من الوقت المستهلك'),
                        FeatureText(text: 'دقة قراءة تصل إلى 99.8%'),
                        FeatureText(text: 'تحديثات لحظية على النظام المركزي'),
                        FeatureText(text: 'تقرير فني تلقائي مع كل قراءة'),
                                                  ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    
              const SizedBox(height: 25),
    
              // Features Grid
              const Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: [
                  FeatureCard(
                    icon: Icons.photo_camera,
                    title: 'قراءة بصريّة',
                    subtitle: 'تحليل الصور باستخدام الذكاء الاصطناعي',
                  ),
                  FeatureCard(
                    icon: Icons.cloud_sync,
                    title: 'مزامنة فورية',
                    subtitle: 'تحديث البيانات مباشرة على قاعدة البيانات',
                  ),
                     FeatureCard(
    icon: Icons.security,
    title: 'أمان مشفر',
    subtitle: 'نقل البيانات عبر قنوات مؤمنة',
        ),
                  FeatureCard(
                    icon: Icons.analytics,
                    title: 'تقارير تفصيلية',
                    subtitle: 'إحصائيات دقيقة وتقارير ميدانية',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureText extends TextSpan {
  FeatureText({required String text}) : super(
    text: '• $text\n',
    style: TextStyle(
      color: Colors.grey[800],
      fontWeight: FontWeight.w500,
    ),
  );
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        width: 170,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: kColorFoured.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kColorFoured.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(icon, size: 30, color: kColorPrimer),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.right,
              style:const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: kColorSecond,
              ),
            ),
            Text(
              subtitle,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
