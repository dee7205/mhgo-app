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
        text: 'Hello! I am MHGo - AI Assistant. What would you like to know about your dashboard or projects?',
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
      
      final todayStr = "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";

      final systemPrompt = '''
You are the official Global AI Assistant for MHGo.
You are answering questions about the company's dashboard, multiple projects, materials, and overall status.
You are also capable of acting as an advanced Solar ROI Calculator and generating Solar EPC Quotations.

TODAY'S DATE: $todayStr

CRITICAL RULES:
1. When asked about projects or dashboard data, ONLY use the facts provided in the DASHBOARD DATA CONTEXT below.
2. If the user asks something not found in the context (unless it's a calculator or quotation request), politely inform them that you do not have access to that information.
3. NEVER invent or hallucinate data, prices, or statuses for existing projects.
4. Keep your answers professional, concise, and well-formatted. Do not use overly long paragraphs.

CALCULATOR RULES (ROI & Monthly Savings):
If the user asks to calculate ROI or Monthly Savings for a solar setup, use the following standard Philippine metrics (unless the user specifies their own):
- Average Electricity Rate: ₱12.00 per kWh
- Average Peak Sun Hours: 4.5 hours/day
- System Efficiency/Performance Ratio: 80% (0.80)
- Estimated Installation Cost: ₱50,000 to ₱70,000 per kW (use ₱60,000 as default if system cost isn't provided)

FORMULAS TO USE:
- Daily Yield (kWh) = System Capacity (kW) * Peak Sun Hours * Efficiency
- Monthly Savings = Daily Yield * 30 days * Electricity Rate
- Annual Savings = Monthly Savings * 12 months
- ROI (Years) = Total System Cost / Annual Savings

QUOTATION GENERATION RULES:
If the user asks to generate a quotation for a solar system, generate a professional Markdown-formatted quotation.
Include the following sections:
1. Header: "MHGo Solar EPC Quotation" with the date set to $todayStr (unless specified otherwise) and a client name placeholder.
2. System Description: e.g., "5kWp Grid-Tied Solar System".
3. Scope of Work: Engineering Design, Procurement, Installation, Testing & Commissioning, and Net-Metering processing.
4. Bill of Materials (BOM): A list of major components (Tier-1 Solar Panels, Inverter, Mounting Structure, AC/DC Protection, Cables).
5. Estimated Project Cost: Calculate the total cost based on the system size using the default ₱60,000/kW rate. Breakdown into Materials (70%) and Labor/Services (30%).
6. Financial Projection: Include the calculated Monthly Savings and ROI.
7. Payment Terms: e.g., 50% Downpayment, 40% Delivery, 10% Commissioning.
Make the quotation look formal and professional using bold text and bullet points. DO NOT use markdown tables (no | characters), as they are incompatible with the PDF exporter. Instead, use clean bulleted lists for breakdowns.

PDF GENERATION TRIGGER:
If the user explicitly asks to "generate a PDF", "save as PDF", or "export to PDF" (whether for a quotation, report, or anything else), you MUST append the exact string `[GENERATE_PDF]` at the very end of your response. This will trigger the app's UI to show a Download button.
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
