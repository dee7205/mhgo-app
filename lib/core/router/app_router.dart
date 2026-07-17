import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mhgo/core/widgets/app_shell.dart';
import 'package:mhgo/features/dashboard/presentation/views/dashboard_view.dart';
import 'package:mhgo/features/auth/presentation/views/login_view.dart';
import 'package:mhgo/features/auth/presentation/views/forgot_password_view.dart';
import 'package:mhgo/features/auth/presentation/providers/auth_provider.dart';
import 'package:mhgo/features/projects/presentation/views/projects_list_view.dart';
import 'package:mhgo/features/projects/presentation/views/project_details_view.dart';
import 'package:mhgo/features/dar/presentation/views/dar_list_view.dart';
import 'package:mhgo/features/dar/presentation/views/dar_create_edit_view.dart';
import 'package:mhgo/features/dar/presentation/views/dar_details_view.dart';
import 'package:mhgo/features/dar/presentation/views/pdf_preview_view.dart';
import '../../features/projects/presentation/views/project_pdf_preview_view.dart';
import 'package:mhgo/features/survey/presentation/views/survey_list_view.dart';
import 'package:mhgo/features/survey/presentation/views/survey_create_edit_view.dart';
import 'package:mhgo/features/survey/presentation/views/survey_details_view.dart';
import 'package:mhgo/features/survey/presentation/views/pdf_preview_view.dart';
import 'package:mhgo/features/progress/presentation/views/progress_list_view.dart';
import 'package:mhgo/features/progress/presentation/views/progress_details_view.dart';
import 'package:mhgo/features/progress/presentation/views/progress_create_edit_view.dart';
import '../../features/materials/presentation/router/materials_router.dart';

abstract class AppRouteNames {
  static const String surveyList = 'survey_list';
  static const String surveyCreate = 'survey_create';
  static const String surveyEdit = 'survey_edit';
  static const String surveyDetails = 'survey_details';
}

// A listenable that notifies GoRouter when auth state changes
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  RouterNotifier(this._ref) {
    _ref.listen<AuthState>(
      authProvider,
      (_, __) => notifyListeners(),
    );
  }
}

// Riverpod Provider for GoRouter to enable dynamic updates (e.g. auth redirect, guards)
final appRouterNotifierProvider = Provider<GoRouter>((ref) {
  final notifier = RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    refreshListenable: notifier,
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Route Boundary Catch: ${state.error}')),
    ),
    redirect: (context, state) {
      final isLoggedIn = ref.read(authProvider).isAuthenticated;
      final isGoingToAuth = state.matchedLocation == '/login' || state.matchedLocation == '/forgot-password';

      if (!isLoggedIn) {
        // If not logged in and not heading to auth screens, push to login
        return isGoingToAuth ? null : '/login';
      }

      // If logged in and attempting to visit auth screens, send to dashboard
      if (isLoggedIn && isGoingToAuth) {
        return '/dashboard';
      }

      return null; // no redirect
    },
    routes: [
      // Top-level Auth & Work Routes (outside the StatefulShellRoute)
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordView(),
      ),
      GoRoute(
        path: '/dar',
        builder: (context, state) => const DarListView(),
      ),
      GoRoute(
        path: '/dar/create',
        builder: (context, state) => const DarCreateEditView(mode: DarFormMode.create),
      ),
      GoRoute(
        path: '/dar/edit/:id',
        builder: (context, state) => DarCreateEditView(
          mode: DarFormMode.edit,
          id: state.pathParameters['id'],
        ),
      ),
      GoRoute(
        path: '/dar/details/:id',
        builder: (context, state) => DarDetailsView(
          id: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/dar/pdf/:id',
        builder: (context, state) => PdfPreviewView(
          id: state.pathParameters['id']!,
        ),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          // Dashboard Branch (Index 0)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardView(),
              ),
            ],
          ),
          // Projects Branch (Index 1)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/projects',
                builder: (context, state) => const ProjectsListView(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => ProjectDetailsView(
                      uuid: state.pathParameters['id']!,
                    ),
                    routes: [
                      GoRoute(
                        path: 'pdf',
                        builder: (context, state) => ProjectPdfPreviewView(
                          uuid: state.pathParameters['id']!,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // Progress Branch (Index 2)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/progress',
                builder: (context, state) => const ProgressListView(),
                routes: [
                  GoRoute(
                    path: 'details/:id',
                    builder: (context, state) => ProgressDetailsView(
                      id: state.pathParameters['id']!,
                    ),
                  ),
                  GoRoute(
                    path: 'update/:id',
                    builder: (context, state) => ProgressCreateEditView(
                      id: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Inventory Branch (Index 3)
          StatefulShellBranch(
            routes: MaterialsRouter.routes,
          ),
          // Survey Branch (Index 4)
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppRouteNames.surveyList,
                path: '/survey',
                builder: (context, state) => const SurveyListView(),
                routes: [
                  GoRoute(
                    name: AppRouteNames.surveyCreate,
                    path: 'new',
                    builder: (context, state) => const SurveyCreateEditView(),
                  ),
                  GoRoute(
                    name: AppRouteNames.surveyEdit,
                    path: 'edit/:uuid',
                    builder: (context, state) => SurveyCreateEditView(
                      uuid: state.pathParameters['uuid'],
                    ),
                  ),
                  GoRoute(
                    name: AppRouteNames.surveyDetails,
                    path: 'details/:uuid',
                    builder: (context, state) => SurveyDetailsView(
                      uuid: state.pathParameters['uuid']!,
                    ),
                  ),
                  GoRoute(
                    path: 'pdf/:uuid',
                    builder: (context, state) => SurveyPdfPreviewView(
                      id: state.pathParameters['uuid']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // O&M Branch (Index 5)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/om',
                builder: (context, state) => const _PlaceholderScreen(title: 'Operations & Maintenance'),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction_outlined,
              size: 64,
              color: theme.colorScheme.secondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              '$title Module',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This module is currently in development for MHG.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
