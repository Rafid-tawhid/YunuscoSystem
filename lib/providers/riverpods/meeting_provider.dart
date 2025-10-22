import 'package:flutter/cupertino.dart';
import 'package:yunusco_group/models/board_room_booking_model.dart';
import 'package:yunusco_group/providers/riverpods/purchase_order_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:yunusco_group/service_class/api_services.dart';


// Different state classes for each provider
class MeetingListState {
  final bool isLoading;
  final dynamic data;
  final String? error;

  const MeetingListState({
    this.isLoading = false,
    this.data = const [],
    this.error,
  });

  MeetingListState copyWith({
    bool? isLoading,
    dynamic data,
    String? error,
  }) {
    return MeetingListState(
      isLoading: isLoading ?? this.isLoading,
      data: data,
      error: error ?? this.error,
    );
  }
}

class CreateMeetingState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  const CreateMeetingState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  CreateMeetingState copyWith({
    bool? isLoading,
    String? error, // This should accept null explicitly
    bool? isSuccess,
  }) {
    return CreateMeetingState(
      isLoading: isLoading ?? this.isLoading,
      error: error, // Remove the ?? this.error - this allows null to be set
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

// Separate providers with different state classes
final meetingProvider = StateNotifierProvider<MeetingNotifier, MeetingListState>((ref) {
  return MeetingNotifier(ref.read(apiServiceProvider));
});

final createMeetingProvider = StateNotifierProvider<CreateMeetingNotifier, CreateMeetingState>((ref) {
  return CreateMeetingNotifier(ref.read(apiServiceProvider));
});

class MeetingNotifier extends StateNotifier<MeetingListState> {
  final ApiService apiService;

  MeetingNotifier(this.apiService) : super(const MeetingListState());

  Future<void> getMeetings() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await apiService.getData('api/support/GetAllBookings');

      if (response!=null) {
        List<BoardRoomBookingModel> meetings=[];
        for(var i in response){
          meetings.add(BoardRoomBookingModel.fromJson(i));
        }

        state = state.copyWith(
          isLoading: false,
          data: meetings,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to load meetings: ${response?.statusCode}',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error loading meetings: $e',
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

class CreateMeetingNotifier extends StateNotifier<CreateMeetingState> {
  final ApiService apiService;

  CreateMeetingNotifier(this.apiService) : super(const CreateMeetingState());

  Future<bool> createMeeting(dynamic meeting) async {
    debugPrint('Sending data ${meeting}');
    state = state.copyWith(isLoading: true, error: null, isSuccess: false);

    try {
      final response = await apiService.postDataWithReturn('api/support/CreateBoardBooking', meeting);
      if (response['success'] == true) {
        state = state.copyWith(isLoading: false, isSuccess: true);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response['message'] ?? 'Failed to create meeting',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '$e',
      );
      return false;
    }
  }

  void clearError() {
    debugPrint('Clearing error - current error: ${state.error}');
    state = state.copyWith(error: null);
    debugPrint('Error after clearing: ${state.error}');
  }
}

