import 'dart:math' as math;

import 'package:bde_esiee_mobile/src/models/course_model.dart';
import 'package:flutter/material.dart';

import 'course_info.dart';
import 'day_view.dart';
import 'utils.dart';

/// Represents a flutter week view event.
class AgendaEventView extends Comparable<AgendaEventView> {
  /// The course
  final CourseModel course;

  /// The event widget background color.
  final Color backgroundColor;

  /// The event widget decoration.
  final BoxDecoration decoration;

  /// The event text widget text style.
  final TextStyle textStyle;

  /// The event widget padding.
  final EdgeInsets padding;

  /// The event widget margin.
  final EdgeInsets margin;

  /// The event widget long press event.
  final VoidCallback onLongPress;

  /// The event text builder.
  final EventTextBuilder eventTextBuilder;

  /// Creates a new flutter week view event instance.
  AgendaEventView({
    this.course,
    this.backgroundColor = const Color(0xCC2196F3),
    this.decoration,
    this.textStyle = const TextStyle(color: Colors.white),
    this.padding = const EdgeInsets.all(5),
    this.margin,
    this.onLongPress,
    this.eventTextBuilder,
  })  : assert(course.title != null),
        assert(course.description != null),
        assert(course.start != null),
        assert(course.end != null);

  /// Builds the event widget.
  Widget build(BuildContext context, DayView dayView, double height, double width) {
    height = height - (padding?.top ?? 0.0) - (padding?.bottom ?? 0.0);
    width = width - (padding?.left ?? 0.0) - (padding?.right ?? 0.0);

    return GestureDetector(
      onTap: () {
        showDialog<void>(
            context: context,
            barrierDismissible: true,
            // user must tap button!
            builder: (BuildContext context) {
              return CourseInfoPage(
                  course: new CourseModel(
                      title: this.title,
                      start: this.start,
                      end: this.end,
                      type: "TD",
                      location: "5301V, 5308, 5309V",
                      description: "2I\n1I\n4I-RV1",
                      updated: DateTime.now()
                  )
              );
            });
      },
      onLongPress: onLongPress,
      child: Container(
        decoration: decoration ?? (backgroundColor != null ? BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(10), border: Border.all(
            color: Colors.white, width: 0.3, style: BorderStyle.solid
        )) : null
        ),
        margin: margin,
        padding: padding,
        child: (eventTextBuilder ?? DefaultBuilders.defaultEventTextBuilder)(
          this,
          context,
          dayView,
          math.max(0.0, height),
          math.max(0.0, width),
        ),
      ),
    );
  }

  @override
  int compareTo(AgendaEventView other) {
    int result = this.course.start.compareTo(other.course.start);
    if (result != 0) {
      return result;
    }
    return this.course.end.compareTo(other.course.end);
  }
}
