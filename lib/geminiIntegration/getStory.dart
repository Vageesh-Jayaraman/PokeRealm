import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';


Future<String> generateStory({required String character}) async {
  final apiKey = API_KEY;
  final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
  final prompt = 'Create a new short, cute and funny story for kids with many emojis on this Pokemon character: $character.'
                  'No need of Bold/italics/other text styles. Leave lines wherever required for easy reading. The title should be short '
                  'It should be of the format [title,story]';
  final content = [Content.text(prompt)];
  final response = await model.generateContent(content);
  return response.text ?? '';
}
