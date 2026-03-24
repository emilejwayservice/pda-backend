part of 'single_command_bloc.dart';

@immutable
abstract class SingleCommandEvent {}


class FetchData extends SingleCommandEvent{}

class Valider extends SingleCommandEvent{

}

class LivrerCommand extends SingleCommandEvent{

}

class SelectDate extends SingleCommandEvent{
  DateTime date;

  SelectDate(this.date);
}