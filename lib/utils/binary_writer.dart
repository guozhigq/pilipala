import 'dart:typed_data';

class BinaryWriter {
  List<int> buffer;
  int position = 0;
  BinaryWriter(this.buffer);
  int get length => buffer.length;

  void writeBytes(List<int> list) {
    buffer.addAll(list);
    position += list.length;
  }

  void writeInt(int value, int len, {Endian endian = Endian.big}) {
    var bytes = _createByteData(len);
    switch (len) {
      case 1:
        bytes.setUint8(0, value.toUnsigned(8));
        break;
      case 2:
        bytes.setInt16(0, value, endian);
        break;
      case 4:
        bytes.setInt32(0, value, endian);
        break;
      case 8:
        bytes.setInt64(0, value, endian);
        break;
      default:
        throw ArgumentError('Invalid length for writeInt: $len');
    }
    _addBytesToBuffer(bytes, len);
  }

  void writeDouble(double value, int len, {Endian endian = Endian.big}) {
    var bytes = _createByteData(len);
    switch (len) {
      case 4:
        bytes.setFloat32(0, value, endian);
        break;
      case 8:
        bytes.setFloat64(0, value, endian);
        break;
      default:
        throw ArgumentError('Invalid length for writeDouble: $len');
    }
    _addBytesToBuffer(bytes, len);
  }

  ByteData _createByteData(int len) {
    var b = Uint8List(len).buffer;
    return ByteData.view(b);
  }

  void _addBytesToBuffer(ByteData bytes, int len) {
    buffer.addAll(bytes.buffer.asUint8List());
    position += len;
  }
}

class BinaryReader {
  Uint8List buffer;
  int position = 0;
  BinaryReader(this.buffer);
  int get length => buffer.length;

  int read() {
    return buffer[position++];
  }

  int readInt(int len, {Endian endian = Endian.big}) {
    var bytes = _getBytes(len);
    var data = ByteData.view(bytes.buffer);
    switch (len) {
      case 1:
        return data.getUint8(0);
      case 2:
        return data.getInt16(0, endian);
      case 4:
        return data.getInt32(0, endian);
      case 8:
        return data.getInt64(0, endian);
      default:
        throw ArgumentError('Invalid length for readInt: $len');
    }
  }

  int readByte({Endian endian = Endian.big}) => readInt(1, endian: endian);
  int readShort({Endian endian = Endian.big}) => readInt(2, endian: endian);
  int readInt32({Endian endian = Endian.big}) => readInt(4, endian: endian);
  int readLong({Endian endian = Endian.big}) => readInt(8, endian: endian);

  Uint8List readBytes(int len) {
    var bytes = _getBytes(len);
    return bytes;
  }

  double readFloat(int len, {Endian endian = Endian.big}) {
    var bytes = _getBytes(len);
    var data = ByteData.view(bytes.buffer);
    switch (len) {
      case 4:
        return data.getFloat32(0, endian);
      case 8:
        return data.getFloat64(0, endian);
      default:
        throw ArgumentError('Invalid length for readFloat: $len');
    }
  }

  Uint8List _getBytes(int len) {
    var bytes =
        Uint8List.fromList(buffer.getRange(position, position + len).toList());
    position += len;
    return bytes;
  }
}
