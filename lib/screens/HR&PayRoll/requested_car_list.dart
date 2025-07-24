import 'package:flutter/material.dart';
import '../../models/vehicle_model.dart';


class VehicleRequestListScreen extends StatelessWidget {
  final List<VehicleModel> vehicles;

  const VehicleRequestListScreen({Key? key, required this.vehicles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Vehicle Requests'),
        centerTitle: true,
        elevation: 0,

      ),
      body: Container(
        decoration: BoxDecoration(

        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: vehicles.length,
          itemBuilder: (context, index) {
            final vehicle = vehicles[index];
            return _buildVehicleCard(vehicle, context);
          },
        ),
      ),
    );
  }

  Widget _buildVehicleCard(VehicleModel vehicle, BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Request #${vehicle.vehicleReqId}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                _buildStatusChip(vehicle.status),
              ],
            ),
            const SizedBox(height: 12),
            _buildDetailRow('From', vehicle.destinationFrom ?? 'N/A'),
            _buildDetailRow('To', vehicle.destinationTo ?? 'N/A'),
            _buildDetailRow('Date', vehicle.requiredDate ?? 'N/A'),
            _buildDetailRow('Time', vehicle.requiredTime ?? 'N/A'),
            _buildDetailRow('Distance',  '${vehicle.distance} km'),
            _buildDetailRow('Purpose', vehicle.purpose ?? 'N/A'),
            _buildDetailRow('Duration','${vehicle.duration} hr'),
            if (vehicle.vehicleNo != null) ...[
              const SizedBox(height: 8),
              Divider(color: Colors.grey[300]),
              const SizedBox(height: 8),
              _buildDetailRow('Vehicle No', vehicle.vehicleNo!),
              if (vehicle.driverName != null)
                _buildDetailRow('Driver', vehicle.driverName!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(num? status) {
    Color chipColor;
    String statusText;

    switch (status) {
      case 0:
        chipColor = Colors.orange;
        statusText = 'Pending';
        break;
      case 1:
        chipColor = Colors.green;
        statusText = 'Approved';
        break;
      case 2:
        chipColor = Colors.red;
        statusText = 'Rejected';
        break;
      case 3:
        chipColor = Colors.blue;
        statusText = 'Completed';
        break;
      default:
        chipColor = Colors.grey;
        statusText = 'Unknown';
    }

    return Chip(
      label: Text(
        statusText,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: chipColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}