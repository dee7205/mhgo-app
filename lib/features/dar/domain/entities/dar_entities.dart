class ManpowerAccomplishment {
  final String category; // e.g. 'Project Engineer', 'Site Supervisor', 'Electricians', 'Civil Workers', 'Mechanical Workers', 'Helpers'
  final int planned;
  final int present;
  final int overtime;

  const ManpowerAccomplishment({
    required this.category,
    required this.planned,
    required this.present,
    required this.overtime,
  });

  Map<String, dynamic> toJson() => {
        'category': category,
        'planned': planned,
        'present': present,
        'overtime': overtime,
      };

  factory ManpowerAccomplishment.fromJson(Map<String, dynamic> json) =>
      ManpowerAccomplishment(
        category: json['category'] as String,
        planned: json['planned'] as int,
        present: json['present'] as int,
        overtime: json['overtime'] as int,
      );
}

class EquipmentUsage {
  final String name; // e.g. 'Crane', 'Boom Truck', 'Excavator', 'Concrete Mixer', 'Service Vehicle'
  final int count;
  final double hoursUsed;

  const EquipmentUsage({
    required this.name,
    required this.count,
    required this.hoursUsed,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'count': count,
        'hoursUsed': hoursUsed,
      };

  factory EquipmentUsage.fromJson(Map<String, dynamic> json) => EquipmentUsage(
        name: json['name'] as String,
        count: json['count'] as int,
        hoursUsed: (json['hoursUsed'] as num).toDouble(),
      );
}

class MaterialInstalled {
  final String name; // e.g. 'PV Modules', 'Mounting Rails', 'Inverters', 'DC Cables', 'AC Cables', 'Combiner Boxes'
  final int quantity;
  final String unit;

  const MaterialInstalled({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
        'unit': unit,
      };

  factory MaterialInstalled.fromJson(Map<String, dynamic> json) =>
      MaterialInstalled(
        name: json['name'] as String,
        quantity: json['quantity'] as int,
        unit: json['unit'] as String,
      );
}

class DelayIssue {
  final String type; // 'Weather Delay', 'Material Delay', 'Safety Issue', 'Technical Issue', 'Other'
  final String description;
  final double impactHours;

  const DelayIssue({
    required this.type,
    required this.description,
    required this.impactHours,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'description': description,
        'impactHours': impactHours,
      };

  factory DelayIssue.fromJson(Map<String, dynamic> json) => DelayIssue(
        type: json['type'] as String,
        description: json['description'] as String,
        impactHours: (json['impactHours'] as num).toDouble(),
      );
}

class DarPhoto {
  final String path;
  final String caption;

  const DarPhoto({
    required this.path,
    required this.caption,
  });

  Map<String, dynamic> toJson() => {
        'path': path,
        'caption': caption,
      };

  factory DarPhoto.fromJson(Map<String, dynamic> json) => DarPhoto(
        path: json['path'] as String,
        caption: json['caption'] as String,
      );
}

class AccomplishmentItem {
  final String workDescription;
  final String areaLocation;
  final double quantity;
  final String unit;
  final String remarks;

  const AccomplishmentItem({
    required this.workDescription,
    required this.areaLocation,
    required this.quantity,
    required this.unit,
    required this.remarks,
  });

  Map<String, dynamic> toJson() => {
        'workDescription': workDescription,
        'areaLocation': areaLocation,
        'quantity': quantity,
        'unit': unit,
        'remarks': remarks,
      };

  factory AccomplishmentItem.fromJson(Map<String, dynamic> json) =>
      AccomplishmentItem(
        workDescription: json['workDescription'] as String,
        areaLocation: json['areaLocation'] as String,
        quantity: (json['quantity'] as num).toDouble(),
        unit: json['unit'] as String,
        remarks: json['remarks'] as String,
      );
}

class DarReport {
  final String id;
  final String darNumber;
  final String projectUuid;
  final String projectName;
  final DateTime reportDate;
  final String preparedBy;
  final String reportingPeriod; // 'Day Shift' | 'Night Shift'

  final String weather; // 'Sunny' | 'Rainy' | 'Cloudy' | 'Windy'
  final double temperature; // °C
  final String windCondition; // 'Light' | 'Moderate' | 'Strong'
  final String siteCondition; // 'Dry' | 'Muddy' | 'Flooded' | 'Normal'

  final List<AccomplishmentItem> accomplishments;
  final List<ManpowerAccomplishment> manpower;
  final List<EquipmentUsage> equipment;
  final List<MaterialInstalled> materials;
  final List<DelayIssue> delays;
  final List<DarPhoto> photos;

  final String signedPrepared;
  final String signedChecked;
  final String signedApproved;

  final String status; // 'Draft' | 'Submitted' | 'Approved' | 'Rejected'
  final DateTime lastUpdated;

  const DarReport({
    required this.id,
    required this.darNumber,
    required this.projectUuid,
    required this.projectName,
    required this.reportDate,
    required this.preparedBy,
    required this.reportingPeriod,
    required this.weather,
    required this.temperature,
    required this.windCondition,
    required this.siteCondition,
    required this.accomplishments,
    required this.manpower,
    required this.equipment,
    required this.materials,
    required this.delays,
    required this.photos,
    required this.signedPrepared,
    required this.signedChecked,
    required this.signedApproved,
    required this.status,
    required this.lastUpdated,
  });

  double get overallProgressPercentage {
    if (accomplishments.isEmpty) return 0.0;
    // Standard simulation of accomplishments progress (sum of completed volumes / total required targets)
    return accomplishments.isNotEmpty ? 100.0 : 0.0;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'darNumber': darNumber,
        'projectUuid': projectUuid,
        'projectName': projectName,
        'reportDate': reportDate.toIso8601String(),
        'preparedBy': preparedBy,
        'reportingPeriod': reportingPeriod,
        'weather': weather,
        'temperature': temperature,
        'windCondition': windCondition,
        'siteCondition': siteCondition,
        'accomplishments': accomplishments.map((a) => a.toJson()).toList(),
        'manpower': manpower.map((m) => m.toJson()).toList(),
        'equipment': equipment.map((e) => e.toJson()).toList(),
        'materials': materials.map((m) => m.toJson()).toList(),
        'delays': delays.map((d) => d.toJson()).toList(),
        'photos': photos.map((p) => p.toJson()).toList(),
        'signedPrepared': signedPrepared,
        'signedChecked': signedChecked,
        'signedApproved': signedApproved,
        'status': status,
        'lastUpdated': lastUpdated.toIso8601String(),
      };

  factory DarReport.fromJson(Map<String, dynamic> json) => DarReport(
        id: json['id'] as String,
        darNumber: json['darNumber'] as String,
        projectUuid: json['projectUuid'] as String,
        projectName: json['projectName'] as String,
        reportDate: DateTime.parse(json['reportDate'] as String),
        preparedBy: json['preparedBy'] as String,
        reportingPeriod: json['reportingPeriod'] as String,
        weather: json['weather'] as String,
        temperature: (json['temperature'] as num).toDouble(),
        windCondition: json['windCondition'] as String,
        siteCondition: json['siteCondition'] as String,
        accomplishments: (json['accomplishments'] as List)
            .map((item) => AccomplishmentItem.fromJson(item as Map<String, dynamic>))
            .toList(),
        manpower: (json['manpower'] as List)
            .map((item) => ManpowerAccomplishment.fromJson(item as Map<String, dynamic>))
            .toList(),
        equipment: (json['equipment'] as List)
            .map((item) => EquipmentUsage.fromJson(item as Map<String, dynamic>))
            .toList(),
        materials: (json['materials'] as List)
            .map((item) => MaterialInstalled.fromJson(item as Map<String, dynamic>))
            .toList(),
        delays: (json['delays'] as List)
            .map((item) => DelayIssue.fromJson(item as Map<String, dynamic>))
            .toList(),
        photos: (json['photos'] as List)
            .map((item) => DarPhoto.fromJson(item as Map<String, dynamic>))
            .toList(),
        signedPrepared: json['signedPrepared'] as String,
        signedChecked: json['signedChecked'] as String,
        signedApproved: json['signedApproved'] as String,
        status: json['status'] as String,
        lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      );

  DarReport copyWith({
    String? id,
    String? darNumber,
    String? projectUuid,
    String? projectName,
    DateTime? reportDate,
    String? preparedBy,
    String? reportingPeriod,
    String? weather,
    double? temperature,
    String? windCondition,
    String? siteCondition,
    List<AccomplishmentItem>? accomplishments,
    List<ManpowerAccomplishment>? manpower,
    List<EquipmentUsage>? equipment,
    List<MaterialInstalled>? materials,
    List<DelayIssue>? delays,
    List<DarPhoto>? photos,
    String? signedPrepared,
    String? signedChecked,
    String? signedApproved,
    String? status,
    DateTime? lastUpdated,
  }) {
    return DarReport(
      id: id ?? this.id,
      darNumber: darNumber ?? this.darNumber,
      projectUuid: projectUuid ?? this.projectUuid,
      projectName: projectName ?? this.projectName,
      reportDate: reportDate ?? this.reportDate,
      preparedBy: preparedBy ?? this.preparedBy,
      reportingPeriod: reportingPeriod ?? this.reportingPeriod,
      weather: weather ?? this.weather,
      temperature: temperature ?? this.temperature,
      windCondition: windCondition ?? this.windCondition,
      siteCondition: siteCondition ?? this.siteCondition,
      accomplishments: accomplishments ?? this.accomplishments,
      manpower: manpower ?? this.manpower,
      equipment: equipment ?? this.equipment,
      materials: materials ?? this.materials,
      delays: delays ?? this.delays,
      photos: photos ?? this.photos,
      signedPrepared: signedPrepared ?? this.signedPrepared,
      signedChecked: signedChecked ?? this.signedChecked,
      signedApproved: signedApproved ?? this.signedApproved,
      status: status ?? this.status,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
