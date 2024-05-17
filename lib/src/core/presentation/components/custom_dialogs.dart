import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<T?> showDialogToConfirm<T>({
  required BuildContext context,
  String? title,
  String? content,
  VoidCallback? onConfirm,
  String confirmText = 'Có',
  String dismissText = 'Không',
  TextStyle? titleTextStyle,
  TextStyle? contentTextStyle,
  Color? dismissBackgroundColor,
  Color? confirmBackgroundColor,
  Color titleColor = Colors.black87,
  Color contentColor = Colors.black87,
  Color? dismissTextColor,
  Color? confirmTextColor,
  bool barrierDismissible = true,
  bool hideDismiss = false,
}) async {
  return await showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        titleTextStyle: titleTextStyle,
        contentTextStyle: contentTextStyle,
        title: title != null
            ? Text(
                title,
                textAlign: TextAlign.center, // Căn giữa tiêu đề
                style: TextStyle(
                  color: titleColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              )
            : null,
        content: content != null
            ? Text(
                content,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: contentColor,
                  fontSize: 16.0,
                ),
              )
            : null,
        actions: [
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              hideDismiss
                  ? SizedBox.shrink()
                  : TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        backgroundColor: dismissBackgroundColor,
                      ),
                      child: Text(dismissText, style: TextStyle(color: dismissTextColor, fontWeight: FontWeight.bold)),
                    ),
              TextButton(
                onPressed: () async {
                  onConfirm?.call();
                  Navigator.of(context).pop(true);
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  backgroundColor: confirmBackgroundColor,
                ),
                child: Text(confirmText, style: TextStyle(color: confirmTextColor, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      );
    },
  );
}

Future showDialogToAlert(
  BuildContext context, {
  List<Widget>? children,
  bool scrollable = false,
  Widget? title,
  TextStyle? titleTextStyle,
  bool barrierDismissible = true,
  String confirmText = 'Đóng',
}) async {
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible, // user must tap button if set to false
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: title,
        titleTextStyle: titleTextStyle ??
            const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
        content: children != null
            ? ListBody(
                children: children,
              )
            : null,
        actions: <Widget>[
          TextButton(
            child: Text(confirmText),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

/// Be sure to add this line if `PackageInfo.fromPlatform()` is called before runApp()
/// WidgetsFlutterBinding.ensureInitialized();
void showCrossPlatformAboutDialog({
  required BuildContext context,
  String? logo,
  List<Widget>? children,
}) async {
  try {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
    // String version = packageInfo.version;
    // String buildNumber = packageInfo.buildNumber;

    if (!context.mounted) return;
    showAboutDialog(
      context: context,
      applicationName: packageInfo.appName,
      applicationVersion: packageInfo.version,
      applicationIcon: (logo != null)
          ? Image.asset(
              logo,
              width: 50,
              height: 50,
            )
          : const FlutterLogo(),
      applicationLegalese: '© ${DateTime.now().year} VTV',
      children: children,
      // bool barrierDismissible = true,
      // Color? barrierColor,
      // String? barrierLabel,
      // bool useRootNavigator = true,
      // RouteSettings? routeSettings,
      // Offset? anchorPoint,
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}
