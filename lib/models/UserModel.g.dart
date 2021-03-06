// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 40;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel()
      ..id = fields[0] as int
      ..username = fields[1] as String
      ..password = fields[2] as String
      ..name = fields[3] as String
      ..avatar = fields[4] as String
      ..remember_token = fields[5] as String
      ..created_at = fields[6] as String
      ..updated_at = fields[7] as String
      ..last_name = fields[8] as String
      ..company_name = fields[9] as String
      ..email = fields[10] as String
      ..phone_number = fields[11] as String
      ..address = fields[12] as String
      ..about = fields[13] as String
      ..services = fields[14] as String
      ..longitude = fields[15] as String
      ..latitude = fields[16] as String
      ..division = fields[17] as String
      ..opening_hours = fields[18] as String
      ..cover_photo = fields[19] as String
      ..facebook = fields[20] as String
      ..twitter = fields[21] as String
      ..whatsapp = fields[22] as String
      ..youtube = fields[23] as String
      ..instagram = fields[24] as String
      ..last_seen = fields[25] as String
      ..status = fields[26] as String
      ..linkedin = fields[27] as String
      ..category_id = fields[28] as String
      ..status_comment = fields[29] as String
      ..country_id = fields[30] as String
      ..region = fields[31] as String
      ..district = fields[32] as String
      ..sub_county = fields[33] as String
      ..logged_in_user = fields[34] as String;
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(35)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.avatar)
      ..writeByte(5)
      ..write(obj.remember_token)
      ..writeByte(6)
      ..write(obj.created_at)
      ..writeByte(7)
      ..write(obj.updated_at)
      ..writeByte(8)
      ..write(obj.last_name)
      ..writeByte(9)
      ..write(obj.company_name)
      ..writeByte(10)
      ..write(obj.email)
      ..writeByte(11)
      ..write(obj.phone_number)
      ..writeByte(12)
      ..write(obj.address)
      ..writeByte(13)
      ..write(obj.about)
      ..writeByte(14)
      ..write(obj.services)
      ..writeByte(15)
      ..write(obj.longitude)
      ..writeByte(16)
      ..write(obj.latitude)
      ..writeByte(17)
      ..write(obj.division)
      ..writeByte(18)
      ..write(obj.opening_hours)
      ..writeByte(19)
      ..write(obj.cover_photo)
      ..writeByte(20)
      ..write(obj.facebook)
      ..writeByte(21)
      ..write(obj.twitter)
      ..writeByte(22)
      ..write(obj.whatsapp)
      ..writeByte(23)
      ..write(obj.youtube)
      ..writeByte(24)
      ..write(obj.instagram)
      ..writeByte(25)
      ..write(obj.last_seen)
      ..writeByte(26)
      ..write(obj.status)
      ..writeByte(27)
      ..write(obj.linkedin)
      ..writeByte(28)
      ..write(obj.category_id)
      ..writeByte(29)
      ..write(obj.status_comment)
      ..writeByte(30)
      ..write(obj.country_id)
      ..writeByte(31)
      ..write(obj.region)
      ..writeByte(32)
      ..write(obj.district)
      ..writeByte(33)
      ..write(obj.sub_county)
      ..writeByte(34)
      ..write(obj.logged_in_user);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
