import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'app_ui.dart';
import 'dom_utils.dart';
import 'icons.dart';
import 'io.dart';
import 'io_codec.dart';
import 'modifiers.dart';
import 'state.dart';

/// Manages the modifier stack panel in the sidebar, including configuration
/// card rendering, live result displays, and drag-and-drop reordering.
class ModifierPanel {
  new({required this.selectAddModifier, required this.modifiersStackList});

  final web.HTMLSelectElement selectAddModifier;
  final web.HTMLElement modifiersStackList;

  final List<void Function()> _modifierCardUpdaters = [];
  int? _draggedModifierIndex;

  /// Updates existing card dynamic states (e.g. summaries, errors) without
  /// rebuilding the configuration inputs.
  void updateModifierCards() {
    for (final updater in _modifierCardUpdaters) {
      updater();
    }
  }

  /// Synchronizes all vertex select dropdowns in active modifier cards with
  /// the vertices available in [state].
  void updateModifierVertexDropdowns(AppState state) {
    final dropdowns = web.document.querySelectorAll('.vertex-select');
    final vertices = state.renderGraph.vertices.toList();

    for (var i = 0; i < dropdowns.length; i++) {
      final select = dropdowns.item(i) as web.HTMLSelectElement?;
      if (select == null) continue;

      final currentVal = select.value;
      final defaultLabel = select.getAttribute('data-default');

      select.textContent = '';
      if (defaultLabel != null) {
        select.appendChild(optionElement('', defaultLabel));
      }
      for (final v in vertices) {
        select.appendChild(optionElement(v, v));
      }

      if (vertices.contains(currentVal)) {
        select.value = currentVal;
      } else if (defaultLabel != null) {
        select.value = '';
      } else if (vertices.isNotEmpty) {
        select.value = vertices.first;
      }
    }
  }

  /// Rebuilds the entire modifier stack card list.
  void renderModifierStack(AppState state, AppUi ui, void Function() updateUI) {
    _modifierCardUpdaters.clear();
    modifiersStackList.textContent = '';
    modifiersStackList.ondragover = ((web.DragEvent e) {
      if (_draggedModifierIndex != null) {
        e.preventDefault();
        e.dataTransfer?.dropEffect = 'move';
      }
    }).toJS;
    modifiersStackList.ondrop = ((web.DragEvent e) {
      final target = e.target as web.HTMLElement?;
      if (target != null && target.closest('.modifier-card') != null) {
        return;
      }
      e.preventDefault();
      final fromIdx = _draggedModifierIndex;
      _draggedModifierIndex = null;
      if (fromIdx != null && fromIdx < state.modifiers.length - 1) {
        final moved = state.modifiers.removeAt(fromIdx);
        state.modifiers.add(moved);
        state.evaluateModifiers();
        updateUI();
        renderModifierStack(state, ui, updateUI);
      }
    }).toJS;

    if (state.modifiers.isEmpty) {
      final emptyMsg = div()..style.color = 'var(--text-muted)';
      emptyMsg.textContent = 'No modifiers active. Add a modifier above to run live analysis or transformations.';
      modifiersStackList.appendChild(emptyMsg);
      return;
    }

    for (var i = 0; i < state.modifiers.length; i++) {
      final idx = i;
      final mod = state.modifiers[idx];
      final card = div('modifier-card');
      if (!mod.enabled) card.classList.add('disabled');

      final output = state.lastModifierOutputs[mod.id];
      final hasError = output?.hasError ?? false;
      if (hasError) {
        card.classList.add('error');
      }

      if (!mod.isPinned) {
        card.ondragover = ((web.DragEvent e) {
          if (_draggedModifierIndex == null || _draggedModifierIndex == idx) {
            card.classList.remove('drag-over-top');
            card.classList.remove('drag-over-bottom');
            return;
          }
          final rect = card.getBoundingClientRect();
          final midY = rect.top + rect.height / 2.0;
          final isTop = e.clientY < midY;

          if (isTop && idx == 0 && state.modifiers[0].isPinned) {
            card.classList.remove('drag-over-top');
            card.classList.remove('drag-over-bottom');
            return;
          }

          if (isTop && idx == _draggedModifierIndex! + 1) {
            card.classList.remove('drag-over-top');
            card.classList.remove('drag-over-bottom');
            return;
          }
          if (!isTop && idx == _draggedModifierIndex! - 1) {
            card.classList.remove('drag-over-top');
            card.classList.remove('drag-over-bottom');
            return;
          }

          e.preventDefault();
          e.dataTransfer?.dropEffect = 'move';
          if (isTop) {
            card.classList.add('drag-over-top');
            card.classList.remove('drag-over-bottom');
          } else {
            card.classList.add('drag-over-bottom');
            card.classList.remove('drag-over-top');
          }
        }).toJS;

        card.ondragleave = ((web.DragEvent e) {
          card.classList.remove('drag-over-top');
          card.classList.remove('drag-over-bottom');
        }).toJS;

        card.ondrop = ((web.DragEvent e) {
          e.preventDefault();
          final isTop = card.classList.contains('drag-over-top');
          card.classList.remove('drag-over-top');
          card.classList.remove('drag-over-bottom');

          final fromIdx =
              _draggedModifierIndex ??
              int.tryParse(e.dataTransfer?.getData('text/plain') ?? '');
          _draggedModifierIndex = null;
          if (fromIdx == null || fromIdx == idx) return;
          if (fromIdx < 0 || fromIdx >= state.modifiers.length) return;
          if (idx < 0 || idx >= state.modifiers.length) return;

          var targetIdx = isTop ? idx : idx + 1;
          if (fromIdx < targetIdx) {
            targetIdx--;
          }
          if (state.modifiers[0].isPinned && targetIdx == 0) {
            targetIdx = 1;
          }
          if (fromIdx == targetIdx) return;

          final moved = state.modifiers.removeAt(fromIdx);
          state.modifiers.insert(targetIdx, moved);
          state.evaluateModifiers();
          updateUI();
          renderModifierStack(state, ui, updateUI);
        }).toJS;
      }

      // Header
      final header = div('modifier-header');
      final headerLeft = div('modifier-header-left');

      if (!mod.isPinned) {
        header.draggable = true;
        header.ondragstart = ((web.DragEvent e) {
          final target = e.target as web.HTMLElement?;
          if (target != null &&
              (target.closest('.modifier-header-actions') != null ||
                  target.tagName.toLowerCase() == 'input' ||
                  target.tagName.toLowerCase() == 'button')) {
            e.preventDefault();
            return;
          }
          _draggedModifierIndex = idx;
          e.dataTransfer?.setData('text/plain', '$idx');
          e.dataTransfer?.effectAllowed = 'move';
          card.classList.add('dragging');
        }).toJS;

        header.ondragend = ((web.DragEvent e) {
          _draggedModifierIndex = null;
          final allCards = modifiersStackList.querySelectorAll(
            '.modifier-card',
          );
          for (var k = 0; k < allCards.length; k++) {
            final el = allCards.item(k) as web.HTMLElement;
            el.classList.remove('dragging');
            el.classList.remove('drag-over-top');
            el.classList.remove('drag-over-bottom');
          }
        }).toJS;

        final dragHandle = span('', 'modifier-drag-handle')
          ..title = 'Drag to reorder'
          ..innerHTML = GraphIcons.grip.toJS;
        headerLeft.appendChild(dragHandle);

        final toggleBtn = button('', 'modifier-btn-icon modifier-btn-enabled')
          ..title = mod.enabled ? 'Enabled' : 'Disabled'
          ..setAttribute('aria-label', 'Enabled')
          ..innerHTML = (mod.enabled ? GraphIcons.eye : GraphIcons.eyeOff).toJS
          ..onClick.listen((e) {
            e.stopPropagation();
            mod.enabled = !mod.enabled;
            mod.collapsed = !mod.enabled;
            state.evaluateModifiers();
            updateUI();
            renderModifierStack(state, ui, updateUI);
          });
        headerLeft.appendChild(toggleBtn);
      }

      final collapseIcon = span('', 'modifier-collapse-icon')
        ..innerHTML =
            (mod.collapsed ? GraphIcons.chevronRight : GraphIcons.chevronDown)
                .toJS;
      headerLeft.appendChild(collapseIcon);

      final titleSpan =
          span(mod.name, hasError ? 'modifier-title error' : 'modifier-title')
            ..title =
                '${mod.description}${mod.complexity != null ? " (${mod.complexity})" : ""}';
      headerLeft.appendChild(titleSpan);
      header.appendChild(headerLeft);

      header.style.cursor = 'pointer';
      header.onClick.listen((web.MouseEvent e) {
        final target = e.target as web.HTMLElement?;
        if (target != null) {
          if (target.closest('.modifier-header-actions') != null ||
              target.closest('.modifier-drag-handle') != null ||
              target.tagName.toLowerCase() == 'input' ||
              target.tagName.toLowerCase() == 'button') {
            return;
          }
        }
        mod.collapsed = !mod.collapsed;
        renderModifierStack(state, ui, updateUI);
      });

      final actions = div('modifier-header-actions');
      web.HTMLButtonElement? btnApply;
      if (mod.canApply) {
        btnApply = button('', 'modifier-btn-icon modifier-btn-apply-icon')
          ..title = 'Apply modifier permanently into base graph'
          ..setAttribute('aria-label', 'Apply modifier permanently')
          ..innerHTML = GraphIcons.check.toJS
          ..onClick.listen((e) {
            e.stopPropagation();
            mod.applyPermanent(state);
            state.evaluateModifiers();
            updateUI();
            renderModifierStack(state, ui, updateUI);
          });
        if (hasError) {
          btnApply.style.display = 'none';
        }
        actions.appendChild(btnApply);
      }

      final btnReset = button('', 'modifier-btn-icon')
        ..title = 'Reset to defaults'
        ..setAttribute('aria-label', 'Reset to defaults')
        ..innerHTML = GraphIcons.reset.toJS
        ..onClick.listen((e) {
          e.stopPropagation();
          mod.resetDefaults();
          state.evaluateModifiers();
          updateUI();
          renderModifierStack(state, ui, updateUI);
        });
      actions.appendChild(btnReset);

      if (!mod.isPinned) {
        final btnRemove = button('', 'modifier-btn-icon')
          ..title = 'Delete'
          ..setAttribute('aria-label', 'Delete')
          ..innerHTML = GraphIcons.close.toJS
          ..onClick.listen((e) {
            e.stopPropagation();
            state.modifiers.removeAt(idx);
            state.evaluateModifiers();
            updateUI();
            renderModifierStack(state, ui, updateUI);
          });
        actions.appendChild(btnRemove);
      }
      header.appendChild(actions);
      card.appendChild(header);

      // Body (if not collapsed)
      void Function()? updateCardBody;
      if (!mod.collapsed) {
        final body = div('modifier-body');
        if (mod.description.isNotEmpty ||
            (mod.complexity != null && mod.complexity!.isNotEmpty)) {
          final helpBox = div('modifier-help-text');
          if (mod.description.isNotEmpty) {
            helpBox.appendChild(span(mod.description));
          }
          if (mod.complexity case final String complexity
              when complexity.isNotEmpty) {
            helpBox.appendChild(
              span(complexity, 'modifier-complexity-badge')
                ..title = 'Time complexity',
            );
          }
          body.appendChild(helpBox);
        }
        final statusContainer = div('modifier-status-container');
        final tableContainer = div('modifier-table-container');

        void updateStatusAndTable() {
          statusContainer.textContent = '';
          tableContainer.textContent = '';

          final currentOut = state.lastModifierOutputs[mod.id];
          final currentErr = currentOut?.hasError ?? false;
          final currentSummary = currentOut?.statusSummary;
          final currentTable = currentOut?.tableData;

          if (currentErr) {
            final errBox = div('modifier-error-alert')
              ..textContent =
                  currentOut?.errorMessage ??
                  'An error occurred in this modifier.';
            statusContainer.appendChild(errBox);
          } else if (currentSummary != null && currentSummary.isNotEmpty) {
            statusContainer.appendChild(
              div('modifier-status')..textContent = currentSummary,
            );
          }

          if (currentTable != null && currentTable.rows.isNotEmpty) {
            final tableWrapper = div('modifier-table-wrapper');
            final headerBar = div('modifier-table-header-bar');
            final tableTitle = span(currentTable.title, 'modifier-table-title');
            headerBar.appendChild(tableTitle);

            final exportBtn = button('Export CSV', 'modifier-btn-export-csv')
              ..title = 'Export table data as CSV'
              ..onClick.listen((e) {
                e.stopPropagation();
                final csv = GraphCodec.exportToCsv(
                  currentTable.headers,
                  currentTable.rows,
                );
                final sanitized = currentTable.title
                    .toLowerCase()
                    .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
                    .replaceAll(RegExp(r'^_+|_+$'), '');
                final filename = sanitized.isEmpty
                    ? '${mod.id}_data.csv'
                    : '$sanitized.csv';
                GraphIO.downloadTextFile(filename, csv, 'text/csv');
              });
            headerBar.appendChild(exportBtn);
            tableWrapper.appendChild(headerBar);

            final tbl = tableElement('table');
            final thead = web.document.createElement('thead');
            final headerRow = web.document.createElement('tr');
            for (final h in currentTable.headers) {
              final th =
                  web.document.createElement('th') as web.HTMLTableCellElement;
              th.textContent = h;
              headerRow.appendChild(th);
            }
            thead.appendChild(headerRow);
            tbl.appendChild(thead);

            final tbody = web.document.createElement('tbody');
            for (final r in currentTable.rows) {
              final row = web.document.createElement('tr');
              for (final cell in r) {
                final td = web.document.createElement(
                  'td',
                ) as web.HTMLTableCellElement;
                td.textContent = cell;
                row.appendChild(td);
              }
              tbody.appendChild(row);
            }
            tbl.appendChild(tbody);
            tableWrapper.appendChild(tbl);
            tableContainer.appendChild(tableWrapper);
          }
        }

        try {
          final configUI = mod.buildConfigUI(state, () {
            state.evaluateModifiers();
            updateUI();
          });
          body.appendChild(configUI);
        } catch (e) {
          final errBox = div('modifier-error-alert')
            ..textContent = 'Failed to load settings: $e';
          body.appendChild(errBox);
        }
        body.appendChild(statusContainer);
        body.appendChild(tableContainer);
        updateStatusAndTable();

        updateCardBody = updateStatusAndTable;
        card.appendChild(body);
      }

      void updateCard() {
        final currentOut = state.lastModifierOutputs[mod.id];
        final currentErr = currentOut?.hasError ?? false;
        card.classList.toggle('error', currentErr);
        card.classList.toggle('disabled', !mod.enabled);
        titleSpan.className = currentErr
            ? 'modifier-title error'
            : 'modifier-title';
        if (btnApply != null) {
          btnApply.style.display = (mod.canApply && !currentErr) ? '' : 'none';
        }
        updateCardBody?.call();
      }

      _modifierCardUpdaters.add(updateCard);
      modifiersStackList.appendChild(card);
    }
  }

  /// Initializes the "Add Modifier" dropdown options and event listeners.
  void init(AppState state, AppUi ui, void Function() updateUI) {
    selectAddModifier.textContent = '';
    final defaultOption = optionElement('', '+ Add Modifier...')
      ..selected = true
      ..disabled = true
      ..setAttribute('hidden', '');
    selectAddModifier.appendChild(defaultOption);

    for (final category in ModifierCategory.values) {
      final specs = ModifierRegistry.byCategory(category);
      final addableSpecs = [
        for (final s in specs)
          if (s.canAdd) s,
      ];
      if (addableSpecs.isEmpty) continue;
      final optGroup =
          web.document.createElement('optgroup') as web.HTMLOptGroupElement
            ..label = category.label;
      for (final spec in addableSpecs) {
        optGroup.appendChild(optionElement(spec.type, spec.name));
      }
      selectAddModifier.appendChild(optGroup);
    }

    selectAddModifier.onChange.listen((_) {
      final type = selectAddModifier.value;
      if (type.isNotEmpty) {
        final mod = ModifierRegistry.create(type);
        state.modifiers.add(mod);
        selectAddModifier.value = '';
        selectAddModifier.selectedIndex = 0;
        state.evaluateModifiers();
        updateUI();
        renderModifierStack(state, ui, updateUI);
      }
    });
  }
}
