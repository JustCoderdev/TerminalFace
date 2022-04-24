import Toybox.Application;
import Toybox.Graphics;
import Toybox.Time.Gregorian;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class TerminalFaceView extends WatchUi.WatchFace {

    var isSleeping = false;
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
        self.appSetting = appSetting;
        WatchFace.initialize();
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

        //* Data formatting
        var timeZone = ""; // " UTC" //! TO IMPLEMENT TIMEZONE
        var timeData = appSetting.get("dateFormatOption") == 0  //"02:15:55 MDT"; "2:15:55 PM MDT"
        ? Lang.format("$1$:$2$$3$ $4$$5$", time.hour < 13 ? [ time.hour, time.min.format("%02d"), isSleeping ? "" : ":" + time.sec.format("%02d"), "AM", timeZone ] : [ time.hour - 12, time.min.format("%02d"), isSleeping ? "" : ":" + time.sec.format("%02d"), "PM", timeZone ])
        : Lang.format("$1$:$2$$3$$4$", [time.hour < 10 ? "0" + time.hour : time.hour, time.min.format("%02d"), isSleeping ? "" : ":" + time.sec.format("%02d"), timeZone]);

        var det1 = appSetting.get("dateOrderOption") == 0 ? WatchUi.loadResource(monthArr[now.month - 1]) : now.day.toNumber();
        var det2 = appSetting.get("dateOrderOption") == 0 ? now.day.toNumber() : WatchUi.loadResource(monthArr[now.month - 1]);
        var dateData = Lang.format("$1$ $2$ $3$ $4$", [ WatchUi.loadResource(dayArr[now.day_of_week - 1]), det1, det2, now.year.toNumber() ]);

        var battData = "[";
        var battLvl = (stat.battery + 0.5).toNumber(); // da 00 a 100
        var alert = ["L", "O", "W", "B", "A", "T", "T"];
        var alertAlt = ["L", "O", "W", ".", "B", "A", "T", "T"];
        for (var i = 0; i < battLvl / 10; i++) { battData += "#"; } // [#.........] 10 %  -  [#.LOWBATT.] 10 % - [.LOW.BATT.] 9 %
        for (var i = 0; i < 10 - battLvl / 10; i++) { battData += battLvl != 100 ? battLvl <= 10 ? battLvl <= 9 ? i == 0 || i == 9 ? "." : alertAlt[i-1] : i == 0 || i >= 8 ? "." : alert[i-1] : "." : ""; }
        battData += "] " + battLvl + " %";

        var stepData = appSetting.get("stepViewOption") == 1
            ? info.steps + " " + WatchUi.loadResource(Rez.Strings.steps)
            : appSetting.get("stepViewOption") == 2
                ? info.steps + "/" + info.stepGoal + " " + WatchUi.loadResource(Rez.Strings.steps)
                : "";
    
        var flrsData = appSetting.get("flrsViewOption") == 1
            ? info.floorsClimbed + " " + WatchUi.loadResource(Rez.Strings.floors)
            : appSetting.get("flrsViewOption") == 2
                ? info.floorsClimbed + "/" + info.floorsClimbedGoal + " " + WatchUi.loadResource(Rez.Strings.floors)
                : "";

        //* Const
        var labRef = [
            "",
            View.findDrawableById("timeLn") as Text,
            View.findDrawableById("dateLn") as Text,
            View.findDrawableById("powLn") as Text,
            View.findDrawableById("connLn") as Text,
            View.findDrawableById("stepLn") as Text,
            View.findDrawableById("flrsLn") as Text,
            View.findDrawableById("bpmLn") as Text,
            View.findDrawableById("endLn") as Text,
            ""
        ];

        var lab = [
            "",
            "[" + WatchUi.loadResource(Rez.Strings.time) + "] ",
            "[" + WatchUi.loadResource(Rez.Strings.date) + "] ",
            "[" + WatchUi.loadResource(Rez.Strings.batt) + "] ",
            "[" + WatchUi.loadResource(Rez.Strings.conn) + "] ",
            "[" + WatchUi.loadResource(Rez.Strings.step) + "] ",
            "[" + WatchUi.loadResource(Rez.Strings.flrs) + "] ",
            "[" + WatchUi.loadResource(Rez.Strings.l_hr) + "] ",
            ""
        ];

        var dataRef = [
            View.findDrawableById("stLnData") as Text,
            View.findDrawableById("timeLnData") as Text,
            View.findDrawableById("dateLnData") as Text,
            View.findDrawableById("powLnData") as Text,
            View.findDrawableById("connLnData") as Text,
            View.findDrawableById("stepLnData") as Text,
            View.findDrawableById("flrsLnData") as Text,
            View.findDrawableById("bpmLnData") as Text,
            View.findDrawableById("endLnData") as Text
        ];

        var data = [
            appSetting.get("consoleUserName") + "@" + appSetting.get("consoleDeviceName") + ":~ $ " + appSetting.get("consoleCommand"),
            timeData,
            dateData,
            battData,
            sett.phoneConnected ? WatchUi.loadResource(Rez.Strings.connected) : WatchUi.loadResource(Rez.Strings.disconnected),
            stepData,
            flrsData,
            sensorsData.get("heartRate") + " bpm",
            appSetting.get("consoleUserName") + "@" + appSetting.get("consoleDeviceName") + ":~ $"
        ];

        var dataCol = [
            Graphics.COLOR_WHITE,
            Graphics.COLOR_GREEN,
            Graphics.COLOR_BLUE,
            battLvl > 40 ? Graphics.COLOR_GREEN : battLvl < 20 ? Graphics.COLOR_RED: Graphics.COLOR_YELLOW,   //battery
            sett.phoneConnected ? Graphics.COLOR_GREEN : Graphics.COLOR_RED,  //connection
            Graphics.COLOR_PURPLE,  
            Graphics.COLOR_YELLOW,
            sensorsData.get("heartRate") > 110 ? Graphics.COLOR_RED : sensorsData.get("heartRate") < 60 ? Graphics.COLOR_RED : Graphics.COLOR_GREEN,     //hb
            Graphics.COLOR_WHITE,
        ];

        //* Reference and Assigning
        var dt = appSetting.get("isConsoleDetailShown") ? 2 : 0;
        var sp = appSetting.get("stepViewOption") != 0 ? 1 : 0;
        var fs = appSetting.get("flrsViewOption") != 0 ? 1 : 0;
        var bt = appSetting.get("isBtShown") ? 1 : 0;
        var hr = appSetting.get("isHRShown") ? 1 : 0;
        var nValue = dt + 3 + bt + sp + fs + hr;

        //* SET PROPERTYES
        var cFont = Graphics.FONT_XTINY; //*UbuntuMono
        // var cFont = UbuntuMono;
        var charHeight = dc.getTextDimensions("@", cFont)[1];
        // var charWidth = dc.getTextWidthInPixels("@", cFont);
        var CIndex = 9;

        // var XspaceDate = charWidth * ( appSetting.get("isConsoleLabelShown") ? (lab[1].length() + data[1].length()) : data[1].length() ); //date = 7 + 14
        // var XspaceBatt = charWidth * ( appSetting.get("isConsoleLabelShown") ? (lab[2].length() + data[2].length()) : data[2].length() ); //batt = 7 + 12 + (1 o 2 o 3) + 2 = 22 - 24
        var XspaceDate = dc.getTextWidthInPixels(appSetting.get("isConsoleLabelShown") ? lab[1] + data[1] : data[1], cFont);    
        var XspaceBatt = dc.getTextWidthInPixels(appSetting.get("isConsoleLabelShown") ? lab[2] + data[2] : data[2], cFont);

        var XbiggestSpace = XspaceDate > XspaceBatt ? XspaceDate : XspaceBatt;
        var XleftResultSpace = (sett.screenWidth - XbiggestSpace) / 2 < 1 ? 0 : (sett.screenWidth - XbiggestSpace) / 2;

        var Yspacing = (sett.screenHeight - charHeight * nValue) / (nValue + 1);
        var yield = 0;

        for (var i = 0; i < CIndex; i++) {
            if (!appSetting.get("isConsoleDetailShown") && i == 0) { yield--;}
            else if (!appSetting.get("isBtShown") && i == 4) { yield--; }
            else if (!(appSetting.get("stepViewOption") != 0) && i == 5) { yield--; }
            else if (!(appSetting.get("flrsViewOption") != 0) && i == 6) { yield--; }
            else if (!appSetting.get("isHRShown") && i == 7) { yield--; }
            else {
                var XresultSpace = appSetting.get("isCentered")
                    ? (sett.screenWidth - dc.getTextWidthInPixels((appSetting.get("isConsoleLabelShown") ? lab[i] + data[i] : data[i] ), cFont)) / 2
                    : XleftResultSpace;
                var YresultSpace = Yspacing + (Yspacing + charHeight) * yield;

                //! SHOULD CHANGE FONT BUT NAH NOT NOW
                // batt  0% -> 49% = Ok (date is bigger) 
                // batt 50% -> 69% = Aa (battery is bigger but doesn't clip)
                // batt 70% -> ... = Not fine (x = 0 to avoid negative x)

                dataRef[i].setColor(appSetting.get("isColorated") ? dataCol[i] : Graphics.COLOR_WHITE);
                dataRef[i].setText(data[i]);
                dataRef[i].setFont(cFont);

                if ( i == 0 || i == CIndex - 1 ) {
                    dataRef[i].setLocation( 
                        XresultSpace,
                        YresultSpace
                    );

                } else {
                    if (appSetting.get("isConsoleLabelShown")) {
                        labRef[i].setText(lab[i]);
                        labRef[i].setFont(cFont);
                        labRef[i].setLocation(
                            XresultSpace,
                            YresultSpace
                        );

                        dataRef[i].setLocation( 
                            (XresultSpace + dc.getTextWidthInPixels(lab[i], cFont)),
                            YresultSpace
                        );

                    } else {
                        dataRef[i].setLocation( 
                            XresultSpace,
                            YresultSpace
                        );
                    }
                }
            }
            yield++;
        }

        //? Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    function out(output) {
        System.print(output);
        System.println(" ");
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