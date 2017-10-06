import "package:flutter/material.dart";

enum SectionType { WORK, BREAK, COFFEE }

class Section {
  int length;
  SectionType sessionType;
  Paint backgroundPaint;
  Paint foregroundPaint;
  bool signalOnEnd;
  bool signalOnStart;
  Section({
    this.length,
    this.sessionType,
    this.backgroundPaint,
    this.foregroundPaint,
    this.signalOnStart = false,
    this.signalOnEnd = false,
  });
}

class Session {
  String name;
  List<Section> sections;
  int length() => sections
      .map((s) => s.length)
      .reduce((collector, length) => collector += length);

  //TODO failing to find current section
  Section currentSection(int elapsedTime) {
    if (elapsedTime > length()) {
      return sections.last;
    }
    for (var section in sections) {
      elapsedTime -= section.length;
      if (elapsedTime <= 0) return section;
    }
    return sections.last;
  }
  
}

class Schedule {
  List<Session> sessions;
}
