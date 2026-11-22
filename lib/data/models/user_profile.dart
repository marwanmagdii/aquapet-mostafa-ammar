class UserAddress {
  const UserAddress({
    required this.id,
    required this.label,
    required this.area,
    required this.street,
    this.isDefault = false,
  });

  final String id;
  final String label;
  final String area;
  final String street;
  final bool isDefault;

  UserAddress copyWith({
    String? id,
    String? label,
    String? area,
    String? street,
    bool? isDefault,
  }) {
    return UserAddress(
      id: id ?? this.id,
      label: label ?? this.label,
      area: area ?? this.area,
      street: street ?? this.street,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'area': area,
        'street': street,
        'isDefault': isDefault,
      };

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
        id: json['id'] as String,
        label: json['label'] as String,
        area: json['area'] as String,
        street: json['street'] as String,
        isDefault: json['isDefault'] as bool? ?? false,
      );
}

class UserProfile {
  const UserProfile({
    required this.name,
    required this.phone,
    required this.memberId,
    required this.referralCode,
    this.birthday,
    this.isOnboarded = false,
    this.isLoggedIn = false,
    this.addresses = const [],
    this.profileBonusClaimed = false,
    this.firstTankBonusClaimed = false,
    this.birthdayBonusClaimed = false,
    this.notificationsEnabled = true,
  });

  final String name;
  final String phone;
  final String memberId;
  final String referralCode;
  final DateTime? birthday;
  final bool isOnboarded;
  final bool isLoggedIn;
  final List<UserAddress> addresses;
  final bool profileBonusClaimed;
  final bool firstTankBonusClaimed;
  final bool birthdayBonusClaimed;
  final bool notificationsEnabled;

  UserProfile copyWith({
    String? name,
    String? phone,
    String? memberId,
    String? referralCode,
    DateTime? birthday,
    bool? isOnboarded,
    bool? isLoggedIn,
    List<UserAddress>? addresses,
    bool? profileBonusClaimed,
    bool? firstTankBonusClaimed,
    bool? birthdayBonusClaimed,
    bool? notificationsEnabled,
  }) {
    return UserProfile(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      memberId: memberId ?? this.memberId,
      referralCode: referralCode ?? this.referralCode,
      birthday: birthday ?? this.birthday,
      isOnboarded: isOnboarded ?? this.isOnboarded,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      addresses: addresses ?? this.addresses,
      profileBonusClaimed: profileBonusClaimed ?? this.profileBonusClaimed,
      firstTankBonusClaimed:
          firstTankBonusClaimed ?? this.firstTankBonusClaimed,
      birthdayBonusClaimed: birthdayBonusClaimed ?? this.birthdayBonusClaimed,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'memberId': memberId,
        'referralCode': referralCode,
        'birthday': birthday?.toIso8601String(),
        'isOnboarded': isOnboarded,
        'isLoggedIn': isLoggedIn,
        'addresses': addresses.map((e) => e.toJson()).toList(),
        'profileBonusClaimed': profileBonusClaimed,
        'firstTankBonusClaimed': firstTankBonusClaimed,
        'birthdayBonusClaimed': birthdayBonusClaimed,
        'notificationsEnabled': notificationsEnabled,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name: json['name'] as String? ?? 'Omar',
        phone: json['phone'] as String? ?? '+201012345678',
        memberId: json['memberId'] as String? ?? 'AQP-482910',
        referralCode: json['referralCode'] as String? ?? 'OMAR-FISH',
        birthday: json['birthday'] != null
            ? DateTime.tryParse(json['birthday'] as String)
            : null,
        isOnboarded: json['isOnboarded'] as bool? ?? false,
        isLoggedIn: json['isLoggedIn'] as bool? ?? false,
        addresses: (json['addresses'] as List<dynamic>? ?? [])
            .map((e) => UserAddress.fromJson(e as Map<String, dynamic>))
            .toList(),
        profileBonusClaimed: json['profileBonusClaimed'] as bool? ?? false,
        firstTankBonusClaimed: json['firstTankBonusClaimed'] as bool? ?? false,
        birthdayBonusClaimed: json['birthdayBonusClaimed'] as bool? ?? false,
        notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      );
}
