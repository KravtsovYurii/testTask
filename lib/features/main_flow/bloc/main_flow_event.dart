abstract class MainFlowEvent {
  const MainFlowEvent();
}

class StartProcessEvent extends MainFlowEvent {
  const StartProcessEvent(this.url);

  final String url;
}

class SendResultsEvent extends MainFlowEvent {
  const SendResultsEvent();
}

class ResetTasksEvent extends MainFlowEvent {
  const ResetTasksEvent();
}
