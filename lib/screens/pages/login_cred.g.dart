// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_cred.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoginCredAdapter extends TypeAdapter<LoginCred> {
  @override
  final int typeId = 2;

  @override
  LoginCred read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoginCred(
      username: fields[0] as String,
      password: fields[1] as String,
      createdAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, LoginCred obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.password)
      ..writeByte(2)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginCredAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
