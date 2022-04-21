import Toybox.Application;
import Toybox.Graphics;
import Toybox.Time.Gregorian;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class TerminalFaceView extends WatchUi.WatchFace {

    // var UbuntuMono = null;
    var appSetting = null;
    var isSleeping = false;

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
        WatchUi.requestUpdate();
    }

    //? Update the view
    function onUpdate(dc as Dc) as Void {
        //* Lib
        var now = Gregorian.info(Time.today(), Time.FORMAT_SHORT);
        var sett = System.getDeviceSettings();
        var info = ActivityMonitor.getInfo();
        var stat = System.getSystemStats();
        var time = System.getClockTime();
        
        //* Data
        var consoleData = appSetting.get("consoleUserName") + "@" + appSetting.get("consoleDeviceName") + ":~ $ ";
        
        var timeZone = ""; // UTC //! TO IMPLEMENT TIMEZONE
        var timeData = sett.is24Hour    //"02:15:55 MDT"; "2:15:55 PM MDT"
        ? Lang.format("$1$:$2$$3$     $4$", [time.hour < 10 ? "0" + time.hour : time.hour, time.min.format("%02d"), isSleeping ? "   " : ":" + time.sec.format("%02d"), timeZone])
        : Lang.format("$1$:$2$$3$ $4$ $5$", time.hour < 13
            ? [ time.hour, time.min.format("%02d"), isSleeping ? "   " : ":" + time.sec.format("%02d"), "AM", timeZone ]
            : [ time.hour - 12, time.min.format("%02d"), isSleeping ? "   " : ":" + time.sec.format("%02d"), "PM", timeZone]
        );
        
        var dateData = Lang.format("$1$ $2$ $3$ $4$", [
            WatchUi.loadResource(dayArr[now.day_of_week - 1]),
            now.day.toNumber(),
            WatchUi.loadResource(monthArr[now.month - 1]),
            now.year.toNumber(),
        ]);

        var battData = "[";
        var battLvl = (stat.battery + 0.5).toNumber(); // da 0 a 10
        for (var i = 0; i < battLvl / 10; i++) { battData += "#"; }
        for (var i = 0; i < 10 - battLvl / 10; i++) { battData += battLvl / 10 != 10 ? "." : ""; }
        battData += "] " + battLvl + " %";

        var connData = sett.phoneConnected ? WatchUi.loadResource(Rez.Strings.connected) : WatchUi.loadResource(Rez.Strings.disconnected);
        var stepData = "";
        var flrsData = "";
        var l_hrData = sensorsData.get("heartRate") + " bpm";

        //* Reference and Assigning
        var dt = appSetting.get("isConsoleDetailShown") ? 2 : 0;
        var sp = appSetting.get("stepViewOption") != 0 ? 1 : 0;
        var fs = appSetting.get("flrsViewOption") != 0 ? 1 : 0;
        var bt = appSetting.get("isBtShown") ? 1 : 0;
        var hr = appSetting.get("isHRShown") ? 1 : 0;
        var nValue = dt + 3 + bt + sp + fs + hr;

        var labData = new[nValue];
        var labAll  = new[nValue];
        var CIndex = 0;

        if (appSetting.get("isConsoleDetailShown")) {
            labAll[CIndex] = View.findDrawableById("stLn") as Text;
            labData[CIndex] = consoleData + appSetting.get("consoleCommand");
            CIndex++;
        }
        
        labAll[CIndex] = View.findDrawableById("timeLn") as Text;
        labData[CIndex] = appSetting.get("isConsoleLabelShown") ? "[" + WatchUi.loadResource(Rez.Strings.time) + "] " + timeData : timeData;
        CIndex++;

        labAll[CIndex] = View.findDrawableById("dateLn") as Text;
        labData[CIndex] = appSetting.get("isConsoleLabelShown") ? "[" + WatchUi.loadResource(Rez.Strings.date) + "] " + dateData : dateData;
        CIndex++;

        labAll[CIndex] = View.findDrawableById("powLn") as Text;
        labData[CIndex] = appSetting.get("isConsoleLabelShown") ? "[" + WatchUi.loadResource(Rez.Strings.batt) + "] " + battData : battData;
        CIndex++;

        if (appSetting.get("isBtShown")) {
            labAll[CIndex] = View.findDrawableById("connLn") as Text;
            labData[CIndex] = appSetting.get("isConsoleLabelShown") ? "[" + WatchUi.loadResource(Rez.Strings.conn) + "] " + connData : connData;
            CIndex++;
        }
        
        if (appSetting.get("stepViewOption") != 0) {
            labAll[CIndex] = View.findDrawableById("stepLn") as Text;

            if (appSetting.get("stepViewOption") == 1) {
                stepData = info.steps + " " + WatchUi.loadResource(Rez.Strings.steps);
            } else if (appSetting.get("stepViewOption") == 2) {
                stepData = info.steps + "/" + info.stepGoal + " " + WatchUi.loadResource(Rez.Strings.steps);
            }

            labData[CIndex] = appSetting.get("isConsoleLabelShown") ? "[" + WatchUi.loadResource(Rez.Strings.step) + "] " + stepData : stepData;
            CIndex++;
        }
        
        if (appSetting.get("flrsViewOption") != 0) {
            labAll[CIndex] = View.findDrawableById("flrsLn") as Text;

            if (appSetting.get("flrsViewOption") == 1) {
                flrsData = info.floorsClimbed + " " + WatchUi.loadResource(Rez.Strings.floors);
            } else if (appSetting.get("flrsViewOption") == 2) {
                flrsData = info.floorsClimbed + "/" + info.floorsClimbedGoal + " " + WatchUi.loadResource(Rez.Strings.floors);
            }

            labData[CIndex] = appSetting.get("isConsoleLabelShown") ? "[" + WatchUi.loadResource(Rez.Strings.flrs) + "] " + flrsData : flrsData;
            CIndex++;
        }

        if (appSetting.get("isHRShown")) {
            labAll[CIndex] = View.findDrawableById("bpmLn") as Text;  
            labData[CIndex] = appSetting.get("isConsoleLabelShown") ? "[" + WatchUi.loadResource(Rez.Strings.l_hr) + "] " + l_hrData : l_hrData;
            CIndex++;
        }

        if (appSetting.get("isConsoleDetailShown")) {
            labAll[CIndex] = View.findDrawableById("endLn") as Text;
            labData[CIndex] = consoleData;
            CIndex++;
        }

        //* SET PROPERTYES
        for (var i = 0; i < CIndex; i++) {
            var XspaceA = dc.getTextWidthInPixels(labData[2], Graphics.FONT_XTINY);   //date = 7 + 15
            var XspaceB = dc.getTextWidthInPixels(labData[3], Graphics.FONT_XTINY);   //batt = 7 + 13 + (1 o 2 o 3) + 2 = 23 - 25
            var XbiggestSpace = XspaceA > XspaceB ? XspaceA : XspaceB;
            var XresultSpace = sett.screenWidth - XbiggestSpace < 0 ? 0 : (sett.screenWidth - XbiggestSpace) / 2;

            var textHeight = dc.getTextDimensions("[", Graphics.FONT_XTINY)[1];
            var Yspacing = (sett.screenHeight - textHeight * CIndex) / (CIndex + 1);
            var YresultSpace = Yspacing + (Yspacing + textHeight) * (i);

            //! SHOULD CHANGE FONT BUT NAH NOT NOW
            // batt  0% -> 49% = Ok (date is bigger) 
            // batt 50% -> 69% = Aa (battery is bigger but doesn't clip)
            // batt 70% -> ... = Not fine (x = 0 to avoid negative x)

            labAll[i].setFont(Graphics.FONT_XTINY); //*UbuntuMono
            labAll[i].setText(labData[i]);
            labAll[i].setLocation( 
                XresultSpace,
                YresultSpace
            );

            // labAll[i].setJustification(Graphics.TEXT_JUSTIFY_LEFT);
            // labAll[i].setColor(Graphics.COLOR_GREEN);
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
        isSleeping = false;
    }

    //? Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
        isSleeping = true;

    }
}