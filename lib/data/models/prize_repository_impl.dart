import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/entities/prize.dart';
import '../../domain/repositories/prize_repository.dart';

class PrizeRepositoryImpl implements PrizeRepository {
  final List<Prize> _prizes = [
    const Prize(
      name: 'iPhone 15 Pro',
      color: Color(0xFFE74C3C),
      icon: Icons.phone_iphone,
    ),
    const Prize(
      name: 'MacBook Pro',
      color: Color(0xFF3498DB),
      icon: Icons.laptop_mac,
    ),
    const Prize(
      name: 'AirPods Pro',
      color: Color(0xFF2ECC71),
      icon: Icons.headphones,
    ),
    const Prize(
      name: 'iPad Pro',
      color: Color(0xFFF39C12),
      icon: Icons.tablet_mac,
    ),
    const Prize(
      name: 'Apple Watch',
      color: Color(0xFF9B59B6),
      icon: Icons.watch,
    ),
    const Prize(
      name: 'Chúc may mắn lần sau!',
      color: Color(0xFF95A5A6),
      icon: Icons.sentiment_dissatisfied,
    ),
    const Prize(
      name: 'Voucher 500k',
      color: Color(0xFFE67E22),
      icon: Icons.card_giftcard,
    ),
    const Prize(
      name: 'Voucher 1M',
      color: Color(0xFF1ABC9C),
      icon: Icons.monetization_on,
    ),
  ];

  @override
  List<Prize> getPrizes() {
    return List.unmodifiable(_prizes);
  }

  @override
  Prize getRandomPrize() {
    final random = Random();
    return _prizes[random.nextInt(_prizes.length)];
  }
} 