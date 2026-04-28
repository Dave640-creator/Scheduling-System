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
  final _passCtrl  = TextEditingController();
  bool _obscure = true;
  String? _error;

  void _login() {
    final user = AppState().login(_emailCtrl.text.trim(), _passCtrl.text.trim());
    if (user == null) { setState(() => _error = 'Invalid credentials. Please try again.'); return; }
    setState(() => _error = null);
    Widget dest;
    if (user.role == 'admin')       dest = const AdminShell();
    else if (user.role == 'instructor') dest = InstructorDashboard(user: user);
    else                             dest = StudentDashboard(user: user);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => dest));
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
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kGray200),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 20, offset: const Offset(0, 4))],
              ),
              padding: EdgeInsets.all(pad),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Logo + title
                Center(child: Column(children: [
                  const TcgcLogo(size: 72),
                  const SizedBox(height: 12),
                  const Text('Academic Scheduling System', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kGray900), textAlign: TextAlign.center),
                  const SizedBox(height: 2),
                  const Text('Tangub City Global College', style: TextStyle(fontSize: 12, color: kGray500)),
                  const SizedBox(height: 2),
                  const Text('Sign in to access your account', style: TextStyle(fontSize: 12, color: kGray400)),
                ])),
                const SizedBox(height: 18),

                // Notice
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFFEFF6FF), border: const Border(left: BorderSide(color: kBlue, width: 3)), borderRadius: BorderRadius.circular(4)),
                  child: const Text('Accounts require administrator approval before access is granted.', style: TextStyle(fontSize: 11, color: Color(0xFF1E40AF))),
                ),
                const SizedBox(height: 18),

                // Fields
                _lbl('Email / ID Number'),
                _field(_emailCtrl, 'Enter your email or ID number', Icons.email_outlined),
                const SizedBox(height: 14),
                _lbl('Password'),
                TextField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  style: const TextStyle(fontSize: 14),
                  onSubmitted: (_) => _login(),
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outline, color: kGray400, size: 20),
                    suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: kGray400, size: 20), onPressed: () => setState(() => _obscure = !_obscure)),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: kRedBg, borderRadius: BorderRadius.circular(6)),
                    child: Row(children: [const Icon(Icons.error_outline, color: kRed, size: 16), const SizedBox(width: 6), Expanded(child: Text(_error!, style: const TextStyle(color: kRed, fontSize: 12)))]),
                  ),
                ],
                const SizedBox(height: 16),

                // Login button
                SizedBox(width: double.infinity, height: 44, child: ElevatedButton(onPressed: _login, child: const Text('Login to System', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)))),
                const SizedBox(height: 12),

                // Register link
                Center(child: Wrap(alignment: WrapAlignment.center, crossAxisAlignment: WrapCrossAlignment.center, children: [
                  const Text("Don't have an account? ", style: TextStyle(fontSize: 13, color: kGray500)),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage())),
                    child: const Text('Register here', style: TextStyle(fontSize: 13, color: kGreen, fontWeight: FontWeight.w600, decoration: TextDecoration.underline)),
                  ),
                ])),
                const SizedBox(height: 16),

                // Demo accounts
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: kGray50, border: Border.all(color: kGray200), borderRadius: BorderRadius.circular(8)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Demo Accounts', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: kGray700)),
                    const SizedBox(height: 8),
                    _demoRow('Admin',      'admin@tcgc.edu',       'admin123'),
                    _demoRow('Instructor', 'instructor@tcgc.edu',  'inst123'),
                    _demoRow('Student',    'student@tcgc.edu',     'stud123'),
                  ]),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _lbl(String t) => Padding(padding: const EdgeInsets.only(bottom: 5), child: Text(t, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: kGray700)));
  Widget _field(TextEditingController c, String hint, IconData icon) =>
    TextField(controller: c, style: const TextStyle(fontSize: 14), onSubmitted: (_) => _login(), decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon, color: kGray400, size: 20)));
  Widget _demoRow(String role, String email, String pass) => Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Row(children: [
      Container(width: 60, child: Text(role, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kGray700))),
      Expanded(child: Text('$email  •  $pass', style: const TextStyle(fontSize: 11, color: kGray500), overflow: TextOverflow.ellipsis)),
    ]),
  );
}
