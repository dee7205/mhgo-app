import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:mhgo/core/theme/app_theme.dart';
import 'package:mhgo/features/survey/domain/entities/survey_entities.dart';
import 'package:mhgo/features/survey/presentation/providers/survey_provider.dart';

class SurveyPdfPreviewView extends ConsumerWidget {
  final String id;

  const SurveyPdfPreviewView({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final detailsAsync = ref.watch(surveyDetailsProvider(id));

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: AppBar(
        title: const Text('Survey Report PDF'),
      ),
      body: SafeArea(
        child: detailsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Text(
              'Error loading report: $err',
              style: const TextStyle(color: Colors.red),
            ),
          ),
          data: (survey) {
            if (survey == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning_amber_rounded, size: 60, color: Colors.orange),
                    const SizedBox(height: 16),
                    Text('Survey data not found.', style: theme.textTheme.titleMedium),
                  ],
                ),
              );
            }
            return PdfPreview(
              build: (format) => SurveyPdfPreviewView.generatePdfDocument(survey, format),
              pdfFileName: 'survey_report_${survey.uuid}.pdf',
              canChangeOrientation: false,
              canChangePageFormat: false,
              allowPrinting: true,
              allowSharing: true,
            );
          },
        ),
      ),
    );
  }

  static Future<Uint8List> generatePdfDocument(Survey survey, PdfPageFormat format, {Uint8List? logoBytes}) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final formattedDate = DateFormat('EEEE, MMMM dd, yyyy').format(survey.surveyDate);

    final pw.ImageProvider? logoImage = logoBytes != null ? pw.MemoryImage(logoBytes) : null;

    // Helper to draw a type-safe vector Philippine Peso symbol that never throws font missing exceptions
    pw.Widget pesoSymbol(double fontSize, PdfColor color) {
      return pw.CustomPaint(
        size: PdfPoint(fontSize * 0.6, fontSize),
        painter: (PdfGraphics canvas, PdfPoint size) {
          canvas
            ..setColor(color)
            ..setLineWidth(fontSize * 0.08)
            ..moveTo(0, size.y * 0.2)
            ..lineTo(0, size.y * 0.85)
            ..drawEllipse(size.x * 0.45, size.y * 0.67, size.x * 0.45, size.y * 0.2)
            ..strokePath()
          // Horizontal double bars matching the strict ₱ configuration
            ..moveTo(-size.x * 0.1, size.y * 0.62)
            ..lineTo(size.x * 0.8, size.y * 0.62)
            ..strokePath()
            ..moveTo(-size.x * 0.1, size.y * 0.48)
            ..lineTo(size.x * 0.8, size.y * 0.48)
            ..strokePath();
        },
      );
    }

    // Standardized row builder for formal two-column technical layouts
    pw.Widget buildFormalRow(String label, pw.Widget valueWidget) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 4),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              flex: 3,
              child: pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.grey800, fontSize: 10)),
            ),
            pw.Expanded(
              flex: 5,
              child: valueWidget,
            ),
          ],
        ),
      );
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format.copyWith(
          marginTop: 1.5 * PdfPageFormat.cm,
          marginBottom: 1.5 * PdfPageFormat.cm,
          marginLeft: 1.5 * PdfPageFormat.cm,
          marginRight: 1.5 * PdfPageFormat.cm,
        ),
        // Running structural header repeated across pages
        header: (context) => pw.Column(
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('MHGO ENGG - FIELD OPERATIONS', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500)),
                pw.Text('CONFIDENTIAL', style: const pw.TextStyle(fontSize: 8, color: PdfColors.red500)),
              ],
            ),
            pw.SizedBox(height: 4),
            pw.Divider(thickness: 0.5, color: PdfColors.grey300),
          ],
        ),
        // Running structural footer calculating pagination elements and branding dynamically
        footer: (context) => pw.Column(
          children: [
            pw.Divider(thickness: 0.5, color: PdfColors.grey300),
            pw.SizedBox(height: 4),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Site Assessment Report', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500)),
                pw.Text('Page ${context.pageNumber} of ${context.pagesCount}', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500)),
              ],
            ),
            pw.SizedBox(height: 4),
            pw.Align(
              alignment: pw.Alignment.centerLeft,
              child: pw.Text(
                'Created using MHGO - Built for MHG',
                style: const pw.TextStyle(fontSize: 6, color: PdfColors.grey600, fontStyle: pw.FontStyle.italic),
              ),
            ),
          ],
        ),
        build: (context) => [
          pw.SizedBox(height: 10),

          // Formal Corporate Header Block
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              logoImage != null
                  ? pw.Image(logoImage, width: 75, height: 75, fit: pw.BoxFit.contain)
                  : pw.Container(
                width: 75,
                height: 75,
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey100,
                  border: pw.Border.fromBorderSide(pw.BorderSide(color: PdfColors.grey300, width: 1)),
                ),
                alignment: pw.Alignment.center,
                child: pw.Text('COMPANY\nLOGO', textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('SITE ASSESSMENT LOG', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.grey900)),
                  pw.SizedBox(height: 4),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.blue50,
                      borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
                    ),
                    child: pw.Text(survey.status.toUpperCase(), style: pw.TextStyle(color: PdfColors.blue800, fontWeight: pw.FontWeight.bold, fontSize: 10)),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text('Date: $formattedDate', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                ],
              ),
            ],
          ),

          pw.SizedBox(height: 25),

          // Section I: Client Particulars
          pw.Text('1. SITE ASSESSMENT PARTICULARS', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
          pw.Divider(thickness: 1, color: PdfColors.blue900),
          pw.SizedBox(height: 4),
          buildFormalRow('Client Name', pw.Text(survey.clientName, style: const pw.TextStyle(fontSize: 10))),
          buildFormalRow('Contact Number', pw.Text(survey.contactNumber, style: const pw.TextStyle(fontSize: 10))),
          buildFormalRow('Email Address', pw.Text(survey.email, style: const pw.TextStyle(fontSize: 10))),
          buildFormalRow('Site Address', pw.Text(survey.address, style: const pw.TextStyle(fontSize: 10))),
          if (survey.coordinates != null)
            buildFormalRow('Geographical Coordinates', pw.Text(survey.coordinates!, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey800))),

          pw.SizedBox(height: 20),

          // Section II: Technical Analysis
          pw.Text('2. SITE TECHNICAL SPECIFICATIONS', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
          pw.Divider(thickness: 1, color: PdfColors.blue900),
          pw.SizedBox(height: 4),
          if (survey.technicalSpecs.isEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 4),
              child: pw.Text('No clear technical specifications structural parameters logged.', style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic)),
            )
          else
            ...survey.technicalSpecs.entries.map((e) => buildFormalRow(e.key, pw.Text(e.value, style: const pw.TextStyle(fontSize: 10)))),

          pw.SizedBox(height: 20),

          // Section III: Engineering Proposal
          pw.Text('3. PROPOSED SYSTEM ARCHITECTURE', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
          pw.Divider(thickness: 1, color: PdfColors.blue900),
          pw.SizedBox(height: 4),
          buildFormalRow('System Configuration', pw.Text(survey.proposedSystem, style: const pw.TextStyle(fontSize: 10))),
          buildFormalRow('Target Array Capacity', pw.Text('${survey.proposedCapacityKw.toStringAsFixed(2)} kW', style: const pw.TextStyle(fontSize: 10))),
          buildFormalRow(
            'Estimated Financial Budget',
            pw.Row(
              mainAxisSize: pw.MainAxisSize.min,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pesoSymbol(10, PdfColors.black),
                pw.SizedBox(width: 2),
                pw.Text(
                  NumberFormat.currency(symbol: '', decimalDigits: 2).format(survey.proposedBudget),
                  style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
          ),

          // Section IV: Remarks
          if (survey.notes != null && survey.notes!.isNotEmpty) ...[
            pw.SizedBox(height: 20),
            pw.Text('4. FIELD SURVEY REMARKS', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
            pw.Divider(thickness: 1, color: PdfColors.blue900),
            pw.SizedBox(height: 6),
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(8),
              decoration: const pw.BoxDecoration(
                color: PdfColors.grey50,
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
              ),
              child: pw.Text(survey.notes!, style: const pw.TextStyle(fontSize: 9.5, color: PdfColors.grey900)),
            ),
          ],
        ],
      ),
    );

    return pdf.save();
  }
}