import 'package:collection/collection.dart';

enum RideStatus {
  Pending,
  In_progress,
  Completed,
  cancelled,
  searching,
  requested,
  in_progress,
}

enum Role {
  passenger,
  driver,
}

enum VerificationStatus {
  pending,
  approved,
  rejected,
}

enum DocType {
  drivers_license,
  national_id,
}

enum OnlineStatus {
  Online,
  Offline,
}

enum PaymentMethod {
  cash,
  card,
  wallet,
  Cash,
}

enum PaymentStatus {
  pending,
  completed,
  failed,
}

enum Ridetype {
  standard,
  premium,
  car,
}

extension FFEnumExtensions<T extends Enum> on T {
  String serialize() => name;
}

extension FFEnumListExtensions<T extends Enum> on Iterable<T> {
  T? deserialize(String? value) =>
      firstWhereOrNull((e) => e.serialize() == value);
}

T? deserializeEnum<T>(String? value) {
  switch (T) {
    case (RideStatus):
      return RideStatus.values.deserialize(value) as T?;
    case (Role):
      return Role.values.deserialize(value) as T?;
    case (VerificationStatus):
      return VerificationStatus.values.deserialize(value) as T?;
    case (DocType):
      return DocType.values.deserialize(value) as T?;
    case (OnlineStatus):
      return OnlineStatus.values.deserialize(value) as T?;
    case (PaymentMethod):
      return PaymentMethod.values.deserialize(value) as T?;
    case (PaymentStatus):
      return PaymentStatus.values.deserialize(value) as T?;
    case (Ridetype):
      return Ridetype.values.deserialize(value) as T?;
    default:
      return null;
  }
}
