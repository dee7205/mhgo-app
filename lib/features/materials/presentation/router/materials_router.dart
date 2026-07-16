import 'package:go_router/go_router.dart';
import '../views/inventory_view.dart';
import '../views/material_requests_view.dart';
import '../views/deliveries_view.dart';
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
    GoRoute(
      path: '/material-requests',
      builder: (context, state) => const MaterialRequestsView(),
    ),
    GoRoute(
      path: '/deliveries',
      builder: (context, state) => const DeliveriesView(),
    ),
  ];
}
