// GENERATED CODE - DO NOT MODIFY BY HAND
// Copyright (C) 2020 covid19cuba
// Use of this source code is governed by a GNU GPL 3 license that can be
// found in the LICENSE file.

part of 'tests_by_days.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TestsByDays _$TestsByDaysFromJson(Map<String, dynamic> json) {
  return TestsByDays()
    ..date = json['date'] == null
        ? null
        : ItemDateList.fromJson(json['date'] as Map<String, dynamic>)
    ..negative = json['negative'] == null
        ? null
        : ItemList.fromJson(json['negative'] as Map<String, dynamic>)
    ..positive = json['positive'] == null
        ? null
        : ItemList.fromJson(json['positive'] as Map<String, dynamic>)
    ..total = json['total'] == null
        ? null
        : ItemList.fromJson(json['total'] as Map<String, dynamic>);
}

Map<String, dynamic> _$TestsByDaysToJson(TestsByDays instance) =>
    <String, dynamic>{
      'date': instance.date,
      'negative': instance.negative,
      'positive': instance.positive,
      'total': instance.total,
    };
