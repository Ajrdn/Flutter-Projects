import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_call/const/agora.dart';

class CamScreen extends StatefulWidget {
  const CamScreen({Key? key}) : super(key: key);

  @override
  State<CamScreen> createState() => _CamScreenState();
}

class _CamScreenState extends State<CamScreen> {
  RtcEngine? engine;
  int? uid = 0;
  int? otherUid;

  Future<bool> checkPermission() async {
    final resp = await [Permission.camera, Permission.microphone].request();

    final cameraPermission = resp[Permission.camera];

    final microphonePermission = resp[Permission.microphone];

    if(cameraPermission != PermissionStatus.granted ||
        microphonePermission != PermissionStatus.granted) {
      throw '카메라 또는 마이크 권한이 없습니다.';
    }

    if(engine == null) {
      engine = createAgoraRtcEngine();
      await engine!.initialize(const RtcEngineContext(appId: APP_ID));

      engine!.registerEventHandler(RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print('채널에 입장했습니다. uid: ${connection.localUid}');
          setState(() {
            uid = connection.localUid;
          });
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          print('채널에서 퇴장하였습니다.');
          setState(() {
            uid == null;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          print('상대가 채널에 입장했습니다. otherUid: $remoteUid');
          setState(() {
            otherUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          print('상대가 채널에서 나갔습니다. otherUid: $remoteUid');
          setState(() {
            otherUid = null;
          });
        },
      ));

      await engine!.enableVideo();
      await engine!.startPreview();

      ChannelMediaOptions options = const ChannelMediaOptions();

      await engine!.joinChannel(
        token: TEMP_TOKEN,
        channelId: CHANNEL_NAME,
        uid: 0,
        options: options,
      );
    }

    return true;
  }

  Widget renderMainView() {
    if(uid == null) return const Center(child: Text('채널에 참여해주세요.'));
    return AgoraVideoView(controller: VideoViewController(
      rtcEngine: engine!,
      canvas: const VideoCanvas(uid: 0),
    ));
  }

  Widget renderSubView() {
    if(otherUid == null) return const Center(child: Text('채널에 유저가 없습니다.'));
    return AgoraVideoView(controller: VideoViewController.remote(
      rtcEngine: engine!,
      canvas: VideoCanvas(uid: otherUid),
      connection: const RtcConnection(channelId: CHANNEL_NAME),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LIVE'),
      ),
      body: FutureBuilder<bool>(
          future: checkPermission(),
          builder: (context, snapshot) {
            if(snapshot.hasError)
              return Center(child: Text(snapshot.error.toString()));
            else if(!snapshot.hasData)
              return Center(child: CircularProgressIndicator());

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      renderMainView(),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          color: Colors.grey,
                          width: 120,
                          height: 160,
                          child: renderSubView(),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if(engine != null) {
                        await engine!.leaveChannel();
                        engine = null;
                      }
                      Navigator.of(context).pop();
                    },
                    child: const Text('채널 나가기'),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
