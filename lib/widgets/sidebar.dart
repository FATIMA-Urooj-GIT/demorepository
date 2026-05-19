// ─── widgets/sidebar.dart ────────────────────────────────────────────────────

import 'package:flutter/material.dart';

class SidebarItem {
  final IconData icon;
  final String label;
  final int index;

  const SidebarItem({required this.icon, required this.label, required this.index});
}

class AdminSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const AdminSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  static const items = [
    SidebarItem(icon: Icons.dashboard_rounded, label: 'Dashboard', index: 0),
    SidebarItem(icon: Icons.people_rounded, label: 'Affected Users', index: 1),
    SidebarItem(icon: Icons.notifications_active_rounded, label: 'Send Alerts', index: 2),
    SidebarItem(icon: Icons.groups_rounded, label: 'Rescue Teams', index: 3),
    SidebarItem(icon: Icons.map_rounded, label: 'Zone Map', index: 4),
    SidebarItem(icon: Icons.bar_chart_rounded, label: 'Reports', index: 5),
    SidebarItem(icon: Icons.settings_rounded, label: 'Settings', index: 6),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: const Color(0xFF0D1117),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo area
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF21262D))),
            ),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.crisis_alert, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SDMS Admin', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      Text('Disaster Control', style: TextStyle(color: Color(0xFF8B949E), fontSize: 10)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Live Status Badge
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2F1A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF238636)),
            ),
            child: Row(
              children: [
                Container(
                  width: 8, height: 8,
                  decoration: const BoxDecoration(color: Color(0xFF3FB950), shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                const Text('System LIVE', style: TextStyle(color: Color(0xFF3FB950), fontSize: 11, fontWeight: FontWeight.w600)),
                const Spacer(),
                const Text('4 Active', style: TextStyle(color: Color(0xFF8B949E), fontSize: 10)),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Text('NAVIGATION', style: TextStyle(color: Color(0xFF8B949E), fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
          ),
          // Nav Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: items.length,
              itemBuilder: (context, i) {
                final item = items[i];
                final isSelected = selectedIndex == item.index;
                return Container(
                  margin: const EdgeInsets.only(bottom: 2),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => onItemSelected(item.index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFE53935).withOpacity(0.15) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected ? Border.all(color: const Color(0xFFE53935).withOpacity(0.3)) : null,
                        ),
                        child: Row(
                          children: [
                            Icon(item.icon,
                                color: isSelected ? const Color(0xFFE53935) : const Color(0xFF8B949E),
                                size: 18),
                            const SizedBox(width: 10),
                            Text(item.label,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : const Color(0xFF8B949E),
                                  fontSize: 13,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                )),
                            if (item.index == 1) ...[
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE53935),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Admin user at bottom
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFF21262D))),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFFE53935),
                  child: const Text('A', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Admin User', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                    Text('Super Admin', style: TextStyle(color: Color(0xFF8B949E), fontSize: 10)),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.logout, color: Color(0xFF8B949E), size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
