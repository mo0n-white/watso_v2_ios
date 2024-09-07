import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

const completeColor = Color(0xff5e6172);
const inProgressColor = Color(0xff5ec792);
const todoColor = Color(0xffd1d2d7);

class MessagingTimeline extends StatefulWidget {
  const MessagingTimeline(
      {super.key, required this.processIndex, required this.processes});

  final int processIndex;
  final List<String> processes;

  @override
  State<MessagingTimeline> createState() => _MessagingTimelineState();
}

class _MessagingTimelineState extends State<MessagingTimeline> {
  Color getColor(int index) {
    if (index == widget.processIndex) {
      return inProgressColor;
    } else if (index < widget.processIndex) {
      return completeColor;
    } else {
      return todoColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: LayoutBuilder(builder: (context, constraints) {
        log('constraints: $constraints');
        return SizedBox(
          height: 70,
          child: Timeline.tileBuilder(
            theme: TimelineThemeData(
              nodePosition: 0,
              direction: Axis.horizontal,
              connectorTheme: ConnectorThemeData(
                space: 30.0,
                thickness: 5.0,
              ),
            ),
            builder: TimelineTileBuilder.connected(
              connectionDirection: ConnectionDirection.before,
              itemExtentBuilder: (_, __) =>
                  constraints.maxWidth / widget.processes.length,
              contentsBuilder: (context, index) {
                return Text(
                  widget.processes[index],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: getColor(index),
                    fontSize: 11,
                  ),
                );
              },
              indicatorBuilder: (_, index) {
                var color;
                var child;
                if (index == widget.processIndex) {
                  color = inProgressColor;
                } else if (index < widget.processIndex) {
                  color = completeColor;
                  child = Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 10.0,
                  );
                } else {
                  color = todoColor;
                }

                if (index <= widget.processIndex) {
                  return DotIndicator(
                    size: 20.0,
                    color: color,
                    child: child,
                  );
                } else {
                  return OutlinedDotIndicator(
                    borderWidth: 4.0,
                    color: color,
                  );
                }
              },
              connectorBuilder: (_, index, type) {
                if (index > 0) {
                  if (index == widget.processIndex) {
                    final prevColor = getColor(index - 1);
                    final color = getColor(index);
                    List<Color> gradientColors;
                    if (type == ConnectorType.start) {
                      gradientColors = [
                        Color.lerp(prevColor, color, 0.5)!,
                        color
                      ];
                    } else {
                      gradientColors = [
                        prevColor,
                        Color.lerp(prevColor, color, 0.5)!
                      ];
                    }
                    return DecoratedLineConnector(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradientColors,
                        ),
                      ),
                    );
                  } else {
                    return SolidLineConnector(
                      color: getColor(index),
                    );
                  }
                } else {
                  return null;
                }
              },
              itemCount: widget.processes.length,
            ),
          ),
        );
      }),
    );
  }
}
