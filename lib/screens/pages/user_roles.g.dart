// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_roles.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserRoleAdapter extends TypeAdapter<UserRole> {
  @override
  final int typeId = 1;

  @override
  UserRole read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserRole(
      roleName: fields[0] as String,
      permissions: (fields[1] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserRole obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.roleName)
      ..writeByte(1)
      ..write(obj.permissions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserRoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
