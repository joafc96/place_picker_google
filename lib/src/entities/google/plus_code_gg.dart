class PlusCodeGG {
  final String? compoundCode;
  final String? globalCode;

  PlusCodeGG({
    this.compoundCode,
    this.globalCode,
  });

  factory PlusCodeGG.fromJson(Map<String, dynamic> json) => PlusCodeGG(
        compoundCode: json["compound_code"],
        globalCode: json["global_code"],
      );

  Map<String, dynamic> toJson() => {
        "compound_code": compoundCode,
        "global_code": globalCode,
      };
}
