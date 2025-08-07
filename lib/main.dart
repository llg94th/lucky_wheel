import 'package:flutter/material.dart';
import 'data/models/prize_repository_impl.dart';
import 'domain/repositories/prize_repository.dart';
import 'presentation/controllers/lucky_wheel_controller.dart';
import 'presentation/widgets/lucky_wheel.dart';

void main() {
  runApp(const LuckyWheelApp());
}

class LuckyWheelApp extends StatelessWidget {
  const LuckyWheelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vòng Quay May Mắn',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const LuckyWheelPage(),
    );
  }
}

class LuckyWheelPage extends StatefulWidget {
  const LuckyWheelPage({super.key});

  @override
  State<LuckyWheelPage> createState() => _LuckyWheelPageState();
}

class _LuckyWheelPageState extends State<LuckyWheelPage> {
  late final PrizeRepository _prizeRepository;
  late final LuckyWheelController _controller;

  @override
  void initState() {
    super.initState();
    _prizeRepository = PrizeRepositoryImpl();
    _controller = LuckyWheelController(_prizeRepository);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎯 Vòng Quay May Mắn'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        elevation: 2,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.red.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 800, // Giới hạn chiều rộng tối đa
                maxHeight: 900, // Giới hạn chiều cao tối đa
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: LuckyWheel(controller: _controller),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
