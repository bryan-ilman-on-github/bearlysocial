// ignore_for_file: camel_case_types

import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:bearlysocial/views/buttons/splash_btn.dart';
import 'package:bearlysocial/views/form_elems/selector.dart';
import 'package:bearlysocial/views/form_elems/social_media_links.dart';
import 'package:bearlysocial/views/form_elems/underlined_txt_field.dart';
import 'package:bearlysocial/views/texts/warning_message.dart';
import 'package:bearlysocial/constants/cloud_apis.dart';
import 'package:bearlysocial/constants/db_key.dart';
import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/constants/http_methods.dart';
import 'package:bearlysocial/constants/native_lang_name.dart';
import 'package:bearlysocial/constants/social_media_consts.dart';
import 'package:bearlysocial/constants/translation_key.dart';
import 'package:bearlysocial/constants/txt_sym.dart';
import 'package:bearlysocial/providers/form_fields/foci_pod.dart';
import 'package:bearlysocial/providers/form_fields/selections_pod.dart';
import 'package:bearlysocial/providers/form_fields/flags_pod.dart';
import 'package:bearlysocial/providers/form_fields/profile_pic_pod.dart';
import 'package:bearlysocial/providers/form_fields/schedule_state.dart';
import 'package:bearlysocial/utils/cloud_util.dart';
import 'package:bearlysocial/utils/form_util.dart';
import 'package:bearlysocial/utils/local_db_util.dart';
import 'package:bearlysocial/utils/user_permission_util.dart';
import 'package:bearlysocial/views/form_elems/profile_pic_canvas.dart';
import 'package:bearlysocial/views/form_elems/schedule.dart';
import 'package:bearlysocial/views/screens/selfie_screen.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img_lib;

typedef local_db = LocalDatabaseUtility;
typedef db_key = DatabaseKey;
typedef txt_sym = TextSymbol;

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
      c.addListener(() => ref.read(setProfileSaveFlag)(false));
    }
  }

  void _syncWithDatabase() async {
    ref.read(setLoadingProfilePicFlag)(true);

    await Future.delayed(Duration(seconds: 10)); // TODO: check this!

    String bytes =
        local_db.retrieveTransaction(key: db_key.base_64_profile_pic.name);

    if (bytes.isNotEmpty) {
      ref.read(setProfilePic)(img_lib.decodeImage(base64Decode(bytes)));
    }

    _firstNameController.text = local_db.retrieveTransaction(
      key: db_key.first_name.name,
    );
    _lastNameController.text = local_db.retrieveTransaction(
      key: db_key.last_name.name,
    );

    ref.read(setInterests)(
      jsonDecode(local_db.retrieveTransaction(key: db_key.interests_code.name))
          .cast<String>(),
    );
    ref.read(setLangs)(
      jsonDecode(local_db.retrieveTransaction(key: db_key.langs_code.name))
          .cast<String>(),
    );

    _interestController.text = txt_sym.emptyString;
    _langController.text = txt_sym.emptyString;

    _instaLinkController.text = local_db.retrieveTransaction(
      key: db_key.insta_handle.name,
    );
    _facebookLinkController.text = local_db.retrieveTransaction(
      key: db_key.fb_handle.name,
    );
    _linkedinLinkController.text = local_db.retrieveTransaction(
      key: db_key.linkedin_handle.name,
    );

    ref.read(setSchedule)(SplayTreeMap.from(jsonDecode(
      local_db.retrieveTransaction(key: db_key.schedule.name),
    )));

    ref.read(setLoadingProfilePicFlag)(false);
    ref.read(setProfileSaveFlag)(true);
  }

  final _allInterests = FormUtility.allInterests;

  void _addInterest() {
    if (_allInterests.containsKey(_interestController.text)) {
      if (ref.read(interests).length >= 4) ref.read(removeFirstInterest)();

      ref.read(addInterest)(_interestController.text);
      _interestController.text = txt_sym.emptyString;

      ref.read(setProfileSaveFlag)(false);
    }
  }

  void _addLang() {
    if (NativeLanguageName.map.containsKey(_langController.text)) {
      if (ref.read(langs).length >= 4) ref.read(removeFirstLang)();

      ref.read(addLang)(_langController.text);
      _langController.text = txt_sym.emptyString;

      ref.read(setProfileSaveFlag)(false);
    }
  }

  void _removeInterest(String entry) {
    ref.read(removeInterest)(entry);
    ref.read(setProfileSaveFlag)(false);
  }

  void _removeLang(String entry) {
    ref.read(removeLang)(entry);
    ref.read(setProfileSaveFlag)(false);
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
              onSuccess: (img_lib.Image? img) {
                // TODO: check if all is smooth.
                ref.read(setLoadingProfilePicFlag)(true);
                ref.read(setProfilePic)(img);
                ref.read(setLoadingProfilePicFlag)(false);
                ref.read(setProfileSaveFlag)(false);
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
    if (ref.read(profilePic) != null) {
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
      ref.read(toggleFirstNameFocus)();
    });
    _lastNameFocusNode.addListener(() {
      ref.read(toggleLastNameFocus)();
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
        // TODO: check if color is necessary.
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
              const ProfilePictureCanvas(),
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
                  borderRadius: BorderRadius.circular(CurvatureSize.infinity),
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
              UnderlinedTextField(
                label: 'First Name',
                controller: _firstNameController,
                focusNode: _firstNameFocusNode,
                focusPod: firstNameFocus,
              ),
              const SizedBox(
                height: WhiteSpaceSize.medium,
              ),
              UnderlinedTextField(
                label: 'Last Name',
                controller: _lastNameController,
                focusNode: _lastNameFocusNode,
                focusPod: lastNameFocus,
              ),
              const SizedBox(
                height: WhiteSpaceSize.large,
              ),
              Selector(
                hint: 'Interest(s)',
                menu: FormUtility.buildDropdownMenu(entries: _allInterests),
                controller: _interestController,
                entries: ref.watch(interests),
                addEntry: _addInterest,
                removeEntry: _removeInterest,
              ),
              const SizedBox(
                height: WhiteSpaceSize.large,
              ),
              Selector(
                hint: 'Language(s)',
                menu: FormUtility.buildDropdownMenu(
                  entries: NativeLanguageName.map,
                ),
                controller: _langController,
                entries: ref.watch(langs),
                addEntry: _addLang,
                removeEntry: _removeLang,
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
