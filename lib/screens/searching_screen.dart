import 'package:flutter/material.dart';
import 'package:parkit/Bloc/searchingBloc.dart';
import 'package:parkit/model/searchModel.dart';
import 'package:parkit/screens/parkingspotDetails.dart';

class Searching extends StatefulWidget {
  @override
  _SearchingState createState() => _SearchingState();
}

class _SearchingState extends State<Searching> {
  TextEditingController _searchController;
  FocusNode _foc=FocusNode();
  @override
  void initState() {
    _searchController=TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: TextField(
            focusNode: _foc,
            autofocus: true,
            controller: _searchController,
                keyboardAppearance: Brightness.light,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                onEditingComplete: (){
                  searchbloc.search(_searchController.text);},
                decoration: InputDecoration(  
                    enabled: true,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(8)),
                    hintText: 'Search',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.yellow,
                            width: 20,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(8))),
              ),
              actions: <Widget>[
                IconButton(
                  onPressed: ()=>searchbloc.search(_searchController.text),
                  icon: Icon(Icons.search),
                )
              ],
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: StreamBuilder(
                    stream: searchbloc.sreachresult,
                    builder: (BuildContext context,
                        AsyncSnapshot<SearchResult> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data.result.length,
                          itemExtent: 60,
                          padding: EdgeInsets.all(10),
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                             onTap: ()=> Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ParkingSpotDetails(parkingSpotKey: snapshot.data.result[index].parkingKey))),
                              contentPadding: EdgeInsets.all(5),
                              title: Text(snapshot.data.result[index].parkingSPotName),
                              subtitle: Text(snapshot.data.result[index].parkinglocation),
                              trailing: Image.network(snapshot.data.result[index].imageurl,width: 80,height: 80,fit: BoxFit.cover,),
                            );
                          },
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
