import 'package:flutter/cupertino.dart';
import 'package:yunusco_group/models/board_room_booking_model.dart';
import 'package:yunusco_group/providers/riverpods/purchase_order_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// Separate providers for each API
final allBookingsProvider = FutureProvider<List<BoardRoomBookingModel>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  final response = await apiService.getData('api/support/GetAllBookings');

  if (response != null) {
    List<BoardRoomBookingModel> bookings = [];
    for (var item in response) {
      bookings.add(BoardRoomBookingModel.fromJson(item));
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
      bookings.add(BoardRoomBookingModel.fromJson(item));
    }
    return bookings;
  } else {
    throw Exception('Failed to load today\'s bookings');
  }
});



