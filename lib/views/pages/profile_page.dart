// ignore_for_file: camel_case_types

import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:bearlysocial/components/buttons/splash_btn.dart';
import 'package:bearlysocial/components/form_elements/social_media_links.dart';
import 'package:bearlysocial/components/texts/warning_message.dart';
import 'package:bearlysocial/constants/cloud_apis.dart';
import 'package:bearlysocial/constants/db_key.dart';
import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/constants/http_methods.dart';
import 'package:bearlysocial/constants/native_lang_name.dart';
import 'package:bearlysocial/constants/social_media_consts.dart';
import 'package:bearlysocial/constants/translation_key.dart';
import 'package:bearlysocial/providers/form_fields/foci_pod.dart';
import 'package:bearlysocial/providers/form_fields/selections_pod.dart';
import 'package:bearlysocial/providers/form_fields/langs_pod.dart';
import 'package:bearlysocial/providers/form_fields/last_name_focus_state.dart';
import 'package:bearlysocial/providers/form_fields/flags_pod.dart';
import 'package:bearlysocial/providers/form_fields/profile_pic_pod.dart';
import 'package:bearlysocial/providers/form_fields/profile_save_state.dart';
import 'package:bearlysocial/providers/form_fields/schedule_state.dart';
import 'package:bearlysocial/utils/cloud_util.dart';
import 'package:bearlysocial/utils/form_util.dart';
import 'package:bearlysocial/utils/local_db_util.dart';
import 'package:bearlysocial/utils/user_permission_util.dart';
import 'package:bearlysocial/views/form_fields/first_name.dart';
import 'package:bearlysocial/views/form_fields/interest_coll.dart';
import 'package:bearlysocial/views/form_fields/lang_coll.dart';
import 'package:bearlysocial/views/form_fields/last_name.dart';
import 'package:bearlysocial/views/form_fields/profile_pic.dart' as form_fields;
import 'package:bearlysocial/views/form_fields/schedule.dart';
import 'package:bearlysocial/views/screens/selfie_screen.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img_lib;

typedef local_db = LocalDatabaseUtility;
typedef db_key = DatabaseKey;

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
  // Flags for managing state changes.
  bool _resettingChanges = false;
  bool _applyingChanges = false;

  // Text controllers for personal details.
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _interestController = TextEditingController();
  final _langController = TextEditingController();

  // Text controllers for social media links.
  final _instaLinkController = TextEditingController();
  final _facebookLinkController = TextEditingController();
  final _linkedinLinkController = TextEditingController();

  // Focus nodes for managing text field focus.
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();

  void _trackProfileChanges(List<TextEditingController> controllers) {
    for (var c in controllers) {
      // TODO: Improve the 'changes not saved' message handling here.
      c.addListener(() => ref.read(setProfileSaveState)(isProfileSaved: false));
    }
  }

  void _syncWithDatabase() async {
    ref.read(setProfilePicLoadingState)(
      isProfilePicBeingLoaded: true,
    );

    await Future.delayed(Duration(seconds: 10)); // TODO: check this!

    String base64ProfilePic = local_db.retrieveTransaction(
      key: db_key.base_64_profile_pic.name,
    );
    if (base64ProfilePic.isNotEmpty) {
      ref.read(setProfilePicState)(
        picState: img_lib.decodeImage(base64Decode(base64ProfilePic)),
      );
    }

    _firstNameController.text = local_db.retrieveTransaction(
      key: db_key.first_name.name,
    );
    _lastNameController.text = local_db.retrieveTransaction(
      key: db_key.last_name.name,
    );

    ref.read(setInterestSelectState)(
      selectState: jsonDecode(local_db.retrieveTransaction(
        key: db_key.interest_select_code.name,
      )).cast<String>(),
    );
    ref.read(setLangSelectState)(
      selectState: jsonDecode(local_db.retrieveTransaction(
        key: db_key.lang_select_code.name,
      )).cast<String>(),
    );

    _interestController.text = '';
    _langController.text = '';

    _instaLinkController.text = local_db.retrieveTransaction(
      key: db_key.insta_handle.name,
    );
    _facebookLinkController.text = local_db.retrieveTransaction(
      key: db_key.fb_handle.name,
    );
    _linkedinLinkController.text = local_db.retrieveTransaction(
      key: db_key.linkedin_handle.name,
    );

    ref.read(setScheduleState)(
      timeSlots: SplayTreeMap.from(jsonDecode(
        local_db.retrieveTransaction(key: db_key.schedule.name),
      )),
    );

    ref.read(setProfilePicLoadingState)(
      isProfilePicBeingLoaded: false,
    );

    ref.read(setProfileSaveState)(
      isProfileSaved: true,
    );
  }

  void _addInterest() {
    if (FormUtility.allInterests.containsKey(_interestController.text)) {
      if (ref.read(interestSelectState).length >= 4) {
        ref.read(rmvFirstLabelFromInterestSelectState)();
      }

      ref.read(addLabelToInterestSelectState)(
        labelToAdd: _interestController.text,
      );
      _interestController.text = '';

      ref.read(setProfileSaveState)(isProfileSaved: false);
    }
  }

  void _addLang() {
    if (NativeLanguageName.map.containsKey(_langController.text)) {
      if (ref.read(langSelectState).length >= 4) {
        ref.read(rmvFirstLabelFromLangSelectState)();
      }

      ref.read(addLabelToLangSelectState)(
        labelToAdd: _langController.text,
      );
      _langController.text = '';

      ref.read(setProfileSaveState)(isProfileSaved: false);
    }
  }

  void _removeInterest({required String labelToRemove}) {
    ref.read(rmvLabelFromInterestSelectState)(
      labelToRemove: labelToRemove,
    );

    ref.read(setProfileSaveState)(
      isProfileSaved: false,
    );
  }

  void _removeLang({required String labelToRemove}) {
    ref.read(rmvLabelFromLangSelectState)(
      labelToRemove: labelToRemove,
    );

    ref.read(setProfileSaveState)(
      isProfileSaved: false,
    );
  }

  Future<CameraDescription?> _getFrontCam() async {
    final bool camAllowed = await UserPermissionUtility.cameraPermission;

    if (camAllowed) {
      return (await availableCameras()).firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );
    } else {
      return null;
    }
  }

  void _navToSelfieScreen() {
    _getFrontCam().then((frontCamera) {
      if (frontCamera != null) {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_, p, q) => SelfieScreen(
              frontCamera: frontCamera,
              onPictureSuccess: ({
                required img_lib.Image? profilePic,
              }) {
                // TODO: check if all is smooth
                ref.read(setProfilePicLoadingState)(
                  isProfilePicBeingLoaded: true,
                );
                ref.read(setProfilePicState)(
                  picState: profilePic,
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
  }

  void _apply() {
    if (ref.read(profilePicState) != null) {
      // CloudUtility.sendRequest(
      //   endpoint: DigitalOceanDropletAPI.updateProfile,
      //   method: HTTPmethod.,
      //   body: ,
      //   image: ,
      //   onSuccess: ,
      //   onBadRequest: ,
      // );
    }
  }

  @override
  void initState() {
    super.initState();

    _trackProfileChanges([
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
              // Profile Picture Update Button
              UnconstrainedBox(
                child: SplashButton(
                  horizontalPadding: PaddingSize.small,
                  verticalPadding: PaddingSize.verySmall,
                  callbackFunction: _navToSelfieScreen,
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
              FirstNameTextField(
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
              InterestSelectionBoard(
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
              const Schedule(),
              Align(
                alignment: Alignment.centerLeft,
                child: UnconstrainedBox(
                  child: SplashButton(
                    horizontalPadding: PaddingSize.small,
                    verticalPadding: PaddingSize.verySmall,
                    callbackFunction: () async {
                      List<DateTime>? dateTimeRange =
                          await FormManagement.appDateTimeRangePicker(
                        context: context,
                      );

                      ref.read(addTimeSlotCollection)(
                        dateTimeRange: dateTimeRange,
                      );
                    },
                    buttonColor: Theme.of(context).highlightColor,
                    borderColor: Theme.of(context).focusColor,
                    borderRadius: BorderRadius.circular(
                      CurvatureSize.infinity,
                    ),
                    child: Text(
                      'Add Slot(s)',
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
