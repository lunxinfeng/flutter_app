package cn.izis.util;

public class Score {
	private String score;
	private int[][] Dlist;

	public String getScore() {
		return score;
	}

	public void setScore(String score) {
		this.score = score;
	}

	public int[][] getDlist() {
		return Dlist;
	}

	public void setDlist(int[][] dlist) {
		Dlist = dlist;
	}

	public Score() {
		super();
		// TODO Auto-generated constructor stub
	}

	public Score(String score, int[][] dlist) {
		super();
		this.score = score;
		Dlist = dlist;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((Dlist == null) ? 0 : Dlist.hashCode());
		result = prime * result + ((score == null) ? 0 : score.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Score other = (Score) obj;
		if (Dlist == null) {
			if (other.Dlist != null)
				return false;
		} else if (!Dlist.equals(other.Dlist))
			return false;
		if (score == null) {
			if (other.score != null)
				return false;
		} else if (!score.equals(other.score))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "Score [score=" + score + ", Dlist=" + Dlist + "]";
	}

}
