part of 'retour_details_bloc.dart';

@immutable
abstract class RetourDetailsEvent {}


class FetchData extends RetourDetailsEvent{}

class Livrer extends RetourDetailsEvent{}
