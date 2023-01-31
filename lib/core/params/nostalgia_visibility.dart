enum NostalgiaVisibility { all, owner, friend }

extension Translate on NostalgiaVisibility {
  String translate() {
    switch (this) {
      case NostalgiaVisibility.all:
        return '전체공개';
      case NostalgiaVisibility.owner:
        return '나만공개';
      case NostalgiaVisibility.friend:
        return '친구공개';
    }
  }
}
