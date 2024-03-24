List<double> generatePlaySpeedList() {
  List<double> playSpeed = [];
  double startSpeed = 0.25;
  double endSpeed = 2.0;
  double increment = 0.25;

  for (double speed = startSpeed; speed <= endSpeed; speed += increment) {
    playSpeed.add(speed);
  }

  return playSpeed;
}

// 导出 playSpeed 列表
List<double> playSpeed = generatePlaySpeedList();
