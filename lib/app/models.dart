import "package:flutter/material.dart";

enum SectionType {
  WORK, BREAK, COFFEE
}

class Section {
  int length;
  SectionType sessionType;
  Color color;
  Section({
    this.length,
    this.sessionType,
    this.color,
  }):
    assert(length > 0),
    assert(sessionType != null),
    assert(color != null);
}

class Session {
  String name;
  List<Section> sections;
}

class Schedule {
  List<Session> sessions;
}
