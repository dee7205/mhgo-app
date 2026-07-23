import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiAiService {
  late final GenerativeModel _model;

  GeminiAiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    
    // Safely check if the API key exists before trying to initialize Gemini
    if (apiKey == null || apiKey.isEmpty || apiKey == 'your_api_key_here') {
      throw Exception('Gemini API Key is missing or invalid in .env file.');
    }
    
    // Using the requested gemini-3-flash-preview model. Preview models require the v1beta endpoint.
    _model = GenerativeModel(
      model: 'gemini-3-flash-preview',
      apiKey: apiKey,
      requestOptions: const RequestOptions(apiVersion: 'v1beta'),
    );
  }

  /// Sends a structured prompt to Gemini utilizing RAG (Retrieval-Augmented Generation)
  Future<String> askQuestion({
    required String systemPrompt,
    required String contextData,
    required String userQuestion,
  }) async {
    try {
      // 1. We construct a strictly formatted prompt.
      // We place the System Prompt at the top to give the AI its rules.
      // We inject the Context Data in the middle so the AI has the exact facts.
      // We place the User Question at the bottom.
      final fullPrompt = '''
$systemPrompt

--- PROJECT DATA CONTEXT ---
$contextData
----------------------------

User Question: $userQuestion
''';
      
      // 2. We send the prompt to Gemini
      final response = await _model.generateContent([Content.text(fullPrompt)]);
      
      // 3. We return the raw text response
      return response.text ?? 'I could not generate an answer.';
    } catch (e) {
      throw Exception('Failed to get answer from AI: $e');
    }
  }
}
