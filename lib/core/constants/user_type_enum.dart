enum UserTypeEnum {
  patient("patient");

  final String value;
  const UserTypeEnum(this.value);

  static UserTypeEnum fromString(String value) {
    switch (value) {
      case "patient":
        return UserTypeEnum.patient;

      default:
        return UserTypeEnum.patient;
    }
  }
}
