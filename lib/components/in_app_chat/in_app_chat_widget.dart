import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/backend/socket_service.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class InAppChatWidget extends StatefulWidget {
  const InAppChatWidget({
    super.key,
    required this.rideId,
    required this.myId,
    required this.myName,
    required this.myRole,   // 'driver' or 'passenger'
    required this.otherId,
    required this.otherName,
    required this.otherRole, // 'driver' or 'passenger'
  });

  final String rideId;
  final String myId;
  final String myName;
  final String myRole;
  final String otherId;
  final String otherName;
  final String otherRole;

  @override
  State<InAppChatWidget> createState() => _InAppChatWidgetState();
}

class _InAppChatWidgetState extends State<InAppChatWidget> {
  final List<_ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final FocusNode _focusNode = FocusNode();
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    // Listen for incoming messages
    final prev = SocketService().onChatMessage;
    SocketService().onChatMessage = (data) {
      prev?.call(data);
      if (!mounted) return;
      final map = data is Map ? data : {};
      final rideId = map['rideId']?.toString() ?? '';
      if (rideId != widget.rideId) return;
      setState(() {
        _messages.add(_ChatMessage(
          text: map['message']?.toString() ?? '',
          senderName: map['senderName']?.toString() ?? widget.otherName,
          isMine: false,
          timestamp: DateTime.fromMillisecondsSinceEpoch(
              (map['timestamp'] as num?)?.toInt() ??
                  DateTime.now().millisecondsSinceEpoch),
        ));
      });
      _scrollToBottom();
    };
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    _focusNode.dispose();
    // Restore previous callback
    SocketService().onChatMessage = null;
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    final msg = _ChatMessage(
      text: text,
      senderName: widget.myName,
      isMine: true,
      timestamp: DateTime.now(),
    );
    setState(() => _messages.add(msg));
    _scrollToBottom();

    SocketService().sendChatMessage(
      rideId: widget.rideId,
      toId: widget.otherId,
      toRole: widget.otherRole,
      message: text,
      senderName: widget.myName,
      senderId: widget.myId,
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _timeLabel(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String _initials(String name) {
    final p = name.trim().split(' ');
    if (p.length >= 2) return '${p[0][0]}${p[1][0]}'.toUpperCase();
    if (p.isNotEmpty && p[0].isNotEmpty) return p[0][0].toUpperCase();
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondaryBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: theme.primaryText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Text(
                _initials(widget.otherName),
                style: GoogleFonts.inter(
                  color: theme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.otherName,
                  style: GoogleFonts.inter(
                    color: theme.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.otherRole == 'driver' ? 'Your Driver' : 'Passenger',
                  style: GoogleFonts.inter(
                    color: theme.secondaryText,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: theme.alternate),
        ),
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.chat_bubble_outline_rounded,
                            size: 48, color: theme.alternate),
                        const SizedBox(height: 12),
                        Text(
                          'Say hello to ${widget.otherName.split(' ').first}',
                          style: GoogleFonts.inter(
                            color: theme.secondaryText,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    itemCount: _messages.length,
                    itemBuilder: (_, i) => _MessageBubble(
                      msg: _messages[i],
                      timeLabel: _timeLabel(_messages[i].timestamp),
                      theme: theme,
                    ),
                  ),
          ),

          // Divider
          Container(height: 1, color: theme.alternate),

          // Input bar
          Container(
            color: theme.secondaryBackground,
            padding: EdgeInsets.fromLTRB(
                12, 8, 12, MediaQuery.of(context).padding.bottom + 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.primaryBackground,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: theme.alternate),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            style: GoogleFonts.inter(
                              color: theme.primaryText,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Type a message…',
                              hintStyle: GoogleFonts.inter(
                                color: theme.secondaryText,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10),
                            ),
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _send(),
                            maxLines: null,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _send,
                  child: Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: theme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded,
                        color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final String senderName;
  final bool isMine;
  final DateTime timestamp;
  const _ChatMessage({
    required this.text,
    required this.senderName,
    required this.isMine,
    required this.timestamp,
  });
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.msg,
    required this.timeLabel,
    required this.theme,
  });

  final _ChatMessage msg;
  final String timeLabel;
  final dynamic theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment:
            msg.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!msg.isMine) ...[
            CircleAvatar(
              radius: 14,
              backgroundColor: theme.alternate,
              child: Text(
                msg.senderName.isNotEmpty ? msg.senderName[0].toUpperCase() : '?',
                style: GoogleFonts.inter(
                  color: theme.primaryText,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: msg.isMine
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: msg.isMine ? theme.primary : theme.secondaryBackground,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(msg.isMine ? 16 : 4),
                      bottomRight: Radius.circular(msg.isMine ? 4 : 16),
                    ),
                    border: msg.isMine
                        ? null
                        : Border.all(color: theme.alternate),
                  ),
                  child: Text(
                    msg.text,
                    style: GoogleFonts.inter(
                      color: msg.isMine ? Colors.white : theme.primaryText,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  timeLabel,
                  style: GoogleFonts.inter(
                    color: theme.secondaryText,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          if (msg.isMine) const SizedBox(width: 4),
        ],
      ),
    );
  }
}
