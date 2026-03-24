import 'package:flutter/material.dart';

import '../../../../../domain/entities/client.dart';
import 'client_widget.dart';




class ProspectClients extends StatefulWidget {
  List<ClientEntity>? clients;
  ProspectClients({required this.clients});

  @override
  State<ProspectClients> createState() => _ProspectClientsState();
}

class _ProspectClientsState extends State<ProspectClients> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.clients!.length,
      itemBuilder: (context,index)=>ClientWidget(client: widget.clients!.elementAt(index)),
    );
  }
}


