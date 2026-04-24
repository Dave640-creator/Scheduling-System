// lib/pages/login_page.dart
import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../theme.dart';
import '../widgets/tcgc_logo.dart';
import 'register_page.dart';
import 'admin/admin_shell.dart';
import 'instructor_dashboard.dart';
import 'student_dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  String? _error;

  void _login() {
    final user = AppState().login(_emailCtrl.text.trim(), _passCtrl.text.trim());
    if (user == null) { setState(() => _error = 'Invalid credentials. Please try again.'); return; }
    setState(() => _error = null);
    Widget dest;
    if (user.role == 'admin') dest = const AdminShell();
    else if (user.role == 'instructor') dest = InstructorDashboard(user: user);
    else dest = StudentDashboard(user: user);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => dest));
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
                const Text('Academic Scheduling System', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: kGray900)),
                const SizedBox(height: 4),
                const Text('Tangub City Global College', style: TextStyle(fontSize: 13, color: kGray500)),
                const Text('Sign in to access your account', style: TextStyle(fontSize: 12, color: kGray400)),
                const SizedBox(height: 20),
                Container(width: double.infinity, padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFEFF6FF), border: const Border(left: BorderSide(color: kBlue, width: 4)), borderRadius: BorderRadius.circular(4)),
                  child: const Text('Accounts for students and instructors require administrator approval before access is granted.', style: TextStyle(fontSize: 12, color: Color(0xFF1E40AF)))),
                const SizedBox(height: 20),
                _lbl('Email / ID Number *'),
                _field(_emailCtrl, 'Enter your email or ID number', Icons.email_outlined),
                const SizedBox(height: 16),
                _lbl('Password *'),
                TextField(controller: _passCtrl, obscureText: _obscure, style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(hintText: 'Enter your password', prefixIcon: const Icon(Icons.lock_outline, color: kGray400, size: 20),
                    suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: kGray400, size: 20), onPressed: () => setState(() => _obscure = !_obscure)))),
                if (_error != null) ...[const SizedBox(height: 8), Align(alignment: Alignment.centerLeft, child: Text(_error!, style: const TextStyle(color: kRed, fontSize: 12)))],
                const SizedBox(height: 16),
                SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _login, child: const Text('Login to System'))),
                const SizedBox(height: 16),
                const Text("Don't have an account?", style: TextStyle(fontSize: 13, color: kGray500)),
                const SizedBox(height: 4),
                TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage())),
                  child: const Text('Register New Account', style: TextStyle(color: kGreen, decoration: TextDecoration.underline, fontSize: 13))),
                const SizedBox(height: 16),
                Container(width: double.infinity, padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: kGray50, border: Border.all(color: kGray200), borderRadius: BorderRadius.circular(8)),
                  child: Column(children: [
                    const Text('Demo Accounts for Testing:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kGray700)),
                    const SizedBox(height: 8),
                    _demoRow('Admin:', 'admin@tcgc.edu / admin123'),
                    _demoRow('Instructor:', 'instructor@tcgc.edu / inst123'),
                    _demoRow('Student:', 'student@tcgc.edu / stud123'),
                    const Divider(height: 12, color: kGray200),
                    _demoRow('Or use:', 'Generated ID + password from registration'),
                  ])),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _lbl(String t) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Align(alignment: Alignment.centerLeft, child: Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kGray700))));
  Widget _field(TextEditingController c, String hint, IconData icon) => TextField(controller: c, style: const TextStyle(fontSize: 14), decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon, color: kGray400, size: 20)));
  Widget _demoRow(String l, String v) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(l, style: const TextStyle(fontSize: 11, color: kGray500)), Text(v, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: kGray900))]));
}
