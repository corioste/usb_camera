import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_usb_camera/flutter_usb_camera.dart';
import 'package:flutter_usb_camera/flutter_usb_camera_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterUsbCameraPlugin = FlutterUsbCamera();
  late StreamSubscription _usbCameraBus;
  int cameraCount = 0;
  String logStr = "";
  bool isShowLog = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _usbCameraBus = _flutterUsbCameraPlugin.events.listen((event) {
      print(event);
      if (event.event == USBCameraEvent.onUsbCameraChanged) {
        setState(() {
          cameraCount = event.count ?? 0;
        });
      } else if (event.event == USBCameraEvent.onLogChanged) {
        logStr = event.logString ?? "";
        print(logStr);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _usbCameraBus.cancel();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _flutterUsbCameraPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    isShowLog = !isShowLog;
                  });
                },
                child: Text(
                  isShowLog ? 'show' : 'not',
                  style: const TextStyle(color: Colors.white),
                )),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Text("设备号: $cameraCount"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () async {
                          PermissionStatus status =
                              await Permission.storage.request();
                          if (status == PermissionStatus.granted) {
                            _flutterUsbCameraPlugin.takePicture(cameraCount);
                          }
                        },
                        child: const Text('拍照')),
                    TextButton(
                        onPressed: () async {
                          PermissionStatus status =
                              await Permission.camera.request();
                          if (status == PermissionStatus.granted) {
                            _flutterUsbCameraPlugin.startPreview(cameraCount);
                          }
                        },
                        child: const Text('开始')),
                    TextButton(
                        onPressed: () {
                          _flutterUsbCameraPlugin.stopPreview(cameraCount);
                        },
                        child: const Text('结束')),
                  ],
                ),
                SizedBox(
                  height: 500,
                  width: 700,
                  child: cameraCount > 0
                      ? AndroidView(
                          viewType: cameraCount.toString(),
                        )
                      : null,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
