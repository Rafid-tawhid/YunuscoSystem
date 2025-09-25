import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/approval_Supply_model.dart';
import '../models/puchaseMasterModelFirebase.dart';

class PurchaseProvider extends ChangeNotifier {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get requisitionMasters => _firestore.collection('requisition_masters');
  CollectionReference get requisitionDetails => _firestore.collection('requisition_details');

  // Save requisition data to Firebase
  Future<Map<String, dynamic>> saveRequisition({
    required Map<String, dynamic> requisitionData,
  }) async {
    try {
      // Generate unique requisition ID
      final String reqId = _generateUniqueId();

      // Extract master data
      final Map<String, dynamic> masterData = requisitionData['requisitionMaster'];
      masterData['reqId'] = reqId;
      masterData['createdAt'] = DateTime.now().toIso8601String();

      // Extract details data
      final List<dynamic> detailsData = requisitionData['requisitionDetails'];

      // Save master data
      await _saveRequisitionMaster(masterData, reqId);

      // Save details data
      await _saveRequisitionDetails(detailsData, reqId);

      return {
        'success': true,
        'message': 'Requisition saved successfully',
        'reqId': reqId,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error saving requisition: $e',
        'reqId': '',
      };
    }
  }

  // Save requisition master data
  Future<void> _saveRequisitionMaster(Map<String, dynamic> masterData, String reqId) async {
    await requisitionMasters.doc(reqId).set(masterData);
  }

  // Save requisition details data
  Future<void> _saveRequisitionDetails(List<dynamic> detailsData, String reqId) async {
    final batch = _firestore.batch();

    for (var detail in detailsData) {
      // Add reqId to each detail
      detail['reqId'] = reqId;

      // Create document reference with productId
      final docRef = requisitionDetails
          .doc(reqId)
          .collection('products')
          .doc('product_${detail['productId']}');

      batch.set(docRef, detail);
    }

    await batch.commit();
  }

  // Generate unique ID
  String _generateUniqueId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${UniqueKey().toString().substring(2, 8)}';
  }

  // Get requisition by ID
  Future<Map<String, dynamic>> getRequisitionById(String reqId) async {
    try {
      // Get master data
      final masterDoc = await requisitionMasters.doc(reqId).get();
      if (!masterDoc.exists) {
        throw Exception('Requisition not found');
      }

      // Get details data
      final detailsSnapshot = await requisitionDetails
          .doc(reqId)
          .collection('products')
          .get();

      final List<RequisitionDetail> details = detailsSnapshot.docs
          .map((doc) => RequisitionDetail.fromMap(doc.data()))
          .toList();

      return {
        'requisitionMaster': PuchaseMasterModelFirebase.fromMap(masterDoc.data() as Map<String,dynamic>),
        'requisitionDetails': details,
      };
    } catch (e) {
      throw Exception('Error fetching requisition: $e');
    }
  }


  // Get all requisitions with their details
  Future<List<Map<String, dynamic>>> getAllRequisitionsWithDetails() async {
    try {
      final masterSnapshot = await requisitionMasters
          .orderBy('createdAt', descending: true)
          .get();

      List<Map<String, dynamic>> requisitions = [];

      for (var masterDoc in masterSnapshot.docs) {
        final masterData = PuchaseMasterModelFirebase.fromMap(masterDoc.data() as Map<String,dynamic>);

        // Get details for this requisition
        final detailsSnapshot = await requisitionDetails
            .doc(masterData.reqId)
            .collection('products')
            .get();

        final List<RequisitionDetail> details = detailsSnapshot.docs
            .map((doc) => RequisitionDetail.fromMap(doc.data()))
            .toList();

        requisitions.add({
          'master': masterData,
          'details': details,
        });
      }

      return requisitions;
    } catch (e) {
      throw Exception('Error fetching requisitions: $e');
    }
  }

  // Update approval status
  Future<void> updateApprovalStatus({
    required String reqId,
    required String status, // 'approved' or 'rejected'
    required String approvedBy,
  }) async {
    try {
      await requisitionMasters.doc(reqId).update({
        'approval': status,
        'approvedBy': approvedBy,
        'approvedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error updating approval status: $e');
    }
  }

  // Get requisitions by status
  Future<List<Map<String, dynamic>>> getRequisitionsByStatus(String status) async {
    try {
      final masterSnapshot = await requisitionMasters
          .where('approval', isEqualTo: status)
          .orderBy('createdAt', descending: true)
          .get();

      List<Map<String, dynamic>> requisitions = [];

      for (var masterDoc in masterSnapshot.docs) {
        final masterData = PuchaseMasterModelFirebase.fromMap(masterDoc.data() as Map<String,dynamic>);

        final detailsSnapshot = await requisitionDetails
            .doc(masterData.reqId)
            .collection('products')
            .get();

        final List<RequisitionDetail> details = detailsSnapshot.docs
            .map((doc) => RequisitionDetail.fromMap(doc.data()))
            .toList();

        requisitions.add({
          'master': masterData,
          'details': details,
        });
      }

      return requisitions;
    } catch (e) {
      throw Exception('Error fetching requisitions by status: $e');
    }
  }



  // Save supply chain record
  Future<void> saveSupplyChainRecord(SupplyChainRecord record) async {
    try {
      await _firestore.collection('supply_chain_records').doc(record.id).set(record.toMap());
    } catch (e) {
      throw Exception('Error saving supply chain record: $e');
    }
  }

  // Check if supply chain record already exists for product
  Future<bool> checkExistingSupplyRecord(String reqId, String productId) async {
    try {
      final snapshot = await _firestore.collection('supply_chain_records')
          .where('reqId', isEqualTo: reqId)
          .where('productId', isEqualTo: productId)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Update this method in your FirebaseService class
  Future<List<ApprovedRequisition>> getApprovedRequisitions() async {
    try {
      // Get ALL requisitions first (without approval filter)
      final masterSnapshot = await requisitionMasters
          .orderBy('createdAt', descending: true)
          .get();

      // Filter approved requisitions locally in memory
      final approvedMasters = masterSnapshot.docs
          .where((doc) => ((doc.data() as Map<String,dynamic>)['approval'] ?? '') == 'approved')
          .toList();

      List<ApprovedRequisition> approvedRequisitions = [];

      for (var masterDoc in approvedMasters) {
        final masterData = PuchaseMasterModelFirebase.fromMap(masterDoc.data() as Map<String,dynamic>);

        final detailsSnapshot = await requisitionDetails
            .doc(masterData.reqId)
            .collection('products')
            .get();

        final List<RequisitionDetail> details = detailsSnapshot.docs
            .map((doc) => RequisitionDetail.fromMap(doc.data()))
            .toList();

        approvedRequisitions.add(ApprovedRequisition(
          reqId: masterData.reqId,
          master: masterData,
          details: details,
        ));
      }

      return approvedRequisitions;
    } catch (e) {
      throw Exception('Error fetching approved requisitions: $e');
    }
  }


  Future<List<SupplyChainRecord>> getAllSupplyChainRecords() async {
    try {
      final snapshot = await _firestore.collection('supply_chain_records')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => SupplyChainRecord.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error fetching supply chain records: $e');
    }
  }

  // Get supply chain records by status
  Future<List<SupplyChainRecord>> getSupplyChainRecordsByStatus(String status) async {
    try {
      final snapshot = await _firestore.collection('supply_chain_records')
          .where('status', isEqualTo: status)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => SupplyChainRecord.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error fetching records by status: $e');
    }
  }


}