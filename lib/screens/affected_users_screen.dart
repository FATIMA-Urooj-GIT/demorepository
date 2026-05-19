// ─── screens/affected_users_screen.dart ─────────────────────────────────────

import 'package:flutter/material.dart';
import '../models/disaster_models.dart';

class AffectedUsersScreen extends StatefulWidget {
  const AffectedUsersScreen({super.key});

  @override
  State<AffectedUsersScreen> createState() => _AffectedUsersScreenState();
}

class _AffectedUsersScreenState extends State<AffectedUsersScreen> {
  String _searchQuery = '';
  UserStatus? _filterStatus;
  List<AffectedUser> _users = [];

  @override
  void initState() {
    super.initState();
    _users = List.from(AppData.users);
  }

  List<AffectedUser> get _filteredUsers {
    return _users.where((u) {
      final matchesSearch = u.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          u.location.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _filterStatus == null || u.status == _filterStatus;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  Color _statusColor(UserStatus s) {
    switch (s) {
      case UserStatus.safe: return const Color(0xFF3FB950);
      case UserStatus.injured: return const Color(0xFFD29922);
      case UserStatus.missing: return const Color(0xFFE53935);
      case UserStatus.evacuated: return const Color(0xFF58A6FF);
    }
  }

  IconData _statusIcon(UserStatus s) {
    switch (s) {
      case UserStatus.safe: return Icons.check_circle;
      case UserStatus.injured: return Icons.medical_services;
      case UserStatus.missing: return Icons.search;
      case UserStatus.evacuated: return Icons.directions_run;
    }
  }

  void _showAlertDialog(AffectedUser user) {
    final msgController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161B22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFF21262D))),
        title: Row(children: [
          const Icon(Icons.notifications_active, color: Color(0xFFE53935), size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text('Send Alert to ${user.name}', style: const TextStyle(color: Colors.white, fontSize: 14))),
        ]),
        content: SizedBox(
          width: 400,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFF0D1117), borderRadius: BorderRadius.circular(8)),
              child: Row(children: [
                const Icon(Icons.person, color: Color(0xFF8B949E), size: 14),
                const SizedBox(width: 8),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(user.name, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                  Text(user.phone, style: const TextStyle(color: Color(0xFF8B949E), fontSize: 11)),
                  Text(user.location, style: const TextStyle(color: Color(0xFF8B949E), fontSize: 11)),
                ])),
              ]),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: msgController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Type your alert message or suggestion...',
                hintStyle: const TextStyle(color: Color(0xFF8B949E)),
                filled: true,
                fillColor: const Color(0xFF0D1117),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF21262D))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF21262D))),
              ),
            ),
            const SizedBox(height: 8),
            const Wrap(spacing: 8, children: [
              _SuggestionChip(label: '🚨 Evacuate Now'),
              _SuggestionChip(label: '🏥 Medical Aid'),
              _SuggestionChip(label: '🗺️ Safe Route'),
              _SuggestionChip(label: '⛺ Shelter Info'),
            ]),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Color(0xFF8B949E)))),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('✅ Alert sent to ${user.name}'),
                backgroundColor: const Color(0xFF238636),
                behavior: SnackBarBehavior.floating,
              ));
            },
            icon: const Icon(Icons.send, size: 14),
            label: const Text('Send Alert'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE53935), foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredUsers;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(children: [
            const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Affected Users', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text('Monitor, track, and send alerts to individuals', style: TextStyle(color: Color(0xFF8B949E), fontSize: 13)),
            ]),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.broadcast_on_personal, size: 16),
              label: const Text('Broadcast Alert'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE53935), foregroundColor: Colors.white),
            ),
          ]),
          const SizedBox(height: 20),

          // Stats Row
          Row(children: [
            _miniStat('Total', '${_users.length}', const Color(0xFF58A6FF)),
            const SizedBox(width: 12),
            _miniStat('Missing', '${_users.where((u) => u.status == UserStatus.missing).length}', const Color(0xFFE53935)),
            const SizedBox(width: 12),
            _miniStat('Injured', '${_users.where((u) => u.status == UserStatus.injured).length}', const Color(0xFFD29922)),
            const SizedBox(width: 12),
            _miniStat('Evacuated', '${_users.where((u) => u.status == UserStatus.evacuated).length}', const Color(0xFF58A6FF)),
            const SizedBox(width: 12),
            _miniStat('Safe', '${_users.where((u) => u.status == UserStatus.safe).length}', const Color(0xFF3FB950)),
          ]),
          const SizedBox(height: 16),

          // Search & Filter
          Row(children: [
            Expanded(
              child: TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Search by name or location...',
                  hintStyle: const TextStyle(color: Color(0xFF8B949E)),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF8B949E), size: 18),
                  filled: true,
                  fillColor: const Color(0xFF161B22),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF21262D))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF21262D))),
                ),
              ),
            ),
            const SizedBox(width: 12),
            _filterBtn('All', null),
            const SizedBox(width: 6),
            _filterBtn('Missing', UserStatus.missing),
            const SizedBox(width: 6),
            _filterBtn('Injured', UserStatus.injured),
            const SizedBox(width: 6),
            _filterBtn('Evacuated', UserStatus.evacuated),
          ]),
          const SizedBox(height: 16),

          // Users List
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF161B22),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF21262D)),
              ),
              child: Column(children: [
                // Table header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color(0xFF21262D))),
                  ),
                  child: const Row(children: [
                    Expanded(flex: 3, child: Text('USER', style: TextStyle(color: Color(0xFF8B949E), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1))),
                    Expanded(flex: 2, child: Text('LOCATION', style: TextStyle(color: Color(0xFF8B949E), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1))),
                    Expanded(flex: 2, child: Text('STATUS', style: TextStyle(color: Color(0xFF8B949E), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1))),
                    Expanded(flex: 3, child: Text('LAST ALERT', style: TextStyle(color: Color(0xFF8B949E), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1))),
                    Expanded(flex: 1, child: Text('ACTION', style: TextStyle(color: Color(0xFF8B949E), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1))),
                  ]),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(color: Color(0xFF21262D), height: 1),
                    itemBuilder: (context, i) {
                      final u = filtered[i];
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        child: Row(children: [
                          Expanded(flex: 3, child: Row(children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: _statusColor(u.status).withOpacity(0.2),
                              child: Text(u.name[0], style: TextStyle(color: _statusColor(u.status), fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                            const SizedBox(width: 10),
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(u.name, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                              Text(u.phone, style: const TextStyle(color: Color(0xFF8B949E), fontSize: 10)),
                            ]),
                          ])),
                          Expanded(flex: 2, child: Text(u.location,
                              style: const TextStyle(color: Color(0xFF8B949E), fontSize: 11),
                              maxLines: 2, overflow: TextOverflow.ellipsis)),
                          Expanded(flex: 2, child: Row(children: [
                            Icon(_statusIcon(u.status), color: _statusColor(u.status), size: 14),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _statusColor(u.status).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(u.status.name.toUpperCase(),
                                  style: TextStyle(color: _statusColor(u.status), fontSize: 9, fontWeight: FontWeight.bold)),
                            ),
                          ])),
                          Expanded(flex: 3, child: Text(u.alertSent ?? 'No alert sent',
                              style: TextStyle(color: u.alertSent != null ? const Color(0xFF8B949E) : const Color(0xFF6E7681), fontSize: 11),
                              maxLines: 2, overflow: TextOverflow.ellipsis)),
                          Expanded(flex: 1, child: ElevatedButton(
                            onPressed: () => _showAlertDialog(u),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF21262D),
                              foregroundColor: const Color(0xFF58A6FF),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              minimumSize: const Size(0, 30),
                              textStyle: const TextStyle(fontSize: 11),
                            ),
                            child: const Text('Alert'),
                          )),
                        ]),
                      );
                    },
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: color.withOpacity(0.7), fontSize: 11)),
      ]),
    );
  }

  Widget _filterBtn(String label, UserStatus? status) {
    final isActive = _filterStatus == status;
    return GestureDetector(
      onTap: () => setState(() => _filterStatus = status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFE53935) : const Color(0xFF161B22),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isActive ? const Color(0xFFE53935) : const Color(0xFF21262D)),
        ),
        child: Text(label, style: TextStyle(color: isActive ? Colors.white : const Color(0xFF8B949E), fontSize: 12)),
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final String label;
  const _SuggestionChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF21262D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: Text(label, style: const TextStyle(color: Color(0xFF8B949E), fontSize: 11)),
    );
  }
}
