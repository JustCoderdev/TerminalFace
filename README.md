# Terminal Face

This clock face is available on Garming's app store ([here](https://apps.garmin.com/apps/1ed9f416-e52f-4002-91c2-c16953861f00?tid=0)) where it's available for the:
- Venu®
- vívoactive® HR 

## Description

The TerminalFace face has the style of a console that can show default information (such as: time, date, battery),
daily activity (like: step and floors made and goals), activity information (heartbeat) and plenty more to come!
If you leave the color they'll update based on: battery percentage (more than 40 green, less than 20 red else
orange-yellow), Connection status (green connected, red disconnected) and with the hearth rate (between 60 and 110
the color stay green, it turn red if it goes too high or too low)

In the setting you can customize:

- the console appereance: (Jc@watch:~ $ now) \
like:
  - show console style label ([TIME])
  - show console details (Jc@watch:~ $ now)
  - name of the user (Jc)
  - name of the device (watch)
  - command (now)
  - show the bluetooth status ([CONN] Disconnected)
  - show the current heart beat [WIP] (disabled)
  - set the text justification
  - color the text or left it white
  - set the hour format 12/24
  - set the day / month order

- the step and floors view options \
like:
  - Don't display
  - Display current
  - Display current and goal

NOTE:
- Garming is having problem with some boolean value, for now i can only mark them [UT] we can only hope they are going to resolve soon
- The timezone is there as a placeholder to avoid alignment issue
- The heart beat is disabled for now

## What’s New

### 0.5.3 | fixed alignment - 24.04.2022

Bug fixed:
- Alignment value now center himself on left alignment mode

New feature:
- Added the setting to change the hour format 12/24

Coming Soon:
- Timezone
- Custom font
- Heart beat displaying
- Heart beat limit changing if the activity has been detected

Known Issue:
- Timezone as placeholder for now
- Heart beat data not accessible
- Some setting (marked with [UT]) are unable to toggle
