import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import '/flutter_flow/flutter_flow_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Replace this with your Agora App ID from https://console.agora.io
// Create a free account → New Project → App ID (Testing mode, no certificate)
// ─────────────────────────────────────────────────────────────────────────────
const String _agoraAppId = 'YOUR_AGORA_APP_ID';

class InAppCallWidget extends StatefulWidget {
  const InAppCallWidget({
    super.key,
    required this.channelName, // use rideId as channel so only these two join
    required this.callerName,  // name shown on the other person's screen
    required this.receiverName,
    this.token = '', // leave empty for testing mode
  });

  final String channelName;
  final String callerName;
  final String receiverName;
  final String token;

  @override
  State<InAppCallWidget> createState() => _InAppCallWidgetState();
}

class _InAppCallWidgetState extends State<InAppCallWidget> {
  RtcEngine? _engine;
  bool _joined = false;
  bool _muted = false;
  bool _speakerOn = true;
  bool _otherJoined = false;
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _engine?.leaveChannel();
    _engine?.release();
    super.dispose();
  }

  Future<void> _initAgora() async {
    if (_agoraAppId == 'YOUR_AGORA_APP_ID') {
      setState(() => _error =
          'Agora App ID not configured.\nGet a free one at console.agora.io\nthen set _agoraAppId in in_app_call_widget.dart');
      return;
    }

    // Request microphone permission
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      setState(() => _error = 'Microphone permission denied.');
      return;
    }

    _engine = createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(appId: _agoraAppId));

    _engine!.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (connection, elapsed) {
        if (!mounted) return;
        setState(() => _joined = true);
        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
          if (!mounted) return;
          setState(() => _elapsed += const Duration(seconds: 1));
        });
      },
      onUserJoined: (connection, remoteUid, elapsed) {
        if (!mounted) return;
        setState(() => _otherJoined = true);
      },
      onUserOffline: (connection, remoteUid, reason) {
        if (!mounted) return;
        setState(() => _otherJoined = false);
        // Auto-end call when other party hangs up
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) Navigator.of(context).pop();
        });
      },
      onError: (err, msg) {
        if (!mounted) return;
        setState(() => _error = 'Call error: $msg');
      },
    ));

    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine!.enableAudio();
    await _engine!.setEnableSpeakerphone(_speakerOn);

    await _engine!.joinChannel(
      token: widget.token,
      channelId: widget.channelName,
      uid: 0,
      options: const ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileCommunication,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        publishMicrophoneTrack: true,
        autoSubscribeAudio: true,
      ),
    );
  }

  void _toggleMute() async {
    _muted = !_muted;
    await _engine?.muteLocalAudioStream(_muted);
    setState(() {});
  }

  void _toggleSpeaker() async {
    _speakerOn = !_speakerOn;
    await _engine?.setEnableSpeakerphone(_speakerOn);
    setState(() {});
  }

  void _endCall() async {
    await _engine?.leaveChannel();
    if (mounted) Navigator.of(context).pop();
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: _error != null
            ? _buildError(theme)
            : _buildCallUI(theme),
      ),
    );
  }

  Widget _buildError(dynamic theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallUI(dynamic theme) {
    return Column(
      children: [
        const SizedBox(height: 40),

        // Status chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: _otherJoined
                ? Colors.green.withOpacity(0.2)
                : Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _otherJoined ? Colors.green : Colors.white24,
            ),
          ),
          child: Text(
            !_joined
                ? 'Connecting…'
                : _otherJoined
                    ? _formatDuration(_elapsed)
                    : 'Calling…',
            style: GoogleFonts.inter(
              color: _otherJoined ? Colors.greenAccent : Colors.white54,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),

        const Spacer(),

        // Avatar
        Container(
          width: 100,
          height: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.primary.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: _otherJoined ? theme.primary : Colors.white24,
              width: 2,
            ),
          ),
          child: Text(
            widget.receiverName.isNotEmpty
                ? widget.receiverName[0].toUpperCase()
                : '?',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 20),

        Text(
          widget.receiverName,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          !_joined
              ? 'Connecting to call…'
              : _otherJoined
                  ? 'On call'
                  : 'Waiting for ${widget.receiverName.split(' ').first}…',
          style: GoogleFonts.inter(
            color: Colors.white54,
            fontSize: 14,
          ),
        ),

        const Spacer(),

        // Control buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _CtrlBtn(
                icon: _muted ? Icons.mic_off_rounded : Icons.mic_rounded,
                label: _muted ? 'Unmute' : 'Mute',
                color: _muted ? Colors.red : Colors.white,
                bgColor: Colors.white.withOpacity(0.1),
                onTap: _toggleMute,
              ),
              // End call — large red button
              GestureDetector(
                onTap: _endCall,
                child: Container(
                  width: 70,
                  height: 70,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE32023),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.call_end_rounded,
                      color: Colors.white, size: 30),
                ),
              ),
              _CtrlBtn(
                icon: _speakerOn
                    ? Icons.volume_up_rounded
                    : Icons.volume_off_rounded,
                label: _speakerOn ? 'Speaker' : 'Earpiece',
                color: _speakerOn ? theme.primary : Colors.white,
                bgColor: Colors.white.withOpacity(0.1),
                onTap: _toggleSpeaker,
              ),
            ],
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}

class _CtrlBtn extends StatelessWidget {
  const _CtrlBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white54,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
