class IntervalModel {
  int duration;
  int warning;
  IntervalType type;

  IntervalModel({required this.duration, required this.type, required this.warning});
}

enum IntervalType {
  rest,
  delay,
  round,
}
