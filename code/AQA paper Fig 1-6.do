

*==============================================================================*
*Fig.1. AQI and alert periods in Xi'an
*==============================================================================*

clear all
use "data/data1.dta", replace

keep if year <= 2020 & year >=2014
keep time date site AQI alert

twoway (scatter AQI date if site == "西安" & alert == "0", mcolor(gs8) msize(*0.4) msymbol(O)) ///
	   (scatter AQI date if site == "西安" & alert == "4", mcolor(blue) msize(*0.4) msymbol(s)) ///
	   (scatter AQI date if site == "西安" & alert == "3", mcolor(yellow) msize(*0.4) msymbol(D)) ///
	   (scatter AQI date if site == "西安" & alert == "2", mcolor(orange) msize(*0.4) msymbol(T)) ///
	   (scatter AQI date if site == "西安" & alert == "1", mcolor(red) msize(*0.4) msymbol(X)) , /// 
	   legend(order(1 "Normal-period" 2 "Blue-level" 3 "Yellow-levle" 4 "Orange-levle" 5 "Red-level") rows(1) col(5)) ///
       xtitle("Time") ytitle("AQI")  ///
       plotregion(margin(l=0 r=4 b=0 t=0))   
graph export "picture/picture-1.png", replace as(png)  width(1500) height(1100)



*==============================================================================*
*Fig.2. Cumulative number of AQAs hours in Guanzhong city
*==============================================================================*

clear all
use "data/data1.dta", replace

gen alert_01 = 1 
replace alert_01 = 0 if alert ==1  

keep if year <= 2020  &  alert_01 != 0

gen d = 1
collapse (sum) alert_hours = d, by(site year)

gen cities = ""
replace cities = "Baoji" if site == "宝鸡"
replace cities = "Tongcuan" if site == "铜川"
replace cities = "Weinan" if site == "渭南"
replace cities = "Xi'an" if site == "西安"
replace cities = "Xianyang" if site == "咸阳"

sort year cities
twoway  (scatter alert_hours year if cities == "Xi'an", mcolor(red) msymbol(O) msize(*1.5)) ///
        (scatter alert_hours year if cities == "Xianyang", mcolor(blue) msymbol(s) msize(*1.5)) ///
        (scatter alert_hours year if cities == "Weinan", mcolor(green) msymbol(D) msize(*1.5)) ///
        (scatter alert_hours year if cities == "Baoji", mcolor(orange) msymbol(T) msize(*1.5)) ///
        (scatter alert_hours year if cities == "Tongcuan", mcolor(purple) msymbol(X) msize(*1.5)) ///
        (line alert_hours year if cities == "Xi'an", lcolor(red) lwidth(*1.7)) ///
        (line alert_hours year if cities == "Xianyang", lcolor(blue) lwidth(*1.7)) ///
        (line alert_hours year if cities == "Weinan", lcolor(green) lwidth(*1.7)) ///
        (line alert_hours year if cities == "Baoji", lcolor(orange) lwidth(*1.7)) ///
        (line alert_hours year if cities == "Tongcuan", lcolor(purple) lwidth(*1.7)), ///
        legend(order(1 "Xi'an" 2 "Xianyang" 3 "Weinan" 4 "Baoji" 5 "Tongcuan") rows(1) col(5)) ///
        xtitle("Year") ///
		xlabel(2013(1)2020) ///
        ytitle("Alert Hours (h)") ///
		ylabel(0(500)1500, nogrid ) 
        
     			
graph export "picture/picture-2.png", replace as(png)  width(1500) height(1100)



*==============================================================================*
*Fig.3: RD plots for plants' emission under different alert level
*==============================================================================*


***Figure 3a: Orange level firm raw and residual pollutans

global  control temperature AQI_l24

global y lnPM_A lnSO2_A lnNOx_A 
 

use "data/data1.dta", replace
keep if o_up_level !=.	


foreach i in $y{
	
reghdfe `i'  $control  ,absorb(enterprise year month weekday) vce(cluster site) resid(e`i')


local i_no_A = subinstr("`i'", "_A", "", .)
local i_sub = subinstr("`i_no_A'", "2", "₂", .)

rdplot e`i' o_up_id if o_up_id <= 50& o_up_id >=-50 & year>=2013 & year<=2020, ///
               binselect(es)  c(0)  ci(95)   /// 
			   graph_options(ylabel(,labsize(*1.2)) xlabel(,labsize(*1.2)) ///
               ytitle("Residual - `i_sub'", size(medium))  ///
               xtitle("Hours before/after AQA declare", size(medium)) ///
			   xtick(-50(25)50) ///
			   legend(off)) ///
               graphregion(color(white))) ///
			   scheme(plotplainblind))
			   
graph save "picture/origin/q-o_up`i'.gph",  replace

 }




use "data/data1.dta", replace
keep if o_down_level !=.	
 

foreach i in $y{
	
reghdfe `i'   $control  ,absorb(enterprise year month weekday) vce(cluster site) resid(e`i')


local i_no_A = subinstr("`i'", "_A", "", .)
local i_sub = subinstr("`i_no_A'", "2", "₂", .)

rdplot e`i' o_down_id if o_down_id <= 50& o_down_id >=-50 & year>=2013 & year<=2020, ///
               binselect(es)  c(0)  ci(95)   /// 
			   graph_options(ylabel(,labsize(*1.2)) xlabel(,labsize(*1.2)) ///
               ytitle("Residual - `i_sub'", size(medium))  ///
               xtitle("Hours before/after AQA terminate", size(medium)) ///
			   xtick(-50(25)50) ///
			   legend(off)) ///
               graphregion(color(white))) ///
			   
graph save "picture/origin/q-o_down`i'.gph",  replace

}


graph combine "picture/origin/q-o_uplnPM_A.gph" "picture/origin/q-o_uplnSO2_A.gph" "picture/origin/q-o_uplnNOx_A.gph" "picture/origin/q-o_downlnPM_A.gph" "picture/origin/q-o_downlnSO2_A.gph" "picture/origin/q-o_downlnNOx_A.gph" 

     			
graph export "picture/q-o_level.png", replace as(png)  width(1800) height(1200)



***Figure 3b: Yellow level firm raw and residual pollutans

clear all  

global  control temperature AQI_l24

global y lnPM_A lnSO2_A lnNOx_A 
 

use "data/data1.dta", replace
keep if y_up_level !=.	
 

foreach i in $y{
	
reghdfe `i'  ,absorb(enterprise year month weekday) vce(cluster site) resid(e`i')


local i_ny_A = subinstr("`i'", "_A", "", .)
local i_sub = subinstr("`i_ny_A'", "2", "₂", .)

rdplot e`i' y_up_id if y_up_id <= 50& y_up_id >=-50 & year>=2013 & year<=2020, ///
               binselect(es)  c(0)  ci(95) nbins(4)  /// 
			   graph_options(ylabel(,labsize(*1.2)) xlabel(,labsize(*1.2)) ///
               ytitle("Residual - `i_sub'", size(medium))  ///
               xtitle("Hours before/after AQA declare", size(medium)) ///
			   xtick(-50(25)50) ///
			   legend(off)) ///
               graphregion(color(white))) ///
			   
graph save "picture/origin/q-y_up`i'.gph",  replace

 }




use "data/data1.dta", replace
keep if y_down_level !=.	
 

foreach i in $y{
	
reghdfe `i'  $control  ,absorb(enterprise year month weekday) vce(cluster site) resid(e`i')

local i_ny_A = subinstr("`i'", "_A", "", .)
local i_sub = subinstr("`i_ny_A'", "2", "₂", .)

rdplot e`i' y_down_id if y_down_id <= 50& y_down_id >=-50 & year>=2013 & year<=2020, ///
               binselect(es)  c(0)  ci(95)   /// 
			   graph_options(ylabel(,labsize(*1.2)) xlabel(,labsize(*1.2)) ///
               ytitle("Residual - `i_sub'", size(medium))  ///
               xtitle("Hours before/after AQA terminate", size(medium)) ///
			   xtick(-50(25)50) ///
			   legend(off)) ///
               graphregion(color(white))) ///
			   
graph save "picture/origin/q-y_down`i'.gph",  replace

}


graph combine "picture/origin/q-y_uplnPM_A.gph" "picture/origin/q-y_uplnSO2_A.gph" "picture/origin/q-y_uplnNOx_A.gph" "picture/origin/q-y_downlnPM_A.gph" "picture/origin/q-y_downlnSO2_A.gph" "picture/origin/q-y_downlnNOx_A.gph" 

     			
graph export "picture/q-y_level.png", replace as(png)  width(1800) height(1200)



***Figure 3c: Blue level firm raw and residual pollutans
clear all  

global  control temperature AQI_l24

global y lnPM_A lnSO2_A lnNOx_A 
 


use "data/data1.dta", replace
keep if b_up_level !=.	
 

foreach i in $y{
	
reghdfe `i' $control  ,absorb(enterprise year month weekday) vce(cluster site) resid(e`i')

local i_nb_A = subinstr("`i'", "_A", "", .)
local i_sub = subinstr("`i_nb_A'", "2", "₂", .)

rdplot e`i' b_up_id if b_up_id <= 50& b_up_id >=-50 & year>=2013 & year<=2020, ///
               binselect(es)  c(0)  ci(95)   /// 
			   graph_options(ylabel(,labsize(*1.2)) xlabel(,labsize(*1.2)) ///
               ytitle("Residual - `i_sub'", size(medium))  ///
               xtitle("Hours before/after AQA declare", size(medium)) ///
			   xtick(-50(25)50) ///
			   legend(off)) ///
               graphregion(color(white))) ///
			   
graph save "picture/origin/q-b_up`i'.gph",  replace

 }


	
use "data/data1.dta", replace
keep if b_down_level !=.	
 

foreach i in $y{
	
reghdfe `i'   $control  ,absorb(enterprise year month weekday) vce(cluster site) resid(e`i')

local i_nb_A = subinstr("`i'", "_A", "", .)
local i_sub = subinstr("`i_nb_A'", "2", "₂", .)

rdplot e`i' b_down_id if b_down_id <= 50& b_down_id >=-50 & year>=2013 & year<=2020, ///
               binselect(es)  c(0)  ci(95)   /// 
			   graph_options(ylabel(,labsize(*1.2)) xlabel(,labsize(*1.2)) ///
               ytitle("Residual - `i_sub'", size(medium))  ///
               xtitle("Hours before/after AQA terminate", size(medium)) ///
			   xtick(-50(25)50) ///
			   legend(off)) ///
               graphregion(color(white))) ///
			   
graph save "picture/origin/q-b_down`i'.gph",  replace

}


graph combine "picture/origin/q-b_uplnPM_A.gph" "picture/origin/q-b_uplnSO2_A.gph" "picture/origin/q-b_uplnNOx_A.gph" "picture/origin/q-b_downlnPM_A.gph" "picture/origin/q-b_downlnSO2_A.gph" "picture/origin/q-b_downlnNOx_A.gph" 

     			
graph export "picture/q-b_level.png", replace as(png)  width(1800) height(1200)


*==============================================================================*
*Fig.4 RD estimates for plants' emission at two-level AQAs
*==============================================================================*

clear all  

global name b_y_up y_o_up o_r_up y_r_up b_o_up r_o_down  y_b_down  o_y_down o_b_down //r_b_down的第二波循环是0,要单独运行
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
	
}


**Figure 4a:
coefplot ///
  (re_b_y_up_lnPM_A_1,  label("First Stage") offset(-0.25)  pstyle(p1)  msymbol(o)  msize(*1.4)) /// 
  (re_b_y_up_lnPM_A_2,  label("Second Stage") offset(-0.75)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_y_o_up_lnPM_A_1,  label("First Stage") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_y_o_up_lnPM_A_2,  label("Second Stage") offset(-0.75)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_o_r_up_lnPM_A_1,  label("First Stage") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_o_r_up_lnPM_A_2,  label("Second Stage") offset(-0.75)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_r_o_down_lnPM_A_1,  label("First Stage") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_r_o_down_lnPM_A_2,  label("Second Stage") offset(-0.75)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_o_b_down_lnPM_A_1,  label("First Stage") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_o_b_down_lnPM_A_2,  label("Second Stage") offset(-0.75)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_y_b_down_lnPM_A_1,  label("First Stage") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_y_b_down_lnPM_A_2,  label("Second Stage") offset(-0.75)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
  xlabel(1 "b_y_up" 1 "b_y_up" 3 "y_o_up" 3 "y_o_up"  5 "o_r_up"  5 "o_r_up" ///
         7 "r_o_down" 7 "r_o_down" 9 "o_b_down" 9 "o_b_down"  11 "y_b_down" 11 "y_b_down") ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(6, lwidth(vthin) lpattern(shortdash) lcolor(teal)) ///
  ytitle("log(PM) estimates", size(medium)) ///
  xtitle("Alert type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "First Stage" 4 "Second Stage")) ///
  name(graphPM, replace)
  graph export "picture/two_level_alert-PM.png", replace as(png) name("graphPM") width(1600) height(1200)

**Figure 4b:  
  
coefplot ///
  (re_b_y_up_lnSO2_A_1,  label("First Stage") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) /// 
  (re_b_y_up_lnSO2_A_2,  label("Second Stage") offset(-0.75)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_y_o_up_lnSO2_A_1,  label("First Stage") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_y_o_up_lnSO2_A_2,  label("Second Stage") offset(-0.75)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_o_r_up_lnSO2_A_1,  label("First Stage") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_o_r_up_lnSO2_A_2,  label("Second Stage") offset(-0.75)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_r_o_down_lnSO2_A_1,  label("First Stage") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_r_o_down_lnSO2_A_2,  label("Second Stage") offset(-0.75)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_o_b_down_lnSO2_A_1,  label("First Stage") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_o_b_down_lnSO2_A_2,  label("Second Stage") offset(-0.75)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_y_b_down_lnSO2_A_1,  label("First Stage") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_y_b_down_lnSO2_A_2,  label("Second Stage") offset(-0.75)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
 xlabel(1 "b_y_up" 1 "b_y_up" 3 "y_o_up" 3 "y_o_up"  5 "o_r_up"  5 "o_r_up" ///
         7 "r_o_down" 7 "r_o_down" 9 "o_b_down" 9 "o_b_down"  11 "y_b_down" 11 "y_b_down") ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(6, lwidth(vthin) lpattern(shortdash) lcolor(teal)) ///
  ytitle("log(SO{sub:2}) estimates", size(medium)) ///
  xtitle("Alert type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "First Stage" 4 "Second Stage") row(1)) ///
  name(graphSO2, replace)
  graph export "picture/two_level_alert-SO2.png", replace as(png) name("graphSO2") width(1600) height(1200)
  

**Figure 4c:

coefplot ///
  (re_b_y_up_lnNOx_A_1,  label("First Stage") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) /// 
  (re_b_y_up_lnNOx_A_2,  label("Second Stage") offset(-0.75)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_y_o_up_lnNOx_A_1,  label("First Stage") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_y_o_up_lnNOx_A_2,  label("Second Stage") offset(-0.75)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_o_r_up_lnNOx_A_1,  label("First Stage") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_o_r_up_lnNOx_A_2,  label("Second Stage") offset(-0.75)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_r_o_down_lnNOx_A_1,  label("First Stage") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_r_o_down_lnNOx_A_2,  label("Second Stage") offset(-0.75)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_o_b_down_lnNOx_A_1,  label("First Stage") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_o_b_down_lnNOx_A_2,  label("Second Stage") offset(-0.75)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  (re_y_b_down_lnNOx_A_1,  label("First Stage") offset(-0.25)  pstyle(p1) msymbol(o)  msize(*1.4)) ///
  (re_y_b_down_lnNOx_A_2,  label("Second Stage") offset(-0.75)  pstyle(p9) msymbol(s)  msize(*1.4)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
  xlabel(1 "b_y_up" 1 "b_y_up" 3 "y_o_up" 3 "y_o_up"  5 "o_r_up"  5 "o_r_up" ///
         7 "r_o_down" 7 "r_o_down" 9 "o_b_down" 9 "o_b_down"  11 "y_b_down" 11 "y_b_down" ) ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(6, lwidth(vthin) lpattern(shortdash) lcolor(teal)) /// 
  ytitle("log(NOx) estimates", size(medium)) ///
  xtitle("Alert type", size(medium)) ///
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  scheme(tufte) ///
  legend(order(2 "First Stage" 4 "Second Stage") row(1)) ///
  name(graphNOx, replace)
  graph export "picture/two_level_alert-NOx.png", replace as(png) name("graphNOx") width(1600) height(1200)
  

*==============================================================================*
*Fig. 5. Event-study estimates for plants' emission at different level alerts
*==============================================================================*
clear all  


global name  o_up  
global  control temperature air_pressure wind_speed visibility_distance 
global y  lnPM_A lnSO2_A lnNOx_A
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
		local i_no_A = subinstr("`i'", "_A", "", .)
		local i_sub = subinstr("`i_no_A'", "2", "₂", .)
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
		xline(9, lwidth(0.8) lpattern(shortdash) lcolor(teal)) 
		ylabel(,labsize(*1.2)) xlabel(,labsize(*1.2)) 
		ytitle("`i_sub'", size(medium)) 
		xtitle("Days before/after AQA activate", size(medium)) 
		ciopts(lpattern(dash) recast(rcap) msize(medium)) 
		scheme(s1mono) ///
		name(graphPM, replace)
		graph save "picture/origin/q-event_`a'`i'.gph",  replace
		
	}
}




global name  y_up 
global  control temperature air_pressure wind_speed visibility_distance 
global y  lnPM_A lnSO2_A lnNOx_A
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
		local i_no_A = subinstr("`i'", "_A", "", .)
		local i_sub = subinstr("`i_no_A'", "2", "₂", .)
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
		xline(5, lwidth(0.8) lpattern(shortdash) lcolor(teal)) 
		ylabel(,labsize(*1.2)) xlabel(,labsize(*1.2)) 
		ytitle("`i_sub'", size(medium))
		xtitle("Days before/after AQA activate", size(medium)) 
		addplot(line @b @at) 
		ciopts(lpattern(dash) recast(rcap) msize(medium)) 
		scheme(s1mono) ///
		name(graphPM, replace)
		graph save "/picture/origin/q-event_`a'`i'.gph",  replace
		
	}
}

graph combine "picture/origin/q-event_o_uplnPM_A.gph" "picture/origin/q-event_o_uplnSO2_A.gph" "picture/origin/q-event_o_uplnNOx_A.gph" "picture/origin/q-event_y_uplnPM_A.gph" "picture/origin/q-event_y_uplnSO2_A.gph" "picture/origin/q-event_Y_uplnNOx_A.gph" 

graph export "picture/figure5.png", replace as(png)  width(1800) height(1200)



*==============================================================================*
*Fig. 6. RD estimates for environmental inspections at different level AQAs.
*==============================================================================*

clear all   

global name  o_up y_up  o_down y_down  
global control  AQI_l24 temp humid ws rain press  
global y  enforce
local replace replace
foreach a in $name{
		
		use "data/data3.dta", replace
		keep if `a'_level!=.	
		keep if year >= 2018 & year <=2020 & enforce!=0
		foreach i in $y{
			reghdfe `i' $control   ,absorb(site year month weekday) resid(re`i')
			rdrobust re`i' `a'_id , c(0) p(2) q(3)  kernel(triangular)  masspoints(of)
			estimates store  re_`a'_`i'
			
			rdrobust re`i' `a'_id , c(12) p(2) q(3)  kernel(triangular)  masspoints(of)
			estimates store  re_`a'_`i'_b12
			
		}
		
	}

	
coefplot ///
  (re_o_up_enforce,  label("Normal") offset(-0.25) msymbol(o)   pstyle(p1)) ///
  (re_o_up_enforce_b12,  label("backward_12h") offset(-0.75) msymbol(s)   pstyle(p9)) ///
  (re_y_up_enforce,  label("Normal") offset(-0.25) msymbol(o)   pstyle(p1)) ///
  (re_y_up_enforce_b12,  label("backward_12h") offset(-0.75) msymbol(s) pstyle(p9)) ///
  (re_o_down_enforce,  label("Normal") offset(-0.25) msymbol(o)    pstyle(p1)) ///
  (re_o_down_enforce_b12,  label("backward_12h") offset(-0.75) msymbol(s) pstyle(p9)) ///
  (re_y_down_enforce,  label("Normal") offset(-0.25) msymbol(o)   pstyle(p1)) ///
  (re_y_down_enforce_b12,  label("backward_12h") offset(-0.75) msymbol(s) pstyle(p9)) ///
  , ///
  drop(_cons) vertical byopts(xrescale) ///
  aseq swapnames  ///
  xlabel(1 "o_activate" 1 "o_activate"  3 "y_activate" 3 "y_activate" ///
         5 "o_terminate"  5 "o_terminate"  7 "y_terminate"  7 "y_terminate") ///
  yline(0, lp(dash) lc(black*0.3)) ///
  xline(4, lwidth(vthin) lpattern(shortdash) lcolor(teal)) 
  ytitle("Inspection", size(medium)) 
  xtitle("Type", size(medium)) 
  graphregion(color(white)) ///
  ciopts(recast(rcap)) ///
  legend(order(2 "Normal" 4 "backward_12h")) ///
  scheme(tufte) ///
  name(graphPM, replace)
  graph export "picture/figure6.png", replace as(png) name("graphPM") width(1600) height(1200)
  
