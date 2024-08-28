/// This class will contain all of the data the we get from the Backend side(From the API), this
/// class is kind of wrapper around onesignal and firebase so that we can get desired values as
/// expected. If your backend team is sending the data that is not available in this class then
/// feel free to add it
class NotificationObserverEvent {
  const NotificationObserverEvent({
    this.redirectionUrl,
    this.title,
    this.body,
  });
  final String? redirectionUrl;
  final String? title;
  final String? body;

  @override
  String toString() {
    return 'NotificationObserverEvent{redirectionUrl: $redirectionUrl, title: $title, body: $body}';
  }
}
