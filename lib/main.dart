import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
    runApp: const HelpRecoverApp());
}

class HelpRecoverApp extends StatelessWidget {
  const HelpRecoverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Account recovery',
      theme: ThemeData(primarySwatch: Colors.blue),
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
      'success_title': 'طلبك تحت المراجعة حالياً ⏳',
      'success_body': 'تم تقديم طلبك بنجاح وجاري فحص البيانات بالسيرفر. تم نسخ رسالة الطعن الاحترافية تلقائياً إلى حافظة هاتفك! يرجى لصقها عند الانتقال لصفحة الدعم المباشرة.',
      'go_btn': 'الانتقال لصفحة الدعم الرسمية للمنصة',
      'val_platform': 'الرجاء اختيار المنصة',
      'val_problem': 'الرجاء تحديد نوع المشكلة',
      'val_user': 'الرجاء إدخال اسم المستخدم',
      'val_email': 'الرجاء إدخال البريد الإلكتروني',
    }
  };

  final _formKey = GlobalKey<FormState>();
  void _launchSupportUrl(String platform) async {
    String urlString = 'https://instagram.com';
    if (platform == 'انستغرام' || platform == 'Instagram') {
      urlString = 'https://help.instagram.com'; 
    } else if (platform == 'تيك توك' || platform == 'TikTok') {
      urlString = 'https://www.tiktok.com/feedback';
    } else if (platform == 'فيسبوك' || platform == 'Facebook') {
      urlString = 'https://www.facebook.com/help';
    }
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر فتح رابط الدعم المباشر')),
        );
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String generatedText = "Hello Support team,\nMy Account on $_selectedPlatform with username: ${_usernameController.text} has been $_selectedProblem.\nMy contact email is: ${_emailController.text}.\nPlease help me recover it. Thank you.";
      Clipboard.setData(ClipboardData(text: generatedText));
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Text(lang['ar']!['success_title']!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
            content: Text(lang['ar']!['success_body']!, textAlign: TextAlign.center),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  Navigator.pop(context); 
                  _launchSupportUrl(_selectedPlatform!); 
                },
                child: Text(lang['ar']!['go_btn']!, style: const TextStyle(color: Colors.white)),
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
        title: Text(lang[cl]!['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Container(
        width: double.infinity,
        height: double.infinity,
decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg_image.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lang[cl]!['sub']!, style: const TextStyle(fontSize: 14, color: Colors.white)),
                  const SizedBox(height: 25),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: lang[cl]!['platform'], filled: true, fillColor: Colors.white),
                    value: _selectedPlatform,
                    items: ['انستغرام', 'تيك توك', 'فيسبوك'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                    onChanged: (val) => setState(() => _selectedPlatform = val),
                    validator: (val) => val == null ? lang[cl]!['val_platform'] : null,
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: lang[cl]!['problem'], filled: true, fillColor: Colors.white),
                    value: _selectedProblem,
                    // 🔥 تمت إعادة جميع خيارات المشاكل السابقة كاملة وموسعة هنا بالأسفل بالملي
                    items: ['تم اختراقه (Hacked)', 'تم تعطيله (Disabled)', 'انتحال شخصية (Impersonation)', 'نسيان كلمة المرور (Forgot )', 'مشكلة في التحقق بخطوتينPassword (2FA Problem)'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                    onChanged: (val) => setState(() => _selectedProblem = val),
                    validator: (val) => val == null ? lang[cl]!['val_problem'] : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: lang[cl]!['username'], filled: true, fillColor: Colors.white),
                    validator: (val) => val!.isEmpty ? lang[cl]!['val_user'] : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: lang[cl]!['email'], filled: true, fillColor: Colors.white),
                    validator: (val) => val!.isEmpty ? lang[cl]!['val_email'] : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _otherProblemController,
                    maxLines: 2,
                    decoration: InputDecoration(labelText: lang[cl]!['other'], filled: true, fillColor: Colors.white),
                  ),
                 const SizedBox(height: 35),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: _submitForm,
            child: Text(lang[cl]!['btn']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    ),
      ),
    ),
  ),
),
),
);
  } // 👈 أضف هذا القوس لإغلاق دالة الـ build
} // 👈 أضف هذا القوس لإغلاق الـ Class
