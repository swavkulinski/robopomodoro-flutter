import 'package:test/test.dart';
import '../../lib/main/digit/path_builder.dart';
import '../../lib/main/digit/models.dart';
import 'session_widget_model_mock.dart';


void main() {

  SessionWidgetModel mockModel = new SessionWidgetModel()
  ..config = mockConfig
  ..elapsed = 0
  ..startTime = mockTime
  ..session = mockSession; 

  PathBuilder mockPathBuilder = new PathBuilder(mockConfig, mockModel);

  //TODO learn to write widget tests

}
