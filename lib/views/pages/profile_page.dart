import 'package:bearlysocial/components/buttons/splash_btn.dart';
import 'package:bearlysocial/components/form_elements/dropdown.dart';
import 'package:bearlysocial/components/form_elements/social_media_links.dart';
import 'package:bearlysocial/components/form_elements/underlined_txt_field.dart';
import 'package:bearlysocial/components/pictures/profile_pic.dart';
import 'package:bearlysocial/constants/db_key.dart';
import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/constants/native_lang_name.dart';
import 'package:bearlysocial/constants/social_media_consts.dart';
import 'package:bearlysocial/constants/translation_key.dart';
import 'package:bearlysocial/utilities/api.dart';
import 'package:bearlysocial/utilities/db_operation.dart';
import 'package:bearlysocial/utilities/dropdown_operation.dart';
import 'package:bearlysocial/utilities/form_management.dart';
import 'package:bearlysocial/utilities/user_permission.dart';
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
  bool changesNotSaved = false;

  img_lib.Image? _canvas;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _langController = TextEditingController();

  List<String> _interestCollection = [];
  List<String> _langCollection = [];

  final TextEditingController _instaLinkController = TextEditingController();
  final TextEditingController _facebookLinkController = TextEditingController();
  final TextEditingController _linkedinLinkController = TextEditingController();

  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();

  void _syncWithDatabase() {
    _canvas = null;

    _firstNameController.text = DatabaseOperation.retrieveTransaction(
      key: DatabaseKey.first_name.name,
    );
    _lastNameController.text = DatabaseOperation.retrieveTransaction(
      key: DatabaseKey.last_name.name,
    );

    _interestCollection = FormManagement.stringToList(
      jsonListString: DatabaseOperation.retrieveTransaction(
        key: DatabaseKey.interest.name,
      ),
    );
    _langCollection = FormManagement.stringToList(
      jsonListString: DatabaseOperation.retrieveTransaction(
        key: DatabaseKey.lang.name,
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

    changesNotSaved = false;
  }

  void _addInterest() {
    if (DropdownOperation.allInterests.containsKey(_interestController.text)) {
      if (_interestCollection.length >= 4) _interestCollection.removeAt(0);

      setState(() {
        _interestCollection.add(_interestController.text);
        changesNotSaved = true;
      });
    }
  }

  void _addLang() {
    if (NativeLanguageName.map.containsKey(_langController.text)) {
      if (_langCollection.length >= 4) _langCollection.removeAt(0);

      setState(() {
        _langCollection.add(_langController.text);
        changesNotSaved = true;
      });
    }
  }

  void _removeInterest({required String labelToRemove}) {
    setState(() {
      _interestCollection.remove(labelToRemove);
      changesNotSaved = true;
    });
  }

  void _removeLang({required String labelToRemove}) {
    setState(() {
      _langCollection.remove(labelToRemove);
      changesNotSaved = true;
    });
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
        setState(() {
          changesNotSaved = true;
        });
      });
    }
  }

  void _apply() {
    if (_canvas != null) {
      print('HELLO AGAIN!');
      API.imageUpload(
        img: _canvas as img_lib.Image,
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

    _syncWithDatabase();

    _firstNameFocusNode.addListener(() {
      setState(() {});
    });
    _lastNameFocusNode.addListener(() {
      setState(() {});
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
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  changesNotSaved ? 'changes not saved' : '',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: TextSize.medium,
                      ),
                ),
              ),
              const SizedBox(
                height: WhiteSpaceSize.verySmall,
              ),
              ProfilePicture(
                imageSource: _canvas,
              ),
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
                                setState(() {
                                  _canvas = profilePic;
                                  changesNotSaved = true;
                                });
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
                  buttonColor: Theme.of(context).scaffoldBackgroundColor,
                  borderColor: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(
                    CurvatureSize.infinity,
                  ),
                  child: Text(
                    'Update Profile Picture',
                    style: Theme.of(context).textTheme.bodyMedium,
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
              ),
              const SizedBox(
                height: WhiteSpaceSize.medium,
              ),
              UnderlinedTextField(
                label: 'Last Name',
                controller: _lastNameController,
                focusNode: _lastNameFocusNode,
              ),
              const SizedBox(
                height: WhiteSpaceSize.large,
              ),
              Dropdown(
                hint: 'Interest(s)',
                controller: _interestController,
                menu: DropdownOperation.buildMenu(
                  entries: DropdownOperation.allInterests,
                ),
                collection: _interestCollection,
                addLabel: _addInterest,
                removeLabel: _removeInterest,
              ),
              const SizedBox(
                height: WhiteSpaceSize.large,
              ),
              Dropdown(
                hint: 'language(s)',
                controller: _langController,
                menu: DropdownOperation.buildMenu(
                  entries: NativeLanguageName.map,
                ),
                collection: _langCollection,
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
                        is24HourMode: true,
                        isForceEndDateAfterStartDate: true,
                        startInitialDate: DateTime.now().add(const Duration(
                          minutes: 10,
                        )),
                        startFirstDate: DateTime.now(),
                        startLastDate: DateTime.now().add(const Duration(
                          days: 30,
                        )),
                        endInitialDate: DateTime.now().add(const Duration(
                          minutes: 20,
                        )),
                        endFirstDate: DateTime.now(),
                        endLastDate: DateTime.now().add(const Duration(
                          days: 30,
                        )),
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
                        selectableDayPredicate: (dateTime) {
                          if (dateTime == DateTime(2023, 2, 25)) {
                            return false;
                          } else {
                            return true;
                          }
                        },
                      );
                    },
                    buttonColor: Theme.of(context).scaffoldBackgroundColor,
                    borderColor: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(
                      CurvatureSize.infinity,
                    ),
                    child: Text(
                      'Add a Slot',
                      style: Theme.of(context).textTheme.bodyMedium,
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
                      callbackFunction: () => setState(() {
                        _syncWithDatabase();
                      }),
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
                      callbackFunction: _apply,
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
