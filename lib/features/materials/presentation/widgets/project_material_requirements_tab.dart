import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/materials_entities.dart';
import '../providers/materials_provider.dart';

const List<String> bomSections = [
  'DC Wire Materials',
  'AC Wire Materials',
  'DC Conduits and Materials',
  'Solar Mounting Materials',
  'Protection Devices and Enclosure',
  'Net Metering (Optional)',
];

const Map<String, List<(String, String, double)>> onGridBom = {
  'DC Wire Materials': [
    ('PV Cable Single Core 2-4mmsq Black', 'roll/100m', 90.0),
    ('PV Cable Single Core 2-4mmsq Red', 'roll/100m', 90.0),
    ('35mm² Battery Cable Black', 'meters', 0.0),
    ('35mm² Battery Cable Red', 'meters', 0.0),
    ('Terminal Lugs', 'pcs', 28.0),
    ('Mechanical Lugs', 'pcs', 5.0),
  ],
  'AC Wire Materials': [
    ('14 mm² THHN Supply Wire Black', 'meters', 90.0),
    ('8 mm² THHN Ground', 'meters', 45.0),
    ('5.5 mm² THHN Black', 'meters', 90.0),
    ('5.5 mm² THW Green', 'meters', 45.0),
    ('2 mm² THHN Black', 'meters', 30.0),
  ],
  'DC Conduits and Materials': [
    ('Metal Clamp 1"', 'pcs', 25.0),
    ('Plastic Cable Tray 100×50', 'pcs', 10.0),
    ('Pull Box 4×6×6', 'pcs', 3.0),
    ('Tex Screw 2"', 'pcs', 60.0),
    ('HDPE 25mm Flexible Conduit', 'meters', 90.0),
    ('Moldflex 1"', 'meters', 40.0),
    ('Plastic Box', 'pcs', 6.0),
    ('Cable Tie', 'pack', 1.0),
    ('25mm Liquid Tight Connector', 'pcs', 10.0),
    ('Electrical Tape Red', 'pcs', 2.0),
    ('Electrical Tape Black', 'pcs', 2.0),
  ],
  'Solar Mounting Materials': [
    ('2.4 Railing', 'length', 18.0),
    ('MC4 Connector', 'pairs', 8.0),
    ('Rail Splice Connector', 'pcs', 15.0),
    ('Lfoot Long 17cm', 'pcs', 80.0),
    ('End Clamp', 'pcs', 60.0),
    ('Mid Clamp', 'pcs', 50.0),
    ('Expansion Bolt', 'pcs', 12.0),
  ],
  'Protection Devices and Enclosure': [
    ('AC 63A MCB 2 Pole', 'pcs', 3.0),
    ('AC 275V SPD 2 Pole', 'pcs', 2.0),
    ('160A DC MCCB', 'pc', 1.0),
    ('20A DC MCB Breaker', 'pcs', 2.0),
    ('20A AC MCB Breaker', 'pcs', 3.0),
    ('32A AC MCB Breaker', 'pcs', 3.0),
    ('Shrinkable Hose', 'meters', 5.0),
    ('1000V DC SPD', 'pcs', 3.0),
    ('19 Way Combiner Box', 'pcs', 2.0),
    ('ATS 2P YCQ1B-63A', 'pc', 1.0),
    ('Grounding Rod & Clamp', 'pc', 1.0),
    ('Vulcaseal 1/4', 'pcs', 2.0),
    ('NEMA 3R Enclosure', 'pc', 1.0),
  ],
  'Net Metering (Optional)': [
    ('IMC PIPE 1-1/2"', 'length', 0.0),
    ('IMC Elbow 1-1/2"', 'pcs', 0.0),
    ('1-1/2" Metal Clamp', 'pcs', 0.0),
    ('LB Conduit', 'pcs', 0.0),
  ],
};

const Map<String, List<(String, String, double)>> hybridBom = {
  'DC Wire Materials': [
    ('PV Cable Single Core 2-4mmsq Black', 'roll/100m', 60.0),
    ('PV Cable Single Core 2-4mmsq Red', 'roll/100m', 60.0),
    ('35mm² Battery Cable Black', 'meters', 4.0),
    ('35mm² Battery Cable Red', 'meters', 4.0),
    ('Terminal Lugs', 'pcs', 28.0),
    ('Mechanical Lugs', 'pcs', 5.0),
  ],
  'AC Wire Materials': [
    ('5.5mm² THHN Supply Wire Black', 'meters', 60.0),
    ('3.5mm² THHN Ground', 'meters', 30.0),
    ('5.5mm² THHN Black', 'meters', 60.0),
    ('3.5mm² THW Green', 'meters', 30.0),
    ('2mm² THHN Black', 'meters', 30.0),
  ],
  'DC Conduits and Materials': [
    ('Metal Clamp 1"', 'pcs', 25.0),
    ('Plastic Cable Tray 100×50', 'pcs', 10.0),
    ('Pull Box 4×6×6', 'pcs', 3.0),
    ('Tex Screw 2"', 'pcs', 50.0),
    ('HDPE 25mm Flexible Conduit', 'meters', 60.0),
    ('Moldflex 1"', 'meters', 40.0),
    ('Plastic Box', 'pcs', 6.0),
    ('Cable Tie', 'pack', 1.0),
    ('25mm Liquid Tight Connector', 'pcs', 10.0),
    ('Electrical Tape Red', 'pcs', 2.0),
    ('Electrical Tape Black', 'pcs', 2.0),
  ],
  'Solar Mounting Materials': [
    ('2.4 Railing', 'lengths', 9.0),
    ('MC4 Connector', 'pairs', 4.0),
    ('Rail Splice Connector', 'pcs', 5.0),
    ('Lfoot Long 17cm', 'pcs', 25.0),
    ('End Clamp', 'pcs', 15.0),
    ('Mid Clamp', 'pcs', 20.0),
    ('Expansion Bolt', 'pcs', 12.0),
  ],
  'Protection Devices and Enclosure': [
    ('AC 32A MCB 2 Pole', 'pcs', 3.0),
    ('AC 275V SPD 2 Pole', 'pcs', 2.0),
    ('160A DC MCCB', 'pc', 1.0),
    ('20A DC MCB Breaker', 'pcs', 2.0),
    ('20A AC MCB Breaker', 'pcs', 3.0),
    ('32A AC MCB Breaker', 'pcs', 3.0),
    ('Shrinkable Hose', 'meters', 5.0),
    ('1000V DC SPD', 'pcs', 3.0),
    ('19 Way Combiner Box', 'pcs', 2.0),
    ('ATS 2P YCQ1B-63A', 'pc', 1.0),
    ('Grounding Rod & Clamp', 'pc', 1.0),
    ('Vulcaseal 1/4', 'pcs', 2.0),
    ('NEMA 3R Enclosure', 'pc', 1.0),
  ],
  'Net Metering (Optional)': [
    ('IMC PIPE 1-1/2"', 'length', 0.0),
    ('IMC Elbow 1-1/2"', 'pcs', 0.0),
    ('1-1/2" Metal Clamp', 'pcs', 0.0),
    ('LB Conduit', 'pcs', 0.0),
  ],
};

class ProjectMaterialRequirementsTab extends ConsumerStatefulWidget {
  final String projectUuid;
  final String projectType;

  const ProjectMaterialRequirementsTab({
    super.key,
    required this.projectUuid,
    required this.projectType,
  });

  @override
  ConsumerState<ProjectMaterialRequirementsTab> createState() =>
      _ProjectMaterialRequirementsTabState();
}

class _ProjectMaterialRequirementsTabState
    extends ConsumerState<ProjectMaterialRequirementsTab> {
  bool _isSeeding = false;

  bool get isOngrid =>
      widget.projectType.toLowerCase().contains('on-grid') ||
      widget.projectType.toLowerCase().contains('ongrid');

  Future<void> _seedDefaults() async {
    setState(() => _isSeeding = true);

    final defaultBom = isOngrid ? onGridBom : hybridBom;

    final existingReqs = await ref
        .read(materialsRepositoryProvider)
        .getRequirementsForProject(widget.projectUuid);

    // Gather all valid material names for the current project type
    final validNames = <String>{};
    for (final items in defaultBom.values) {
      for (final item in items) {
        validNames.add(item.$1);
      }
    }

    // Delete existing requirements that do NOT belong to the current template
    final notifier = ref.read(materialsNotifierProvider.notifier);
    for (final req in existingReqs) {
      if (!validNames.contains(req.materialUuid)) {
        await notifier.deleteRequirement(req.uuid, widget.projectUuid);
      }
    }

    final existingNames = existingReqs.map((e) => e.materialUuid).toSet();

    for (final section in bomSections) {
      final items = defaultBom[section] ?? [];
      for (final item in items) {
        if (!existingNames.contains(item.$1)) {
          final req = ProjectMaterialRequirementEntity(
            uuid: const Uuid().v4(),
            projectUuid: widget.projectUuid,
            materialUuid: item.$1,
            requiredQuantity: item.$3,
            allocatedQuantity: 0.0,
            unit: item.$2,
            status: 'Pending',
          );
          await notifier.saveRequirement(req);
        }
      }
    }

    // Also invalidate the cache so UI updates
    ref.invalidate(projectMaterialRequirementsProvider(widget.projectUuid));
    setState(() => _isSeeding = false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndSeed();
    });
  }

  Future<void> _checkAndSeed() async {
    await _seedDefaults();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final requirementsAsync = ref.watch(
      projectMaterialRequirementsProvider(widget.projectUuid),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Material Requirements',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              TextButton.icon(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.centerLeft,
                ),
                icon: const Icon(Icons.refresh, color: Colors.red, size: 18),
                label: const Text(
                  'Reset All to 0',
                  style: TextStyle(color: Colors.red, fontSize: 13),
                ),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Reset BOM?'),
                      content: const Text(
                        'This will set Qty and Allocated to 0 for ALL projects.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text(
                            'Reset',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await ref
                        .read(materialsRepositoryProvider)
                        .forceResetAllRequirementsToZero();
                    ref.invalidate(projectMaterialRequirementsProvider);
                  }
                },
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
                      Text(
                        'No material requirements assigned.',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      AppButton(
                        text: 'Load BOM Template',
                        icon: Icons.download,
                        width: 250,
                        variant: AppButtonVariant.secondary,
                        onPressed: _seedDefaults,
                      ),
                    ],
                  ),
                );
              }

              // Group requirements by section
              final Map<String, List<ProjectMaterialRequirementEntity>>
              groupedReqs = {};
              final defaultBom = isOngrid ? onGridBom : hybridBom;

              for (final req in requirements) {
                String foundSection = 'Other Materials';
                for (final section in bomSections) {
                  if (defaultBom[section]?.any(
                        (item) => item.$1 == req.materialUuid,
                      ) ??
                      false) {
                    foundSection = section;
                    break;
                  }
                }
                groupedReqs.putIfAbsent(foundSection, () => []).add(req);
              }

              return ListView.builder(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 32.0,
                ),
                itemCount:
                    bomSections.length +
                    (groupedReqs.containsKey('Other Materials') ? 1 : 0),
                itemBuilder: (context, index) {
                  final sectionName = index < bomSections.length
                      ? bomSections[index]
                      : 'Other Materials';

                  final sectionReqs = groupedReqs[sectionName] ?? [];
                  if (sectionReqs.isEmpty) return const SizedBox.shrink();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        sectionName.toUpperCase(),
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      AppCard(
                        padding: EdgeInsets.zero,
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: sectionReqs.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (ctx, idx) {
                            final req = sectionReqs[idx];
                            return _buildMaterialRow(context, req);
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMaterialRow(
    BuildContext context,
    ProjectMaterialRequirementEntity req,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  req.customName ?? req.materialUuid,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Qty: ${req.requiredQuantity} ${req.unit}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white24,
                      ),
                    ),
                    _buildStatusChip(req.status),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.blue),
            onPressed: () => _showEditRequirementDialog(context, req),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Requested':
        color = Colors.orange;
        break;
      case 'Ordered':
        color = Colors.blue;
        break;
      case 'Delivered':
        color = Colors.purple;
        break;
      case 'Installed':
        color = Colors.green;
        break;
      case 'Cancelled':
        color = Colors.red;
        break;
      case 'Pending':
      default:
        color = Colors.grey;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showEditRequirementDialog(
    BuildContext context,
    ProjectMaterialRequirementEntity req,
  ) {
    showDialog(
      context: context,
      builder: (context) =>
          _EditRequirementDialog(projectUuid: widget.projectUuid, req: req),
    );
  }
}

class _EditRequirementDialog extends ConsumerStatefulWidget {
  final String projectUuid;
  final ProjectMaterialRequirementEntity req;

  const _EditRequirementDialog({required this.projectUuid, required this.req});

  @override
  ConsumerState<_EditRequirementDialog> createState() =>
      _EditRequirementDialogState();
}

class _EditRequirementDialogState
    extends ConsumerState<_EditRequirementDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _qtyController;
  late TextEditingController _nameController;
  late TextEditingController _unitController;
  late String _status;

  final FocusNode _qtyFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    final validStatuses = [
      'Pending',
      'Requested',
      'Ordered',
      'Delivered',
      'Installed',
      'Cancelled',
    ];
    _status = validStatuses.contains(widget.req.status)
        ? widget.req.status
        : 'Pending';

    // Strip trailing .0 if integer
    final qty = widget.req.requiredQuantity;
    _qtyController = TextEditingController(
      text: qty == qty.truncateToDouble()
          ? qty.toInt().toString()
          : qty.toString(),
    );
    _nameController = TextEditingController(
      text: widget.req.customName ?? widget.req.materialUuid,
    );
    _unitController = TextEditingController(text: widget.req.unit);

    _qtyFocus.addListener(() {
      if (_qtyFocus.hasFocus) {
        if (double.tryParse(_qtyController.text) == 0) _qtyController.clear();
      } else {
        if (_qtyController.text.trim().isEmpty) _qtyController.text = '0';
      }
    });
  }

  @override
  void dispose() {
    _qtyFocus.dispose();
    _qtyController.dispose();
    _nameController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Material'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Material Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _unitController,
                  decoration: const InputDecoration(
                    labelText: 'Unit',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value:
                      [
                        'Pending',
                        'Requested',
                        'Ordered',
                        'Delivered',
                        'Installed',
                        'Cancelled',
                      ].contains(_status)
                      ? _status
                      : null,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      [
                            'Pending',
                            'Requested',
                            'Ordered',
                            'Delivered',
                            'Installed',
                            'Cancelled',
                          ]
                          .toSet()
                          .map(
                            (s) => DropdownMenuItem<String>(
                              value: s,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      s,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _status = val);
                  },
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _qtyController,
                  focusNode: _qtyFocus,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Required';
                    if (double.tryParse(val) == null) return 'Must be a number';
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final customName = _nameController.text.trim();
              final updatedReq = ProjectMaterialRequirementEntity(
                uuid: widget.req.uuid,
                projectUuid: widget.projectUuid,
                materialUuid: widget.req.materialUuid,
                requiredQuantity: double.parse(_qtyController.text),
                allocatedQuantity: widget.req.allocatedQuantity,
                unit: _unitController.text.trim(),
                status: _status,
                customName: customName == widget.req.materialUuid
                    ? null
                    : customName,
              );
              ref
                  .read(materialsNotifierProvider.notifier)
                  .saveRequirement(updatedReq);
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
