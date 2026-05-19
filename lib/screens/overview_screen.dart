// ─── screens/overview_screen.dart ───────────────────────────────────────────

import 'package:flutter/material.dart';
import '../models/disaster_models.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final users = AppData.users;
    final teams = AppData.teams;
    final alerts = AppData.alerts;
    final zones = AppData.zones;

    final injured = users.where((u) => u.status == UserStatus.injured).length;
    final missing = users.where((u) => u.status == UserStatus.missing).length;
    final evacuated = users.where((u) => u.status == UserStatus.evacuated).length;
    final deployed = teams.where((t) => t.status == RescueTeamStatus.deployed).length;
    final totalRescued = teams.fold(0, (sum, t) => sum + t.rescuedCount);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Disaster Control Dashboard',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Real-time monitoring & emergency coordination',
                      style: TextStyle(color: Color(0xFF8B949E), fontSize: 13)),
                ],
              ),
              const Spacer(),
              _buildLiveChip(),
            ],
          ),
          const SizedBox(height: 24),

          // Stat Cards
          LayoutBuilder(builder: (context, constraints) {
            final crossCount = constraints.maxWidth > 900 ? 4 : (constraints.maxWidth > 600 ? 2 : 1);
            return GridView.count(
              crossAxisCount: crossCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.6,
              children: [
                _StatCard(label: 'Total Affected', value: '${users.length}', icon: Icons.people, color: const Color(0xFF58A6FF), subtitle: '$injured injured · $missing missing'),
                _StatCard(label: 'Evacuated Safe', value: '$evacuated', icon: Icons.directions_run, color: const Color(0xFF3FB950), subtitle: 'Out of ${users.length} reported'),
                _StatCard(label: 'Teams Deployed', value: '$deployed / ${teams.length}', icon: Icons.groups, color: const Color(0xFFF7855E), subtitle: '${teams.where((t) => t.status == RescueTeamStatus.standby).length} on standby'),
                _StatCard(label: 'Rescued Today', value: '$totalRescued', icon: Icons.favorite, color: const Color(0xFFE53935), subtitle: 'Across ${zones.length} active zones'),
              ],
            );
          }),
          const SizedBox(height: 24),

          // Active Zones + Recent Alerts (side by side)
          LayoutBuilder(builder: (context, constraints) {
            final isWide = constraints.maxWidth > 800;
            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 6, child: _ActiveZonesCard(zones: zones)),
                  const SizedBox(width: 16),
                  Expanded(flex: 4, child: _RecentAlertsCard(alerts: alerts)),
                ],
              );
            }
            return Column(children: [
              _ActiveZonesCard(zones: zones),
              const SizedBox(height: 16),
              _RecentAlertsCard(alerts: alerts),
            ]);
          }),
          const SizedBox(height: 24),

          // Rescue Teams Quick Overview
          _RescueTeamsQuickView(teams: teams),
        ],
      ),
    );
  }

  Widget _buildLiveChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2F1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF238636)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 8, height: 8,
              decoration: const BoxDecoration(color: Color(0xFF3FB950), shape: BoxShape.circle)),
          const SizedBox(width: 6),
          const Text('LIVE', style: TextStyle(color: Color(0xFF3FB950), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String subtitle;

  const _StatCard({required this.label, required this.value, required this.icon, required this.color, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF21262D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const Spacer(),
              Icon(Icons.trending_up, color: color, size: 14),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(label, style: const TextStyle(color: Color(0xFF8B949E), fontSize: 12, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: color.withOpacity(0.8), fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActiveZonesCard extends StatelessWidget {
  final List<DisasterZone> zones;
  const _ActiveZonesCard({required this.zones});

  Color _severityColor(AlertSeverity s) {
    switch (s) {
      case AlertSeverity.critical: return const Color(0xFFE53935);
      case AlertSeverity.high: return const Color(0xFFF7855E);
      case AlertSeverity.medium: return const Color(0xFFD29922);
      case AlertSeverity.low: return const Color(0xFF3FB950);
    }
  }

  IconData _disasterIcon(DisasterType t) {
    switch (t) {
      case DisasterType.flood: return Icons.water;
      case DisasterType.earthquake: return Icons.vibration;
      case DisasterType.fire: return Icons.local_fire_department;
      case DisasterType.cyclone: return Icons.cyclone;
      case DisasterType.landslide: return Icons.landscape;
      case DisasterType.tsunami: return Icons.waves;
    }
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.location_on, color: Color(0xFFE53935), size: 16),
            const SizedBox(width: 8),
            const Text('Active Disaster Zones', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            const Spacer(),
            Text('${zones.length} zones', style: const TextStyle(color: Color(0xFF8B949E), fontSize: 11)),
          ]),
          const SizedBox(height: 16),
          ...zones.map((z) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1117),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _severityColor(z.severity).withOpacity(0.3)),
            ),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _severityColor(z.severity).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(_disasterIcon(z.type), color: _severityColor(z.severity), size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(z.name, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                Text('${z.affectedPopulation.toString()} affected · ${z.rescueTeamsDeployed} teams deployed',
                    style: const TextStyle(color: Color(0xFF8B949E), fontSize: 10)),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _severityColor(z.severity).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(z.severity.name.toUpperCase(),
                      style: TextStyle(color: _severityColor(z.severity), fontSize: 9, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 4),
                Text(z.status, style: const TextStyle(color: Color(0xFF8B949E), fontSize: 9)),
              ]),
            ]),
          )),
        ],
      ),
    );
  }
}

class _RecentAlertsCard extends StatelessWidget {
  final List<AlertMessage> alerts;
  const _RecentAlertsCard({required this.alerts});

  Color _sevColor(AlertSeverity s) {
    switch (s) {
      case AlertSeverity.critical: return const Color(0xFFE53935);
      case AlertSeverity.high: return const Color(0xFFF7855E);
      case AlertSeverity.medium: return const Color(0xFFD29922);
      case AlertSeverity.low: return const Color(0xFF3FB950);
    }
  }

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.notifications_active, color: Color(0xFFD29922), size: 16),
            const SizedBox(width: 8),
            const Text('Recent Alerts', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 16),
          ...alerts.map((a) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1117),
              borderRadius: BorderRadius.circular(8),
              border: Border(left: BorderSide(color: _sevColor(a.severity), width: 3)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(a.title,
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    maxLines: 1, overflow: TextOverflow.ellipsis)),
                Text(_timeAgo(a.sentAt), style: const TextStyle(color: Color(0xFF8B949E), fontSize: 9)),
              ]),
              const SizedBox(height: 4),
              Text('${a.recipientCount} recipients · ${a.targetZone}',
                  style: const TextStyle(color: Color(0xFF8B949E), fontSize: 9)),
            ]),
          )),
        ],
      ),
    );
  }
}

class _RescueTeamsQuickView extends StatelessWidget {
  final List<RescueTeam> teams;
  const _RescueTeamsQuickView({required this.teams});

  Color _statusColor(RescueTeamStatus s) {
    switch (s) {
      case RescueTeamStatus.deployed: return const Color(0xFFE53935);
      case RescueTeamStatus.active: return const Color(0xFF3FB950);
      case RescueTeamStatus.standby: return const Color(0xFFD29922);
      case RescueTeamStatus.offDuty: return const Color(0xFF8B949E);
    }
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.groups, color: Color(0xFF58A6FF), size: 16),
            const SizedBox(width: 8),
            const Text('Rescue Teams Overview', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 16),
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1117),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Row(children: [
              Expanded(flex: 3, child: Text('Team', style: TextStyle(color: Color(0xFF8B949E), fontSize: 11, fontWeight: FontWeight.w600))),
              Expanded(flex: 2, child: Text('Leader', style: TextStyle(color: Color(0xFF8B949E), fontSize: 11, fontWeight: FontWeight.w600))),
              Expanded(flex: 3, child: Text('Location', style: TextStyle(color: Color(0xFF8B949E), fontSize: 11, fontWeight: FontWeight.w600))),
              Expanded(flex: 2, child: Text('Status', style: TextStyle(color: Color(0xFF8B949E), fontSize: 11, fontWeight: FontWeight.w600))),
              Expanded(flex: 1, child: Text('Rescued', style: TextStyle(color: Color(0xFF8B949E), fontSize: 11, fontWeight: FontWeight.w600))),
            ]),
          ),
          const SizedBox(height: 8),
          ...teams.map((t) => Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1117),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(children: [
              Expanded(flex: 3, child: Row(children: [
                CircleAvatar(radius: 14, backgroundColor: _statusColor(t.status).withOpacity(0.2),
                    child: Text(t.name[0], style: TextStyle(color: _statusColor(t.status), fontSize: 11, fontWeight: FontWeight.bold))),
                const SizedBox(width: 8),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(t.name, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                  Text('${t.memberCount} members', style: const TextStyle(color: Color(0xFF8B949E), fontSize: 9)),
                ])),
              ])),
              Expanded(flex: 2, child: Text(t.leader, style: const TextStyle(color: Color(0xFF8B949E), fontSize: 11))),
              Expanded(flex: 3, child: Text(t.currentLocation,
                  style: const TextStyle(color: Color(0xFF8B949E), fontSize: 10),
                  maxLines: 1, overflow: TextOverflow.ellipsis)),
              Expanded(flex: 2, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusColor(t.status).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(t.status.name.toUpperCase(),
                    style: TextStyle(color: _statusColor(t.status), fontSize: 9, fontWeight: FontWeight.bold)),
              )),
              Expanded(flex: 1, child: Text('${t.rescuedCount}',
                  style: const TextStyle(color: Color(0xFF3FB950), fontSize: 13, fontWeight: FontWeight.bold))),
            ]),
          )),
        ],
      ),
    );
  }
}
