import 'package:flutter/cupertino.dart';
import 'package:yunusco_group/models/JobCardDropdownModel.dart';
import 'package:yunusco_group/models/board_room_booking_model.dart';
import 'package:yunusco_group/providers/riverpods/purchase_order_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:yunusco_group/service_class/api_services.dart';
import 'package:yunusco_group/utils/constants.dart';


// Separate providers for each API
final allBookingsProvider = FutureProvider<List<BoardRoomBookingModel>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  final response = await apiService.getData('api/support/GetAllBookings');

  if (response != null) {
    List<BoardRoomBookingModel> bookings = [];
    for (var item in response) {
      var data= BoardRoomBookingModel.fromJson(item);
      if(isPastDateTime(data.endTime.toString())){
        data.status='completed' ;
      }
      if(data.status!='cancelled'){
        bookings.add(data);
      }
    }
    return bookings;
  } else {
    throw Exception('Failed to load bookings');
  }
});

final todaysBookingsProvider = FutureProvider<List<BoardRoomBookingModel>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  final response = await apiService.getData('api/support/today');

  if (response != null) {
    List<BoardRoomBookingModel> bookings = [];
    for (var item in response) {
     var data= BoardRoomBookingModel.fromJson(item);
     if(isPastDateTime(data.endTime.toString())){
       data.status='completed' ;
     }
     if(data.status!='cancelled'){
       bookings.add(data);
     }


    }
    return bookings;
  } else {
    throw Exception('Failed to load today\'s bookings');
  }
});


bool isPastDateTime(String dateTimeString) {
  try {
    final dateTime = DateTime.parse(dateTimeString);
    final now = DateTime.now();
    return now.isAfter(dateTime);
  } catch (e) {
    print('Invalid date format: $e');
    return false;
  }
}

final selectedDeptProvider = StateProvider<Departments?>((ref) => null);

final allDeptList=FutureProvider<List<Departments>>((ref) async {

  final apiService = ref.read(apiServiceProvider);
  final response = await apiService.getData('api/HR/SalaryReportDropDown');

  if (response != null) {
    //Result
    List<Departments> allDept = [];
    for (var item in response['Result']['Departments']) {
      allDept.add(Departments.fromJson(item));
    }

    debugPrint('allDept ${allDept.length}');
    return allDept;
  } else {
    throw Exception('Failed to load bookings');
  }
});


// Delete provider
final deleteProvider = StateProvider<bool>((ref) => false);


// Update provider
final updateProvider = StateProvider<bool>((ref) => false);

// Update meeting decisions function
void updateMeetingDecisions(WidgetRef ref, String bookingId, String decisions) async {
  try {
    final apiService = ref.read(apiServiceProvider);

    final response = await apiService.patchData(
        'api/support/UpdateBoardBooking/$bookingId',
        {'Decisions': decisions}
    );

    if (response != null && response.statusCode == 200) {
      ref.read(updateProvider.notifier).state = true; // Success

      // Invalidate the bookings providers to refresh the data
      ref.invalidate(todaysBookingsProvider);
      ref.invalidate(allBookingsProvider);

    } else {
      throw Exception('Update failed with status: ${response?.statusCode}');
    }
  } catch (e) {
    print('Update error: $e');
    rethrow;
  }
}

// Delete function
void deleteItem(WidgetRef ref, String id) async {
  try {
    final apiService = ref.read(apiServiceProvider);
    await apiService.deleteData('${AppConstants.baseUrl}api/support/CancelBoardBooking/$id');
    ref.read(deleteProvider.notifier).state = true; // Success
  } catch (e) {
    print('Delete error: $e');
  }
}
