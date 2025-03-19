import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Dotenv Test', () {
    var envPath = getEnvFilePath();
    setUpAll(() async {
      if (Platform.environment.containsKey('CI')) {
        if (kDebugMode) {
          print("⚠️  Running in CI/CD mode, using GitHub Secrets");
        }
        return;
      }

      if (envPath.isEmpty) {
        fail("⚠️  `.env` 文件不存在！\n"
            "解决方案：\n"
            "1️⃣  在项目根目录创建 `.env` 文件\n"
            "2️⃣  或者，在 GitHub Secrets 裡添加環境變數\n"
            "3️⃣  也可以執行 `cp .env.example .env` 來創建\n");
      }

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

// 痛袋讀取env的路徑
String getEnvFilePath() {
  List<String> possiblePaths = [
    "${Directory.current.path}/.env",
    "${Directory.current.path}/assets/.env"
  ];

  for (var path in possiblePaths) {
    if (File(path).existsSync()) {
      return path;
    }
  }

  return "";
}
