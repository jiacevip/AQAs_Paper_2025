
*==============================================================================*
******Figure S5-S7   B Empirical results  **************************************
*==============================================================================*

**Figure S5 RD estimates for plants' emission at three-level AQAs
clear all  

global name b_y_o_up y_o_r_up 
global  control temperature AQI_l24
global y  lnPM_A lnSO2_A lnNOx_A 
local replace replace
foreach a in $name{
	use "data/data1.dta", replace

	keep if `a'_level==0|`a'_level==1

	foreach i in $y{
		reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster site)  resid(re`i')
		rdrobust re`i' `a'_id , c(0) p(2) q(3)  kernel(triangular)  masspoints(off)
		estimates store  re_`a'_`i'_1
		
	}
	
	use "data/data1.dta", replace
	keep  if `a'_level==2|`a'_level==3
	replace `a'_level=0 if `a'_level==2
	replace `a'_level=1 if `a'_level==3

	foreach i in $y{
		reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster site)  resid(re`i')
		rdrobust re`i' `a'_id , c(0) p(2) q(3)  kernel(triangular)  masspoints(off)
		estimates store  re_`a'_`i'_2
		
	}
	
	use "data/data1.dta", replace
	keep   if `a'_level==4|`a'_level==5 
	replace `a'_level=0 if `a'_level==4
	replace `a'_level=1 if `a'_level==5

	foreach i in $y{
		reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster site)  resid(re`i')
		rdrobust re`i' `a'_id , c(0) p(2) q(3)  kernel(triangular)  masspoints(off)
		estimates store  re_`a'_`i'_3
		
	}
	
}

**Figure S5a:

coefplot ///
  (re_b_y_o_up_lnPM_A_1,  label("First Stage") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) /// 
  (re_b_y_o_up_lnPM_A_2,  label("Second Stage") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) /// 
  (re_b_y_o_up_lnPM_A_3,  label("Third Stage") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) /// 
  (re_y_o_r_up_lnPM_A_1,  label("First Stage") offset(-0.25)  pstyle(p1) msymbol(o) msize(*1.4)) ///
  (re_y_o_r_up_lnPM_A_2,  label("Second Stage") offset(-1)  pstyle(p9) msymbol(s) msize(*1.4)) ///
  (re_y_o_r_up_lnPM_A_3,  label("Third Stage") offset(-1.75)  pstyle(p12) msymbol(d) msize(*1.4)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
  xlabel(1 "b_y_o_up" 1 "b_y_o_up" 1 "b_y_o_up" 4 "y_o_r_up"  4 "y_o_r_up"  4 "y_o_r_up" ) ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(8.5, lwidth(vthin) lpattern(shortdash) lcolor(teal)) ///
  ytitle("log(PM) estimates", size(medium)) ///
  xtitle("Alert type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "First Stage" 4 "Second Stage" 6 "Third Stage") row(1)) ///
  name(graphPM, replace)
  graph export "picture/three_level_alert-PM.png", replace as(png) name("graphPM") width(1600) height(1200)

**Figure S5b:  
  
coefplot ///
  (re_b_y_o_up_lnSO2_A_1,  label("First Stage") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_b_y_o_up_lnSO2_A_2,  label("Second Stage") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_b_y_o_up_lnSO2_A_3,  label("Third Stage") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_y_o_r_up_lnSO2_A_1,  label("First Stage") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_y_o_r_up_lnSO2_A_2,  label("Second Stage") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_y_o_r_up_lnSO2_A_3,  label("Third Stage") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
  xlabel(1 "b_y_o_up" 1 "b_y_o_up" 1 "b_y_o_up" 4 "y_o_r_up"  4 "y_o_r_up"  4 "y_o_r_up" ) ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(8.5, lwidth(vthin) lpattern(shortdash) lcolor(teal)) ///
  ytitle("log(SO{sub:2}) estimates", size(medium)) ///
  xtitle("Alert type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "First Stage" 4 "Second Stage" 6 "Third Stage") row(1)) ///
  name(graphSO2, replace)
  graph export "picture/three_level_alert-SO2.png", replace as(png) name("graphSO2") width(1600) height(1200)
  
  
**Figure S5c:  

coefplot ///
  (re_b_y_o_up_lnNOx_A_1,  label("First Stage") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) /// 
  (re_b_y_o_up_lnNOx_A_2,  label("Second Stage") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_b_y_o_up_lnNOx_A_3,  label("Third Stage") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_y_o_r_up_lnNOx_A_1,  label("First Stage") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_y_o_r_up_lnNOx_A_2,  label("Second Stage") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_y_o_r_up_lnNOx_A_3,  label("Third Stage") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
  xlabel(1 "b_y_o_up" 1 "b_y_o_up" 1 "b_y_o_up" 4 "y_o_r_up"  4 "y_o_r_up"  4 "y_o_r_up" ) ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(8.5, lwidth(vthin) lpattern(shortdash) lcolor(teal)) ///
  ytitle("log(NOx) estimates", size(medium)) ///
  xtitle("Alert type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "First Stage" 4 "Second Stage" 6 "Third Stage") row(1)) ///
  name(graphNOx, replace)
  graph export "picture/three_level_alert-NOx.png", replace as(png) name("graphNOx") width(1600) height(1200)

  
**Figure S6 RD estimates for plants' emission at four-level AQAs
clear all  

global name b_y_o_r_up
global  control temperature AQI_l24
global y  lnPM_A lnSO2_A lnNOx_A 
local replace replace
foreach a in $name{
	use "data/data1.dta", replace
	keep if `a'_level==0|`a'_level==1
	foreach i in $y{
		reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster site)  resid(re`i')
		rdrobust re`i' `a'_id , c(0) p(2) q(3)  kernel(triangular)  masspoints(off)
		estimates store  re_`a'_`i'_1
		
	}
	
	use "data/data1.dta", replace
	keep  if `a'_level==2|`a'_level==3
	replace `a'_level=0 if `a'_level==2
	replace `a'_level=1 if `a'_level==3

	foreach i in $y{
		reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster site)  resid(re`i')
		rdrobust re`i' `a'_id , c(0) p(2) q(3)  kernel(triangular)  masspoints(off)
		estimates store  re_`a'_`i'_2
		
	}
	
	use "data/data1.dta", replace
	keep   if `a'_level==4|`a'_level==5 
	replace `a'_level=0 if `a'_level==4
	replace `a'_level=1 if `a'_level==5

	foreach i in $y{
		reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster site)  resid(re`i')
		rdrobust re`i' `a'_id , c(0) p(2) q(3)  kernel(triangular)  masspoints(off)
		estimates store  re_`a'_`i'_3
		
	}
	
	use "data/data1.dta", replace
	keep   if `a'_level==6|`a'_level==7 
	replace `a'_level=0 if `a'_level==6
	replace `a'_level=1 if `a'_level==7

	foreach i in $y{
		reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster site)  resid(re`i')
		rdrobust re`i' `a'_id , c(0) p(2) q(3)  kernel(triangular)  masspoints(off)
		estimates store  re_`a'_`i'_4
		
	}
	
	
}


coefplot ///
  (re_b_y_o_r_up_lnPM_A_1,  label("First Stage") offset(-0.05)  pstyle(p1)  msymbol(o)  msize(*1.4)) /// 
  (re_b_y_o_r_up_lnPM_A_2,  label("Second Stage") offset(-1.25)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_b_y_o_r_up_lnPM_A_3,  label("Third Stage") offset(-1.85)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_b_y_o_r_up_lnPM_A_4,  label("Forth Stage") offset(-2.65)  pstyle(p3) msymbol(t)  msize(*1.4)) ///
  (re_b_y_o_r_up_lnSO2_A_1,  label("First Stage") offset(-0.05)  pstyle(p1) msymbol(o)  msize(*1.4)) /// 
  (re_b_y_o_r_up_lnSO2_A_2,  label("Second Stage") offset(-1.25)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_b_y_o_r_up_lnSO2_A_3,  label("Third Stage") offset(-1.85)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_b_y_o_r_up_lnSO2_A_4,  label("Forth Stage") offset(-2.65)  pstyle(p3) msymbol(t)  msize(*1.4)) ///
  (re_b_y_o_r_up_lnNOx_A_1,  label("First Stage") offset(-0.05)  pstyle(p1) msymbol(o)  msize(*1.4)) /// 
  (re_b_y_o_r_up_lnNOx_A_2,  label("Second Stage") offset(-1.25)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_b_y_o_r_up_lnNOx_A_3,  label("Third Stage") offset(-1.85)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_b_y_o_r_up_lnNOx_A_4,  label("Forth Stage") offset(-2.65)  pstyle(p3) msymbol(t)  msize(*1.4)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
  xlabel(1 "PM" 1 "PM" 1 "PM" 1 "PM"  5 "SO{sub:2}"  5 "SO{sub:2}" ///
         5 "SO{sub:2}" 5 "SO{sub:2}" 9 "NOx" 9 "NOx" 9 "NOx" 9 "NOx" ) ///
  yline(0, lp(dash) lc(black*0.3)) ///
  ytitle("log(Pollutants) estimates", size(medium)) ///
  xtitle("Pollutants", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "First Stage" 4 "Second Stage" 6 "Third Stage" 8 "Forth Stage") row(1)) ///
  name(graphPM, replace)
  graph export "picture/four_level_alert.png", replace as(png) name("graphPM") width(1600) height(1200)

 
**Figure S7 Statistics on the duration of different phases of two-level AQAs
**Figure S7a:  
  
use "data/data4.dta", replace

keep if 是否单级预警 == 1

hist 单级时长, xtitle("single-level alert time")
graph export "/picture/figure_s7a.png", replace as(png)  width(1800) height(1200)

**Figure S7b:  

use "data/data4.dta", replace

keep if 是否多级预警 != .

hist 多级别时长 if 是否多级预警 == 1 , xtitle("Dynamic adjustments alert first stage time")
graph export "picture/figures7a.png", replace as(png)  width(1800) height(1200)


hist 多级别时长 if 是否多级预警 == 2  , xtitle("Dynamic adjustments alert second stage time")
graph export "picture/figures7b.png", replace as(png)  width(1800) height(1200)


*==============================================================================*
*Figure S10-S32 C Robustness check and heterogeneous analysis  *****************
*==============================================================================*

**Figure S10 RD estimates for plants' emission at AQAs declare and terminate time at 0.5 times optimal bandwidth
clear all  


global name  o_up y_up b_up  o_down y_down b_down 
global  control temperature AQI_l24
global y  lnPM_A lnSO2_A lnNOx_A 
local replace replace
foreach a in $name{
	use "data/data1.dta", replace
	keep if `a'_level!=.		
	foreach i in $y{
		reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster site)  resid(re`i')
		rdrobust re`i' `a'_id , c(0) p(2) q(3)  kernel(triangular)  
		local h = e(h_l)   //
		rdrobust re`i' `a'_id , c(0) p(2) q(3) h(`h'*0.5) kernel(triangular)   //
		estimates store  re_`a'_`i'
	}
}


coefplot ///
  (re_o_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_o_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_o_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_y_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_y_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_y_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_b_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_b_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_b_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_o_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_o_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_o_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_y_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_y_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_y_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_b_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_b_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_b_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
  xlabel(1 "o_declare"  1 "o_declare"  1 "o_declare" ///
         4 "y_declare" 4 "y_declare" 4 "y_declare"  ///
		 7 "b_declare"  7 "b_declare"  7 "b_declare" ///
		 10 "o_terminate"  10 "o_terminate"  10"o_terminate" ///
		 13 "y_terminate" 13 "y_terminate" 13 "y_terminate"  ///
		 16 "b_terminate"  16 "b_terminate"  16 "b_terminate" , angle(-30)) ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(8.5, lwidth(vthin) lpattern(shortdash) lcolor(teal)) ///
  ytitle("log(Pollutant) estimates", size(medium)) ///
  xtitle("Type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "PM" 4 "SO{sub:2}" 6 "NOx") row(1)) ///
  name(graphPM, replace)
  graph export "picture/Robustness_0.5X_optimal_bandwidth.png", replace as(png) name("graphPM") width(1600) height(1200)
  

**Figure S11 RD estimates for plants' emission at AQAs declare and terminate time at 2 times optimal bandwidth

clear all  


global name  o_up y_up b_up  o_down y_down b_down 
global  control temperature AQI_l24
global y  lnPM_A lnSO2_A lnNOx_A 
local replace replace
foreach a in $name{
	use "data/data1.dta", replace
	keep if `a'_level!=.		
	foreach i in $y{
		reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster site)  resid(re`i')
		rdrobust re`i' `a'_id , c(0) p(2) q(3)  kernel(triangular)  masspoints(off)
		local h = e(h_l)   //
		rdrobust re`i' `a'_id , c(0) p(2) q(3) h(`h'*2) kernel(triangular)  masspoints(off)  //
		estimates store  re_`a'_`i'
	}
}



coefplot ///
  (re_o_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_o_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_o_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_y_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_y_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_y_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_b_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_b_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_b_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_o_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_o_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_o_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_y_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_y_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_y_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_b_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_b_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_b_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
  xlabel(1 "o_declare"  1 "o_declare"  1 "o_declare" ///
         4 "y_declare" 4 "y_declare" 4 "y_declare"  ///
		 7 "b_declare"  7 "b_declare"  7 "b_declare" ///
		 10 "o_terminate"  10 "o_terminate"  10"o_terminate" ///
		 13 "y_terminate" 13 "y_terminate" 13 "y_terminate"  ///
		 16 "b_terminate"  16 "b_terminate"  16 "b_terminate" , angle(-30)) ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(8.5, lwidth(vthin) lpattern(shortdash) lcolor(teal)) ///
  ytitle("log(Pollutant) estimates", size(medium)) ///
  xtitle("Type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "PM" 4 "SO{sub:2}" 6 "NOx") row(1)) ///
  name(graphPM, replace)
  graph export "picture/Robustness_2X_optimal_bandwidth.png", replace as(png) name("graphPM") width(1600) height(1200)
  
 

**Figure S12 RDiT estimates for plant emission at AQAs activate and terminate time at different bandwidth
	

clear all  

global name  o_up y_up b_up  o_down y_down b_down 
global  control temperature air_pressure wind_speed visibility_distance AQI_l24
global y  lnPM_A lnSO2_A lnNOx_A 
global window_ranges 24 48 72 96
local replace replace

foreach window in $window_ranges {	
	
	foreach a in $name{
		use "data/data1.dta", replace
		keep if `a'_level!=.		
		foreach i in $y{	
			reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster enterprise)  resid(re`i')
			rdrobust re`i' `a'_id , c(0) p(2) q(3) h(`window')  kernel(triangular)  masspoints(off)
			estimates store  re_`a'_`i'
		}
	}



coefplot ///
  (re_o_up_lnPM_A,  label("PM") offset(-0.25) msymbol(o)  pstyle(p1)  msize(*1.6)) ///
  (re_o_up_lnSO2_A,  label("SO2") offset(-1) msymbol(s) pstyle(p9)  msize(*1.6)) ///
  (re_o_up_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d) pstyle(p12)  msize(*1.6)) ///
  (re_y_up_lnPM_A,  label("PM") offset(-0.25) msymbol(o)  pstyle(p1)  msize(*1.6)) ///
  (re_y_up_lnSO2_A,  label("SO2") offset(-1) msymbol(s) pstyle(p9)  msize(*1.6)) ///
  (re_y_up_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d) pstyle(p12)  msize(*1.6)) ///
  (re_b_up_lnPM_A,  label("PM") offset(-0.25) msymbol(o)  pstyle(p1)  msize(*1.6)) ///
  (re_b_up_lnSO2_A,  label("SO2") offset(-1) msymbol(s) pstyle(p9)  msize(*1.6)) ///
  (re_b_up_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d) pstyle(p12)  msize(*1.6)) ///
  (re_o_down_lnPM_A,  label("PM") offset(-0.25) msymbol(o)  pstyle(p1)  msize(*1.6)) ///
  (re_o_down_lnSO2_A,  label("SO2") offset(-1)  msymbol(s) pstyle(p9)  msize(*1.6)) ///
  (re_o_down_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d) pstyle(p12)  msize(*1.6)) ///
  (re_y_down_lnPM_A,  label("PM") offset(-0.25) msymbol(o)  pstyle(p1)  msize(*1.6)) ///
  (re_y_down_lnSO2_A,  label("SO2") offset(-1) msymbol(s) pstyle(p9)  msize(*1.6)) ///
  (re_y_down_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d) pstyle(p12)  msize(*1.6)) ///
  (re_b_down_lnPM_A,  label("PM") offset(-0.25) msymbol(o)   pstyle(p1)  msize(*1.6)) ///
  (re_b_down_lnSO2_A,  label("SO2") offset(-1) msymbol(s) pstyle(p9)  msize(*1.6)) ///
  (re_b_down_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d) pstyle(p12)  msize(*1.6)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
  xlabel(1 "o_activate"  1 "o_activate"  1 "o_activate" 4 "y_activate" 4 "y_activate" 4 "y_activate" ///
	     7 "b_activate"  7 "b_activate"  7 "b_activate" 10 "o_terminate"  10 "o_terminate"  10"o_terminate" ///
		 13 "y_terminate" 13 "y_terminate" 13 "y_terminate" ///
		 16 "b_terminate"  16 "b_terminate"  16 "b_terminate" , angle(-30)) ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(8.5, lwidth(vthin) lpattern(shortdash) lcolor(teal)) ///
  ytitle("log(Pollutant) estimates", size(medium)) ///
  xtitle("Type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "PM" 4 "SO{sub:2}" 6 "NOx") row(1)) ///
  name(graphPM, replace)
  graph export "picture/single-womdow-`window'.png", replace as(png) name("graphPM") width(1600) height(1200)

  
}
  
 
***different estimated function

**Figure S13 RDiT estimates for plant emission of AQAs at different kernel function

**fig_s13(a)
clear all  

global name o_up y_up b_up o_down y_down b_down 
global  control temperature air_pressure wind_speed visibility_distance AQI_l24
global y  lnPM_A lnSO2_A lnNOx_A 
local replace replace
foreach a in $name{
	use "data/data1.dta", replace
	keep if `a'_level!=.		
	foreach i in $y{
		reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster enterprise)  resid(re`i')
		rdrobust re`i' `a'_id , c(0) p(2) q(3)  kernel(epanechnikov)  masspoints(off)
		estimates store  re_`a'_`i'
	}
}


coefplot ///
  (re_o_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1)) ///
  (re_o_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9)) ///
  (re_o_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12)) ///
  (re_y_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1)) ///
  (re_y_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9)) ///
  (re_y_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12)) ///
  (re_b_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1)) ///
  (re_b_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9)) ///
  (re_b_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12)) ///
  (re_o_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1)) ///
  (re_o_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9)) ///
  (re_o_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12)) ///
  (re_y_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1)) ///
  (re_y_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9)) ///
  (re_y_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12)) ///
  (re_b_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1)) ///
  (re_b_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9)) ///
  (re_b_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
  xlabel(1 "o_activate"  1 "o_activate"  1 "o_activate" ///
         4 "y_activate" 4 "y_activate" 4 "y_activate"  ///
		 7 "b_activate"  7 "b_activate"  7 "b_activate" ///
		 10 "o_terminate"  10 "o_terminate"  10"o_terminate" ///
		 13 "y_terminate" 13 "y_terminate" 13 "y_terminate"  ///
		 16 "b_terminate"  16 "b_terminate"  16 "b_terminate" , angle(-30)) ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(8.5, lwidth(vthin) lpattern(shortdash) lcolor(teal)) ///
  ytitle("log(Pollutant) estimates", size(medium)) ///
  xtitle("Type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "PM" 4 "SO{sub:2}" 6 "NOx") row(1)) ///
  name(graphPM, replace)
  graph export "picture/single-all-核函数（epanechnikov）.png", replace as(png) name("graphPM") width(1600) height(1200)

  
**fig_s13(b) 
clear all  

global name o_up y_up b_up o_down y_down b_down 
global  control temperature air_pressure wind_speed visibility_distance AQI_l24
global y  lnPM_A lnSO2_A lnNOx_A 
local replace replace
foreach a in $name{
	use "data/data1.dta", replace
	keep if `a'_level!=.		
	foreach i in $y{
		reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster enterprise)  resid(re`i')
		rdrobust re`i' `a'_id , c(0) p(2) q(3)  kernel(uniform)  masspoints(off)
		estimates store  re_`a'_`i'
	}
}


coefplot ///
  (re_o_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1)) ///
  (re_o_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9)) ///
  (re_o_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12)) ///
  (re_y_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1)) ///
  (re_y_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9)) ///
  (re_y_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12)) ///
  (re_b_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1)) ///
  (re_b_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9)) ///
  (re_b_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12)) ///
  (re_o_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1)) ///
  (re_o_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9)) ///
  (re_o_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12)) ///
  (re_y_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1)) ///
  (re_y_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9)) ///
  (re_y_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12)) ///
  (re_b_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1)) ///
  (re_b_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9)) ///
  (re_b_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
  xlabel(1 "o_activate"  1 "o_activate"  1 "o_activate" ///
         4 "y_activate" 4 "y_activate" 4 "y_activate"  ///
		 7 "b_activate"  7 "b_activate"  7 "b_activate" ///
		 10 "o_terminate"  10 "o_terminate"  10"o_terminate" ///
		 13 "y_terminate" 13 "y_terminate" 13 "y_terminate"  ///
		 16 "b_terminate"  16 "b_terminate"  16 "b_terminate" , angle(-30)) ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(8.5, lwidth(vthin) lpattern(shortdash) lcolor(teal)) ///
  ytitle("log(Pollutant) estimates", size(medium)) ///
  xtitle("Type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "PM" 4 "SO{sub:2}" 6 "NOx") row(1)) ///
  name(graphPM, replace)
  graph export "picture/single-all-核函数（uniform）.png", replace as(png) name("graphPM") width(1600) height(1200)


  
**Figure S14 RDiT estimates for plant emission of AQAs at different functional form
**fig_s14(a) 

clear all  

global name o_up y_up b_up o_down y_down b_down 
global  control temperature air_pressure wind_speed visibility_distance AQI_l24
global y  lnPM_A lnSO2_A lnNOx_A 
local replace replace
foreach a in $name{
	use "data/data1.dta", replace
	keep if `a'_level!=.		
	foreach i in $y{
		reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster enterprise)  resid(re`i')
		rdrobust re`i' `a'_id , c(0) p(1) q(2)  kernel(triangular)  masspoints(off)
		estimates store  re_`a'_`i'
	}
}


coefplot ///
  (re_o_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1)) ///
  (re_o_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9)) ///
  (re_o_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12)) ///
  (re_y_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1)) ///
  (re_y_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9)) ///
  (re_y_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12)) ///
  (re_b_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1)) ///
  (re_b_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9)) ///
  (re_b_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12)) ///
  (re_o_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1)) ///
  (re_o_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9)) ///
  (re_o_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12)) ///
  (re_y_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1)) ///
  (re_y_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9)) ///
  (re_y_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12)) ///
  (re_b_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1)) ///
  (re_b_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9)) ///
  (re_b_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
  xlabel(1 "o_activate"  1 "o_activate"  1 "o_activate" ///
         4 "y_activate" 4 "y_activate" 4 "y_activate"  ///
		 7 "b_activate"  7 "b_activate"  7 "b_activate" ///
		 10 "o_terminate"  10 "o_terminate"  10"o_terminate" ///
		 13 "y_terminate" 13 "y_terminate" 13 "y_terminate"  ///
		 16 "b_terminate"  16 "b_terminate"  16 "b_terminate" , angle(-30)) ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(8.5, lwidth(vthin) lpattern(shortdash) lcolor(teal)) ///
  ytitle("log(Pollutant) estimates", size(medium)) ///
  xtitle("Type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "PM" 4 "SO{sub:2}" 6 "NOx") row(1)) ///
  name(graphPM, replace)
  graph export "picture/single-all-一阶.png", replace as(png) name("graphPM") width(1600) height(1200)

  
**fig_s14(b) 
clear all  

global name o_up y_up b_up o_down y_down b_down 
global  control temperature air_pressure wind_speed visibility_distance AQI_l24
global y  lnPM_A lnSO2_A lnNOx_A 
local replace replace
foreach a in $name{
	use "data/data1.dta", replace
	keep if `a'_level!=.		
	foreach i in $y{
		reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster enterprise)  resid(re`i')
		rdrobust re`i' `a'_id , c(0) p(3) q(4)  kernel(triangular)  masspoints(off)
		estimates store  re_`a'_`i'
	}
}


coefplot ///
  (re_o_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1)) ///
  (re_o_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9)) ///
  (re_o_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12)) ///
  (re_y_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1)) ///
  (re_y_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9)) ///
  (re_y_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12)) ///
  (re_b_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1)) ///
  (re_b_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9)) ///
  (re_b_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12)) ///
  (re_o_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1)) ///
  (re_o_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9)) ///
  (re_o_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12)) ///
  (re_y_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1)) ///
  (re_y_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9)) ///
  (re_y_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12)) ///
  (re_b_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1)) ///
  (re_b_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9)) ///
  (re_b_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
  xlabel(1 "o_activate"  1 "o_activate"  1 "o_activate" ///
         4 "y_activate" 4 "y_activate" 4 "y_activate"  ///
		 7 "b_activate"  7 "b_activate"  7 "b_activate" ///
		 10 "o_terminate"  10 "o_terminate"  10"o_terminate" ///
		 13 "y_terminate" 13 "y_terminate" 13 "y_terminate"  ///
		 16 "b_terminate"  16 "b_terminate"  16 "b_terminate" , angle(-30)) ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(8.5, lwidth(vthin) lpattern(shortdash) lcolor(teal)) ///
  ytitle("log(Pollutant) estimates", size(medium)) ///
  xtitle("Type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "PM" 4 "SO{sub:2}" 6 "NOx") row(1)) ///
  name(graphPM, replace)
  graph export "picture/single-all-三阶.png", replace as(png) name("graphPM") width(1600) height(1200)

 
  
**Figure S15 RDiT estimates for plant emission of AQAs at different donut check
  
clear all  

global name  o_up y_up b_up  o_down y_down b_down 
global  control temperature air_pressure wind_speed visibility_distance AQI_l24
global y  lnPM_A lnSO2_A lnNOx_A 
global donut_ranges 12 24 36 48
local replace replace

foreach range in $donut_ranges {	
	
	foreach a in $name{
		use "data/data1.dta", replace
		keep if `a'_level!=.		
		gen donut = (`a'_id >= -`range' & `a'_id <= `range')
		foreach i in $y{	
			reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster enterprise)  resid(re`i')
			rdrobust re`i' `a'_id  if !donut, c(0) p(2) q(3)  kernel(triangular)  masspoints(off)
			estimates store  re_`a'_`i'
		}
	}



coefplot ///
  (re_o_up_lnPM_A,  label("PM") offset(-0.25) msymbol(o)  pstyle(p1)  msize(*1.6)) ///
  (re_o_up_lnSO2_A,  label("SO2") offset(-1) msymbol(s) pstyle(p9)  msize(*1.6)) ///
  (re_o_up_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d) pstyle(p12)  msize(*1.6)) ///
  (re_y_up_lnPM_A,  label("PM") offset(-0.25) msymbol(o)  pstyle(p1)  msize(*1.6)) ///
  (re_y_up_lnSO2_A,  label("SO2") offset(-1) msymbol(s) pstyle(p9)  msize(*1.6)) ///
  (re_y_up_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d) pstyle(p12)  msize(*1.6)) ///
  (re_b_up_lnPM_A,  label("PM") offset(-0.25) msymbol(o)  pstyle(p1)  msize(*1.6)) ///
  (re_b_up_lnSO2_A,  label("SO2") offset(-1) msymbol(s) pstyle(p9)  msize(*1.6)) ///
  (re_b_up_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d) pstyle(p12)  msize(*1.6)) ///
  (re_o_down_lnPM_A,  label("PM") offset(-0.25) msymbol(o)  pstyle(p1)  msize(*1.6)) ///
  (re_o_down_lnSO2_A,  label("SO2") offset(-1)  msymbol(s) pstyle(p9)  msize(*1.6)) ///
  (re_o_down_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d) pstyle(p12)  msize(*1.6)) ///
  (re_y_down_lnPM_A,  label("PM") offset(-0.25) msymbol(o)  pstyle(p1)  msize(*1.6)) ///
  (re_y_down_lnSO2_A,  label("SO2") offset(-1) msymbol(s) pstyle(p9)  msize(*1.6)) ///
  (re_y_down_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d) pstyle(p12)  msize(*1.6)) ///
  (re_b_down_lnPM_A,  label("PM") offset(-0.25) msymbol(o)   pstyle(p1)  msize(*1.6)) ///
  (re_b_down_lnSO2_A,  label("SO2") offset(-1) msymbol(s) pstyle(p9)  msize(*1.6)) ///
  (re_b_down_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d) pstyle(p12)  msize(*1.6)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
  xlabel(1 "o_activate"  1 "o_activate"  1 "o_activate" 4 "y_activate" 4 "y_activate" 4 "y_activate" ///
	     7 "b_activate"  7 "b_activate"  7 "b_activate" 10 "o_terminate"  10 "o_terminate"  10"o_terminate" ///
		 13 "y_terminate" 13 "y_terminate" 13 "y_terminate" ///
		 16 "b_terminate"  16 "b_terminate"  16 "b_terminate" , angle(-30)) ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(8.5, lwidth(vthin) lpattern(shortdash) lcolor(teal)) ///
  ytitle("log(Pollutant) estimates", size(medium)) ///
  xtitle("Type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "PM" 4 "SO{sub:2}" 6 "NOx") row(1)) ///
  name(graphPM, replace)
  graph export "/picture/single_level-donut-`range'.png", replace as(png) name("graphPM") width(1600) height(1200)

  
}
  

**Figure S16-S18 RDiT Plots for Weather Conditions	

***Figure S16

global y temp humid ws press
use "/data/data3.dta", replace
keep if o_up_level !=.	


foreach i in $y{
	
    if "`i'" == "temp" {
        local ytitle_label "Temperature"
    }
    else if "`i'" == "humid" {
        local ytitle_label "Humidity"
    }
    else if "`i'" == "ws" {
        local ytitle_label "Wind speed"
    }
    else if "`i'" == "press" {
        local ytitle_label "Air pressure"
    }
    else {
        local ytitle_label "`i_sub'"  
    }



rdplot `i' o_up_id if o_up_id <= 50& o_up_id >=-50 & year>=2013 & year<=2020, ///
               binselect(es)  c(0)  ci(95)   
			   graph_options(ylabel(,labsize(*1.2)) xlabel(,labsize(*1.2)) 
               ytitle("`ytitle_label'", size(medium))  
               xtitle("AQA declare", size(medium)) 
			   xtick(-50(25)50) ///
			   legend(off)) 
               graphregion(color(white))) ///
			   scheme(plotplainblind))
			   
graph save "picture/origin/q-o_up`i'.gph",  replace

 }


use "data/GZ_alert_deal_stata.dta", replace
keep if o_down_level !=.	
 

foreach i in $y{
	
    if "`i'" == "temp" {
        local ytitle_label "Temperature"
    }
    else if "`i'" == "humid" {
        local ytitle_label "Humidity"
    }
    else if "`i'" == "ws" {
        local ytitle_label "Wind speed"
    }
    else if "`i'" == "press" {
        local ytitle_label "Air pressure"
    }
    else {
        local ytitle_label "`i_sub'"  
    }


rdplot `i' o_down_id if o_down_id <= 50& o_down_id >=-50 & year>=2013 & year<=2020, ///
               binselect(es)  c(0)  ci(95)   /// 
			   graph_options(ylabel(,labsize(*1.2)) xlabel(,labsize(*1.2)) ///
               ytitle("`ytitle_label'", size(medium))  ///
               xtitle("AQA terminate", size(medium)) ///
			   xtick(-50(25)50) ///
			   legend(off)) ///
               graphregion(color(white))) ///
			   
graph save "picture/origin/q-o_down`i'.gph",  replace

}


graph combine "picture/origin/q-o_uptemp.gph" "picture/origin/q-o_uphumid.gph" "picture/origin/q-o_upws.gph" "picture/origin/q-o_uppress.gph" "picture/origin/q-o_downtemp.gph" "picture/origin/q-o_downhumid.gph" "picture/origin/q-o_downws.gph" "picture/origin/q-o_downpress.gph" , rows(2)
		
graph export "picture/q-o_level.png", replace as(png)  width(1800) height(1200)



***Figure S17

global y temp humid ws press
 
use "data/GZ_alert_deal_stata.dta", replace
keep if y_up_level !=.	


foreach i in $y{
	
    if "`i'" == "temp" {
        local ytitle_label "Temperature"
    }
    else if "`i'" == "humid" {
        local ytitle_label "Humidity"
    }
    else if "`i'" == "ws" {
        local ytitle_label "Wind speed"
    }
    else if "`i'" == "press" {
        local ytitle_label "Air pressure"
    }
    else {
        local ytitle_label "`i_sub'"  
    }



rdplot `i' y_up_id if y_up_id <= 50& y_up_id >=-50 & year>=2013 & year<=2020, ///
               binselect(es)  c(0)  ci(95)   /// 
			   graph_options(ylabel(,labsize(*1.2)) xlabel(,labsize(*1.2)) ///
               ytitle("`ytitle_label'", size(medium))  ///
               xtitle("AQA declare", size(medium)) ///
			   xtick(-50(25)50) ///
			   legend(off)) ///
               graphregion(color(white))) ///
			   scheme(plotplainblind))
			   
graph save "picture/origin/q-y_up`i'.gph",  replace

 }




use "data/GZ_alert_deal_stata.dta", replace
keep if y_down_level !=.	
 

foreach i in $y{
	
    if "`i'" == "temp" {
        local ytitle_label "Temperature"
    }
    else if "`i'" == "humid" {
        local ytitle_label "Humidity"
    }
    else if "`i'" == "ws" {
        local ytitle_label "Wind speed"
    }
    else if "`i'" == "press" {
        local ytitle_label "Air pressure"
    }
    else {
        local ytitle_label "`i_sub'" 
    }


rdplot `i' y_down_id if y_down_id <= 50& y_down_id >=-50 & year>=2013 & year<=2020, ///
               binselect(es)  c(0)  ci(95)   /// 
			   graph_options(ylabel(,labsize(*1.2)) xlabel(,labsize(*1.2)) ///
               ytitle("`ytitle_label'", size(medium))  ///
               xtitle("AQA terminate", size(medium)) ///
			   xtick(-50(25)50) ///
			   legend(off)) ///
               graphregion(color(white))) ///
			   
graph save "picture/origin/q-y_down`i'.gph",  replace

}


graph combine "picture/origin/q-y_uptemp.gph" "picture/origin/q-y_uphumid.gph" "picture/origin/q-y_upws.gph" "picture/origin/q-y_uppress.gph" "picture/origin/q-y_downtemp.gph" "picture/origin/q-y_downhumid.gph" "picture/origin/q-y_downws.gph" "picture/origin/q-y_downpress.gph" , rows(2)

     			
graph export "picture/q-y_level.png", replace as(png)  width(1800) height(1200)


***Figure S18

global y temp humid ws press
 
use "data/data3.dta", replace
keep if b_up_level !=.	


foreach i in $y{
	

    if "`i'" == "temp" {
        local ytitle_label "Temperature"
    }
    else if "`i'" == "humid" {
        local ytitle_label "Humidity"
    }
    else if "`i'" == "ws" {
        local ytitle_label "Wind speed"
    }
    else if "`i'" == "press" {
        local ytitle_label "Air pressure"
    }
    else {
        local ytitle_label "`i_sub'"  
    }



rdplot `i' b_up_id if b_up_id <= 50& b_up_id >=-50 & year>=2013 & year<=2020, ///
               binselect(es)  c(0)  ci(95)   /// 
			   graph_options(ylabel(,labsize(*1.2)) xlabel(,labsize(*1.2)) ///
               ytitle("`ytitle_label'", size(medium))  ///
               xtitle("AQA declare", size(medium)) ///
			   xtick(-50(25)50) ///
			   legend(off)) ///
               graphregion(color(white))) ///
			   scheme(plotplainblind))
			   
graph save "picture/origin/q-b_up`i'.gph",  replace

 }


use "data/data3.dta", replace
keep if b_down_level !=.	
 

foreach i in $y{
	
    if "`i'" == "temp" {
        local ytitle_label "Temperature"
    }
    else if "`i'" == "humid" {
        local ytitle_label "Humidity"
    }
    else if "`i'" == "ws" {
        local ytitle_label "Wind speed"
    }
    else if "`i'" == "press" {
        local ytitle_label "Air pressure"
    }
    else {
        local ytitle_label "`i_sub'"  //
    }


rdplot `i' b_down_id if b_down_id <= 50& b_down_id >=-50 & year>=2013 & year<=2020, ///
               binselect(es)  c(0)  ci(95)   /// 
			   graph_options(ylabel(,labsize(*1.2)) xlabel(,labsize(*1.2)) ///
               ytitle("`ytitle_label'", size(medium))  ///
               xtitle("AQA terminate", size(medium)) ///
			   xtick(-50(25)50) ///
			   legend(off)) ///
               graphregion(color(white))) ///
			   
graph save "picture/origin/q-b_down`i'.gph",  replace

}


graph combine "picture/origin/q-b_uptemp.gph" "picture/origin/q-b_uphumid.gph" "picture/origin/q-b_upws.gph" "picture/origin/q-b_uppress.gph" "picture/origin/q-b_downtemp.gph" "picture/origin/q-b_downhumid.gph" "picture/origin/q-b_downws.gph" "picture/origin/q-b_downpress.gph" , rows(2)

     			
graph export "picture/q-b_level.png", replace as(png)  width(1800) height(1200)



  
**Figure S19 RDiT estimates for plant' emissions under resolving autoregression	

clear all  

global name  o_up y_up b_up  o_down y_down b_down 
global  control temperature air_pressure wind_speed visibility_distance AQI_l24
global y  lnPM_A lnSO2_A lnNOx_A 
local replace replace
foreach a in $name{
	use "data&code_revision/firmdata_merge_sub_revision_deal_stata_1.dta", replace
	keep if `a'_level!=.		
	foreach i in $y{
		reghdfe `i' `i'_1 $control  ,absorb(enterprise year month weekday) vce(cluster enterprise)  resid(re`i')
		rdrobust re`i' `a'_id , c(0) p(2) q(3)  kernel(triangular)  masspoints(off)
		estimates store  re_`a'_`i'
	}
}



coefplot ///
  (re_o_up_lnPM_A,  label("PM") offset(-0.25) msymbol(o)  pstyle(p1)  msize(*1.6)) ///
  (re_o_up_lnSO2_A,  label("SO2") offset(-1) msymbol(s) pstyle(p9)  msize(*1.6)) ///
  (re_o_up_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d) pstyle(p12)  msize(*1.6)) ///
  (re_y_up_lnPM_A,  label("PM") offset(-0.25) msymbol(o)  pstyle(p1)  msize(*1.6)) ///
  (re_y_up_lnSO2_A,  label("SO2") offset(-1) msymbol(s) pstyle(p9)  msize(*1.6)) ///
  (re_y_up_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d) pstyle(p12)  msize(*1.6)) ///
  (re_b_up_lnPM_A,  label("PM") offset(-0.25) msymbol(o)  pstyle(p1)  msize(*1.6)) ///
  (re_b_up_lnSO2_A,  label("SO2") offset(-1) msymbol(s) pstyle(p9)  msize(*1.6)) ///
  (re_b_up_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d) pstyle(p12)  msize(*1.6)) ///
  (re_o_down_lnPM_A,  label("PM") offset(-0.25) msymbol(o)  pstyle(p1)  msize(*1.6)) ///
  (re_o_down_lnSO2_A,  label("SO2") offset(-1)  msymbol(s) pstyle(p9)  msize(*1.6)) ///
  (re_o_down_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d) pstyle(p12)  msize(*1.6)) ///
  (re_y_down_lnPM_A,  label("PM") offset(-0.25) msymbol(o)  pstyle(p1)  msize(*1.6)) ///
  (re_y_down_lnSO2_A,  label("SO2") offset(-1) msymbol(s) pstyle(p9)  msize(*1.6)) ///
  (re_y_down_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d) pstyle(p12)  msize(*1.6)) ///
  (re_b_down_lnPM_A,  label("PM") offset(-0.25) msymbol(o)   pstyle(p1)  msize(*1.6)) ///
  (re_b_down_lnSO2_A,  label("SO2") offset(-1) msymbol(s) pstyle(p9)  msize(*1.6)) ///
  (re_b_down_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d) pstyle(p12)  msize(*1.6)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
  xlabel(1 "o_activate"  1 "o_activate"  1 "o_activate" 4 "y_activate" 4 "y_activate" 4 "y_activate" ///
	     7 "b_activate"  7 "b_activate"  7 "b_activate" 10 "o_terminate"  10 "o_terminate"  10"o_terminate" ///
		 13 "y_terminate" 13 "y_terminate" 13 "y_terminate" ///
		 16 "b_terminate"  16 "b_terminate"  16 "b_terminate" , angle(-30)) ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(8.5, lwidth(vthin) lpattern(shortdash) lcolor(teal)) ///
  ytitle("log(Pollutant) estimates", size(medium)) ///
  xtitle("Type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "PM" 4 "SO{sub:2}" 6 "NOx") row(1)) ///
  name(graphPM, replace)
  graph export "picture/fig_s19.png", replace as(png) name("graphPM") width(1600) height(1200)

	

  
**Figure S20 Plants' emission data smoothness test	


clear all
use "data&code_revision/firmdata_merge_sub_revision_deal_stata.dta", replace
keep if o_up_level!=.	&  if_alert == 1
drop if PM_A ==. &  NOx_A ==. & SO2_A ==.

rddensity o_up_id, c(0) p(3) bwselect(each) ///
	plot plot_range(-50 50) plot_n(30 30) ///
	nohistogram ///
	graph_opt(xline(0, lpattern(dash) lcolor(red)) ///
	title("Orange level alert active (1)", size(medium)) ///
	xtitle("Hours to AQA active", size(medium)) legend(off)) 
	graph save "picture/origin/q-hours_o_up.gph",  replace
	
clear all
use "data&code_revision/firmdata_merge_sub_revision_deal_stata.dta", replace
keep if y_up_level!=.	&  if_alert == 1
drop if PM_A ==. &  NOx_A ==. & SO2_A ==.

rddensity y_up_id, c(0) p(3) bwselect(each) ///
	plot plot_range(-50 50) plot_n(30 30) ///
	nohistogram ///
	graph_opt(xline(0, lpattern(dash) lcolor(red)) ///
	title("Yellow level alert active (1)", size(medium)) ///
	xtitle("Hours to AQA active", size(medium)) legend(off)) 
	graph save "picture/origin/q-hours_y_up.gph",  replace
	
clear all
use "data&code_revision/firmdata_merge_sub_revision_deal_stata.dta", replace
keep if b_up_level!=.	&  if_alert == 1
drop if PM_A ==. &  NOx_A ==. & SO2_A ==.

rddensity b_up_id, c(0) p(3) bwselect(each) ///
	plot plot_range(-40 40) plot_n(30 30) ///
	nohistogram ///
	graph_opt(xline(0, lpattern(dash) lcolor(red)) ///
	title("Blue level alert active (1)", size(medium)) ///
	xtitle("Hours to AQA active", size(medium)) legend(off)) 
	graph save "picture/origin/q-hours_b_up.gph",  replace
	
	
//去除了0值之后的变化情况

clear all
use "data&code_revision/firmdata_merge_sub_revision_deal_stata.dta", replace
keep if o_up_level!=.	&  if_alert == 1
drop if PM_A ==. &  NOx_A ==. & SO2_A ==.
drop if PM_A ==0 &  NOx_A ==0 & SO2_A ==0

rddensity o_up_id, c(0) p(3) bwselect(each) ///
	plot plot_range(-50 50) plot_n(30 30) ///
	nohistogram ///
	graph_opt(xline(0, lpattern(dash) lcolor(red)) ///
	title("Orange level alert active (2)", size(medium)) ///
	xtitle("Hours to AQA active", size(medium)) legend(off)) 
	graph save "picture/origin/q-hours_o_up-1.gph",  replace
	
clear all
use "data&code_revision/firmdata_merge_sub_revision_deal_stata.dta", replace
keep if y_up_level!=.	&  if_alert == 1
drop if PM_A ==. &  NOx_A ==. & SO2_A ==.
drop if PM_A ==0 &  NOx_A ==0 & SO2_A ==0

rddensity y_up_id, c(0) p(3) bwselect(each) ///
	plot plot_range(-50 50) plot_n(30 30) ///
	nohistogram ///
	graph_opt(xline(0, lpattern(dash) lcolor(red)) ///
	title("Yellow level alert active (2)", size(medium)) ///
	xtitle("Hours to AQA active", size(medium)) legend(off)) 
	graph save "picture/origin/q-hours_y_up-1.gph",  replace
	
clear all
use "data&code_revision/firmdata_merge_sub_revision_deal_stata.dta", replace
keep if b_up_level!=.	&  if_alert == 1
drop if PM_A ==. &  NOx_A ==. & SO2_A ==.
drop if PM_A ==0 &  NOx_A ==0 & SO2_A ==0

rddensity b_up_id, c(0) p(3) bwselect(each) ///
	plot plot_range(-40 40) plot_n(30 30) ///
	nohistogram ///
	graph_opt(xline(0, lpattern(dash) lcolor(red)) ///
	title("Blue level alert active (2)", size(medium)) ///
	xtitle("Hours to AQA active", size(medium)) legend(off)) 
	graph save "picture/origin/q-hours_b_up-1.gph",  replace
	
		
	
	
graph combine "picture/origin/q-hours_o_up.gph" "picture/origin/q-hours_y_up.gph" "picture/origin/q-hours_b_up.gph" "/picture/origin/q-hours_o_up-1.gph" "picture/origin/q-hours_y_up-1.gph" "picture/origin/q-hours_b_up-1.gph" 

graph export "picture/figure_s20.png", replace as(png)  width(1800) height(1200)

  
**Figure S21 AQI smoothness test

clear all
use "data/data3.dta", replace

rddensity AQI_l36_max, c(200) p(3) bwselect(each) ///
	plot plot_range(150 250) plot_n(10 10) ///
	hist_range(150 250) hist_n(10 10) ///
	graph_opt(xtitle("Running Variable AQI") legend(off)) 
graph export "picture/runing_variable_check.png", replace as(png)  width(1800) height(1200)


***different alert time

clear all  

global  day night
global name  o_up y_up b_up  o_down y_down b_down 
global  control temperature AQI_l24
global y  lnPM_A lnSO2_A lnNOx_A 
local replace replace
foreach a in $name{
	
	foreach b in $heter{
		
		use "data/data1.dta", replace
		keep if `a'_level!=.	
		keep if `a'_daynight == "`b'"
		foreach i in $y{
			reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster site)  resid(re`i')
			rdrobust re`i' `a'_id , c(0) p(2) q(3)  kernel(triangular)  masspoints(off)
			estimates store  re_`b'_`a'_`i'
		}
		
	}
	
}

**Figure S22 RD estimates for plants' emission at AQAs declare and terminate time during the day

coefplot ///
  (re_day_o_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_day_o_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_day_o_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_day_y_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_day_y_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_day_y_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_day_b_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_day_b_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_day_b_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_day_o_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_day_o_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_day_o_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_day_y_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_day_y_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_day_y_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_day_b_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_day_b_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_day_b_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
   xlabel(1 "o_declare"  1 "o_declare"  1 "o_declare" ///
         4 "y_declare" 4 "y_declare" 4 "y_declare"  ///
		 7 "b_declare"  7 "b_declare"  7 "b_declare" ///
		 10 "o_terminate"  10 "o_terminate"  10"o_terminate" ///
		 13 "y_terminate" 13 "y_terminate" 13 "y_terminate"  ///
		 16 "b_terminate"  16 "b_terminate"  16 "b_terminate" , angle(-30)) ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(8.5, lwidth(vthin) lpattern(shortdash) lcolor(teal)) ///
  ytitle("log(Pollutant) estimates", size(medium)) ///
  xtitle("Type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "PM" 4 "SO{sub:2}" 6 "NOx") row(1)) ///
  name(graphPM, replace)
  graph export "picture/Heterogeneous_day.png", replace as(png) name("graphPM") width(1600) height(1200)
  
  
**Figure S23 RD estimates for plants' emission at AQAs declare and terminate time during the night
coefplot ///
   (re_night_o_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_night_o_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_night_o_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_night_y_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_night_y_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_night_y_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_night_b_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_night_b_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_night_b_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_night_o_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_night_o_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_night_o_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_night_y_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_night_y_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_night_y_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_night_b_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_night_b_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_night_b_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
   xlabel(1 "o_declare"  1 "o_declare"  1 "o_declare" ///
         4 "y_declare" 4 "y_declare" 4 "y_declare"  ///
		 7 "b_declare"  7 "b_declare"  7 "b_declare" ///
		 10 "o_terminate"  10 "o_terminate"  10"o_terminate" ///
		 13 "y_terminate" 13 "y_terminate" 13 "y_terminate"  ///
		 16 "b_terminate"  16 "b_terminate"  16 "b_terminate" , angle(-30)) ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(8.5, lwidth(vthin) lpattern(shortdash) lcolor(teal)) ///
  ytitle("log(Pollutant) estimates", size(medium)) ///
  xtitle("Type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "PM" 4 "SO{sub:2}" 6 "NOx") row(1)) ///
  name(graphPM, replace)
  graph export "picture/Heterogeneous_night.png", replace as(png) name("graphPM") width(1600) height(1200)



***different industries
** Fig.S24. RDiT estimates for plant emission for thermal power industry.

clear all  

global name  o_up y_up b_up  o_down y_down b_down 
global  control temperature air_pressure wind_speed visibility_distance AQI_l24
global y  lnPM_A lnSO2_A lnNOx_A 
local replace replace
foreach a in $name{
		
		use "data/data1.dta", replace
		
		gen sector_type = 0

		replace sector_type= 1 if sector== "火力发电" | sector== "热电联产" 


		keep if `a'_level!=.	
		keep if sector_type == 1
		foreach i in $y{
			reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster enterprise)  resid(re`i')
			rdrobust re`i' `a'_id , c(0) p(2) q(3)  kernel(triangular)  masspoints(off)
			estimates store  re_`a'_`i'
		}
		
	}
	



coefplot ///
  (re_o_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.6)) ///
  (re_o_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.6)) ///
  (re_o_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.6)) ///
  (re_y_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.6)) ///
  (re_y_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.6)) ///
  (re_y_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.6)) ///
  (re_b_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.6)) ///
  (re_b_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.6)) ///
  (re_b_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.6)) ///
  (re_o_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.6)) ///
  (re_o_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.6)) ///
  (re_o_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.6)) ///
  (re_y_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.6)) ///
  (re_y_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.6)) ///
  (re_y_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.6)) ///
  (re_b_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.6)) ///
  (re_b_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.6)) ///
  (re_b_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.6)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
  xlabel(1 "o_activate"  1 "o_activate"  1 "o_activate" ///
         4 "y_activate" 4 "y_activate" 4 "y_activate"  ///
		 7 "b_activate"  7 "b_activate"  7 "b_activate" ///
		 10 "o_terminate"  10 "o_terminate"  10"o_terminate" ///
		 13 "y_terminate" 13 "y_terminate" 13 "y_terminate"  ///
		 16 "b_terminate"  16 "b_terminate"  16 "b_terminate" , angle(-30)) ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(8.5, lwidth(vthin) lpattern(shortdash) lcolor(teal)) ///
  ytitle("log(Pollutant) estimates", size(medium)) ///
  xtitle("Type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "PM" 4 "SO{sub:2}" 6 "NOx") row(1)) ///
  name(graphPM, replace)
  graph export "picture/fig_s24.png", replace as(png) name("graphPM") width(1600) height(1200)
 
 
 
**Fig.S25. RDiT estimates for plant emission for special heavy pollution industries.

clear all  

global name  o_up y_up b_up  o_down y_down b_down 
global  control temperature air_pressure wind_speed visibility_distance AQI_l24
global y  lnPM_A lnSO2_A lnNOx_A 
local replace replace
foreach a in $name{
		
		use "data/data1.dta", replace
		
		gen sector_type = 0

		replace sector_type= 1 if sector== "炼焦"| sector== "水泥制造"| ///
		sector== "炼铁" | sector== "平板玻璃制造"| sector== "黑色金属冶炼和压延加工业"


		keep if `a'_level!=.	
		keep if sector_type == 1
		foreach i in $y{
			reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster enterprise)  resid(re`i')
			rdrobust re`i' `a'_id , c(0) p(2) q(3)  kernel(triangular)  masspoints(off)
			estimates store  re_`a'_`i'
		}
		
	}

coefplot ///
  (re_o_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.6)) ///
  (re_o_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.6)) ///
  (re_o_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.6)) ///
  (re_y_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.6)) ///
  (re_y_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.6)) ///
  (re_y_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.6)) ///
  (re_b_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.6)) ///
  (re_b_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.6)) ///
  (re_b_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.6)) ///
  (re_o_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.6)) ///
  (re_o_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.6)) ///
  (re_o_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.6)) ///
  (re_y_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.6)) ///
  (re_y_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.6)) ///
  (re_y_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.6)) ///
  (re_b_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.6)) ///
  (re_b_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.6)) ///
  (re_b_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.6)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
  xlabel(1 "o_activate"  1 "o_activate"  1 "o_activate" ///
         4 "y_activate" 4 "y_activate" 4 "y_activate"  ///
		 7 "b_activate"  7 "b_activate"  7 "b_activate" ///
		 10 "o_terminate"  10 "o_terminate"  10"o_terminate" ///
		 13 "y_terminate" 13 "y_terminate" 13 "y_terminate"  ///
		 16 "b_terminate"  16 "b_terminate"  16 "b_terminate" , angle(-30)) ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(8.5, lwidth(vthin) lpattern(shortdash) lcolor(teal)) ///
  ytitle("log(Pollutant) estimates", size(medium)) ///
  xtitle("Type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "PM" 4 "SO{sub:2}" 6 "NOx") row(1)) ///
  name(graphPM, replace)
  graph export "picture/fig_s25.png", replace as(png) name("graphPM") width(1600) height(1200)
 
 
**Fig.S26. RDiT estimates for plant emission for other pollution industries.
 
clear all  


global name  o_up y_up b_up  o_down y_down b_down 
global  control temperature AQI_l24
global y  lnPM_A lnSO2_A lnNOx_A 
local replace replace
foreach a in $name{
		
		use "data/data1.dta", replace
		gen sector_type = 0

		replace sector_type= 1  if sector== "炼焦"| sector== "水泥制造"| ///
		sector== "炼铁" | sector== "平板玻璃制造"| sector== "黑色金属冶炼和压延加工业" | sector== "火力发电" | sector== "热电联产" 


		keep if `a'_level!=.	
		keep if sector_type == 1

		foreach i in $y{
			reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster enterprise)  resid(re`i')
			rdrobust re`i' `a'_id , c(0) p(2) q(3)  kernel(triangular)  masspoints(off)
			estimates store  re_`a'_`i'
		}
		
	}
	

  

coefplot ///
  (re_o_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.6)) ///
  (re_o_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.6)) ///
  (re_o_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.6)) ///
  (re_y_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.6)) ///
  (re_y_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.6)) ///
  (re_y_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.6)) ///
  (re_b_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.6)) ///
  (re_b_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.6)) ///
  (re_b_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.6)) ///
  (re_o_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.6)) ///
  (re_o_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.6)) ///
  (re_o_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.6)) ///
  (re_y_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.6)) ///
  (re_y_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.6)) ///
  (re_y_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.6)) ///
  (re_b_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.6)) ///
  (re_b_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.6)) ///
  (re_b_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.6)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
   xlabel(1 "o_activate"  1 "o_activate"  1 "o_activate" ///
         4 "y_activate" 4 "y_activate" 4 "y_activate"  ///
		 7 "b_activate"  7 "b_activate"  7 "b_activate" ///
		 10 "o_terminate"  10 "o_terminate"  10"o_terminate" ///
		 13 "y_terminate" 13 "y_terminate" 13 "y_terminate"  ///
		 16 "b_terminate"  16 "b_terminate"  16 "b_terminate" , angle(-30)) ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(8.5, lwidth(vthin) lpattern(shortdash) lcolor(teal)) ///
  ytitle("log(Pollutant) estimates", size(medium)) ///
  xtitle("Type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "PM" 4 "SO{sub:2}" 6 "NOx") row(1)) ///
  name(graphPM, replace)
  graph export "picture/fig_s26.png", replace as(png) name("graphPM") width(1600) height(1200)
 


***Different contaminated area

clear all  


global name  o_up y_up b_up  o_down y_down b_down 
global  control temperature AQI_l24
global y  lnPM_A lnSO2_A lnNOx_A 
local replace replace
foreach a in $name{
		
		use "data/data1.dta", replace
		keep if `a'_level!=.	
		keep if pollutant_day > 5
		foreach i in $y{
			reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster site)  resid(re`i')
			rdrobust re`i' `a'_id , c(0) p(2) q(3)  kernel(triangular)  masspoints(off)
			estimates store  re_`a'_`i'
		}
		
	}
	

**Figure S27 RD estimates for plants' emission for heavy pollution area

coefplot ///
  (re_o_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_o_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_o_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_y_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_y_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_y_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_b_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_b_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_b_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_o_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_o_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_o_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_y_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_y_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_y_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_b_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_b_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_b_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
   xlabel(1 "o_declare"  1 "o_declare"  1 "o_declare" ///
         4 "y_declare" 4 "y_declare" 4 "y_declare"  ///
		 7 "b_declare"  7 "b_declare"  7 "b_declare" ///
		 10 "o_terminate"  10 "o_terminate"  10"o_terminate" ///
		 13 "y_terminate" 13 "y_terminate" 13 "y_terminate"  ///
		 16 "b_terminate"  16 "b_terminate"  16 "b_terminate" , angle(-30)) ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(8.5, lwidth(vthin) lpattern(shortdash) lcolor(teal)) ///
  ytitle("log(Pollutant) estimates", size(medium)) ///
  xtitle("Type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "PM" 4 "SO{sub:2}" 6 "NOx") row(1)) ///
  name(graphPM, replace)
  graph export "picture/Heterogeneous_polluted_area.png", replace as(png) name("graphPM") width(1600) height(1200)
 
 
clear all  


global name  o_up y_up b_up  o_down y_down b_down 
global  control temperature AQI_l24
global y  lnPM_A lnSO2_A lnNOx_A 
local replace replace
foreach a in $name{
		
		use "data/data1.dta", replace
		keep if `a'_level!=.	
		keep if pollutant_day <= 5
		foreach i in $y{
			reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster site)  resid(re`i')
			rdrobust re`i' `a'_id , c(0) p(2) q(3)  kernel(triangular)  masspoints(off)
			estimates store  re_`a'_`i'
		}
		
	}
	

**Figure S28 RD estimates for plants' emission for non-polluted area

coefplot ///
  (re_o_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_o_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_o_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_y_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_y_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_y_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_b_up_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_b_up_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_b_up_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_o_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_o_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_o_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_y_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_y_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_y_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  (re_b_down_lnPM_A,  label("PM") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_b_down_lnSO2_A,  label("SO2") offset(-1)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_b_down_lnNOx_A,  label("NOx") offset(-1.75)  pstyle(p12) msymbol(d)  msize(*1.4)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
   xlabel(1 "o_declare"  1 "o_declare"  1 "o_declare" ///
         4 "y_declare" 4 "y_declare" 4 "y_declare"  ///
		 7 "b_declare"  7 "b_declare"  7 "b_declare" ///
		 10 "o_terminate"  10 "o_terminate"  10"o_terminate" ///
		 13 "y_terminate" 13 "y_terminate" 13 "y_terminate"  ///
		 16 "b_terminate"  16 "b_terminate"  16 "b_terminate" , angle(-30)) ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(8.5, lwidth(vthin) lpattern(shortdash) lcolor(teal)) ///
  ytitle("log(Pollutant) estimates", size(medium)) ///
  xtitle("Type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "PM" 4 "SO{sub:2}" 6 "NOx") row(1)) ///
  name(graphPM, replace)
  graph export "picture/Heterogeneous_non-polluted_area.png", replace as(png) name("graphPM") width(1600) height(1200)
  
  
  
**Figure S29 RDiT estimates for plant emission before 2018

clear all  

global name o_up  y_up o_down y_down  
global  control temperature air_pressure wind_speed visibility_distance AQI_l24
global y  lnPM_A lnSO2_A lnNOx_A 
local replace replace
foreach a in $name{
	use "data/data1.dta", replace
	keep if `a'_level!=. & year <2018
	foreach i in $y{
		reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster enterprise)  resid(re`i')
		rdrobust re`i' `a'_id , c(0) p(2) q(3)  kernel(triangular)  masspoints(off)
		estimates store  re_`a'_`i'
	}
}



coefplot ///
  (re_o_up_lnPM_A,  label("PM") offset(-0.25) msymbol(o)   msize(*1.6) pstyle(p1)) ///
  (re_o_up_lnSO2_A,  label("SO2") offset(-1) msymbol(s)   msize(*1.6) pstyle(p9)) ///
  (re_o_up_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d)   msize(*1.6) pstyle(p12)) ///
  (re_y_up_lnPM_A,  label("PM") offset(-0.25) msymbol(o)   msize(*1.6) pstyle(p1)) ///
  (re_y_up_lnSO2_A,  label("SO2") offset(-1) msymbol(s)   msize(*1.6) pstyle(p9)) ///
  (re_y_up_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d)   msize(*1.6) pstyle(p12)) ///
  (re_o_down_lnPM_A,  label("PM") offset(-0.25) msymbol(o)   msize(*1.6) pstyle(p1)) ///
  (re_o_down_lnSO2_A,  label("SO2") offset(-1) msymbol(s)   msize(*1.6) pstyle(p9)) ///
  (re_o_down_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d)   msize(*1.6) pstyle(p12)) ///
  (re_y_down_lnPM_A,  label("PM") offset(-0.25) msymbol(o)   msize(*1.6) pstyle(p1)) ///
  (re_y_down_lnSO2_A,  label("SO2") offset(-1) msymbol(s)   msize(*1.6) pstyle(p9)) ///
  (re_y_down_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d)   msize(*1.6) pstyle(p12)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
  xlabel(1 "o_activate"  1 "o_activate"  1 "o_activate" ///
         4 "y_activate" 4 "y_activate" 4 "y_activate"  ///
		 7 "o_terminate"  7 "o_terminate"  7"o_terminate" ///
		 10 "y_terminate" 10 "y_terminate" 10 "y_terminate" ) ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(5.5, lwidth(vthin) lpattern(shortdash) lcolor(teal)) ///
  ytitle("log(Pollutant) estimates", size(medium)) ///
  xtitle("Type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "PM" 4 "SO{sub:2}" 6 "NOx") row(1)) ///
  name(graphPM, replace)
  graph export "picture/fig_s29.png", replace as(png) name("graphPM") width(1600) height(1200)


**Figure S30 RDiT estimates for plant emission after 2018 (include 2018)


clear all  

global name o_up  y_up o_down y_down  
global  control temperature air_pressure wind_speed visibility_distance AQI_l24
global y  lnPM_A lnSO2_A lnNOx_A 
local replace replace
foreach a in $name{
	use "data/data1.dta", replace
	keep if `a'_level!=. & year >=2018
	foreach i in $y{
		reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster enterprise)  resid(re`i')
		rdrobust re`i' `a'_id , c(0) p(2) q(3)  kernel(triangular)  masspoints(off)
		estimates store  re_`a'_`i'
	}
}



coefplot ///
  (re_o_up_lnPM_A,  label("PM") offset(-0.25) msymbol(o)   msize(*1.6) pstyle(p1)) ///
  (re_o_up_lnSO2_A,  label("SO2") offset(-1) msymbol(s)   msize(*1.6) pstyle(p9)) ///
  (re_o_up_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d)   msize(*1.6) pstyle(p12)) ///
  (re_y_up_lnPM_A,  label("PM") offset(-0.25) msymbol(o)   msize(*1.6) pstyle(p1)) ///
  (re_y_up_lnSO2_A,  label("SO2") offset(-1) msymbol(s)   msize(*1.6) pstyle(p9)) ///
  (re_y_up_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d)   msize(*1.6) pstyle(p12)) ///
  (re_o_down_lnPM_A,  label("PM") offset(-0.25) msymbol(o)   msize(*1.6) pstyle(p1)) ///
  (re_o_down_lnSO2_A,  label("SO2") offset(-1) msymbol(s)   msize(*1.6) pstyle(p9)) ///
  (re_o_down_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d)   msize(*1.6) pstyle(p12)) ///
  (re_y_down_lnPM_A,  label("PM") offset(-0.25) msymbol(o)   msize(*1.6) pstyle(p1)) ///
  (re_y_down_lnSO2_A,  label("SO2") offset(-1) msymbol(s)   msize(*1.6) pstyle(p9)) ///
  (re_y_down_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d)   msize(*1.6) pstyle(p12)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
  xlabel(1 "o_activate"  1 "o_activate"  1 "o_activate" ///
         4 "y_activate" 4 "y_activate" 4 "y_activate"  ///
		 7 "o_terminate"  7 "o_terminate"  7"o_terminate" ///
		 10 "y_terminate" 10 "y_terminate" 10 "y_terminate" ) ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(5.5, lwidth(vthin) lpattern(shortdash) lcolor(teal)) ///
  ytitle("log(Pollutant) estimates", size(medium)) ///
  xtitle("Type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "PM" 4 "SO{sub:2}" 6 "NOx") row(1)) ///
  name(graphPM, replace)
  graph export "picture/fig_s30.png", replace as(png) name("graphPM") width(1600) height(1200)

  

**Figure S31 RDiT estimates for plant emission in 2018 and 2019


clear all  

global name o_up  y_up o_down y_down  
global  control temperature air_pressure wind_speed visibility_distance AQI_l24
global y  lnPM_A lnSO2_A lnNOx_A 
local replace replace
foreach a in $name{
	use "data/data1.dta", replace
	keep if `a'_level!=. & year < 2020 & year >=2019
	foreach i in $y{
		reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster enterprise)  resid(re`i')
		rdrobust re`i' `a'_id , c(0) p(2) q(3)  kernel(triangular)  masspoints(off)
		estimates store  re_`a'_`i'
	}
}



coefplot ///
  (re_o_up_lnPM_A,  label("PM") offset(-0.25) msymbol(o)   msize(*1.6) pstyle(p1)) ///
  (re_o_up_lnSO2_A,  label("SO2") offset(-1) msymbol(s)   msize(*1.6) pstyle(p9)) ///
  (re_o_up_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d)   msize(*1.6) pstyle(p12)) ///
  (re_y_up_lnPM_A,  label("PM") offset(-0.25) msymbol(o)   msize(*1.6) pstyle(p1)) ///
  (re_y_up_lnSO2_A,  label("SO2") offset(-1) msymbol(s)   msize(*1.6) pstyle(p9)) ///
  (re_y_up_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d)   msize(*1.6) pstyle(p12)) ///
  (re_o_down_lnPM_A,  label("PM") offset(-0.25) msymbol(o)   msize(*1.6) pstyle(p1)) ///
  (re_o_down_lnSO2_A,  label("SO2") offset(-1) msymbol(s)   msize(*1.6) pstyle(p9)) ///
  (re_o_down_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d)   msize(*1.6) pstyle(p12)) ///
  (re_y_down_lnPM_A,  label("PM") offset(-0.25) msymbol(o)   msize(*1.6) pstyle(p1)) ///
  (re_y_down_lnSO2_A,  label("SO2") offset(-1) msymbol(s)   msize(*1.6) pstyle(p9)) ///
  (re_y_down_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d)   msize(*1.6) pstyle(p12)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
  xlabel(1 "o_activate"  1 "o_activate"  1 "o_activate" ///
         4 "y_activate" 4 "y_activate" 4 "y_activate"  ///
		 7 "o_terminate"  7 "o_terminate"  7"o_terminate" ///
		 10 "y_terminate" 10 "y_terminate" 10 "y_terminate" ) ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(5.5, lwidth(vthin) lpattern(shortdash) lcolor(teal)) ///
  ytitle("log(Pollutant) estimates", size(medium)) ///
  xtitle("Type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "PM" 4 "SO{sub:2}" 6 "NOx") row(1)) ///
  name(graphPM, replace)
  graph export "picture/fig_s31.png", replace as(png) name("graphPM") width(1600) height(1200)



**Figure S32 RDiT estimates for plant emission in 2020

clear all  

global name o_up  y_up o_down y_down  
global  control temperature air_pressure wind_speed visibility_distance AQI_l24
global y  lnPM_A lnSO2_A lnNOx_A 
local replace replace
foreach a in $name{
	use "data/data1.dta", replace
	keep if `a'_level!=. & year == 2020
	foreach i in $y{
		reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster enterprise)  resid(re`i')
		rdrobust re`i' `a'_id , c(0) p(2) q(3)  kernel(triangular)  masspoints(off)
		estimates store  re_`a'_`i'
	}
}



coefplot ///
  (re_o_up_lnPM_A,  label("PM") offset(-0.25) msymbol(o)   msize(*1.6) pstyle(p1)) ///
  (re_o_up_lnSO2_A,  label("SO2") offset(-1) msymbol(s)   msize(*1.6) pstyle(p9)) ///
  (re_o_up_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d)   msize(*1.6) pstyle(p12)) ///
  (re_y_up_lnPM_A,  label("PM") offset(-0.25) msymbol(o)   msize(*1.6) pstyle(p1)) ///
  (re_y_up_lnSO2_A,  label("SO2") offset(-1) msymbol(s)   msize(*1.6) pstyle(p9)) ///
  (re_y_up_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d)   msize(*1.6) pstyle(p12)) ///
  (re_o_down_lnPM_A,  label("PM") offset(-0.25) msymbol(o)   msize(*1.6) pstyle(p1)) ///
  (re_o_down_lnSO2_A,  label("SO2") offset(-1) msymbol(s)   msize(*1.6) pstyle(p9)) ///
  (re_o_down_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d)   msize(*1.6) pstyle(p12)) ///
  (re_y_down_lnPM_A,  label("PM") offset(-0.25) msymbol(o)   msize(*1.6) pstyle(p1)) ///
  (re_y_down_lnSO2_A,  label("SO2") offset(-1) msymbol(s)   msize(*1.6) pstyle(p9)) ///
  (re_y_down_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d)   msize(*1.6) pstyle(p12)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
  xlabel(1 "o_activate"  1 "o_activate"  1 "o_activate" ///
         4 "y_activate" 4 "y_activate" 4 "y_activate"  ///
		 7 "o_terminate"  7 "o_terminate"  7"o_terminate" ///
		 10 "y_terminate" 10 "y_terminate" 10 "y_terminate" ) ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(5.5, lwidth(vthin) lpattern(shortdash) lcolor(teal)) ///
  ytitle("log(Pollutant) estimates", size(medium)) ///
  xtitle("Type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "PM" 4 "SO{sub:2}" 6 "NOx") row(1)) ///
  name(graphPM, replace)
  graph export "picture/fig_s32.png", replace as(png) name("graphPM") width(1600) height(1200)
 

*==============================================================================*
**Figure S33-S38   D Analyses of plants behavior under AQAs*********************
*==============================================================================* 
 
**Figure S33 Inspection under different alert level

use "data/data3.dta", replace

gen hour = hh(time) 
gen hour_type = 0 
replace hour_type = 1 if hour >= 8 & hour <=18

keep if alert != "0"

gen alert_type = 1
replace alert_type = 0 if  r_up_id !=. | o_up_id !=. | y_up_id !=. | b_up_id !=. | r_down_id !=. | o_down_id !=. | y_down_id !=. | b_down_id !=.

keep if alert_type == 0
keep alert hour_type enforce

collapse (sum) enforce, by (alert hour_type)

keep if alert == "2" | alert == "3" 

replace alert = "Orange level" if alert == "2"
replace alert = "yellow level" if alert == "3"

gen hour_type1 = "Daytime" 
replace hour_type1 = "Nighttime" if hour_type == 0


graph bar (sum) enforce,over(hour_type1) over(alert)  asyvars ///
	bargap(15) /// 
    ytitle("Inspection")
		
graph export "picture/fig_s33.png", replace as(png)  width(1500) height(1100)
 
 
**Figure S34 Plants' emission under environment non-inspection and inspection
**Figure S34(a)
clear all  

global name o_up  y_up o_down y_down  
global  control temperature air_pressure wind_speed visibility_distance AQI_l24
global y  lnPM_A lnSO2_A lnNOx_A 
local replace replace
foreach a in $name{
	use "data/data1.dta", replace
	keep if `a'_level!=. & year >=2018 & enforcement == 0
	foreach i in $y{
		reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster enterprise)  resid(re`i')
		rdrobust re`i' `a'_id , c(0) p(2) q(3)  kernel(triangular)  masspoints(off)
		estimates store  re_`a'_`i'
	}
}



coefplot ///
  (re_o_up_lnPM_A,  label("PM") offset(-0.25) msymbol(o)   msize(*1.6) pstyle(p1)) ///
  (re_o_up_lnSO2_A,  label("SO2") offset(-1) msymbol(s)   msize(*1.6) pstyle(p9)) ///
  (re_o_up_lnNOx_A,  label("NOx") offset(-1.75)  msymbol(d) msize(*1.6) pstyle(p12)) ///
  (re_y_up_lnPM_A,  label("PM") offset(-0.25) msymbol(o) msize(*1.6)  pstyle(p1)) ///
  (re_y_up_lnSO2_A,  label("SO2") offset(-1) msymbol(s) msize(*1.6)  pstyle(p9)) ///
  (re_y_up_lnNOx_A,  label("NOx") offset(-1.75)  msymbol(d) msize(*1.6) pstyle(p12)) ///
  (re_o_down_lnPM_A,  label("PM") offset(-0.25) msymbol(o) msize(*1.6) pstyle(p1)) ///
  (re_o_down_lnSO2_A,  label("SO2") offset(-1) msymbol(s) msize(*1.6) pstyle(p9)) ///
  (re_o_down_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d) msize(*1.6) pstyle(p12)) ///
  (re_y_down_lnPM_A,  label("PM") offset(-0.25) msymbol(o) msize(*1.6) pstyle(p1)) ///
  (re_y_down_lnSO2_A,  label("SO2") offset(-1) msymbol(s) msize(*1.6) pstyle(p9)) ///
  (re_y_down_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d) msize(*1.6) pstyle(p12)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
  xlabel(1 "o_activate"  1 "o_activate"  1 "o_activate" ///
         4 "y_activate" 4 "y_activate" 4 "y_activate"  ///
		 7 "o_terminate"  7 "o_terminate"  7"o_terminate" ///
		 10 "y_terminate" 10 "y_terminate" 10 "y_terminate" ) ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(5.5, lwidth(vthin) lpattern(shortdash) lcolor(teal)) ///
  ytitle("log(Pollutant) estimates", size(medium)) ///
  xtitle("Type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "PM" 4 "SO{sub:2}" 6 "NOx") row(1)) ///
  name(graphPM, replace)
  graph export "picture/fig_s34_a.png", replace as(png) name("graphPM") width(1600) height(1200)
  
  
**Figure S34(b)
  
clear all  

global name o_up  y_up o_down y_down  
global  control temperature air_pressure wind_speed visibility_distance AQI_l24
global y  lnPM_A lnSO2_A lnNOx_A 
local replace replace
foreach a in $name{
	use "data/data1.dta", replace
	keep if `a'_level!=. & year >=2018 & enforcement == 1
	foreach i in $y{
		reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster enterprise)  resid(re`i')
		rdrobust re`i' `a'_id , c(0) p(2) q(3)  kernel(triangular)  masspoints(off)
		estimates store  re_`a'_`i'
	}
}



coefplot ///
  (re_o_up_lnPM_A,  label("PM") offset(-0.25) msymbol(o)   msize(*1.6) pstyle(p1)) ///
  (re_o_up_lnSO2_A,  label("SO2") offset(-1) msymbol(s)   msize(*1.6) pstyle(p9)) ///
  (re_o_up_lnNOx_A,  label("NOx") offset(-1.75)  msymbol(d) msize(*1.6) pstyle(p12)) ///
  (re_y_up_lnPM_A,  label("PM") offset(-0.25) msymbol(o) msize(*1.6)  pstyle(p1)) ///
  (re_y_up_lnSO2_A,  label("SO2") offset(-1) msymbol(s) msize(*1.6)  pstyle(p9)) ///
  (re_y_up_lnNOx_A,  label("NOx") offset(-1.75)  msymbol(d) msize(*1.6) pstyle(p12)) ///
  (re_o_down_lnPM_A,  label("PM") offset(-0.25) msymbol(o) msize(*1.6) pstyle(p1)) ///
  (re_o_down_lnSO2_A,  label("SO2") offset(-1) msymbol(s) msize(*1.6) pstyle(p9)) ///
  (re_o_down_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d) msize(*1.6) pstyle(p12)) ///
  (re_y_down_lnPM_A,  label("PM") offset(-0.25) msymbol(o) msize(*1.6) pstyle(p1)) ///
  (re_y_down_lnSO2_A,  label("SO2") offset(-1) msymbol(s) msize(*1.6) pstyle(p9)) ///
  (re_y_down_lnNOx_A,  label("NOx") offset(-1.75) msymbol(d) msize(*1.6) pstyle(p12)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
  xlabel(1 "o_activate"  1 "o_activate"  1 "o_activate" ///
         4 "y_activate" 4 "y_activate" 4 "y_activate"  ///
		 7 "o_terminate"  7 "o_terminate"  7"o_terminate" ///
		 10 "y_terminate" 10 "y_terminate" 10 "y_terminate" ) ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(5.5, lwidth(vthin) lpattern(shortdash) lcolor(teal)) ///
  ytitle("log(Pollutant) estimates", size(medium)) ///
  xtitle("Type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "PM" 4 "SO{sub:2}" 6 "NOx") row(1)) ///
  name(graphPM, replace)
  graph export "picture/fig_s34_b.png", replace as(png) name("graphPM") width(1600) height(1200)
  
**Figure S34 Plants' concentration under environment non-inspection and inspection
**Figure S35(a)  

clear all  

global name o_up  y_up o_down y_down  
global  control temperature air_pressure wind_speed visibility_distance AQI_l24
global y  lnPM_C lnSO2_C lnNOx_C 
local replace replace
foreach a in $name{
	use "data/data1.dta", replace
	keep if `a'_level!=. & year >=2018 & enforcement == 0
	foreach i in $y{
		reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster enterprise)  resid(re`i')
		rdrobust re`i' `a'_id , c(0) p(2) q(3)  kernel(triangular)  masspoints(off)
		estimates store  re_`a'_`i'
	}
}



coefplot ///
  (re_o_up_lnPM_C,  label("PM") offset(-0.25) msymbol(o)   msize(*1.6) pstyle(p1)) ///
  (re_o_up_lnSO2_C,  label("SO2") offset(-1) msymbol(s)   msize(*1.6) pstyle(p9)) ///
  (re_o_up_lnNOx_C,  label("NOx") offset(-1.75)  msymbol(d) msize(*1.6) pstyle(p12)) ///
  (re_y_up_lnPM_C,  label("PM") offset(-0.25) msymbol(o) msize(*1.6)  pstyle(p1)) ///
  (re_y_up_lnSO2_C,  label("SO2") offset(-1) msymbol(s) msize(*1.6)  pstyle(p9)) ///
  (re_y_up_lnNOx_C,  label("NOx") offset(-1.75)  msymbol(d) msize(*1.6) pstyle(p12)) ///
  (re_o_down_lnPM_C,  label("PM") offset(-0.25) msymbol(o) msize(*1.6) pstyle(p1)) ///
  (re_o_down_lnSO2_C,  label("SO2") offset(-1) msymbol(s) msize(*1.6) pstyle(p9)) ///
  (re_o_down_lnNOx_C,  label("NOx") offset(-1.75) msymbol(d) msize(*1.6) pstyle(p12)) ///
  (re_y_down_lnPM_C,  label("PM") offset(-0.25) msymbol(o) msize(*1.6) pstyle(p1)) ///
  (re_y_down_lnSO2_C,  label("SO2") offset(-1) msymbol(s) msize(*1.6) pstyle(p9)) ///
  (re_y_down_lnNOx_C,  label("NOx") offset(-1.75) msymbol(d) msize(*1.6) pstyle(p12)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
  xlabel(1 "o_activate"  1 "o_activate"  1 "o_activate" ///
         4 "y_activate" 4 "y_activate" 4 "y_activate"  ///
		 7 "o_terminate"  7 "o_terminate"  7"o_terminate" ///
		 10 "y_terminate" 10 "y_terminate" 10 "y_terminate" ) ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(5.5, lwidth(vthin) lpattern(shortdash) lcolor(teal)) ///
  ytitle("log(Pollutant) estimates", size(medium)) ///
  xtitle("Type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "PM" 4 "SO{sub:2}" 6 "NOx") row(1)) ///
  name(graphPM, replace)
  graph export "picture/fig_s35_a.png", replace as(png) name("graphPM") width(1600) height(1200)
  

**Figure S35(b)

clear all  

global name o_up  y_up o_down y_down  
global  control temperature air_pressure wind_speed visibility_distance AQI_l24
global y  lnPM_C lnSO2_C lnNOx_C 
local replace replace
foreach a in $name{
	use "data/data1.dta", replace
	keep if `a'_level!=. & year >=2018 & enforcement == 1
	foreach i in $y{
		reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster enterprise)  resid(re`i')
		rdrobust re`i' `a'_id , c(0) p(2) q(3)  kernel(triangular)  masspoints(off)
		estimates store  re_`a'_`i'
	}
}



coefplot ///
  (re_o_up_lnPM_C,  label("PM") offset(-0.25) msymbol(o)   msize(*1.6) pstyle(p1)) ///
  (re_o_up_lnSO2_C,  label("SO2") offset(-1) msymbol(s)   msize(*1.6) pstyle(p9)) ///
  (re_o_up_lnNOx_C,  label("NOx") offset(-1.75)  msymbol(d) msize(*1.6) pstyle(p12)) ///
  (re_y_up_lnPM_C,  label("PM") offset(-0.25) msymbol(o) msize(*1.6)  pstyle(p1)) ///
  (re_y_up_lnSO2_C,  label("SO2") offset(-1) msymbol(s) msize(*1.6)  pstyle(p9)) ///
  (re_y_up_lnNOx_C,  label("NOx") offset(-1.75)  msymbol(d) msize(*1.6) pstyle(p12)) ///
  (re_o_down_lnPM_C,  label("PM") offset(-0.25) msymbol(o) msize(*1.6) pstyle(p1)) ///
  (re_o_down_lnSO2_C,  label("SO2") offset(-1) msymbol(s) msize(*1.6) pstyle(p9)) ///
  (re_o_down_lnNOx_C,  label("NOx") offset(-1.75) msymbol(d) msize(*1.6) pstyle(p12)) ///
  (re_y_down_lnPM_C,  label("PM") offset(-0.25) msymbol(o) msize(*1.6) pstyle(p1)) ///
  (re_y_down_lnSO2_C,  label("SO2") offset(-1) msymbol(s) msize(*1.6) pstyle(p9)) ///
  (re_y_down_lnNOx_C,  label("NOx") offset(-1.75) msymbol(d) msize(*1.6) pstyle(p12)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
  xlabel(1 "o_activate"  1 "o_activate"  1 "o_activate" ///
         4 "y_activate" 4 "y_activate" 4 "y_activate"  ///
		 7 "o_terminate"  7 "o_terminate"  7"o_terminate" ///
		 10 "y_terminate" 10 "y_terminate" 10 "y_terminate" ) ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(5.5, lwidth(vthin) lpattern(shortdash) lcolor(teal)) ///
  ytitle("log(Pollutant) estimates", size(medium)) ///
  xtitle("Type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "PM" 4 "SO{sub:2}" 6 "NOx") row(1)) ///
  name(graphPM, replace)
  graph export "picture/fig_s35_b.png", replace as(png) name("graphPM") width(1600) height(1200)
  
  

**Figure S36 Plants' gas flow under environment non-inspection and inspection
clear all  

global name o_up  y_up o_down y_down  
global  control temperature air_pressure wind_speed visibility_distance AQI_l24
global y  lnflow 
local replace replace
foreach a in $name{
	use "data/data1.dta", replace
	keep if `a'_level!=. & year >=2018 & enforcement == 1
	foreach i in $y{
		reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster enterprise)  resid(re`i')
		rdrobust re`i' `a'_id , c(0) p(2) q(3)  kernel(triangular)  masspoints(off)
		estimates store  re_`a'_`i'_1
	}
}

foreach a in $name{
	use "data/data1.dta", replace
	keep if `a'_level!=. & year >=2018 & enforcement == 0
	foreach i in $y{
		reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster enterprise)  resid(re`i')
		rdrobust re`i' `a'_id , c(0) p(2) q(3)  kernel(triangular)  masspoints(off)
		estimates store  re_`a'_`i'_0
	}
}




coefplot ///
  (re_o_up_lnflow_0,  label("Non-inspection") offset(-0.25) msymbol(o)   msize(*1.6) pstyle(p1)) ///
  (re_o_up_lnflow_1,  label("Inspection") offset(-1) msymbol(s)   msize(*1.6) pstyle(p9)) ///
  (re_y_up_lnflow_0,  label("Non-inspection") offset(-0.25) msymbol(o) msize(*1.6)  pstyle(p1)) ///
  (re_y_up_lnflow_1,  label("Inspection") offset(-1) msymbol(s) msize(*1.6)  pstyle(p9)) ///
  (re_o_down_lnflow_0,  label("Non-inspection") offset(-0.25) msymbol(o) msize(*1.6) pstyle(p1)) ///
  (re_o_down_lnflow_1,  label("Inspection") offset(-1) msymbol(s) msize(*1.6) pstyle(p9)) ///
  (re_y_down_lnflow_0,  label("Non-inspection") offset(-0.25) msymbol(o) msize(*1.6) pstyle(p1)) ///
  (re_y_down_lnflow_1,  label("Inspection") offset(-1) msymbol(s) msize(*1.6) pstyle(p9)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
  xlabel(1 "o_activate"  1 "o_activate" ///
         3 "y_activate" 3 "y_activate"  ///
		 5 "o_terminate"  5 "o_terminate" ///
		 7 "y_terminate" 7 "y_terminate"  ) ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(4, lwidth(vthin) lpattern(shortdash) lcolor(teal)) ///
  ytitle("log(Flow) estimates", size(medium)) ///
  xtitle("Type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "Non-inspection" 4 "Inspection") row(1)) ///
  name(graphPM, replace)
  graph export "picturefig_s36.png", replace as(png) name("graphPM") width(1600) height(1200)
  
  
  
 
 
**Figure S37 Event-study estimates for plants' concentration at different level alerts


global name  o_up  
global  control temperature air_pressure wind_speed visibility_distance
global y  lnPM_C lnSO2_C lnNOx_C
local replace replace
foreach a in $name{
	use "data/data2.dta", replace
	keep if `a'_level!=.	
	
	gen pre9 = ((`a'_id > -108) & (`a'_id <= -96) & (if_alert == 1))
	gen pre8 = ((`a'_id > -96) & (`a'_id <= -84) & (if_alert == 1))
	gen pre7 = ((`a'_id > -84) & (`a'_id <= -72) & (if_alert == 1))
	gen pre6 = ((`a'_id > -72) & (`a'_id <= -60) & (if_alert == 1))
	gen pre5 = ((`a'_id > -60) & (`a'_id <= -48) & (if_alert == 1))
	gen pre4 = ((`a'_id > -48) & (`a'_id <= -36) & (if_alert == 1))
	gen pre3 = ((`a'_id > -36) & (`a'_id <= -24) & (if_alert == 1))
	gen pre2 = ((`a'_id > -24) & (`a'_id <= -12) & (if_alert == 1))
	gen pre1 = ((`a'_id > -12) & (`a'_id <= 0) & (if_alert == 1))
	gen current = ((`a'_id > -0) & (`a'_id <= 12) & (if_alert == 1))
	gen post1 = ((`a'_id > 12) & (`a'_id <= 24) & (if_alert == 1))
	gen post2 = ((`a'_id > 24) & (`a'_id <= 36) & (if_alert == 1))
	gen post3 = ((`a'_id > 36) & (`a'_id <= 48) & (if_alert == 1))
	gen post4 = ((`a'_id > 48) & (`a'_id <= 60) & (if_alert == 1))
	gen post5 = ((`a'_id > 60) & (`a'_id <= 72) & (if_alert == 1))
	gen post6 = ((`a'_id > 72) & (`a'_id <= 84) & (if_alert == 1))
	
	drop pre1 //

	foreach i in $y{
		local i_no_C = subinstr("`i'", "_C", "", .)
		local i_sub = subinstr("`i_no_C'", "2", "₂", .)
		local i_sub = "`i_sub' Concentration"
		reghdfe `i' pre* current post* $control, absorb(enterprise year month weekday) vce(cluster enterprise)
		coefplot, baselevels ///
		keep(pre* current post*) ///
		vertical ///
		coeflabels(  /// 
		pre9 = "-9" ///
		pre8 = "-8" ///
		pre7 = "-7" ///
		pre6 = "-6" ///
		pre5 = "-5" ///
		pre4 = "-4" ///
		pre3 = "-3" ///
		pre2 = "-2" ///
		current = "0" ///
		post1 = "1" ///
		post2 = "2" ///
		post3 = "3" ///
		post4 = "4" ///
		post5 = "5" ///
		post6 = "6" ) ///
		yline(0, lcolor(dkblue*0.8)) ///
		xline(9, lwidth(0.8) lpattern(shortdash) lcolor(teal)) ///
		ylabel(,labsize(*1.2)) xlabel(,labsize(*1.2)) ///
		ytitle("`i_sub'", size(medium)) ///
		xtitle("Days before/after AQA activate", size(medium)) ///
		addplot(line @b @at) ///
		ciopts(lpattern(dash) recast(rcap) msize(medium)) ///
		scheme(s1mono) ///
		name(graphPM, replace)
		graph save "picture/origin/q-event_`a'`i'.gph",  replace
		
	}
}




global name   y_up 
global  control temperature air_pressure wind_speed visibility_distance
global y  lnPM_C lnSO2_C lnNOx_C
local replace replace
foreach a in $name{
	use "data/data2.dta", replace
	keep if `a'_level!=.	

	gen pre9 = ((`a'_id > -108) & (`a'_id <= -96) & (if_alert == 1))
	gen pre8 = ((`a'_id > -96) & (`a'_id <= -84) & (if_alert == 1))
	gen pre7 = ((`a'_id > -84) & (`a'_id <= -72) & (if_alert == 1))
	gen pre6 = ((`a'_id > -72) & (`a'_id <= -60) & (if_alert == 1))
	gen pre5 = ((`a'_id > -60) & (`a'_id <= -48) & (if_alert == 1))
	gen pre4 = ((`a'_id > -48) & (`a'_id <= -36) & (if_alert == 1))
	gen pre3 = ((`a'_id > -36) & (`a'_id <= -24) & (if_alert == 1))
	gen pre2 = ((`a'_id > -24) & (`a'_id <= -12) & (if_alert == 1))
	gen pre1 = ((`a'_id > -12) & (`a'_id <= 0) & (if_alert == 1))
	gen current = ((`a'_id > -0) & (`a'_id <= 12) & (if_alert == 1))
	gen post1 = ((`a'_id > 12) & (`a'_id <= 24) & (if_alert == 1))
	gen post2 = ((`a'_id > 24) & (`a'_id <= 36) & (if_alert == 1))
	gen post3 = ((`a'_id > 36) & (`a'_id <= 48) & (if_alert == 1))
	gen post4 = ((`a'_id > 48) & (`a'_id <= 60) & (if_alert == 1))
	gen post5 = ((`a'_id > 60) & (`a'_id <= 72) & (if_alert == 1))
	gen post6 = ((`a'_id > 72) & (`a'_id <= 84) & (if_alert == 1))
	
	drop pre1

	foreach i in $y{
		local i_no_C = subinstr("`i'", "_C", "", .)
		local i_sub = subinstr("`i_no_C'", "2", "₂", .)
		local i_sub = "`i_sub' Concentration"
		reghdfe `i' pre* current post* $control, absorb(enterprise year month weekday) vce(cluster enterprise)
		coefplot, baselevels ///
		keep(pre5 pre4 pre3 pre2 pre1 current post*) ///
		vertical ///
		coeflabels(  /// 
		pre9 = "-9" ///
		pre8 = "-8" ///
		pre7 = "-7" ///
		pre6 = "-6" ///
		pre5 = "-5" ///
		pre4 = "-4" ///
		pre3 = "-3" ///
		pre2 = "-2" ///
		current = "0" ///
		post1 = "1" ///
		post2 = "2" ///
		post3 = "3" ///
		post4 = "4" ///
		post5 = "5" ///
		post6 = "6" ) ///
		yline(0, lcolor(dkblue*0.8)) ///
		xline(5, lwidth(0.8) lpattern(shortdash) lcolor(teal)) ///
		ylabel(,labsize(*1.2)) xlabel(,labsize(*1.2)) ///
		ytitle("`i_sub'", size(medium)) ///
		xtitle("Days before/after AQA activate", size(medium)) ///
		addplot(line @b @at) ///
		ciopts(lpattern(dash) recast(rcap) msize(medium)) ///
		scheme(s1mono) ///
		name(graphPM, replace)
		graph save "picture/origin/q-event_`a'`i'.gph",  replace
		
	}
}


graph combine "picture/origin/q-event_o_uplnPM_C.gph" "picture/origin/q-event_o_uplnSO2_C.gph" "picture/origin/q-event_o_uplnNOx_C.gph" "picture/origin/q-event_y_uplnPM_C.gph" "picture/origin/q-event_y_uplnSO2_C.gph" "picture/origin/q-event_y_uplnNOx_C.gph" 

graph export "picture/figure_s37.png", replace as(png)  width(1800) height(1200)


***flow analysis
**Figure S38 Event-study estimates for plants' gas flu at different level alerts

global name  o_up   
global  control temperature air_pressure wind_speed visibility_distance 
global y  lnflow 
local replace replace
foreach a in $name{
	use "data/data2.dta", replace
	keep if `a'_level!=.	
	gen pre9 = ((`a'_id > -108) & (`a'_id <= -96) & (if_alert == 1))
	gen pre8 = ((`a'_id > -96) & (`a'_id <= -84) & (if_alert == 1))
	gen pre7 = ((`a'_id > -84) & (`a'_id <= -72) & (if_alert == 1))
	gen pre6 = ((`a'_id > -72) & (`a'_id <= -60) & (if_alert == 1))
	gen pre5 = ((`a'_id > -60) & (`a'_id <= -48) & (if_alert == 1))
	gen pre4 = ((`a'_id > -48) & (`a'_id <= -36) & (if_alert == 1))
	gen pre3 = ((`a'_id > -36) & (`a'_id <= -24) & (if_alert == 1))
	gen pre2 = ((`a'_id > -24) & (`a'_id <= -12) & (if_alert == 1))
	gen pre1 = ((`a'_id > -12) & (`a'_id <= 0) & (if_alert == 1))
	gen current = ((`a'_id > -0) & (`a'_id <= 12) & (if_alert == 1))
	gen post1 = ((`a'_id > 12) & (`a'_id <= 24) & (if_alert == 1))
	gen post2 = ((`a'_id > 24) & (`a'_id <= 36) & (if_alert == 1))
	gen post3 = ((`a'_id > 36) & (`a'_id <= 48) & (if_alert == 1))
	gen post4 = ((`a'_id > 48) & (`a'_id <= 60) & (if_alert == 1))
	gen post5 = ((`a'_id > 60) & (`a'_id <= 72) & (if_alert == 1))
	gen post6 = ((`a'_id > 72) & (`a'_id <= 84) & (if_alert == 1))
	
	
	drop pre1 
	
    local alert_level ""
    if "`a'" == "o_up" {
        local alert_level "orange-level"
    }
    else if "`a'" == "y_up" {
        local alert_level "yellow-level"
    }
    else if "`a'" == "b_up" {
        local alert_level "blue-level"
    }
	

	foreach i in $y{
		reghdfe `i' pre* current post* $control, absorb(enterprise year month weekday) vce(cluster enterprise)
		coefplot, baselevels ///
		keep(pre* current post*) ///
		vertical ///
		coeflabels(  /// 
		pre9 = "-9" ///
		pre8 = "-8" ///
		pre7 = "-7" ///
		pre6 = "-6" ///
		pre5 = "-5" ///
		pre4 = "-4" ///
		pre3 = "-3" ///
		pre2 = "-2" ///
		current = "0" ///
		post1 = "1" ///
		post2 = "2" ///
		post3 = "3" ///
		post4 = "4" ///
		post5 = "5" ///
		post6 = "6" ) ///
		yline(0, lcolor(dkblue*0.8)) ///
		xline(9, lwidth(0.8) lpattern(shortdash) lcolor(teal)) ///
		ylabel(,labsize(*1.2)) xlabel(,labsize(*1.2)) ///
		ytitle("log(Flow)", size(medium)) ///
		xtitle("Days before/after AQA activate""at `alert_level' alert", size(medium)) ///
		addplot(line @b @at) ///
		ciopts(lpattern(dash) recast(rcap) msize(medium)) ///
		scheme(s1mono) ///
		name(graphPM, replace)
		graph save "picture/origin/q-event_`a'`i'.gph",  replace
		
	}
}


global name  y_up 
global  control temperature air_pressure wind_speed visibility_distance 
global y  lnflow 
local replace replace
foreach a in $name{
	use "data/data2.dta", replace
	keep if `a'_level!=.	
	gen pre9 = ((`a'_id > -108) & (`a'_id <= -96) & (if_alert == 1))
	gen pre8 = ((`a'_id > -96) & (`a'_id <= -84) & (if_alert == 1))
	gen pre7 = ((`a'_id > -84) & (`a'_id <= -72) & (if_alert == 1))
	gen pre6 = ((`a'_id > -72) & (`a'_id <= -60) & (if_alert == 1))
	gen pre5 = ((`a'_id > -60) & (`a'_id <= -48) & (if_alert == 1))
	gen pre4 = ((`a'_id > -48) & (`a'_id <= -36) & (if_alert == 1))
	gen pre3 = ((`a'_id > -36) & (`a'_id <= -24) & (if_alert == 1))
	gen pre2 = ((`a'_id > -24) & (`a'_id <= -12) & (if_alert == 1))
	gen pre1 = ((`a'_id > -12) & (`a'_id <= 0) & (if_alert == 1))
	gen current = ((`a'_id > -0) & (`a'_id <= 12) & (if_alert == 1))
	gen post1 = ((`a'_id > 12) & (`a'_id <= 24) & (if_alert == 1))
	gen post2 = ((`a'_id > 24) & (`a'_id <= 36) & (if_alert == 1))
	gen post3 = ((`a'_id > 36) & (`a'_id <= 48) & (if_alert == 1))
	gen post4 = ((`a'_id > 48) & (`a'_id <= 60) & (if_alert == 1))
	gen post5 = ((`a'_id > 60) & (`a'_id <= 72) & (if_alert == 1))
	gen post6 = ((`a'_id > 72) & (`a'_id <= 84) & (if_alert == 1))
	
	
	drop pre1 
    local alert_level ""
    if "`a'" == "o_up" {
        local alert_level "orange-level"
    }
    else if "`a'" == "y_up" {
        local alert_level "yellow-level"
    }
    else if "`a'" == "b_up" {
        local alert_level "blue-level"
    }
	

	foreach i in $y{
		reghdfe `i' pre* current post* $control, absorb(enterprise year month weekday) vce(cluster enterprise)
		coefplot, baselevels ///
		keep(pre5 pre4 pre3 pre2 pre1 current post*) ///
		vertical ///
		coeflabels(  /// 
		pre9 = "-9" ///
		pre8 = "-8" ///
		pre7 = "-7" ///
		pre6 = "-6" ///
		pre5 = "-5" ///
		pre4 = "-4" ///
		pre3 = "-3" ///
		pre2 = "-2" ///
		current = "0" ///
		post1 = "1" ///
		post2 = "2" ///
		post3 = "3" ///
		post4 = "4" ///
		post5 = "5" ///
		post6 = "6" ) ///
		yline(0, lcolor(dkblue*0.8)) ///
		xline(5, lwidth(0.8) lpattern(shortdash) lcolor(teal)) ///
		ylabel(,labsize(*1.2)) xlabel(,labsize(*1.2)) ///
		ytitle("log(Flow)", size(medium)) ///
		xtitle("Days before/after AQA activate""at `alert_level' alert", size(medium)) ///
		addplot(line @b @at) ///
		ciopts(lpattern(dash) recast(rcap) msize(medium)) ///
		scheme(s1mono) ///
		name(graphPM, replace)
		graph save "picture/origin/q-event_`a'`i'.gph",  replace
		
	}
}


graph combine "picture/origin/q-event_o_uplnflow.gph"  "picture/origin/q-event_y_uplnflow.gph" 

graph export "picture/figure_s38.png", replace as(png)  width(1800) height(1200)


