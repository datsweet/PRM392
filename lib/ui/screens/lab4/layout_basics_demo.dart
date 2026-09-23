// Lab 4 - Exercise 3: Layout Basics (Column, Row, Padding, ListView)
//
// Mục tiêu: Xây dựng giao diện phân chia theo section tương tự màn hình Home
// của ứng dụng thực tế, sử dụng Column, Row, Padding, SizedBox, và ListView.builder.

import 'package:flutter/material.dart';

// Model đơn giản đại diện cho một bộ phim / mục trong danh sách.
class MovieItem {
  final String title;
  final String description;
  final String genre;
  final double rating;

  const MovieItem({
    required this.title,
    required this.description,
    required this.genre,
    required this.rating,
  });
}

class LayoutBasicsDemo extends StatelessWidget {
  const LayoutBasicsDemo({super.key});

  // Dữ liệu mẫu khớp với hình minh họa đề bài: Avatar, Inception, Interstellar, Joker...
  static const List<MovieItem> _movies = [
    MovieItem(
      title: "Avatar",
      description: "Sample description",
      genre: "Sci-Fi",
      rating: 7.9,
    ),
    MovieItem(
      title: "Inception",
      description: "Sample description",
      genre: "Action",
      rating: 8.8,
    ),
    MovieItem(
      title: "Interstellar",
      description: "Sample description",
      genre: "Sci-Fi",
      rating: 8.7,
    ),
    MovieItem(
      title: "Joker",
      description: "Sample description",
      genre: "Drama",
      rating: 8.4,
    ),
    MovieItem(
      title: "The Dark Knight",
      description: "Sample description",
      genre: "Action",
      rating: 9.0,
    ),
    MovieItem(
      title: "Oppenheimer",
      description: "Sample description",
      genre: "Biography",
      rating: 8.9,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercise 3 – Layout Demo"),
      ),
      // Step 1: Dùng Column để tạo các section theo chiều dọc (Vertical sections).
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Step 2 & 4: Dùng Padding với khoảng cách chuẩn (16px) cho tiêu đề section.
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              children: [
                // Tiêu đề chính của section: "Now Playing" (như trong hình đề bài)
                Text(
                  "Now Playing",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Biểu diễn Widget 'Row' - Thể hiện các thể loại / hành động nằm ngang
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryChip(context, "All", isSelected: true),
                      const SizedBox(width: 8),
                      _buildCategoryChip(context, "Sci-Fi"),
                      const SizedBox(width: 8),
                      _buildCategoryChip(context, "Action"),
                      const SizedBox(width: 8),
                      _buildCategoryChip(context, "Drama"),
                      const SizedBox(width: 8),
                      _buildCategoryChip(context, "Animation"),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Spacing 8px giữa header và danh sách
          const SizedBox(height: 8),

          // Step 3: Dùng ListView.builder để hiển thị danh sách phim/mục
          // Bọc trong Expanded để ListView chiếm trọn phần không gian còn lại của Column.
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _movies.length,
              itemBuilder: (context, index) {
                final movie = _movies[index];
                // Lấy chữ cái đầu tiên làm avatar như trong ảnh
                final initial = movie.title.isNotEmpty ? movie.title[0] : "?";

                // Step 4: Áp dụng Card và khoảng cách đồng nhất (margin 8-12px)
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 0.5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                  child: Padding(
                    // Padding bên trong Card (12px)
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    child: ListTile(
                      // CircleAvatar với chữ cái đầu của tên phim
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Text(
                          initial,
                          style: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        movie.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            movie.description,
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const Spacer(),
                          // Dùng Row nhỏ hiển thị điểm rating & thể loại
                          Icon(Icons.star, size: 14, color: Colors.amber.shade700),
                          const SizedBox(width: 4),
                          Text(
                            movie.rating.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Đã chọn phim: ${movie.title}"),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget phụ trợ minh họa việc dùng Padding và Container/Chip
  static Widget _buildCategoryChip(
    BuildContext context,
    String label, {
    bool isSelected = false,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurface,
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
