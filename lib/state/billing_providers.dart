import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/billing_repository.dart';
import 'auth_providers.dart';

final billingRepositoryProvider = Provider<BillingRepository>((ref) {
  return BillingRepository(ref.watch(supabaseClientProvider));
});
