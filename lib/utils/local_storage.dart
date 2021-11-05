import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  saveNewGoal(String goal) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('goal', goal);
  }

  addAmount(int amount, int currentAmount) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final newAmount = amount + currentAmount;
    await pref.setInt('amount', newAmount);
  }

  Future getCurrentAmount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt("amount") ?? 0;
  }

  Future getCurretGoalAmount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt('goalAmount') ?? 0;
  }

  Future getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("goal") ?? "";
  }

  setToNewGoalAmount(int amount) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt('goalAmount', amount);
  }

  resetAmount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt('amount', 0);
  }
}
