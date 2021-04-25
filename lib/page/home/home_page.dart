import 'package:flutter/material.dart';
import 'package:layout/base/base_bloc.dart';
import 'package:layout/model/co_check.dart';
import 'package:layout/model/rows_model.dart';

import 'home_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = BlocProvider.of<HomeBloc>(context);
    bloc.getListTote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: _appBar(),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(10),
            child: _textInput(),
          ),
          Expanded(child: _listTote()),
        ],
      ),
    );
  }

  Widget _listTote() {
    return StreamBuilder(
        stream: bloc.toteListStream,
        builder: (BuildContext context,
            AsyncSnapshot<CoCheck> snapshot) {
          if (!snapshot.hasData) {
            return Text('Data not found');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            scrollDirection: Axis.vertical,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
            itemCount: snapshot.data.rows.length,
            itemBuilder: (context, index) {
              return _gridViewBuilder(snapshot.data.rows[index]);
            },
          );
        });
  }

  Widget _gridViewBuilder(RowEntity entity) {
    return GestureDetector(
      child: Card(
        color: Colors.black12,
        child: Column(
          children: [
            Text(
              entity.storeEtonCode,
              style: TextStyle(color: Colors.white, fontSize: 25),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            Text(
              entity.tote,
              style: TextStyle(color: Colors.white, fontSize: 25),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            Text(
              entity.qty.toString(),
              style: TextStyle(color: Colors.white, fontSize: 25),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _textInput(){
    return Container(
      color: Colors.grey[850],
      child: TextFormField(
        decoration: InputDecoration(
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Colors.deepOrangeAccent,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar(){
    bool isSwitched = false;
    return AppBar(
      leading: Icon(Icons.arrow_back),
      title: Text('Tote List'),centerTitle: true,
      actions: [
        Row(
          children: [
            Switch(
              value: isSwitched,
              onChanged: (value) {
                setState(() {
                  isSwitched = value;
                  print(isSwitched);
                });
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            )
          ],
        ),
      ],
    );
  }
}
