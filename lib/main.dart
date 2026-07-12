import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

void main() {
  runApp(const RecoveryApp());
}

class RecoveryApp extends StatelessWidget {
  const RecoveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HelpRecover',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
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
final _formKey = GlobalKey<FormState>();
bool isArabic = true;

String? selectedPlatform;
String? selectedProblem;
final TextEditingController _usernameController = TextEditingController();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _otherProblemController = TextEditingController();

final Map<String, Map<String, String>> lang = {
'ar': {
'title': 'مستشار استرجاع الحسابات',
'sub': 'قم بتعبئة البيانات لإنشاء طلب استعادة الحساب فوراً.',
'platform': 'اختر المنصة الرقمية',
'problem': 'ما هي المشكلة التي تواجهها؟',
'username': 'اسم المستخدم (Username) أو رابط الحساب',
'email': 'بريدك الإلكتروني للتواصل مع الدعم',
'other': 'اشرح مشكلتك بالتفصيل باللغة العربية أو الإنجليزية...',
'btn': 'تقديم الطلب والانتقال للدفع الآمن',
'success_title': 'تم تقديم طلبك بنجاح ✅',
'success_body': 'طلبك قيد المراجعة الآلية لتوليد الطعن الرسمي. تم نسخ رسالة الطعن الاحترافية تلقائياً إلى حافظة هاتفك! اضغط أدناه للانتقال للمنصة وقم بعمل "لصق" للرسالة هناك في خانة الوصف.',
'go_btn': 'الانتقال لصفحة الدعم الرسمية',
'val_platform': 'الرجاء اختيار المنصة',
'val_problem': 'الرجاء تحديد نوع المشكلة',
'val_user': 'الرجاء إدخال اسم المستخدم',
'val_email': 'الرجاء إدخال البريد الإلكتروني',
},
'en': {
'title': 'Account Recovery Advisor',
'sub': 'Fill in the data to create a recovery request immediately.',
'platform': 'Select Platform',
'problem': 'What is the problem?',
'username': 'Username or Account Link',
'email': 'Your Email for Support Contact',
'other': 'Explain your problem in detail...',
'btn': 'Submit & Proceed to Payment',
'success_title': 'Request Submitted Successfully ✅',
'success_body': 'Your request is under automated review. The professional appeal message has been copied to your clipboard automatically! Click below to go to the official support page and "Paste" it into the description box.',
'go_btn': 'Go to Official Support Page',
'val_platform': 'Please select a platform',
'val_problem': 'Please select a problem',
'val_user': 'Please enter username',
'val_email': 'Please enter email',
}
};

String _generateEnglishAppeal() {
String user = _usernameController.text;
if (selectedProblem == 'حظر الحساب' || selectedProblem == 'Account Suspended') {
return "Dear Support Team, My account (@$user) has been suspended by mistake. I strictly follow all community guidelines. Please review my case and restore my access as soon as possible. Thank you.";
} else if (selectedProblem == 'اختراق الحساب' || selectedProblem == 'Account Hacked') {
return "Dear Support Team, My account (@$user) has been compromised and hacked. The access details were changed maliciously. I can provide official ownership proofs to recover it. Please help.";
} else if (selectedProblem == 'انتحال شخصية' || selectedProblem == 'Impersonation') {
return "Dear Support Team, Another malicious account is impersonating my identity and using my personal data to mislead users. Please investigate this immediately.";
} else {
return "Dear Support Team, I am facing an urgent issue with my account (@$user). Description: ${_otherProblemController.text}. Please check my status.";
}
}

Future<void> _launchSupportUrl() async {
  String url = "https://instagram.com";
  String plat = selectedPlatform!;
  String prob = selectedProblem!;

  // روابط الدعم المباشرة لمنصة فيسبوك
  if (plat.contains('فيسبوك') || plat.contains('Facebook')) {
    if (prob.contains('اختراق') || prob.contains('Hacked')) {
      url = "https://facebook.com"; // رابط الإبلاغ عن اختراق الفيسبوك
    } else if (prob.contains('انتحال') || prob.contains('Impersonation')) {
      url = "https://facebook.com"; // رابط بلاغات الانتحال الرسمي
    } else {
      url = "https://facebook.com"; // نموذج طعن الحظر العام
    }
  }
  // روابط الدعم المباشرة لمنصة انستغرام
  else if (plat.contains('انستغرام') || plat.contains('Instagram')) {
    if (prob.contains('اختراق') || prob.contains('Hacked')) {
      url = "https://instagram.com/368191326593075"; // صفحة الدعم الشاملة لاختراق الحسابات
    } else if (prob.contains('انتحال') || prob.contains('Impersonation')) {
      url = "https://instagram.com/contact/606967319425038"; // نموذج بلاغات انتحال الهوية الحاسم
    } else {
      url = "https://instagram.com/contact/1652567848289083"; // نموذج طعون فك الحظر التجاري والشخصي
    }
  }
  // روابط الدعم المباشرة لمنصة تيك توك
  else if (plat.contains('تيك توك') || plat.contains('TikTok')) {
    url = "https://tiktok.com"; // نموذج التغذية الراجعة والطعون الرسمي لتيك توك
  }

  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

void _buyService() {
if (_formKey.currentState!.validate()) {
_showSuccessDialog();
}
}

void _showSuccessDialog() {
String currentLang = isArabic ? 'ar' : 'en';
String appealMessage = _generateEnglishAppeal();

Clipboard.setData(ClipboardData(text: appealMessage));

showDialog(
context: context,
barrierDismissible: false,
builder: (context) => AlertDialog(
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
title: Text(lang[currentLang]!['success_title']!, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
content: Text(lang[currentLang]!['success_body']!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
actions: [
TextButton(
onPressed: () {
Navigator.pop(context);
_launchSupportUrl();
},
child: Text(lang[currentLang]!['go_btn']!),
),
],
),
);
}

@override
Widget build(BuildContext context) {
String cl = isArabic ? 'ar' : 'en';

return Scaffold(
appBar: AppBar(
title: Text(lang[cl]!['title']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
centerTitle: true,
backgroundColor: Colors.blueGrey,
actions: [
TextButton(
onPressed: () => setState(() => isArabic = !isArabic),
child: Text(isArabic ? "English" : "العربية", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
)
],
),
body: Directionality(
textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
child: Padding(
padding: const EdgeInsets.all(20.0),
child: Form(
key: _formKey,
child: ListView(
children: [
Text(lang[cl]!['sub']!, style: const TextStyle(fontSize: 14, color: Colors.grey)),
const SizedBox(height: 25),

DropdownButtonFormField<String>(
decoration: InputDecoration(labelText: lang[cl]!['platform'], border: const OutlineInputBorder()),
items: (isArabic ? ['فيسبوك', 'انستغرام', 'تيك توك'] : ['Facebook', 'Instagram', 'TikTok']).map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
onChanged: (val) => setState(() => selectedPlatform = val),
validator: (val) => val == null ? lang[cl]!['val_platform'] : null,
),
const SizedBox(height: 15),

DropdownButtonFormField<String>(
decoration: InputDecoration(labelText: lang[cl]!['problem'], border: const OutlineInputBorder()),
items: (isArabic
? ['حظر الحساب', 'اختراق الحساب', 'انتحال شخصية', 'أخرى']
: ['Account Suspended', 'Account Hacked', 'Impersonation', 'Other']).map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
onChanged: (val) => setState(() => selectedProblem = val),
validator: (val) => val == null ? lang[cl]!['val_problem'] : null,
),
const SizedBox(height: 15),

if (selectedProblem == 'أخرى' || selectedProblem == 'Other') ...[
TextFormField(
controller: _otherProblemController,
maxLines: 3,
decoration: InputDecoration(labelText: lang[cl]!['other'], border: const OutlineInputBorder()),
validator: (val) => val!.isEmpty ? 'تفاصيل المشكلة مطلوبة' : null,
),
const SizedBox(height: 15),
],

TextFormField(
controller: _usernameController,
decoration: InputDecoration(labelText: lang[cl]!['username'], border: const OutlineInputBorder(), prefixIcon: const Icon(Icons.person)),
validator: (val) => val!.isEmpty ? lang[cl]!['val_user'] : null,
),
const SizedBox(height: 15),

TextFormField(
controller: _emailController,
keyboardType: TextInputType.emailAddress,
decoration: InputDecoration(labelText: lang[cl]!['email'], border: const OutlineInputBorder(), prefixIcon: const Icon(Icons.email)),
validator: (val) => val!.isEmpty ? lang[cl]!['val_email'] : null,
),
const SizedBox(height: 35),

  ElevatedButton(
    onPressed: _buyService,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      backgroundColor: Colors.blueGrey,
    ),
    child: Text(lang[cl]!['btn']!, style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
  ), // إغلاق زر الدفع
], // إغلاق قائمة عناصر الصفحة
), // إغلاق الـ ListView
), // إغلاق الـ Form
), // إغلاق الـ Padding
), // إغلاق الـ Directionality
); // إغلاق الـ Scaffold
} // إغلاق دالة الـ build
} // إغلاق كلاس الـ MainRecoveryScreen