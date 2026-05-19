// ─── screens/dashboard_screen.dart ──────────────────────────────────────────

import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import 'overview_screen.dart';
import 'affected_users_screen.dart';
import 'send_alert_screen.dart';
import 'rescue_teams_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final _screenTitles = [
    'Dashboard Overview',
    'Affected Users',
    'Send Alerts',
    'Rescue Teams',
    'Zone Map',
    'Reports',
    'Settings',
  ];

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0: return const OverviewScreen();
      case 1: return const AffectedUsersScreen();
      case 2: return const SendAlertScreen();
      case 3: return const RescueTeamsScreen();
      case 4: return _placeholder(Icons.map_rounded, 'Zone Map', 'Interactive map with disaster zones, rescue team positions, and affected user locations. Integrate Google Maps or flutter_map package here.');
      case 5: return _placeholder(Icons.bar_chart_rounded, 'Reports & Analytics', 'Charts, export tools, and historical data analysis. Integrate fl_chart package for visualizations.');
      case 6: return _placeholder(Icons.settings_rounded, 'System Settings', 'Admin configuration, notification settings, team management, and system preferences.');
      default: return const OverviewScreen();
    }
  }

  Widget _placeholder(IconData icon, String title, String description) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF161B22),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF21262D)),
          ),
          child: Icon(icon, color: const Color(0xFF58A6FF), size: 40),
        ),
        const SizedBox(height: 16),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          width: 400,
          child: Text(description, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF8B949E), fontSize: 13, height: 1.5)),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF21262D), foregroundColor: const Color(0xFF58A6FF)),
          child: const Text('Coming Soon'),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Row(
        children: [
          AdminSidebar(
            selectedIndex: _selectedIndex,
            onItemSelected: (i) => setState(() => _selectedIndex = i),
          ),
          Expanded(
            child: Column(
              children: [
                // Top bar
                Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: const BoxDecoration(
                    color: Color(0xFF161B22),
                    border: Border(bottom: BorderSide(color: Color(0xFF21262D))),
                  ),
                  child: Row(children: [
                    Text(_screenTitles[_selectedIndex],
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    // Notification bell
                    Stack(children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_outlined, color: Color(0xFF8B949E), size: 20),
                      ),
                      Positioned(
                        top: 8, right: 8,
                        child: Container(
                          width: 8, height: 8,
                          decoration: const BoxDecoration(color: Color(0xFFE53935), shape: BoxShape.circle),
                        ),
                      ),
                    ]),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF21262D),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(children: [
                        Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF3FB950), shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        const Text('All Systems Operational', style: TextStyle(color: Color(0xFF8B949E), fontSize: 11)),
                      ]),
                    ),
                  ]),
                ),
                // Main content
                Expanded(child: _buildBody()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
