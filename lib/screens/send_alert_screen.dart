// ─── screens/send_alert_screen.dart ─────────────────────────────────────────

import 'package:flutter/material.dart';
import '../models/disaster_models.dart';

class SendAlertScreen extends StatefulWidget {
  const SendAlertScreen({super.key});

  @override
  State<SendAlertScreen> createState() => _SendAlertScreenState();
}

class _SendAlertScreenState extends State<SendAlertScreen> {
  AlertSeverity _selectedSeverity = AlertSeverity.high;
  DisasterType _selectedType = DisasterType.flood;
  String _targetZone = '';
  String _alertTitle = '';
  String _alertMessage = '';
  bool _isSending = false;
  final List<AlertMessage> _sentAlerts = List.from(AppData.alerts);

  final _templates = {
    'Flood Evacuation': 'Immediate evacuation required. Water levels rising rapidly. Move to higher ground using designated evacuation routes. Rescue teams are en route to your location.',
    'Earthquake Safety': 'Stay calm. If indoors, take cover under sturdy furniture. Avoid windows and exterior walls. Do not use elevators. After shaking stops, evacuate safely.',
    'Cyclone Warning': 'A cyclone is approaching. Secure your home and seek shelter immediately. Move to the nearest government shelter. Avoid coastal areas.',
    'Medical Assistance': 'Medical assistance teams have been dispatched to your area. Please stay where you are. First aid and supplies are on the way.',
    'Safe Route Update': 'Updated evacuation route: Use main highway. Avoid riverside roads. Food and water available at community center. Follow rescue team instructions.',
  };

  Color _sevColor(AlertSeverity s) {
    switch (s) {
      case AlertSeverity.critical: return const Color(0xFFE53935);
      case AlertSeverity.high: return const Color(0xFFF7855E);
      case AlertSeverity.medium: return const Color(0xFFD29922);
      case AlertSeverity.low: return const Color(0xFF3FB950);
    }
  }

  void _sendAlert() async {
    if (_alertTitle.isEmpty || _alertMessage.isEmpty || _targetZone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill all fields before sending.'),
        backgroundColor: Color(0xFFE53935),
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }
    setState(() => _isSending = true);
    await Future.delayed(const Duration(seconds: 2));
    final newAlert = AlertMessage(
      id: 'A${_sentAlerts.length + 1}',
      title: _alertTitle,
      message: _alertMessage,
      severity: _selectedSeverity,
      disasterType: _selectedType,
      sentAt: DateTime.now(),
      recipientCount: (100 + _sentAlerts.length * 50),
      targetZone: _targetZone,
    );
    setState(() {
      _sentAlerts.insert(0, newAlert);
      _isSending = false;
      _alertTitle = '';
      _alertMessage = '';
      _targetZone = '';
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('✅ Alert "${newAlert.title}" sent successfully to $_targetZone!'),
      backgroundColor: const Color(0xFF238636),
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Send Emergency Alerts', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Broadcast alerts and suggestions to affected users by zone or individually', style: TextStyle(color: Color(0xFF8B949E), fontSize: 13)),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Compose Panel
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161B22),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF21262D)),
                    ),
                    child: SingleChildScrollView(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Compose Alert', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),

                        // Severity
                        _label('Alert Severity'),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: AlertSeverity.values.map((s) {
                            final isSelected = _selectedSeverity == s;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedSeverity = s),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? _sevColor(s).withOpacity(0.2) : const Color(0xFF0D1117),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: isSelected ? _sevColor(s) : const Color(0xFF21262D)),
                                ),
                                child: Text(s.name.toUpperCase(),
                                    style: TextStyle(color: isSelected ? _sevColor(s) : const Color(0xFF8B949E), fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),

                        // Disaster Type
                        _label('Disaster Type'),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<DisasterType>(
                          value: _selectedType,
                          dropdownColor: const Color(0xFF161B22),
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: InputDecoration(
                            filled: true, fillColor: const Color(0xFF0D1117),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF21262D))),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF21262D))),
                          ),
                          items: DisasterType.values.map((t) => DropdownMenuItem(
                            value: t,
                            child: Text(t.name[0].toUpperCase() + t.name.substring(1)),
                          )).toList(),
                          onChanged: (v) => setState(() => _selectedType = v!),
                        ),
                        const SizedBox(height: 16),

                        // Target Zone
                        _label('Target Zone / Area'),
                        const SizedBox(height: 8),
                        _textField('e.g. G-10 Islamabad, Model Town Lahore', onChanged: (v) => _targetZone = v),
                        const SizedBox(height: 16),

                        // Title
                        _label('Alert Title'),
                        const SizedBox(height: 8),
                        _textField('e.g. CRITICAL FLOOD WARNING', onChanged: (v) => _alertTitle = v),
                        const SizedBox(height: 16),

                        // Templates
                        _label('Quick Templates'),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8, runSpacing: 6,
                          children: _templates.entries.map((e) => GestureDetector(
                            onTap: () => setState(() => _alertMessage = e.value),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0D1117),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFF30363D)),
                              ),
                              child: Text(e.key, style: const TextStyle(color: Color(0xFF58A6FF), fontSize: 11)),
                            ),
                          )).toList(),
                        ),
                        const SizedBox(height: 16),

                        // Message
                        _label('Alert Message / Suggestion'),
                        const SizedBox(height: 8),
                        TextField(
                          maxLines: 5,
                          controller: TextEditingController(text: _alertMessage)..selection = TextSelection.fromPosition(TextPosition(offset: _alertMessage.length)),
                          onChanged: (v) => _alertMessage = v,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Write your alert or safety suggestion here...',
                            hintStyle: const TextStyle(color: Color(0xFF8B949E)),
                            filled: true, fillColor: const Color(0xFF0D1117),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF21262D))),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF21262D))),
                          ),
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isSending ? null : _sendAlert,
                            icon: _isSending
                                ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Icon(Icons.send_rounded, size: 16),
                            label: Text(_isSending ? 'Sending...' : 'Send Alert Now'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE53935),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Sent Alerts History
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161B22),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF21262D)),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        const Icon(Icons.history, color: Color(0xFF8B949E), size: 16),
                        const SizedBox(width: 8),
                        const Text('Alert History', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Text('${_sentAlerts.length} sent', style: const TextStyle(color: Color(0xFF8B949E), fontSize: 11)),
                      ]),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _sentAlerts.length,
                          itemBuilder: (ctx, i) {
                            final a = _sentAlerts[i];
                            final diff = DateTime.now().difference(a.sentAt);
                            final timeStr = diff.inMinutes < 1 ? 'Just now' : diff.inMinutes < 60 ? '${diff.inMinutes}m ago' : '${diff.inHours}h ago';
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0D1117),
                                borderRadius: BorderRadius.circular(10),
                                border: Border(left: BorderSide(color: _sevColor(a.severity), width: 3)),
                              ),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Row(children: [
                                  Expanded(child: Text(a.title, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                  Text(timeStr, style: const TextStyle(color: Color(0xFF8B949E), fontSize: 9)),
                                ]),
                                const SizedBox(height: 4),
                                Text(a.message, style: const TextStyle(color: Color(0xFF8B949E), fontSize: 10), maxLines: 2, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 6),
                                Row(children: [
                                  const Icon(Icons.location_on, color: Color(0xFF8B949E), size: 10),
                                  const SizedBox(width: 2),
                                  Expanded(child: Text(a.targetZone, style: const TextStyle(color: Color(0xFF8B949E), fontSize: 9))),
                                  const Icon(Icons.people, color: Color(0xFF8B949E), size: 10),
                                  const SizedBox(width: 2),
                                  Text('${a.recipientCount}', style: const TextStyle(color: Color(0xFF3FB950), fontSize: 9, fontWeight: FontWeight.bold)),
                                ]),
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
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(text, style: const TextStyle(color: Color(0xFF8B949E), fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5));

  Widget _textField(String hint, {required ValueChanged<String> onChanged}) {
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF8B949E)),
        filled: true, fillColor: const Color(0xFF0D1117),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF21262D))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF21262D))),
      ),
    );
  }
}
