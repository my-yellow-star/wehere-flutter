enum NostalgiaVisibility { all, owner, friend, none }

extension Translate on NostalgiaVisibility {
  String translate() {
    switch (this) {
      case NostalgiaVisibility.all:
        return '전체공개';
      case NostalgiaVisibility.owner:
        return '나만공개';
      case NostalgiaVisibility.friend:
        return '친구공개';
      case NostalgiaVisibility.none:
        return '삭제됨';
    }
  }
}

NostalgiaVisibility toNostalgiaVisibility(String raw) {
  return NostalgiaVisibility.values
      .singleWhere((element) => element.name == raw.toLowerCase());
}
