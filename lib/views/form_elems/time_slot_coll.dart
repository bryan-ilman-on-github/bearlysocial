import 'dart:collection';

import 'package:bearlysocial/views/buttons/splash_btn.dart';
import 'package:bearlysocial/views/pictures/profile_pic.dart' as reusables;
import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/providers/form_fields/schedule_state.dart';
import 'package:bearlysocial/utils/form_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimeSlotCollection extends ConsumerStatefulWidget {
  final String dateTimeRange;
  final SplayTreeMap meetups;

  const TimeSlotCollection({
    super.key,
    required this.dateTimeRange,
    required this.meetups,
  });

  @override
  ConsumerState<TimeSlotCollection> createState() => _TimeSlotCollectionState();
}

class _TimeSlotCollectionState extends ConsumerState<TimeSlotCollection> {
  bool expanded = false;

  void _toggleExpansion() {
    setState(() {
      expanded = !expanded;
    });
  }

  String _formatDateTimeRange(String dateTimeRange) {
    final dates = dateTimeRange.split('#');
    final formatIn = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final formatOut = DateFormat('MMM dd, HH:mm');

    final start = formatIn.parse(dates[0]);
    final end = formatIn.parse(dates[1]);

    return '${formatOut.format(start)} → ${formatOut.format(end)}';
  }

  List<Widget> meetupsInfoDisplay(SplayTreeMap map) {
    List<Widget> meetupsWidgets = [];

    map.forEach((key, value) {
      final userDetails = value.split('#');

      meetupsWidgets.add(
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: PaddingSize.verySmall,
              ),
              child: reusables.ProfilePicture(
                uid: userDetails[1],
                collapsed: true,
              ),
            ),
            Expanded(
              child: Text(userDetails[0]),
            ),
            Text(key),
            _TimeSlotCollectionButton(
              callbackFunction: () {},
              child: const Icon(
                Icons.close_rounded,
                color: AppColor.heavyRed,
              ),
            )
          ],
        ),
      );
    });

    return meetupsWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        PaddingSize.verySmall,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          width: ThicknessSize.medium,
          color: Theme.of(context).focusColor,
        ),
        borderRadius: BorderRadius.circular(
          CurvatureSize.large,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(
                width: PaddingSize.verySmall / 2.0,
              ),
              Expanded(
                child: SplashButton(
                  verticalPadding: PaddingSize.verySmall,
                  callbackFunction: () async {
                    List<DateTime>? currDateTimeRange =
                        await FormManagement.appDateTimeRangePicker(
                      context: context,
                    );

                    ref.read(updateTimeSlotCollection)(
                      prevDateTimeRange: widget.dateTimeRange,
                      currDateTimeRange: currDateTimeRange,
                      meetups: widget.meetups,
                    );
                  },
                  buttonColor: Colors.transparent,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: MarginSize.small,
                      ),
                      Text(
                        _formatDateTimeRange(widget.dateTimeRange),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          top: PaddingSize.verySmall,
                        ),
                        child: Icon(
                          Icons.edit_note_rounded,
                          size: IconSize.small * 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _TimeSlotCollectionButton(
                callbackFunction: _toggleExpansion,
                child: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                ),
              ),
              _TimeSlotCollectionButton(
                callbackFunction: () => ref.read(deleteTimeSlotCollection)(
                  dateTimeRange: widget.dateTimeRange,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: AppColor.heavyRed,
                ),
              )
            ],
          ),
          if (expanded) ...[
            Padding(
              padding: const EdgeInsets.only(
                left: PaddingSize.verySmall * 1.5,
                top: PaddingSize.verySmall,
              ),
              child: Text('${widget.meetups.length} meetup(s)'),
            ),
            const SizedBox(
              height: WhiteSpaceSize.verySmall,
            ),
            ...meetupsInfoDisplay(widget.meetups),
          ] else
            const SizedBox(),
        ],
      ),
    );
  }
}

class _TimeSlotCollectionButton extends StatelessWidget {
  final void Function() callbackFunction;
  final Icon child;

  const _TimeSlotCollectionButton({
    required this.callbackFunction,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SplashButton(
      horizontalPadding: PaddingSize.verySmall,
      verticalPadding: PaddingSize.verySmall,
      callbackFunction: callbackFunction,
      buttonColor: Colors.transparent,
      borderRadius: const BorderRadius.all(
        Radius.circular(CurvatureSize.infinity),
      ),
      child: child,
    );
  }
}
