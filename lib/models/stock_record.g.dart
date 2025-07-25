// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StockRecordAdapter extends TypeAdapter<StockRecord> {
  @override
  final int typeId = 2;

  @override
  StockRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StockRecord(
      item: fields[0] as String,
      quantity: fields[1] as int,
      unit: fields[2] as String,
      source: fields[3] as String,
      timestamp: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, StockRecord obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.item)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.unit)
      ..writeByte(3)
      ..write(obj.source)
      ..writeByte(4)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
