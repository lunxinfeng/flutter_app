package com.lxf.flutterapp

import android.os.Bundle
import cn.izis.util.JavaToC
import cn.izis.util.ScoreUtil

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.view.FlutterNativeView
import java.util.concurrent.Callable
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {
    /**
     * Channel名称：必须与Flutter App的Channel名称一致
     */
    private val BASIC_MESSAGE_CHANNEL = "study_3/basicMessageChannel"
    private val METHOD_CHANNEL = "study_3/methodChannel"
    private val EVENT_CHANNEL = "study_3/eventChannel"

    private val METHOD_CHANNEL_ROBOT = "com.lxf.plugin/robot"
    private val executorService = Executors.newSingleThreadExecutor()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        basicMessageChanelDemo()
        methodChannelDemo()
        eventChannelDemo()

        MethodChannel(this.flutterView, METHOD_CHANNEL_ROBOT)
                .setMethodCallHandler { methodCall, result ->
                    when (methodCall.method) {
                        "startGame" -> {
                            result.success(startGame())
                        }
                        "getRobotChess" -> {
                            println(methodCall.arguments)
                            getRobotChess(methodCall.arguments as String,result)
                        }
                        "aiRegret" -> {
                            result.success(aiRegret(methodCall.arguments as Int))
                        }
                    }
                }
    }

    private fun basicMessageChanelDemo(){
        BasicMessageChannel(this.flutterView,BASIC_MESSAGE_CHANNEL, StandardMessageCodec.INSTANCE)
                .setMessageHandler { any, reply ->
                    println("android listen:$any")
                    reply.reply("android response to flutter")


                    BasicMessageChannel(this.flutterView,BASIC_MESSAGE_CHANNEL, StandardMessageCodec.INSTANCE)
                            .send("android send to flutter"){
                                println("android receive response:$it")
                            }
                }
    }

    private fun methodChannelDemo(){
        MethodChannel(this.flutterView,METHOD_CHANNEL)
                .setMethodCallHandler { methodCall, result ->
                    println("android listen:${methodCall.method} \t ${methodCall.arguments}")
                    when(methodCall.method){
                        "getAge" -> {
                            result.success(getAge(methodCall.argument<String>("name")))
                        }
                    }


                    MethodChannel(this.flutterView,METHOD_CHANNEL)
                            .invokeMethod("getSex", mapOf(Pair("name","tom")), object : MethodChannel.Result {
                                override fun notImplemented() {
                                    println("android receive notImplemented")
                                }

                                override fun error(p0: String?, p1: String?, p2: Any?) {
                                    println("android receive error")
                                }

                                override fun success(p0: Any?) {
                                    println("android receive response:$p0")
                                }
                            })
                }
    }

    private fun getAge(name:String?): Int{
        return when(name){
            "lili" -> 18
            "tom" -> 19
            "allen" -> 20
            else -> 0
        }
    }

    private fun eventChannelDemo(){
        EventChannel(this.flutterView,EVENT_CHANNEL)
                .setStreamHandler(object : EventChannel.StreamHandler {
                    override fun onListen(p0: Any?, events: EventChannel.EventSink?) {
                        println("android onListen:$p0")

                        events?.success(1)
                        events?.success(2)
                        events?.success(3)
                        events?.success(4)
                        events?.endOfStream()
                        events?.success(5)
                    }

                    override fun onCancel(p0: Any?) {
                        println("android onCancel:$p0")
                    }
                })
    }

    private fun startGame(): Int {
        println("android startGame")
        //用户执黑
        JavaToC.playGTP("boardsize " + 9) //9路棋
        JavaToC.playGTP("level 4")// 初始化机器人，设置等级
        return 1
    }

    private fun getRobotChess(lastStep:String,result:MethodChannel.Result) {
        println("android getRobotChess $lastStep")
        val future = executorService.submit(Callable<String> {
            val lastStepx = lastStep.substring(1, 3).toInt() // 从第一个截取前两个
            val lastStepy = lastStep.substring(3).toInt()  // 截取最后2个
            var step = ""
            ScoreUtil().let {
                step = it.gtpString(lastStepy - 1, lastStepx, 0)
                step = parseCoordinate(true,step,it)
            }
            println("android getRobotChess result $step")
            result.success(step)
            step
        })
        println("android getRobotChess after")
    }

    private fun aiRegret(num:Int): Int {
        println("android aiRegret $num")
        for(i in 0 until num){
            JavaToC.playGTP("undo")
        }
        return 1
    }

    /**
     * 把机器人C方法传过来的值解析成board可以读的坐标值 like "+1203"
     */
    private fun parseCoordinate(useBlack:Boolean,gtpString: String,util:ScoreUtil): String {
        var gtpString = gtpString
        // 如果机器人返回pass表示机器人让一手
        if (gtpString.equals("= PASS\n\n", ignoreCase = true)) {
            return if (useBlack) {
                "-0000"
            } else {
                "+0000"
            }
        } else if (gtpString.equals("= resign\n\n", ignoreCase = true)) {
            return "resign"
        } else {
            var parseCoor = ""
            gtpString = gtpString.replace("=", "") // 去掉前面的等于号
            gtpString = gtpString.replace(" ", "") // 去掉空格
            val gtpStr = util.getTokens(gtpString) // 拆分斜杠前后的数据
            gtpString = gtpStr[0] // 得到俩坐标 与 “R3” 类似的结构的
            if (gtpString.length == 2) {
                val cX = gtpString[0]
                val coordinateX = changeToIntString(cX)
                var coordinateY = gtpString.substring(1)
                if (Integer.valueOf(coordinateY) < 10) {
                    coordinateY = "0$coordinateY"
                }
                parseCoor = coordinateY + coordinateX
            } else if (gtpString.length == 3) {
                val cX = gtpString[0]
                val coordinateX = changeToIntString(cX)
                val coordinateY = gtpString.substring(1)
                parseCoor = coordinateY + coordinateX
            }
            return if (useBlack) {
                "-$parseCoor" // 用户使用黑子 机器人即为白子
            } else {
                "+$parseCoor"
            }
        }
    }

    /**
     * 将字母转换成对应的坐标 的值 （先转换成相应的asscll码值 再 转换成坐标值） 注意机器人的X坐标没有“I”
     */
    private fun changeToIntString(coordinateX: Char): String {
        val coordiateXInt = coordinateX.toInt()// Integer.valueOf(coordinateY);
        val intX: Int
        if (coordinateX.toInt() > 73) {
            intX = coordiateXInt - 65
        } else {
            intX = coordiateXInt - 64
        }

        return if (intX < 10) {
            "0" + intX.toString() // 小于10前面补零
        } else {
            intX.toString()
        }
    }
}
