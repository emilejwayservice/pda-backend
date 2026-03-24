import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/dependencies/dependencies.dart';
import 'package:pda/core/extensions/extension_on_date.dart';
import 'package:pda/core/services/qr_code_generation_service.dart';
import 'package:pda/core/services/qr_payload.dart';
import 'package:pda/core/services/shared_pref_service.dart';
import 'package:pda/domain/entities/Livraison.dart';
import 'package:pda/domain/entities/company.dart';
import 'package:pda/domain/entities/details.dart';
import 'package:pda/domain/entities/user.dart';
import 'package:pda/domain/exceptions/network_connectivity_exception.dart';
import 'package:pda/domain/repository/repository.dart';
import 'package:pda/presentation/blocs/core_bloc/core_bloc.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../core/constants/app_images.dart';
import '../../../core/services/bleutooth_service.dart';

part 'livraison_details_event.dart';
part 'livraison_details_state.dart';

class LivraisonDetailsBloc extends Bloc<LivraisonDetailsEvent, LivraisonDetailsState> {

  StreamSubscription<List<BluetoothDevice>>? _devicesSubscription;
  StreamSubscription<ConnectState>? _connectionSubscription;

  Map<String, String> characterReplacementMap = {
    "â": "a", "à": "a", "á": "a", "ä": "a", "ã": "a", "å": "a",
    "ê": "e", "è": "e", "é": "e", "ë": "e",
    "î": "i", "ì": "i", "í": "i", "ï": "i",
    "ô": "o", "ò": "o", "ó": "o", "ö": "o", "õ": "o",
    "û": "u", "ù": "u", "ú": "u", "ü": "u",
    "ç": "c",
    "ñ": "n",
    "ý": "y", "ÿ": "y",
    "œ": "oe", "æ": "ae",
    "ß": "ss",
  };

  LivraisonDetailsBloc(int livraison) : super(LivraisonDetailsState(livraisonId: livraison)) {

    on<FetchData>(_fetchData);
    on<ValiderLivraison>(_validerLivraison);
    on<GenerateRecu>(_generateRecu);
    on<GenerateBl>(_generateBonLivraison);
    on<FacturableLivraison>(_facturableLivraison);
    on<SelectDevice>(_selectDevice);


    BluetoothPrintPlus.scanResults.listen(devicesListener);
    BluetoothPrintPlus.connectState.listen(connectionListenner);



  }

  FutureOr<void> _fetchData(FetchData event, Emitter<LivraisonDetailsState> emit) async{
    try{
      emit(state.copyWith(fetchData: AppStatus.loading));
      Repository repository=Dependencies.get<Repository>();
      LivraisonEntity livraisonEntity=await repository.getSingleLivraison(state.livraisonId!);
      emit(state.copyWith(fetchData: AppStatus.success,livraison: livraisonEntity));
    }on NetworkConnectivityException catch(ex){
      emit(state.copyWith(fetchData: AppStatus.error,isOffline: true));
    }catch(ex){
      emit(state.copyWith(fetchData: AppStatus.error));
    }
  }

  FutureOr<void> _validerLivraison(ValiderLivraison event, Emitter<LivraisonDetailsState> emit)async {
    try{
      emit(state.copyWith(validerLivraisonStatus: AppStatus.loading));
      Repository repository=Dependencies.get<Repository>();
      LivraisonEntity livraisonEntity=await repository.validerLivraison(state.livraisonId!);
      CoreBloc coreBloc=Dependencies.get<CoreBloc>();
      coreBloc.add(UpdateLivraison());
      coreBloc.add(UpdateClients());
      emit(state.copyWith(validerLivraisonStatus: AppStatus.success,livraison: livraisonEntity));
    }on NetworkConnectivityException catch(ex){
      emit(state.copyWith(validerLivraisonStatus: AppStatus.error,isOffline: true));
    }catch(ex){
      emit(state.copyWith(validerLivraisonStatus: AppStatus.error));
    }
  }

  FutureOr<void> _generateRecu(GenerateRecu event, Emitter<LivraisonDetailsState> emit) async{
    print("============generate recu");
    emit(state.copyWith(isPrinting: true));

    if(state.selectedDevice!=null || Dependencies.contain<BluetoothDevice>()){

      if(BluetoothPrintPlus.isConnected){
        emit(state.copyWith(isPrinting: false));
        printRecu();
      }else{
        await BluetoothPrintPlus.connect(state.selectedDevice??Dependencies.get<BluetoothDevice>());
      }
    }else{
        BluetoothPrintPlus.startScan(timeout: const Duration(seconds: 10));
        emit(state.copyWith(bluetoothSrviceReadyStatus: AppStatus.success));
    }

  }



  Future<void> printRecu()async {
    EscCommand escCommand=EscCommand();
    await escCommand.cleanCommand();
    await escCommand.print(feedLines: 2);
    //await escCommand.newline();
    await escCommand.text(
        content: "Jway Services",
        alignment: Alignment.center,
        //style: EscTextStyle.underline,
        fontSize: EscFontSize.default_);

    await escCommand.newline();

    await escCommand.text(
        content: DateTime.now().formattedDateTimeFr,
        alignment: Alignment.center,
        //style: EscTextStyle.underline,
        fontSize: EscFontSize.default_);

    await escCommand.newline();

    await escCommand.text(
        content: "----------------------",
        alignment: Alignment.center,
        fontSize: EscFontSize.size1);

    //=================================================  client
    await escCommand.newline();
    await escCommand.text(
        content: "Nom du client : ${state.livraison?.client?.nom}\nAdresse du client : ${state.livraison?.client?.address}",
        alignment: Alignment.left,
        //style: EscTextStyle.underline,
        fontSize: EscFontSize.default_);


    await escCommand.newline();
    await escCommand.text(
        content: "----------------------",
        alignment: Alignment.center,
        fontSize: EscFontSize.size1);




    await escCommand.newline();
    //=================================================  seller
    UserEntity user=Dependencies.get<UserEntity>();
    await escCommand.text(
        content: "Nom du vendeur : ${user.firstName}-${user.lastName}",
        alignment: Alignment.left,
        fontSize: EscFontSize.default_);

    await escCommand.newline();

    await escCommand.text(
        content: "----------------------",
        alignment: Alignment.center,
        fontSize: EscFontSize.size1);

    await escCommand.newline();

    String header="   Article             Qte    Tva    Montant";

    await escCommand.text(
        content: header,
        alignment: Alignment.left,
        //style: EscTextStyle.underline,
        fontSize: EscFontSize.default_);
    await escCommand.newline();


    for(LivraisonDetailEntity item in state.livraison?.details??[]){
      String row=_getRow(cleanWord(item.product!.labelle!),item.quantity.toString(),item.totalTva.toString(),item.totalTTC.toString());
      //print("===============${item.totalTva.toString()}");
      await escCommand.text(
          content:row,
          alignment: Alignment.left,
          fontSize: EscFontSize.default_);

      await escCommand.newline();
    }


    await escCommand.text(
        content: "Date Livraison :  ${state.livraison?.dateLaivraison?.formattedDateFr??"-"}",
        alignment: Alignment.center,
        style: EscTextStyle.bold,
        fontSize: EscFontSize.size1);

    await escCommand.newline();



    await escCommand.text(
        content: "----------------------",
        alignment: Alignment.center,
        fontSize: EscFontSize.size1);

    await escCommand.newline();

    await escCommand.text(
        content: "Total HT :  ${state.livraison?.totalHt??"-"}",
        alignment: Alignment.left,
        style: EscTextStyle.bold,
        fontSize: EscFontSize.size1);
    await escCommand.newline();
    await escCommand.text(
        content: "Total TVA :  ${state.livraison?.totalTva??"-"}",
        alignment: Alignment.left,
        style: EscTextStyle.bold,
        fontSize: EscFontSize.size1);
    await escCommand.newline();
    await escCommand.text(
        content: "Total TTC :  ${state.livraison?.totalTTC??"-"}",
        alignment: Alignment.left,
        style: EscTextStyle.bold,
        fontSize: EscFontSize.size1);
    await escCommand.newline();

    await escCommand.text(
        content: "----------------------",
        alignment: Alignment.center,
        fontSize: EscFontSize.size1);

    await escCommand.newline();

    await escCommand.text(
        content: "Merci",
        alignment: Alignment.center,
        style: EscTextStyle.bold,
        fontSize: EscFontSize.size1);
    await escCommand.newline();
    await escCommand.text(
        content: "Toujours Bienvenue Chez Jway Services",
        alignment: Alignment.center,
        style: EscTextStyle.bold,
        fontSize: EscFontSize.size1);
    await escCommand.print(feedLines: 3);
    await escCommand.cutPaper();
    final cmd = await escCommand.getCommand();
    BluetoothPrintPlus.write(cmd);

  }


  String cleanWord(String word){
    String newStr="";
    for(String char in word.split("")){
      newStr+=(characterReplacementMap[char]??char);
    }
    return newStr;
  }






  String _getRow(String article,String qte,String tva,String montat){
    print("============================tva========${tva}");
    String row=" ";
    if(article.length<21){
      row+=(article+List.filled(21-article.length, " ").join());
    }else{
      row+=(article.substring(0,21));
    }
    row+=" ";

    row+=qte;

    String spaces=qte.length<=3
        ?(List.filled(3-qte.length+4, " ").join())
        :List.filled(4-(qte.length-3), " ").join();

    row+=spaces;

    row+=tva;

    spaces=tva.length<=3
        ?(List.filled(3-tva.length+4, " ").join())
        :List.filled(4-(tva.length-3), " ").join();
    row+=spaces;


    row+=montat;
    return row;
  }




  FutureOr<void> _generateBonLivraison(GenerateBl event, Emitter<LivraisonDetailsState> emit) async{

    if(state.fetchData!=AppStatus.success)return;
    emit(state.copyWith(generatePdfStatus: AppStatus.loading));

    //fetch company information
    int companyId=Dependencies.get<SharedPrefService>().getValue(SharedPrefService.company, 0);
    Repository repository=Dependencies.get<Repository>();
    CompanyEntity company=await repository.getCompany(companyId);

    PdfDocument document = PdfDocument();
    PdfPage page = document.pages.add();

    double width=page.getClientSize().width;
    double height=page.getClientSize().height;

    //fonts
    final PdfFont boldFont = PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold);
    final PdfFont normalFont = PdfStandardFont(PdfFontFamily.helvetica, 10);



    //write img header
    ByteData data=await rootBundle.load(AppImages.app_logo);
    Uint8List imageBytes=data.buffer.asUint8List();
    PdfBitmap pdfImage=PdfBitmap(imageBytes);
    page.graphics.drawImage(pdfImage, Rect.fromLTWH(0, 0, 90, 55));


    //write string header
    String strHeader="Livraison\nDate Livraison :${state.livraison?.dateLaivraison?.formattedDateFr}";
    double widthStrHeader=boldFont.measureString(strHeader).width;
    double heightStrHeader=boldFont.measureString(strHeader).height;
    page.graphics.drawString(strHeader,boldFont,format: PdfStringFormat(alignment: PdfTextAlignment.right) ,bounds: Rect.fromLTWH(width-widthStrHeader, 0, widthStrHeader, heightStrHeader));

    //draw qr img
    //ByteData qrData=await rootBundle.load("assets/images/img_qr.png");
    String payLoad=QrPayload.generatePayload(state.livraison!.id!);
    Uint8List qrImage=await QrCodeGenerationService(payLoad, 80).generate();
    PdfBitmap qrImg=PdfBitmap(qrImage);
    page.graphics.drawImage(qrImg, Rect.fromLTWH(width-80, heightStrHeader+10, 80, 80));


    String emuteur="Emetteur : ${company.name}\nAdresss : ${company.address}";
    String recepteur="Adressé  a: ${state.livraison?.client?.nom}\nAdresss : ${state.livraison?.client?.address}";

    double textEmetteurHeight=normalFont.measureString(emuteur,layoutArea: Size.fromWidth(width*0.45)).height;
    double textRecepteurHeight=normalFont.measureString(recepteur,layoutArea: Size.fromWidth(width*0.3)).height;

    double rectangleHeight=textRecepteurHeight>textEmetteurHeight?textRecepteurHeight:textEmetteurHeight;



    double eRectWidth=width*0.45;
    double rRectWidth=width*0.55-95;
    //draw emutteur
    PdfPen pdfPen=PdfPen(PdfColor(54, 47, 148),width: 1);
    page.graphics.drawRectangle(pen: pdfPen,bounds: Rect.fromLTWH(0, 70, eRectWidth, rectangleHeight+5));
    // //draw recepteur
    page.graphics.drawRectangle(pen:pdfPen,bounds: Rect.fromLTWH(eRectWidth+10, 70, rRectWidth, rectangleHeight+5));

    page.graphics.drawString(emuteur, normalFont,bounds: Rect.fromLTWH(3,72 , eRectWidth, rectangleHeight));
    page.graphics.drawString(recepteur, normalFont,bounds: Rect.fromLTWH(eRectWidth+13,72 , rRectWidth-10, rectangleHeight));





    PdfGrid detailsGrid = PdfGrid();
    detailsGrid.columns.add(count: 5);
    detailsGrid.headers.add(1);

    PdfGridRow headerRow = detailsGrid.headers[0];
    detailsGrid.repeatHeader=true;
    headerRow.cells[0].value = 'Désignation';
    headerRow.cells[0].columnSpan=2;
    headerRow.cells[2].value = 'TVA';
    headerRow.cells[3].value = 'Qté';
    headerRow.cells[4].value = 'Total HT';
    headerRow.style = PdfGridRowStyle(font: boldFont,
    backgroundBrush: PdfSolidBrush(PdfColor(224, 235, 255)));




    detailsGrid.style = PdfGridStyle(
      cellPadding: PdfPaddings(left: 4, top: 4, right: 4, bottom: 4),
      font:
      PdfStandardFont(PdfFontFamily.courier, 18, style: PdfFontStyle.bold),
    );
    //======detailsGrid
    PdfGridRow row;
    for(LivraisonDetailEntity detail in state.livraison?.details??[]){
      row=detailsGrid.rows.add();
      row.cells[0].value=detail.product?.labelle;
      row.cells[0].columnSpan=2;
      row.cells[2].value=detail.totalTva.toString();
      row.cells[3].value=detail.quantity.toString();
      row.cells[4].value=detail.totalHt.toString();
    }
    //=====================draw second table
    double gridHeight=90+rectangleHeight;
    gridHeight=gridHeight>(heightStrHeader+100)?gridHeight:(heightStrHeader+100);
     PdfLayoutResult? result = detailsGrid.draw(page: page,bounds: Rect.fromLTWH(0, gridHeight,width,height));

    PdfGrid totalesGrid=PdfGrid();
    totalesGrid.columns.add(count: 2);
    PdfGridRow htRow=totalesGrid.rows.add();
    htRow.cells[0].value="Total HT";
    htRow.cells[0].style=PdfGridCellStyle(font: boldFont,backgroundBrush: PdfSolidBrush(PdfColor(224, 235, 255)));
    htRow.cells[1].value="${state.livraison?.totalHt}DH";
    htRow.cells[1].style=PdfGridCellStyle( font: boldFont);
    PdfGridRow tvaRow=totalesGrid.rows.add();
    tvaRow.cells[0].value="Total TVA";
    tvaRow.cells[0].style=PdfGridCellStyle(font: boldFont,backgroundBrush: PdfSolidBrush(PdfColor(224, 235, 255)));
    tvaRow.cells[1].value="${state.livraison?.totalTva}DH";
    tvaRow.cells[1].style=PdfGridCellStyle( font: boldFont);
    PdfGridRow ttcRow=totalesGrid.rows.add();
    ttcRow.cells[0].value="Total TTC:";
    ttcRow.cells[0].style=PdfGridCellStyle( font: boldFont,backgroundBrush: PdfSolidBrush(PdfColor(224, 235, 255)));
    ttcRow.cells[1].value="${state.livraison?.totalTTC}DH";
    ttcRow.cells[1].style=PdfGridCellStyle( font: boldFont);

    totalesGrid.draw(page: result!.page,bounds: Rect.fromLTWH(width*0.5,result.bounds.bottom+10 , width, height));


    List<int> bytes = await document.save();
    Directory dir=await getTemporaryDirectory();
    String fullPath=dir.path+"/livraison.pdf";
    await File(fullPath).writeAsBytes(bytes);
    await OpenFile.open(fullPath);
    document.dispose();


    emit(state.copyWith(generatePdfStatus: AppStatus.success));

  }



  FutureOr<void> _facturableLivraison(FacturableLivraison event, Emitter<LivraisonDetailsState> emit)async{
    try{
      emit(state.copyWith(facturableStatus: AppStatus.loading));
      Repository repository=Dependencies.get<Repository>();
      LivraisonEntity livraison=await repository.facturableLivraison(state.livraisonId!);
      CoreBloc coreBloc=Dependencies.get<CoreBloc>();
      coreBloc.add(UpdateLivraison());
      coreBloc.add(UpdateClients());
      emit(state.copyWith(facturableStatus: AppStatus.success,livraison: livraison));
    }on NetworkConnectivityException catch(ex){
      emit(state.copyWith(facturableStatus: AppStatus.error,isOffline: true));
    }catch(ex){
      emit(state.copyWith(facturableStatus: AppStatus.error));
    }
  }


  FutureOr<void> _selectDevice(SelectDevice event, Emitter<LivraisonDetailsState> emit) async{
    print("============Select device");
    emit(state.copyWith(selectedDevice: event.device));
    Dependencies.put(event.device);
    add(GenerateRecu());
  }

  void devicesListener(List<BluetoothDevice> devices) {
    print("*******devices**************${devices}***********************");
    emit(state.copyWith(devices: devices));
  }
  void connectionListenner(ConnectState connectStatus) {
    print("*******connect status**************${connectStatus}***********************");
    if(connectStatus==ConnectState.connected){
      if(state.isPrinting??false){
        emit(state.copyWith(isPrinting: false));
        printRecu();
      }
    }else{

    }

  }

  @override
  Future<void> close() async{
    //await _devicesSubscription?.cancel();
    //await _connectionSubscription?.cancel();
    await super.close();
  }



}
