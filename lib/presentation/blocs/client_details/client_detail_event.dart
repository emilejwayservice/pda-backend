part of 'client_detail_bloc.dart';

@immutable
abstract class ClientDetailEvent {}


class FetchData extends ClientDetailEvent{}



class GenerateQrCode extends ClientDetailEvent{}
