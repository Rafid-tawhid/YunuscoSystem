import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/providers/hr_provider.dart';
import 'package:yunusco_group/screens/HR&PayRoll/widgets/vehicle_accept_rej_screen.dart';
import '../../models/vehicle_model.dart';


class VehicleRequestListScreen extends StatefulWidget {

  const VehicleRequestListScreen({Key? key,}) : super(key: key);

  @override
  State<VehicleRequestListScreen> createState() => _VehicleRequestListScreenState();
}

class _VehicleRequestListScreenState extends State<VehicleRequestListScreen> {


  @override
  void initState() {

    getAllRequestedVehicles();
    super.initState();
  }

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
        child: Consumer<HrProvider>(
          builder: (context, pro, _) => pro.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pro.vehicleList.length,
            itemBuilder: (context, index) {
              // Sort the list in descending order (e.g., by `id`)
              final sortedList = List.from(pro.vehicleList)
                ..sort((a, b) => b.vehicleReqId.compareTo(a.vehicleReqId)); // Descending
              final vehicle = sortedList[index];
              return _buildVehicleCard(vehicle, context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleCard(VehicleModel vehicle, BuildContext context) {
    return InkWell(
      onTap: (){

        if(vehicle.status==1&&DashboardHelpers.currentUser!.iDnum=='38832'){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>VehicleApprovalScreen(vehicleModel: vehicle,)));
        }
      },
      child: Card(
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
                _buildDetailRow('Driver', vehicle.driverName??''),
                _buildDetailRow('Phone', vehicle.driverMobileNo??''),

                // if (vehicle.driverMobileNo != null&&vehicle.status==2)
                //   Row(
                //     children: [
                //       Expanded(child: _buildDetailRow('Driver', vehicle.driverName!)),
                //       if(vehicle.driverMobileNo!=null||vehicle.driverMobileNo!=''&&vehicle.status==2)TextButton(onPressed: (){
                //          DashboardHelpers.makePhoneCall(vehicle.driverMobileNo??'');
                //       }, child: Text('Call Driver ${vehicle.driverMobileNo}'))
                //     ],
                //   ),
              ],
            ],
          ),
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
      case 1:
        chipColor = Colors.orange;
        statusText = 'Pending';
        break;
      case 2:
        chipColor = Colors.green;
        statusText = 'Approved';
        break;
      case 3:
        chipColor = Colors.red;
        statusText = 'Rejected';
        break;
      case 4:
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

  void getAllRequestedVehicles() async{
    var hp=context.read<HrProvider>();
    await hp.getRequestedCarList();
  }
}