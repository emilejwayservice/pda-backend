import 'dart:async';

import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pda/core/dependencies/dependencies.dart';
import 'package:pda/core/services/encryption_service.dart';
import 'package:pda/core/services/qr_code_generation_service.dart';
import 'package:pda/core/services/shared_pref_service.dart';
import 'package:pda/domain/exceptions/network_connectivity_exception.dart';
import 'package:pda/domain/repository/repository.dart';

import '../../../core/constants/enums/app_status.dart';
import '../../../domain/entities/client.dart';
import '../core_bloc/core_bloc.dart';

part 'client_detail_event.dart';
part 'client_detail_state.dart';

class ClientDetailBloc extends Bloc<ClientDetailEvent, ClientDetailState> {

  late StreamSubscription<CoreState> streamSubscription;

  ClientDetailBloc(int idClient) : super(ClientDetailState(idClient: idClient)) {
    on<FetchData>(_fetchData);
    on<GenerateQrCode>(_generateQrCode);
    CoreBloc core=Dependencies.get<CoreBloc>();
    streamSubscription=core.stream.listen(listener);
  }

  FutureOr<void> _fetchData(FetchData event, Emitter<ClientDetailState> emit) async{
    try{
      emit(state.copyWith(fetchData: AppStatus.loading));
      Repository repository=Dependencies.get<Repository>();
      int company=Dependencies.get<SharedPrefService>().getValue(SharedPrefService.company, 0);
      ClientEntity client=await repository.getClient(company,state.idClient!);
      emit(state.copyWith(fetchData: AppStatus.success,client: client));
    }on NetworkConnectivityException catch(ex){
      emit(state.copyWith(fetchData: AppStatus.error,isOffline: true));
      rethrow;
    }catch(ex){
      emit(state.copyWith(fetchData: AppStatus.error,));
      rethrow;
    }
  }

  FutureOr<void> _generateQrCode(GenerateQrCode event, Emitter<ClientDetailState> emit) async{
    if(state.client==null)return;
    String payload=EncryptionService().encrypt(state.client!.id.toString());
    QrCodeGenerationService qrs=QrCodeGenerationService(payload, 90);
    Uint8List uint8list=await qrs.generate();
    Directory dic=await getTemporaryDirectory();
    String fullPath="${dic.path}/qrClient.png";
    File file=File(fullPath);
    file.writeAsBytes(uint8list);
    OpenFile.open(fullPath);
  }

  void listener(CoreState state) {
    if(state is ClientsUpdated){
      add(FetchData());
    }
  }

  @override
  Future<void> close() async{
    await streamSubscription.cancel();
    await super.close();
  }


}
