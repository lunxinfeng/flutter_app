package cn.izis.util;

import android.util.Log;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

public class ScoreUtil {
	private String str[] = { "A", "B", "C", "D", "E", "F", "G", "H", "J", "K",
			"L", "M", "N", "O", "P", "Q", "R", "S", "T" };
	private int[][] Final_a;

	public ScoreUtil() {
		super();
		// TODO Auto-generated constructor stub
		new JavaToC();
	}

	public Score Final_score(String str) {
		Score score = new Score();
		List<Point> Dlist = new ArrayList<Point>();
		// JavaToC.playGTP("clear_cache");
		JavaToC.setRules(0);
		JavaToC.playGTP("komi 7.5");
		// JavaToC.playGTP("clear_board");
		// JavaToC.playGTP("level 5");
		List<String> myStrToSgf = MyStrToSgf(str);
		// gtpString(myStrToSgf);
		// finalborad(StringToArray(str));
		String showborad = JavaToC.playGTP("showboard");
		System.out.println(showborad + "          h");
		String final_score = JavaToC.playGTP("final_score");
		String final_status_list = JavaToC.playGTP("final_status_list dead");
		String black_territory = JavaToC
				.playGTP("final_status_list black_territory");
		String white_territory = JavaToC
				.playGTP("final_status_list white_territory");
		score.setScore(final_score);
		String[] tokens = getTokens(final_status_list);
		for (int i = 1; i < tokens.length; i++) {
			String string = tokens[i].toString();
			string.replace(" ", "");
			if (!string.equals("")) {
				Dlist.add(getPoint(string));
			}
		}
		// score.setDlist(Dlist);
		// 死子为隐智坐标系
		return score;
	}

	public Score Final_score2(int[][] a) {
		Final_a = new int[19][19];
		Final_a = a;
		Score score = new Score();
		List<Point> Dlist = new ArrayList<Point>();
		List<Point> Blist = new ArrayList<Point>();
		List<Point> Wlist = new ArrayList<Point>();
		JavaToC.playGTP("clear_cache");
		JavaToC.setRules(0);
		JavaToC.playGTP("komi 7.5");
		JavaToC.playGTP("clear_board");
		// JavaToC.playGTP("level 5");
		finalborad(Final_a, 19);
		// String final_score = JavaToC.playGTP("final_score");
		String final_score = JavaToC.playGTP("estimate_score");
		Log.d("----", "计算结果" + final_score);
		String final_status_list = JavaToC.playGTP("final_status_list dead");
		String black_territory = JavaToC
				.playGTP("final_status_list black_territory");
		String white_territory = JavaToC
				.playGTP("final_status_list white_territory");
		Log.d("----", "计算完成");
		Dlist = StringToList(final_status_list, Dlist);
		Blist = StringToList(black_territory, Blist);
		Wlist = StringToList(white_territory, Wlist);
		// 将死子标记
		String Final_score = "";
		double B_Point = 0;
		double W_Point = 0;
		double black_tag = 184.25;
		double white_tag = 176.75;
		for (int i = 0; i < Dlist.size(); i++) {
			int y = Dlist.get(i).getX();
			int x = Dlist.get(i).getY();
			if (Final_a[x][y] == 1) {
				Final_a[x][y] = 4;
			}
			if (Final_a[x][y] == 2) {
				Final_a[x][y] = 3;
			}
		}

		Territory(Blist, 5);
		Territory(Wlist, 6);
		a = Final_a;
		for (int i = 0; i < 19; i++) {
			for (int j = 0; j < 19; j++) {
				if (a[i][j] == 1 || a[i][j] == 3 || a[i][j] == 5) {
					B_Point++;
				}
				if (a[i][j] == 2 || a[i][j] == 4 || a[i][j] == 6) {
					W_Point++;
				}
				if (a[i][j] == 0) {
					B_Point += 0.5;
					W_Point += 0.5;
				}
			}
		}
		double black_success = B_Point - black_tag;
		double white_success = W_Point - white_tag;
		if (black_success > 0) {
			Final_score = "B ";
			double black_poor = black_success - (int) black_success;
			String black_po = String.valueOf(black_poor);
			if (black_success < 1) {
				black_po = "";
			} else {
				black_po = (int) black_success + "又";
			}
			if (black_poor == (int) black_poor) {
				Final_score += "黑胜：" + (int) black_poor + "子";
			} else if (black_poor == 0.25) {
				Final_score += "黑胜：" + black_po + "1/4子";
			} else if (black_poor == 0.5) {
				Final_score += "黑胜：" + black_po + "1/2子";
			} else if (black_poor == 0.75) {
				Final_score += "黑胜：" + black_po + "3/4子";
			}
		} else {
			Final_score = "W ";
			double white_poor = white_success - (int) white_success;
			String white_po = String.valueOf(white_poor);
			if (white_success < 1) {
				white_po = "";
			} else {
				white_po = (int) white_success + "又";
			}
			if (white_poor == (int) white_poor) {
				Final_score += "白胜：" + (int) white_poor + "子";
			} else if (white_poor == 0.25) {
				Final_score += "白胜：" + white_po + "1/4子";
			} else if (white_poor == 0.5) {
				Final_score += "白胜：" + white_po + "1/2子";
			} else if (white_poor == 0.75) {
				Final_score += "白胜：" + white_po + "3/4子";
			}
		}
		score.setScore(Final_score);
		score.setDlist(a);
		return score;
	}

	public Score Final_score3(int[][] a, int boradsize) {
		double B_Point = 0;
		double W_Point = 0;
		double black_tag = 0;
		double white_tag = 0;
		String Final_score = "";
		Final_a = new int[boradsize][boradsize];
		Final_a = a;
		Score score = new Score();
		List<Point> Dlist = new ArrayList<Point>();
		List<Point> Blist = new ArrayList<Point>();
		List<Point> Wlist = new ArrayList<Point>();
		JavaToC.playGTP("clear_cache");
		JavaToC.setRules(0);
		JavaToC.playGTP("boardsize " + boradsize);

		JavaToC.playGTP("komi 7.5");
		JavaToC.playGTP("clear_board");
		JavaToC.playGTP("level 5");
		finalborad(Final_a, boradsize);
		// String final_score = JavaToC.playGTP("final_score");
		String final_score = JavaToC.playGTP("estimate_score");
		// System.out.println("---------final_score="+final_score);
		String final_status_list = JavaToC.playGTP("final_status_list dead");
		String black_territory = JavaToC
				.playGTP("final_status_list black_territory");
		String white_territory = JavaToC
				.playGTP("final_status_list white_territory");
		Dlist = StringToList(final_status_list, Dlist);
		Blist = StringToList(black_territory, Blist);
		Wlist = StringToList(white_territory, Wlist);
		// 将死子标记
		for (int i = 0; i < Dlist.size(); i++) {
			int y = Dlist.get(i).getX();
			int x = Dlist.get(i).getY();
			if (Final_a[x][y] == 1) {
				Final_a[x][y] = 4;
			}
			if (Final_a[x][y] == 2) {
				Final_a[x][y] = 3;
			}
		}

		Territory(Blist, 5);
		Territory(Wlist, 6);
		a = Final_a;
		for (int i = 0; i < boradsize; i++) {
			for (int j = 0; j < boradsize; j++) {
				if (a[i][j] == 1 || a[i][j] == 3 || a[i][j] == 5) {
					B_Point++;
				}
				if (a[i][j] == 2 || a[i][j] == 4 || a[i][j] == 6) {
					W_Point++;
				}
				if (a[i][j] == 0) {
					B_Point += 0.5;
					W_Point += 0.5;
				}
			}
		}
		if (boradsize == 19) {
			black_tag = 184.25;
			white_tag = 176.75;
		} else if (boradsize == 13) {
			// black_tag = 87.25; 5.5目
			// white_tag = 81.75;
			black_tag = 88.25;
			white_tag = 80.75;
		} else if (boradsize == 9) {
			black_tag = 44.25;
			white_tag = 36.75;
		} else if (boradsize == 7) {
			black_tag = 28.25;
			white_tag = 20.75;
		}
		double black_success = B_Point - black_tag;
		double white_success = W_Point - white_tag;
		if (black_success > 0) {
			Final_score = "B ";
			double black_poor = black_success - (int) black_success;
			String black_po = String.valueOf(black_poor);
			if (black_success < 1) {
				black_po = "";
			} else {
				black_po = (int) black_success + "又";
			}
			if (black_poor == (int) black_poor) {
				Final_score += "黑胜：" + (int) black_poor + "子";
			} else if (black_poor == 0.25) {
				Final_score += "黑胜：" + black_po + "1/4子";
			} else if (black_poor == 0.5) {
				Final_score += "黑胜：" + black_po + "1/2子";
			} else if (black_poor == 0.75) {
				Final_score += "黑胜：" + black_po + "3/4子";
			}
		} else {
			Final_score = "W ";
			double white_poor = white_success - (int) white_success;
			String white_po = String.valueOf(white_poor);
			if (white_success < 1) {
				white_po = "";
			} else {
				white_po = (int) white_success + "又";
			}
			if (white_poor == (int) white_poor) {
				Final_score += "白胜：" + (int) white_poor + "子";
			} else if (white_poor == 0.25) {
				Final_score += "白胜：" + white_po + "1/4子";
			} else if (white_poor == 0.5) {
				Final_score += "白胜：" + white_po + "1/2子";
			} else if (white_poor == 0.75) {
				Final_score += "白胜：" + white_po + "3/4子";
			}
		}
		score.setScore(Final_score);
		score.setDlist(a);
		return score;
	}
	
	/**
	 * 当前棋局的形势
	 */
	public int[][] situation(int[][] a, int boradsize,String color){
		
		JavaToC.playGTP("clear_cache");
		JavaToC.setRules(0);
		JavaToC.playGTP("boardsize " + boradsize);
		
		Final_a = new int[boradsize][boradsize];
		Final_a = a;
		
		finalborad(Final_a, boradsize);
		
		String situation = JavaToC.playGTP("initial_influence "+color+" influence_regions");
		String[] str = situation.substring(1).replaceFirst("\\s+", "").split("\\s+");
		int[][] board = new int[boradsize][boradsize];
		for (int i = 0; i < boradsize; i++) {
			for (int j = 0; j < boradsize; j++) {
				int n = Integer.parseInt(str[i*boradsize+j]);
				if (n==-4) {
					board[j][boradsize-1-i] = 1;
				}else if (n==4) {
					board[j][boradsize-1-i] = 2;
				}else if (n==0) {
					board[j][boradsize-1-i] = 0;
				}else if(n<0){
					board[j][boradsize-1-i] = 5;
				}else if(n>0){
					board[j][boradsize-1-i] = 6;
				}
			}
		}
		return board;
	}

	/**
	 * 天元流判胜负
	 * 
	 * @param a
	 * @param boradsize
	 * @return
	 */
	public Score Final_score_tianyuan(int[][] a, int boradsize) {
		double B_Point = 0;
		double W_Point = 0;
		double black_tag = 0;
		double white_tag = 0;
		String Final_score = "";
		Final_a = new int[boradsize][boradsize];
		Final_a = a;
		Score score = new Score();
		List<Point> Dlist = new ArrayList<Point>();
		List<Point> Blist = new ArrayList<Point>();
		List<Point> Wlist = new ArrayList<Point>();
		JavaToC.playGTP("clear_cache");
		JavaToC.setRules(0);
		JavaToC.playGTP("boardsize " + boradsize);
		JavaToC.playGTP("clear_board");
		JavaToC.playGTP("level 5");
		JavaToC.playGTP("komi 9");
		finalborad(Final_a, boradsize);
		// String final_score = JavaToC.playGTP("final_score");
		String final_score = JavaToC.playGTP("estimate_score");
		// System.out.println("---------final_score="+final_score);
		String final_status_list = JavaToC.playGTP("final_status_list dead");
		String black_territory = JavaToC
				.playGTP("final_status_list black_territory");
		String white_territory = JavaToC
				.playGTP("final_status_list white_territory");
		Dlist = StringToList(final_status_list, Dlist);
		Blist = StringToList(black_territory, Blist);
		Wlist = StringToList(white_territory, Wlist);
		// 将死子标记
		for (int i = 0; i < Dlist.size(); i++) {
			int y = Dlist.get(i).getX();
			int x = Dlist.get(i).getY();
			if (Final_a[x][y] == 1) {
				Final_a[x][y] = 4;
			}
			if (Final_a[x][y] == 2) {
				Final_a[x][y] = 3;
			}
		}

		Territory(Blist, 5);
		Territory(Wlist, 6);
		a = Final_a;
		for (int i = 0; i < boradsize; i++) {
			for (int j = 0; j < boradsize; j++) {
				if (a[i][j] == 1 || a[i][j] == 3 || a[i][j] == 5) {
					B_Point++;
				}
				if (a[i][j] == 2 || a[i][j] == 4 || a[i][j] == 6) {
					W_Point++;
				}
				if (a[i][j] == 0) {
					B_Point += 0.5;
					W_Point += 0.5;
				}
			}
		}

		// 9---7.5 相差1.5
		if (boradsize == 19) {
			black_tag = 185; // 185
			white_tag = 176; // 176
		} else if (boradsize == 13) {
			black_tag = 89;
			white_tag = 80;
		} else if (boradsize == 9) {
			black_tag = 45;
			white_tag = 36;
		} else if (boradsize == 7) {
			black_tag = 29;
			white_tag = 20;
		}
		double black_success = B_Point - black_tag;
		double white_success = W_Point - white_tag;

		if (black_success == 0) {
			Final_score = "* ";
			Final_score += "贴9目和棋";
		} else {

			if (black_success > 0) {
				Final_score = "B ";
				double black_poor = black_success - (int) black_success;

				String black_po = String.valueOf(black_poor);
				if (black_success < 1) {
					black_po = "";
				} else {
					black_po = (int) black_success + "又";
				}
				if (black_poor == (int) black_poor) {
					Final_score += "黑胜：" + (int) black_success + "子";
				} else if (black_poor == 0.25) {
					Final_score += "黑胜：" + black_po + "1/4子";
				} else if (black_poor == 0.5) {
					Final_score += "黑胜：" + black_po + "1/2子";
				} else if (black_poor == 0.75) {
					Final_score += "黑胜：" + black_po + "3/4子";
				}

			} else {
				Final_score = "W ";
				double white_poor = white_success - (int) white_success;

				String white_po = String.valueOf(white_poor);
				if (white_success < 1) {
					white_po = "";
				} else {
					white_po = (int) white_success + "又";
				}
				if (white_poor == (int) white_poor) {
					Final_score += "白胜：" + (int) white_success + "子";
				} else if (white_poor == 0.25) {
					Final_score += "白胜：" + white_po + "1/4子";
				} else if (white_poor == 0.5) {
					Final_score += "白胜：" + white_po + "1/2子";
				} else if (white_poor == 0.75) {
					Final_score += "白胜：" + white_po + "3/4子";
				}

			}
		}
		score.setScore(Final_score);
		score.setDlist(a);
		return score;
	}

	public void Territory(List<Point> list, int color) {
		for (int i = 0; i < list.size(); i++) {
			Final_a[list.get(i).getY()][list.get(i).getX()] = color;
		}
	}

	public List<Point> StringToList(String msg, List<Point> list) {
		String[] tokens = getTokens(msg);
		for (int i = 1; i < tokens.length; i++) {
			String string = tokens[i].toString();
			string.replace(" ", "");
			if (!string.equals("")) {
				list.add(getPoint(string));
			}
		}
		return list;

	}

	public List<String> MyStrToSgf(String str) {
		List<String> list = new ArrayList<String>();
		if (str.length() % 5 == 0) {
			for (int i = 0; i < str.length() / 5; i++) {
				String substring = str.substring(i * 5, i * 5 + 5);
				String SGF = IntToString(substring.substring(3, 5))
						+ substring.substring(1, 3);
				list.add(SGF);
			}
		}
		return list;
	}

	public Point getPoint(String str) {
		String x = "";
		String y = "";
		Point p = new Point();
		x = str.substring(0, 1);
		y = str.substring(1);
		int m = StringToInt(x);
		p.setX(Integer.parseInt(y) - 1);
		p.setY(m);
		if (m < 0) {
			return null;
		}
		return p;
	}

	private int StringToInt(String msg) {
		int x = -1;
		for (int i = 0; i < str.length; i++) {
			if (msg.equals(str[i])) {
				x = i;
				break;
			}
		}
		return x;
	}

	public String IntToString(String msg) {
		String STR = "";
		if (msg.equals("01")) {
			STR = "a";
		} else if (msg.equals("02")) {
			STR = "b";
		} else if (msg.equals("03")) {
			STR = "c";
		} else if (msg.equals("04")) {
			STR = "d";
		} else if (msg.equals("05")) {
			STR = "e";
		} else if (msg.equals("06")) {
			STR = "f";
		} else if (msg.equals("07")) {
			STR = "g";
		} else if (msg.equals("08")) {
			STR = "h";
		} else if (msg.equals("09")) {
			STR = "j";
		} else if (msg.equals("10")) {
			STR = "k";
		} else if (msg.equals("11")) {
			STR = "l";
		} else if (msg.equals("12")) {
			STR = "m";
		} else if (msg.equals("13")) {
			STR = "n";
		} else if (msg.equals("14")) {
			STR = "o";
		} else if (msg.equals("15")) {
			STR = "p";
		} else if (msg.equals("16")) {
			STR = "q";
		} else if (msg.equals("17")) {
			STR = "r";
		} else if (msg.equals("18")) {
			STR = "s";
		} else if (msg.equals("19")) {
			STR = "t";
		}
		return STR;
	}

	public String[] getTokens(String input) {

		int i = 0;
		StringTokenizer st = new StringTokenizer(input);
		int numTokens = st.countTokens();
		String[] tokenList = new String[numTokens];
		while (st.hasMoreTokens()) {
			tokenList[i] = st.nextToken();
			i++;
		}
		return (tokenList);
	}

	public void finalborad(int[][] a, int boardsize) {
		for (int i = 0; i < boardsize; i++) {
			for (int j = 0; j < boardsize; j++) {
				if (a[j][i] == 1) {
					JavaToC.playGTP("black " + str[j] + String.valueOf(i + 1));
				}
				if (a[j][i] == 2) {
					JavaToC.playGTP("white " + str[j] + String.valueOf(i + 1));
				}
			}
		}
	}

	public static int[][] StringToArray(String str, int boardsize) {
		int[][] nowpieces = new int[boardsize][boardsize];
		String temp[] = str.split(",");
		for (int i = 0; i < boardsize; i++) {
			for (int j = 0; j < boardsize; j++) {
				nowpieces[i][j] = temp[i].charAt(j) - '0';
			}
		}
		return nowpieces;

	}

	public void gtpString(List<String> list) {
		for (int i = 0; i < list.size(); i++) {
			if (i % 2 == 0) {
				JavaToC.playGTP("black " + list.get(i).toString());

			} else {
				JavaToC.playGTP("white " + list.get(i).toString());
			}
		}
	}

	public String gtpString(int x, int y, int Player) {
		String json = "";
		if (Player == 0) {
			JavaToC.playGTP("black " + str[x] + String.valueOf(y));
			json = JavaToC.playGTP("genmove white");
		} else {
			JavaToC.playGTP("white " + str[x] + String.valueOf(y));
			json = JavaToC.playGTP("genmove black");
		}
		return json;
	}

	public void gtpUserString(int x, int y, int Player) {
		String json = "";
		if (Player == 0) {
			JavaToC.playGTP("black " + str[x] + String.valueOf(y));
		} else {
			JavaToC.playGTP("white " + str[x] + String.valueOf(y));
		}
	}

	public int[][] ArrayScore(int[][] a, Score score) {
		int finalScore[][] = new int[19][19];
		int used[][] = new int[19][19];
		int used2[][] = new int[19][19];
		for (int i = 0; i < 19; i++) {
			used2 = used;
			for (int j = 0; j < 19; j++) {
				if (a[j][i] == 0) {
					ArrayList<Point> list = new ArrayList<Point>();
					floodFill4(j, i, a, finalScore, used,
							ListF(j, i, used2, a, list, score));
				}
			}
		}
		// for (int i = 0; i < score.getDlist().size(); i++) {
		// if(a[score.getDlist().get(i).getX()][score.getDlist().get(i).getY()]==1){
		// finalScore[score.getDlist().get(i).getX()][score.getDlist().get(i).getY()]=4;
		// }
		// if(a[score.getDlist().get(i).getX()][score.getDlist().get(i).getY()]==2){
		// finalScore[score.getDlist().get(i).getX()][score.getDlist().get(i).getY()]=5;
		// }
		//
		// }
		for (int i = 0; i < 19; i++) {
			for (int j = 0; j < 19; j++) {
				if (finalScore[i][j] == 0) {
					finalScore[i][j] = a[i][j];
				}
			}
		}
		return finalScore;
	}

	public void floodFill4(int x, int y, int[][] a, int[][] finalScore,
			int[][] used, int Ncolor) {
		// 标记该点已被查询
		used[x][y] = 1;
		finalScore[x][y] = Ncolor;

		// 判断x,y是否在棋盘边缘上
		if (x - 1 >= 0) {
			if (x >= 0 && a[x - 1][y] == 0 && used[x - 1][y] == 0) { // 向左
				floodFill4(x - 1, y, a, finalScore, used, Ncolor);
			}
		}

		if (y - 1 >= 0) {
			if (y >= 0 && a[x][y - 1] == 0 && used[x][y - 1] == 0) { // 向下
				floodFill4(x, y - 1, a, finalScore, used, Ncolor);
			}
		}

		if (x + 1 < 19) {
			if (x < 19 && a[x + 1][y] == 0 && used[x + 1][y] == 0) {

				floodFill4(x + 1, y, a, finalScore, used, Ncolor);
			}
		}

		if (y + 1 < 19) {
			if (y < 19 && a[x][y + 1] == 0 && used[x][y + 1] == 0) { // 向上
				floodFill4(x, y + 1, a, finalScore, used, Ncolor);
			}
		}
	}

	public int ListF(int x, int y, int[][] used2, int[][] a,
			ArrayList<Point> list, Score score) {
		F(x, y, used2, a, list);
		return name(list, score, a);
	}

	public int name(ArrayList<Point> list, Score score, int[][] a) {
		String X = null;
		String Y = null;

		// for (int i = 0; i < score.getDlist().size(); i++) {
		// for (int j = 0; j < list.size(); j++) {
		// if(score.getDlist().get(i).equals(list.get(j))){
		// list.remove(list.get(j));
		// }
		// }
		// }
		for (int i = 0; i < list.size(); i++) {
			if (a[list.get(i).getX()][list.get(i).getY()] == 1) {
				X = "A";
			}
			if (a[list.get(i).getX()][list.get(i).getY()] == 2) {
				Y = "B";
			}
		}

		if (X != null && Y != null) {
			return 7;
		} else if (X == null && Y != null) {
			return 6;
		} else {
			return 5;
		}

	}

	public void F(int x, int y, int[][] used2, int[][] a, ArrayList<Point> list) {
		used2[x][y] = 1;

		if (x - 1 >= 0) {
			if (x >= 0 && used2[x - 1][y] == 0) {
				if (a[x - 1][y] != 0) {
					list.add(new Point(x - 1, y));
					used2[x - 1][y] = 1;
				} else {
					F(x - 1, y, used2, a, list);
				}
			}
		}

		if (y - 1 >= 0) {
			if (y >= 0 && used2[x][y - 1] == 0) {
				if (a[x][y - 1] != 0) {
					list.add(new Point(x, y - 1));
					used2[x][y - 1] = 1;
				} else {
					F(x, y - 1, used2, a, list);
				}
			}
		}

		if (x + 1 < 19) {
			if (x < 19 && used2[x + 1][y] == 0) {
				if (a[x + 1][y] != 0) {
					list.add(new Point(x + 1, y));
					used2[x + 1][y] = 1;
				} else {
					F(x + 1, y, used2, a, list);
				}
			}
		}

		if (y + 1 < 19) {
			if (y < 19 && used2[x][y + 1] == 0) {
				if (a[x][y + 1] != 0) {
					list.add(new Point(x, y + 1));
					used2[x][y + 1] = 1;
				} else {
					F(x, y + 1, used2, a, list);
				}
			}
		}
	}

	/**
	 * 五子棋计算胜负
	 * 
	 * @param x
	 *            落子点位x坐标
	 * @param y
	 *            落子点位y坐标
	 * @param colour
	 *            落子颜色
	 * @param a
	 *            二维数组后的棋盘
	 * @param nx
	 *            棋盘x方向大小
	 * @param ny
	 *            棋盘y方向大小
	 * @return
	 */
	public boolean GoBangWin(int x, int y, int colour, int[][] a, int nx, int ny) {
		List<Point> listR = new ArrayList<Point>();// 左右方向的棋子
		List<Point> listU = new ArrayList<Point>();// 上下方向的棋子
		List<Point> listRU = new ArrayList<Point>();// 右上左下方向的棋子
		List<Point> listRD = new ArrayList<Point>();// 右下坐上方向的棋子
		int[][] used = new int[nx][ny];
		listR.add(new Point(x, y));
		listU.add(new Point(x, y));
		listRU.add(new Point(x, y));
		listRD.add(new Point(x, y));
		GoBangfloodFill8(x, y, colour, a, listR, listU, listRU, listRD, nx, ny,
				0, used);
		if (listR.size() >= 5 || listU.size() >= 5 || listRU.size() >= 5
				|| listRD.size() >= 5) {
			return true;
		} else {
			return false;
		}
		// if(listR.size()<6&&listU.size()<6&&listRU.size()<6&&listRD.size()<6){
		// if(listR.size()==5||listU.size()==5||listRU.size()==5||listRD.size()==5){
		// return true;
		// }else{
		// return false;
		// }
		// }else{
		// return false;
		// }
	}

	/**
	 * 
	 * @param x
	 *            落子点位x坐标
	 * @param y
	 *            落子点位y坐标
	 * @param colour
	 *            落子颜色
	 * @param a
	 *            二维数组后的棋盘
	 * @param listR
	 *            棋子方向集合
	 * @param listU
	 *            棋子方向集合
	 * @param listRU
	 *            棋子方向集合
	 * @param listRD
	 *            棋子方向集合
	 * @param nx
	 *            棋盘x方向大小
	 * @param ny
	 *            棋盘y方向大小
	 * @param direction
	 *            需找方向限定 0：8方向寻找 1：R 2：U 3:RU 4：RD
	 * @param used
	 *            查询情况 0 未查询 1已查询
	 */
	public void GoBangfloodFill8(int x, int y, int colour, int[][] a,
			List<Point> listR, List<Point> listU, List<Point> listRU,
			List<Point> listRD, int nx, int ny, int direction, int[][] used) {
		used[x][y] = 1;
		if (direction > 0) {
			switch (direction) {
			case 1:// 左右方向的棋子
				if (x - 1 >= 0 && used[x - 1][y] == 0 && a[x - 1][y] == colour) {// 向左
					listR.add(new Point(x - 1, y));
					GoBangfloodFill8(x - 1, y, colour, a, listR, listU, listRU,
							listRD, nx, ny, 1, used);
				}
				if (x + 1 < nx && used[x + 1][y] == 0 && a[x + 1][y] == colour) {// 向右
					listR.add(new Point(x + 1, y));
					GoBangfloodFill8(x + 1, y, colour, a, listR, listU, listRU,
							listRD, nx, ny, 1, used);
				}
				break;
			case 2:// 上下方向的棋子
				if (y - 1 >= 0 && used[x][y - 1] == 0 && a[x][y - 1] == colour) {// 向下
					listU.add(new Point(x, y - 1));
					GoBangfloodFill8(x, y - 1, colour, a, listR, listU, listRU,
							listRD, nx, ny, 2, used);
				}
				if (y + 1 < ny && used[x][y + 1] == 0 && a[x][y + 1] == colour) {// 向上
					listU.add(new Point(x, y + 1));
					GoBangfloodFill8(x, y + 1, colour, a, listR, listU, listRU,
							listRD, nx, ny, 2, used);
				}
				break;
			case 3:// 右上左下方向的棋子
				if (x - 1 >= 0 && y - 1 >= 0 && used[x - 1][y - 1] == 0
						&& a[x - 1][y - 1] == colour) {// 左下
					listRU.add(new Point(x - 1, y - 1));
					GoBangfloodFill8(x - 1, y - 1, colour, a, listR, listU,
							listRU, listRD, nx, ny, 3, used);
				}
				if (x + 1 < nx && y + 1 < ny && used[x + 1][y + 1] == 0
						&& a[x + 1][y + 1] == colour) {// 右上
					listRU.add(new Point(x + 1, y + 1));
					GoBangfloodFill8(x + 1, y + 1, colour, a, listR, listU,
							listRU, listRD, nx, ny, 3, used);
				}
				break;
			case 4:// 右下坐上方向的棋子
				if (x - 1 >= 0 && y + 1 < ny && used[x - 1][y + 1] == 0
						&& a[x - 1][y + 1] == colour) {// 左上
					listRD.add(new Point(x - 1, y + 1));
					GoBangfloodFill8(x - 1, y + 1, colour, a, listR, listU,
							listRU, listRD, nx, ny, 4, used);
				}
				if (x + 1 < nx && y - 1 >= 0 && used[x + 1][y - 1] == 0
						&& a[x + 1][y - 1] == colour) {// 右下
					listRD.add(new Point(x + 1, y + 1));
					GoBangfloodFill8(x + 1, y - 1, colour, a, listR, listU,
							listRU, listRD, nx, ny, 4, used);
				}
				break;
			default:
				break;
			}
		} else {
			if (x - 1 >= 0 && used[x - 1][y] == 0 && a[x - 1][y] == colour) {// 向左
				listR.add(new Point(x - 1, y));
				GoBangfloodFill8(x - 1, y, colour, a, listR, listU, listRU,
						listRD, nx, ny, 1, used);
			}
			if (y - 1 >= 0 && used[x][y - 1] == 0 && a[x][y - 1] == colour) {// 向下
				listU.add(new Point(x, y - 1));
				GoBangfloodFill8(x, y - 1, colour, a, listR, listU, listRU,
						listRD, nx, ny, 2, used);
			}
			if (x + 1 < nx && used[x + 1][y] == 0 && a[x + 1][y] == colour) {// 向右
				listR.add(new Point(x + 1, y));
				GoBangfloodFill8(x + 1, y, colour, a, listR, listU, listRU,
						listRD, nx, ny, 1, used);
			}
			if (y + 1 < ny && used[x][y + 1] == 0 && a[x][y + 1] == colour) {// 向上
				listU.add(new Point(x, y + 1));
				GoBangfloodFill8(x, y + 1, colour, a, listR, listU, listRU,
						listRD, nx, ny, 2, used);
			}
			if (x - 1 >= 0 && y - 1 >= 0 && used[x - 1][y - 1] == 0
					&& a[x - 1][y - 1] == colour) {// 左下
				listRU.add(new Point(x - 1, y - 1));
				GoBangfloodFill8(x - 1, y - 1, colour, a, listR, listU, listRU,
						listRD, nx, ny, 3, used);
			}
			if (x - 1 >= 0 && y + 1 < ny && used[x - 1][y + 1] == 0
					&& a[x - 1][y + 1] == colour) {// 左上
				listRD.add(new Point(x - 1, y + 1));
				GoBangfloodFill8(x - 1, y + 1, colour, a, listR, listU, listRU,
						listRD, nx, ny, 4, used);
			}
			if (x + 1 < nx && y - 1 >= 0 && used[x + 1][y - 1] == 0
					&& a[x + 1][y - 1] == colour) {// 右下
				listRD.add(new Point(x + 1, y + 1));
				GoBangfloodFill8(x + 1, y - 1, colour, a, listR, listU, listRU,
						listRD, nx, ny, 4, used);
			}
			if (x + 1 < nx && y + 1 < ny && used[x + 1][y + 1] == 0
					&& a[x + 1][y + 1] == colour) {// 右上
				listRU.add(new Point(x + 1, y + 1));
				GoBangfloodFill8(x + 1, y + 1, colour, a, listR, listU, listRU,
						listRD, nx, ny, 3, used);
			}
		}

	}

}
