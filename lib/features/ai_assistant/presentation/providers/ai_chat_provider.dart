import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../data/services/gemini_ai_service.dart';
import '../../domain/usecases/dashboard_context_builder.dart';

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;

  ChatMessage({required this.id, required this.text, required this.isUser});
}

class AiChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  AiChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  AiChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final geminiServiceProvider = Provider<GeminiAiService>((ref) {
  return GeminiAiService();
});

class AiChatNotifier extends Notifier<AiChatState> {
  @override
  AiChatState build() {
    return AiChatState(messages: [
      ChatMessage(
        id: const Uuid().v4(),
        text: 'Hello! I am your Global AI Assistant. What would you like to know about your dashboard or projects?',
        isUser: false,
      )
    ]);
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessage(id: const Uuid().v4(), text: text, isUser: true);
    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isLoading: true,
      error: null,
    );

    try {
      final geminiService = ref.read(geminiServiceProvider);
      
      // Fetch the global dashboard state
      final dashboardOverview = await ref.read(dashboardStateProvider.future);
      
      // Build context from dashboard
      final contextData = DashboardContextBuilder.build(dashboardOverview);

      const systemPrompt = '''
You are the official Global AI Assistant for MHGo.
You are answering questions about the company's dashboard, multiple projects, materials, and overall status.

CRITICAL RULES:
1. ONLY answer questions using the facts provided in the DASHBOARD DATA CONTEXT below.
2. If the user asks something not found in the context, politely inform them that you do not have access to that information.
3. NEVER invent or hallucinate data, prices, or statuses.
4. Keep your answers professional, concise, and well-formatted. Do not use overly long paragraphs.
5. You can summarize projects if the user asks for high-level overviews.
''';

      final responseText = await geminiService.askQuestion(
        systemPrompt: systemPrompt,
        contextData: contextData,
        userQuestion: text,
      );

      final aiMsg = ChatMessage(id: const Uuid().v4(), text: responseText.trim(), isUser: false);
      state = state.copyWith(
        messages: [...state.messages, aiMsg],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final aiChatProvider = NotifierProvider<AiChatNotifier, AiChatState>(() => AiChatNotifier());
