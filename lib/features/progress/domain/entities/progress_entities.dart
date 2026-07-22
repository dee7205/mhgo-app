class ProgressReport {
  final String uuid;
  final String projectUuid;
  final String projectName;
  final double overallProgress;
  final bool isAutoCalculated;
  final List<ProgressCategory> categories;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;

  ProgressReport({
    required this.uuid,
    required this.projectUuid,
    required this.projectName,
    required this.overallProgress,
    required this.isAutoCalculated,
    required this.categories,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });

  factory ProgressReport.fromJson(Map<String, dynamic> json) {
    return ProgressReport(
      uuid: json['uuid'] as String,
      projectUuid: json['projectUuid'] as String,
      projectName: json['projectName'] as String,
      overallProgress: (json['overallProgress'] as num).toDouble(),
      isAutoCalculated: json['isAutoCalculated'] as bool? ?? true,
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => ProgressCategory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isSynced: json['isSynced'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'projectUuid': projectUuid,
      'projectName': projectName,
      'overallProgress': overallProgress,
      'isAutoCalculated': isAutoCalculated,
      'categories': categories.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isSynced': isSynced,
    };
  }

  ProgressReport copyWith({
    String? uuid,
    String? projectUuid,
    String? projectName,
    double? overallProgress,
    bool? isAutoCalculated,
    List<ProgressCategory>? categories,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return ProgressReport(
      uuid: uuid ?? this.uuid,
      projectUuid: projectUuid ?? this.projectUuid,
      projectName: projectName ?? this.projectName,
      overallProgress: overallProgress ?? this.overallProgress,
      isAutoCalculated: isAutoCalculated ?? this.isAutoCalculated,
      categories: categories ?? this.categories,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}

class ProgressCategory {
  final String id;
  final String name;
  final String? description;
  final double progress;
  final String status;
  final DateTime? targetDate;
  final DateTime lastUpdated;
  final String? notes;
  final bool isArchived;
  final int orderIndex;

  ProgressCategory({
    required this.id,
    required this.name,
    this.description,
    required this.progress,
    required this.status,
    this.targetDate,
    required this.lastUpdated,
    this.notes,
    required this.isArchived,
    required this.orderIndex,
  });

  factory ProgressCategory.fromJson(Map<String, dynamic> json) {
    return ProgressCategory(
      id:
          json['id'] as String? ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'] as String,
      description: json['description'] as String?,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'Not Started',
      targetDate: json['targetDate'] != null
          ? DateTime.parse(json['targetDate'] as String)
          : null,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : DateTime.now(),
      notes: json['notes'] as String?,
      isArchived: json['isArchived'] as bool? ?? false,
      orderIndex: json['orderIndex'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'progress': progress,
      'status': status,
      'targetDate': targetDate?.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'notes': notes,
      'isArchived': isArchived,
      'orderIndex': orderIndex,
    };
  }

  ProgressCategory copyWith({
    String? id,
    String? name,
    String? description,
    double? progress,
    String? status,
    DateTime? targetDate,
    DateTime? lastUpdated,
    String? notes,
    bool? isArchived,
    int? orderIndex,
  }) {
    return ProgressCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      targetDate: targetDate ?? this.targetDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      notes: notes ?? this.notes,
      isArchived: isArchived ?? this.isArchived,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}
