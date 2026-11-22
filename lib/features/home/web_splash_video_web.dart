// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';

int _viewCounter = 0;

Widget buildWebSplashVideo({
  required String assetPath,
  required VoidCallback onEnded,
  required VoidCallback onError,
}) {
  final viewType = 'aquapet-splash-video-${_viewCounter++}';
  ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
    final video = html.VideoElement()
      ..src = 'assets/$assetPath'
      ..autoplay = true
      ..muted = true
      ..controls = false
      ..setAttribute('playsinline', 'true')
      ..setAttribute('muted', 'true')
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'cover'
      ..style.border = 'none'
      ..style.pointerEvents = 'none';

    video.onEnded.listen((_) => onEnded());
    video.onError.listen((_) => onError());
    video.onCanPlay.listen((_) {
      video.play().catchError((_) {});
    });

    return video;
  });

  return HtmlElementView(viewType: viewType);
}
