

*==============================================================================*
*Table S2. AQI, Plants' emissions and meteorology
*==============================================================================*

clear all
use "data/data3.dta", replace

reghdfe AQI      PM_A SO2_A NOx_A temp humid ws rain press  if o_up_level==. & y_up_level==. & b_up_level==. , absorb(site year month weekday) vce(robust)
outreg2 using "table_s2.doc",  ctitle(`i')   nocons  bdec(3) sdec(2)   `replace'
		local replace append
reghdfe AQI_l24  PM_A SO2_A NOx_A temp humid ws rain press if o_up_level==. & y_up_level==. & b_up_level==. ,absorb(site year month weekday) vce(robust)
outreg2 using "table_s2.doc",  ctitle(`i')   nocons  bdec(3) sdec(2)   `replace'
		local replace append
		
reghdfe AQI      PM_A SO2_A NOx_A temp humid ws rain press if AQI<=150 & o_up_level==. & y_up_level==. & b_up_level==.  ,absorb(site year month weekday) vce(robust)
outreg2 using "table_s2.doc",  ctitle(`i')  nocons  bdec(3) sdec(2)   `replace'
		local replace append
reghdfe AQI_l24  PM_A SO2_A NOx_A temp humid ws rain press if AQI<=150 & o_up_level==. & y_up_level==. & b_up_level==.  ,absorb(site year month weekday) vce(robust)
outreg2 using "table_s2.doc",  ctitle(`i')   nocons  bdec(3) sdec(2)   `replace'
		local replace append
reghdfe AQI      PM_A SO2_A NOx_A temp humid ws rain press if AQI>150 & o_up_level==. & y_up_level==. & b_up_level==.  ,absorb(site year month weekday) vce(robust)
outreg2 using "table_s2.doc",  ctitle(`i')   nocons  bdec(3) sdec(2)   `replace'
		local replace append
reghdfe AQI_l24  PM_A SO2_A NOx_A temp humid ws rain press if AQI>150 & o_up_level==. & y_up_level==. & b_up_level==. ,absorb(site year month weekday) vce(robust)
outreg2 using "table_s2.doc",  ctitle(`i')   nocons  bdec(3) sdec(2)   `replace'
		local replace append

*==============================================================================*
*Table S5. DiD estimates for plants' emission at different level alerts
*==============================================================================*

clear all  

global name  o_up y_up  
global  control temperature air_pressure wind_speed visibility_distance AQI_l24
global y  lnPM_A lnSO2_A lnNOx_A lnflow
local replace replace
foreach a in $name{
	use "data/data2.dta", replace
	keep if `a'_level!=.
	
	gen did_id = 0
	replace did_id = 1 if `a'_id > 0
	
	gen did = did_id*if_alert
	
	foreach i in $y{
		
		reghdfe `i' did $control  ,absorb(enterprise year month weekday) vce(cluster enterprise)  resid(re`i')
		outreg2 using "DID-`a'.doc",  dec(3) append ctitle(`i') addtext(Plant FE, Y, Year FE, Y, Weather Controls, Y)
		local replace append
	}
}



