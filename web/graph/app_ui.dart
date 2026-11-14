/// View interface decoupling UI actions and coordinates from the application state.
abstract interface class AppUi {
  /// Opens the file picker dialog to open a graph file.
  void openFile();

  /// Opens the import modal dialog.
  void openImport();

  /// Opens the export modal dialog.
  void openExport();

  /// Shows the inline node editor for [vertex].
  void showInlineEditor(String vertex);

  /// Resets the canvas view/camera.
  void resetView();

  /// Current cursor X coordinate in canvas space.
  double get cursorX;
  set cursorX(double value);

  /// Current cursor Y coordinate in canvas space.
  double get cursorY;
  set cursorY(double value);

  /// Pending vertex attached to cursor for placement.
  String? get pendingPlacementVertex;
  set pendingPlacementVertex(String? vertex);
}

/// Fallback or test implementation of [AppUi] that performs no operations.
class NoOpAppUi implements AppUi {
  const new();

  @override
  void openFile() {}

  @override
  void openImport() {}

  @override
  void openExport() {}

  @override
  void showInlineEditor(String vertex) {}

  @override
  void resetView() {}

  @override
  double get cursorX => 400.0;

  @override
  set cursorX(double value) {}

  @override
  double get cursorY => 300.0;

  @override
  set cursorY(double value) {}

  @override
  String? get pendingPlacementVertex => null;

  @override
  set pendingPlacementVertex(String? vertex) {}
}
