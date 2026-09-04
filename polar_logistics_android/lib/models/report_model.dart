class ReportSummary {
  final PersonnelReport personnel;
  final CargoReport cargo;
  final InventoryReport inventory;

  ReportSummary({
    required this.personnel,
    required this.cargo,
    required this.inventory,
  });

  factory ReportSummary.fromJson(Map<String, dynamic> json) {
    return ReportSummary(
      personnel: PersonnelReport.fromJson(
        Map<String, dynamic>.from(json['personnel'] ?? {}),
      ),
      cargo: CargoReport.fromJson(
        Map<String, dynamic>.from(json['cargo'] ?? {}),
      ),
      inventory: InventoryReport.fromJson(
        Map<String, dynamic>.from(json['inventory'] ?? {}),
      ),
    );
  }
}

class PersonnelReport {
  final int total;
  final int active;
  final int inactive;
  final double activePercentage;

  PersonnelReport({
    required this.total,
    required this.active,
    required this.inactive,
    required this.activePercentage,
  });

  factory PersonnelReport.fromJson(
      Map<String, dynamic> json,
      ) {
    return PersonnelReport(
      total: (json['total'] ?? 0) as int,
      active: (json['active'] ?? 0) as int,
      inactive: (json['inactive'] ?? 0) as int,
      activePercentage:
      (json['active_percentage'] ?? 0).toDouble(),
    );
  }
}

class CargoReport {
  final int total;
  final int delivered;
  final int inTransit;
  final int pending;

  CargoReport({
    required this.total,
    required this.delivered,
    required this.inTransit,
    required this.pending,
  });

  factory CargoReport.fromJson(
      Map<String, dynamic> json,
      ) {
    return CargoReport(
      total: (json['total'] ?? 0) as int,
      delivered: (json['delivered'] ?? 0) as int,
      inTransit: (json['in_transit'] ?? 0) as int,
      pending: (json['pending'] ?? 0) as int,
    );
  }
}

class InventoryReport {
  final int total;
  final int available;
  final int notAvailable;
  final double availablePercentage;

  InventoryReport({
    required this.total,
    required this.available,
    required this.notAvailable,
    required this.availablePercentage,
  });

  factory InventoryReport.fromJson(
      Map<String, dynamic> json,
      ) {
    return InventoryReport(
      total: (json['total'] ?? 0) as int,
      available: (json['available'] ?? 0) as int,
      notAvailable:
      (json['not_available'] ?? 0) as int,
      availablePercentage:
      (json['available_percentage'] ?? 0).toDouble(),
    );
  }
}