// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aya_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AyahAdapter extends TypeAdapter<Ayah> {
  @override
  final int typeId = 0;

  @override
  Ayah read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ayah(
      number: fields[0] as int,
      text: fields[1] as String,
      surahNumber: fields[2] as int,
      audio: fields[3] as String?,
      page: fields[4] as int,
      juz: fields[5] as int,
      hizbQuarter: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Ayah obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.number)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.surahNumber)
      ..writeByte(3)
      ..write(obj.audio)
      ..writeByte(4)
      ..write(obj.page)
      ..writeByte(5)
      ..write(obj.juz)
      ..writeByte(6)
      ..write(obj.hizbQuarter);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AyahAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
