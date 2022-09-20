import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_usb_camera_method_channel.dart';

abstract class FlutterUsbCameraPlatform extends PlatformInterface {
  /// Constructs a FlutterUsbCameraPlatform.
  FlutterUsbCameraPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterUsbCameraPlatform _instance = MethodChannelFlutterUsbCamera();

  Stream<USBCameraEvent> get events;

  /// The default instance of [FlutterUsbCameraPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterUsbCamera].
  static FlutterUsbCameraPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterUsbCameraPlatform] when
  /// they register themselves.
  static set instance(FlutterUsbCameraPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
    _instance.setMessageHandler();
  }

  void setMessageHandler();

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> takePicture(int deviceId) {
    throw UnimplementedError('takePicture() has not been implemented.');
  }

  Future<bool?> startPreview(int deviceId) {
    throw UnimplementedError('startPreview() has not been implemented.');
  }

  Future<bool?> stopPreview(int deviceId) {
    throw UnimplementedError('stopPreview() has not been implemented.');
  }
}

class USBCameraEvent {
  String event;
  int? count;
  String? logString;
  ByteData? bytes;
  USBCameraEvent(this.event, {this.count, this.logString, this.bytes});

  // 摄像头改变
  static const String onUsbCameraChanged = "onUsbCameraChanged";
  // 日志改变
  static const String onLogChanged = "onLogChanged";

  static const String onCameraPreview = "onCameraPreview";

  static const String onTakePicture = "onTakePicture";
}

class USBCameraDevice {}
