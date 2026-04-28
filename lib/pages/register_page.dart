import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../models/app_state.dart';
import '../theme.dart';
import '../widgets/tcgc_logo.dart';
import 'pending_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _obscure    = true;
  String _role      = 'Student';
  String _yearLevel = '1st Year';

  void _submit() {
    if (_nameCtrl.text.trim().isEmpty || _emailCtrl.text.trim().isEmpty || _passCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in all required fields.'), backgroundColor: kRed)); return;
    }
    final id = (100000 + DateTime.now().millisecondsSinceEpoch % 900000).toString().padLeft(6, '0');
    AppState().users.add(AppUser(email: _emailCtrl.text.trim(), password: _passCtrl.text.trim(), role: _role.toLowerCase(), idNumber: id, name: _nameCtrl.text.trim()));
    AppState().accounts.insert(0, PendingAccount(id: AppState().accounts.length + 1, name: _nameCtrl.text.trim(), email: _emailCtrl.text.trim(), role: _role, status: 'Pending', dateSubmitted: DateTime.now().toIso8601String().split('T')[0]));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PendingPage(generatedId: id, password: _passCtrl.text.trim())));
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cardWidth = w < 480 ? w : 440.0;
    final pad = w < 480 ? 16.0 : 32.0;

    return Scaffold(
      backgroundColor: kGray50,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: cardWidth,
              decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(12), border: Border.all(color: kGray200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 20, offset: const Offset(0, 4))]),
              padding: EdgeInsets.all(pad),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Center(child: Column(children: [
                  const TcgcLogo(size: 72),
                  const SizedBox(height: 12),
                  const Text('Create Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kGray900)),
                  const Text('Tangub City Global College', style: TextStyle(fontSize: 12, color: kGray500)),
                ])),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFFEFF6FF), border: const Border(left: BorderSide(color: kBlue, width: 3)), borderRadius: BorderRadius.circular(4)),
                  child: const Text('Your account will be reviewed by an administrator before activation. A 6-digit ID will be auto-generated.', style: TextStyle(fontSize: 11, color: Color(0xFF1E40AF))),
                ),
                const SizedBox(height: 16),

                _lbl('Full Name *'),
                _field(_nameCtrl, 'Enter your full name', Icons.person_outline),
                const SizedBox(height: 12),
                _lbl('Email Address *'),
                _field(_emailCtrl, 'Enter your email', Icons.email_outlined, type: TextInputType.emailAddress),
                const SizedBox(height: 12),
                _lbl('Password *'),
                TextField(
                  controller: _passCtrl, obscureText: _obscure,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Create a strong password',
                    prefixIcon: const Icon(Icons.lock_outline, color: kGray400, size: 20),
                    suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: kGray400, size: 20), onPressed: () => setState(() => _obscure = !_obscure)),
                  ),
                ),
                const SizedBox(height: 4),
                const Text('Minimum 8 characters recommended', style: TextStyle(fontSize: 11, color: kGray400)),
                const SizedBox(height: 12),

                _lbl('Role *'),
                _dropdown(_role, ['Student', 'Instructor'], (v) => setState(() => _role = v!)),
                if (_role == 'Student') ...[
                  const SizedBox(height: 12),
                  _lbl('Year Level *'),
                  _dropdown(_yearLevel, ['1st Year', '2nd Year', '3rd Year', '4th Year'], (v) => setState(() => _yearLevel = v!)),
                ],
                const SizedBox(height: 20),

                SizedBox(width: double.infinity, height: 44, child: ElevatedButton(onPressed: _submit, child: const Text('Submit Registration', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)))),
                const SizedBox(height: 10),
                Center(child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('← Back to Login', style: TextStyle(color: kGreen, fontSize: 13)),
                )),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _lbl(String t) => Padding(padding: const EdgeInsets.only(bottom: 5), child: Text(t, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: kGray700)));
  Widget _field(TextEditingController c, String hint, IconData icon, {TextInputType? type}) =>
    TextField(controller: c, style: const TextStyle(fontSize: 14), keyboardType: type, decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon, color: kGray400, size: 20)));
  Widget _dropdown(String val, List<String> items, ValueChanged<String?> cb) =>
    Container(
      decoration: BoxDecoration(border: Border.all(color: kGray300), borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<String>(value: val, isExpanded: true, underline: const SizedBox(), style: const TextStyle(fontSize: 14, color: kGray900),
        items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(), onChanged: cb),
    );
}
