package cn.izis.util;


public class JavaToC {
	private static final int MEMORY_SIZE = 8;//设置内存
	static {
		System.loadLibrary("gnuGo-3.8");
		initGTP(MEMORY_SIZE);
//		setRules(1);
	}
	public native static String robot(String msg);
	public native static void initGTP(float a);//a=8 b=1or0
	public native static void setRules(int setRules);
	public native static String playGTP(String msg);
	
	
}
