import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helper.dart';

void main() {
  group('Dotenv Test', () {
    var envPath = getEnvFilePath();
    setUpAll(() async {
      await setupTestEnv();
      await dotenv.load(fileName: envPath);
    });

    test('Ensure all required keys have values', () async {
      final envFile = File(envPath);
      final lines = await envFile.readAsLines();

      final List<String> envKeys = lines
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty && !line.startsWith('#'))
          .where((line) => line.contains('='))
          .map((line) => line.split('=').first.trim())
          .toList();
      for (var key in envKeys) {
        String? value = dotenv.env[key]?.trim().isNotEmpty == true
            ? dotenv.env[key]
            : Platform.environment[key];
        expect(value, isNotNull, reason: "⚠️  缺少环境变量: $key");
        expect(value!.isNotEmpty, isTrue, reason: "⚠️  環境變數 $key 不能為空");
      }
    });
  });
}

