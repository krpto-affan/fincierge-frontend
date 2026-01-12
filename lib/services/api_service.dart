import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  final String baseUrl = "https://fincierge-backend-production.up.railway.app"; // change for android

  Future<Map<String, dynamic>?> verifyUser(String token) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/verify"),
      headers: {"Authorization": "Bearer $token",},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Verification failed: ${response.body}");
    }
  }

    /// ✅ Get user profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken();

    final response = await http.get(
      Uri.parse("$baseUrl/user/profile"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("❌ Failed to fetch profile: ${response.body}");
      return null;
    }
  }

  /// ✅ Update user profile
  Future<bool> updateUserProfile(Map<String, dynamic> data) async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken();

    final response = await http.put(
      Uri.parse("$baseUrl/user/profile"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print("✅ Profile updated successfully");
      return true;
    } else {
      print("❌ Update failed: ${response.body}");
      return false;
    }
  }

Future<Map<String, dynamic>> sendRagQuery(String query) async {
    final url = Uri.parse("$baseUrl/rag/chat"); // FIXED: remove stray https:
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'query': query}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch response: ${response.statusCode} ${response.body}");
    }
  }

  /// Streams chat response from the backend and calls callbacks for each chunk
  Future<void> streamChatResponse({
    required String query,
    required void Function(String chunk) onChunk,
    required void Function() onComplete,
    required void Function(String error) onError,
  }) async {
    final url = Uri.parse("$baseUrl/rag/chat/stream");
    final client = http.Client();

    try {
      final request = http.Request('POST', url)
        ..headers['Content-Type'] = 'application/json'
        ..headers['Accept'] = 'application/x-ndjson' // optional, helpful
        ..body = jsonEncode({'query': query});

      final streamedResponse = await client.send(request);

      if (streamedResponse.statusCode != 200) {
        final body = await streamedResponse.stream.bytesToString();
        client.close();
        onError("HTTP ${streamedResponse.statusCode}: $body");
        return;
      }

      // Listen to the stream line-by-line; keep a subscription so we can close client onDone
      final subscription = streamedResponse.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
        (line) {
          try {
            if (line.trim().isEmpty) return;
            final data = jsonDecode(line);
            if (data is Map && data.containsKey('token')) {
              final token = data['token'] as String;
              if (token == "[DONE]") {
                // Will be handled in onDone, but call onComplete here too
                onComplete();
              } else {
                onChunk(token);
              }
            } else if (data is Map && data.containsKey('error')) {
              onError(data['error'].toString());
            } else {
              onChunk(line);
            }
          } catch (e) {
            onError("Stream parse error: $e");
          }
        },
        onError: (err) {
          onError(err.toString());
          // close client when stream errors
          try {
            client.close();
          } catch (_) {}
        },
        onDone: () {
          // Stream finished normally
          try {
            client.close();
          } catch (_) {}
          onComplete();
        },
        cancelOnError: true,
      );

      // Optionally, return control to caller while subscription is active.
      // If you want this function to await until the stream finishes, uncomment:
      // await subscription.asFuture();

    } catch (e) {
      // Network / request creation error
      try {
        client.close();
      } catch (_) {}
      onError(e.toString());
    }
  }
}