import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/unit_test_repository.dart';
import 'auth_providers.dart';

final unitTestRepositoryProvider = Provider<UnitTestRepository>((ref) {
  return UnitTestRepository(ref.watch(supabaseClientProvider));
});
