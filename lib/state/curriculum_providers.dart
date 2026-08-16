import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/curriculum_repository.dart';
import '../models/subtopic.dart';
import '../models/unit.dart';
import 'auth_providers.dart';

final curriculumRepositoryProvider = Provider<CurriculumRepository>((ref) {
  return CurriculumRepository(ref.watch(supabaseClientProvider));
});

final unitsProvider = FutureProvider<List<Unit>>((ref) {
  return ref.watch(curriculumRepositoryProvider).fetchUnits();
});

final subtopicsProvider = FutureProvider<List<Subtopic>>((ref) {
  return ref.watch(curriculumRepositoryProvider).fetchSubtopics();
});
