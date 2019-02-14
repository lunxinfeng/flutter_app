import 'package:tile/Coordinate.dart';

class PieceProcess{
   int bw;
   Coordinate c;
   List<PieceProcess> removedList;

   int resultBlackCount;
   int resultWhiteCount;

   PieceProcess(this.bw, this.c, this.removedList);
   PieceProcess.create(int bw,Coordinate c):this(bw,c,List<PieceProcess>());
}