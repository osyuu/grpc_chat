import 'package:flutter/material.dart';

class MessageListItem extends StatefulWidget {
  const MessageListItem({
    super.key,
    required this.message,
    required this.sender,
    this.isMe = false,
    required this.timestamp,
  });

  final String message;
  final String sender;
  final DateTime? timestamp;
  final bool isMe;

  @override
  State<MessageListItem> createState() => _MessageListItemState();
}

class _MessageListItemState extends State<MessageListItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _widthFactor;
  late final Animation<double> _scaleFactor;

  static final tailSize = const Size(10, 10);

  final GlobalKey _bubbleKey = GlobalKey();
  double _bubbleWidth = 0.0;
  double _bubbleHeight = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _widthFactor = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _scaleFactor = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    // 延遲到下一幀計算寬度
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? box =
          _bubbleKey.currentContext?.findRenderObject() as RenderBox?;
      if (box != null) {
        setState(() {
          _bubbleWidth = box.size.width;
          _bubbleHeight = box.size.height;
        });
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!widget.isMe) ...[
            Column(
              children: [
                CircleAvatar(
                  radius: 16,
                  child: Text(widget.sender[0].toUpperCase()),
                ),
                Text(
                  widget.sender,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: widget.isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                _bubbleWidth == 0.0
                    ? Opacity(
                        opacity: 0,
                        child: _buildBubble(), // 隱藏的 Bubble 用於測量寬度
                      )
                    : SizedBox(
                        width: _bubbleWidth,
                        height: _bubbleHeight,
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return FractionallySizedBox(
                              alignment: widget.isMe
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              widthFactor: _widthFactor.value,
                              child: Transform.scale(
                                scale: _scaleFactor.value,
                                alignment: widget.isMe
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: child,
                              ),
                            );
                          },
                          child: _buildBubble(),
                        ),
                      ),
                if (widget.timestamp != null)
                  Text(
                    _formatTimestamp(widget.timestamp!),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                    ),
                  ),
              ],
            ),
          ),
          if (widget.isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue,
              child: Text(widget.sender[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBubble() {
    final theme = Theme.of(context);
    return Stack(
      key: _bubbleKey,
      children: [
        Container(
          margin: widget.isMe
              ? EdgeInsets.only(right: tailSize.width)
              : EdgeInsets.only(left: tailSize.width),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: widget.isMe
                ? theme.colorScheme.secondaryContainer
                : theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Text(
            widget.message,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Positioned(
          top: 10,
          left: widget.isMe ? null : 0,
          right: widget.isMe ? 0 : null,
          child: CustomPaint(
            size: tailSize,
            painter: BubbleTailPainter(
              color: widget.isMe
                  ? theme.colorScheme.secondaryContainer
                  : theme.colorScheme.primaryContainer,
              isMe: widget.isMe,
            ),
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class BubbleTailPainter extends CustomPainter {
  final Color color;
  final bool isMe;

  BubbleTailPainter({required this.color, required this.isMe});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final path = Path();
    if (isMe) {
      // 右側的三角形
      path.moveTo(0, 0);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(0, size.height);
    } else {
      // 左側的三角形
      path.moveTo(size.width, 0);
      path.lineTo(0, size.height / 2);
      path.lineTo(size.width, size.height);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
