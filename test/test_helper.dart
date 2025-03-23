import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

// Future<void> setupTestEnv() async {
//   var envPath = getEnvFilePath();
//
//   if (Platform.environment.containsKey('CI')) {
//     if (kDebugMode) {
//       print("⚠️  Running in CI/CD mode, using GitHub Secrets");
//     }
//     await dotenv.load(fileName: "assets/.env");
//     return;
//   }
//
//   if (!File(envPath).existsSync()) {
//     throw Exception("⚠️ `.env` 文件不存在！请建立 `.env` 或使用 GitHub Secrets");
//   }
//   // 统一加载 `.env`
//   await dotenv.load(fileName: envPath);
//
// }

// 痛袋讀取env的路徑
// String getEnvFilePath() {
//   List<String> possiblePaths = [
//     "${Directory.current.path}/.env",
//     "${Directory.current.path}/assets/.env"
//   ];
//
//   for (var path in possiblePaths) {
//     if (File(path).existsSync()) {
//       return path;
//     }
//   }
//
//   return "";
// }

Future<void> setupTestEnv() async {
  final envPath = '${Directory.current.path}/assets/.env';
  if (kDebugMode) {
    print("🧪 載入環境變數：$envPath");
  }

  if (!File(envPath).existsSync()) {
    throw Exception("❌ assets/.env 檔案不存在，請確認 CI 有正確建立");
  }

  await dotenv.load(fileName: envPath);
  if (kDebugMode) {
    print("✅ .env 載入成功，BASE_URL = \${dotenv.env['BASE_URL']}");
  }
}

void assertEnvKeysPresent(List<String> keys) {
  for (final key in keys) {
    final value = dotenv.env[key];
    assert(value != null && value!.isNotEmpty, '缺少環境變數或為空: \$key');
  }
}