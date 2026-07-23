import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AiPdfGenerator {
  static pw.Widget _buildRichText(String text) {
    final List<pw.TextSpan> spans = [];
    // Split by ** to detect bold sections
    final parts = text.split('**');
    
    for (int i = 0; i < parts.length; i++) {
      if (i % 2 == 1) { // It's bold
        spans.add(pw.TextSpan(
          text: parts[i],
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.grey900),
        ));
      } else {
        // Handle single asterisks for italics if needed, or just normal text
        spans.add(pw.TextSpan(
          text: parts[i].replaceAll('*', ''), 
          style: const pw.TextStyle(color: PdfColors.grey800),
        ));
      }
    }
    
    return pw.RichText(
      text: pw.TextSpan(
        children: spans,
        style: const pw.TextStyle(fontSize: 11, lineSpacing: 1.4),
      ),
    );
  }

  static List<pw.Widget> _parseMarkdownToWidgets(String text) {
    final List<pw.Widget> elements = [];
    final lines = text.replaceAll('[GENERATE_PDF]', '').trim().split('\n');

    for (var line in lines) {
      final tLine = line.trim();
      
      if (tLine.isEmpty) {
        elements.add(pw.SizedBox(height: 8));
      } else if (tLine.startsWith('###') || tLine.startsWith('##') || tLine.startsWith('#')) {
        final headingText = tLine.replaceAll(RegExp(r'^#+\s*'), '');
        elements.add(pw.SizedBox(height: 12));
        elements.add(
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: const pw.BoxDecoration(
              border: pw.Border(left: pw.BorderSide(color: PdfColors.blue800, width: 4)),
            ),
            child: pw.Text(
              headingText.replaceAll('**', ''),
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900),
            ),
          )
        );
        elements.add(pw.SizedBox(height: 8));
      } else if (tLine.startsWith('-') || tLine.startsWith('*')) {
        final content = tLine.substring(1).trim();
        elements.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 12, bottom: 4),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.only(right: 8, top: 4),
                  child: pw.Container(
                    width: 4, 
                    height: 4, 
                    decoration: const pw.BoxDecoration(color: PdfColors.blue800, shape: pw.BoxShape.circle),
                  ),
                ),
                pw.Expanded(child: _buildRichText(content)),
              ],
            ),
          )
        );
      } else {
        elements.add(_buildRichText(tLine));
        elements.add(pw.SizedBox(height: 4));
      }
    }
    return elements;
  }

  static Future<void> generateAndPrint(String aiText) async {
    final pdf = pw.Document();
    
    // The default PDF fonts do not support the ₱ symbol and render it as [X]. 
    // We replace it with 'PHP ' as a fallback.
    final sanitizedText = aiText.replaceAll('₱', 'PHP ');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 48),
        header: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    'MHGo',
                    style: pw.TextStyle(
                      fontSize: 28,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue900,
                    ),
                  ),
                  pw.Text(
                    'SOLAR EPC QUOTATION / REPORT',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.grey600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Divider(color: PdfColors.blue900, thickness: 2),
              pw.SizedBox(height: 24),
            ],
          );
        },
        footer: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Divider(color: PdfColors.grey300),
              pw.SizedBox(height: 8),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Generated securely by MHGo AI Assistant',
                    style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
                  ),
                  pw.Text(
                    'Page ${context.pageNumber} of ${context.pagesCount}',
                    style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
                  ),
                ],
              ),
            ],
          );
        },
        build: (pw.Context context) {
          return _parseMarkdownToWidgets(sanitizedText);
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'MHGo_AI_Report.pdf',
    );
  }
}
