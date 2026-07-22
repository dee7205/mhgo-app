import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/materials_entities.dart';
import '../providers/materials_provider.dart';

class MaterialFormDialog extends ConsumerStatefulWidget {
  final MaterialEntity? existingMaterial;

  const MaterialFormDialog({super.key, this.existingMaterial});

  @override
  ConsumerState<MaterialFormDialog> createState() => _MaterialFormDialogState();
}

class _MaterialFormDialogState extends ConsumerState<MaterialFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _currentStockController;
  late TextEditingController _minimumStockController;
  late TextEditingController _supplierController;
  late TextEditingController _storageLocationController;
  late TextEditingController _remarksController;

  String _selectedCategory = 'Solar Modules';
  String _selectedUnit = 'pcs';

  final List<String> _categories = [
    'Solar Modules',
    'Inverters',
    'Mounting Structures',
    'DC/AC Cabling',
    'Transformers',
    'BOS',
    'Misc',
  ];

  final List<String> _units = ['pcs', 'meters', 'sets', 'rolls', 'kg'];

  @override
  void initState() {
    super.initState();
    final m = widget.existingMaterial;
    _nameController = TextEditingController(text: m?.name ?? '');
    _currentStockController = TextEditingController(
      text: m != null ? m.currentStock.toString() : '',
    );
    _minimumStockController = TextEditingController(
      text: m != null ? m.minimumStock.toString() : '',
    );
    _supplierController = TextEditingController(text: m?.supplier ?? '');
    _storageLocationController = TextEditingController(
      text: m?.storageLocation ?? '',
    );
    _remarksController = TextEditingController(text: m?.remarks ?? '');

    if (m != null) {
      if (_categories.contains(m.category)) _selectedCategory = m.category;
      if (_units.contains(m.unit)) _selectedUnit = m.unit;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _currentStockController.dispose();
    _minimumStockController.dispose();
    _supplierController.dispose();
    _storageLocationController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final currentStock = double.tryParse(_currentStockController.text) ?? 0.0;
    final minimumStock = double.tryParse(_minimumStockController.text) ?? 0.0;

    String stockStatus = 'In Stock';
    if (currentStock == 0) {
      stockStatus = 'Out of Stock';
    } else if (currentStock <= minimumStock) {
      stockStatus = 'Low Stock';
    }

    final material = MaterialEntity(
      uuid: widget.existingMaterial?.uuid ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      category: _selectedCategory,
      unit: _selectedUnit,
      currentStock: currentStock,
      minimumStock: minimumStock,
      supplier: _supplierController.text.trim(),
      storageLocation: _storageLocationController.text.trim(),
      remarks: _remarksController.text.trim(),
      stockStatus: stockStatus,
    );

    ref.read(materialsNotifierProvider.notifier).saveMaterial(material);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: MediaQuery.sizeOf(context).width),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.existingMaterial == null
                        ? 'Add Material'
                        : 'Edit Material',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Material Name',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    value: _categories.contains(_selectedCategory)
                        ? _selectedCategory
                        : null,
                    items: _categories
                        .toSet()
                        .map(
                          (c) => DropdownMenuItem<String>(
                            value: c,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    c,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCategory = val);
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Unit',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    value: _units.contains(_selectedUnit)
                        ? _selectedUnit
                        : null,
                    items: _units
                        .toSet()
                        .map(
                          (u) => DropdownMenuItem<String>(
                            value: u,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    u,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedUnit = val);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _currentStockController,
                    decoration: const InputDecoration(
                      labelText: 'Current Stock',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _minimumStockController,
                    decoration: const InputDecoration(
                      labelText: 'Minimum Stock',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _supplierController,
                    decoration: const InputDecoration(
                      labelText: 'Supplier',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _storageLocationController,
                    decoration: const InputDecoration(
                      labelText: 'Storage Location',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _remarksController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Remarks',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(onPressed: _save, child: const Text('Save')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
