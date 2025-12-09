
cd result/

*==============================================================================*
*Table 1 Summary Statistics
*==============================================================================*

use "data/data1.dta", replace

gen alert_01 = 1 
replace alert_01 = 0 if alert ==1 

sum2docx enterprise PM_A SO2_A NOx_A PM_C SO2_C NOx_C flow AQI temperature using summary_statistics-2.docx, ///
  replace stats(N mean(%9.2f) sd(%9.2f) min(%9.2f) max(%9.2f)  ) 
  


*==============================================================================*
*Table 2 RD estimates for plants' emission at single-level AQAs declare and terminate
*==============================================================================*
clear all  

global name r_up o_up y_up b_up r_down o_down y_down b_down 
global  control temperature AQI_l24
global y  lnPM_A lnSO2_A lnNOx_A 
local replace replace
foreach a in $name{
	use "data/data1.dta", replace
	keep if `a'_level!=.		
	foreach i in $y{
		reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster site)  resid(re`i')
		rdrobust re`i' `a'_id , c(0) p(2) q(3)  kernel(triangular)  masspoints(off)
		outreg2 using "RD-`a'.doc",  dec(3) append ctitle(`i') addtext(Plant FE, Y, Year FE, Y, Weather Controls, Y) addstat(Bandwidth (Hours), floor(e(h_l)))
		local replace append
	}
}

