int calculateReadingTime(String content) {
  final worldCount = content.split(" ").length;

  final readingTime = worldCount / 225;
  return readingTime.ceil();
}
