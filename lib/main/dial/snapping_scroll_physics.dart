import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'dart:math' as math;

class SnappingScrollPhysics extends ScrollPhysics {
  const SnappingScrollPhysics({
    ScrollPhysics parent,
    @required this.maxScrollOffset,
  })
      : assert(maxScrollOffset != null),
        super(parent: parent);

  final double maxScrollOffset;

  @override
  SnappingScrollPhysics applyTo(ScrollPhysics ancestor) {
    return new SnappingScrollPhysics(
        parent: buildParent(ancestor), maxScrollOffset: maxScrollOffset);
  }

  Simulation _toMaxScrollOffsetSimulation(double offset, double dragVelocity) {
    final double velocity = math.max(dragVelocity, minFlingVelocity);
    return new ScrollSpringSimulation(spring, offset, maxScrollOffset, velocity,
        tolerance: tolerance);
  }

  Simulation _toZeroScrollOffsetSimulation(double offset, double dragVelocity) {
    final double velocity = math.max(dragVelocity, minFlingVelocity);
    return new ScrollSpringSimulation(spring, offset, 0.0, velocity,
        tolerance: tolerance);
  }

  @override
  Simulation createBallisticSimulation(
      ScrollMetrics position, double dragVelocity) {
    final Simulation simulation =
        super.createBallisticSimulation(position, dragVelocity);
    final double offset = position.pixels;

    if (simulation != null) {
      // The drag ended with sufficient velocity to trigger creating a simulation.
      // If the simulation is headed up towards midScrollOffset but will not reach it,
      // then snap it there. Similarly if the simulation is headed down past
      // midScrollOffset but will not reach zero, then snap it to zero.
      final double simulationEnd = simulation.x(maxScrollOffset);
      if (simulationEnd >= maxScrollOffset) return simulation;
      if (dragVelocity > 0.0)
        return _toMaxScrollOffsetSimulation(offset, dragVelocity);
      if (dragVelocity < 0.0)
        return _toZeroScrollOffsetSimulation(offset, dragVelocity);
    } else {
      // The user ended the drag with little or no velocity. If they
      // didn't leave the the offset above midScrollOffset, then
      // snap to midScrollOffset if they're more than halfway there,
      // otherwise snap to zero.
      final double snapThreshold = maxScrollOffset / 2.0;
      if (offset >= snapThreshold && offset < maxScrollOffset)
        return _toMaxScrollOffsetSimulation(offset, dragVelocity);
      if (offset > 0.0 && offset < snapThreshold)
        return _toZeroScrollOffsetSimulation(offset, dragVelocity);
    }
    return simulation;
  }
}
