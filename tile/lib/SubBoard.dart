import 'package:tile/Board.dart';
import 'package:tile/PieceProcess.dart';

class SubBoard extends Board{
   Board parent;
   int position = -1;

   SubBoard(Board parent,int boardSize):super(boardSize) {
     this.parent = parent;
   }

   int getParentCount() {
     return parent.getCount();
   }

   void forward() {
     if (position + 1 < parent.getCount()) {
       position++;
       PieceProcess p = parent.getPieceProcess(position);
       //if(p.c.x==0 || p.c.y==0) return;
       this.addPieceProcess(p);
     }
   }

   void back() {
     if (position < 0)return;

     this.removePieceProcess();
     position--;
   }

   void gotoIt(int m) {
     if (m > parent.getCount() || m < 0)
       return;

     this.cleanGrid(this.getBoardSize());

     for (int i = 0; i < m; i++) {
       forward();
     }
   }

   @override
   bool put(int x,int y,int boardSize){
     bool r=super.put(x, y,boardSize);
     if(r==true){
       position++;
     }
     return r;
   }
}