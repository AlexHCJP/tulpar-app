import 'package:garage/data/params/index.dart';

enum IndexProducerSortBy {
  id, name;
}

class IndexProducerParams extends IndexParams {
  final IndexProducerSortBy sortBy;
  final String? filter;

  IndexProducerParams({
    super.descending,
    super.rowsPerPage,
    super.startRow,
    this.filter,
    this.sortBy = IndexProducerSortBy.id
  });

  copyWith({
    int? rowsPerPage,
    int? startRow,
    bool? descending,
    String? filter,
    IndexProducerSortBy? sortBy
  }) {
    return IndexProducerParams(
      rowsPerPage: rowsPerPage ?? this.rowsPerPage,
      startRow: startRow ?? this.startRow,
      descending: descending ?? this.descending,
      filter: filter ?? this.filter,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  @override
  Map<String, dynamic> toData() {
    return {
      'sortBy': sortBy.name,
      'filter': filter
    }..addAll(super.toData());
  }
}