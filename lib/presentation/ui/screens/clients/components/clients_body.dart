import 'package:flutter/material.dart';
import 'package:pda/presentation/ui/components/not_found_widget.dart';

import '../../../../../domain/entities/client.dart';
import 'client_widget.dart';

class ClientsBody extends StatefulWidget {
  List<ClientEntity> clients;
  void Function(ClientEntity)? onClick;
  ClientsBody({required this.clients,this.onClick});

  @override
  State<ClientsBody> createState() => _ClientsBodyState();
}

class _ClientsBodyState extends State<ClientsBody> {
  @override
  Widget build(BuildContext context) {
    return widget.clients.isNotEmpty
        ? ListView.builder(
            itemCount: widget.clients.length,
            itemBuilder: (context, index) =>
                ClientWidget(client: widget.clients.elementAt(index),onClick: widget.onClick,),
          )
        : Center(
            child: NotFoundWidget(),
          );
  }
}
