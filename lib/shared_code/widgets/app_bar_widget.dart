import 'package:flutter/material.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const AppBarWidget({
    @required this.title,
    this.onBack,
    this.actions,
    this.isVisibleBackButton = true,
  });

  final VoidCallback onBack;
  final String title;
  final List<Widget> actions;
  final bool isVisibleBackButton;

  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();

  @override
  Size get preferredSize {
    return const Size.fromHeight(60);
  }
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.orange,
      title: Text(
        widget.title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      leading: widget.isVisibleBackButton
          ? IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: widget.onBack ??
                () {
              Navigator.pop(context);
            },
      )
          : null,
      actions: widget.actions,
    );
  }
}
