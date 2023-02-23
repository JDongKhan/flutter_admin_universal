// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const Duration _rightSheetEnterDuration = Duration(milliseconds: 250);
const Duration _rightSheetExitDuration = Duration(milliseconds: 200);
const Curve _modalRightSheetCurve = decelerateEasing;
const double _minFlingVelocity = 700.0;
const double _closeProgressThreshold = 0.5;

/// A callback for when the user begins dragging the right sheet.
///
/// Used by [RightSheet.onDragStart].
typedef RightSheetDragStartHandler = void Function(DragStartDetails details);

/// A callback for when the user stops dragging the right sheet.
///
/// Used by [RightSheet.onDragEnd].
typedef RightSheetDragEndHandler = void Function(
  DragEndDetails details, {
  required bool isClosing,
});

/// A Material Design right sheet.
///
/// There are two kinds of right sheets in Material Design:
///
///  * _Persistent_. A persistent right sheet shows information that
///    supplements the primary content of the app. A persistent right sheet
///    remains visible even when the user interacts with other parts of the app.
///    Persistent right sheets can be created and displayed with the
///    [ScaffoldState.showRightSheet] function or by specifying the
///    [Scaffold.rightSheet] constructor parameter.
///
///  * _Modal_. A modal right sheet is an alternative to a menu or a dialog and
///    prevents the user from interacting with the rest of the app. Modal right
///    sheets can be created and displayed with the [showModalRightSheet]
///    function.
///
/// The [RightSheet] widget itself is rarely used directly. Instead, prefer to
/// create a persistent right sheet with [ScaffoldState.showRightSheet] or
/// [Scaffold.rightSheet], and a modal right sheet with [showModalRightSheet].
///
/// See also:
///
///  * [showRightSheet] and [ScaffoldState.showRightSheet], for showing
///    non-modal "persistent" right sheets.
///  * [showModalRightSheet], which can be used to display a modal right
///    sheet.
///  * [RightSheetThemeData], which can be used to customize the default
///    right sheet property values.
///  * <https://material.io/design/components/sheets-right.html>
class RightSheet extends StatefulWidget {
  /// Creates a right sheet.
  ///
  /// Typically, right sheets are created implicitly by
  /// [ScaffoldState.showRightSheet], for persistent right sheets, or by
  /// [showModalRightSheet], for modal right sheets.
  const RightSheet({
    super.key,
    this.animationController,
    this.enableDrag = true,
    this.onDragStart,
    this.onDragEnd,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.constraints,
    required this.onClosing,
    required this.builder,
  })  : assert(enableDrag != null),
        assert(onClosing != null),
        assert(builder != null),
        assert(elevation == null || elevation >= 0.0);

  /// The animation controller that controls the right sheet's entrance and
  /// exit animations.
  ///
  /// The RightSheet widget will manipulate the position of this animation, it
  /// is not just a passive observer.
  final AnimationController? animationController;

  /// Called when the right sheet begins to close.
  ///
  /// A right sheet might be prevented from closing (e.g., by user
  /// interaction) even after this callback is called. For this reason, this
  /// callback might be call multiple times for a given right sheet.
  final VoidCallback onClosing;

  /// A builder for the contents of the sheet.
  ///
  /// The right sheet will wrap the widget produced by this builder in a
  /// [Material] widget.
  final WidgetBuilder builder;

  /// If true, the right sheet can be dragged up and down and dismissed by
  /// swiping downwards.
  ///
  /// Default is true.
  final bool enableDrag;

  /// Called when the user begins dragging the right sheet vertically, if
  /// [enableDrag] is true.
  ///
  /// Would typically be used to change the right sheet animation curve so
  /// that it tracks the user's finger accurately.
  final RightSheetDragStartHandler? onDragStart;

  /// Called when the user stops dragging the right sheet, if [enableDrag]
  /// is true.
  ///
  /// Would typically be used to reset the right sheet animation curve, so
  /// that it animates non-linearly. Called before [onClosing] if the right
  /// sheet is closing.
  final RightSheetDragEndHandler? onDragEnd;

  /// The right sheet's background color.
  ///
  /// Defines the right sheet's [Material.color].
  ///
  /// Defaults to null and falls back to [Material]'s default.
  final Color? backgroundColor;

  /// The z-coordinate at which to place this material relative to its parent.
  ///
  /// This controls the size of the shadow below the material.
  ///
  /// Defaults to 0. The value is non-negative.
  final double? elevation;

  /// The shape of the right sheet.
  ///
  /// Defines the right sheet's [Material.shape].
  ///
  /// Defaults to null and falls back to [Material]'s default.
  final ShapeBorder? shape;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defines the right sheet's [Material.clipBehavior].
  ///
  /// Use this property to enable clipping of content when the right sheet has
  /// a custom [shape] and the content can extend past this shape. For example,
  /// a right sheet with rounded corners and an edge-to-edge [Image] at the
  /// top.
  ///
  /// If this property is null then [RightSheetThemeData.clipBehavior] of
  /// [ThemeData.rightSheetTheme] is used. If that's null then the behavior
  /// will be [Clip.none].
  final Clip? clipBehavior;

  /// Defines minimum and maximum sizes for a [RightSheet].
  ///
  /// Typically a right sheet will cover the entire width of its
  /// parent. However for large screens you may want to limit the width
  /// to something smaller and this property provides a way to specify
  /// a maximum width.
  ///
  /// If null, then the ambient [ThemeData.rightSheetTheme]'s
  /// [RightSheetThemeData.constraints] will be used. If that
  /// is null then the right sheet's size will be constrained
  /// by its parent (usually a [Scaffold]).
  ///
  /// If constraints are specified (either in this property or in the
  /// theme), the right sheet will be aligned to the right-center of
  /// the available space. Otherwise, no alignment is applied.
  final BoxConstraints? constraints;

  @override
  State<RightSheet> createState() => _RightSheetState();

  /// Creates an [AnimationController] suitable for a
  /// [RightSheet.animationController].
  ///
  /// This API available as a convenience for a Material compliant right sheet
  /// animation. If alternative animation durations are required, a different
  /// animation controller could be provided.
  static AnimationController createAnimationController(TickerProvider vsync) {
    return AnimationController(
      duration: _rightSheetEnterDuration,
      reverseDuration: _rightSheetExitDuration,
      debugLabel: 'RightSheet',
      vsync: vsync,
    );
  }
}

class _RightSheetState extends State<RightSheet> {
  final GlobalKey _childKey = GlobalKey(debugLabel: 'RightSheet child');

  double get _childHeight {
    final RenderBox renderBox =
        _childKey.currentContext!.findRenderObject()! as RenderBox;
    return renderBox.size.height;
  }

  bool get _dismissUnderway =>
      widget.animationController!.status == AnimationStatus.reverse;

  void _handleDragStart(DragStartDetails details) {
    widget.onDragStart?.call(details);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    assert(
      widget.enableDrag && widget.animationController != null,
      "'RightSheet.animationController' can not be null when 'RightSheet.enableDrag' is true. "
      "Use 'RightSheet.createAnimationController' to create one, or provide another AnimationController.",
    );
    if (_dismissUnderway) {
      return;
    }
    widget.animationController!.value -= details.primaryDelta! / _childHeight;
  }

  void _handleDragEnd(DragEndDetails details) {
    assert(
      widget.enableDrag && widget.animationController != null,
      "'RightSheet.animationController' can not be null when 'RightSheet.enableDrag' is true. "
      "Use 'RightSheet.createAnimationController' to create one, or provide another AnimationController.",
    );
    if (_dismissUnderway) {
      return;
    }
    bool isClosing = false;
    if (details.velocity.pixelsPerSecond.dy > _minFlingVelocity) {
      final double flingVelocity =
          -details.velocity.pixelsPerSecond.dy / _childHeight;
      if (widget.animationController!.value > 0.0) {
        widget.animationController!.fling(velocity: flingVelocity);
      }
      if (flingVelocity < 0.0) {
        isClosing = true;
      }
    } else if (widget.animationController!.value < _closeProgressThreshold) {
      if (widget.animationController!.value > 0.0) {
        widget.animationController!.fling(velocity: -1.0);
      }
      isClosing = true;
    } else {
      widget.animationController!.forward();
    }

    widget.onDragEnd?.call(
      details,
      isClosing: isClosing,
    );

    if (isClosing) {
      widget.onClosing();
    }
  }

  bool extentChanged(DraggableScrollableNotification notification) {
    if (notification.extent == notification.minExtent) {
      widget.onClosing();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final BottomSheetThemeData rightSheetTheme =
        Theme.of(context).bottomSheetTheme;
    final BoxConstraints? constraints =
        widget.constraints ?? rightSheetTheme.constraints;
    final Color? color =
        widget.backgroundColor ?? rightSheetTheme.backgroundColor;
    final double elevation = widget.elevation ?? rightSheetTheme.elevation ?? 0;
    final ShapeBorder? shape = widget.shape ?? rightSheetTheme.shape;
    final Clip clipBehavior =
        widget.clipBehavior ?? rightSheetTheme.clipBehavior ?? Clip.none;

    Widget rightSheet = Material(
      key: _childKey,
      color: color,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      child: NotificationListener<DraggableScrollableNotification>(
        onNotification: extentChanged,
        child: widget.builder(context),
      ),
    );

    if (constraints != null) {
      rightSheet = Align(
        alignment: Alignment.centerRight,
        heightFactor: 1.0,
        child: ConstrainedBox(
          constraints: constraints,
          child: rightSheet,
        ),
      );
    }

    return !widget.enableDrag
        ? rightSheet
        : GestureDetector(
            onVerticalDragStart: _handleDragStart,
            onVerticalDragUpdate: _handleDragUpdate,
            onVerticalDragEnd: _handleDragEnd,
            excludeFromSemantics: true,
            child: rightSheet,
          );
  }
}

// PERSISTENT BOTTOM SHEETS

// See scaffold.dart

// MODAL BOTTOM SHEETS
class _ModalRightSheetLayout extends SingleChildLayoutDelegate {
  _ModalRightSheetLayout(this.progress, this.isScrollControlled);

  final double progress;
  final bool isScrollControlled;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      maxWidth: isScrollControlled
          ? constraints.maxWidth
          : constraints.maxWidth * 9.0 / 16.0,
      minHeight: constraints.minHeight,
      maxHeight: constraints.maxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(size.width - childSize.width * progress, 0);
  }

  @override
  bool shouldRelayout(_ModalRightSheetLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

class _ModalRightSheet<T> extends StatefulWidget {
  const _ModalRightSheet({
    super.key,
    this.route,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.constraints,
    this.isScrollControlled = false,
    this.enableDrag = true,
  })  : assert(isScrollControlled != null),
        assert(enableDrag != null);

  final _ModalRightSheetRoute<T>? route;
  final bool isScrollControlled;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final BoxConstraints? constraints;
  final bool enableDrag;

  @override
  _ModalRightSheetState<T> createState() => _ModalRightSheetState<T>();
}

class _ModalRightSheetState<T> extends State<_ModalRightSheet<T>> {
  ParametricCurve<double> animationCurve = _modalRightSheetCurve;

  String _getRouteLabel(MaterialLocalizations localizations) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return '';
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return localizations.dialogLabel;
    }
  }

  void handleDragStart(DragStartDetails details) {
    // Allow the right sheet to track the user's finger accurately.
    animationCurve = Curves.linear;
  }

  void handleDragEnd(DragEndDetails details, {bool? isClosing}) {
    // Allow the right sheet to animate smoothly from its current position.
    animationCurve = _RightSheetSuspendedCurve(
      widget.route!.animation!.value,
      curve: _modalRightSheetCurve,
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    assert(debugCheckHasMaterialLocalizations(context));
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final String routeLabel = _getRouteLabel(localizations);

    return AnimatedBuilder(
      animation: widget.route!.animation!,
      child: RightSheet(
        animationController: widget.route!._animationController,
        onClosing: () {
          if (widget.route!.isCurrent) {
            Navigator.pop(context);
          }
        },
        builder: widget.route!.builder!,
        backgroundColor: widget.backgroundColor,
        elevation: widget.elevation,
        shape: widget.shape,
        clipBehavior: widget.clipBehavior,
        constraints: widget.constraints,
        enableDrag: widget.enableDrag,
        onDragStart: handleDragStart,
        onDragEnd: handleDragEnd,
      ),
      builder: (BuildContext context, Widget? child) {
        // Disable the initial animation when accessible navigation is on so
        // that the semantics are added to the tree at the correct time.
        final double animationValue = animationCurve.transform(
          mediaQuery.accessibleNavigation
              ? 1.0
              : widget.route!.animation!.value,
        );
        return Semantics(
          scopesRoute: true,
          namesRoute: true,
          label: routeLabel,
          explicitChildNodes: true,
          child: ClipRect(
            child: CustomSingleChildLayout(
              delegate: _ModalRightSheetLayout(
                  animationValue, widget.isScrollControlled),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class _ModalRightSheetRoute<T> extends PopupRoute<T> {
  _ModalRightSheetRoute({
    this.builder,
    required this.capturedThemes,
    this.barrierLabel,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.constraints,
    this.modalBarrierColor,
    this.isDismissible = true,
    this.enableDrag = true,
    required this.isScrollControlled,
    super.settings,
    this.transitionAnimationController,
    this.anchorPoint,
  })  : assert(isScrollControlled != null),
        assert(isDismissible != null),
        assert(enableDrag != null);

  final WidgetBuilder? builder;
  final CapturedThemes capturedThemes;
  final bool isScrollControlled;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final BoxConstraints? constraints;
  final Color? modalBarrierColor;
  final bool isDismissible;
  final bool enableDrag;
  final AnimationController? transitionAnimationController;
  final Offset? anchorPoint;

  @override
  Duration get transitionDuration => _rightSheetEnterDuration;

  @override
  Duration get reverseTransitionDuration => _rightSheetExitDuration;

  @override
  bool get barrierDismissible => isDismissible;

  @override
  final String? barrierLabel;

  @override
  Color get barrierColor => modalBarrierColor ?? Colors.black54;

  AnimationController? _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    if (transitionAnimationController != null) {
      _animationController = transitionAnimationController;
      willDisposeAnimationController = false;
    } else {
      _animationController = RightSheet.createAnimationController(navigator!);
    }
    return _animationController!;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // By definition, the right sheet is aligned to the right of the page
    // and isn't exposed to the top padding of the MediaQuery.
    final Widget rightSheet = MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: DisplayFeatureSubScreen(
        anchorPoint: anchorPoint,
        child: Builder(
          builder: (BuildContext context) {
            final BottomSheetThemeData sheetTheme =
                Theme.of(context).bottomSheetTheme;
            return _ModalRightSheet<T>(
              route: this,
              backgroundColor: backgroundColor ??
                  sheetTheme.modalBackgroundColor ??
                  sheetTheme.backgroundColor,
              elevation: elevation ??
                  sheetTheme.modalElevation ??
                  sheetTheme.elevation,
              shape: shape,
              clipBehavior: clipBehavior,
              constraints: constraints,
              isScrollControlled: isScrollControlled,
              enableDrag: enableDrag,
            );
          },
        ),
      ),
    );
    return capturedThemes.wrap(rightSheet);
  }
}

// TODO(guidezpl): Look into making this public. A copy of this class is in
//  scaffold.dart, for now, https://github.com/flutter/flutter/issues/51627
/// A curve that progresses linearly until a specified [startingPoint], at which
/// point [curve] will begin. Unlike [Interval], [curve] will not start at zero,
/// but will use [startingPoint] as the Y position.
///
/// For example, if [startingPoint] is set to `0.5`, and [curve] is set to
/// [Curves.easeOut], then the right-left quarter of the curve will be a
/// straight line, and the top-right quarter will contain the entire contents of
/// [Curves.easeOut].
///
/// This is useful in situations where a widget must track the user's finger
/// (which requires a linear animation), and afterwards can be flung using a
/// curve specified with the [curve] argument, after the finger is released. In
/// such a case, the value of [startingPoint] would be the progress of the
/// animation at the time when the finger was released.
///
/// The [startingPoint] and [curve] arguments must not be null.
class _RightSheetSuspendedCurve extends ParametricCurve<double> {
  /// Creates a suspended curve.
  const _RightSheetSuspendedCurve(
    this.startingPoint, {
    this.curve = Curves.easeOutCubic,
  })  : assert(startingPoint != null),
        assert(curve != null);

  /// The progress value at which [curve] should begin.
  ///
  /// This defaults to [Curves.easeOutCubic].
  final double startingPoint;

  /// The curve to use when [startingPoint] is reached.
  final Curve curve;

  @override
  double transform(double t) {
    assert(t >= 0.0 && t <= 1.0);
    assert(startingPoint >= 0.0 && startingPoint <= 1.0);

    if (t < startingPoint) {
      return t;
    }

    if (t == 1.0) {
      return t;
    }

    final double curveProgress = (t - startingPoint) / (1 - startingPoint);
    final double transformed = curve.transform(curveProgress);
    return lerpDouble(startingPoint, 1, transformed)!;
  }

  @override
  String toString() {
    return '${describeIdentity(this)}($startingPoint, $curve)';
  }
}

/// Shows a modal Material Design right sheet.
///
/// A modal right sheet is an alternative to a menu or a dialog and prevents
/// the user from interacting with the rest of the app.
///
/// A closely related widget is a persistent right sheet, which shows
/// information that supplements the primary content of the app without
/// preventing the user from interacting with the app. Persistent right sheets
/// can be created and displayed with the [showRightSheet] function or the
/// [ScaffoldState.showRightSheet] method.
///
/// The `context` argument is used to look up the [Navigator] and [Theme] for
/// the right sheet. It is only used when the method is called. Its
/// corresponding widget can be safely removed from the tree before the right
/// sheet is closed.
///
/// The `isScrollControlled` parameter specifies whether this is a route for
/// a right sheet that will utilize [DraggableScrollableSheet]. If you wish
/// to have a right sheet that has a scrollable child such as a [ListView] or
/// a [GridView] and have the right sheet be draggable, you should set this
/// parameter to true.
///
/// The `useRootNavigator` parameter ensures that the root navigator is used to
/// display the [RightSheet] when set to `true`. This is useful in the case
/// that a modal [RightSheet] needs to be displayed above all other content
/// but the caller is inside another [Navigator].
///
/// The [isDismissible] parameter specifies whether the right sheet will be
/// dismissed when user taps on the scrim.
///
/// The [enableDrag] parameter specifies whether the right sheet can be
/// dragged up and down and dismissed by swiping downwards.
///
/// The optional [backgroundColor], [elevation], [shape], [clipBehavior],
/// [constraints] and [transitionAnimationController]
/// parameters can be passed in to customize the appearance and behavior of
/// modal right sheets (see the documentation for these on [RightSheet]
/// for more details).
///
/// The [transitionAnimationController] controls the right sheet's entrance and
/// exit animations. It's up to the owner of the controller to call
/// [AnimationController.dispose] when the controller is no longer needed.
///
/// The optional `routeSettings` parameter sets the [RouteSettings] of the modal right sheet
/// sheet. This is particularly useful in the case that a user wants to observe
/// [PopupRoute]s within a [NavigatorObserver].
///
/// {@macro flutter.widgets.RawDialogRoute}
///
/// Returns a `Future` that resolves to the value (if any) that was passed to
/// [Navigator.pop] when the modal right sheet was closed.
///
/// {@tool dartpad}
/// This example demonstrates how to use `showModalRightSheet` to display a
/// right sheet that obscures the content behind it when a user taps a button.
/// It also demonstrates how to close the right sheet using the [Navigator]
/// when a user taps on a button inside the right sheet.
///
/// ** See code in examples/api/lib/material/right_sheet/show_modal_right_sheet.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [RightSheet], which becomes the parent of the widget returned by the
///    function passed as the `builder` argument to [showModalRightSheet].
///  * [showRightSheet] and [ScaffoldState.showRightSheet], for showing
///    non-modal right sheets.
///  * [DraggableScrollableSheet], which allows you to create a right sheet
///    that grows and then becomes scrollable once it reaches its maximum size.
///  * [DisplayFeatureSubScreen], which documents the specifics of how
///    [DisplayFeature]s can split the screen into sub-screens.
///  * <https://material.io/design/components/sheets-right.html#modal-right-sheet>
Future<T?> showModalRightSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  double? elevation,
  ShapeBorder? shape,
  Clip? clipBehavior,
  BoxConstraints? constraints,
  Color? barrierColor,
  bool isScrollControlled = false,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  RouteSettings? routeSettings,
  AnimationController? transitionAnimationController,
  Offset? anchorPoint,
}) {
  assert(context != null);
  assert(builder != null);
  assert(isScrollControlled != null);
  assert(useRootNavigator != null);
  assert(isDismissible != null);
  assert(enableDrag != null);
  assert(debugCheckHasMediaQuery(context));
  assert(debugCheckHasMaterialLocalizations(context));

  final NavigatorState navigator =
      Navigator.of(context, rootNavigator: useRootNavigator);
  return navigator.push(_ModalRightSheetRoute<T>(
    builder: builder,
    capturedThemes:
        InheritedTheme.capture(from: context, to: navigator.context),
    isScrollControlled: isScrollControlled,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    backgroundColor: backgroundColor,
    elevation: elevation,
    shape: shape,
    clipBehavior: clipBehavior,
    constraints: constraints,
    isDismissible: isDismissible,
    modalBarrierColor: barrierColor,
    enableDrag: enableDrag,
    settings: routeSettings,
    transitionAnimationController: transitionAnimationController,
    anchorPoint: anchorPoint,
  ));
}
