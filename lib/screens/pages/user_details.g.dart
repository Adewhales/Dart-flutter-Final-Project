// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDetailsAdapter extends TypeAdapter<UserDetails> {
  @override
  final int typeId = 5;

  @override
  UserDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDetails(
      username: fields[0] as String,
      password: fields[1] as String,
      isSuperUser: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserDetails obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.password)
      ..writeByte(2)
      ..write(obj.isSuperUser);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
