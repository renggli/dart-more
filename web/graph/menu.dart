import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'app_ui.dart';
import 'commands.dart';
import 'state.dart';

/// Manages application dropdown menus, triggers, and action dispatching.
class MenuController {
  new({required this.state, required this.ui, required this.onExecuteCommand});

  final AppState state;
  final AppUi ui;
  final void Function(String cmdId) onExecuteCommand;

  bool isAnyMenuOpen = false;

  /// Closes all open menu dropdowns.
  void closeAllMenus() {
    final openMenus = web.document.querySelectorAll('.menu-item.open');
    for (var i = 0; i < openMenus.length; i++) {
      (openMenus.item(i) as web.HTMLElement?)?.classList.remove('open');
    }
    isAnyMenuOpen = false;
  }

  /// Opens the specified [parent] menu item and synchronizes items state.
  void openMenu(web.HTMLElement parent) {
    syncMenuChecks();
    final openMenus = web.document.querySelectorAll('.menu-item.open');
    for (var i = 0; i < openMenus.length; i++) {
      (openMenus.item(i) as web.HTMLElement?)?.classList.remove('open');
    }
    parent.classList.add('open');
    isAnyMenuOpen = true;
  }

  /// Synchronizes checkmarks, enabled states, and trigger buttons for menus.
  void syncMenuChecks() {
    web.document
        .querySelector('[data-cmd="select.mode_vertex"]')
        ?.classList
        .toggle('checked', state.selectVerticesMode);
    web.document
        .querySelector('[data-cmd="select.mode_edge"]')
        ?.classList
        .toggle('checked', state.selectEdgesMode);

    final items = web.document.querySelectorAll('.dropdown-item[data-cmd]');
    for (var i = 0; i < items.length; i++) {
      final item = items.item(i) as web.HTMLElement?;
      final cmdId = item?.getAttribute('data-cmd');
      if (item != null && cmdId != null) {
        final cmd = CommandRegistry.findById(cmdId);
        final enabled = cmd?.canExecute(state, ui) ?? false;
        item.classList.toggle('disabled', !enabled);
      }
    }

    final menus = web.document.querySelectorAll('.menu-item');
    for (var i = 0; i < menus.length; i++) {
      final menu = menus.item(i) as web.HTMLElement?;
      if (menu == null) continue;
      final trigger =
          menu.querySelector('.menu-label') as web.HTMLButtonElement?;
      if (trigger == null) continue;
      final dropdownItems = menu.querySelectorAll('.dropdown-item[data-cmd]');
      var anyEnabled = false;
      for (var j = 0; j < dropdownItems.length; j++) {
        final item = dropdownItems.item(j) as web.HTMLElement?;
        if (item != null && !item.classList.contains('disabled')) {
          anyEnabled = true;
          break;
        }
      }
      trigger.disabled = !anyEnabled;
      if (!anyEnabled) {
        menu.classList.remove('open');
      }
    }
  }

  /// Initializes menu DOM events and external dismiss listeners.
  void init() {
    // Menu triggers
    final menuTriggers = web.document.querySelectorAll('.menu-label');
    for (var i = 0; i < menuTriggers.length; i++) {
      final trigger = menuTriggers.item(i) as web.HTMLButtonElement?;
      if (trigger == null) continue;
      trigger.onClick.listen((event) {
        if (trigger.disabled) return;
        event.stopPropagation();
        final parent = trigger.parentElement as web.HTMLElement?;
        if (parent == null) return;
        if (parent.classList.contains('open')) {
          closeAllMenus();
        } else {
          openMenu(parent);
        }
      });

      trigger.onMouseEnter.listen((event) {
        if (trigger.disabled) return;
        if (isAnyMenuOpen) {
          final parent = trigger.parentElement as web.HTMLElement?;
          if (parent != null && !parent.classList.contains('open')) {
            openMenu(parent);
          }
        }
      });
    }

    // Dismiss open menus on interactions outside
    web.document.addEventListener(
      'pointerdown',
      ((web.PointerEvent event) {
        if (!isAnyMenuOpen) return;
        final target = event.target as web.Element?;
        if (target?.closest('.menu-item') != null) return;
        closeAllMenus();
      }).toJS,
      true.toJS,
    );

    web.document.addEventListener(
      'focusin',
      ((web.FocusEvent event) {
        if (!isAnyMenuOpen) return;
        final target = event.target as web.Element?;
        if (target?.closest('.menu-item') != null) return;
        closeAllMenus();
      }).toJS,
      true.toJS,
    );

    web.document.addEventListener(
      'click',
      ((web.MouseEvent event) {
        if (!isAnyMenuOpen) return;
        final target = event.target as web.Element?;
        if (target?.closest('.menu-item') != null) return;
        closeAllMenus();
      }).toJS,
      true.toJS,
    );

    web.window.addEventListener(
      'blur',
      ((web.Event _) {
        closeAllMenus();
      }).toJS,
    );

    // Dropdown command item clicks
    final menuItems = web.document.querySelectorAll('.dropdown-item');
    for (var i = 0; i < menuItems.length; i++) {
      final item = menuItems.item(i) as web.HTMLElement?;
      if (item == null) continue;
      final cmdId = item.getAttribute('data-cmd');
      if (cmdId != null) {
        item.onClick.listen((event) {
          if (item.classList.contains('disabled')) return;
          event.stopPropagation();
          closeAllMenus();
          onExecuteCommand(cmdId);
        });
      }
    }
  }
}
