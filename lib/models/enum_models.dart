enum ProcedureType {
  bottocks, // 0
  mesotherapy, // 1
  filling, // 2
  prp, // 3
  other // 4
}

extension ProcedureTypeExtension on ProcedureType {
  static ProcedureType fromCode(int code) {
    return ProcedureType.values[code];
  }

  int toCode() {
    return index;
  }

  String get name {
    switch (this) {
      case ProcedureType.bottocks:
        return 'Botoks';
      case ProcedureType.mesotherapy:
        return 'Mezoterapi';
      case ProcedureType.filling:
        return 'Dolgu';
      case ProcedureType.prp:
        return 'PRP';
      case ProcedureType.other:
        return 'Diğer İşlemler';
      default:
        return '';
    }
  }
}
