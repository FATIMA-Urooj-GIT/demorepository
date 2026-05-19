// ─── screens/rescue_teams_screen.dart ───────────────────────────────────────

import 'package:flutter/material.dart';
import '../models/disaster_models.dart';

class RescueTeamsScreen extends StatefulWidget {
  const RescueTeamsScreen({super.key});

  @override
  State<RescueTeamsScreen> createState() => _RescueTeamsScreenState();
}

class _RescueTeamsScreenState extends State<RescueTeamsScreen> {
  RescueTeam? _selectedTeam;
  final List<RescueTeam> _teams = List.from(AppData.teams);

  Color _statusColor(RescueTeamStatus s) {
    switch (s) {
      case RescueTeamStatus.deployed: return const Color(0xFFE53935);
      case RescueTeamStatus.active: return const Color(0xFF3FB950);
      case RescueTeamStatus.standby: return const Color(0xFFD29922);
      case RescueTeamStatus.offDuty: return const Color(0xFF8B949E);
    }
  }

  IconData _statusIcon(RescueTeamStatus s) {
    switch (s) {
      case RescueTeamStatus.deployed: return Icons.emergency;
      case RescueTeamStatus.active: return Icons.play_circle;
      case RescueTeamStatus.standby: return Icons.pause_circle;
      case RescueTeamStatus.offDuty: return Icons.bedtime;
    }
  }

  void _showDeployDialog(RescueTeam team) {
    final zoneController = TextEditingController(text: team.assignedZone ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161B22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFF21262D))),
        title: Text('Deploy ${team.name}', style: const TextStyle(color: Colors.white, fontSize: 15)),
        content: SizedBox(
          width: 360,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Assign a disaster zone for this team:', style: TextStyle(color: Color(0xFF8B949E), fontSize: 12)),
            const SizedBox(height: 12),
            TextField(
              controller: zoneController,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'e.g. Zone A - G-10 Islamabad',
                hintStyle: const TextStyle(color: Color(0xFF8B949E)),
                filled: true, fillColor: const Color(0xFF0D1117),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF21262D))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF21262D))),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 6, children: [
              'Zone A - Flood Area', 'Zone B - Residential', 'Zone C - Coastal', 'Zone D - Mountain'
            ].map((z) => GestureDetector(
              onTap: () => zoneController.text = z,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: const Color(0xFF21262D), borderRadius: BorderRadius.circular(12)),
                child: Text(z, style: const TextStyle(color: Color(0xFF58A6FF), fontSize: 10)),
              ),
            )).toList()),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Color(0xFF8B949E)))),
          ElevatedButton(
            onPressed: () {
              final idx = _teams.indexWhere((t) => t.id == team.id);
              if (idx >= 0) {
                setState(() {
                  _teams[idx] = RescueTeam(
                    id: team.id, name: team.name, leader: team.leader,
                    memberCount: team.memberCount, status: RescueTeamStatus.deployed,
                    currentLocation: team.currentLocation, lat: team.lat, lng: team.lng,
                    assignedZone: zoneController.text, lastUpdated: DateTime.now(),
                    rescuedCount: team.rescuedCount,
                  );
                  _selectedTeam = _teams[idx];
                });
              }
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('✅ ${team.name} deployed to ${zoneController.text}'),
                backgroundColor: const Color(0xFF238636),
                behavior: SnackBarBehavior.floating,
              ));
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE53935), foregroundColor: Colors.white),
            child: const Text('Deploy Team'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Rescue Teams', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text('Monitor, deploy, and track all rescue teams in real-time', style: TextStyle(color: Color(0xFF8B949E), fontSize: 13)),
            ]),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add Team'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF238636), foregroundColor: Colors.white),
            ),
          ]),
          const SizedBox(height: 20),

          // Status summary chips
          Row(children: RescueTeamStatus.values.map((s) {
            final count = _teams.where((t) => t.status == s).length;
            return Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: _statusColor(s).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _statusColor(s).withOpacity(0.3)),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(_statusIcon(s), color: _statusColor(s), size: 14),
                const SizedBox(width: 6),
                Text('$count ${s.name[0].toUpperCase()}${s.name.substring(1)}',
                    style: TextStyle(color: _statusColor(s), fontSize: 11, fontWeight: FontWeight.w600)),
              ]),
            );
          }).toList()),
          const SizedBox(height: 16),

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Teams list
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF161B22),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF21262D)),
                    ),
                    child: Column(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFF21262D)))),
                        child: const Row(children: [
                          Expanded(flex: 3, child: Text('TEAM', style: TextStyle(color: Color(0xFF8B949E), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1))),
                          Expanded(flex: 2, child: Text('STATUS', style: TextStyle(color: Color(0xFF8B949E), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1))),
                          Expanded(flex: 3, child: Text('CURRENT LOCATION', style: TextStyle(color: Color(0xFF8B949E), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1))),
                          Expanded(flex: 2, child: Text('ZONE', style: TextStyle(color: Color(0xFF8B949E), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1))),
                          Expanded(flex: 1, child: Text('RESCUED', style: TextStyle(color: Color(0xFF8B949E), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1))),
                        ]),
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: _teams.length,
                          separatorBuilder: (_, __) => const Divider(color: Color(0xFF21262D), height: 1),
                          itemBuilder: (ctx, i) {
                            final t = _teams[i];
                            final isSelected = _selectedTeam?.id == t.id;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedTeam = t),
                              child: Container(
                                color: isSelected ? const Color(0xFF58A6FF).withOpacity(0.05) : Colors.transparent,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                child: Row(children: [
                                  Expanded(flex: 3, child: Row(children: [
                                    Container(
                                      width: 8, height: 8,
                                      decoration: BoxDecoration(color: _statusColor(t.status), shape: BoxShape.circle),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text(t.name, style: TextStyle(color: isSelected ? const Color(0xFF58A6FF) : Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                                      Text('${t.leader} · ${t.memberCount} members', style: const TextStyle(color: Color(0xFF8B949E), fontSize: 10)),
                                    ])),
                                  ])),
                                  Expanded(flex: 2, child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _statusColor(t.status).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(t.status.name.toUpperCase(),
                                        style: TextStyle(color: _statusColor(t.status), fontSize: 9, fontWeight: FontWeight.bold)),
                                  )),
                                  Expanded(flex: 3, child: Text(t.currentLocation,
                                      style: const TextStyle(color: Color(0xFF8B949E), fontSize: 10),
                                      maxLines: 1, overflow: TextOverflow.ellipsis)),
                                  Expanded(flex: 2, child: Text(t.assignedZone ?? 'Unassigned',
                                      style: TextStyle(color: t.assignedZone != null ? const Color(0xFF58A6FF) : const Color(0xFF6E7681), fontSize: 10),
                                      maxLines: 1, overflow: TextOverflow.ellipsis)),
                                  Expanded(flex: 1, child: Text('${t.rescuedCount}',
                                      style: const TextStyle(color: Color(0xFF3FB950), fontSize: 13, fontWeight: FontWeight.bold))),
                                ]),
                              ),
                            );
                          },
                        ),
                      ),
                    ]),
                  ),
                ),

                const SizedBox(width: 16),

                // Detail panel
                SizedBox(
                  width: 280,
                  child: _selectedTeam == null
                      ? Container(
                    decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF21262D))),
                    child: const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.touch_app, color: Color(0xFF8B949E), size: 32),
                      SizedBox(height: 12),
                      Text('Select a team\nto view details', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF8B949E), fontSize: 13)),
                    ])),
                  )
                      : _TeamDetailPanel(
                    team: _selectedTeam!,
                    statusColor: _statusColor(_selectedTeam!.status),
                    onDeploy: () => _showDeployDialog(_selectedTeam!),
                    onNotify: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('📡 Notification sent to ${_selectedTeam!.name}'),
                        backgroundColor: const Color(0xFF58A6FF),
                        behavior: SnackBarBehavior.floating,
                      ));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamDetailPanel extends StatelessWidget {
  final RescueTeam team;
  final Color statusColor;
  final VoidCallback onDeploy;
  final VoidCallback onNotify;

  const _TeamDetailPanel({required this.team, required this.statusColor, required this.onDeploy, required this.onNotify});

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    return '${diff.inHours}h ago';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF21262D)),
      ),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header
          Row(children: [
            CircleAvatar(
              radius: 22, backgroundColor: statusColor.withOpacity(0.2),
              child: Text(team.name[0], style: TextStyle(color: statusColor, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(team.name, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                child: Text(team.status.name.toUpperCase(), style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
            ])),
          ]),
          const SizedBox(height: 20),

          _detail(Icons.person, 'Leader', team.leader),
          _detail(Icons.group, 'Members', '${team.memberCount} personnel'),
          _detail(Icons.location_on, 'Location', team.currentLocation),
          _detail(Icons.map, 'Assigned Zone', team.assignedZone ?? 'Unassigned'),
          _detail(Icons.access_time, 'Last Update', _timeAgo(team.lastUpdated)),
          _detail(Icons.favorite, 'Rescued', '${team.rescuedCount} persons'),

          const SizedBox(height: 4),
          const Divider(color: Color(0xFF21262D)),
          const SizedBox(height: 4),

          // Simulated GPS dot
          const Text('Last Known Position', style: TextStyle(color: Color(0xFF8B949E), fontSize: 10, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Container(
            height: 120,
            decoration: BoxDecoration(color: const Color(0xFF0D1117), borderRadius: BorderRadius.circular(8)),
            child: Stack(children: [
              // Grid lines
              CustomPaint(painter: _GridPainter(), size: Size.infinite),
              Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  width: 16, height: 16,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.3),
                    shape: BoxShape.circle,
                    border: Border.all(color: statusColor, width: 2),
                  ),
                ),
                const SizedBox(height: 4),
                Text('${team.lat.toStringAsFixed(4)}, ${team.lng.toStringAsFixed(4)}',
                    style: const TextStyle(color: Color(0xFF8B949E), fontSize: 9)),
              ])),
            ]),
          ),
          const SizedBox(height: 16),

          SizedBox(width: double.infinity, child: ElevatedButton.icon(
            onPressed: onDeploy,
            icon: const Icon(Icons.emergency, size: 14),
            label: const Text('Deploy Team'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE53935), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 10)),
          )),
          const SizedBox(height: 8),
          SizedBox(width: double.infinity, child: OutlinedButton.icon(
            onPressed: onNotify,
            icon: const Icon(Icons.notifications, size: 14),
            label: const Text('Send Notification'),
            style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF58A6FF), side: const BorderSide(color: Color(0xFF21262D)), padding: const EdgeInsets.symmetric(vertical: 10)),
          )),
        ]),
      ),
    );
  }

  Widget _detail(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: const Color(0xFF8B949E), size: 14),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(color: Color(0xFF8B949E), fontSize: 10)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
        ]),
      ]),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF21262D)..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 20) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
