import 'package:flutter/material.dart';

class FavCountBadge extends StatefulWidget {
  final int count;

  const FavCountBadge({Key key, @required this.count}) : super(key: key);

  @override
  _FavCountBadgeState createState() => _FavCountBadgeState();
}

class _FavCountBadgeState extends State<FavCountBadge>
    with SingleTickerProviderStateMixin<FavCountBadge> {
  AnimationController _animController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1.2,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.elasticOut,
      ),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: CircleAvatar(
        radius: 14,
        backgroundColor: Colors.deepOrangeAccent,
        child: Text(
          widget.count.toString(),
          style: Theme.of(context).textTheme.caption.copyWith(fontSize: 15),
        ),
      ),
    );
  }
}
