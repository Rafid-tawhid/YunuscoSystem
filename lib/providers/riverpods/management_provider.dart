
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/service_class/api_services.dart';
import 'dart:math';

import '../../helper_class/firebase_helpers.dart';
import '../../models/announcement_model.dart';

ApiService apiService=ApiService();


final dateStateProvider = StateProvider<Map<String, DateTime?>>((ref) {
  return {
    'fromDate': null,
    'toDate': null,
  };
});

final numValueProvider = FutureProvider<num>((ref) async {
  final dates = ref.watch(dateStateProvider);
  final fromDate = dates['fromDate'];
  final toDate = dates['toDate'];
  return await getKaizanValue(fromDate, toDate);
});

Future<dynamic> getKaizanValue(DateTime? fromDate, DateTime? toDate) async {
  ApiService apiService = ApiService();

  if (fromDate == null || toDate == null) {
    var data = await apiService.getData('api/dashboard/KaizanCount');
    return data != null ? data['returnvalue'] : 0.0;
  } else {
    var data = await apiService.getData(
        'api/dashboard/KaizanCount?fromDate=${DashboardHelpers.convertDateTime(fromDate.toString(), pattern: 'dd-MM-yyyy')}&toDate=${DashboardHelpers.convertDateTime(toDate.toString(), pattern: 'dd-MM-yyyy')}'
    );
    return data != null ? data['returnvalue'] : 0.0;
  }
}

final randNum = StateProvider<int>((ref) {
  var secureRandom = Random();
  var data=secureRandom.nextInt(100);
  return data;
});




///announcement providers
///

// providers/news_feed_provider.dart


// Firebase Service Provider
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

// Posts Stream Provider
final postsStreamProvider = StreamProvider<List<AnnouncementModel>>((ref) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return firebaseService.getPosts();
});

// Comments Stream Provider (family)
final commentsStreamProvider = StreamProvider.family<List<Comment>, String>((ref, postId) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return firebaseService.getComments(postId);
});

// Create Post Provider
final createPostProvider = StateNotifierProvider<CreatePostNotifier, bool>((ref) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return CreatePostNotifier(firebaseService);
});

class CreatePostNotifier extends StateNotifier<bool> {
  final FirebaseService _firebaseService;

  CreatePostNotifier(this._firebaseService) : super(false);

  Future<void> createPost(String content) async {
    state = true;
    try {
      await _firebaseService.createPost(content);
    } finally {
      state = false;
    }
  }
}

// Like Post Provider
final likePostProvider = StateNotifierProvider.family<LikePostNotifier, AsyncValue<void>, String>((ref, postId) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return LikePostNotifier(firebaseService, postId);
});

class LikePostNotifier extends StateNotifier<AsyncValue<void>> {
  final FirebaseService _firebaseService;
  final String postId;

  LikePostNotifier(this._firebaseService, this.postId) : super(const AsyncValue.data(null));

  Future<void> toggleLike() async {
    state = const AsyncValue.loading();
    try {
      await _firebaseService.toggleLike(postId);
      state = const AsyncValue.data(null);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
}

// Add Comment Provider
final addCommentProvider = StateNotifierProvider.family<AddCommentNotifier, AsyncValue<void>, String>((ref, postId) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return AddCommentNotifier(firebaseService, postId);
});

class AddCommentNotifier extends StateNotifier<AsyncValue<void>> {
  final FirebaseService _firebaseService;
  final String postId;

  AddCommentNotifier(this._firebaseService, this.postId) : super(const AsyncValue.data(null));

  Future<void> addComment(String content) async {
    state = const AsyncValue.loading();
    try {
      await _firebaseService.addComment(postId, content);
      state = const AsyncValue.data(null);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
}

// Delete Post Provider
final deletePostProvider = StateNotifierProvider.family<DeletePostNotifier, AsyncValue<void>, String>((ref, postId) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return DeletePostNotifier(firebaseService, postId);
});

class DeletePostNotifier extends StateNotifier<AsyncValue<void>> {
  final FirebaseService _firebaseService;
  final String postId;

  DeletePostNotifier(this._firebaseService, this.postId) : super(const AsyncValue.data(null));

  Future<void> deletePost() async {
    state = const AsyncValue.loading();
    try {
      await _firebaseService.deletePost(postId);
      state = const AsyncValue.data(null);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
}

