// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountDetailsAdapter extends TypeAdapter<AccountDetails> {
  @override
  final int typeId = 4;

  @override
  AccountDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccountDetails(
      accountName: fields[0] as String,
      accountAddress: fields[1] as String,
      accountTelephone: fields[2] as String,
      email: fields[4] as String,
      accountCreationDateTime: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AccountDetails obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.accountName)
      ..writeByte(1)
      ..write(obj.accountAddress)
      ..writeByte(2)
      ..write(obj.accountTelephone)
      ..writeByte(3)
      ..write(obj.accountCreationDateTime)
      ..writeByte(4)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
