class ChecklistItem {
  final String name;
  final String result; // 'Pass' | 'Fail' | 'N/A'
  final String remarks;

  const ChecklistItem({
    required this.name,
    required this.result,
    required this.remarks,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'result': result,
        'remarks': remarks,
      };

  factory ChecklistItem.fromJson(Map<String, dynamic> json) => ChecklistItem(
        name: json['name'] as String? ?? '',
        result: json['result'] as String? ?? 'N/A',
        remarks: json['remarks'] as String? ?? '',
      );

  ChecklistItem copyWith({
    String? name,
    String? result,
    String? remarks,
  }) {
    return ChecklistItem(
      name: name ?? this.name,
      result: result ?? this.result,
      remarks: remarks ?? this.remarks,
    );
  }
}

class NonConformance {
  final String description;
  final String severity; // 'Low' | 'Medium' | 'High'
  final String recommendedAction;
  final String responsiblePerson;
  final DateTime? targetCompletionDate;

  const NonConformance({
    required this.description,
    required this.severity,
    required this.recommendedAction,
    required this.responsiblePerson,
    this.targetCompletionDate,
  });

  Map<String, dynamic> toJson() => {
        'description': description,
        'severity': severity,
        'recommendedAction': recommendedAction,
        'responsiblePerson': responsiblePerson,
        'targetCompletionDate': targetCompletionDate?.toIso8601String(),
      };

  factory NonConformance.fromJson(Map<String, dynamic> json) => NonConformance(
        description: json['description'] as String? ?? '',
        severity: json['severity'] as String? ?? 'Medium',
        recommendedAction: json['recommendedAction'] as String? ?? '',
        responsiblePerson: json['responsiblePerson'] as String? ?? '',
        targetCompletionDate: json['targetCompletionDate'] != null
            ? DateTime.tryParse(json['targetCompletionDate'] as String)
            : null,
      );

  NonConformance copyWith({
    String? description,
    String? severity,
    String? recommendedAction,
    String? responsiblePerson,
    DateTime? targetCompletionDate,
  }) {
    return NonConformance(
      description: description ?? this.description,
      severity: severity ?? this.severity,
      recommendedAction: recommendedAction ?? this.recommendedAction,
      responsiblePerson: responsiblePerson ?? this.responsiblePerson,
      targetCompletionDate: targetCompletionDate ?? this.targetCompletionDate,
    );
  }
}

class InspectionPhoto {
  final String path;
  final String caption;

  const InspectionPhoto({
    required this.path,
    required this.caption,
  });

  Map<String, dynamic> toJson() => {
        'path': path,
        'caption': caption,
      };

  factory InspectionPhoto.fromJson(Map<String, dynamic> json) =>
      InspectionPhoto(
        path: json['path'] as String? ?? '',
        caption: json['caption'] as String? ?? '',
      );

  InspectionPhoto copyWith({
    String? path,
    String? caption,
  }) {
    return InspectionPhoto(
      path: path ?? this.path,
      caption: caption ?? this.caption,
    );
  }
}

class InspectionSignatures {
  final String inspector;
  final String contractor;
  final String qaqc;

  const InspectionSignatures({
    required this.inspector,
    required this.contractor,
    required this.qaqc,
  });

  Map<String, dynamic> toJson() => {
        'inspector': inspector,
        'contractor': contractor,
        'qaqc': qaqc,
      };

  factory InspectionSignatures.fromJson(Map<String, dynamic> json) =>
      InspectionSignatures(
        inspector: json['inspector'] as String? ?? '',
        contractor: json['contractor'] as String? ?? '',
        qaqc: json['qaqc'] as String? ?? '',
      );

  InspectionSignatures copyWith({
    String? inspector,
    String? contractor,
    String? qaqc,
  }) {
    return InspectionSignatures(
      inspector: inspector ?? this.inspector,
      contractor: contractor ?? this.contractor,
      qaqc: qaqc ?? this.qaqc,
    );
  }
}

class InspectionReport {
  final String id; // maps to uuid
  final String inspectionId; // e.g. INSP-YYYYMMDD-XXXX
  final String projectUuid;
  final String projectName;
  final String title;
  final String inspectorName;
  final String witness;
  final String status; // 'Draft' | 'Pending' | 'Approved' | 'Rejected'
  final String priority; // 'Low' | 'Medium' | 'High' | 'Critical'
  final String overallResult; // 'Pass' | 'Fail' | 'Open NC'
  final DateTime inspectionDate;
  final String inspectionType; // e.g. 'Civil', 'Structural', etc.
  final List<ChecklistItem> checklist;
  final List<NonConformance> nonConformance;
  final List<InspectionPhoto> photos;
  final InspectionSignatures signatures;
  final String time;
  final String area;
  final String location;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;

  const InspectionReport({
    required this.id,
    required this.inspectionId,
    required this.projectUuid,
    required this.projectName,
    required this.title,
    required this.inspectorName,
    required this.witness,
    required this.status,
    required this.priority,
    required this.overallResult,
    required this.inspectionDate,
    required this.inspectionType,
    required this.checklist,
    required this.nonConformance,
    required this.photos,
    required this.signatures,
    required this.time,
    required this.area,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'inspectionId': inspectionId,
        'projectUuid': projectUuid,
        'projectName': projectName,
        'title': title,
        'inspectorName': inspectorName,
        'witness': witness,
        'status': status,
        'priority': priority,
        'overallResult': overallResult,
        'inspectionDate': inspectionDate.toIso8601String(),
        'inspectionType': inspectionType,
        'checklist': checklist.map((e) => e.toJson()).toList(),
        'nonConformance': nonConformance.map((e) => e.toJson()).toList(),
        'photos': photos.map((e) => e.toJson()).toList(),
        'signatures': signatures.toJson(),
        'time': time,
        'area': area,
        'location': location,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'isSynced': isSynced,
      };

  factory InspectionReport.fromJson(Map<String, dynamic> json) =>
      InspectionReport(
        id: json['id'] as String? ?? '',
        inspectionId: json['inspectionId'] as String? ?? '',
        projectUuid: json['projectUuid'] as String? ?? '',
        projectName: json['projectName'] as String? ?? '',
        title: json['title'] as String? ?? '',
        inspectorName: json['inspectorName'] as String? ?? '',
        witness: json['witness'] as String? ?? '',
        status: json['status'] as String? ?? 'Draft',
        priority: json['priority'] as String? ?? 'Medium',
        overallResult: json['overallResult'] as String? ?? 'Open NC',
        inspectionDate: json['inspectionDate'] != null
            ? DateTime.parse(json['inspectionDate'] as String)
            : DateTime.now(),
        inspectionType: json['inspectionType'] as String? ?? 'General',
        checklist: json['checklist'] != null
            ? (json['checklist'] as List)
                .map((e) => ChecklistItem.fromJson(e as Map<String, dynamic>))
                .toList()
            : [],
        nonConformance: json['nonConformance'] != null
            ? (json['nonConformance'] as List)
                .map((e) => NonConformance.fromJson(e as Map<String, dynamic>))
                .toList()
            : [],
        photos: json['photos'] != null
            ? (json['photos'] as List)
                .map((e) => InspectionPhoto.fromJson(e as Map<String, dynamic>))
                .toList()
            : [],
        signatures: json['signatures'] != null
            ? InspectionSignatures.fromJson(json['signatures'] as Map<String, dynamic>)
            : const InspectionSignatures(inspector: '', contractor: '', qaqc: ''),
        time: json['time'] as String? ?? '',
        area: json['area'] as String? ?? '',
        location: json['location'] as String? ?? '',
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : DateTime.now(),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'] as String)
            : DateTime.now(),
        isSynced: json['isSynced'] as bool? ?? false,
      );

  InspectionReport copyWith({
    String? id,
    String? inspectionId,
    String? projectUuid,
    String? projectName,
    String? title,
    String? inspectorName,
    String? witness,
    String? status,
    String? priority,
    String? overallResult,
    DateTime? inspectionDate,
    String? inspectionType,
    List<ChecklistItem>? checklist,
    List<NonConformance>? nonConformance,
    List<InspectionPhoto>? photos,
    InspectionSignatures? signatures,
    String? time,
    String? area,
    String? location,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return InspectionReport(
      id: id ?? this.id,
      inspectionId: inspectionId ?? this.inspectionId,
      projectUuid: projectUuid ?? this.projectUuid,
      projectName: projectName ?? this.projectName,
      title: title ?? this.title,
      inspectorName: inspectorName ?? this.inspectorName,
      witness: witness ?? this.witness,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      overallResult: overallResult ?? this.overallResult,
      inspectionDate: inspectionDate ?? this.inspectionDate,
      inspectionType: inspectionType ?? this.inspectionType,
      checklist: checklist ?? this.checklist,
      nonConformance: nonConformance ?? this.nonConformance,
      photos: photos ?? this.photos,
      signatures: signatures ?? this.signatures,
      time: time ?? this.time,
      area: area ?? this.area,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
