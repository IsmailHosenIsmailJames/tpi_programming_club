import 'package:flutter/material.dart';

class PublicProfileView extends StatefulWidget {
  const PublicProfileView({super.key, required this.userEmail});

  final String userEmail;

  @override
  State<PublicProfileView> createState() => _PublicProfileViewState();
}

class _PublicProfileViewState extends State<PublicProfileView> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.userEmail);
  }
}
