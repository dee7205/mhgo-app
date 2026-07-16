import 'package:go_router/go_router.dart';
import '../views/inventory_view.dart';
import '../views/material_details_view.dart';

class MaterialsRouter {
  static final List<GoRoute> routes = [
    GoRoute(
      path: '/inventory',
      builder: (context, state) => const InventoryView(),
    ),
    GoRoute(
      path: '/inventory/details/:uuid',
      builder: (context, state) {
        final uuid = state.pathParameters['uuid']!;
        return MaterialDetailsView(uuid: uuid);
      },
    ),
  ];
}
