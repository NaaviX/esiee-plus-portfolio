import 'package:flutter/material.dart';

import 'event_list.dart';

class DisabledEventList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DisabledEventListState();
  }
}

class DisabledEventListState extends State<DisabledEventList>  with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(

        body: EventList(moderation: true,),
    );
  }
}



