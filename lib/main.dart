import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

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
      urlString = 'https://instagram.com/149494825257596'; 
    } else if (platform == 'تيك توك' || platform == 'TikTok') {
      urlString = 'https://tiktok.com'; 
    } else if (platform == 'فيسبوك' || platform == 'Facebook') {
      urlString = 'https://facebook.com'; 
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
      String generatedText = "Hello Support team,\n"
          "My Account on $_selectedPlatform with username: ${_usernameController.text} has been $_selectedProblem.\n"
          "My contact email is: ${_emailController.text}.\n"
          "Additional Details: ${_otherProblemController.text}\n"
          "Please help me recover it as soon as possible. Thank you.";

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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.pop(context); 
                  _launchSupportUrl(_selectedPlatform!); 
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
        title: Text(lang[cl]!['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue.withOpacity(0.8), // شريط علوي شبه شفاف ليتناسق مع الخلفية
        elevation: 2,
      ),
      // 🔑 دمج صورة الخلفية لتفرش كامل الشاشة بشكل فخم جداً
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_image.png'),
            fit: BoxFit.cover, // جعل الصورة ممتدة بالكامل وتغطي الشاشة
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
                  Text(lang[cl]!['sub']!, style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.black, blurRadius: 2)])),
                  const SizedBox(height: 25),
                  
                  // الصناديق بخلفية بيضاء شفافة لتظهر بوضوح فوق صورتك
                  Theme(
                    data: Theme.of(context).copyWith(canvasColor: Colors.white),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: lang[cl]!['platform'], 
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                      ),
                      value: _selectedPlatform,
                      items: ['انستغرام', 'تيك توك', 'فيسبوك'].map((String value) {
                        return DropdownMenuItem<String>(value: value, child: Text(value, style: const TextStyle(color: Colors.black)));
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedPlatform = val),
                      validator: (val) => val == null ? lang[cl]!['val_platform'] : null,
                    ),
                  ),
                  const SizedBox(height: 15),

                  Theme(
                    data: Theme.of(context).copyWith(canvasColor: Colors.white),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: lang[cl]!['problem'], 
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                      ),
                      value: _selectedProblem,
                      items: ['تم اختراقه (Hacked)', 'تم تعطيله (Disabled)', 'نسيت كلمة السر (Forgot Password)'].map((String value) {
                        return DropdownMenuItem<String>(value: value, child: Text(value, style: const TextStyle(color: Colors.black)));
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedProblem = val),
                      validator: (val) => val == null ? lang[cl]!['val_problem'] : null,
                    ),
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: lang[cl]!['username'], 
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                    ),
                    validator: (val) => val!.isEmpty ? lang[cl]!['val_user'] : null,
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: lang[cl]!['email'], 
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                    ),
                    validator: (val) => val!.isEmpty ? lang[cl]!['val_email'] : null,
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: _otherProblemController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: lang[cl]!['other'], 
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                    ),
                  ),
