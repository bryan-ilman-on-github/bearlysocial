import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:bearlysocial/components/buttons/splash_btn.dart';
import 'package:bearlysocial/components/form_elements/social_media_links.dart';
import 'package:bearlysocial/components/texts/warning_message.dart';
import 'package:bearlysocial/constants/db_key.dart';
import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/constants/native_lang_name.dart';
import 'package:bearlysocial/constants/social_media_consts.dart';
import 'package:bearlysocial/constants/translation_key.dart';
import 'package:bearlysocial/providers/form_fields/first_name_focus_state.dart';
import 'package:bearlysocial/providers/form_fields/interest_collection_state.dart';
import 'package:bearlysocial/providers/form_fields/lang_collection_state.dart';
import 'package:bearlysocial/providers/form_fields/last_name_focus_state.dart';
import 'package:bearlysocial/providers/form_fields/profile_pic_loading_state.dart';
import 'package:bearlysocial/providers/form_fields/profile_pic_state.dart';
import 'package:bearlysocial/providers/form_fields/profile_save_state.dart';
import 'package:bearlysocial/utilities/cloud_services_apis.dart';
import 'package:bearlysocial/utilities/db_operation.dart';
import 'package:bearlysocial/utilities/dropdown_operation.dart';
import 'package:bearlysocial/utilities/form_management.dart';
import 'package:bearlysocial/utilities/user_permission.dart';
import 'package:bearlysocial/views/form_fields/first_name.dart';
import 'package:bearlysocial/views/form_fields/interest_collection.dart';
import 'package:bearlysocial/views/form_fields/lang_collection.dart';
import 'package:bearlysocial/views/form_fields/last_name.dart';
import 'package:bearlysocial/views/form_fields/profile_pic.dart' as form_fields;
import 'package:bearlysocial/views/form_fields/time_slots.dart';
import 'package:bearlysocial/views/screens/selfie_screen.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img_lib;
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class ProfilePage extends ConsumerStatefulWidget {
  final ScrollController controller;

  const ProfilePage({
    super.key,
    required this.controller,
  });

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool _resettingChanges = false;
  bool _applyingChanges = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _langController = TextEditingController();

  final TextEditingController _instaLinkController = TextEditingController();
  final TextEditingController _facebookLinkController = TextEditingController();
  final TextEditingController _linkedinLinkController = TextEditingController();

  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();

  final List<List<DateTime>> timeSlots = [];

  // SplayTreeMap<String, int> timeSlots = SplayTreeMap<String, int>();
  // ages.addAll({
  //   'John': 30,
  //   'Alice': 25,
  //   'Bob': 35,
  // });

  void _syncWithDatabase() {
    ref.read(setProfilePicLoadingState)(
      isProfilePicBeingLoaded: true,
    );

    String base64ProfilePic = DatabaseOperation.retrieveTransaction(
      key: DatabaseKey.base_64_profile_pic.name,
    );

    if (base64ProfilePic.isNotEmpty) {
      ref.read(setProfilePic)(
        pic: img_lib.decodeImage(base64Decode(base64ProfilePic)),
      );
    }

    _firstNameController.text = DatabaseOperation.retrieveTransaction(
      key: DatabaseKey.first_name.name,
    );
    _lastNameController.text = DatabaseOperation.retrieveTransaction(
      key: DatabaseKey.last_name.name,
    );

    ref.read(setInterestCollection)(
      collection: FormManagement.stringToList(
        jsonListString: DatabaseOperation.retrieveTransaction(
          key: DatabaseKey.interest.name,
        ),
      ),
    );
    ref.read(setLangCollection)(
      collection: FormManagement.stringToList(
        jsonListString: DatabaseOperation.retrieveTransaction(
          key: DatabaseKey.lang.name,
        ),
      ),
    );

    _interestController.text = '';
    _langController.text = '';

    _instaLinkController.text = DatabaseOperation.retrieveTransaction(
      key: DatabaseKey.insta_handle.name,
    );
    _facebookLinkController.text = DatabaseOperation.retrieveTransaction(
      key: DatabaseKey.fb_handle.name,
    );
    _linkedinLinkController.text = DatabaseOperation.retrieveTransaction(
      key: DatabaseKey.linkedin_handle.name,
    );

    ref.read(setProfilePicLoadingState)(
      isProfilePicBeingLoaded: false,
    );

    ref.read(setProfileSaveState)(
      isProfileSaved: true,
    );
  }

  void _addInterest() {
    if (DropdownOperation.allInterests.containsKey(_interestController.text)) {
      if (ref.read(interestCollection).length >= 4) {
        ref.read(removeFirstLabelFromInterestCollection)();
      }

      ref.read(addLabelToInterestCollection)(
        label: _interestController.text,
      );

      ref.read(setProfileSaveState)(
        isProfileSaved: false,
      );
    }
  }

  void _addLang() {
    if (NativeLanguageName.map.containsKey(_langController.text)) {
      if (ref.read(langCollection).length >= 4) {
        ref.read(removeFirstLabelFromLangCollection)();
      }

      ref.read(addLabelToLangCollection)(
        label: _langController.text,
      );

      ref.read(setProfileSaveState)(
        isProfileSaved: false,
      );
    }
  }

  void _removeInterest({required String labelToRemove}) {
    ref.read(removeLabelFromInterestCollection)(
      labelToRemove: labelToRemove,
    );

    ref.read(setProfileSaveState)(
      isProfileSaved: false,
    );
  }

  void _removeLang({required String labelToRemove}) {
    ref.read(removeLabelFromLangCollection)(
      labelToRemove: labelToRemove,
    );

    ref.read(setProfileSaveState)(
      isProfileSaved: false,
    );
  }

  Future<CameraDescription?> _getFrontCam() async {
    final bool camAllowed = await UserPermission.cameraPermission;

    if (camAllowed) {
      return (await availableCameras()).firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );
    } else {
      return null;
    }
  }

  void _addListenersToControllers(List<TextEditingController> controllers) {
    for (final controller in controllers) {
      controller.addListener(() {
        ref.read(setProfileSaveState)(isProfileSaved: false);
      });
    }
  }

  void _apply() {
    if (ref.read(profilePic) != null) {
      DigitalOceanSpacesAPI.uploadProfilePic(
        profilePic: ref.read(profilePic) as img_lib.Image,
        uid: DatabaseOperation.retrieveTransaction(
          key: DatabaseKey.id.name,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    _addListenersToControllers([
      _firstNameController,
      _lastNameController,
      _interestController,
      _langController,
      _instaLinkController,
      _facebookLinkController,
      _linkedinLinkController,
    ]);

    _firstNameFocusNode.addListener(() {
      ref.read(toggleFirstNameFocusState)();
    });
    _lastNameFocusNode.addListener(() {
      ref.read(toggleLastNameFocusState)();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncWithDatabase();
    });
  }

  @override
  void dispose() {
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SingleChildScrollView(
          controller: widget.controller,
          padding: const EdgeInsets.symmetric(
            horizontal: PaddingSize.medium,
          ),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: WarningMessage(),
              ),
              const SizedBox(
                height: WhiteSpaceSize.verySmall,
              ),
              const form_fields.ProfilePicture(),
              const SizedBox(
                height: WhiteSpaceSize.small,
              ),
              UnconstrainedBox(
                child: SplashButton(
                  horizontalPadding: PaddingSize.small,
                  verticalPadding: PaddingSize.verySmall,
                  callbackFunction: () {
                    _getFrontCam().then((frontCamera) {
                      if (frontCamera != null) {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (_, p, q) => SelfieScreen(
                              frontCamera: frontCamera,
                              onPictureSuccess: ({
                                required img_lib.Image? profilePic,
                              }) {
                                ref.read(setProfilePicLoadingState)(
                                  isProfilePicBeingLoaded: true,
                                );
                                ref.read(setProfilePic)(
                                  pic: profilePic,
                                );
                                ref.read(setProfilePicLoadingState)(
                                  isProfilePicBeingLoaded: false,
                                );

                                ref.read(setProfileSaveState)(
                                  isProfileSaved: false,
                                );
                              },
                            ),
                            transitionDuration: const Duration(
                              seconds: AnimationDuration.instant,
                            ),
                          ),
                        );
                      }
                    });
                  },
                  buttonColor: Theme.of(context).highlightColor,
                  borderColor: Theme.of(context).focusColor,
                  borderRadius: BorderRadius.circular(
                    CurvatureSize.infinity,
                  ),
                  child: Text(
                    'Update Profile Picture',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).focusColor,
                        ),
                  ),
                ),
              ),
              const SizedBox(
                height: WhiteSpaceSize.medium,
              ),
              FirstName(
                controller: _firstNameController,
                focusNode: _firstNameFocusNode,
              ),
              const SizedBox(
                height: WhiteSpaceSize.medium,
              ),
              LastName(
                controller: _lastNameController,
                focusNode: _lastNameFocusNode,
              ),
              const SizedBox(
                height: WhiteSpaceSize.large,
              ),
              InterestCollection(
                controller: _interestController,
                addLabel: _addInterest,
                removeLabel: _removeInterest,
              ),
              const SizedBox(
                height: WhiteSpaceSize.large,
              ),
              LanguageCollection(
                controller: _langController,
                addLabel: _addLang,
                removeLabel: _removeLang,
              ),
              const SizedBox(
                height: WhiteSpaceSize.medium,
              ),
              SocialMediaLink(
                platform: SocialMedia.instagram,
                controller: _instaLinkController,
              ),
              const SizedBox(
                height: WhiteSpaceSize.medium,
              ),
              SocialMediaLink(
                platform: SocialMedia.facebook,
                controller: _facebookLinkController,
              ),
              const SizedBox(
                height: WhiteSpaceSize.medium,
              ),
              SocialMediaLink(
                platform: SocialMedia.linkedin,
                controller: _linkedinLinkController,
              ),
              const SizedBox(
                height: WhiteSpaceSize.large,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'When is your free time?',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(
                height: WhiteSpaceSize.verySmall,
              ),
              const TimeSlots(),
              const SizedBox(
                height: WhiteSpaceSize.verySmall,
              ),
              const TimeSlots(),
              const SizedBox(
                height: WhiteSpaceSize.verySmall,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: UnconstrainedBox(
                  child: SplashButton(
                    horizontalPadding: PaddingSize.small,
                    verticalPadding: PaddingSize.verySmall,
                    callbackFunction: () async {
                      List<DateTime>? timeSlot =
                          await showOmniDateTimeRangePicker(
                        context: context,
                        theme: ThemeData(
                          colorScheme: const ColorScheme.light(
                            primary: AppColor.heavyGray,
                            surface: Colors.transparent,
                            onSurface: AppColor.heavyGray,
                          ),
                        ),
                        is24HourMode: true,
                        isForceEndDateAfterStartDate: true,
                        startInitialDate:
                            DateTime.now().add(const Duration(minutes: 10)),
                        endInitialDate:
                            DateTime.now().add(const Duration(minutes: 20)),
                        startFirstDate: DateTime.now(),
                        endFirstDate: DateTime.now(),
                        startLastDate:
                            DateTime.now().add(const Duration(days: 30)),
                        endLastDate:
                            DateTime.now().add(const Duration(days: 30)),
                        minutesInterval: 5,
                        borderRadius: const BorderRadius.all(Radius.circular(
                          CurvatureSize.large,
                        )),
                        constraints: const BoxConstraints(
                          maxWidth: 350,
                          maxHeight: 650,
                        ),
                        transitionBuilder: (context, animA, animB, child) {
                          return FadeTransition(
                            opacity: animA.drive(
                              Tween(
                                begin: 0.0,
                                end: 1.0,
                              ),
                            ),
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(
                          milliseconds: AnimationDuration.medium,
                        ),
                        barrierDismissible: true,
                      );

                      print(timeSlot);
                    },
                    buttonColor: Theme.of(context).highlightColor,
                    borderColor: Theme.of(context).focusColor,
                    borderRadius: BorderRadius.circular(
                      CurvatureSize.infinity,
                    ),
                    child: Text(
                      'Add a Time Slot',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).focusColor,
                          ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: WhiteSpaceSize.large,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: PaddingSize.medium,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SplashButton(
                      horizontalPadding: PaddingSize.veryLarge,
                      verticalPadding: PaddingSize.small,
                      callbackFunction: _resettingChanges
                          ? null
                          : () {
                              _resettingChanges = true;
                              _syncWithDatabase();
                              _resettingChanges = false;
                            },
                      buttonColor: Colors.transparent,
                      borderColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(
                        CurvatureSize.large,
                      ),
                      child: Text(
                        TranslationKey.resetButton.name.tr(),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).focusColor,
                                ),
                      ),
                    ),
                    SplashButton(
                      horizontalPadding: PaddingSize.veryLarge,
                      verticalPadding: PaddingSize.small,
                      callbackFunction: _applyingChanges
                          ? null
                          : () {
                              _applyingChanges = true;
                              _syncWithDatabase();
                              _applyingChanges = false;
                            },
                      borderRadius: BorderRadius.circular(
                        CurvatureSize.large,
                      ),
                      shadow: Shadow.medium,
                      child: Text(
                        TranslationKey.applyButton.name.tr(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
