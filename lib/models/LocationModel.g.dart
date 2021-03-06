// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LocationModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocationModelAdapter extends TypeAdapter<LocationModel> {
  @override
  final int typeId = 52;

  @override
  LocationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocationModel()
      ..id = fields[0] as int
      ..parent_id = fields[1] as int
      ..name = fields[2] as String
      ..longitude = fields[3] as String
      ..latitude = fields[4] as String
      ..details = fields[5] as String
      ..image = fields[6] as String
      ..type = fields[7] as String
      ..listed = fields[8] as String;
  }

  @override
  void write(BinaryWriter writer, LocationModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.parent_id)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.longitude)
      ..writeByte(4)
      ..write(obj.latitude)
      ..writeByte(5)
      ..write(obj.details)
      ..writeByte(6)
      ..write(obj.image)
      ..writeByte(7)
      ..write(obj.type)
      ..writeByte(8)
      ..write(obj.listed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
