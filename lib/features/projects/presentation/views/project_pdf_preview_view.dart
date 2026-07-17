import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mhgo/core/theme/app_theme.dart';
import 'package:mhgo/features/materials/domain/entities/materials_entities.dart';
import 'package:mhgo/features/materials/presentation/providers/materials_provider.dart';
import 'package:mhgo/features/projects/presentation/providers/projects_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../../core/database/models/project_model.dart';

class ProjectPdfPreviewView extends ConsumerWidget {
  final String uuid;

  const ProjectPdfPreviewView({
    super.key,
    required this.uuid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final projectAsync = ref.watch(projectDetailsProvider(uuid));
    final materialsAsync = ref.watch(projectMaterialRequirementsProvider(uuid));

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : const Color(0xFFECEFF1),
      appBar: AppBar(
        title: const Text('Project Specs & BOM Print Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print_outlined),
            tooltip: 'Print Report',
            onPressed: () async {
              if (projectAsync.value != null && materialsAsync.value != null) {
                await Printing.layoutPdf(
                  onLayout: (PdfPageFormat format) async => _generatePdf(projectAsync.value!.project, materialsAsync.value!),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.download_rounded),
            tooltip: 'Download PDF',
            onPressed: () async {
              if (projectAsync.value != null && materialsAsync.value != null) {
                final bytes = await _generatePdf(projectAsync.value!.project, materialsAsync.value!);
                await Printing.sharePdf(
                  bytes: bytes, 
                  filename: 'Project_BOM_${projectAsync.value!.project.name.replaceAll(' ', '_')}.pdf',
                );
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: projectAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
          data: (detailedData) {
            final project = detailedData.project;
            if (project == null) {
              return const Center(child: Text('Project not found.'));
            }
            
            return materialsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (materials) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                  child: Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final double availableWidth = constraints.maxWidth;
                        final double targetWidth = 794.0; // A4 portrait width at 96 DPI

                        Widget pageContent = Hero(
                          tag: 'pdf_page_${project.uuid}',
                          child: Material(
                            elevation: 8,
                            borderRadius: BorderRadius.circular(4),
                            child: Container(
                              width: targetWidth,
                              padding: const EdgeInsets.all(40.0),
                              color: Colors.white, 
                              child: DefaultTextStyle(
                                style: const TextStyle(color: Colors.black87, fontFamily: 'Courier'),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildPdfHeader(project),
                                    const SizedBox(height: 12),
                                    const Divider(color: Colors.black54, thickness: 1.5),
                                    const SizedBox(height: 12),

                                    _buildPdfInfoRow(project),
                                    const SizedBox(height: 24),

                                    _buildPdfBomSpecs(project),
                                    const SizedBox(height: 24),

                                    if (materials.isNotEmpty) ...[
                                      _buildPdfMaterialsTable(materials),
                                      const SizedBox(height: 24),
                                    ],
                                    
                                    const SizedBox(height: 40),
                                    const Divider(color: Colors.black26),
                                    const SizedBox(height: 8),
                                    _buildPdfFooter(project),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );

                        if (availableWidth < targetWidth) {
                          return FittedBox(
                            fit: BoxFit.scaleDown,
                            child: pageContent,
                          );
                        }
                        return pageContent;
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPdfHeader(ProjectModel project) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'MHG SOLAR EPC SOLUTIONS INC.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                color: Color(0xFF1B5E20),
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'EPC Project Site Operations & Engineering Division',
              style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'PROJECT SPECIFICATIONS & BOM',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                background: Paint()..color = Colors.yellow.withOpacity(0.3),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'GENERATED: ${DateFormat('MMM dd, yyyy').format(DateTime.now())}',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPdfInfoRow(ProjectModel project) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        color: const Color(0xFFF5F5F5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoItem('PROJECT NAME:', project.name),
          _buildInfoItem('CLIENT:', project.client ?? 'N/A'),
          _buildInfoItem('LOCATION:', project.location),
          _buildInfoItem('CAPACITY:', '${project.capacityMw} ${project.capacityUnit}'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPdfBomSpecs(ProjectModel project) {
    Map<String, dynamic> solar = {};
    Map<String, dynamic> battery = {};
    Map<String, dynamic> inverter = {};

    if (project.bomSpecsJson != null) {
      try {
        final bom = jsonDecode(project.bomSpecsJson!);
        solar = bom['solar'] as Map<String, dynamic>? ?? {};
        battery = bom['battery'] as Map<String, dynamic>? ?? {};
        inverter = bom['inverter'] as Map<String, dynamic>? ?? {};
        
        if (solar.isEmpty && bom['panels'] != null) solar['brand'] = bom['panels'];
        if (battery.isEmpty && bom['battery'] != null) battery['brand'] = bom['battery'];
        if (inverter.isEmpty && bom['inverter'] != null) inverter['brand'] = bom['inverter'];
      } catch (_) {}
    }

    String formatSpecs(Map<String, dynamic> specs) {
      final entries = specs.entries.where((e) => e.value.toString().isNotEmpty);
      if (entries.isEmpty) return 'N/A';
      return entries.map((e) => '${e.key.toUpperCase()}: ${e.value}').join(' | ');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'EQUIPMENT SPECIFICATIONS',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(border: Border.all(color: Colors.black54)),
          child: Column(
            children: [
              _buildSpecsRow('Solar Panels', formatSpecs(solar), isFirst: true),
              _buildSpecsRow('Inverter', formatSpecs(inverter)),
              _buildSpecsRow('Battery System', formatSpecs(battery)),
              _buildSpecsRow('Total Project Cost', NumberFormat.currency(symbol: '₱', decimalDigits: 2).format(project.totalCost)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecsRow(String label, String value, {bool isFirst = false}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: isFirst ? BorderSide.none : const BorderSide(color: Colors.black26)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 150,
              padding: const EdgeInsets.all(8),
              color: const Color(0xFFF0F0F0),
              child: Text(
                label,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            const VerticalDivider(width: 1, thickness: 1, color: Colors.black26),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPdfMaterialsTable(List<ProjectMaterialRequirementEntity> materials) {
    double grandTotal = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'BILL OF MATERIALS',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black54)),
          child: Column(
            children: [
              Container(
                color: const Color(0xFFEEEEEE),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: const Row(
                  children: [
                    Expanded(flex: 3, child: Text('DESCRIPTION', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold))),
                    Expanded(flex: 1, child: Text('QTY', textAlign: TextAlign.center, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold))),
                    Expanded(flex: 1, child: Text('UNIT', textAlign: TextAlign.center, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold))),
                    Expanded(flex: 2, child: Text('STATUS', textAlign: TextAlign.center, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1, color: Colors.black54),
              ...materials.map((m) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black12)),
                  ),
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: Text(m.materialUuid, style: const TextStyle(fontSize: 9))),
                      Expanded(flex: 1, child: Text(m.requiredQuantity.toString(), textAlign: TextAlign.center, style: const TextStyle(fontSize: 9))),
                      Expanded(flex: 1, child: Text(m.unit, textAlign: TextAlign.center, style: const TextStyle(fontSize: 9))),
                      Expanded(flex: 2, child: Text(m.status, textAlign: TextAlign.center, style: const TextStyle(fontSize: 9))),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPdfFooter(ProjectModel project) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Confidential - Internal Use Only',
          style: TextStyle(fontSize: 9, color: Colors.black54),
        ),
        Text(
          'Project UUID: ${project.uuid}',
          style: const TextStyle(fontSize: 8, color: Colors.black54),
        ),
      ],
    );
  }

  // --- PDF GENERATION LOGIC ---
  Future<Uint8List> _generatePdf(ProjectModel project, List<ProjectMaterialRequirementEntity> materials) async {
    final pdf = pw.Document();

    Map<String, dynamic> solar = {};
    Map<String, dynamic> battery = {};
    Map<String, dynamic> inverter = {};

    if (project.bomSpecsJson != null) {
      try {
        final bom = jsonDecode(project.bomSpecsJson!);
        solar = bom['solar'] as Map<String, dynamic>? ?? {};
        battery = bom['battery'] as Map<String, dynamic>? ?? {};
        inverter = bom['inverter'] as Map<String, dynamic>? ?? {};
        if (solar.isEmpty && bom['panels'] != null) solar['brand'] = bom['panels'];
        if (battery.isEmpty && bom['battery'] != null) battery['brand'] = bom['battery'];
        if (inverter.isEmpty && bom['inverter'] != null) inverter['brand'] = bom['inverter'];
      } catch (_) {}
    }

    String formatSpecs(Map<String, dynamic> specs) {
      final entries = specs.entries.where((e) => e.value.toString().isNotEmpty);
      if (entries.isEmpty) return 'N/A';
      return entries.map((e) => '${e.key.toUpperCase()}: ${e.value}').join(' | ');
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // HEADER
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'MHG SOLAR EPC SOLUTIONS INC.',
                      style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: const PdfColor.fromInt(0xFF1B5E20)),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'EPC Project Site Operations & Engineering Division',
                      style: pw.TextStyle(fontSize: 10, color: const PdfColor.fromInt(0xFF757575), fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      'PROJECT SPECIFICATIONS & BOM',
                      style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'GENERATED: ${DateFormat('MMM dd, yyyy').format(DateTime.now())}',
                      style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 12),
            pw.Divider(color: const PdfColor.fromInt(0xFF000000), thickness: 1.5),
            pw.SizedBox(height: 12),

            // INFO
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: const PdfColor.fromInt(0xFFE0E0E0)),
                color: const PdfColor.fromInt(0xFFF5F5F5),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  _pdfInfoItem('PROJECT NAME:', project.name),
                  _pdfInfoItem('CLIENT:', project.client ?? 'N/A'),
                  _pdfInfoItem('LOCATION:', project.location),
                  _pdfInfoItem('CAPACITY:', '${project.capacityMw} ${project.capacityUnit}'),
                ],
              ),
            ),
            pw.SizedBox(height: 24),

            // SPECS
            pw.Text(
              'EQUIPMENT SPECIFICATIONS',
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            pw.Table(
              border: pw.TableBorder.all(color: const PdfColor.fromInt(0xFF9E9E9E)),
              columnWidths: {
                0: const pw.FixedColumnWidth(120),
                1: const pw.FlexColumnWidth(),
              },
              children: [
                _pdfSpecsRow('Solar Panels', formatSpecs(solar)),
                _pdfSpecsRow('Inverter', formatSpecs(inverter)),
                _pdfSpecsRow('Battery System', formatSpecs(battery)),
                _pdfSpecsRow('Total Project Cost', NumberFormat.currency(symbol: '₱', decimalDigits: 2).format(project.totalCost)),
              ],
            ),
            pw.SizedBox(height: 24),

            // MATERIALS
            if (materials.isNotEmpty) ...[
              pw.Text(
                'BILL OF MATERIALS',
                style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 8),
              _buildRealPdfMaterialsTable(materials, project.totalCost),
              pw.SizedBox(height: 24),
            ],
          ];
        },
        footer: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Divider(color: const PdfColor.fromInt(0xFFBDBDBD)),
              pw.SizedBox(height: 4),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Confidential - Internal Use Only', style: const pw.TextStyle(fontSize: 8, color: PdfColor.fromInt(0xFF757575))),
                  pw.Text('Page ${context.pageNumber} of ${context.pagesCount}', style: const pw.TextStyle(fontSize: 8, color: PdfColor.fromInt(0xFF757575))),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _pdfInfoItem(String label, String value) {
    return pw.Expanded(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: const PdfColor.fromInt(0xFF757575)),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  pw.TableRow _pdfSpecsRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.all(6),
          color: const PdfColor.fromInt(0xFFEEEEEE),
          child: pw.Text(label, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text(value, style: const pw.TextStyle(fontSize: 10)),
        ),
      ],
    );
  }

  pw.Widget _buildRealPdfMaterialsTable(List<ProjectMaterialRequirementEntity> materials, double totalCost) {
    return pw.Table(
      border: pw.TableBorder.all(color: const PdfColor.fromInt(0xFF9E9E9E)),
      columnWidths: {
        0: const pw.FlexColumnWidth(3),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FlexColumnWidth(1),
        3: const pw.FlexColumnWidth(2),
      },
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFFEEEEEE)),
          children: [
            pw.Container(padding: const pw.EdgeInsets.all(6), child: pw.Text('DESCRIPTION', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold))),
            pw.Container(padding: const pw.EdgeInsets.all(6), child: pw.Text('QTY', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold))),
            pw.Container(padding: const pw.EdgeInsets.all(6), child: pw.Text('UNIT', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold))),
            pw.Container(padding: const pw.EdgeInsets.all(6), child: pw.Text('STATUS', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold))),
          ],
        ),
        // Rows
        ...materials.map((m) {
          return pw.TableRow(
            children: [
              pw.Container(padding: const pw.EdgeInsets.all(4), child: pw.Text(m.customName ?? m.materialUuid, style: const pw.TextStyle(fontSize: 9))),
              pw.Container(padding: const pw.EdgeInsets.all(4), child: pw.Text(m.requiredQuantity.toString(), textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 9))),
              pw.Container(padding: const pw.EdgeInsets.all(4), child: pw.Text(m.unit, textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 9))),
              pw.Container(padding: const pw.EdgeInsets.all(4), child: pw.Text(m.status, textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 9))),
            ],
          );
        }),
        // Grand Total omitted from material list, as it was moved to specs. But to satisfy "Replace with project saved totalCost":
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFFF5F5F5)),
          children: [
            pw.Container(padding: const pw.EdgeInsets.all(6), child: pw.Text('TOTAL PROJECT COST', textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))),
            pw.Container(),
            pw.Container(),
            pw.Container(padding: const pw.EdgeInsets.all(6), child: pw.Text('PHP ${totalCost.toStringAsFixed(2)}', textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))),
          ],
        ),
      ],
    );
  }
}
