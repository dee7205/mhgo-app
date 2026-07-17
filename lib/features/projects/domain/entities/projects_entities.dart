import 'package:mhgo/core/database/models/project_model.dart';

class ProjectCategoryProgress {
  final String name;
  final double progress;
  final String status;

  const ProjectCategoryProgress({
    required this.name,
    required this.progress,
    required this.status,
  });
}

class ProjectKpis {
  final int totalManHours;
  final int safeDays;
  final double weatherDowntimeHours;
  final double qualityComplianceRate;

  const ProjectKpis({
    required this.totalManHours,
    required this.safeDays,
    required this.weatherDowntimeHours,
    required this.qualityComplianceRate,
  });
}

class ProjectActivityLog {
  final DateTime timestamp;
  final String title;
  final String description;
  final String category; // 'QC' | 'Engineering' | 'Logistics' | 'Safety'
  final String author;

  const ProjectActivityLog({
    required this.timestamp,
    required this.title,
    required this.description,
    required this.category,
    required this.author,
  });
}

class DocumentSummary {
  final String title;
  final String code;
  final String category; // 'AS-BUILT', 'CIVIL DRAWING', 'QC CHECKLIST'
  final String revision;
  final String status; // 'Approved', 'Under Review'

  const DocumentSummary({
    required this.title,
    required this.code,
    required this.category,
    required this.revision,
    required this.status,
  });
}

class MaterialSummaryItem {
  final String name;
  final int quantityRequired;
  final int quantityReceived;
  final String unit;
  final double deliveryProgress;

  const MaterialSummaryItem({
    required this.name,
    required this.quantityRequired,
    required this.quantityReceived,
    required this.unit,
    required this.deliveryProgress,
  });
}

class InspectionSummary {
  final int totalInspections;
  final int approved;
  final int rejected;
  final int pending;

  const InspectionSummary({
    required this.totalInspections,
    required this.approved,
    required this.rejected,
    required this.pending,
  });
}

class DarSummary {
  final int reportsFiled;
  final double averageProgressPerDay;
  final int totalWorkersOnSite;

  const DarSummary({
    required this.reportsFiled,
    required this.averageProgressPerDay,
    required this.totalWorkersOnSite,
  });
}

class PunchListSummary {
  final int totalItems;
  final int openItems;
  final int resolvedItems;
  final int closedItems;

  const PunchListSummary({
    required this.totalItems,
    required this.openItems,
    required this.resolvedItems,
    required this.closedItems,
  });
}

class ProjectTeamMember {
  final String name;
  final String role;
  final String department;
  final String contactEmail;
  final String contactPhone;
  final int assignedTasksCount;
  final String workload; // 'Low', 'Medium', 'High', 'Optimal'
  final String avatarInitials;

  const ProjectTeamMember({
    required this.name,
    required this.role,
    required this.department,
    required this.contactEmail,
    required this.contactPhone,
    required this.assignedTasksCount,
    required this.workload,
    required this.avatarInitials,
  });

  factory ProjectTeamMember.fromJson(Map<String, dynamic> json) {
    return ProjectTeamMember(
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? '',
      department: json['department'] as String? ?? '',
      contactEmail: json['contactEmail'] as String? ?? '',
      contactPhone: json['contactPhone'] as String? ?? '',
      assignedTasksCount: json['assignedTasksCount'] as int? ?? 0,
      workload: json['workload'] as String? ?? 'Optimal',
      avatarInitials: json['avatarInitials'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'role': role,
      'department': department,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'assignedTasksCount': assignedTasksCount,
      'workload': workload,
      'avatarInitials': avatarInitials,
    };
  }
}

class ProjectTimelineItem {
  final String milestoneName;
  final DateTime date;
  final String owner;
  final String status; // 'completed', 'upcoming', 'delayed'
  final double progress;

  const ProjectTimelineItem({
    required this.milestoneName,
    required this.date,
    required this.owner,
    required this.status,
    required this.progress,
  });
}

class DetailedProjectData {
  final ProjectModel project;
  final List<ProjectCategoryProgress> categoryProgresses;
  final ProjectKpis kpis;
  final List<ProjectActivityLog> activityLogs;
  final List<ProjectTimelineItem> timeline;
  final List<ProjectTeamMember> team;
  final List<DocumentSummary> documents;
  final List<MaterialSummaryItem> materials;
  final InspectionSummary inspectionSummary;
  final DarSummary darSummary;
  final PunchListSummary punchListSummary;

  const DetailedProjectData({
    required this.project,
    required this.categoryProgresses,
    required this.kpis,
    required this.activityLogs,
    required this.timeline,
    required this.team,
    required this.documents,
    required this.materials,
    required this.inspectionSummary,
    required this.darSummary,
    required this.punchListSummary,
  });
}
