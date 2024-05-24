import 'package:flutter/material.dart';

import '../components/custom_widgets.dart';

class NoPermissionPage extends StatelessWidget {
  const NoPermissionPage({super.key, this.message = 'Bạn không có quyền truy cập trang này'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: MessageScreen(message: message));
  }
}
