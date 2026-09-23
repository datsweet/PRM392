// Lab 4 - Exercise 4: App Structure with Scaffold, AppBar, FAB & Theme
//
// Mục tiêu: Thực hành xây dựng cấu trúc màn hình hoàn chỉnh gồm:
// - Scaffold
// - AppBar
// - Body
// - FloatingActionButton (FAB)
// - Tùy biến Theme với ThemeData
// - Triển khai nút gạt chuyển đổi "Dark Mode" sử dụng themeMode.

import 'package:flutter/material.dart';
import 'package:untitled/main.dart';

class AppStructureDemo extends StatefulWidget {
  const AppStructureDemo({super.key});

  @override
  State<AppStructureDemo> createState() => _AppStructureDemoState();
}

class _AppStructureDemoState extends State<AppStructureDemo> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    // Lấy thông tin theme hiện tại từ BuildContext
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Step 1: Tạo cấu trúc màn hình hoàn chỉnh với Scaffold
    return Scaffold(
      // Step 2a: AppBar với tiêu đề và nút chuyển đổi Dark Mode
      appBar: AppBar(
        title: const Text("Exercise 4 – App Structure & Theme"),
        actions: [
          // Row chứa nhãn "Dark" và Switch toggle theo hình đề bài
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Dark",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 4),
                // Step 3: Implement "Dark Mode" toggle using themeMode
                Switch(
                  value: isDarkMode,
                  onChanged: (bool value) {
                    // Cập nhật giá trị themeMode qua ValueNotifier được cấu hình tại main.dart
                    themeModeNotifier.value =
                        value ? ThemeMode.dark : ThemeMode.light;
                  },
                ),
              ],
            ),
          ),
        ],
      ),

      // Step 2b: Body với dòng chữ chính xác như hình đề bài
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text chính xác theo ảnh đề bài
              Text(
                "This is a simple screen with theme toggle.",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Thẻ Card minh họa các thuộc tính của ThemeData hiện tại
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        size: 48,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isDarkMode ? "Chế độ Tối (Dark Theme)" : "Chế độ Sáng (Light Theme)",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "ThemeMode hiện tại: ${themeModeNotifier.value.name.toUpperCase()}",
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Thể hiện thông tin tương tác với FAB
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "Số lần nhấn FAB: $_counter",
                          style: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Step 2c: FloatingActionButton (FAB)
      floatingActionButton: FloatingActionButton(
        tooltip: "Tăng biến đếm và hiện thông báo",
        onPressed: () {
          setState(() {
            _counter++;
          });
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("FloatingActionButton được bấm! Lần: $_counter"),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
