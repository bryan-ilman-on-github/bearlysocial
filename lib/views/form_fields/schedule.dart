import 'dart:collection';

import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/providers/form_fields/schedule_state.dart';
import 'package:bearlysocial/views/form_fields/time_slot_coll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Schedule extends ConsumerStatefulWidget {
  const Schedule({super.key});

  @override
  ConsumerState<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends ConsumerState<Schedule> {
  List<Widget> createSchedule(SplayTreeMap map) {
    List<Widget> timeSlotColls = [];

    map.forEach((key, value) {
      timeSlotColls.add(TimeSlotCollection(
        dateTimeRange: key,
        meetups: value,
      ));

      timeSlotColls.add(const SizedBox(
        height: WhiteSpaceSize.verySmall,
      ));
    });

    return timeSlotColls;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: createSchedule(ref.watch(schedule)),
    );
  }
}
