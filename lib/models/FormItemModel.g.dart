// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FormItemModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FormItemModelAdapter extends TypeAdapter<FormItemModel> {
  @override
  final int typeId = 50;

  @override
  FormItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FormItemModel()
      ..id = fields[0] as int
      ..category_id = fields[1] as int
      ..name = fields[2] as String
      ..type = fields[3] as String
      ..description = fields[4] as String
      ..units = fields[5] as String
      ..value = fields[6] as String
      ..options = (fields[7] as List).cast<String>()
      ..is_required = fields[8] as bool
      ..active_form = fields[9] as String;
  }

  @override
  void write(BinaryWriter writer, FormItemModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.category_id)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.units)
      ..writeByte(6)
      ..write(obj.value)
      ..writeByte(7)
      ..write(obj.options)
      ..writeByte(8)
      ..write(obj.is_required)
      ..writeByte(9)
      ..write(obj.active_form);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
