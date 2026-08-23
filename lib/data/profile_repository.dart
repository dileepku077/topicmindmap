import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/profile.dart';

class ProfileRepository {
  ProfileRepository(this._client);

  final SupabaseClient _client;

  /// Null if this user has somehow never had a profile row created (the
  /// handle_new_user trigger in schema.sql normally guarantees one exists
  /// from the moment they sign up).
  Future<Profile?> fetchProfile(String userId) async {
    final row = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    return row == null ? null : Profile.fromMap(row);
  }

  Future<void> updateDefaultView(String userId, DefaultView view) {
    return _client
        .from('profiles')
        .update({'default_view': view.name})
        .eq('id', userId);
  }

  Future<void> updateGrade(String userId, int grade) {
    return _client.from('profiles').update({'grade': grade}).eq('id', userId);
  }
}
