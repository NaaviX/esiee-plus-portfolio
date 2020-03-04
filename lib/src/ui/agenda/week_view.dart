import 'dart:math' as math;
import 'package:bde_esiee_mobile/src/ui/agenda/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import 'controller.dart';
import 'day_view.dart';
import 'headers.dart';

/// Builds a day view.
typedef DayViewBuilder = DayView Function(BuildContext context, WeekView weekView, DateTime date, DayViewController dayViewController);

/// Creates a date according to the specified index.
typedef DateCreator = DateTime Function(int index);

/// A (scrollable) week view which is able to display events, zoom and un-zoom and more !
class WeekView extends ZoomableHeadersWidget<WeekViewController> {
  /// The number of events.
  final int dateCount;

  /// The date creator.
  final DateCreator dateCreator;

  /// The events.
  final List<FlutterWeekViewEvent> events;

  /// The day view builder.
  final DayViewBuilder dayViewBuilder;

  /// A day view width.
  final double dayViewWidth;

  /// Creates a new week view instance.
  WeekView({
    List<FlutterWeekViewEvent> events,
    @required List<DateTime> dates,
    this.dayViewBuilder = DefaultBuilders.defaultDayViewBuilder,
    this.dayViewWidth,
    DateFormatter dateFormatter,
    HourFormatter hourFormatter,
    WeekViewController controller,
    TextStyle dayBarTextStyle,
    double dayBarHeight,
    Color dayBarBackgroundColor,
    TextStyle hoursColumnTextStyle,
    double hoursColumnWidth,
    Color hoursColumnBackgroundColor,
    double hourRowHeight,
    bool inScrollableWidget = true,
    bool scrollToCurrentTime = true,
    bool userZoomable = true,
  })  : assert(dates != null && dates.isNotEmpty),
        assert(dayViewBuilder != null),
        dateCount = dates?.length ?? 0,
        dateCreator = ((index) => DefaultBuilders.defaultDateCreator(dates, index)),
        events = events ?? [],
        super(
          controller: controller ?? WeekViewController(dayViewsCount: dates.length),
          dateFormatter: dateFormatter ?? DefaultBuilders.defaultDateFormatter,
          hourFormatter: hourFormatter ?? DefaultBuilders.defaultHourFormatter,
          dayBarTextStyle: dayBarTextStyle,
          dayBarHeight: dayBarHeight,
          dayBarBackgroundColor: dayBarBackgroundColor,
          hoursColumnTextStyle: hoursColumnTextStyle,
          hoursColumnWidth: hoursColumnWidth,
          hoursColumnBackgroundColor: hoursColumnBackgroundColor,
          hourRowHeight: hourRowHeight,
          inScrollableWidget: inScrollableWidget,
          scrollToCurrentTime: scrollToCurrentTime,
          userZoomable: userZoomable,
        );

  /// Creates a new week view instance.
  WeekView.builder({
    List<FlutterWeekViewEvent> events,
    this.dateCount,
    @required this.dateCreator,
    this.dayViewBuilder = DefaultBuilders.defaultDayViewBuilder,
    this.dayViewWidth,
    DateFormatter dateFormatter,
    HourFormatter hourFormatter,
    WeekViewController controller,
    TextStyle dayBarTextStyle,
    double dayBarHeight,
    Color dayBarBackgroundColor,
    TextStyle hoursColumnTextStyle,
    double hoursColumnWidth,
    Color hoursColumnBackgroundColor,
    double hourRowHeight,
    bool inScrollableWidget = true,
    bool scrollToCurrentTime = true,
    bool userZoomable = true,
  })  : assert(dateCount == null || dateCount >= 0),
        assert(dateCreator != null),
        assert(dayViewBuilder != null),
        events = events ?? [],
        super(
          controller: controller ?? WeekViewController(dayViewsCount: dateCount),
          dateFormatter: dateFormatter ?? DefaultBuilders.defaultDateFormatter,
          hourFormatter: hourFormatter ?? DefaultBuilders.defaultHourFormatter,
          dayBarTextStyle: dayBarTextStyle,
          dayBarHeight: dayBarHeight,
          dayBarBackgroundColor: dayBarBackgroundColor,
          hoursColumnTextStyle: hoursColumnTextStyle,
          hoursColumnWidth: hoursColumnWidth,
          hoursColumnBackgroundColor: hoursColumnBackgroundColor,
          hourRowHeight: hourRowHeight,
          inScrollableWidget: inScrollableWidget,
          scrollToCurrentTime: scrollToCurrentTime,
          userZoomable: userZoomable,
        );

  @override
  State<StatefulWidget> createState() => _WeekViewState(this);
}

class Agenda_Utils {
  /// Makes the specified number to have at least two digits by adding a leading zero if needed.
  static String addLeadingZero(int number) => (number < 10 ? '0' : '') + number.toString();

  /// Checks whether the provided date is the same year, month and day than the target date.
  static bool sameDay(DateTime date, [DateTime target]) {
    target = target ?? DateTime.now();
    return target.year == date.year && target.month == date.month && target.day == date.day;
  }

  /// Removes the last word from a string.
  static String removeLastWord(String string) {
    List<String> words = string.split(' ');
    if (words.isEmpty) {
      return '';
    }

    return words.getRange(0, words.length - 1).join(' ');
  }
}

class DefaultBuilders {
  /// Formats a day.
  static String defaultDateFormatter(int year, int month, int day) => year.toString() + '-' + Agenda_Utils.addLeadingZero(month) + '-' + Agenda_Utils.addLeadingZero(day);

  /// Formats a hour.
  static String defaultHourFormatter(int hour, int minute) => Agenda_Utils.addLeadingZero(hour) + ':' + Agenda_Utils.addLeadingZero(minute);

  /// Builds an event text widget in order to put it in a week view.
  static Widget defaultEventTextBuilder(FlutterWeekViewEvent event, BuildContext context, DayView dayView, double height, double width) {
    List<TextSpan> text = [
      TextSpan(
        text: event.title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(
        text: ' ' + dayView.hourFormatter(event.start.hour, event.start.minute) + ' - ' + dayView.hourFormatter(event.end.hour, event.end.minute) + '\n\n',
      ),
      TextSpan(
        text: event.description,
      ),
    ];

    bool exceedHeight;
    while (exceedHeight ?? true) {
      exceedHeight = _exceedHeight(text, event.textStyle, height, width);
      if (exceedHeight == null || !exceedHeight) {
        if (exceedHeight == null) {
          text.clear();
        }
        break;
      }

      if (!_ellipsize(text)) {
        break;
      }
    }

    return RichText(
      text: TextSpan(
        children: text,
        style: event.textStyle,
      ),
    );
  }

  /// Builds a date according to a list.
  static DateTime defaultDateCreator(List<DateTime> dates, int index) => dates[index];

  /// Builds a day view in order to put it in a week view.
  static DayView defaultDayViewBuilder(BuildContext context, WeekView weekView, DateTime date, DayViewController controller) => DayView(
    date: date,
    events: weekView.events,
    hoursColumnWidth: 0,
    controller: controller,
    inScrollableWidget: false,
    dayBarHeight: 0,
    userZoomable: false,
    scrollToCurrentTime: false,
  );

  /// Builds a day bar in order to put it in a week view.
  static DayBar defaultDayBarBuilder(BuildContext context, WeekView weekView, DateTime date) => DayBar(
    date: date,
    height: weekView.dayBarHeight,
    backgroundColor: weekView.dayBarBackgroundColor,
  );

  /// Builds a hours column widget in order to put it in a week view.
  static HoursColumn defaultHoursColumnBuilder(BuildContext context, WeekView weekView, double hourRowHeight) => weekView.hoursColumnWidth <= 0
      ? const SizedBox.shrink()
      : HoursColumn(
    hourRowHeight: hourRowHeight,
    width: weekView.hoursColumnWidth,
  );

  /// Returns whether this input exceeds the specified height.
  static bool _exceedHeight(List<TextSpan> input, TextStyle textStyle, double height, double width) {
    double fontSize = textStyle?.fontSize ?? 14;
    int maxLines = height ~/ ((textStyle?.height ?? 1.2) * fontSize);
    if (maxLines == 0) {
      return null;
    }

    TextPainter painter = TextPainter(
      text: TextSpan(
        children: input,
        style: textStyle,
      ),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    );
    painter.layout(maxWidth: width);
    return painter.didExceedMaxLines;
  }

  /// Ellipsizes the input.
  static bool _ellipsize(List<TextSpan> input, [String ellipse = '…']) {
    if (input.isEmpty) {
      return false;
    }

    TextSpan last = input.last;
    String text = last.text;
    if (text.isEmpty || text == ellipse) {
      input.removeLast();

      if (text == ellipse) {
        _ellipsize(input, ellipse);
      }
      return true;
    }

    String truncatedText;
    if (text.endsWith('\n')) {
      truncatedText = text.substring(0, text.length - 1) + ellipse;
    } else {
      truncatedText = Agenda_Utils.removeLastWord(text);
      truncatedText = truncatedText.substring(0, math.max(0, truncatedText.length - 2)) + ellipse;
    }

    input[input.length - 1] = TextSpan(
      text: truncatedText,
      style: last.style,
    );

    return true;
  }
}

/// Contains some useful methods.
class Utils {
  /// Makes the specified number to have at least two digits by adding a leading zero if needed.
  static String addLeadingZero(int number) => (number < 10 ? '0' : '') + number.toString();

  /// Checks whether the provided date is the same year, month and day than the target date.
  static bool sameDay(DateTime date, [DateTime target]) {
    target = target ?? DateTime.now();
    return target.year == date.year && target.month == date.month && target.day == date.day;
  }

  /// Removes the last word from a string.
  static String removeLastWord(String string) {
    List<String> words = string.split(' ');
    if (words.isEmpty) {
      return '';
    }

    return words.getRange(0, words.length - 1).join(' ');
  }
}

/// A scroll controller that allows to use the [silentJumpTo] method.
class SilentScrollController extends ScrollController {
  /// Creates a new silent scroll controller instance.
  SilentScrollController({
    double initialScrollOffset = 0.0,
    bool keepScrollOffset = true,
    String debugLabel,
  }) : super(
    initialScrollOffset: initialScrollOffset,
    keepScrollOffset: keepScrollOffset,
    debugLabel: debugLabel,
  );

  @override
  _SilentScrollPosition createScrollPosition(
      ScrollPhysics physics,
      ScrollContext context,
      ScrollPosition oldPosition,
      ) {
    return _SilentScrollPosition(
      physics: physics,
      context: context,
      initialPixels: initialScrollOffset,
      keepScrollOffset: keepScrollOffset,
      oldPosition: oldPosition,
      debugLabel: debugLabel,
    );
  }

  /// Silently jumps to the specified position.
  void silentJumpTo(double pixels) {
    assert(positions.isNotEmpty, 'ScrollController not attached to any scroll views.');
    List.from(positions).forEach((position) => position.silentJumpTo(pixels));
  }
}

/// A scroll position that allows to use [silentJumpTo].
class _SilentScrollPosition extends ScrollPositionWithSingleContext {
  /// Creates a new scroll position instance.
  _SilentScrollPosition({
    @required ScrollPhysics physics,
    @required ScrollContext context,
    double initialPixels = 0.0,
    bool keepScrollOffset = true,
    ScrollPosition oldPosition,
    String debugLabel,
  }) : super(
    physics: physics,
    context: context,
    initialPixels: initialPixels,
    keepScrollOffset: keepScrollOffset,
    oldPosition: oldPosition,
    debugLabel: debugLabel,
  );

  /// Silently jumps to the specified position.
  void silentJumpTo(double value) {
    if (pixels != value) {
      forcePixels(value);
    }
  }
}

// Allows to not show the glow effect in scrollable widgets.
class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }

  /// Applies this behavior to a scrollable widget.
  static Widget noGlow({
    Widget child,
  }) =>
      ScrollConfiguration(
        behavior: NoGlowBehavior(),
        child: child,
      );
}

/// A scroll physics that always lands on specific points.
class MagnetScrollPhysics extends ScrollPhysics {
  /// The fixed item size.
  final double itemSize;

  /// Creates a new magnet scroll physics instance.
  const MagnetScrollPhysics({
    ScrollPhysics parent,
    @required this.itemSize,
  }) : super(parent: parent);

  @override
  MagnetScrollPhysics applyTo(ScrollPhysics ancestor) {
    return MagnetScrollPhysics(
      parent: buildParent(ancestor),
      itemSize: itemSize,
    );
  }

  @override
  Simulation createBallisticSimulation(ScrollMetrics position, double velocity) {
    // Scenario 1:
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at the scrollable's boundary.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) || (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }

    // Create a test simulation to see where it would have ballistically fallen
    // naturally without settling onto items.
    final Simulation testFrictionSimulation = super.createBallisticSimulation(position, velocity);

    // Scenario 2:
    // If it was going to end up past the scroll extent, defer back to the
    // parent physics' ballistics again which should put us on the scrollable's
    // boundary.
    if (testFrictionSimulation != null && (testFrictionSimulation.x(double.infinity) == position.minScrollExtent || testFrictionSimulation.x(double.infinity) == position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }

    // From the natural final position, find the nearest item it should have
    // settled to.
    final int settlingItemIndex = _getItemFromOffset(
      offset: testFrictionSimulation?.x(double.infinity) ?? position.pixels,
      minScrollExtent: position.minScrollExtent,
      maxScrollExtent: position.maxScrollExtent,
    );

    final double settlingPixels = settlingItemIndex * itemSize;

    // Scenario 3:
    // If there's no velocity and we're already at where we intend to land,
    // do nothing.
    if (velocity.abs() < tolerance.velocity && (settlingPixels - position.pixels).abs() < tolerance.distance) {
      return null;
    }

    // Scenario 4:
    // If we're going to end back at the same item because initial velocity
    // is too low to break past it, use a spring simulation to get back.
    if (settlingItemIndex ==
        _getItemFromOffset(
          offset: position.pixels,
          minScrollExtent: position.minScrollExtent,
          maxScrollExtent: position.maxScrollExtent,
        )) {
      return SpringSimulation(
        spring,
        position.pixels,
        settlingPixels,
        velocity,
        tolerance: tolerance,
      );
    }

    // Scenario 5:
    // Create a new friction simulation except the drag will be tweaked to land
    // exactly on the item closest to the natural stopping point.
    return FrictionSimulation.through(
      position.pixels,
      settlingPixels,
      velocity,
      tolerance.velocity * velocity.sign,
    );
  }

  /// Returns the item index from the specified offset.
  int _getItemFromOffset({
    double offset,
    double minScrollExtent,
    double maxScrollExtent,
  }) =>
      (_clipOffsetToScrollableRange(offset, minScrollExtent, maxScrollExtent) / itemSize).round();

  /// Clips the specified offset to the scrollable range.
  double _clipOffsetToScrollableRange(
      double offset,
      double minScrollExtent,
      double maxScrollExtent,
      ) =>
      math.min(math.max(offset, minScrollExtent), maxScrollExtent);
}

/// The week view state.
class _WeekViewState extends ZoomableHeadersWidgetState<WeekView, WeekViewController> {
  /// A day view width.
  double dayViewWidth;

  /// Creates a new week view state instance.
  _WeekViewState(WeekView weekView)
      : dayViewWidth = weekView.dayViewWidth;

  @override
  void initState() {
    super.initState();

    if (dayViewWidth != null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      double widgetWidth = (context.findRenderObject() as RenderBox).size.width;
      setState(() {
        dayViewWidth = widgetWidth - widget.hoursColumnWidth;
        scheduleScrollToCurrentTimeIfNeeded();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (dayViewWidth == null) {
      return const SizedBox.expand();
    }

    return createMainWidget();
  }

  /// Creates the main widget.
  Widget createMainWidget() {
    Widget weekViewStack = createWeekViewStack();
    if (widget.inScrollableWidget) {
      weekViewStack = NoGlowBehavior.noGlow(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: widget.dayBarHeight),
          controller: widget.controller.verticalScrollController,
          child: weekViewStack,
        ),
      );
    }

    if (isZoomable) {
      weekViewStack = GestureDetector(
        onScaleStart: (_) => widget.controller.scaleStart(),
        onScaleUpdate: (details) => widget.controller.scaleUpdate(details),
        child: weekViewStack,
      );
    }

    return Stack(
      children: [
        weekViewStack,
        _AutoScrollDayBar(
          state: this,
        ),
        Container(
          height: widget.dayBarHeight,
          width: widget.hoursColumnWidth,
          color: widget.dayBarBackgroundColor ?? const Color(0xFFEBEBEB),
        ),
      ],
    );
  }

  /// Creates the week view stack.
  Widget createWeekViewStack() => Stack(
        children: [
          SizedBox(
            height: calculateHeight(),
            child: ListView.builder(
              padding: EdgeInsets.only(left: widget.hoursColumnWidth),
              controller: widget.controller.horizontalScrollController,
              scrollDirection: Axis.horizontal,
              physics: widget.inScrollableWidget ? MagnetScrollPhysics(itemSize: dayViewWidth) : const NeverScrollableScrollPhysics(),
              itemCount: widget.dateCount,
              itemBuilder: (context, index) => createDayView(index),
            ),
          ),
          HoursColumn.fromHeadersWidget(parent: widget),
        ],
      );

  /// Creates the day view at the specified index.
  Widget createDayView(int index) => SizedBox(
        width: dayViewWidth,
        child: widget.dayViewBuilder(context, widget, widget.dateCreator(index), widget.controller.dayViewControllers[index]),
      );

  @override
  bool get shouldScrollToCurrentTime {
    if (widget.dateCount == null) {
      return false;
    }

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    bool hasCurrentDay = false;
    if (widget.dateCount != null) {
      for (int i = 0; i < widget.dateCount; i++) {
        if (widget.dateCreator(i) == today) {
          hasCurrentDay = true;
          break;
        }
      }
    }

    return dayViewWidth != null && super.shouldScrollToCurrentTime && hasCurrentDay;
  }

  @override
  void scrollToCurrentTime() {
    super.scrollToCurrentTime();

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    int index = 0;
    if (widget.dateCount != null) {
      for (; index < widget.dateCount; index++) {
        if (widget.dateCreator(index) == today) {
          break;
        }
      }
    }

    double topOffset = calculateTopOffset(now.hour, now.minute);
    //double leftOffset = dayViewWidth * index;

    widget.controller.verticalScrollController.jumpTo(math.min(topOffset, widget.controller.verticalScrollController.position.maxScrollExtent));
    widget.controller.horizontalScrollController.jumpTo(MediaQuery.of(context).size.width*10);//math.min(leftOffset, widget.controller.horizontalScrollController.position.maxScrollExtent));
  }
}

/// A day bar that scroll itself according to the current week view scroll position.
class _AutoScrollDayBar extends StatefulWidget {
  /// The week view.
  final WeekView weekView;

  /// A day view width.
  final double dayViewWidth;

  /// Creates a new positioned day bar instance.
  _AutoScrollDayBar({
    @required _WeekViewState state,
  })  : weekView = state.widget,
        dayViewWidth = state.dayViewWidth;

  @override
  State<StatefulWidget> createState() => _AutoScrollDayBarState();
}

/// The auto scroll day bar state.
class _AutoScrollDayBarState extends State<_AutoScrollDayBar> {
  /// The day bar scroll controller.
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    scrollController = SilentScrollController();
    scrollController.addListener(onScrolledHorizontally);
    widget.weekView.controller.horizontalScrollController.addListener(updateScrollPosition);

    WidgetsBinding.instance.scheduleFrameCallback((_) => updateScrollPosition());
  }

  @override
  void didUpdateWidget(_AutoScrollDayBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    widget.weekView.controller.horizontalScrollController.addListener(updateScrollPosition);
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: widget.weekView.dayBarHeight,
        child: ListView.builder(
          itemCount: widget.weekView.dateCount,
          itemBuilder: (context, position) => SizedBox(
            width: widget.dayViewWidth,
            child: DayBar.fromHeadersWidget(
              parent: widget.weekView,
              date: widget.weekView.dateCreator(position),
            ),
          ),
          physics: MagnetScrollPhysics(itemSize: widget.dayViewWidth),
          padding: EdgeInsets.only(left: widget.weekView.hoursColumnWidth),
          controller: scrollController,
          scrollDirection: Axis.horizontal,
        ),
      );

  @override
  void dispose() {
    scrollController.dispose();
    widget.weekView.controller.horizontalScrollController.removeListener(updateScrollPosition);
    super.dispose();
  }

  /// Triggered when this widget is scrolling horizontally.
  void onScrolledHorizontally() => updateScrollBasedOnAnother(scrollController, widget.weekView.controller.horizontalScrollController);

  /// Triggered when the week view is scrolling horizontally.
  void updateScrollPosition() => updateScrollBasedOnAnother(widget.weekView.controller.horizontalScrollController, scrollController);

  /// Updates a scroll controller position based on another scroll controller.
  void updateScrollBasedOnAnother(ScrollController base, SilentScrollController target) {
    if (!mounted) {
      return;
    }

    target.silentJumpTo(base.position.pixels);
  }
}
