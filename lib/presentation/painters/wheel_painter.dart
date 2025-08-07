import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/entities/prize.dart';

class WheelPainter extends CustomPainter {
  final List<Prize> prizes;
  final double rotationAngle;

  WheelPainter({
    required this.prizes,
    required this.rotationAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 10;
    
    // Save canvas state
    canvas.save();
    
    // Move to center and rotate
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotationAngle);
    
    // Draw wheel segments
    final anglePerSegment = 2 * pi / prizes.length;
    
    for (int i = 0; i < prizes.length; i++) {
      // Đảo ngược thứ tự: index 0 sẽ ở cuối, index cuối sẽ ở đầu
      final reversedIndex = prizes.length - 1 - i;
      final startAngle = i * anglePerSegment;
      
      // Draw segment
      final paint = Paint()
        ..color = prizes[reversedIndex].color
        ..style = PaintingStyle.fill;
      
      final rect = Rect.fromCircle(center: Offset.zero, radius: radius);
      canvas.drawArc(rect, startAngle, anglePerSegment, true, paint);
      
      // Draw border
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      
      canvas.drawArc(rect, startAngle, anglePerSegment, true, borderPaint);
      
      // Draw text
      final textPainter = TextPainter(
        text: TextSpan(
          text: prizes[reversedIndex].name,
          style: TextStyle(
            color: Colors.white,
            fontSize: size.width < 400 ? 10 : 12, // Responsive font size
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      
      textPainter.layout();
      
      // Calculate text position - từ tâm đến giữa ô
      final textAngle = startAngle + anglePerSegment / 2;
      final textRadius = radius * 0.6;
      final textX = textRadius * cos(textAngle) - textPainter.width / 2;
      final textY = textRadius * sin(textAngle) - textPainter.height / 2;
      
      // Save canvas state for text rotation
      canvas.save();
      
      // Move to text position and rotate
      canvas.translate(textX + textPainter.width / 2, textY + textPainter.height / 2);
      canvas.rotate(textAngle); // Xoay theo góc từ tâm đến giữa ô
      
      // Draw text at origin (0,0) vì đã translate
      textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      
      // Restore canvas state
      canvas.restore();
      
      // Draw icon
      final iconSize = size.width < 400 ? 20.0 : 24.0; // Responsive icon size
      final iconRadius = radius * 0.3;
      final iconX = iconRadius * cos(textAngle) - iconSize / 2;
      final iconY = iconRadius * sin(textAngle) - iconSize / 2;
      
      final iconPainter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(prizes[reversedIndex].icon.codePoint),
          style: TextStyle(
            color: Colors.white,
            fontSize: iconSize,
            fontFamily: prizes[reversedIndex].icon.fontFamily,
            package: prizes[reversedIndex].icon.fontPackage,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      
      iconPainter.layout();
      iconPainter.paint(canvas, Offset(iconX, iconY));
    }
    
    // Restore canvas state
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
} 