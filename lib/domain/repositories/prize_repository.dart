import '../entities/prize.dart';

abstract class PrizeRepository {
  List<Prize> getPrizes();
  Prize getRandomPrize();
} 