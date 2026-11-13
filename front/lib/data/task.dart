class Task {
  
  Task(this._id, this._description, this._date, this._completed, this._iniciated);

  final int _id;
  final String _description;
  final DateTime _date;
  bool _completed;
  bool _iniciated;

  int get id => _id;
  String get description => _description;
  DateTime get date => _date;
  bool get completed => _completed;
  bool get iniciated => _iniciated;

  void setCompleted(bool completed) {
    _completed = completed;
  }

  void setIniciated(bool iniciated) {
    _iniciated = iniciated;
  }

  static Task fromJSON(Map<String, dynamic> task) {
    int id = task['id'] as int;
    String description = task['description'];
    List<String> listDateBodyISO = task['date'].split("T")[0].split("-");
    DateTime date = DateTime(int.parse(listDateBodyISO[0]), int.parse(listDateBodyISO[1]), int.parse(listDateBodyISO[2]));
    bool completed = task['completed'] as bool;
    bool iniciated = task['iniciated'] as bool;

    Task newTask = Task(id,description,date,completed,iniciated);
    return newTask;
  }

}