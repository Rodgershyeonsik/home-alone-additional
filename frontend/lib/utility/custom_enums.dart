enum SortBy {
  latest(sortValue: "최신순"),
  earliest(sortValue: "오래된순");

  const SortBy({
    required this.sortValue
});

  final String sortValue;

}