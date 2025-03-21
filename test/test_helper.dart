import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

Future<void> setupTestEnv() async {
  var envPath = getEnvFilePath();

  if (Platform.environment.containsKey('CI')) {
    if (kDebugMode) {
      print("⚠️  Running in CI/CD mode, using GitHub Secrets");
    }
    return;
  }

  if (!File(envPath).existsSync()) {
    throw Exception("⚠️ `.env` 文件不存在！请建立 `.env` 或使用 GitHub Secrets");
  }
  // 统一加载 `.env`
  await dotenv.load(fileName: envPath);

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
