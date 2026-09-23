import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:untitled/data/models/person.dart';
import 'package:untitled/data/models/product.dart';
import 'package:untitled/data/models/student.dart';
import 'package:untitled/data/models/teacher.dart';
import 'package:untitled/main.dart';
import 'package:untitled/ui/screens/home_page.dart';
import 'package:untitled/ui/screens/lab4/app_structure_demo.dart';
import 'package:untitled/ui/screens/lab4/common_ui_errors_demo.dart';
import 'package:untitled/ui/screens/lab4/core_widgets_demo.dart';
import 'package:untitled/ui/screens/lab4/input_controls_demo.dart';
import 'package:untitled/ui/screens/lab4/layout_basics_demo.dart';
import 'package:untitled/ui/widgets/product_widget.dart';

void main() {
  testWidgets('HomePage hiển thị AppBar và thông tin sản phẩm', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    expect(find.text('Home page'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.byIcon(Icons.menu), findsOneWidget);

    // Hai sản phẩm, mỗi cái một nút thêm giỏ hàng.
    expect(find.byType(ProductWidget), findsNWidgets(2));
    expect(find.text('Thêm vào giỏ hàng'), findsNWidgets(2));

    expect(find.text('Golden Retriever'), findsOneWidget);
    expect(find.text('960\$'), findsOneWidget);

    expect(find.text('Siberian Husky'), findsOneWidget);
    expect(find.text('1500\$'), findsOneWidget);

    // '1200$' xuất hiện 2 lần: giá gốc của Golden và giá sau giảm của Husky.
    expect(find.text('1200\$'), findsNWidgets(2));
  });

  testWidgets('Ảnh giữ đúng kích thước 300x200', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    final box = tester.widget<SizedBox>(
      find
          .descendant(
            of: find.byType(ProductWidget).first,
            matching: find.byType(SizedBox),
          )
          .first,
    );

    expect(box.width, 300);
    expect(box.height, 200);
  });

  testWidgets('Bấm nút hiện SnackBar xác nhận', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    await tester.tap(find.text('Thêm vào giỏ hàng').first);
    await tester.pump();

    expect(
      find.text('Đã thêm Golden Retriever vào giỏ hàng'),
      findsOneWidget,
    );
  });

  testWidgets('Layout không tràn khi cửa sổ hẹp', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(420, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();

    // Thông tin vẫn còn, không bị RenderFlex overflow.
    expect(tester.takeException(), isNull);
    expect(find.text('Golden Retriever'), findsOneWidget);
    expect(find.text('Thêm vào giỏ hàng'), findsWidgets);
  });

  test('Product.copyTo chỉ thay đổi field được truyền vào', () {
    const p = Product(id: 1, name: 'iPhone 15', price: 1000);
    final copy = p.copyTo(name: 'iPhone 15 Pro', price: 1500);

    expect(copy.id, 1);
    expect(copy.name, 'iPhone 15 Pro');
    expect(copy.price, 1500);
  });

  test('Product chuyển đổi JSON hai chiều', () {
    const p = Product(
      id: 7,
      name: 'MacBook Air',
      price: 1100,
      image: 'assets/images/img.png',
      description: 'Laptop mỏng nhẹ',
    );

    final restored = Product.fromJson(p.toJson());

    expect(restored.id, p.id);
    expect(restored.name, p.name);
    expect(restored.price, p.price);
    expect(restored.image, p.image);
    expect(restored.description, p.description);
  });

  test('Person.create trả về Student khi personType là student', () {
    final person = Person.create(
      personType: PersonType.student,
      json: {'id': 'S01', 'name': 'Dat', 'math': 8.5, 'physic': 7},
    );

    expect(person, isA<Student>());
    expect(person.id, 'S01');

    final student = person as Student;
    expect(student.math, 8.5);
    expect(student.physic, 7.0);
    expect(student.chemistry, isNull);
  });

  test('Person.create trả về Teacher khi personType là teacher', () {
    final person = Person.create(
      personType: PersonType.teacher,
      json: {
        'id': 'T01',
        'name': 'Khang',
        'subjects': ['Toán', 'Lý'],
      },
    );

    expect(person, isA<Teacher>());

    final teacher = person as Teacher;
    expect(teacher.name, 'Khang');
    expect(teacher.subjects, ['Toán', 'Lý']);
  });

  test('Teacher.fromJson trả về list rỗng khi thiếu subjects', () {
    final teacher = Teacher.fromJson({'id': 'T02', 'name': 'Lan'});

    expect(teacher.subjects, isEmpty);
  });

  // ===================== Lab 4 =====================

  group('Lab 4', () {
    testWidgets('Menu liệt kê Bài 1 và Bài 2', (tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.text('Bài 1 - Core Widgets'), findsOneWidget);
      expect(find.text('Bài 2 - Input Widgets'), findsOneWidget);
    });

    testWidgets('Menu mở được Bài 1 và quay lại được', (tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.tap(find.text('Bài 1 - Core Widgets'));
      await tester.pumpAndSettle();
      expect(find.text('Ex1 - Core Widgets'), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Bài 1 - Core Widgets'), findsOneWidget);
    });

    testWidgets('Menu mở được Bài 2', (tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.tap(find.text('Bài 2 - Input Widgets'));
      await tester.pumpAndSettle();
      expect(find.text('Ex2 - Input Widgets'), findsOneWidget);
    });

    testWidgets('Ex1 hiển thị Text, Icon, Image, Card, ListTile', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: CoreWidgetsDemo()));

      expect(find.text('Cửa hàng thú cưng'), findsOneWidget);
      expect(find.byIcon(Icons.pets), findsWidgets);
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(Card), findsNWidgets(2));
      expect(find.byType(ListTile), findsNWidgets(2));
    });

    testWidgets('Ex2 Slider đổi giá trị và hiện ra màn hình', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: InputControlsDemo()));

      // 'Số lượng: 1' hiện ở 2 chỗ: nhãn trên Slider và thẻ tổng kết đơn hàng.
      expect(find.text('Số lượng: 1'), findsNWidgets(2));

      // Bấm vào giữa thanh slider -> giá trị nhảy lên khoảng giữa (1..10).
      final slider = tester.getRect(find.byType(Slider));
      await tester.tapAt(slider.center);
      await tester.pump();

      // Cả hai chỗ đều cập nhật theo giá trị mới.
      expect(find.text('Số lượng: 1'), findsNothing);
      expect(find.textContaining('Số lượng: '), findsNWidgets(2));
    });

    testWidgets('Ex2 Switch bật thì thông tin đơn đổi theo', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: InputControlsDemo()));

      expect(find.text('Gói quà: Không'), findsOneWidget);

      await tester.tap(find.byType(SwitchListTile));
      await tester.pump();

      expect(find.text('Gói quà: Có'), findsOneWidget);
    });

    testWidgets('Ex2 RadioListTile đổi phương thức giao hàng', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: InputControlsDemo()));

      expect(find.text('Giao hàng: Tiêu chuẩn (3-5 ngày)'), findsOneWidget);

      await tester.tap(find.text('Nhận tại cửa hàng'));
      await tester.pump();

      expect(find.text('Giao hàng: Nhận tại cửa hàng'), findsOneWidget);
    });

    testWidgets('Ex2 nút mở được DatePicker', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: InputControlsDemo()));

      await tester.tap(find.text('Chọn ngày giao hàng'));
      await tester.pumpAndSettle();

      // DatePicker mở ra dưới dạng dialog.
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('Menu liệt kê Bài 3 và Bài 4', (tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.text('Bài 3 - Layout Basics'), findsOneWidget);
      expect(find.text('Bài 4 - App Structure & Theme'), findsOneWidget);
    });

    testWidgets('Menu mở được Bài 3', (tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.tap(find.text('Bài 3 - Layout Basics'));
      await tester.pumpAndSettle();
      expect(find.text('Exercise 3 – Layout Demo'), findsOneWidget);
    });

    testWidgets('Ex3 hiển thị Now Playing và danh sách phim', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LayoutBasicsDemo()));

      expect(find.text('Now Playing'), findsOneWidget);
      expect(find.text('Avatar'), findsOneWidget);
      expect(find.text('Inception'), findsOneWidget);
      expect(find.text('Interstellar'), findsOneWidget);
      expect(find.text('Joker'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Menu mở được Bài 4', (tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.tap(find.text('Bài 4 - App Structure & Theme'));
      await tester.pumpAndSettle();
      expect(find.text('Exercise 4 – App Structure & Theme'), findsOneWidget);
    });

    testWidgets('Ex4 hiển thị Scaffold, AppBar, FAB, Body text và toggle theme', (
      tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      await tester.tap(find.text('Bài 4 - App Structure & Theme'));
      await tester.pumpAndSettle();

      expect(find.byType(AppStructureDemo), findsOneWidget);
      expect(find.text('Exercise 4 – App Structure & Theme'), findsOneWidget);
      expect(find.text('This is a simple screen with theme toggle.'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);

      // Nhấn FAB kiểm tra tương tác
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      expect(find.textContaining('FloatingActionButton được bấm! Lần: 1'), findsOneWidget);

      // Bật Dark Mode switch
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(themeModeNotifier.value, ThemeMode.dark);

      // Tắt Dark Mode switch
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(themeModeNotifier.value, ThemeMode.light);
    });

    testWidgets('Menu liệt kê Bài 5', (tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.text('Bài 5 - Debug & Fix UI Errors'), findsOneWidget);
    });

    testWidgets('Menu mở được Bài 5 và Task 1 hiển thị chuẩn', (tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.tap(find.text('Bài 5 - Debug & Fix UI Errors'));
      await tester.pumpAndSettle();

      expect(find.byType(CommonUiErrorsDemo), findsOneWidget);
      expect(find.text('Exercise 5 – Common UI Errors'), findsOneWidget);
      expect(find.textContaining('Correct ListView inside Column using'), findsOneWidget);
      expect(find.text('Movie A'), findsOneWidget);
      expect(find.text('Movie B'), findsOneWidget);
      expect(find.text('Movie C'), findsOneWidget);
      expect(find.text('Movie D'), findsOneWidget);
    });

    testWidgets('Ex5 chuyển các Task qua BottomNavigationBar và hoạt động chính xác', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: CommonUiErrorsDemo()));

      // Task 1: Expanded
      expect(find.text('Movie A'), findsOneWidget);

      // Chuyển Task 2: ScrollView
      await tester.tap(find.text('ScrollView'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Fix overflow in small screens'), findsOneWidget);

      // Chuyển Task 3: setState
      await tester.tap(find.text('setState'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Fix state update issue by adding setState()'), findsOneWidget);
      expect(find.text('Giá trị hiển thị trên UI: 0'), findsWidgets);

      // Bấm nút có setState
      await tester.ensureVisible(find.text('Tăng (Dùng setState)'));
      await tester.tap(find.text('Tăng (Dùng setState)'));
      await tester.pump();
      expect(find.text('Giá trị hiển thị trên UI: 1'), findsOneWidget);

      // Chuyển Task 4: DatePicker
      await tester.tap(find.text('DatePicker'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Fix DatePicker build context errors'), findsOneWidget);
      expect(find.text('Chưa chọn ngày'), findsOneWidget);

      // Bấm nút mở DatePicker an toàn
      await tester.ensureVisible(find.text('Chọn ngày (Gọi an toàn từ onPressed)'));
      await tester.tap(find.text('Chọn ngày (Gọi an toàn từ onPressed)'));
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });
  });
}


