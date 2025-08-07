import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/entities/prize.dart';
import '../../domain/repositories/prize_repository.dart';

class LuckyWheelController extends ChangeNotifier {
  final PrizeRepository _prizeRepository;
  
  List<Prize> _prizes = [];
  double _rotationAngle = 0.0;
  bool _isSpinning = false;
  Prize? _lastWinningPrize;
  
  LuckyWheelController(this._prizeRepository) {
    _prizes = _prizeRepository.getPrizes();
  }
  
  List<Prize> get prizes => _prizes;
  double get rotationAngle => _rotationAngle;
  bool get isSpinning => _isSpinning;
  Prize? get lastWinningPrize => _lastWinningPrize;

  double get anglePerSegment => 2 * pi / _prizes.length;
  
  void spinWheel() {
    if (_isSpinning) return;
    
    print('SpinWheel called');
    _isSpinning = true;
    
    // Reset góc về 0 để tránh tích lũy
    _rotationAngle = 0.0;
    
    notifyListeners();
    
    // Get random prize
    final winningPrize = _prizeRepository.getRandomPrize(); // Test với giải thưởng thứ 3 (AirPods Pro)
    final winningIndex = _prizes.indexOf(winningPrize);
    
    print('Winning prize: ${winningPrize.name} at index: $winningIndex');
    
    // Calculate target rotation
    final anglePerSegment = 2 * pi / _prizes.length;
    
    // Trong WheelPainter, các ô được vẽ từ góc 0 (12h) theo chiều kim đồng hồ
    // Ô đầu tiên (index 0) có góc từ 0 đến anglePerSegment
    // Ô thứ hai (index 1) có góc từ anglePerSegment đến 2*anglePerSegment
    // v.v.
    // Mũi tên ở trên cùng (12h), nên để mũi tên chỉ vào biên cuối của ô index i,
    // cần quay để ô đó di chuyển lên vị trí 12h
    // Góc biên cuối của ô index i = (i + 1) * anglePerSegment
    // Để mũi tên chỉ vào biên cuối ô, cần quay theo chiều kim đồng hồ (dương)
    final targetAngle = (winningIndex + 1) * anglePerSegment - pi/2 - anglePerSegment/2;
    
    // Calculate total rotation (at least 5 full rotations)
    const minRotations = 5;
    final randomRotations = Random().nextInt(3) + minRotations; // 5-7 rotations
    final totalRotation = randomRotations * 2 * pi + targetAngle;
    
    print('Angle per segment: ${anglePerSegment * 180 / pi}°');
    print('Target angle: ${targetAngle * 180 / pi}°');
    print('Total rotation: ${totalRotation * 180 / pi}°');
    print('Expected final position: ${(totalRotation % (2 * pi)) * 180 / pi}°');
    
    // Store the target rotation for the widget to animate
    _targetRotation = totalRotation;
    _winningPrize = winningPrize;
    notifyListeners();
  }
  
  // These will be set by the widget during animation
  double? _targetRotation;
  Prize? _winningPrize;
  
  double? get targetRotation => _targetRotation;
  Prize? get winningPrize => _winningPrize;
  
  void onAnimationComplete() {
    _isSpinning = false;
    _lastWinningPrize = _winningPrize;
    _targetRotation = null;
    _winningPrize = null;
    notifyListeners();
  }
  
  void updateRotationAngle(double angle) {
    _rotationAngle = angle;
  }
  
  void reset() {
    _rotationAngle = 0.0;
    _isSpinning = false;
    _lastWinningPrize = null;
    _targetRotation = null;
    _winningPrize = null;
    notifyListeners();
  }
} 