import 'dart:math';
import 'package:flutter/material.dart';
import '../controllers/lucky_wheel_controller.dart';
import '../painters/wheel_painter.dart';

class LuckyWheel extends StatefulWidget {
  final LuckyWheelController controller;

  const LuckyWheel({
    super.key,
    required this.controller,
  });

  @override
  State<LuckyWheel> createState() => _LuckyWheelState();
}

enum SpinScenario {
  /// Ngẫu nhiên - chọn ngẫu nhiên từ 3 kịch bản
  random,
  
  /// Quay vào giữa ô - kết quả chính xác
  center,
  
  /// Quay mạnh hơn một chút - sang ô tiếp theo
  overshoot,
  
  /// Quay nhẹ hơn một chút - ở lại ô trước đó
  undershoot;

  static SpinScenario getRandomScenario() {
    final random = Random();
    final probability = random.nextDouble();
    
    // 60% khả năng quay vào giữa ô
    if (probability < 0.6) {
      return SpinScenario.center;
    }
    // 20% khả năng quay mạnh hơn
    else if (probability < 0.8) {
      return SpinScenario.overshoot;
    }
    // 20% khả năng quay nhẹ hơn
    else {
      return SpinScenario.undershoot;
    }
  }

  String get displayName {
    switch (this) {
      case SpinScenario.random:
        return '🎲 Ngẫu nhiên';
      case SpinScenario.center:
        return '🎯 Chính xác';
      case SpinScenario.overshoot:
        return '💫 Mạnh hơn';
      case SpinScenario.undershoot:
        return '🎪 Nhẹ hơn';
    }
  }

  String get description {
    switch (this) {
      case SpinScenario.random:
        return 'Chọn ngẫu nhiên từ 3 kịch bản';
      case SpinScenario.center:
        return 'Quay chính xác vào giữa ô';
      case SpinScenario.overshoot:
        return 'Quay mạnh hơn, sang ô tiếp theo';
      case SpinScenario.undershoot:
        return 'Quay nhẹ hơn, ở lại ô trước đó';
    }
  }
}

class _LuckyWheelState extends State<LuckyWheel> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _bounceController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _bounceAnimation;

  final scenarioNotifier = ValueNotifier<SpinScenario?>(null);

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeOutCubic,
    ));

    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.linear,
    ));
    _rotationController.addListener(() {
      final newAngle = _rotationAnimation.value;
      widget.controller.updateRotationAngle(newAngle);
    });

    _rotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _startBounceAnimation();
      }
    });

    _bounceController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.controller.onAnimationComplete();
        _showResultDialog();
      }
    });

    // Listen to controller changes
    widget.controller.addListener(_onControllerChanged);
  }

  void setupAnimation(SpinScenario scenario) {
    _rotationController.reset();
    _bounceController.reset();

    final currentAngle = widget.controller.rotationAngle;
    final targetRotation = widget.controller.targetRotation!;
    final anglePerSegment = widget.controller.anglePerSegment;

    switch (scenario) {
      case SpinScenario.random:
        // Sử dụng kịch bản ngẫu nhiên
        final randomScenario = SpinScenario.getRandomScenario();
        setupAnimation(randomScenario);
        return;
      case SpinScenario.center:
        _rotationAnimation = Tween<double>(
          begin: currentAngle,
          end: targetRotation,
        ).animate(CurvedAnimation(
          parent: _rotationController,
          curve: Curves.easeOutCubic,
        ));
        _bounceAnimation = Tween<double>(
          begin: 0.0,
          end: 0.0,
        ).animate(CurvedAnimation(
          parent: _bounceController,
          curve: Curves.linear,
        ));
        break;
      case SpinScenario.overshoot:
        _rotationAnimation = Tween<double>(
          begin: currentAngle,
          end: targetRotation + anglePerSegment/2 + 0.05,
        ).animate(CurvedAnimation(
          parent: _rotationController,
          curve: Curves.easeOutCubic,
        ));
        _bounceAnimation = Tween<double>(
          begin: 0.0,
          end: -0.2,
        ).animate(CurvedAnimation(
          parent: _bounceController,
          curve: Curves.easeInOut,
        ));
        break;
      case SpinScenario.undershoot:
        _rotationAnimation = Tween<double>(
          begin: currentAngle,
          end: targetRotation - anglePerSegment/2 + 0.05,
        ).animate(CurvedAnimation(
          parent: _rotationController,
          curve: Curves.easeOutCubic,
        ));
        _bounceAnimation = Tween<double>(
          begin: 0.0,
          end: 0.05,
        ).animate(CurvedAnimation(
          parent: _bounceController,
          curve: Curves.easeInOut,
        ));
        break;
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _bounceController.dispose();
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (widget.controller.targetRotation != null &&
        widget.controller.isSpinning) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    // Nếu scenarioNotifier.value là null, sử dụng kịch bản ngẫu nhiên
    final scenario = scenarioNotifier.value ?? SpinScenario.getRandomScenario();
    setupAnimation(scenario);
    _rotationController.forward();
  }

  void _startBounceAnimation() {
    _bounceController.forward();
  }

  void _showResultDialog() {
    final winningPrize = widget.controller.lastWinningPrize;
    final selectedScenario = scenarioNotifier.value;
    
    if (winningPrize != null) {
      String scenarioText = '';
      String scenarioDescription = '';
      
      if (selectedScenario == null) {
        // Ngẫu nhiên - hiển thị kịch bản thực tế đã được chọn
        final actualScenario = SpinScenario.getRandomScenario();
        scenarioText = '🎲 ${actualScenario.displayName}';
        scenarioDescription = actualScenario.description;
      } else {
        scenarioText = selectedScenario.displayName;
        scenarioDescription = selectedScenario.description;
      }
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(scenarioText),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                winningPrize.icon,
                size: 64,
                color: winningPrize.color,
              ),
              const SizedBox(height: 16),
              Text(
                'Bạn đã trúng:',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                winningPrize.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: winningPrize.color,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  scenarioDescription,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.blue.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  double _getCombinedAngle() {
    if (_rotationAnimation.isAnimating) return _rotationAnimation.value;
    final mainAngle = _rotationAnimation.value;
    final bounceAngle = _bounceAnimation.value;
    return mainAngle + bounceAngle;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final wheelSize = screenSize.width < 600 ? 300.0 : 400.0; // Responsive size

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 0,
              height: 0,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                      color: Colors.transparent, width: wheelSize * 0.05),
                  right: BorderSide(
                      color: Colors.transparent, width: wheelSize * 0.05),
                  bottom: BorderSide(color: Colors.red, width: wheelSize * 0.1),
                ),
              ),
            ),

            // Wheel
            Container(
              width: wheelSize,
              height: wheelSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 3,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: AnimatedBuilder(
                animation:
                    Listenable.merge([_rotationController, _bounceController]),
                builder: (context, child) {
                  return CustomPaint(
                    painter: WheelPainter(
                      prizes: widget.controller.prizes,
                      rotationAngle: _getCombinedAngle(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 40),

            // Prize info
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    '🎁 Giải thưởng có sẵn:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'iPhone 15 Pro • MacBook Pro • AirPods Pro • iPad Pro • Apple Watch • Voucher 500k • Voucher 1M',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Scenario dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🎮 Chọn kịch bản quay:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  ValueListenableBuilder<SpinScenario?>(
                    valueListenable: scenarioNotifier,
                    builder: (context, selectedScenario, child) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 3,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<SpinScenario?>(
                            value: selectedScenario,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down),
                            hint: Text(
                              SpinScenario.random.displayName,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            items: [
                              // Tùy chọn ngẫu nhiên (null)
                              DropdownMenuItem<SpinScenario?>(
                                value: null,
                                child: Row(
                                  children: [
                                    Text(SpinScenario.random.displayName),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        SpinScenario.random.description,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Colors.grey.shade600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Các kịch bản cụ thể
                              ...SpinScenario.values.where((s) => s != SpinScenario.random).map(
                                (scenario) => DropdownMenuItem<SpinScenario>(
                                  value: scenario,
                                  child: Row(
                                    children: [
                                      Text(scenario.displayName),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          scenario.description,
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Colors.grey.shade600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            onChanged: widget.controller.isSpinning
                                ? null
                                : (SpinScenario? newValue) {
                                    scenarioNotifier.value = newValue;
                                  },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Spin button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.controller.isSpinning
                    ? null
                    : () => widget.controller.spinWheel(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  widget.controller.isSpinning
                      ? '🔄 Đang quay...'
                      : '🎯 Quay ngay!',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Reset button
            TextButton.icon(
              onPressed: widget.controller.isSpinning
                  ? null
                  : () => widget.controller.reset(),
              icon: const Icon(Icons.refresh),
              label: const Text('Quay lại'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade600,
              ),
            ),
          ],
        );
      },
    );
  }
}
