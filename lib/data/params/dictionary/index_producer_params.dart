import 'package:garage/data/params/index.dart';

enum IndexProducerSortBy {
  id, name;
}

class IndexProducerParams extends IndexParams {
  final IndexProducerSortBy sortBy;
  final String? filter;
  final bool isPopular;

  IndexProducerParams({
    super.descending,
    super.rowsPerPage = 100,
    super.startRow,
    this.filter,
    this.sortBy = IndexProducerSortBy.name,
    this.isPopular = false
  });

  copyWith({
    int? rowsPerPage,
    int? startRow,
    bool? descending,
    String? filter,
    IndexProducerSortBy? sortBy,
    bool? isPopular,
  }) {
    return IndexProducerParams(
      rowsPerPage: rowsPerPage ?? this.rowsPerPage,
      startRow: startRow ?? this.startRow,
      descending: descending ?? this.descending,
      filter: filter ?? this.filter,
      sortBy: sortBy ?? this.sortBy,
      isPopular: isPopular ?? this.isPopular
    );
  }

  @override
  Map<String, dynamic> toData() {
    print(sortBy.name);
    return {
      'sortBy': sortBy.name,
      'filter': filter,
      'is_popular': isPopular ? 1 : 0
    }..addAll(super.toData());
  }
}