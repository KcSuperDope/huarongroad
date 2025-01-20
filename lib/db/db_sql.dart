class SQLString {
  static const history = "History";
  static const level = "Level";
  static const special = "Special";

  /*
  * 日期 时间戳 int
  * 初始棋盘 String "11221132"
  * 历史步骤 String " x y toX toY" [x,y,toX,toY]
  * 耗时 int 毫秒
  * 游戏类型 int (hrd num3 num4)
  * 游戏模式 int (练习，闯关)
  * 游戏状态 int (成功 失败)
  * userId
  * index (闯关模式所用到关卡编号)
  * title (本局游戏的名称)
  * isConnect (是否链接)
  *
  * */

  /// 游戏历史记录
  static const createGameTable =
      "CREATE TABLE IF NOT EXISTS $history (time INTEGER NOT NULL, duration INTEGER NOT NULL, steps TEXT NOT NULL, opening TEXT NOT NULL, type INTEGER NOT NULL, mode INTEGER NOT NULL, state INTEGER NOT NULL, user_id TEXT NOT NULL, l_index INTEGER, title TEXT, isConnect INTEGER NOT NULL, id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL)";

  /*
  * l_index : 游戏编号
  * starNum : 星星数量
  * type : hrd or num
  * userId 当前用户
  * */

  /// 完成本关卡后，插入条记录
  static const createLevelTable =
      "CREATE TABLE IF NOT EXISTS $level (l_index INTEGER NOT NULL, starNum INTEGER NOT NULL, type INTEGER NOT NULL, user_id TEXT NOT NULL, id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL)";

/* userId 当前用户
  * time : 时间
  * 耗时 int 毫秒
  * step 步数
  * open 开局
  * type 游戏类型
  * */
  static const createSpecialTable =
      "CREATE TABLE IF NOT EXISTS $special (time INTEGER NOT NULL, duration INTEGER NOT NULL, type INTEGER NOT NULL, user_id TEXT NOT NULL, opening TEXT NOT NULL, step_length INTEGER NOT NULL, id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL)";
}
