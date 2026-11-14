import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'app_ui.dart';
import 'commands.dart';
import 'menu.dart';
import 'renderer.dart';
import 'state.dart';
import 'toolbar.dart';

/// Handles keyboard shortcuts, mouse gestures, and interactive canvas inputs.
class CanvasInput {
  new({
    required this.state,
    required this.ui,
    required this.renderer,
    required this.menuController,
    required this.toolbarController,
    required this.onExecuteCommand,
    required this.onUpdateUI,
  });

  final AppState state;
  final AppUi ui;
  final GraphRenderer renderer;
  final MenuController menuController;
  final ToolbarController toolbarController;
  final void Function(String cmdId) onExecuteCommand;
  final void Function() onUpdateUI;

  void handleVertexDblClick(String vertex) {
    renderer.showInlineNodeEditor(
      state,
      vertex,
      onCommit: (newLabel) {
        state.saveSnapshot();
        state.getOrCreateNode(vertex).label = newLabel;
        onUpdateUI();
      },
    );
  }

  void handleVertexClick(String vertex, web.MouseEvent event) {
    if (!state.selectVerticesMode) return;
    if (state.showLabels &&
        !event.shiftKey &&
        state.selectedVertices.length == 1 &&
        state.selectedVertices.contains(vertex)) {
      handleVertexDblClick(vertex);
      return;
    }
    state.selectVertex(
      vertex,
      toggle: event.shiftKey,
      clearOthers: !event.shiftKey,
    );
    onUpdateUI();
  }

  void handleEdgeClick(String source, String target, web.MouseEvent event) {
    if (!state.selectEdgesMode) return;
    state.selectEdge(
      source,
      target,
      toggle: event.shiftKey,
      clearOthers: !event.shiftKey,
    );
    onUpdateUI();
  }

  void handleLassoSelection(
    List<String> matchedVertices,
    List<(String, String)> matchedEdges,
    bool isShift,
  ) {
    if (!isShift) {
      state.clearSelection();
    }
    if (state.selectVerticesMode && matchedVertices.isNotEmpty) {
      state.selectedVertices.addAll(matchedVertices);
      state.activeVertex = matchedVertices.last;
      state.syncSelectionSourceTarget();
    }
    if (state.selectEdgesMode && matchedEdges.isNotEmpty) {
      final normalized = matchedEdges.map(
        (e) => state.normalizeEdge(e.$1, e.$2),
      );
      state.selectedEdges.addAll(normalized);
      state.selectedEdge = normalized.last;
    }
    onUpdateUI();
  }

  void handleBackgroundClick(web.MouseEvent event) {
    state.clearSelection();
    onUpdateUI();
  }

  void handlePlacementConfirmed(String placedVertex) {
    state.selectVertex(placedVertex, clearOthers: true);
    onUpdateUI();
    if (state.showLabels) {
      renderer.showInlineNodeEditor(
        state,
        placedVertex,
        onCommit: (newLabel) {
          state.saveSnapshot();
          state.getOrCreateNode(placedVertex).label = newLabel;
          onUpdateUI();
        },
      );
    }
  }

  void handleEdgeWeightEdit(String u, String v, num newWeight) {
    state.saveSnapshot();
    state.isWeighted = true;
    state.primaryGraph.addEdge(u, v, value: newWeight);
    if (!state.primaryGraph.isDirected) {
      state.primaryGraph.addEdge(v, u, value: newWeight);
    }
    onUpdateUI();
  }

  void handleNodesMoved(Map<String, (double, double)> moves) {
    state.saveSnapshot();
    for (final MapEntry(:key, :value) in moves.entries) {
      final node = state.nodes[key];
      if (node != null) {
        node.x = value.$1;
        node.y = value.$2;
      }
    }
    onUpdateUI();
  }

  void init() {
    web.window.onkeydown = ((web.KeyboardEvent event) {
      final target = event.target;
      if (target != null &&
          (target.isA<web.HTMLInputElement>() ||
              target.isA<web.HTMLTextAreaElement>())) {
        return;
      }

      final key = event.key;
      final isModifier = event.ctrlKey || event.metaKey;

      if (key == 'Escape') {
        var handled = false;
        if (toolbarController.modalIo.style.display != 'none') {
          toolbarController.closeModal();
          handled = true;
        }
        final openMenus = web.document.querySelectorAll('.menu-item.open');
        if (openMenus.length > 0) {
          menuController.closeAllMenus();
          handled = true;
        }
        if (toolbarController.introOverlay?.style.display != 'none') {
          toolbarController.dismissedEmpty = true;
          toolbarController.updateIntroOverlay();
          handled = true;
        }
        renderer.cancelInlineEditor();
        if (ui.pendingPlacementVertex != null) {
          final pv = ui.pendingPlacementVertex!;
          state.primaryGraph.removeVertex(pv);
          state.nodes.remove(pv);
          ui.pendingPlacementVertex = null;
          handled = true;
          onUpdateUI();
        }
        if (!handled &&
            (state.selectedVertices.isNotEmpty ||
                state.selectedEdges.isNotEmpty ||
                state.selectedEdge != null)) {
          state.clearSelection();
          onUpdateUI();
        }
        event.preventDefault();
        return;
      }

      for (final cmd in CommandRegistry.all) {
        if (cmd.matchesKey(
          key,
          ctrl: isModifier,
          shift: event.shiftKey,
          alt: event.altKey,
        )) {
          if (cmd.canExecute(state, ui)) {
            onExecuteCommand(cmd.id);
            event.preventDefault();
            return;
          }
        }
      }
    }).toJS;
  }
}
