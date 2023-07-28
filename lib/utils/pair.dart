class Pair<T1, T2> extends Object {
  final T1 first;
  final T2 second;
  Pair(this.first, this.second);

  @override
  bool operator ==(Object other) => other is Pair && first == other.first && second == other.second;

  @override
  int get hashCode => first.hashCode * second.hashCode * 17;
}
