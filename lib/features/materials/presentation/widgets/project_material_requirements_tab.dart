import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/materials_entities.dart';
import '../providers/materials_provider.dart';

class ProjectMaterialRequirementsTab extends ConsumerStatefulWidget {
  final String projectUuid;
  final String projectType;

  const ProjectMaterialRequirementsTab({
    super.key,
    required this.projectUuid,
    required this.projectType,
  });

  @override
  ConsumerState<ProjectMaterialRequirementsTab> createState() => _ProjectMaterialRequirementsTabState();
}

class _ProjectMaterialRequirementsTabState extends ConsumerState<ProjectMaterialRequirementsTab> {
  bool _isSeeding = false;

  Future<void> _seedDefaults() async {
    setState(() => _isSeeding = true);
    final isOngrid = widget.projectType.toLowerCase().contains('on-grid') || widget.projectType.toLowerCase().contains('ongrid');

    final hybridMaterials = [
      ('JINKO 640W', 'pcs', 8.0, 49600.0),
      ('PYLONTECH FIDUS 5.12KWH', 'pcs', 1.0, 42000.0),
      ('S6-EH1P5K-L-PLUS', 'pcs', 1.0, 41000.0),
      ('Twisted Wire #18', 'pcs', 1.0, 3700.0),
      ('PV Cable Single Core 2-4mmsq Black', 'roll', 60.0, 3900.0),
      ('PV Cable Single Core 2-4mmsq Red', 'roll', 60.0, 3900.0),
      ('35mm2 Battery Cable Black', 'meters', 4.0, 2400.0),
      ('35mm2 Battery Cable Red', 'meters', 4.0, 2400.0),
      ('Terminal lugs', 'pcs', 28.0, 2520.0),
      ('5.5mm2 THHN Supply Wire Black', 'meters', 60.0, 4800.0),
      ('3.5mm2 THHN Ground', 'meters', 30.0, 2400.0),
      ('5.5 mm2 THHN Black', 'meters', 60.0, 4800.0),
      ('HDPE 25mm Flexible Conduit', 'meters', 60.0, 6000.0),
      ('Plastic Box', 'pcs', 6.0, 6000.0),
      ('2.4 Railing', 'length', 9.0, 4500.0),
      ('Lfoot Long 17cm', 'pcs', 25.0, 8750.0),
    ];

    final ongridMaterials = [
      ('Jinko 640W', 'pcs', 16.0, 6600.0),
      ('S6-EH1P10K-L-PLUS (21A)', 'pcs', 1.0, 58000.0),
      ('PV Cable Single Core 2-4mmsq Black', 'meters', 90.0, 65.0),
      ('PV Cable Single Core 2-4mmsq Red', 'meters', 90.0, 65.0),
      ('Terminal lugs', 'pcs', 28.0, 90.0),
      ('14 mm2 THHN Supply Wire Black', 'meters', 90.0, 300.0),
      ('8 mm2 THHN Ground', 'meters', 45.0, 150.0),
      ('5.5 mm2 THHN Black', 'meters', 90.0, 80.0),
      ('5.5 mm2 THW Green', 'meters', 45.0, 80.0),
      ('Metal Clamp 1"', 'pcs', 25.0, 25.0),
      ('HDPE 25mm Flexible Conduit', 'meters', 90.0, 100.0),
      ('Plastic Box', 'pcs', 6.0, 1000.0),
      ('2.4 Railing', 'length', 18.0, 500.0),
      ('Lfoot Long 17cm', 'pcs', 80.0, 350.0),
      ('AC 63A MCB 2POLE', 'pcs', 3.0, 4000.0),
      ('19 Way Combiner Box', 'pcs', 2.0, 1500.0),
    ];

    final defaultMaterials = isOngrid ? ongridMaterials : hybridMaterials;

    for (final item in defaultMaterials) {
      final req = ProjectMaterialRequirementEntity(
        uuid: const Uuid().v4(),
        projectUuid: widget.projectUuid,
        materialUuid: item.$1,
        requiredQuantity: item.$3,
        allocatedQuantity: 0.0,
        unit: item.$2,
        estimatedCost: item.$4,
      );
      await ref.read(materialsNotifierProvider.notifier).saveRequirement(req);
    }
    setState(() => _isSeeding = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final requirementsAsync = ref.watch(projectMaterialRequirementsProvider(widget.projectUuid));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Material Requirements', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.refresh, color: Colors.red),
                    label: const Text('Reset All to 0', style: TextStyle(color: Colors.red)),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Reset BOM?'),
                          content: const Text('This will set Qty, Allocated, and Cost to 0 for ALL projects.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Reset', style: TextStyle(color: Colors.red))),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await ref.read(materialsRepositoryProvider).forceResetAllRequirementsToZero();
                        ref.invalidate(projectMaterialRequirementsProvider);
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  AppButton(
                    text: 'Add Material',
                    icon: Icons.add,
                    width: 150,
                    onPressed: () => _showAddRequirementDialog(context),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: requirementsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
            data: (requirements) {
              if (requirements.isEmpty) {
                if (_isSeeding) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('No material requirements assigned yet.', style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 16),
                      AppButton(
                        text: 'Load Default BOM Template',
                        icon: Icons.download,
                        width: 250,
                        variant: AppButtonVariant.secondary,
                        onPressed: _seedDefaults,
                      ),
                    ],
                  ),
                );
              }
              final grandTotal = requirements.fold<double>(0, (sum, req) => sum + (req.estimatedCost ?? 0));

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Grand Total', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        Text('₱${grandTotal.toStringAsFixed(2)}', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onPrimaryContainer)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: requirements.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final requirement = requirements[index];
                      return AppCard(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.category, color: Colors.grey),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    spacing: 8,
                                    children: [
                                      Text(requirement.materialUuid, style: const TextStyle(fontWeight: FontWeight.bold)),
                                      _buildStatusChip(requirement.status),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Wrap(
                                    spacing: 12,
                                    children: [
                                      Text('Required: ${requirement.requiredQuantity} ${requirement.unit}'),
                                      Text('Allocated: ${requirement.allocatedQuantity} ${requirement.unit}'),
                                      if (requirement.estimatedCost != null) ...[
                                        Text(
                                          'Total: ₱${requirement.estimatedCost!.toStringAsFixed(2)}', 
                                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showAddRequirementDialog(context, existingRequirement: requirement),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Approved': color = Colors.green; break;
      case 'Procured': color = Colors.blue; break;
      case 'Delivered': color = Colors.purple; break;
      default: color = Colors.orange;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(status, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  void _showAddRequirementDialog(BuildContext context, {ProjectMaterialRequirementEntity? existingRequirement}) {
    showDialog(
      context: context,
      builder: (context) => _AddRequirementDialog(
        projectUuid: widget.projectUuid,
        existingRequirement: existingRequirement,
      ),
    );
  }
}

class _AddRequirementDialog extends ConsumerStatefulWidget {
  final String projectUuid;
  final ProjectMaterialRequirementEntity? existingRequirement;

  const _AddRequirementDialog({
    required this.projectUuid,
    this.existingRequirement,
  });

  @override
  ConsumerState<_AddRequirementDialog> createState() => _AddRequirementDialogState();
}

class _AddRequirementDialogState extends ConsumerState<_AddRequirementDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _unitController = TextEditingController();
  TextEditingController _requiredController = TextEditingController();
  TextEditingController _allocatedController = TextEditingController();
  TextEditingController _totalCostController = TextEditingController();
  String _status = 'Pending';

  final FocusNode _qtyFocus = FocusNode();
  final FocusNode _allocFocus = FocusNode();
  final FocusNode _totalFocus = FocusNode();

  void _setupZeroClear(TextEditingController controller, FocusNode node, {bool isCurrency = false}) {
    node.addListener(() {
      if (node.hasFocus) {
        if (controller.text == '0' || controller.text == '0.0' || controller.text == '0.00') {
          controller.clear();
        }
      } else {
        if (controller.text.trim().isEmpty) {
          controller.text = isCurrency ? '0.00' : '0';
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _status = widget.existingRequirement?.status ?? 'Pending';
    _nameController.text = widget.existingRequirement?.materialUuid ?? '';
    _unitController.text = widget.existingRequirement?.unit ?? '';
    _requiredController.text = widget.existingRequirement?.requiredQuantity.toString() ?? '0';
    _allocatedController.text = widget.existingRequirement?.allocatedQuantity.toString() ?? '0';
    final cost = widget.existingRequirement?.estimatedCost;
    if (cost != null) {
      _totalCostController.text = cost.toStringAsFixed(2);
    } else {
      _totalCostController.text = '0.00';
    }

    _setupZeroClear(_requiredController, _qtyFocus);
    _setupZeroClear(_allocatedController, _allocFocus);
    _setupZeroClear(_totalCostController, _totalFocus, isCurrency: true);
  }

  @override
  void dispose() {
    _qtyFocus.dispose();
    _allocFocus.dispose();
    _totalFocus.dispose();
    _nameController.dispose();
    _unitController.dispose();
    _requiredController.dispose();
    _allocatedController.dispose();
    _totalCostController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existingRequirement == null ? 'Add Material Requirement' : 'Edit Material Requirement'),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                  items: ['Pending', 'Approved', 'Procured', 'Delivered']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s, overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _status = val);
                  },
                  isExpanded: true,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Material Name (BOM item)', border: OutlineInputBorder()),
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _unitController,
                  decoration: const InputDecoration(labelText: 'Unit (e.g., pcs, meters)', border: OutlineInputBorder()),
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _requiredController,
                  focusNode: _qtyFocus,
                  decoration: const InputDecoration(labelText: 'Required Quantity', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Required';
                    if (double.tryParse(val) == null) return 'Must be a number';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _allocatedController,
                  focusNode: _allocFocus,
                  decoration: const InputDecoration(labelText: 'Allocated/Delivered Quantity', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Required';
                    if (double.tryParse(val) == null) return 'Must be a number';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _totalCostController,
                  focusNode: _totalFocus,
                  decoration: const InputDecoration(labelText: 'Total Cost (₱)', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val != null && val.isNotEmpty) {
                      if (double.tryParse(val) == null) return 'Must be a number';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        if (widget.existingRequirement != null)
          TextButton(
            onPressed: () {
              ref.read(materialsNotifierProvider.notifier).deleteRequirement(widget.existingRequirement!.uuid, widget.projectUuid);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final req = ProjectMaterialRequirementEntity(
                uuid: widget.existingRequirement?.uuid ?? const Uuid().v4(),
                projectUuid: widget.projectUuid,
                materialUuid: _nameController.text.trim(),
                requiredQuantity: double.parse(_requiredController.text),
                allocatedQuantity: double.parse(_allocatedController.text),
                unit: _unitController.text.trim(),
                estimatedCost: _totalCostController.text.isNotEmpty ? double.parse(_totalCostController.text) : null,
                status: _status,
              );
              ref.read(materialsNotifierProvider.notifier).saveRequirement(req);
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
