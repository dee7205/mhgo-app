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
        heroTag: 'inventory-fab',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search materials',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  value:
                      [
                        null,
                        'Raw',
                        'Electrical',
                        'Structural',
                        'Misc',
                      ].contains(_selectedCategory)
                      ? _selectedCategory
                      : null,
                  items: [null, 'Raw', 'Electrical', 'Structural', 'Misc']
                      .toSet()
                      .map(
                        (c) => DropdownMenuItem<String?>(
                          value: c,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  c ?? 'All Categories',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => _selectedCategory = val),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Sort By',
                    border: OutlineInputBorder(),
                  ),
                  value:
                      [
                        'Name A-Z',
                        'Name Z-A',
                        'Stock: Low to High',
                        'Stock: High to Low',
                      ].contains(_sortOption)
                      ? _sortOption
                      : null,
                  items:
                      [
                            'Name A-Z',
                            'Name Z-A',
                            'Stock: Low to High',
                            'Stock: High to Low',
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
                    if (val != null) setState(() => _sortOption = val);
                  },
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _StockStatusChip(status: item.stockStatus),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => MaterialFormDialog(
                                    existingMaterial: item,
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                size: 20,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                ref
                                    .read(materialsNotifierProvider.notifier)
                                    .deleteMaterial(item.uuid);
                              },
                            ),
                          ],
                        ),
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
