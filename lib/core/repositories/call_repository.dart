import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/call.dart';
import '../services/agora_service.dart';

class CallRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AgoraService _agoraService = AgoraService();

  // Create a new call
  Future<Call> createCall({
    required String callerId,
    required String callerName,
    required String callerFcmToken,
    required String receiverId,
    required String receiverName,
    required String receiverFcmToken,
    required String callType,
  }) async {
    final String callId = const Uuid().v4();
    final String channelName = '${callerId}_${receiverId}_$callId';
    final String token = await _agoraService.generateToken(channelName);

    final Call call = Call(
      callId: callId,
      callerId: callerId,
      callerName: callerName,
      callerFcmToken: callerFcmToken,
      receiverId: receiverId,
      receiverName: receiverName,
      receiverFcmToken: receiverFcmToken,
      channelName: channelName,
      token: token,
      callType: callType,
      status: 'pending',
      createdAt: DateTime.now(),
      participants: [callerId, receiverId],
    );

    await _firestore.collection('calls').doc(callId).set(call.toMap());
    return call;
  }

  // Get call stream
  Stream<Call?> getCallStream(String callId) {
    return _firestore.collection('calls').doc(callId).snapshots().map(
        (snapshot) => snapshot.exists ? Call.fromMap(snapshot.data()!) : null);
  }

  // Get active call stream for a user
  Stream<Call?> getActiveCallStream(String userId) {
    return _firestore
        .collection('calls')
        .where('status', whereIn: ['pending', 'ongoing'])
        .where('participants', arrayContains: userId)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty
            ? Call.fromMap(snapshot.docs.first.data())
            : null);
  }

  // Update call status
  Future<void> updateCallStatus(String callId, String status) async {
    await _firestore.collection('calls').doc(callId).update({
      'status': status,
      if (status == 'ended') 'endedAt': DateTime.now().toIso8601String(),
    });
  }

  // End call
  Future<void> endCall(String callId) async {
    await updateCallStatus(callId, 'ended');
  }

  // Reject call
  Future<void> rejectCall(String callId) async {
    await updateCallStatus(callId, 'rejected');
  }
}
