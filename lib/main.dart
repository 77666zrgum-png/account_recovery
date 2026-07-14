import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart'; // مكتبة فتح الروابط الخارجية

void main() {
  runApp(const HelpRecoverApp());
}

class HelpRecoverApp extends StatelessWidget {
  const HelpRecoverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'استرجاع حساب تكتوك وانستغرام وفيسبوك',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      home: const MainRecoveryScreen(),
    );
  }
}

class MainRecoveryScreen extends StatefulWidget {
  const MainRecoveryScreen({super.key});

  @override
  State<MainRecoveryScreen> createState() => _MainRecoveryScreenState();
}

class _MainRecoveryScreenState extends State<MainRecoveryScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otherProblemController = TextEditingController();

  String? _selectedPlatform;
  String? _selectedProblem;

  // قاموس النصوص والترجمة
  final Map<String, Map<String, String>> lang = {
    'ar': {
      'title': 'استرجاع حساب تكتوك وانستغرام وفيسبوك',
      'sub': 'قم بتعبئة البيانات لإنشاء طلب استعادة الحساب فوراً',
      'platform': 'اختر المنصة الرقمية',
      'problem': 'ما هي المشكلة التي تواجهها؟',
      'username': 'رابط الحساب (Username) أو اسم المستخدم',
      'email': 'بريدك الإلكتروني للتواصل مع الدعم',
      'other': 'توضيح المشكلة بالتفصيل باللغة العربية أو الإنجليزية',
      'btn': 'تقديم الطلب والانتقال الآمن',
      'success_title': 'تم تقديم طلبك بنجاح ✔️',
      'success_body': 'تم نسخ رسالة الطعن الاحترافية تلقائياً إلى حافظة هاتفك! لـصق الرسالة هناك في حالة طلبها منك.',
      'go_btn': 'الانتقال لصفحة الدعم الرسمية للمنصة',
      'val_platform': 'الرجاء اختيار المنصة',
      'val_problem': 'الرجاء تحديد نوع المشكلة',
      'val_user': 'الرجاء إدخال اسم المستخدم',
      'val_email': 'الرجاء إدخال البريد الإلكتروني',
    }
  };

  final _formKey = GlobalKey<FormState>();

  // دالة ذكية لتوجيه المستخدم للرابط الرسمي الصحيح بناءً على المنصة المختارة
  void _launchSupportUrl(String platform) async {
    String urlString = 'https://instagram.com'; // افتراضي
    
    if (platform == 'انستغرام' || platform == 'Instagram') {
      urlString = 'https://instagram.com149494825257596'; // نموذج الاختراق والتعطيل لشاشات انستغرام
    } else if (platform == 'تيك توك' || platform == 'TikTok') {
      urlString = 'https://tiktok.com'; // نموذج طعون تيك توك الرسمي
    } else if (platform == 'فيسبوك' || platform == 'Facebook') {
      urlString = 'https://facebook.com'; // صفحة دعم الحسابات المخترقة في فيسبوك
    }

    final Uri url = Uri.parse(urlString);
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر فتح رابط الدعم المباشر، الرجاء التحقق من المتصفح')),
        );
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // إنشاء نص الطعن الاحترافي آلياً
      String generatedText = "Hello Support team,\n"
          "My Account on $_selectedPlatform with username: ${_usernameController.text} has been $_selectedProblem.\n"
          "My contact email is: ${_emailController.text}.\n"
          "Additional Details: ${_otherProblemController.text}\n"
          "Please help me recover it as soon as possible. Thank you.";

      // نسخ النص التلقائي إلى حافظة الجوال الافتراضية لحمايته
      Clipboard.setData(ClipboardData(text: generatedText));

      // إظهار نافذة النجاح والتوجيه المباشر
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Text(lang['ar']!['success_title']!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            content: Text(lang['ar']!['success_body']!, textAlign: TextAlign.center),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.pop(context); // إغلاق النافذة
                  _launchSupportUrl(_selectedPlatform!); // إطلاق الرابط الرسمي الفوري للمنصة المختارة!
                },
                child: Text(lang['ar']!['go_btn']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String cl = 'ar';
    return Scaffold(
      appBar: AppBar(
        title: Text(lang[cl]!['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 2,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lang[cl]!['sub']!, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 25),
                
                // قائمة اختيار المنصة
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: lang[cl]!['platform'], border: const OutlineInputBorder()),
                  value: _selectedPlatform,
                  items: ['انستغرام', 'تيك توك', 'فيسبوك'].map((String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedPlatform = val),
                  validator: (val) => val == null ? lang[cl]!['val_platform'] : null,
                ),
                const SizedBox(height: 15),

                // قائمة اختيار نوع المشكلة
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: lang[cl]!['problem'], border: const OutlineInputBorder()),
                  value: _selectedProblem,
                  items: ['تم اختراقه (Hacked)', 'تم تعطيله (Disabled)', 'نسيت كلمة السر (Forgot Password)'].map((String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedProblem = val),
                  validator: (val) => val == null ? lang[cl]!['val_problem'] : null,
                ),
                const SizedBox(height: 15),

                // خانة اسم المستخدم
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: lang[cl]!['username'], border: const OutlineInputBorder()),
                  validator: (val) => val!.isEmpty ? lang[cl]!['val_user'] : null,
                ),
                const SizedBox(height: 15),

                // خانة البريد الإلكتروني
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: lang[cl]!['email'], border: const OutlineInputBorder()),
                  validator: (val) => val!.isEmpty ? lang[cl]!['val_email'] : null,
                ),
                const SizedBox(height: 15),

                // خانة تفاصيل المشكلة
                TextFormField(
                  controller: _otherProblemController,
                  maxLines: 3,
                  decoration: InputDecoration(labelText: lang[cl]!['other'], border: const OutlineInputBorder()),
                ),
                const SizedBox(height: 35),

                // زر الإرسال والتشغيل النهائي
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    onPressed: _submitForm,
                    child: Text(lang[cl]!['btn']!, style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
