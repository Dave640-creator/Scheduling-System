import 'package:flutter/material.dart';
import '../../models/app_state.dart';
import '../../theme.dart';

class AdminApprove extends StatefulWidget {
  const AdminApprove({super.key});
  @override
  State<AdminApprove> createState() => _AdminApproveState();
}

class _AdminApproveState extends State<AdminApprove> {
  final state = AppState();
  Color _sc(String s) => s == 'Pending' ? kYellow    : s == 'Approved' ? kGreen    : kRed;
  Color _bg(String s) => s == 'Pending' ? kYellowLight : s == 'Approved' ? kGreenLight : kRedLight;

  @override
  Widget build(BuildContext context) {
    final w        = MediaQuery.of(context).size.width;
    final isMobile = w < 600;
    final pending  = state.accounts.where((a) => a.status == 'Pending').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Approve Accounts', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: kGray900)),
            const Text('Review and approve pending user registrations', style: TextStyle(fontSize: 13, color: kGray500)),
          ])),
          if (pending > 0) Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: kYellowLight, borderRadius: BorderRadius.circular(20)),
            child: Text('$pending pending', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF854D0E))),
          ),
        ]),
        const SizedBox(height: 20),

        // Mobile: cards. Desktop: table
        isMobile
          ? Column(children: state.accounts.map((a) => _mobileCard(a)).toList())
          : Container(
              decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(kGray50),
                  columns: ['Name', 'Email', 'Role', 'Date', 'Status', 'Actions']
                      .map((h) => DataColumn(label: Text(h, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kGray500)))).toList(),
                  rows: state.accounts.map((a) => DataRow(cells: [
                    DataCell(Text(a.name,          style: const TextStyle(fontSize: 13, color: kGray900))),
                    DataCell(Text(a.email,          style: const TextStyle(fontSize: 12, color: kGray500))),
                    DataCell(Text(a.role,           style: const TextStyle(fontSize: 13, color: kGray700))),
                    DataCell(Text(a.dateSubmitted,  style: const TextStyle(fontSize: 12, color: kGray500))),
                    DataCell(_badge(a.status)),
                    DataCell(a.status == 'Pending'
                      ? Row(mainAxisSize: MainAxisSize.min, children: [
                          _actionBtn(Icons.check, kGreen, 'Approve', () => setState(() => a.status = 'Approved')),
                          _actionBtn(Icons.close, kRed,   'Reject',  () => setState(() => a.status = 'Rejected')),
                        ])
                      : const Text('—', style: TextStyle(color: kGray400))),
                  ])).toList(),
                ),
              ),
            ),
      ]),
    );
  }

  Widget _mobileCard(a) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: Text(a.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kGray900), overflow: TextOverflow.ellipsis)),
        const SizedBox(width: 8),
        _badge(a.status),
      ]),
      const SizedBox(height: 4),
      Text(a.email, style: const TextStyle(fontSize: 12, color: kGray500)),
      const SizedBox(height: 2),
      Row(children: [
        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: a.role == 'Instructor' ? kYellowLight : kBlueLight, borderRadius: BorderRadius.circular(20)), child: Text(a.role, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: a.role == 'Instructor' ? const Color(0xFF854D0E) : kBlue))),
        const SizedBox(width: 8),
        Text(a.dateSubmitted, style: const TextStyle(fontSize: 11, color: kGray400)),
      ]),
      if (a.status == 'Pending') ...[
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(foregroundColor: kRed, side: const BorderSide(color: kRed)),
            onPressed: () => setState(() => a.status = 'Rejected'),
            icon: const Icon(Icons.close, size: 15), label: const Text('Reject', style: TextStyle(fontSize: 13)),
          )),
          const SizedBox(width: 10),
          Expanded(child: ElevatedButton.icon(
            onPressed: () => setState(() => a.status = 'Approved'),
            icon: const Icon(Icons.check, size: 15), label: const Text('Approve', style: TextStyle(fontSize: 13)),
          )),
        ]),
      ],
    ]),
  );

  Widget _badge(String s) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: _bg(s), borderRadius: BorderRadius.circular(20)),
    child: Text(s, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _sc(s))),
  );

  Widget _actionBtn(IconData icon, Color color, String tip, VoidCallback onTap) =>
    Tooltip(message: tip, child: IconButton(
      onPressed: onTap,
      icon: Container(width: 26, height: 26, decoration: BoxDecoration(color: color, shape: BoxShape.circle), child: Icon(icon, color: kWhite, size: 14)),
    ));
}
