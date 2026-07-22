import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mhgo/core/theme/app_theme.dart';
import 'package:mhgo/core/widgets/app_button.dart';
import 'package:mhgo/features/dar/domain/entities/dar_entities.dart';
import 'package:mhgo/features/dar/presentation/providers/dar_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfPreviewView extends ConsumerWidget {
  final String id;

  const PdfPreviewView({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final detailsAsync = ref.watch(darDetailsProvider(id));

    return Scaffold(
      backgroundColor: isDark
          ? AppTheme.darkBg
          : const Color(
              0xFFECEFF1,
            ), // Light grey background to contrast the white paper page
      appBar: AppBar(
        title: const Text('DAR PDF Print Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print_outlined),
            tooltip: 'Print Report',
            onPressed: () async {
              if (detailsAsync.value != null) {
                await Printing.layoutPdf(
                  onLayout: (PdfPageFormat format) async =>
                      _generatePdf(detailsAsync.value!),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.download_rounded),
            tooltip: 'Download PDF',
            onPressed: () async {
              if (detailsAsync.value != null) {
                final bytes = await _generatePdf(detailsAsync.value!);
                await Printing.sharePdf(
                  bytes: bytes,
                  filename: 'DAR_${detailsAsync.value!.darNumber}.pdf',
                );
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: detailsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => _buildErrorState(context, err.toString()),
          data: (report) {
            if (report == null) {
              return const Center(
                child: Text('Daily Activity Report not found.'),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                vertical: 32.0,
                horizontal: 16.0,
              ),
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double availableWidth = constraints.maxWidth;
                    final double targetWidth = 794.0;

                    Widget pageContent = Hero(
                      tag: 'pdf_page_${report.id}',
                      child: Material(
                        elevation: 8,
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          width: targetWidth,
                          padding: const EdgeInsets.all(40.0),
                          color: Colors
                              .white, // Always white background for printing page look
                          child: DefaultTextStyle(
                            style: const TextStyle(
                              color: Colors.black87,
                              fontFamily: 'Courier',
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 1. Corporate Header
                                _buildPdfHeader(report),
                                const SizedBox(height: 12),
                                const Divider(
                                  color: Colors.black54,
                                  thickness: 1.5,
                                ),
                                const SizedBox(height: 12),

                                // 2. Info Block Row
                                _buildPdfInfoRow(report),
                                const SizedBox(height: 20),

                                // 3. Weather Conditions Block
                                _buildPdfWeatherRow(report),
                                const SizedBox(height: 24),

                                // 4. Daily Accomplishments Table
                                _buildPdfAccomplishmentsTable(
                                  report.accomplishments,
                                ),
                                const SizedBox(height: 24),

                                // 5. Grid for Manpower, Equipment and Materials side-by-side
                                _buildPdfResourcesSection(report),
                                const SizedBox(height: 24),

                                // 6. Delays Block
                                if (report.delays.isNotEmpty) ...[
                                  _buildPdfDelaysSection(report.delays),
                                  const SizedBox(height: 24),
                                ],

                                // 7. Attached Documentation Photos
                                if (report.photos.isNotEmpty) ...[
                                  _buildPdfPhotosSection(report.photos),
                                  const SizedBox(height: 32),
                                ],

                                // Spacer to push signatures to the bottom if content is short
                                const SizedBox(height: 40),

                                // 8. Sign-off block
                                _buildPdfSignaturesRow(report),
                                const SizedBox(height: 32),

                                // 9. Document Footer
                                const Divider(color: Colors.black26),
                                const SizedBox(height: 8),
                                _buildPdfFooter(report),
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
        ),
      ),
    );
  }

  // --- PDF CORPORATE HEADER ---
  Widget _buildPdfHeader(DarReport report) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Created by MHGo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                color: Color(0xFF1B5E20), // Solar Green primary branding
              ),
            ),
            // const SizedBox(height: 2),
            // const Text(
            //   'PROJECT',
            //   style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 6),
            Text(
              'DAILY ACCOMPLISHMENT REPORT (DAR)',
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
              'REPORT NO: ${report.darNumber}',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              'STATUS: ${report.status.toUpperCase()}',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: report.status == 'Approved' ? Colors.green : Colors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- SPEC INFO ROW ---
  Widget _buildPdfInfoRow(DarReport report) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        color: const Color(0xFFF5F5F5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoItem('PROJECT NAME:', report.projectName),
          _buildInfoItem(
            'REPORT DATE:',
            DateFormat('MMMM dd, yyyy').format(report.reportDate),
          ),
          _buildInfoItem('PREPARED BY:', report.preparedBy),
          _buildInfoItem('PERIOD SHIFT:', report.reportingPeriod),
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
            style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
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

  // --- WEATHER ROW ---
  Widget _buildPdfWeatherRow(DarReport report) {
    return Table(
      border: TableBorder.all(color: Colors.black12),
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFFFAFAFA)),
          children: [
            _buildTableHeaderCell('Weather Status'),
            _buildTableHeaderCell('Avg Temp (°C)'),
            _buildTableHeaderCell('Wind Velocity'),
            _buildTableHeaderCell('Site / Terrain Condition'),
          ],
        ),
        TableRow(
          children: [
            _buildTableBodyCell(report.weather),
            _buildTableBodyCell('${report.temperature}°C'),
            _buildTableBodyCell(report.windCondition),
            _buildTableBodyCell(report.siteCondition),
          ],
        ),
      ],
    );
  }

  // --- ACCOMPLISHMENTS TABLE ---
  Widget _buildPdfAccomplishmentsTable(List<AccomplishmentItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '1.0 DAILY WORK ACCOMPLISHMENTS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
          ),
        ),
        const SizedBox(height: 8),
        Table(
          border: TableBorder.all(color: Colors.black26),
          columnWidths: const {
            0: FixedColumnWidth(40),
            1: FlexColumnWidth(4),
            2: FlexColumnWidth(2),
            3: FixedColumnWidth(60),
            4: FixedColumnWidth(60),
            5: FlexColumnWidth(3),
          },
          children: [
            TableRow(
              decoration: const BoxDecoration(color: Color(0xFFEEEEEE)),
              children: [
                _buildTableHeaderCell('#'),
                _buildTableHeaderCell('Work Description'),
                _buildTableHeaderCell('Area / Location'),
                _buildTableHeaderCell('Qty'),
                _buildTableHeaderCell('Unit'),
                _buildTableHeaderCell('Remarks / Comments'),
              ],
            ),
            if (items.isEmpty)
              TableRow(
                children: [
                  _buildTableBodyCell('-'),
                  _buildTableBodyCell('No accomplishments recorded.'),
                  _buildTableBodyCell('-'),
                  _buildTableBodyCell('-'),
                  _buildTableBodyCell('-'),
                  _buildTableBodyCell('-'),
                ],
              )
            else
              ...List.generate(items.length, (idx) {
                final item = items[idx];
                return TableRow(
                  children: [
                    _buildTableBodyCell('${idx + 1}'),
                    _buildTableBodyCell(item.workDescription),
                    _buildTableBodyCell(item.areaLocation),
                    _buildTableBodyCell(
                      (item.quantity.isNaN || item.quantity.isInfinite
                              ? 0.0
                              : item.quantity)
                          .toStringAsFixed(1),
                    ),
                    _buildTableBodyCell(item.unit),
                    _buildTableBodyCell(item.remarks),
                  ],
                );
              }),
          ],
        ),
      ],
    );
  }

  // --- RESOURCES COLUMN TABLES (Manpower, Equipment, Materials) ---
  Widget _buildPdfResourcesSection(DarReport report) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Manpower Table
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '2.0 MANPOWER LOGS',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                ),
              ),
              const SizedBox(height: 6),
              Table(
                border: TableBorder.all(color: Colors.black12),
                columnWidths: const {
                  0: FlexColumnWidth(2.5),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                    decoration: const BoxDecoration(color: Color(0xFFFAFAFA)),
                    children: [
                      _buildTableHeaderCell('Personnel Category'),
                      _buildTableHeaderCell('Plan'),
                      _buildTableHeaderCell('Pres'),
                      _buildTableHeaderCell('OT'),
                    ],
                  ),
                  if (report.manpower.isEmpty)
                    TableRow(
                      children: [
                        _buildTableBodyCell('No personnel logs.'),
                        _buildTableBodyCell('-'),
                        _buildTableBodyCell('-'),
                        _buildTableBodyCell('-'),
                      ],
                    )
                  else
                    ...report.manpower.map((m) {
                      return TableRow(
                        children: [
                          _buildTableBodyCell(m.category),
                          _buildTableBodyCell('${m.planned}'),
                          _buildTableBodyCell('${m.present}'),
                          _buildTableBodyCell('${m.overtime}'),
                        ],
                      );
                    }),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),

        // Right Column: Equipment and Materials
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Equipment
              const Text(
                '3.0 EQUIPMENT / MACHINERY LOGS',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                ),
              ),
              const SizedBox(height: 6),
              Table(
                border: TableBorder.all(color: Colors.black12),
                children: [
                  TableRow(
                    decoration: const BoxDecoration(color: Color(0xFFFAFAFA)),
                    children: [
                      _buildTableHeaderCell('Equipment Name'),
                      _buildTableHeaderCell('Qty'),
                      _buildTableHeaderCell('Op Hours'),
                    ],
                  ),
                  if (report.equipment.isEmpty)
                    TableRow(
                      children: [
                        _buildTableBodyCell('No machinery logs.'),
                        _buildTableBodyCell('-'),
                        _buildTableBodyCell('-'),
                      ],
                    )
                  else
                    ...report.equipment.map((e) {
                      return TableRow(
                        children: [
                          _buildTableBodyCell(e.name),
                          _buildTableBodyCell('${e.count} units'),
                          _buildTableBodyCell('${e.hoursUsed} hrs'),
                        ],
                      );
                    }),
                ],
              ),

              const SizedBox(height: 16),

              // Materials
              const Text(
                '4.0 MATERIALS INSTALLED LOGS',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                ),
              ),
              const SizedBox(height: 6),
              Table(
                border: TableBorder.all(color: Colors.black12),
                children: [
                  TableRow(
                    decoration: const BoxDecoration(color: Color(0xFFFAFAFA)),
                    children: [
                      _buildTableHeaderCell('Material Name'),
                      _buildTableHeaderCell('Qty Installed'),
                    ],
                  ),
                  if (report.materials.isEmpty)
                    TableRow(
                      children: [
                        _buildTableBodyCell('No materials installed.'),
                        _buildTableBodyCell('-'),
                      ],
                    )
                  else
                    ...report.materials.map((mat) {
                      return TableRow(
                        children: [
                          _buildTableBodyCell(mat.name),
                          _buildTableBodyCell('${mat.quantity} ${mat.unit}'),
                        ],
                      );
                    }),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- DELAYS ---
  Widget _buildPdfDelaysSection(List<DelayIssue> delays) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '5.0 TECHNICAL DELAYS & HSE ISSUES',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
          ),
        ),
        const SizedBox(height: 8),
        Table(
          border: TableBorder.all(color: Colors.black26),
          columnWidths: const {
            0: FixedColumnWidth(120),
            1: FlexColumnWidth(4),
            2: FixedColumnWidth(80),
          },
          children: [
            TableRow(
              decoration: const BoxDecoration(color: Color(0xFFFAFAFA)),
              children: [
                _buildTableHeaderCell('Delay Category'),
                _buildTableHeaderCell('Issue Description'),
                _buildTableHeaderCell('Impact Time'),
              ],
            ),
            ...delays.map((d) {
              return TableRow(
                children: [
                  _buildTableBodyCell(d.type),
                  _buildTableBodyCell(d.description),
                  _buildTableBodyCell('${d.impactHours} hrs'),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  // --- PHOTOS ---
  Widget _buildPdfPhotosSection(List<DarPhoto> photos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '6.0 OPERATIONS DOCUMENTATION PHOTOS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: photos.map((p) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  color: const Color(0xFFF5F5F5),
                ),
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(
                        Icons.insert_photo_outlined,
                        size: 28,
                        color: Colors.grey,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        color: Colors.black.withOpacity(0.6),
                        child: Text(
                          p.caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // --- SIGNATURES ---
  Widget _buildPdfSignaturesRow(DarReport report) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSignatureField(
          'PREPARED BY (Supervisor/Engineer):',
          report.signedPrepared,
        ),
        _buildSignatureField('CHECKED BY (Lead QA/QC):', report.signedChecked),
        _buildSignatureField(
          'APPROVED BY (Project Manager):',
          report.signedApproved,
        ),
      ],
    );
  }

  Widget _buildSignatureField(String title, String signatureName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 28),
        Container(
          width: 200,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black54)),
          ),
          child: Text(
            signatureName.isEmpty ? 'Pending sign-off' : signatureName,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              fontStyle: signatureName.isEmpty
                  ? FontStyle.normal
                  : FontStyle.italic,
              color: signatureName.isEmpty ? Colors.grey : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  // --- TABLE CELLS ---
  Widget _buildTableHeaderCell(String label) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTableBodyCell(String label) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Text(
        label,
        style: const TextStyle(fontSize: 8, color: Colors.black87),
      ),
    );
  }

  // --- FOOTER ---
  Widget _buildPdfFooter(DarReport report) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'CONFIDENTIAL — FOR INTERNAL MHG PROJECT USE ONLY',
          style: TextStyle(
            fontSize: 7,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Generated on ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())} | Page 1 of 1',
          style: const TextStyle(
            fontSize: 7,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // --- ERROR STATE ---
  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 56, color: Color(0xFFD32F2F)),
          const SizedBox(height: 16),
          Text(
            'Failed to render PDF preview',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          AppButton(text: 'Return to details', onPressed: () => context.pop()),
        ],
      ),
    );
  }

  // --- NATIVE PDF GENERATOR ---
  Future<Uint8List> _generatePdf(DarReport report) async {
    final pdf = pw.Document();

    pw.ImageProvider? logoImage;
    try {
      final ByteData logoData = await rootBundle.load(
        'assets/images/company_logo.png',
      );
      final Uint8List logoBytes = logoData.buffer.asUint8List();
      logoImage = pw.MemoryImage(logoBytes);
    } catch (_) {
      logoImage = null;
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              if (logoImage != null)
                pw.Image(logoImage, height: 60, fit: pw.BoxFit.contain)
              else
                pw.Text(
                  'COMPANY LOGO',
                  style: const pw.TextStyle(
                    fontSize: 16,
                    color: PdfColors.grey500,
                  ),
                ),
              pw.SizedBox(height: 12),
              pw.Divider(
                color: const PdfColor.fromInt(0xFF1B5E20),
                thickness: 1.0,
              ),
              pw.SizedBox(height: 16),
            ],
          );
        },
        build: (pw.Context context) => [
          // Title
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                'DAILY ACCOMPLISHMENT REPORT',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: const PdfColor.fromInt(0xFF1B5E20),
                ),
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    'REPORT NO: ${report.darNumber}',
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    'STATUS: ${report.status.toUpperCase()}',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      color: report.status == 'Approved'
                          ? PdfColors.green
                          : PdfColors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 16),

          // Info
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              color: PdfColors.grey100,
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _pwInfoItem('PROJECT NAME:', report.projectName),
                _pwInfoItem(
                  'REPORT DATE:',
                  DateFormat('MMMM dd, yyyy').format(report.reportDate),
                ),
                _pwInfoItem('PREPARED BY:', report.preparedBy),
                _pwInfoItem('PERIOD SHIFT:', report.reportingPeriod),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // Weather
          pw.TableHelper.fromTextArray(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
            headers: [
              'Weather Status',
              'Avg Temp (°C)',
              'Wind Velocity',
              'Site / Terrain Condition',
            ],
            data: [
              [
                report.weather,
                '${report.temperature}',
                report.windCondition,
                report.siteCondition,
              ],
            ],
          ),
          pw.SizedBox(height: 24),

          // Accomplishments
          pw.Text(
            '1.0 DAILY WORK ACCOMPLISHMENTS',
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              color: const PdfColor.fromInt(0xFF1B5E20),
            ),
          ),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
            headers: [
              '#',
              'Work Description',
              'Area / Location',
              'Qty',
              'Unit',
              'Remarks',
            ],
            data: report.accomplishments.isEmpty
                ? [
                    ['-', 'No accomplishments recorded.', '-', '-', '-', '-'],
                  ]
                : List.generate(report.accomplishments.length, (i) {
                    final acc = report.accomplishments[i];
                    return [
                      '${i + 1}',
                      acc.workDescription,
                      acc.areaLocation,
                      '${acc.quantity}',
                      acc.unit,
                      acc.remarks,
                    ];
                  }),
          ),
          pw.SizedBox(height: 32),

          // Signatures
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _pwSig(
                'PREPARED BY (Supervisor/Engineer):',
                report.signedPrepared,
              ),
              _pwSig('CHECKED BY (Lead QA/QC):', report.signedChecked),
              _pwSig('APPROVED BY (Project Manager):', report.signedApproved),
            ],
          ),
        ],
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 10.0),
            child: pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _pwInfoItem(String label, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 8,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.grey700,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          value,
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
      ],
    );
  }

  pw.Widget _pwSig(String title, String name) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 8,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.grey700,
          ),
        ),
        pw.SizedBox(height: 28),
        pw.Container(
          width: 150,
          decoration: const pw.BoxDecoration(
            border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey700)),
          ),
          child: pw.Text(
            name.isEmpty ? 'Pending sign-off' : name,
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              color: name.isEmpty ? PdfColors.grey500 : PdfColors.black,
            ),
          ),
        ),
      ],
    );
  }
}
