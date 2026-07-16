import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/materials_entities.dart';
import '../providers/materials_provider.dart';

class ProjectMaterialRequirementsTab extends ConsumerStatefulWidget {
  final String projectUuid;

  const ProjectMaterialRequirementsTab({
    super.key,
    required this.projectUuid,
  });

  @override
  ConsumerState<ProjectMaterialRequirementsTab> createState() => _ProjectMaterialRequirementsTabState();
}

class _ProjectMaterialRequirementsTabState extends ConsumerState<ProjectMaterialRequirementsTab> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final requirementsAsync = ref.watch(projectMaterialRequirementsProvider(widget.projectUuid));

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddRequirementDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Material'),
      ),
      body: requirementsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (requirements) {
          if (requirements.isEmpty) {
            return const Center(child: Text('No material requirements assigned yet.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: requirements.length,
            itemBuilder: (context, index) {
              final req = requirements[index];
              // We also need the material details to show the name. 
              // We can watch materialDetailsProvider(req.materialUuid) for each item.
              return _RequirementCard(requirement: req);
            },
          );
        },
      ),
    );
  }

  void _showAddRequirementDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _AddRequirementDialog(projectUuid: widget.projectUuid),
    );
  }
}

class _RequirementCard extends ConsumerWidget {
  final ProjectMaterialRequirementEntity requirement;

  const _RequirementCard({required this.requirement});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materialAsync = ref.watch(materialDetailsProvider(requirement.materialUuid));
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: materialAsync.when(
        loading: () => const ListTile(title: Text('Loading material...')),
        error: (err, stack) => ListTile(title: Text('Error: $err')),
        data: (material) {
          if (material == null) return const ListTile(title: Text('Material not found'));
          return ListTile(
            title: Text(material.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Required: ${requirement.requiredQuantity} ${requirement.unit}'),
                Text('Allocated: ${requirement.allocatedQuantity} ${requirement.unit}'),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => _AddRequirementDialog(
                    projectUuid: requirement.projectUuid,
                    existingRequirement: requirement,
                  ),
                );
              },
            ),
          );
        },
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
  MaterialEntity? _selectedMaterial;
  late TextEditingController _requiredController;
  late TextEditingController _allocatedController;

  @override
  void initState() {
    super.initState();
    _requiredController = TextEditingController(text: widget.existingRequirement?.requiredQuantity.toString() ?? '');
    _allocatedController = TextEditingController(text: widget.existingRequirement?.allocatedQuantity.toString() ?? '');
  }

  @override
  void dispose() {
    _requiredController.dispose();
    _allocatedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final materialsAsync = ref.watch(materialsProvider);

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
                if (widget.existingRequirement == null)
                  materialsAsync.when(
                    loading: () => const CircularProgressIndicator(),
                    error: (e, s) => Text('Error: $e'),
                    data: (materials) {
                      return DropdownButtonFormField<MaterialEntity>(
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: 'Select Global Material', border: OutlineInputBorder()),
                        items: materials.map((m) => DropdownMenuItem(
                          value: m,
                          child: Text('${m.name} (Avail: ${m.availableStock} ${m.unit})', overflow: TextOverflow.ellipsis),
                        )).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedMaterial = val;
                          });
                        },
                        validator: (val) => val == null ? 'Required' : null,
                      );
                    },
                  )
                else
                  materialsAsync.when(
                    loading: () => const CircularProgressIndicator(),
                    error: (e, s) => Text('Error: $e'),
                    data: (materials) {
                      final mat = materials.firstWhere(
                        (m) => m.uuid == widget.existingRequirement!.materialUuid,
                        orElse: () => MaterialEntity(
                          uuid: '', name: 'Unknown', category: '', unit: '', currentStock: 0, minimumStock: 0, stockStatus: ''
                        ),
                      );
                      _selectedMaterial = mat;
                      return TextFormField(
                        initialValue: '${mat.name} (Avail: ${mat.availableStock} ${mat.unit})',
                        readOnly: true,
                        decoration: const InputDecoration(labelText: 'Material', border: OutlineInputBorder()),
                      );
                    },
                  ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _requiredController,
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
                  decoration: const InputDecoration(labelText: 'Allocated Quantity', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Required';
                    final parsed = double.tryParse(val);
                    if (parsed == null) return 'Must be a number';
                    
                    if (_selectedMaterial != null) {
                      final currentAllocated = widget.existingRequirement?.allocatedQuantity ?? 0.0;
                      // Max allowable allocation is the currently available stock + what was already allocated to this requirement
                      final maxAllowable = _selectedMaterial!.availableStock + currentAllocated;
                      if (parsed > maxAllowable) {
                        return 'Exceeds available stock ($maxAllowable)';
                      }
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
            if (_formKey.currentState!.validate() && (_selectedMaterial != null || widget.existingRequirement != null)) {
              final req = ProjectMaterialRequirementEntity(
                uuid: widget.existingRequirement?.uuid ?? const Uuid().v4(),
                projectUuid: widget.projectUuid,
                materialUuid: _selectedMaterial?.uuid ?? widget.existingRequirement!.materialUuid,
                requiredQuantity: double.parse(_requiredController.text),
                allocatedQuantity: double.parse(_allocatedController.text),
                unit: _selectedMaterial?.unit ?? widget.existingRequirement!.unit,
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
