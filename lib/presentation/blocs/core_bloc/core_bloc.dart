import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'core_event.dart';
part 'core_state.dart';

class CoreBloc extends Bloc<CoreEvent, CoreState> {
  CoreBloc() : super(CoreInitial()) {
    on<CoreEvent>((event, emit) {
      if(event is UpdateChargement){
        emit(ChargementUpdated());
      }else if(event is UpdateClients){
        emit(ClientsUpdated());
      }else if(event is UpdateCommands){
        emit(CommandsUpdated());
      }else if(event is UpdateLivraison){
        emit(LivraisonsUpdated());
      }else if(event is UpdateRetours){
        emit(RetoursUpdated());
      }
    });
  }
}
