enum SocialMedia {
  instagram,
  facebook,
  linkedin,
}

extension Getter on SocialMedia {
  String get domain {
    switch (this) {
      case SocialMedia.instagram:
        return 'https:/www.instagram.com/';
      case SocialMedia.facebook:
        return 'https:/www.facebook.com/';
      case SocialMedia.linkedin:
        return 'https:/www.linkedin.com/in/';
      default:
        return '';
    }
  }

  String get icon {
    switch (this) {
      case SocialMedia.instagram:
        return 'instagram_icon.svg';
      case SocialMedia.facebook:
        return 'facebook_icon.svg';
      case SocialMedia.linkedin:
        return 'linkedin_icon.svg';
      default:
        return '';
    }
  }
}
