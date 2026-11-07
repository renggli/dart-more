import 'dart:js_interop';

import 'package:web/web.dart';

@JS('Viz.instance')
external JSPromise<VizInstance> vizInstance();

extension type VizInstance._(JSObject _) implements JSObject {
  external SVGSVGElement renderSVGElement(
    String src, [
    VizRenderOptions? options,
  ]);
  external String renderString(String src, [VizRenderOptions? options]);
}

extension type VizRenderOptions._(JSObject _) implements JSObject {
  external factory({String? engine, String? format});
}
