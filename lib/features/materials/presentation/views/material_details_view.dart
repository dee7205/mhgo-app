import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mhgo/features/projects/presentation/providers/projects_provider.dart';
import '../../domain/entities/materials_entities.dart';
import '../providers/materials_provider.dart';

class MaterialDetailsView extends ConsumerStatefulWidget {
  final String uuid;
  const MaterialDetailsView({super.key, required this.uuid});

  @override
  ConsumerState<MaterialDetailsView> createState() =>
      _MaterialDetailsViewState();
}

class _MaterialDetailsViewState extends ConsumerState<MaterialDetailsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final materialAsync = ref.watch(materialDetailsProvider(widget.uuid));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Material Details'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Stock Levels'),
            Tab(text: 'Project Allocations'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(materialDetailsProvider(widget.uuid));
            },
          ),
        ],
      ),
      body: materialAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (material) {
          if (material == null) {
            return const Center(child: Text('Material not found'));
          }

          return TabBarView(
            controller: _tabController,
            children: [_buildStockLevels(material), _buildAllocations()],
          );
        },
      ),
    );
  }

  Widget _buildStockLevels(material) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Material Info',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(label: 'Name', value: material.name),
                  _InfoRow(label: 'Category', value: material.category),
                  _InfoRow(
                    label: 'Supplier',
                    value: material.supplier ?? 'Unknown',
                  ),
                  _InfoRow(
                    label: 'Storage',
                    value: material.storageLocation ?? 'Unknown',
                  ),
                  if (material.remarks != null &&
                      material.remarks!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text('Remarks: ${material.remarks}'),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stock Status',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Current Stock',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${material.currentStock} ${material.unit}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (material.currentStock / (material.minimumStock * 2))
                        .clamp(0.0, 1.0),
                    backgroundColor: Colors.grey.shade300,
                    color: material.stockStatus == 'In Stock'
                        ? Colors.green
                        : (material.stockStatus == 'Low Stock'
                              ? Colors.orange
                              : Colors.red),
                    minHeight: 12,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Minimum Required: ${material.minimumStock} ${material.unit}',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllocations() {
    final allocationsAsync = ref.watch(
      materialAllocationsProvider(widget.uuid),
    );
    return allocationsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (allocations) {
        if (allocations.isEmpty) {
          return const Center(child: Text('No allocations for this material.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: allocations.length,
          itemBuilder: (context, index) {
            final allocation = allocations[index];
            return _AllocationTile(allocation: allocation);
          },
        );
      },
    );
  }
}

class _AllocationTile extends ConsumerWidget {
  final ProjectMaterialRequirementEntity allocation;
  const _AllocationTile({required this.allocation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectAsync = ref.watch(
      projectDetailsProvider(allocation.projectUuid),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: projectAsync.when(
        loading: () => const ListTile(title: Text('Loading project...')),
        error: (err, stack) => ListTile(title: Text('Error: $err')),
        data: (data) {
          return ListTile(
            title: Text(
              data.project.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Required: ${allocation.requiredQuantity} ${allocation.unit}',
                ),
                Text(
                  'Allocated: ${allocation.allocatedQuantity} ${allocation.unit}',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
