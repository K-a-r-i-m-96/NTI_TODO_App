abstract class EndPoints {
  static const String baseUrl = 'https://ntitodo-production-463a.up.railway.app/api/';
  static const String login = 'login';
  static const String register = 'register';
  static const String refresh = 'refresh_token';
  static const String myTasks = 'my_tasks';
  static const String newTask = 'new_task';
  static String updateTask({required int? taskId}) => 'tasks/$taskId';
}
