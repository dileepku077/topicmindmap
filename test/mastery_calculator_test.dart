import 'package:flutter_test/flutter_test.dart';
import 'package:astro_stem_labs/domain/mastery_calculator.dart';
import 'package:astro_stem_labs/domain/mastery_config.dart';

DifficultyStats _stats(String difficulty, int attempted, int firstTryCorrect) {
  return DifficultyStats(
    difficulty: difficulty,
    attempted: attempted,
    correct: attempted,
    firstTryCorrect: firstTryCorrect,
  );
}

void main() {
  group('bandForPercent', () {
    test('boundaries are inclusive at each threshold', () {
      expect(bandForPercent(90), 'Diamond');
      expect(bandForPercent(89.9), 'Gold');
      expect(bandForPercent(80), 'Gold');
      expect(bandForPercent(79.9), 'Silver');
      expect(bandForPercent(60), 'Silver');
      expect(bandForPercent(59.9), 'Bronze');
      expect(bandForPercent(30), 'Bronze');
      expect(bandForPercent(29.9), 'None');
      expect(bandForPercent(0), 'None');
    });
  });

  group('calculateMastery', () {
    test('too few total attempts reports insufficient data, not a medal', () {
      final result = calculateMastery([_stats('Easy', 2, 2)]);
      expect(result.insufficientData, isTrue);
      expect(result.medal, 'None');
      expect(result.masteryPercent, 0);
    });

    test('all-Easy high accuracy cannot reach Diamond on its own', () {
      // 95% first-try on 20 Easy questions -- would band to Diamond by
      // percentage alone, but there's zero higher-tier evidence.
      final result = calculateMastery([_stats('Easy', 20, 19)]);
      expect(result.insufficientData, isFalse);
      expect(result.masteryPercent, closeTo(95, 0.01));
      expect(result.medal, 'Gold');
    });

    test('strong Easy but weak Advanced pulls overall mastery down', () {
      final result = calculateMastery([
        _stats('Easy', 10, 10), // 100%, weight 1 -> weighted 10
        _stats('Advanced', 10, 2), // 20%, weight 4 -> weighted 8
      ]);
      // weighted = (100*10 + 20*40) / (10 + 40) = (1000 + 800) / 50 = 36
      expect(result.masteryPercent, closeTo(36, 0.01));
      expect(result.medal, 'Bronze');
      expect(result.byDifficulty['Easy']!.medal, 'Diamond');
      expect(result.byDifficulty['Advanced']!.medal, 'None');
    });

    test('strong performance across every difficulty earns Diamond', () {
      final result = calculateMastery([
        _stats('Easy', 10, 10),
        _stats('Medium', 10, 9),
        _stats('Challenge', 10, 9),
        _stats('Advanced', 10, 9),
      ]);
      expect(result.insufficientData, isFalse);
      expect(result.masteryPercent, greaterThanOrEqualTo(90));
      expect(result.medal, 'Diamond');
    });

    test('mixed moderate accuracy lands in Silver', () {
      final result = calculateMastery([
        _stats('Easy', 10, 7),
        _stats('Medium', 10, 6),
      ]);
      // weighted = (70*10 + 60*20) / (10+20) = (700+1200)/30 = 63.33
      expect(result.masteryPercent, closeTo(63.33, 0.1));
      expect(result.medal, 'Silver');
    });

    test('low accuracy across the board earns no medal', () {
      final result = calculateMastery([
        _stats('Easy', 10, 2),
        _stats('Medium', 10, 1),
      ]);
      expect(result.medal, 'None');
    });

    test('large attempt counts still compute a stable, sane result', () {
      final result = calculateMastery([
        _stats('Easy', 200, 190),
        _stats('Medium', 150, 120),
        _stats('Challenge', 80, 60),
        _stats('Advanced', 40, 30),
      ]);
      expect(result.insufficientData, isFalse);
      expect(result.masteryPercent, greaterThan(0));
      expect(result.masteryPercent, lessThanOrEqualTo(100));
    });

    test('a difficulty with too few of its own attempts gets no per-tier medal', () {
      final result = calculateMastery([
        _stats('Easy', 20, 20),
        _stats('Advanced', 2, 2), // only 2 attempts at this tier
      ]);
      expect(result.byDifficulty['Advanced']!.insufficientData, isTrue);
      expect(result.byDifficulty['Advanced']!.medal, 'None');
    });

    test('an untouched difficulty contributes nothing and has no entry', () {
      final result = calculateMastery([
        _stats('Easy', 10, 10),
        _stats('Medium', 0, 0),
      ]);
      expect(result.byDifficulty.containsKey('Medium'), isFalse);
    });

    test('Diamond right at the higher-tier attempt floor is allowed', () {
      final result = calculateMastery(
        [
          _stats('Easy', 10, 10),
          _stats('Challenge', 3, 3),
        ],
        config: const MasteryConfig(minHigherTierAttemptsForDiamond: 3),
      );
      expect(result.masteryPercent, closeTo(100, 0.01));
      expect(result.medal, 'Diamond');
    });

    test('one short of the higher-tier floor caps at Gold instead', () {
      final result = calculateMastery(
        [
          _stats('Easy', 10, 10),
          _stats('Challenge', 2, 2),
        ],
        config: const MasteryConfig(minHigherTierAttemptsForDiamond: 3),
      );
      expect(result.masteryPercent, closeTo(100, 0.01));
      expect(result.medal, 'Gold');
    });
  });
}
