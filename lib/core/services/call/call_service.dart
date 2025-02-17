import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

class CallService {
  static Future<void> showIncomingCall(String callerName, String channelId) async {
    final params = CallKitParams(
      id: channelId,
      nameCaller: callerName,
      appName: 'RideNow',
      avatar: 'https://your-image-url.com/avatar.png',
      handle: 'Audio Call',
      type: 0,
      duration: 30000,
      textAccept: 'Answer',
      textDecline: 'Decline',
      extra: {'channelId': channelId},
      android: AndroidParams(
          isCustomNotification: true,
          isShowLogo: false,
          ringtonePath: 'system_ringtone_default',
          backgroundColor: '#0955fa',
          backgroundUrl: 'https://i.pravatar.cc/500',
          actionColor: '#4CAF50',
          textColor: '#ffffff',
          incomingCallNotificationChannelName: "Incoming Call",
          missedCallNotificationChannelName: "Missed Call",
          isShowCallID: false
      ),
      ios: IOSParams(
        supportsVideo: false,
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }
}
