import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mhgo/core/theme/app_theme.dart';
import 'package:mhgo/features/inspections/domain/entities/inspection_entities.dart';
import 'package:mhgo/features/inspections/presentation/providers/inspections_provider.dart';

class InspectionPdfPreviewView extends ConsumerWidget {
  final String id;

  const InspectionPdfPreviewView({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final detailsAsync = ref.watch(inspectionDetailsProvider(id));

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: AppBar(
        title: Text(
          'Inspection Report PDF Preview',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
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
          data: (report) {
            if (report == null) {
              return const Center(child: Text('Inspection report not found.'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
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
                          color: Colors.white, // Always white background for printable design
                          child: DefaultTextStyle(
                            style: const TextStyle(color: Colors.black87, fontFamily: 'Courier'),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 1. Header
                                _buildHeader(report),
                                const SizedBox(height: 12),
                                const Divider(color: Colors.black54, thickness: 1.5),
                                const SizedBox(height: 12),

                                // 2. Metadata Info Grid
                                _buildMetadataGrid(report),
                                const SizedBox(height: 20),

                                // 3. Checklist Table
                                _buildChecklistSection(report.checklist),
                                const SizedBox(height: 24),

                                // 4. Non-Conformance Section
                                if (report.nonConformance.isNotEmpty) ...[
                                  _buildNcrSection(report.nonConformance),
                                  const SizedBox(height: 24),
                                ],

                                // 5. Photos Section
                                if (report.photos.isNotEmpty) ...[
                                  _buildPhotosSection(report.photos),
                                  const SizedBox(height: 32),
                                ],

                                const SizedBox(height: 40),

                                // 6. Signatures Row
                                _buildSignaturesRow(report),
                                const SizedBox(height: 32),

                                // 7. Footer
                                const Divider(color: Colors.black26),
                                const SizedBox(height: 8),
                                _buildFooter(report),
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

  // --- HEADER ---
  Widget _buildHeader(InspectionReport report) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'MHG ENERGY EPC CORP',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
            const SizedBox(height: 2),
            Text(
              'Built for MHG.',
              style: TextStyle(fontSize: 10, color: Colors.blue.shade800, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'QUALITY CONTROL REPORT',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              'STATUS: ${report.status.toUpperCase()}',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: report.status.toLowerCase() == 'approved'
                    ? Colors.green.shade800
                    : (report.status.toLowerCase() == 'rejected'
                        ? Colors.red.shade800
                        : Colors.orange.shade800),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- METADATA GRID ---
  Widget _buildMetadataGrid(InspectionReport report) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        color: const Color(0xFFF5F5F5),
      ),
      child: Row(
        children: [
          _buildInfoItem('INSPECTION ID:', report.inspectionId),
          _buildInfoItem('PROJECT:', report.projectName),
          _buildInfoItem('DATE/TIME:', '${DateFormat('yyyy-MM-dd').format(report.inspectionDate)} ${report.time}'),
          _buildInfoItem('INSPECTOR:', report.inspectorName),
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
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // --- CHECKLIST TABLE ---
  Widget _buildChecklistSection(List<ChecklistItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '1. INSPECTION CHECKLIST RESULTS',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Table(
          border: TableBorder.all(color: Colors.black26),
          columnWidths: const {
            0: FlexColumnWidth(4),
            1: FixedColumnWidth(60),
            2: FlexColumnWidth(3),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              decoration: const BoxDecoration(color: Color(0xFFEBEBEB)),
              children: [
                _tableHeaderCell('Checklist Item / Specification'),
                _tableHeaderCell('Result', center: true),
                _tableHeaderCell('Remarks / Comments'),
              ],
            ),
            ...items.map((item) => TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                      child: Text(item.name, style: const TextStyle(fontSize: 9)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
                      child: Text(
                        item.result,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: item.result.toLowerCase() == 'pass'
                              ? Colors.green.shade800
                              : (item.result.toLowerCase() == 'fail' ? Colors.red.shade800 : Colors.grey),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                      child: Text(
                        item.remarks.isEmpty ? 'Conforms to specs' : item.remarks,
                        style: const TextStyle(fontSize: 8, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ],
    );
  }

  // --- NCR SECTION ---
  Widget _buildNcrSection(List<NonConformance> ncrList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '2. NON-CONFORMANCE & CORRECTIVE ACTIONS SUMMARY',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFD32F2F)),
        ),
        const SizedBox(height: 8),
        Table(
          border: TableBorder.all(color: Colors.black26),
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FixedColumnWidth(60),
            2: FlexColumnWidth(3),
            3: FixedColumnWidth(80),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              decoration: const BoxDecoration(color: Color(0xFFFDEDEC)),
              children: [
                _tableHeaderCell('Defect Description'),
                _tableHeaderCell('Severity', center: true),
                _tableHeaderCell('Recommended Action / Owner'),
                _tableHeaderCell('Target Date', center: true),
              ],
            ),
            ...ncrList.map((ncr) => TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                      child: Text(ncr.description, style: const TextStyle(fontSize: 8)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
                      child: Text(
                        ncr.severity,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: ncr.severity.toLowerCase() == 'high' ? Colors.red.shade800 : Colors.orange.shade800,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                      child: Text(
                        '${ncr.recommendedAction} \n[Owner: ${ncr.responsiblePerson}]',
                        style: const TextStyle(fontSize: 8),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
                      child: Text(
                        ncr.targetCompletionDate != null
                            ? DateFormat('yyyy-MM-dd').format(ncr.targetCompletionDate!)
                            : 'N/A',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 8),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ],
    );
  }

  // --- PHOTOS ---
  Widget _buildPhotosSection(List<InspectionPhoto> photos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '3. SITE ATTACHMENTS & VISUAL EVIDENCE',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemCount: photos.length,
          itemBuilder: (context, index) {
            final photo = photos[index];
            return Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.black26)),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      color: const Color(0xFFF0F0F0),
                      child: const Center(
                        child: Icon(Icons.image, size: 24, color: Colors.grey),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(4),
                    color: const Color(0xFFFAFAFA),
                    child: Text(
                      photo.caption.isEmpty ? 'Photo evidence #${index + 1}' : photo.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 7),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // --- SIGNATURES ---
  Widget _buildSignaturesRow(InspectionReport report) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _signatureBlock('INSPECTED BY (Inspector):', report.signatures.inspector, 'MHG QA/QC Lead'),
        _signatureBlock('WITNESSED BY (Contractor):', report.signatures.contractor, 'EPC Site Representative'),
        _signatureBlock('APPROVED BY (QA/QC Engr):', report.signatures.qaqc, 'MHG Quality Manager'),
      ],
    );
  }

  Widget _signatureBlock(String label, String signature, String role) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          Container(
            height: 32,
            width: 140,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black38)),
            ),
            child: signature.isNotEmpty
                ? Text(
                    signature,
                    style: const TextStyle(
                      fontFamily: 'Courier',
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.blueGrey,
                    ),
                  )
                : const Text(
                    'UNSIGNED',
                    style: TextStyle(color: Colors.red, fontSize: 8, fontWeight: FontWeight.bold),
                  ),
          ),
          const SizedBox(height: 4),
          Text(
            role,
            style: const TextStyle(fontSize: 7, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // --- FOOTER ---
  Widget _buildFooter(InspectionReport report) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Document ID: ${report.id.toUpperCase()}',
          style: const TextStyle(fontSize: 7, color: Colors.black45),
        ),
        Text(
          'Date Printed: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}',
          style: const TextStyle(fontSize: 7, color: Colors.black45),
        ),
        const Text(
          'Page 1 of 1',
          style: TextStyle(fontSize: 7, color: Colors.black45),
        ),
      ],
    );
  }

  Widget _tableHeaderCell(String text, {bool center = false}) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Text(
        text,
        textAlign: center ? TextAlign.center : TextAlign.left,
        style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }
}
