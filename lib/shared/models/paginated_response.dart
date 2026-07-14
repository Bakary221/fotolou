class PaginatedResponse<T> {
  const PaginatedResponse({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalItems,
  });

  final List<T> items;
  final int page;
  final int pageSize;
  final int totalItems;

  bool get isEmpty => items.isEmpty;
  bool get hasNextPage => page * pageSize < totalItems;
}
