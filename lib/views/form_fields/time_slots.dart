import 'package:bearlysocial/components/buttons/splash_btn.dart';
import 'package:bearlysocial/components/pictures/profile_pic.dart' as reusables;
import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:flutter/material.dart';

class TimeSlots extends StatefulWidget {
  const TimeSlots({super.key});

  @override
  State<TimeSlots> createState() => _TimeSlotsState();
}

class _TimeSlotsState extends State<TimeSlots> {
  bool expanded = false;

  void _toggleExpansion() {
    setState(() {
      expanded = !expanded;
    });
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
                  callbackFunction: _toggleExpansion,
                  buttonColor: Colors.transparent,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: MarginSize.small,
                      ),
                      Text(
                        'May 24, 12:10 → May 24, 14:00',
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
              _TimeSlotButton(
                callbackFunction: _toggleExpansion,
                child: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                ),
              ),
              _TimeSlotButton(
                callbackFunction: () {},
                child: const Icon(
                  Icons.close_rounded,
                  color: AppColor.heavyRed,
                ),
              )
            ],
          ),
          if (expanded) ...[
            const Padding(
              padding: EdgeInsets.only(
                left: PaddingSize.verySmall * 1.5,
                top: PaddingSize.verySmall,
              ),
              child: Text('4 meetup(s)'),
            ),
            const SizedBox(
              height: WhiteSpaceSize.verySmall,
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: PaddingSize.verySmall,
                  ),
                  child: reusables.ProfilePicture(uid: 'uid', collapsed: true),
                ),
                const Expanded(
                  child: Text('Bryan'),
                ),
                const Text('May 24, 12:20'),
                _TimeSlotButton(
                  callbackFunction: () {},
                  child: const Icon(
                    Icons.close_rounded,
                    color: AppColor.heavyRed,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: WhiteSpaceSize.verySmall,
            ),
          ] else
            const SizedBox(),
        ],
      ),
    );
  }
}

class _TimeSlotButton extends StatelessWidget {
  final void Function() callbackFunction;
  final Icon child;

  const _TimeSlotButton({
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
