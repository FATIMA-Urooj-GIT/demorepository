// ─── models/disaster_models.dart ───────────────────────────────────────────

enum AlertSeverity { critical, high, medium, low }
enum RescueTeamStatus { active, standby, deployed, offDuty }
enum UserStatus { safe, injured, missing, evacuated }
enum DisasterType { flood, earthquake, fire, cyclone, landslide, tsunami }

class AffectedUser {
  final String id;
  final String name;
  final String phone;
  final String location;
  final double lat;
  final double lng;
  final UserStatus status;
  final DateTime reportedAt;
  final String? alertSent;

  AffectedUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.location,
    required this.lat,
    required this.lng,
    required this.status,
    required this.reportedAt,
    this.alertSent,
  });
}

class RescueTeam {
  final String id;
  final String name;
  final String leader;
  final int memberCount;
  final RescueTeamStatus status;
  final String currentLocation;
  final double lat;
  final double lng;
  final String? assignedZone;
  final DateTime lastUpdated;
  final int rescuedCount;

  RescueTeam({
    required this.id,
    required this.name,
    required this.leader,
    required this.memberCount,
    required this.status,
    required this.currentLocation,
    required this.lat,
    required this.lng,
    this.assignedZone,
    required this.lastUpdated,
    required this.rescuedCount,
  });
}

class AlertMessage {
  final String id;
  final String title;
  final String message;
  final AlertSeverity severity;
  final DisasterType disasterType;
  final DateTime sentAt;
  final int recipientCount;
  final String targetZone;

  AlertMessage({
    required this.id,
    required this.title,
    required this.message,
    required this.severity,
    required this.disasterType,
    required this.sentAt,
    required this.recipientCount,
    required this.targetZone,
  });
}

class DisasterZone {
  final String id;
  final String name;
  final DisasterType type;
  final AlertSeverity severity;
  final int affectedPopulation;
  final int rescueTeamsDeployed;
  final String status;

  DisasterZone({
    required this.id,
    required this.name,
    required this.type,
    required this.severity,
    required this.affectedPopulation,
    required this.rescueTeamsDeployed,
    required this.status,
  });
}

// ─── Dummy Data ──────────────────────────────────────────────────────────────

class AppData {
  static List<AffectedUser> get users => [
    AffectedUser(
      id: 'U001', name: 'Ali Hassan', phone: '+92-300-1234567',
      location: 'Sector G-10, Islamabad', lat: 33.69, lng: 73.06,
      status: UserStatus.injured, reportedAt: DateTime.now().subtract(const Duration(hours: 2)),
      alertSent: 'Flood Warning - Evacuate Immediately',
    ),
    AffectedUser(
      id: 'U002', name: 'Fatima Khan', phone: '+92-321-9876543',
      location: 'Model Town, Lahore', lat: 31.48, lng: 74.32,
      status: UserStatus.evacuated, reportedAt: DateTime.now().subtract(const Duration(hours: 5)),
      alertSent: 'Flood Warning - Safe Route Provided',
    ),
    AffectedUser(
      id: 'U003', name: 'Usman Malik', phone: '+92-333-4561234',
      location: 'Clifton, Karachi', lat: 24.81, lng: 67.03,
      status: UserStatus.missing, reportedAt: DateTime.now().subtract(const Duration(hours: 1)),
      alertSent: null,
    ),
    AffectedUser(
      id: 'U004', name: 'Sara Ahmed', phone: '+92-345-7891234',
      location: 'Hayatabad, Peshawar', lat: 34.00, lng: 71.43,
      status: UserStatus.safe, reportedAt: DateTime.now().subtract(const Duration(hours: 8)),
      alertSent: 'Earthquake Alert - Stay Indoors',
    ),
    AffectedUser(
      id: 'U005', name: 'Bilal Chaudhry', phone: '+92-311-2345678',
      location: 'F-7, Islamabad', lat: 33.72, lng: 73.05,
      status: UserStatus.injured, reportedAt: DateTime.now().subtract(const Duration(minutes: 45)),
      alertSent: 'Medical Aid Dispatched',
    ),
    AffectedUser(
      id: 'U006', name: 'Zara Siddiqui', phone: '+92-322-3456789',
      location: 'DHA Phase 5, Lahore', lat: 31.47, lng: 74.39,
      status: UserStatus.evacuated, reportedAt: DateTime.now().subtract(const Duration(hours: 3)),
      alertSent: 'Evacuation Route: Ferozpur Road',
    ),
  ];

  static List<RescueTeam> get teams => [
    RescueTeam(
      id: 'RT001', name: 'Alpha Squad', leader: 'Major Tariq',
      memberCount: 12, status: RescueTeamStatus.deployed,
      currentLocation: 'G-10 Sector, Islamabad', lat: 33.69, lng: 73.06,
      assignedZone: 'Zone A - Flood Area', lastUpdated: DateTime.now().subtract(const Duration(minutes: 10)),
      rescuedCount: 23,
    ),
    RescueTeam(
      id: 'RT002', name: 'Bravo Team', leader: 'Capt. Asif',
      memberCount: 8, status: RescueTeamStatus.active,
      currentLocation: 'Model Town, Lahore', lat: 31.48, lng: 74.32,
      assignedZone: 'Zone B - Residential', lastUpdated: DateTime.now().subtract(const Duration(minutes: 5)),
      rescuedCount: 17,
    ),
    RescueTeam(
      id: 'RT003', name: 'Charlie Unit', leader: 'Lt. Raza',
      memberCount: 15, status: RescueTeamStatus.standby,
      currentLocation: 'HQ Base, Rawalpindi', lat: 33.60, lng: 73.04,
      assignedZone: null, lastUpdated: DateTime.now().subtract(const Duration(hours: 1)),
      rescuedCount: 0,
    ),
    RescueTeam(
      id: 'RT004', name: 'Delta Force', leader: 'Col. Imran',
      memberCount: 20, status: RescueTeamStatus.deployed,
      currentLocation: 'Clifton, Karachi', lat: 24.81, lng: 67.03,
      assignedZone: 'Zone C - Coastal', lastUpdated: DateTime.now().subtract(const Duration(minutes: 20)),
      rescuedCount: 41,
    ),
    RescueTeam(
      id: 'RT005', name: 'Echo Squad', leader: 'Maj. Nadia',
      memberCount: 10, status: RescueTeamStatus.offDuty,
      currentLocation: 'Base Camp, Peshawar', lat: 34.01, lng: 71.57,
      assignedZone: null, lastUpdated: DateTime.now().subtract(const Duration(hours: 6)),
      rescuedCount: 8,
    ),
  ];

  static List<AlertMessage> get alerts => [
    AlertMessage(
      id: 'A001', title: 'CRITICAL FLOOD WARNING',
      message: 'Immediate evacuation required for G-10 sector. Water level rising rapidly. Move to higher ground. Rescue teams are en route.',
      severity: AlertSeverity.critical, disasterType: DisasterType.flood,
      sentAt: DateTime.now().subtract(const Duration(minutes: 30)),
      recipientCount: 1240, targetZone: 'G-10, G-11 Islamabad',
    ),
    AlertMessage(
      id: 'A002', title: 'EARTHQUAKE AFTERSHOCK ALERT',
      message: 'Aftershocks expected in next 2 hours. Stay away from damaged buildings. Follow evacuation routes.',
      severity: AlertSeverity.high, disasterType: DisasterType.earthquake,
      sentAt: DateTime.now().subtract(const Duration(hours: 1)),
      recipientCount: 3800, targetZone: 'Peshawar District',
    ),
    AlertMessage(
      id: 'A003', title: 'CYCLONE ADVISORY',
      message: 'Cyclone approaching coastal areas. Expected landfall in 6 hours. All residents must evacuate to designated shelters.',
      severity: AlertSeverity.high, disasterType: DisasterType.cyclone,
      sentAt: DateTime.now().subtract(const Duration(hours: 3)),
      recipientCount: 15000, targetZone: 'Karachi Coastal Belt',
    ),
    AlertMessage(
      id: 'A004', title: 'EVACUATION ROUTE UPDATE',
      message: 'Use Ferozpur Road as primary evacuation route. GT Road is blocked. Food supplies at Model Town Park.',
      severity: AlertSeverity.medium, disasterType: DisasterType.flood,
      sentAt: DateTime.now().subtract(const Duration(hours: 2)),
      recipientCount: 560, targetZone: 'Model Town, Lahore',
    ),
  ];

  static List<DisasterZone> get zones => [
    DisasterZone(id: 'Z001', name: 'G-10 Islamabad', type: DisasterType.flood, severity: AlertSeverity.critical, affectedPopulation: 4500, rescueTeamsDeployed: 2, status: 'Active Response'),
    DisasterZone(id: 'Z002', name: 'Model Town Lahore', type: DisasterType.flood, severity: AlertSeverity.high, affectedPopulation: 2300, rescueTeamsDeployed: 1, status: 'Evacuation'),
    DisasterZone(id: 'Z003', name: 'Clifton Karachi', type: DisasterType.cyclone, severity: AlertSeverity.high, affectedPopulation: 8700, rescueTeamsDeployed: 1, status: 'Monitoring'),
    DisasterZone(id: 'Z004', name: 'Hayatabad Peshawar', type: DisasterType.earthquake, severity: AlertSeverity.medium, affectedPopulation: 1200, rescueTeamsDeployed: 0, status: 'Standby'),
  ];
}
