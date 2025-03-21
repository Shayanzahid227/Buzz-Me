// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_callkeep/flutter_callkeep.dart';
// import 'package:uuid/uuid.dart';
// import 'package:flutter/material.dart';
// import '../repositories/call_repository.dart';
// import '../models/call.dart';
// import '../services/notification_service.dart';
// import 'package:flutter/services.dart';

// class CallService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final CallRepository _callRepository = CallRepository();
//   final NotificationService _notificationService = NotificationService();
//   bool _callKeepInitialized = false;
//   final GlobalKey<NavigatorState> navigatorKey;
//   Call? _currentCall;

//   CallService({required this.navigatorKey});

//   Future<void> initialize() async {
//     // Configure flutter_callkeep
//     if (!_callKeepInitialized) {
//       try {
//         final config = CallKeepConfig(
//           appName: 'Buzz Me',
//           android: CallKeepAndroidConfig(
//             logo: '',
//             notificationIcon: 'mipmap/ic_notification_launcher',
//             ringtoneFileName: 'system_ringtone_default',
//             accentColor: '#0955fa',
//             incomingCallNotificationChannelName: 'Incoming Calls',
//             missedCallNotificationChannelName: 'Missed Calls',
//             showMissedCallNotification: true,
//             showCallBackAction: true,
//           ),
//           ios: CallKeepIosConfig(
//             iconName: 'CallKitLogo',
//             maximumCallGroups: 2,
//             maximumCallsPerCallGroup: 1,
//           ),
//           headers: <String, dynamic>{}, // Add any headers needed here
//         );

//         CallKeep.instance.configure(config);
//         _callKeepInitialized = true;

//         // Register event handlers
//         _registerCallKeepEventHandlers();
//       } catch (e) {
//         print('Error initializing CallKeep: $e');
//       }
//     }

//     // Handle incoming call notifications
//     FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
//     FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
//   }

//   void _registerCallKeepEventHandlers() {
//     CallKeep.instance.handler = CallEventHandler(
//       onCallAccepted: _handleAnswerCall,
//       onCallEnded: _handleEndCallEvent,
//       onCallDeclined: _handleDeclineCall,
//     );
//   }

//   // Make a call
//   Future<void> makeCall({
//     required String callerId,
//     required String callerName,
//     required String receiverId,
//     required String receiverName,
//     required String receiverFcmToken,
//     required String callType,
//   }) async {
//     final callerFcmToken = await getFCMToken();
//     if (callerFcmToken == null) return;

//     final call = await _callRepository.createCall(
//       callerId: callerId,
//       callerName: callerName,
//       callerFcmToken: callerFcmToken,
//       receiverId: receiverId,
//       receiverName: receiverName,
//       receiverFcmToken: receiverFcmToken,
//       callType: callType,
//     );

//     _currentCall = call;

//     // Start an outgoing call with CallKeep
//     final callEvent = CallEvent(
//       uuid: call.callId,
//       callerName: callerName,
//       handle: call.receiverId,
//       hasVideo: callType == 'video',
//       extra: <String, dynamic>{
//         'callerId': callerId,
//         'receiverId': receiverId,
//         'callType': callType,
//       },
//     );

//     await CallKeep.instance.startCall(callEvent);

//     // Send notification to receiver
//     await _notificationService.sendCallNotification(
//       recipientToken: receiverFcmToken,
//       callerName: callerName,
//       callerId: callerId,
//       callType: callType,
//       callId: call.callId,
//     );

//     // Listen to call updates
//     _listenToCallUpdates(call.callId);
//   }

//   // Listen to call updates
//   void _listenToCallUpdates(String callId) {
//     _callRepository.getCallStream(callId).listen((call) {
//       if (call == null) return;

//       _currentCall = call;
//       switch (call.status) {
//         case 'rejected':
//           _handleCallRejected(call);
//           break;
//         case 'ended':
//           _handleCallEnded(call);
//           break;
//         case 'ongoing':
//           // Handle call accepted
//           break;
//       }
//     });
//   }

//   // Handle when a call is rejected
//   void _handleCallRejected(Call call) async {
//     await _notificationService.sendCallRejectedNotification(
//       recipientToken: call.callerFcmToken,
//       callId: call.callId,
//     );
//     _currentCall = null;
//   }

//   // Handle when a call is ended
//   void _handleCallEnded(Call call) async {
//     await _notificationService.sendCallEndedNotification(
//       recipientToken: call.receiverFcmToken,
//       callId: call.callId,
//     );
//     _currentCall = null;
//     Navigator.of(navigatorKey.currentContext!)
//         .popUntil((route) => route.isFirst);
//   }

//   static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
//     if (message.data['type'] == 'call') {
//       final String callId = message.data['callId'];
//       final bool hasVideo = message.data['callType'] == 'video';

//       final callEvent = CallEvent(
//         uuid: callId,
//         callerName: message.data['callerName'] ?? 'Unknown',
//         handle: message.data['callerName'] ?? 'Unknown',
//         hasVideo: hasVideo,
//         extra: <String, dynamic>{
//           'callerId': message.data['callerId'],
//           'callType': message.data['callType'],
//         },
//       );

//       await CallKeep.instance.displayIncomingCall(callEvent);
//     }
//   }

//   Future<void> _handleForegroundMessage(RemoteMessage message) async {
//     if (message.data['type'] == 'call') {
//       final String callId = message.data['callId'];
//       final bool hasVideo = message.data['callType'] == 'video';

//       final callEvent = CallEvent(
//         uuid: callId,
//         callerName: message.data['callerName'] ?? 'Unknown',
//         handle: message.data['callerName'] ?? 'Unknown',
//         hasVideo: hasVideo,
//         extra: <String, dynamic>{
//           'callerId': message.data['callerId'],
//           'callType': message.data['callType'],
//         },
//       );

//       await CallKeep.instance.displayIncomingCall(callEvent);

//       // Start listening to call updates
//       _listenToCallUpdates(callId);
//     }
//   }

//   void _handleAnswerCall(CallEvent event) async {
//     if (_currentCall == null) {
//       // If current call is null, try to fetch call details from callId
//       final callId = event.uuid;
//       try {
//         final call = await _callRepository.getCallStream(callId).first;
//         if (call != null) {
//           _currentCall = call;
//         } else {
//           return;
//         }
//       } catch (e) {
//         print('Error fetching call: $e');
//         return;
//       }
//     }

//     // Update call status to ongoing
//     await _callRepository.updateCallStatus(_currentCall!.callId, 'ongoing');

//     // Navigate to appropriate call screen based on call type
//     final context = navigatorKey.currentContext!;
//     if (_currentCall!.callType == 'video') {
//       Navigator.pushNamed(context, '/video-call', arguments: _currentCall);
//     } else {
//       Navigator.pushNamed(context, '/audio-call', arguments: _currentCall);
//     }
//   }

//   void _handleEndCallEvent(CallEvent event) async {
//     await endCall(event.uuid);
//   }

//   void _handleDeclineCall(CallEvent event) async {
//     await rejectCall(event.uuid);
//   }

//   Future<void> endCall(String callId) async {
//     // End the call in CallKeep
//     await CallKeep.instance.endCall(callId);

//     // Update call in repository
//     await _callRepository.endCall(callId);

//     if (_currentCall?.callId == callId) {
//       _currentCall = null;
//     }

//     // Return to home screen
//     if (navigatorKey.currentContext != null) {
//       Navigator.of(navigatorKey.currentContext!)
//           .popUntil((route) => route.isFirst);
//     }
//   }

//   Future<void> endCurrentCall() async {
//     if (_currentCall == null) return;
//     await endCall(_currentCall!.callId);
//   }

//   Future<void> rejectCall(String callId) async {
//     // Reject the call in CallKeep
//     await CallKeep.instance
//         .endCall(callId); // Using endCall as rejectCall isn't available

//     // Update call in repository
//     await _callRepository.rejectCall(callId);

//     if (_currentCall?.callId == callId) {
//       _currentCall = null;
//     }
//   }

//   Future<void> rejectCurrentCall() async {
//     if (_currentCall == null) return;
//     await rejectCall(_currentCall!.callId);
//   }

//   Future<String?> getFCMToken() async {
//     return await _firebaseMessaging.getToken();
//   }

//   Call? get currentCall => _currentCall;
// }
