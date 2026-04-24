// lib/pages/register_page.dart
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
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  String _role = 'Student';
  String _yearLevel = '1st Year';

  void _submit() {
    if (_nameCtrl.text.trim().isEmpty || _emailCtrl.text.trim().isEmpty || _passCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in all required fields.'))); return;
    }
    final id = (100000 + DateTime.now().millisecondsSinceEpoch % 900000).toString().padLeft(6, '0');
    AppState().users.add(AppUser(email: _emailCtrl.text.trim(), password: _passCtrl.text.trim(), role: _role.toLowerCase(), idNumber: id, name: _nameCtrl.text.trim()));
    AppState().accounts.insert(0, PendingAccount(id: AppState().accounts.length + 1, name: _nameCtrl.text.trim(), email: _emailCtrl.text.trim(), role: _role, status: 'Pending', dateSubmitted: DateTime.now().toIso8601String().split('T')[0]));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PendingPage(generatedId: id, password: _passCtrl.text.trim())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: 480,
              decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(12), border: Border.all(color: kGray200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 24, offset: const Offset(0, 4))]),
              padding: const EdgeInsets.all(32),
              child: Column(children: [
                const TcgcLogo(size: 80),
                const SizedBox(height: 16),
                const Text('Create Account', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: kGray900)),
                const Text('Tangub City Global College', style: TextStyle(fontSize: 13, color: kGray500)),
                const Text('Academic Scheduling System', style: TextStyle(fontSize: 12, color: kGray400)),
                const SizedBox(height: 20),
                Container(width: double.infinity, padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFEFF6FF), border: const Border(left: BorderSide(color: kBlue, width: 4)), borderRadius: BorderRadius.circular(4)),
                  child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Registration Notice:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF))),
                    SizedBox(height: 4),
                    Text('• Your account will be reviewed by the administrator before activation', style: TextStyle(fontSize: 12, color: Color(0xFF1E40AF))),
                    Text('• A 6-digit ID Number will be generated automatically upon registration', style: TextStyle(fontSize: 12, color: Color(0xFF1E40AF))),
                    Text('• Please save your ID Number for future login reference', style: TextStyle(fontSize: 12, color: Color(0xFF1E40AF))),
                  ])),
                const SizedBox(height: 20),
                _lbl('Full Name *'), _field(_nameCtrl, 'Enter your full name', Icons.person_outline),
                const SizedBox(height: 14),
                _lbl('Email Address *'), _field(_emailCtrl, 'Enter your email address', Icons.email_outlined, type: TextInputType.emailAddress),
                const SizedBox(height: 14),
                _lbl('Password *'),
                TextField(controller: _passCtrl, obscureText: _obscure, style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(hintText: 'Create a strong password', prefixIcon: const Icon(Icons.lock_outline, color: kGray400, size: 20),
                    suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: kGray400, size: 20), onPressed: () => setState(() => _obscure = !_obscure)))),
                const Padding(padding: EdgeInsets.only(top: 4, left: 2), child: Align(alignment: Alignment.centerLeft, child: Text('Minimum 8 characters recommended', style: TextStyle(fontSize: 11, color: kGray400)))),
                const SizedBox(height: 14),
                _lbl('Role *'),
                Container(decoration: BoxDecoration(border: Border.all(color: kGray300), borderRadius: BorderRadius.circular(8), color: kWhite), padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButton<String>(value: _role, isExpanded: true, underline: const SizedBox(),
                    items: ['Student', 'Instructor'].map((r) => DropdownMenuItem(value: r, child: Text(r, style: const TextStyle(fontSize: 14)))).toList(),
                    onChanged: (v) => setState(() => _role = v!))),
                if (_role == 'Student') ...[
                  const SizedBox(height: 14),
                  _lbl('Year Level *'),
                  Container(decoration: BoxDecoration(border: Border.all(color: kGray300), borderRadius: BorderRadius.circular(8), color: kWhite), padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton<String>(value: _yearLevel, isExpanded: true, underline: const SizedBox(),
                      items: ['1st Year', '2nd Year', '3rd Year', '4th Year'].map((y) => DropdownMenuItem(value: y, child: Text(y, style: const TextStyle(fontSize: 14)))).toList(),
                      onChanged: (v) => setState(() => _yearLevel = v!))),
                ],
                const SizedBox(height: 16),
                Container(width: double.infinity, padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFFEFCE8), border: const Border(left: BorderSide(color: kYellow, width: 4)), borderRadius: BorderRadius.circular(4)),
                  child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Pending Administrator Approval', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF854D0E))),
                    SizedBox(height: 4),
                    Text('Your account will be reviewed and approved by the administrator before you can access the system.', style: TextStyle(fontSize: 12, color: Color(0xFF854D0E))),
                  ])),
                const SizedBox(height: 16),
                SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _submit, child: const Text('Submit Registration'))),
                const SizedBox(height: 10),
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Back to Login', style: TextStyle(color: kGreen, decoration: TextDecoration.underline, fontSize: 13))),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _lbl(String t) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Align(alignment: Alignment.centerLeft, child: Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kGray700))));
  Widget _field(TextEditingController c, String hint, IconData icon, {TextInputType? type}) => TextField(controller: c, style: const TextStyle(fontSize: 14), keyboardType: type, decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon, color: kGray400, size: 20)));
}
