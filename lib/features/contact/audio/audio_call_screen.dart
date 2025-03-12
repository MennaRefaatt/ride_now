import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/services/network/api_constants.dart';
import '../../../core/theming/app_colors.dart';

class AudioCallScreen extends StatefulWidget {
  const AudioCallScreen({
    super.key,
  });
  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool _callEnded = false;

  @override
  void initState() {
    super.initState();
    initAgora();
    listenForCallkitEvents();
  }

  Future<void> initAgora() async {
    await [Permission.microphone].request();
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
      appId: AgoraConstants.appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _callEnded = false;
            _localUserJoined = true;
          });        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
            _callEnded = false;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
            _callEnded = true;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableAudio();

    await _engine.joinChannel(
      token: AgoraConstants.token,
      channelId: AgoraConstants.channelId,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  void listenForCallkitEvents() async {
    FlutterCallkitIncoming.onEvent.listen((CallEvent? event) {
      if (event != null) {
        debugPrint('Event: ${event.toString()}');
        switch (event.event) {
          case Event.actionCallAccept:
          // تحقق من محتويات الـ event
            _joinCall(AgoraConstants.channelId);
            break;
          case Event.actionCallDecline:
          case Event.actionCallEnded:
          // معالجة رفض المكالمة أو نهايتها
            break;
          default:
            break;
        }
      }
    });
  }

  void _joinCall(String channelId) {
    _engine.joinChannel(
      token: AgoraConstants.token,
      channelId: channelId,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
        child: _callEnded
            ? const Text(
                'Call ended',
                style: TextStyle(fontSize: 24, color: Colors.white),
                textAlign: TextAlign.center,
              )
            : _localUserJoined && _remoteUid != null
                ? Text(
                    'Calling...\n${_remoteUid != null ? '$_remoteUid' : ''}',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  )
                : const Text(
                    'Ringing...',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
      ),
      floatingActionButton: _callEnded
          ? FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () {
                setState(() {
                  _callEnded = false;
                  _remoteUid = null;
                  _localUserJoined = false;
                  initAgora();
                });
              },
              backgroundColor: AppColors.primary,
              child: const Icon(
                CupertinoIcons.phone,
                color: Colors.white,
              ),
            )
          : FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () {
                setState(() {
                  _engine.leaveChannel();
                  _callEnded = true;
                  _localUserJoined = false;
                  _remoteUid = null;
                });
              },
              backgroundColor: AppColors.red,
              child: const Icon(
                CupertinoIcons.phone_down,
                color: Colors.white,
              ),
            ),
    );
  }
}
