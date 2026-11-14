import 'dart:js_interop';
import 'dart:math' as math;

import 'package:more/collection.dart';
import 'package:web/web.dart' as web;

import 'renderer.dart';
import 'state.dart';

void main() {
  final state = RTreeAppState();

  // Canvas & layout elements
  final canvas = web.document.querySelector('#canvas') as web.HTMLCanvasElement;

  // Floating Zoom & Recenter Controls
  final btnZoomIn =
      web.document.querySelector('#btn-zoom-in') as web.HTMLButtonElement;
  final btnZoomOut =
      web.document.querySelector('#btn-zoom-out') as web.HTMLButtonElement;
  final btnZoomFit =
      web.document.querySelector('#btn-zoom-fit') as web.HTMLButtonElement;

  // Tool buttons
  final toolPoint =
      web.document.querySelector('#tool-point') as web.HTMLButtonElement;
  final toolBox =
      web.document.querySelector('#tool-box') as web.HTMLButtonElement;
  final toolQuery =
      web.document.querySelector('#tool-query') as web.HTMLButtonElement;
  final toolKnn =
      web.document.querySelector('#tool-knn') as web.HTMLButtonElement;
  final toolDelete =
      web.document.querySelector('#tool-delete') as web.HTMLButtonElement;
  final toggleLabels =
      web.document.querySelector('#toggle-labels') as web.HTMLButtonElement;
  final toggleBadges =
      web.document.querySelector('#toggle-badges') as web.HTMLButtonElement;
  final btnUndo =
      web.document.querySelector('#btn-undo') as web.HTMLButtonElement;
  final btnRedo =
      web.document.querySelector('#btn-redo') as web.HTMLButtonElement;
  final btnClear =
      web.document.querySelector('#btn-clear') as web.HTMLButtonElement;

  // HUD & Hint elements
  final hudAlgo = web.document.querySelector('#hud-algo') as web.HTMLElement;
  final hudItems = web.document.querySelector('#hud-items') as web.HTMLElement;
  final hudTree = web.document.querySelector('#hud-tree') as web.HTMLElement;
  final hudHits = web.document.querySelector('#hud-hits') as web.HTMLElement;
  final canvasHint =
      web.document.querySelector('#canvas-hint') as web.HTMLElement;

  // Sidebar Controls
  final selectAlgo =
      web.document.querySelector('#select-algo') as web.HTMLSelectElement;
  final inputMaxEntries =
      web.document.querySelector('#input-max-entries') as web.HTMLInputElement;
  final valMaxEntries =
      web.document.querySelector('#val-max-entries') as web.HTMLElement;
  final inputMinEntries =
      web.document.querySelector('#input-min-entries') as web.HTMLInputElement;
  final valMinEntries =
      web.document.querySelector('#val-min-entries') as web.HTMLElement;
  final inputKnnK =
      web.document.querySelector('#input-knn-k') as web.HTMLInputElement;
  final valKnnK = web.document.querySelector('#val-knn-k') as web.HTMLElement;

  // Metric elements
  final metricItems =
      web.document.querySelector('#metric-items') as web.HTMLElement;
  final metricNodes =
      web.document.querySelector('#metric-nodes') as web.HTMLElement;
  final metricHeight =
      web.document.querySelector('#metric-height') as web.HTMLElement;
  final metricFill =
      web.document.querySelector('#metric-fill') as web.HTMLElement;
  final metricOverlap =
      web.document.querySelector('#metric-overlap') as web.HTMLElement;

  final renderer = RTreeRenderer(canvas: canvas);

  void updateUI() {
    renderer.render(state);

    // Update HUD
    hudAlgo.textContent = state.algorithm.label;
    hudItems.textContent = state.items.length.toString();
    hudTree.textContent = '${state.totalNodes} / ${state.treeHeight}';
    hudHits.textContent = state.lastQueryHits.length.toString();

    // Update Metrics
    metricItems.textContent = state.items.length.toString();
    metricNodes.textContent = state.totalNodes.toString();
    metricHeight.textContent = state.treeHeight.toString();
    metricFill.textContent = '${state.averageFillFactor.toStringAsFixed(1)}%';
    metricOverlap.textContent = state.totalOverlapArea.toStringAsFixed(0);

    // Update Tool Active States
    toolPoint.classList.toggle(
      'active',
      state.currentTool == InteractionTool.addPoint,
    );
    toolPoint.setAttribute(
      'aria-pressed',
      (state.currentTool == InteractionTool.addPoint).toString(),
    );

    toolBox.classList.toggle(
      'active',
      state.currentTool == InteractionTool.addBox,
    );
    toolBox.setAttribute(
      'aria-pressed',
      (state.currentTool == InteractionTool.addBox).toString(),
    );

    toolQuery.classList.toggle(
      'active',
      state.currentTool == InteractionTool.query,
    );
    toolQuery.setAttribute(
      'aria-pressed',
      (state.currentTool == InteractionTool.query).toString(),
    );

    toolKnn.classList.toggle(
      'active',
      state.currentTool == InteractionTool.nearest,
    );
    toolKnn.setAttribute(
      'aria-pressed',
      (state.currentTool == InteractionTool.nearest).toString(),
    );

    toolDelete.classList.toggle(
      'active',
      state.currentTool == InteractionTool.delete,
    );
    toolDelete.setAttribute(
      'aria-pressed',
      (state.currentTool == InteractionTool.delete).toString(),
    );

    toggleLabels.classList.toggle('active', state.showLabels);
    toggleLabels.setAttribute('aria-pressed', state.showLabels.toString());

    toggleBadges.classList.toggle('active', state.showBadges);
    toggleBadges.setAttribute('aria-pressed', state.showBadges.toString());

    btnUndo.disabled = !state.canUndo;
    btnRedo.disabled = !state.canRedo;

    // Hint text
    switch (state.currentTool) {
      case InteractionTool.addPoint:
        canvasHint.textContent = 'Click on canvas to insert a 2D point (Scroll to zoom, Drag with middle/right button or Space to pan).';
      case InteractionTool.addBox:
        canvasHint.textContent = 'Drag to draw an axis-aligned bounding box (Scroll to zoom, Drag with middle/right button or Space to pan).';
      case InteractionTool.query:
        canvasHint.textContent =
            'Drag on canvas to define a window query box and inspect hits.';
      case InteractionTool.nearest:
        canvasHint.textContent = 'Move cursor across the canvas to radiate real-time k-NN search rays.';
      case InteractionTool.delete:
        canvasHint.textContent =
            'Click on any point or box to remove it from the tree.';
    }
  }

  void setTool(InteractionTool tool) {
    state.currentTool = tool;
    state.clearTransientQueries();
    updateUI();
  }

  // --- Interaction Tools Wiring ---
  toolPoint.onClick.listen((_) => setTool(InteractionTool.addPoint));
  toolBox.onClick.listen((_) => setTool(InteractionTool.addBox));
  toolQuery.onClick.listen((_) => setTool(InteractionTool.query));
  toolKnn.onClick.listen((_) => setTool(InteractionTool.nearest));
  toolDelete.onClick.listen((_) => setTool(InteractionTool.delete));

  toggleLabels.onClick.listen((_) {
    state.showLabels = !state.showLabels;
    updateUI();
  });

  toggleBadges.onClick.listen((_) {
    state.showBadges = !state.showBadges;
    updateUI();
  });

  btnUndo.onClick.listen((_) {
    state.undo();
    updateUI();
  });

  btnRedo.onClick.listen((_) {
    state.redo();
    updateUI();
  });

  btnClear.onClick.listen((_) {
    state.clearAll();
    renderer.zoomFit(state);
    updateUI();
  });

  // --- Zoom & Recenter Controls Wiring ---
  btnZoomIn.onClick.listen((_) {
    renderer.zoomIn();
    updateUI();
  });

  btnZoomOut.onClick.listen((_) {
    renderer.zoomOut();
    updateUI();
  });

  btnZoomFit.onClick.listen((_) {
    renderer.zoomFit(state);
    updateUI();
  });

  canvas.onDoubleClick.listen((_) {
    renderer.zoomFit(state);
    updateUI();
  });

  // --- Sidebar Configuration Wiring ---
  selectAlgo.onChange.listen((_) {
    switch (selectAlgo.value) {
      case 'guttman':
        state.algorithm = RTreeAlgorithm.guttman;
      case 'linear':
        state.algorithm = RTreeAlgorithm.linear;
      case 'rStar':
        state.algorithm = RTreeAlgorithm.rStar;
    }
    state.rebuildTree();
    updateUI();
  });

  inputMinEntries.onInput.listen((_) {
    final minVal = int.parse(inputMinEntries.value);
    state.minEntries = minVal;
    valMinEntries.textContent = minVal.toString();
    if (state.maxEntries < minVal * 2) {
      state.maxEntries = minVal * 2;
      inputMaxEntries.value = state.maxEntries.toString();
      valMaxEntries.textContent = state.maxEntries.toString();
    }
    state.rebuildTree();
    updateUI();
  });

  inputMaxEntries.onInput.listen((_) {
    final maxVal = int.parse(inputMaxEntries.value);
    state.maxEntries = maxVal;
    valMaxEntries.textContent = maxVal.toString();
    // Clamp minEntries <= maxVal / 2
    if (state.minEntries > maxVal ~/ 2) {
      state.minEntries = math.max(2, maxVal ~/ 2);
      inputMinEntries.value = state.minEntries.toString();
      valMinEntries.textContent = state.minEntries.toString();
    }
    state.rebuildTree();
    updateUI();
  });

  inputKnnK.onInput.listen((_) {
    final k = int.parse(inputKnnK.value);
    state.knnK = k;
    valKnnK.textContent = k.toString();
    if (state.currentTool == InteractionTool.nearest &&
        state.activeKnnPoint != null) {
      state.performKnnQuery(state.activeKnnPoint!, k);
    }
    updateUI();
  });

  // Preset Buttons
  final presetButtons = web.document.querySelectorAll(
    '.preset-btn, .btn-preset',
  );
  for (var i = 0; i < presetButtons.length; i++) {
    final btn = presetButtons.item(i) as web.HTMLButtonElement;
    final presetType = btn.getAttribute('data-preset');
    if (presetType != null) {
      btn.onClick.listen((_) async {
        final rect = canvas.getBoundingClientRect();
        await state.loadPreset(presetType, rect.width, rect.height);
        renderer.zoomFit(state);
        updateUI();
      });
    }
  }

  // --- Canvas Pointer Gestures (Zoom, Pan & Tools) ---
  var isPointerDown = false;
  var isPanning = false;
  var panStartX = 0.0;
  var panStartY = 0.0;
  var dragStartX = 0.0;
  var dragStartY = 0.0;
  var isSpaceDown = false;

  canvas.onContextMenu.listen((e) => e.preventDefault());

  // Mouse wheel zoom centered on cursor
  canvas.onWheel.listen((e) {
    e.preventDefault();
    final mouseX = e.offsetX.toDouble();
    final mouseY = e.offsetY.toDouble();
    final zoomFactor = e.deltaY < 0 ? 1.15 : 0.85;
    renderer.zoomAt(mouseX, mouseY, zoomFactor);
    updateUI();
  });

  canvas.onMouseDown.listen((e) {
    // Middle click, right click, or space-click initiates canvas pan
    if (e.button == 1 || e.button == 2 || isSpaceDown) {
      isPanning = true;
      panStartX = e.clientX.toDouble() - renderer.panX;
      panStartY = e.clientY.toDouble() - renderer.panY;
      canvas.style.cursor = 'grabbing';
      return;
    }

    if (e.button != 0) return; // Only primary button for spatial tools

    isPointerDown = true;
    dragStartX = renderer.toCanvasX(e.offsetX.toDouble());
    dragStartY = renderer.toCanvasY(e.offsetY.toDouble());

    if (state.currentTool == InteractionTool.delete) {
      state.removeItemAtPoint([dragStartX, dragStartY], 10.0 / renderer.scale);
      updateUI();
    } else if (state.currentTool == InteractionTool.nearest) {
      state.performKnnQuery([dragStartX, dragStartY], state.knnK);
      updateUI();
    }
  });

  canvas.onMouseMove.listen((e) {
    if (isPanning) {
      renderer.panX = e.clientX.toDouble() - panStartX;
      renderer.panY = e.clientY.toDouble() - panStartY;
      updateUI();
      return;
    }

    final curX = renderer.toCanvasX(e.offsetX.toDouble());
    final curY = renderer.toCanvasY(e.offsetY.toDouble());

    if (isPointerDown) {
      if (state.currentTool == InteractionTool.query) {
        final minX = math.min(dragStartX, curX);
        final maxX = math.max(dragStartX, curX);
        final minY = math.min(dragStartY, curY);
        final maxY = math.max(dragStartY, curY);
        state.performRangeQuery(Bounds.from2D(minX, minY, maxX, maxY));
        updateUI();
      } else if (state.currentTool == InteractionTool.addBox) {
        final minX = math.min(dragStartX, curX);
        final maxX = math.max(dragStartX, curX);
        final minY = math.min(dragStartY, curY);
        final maxY = math.max(dragStartY, curY);
        state.activeQueryBounds = Bounds.from2D(minX, minY, maxX, maxY);
        renderer.render(state);
      } else if (state.currentTool == InteractionTool.delete) {
        state.removeItemAtPoint([curX, curY], 10.0 / renderer.scale);
        updateUI();
      }
    } else if (state.currentTool == InteractionTool.nearest) {
      state.performKnnQuery([curX, curY], state.knnK);
      updateUI();
    }
  });

  web.window.addEventListener(
    'mouseup',
    ((web.MouseEvent e) {
      if (isPanning) {
        isPanning = false;
        canvas.style.cursor = isSpaceDown ? 'grab' : '';
      }

      if (!isPointerDown) return;
      isPointerDown = false;

      final rect = canvas.getBoundingClientRect();
      final endScreenX = e.clientX.toDouble() - rect.left;
      final endScreenY = e.clientY.toDouble() - rect.top;
      final endX = renderer.toCanvasX(endScreenX);
      final endY = renderer.toCanvasY(endScreenY);

      if (state.currentTool == InteractionTool.addPoint) {
        state.addItem([dragStartX, dragStartY].toBounds());
        state.activeQueryBounds = null;
        updateUI();
      } else if (state.currentTool == InteractionTool.addBox) {
        final distScreen = math.sqrt(
          math.pow(endScreenX - renderer.toScreenX(dragStartX), 2) +
              math.pow(endScreenY - renderer.toScreenY(dragStartY), 2),
        );

        if (distScreen > 5.0) {
          final minX = math.min(dragStartX, endX);
          final maxX = math.max(dragStartX, endX);
          final minY = math.min(dragStartY, endY);
          final maxY = math.max(dragStartY, endY);
          state.addItem(Bounds.from2D(minX, minY, maxX, maxY));
        } else {
          // Fallback small box if clicked without dragging
          final size = 16.0 / renderer.scale;
          state.addItem(
            Bounds.from2D(
              dragStartX - size / 2,
              dragStartY - size / 2,
              dragStartX + size / 2,
              dragStartY + size / 2,
            ),
          );
        }
        state.activeQueryBounds = null;
        updateUI();
      }
    }).toJS,
  );

  // --- Keyboard Shortcuts & Space Tracking ---
  web.window.onKeyDown.listen((e) {
    if (e.code == 'Space' && !isSpaceDown) {
      final target = e.target;
      if (target != null &&
          (target.isA<web.HTMLInputElement>() ||
              target.isA<web.HTMLTextAreaElement>())) {
        return;
      }
      isSpaceDown = true;
      canvas.style.cursor = 'grab';
      return;
    }

    final target = e.target;
    if (target != null &&
        (target.isA<web.HTMLInputElement>() ||
            target.isA<web.HTMLTextAreaElement>())) {
      return;
    }

    if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() == 'z') {
      e.preventDefault();
      if (e.shiftKey) {
        state.redo();
      } else {
        state.undo();
      }
      updateUI();
      return;
    }

    if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() == 'y') {
      e.preventDefault();
      state.redo();
      updateUI();
      return;
    }

    switch (e.key) {
      case '1':
        setTool(InteractionTool.addPoint);
      case '2':
        setTool(InteractionTool.addBox);
      case '3':
        setTool(InteractionTool.query);
      case '4':
        setTool(InteractionTool.nearest);
      case '5':
        setTool(InteractionTool.delete);
    }
  });

  web.window.addEventListener(
    'keyup',
    ((web.KeyboardEvent e) {
      if (e.code == 'Space') {
        isSpaceDown = false;
        if (!isPanning) {
          canvas.style.cursor = '';
        }
      }
    }).toJS,
  );

  web.window.addEventListener('resize', ((web.Event _) => updateUI()).toJS);

  // Load initial preset (Clusters) and fit viewport
  web.window.requestAnimationFrame(
    ((JSNumber _) {
      final rect = canvas.getBoundingClientRect();
      state.loadPreset('gaussian_clusters', rect.width, rect.height).then((_) {
        renderer.zoomFit(state);
        updateUI();
      });
    }).toJS,
  );
}
