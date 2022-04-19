import Toybox.Application;
import Toybox.Graphics;
import Toybox.Time.Gregorian;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class TerminalFaceView extends WatchUi.WatchFace {

    // var UbuntuMono = null;
    var appSetting = null;

    var dayArr = [
            Rez.Strings.sun,
            Rez.Strings.mon,
            Rez.Strings.tue,
            Rez.Strings.wed,
            Rez.Strings.thu,
            Rez.Strings.fri,
            Rez.Strings.sat
    ];
    
    var monthArr = [
        Rez.Strings.jan,
        Rez.Strings.feb,
        Rez.Strings.mar,
        Rez.Strings.apr,
        Rez.Strings.may,
        Rez.Strings.jun,
        Rez.Strings.jul,
        Rez.Strings.aug,
        Rez.Strings.sep,
        Rez.Strings.oct,
        Rez.Strings.nov,
        Rez.Strings.dec
    ];

    var sensorsData = {
        "heartRate" => 0,
    };

    function initialize(appSetting) {
        WatchFace.initialize();
        self.appSetting = appSetting;
    }

    //? Load your resources here
    function onLayout(dc as Dc) as Void {
        // UbuntuMono = WatchUi.loadResource(Rez.Fonts.UbuntuMono);
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    //? Called when this View is brought to the foreground. Restore
    //? the state of this View and prepare it to be shown. This includes
    //? loading resources into memory.
    function onShow() as Void {
    }

    //? Update the view
    function onUpdate(dc as Dc) as Void {
        //* Lib
        var now = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var sett = System.getDeviceSettings();
        var info = ActivityMonitor.getInfo();
        var stat = System.getSystemStats();
        var time = System.getClockTime();
        
        //* Data
        var consoleData = appSetting.get("consoleUserName") + "@" + appSetting.get("consoleDeviceName") + ":~ $ ";
        
        //! TO IMPLEMENT TIMEZONE
        var timeData = ""; //"02:15:55 MDT"; "2:15:55 PM MDT"
        var timeZone = ""; // UTC
        if (System.getDeviceSettings().is24Hour) {
            timeData = Lang.format("$1$:$2$:$3$ $4$", [time.hour < 12 ? "0" + time.hour : time.hour, time.min.format("%02d"), time.sec.format("%02d"), timeZone]);
        } else {
            timeData = Lang.format("$1$:$2$:$3$ $4$ $5$", time.hour < 13
            ? [ time.hour, time.min.format("%02d"), time.sec.format("%02d"), "AM", timeZone ]
            : [ time.hour - 12, time.min.format("%02d"), time.sec.format("%02d"), "PM", timeZone]
            );
        }
        
        var dateData = Lang.format("$1$ $2$ $3$ $4$", [
            WatchUi.loadResource(dayArr[now.day_of_week - 1]),
            WatchUi.loadResource(monthArr[now.month - 1]),
            now.day.toNumber(),
            now.year.toNumber(),
        ]);

        var battData = "[";
        for (var i = 0; i < stat.battery.toNumber()/10; i++) { battData += "#"; }
        for (var i = 0; i < 10-stat.battery.toNumber()/10; i++) { battData += "."; }
        battData += "] " + stat.battery.toNumber() + " %";

        var connData = sett.phoneConnected ? WatchUi.loadResource(Rez.Strings.connected) : WatchUi.loadResource(Rez.Strings.disconnected);
        var stepData = "";
        var flrsData = "";
        var l_hrData = sensorsData.get("heartRate") + " bpm";

        //* Reference and Assigning
        var labData = new[9];
        var labAll  = new[9];
        var CIndex = 0;

        labAll[CIndex] = View.findDrawableById("stLn") as Text;  
        labData[CIndex] = consoleData + appSetting.get("consoleCommand");
        CIndex++;
        
        labAll[CIndex] = View.findDrawableById("timeLn") as Text;
        labData[CIndex] = "[" + WatchUi.loadResource(Rez.Strings.time) + "] " + timeData;
        CIndex++;

        labAll[CIndex] = View.findDrawableById("dateLn") as Text;
        labData[CIndex] = "[" + WatchUi.loadResource(Rez.Strings.date) + "] " + dateData;
        CIndex++;

        labAll[CIndex] = View.findDrawableById("powLn") as Text;
        labData[CIndex] = "[" + WatchUi.loadResource(Rez.Strings.batt) + "] " + battData;
        CIndex++;

        if (appSetting.get("isBtShown")) {
            labAll[CIndex] = View.findDrawableById("connLn") as Text;
            labData[CIndex] = "[" + WatchUi.loadResource(Rez.Strings.conn) + "] " + connData;
            CIndex++;
        }
        
        if (appSetting.get("stepViewOption") != 0) {
            labAll[CIndex] = View.findDrawableById("stepLn") as Text;

            if (appSetting.get("stepViewOption") == 1) {
                stepData = info.steps + " " + WatchUi.loadResource(Rez.Strings.steps);
            } else if (appSetting.get("stepViewOption") == 2) {
                stepData = info.steps + "/" + info.stepGoal + " " + WatchUi.loadResource(Rez.Strings.steps);
            }

            labData[CIndex] = "[" + WatchUi.loadResource(Rez.Strings.step) + "] " + stepData;
            CIndex++;
        }
        
        if (appSetting.get("flrsViewOption") != 0) {
            labAll[CIndex] = View.findDrawableById("flrsLn") as Text;

            if (appSetting.get("flrsViewOption") == 1) {
                flrsData = info.floorsClimbed + " " + WatchUi.loadResource(Rez.Strings.floors);
            } else if (appSetting.get("flrsViewOption") == 2) {
                flrsData = info.floorsClimbed + "/" + info.floorsClimbedGoal + " " + WatchUi.loadResource(Rez.Strings.floors);
            }

            labData[CIndex] = "[" + WatchUi.loadResource(Rez.Strings.flrs) + "] " + flrsData;
            CIndex++;
        }

        labAll[CIndex] = View.findDrawableById("bpmLn") as Text;  
        labData[CIndex] = "[" + WatchUi.loadResource(Rez.Strings.l_hr) + "] " + l_hrData;
        CIndex++;

        labAll[CIndex] = View.findDrawableById("endLn") as Text;
        labData[CIndex] = consoleData;
        CIndex++;

        //* SET PROPERTYES
        for (var i = 0; i < CIndex; i++) {
            // var height = sett.screenHeight / (CIndex + 3) * i;
            // var padding_1p = sett.screenWidth / 100;
    		// var totalWidth = dc.getTextWidthInPixels(labData[i], Graphics.FONT_XTINY);
	    	// var x = halfDCWidth - (totalWidth / 2);

            // labAll[i].setFont(UbuntuMono);

            labAll[i].setFont(Graphics.FONT_XTINY);
            labAll[i].setText(labData[i]);
            labAll[i].setLocation(x, y);

            // labAll[i].setJustification(Graphics.TEXT_JUSTIFY_LEFT);
            // labAll[i].setColor(getApp().getProperty("ForegroundColor") as Number);
        }

        //? Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    //? Called when this View is removed from the screen. Save the
    //? state of this View here. This includes freeing resources from
    //? memory.
    function onHide() as Void {
    }

    //? The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    //? Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
