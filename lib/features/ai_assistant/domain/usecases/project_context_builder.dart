import 'package:mhgo/features/projects/domain/entities/projects_entities.dart';

class ProjectContextBuilder {
  /// Converts a [DetailedProjectData] object into a structured Markdown string
  /// that Gemini can easily read and analyze.
  static String build(DetailedProjectData data) {
    final project = data.project;
    
    // We use a StringBuffer because it is much more memory efficient 
    // for building large strings in Dart than using the '+' operator.
    final buffer = StringBuffer();

    // 1. Core Project Details
    buffer.writeln('# Project Core Details');
    buffer.writeln('- Name: ${project.name}');
    buffer.writeln('- Status: ${project.status}');
    buffer.writeln('- Stage: ${project.stage ?? "N/A"}');
    buffer.writeln('- Capacity: ${project.capacity} ${project.capacityUnit ?? "kWp"}');
    buffer.writeln('- Installation Type: ${project.type}');
    buffer.writeln('- System Type: ${project.systemType ?? "N/A"}');
    buffer.writeln('- Location: ${project.location}');
    buffer.writeln('- Client: ${project.client ?? "N/A"}');
    buffer.writeln('- Description: ${project.description ?? "N/A"}');
    buffer.writeln('- Overall Progress: ${(project.progress * 100).toStringAsFixed(1)}%');
    buffer.writeln('');

    // 2. Timeline & Milestones
    if (data.timeline.isNotEmpty) {
      buffer.writeln('# Milestones & Sub-Progress');
      for (final item in data.timeline) {
        buffer.writeln('- ${item.milestoneName}: ${item.status} (${(item.progress * 100).toStringAsFixed(1)}%)');
      }
      buffer.writeln('');
    }

    // 3. BOM & Specifications (if available)
    if (project.bomSpecsJson != null && project.bomSpecsJson!.isNotEmpty) {
      buffer.writeln('# System Specifications & Brands');
      buffer.writeln('JSON Data: ${project.bomSpecsJson}');
      buffer.writeln('');
    }

    // 4. Activity & Quality Summaries
    buffer.writeln('# Module Summaries');
    buffer.writeln('- Total Site Inspections: ${data.inspectionSummary.totalInspections} (${data.inspectionSummary.approved} Approved, ${data.inspectionSummary.rejected} Rejected)');
    buffer.writeln('- Daily Accomplishment Reports (DARs) Filed: ${data.darSummary.reportsFiled}');
    buffer.writeln('- Punch List Items: ${data.punchListSummary.totalItems} (${data.punchListSummary.openItems} Open, ${data.punchListSummary.resolvedItems} Resolved)');

    return buffer.toString();
  }
}
