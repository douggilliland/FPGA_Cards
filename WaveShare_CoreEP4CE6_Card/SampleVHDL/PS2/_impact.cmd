setPreference -pref AutoSignature:FALSE
setPreference -pref KeepSVF:FALSE
setPreference -pref ConcurrentMode:FALSE
setPreference -pref UseHighz:FALSE
setPreference -pref svfUseTime:FALSE
setMode -bs
setMode -bs
setCable -port auto
Identify
identifyMPM
assignFile -p 2 -file "F:/FPGA/ps2_lcd_1602/ps2_lcd1602_1.bit"
Program -p 2 -defaultVersion 0 
