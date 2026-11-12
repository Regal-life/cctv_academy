import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cctv_learning.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';

    // 1. Modules Table
    await db.execute('''
      CREATE TABLE modules (
        id $idType,
        title $textType,
        category $textType,
        description $textType
      )
    ''');

    // 2. Quiz Questions Table
    await db.execute('''
      CREATE TABLE quiz_questions (
        id $idType,
        module_id $intType,
        question $textType,
        option_a $textType,
        option_b $textType,
        option_c $textType,
        option_d $textType,
        correct_option $intType,
        explanation $textType,
        FOREIGN KEY (module_id) REFERENCES modules (id)
      )
    ''');

    // 3. Troubleshooting Scenarios Table
    await db.execute('''
      CREATE TABLE troubleshooting_scenarios (
        id $idType,
        title $textType,
        symptom $textType,
        system_context $textType,
        option_a $textType,
        option_b $textType,
        option_c $textType,
        option_d $textType,
        correct_option $intType,
        solution_explanation $textType
      )
    ''');

    // 4. User Progress Table
    await db.execute('''
      CREATE TABLE user_progress (
        id $idType,
        item_id $intType,
        item_type $textType,
        is_completed $intType,
        score $intType
      )
    ''');

    // Seed Data immediately after creation
    await _seedDatabase(db);
  }

  Future<void> _seedDatabase(Database db) async {
    // Seed Modules
    await db.rawInsert('''
      INSERT INTO modules (id, title, category, description) VALUES
      (1, 'IP Networking & Subnetting', 'Networking', 'Master static IPs, DHCP, gateways, and subnets for IP cameras.'),
      (2, 'CCTV Power & Cables', 'Hardware', 'Learn PoE standards (802.3af/at/bt), RG59, and Cat6 voltage drops.')
    ''');

    // Seed Quiz Questions
    await db.rawInsert('''
      INSERT INTO quiz_questions (module_id, question, option_a, option_b, option_c, option_d, correct_option, explanation) VALUES
      (1, 
       'Why should IP cameras always be assigned Static IP addresses instead of dynamic DHCP?', 
       'Static IPs make cameras record in higher resolution', 
       'DHCP IPs can change on router reboot, causing NVR channel disconnections', 
       'Static IPs bypass the need for a network switch', 
       'DHCP only supports coax cables', 
       1, 
       'If an NVR is configured to pull video streams from specific IP addresses, a dynamic IP change via DHCP will cause the camera stream to go offline.'),
      
      (2, 
       'What is the maximum recommended transmission distance for standard PoE over Cat6 cable without an extender?', 
       '50 meters (164 ft)', 
       '100 meters (328 ft)', 
       '250 meters (820 ft)', 
       '500 meters (1640 ft)', 
       1, 
       'The IEEE 802.3 standard limits Ethernet over twisted pair cabling to 100 meters due to attenuation and timing constraints.')
    ''');

    // Seed Troubleshooting Scenarios
    await db.rawInsert('''
      INSERT INTO troubleshooting_scenarios (title, symptom, system_context, option_a, option_b, option_c, option_d, correct_option, solution_explanation) VALUES
      ('The Night Vision Drop-out', 
       'Camera 08 displays crisp video during the day but goes completely offline every night at 6:15 PM.', 
       'The camera is installed 85 meters away using 12V DC power over 24AWG wire, connected via a 12V 1A power supply.', 
       'Bad RJ45 crimp on the data pairs', 
       'Voltage drop: IR LED activation increases current draw, causing voltage at camera to drop below operating threshold', 
       'Subnet mask conflict with the local router', 
       'Video stream codec incompatible with night mode', 
       1, 
       'IR LEDs consume significant additional power when night mode turns on. Over long cable runs, resistance causes the voltage to drop under heavy load, causing the camera board to reboot endlessly.')
    ''');
  }

  // Fetching methods
  Future<List<Map<String, dynamic>>> getQuizQuestions(int moduleId) async {
    final db = await instance.database;
    return await db.query(
      'quiz_questions',
      where: 'module_id = ?',
      whereArgs: [moduleId],
    );
  }

  Future<List<Map<String, dynamic>>> getScenarios() async {
    final db = await instance.database;
    return await db.query('troubleshooting_scenarios');
  }

  Future<List<Map<String, dynamic>>> getModules() async {
    final db = await instance.database;
    return await db.query('modules');
  }
}
