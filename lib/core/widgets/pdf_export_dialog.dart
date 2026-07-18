import 'package:flutter/material.dart';

class PdfExportOptions {
  final bool includeSignatures;
  final String engineerName;
  final String engineerTitle;
  final String clientName;
  final String clientTitle;

  const PdfExportOptions({
    this.includeSignatures = true,
    this.engineerName = '',
    this.engineerTitle = 'Field Engineer',
    this.clientName = '',
    this.clientTitle = 'Client Acknowledgment',
  });
}

class PdfExportDialog extends StatefulWidget {
  const PdfExportDialog({super.key});

  @override
  State<PdfExportDialog> createState() => _PdfExportDialogState();
}

class _PdfExportDialogState extends State<PdfExportDialog> {
  bool _includeSignatures = true;
  bool _isPopping = false;
  final _engineerNameCtrl = TextEditingController(text: 'ENGR. MARY HEIKE D. GARCIA');
  final _engineerTitleCtrl = TextEditingController(text: 'Project Engineer');
  final _clientNameCtrl = TextEditingController();
  final _clientTitleCtrl = TextEditingController(text: 'Client Acknowledgment');

  @override
  void dispose() {
    _engineerNameCtrl.dispose();
    _engineerTitleCtrl.dispose();
    _clientNameCtrl.dispose();
    _clientTitleCtrl.dispose();
    super.dispose();
  }

  void _safePop([PdfExportOptions? options]) {
    if (_isPopping) return;
    _isPopping = true;
    if (context.mounted) {
      Navigator.of(context).pop(options);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Report Settings'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Include Signatures and Authorization Block', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              value: _includeSignatures,
              onChanged: (val) {
                setState(() => _includeSignatures = val);
              },
              contentPadding: EdgeInsets.zero,
            ),
            if (_includeSignatures) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _engineerNameCtrl,
                decoration: const InputDecoration(labelText: 'Engineer Name', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _engineerTitleCtrl,
                decoration: const InputDecoration(labelText: 'Engineer Title', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              TextField(
                controller: _clientNameCtrl,
                decoration: const InputDecoration(labelText: 'Client Name (Optional)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _clientTitleCtrl,
                decoration: const InputDecoration(labelText: 'Client Title', border: OutlineInputBorder()),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => _safePop(null),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            _safePop(PdfExportOptions(
              includeSignatures: _includeSignatures,
              engineerName: _engineerNameCtrl.text.trim(),
              engineerTitle: _engineerTitleCtrl.text.trim(),
              clientName: _clientNameCtrl.text.trim(),
              clientTitle: _clientTitleCtrl.text.trim(),
            ));
          },
          child: const Text('Generate Report'),
        ),
      ],
    );
  }
}

Future<PdfExportOptions?> showPdfExportDialog(BuildContext context) {
  return showDialog<PdfExportOptions>(
    context: context,
    builder: (context) => const PdfExportDialog(),
  );
}
