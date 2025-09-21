import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/test_model.dart';
import '../../service_class/repos.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return ApiUserRepository(baseUrl: 'https://jsonplaceholder.typicode.com');
});

final usersProvider = FutureProvider<List<User>>((ref) async {
  final repository = ref.read(userRepositoryProvider);
  return await repository.getUsers();
});