//gasから送られてくる形式
class SongDTO {
  static List<String> difficulties = [
    "S+",
    "個人差S+",
    "S",
    "個人差S",
    "A+",
    "個人差A+",
    "A",
    "個人差A",
    "B+",
    "個人差B+",
    "B",
    "個人差B",
    "C",
    "個人差C",
    "D",
    "個人差D",
    "E",
    "個人差E",
    "F",
    "個人差F"
  ];
  String songName;
  int level;
  String normalDifficulty;
  String hardDifficulty;
  //相当頭悪い？
  SongDTO(SongDTO dto) {
    this.songName = dto.songName;
    this.level = dto.level;
    this.normalDifficulty = dto.normalDifficulty;
    this.hardDifficulty = dto.hardDifficulty;
  }
  SongDTO.init(
      this.songName, this.level, this.normalDifficulty, this.hardDifficulty);
  SongDTO.fromJson(Map<String, dynamic> json)
      : songName = json['song_name'],
        level = json['level'],
        normalDifficulty = json['normal_difficulty'],
        hardDifficulty = json['hard_difficulty'];
}
