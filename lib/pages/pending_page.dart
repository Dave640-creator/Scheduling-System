// lib/pages/pending_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';
import '../widgets/tcgc_logo.dart';
import 'login_page.dart';

class PendingPage extends StatefulWidget {
  final String generatedId;
  final String password;
  const PendingPage({super.key, required this.generatedId, required this.password});
  @override
  State<PendingPage> createState() => _PendingPageState();
}

class _PendingPageState extends State<PendingPage> {
  bool _copied = false;

  void _copyId() async {
    await Clipboard.setData(ClipboardData(text: widget.generatedId));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () { if (mounted) setState(() => _copied = false); });
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
                const Text('Registration Submitted', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: kGray900)),
                const Text('Tangub City Global College', style: TextStyle(fontSize: 13, color: kGray500)),
                const SizedBox(height: 20),
                Container(width: 64, height: 64, decoration: const BoxDecoration(color: kGreenLight, shape: BoxShape.circle), child: const Icon(Icons.check_circle_outline, color: kGreen, size: 36)),
                const SizedBox(height: 20),
                // ID + password display card
                Container(
                  width: double.infinity, padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(gradient: const LinearGradient(colors: [kGreenBg, kGreenLight], begin: Alignment.topLeft, end: Alignment.bottomRight), border: Border.all(color: kGreen, width: 2), borderRadius: BorderRadius.circular(12)),
                  child: Column(children: [
                    const Text('Your Generated ID Number:', style: TextStyle(fontSize: 13, color: kGray700)),
                    const SizedBox(height: 8),
                    Container(padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: kWhite, border: Border.all(color: const Color(0xFF86EFAC), width: 2), borderRadius: BorderRadius.circular(8)),
                      child: Text(widget.generatedId, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: kGreenDark, letterSpacing: 4, fontFamily: 'monospace'))),
                    const SizedBox(height: 14),
                    const Text('Your Password:', style: TextStyle(fontSize: 13, color: kGray700)),
                    const SizedBox(height: 6),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(color: kGray50, border: Border.all(color: kGray300), borderRadius: BorderRadius.circular(6)),
                      child: Text(widget.password, style: const TextStyle(fontSize: 16, color: kGray700, letterSpacing: 2))),
                    const SizedBox(height: 8),
                    const Text('💡 Save these — use your ID or email to login.', style: TextStyle(fontSize: 11, color: kGray500), textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    SizedBox(width: double.infinity, child: ElevatedButton.icon(
                      onPressed: _copyId,
                      icon: const Icon(Icons.copy, size: 16),
                      label: Text(_copied ? 'Copied!' : 'Copy ID Number'),
                    )),
                  ]),
                ),
                const SizedBox(height: 20),
                Container(width: 72, height: 72, decoration: const BoxDecoration(color: kYellowLight, shape: BoxShape.circle), child: const Icon(Icons.access_time, color: Color(0xFFD97706), size: 40)),
                const SizedBox(height: 12),
                const Text('Status: Pending Approval', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: kGray900)),
                const SizedBox(height: 8),
                const Text('Your account has been submitted for review. An administrator will approve your account shortly.', style: TextStyle(fontSize: 13, color: kGray500), textAlign: TextAlign.center),
                const SizedBox(height: 20),
                Container(width: double.infinity, padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFEFF6FF), border: const Border(left: BorderSide(color: kBlue, width: 4)), borderRadius: BorderRadius.circular(4)),
                  child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('What happens next?', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF))),
                    SizedBox(height: 4),
                    Text('• Administrator will review your registration', style: TextStyle(fontSize: 12, color: Color(0xFF1E40AF))),
                    Text('• You will receive approval notification via email', style: TextStyle(fontSize: 12, color: Color(0xFF1E40AF))),
                    Text('• Once approved, you can login using your credentials', style: TextStyle(fontSize: 12, color: Color(0xFF1E40AF))),
                  ])),
                const SizedBox(height: 12),
                Container(width: double.infinity, padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: kGray50, border: Border.all(color: kGray200), borderRadius: BorderRadius.circular(8)),
                  child: const Text('Processing Time: Account approval typically takes 1-2 business days.', style: TextStyle(fontSize: 12, color: kGray700), textAlign: TextAlign.center)),
                const SizedBox(height: 16),
                SizedBox(width: double.infinity, child: ElevatedButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (_) => false),
                  child: const Text('Back to Login'))),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
