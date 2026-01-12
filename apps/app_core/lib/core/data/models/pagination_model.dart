// ignore_for_file: avoid_dynamic_calls

import 'package:equatable/equatable.dart';

class PaginationModel extends Equatable {
  const PaginationModel({this.currentPage, this.hasMorePages, this.total});

  factory PaginationModel.fromJson(dynamic json) {
    return PaginationModel(
      currentPage: json['currentPage'] as int?,
      hasMorePages: json['hasMorePages'] as bool?,
      total: json['total'] as int?,
    );
  }
  final int? currentPage;
  final bool? hasMorePages;
  final int? total;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['currentPage'] = currentPage;
    data['hasMorePages'] = hasMorePages;
    data['total'] = total;
    return data;
  }

  @override
  List<Object?> get props => [currentPage, hasMorePages, total];
}
