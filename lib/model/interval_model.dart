class IntervalModel {
  int duration;
  IntervalType type;

  IntervalModel({required this.duration, required this.type});
}

enum IntervalType {
  rest,
  delay,
  round,
}
