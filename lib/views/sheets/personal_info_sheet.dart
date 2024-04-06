import 'package:bearlysocial/base_designs/sheets/bottom_sheet.dart'
    as app_bottom_sheet;
import 'package:bearlysocial/components/buttons/splash_btn.dart';
import 'package:bearlysocial/components/form_elements/dropdown.dart';
import 'package:bearlysocial/components/pictures/profile_pic.dart';
import 'package:bearlysocial/components/form_elements/social_media_links.dart';
import 'package:bearlysocial/components/form_elements/underlined_txt_field.dart';
import 'package:bearlysocial/constants/db_key.dart';
import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/constants/native_lang_name.dart';
import 'package:bearlysocial/constants/social_media_consts.dart';
import 'package:bearlysocial/constants/translation_key.dart';
import 'package:bearlysocial/providers/personal_info_saving_state.dart';
import 'package:bearlysocial/utilities/db_operation.dart';
import 'package:bearlysocial/utilities/dropdown_operation.dart';
import 'package:bearlysocial/utilities/form_management.dart';
import 'package:bearlysocial/utilities/user_permission.dart';
import 'package:bearlysocial/views/pages/selfie_screen.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img_lib;

class PersonalInformation extends ConsumerStatefulWidget {
  const PersonalInformation({super.key});

  @override
  ConsumerState<PersonalInformation> createState() =>
      _PersonalInformationState();
}

final _FormState _formState = _FormState.instance;

class _FormState {
  _FormState._privateConstructor() {
    syncWithDatabase();

    firstNameController.addListener(() {
      isFirstNameEdited = savedFirstName != firstNameController.text;
      evaluatePersonalInfoEditingState();
    });
    lastNameController.addListener(() {
      isLastNameEdited = savedLastName != lastNameController.text;
      evaluatePersonalInfoEditingState();
    });
    instaLinkController.addListener(() {
      isInstaUsernameEdited = savedInstaUsername != instaLinkController.text;
      evaluatePersonalInfoEditingState();
    });
    facebookLinkController.addListener(() {
      isFacebookUsernameEdited =
          savedFacebookUsername != facebookLinkController.text;
      evaluatePersonalInfoEditingState();
    });
    linkedinLinkController.addListener(() {
      isLinkedInUsernameEdited =
          savedLinkedInUsername != linkedinLinkController.text;
      evaluatePersonalInfoEditingState();
    });
    emailController.addListener(() {
      isEmailEdited = savedEmail != emailController.text;
      evaluatePersonalInfoEditingState();
    });
    newPasswordController.addListener(() {
      isNewPasswordEdited = newPasswordController.text.isNotEmpty;
      evaluatePersonalInfoEditingState();
    });
    newPasswordConfirmationController.addListener(() {
      isNewPasswordConfirmationEdited =
          newPasswordConfirmationController.text.isNotEmpty;
      evaluatePersonalInfoEditingState();
    });

    initialized = true;
  }

  static final _FormState instance = _FormState._privateConstructor();

  bool initialized = false;
  late WidgetRef ref;

  // Editing Fields
  img_lib.Image? profilePicEdit;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController interestController = TextEditingController();
  final TextEditingController langController = TextEditingController();
  List<String> interestCollectionEdit = [];
  List<String> langCollectionEdit = [];
  final TextEditingController instaLinkController = TextEditingController();
  final TextEditingController facebookLinkController = TextEditingController();
  final TextEditingController linkedinLinkController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController newPasswordConfirmationController =
      TextEditingController();

  // Saved Fields
  late img_lib.Image? savedProfilePic;
  late String savedFirstName;
  late String savedLastName;
  late List<String> savedInterestCollection;
  late List<String> savedLangCollection;
  late String savedInstaUsername;
  late String savedFacebookUsername;
  late String savedLinkedInUsername;
  late String savedEmail;

  // Edit Status Fields
  late bool isProfilePicEdited;
  late bool isFirstNameEdited;
  late bool isLastNameEdited;
  late bool isInterestCollectionEdited;
  late bool isLangCollectionEdited;
  late bool isInstaUsernameEdited;
  late bool isFacebookUsernameEdited;
  late bool isLinkedInUsernameEdited;
  late bool isEmailEdited;
  late bool isNewPasswordEdited;
  late bool isNewPasswordConfirmationEdited;

  void syncWithDatabase() {
    savedProfilePic = null;

    savedFirstName = DatabaseOperation.retrieveTransaction(
      key: DatabaseKey.firstName.name,
    );
    savedLastName = DatabaseOperation.retrieveTransaction(
      key: DatabaseKey.lastName.name,
    );

    savedInterestCollection = FormManagement.stringToList(
      jsonListString: DatabaseOperation.retrieveTransaction(
        key: DatabaseKey.interests.name,
      ),
    );
    savedLangCollection = FormManagement.stringToList(
      jsonListString: DatabaseOperation.retrieveTransaction(
        key: DatabaseKey.languages.name,
      ),
    );

    savedInstaUsername = DatabaseOperation.retrieveTransaction(
      key: DatabaseKey.instagramUsername.name,
    );
    savedFacebookUsername = DatabaseOperation.retrieveTransaction(
      key: DatabaseKey.facebookUsername.name,
    );
    savedLinkedInUsername = DatabaseOperation.retrieveTransaction(
      key: DatabaseKey.linkedinUsername.name,
    );
    savedEmail = DatabaseOperation.retrieveTransaction(
      key: DatabaseKey.email.name,
    );

    undoChanges();
  }

  void undoChanges() {
    // Profile Picture
    profilePicEdit = savedProfilePic;
    isProfilePicEdited = false;

    // First Name
    firstNameController.text = savedFirstName;
    isFirstNameEdited = false;

    // Last Name
    lastNameController.text = savedLastName;
    isLastNameEdited = false;

    // Interests
    interestCollectionEdit = savedInterestCollection;
    interestController.text = '';
    isInterestCollectionEdited = false;

    // Languages
    langCollectionEdit = savedLangCollection;
    langController.text = '';
    isLangCollectionEdited = false;

    // Social Media Links
    instaLinkController.text = savedInstaUsername;
    isInstaUsernameEdited = false;

    facebookLinkController.text = savedFacebookUsername;
    isFacebookUsernameEdited = false;

    linkedinLinkController.text = savedLinkedInUsername;
    isLinkedInUsernameEdited = false;

    // Email
    emailController.text = savedLinkedInUsername;
    isEmailEdited = false;

    // Password
    newPasswordController.text = '';
    isNewPasswordEdited = false;
    newPasswordConfirmationController.text = '';
    isNewPasswordConfirmationEdited = false;

    // Evaluate Personal Info Editing State
    if (initialized) evaluatePersonalInfoEditingState();
  }

  void evaluatePersonalInfoEditingState() {
    // Check if any personal information has been edited
    bool isAnyPersonalInfoEdited = isProfilePicEdited ||
        isFirstNameEdited ||
        isLastNameEdited ||
        isInterestCollectionEdited ||
        isLangCollectionEdited ||
        isInstaUsernameEdited ||
        isFacebookUsernameEdited ||
        isLinkedInUsernameEdited ||
        isEmailEdited ||
        isNewPasswordEdited ||
        isNewPasswordConfirmationEdited;

    // If any personal information has been edited, set the editing state to true
    // Otherwise, set the editing state to false
    ref.watch(setPersonalInfoEditingState)(value: isAnyPersonalInfoEdited);
  }
}

class _PersonalInformationState extends ConsumerState<PersonalInformation> {
  final GlobalKey<ScaffoldState> _sheetKey = GlobalKey<ScaffoldState>();

  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _newPasswordFocusNode = FocusNode();
  final FocusNode _newPasswordConfirmationFocusNode = FocusNode();

  void _setProfilePic({required img_lib.Image? profilePic}) {
    setState(() {
      _formState.profilePicEdit = profilePic;

      _formState.isProfilePicEdited = true;
      _formState.evaluatePersonalInfoEditingState();
    });
  }

  void _addInterest() {
    setState(() {
      _formState.interestCollectionEdit = DropdownOperation.addLabel(
        menu: DropdownOperation.allInterests,
        labelToAdd: _formState.interestController.text,
        labelCollection: _formState.interestCollectionEdit,
      );

      _formState.isInterestCollectionEdited =
          !FormManagement.listsContainSameElements(
        listA: _formState.savedInterestCollection,
        listB: _formState.interestCollectionEdit,
      );

      _formState.evaluatePersonalInfoEditingState();
    });
  }

  void _addLanguage() {
    setState(() {
      _formState.langCollectionEdit = DropdownOperation.addLabel(
        menu: NativeLanguageName.map,
        labelToAdd: _formState.langController.text,
        labelCollection: _formState.langCollectionEdit,
      );

      _formState.isLangCollectionEdited =
          !FormManagement.listsContainSameElements(
        listA: _formState.savedLangCollection,
        listB: _formState.langCollectionEdit,
      );

      _formState.evaluatePersonalInfoEditingState();
    });
  }

  void _removeInterest({required String labelToRemove}) {
    setState(() {
      _formState.interestCollectionEdit = DropdownOperation.removeLabel(
        labelToRemove: labelToRemove,
        labelCollection: _formState.interestCollectionEdit,
      );

      _formState.isInterestCollectionEdited =
          !FormManagement.listsContainSameElements(
        listA: _formState.savedInterestCollection,
        listB: _formState.interestCollectionEdit,
      );

      _formState.evaluatePersonalInfoEditingState();
    });
  }

  void _removeLang({required String labelToRemove}) {
    setState(() {
      _formState.langCollectionEdit = DropdownOperation.removeLabel(
        labelToRemove: labelToRemove,
        labelCollection: _formState.langCollectionEdit,
      );

      _formState.isLangCollectionEdited =
          !FormManagement.listsContainSameElements(
        listA: _formState.savedLangCollection,
        listB: _formState.langCollectionEdit,
      );

      _formState.evaluatePersonalInfoEditingState();
    });
  }

  void _captureSelfie() {
    UserPermission.cameraPermission.then((cameraPermission) async {
      if (!cameraPermission) return;

      final frontCamera = (await availableCameras()).firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );

      final BuildContext? ctx = _sheetKey.currentContext;

      if (ctx != null && ctx.mounted) {
        Navigator.of(ctx).push(
          PageRouteBuilder(
            pageBuilder: (ctx, p, q) => SelfieScreen(
              frontCamera: frontCamera,
              onPictureSuccess: _setProfilePic,
            ),
            transitionDuration: const Duration(
              seconds: AnimationDuration.instant,
            ),
          ),
        );
      }
    });
  }

  void _validateInput() {}

  @override
  void initState() {
    super.initState();

    _formState.ref = ref;

    _firstNameFocusNode.addListener(() {
      setState(() {});
    });
    _lastNameFocusNode.addListener(() {
      setState(() {});
    });
    _emailFocusNode.addListener(() {
      setState(() {});
    });
    _newPasswordFocusNode.addListener(() {
      setState(() {});
    });
    _newPasswordConfirmationFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();

    _emailFocusNode.dispose();
    _newPasswordFocusNode.dispose();
    _newPasswordConfirmationFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return app_bottom_sheet.BottomSheet(
      key: _sheetKey,
      title: TranslationKey.personalInformationTitle.name.tr(),
      content: Column(
        children: [
          ProfilePicture(
            imageSource: _formState.profilePicEdit,
          ),
          const SizedBox(
            height: WhiteSpaceSize.small,
          ),
          UnconstrainedBox(
            child: SplashButton(
              horizontalPadding: PaddingSize.small,
              verticalPadding: PaddingSize.verySmall,
              callbackFunction: _captureSelfie,
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
            controller: _formState.firstNameController,
            focusNode: _firstNameFocusNode,
            errorText: null,
          ),
          const SizedBox(
            height: WhiteSpaceSize.medium,
          ),
          UnderlinedTextField(
            label: 'Last Name',
            controller: _formState.lastNameController,
            focusNode: _lastNameFocusNode,
            errorText: null,
          ),
          const SizedBox(
            height: WhiteSpaceSize.medium,
          ),
          Dropdown(
            hint: 'Interest(s)',
            controller: _formState.interestController,
            menu: DropdownOperation.buildMenu(
              entries: DropdownOperation.allInterests,
            ),
            collection: _formState.interestCollectionEdit,
            addLabel: _addInterest,
            removeLabel: _removeInterest,
          ),
          const SizedBox(
            height: WhiteSpaceSize.large,
          ),
          Dropdown(
            hint: 'language(s)',
            controller: _formState.langController,
            menu: DropdownOperation.buildMenu(
              entries: NativeLanguageName.map,
            ),
            collection: _formState.langCollectionEdit,
            addLabel: _addLanguage,
            removeLabel: _removeLang,
          ),
          const SizedBox(
            height: WhiteSpaceSize.medium,
          ),
          SocialMediaLink(
            platform: SocialMedia.instagram,
            controller: _formState.instaLinkController,
          ),
          const SizedBox(
            height: WhiteSpaceSize.medium,
          ),
          SocialMediaLink(
            platform: SocialMedia.facebook,
            controller: _formState.facebookLinkController,
          ),
          const SizedBox(
            height: WhiteSpaceSize.medium,
          ),
          SocialMediaLink(
            platform: SocialMedia.linkedin,
            controller: _formState.linkedinLinkController,
          ),
          const SizedBox(
            height: WhiteSpaceSize.medium,
          ),
          UnderlinedTextField(
            label: 'Email',
            controller: _formState.emailController,
            focusNode: _emailFocusNode,
            errorText: null,
          ),
          const SizedBox(
            height: WhiteSpaceSize.medium,
          ),
          UnderlinedTextField(
            label: 'New Password',
            controller: _formState.newPasswordController,
            focusNode: _newPasswordFocusNode,
            errorText: null,
          ),
          const SizedBox(
            height: WhiteSpaceSize.medium,
          ),
          UnderlinedTextField(
            label: 'New Password Confirmation',
            controller: _formState.newPasswordConfirmationController,
            focusNode: _newPasswordConfirmationFocusNode,
            errorText: null,
          ),
        ],
      ),
      closure: [
        SplashButton(
          horizontalPadding: PaddingSize.veryLarge,
          verticalPadding: PaddingSize.small,
          callbackFunction: () {
            setState(() {
              _formState.undoChanges();
            });
          },
          buttonColor: Colors.transparent,
          borderColor: Colors.transparent,
          borderRadius: BorderRadius.circular(
            CurvatureSize.large,
          ),
          child: Text(
            TranslationKey.resetButton.name.tr(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).focusColor,
                ),
          ),
        ),
        SplashButton(
          horizontalPadding: PaddingSize.veryLarge,
          verticalPadding: PaddingSize.small,
          callbackFunction: () {},
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
    );
  }
}
