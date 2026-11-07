import 'dart:async';

/// Callback when the active playback step changes.
typedef StepCallback = void Function(int step, int totalSteps);

/// Controls animated step-by-step playback of graph traversals and paths.
final class TraversalPlayer {
  new({required this.onStepChanged});

  final StepCallback onStepChanged;

  List<String> _vertices = [];
  List<(String, String)> _edges = [];
  int _currentStep = 0;
  Timer? _timer;
  int speedMs = 500;
  bool isPlaying = false;

  List<String> get vertices => _vertices;
  List<(String, String)> get edges => _edges;
  int get currentStep => _currentStep;
  int get totalSteps => _vertices.isEmpty ? 0 : _vertices.length;

  void load({
    required List<String> vertices,
    required List<(String, String)> edges,
  }) {
    pause();
    _vertices = vertices;
    _edges = edges;
    _currentStep = 0;
    onStepChanged(_currentStep, totalSteps);
  }

  void first() {
    _currentStep = 0;
    onStepChanged(_currentStep, totalSteps);
  }

  void prev() {
    if (_currentStep > 0) {
      _currentStep--;
      onStepChanged(_currentStep, totalSteps);
    }
  }

  void next() {
    if (_currentStep < totalSteps - 1) {
      _currentStep++;
      onStepChanged(_currentStep, totalSteps);
    } else {
      pause();
    }
  }

  void last() {
    if (totalSteps > 0) {
      _currentStep = totalSteps - 1;
      onStepChanged(_currentStep, totalSteps);
    }
  }

  void play() {
    if (totalSteps <= 1) return;
    if (_currentStep >= totalSteps - 1) {
      _currentStep = 0;
    }
    isPlaying = true;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: speedMs), (_) {
      if (_currentStep < totalSteps - 1) {
        next();
      } else {
        pause();
      }
    });
  }

  void pause() {
    isPlaying = false;
    _timer?.cancel();
    _timer = null;
  }

  void stop() {
    pause();
    _vertices = [];
    _edges = [];
    _currentStep = 0;
  }
}
