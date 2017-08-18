import 'package:test/test.dart';
import '../../lib/main/digit/path_builder.dart';
import '../../lib/app/models.dart';
import '../../lib/main/digit/models.dart';
import 'session_widget_model_mock.dart';


void main() {

  SessionWidgetModel mockModel = new SessionWidgetModel()
  ..config = mockConfig
  ..elapsed = 0
  ..startTime = mockTime
  ..sections = <Section> [mockSectionOne,mockSectionTwo,mockSectionThree];

  PathBuilder mockPathBuilder = new PathBuilder(mockConfig, mockModel);

  //*/
}
