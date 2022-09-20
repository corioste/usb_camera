package com.zly.usbcamera.flutter_usb_camera;

import java.text.SimpleDateFormat;

import io.flutter.plugin.common.MethodChannel;

public class DebugLog {
    private static String logString = "";
    static MethodChannel channel;

    static void log(String log) {
        channel.invokeMethod("onLogChanged", log);
    }

    static void clearLog() {
        logString = "";
        channel.invokeMethod("onLogChanged", logString);
    }
}
