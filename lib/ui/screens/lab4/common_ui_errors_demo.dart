// Lab 4 - Exercise 5: Debug & Fix Common UI Errors
//
// Mục tiêu: Hiểu các lỗi bố cục và vòng đời UI phổ biến trong Flutter và cách sửa:
// 1. Fix ListView inside Column using Expanded.
// 2. Fix overflow in small screens using SingleChildScrollView.
// 3. Fix state update issue by adding setState().
// 4. Fix DatePicker build context errors by calling from valid widget tree.

import 'package:flutter/material.dart';

class CommonUiErrorsDemo extends StatefulWidget {
  const CommonUiErrorsDemo({super.key});

  @override
  State<CommonUiErrorsDemo> createState() => _CommonUiErrorsDemoState();
}

class _CommonUiErrorsDemoState extends State<CommonUiErrorsDemo> {
  // Chỉ số task hiện tại: 0 (Task 1), 1 (Task 2), 2 (Task 3), 3 (Task 4)
  int _currentTaskIndex = 0;

  // --- State cho Task 3 (setState) ---
  int _counterWithSetState = 0;
  int _counterWithoutSetState = 0;

  // --- State cho Task 4 (DatePicker) ---
  DateTime? _selectedDate;

  // Dữ liệu phim cho Task 1 (khớp với ảnh đề bài: Movie A, B, C, D)
  static const List<String> _movies = [
    "Movie A",
    "Movie B",
    "Movie C",
    "Movie D",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercise 5 – Common UI Errors"),
        actions: [
          PopupMenuButton<int>(
            tooltip: "Chọn Task kiểm tra lỗi",
            initialValue: _currentTaskIndex,
            onSelected: (int value) {
              setState(() {
                _currentTaskIndex = value;
              });
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 0,
                child: Text("Task 1: ListView in Column (Expanded)"),
              ),
              PopupMenuItem(
                value: 1,
                child: Text("Task 2: Screen Overflow (ScrollView)"),
              ),
              PopupMenuItem(
                value: 2,
                child: Text("Task 3: State Update (setState)"),
              ),
              PopupMenuItem(
                value: 3,
                child: Text("Task 4: DatePicker Context"),
              ),
            ],
          ),
        ],
      ),
      body: switch (_currentTaskIndex) {
        0 => _buildTask1Expanded(),
        1 => _buildTask2ScrollView(),
        2 => _buildTask3SetState(),
        3 => _buildTask4DatePicker(),
        _ => _buildTask1Expanded(),
      },
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTaskIndex,
        onTap: (index) => setState(() => _currentTaskIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.table_rows),
            label: "Expanded",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_vert),
            label: "ScrollView",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.refresh),
            label: "setState",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "DatePicker",
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Task 1: Fix ListView inside Column using Expanded.
  // Giao diện mặc định khớp 100% hình ảnh trong đề bài.
  // ===========================================================================
  Widget _buildTask1Expanded() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dòng tiêu đề như trong hình ảnh đề bài
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            "Correct ListView inside Column using\nExpanded",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // LỖI: Nếu không bọc Expanded, ListView trong Column sẽ bị lỗi
        // "Vertical viewport was given unbounded height".
        // SỬA: Bọc ListView bằng Expanded để chiếm toàn bộ phần chiều cao còn lại.
        Expanded(
          child: ListView.builder(
            itemCount: _movies.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.movie),
                title: Text(_movies[index]),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Selected: ${_movies[index]}"),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
          ),
        ),

        // Thẻ ghi chú giải thích giải pháp
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.blue.shade50,
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Giải thích: ListView có chiều cao vô hạn, khi đặt trong Column "
                      "sẽ gây xung đột viewport. Dùng Expanded giúp giới hạn chiều cao "
                      "của ListView theo không gian còn lại của Column.",
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // Task 2: Fix overflow in small screens using SingleChildScrollView.
  // ===========================================================================
  Widget _buildTask2ScrollView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Fix overflow in small screens using SingleChildScrollView",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Card(
            color: Colors.green.shade50,
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "LỖI: Khi Column chứa nhiều nội dung vượt quá kích thước màn hình "
                "(hoặc khi bàn phím ảo xuất hiện), Flutter sẽ báo lỗi tràn sọc vàng đen "
                "'A RenderFlex overflowed by xxx pixels'.\n\n"
                "SỬA: Bọc Column trong SingleChildScrollView để nội dung có thể cuộn được an toàn.",
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Mô phỏng nhiều thành phần form/thẻ gây tràn nếu không có ScrollView
          for (int i = 1; i <= 6; i++)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(child: Text("$i")),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Mục nội dung #$i",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Nội dung này cuộn mượt mà trên màn hình nhỏ nhờ SingleChildScrollView.",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Task 3: Fix state update issue by adding setState().
  // ===========================================================================
  Widget _buildTask3SetState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Fix state update issue by adding setState()",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Card(
            color: Colors.amber.shade50,
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "LỖI: Thay đổi giá trị biến trong StatefulWidget mà không gọi setState() "
                "khiến biến trong RAM thay đổi nhưng Flutter không vẽ lại màn hình.\n\n"
                "SỬA: Bao bọc cập nhật biến trong setState(() { ... }) để kích hoạt hàm build() vẽ lại UI.",
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Minh họa lỗi: không gọi setState()
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    "Trường hợp lỗi: Thay đổi biến KHÔNG gọi setState()",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Giá trị hiển thị trên UI: $_counterWithoutSetState",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade100,
                      foregroundColor: Colors.red.shade900,
                    ),
                    onPressed: () {
                      // Sai: biến thay đổi nhưng không báo Flutter render lại
                      _counterWithoutSetState++;
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Biến đã tăng lên $_counterWithoutSetState nhưng UI không cập nhật!",
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    icon: const Icon(Icons.close),
                    label: const Text("Tăng (Không dùng setState)"),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Minh họa đúng: có setState()
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    "Trường hợp ĐÃ SỬA: Thay đổi biến CÓ gọi setState()",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Giá trị hiển thị trên UI: $_counterWithSetState",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      // Đúng: gọi setState() để Flutter render lại với giá trị mới
                      setState(() {
                        _counterWithSetState++;
                      });
                    },
                    icon: const Icon(Icons.check),
                    label: const Text("Tăng (Dùng setState)"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Task 4: Fix DatePicker build context errors by calling from valid widget tree.
  // ===========================================================================
  Widget _buildTask4DatePicker() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Fix DatePicker build context errors",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Card(
            color: Colors.purple.shade50,
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "LỖI: Gọi showDatePicker trực tiếp trong phương thức build() sẽ gây lỗi "
                "'setState() or markNeedsBuild() called during build' và lặp vô tận.\n\n"
                "SỬA: Chỉ mở DatePicker trong sự kiện tương tác (ví dụ onPressed), sử dụng "
                "BuildContext hợp lệ có Navigator/MaterialApp, và kiểm tra 'if (!mounted) return;' "
                "sau await trước khi gọi setState().",
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Icon(Icons.calendar_today, size: 48, color: Colors.purple),
                  const SizedBox(height: 12),
                  Text(
                    _selectedDate == null
                        ? "Chưa chọn ngày"
                        : "Ngày đã chọn: ${_selectedDate!.day.toString().padLeft(2, '0')}/"
                            "${_selectedDate!.month.toString().padLeft(2, '0')}/"
                            "${_selectedDate!.year}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _openDatePickerSafely,
                    icon: const Icon(Icons.date_range),
                    label: const Text("Chọn ngày (Gọi an toàn từ onPressed)"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Hàm mở DatePicker chuẩn chỉnh, an toàn:
  // 1. Gọi từ callback onPressed với context hợp lệ.
  // 2. Có kiểm tra if (!mounted) return sau async gap.
  Future<void> _openDatePickerSafely() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    // Kiểm tra mounted sau await để tránh lỗi nếu widget đã bị dispose
    if (!mounted) return;

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
