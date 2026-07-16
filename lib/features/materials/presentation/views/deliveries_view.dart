import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/materials_provider.dart';

class DeliveriesView extends ConsumerWidget {
  const DeliveriesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveriesAsync = ref.watch(deliveriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deliveries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(deliveriesProvider),
          ),
        ],
      ),
      body: deliveriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (deliveries) {
          if (deliveries.isEmpty) {
            return const Center(child: Text('No deliveries recorded.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: deliveries.length,
            itemBuilder: (context, index) {
              final d = deliveries[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Delivery from ${d.supplier}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Chip(
                        label: Text(
                          d.status,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text('Project: ${d.projectName}'),
                      Text(
                        'Date: ${d.deliveryDate.toLocal().toString().split(' ')[0]}',
                      ),
                      Text('Items: ${d.deliveredMaterialsJson.length}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
