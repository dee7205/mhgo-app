import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/materials_provider.dart';
import '../../domain/entities/materials_entities.dart';

import '../widgets/material_form_dialog.dart';

class InventoryView extends ConsumerStatefulWidget {
  const InventoryView({super.key});

  @override
  ConsumerState<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends ConsumerState<InventoryView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;
  String _sortOption = 'Name A-Z';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MaterialEntity> _getFilteredAndSorted(List<MaterialEntity> materials) {
    var filtered = materials.where((m) {
      final matchesSearch =
          m.name.toLowerCase().contains(_searchQuery) ||
          m.uuid.toLowerCase().contains(_searchQuery);
      final matchesCategory =
          _selectedCategory == null || m.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    filtered.sort((a, b) {
      switch (_sortOption) {
        case 'Name Z-A':
          return b.name.compareTo(a.name);
        case 'Stock: Low to High':
          return a.currentStock.compareTo(b.currentStock);
        case 'Stock: High to Low':
          return b.currentStock.compareTo(a.currentStock);
        case 'Name A-Z':
        default:
          return a.name.compareTo(b.name);
      }
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final materialsAsync = ref.watch(materialsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(materialsProvider),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const MaterialFormDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search materials',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedCategory,
                    items: [null, 'Raw', 'Electrical', 'Structural', 'Misc']
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text(
                              c ?? 'All Categories',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => _selectedCategory = val),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Sort By',
                      border: OutlineInputBorder(),
                    ),
                    value: _sortOption,
                    items:
                        [
                              'Name A-Z',
                              'Name Z-A',
                              'Stock: Low to High',
                              'Stock: High to Low',
                            ]
                            .map(
                              (s) => DropdownMenuItem(
                                value: s,
                                child: Text(s, overflow: TextOverflow.ellipsis),
                              ),
                            )
                            .toList(),
                    onChanged: (val) => setState(() => _sortOption = val!),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: materialsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (materials) {
                final processed = _getFilteredAndSorted(materials);
                if (processed.isEmpty) {
                  return const Center(child: Text('No materials found.'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  itemCount: processed.length,
                  itemBuilder: (context, index) {
                    final item = processed[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(
                          item.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('Category: ${item.category}'),
                            Text('Stock: ${item.currentStock} ${item.unit}'),
                          ],
                        ),
                        trailing: _StockStatusChip(status: item.stockStatus),
                        onTap: () =>
                            context.push('/inventory/details/${item.uuid}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StockStatusChip extends StatelessWidget {
  final String status;
  const _StockStatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'In Stock':
        color = Colors.green;
        break;
      case 'Low Stock':
        color = Colors.orange;
        break;
      case 'Out of Stock':
      default:
        color = Colors.red;
    }
    return Chip(
      label: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(color: color.withValues(alpha: 0.5)),
    );
  }
}
