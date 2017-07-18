import "package:flutter/material.dart";

enum SectionType {
  WORK, BREAK, COFFEE
}

class Section {
  int length;
  SectionType sessionType;
  Paint backgroundPaint;
  Paint foregroundPaint;
  Section({
    this.length,
    this.sessionType,
    this.backgroundPaint,
    this.foregroundPaint,
  }):
    assert(length > 0),
    assert(sessionType != null),
    assert(backgroundPaint != null),
    assert(foregroundPaint != null);
}

class Session {
  String name;
  List<Section> sections;
}

class Schedule {
  List<Session> sessions;
}
