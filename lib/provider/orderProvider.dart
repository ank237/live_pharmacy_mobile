import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:live_pharmacy/models/agentModel.dart';
import 'package:live_pharmacy/models/orderModel.dart';

class OrderProvider extends ChangeNotifier {
  OrderModel newOrder;
  FirebaseFirestore _db = FirebaseFirestore.instance;
  bool isSaving = false;
  List<AgentModel> agentList = [];

  void toggleIsLoading() {
    isSaving = !isSaving;
    notifyListeners();
  }

  Future<void> fetchAgents() async {
    agentList.clear();
    var res = await _db.collection('users').get();
    for (var d in res.docs) {
      if (d['role'] == 'agent') {
        agentList.add(
          AgentModel(
            name: d['name'],
            phone: d['phone'],
            docId: d.id,
          ),
        );
      }
    }
    notifyListeners();
  }

  Future<void> assignAgent(String orderId, String agentId, String agentName) async {
    toggleIsLoading();
    await _db.collection('orders').doc(orderId).update(
      {
        'delivered_by': agentId,
        'agent_name': agentName,
      },
    );
    await _db.collection('users').doc(agentId).collection('deliveries').add({
      'order_id': orderId,
      'date': DateTime.now(),
    });
    toggleIsLoading();
    notifyListeners();
  }

  Future<void> saveNewOrder() async {
    toggleIsLoading();
    await _db.collection('orders').add({
      'name': newOrder.name,
      'address': newOrder.address,
      'phone': newOrder.phoneNumber,
      'order_details': newOrder.orderDetails,
      'amount': newOrder.amount,
      'delivery_date': newOrder.date,
      'is_repeating': newOrder.isRepeating,
      'is_delivered': newOrder.isDelivered,
      'delivered_by': newOrder.deliveredBy,
      'delivered_on': newOrder.deliveredOn,
      'mode_of_payment': newOrder.modeOfPayment,
      'is_paid': newOrder.isPaid,
      'order_created_date': newOrder.orderCreatedDate,
    });
    toggleIsLoading();
    notifyListeners();
  }
}
