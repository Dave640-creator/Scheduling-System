// lib/pages/admin/admin_approve.dart
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

  Color _statusColor(String s) =>
      s == 'Pending' ? kYellow : s == 'Approved' ? kGreen : kRed;
  Color _statusBg(String s) =>
      s == 'Pending' ? kYellowLight : s == 'Approved' ? kGreenLight : kRedLight;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Approve Accounts',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kGray900)),
        const SizedBox(height: 4),
        const Text('Review and approve pending user registrations',
            style: TextStyle(fontSize: 13, color: kGray500)),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: kGray200),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(kGray50),
              columns: ['Name', 'Email', 'Role', 'Date Submitted', 'Status', 'Actions']
                  .map((h) => DataColumn(
                        label: Text(h,
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: kGray500)),
                      ))
                  .toList(),
              rows: state.accounts.map((a) {
                // Build the actions widget separately to keep types clean
                Widget actionsWidget;
                if (a.status == 'Pending') {
                  actionsWidget = Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                              color: kGreen, shape: BoxShape.circle),
                          child: const Icon(Icons.check, color: kWhite, size: 14),
                        ),
                        onPressed: () => setState(() => a.status = 'Approved'),
                        tooltip: 'Approve',
                      ),
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                              color: kRed, shape: BoxShape.circle),
                          child: const Icon(Icons.close, color: kWhite, size: 14),
                        ),
                        onPressed: () => setState(() => a.status = 'Rejected'),
                        tooltip: 'Reject',
                      ),
                    ],
                  );
                } else {
                  actionsWidget = const Text('—',
                      style: TextStyle(fontSize: 13, color: kGray500));
                }

                return DataRow(cells: [
                  DataCell(Text(a.name,
                      style: const TextStyle(fontSize: 13, color: kGray900))),
                  DataCell(Text(a.email,
                      style: const TextStyle(fontSize: 13, color: kGray500))),
                  DataCell(Text(a.role,
                      style: const TextStyle(fontSize: 13, color: kGray700))),
                  DataCell(Text(a.dateSubmitted,
                      style: const TextStyle(fontSize: 13, color: kGray500))),
                  DataCell(Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _statusBg(a.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(a.status,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _statusColor(a.status))),
                  )),
                  DataCell(actionsWidget),
                ]);
              }).toList(),
            ),
          ),
        ),
      ]),
    );
  }
}
