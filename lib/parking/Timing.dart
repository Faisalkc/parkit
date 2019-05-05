class Timing {
  String from, to;
  bool isAvailable = false;

  Timing(int fromhh,int frommm,this.isAvailable )
  {
    this.from=fromhh.toString()+' : '+frommm.toString();
    frommm==30?this.to=(fromhh+1).toString()+' : 00':this.to=fromhh.toString()+" : 30";
  }
}
