* This file i) calculates the fraction of households whose wealth level is between 0.5*mean and 1.5*mean, and ii) the distribution of wealth/permanent income ratio, using SCF1992
* This file closely follows codes written for SAS which create summary variables. 
* (These codes are available at http://www.federalreserve.gov/pubs/oss/oss2/bulletin.macro.txt)  

clear 
clear matrix

** Set memeory 
set memory 32m 

** Load data and pick up necessary vars from original data
use y1 x42000 x42001 x5729 x5751 x7650 ///
    x3506 x3507 x3510 x3511 x3514 x3515 x3518 x3519 x3522 x3523 x3526 x3527 x3529 ///
    x3804 x3807 x3810 x3813 x3816 x3818 ///
    x3506 x3507 x9113 x3510 x3511 x9114 x3514 x3515 x9115 x3518 x3519 x9116 x3522 x3523 x9117 x3526 x3527 x9118 x3529 x3706 x9131 x3711 x9132 x3716 x9133 x3718 ///
    x3930 ///
    x3721 x3821 x3822 x3823 x3824 x3825 x3826 x3827 x3828 x3829 x3830 x3915 x3910 x3906 x3908 x7634 x7633 ///
    x3610 x3620 x3630 x3631 ///
    x4216 x4316 x4416 x4816 x4916 x5016 x4226 x4326 x4426 x4826 x4926 x5026 x4227 x4327 x4427 x4827 x4927 x5027 x4231 x4331 x4431 x4831 x4931 x5031 x4234 x4334 x4434 x4834 x4934 x5034 x4436 x5036 ///
    x3902 x4006 x3942 x3947 x4018 x4022 x4020 x4026 x4024 x4030 x4028 ///
    x8166 x8167 x8168 x2422 x2506 x2606 x2623 ///
    x507 x604 x614 x623 x716 x513 x526 ///
    x1405 x1409 x1505 x1509 x1605 x1609 x1619 x1703 x1706 x1705 x1803 x1806 x1805 x1903 x1906 x1905 x2002 x1715 x1815 x1915 x2016 x2012 x2723 x2710 x2740 x2727 x2823 x2810 x2840 x2827 x2923 x2910 x2940 x2927 ///
    x3129 x3124 x3126 x3127 x3121 x3122 x2723 x2710 x2740 x2727 x2823 x2810 x2840 x2827 x2923 x2910 x2940 x2927 x3229 x3224 x3226 x3227 x3221 x3222 x2723 x2710 x2740 x2727 x2823 x2810 x2840 x2827 x2923 x2910 x2940 x2927 x3329 x3324 x3326 x3327 x3321 x3322 x2723 x2710 x2740 x2727 x2823 x2810 x2840 x2827 x2923 x2910 x2940 x2927 x3335 x507 x513 x526 x2723 x2710 x2740 x2727 x2823 x2810 x2840 x2827 x2923 x2910 x2940 x2927 x3408 x3412 x3416 x3420 x3424 x3428 ///
    x4022 x4026 x4030 ///
    x805 x905 x1005 x1108 x1103 x1119 x1114 x1130 x1125 x1136 ///
    x1417 x1517 x1617 x1621 x2006 ///
    x1108 x1103 x1119 x1114 x1130 x1125 x1136 ///
    x427 x413 x421 x430 x424 x7575 ///
    x2218 x2318 x2418 x2424 x2519 x2619 x2625 x7824 x7847 x7870 x7924 x7947 x7970 x1044 x1215 x1219 ///
    x4229 x4230 x4329 x4330 x4429 x4430 x4829 x4830 x4929 x4930 x5029 x5030 ///
    x4010 x3932 x4032 ///
    x14 x19 x8020 x8023 x5902 x5904 x6102 x6104 ///
    using "scf92.dta"


** Generate variables 
* ID
gen ID   = y1                  /* ID # */
gen HHID = (y1-mod(y1,10))/10  /* HH ID # */
gen YEAR = 1992                /* Indicates data is from which wave */

* Weight
gen WGT       = x42001

* Asset 
gen CHECKING = max(0,x3506)*(x3507==5)+max(0,x3510)*(x3511==5) ///
              +max(0,x3514)*(x3515==5)+max(0,x3518)*(x3519==5) ///
              +max(0,x3522)*(x3523==5)+max(0,x3526)*(x3527==5) ///
              +max(0,x3529)*(x3527==5) 
gen SAVING   = max(0,x3804)+max(0,x3807)+max(0,x3810)+max(0,x3813) ///
              +max(0,x3816)+max(0,x3818) 
 gen MMDA    = max(0,x3506)*((x3507==1)*(11<=x9113 & x9113<=13)) ///
              +max(0,x3510)*((x3511==1)*(11<=x9114 & x9114<=13)) ///
              +max(0,x3514)*((x3515==1)*(11<=x9115 & x9115<=13)) ///
              +max(0,x3518)*((x3519==1)*(11<=x9116 & x9116<=13)) ///
              +max(0,x3522)*((x3523==1)*(11<=x9117 & x9117<=13)) ///
              +max(0,x3526)*((x3527==1)*(11<=x9118 & x9118<=13)) ///
              +max(0,x3529)*((x3527==1)*(11<=x9118 & x9118<=13)) ///
              +max(0,x3706)*(11<=x9131 & x9131<=13) ///
              +max(0,x3711)*(11<=x9132 & x9132<=13) ///
              +max(0,x3716)*(11<=x9133 & x9133<=13) ///
              +max(0,x3718)*(11<=x9133 & x9133<=13) 
 gen MMMF    = max(0,x3506)*(x3507==1)*(x9113<11|x9113>13) ///
              +max(0,x3510)*(x3511==1)*(x9114<11|x9114>13) ///
              +max(0,x3514)*(x3515==1)*(x9115<11|x9115>13) ///
              +max(0,x3518)*(x3519==1)*(x9116<11|x9116>13) ///
              +max(0,x3522)*(x3523==1)*(x9117<11|x9117>13) ///
              +max(0,x3526)*(x3527==1)*(x9118<11|x9118>13) ///
              +max(0,x3529)*(x3527==1)*(x9118<11|x9118>13) ///
              +max(0,x3706)*(x9131<11|x9131>13) ///
              +max(0,x3711)*(x9132<11|x9132>13) ///
              +max(0,x3716)*(x9133<11|x9133>13) ///
              +max(0,x3718)*(x9133<11|x9133>13) 
gen MMA      = MMDA+MMMF 
gen CALL     = max(0,x3930) 
gen LIQ      = CHECKING+SAVING+MMA+CALL 

gen CDS      = max(0,x3721) 
 gen STMUTF  = (x3821==1)*max(0,x3822) 
 gen TFBMUTF = (x3823==1)*max(0,x3824) 
 gen GBMUTF  = (x3825==1)*max(0,x3826) 
 gen OBMUTF  = (x3827==1)*max(0,x3828) 
 gen COMUTF  = (x3829==1)*max(0,x3830) 
 gen SNMMF   = TFBMUTF+GBMUTF+OBMUTF+(.5*(COMUTF)) 
 gen RNMMF   = STMUTF + (.5*(COMUTF)) 
gen NMMF     = SNMMF + RNMMF 
gen STOCKS   = max(0,x3915) 
 gen NOTXBND = x3910 
 gen MORTBND = x3906 
 gen GOVTBND = x3908 
 gen OBND    = x7634+x7633 
gen BOND     = NOTXBND + MORTBND + GOVTBND + OBND
 gen IRAKH   = max(0,x3610)+max(0,x3620)+max(0,x3630)
 gen THRIFT  = max(0,x4226)*(x4216==1|x4216==2|x4227==1|x4231==1) ///
              +max(0,x4326)*(x4316==1|x4316==2|x4327==1|x4331==1) ///
              +max(0,x4426)*(x4416==1|x4416==2|x4427==1|x4431==1) ///
              +max(0,x4826)*(x4816==1|x4816==2|x4827==1|x4831==1) ///
              +max(0,x4926)*(x4916==1|x4916==2|x4927==1|x4931==1) ///
              +max(0,x5026)*(x5016==1|x5016==2|x5027==1|x5031==1)
 gen PMOP     = x4436
 replace PMOP = 0 if x4436<=0
 replace PMOP = 0 if x4216!=0 & x4316!=0 & x4416!=0 & x4231!=0 & x4331!=0 & x4431!=0
 replace THRIFT = THRIFT + PMOP 
 replace PMOP   = x5036
 replace PMOP = 0 if x5036<=0
 replace PMOP = 0 if x4816!=0 & x4916!=0 & x5016!=0 & x4831!=0 & x4931!=0 & x5031!=0
 replace THRIFT = THRIFT + PMOP
gen RETQLIQ  = IRAKH + THRIFT
gen SAVBND   = x3902
gen CASHLI   = max(0,x4006)
 gen ROTHMA  = 0
 gen SOTHMA  = 0
 gen COTHMA  = 0
 replace ROTHMA = x3942 if x3947==1 | x3947==3
 replace SOTHMA = x3942 if x3947==2 | x3947==7
 replace COTHMA = x3942 if x3947==5 | x3947==6 | x3947==8 | x3947==9 | x3947==-7 
gen OTHMA    = ROTHMA+SOTHMA+COTHMA
gen OTHFIN   = x4018+x4022*(x4020==61|x4020==62|x4020==63|x4020==64|x4020==66|x4020==71|x4020==73|x4020==74) ///
              +x4026*(x4024==61|x4024==62|x4024==63|x4024==64|x4024==66|x4024==71|x4024==73|x4024==74) ///
              +x4030*(x4028==61|x4028==62|x4028==63|x4028==64|x4028==66|x4028==71|x4028==73|x4028==74)
gen LiqFIN       = LIQ+CDS+NMMF+STOCKS+BOND        +SAVBND                     /* Total liquid fin asset */
gen LiqFINPlsRet = LIQ+CDS+NMMF+STOCKS+BOND+RETQLIQ+SAVBND                     /* Total liquid fin asset plus retirement assets*/
gen FIN          = LIQ+CDS+NMMF+STOCKS+BOND+RETQLIQ+SAVBND+CASHLI+OTHMA+OTHFIN /* Total fin asset */

gen VEHIC    = max(0,x8166)+max(0,x8167)+max(0,x8168) ///
              +max(0,x2422)+max(0,x2506)+max(0,x2606)+max(0,x2623)
replace x507 = 9000 if x507 > 9000
gen HOUSES   = (x604+x614+x623+x716) + ((10000-x507)/10000)*(x513+x526) 
gen ORESRE   = max(x1405,x1409)+max(x1505,x1509)+max(x1605,x1609)+max(0,x1619) ///
              +(x1703==12|x1703==14|x1703==21|x1703==22|x1703==25|x1703==40|x1703==41|x1703==42|x1703==43|x1703==44|x1703==49|x1703==50|x1703==52|x1703==999) ///
              *max(0,x1706)*(x1705/10000) ///
              +(x1803==12|x1803==14|x1803==21|x1803==22|x1803==25|x1803==40|x1803==41|x1803==42|x1803==43|x1803==44|x1803==49|x1803==50|x1803==52|x1803==999) ///
              *max(0,x1806)*(x1805/10000) ///
              +(x1903==12|x1903==14|x1903==21|x1903==22|x1903==25|x1903==40|x1903==41|x1903==42|x1903==43|x1903==44|x1903==49|x1903==50|x1903==52|x1903==999) ///
              *max(0,x1906)*(x1905/10000) ///
              +max(0,x2002)
gen NNRESRE  = (x1703==1|x1703==2|x1703==3|x1703==4|x1703==5|x1703==6|x1703==7|x1703==10|x1703==11|x1703==13|x1703==15|x1703==24|x1703==45|x1703==46|x1703==47|x1703==48|x1703==51|x1703==-7) ///
              *(max(0,x1706)*(x1705/10000)-x1715*(x1705/10000)) ///
              +(x1803==1|x1803==2|x1803==3|x1803==4|x1803==5|x1803==6|x1803==7|x1803==10|x1803==11|x1803==13|x1803==15|x1803==24|x1803==45|x1803==46|x1803==47|x1803==48|x1803==51|x1803==-7) ///
              *(max(0,x1806)*(x1805/10000)-x1815*(x1805/10000)) ///
              +(x1903==1|x1903==2|x1903==3|x1903==4|x1903==5|x1903==6|x1903==7|x1903==10|x1903==11|x1903==13|x1903==15|x1903==24|x1903==45|x1903==46|x1903==47|x1903==48|x1903==51|x1903==-7) ///
              *(max(0,x1906)*(x1905/10000)-x1915*(x1905/10000)) ///
              +max(0,x2012)-x2016
replace NNRESRE = NNRESRE-x2723*(x2710==78)-x2740*(x2727==78)-x2823*(x2810==78) ///
                 -x2840*(x2827==78)-x2923*(x2910==78)-x2940*(x2927==78) if NNRESRE!=0
gen FLAG781  = (NNRESRE!=0)
gen BUS      = max(0,x3129)+max(0,x3124)-max(0,x3126)*(x3127==5)+max(0,x3121)*(x3122==1) ///
              +max(0,x2723*(x2710==71))+max(0,x2740*(x2727==71)) ///
              +max(0,x2823*(x2810==71))+max(0,x2840*(x2827==71)) ///
              +max(0,x2923*(x2910==71))+max(0,x2940*(x2927==71)) ///
              +max(0,x3229)+max(0,x3224)-max(0,x3226)*(x3227==5) ///
              +max(0,x3221)*(x3222==1)+max(0,x2723*(x2710==72))+max(0,x2740*(x2727==72)) ///
              +max(0,x2823*(x2810==72))+max(0,x2840*(x2827==72)) ///
              +max(0,x2923*(x2910==72))+max(0,x2940*(x2927==72)) ///
              +max(0,x3329)+max(0,x3324)-max(0,x3326)*(x3327==5) ///
              +max(0,x3321)*(x3322==1)+max(0,x2723*(x2710==73))+max(0,x2740*(x2727==73)) ///
              +max(0,x2823*(x2810==73))+max(0,x2840*(x2827==73)) ///
              +max(0,x2923*(x2910==73))+max(0,x2940*(x2927==73)) ///
              +max(0,x3335)+(x507/10000)*(x513+x526) ///
              +max(0,x2723*(x2710==74))+max(0,x2740*(x2727==74)) ///
              +max(0,x2823*(x2810==74))+max(0,x2840*(x2827==74)) ///
              +max(0,x2923*(x2910==74))+max(0,x2940*(x2927==74)) ///
              +max(0,x3408)+max(0,x3412)+max(0,x3416)+max(0,x3420)+max(0,x3424)+max(0,x3428)
gen OTHNFIN  = x4022 + x4026 + x4030 - OTHFIN + x4018
gen NFIN     = VEHIC+HOUSES+ORESRE+NNRESRE+BUS+OTHNFIN
gen ASSET    = FIN+NFIN /* Total asset */

* Debt 
gen MRTHEL   = x805+x905+x1005+x1108*(x1103==1)+x1119*(x1114==1) ///
             +x1130*(x1125==1)+max(0,x1136)*(x1108*(x1103==1)+x1119*(x1114==1) ///
             +x1130*(x1125==1))/(x1108+x1119+x1130) if (x1108+x1119+x1130)>=1
replace MRTHEL = x805+x905+x1005+.5*(max(0,x1136)) if (x1108+x1119+x1130)<1
 gen MORT1    = (x1703==12|x1703==14|x1703==21|x1703==22|x1703==25|x1703==40|x1703==41|x1703==42|x1703==43|x1703==44|x1703==49|x1703==50|x1703==52|x1703==999) ///
               *x1715*(x1705/10000)
 gen MORT2    = (x1803==12|x1803==14|x1803==21|x1803==22|x1803==25|x1803==40|x1803==41|x1803==42|x1803==43|x1803==44|x1803==49|x1803==50|x1803==52|x1803==999) ///
               *x1815*(x1805/10000)
 gen MORT3    = (x1903==12|x1903==14|x1903==21|x1903==22|x1903==25|x1903==40|x1903==41|x1903==42|x1903==43|x1903==44|x1903==49|x1903==50|x1903==52|x1903==999) ///
               *x1915*(x1905/10000)
gen RESDBT   = x1417+x1517+x1617+x1621+MORT1+MORT2+MORT3+x2006
 gen FLAG782  = (FLAG781!=1 & ORESRE>0)
replace RESDBT = RESDBT+x2723*(x2710==78)+x2740*(x2727==78)+x2823*(x2810==78)+x2840*(x2827==78) ///
                +x2923*(x2910==78)+x2940*(x2927==78) if FLAG781!=1 & ORESRE>0
 gen FLAG67   = (ORESRE>0)
replace RESDBT= RESDBT+x2723*(x2710==67)+x2740*(x2727==67)+x2823*(x2810==67)+x2840*(x2827==67) ///
               +x2923*(x2910==67)+x2940*(x2927==67) if ORESRE>0 
gen OTHLOC   = x1108*(x1103!=1)+x1119*(x1114!=1)+x1130*(x1125!=1) ///
              +max(0,x1136)*(x1108*(x1103!=1)+x1119*(x1114!=1) ///
              +x1130*(x1125!=1))/(x1108+x1119+x1130) if (x1108+x1119+x1130)>=1
replace OTHLOC = .5*(max(0,x1136)) if (x1108+x1119+x1130)<1 
gen CCBAL    = max(0,x427)+max(0,x413)+max(0,x421)+max(0,x430)+max(0,x424)+max(0,x7575)
gen INSTALL  = x2218+x2318+x2418+x2424+x2519+x2619+x2625+x7824 ///
              +x7847+x7870+x7924+x7947+x7970+x1044+x1215+x1219
replace INSTALL = INSTALL+x2723*(x2710==78)+x2740*(x2727==78) ///
                 +x2823*(x2810==78)+x2840*(x2827==78)+x2923*(x2910==78)+x2940*(x2927==78) ///
                  if FLAG781==0 & FLAG782==0
replace INSTALL = INSTALL+x2723*(x2710==67)+x2740*(x2727==67)+x2823*(x2810==67) ///
                 +x2840*(x2827==67)+x2923*(x2910==67)+x2940*(x2927==67) if FLAG67==0
replace INSTALL = INSTALL+x2723*(x2710!=67&x2710!=78)+x2740*(x2727!=67&x2727!=78) ///
                 +x2823*(x2810!=67&x2810!=78)+x2840*(x2827!=67&x2827!=78)+x2923*(x2910!=67&x2910!=78) ///
                 +x2940*(x2927!=67&x2927!=78)
gen PENDBT   = max(0,x4229)*(x4230==5)+max(0,x4329)*(x4330==5) ///
              +max(0,x4429)*(x4430==5)+max(0,x4829)*(x4830==5) ///
              +max(0,x4929)*(x4930==5)+max(0,x5029)*(x5030==5)
gen CASHLIDB = max(0,x4010)
gen CALLDBT  = max(0,x3932)
gen ODEBT    = max(0,x4032)
gen DEBT     = MRTHEL+RESDBT+OTHLOC+CCBAL+INSTALL+PENDBT+CASHLIDB+CALLDBT+ODEBT /* Total debt */

* Net worth 
gen NETW     = ASSET-DEBT

* Drop data, if age < 25 or >60 
gen AGE     = x14       /* Age */
drop if AGE < 25
drop if AGE > 60

* Income
gen PINCOME    = x5729        /* Income before tax */
replace PINCOME = PINCOME*1.03 /* Adjust with CPI (adjusted to 1992$ price) */   
gen D_NORMINC = (x7650==3) /* D_NORMINC = 1 if inc level is normal */
keep if D_NORMINC == 1     /* Keep if inc level is normal */
drop if PINCOME <0
sum PINCOME [weight= WGT] 
gen NPINCOME = PINCOME /49629.65       /* P/M[P] */
sum NPINCOME  [weight= WGT] 

* Calculate variance of p/M[p]
matrix std = r(sd)
matrix var = std*std
log using "results-variances", replace text
* Summary of estimated variances of p/M[p]:
* SCF1992
matrix list var 
log close

* Wealth (net worth) / perm inc ratio (note divided by quarterly perm inc)  
gen WYRATIO  = NETW/(PINCOME/4) 
 * WYRATIO is wealth ratio to quraterly permanent income 

* Fraction of households whose wealth level is between 0.5*mean and 1.5*mean
sum NETW [weight= WGT] , d
gen NETWRatio = NETW/171957.1
sum NETWRatio [weight= WGT] 
gen dum=0 
replace dum=1 if NETWRatio>0.5 & NETWRatio<1.5 /* dum is 1 if net worth is between is between 0.5*mean and 1.5*mean*/
log using "results-fraction_between_05_and_15.txt", replace text
* Summary results: "Mean" measures the fraction of households whose wealth level is between 0.5*average and 1.5*average
* SCF1992
sum dum [weight=WGT] /* mean of dum is fraction of households whose wealth level is between 0.5*mean and 1.5*mean*/
log close

* WYRATIO by pecentile 
log using "results-WYDist", replace text
* Summary of results: wealth/perm inc ratios
* SCF1992
sum WYRATIO [weight= WGT]  if WYRATIO <10000, d
pctile pct = WYRATIO [weight=WGT] if WYRATIO <10000, nq(20) genp(percent)
list percent pct in 1/20
log close 

* FINYRATIO (finanical assets/perm inc ratio) by percentile 
log using "results-WYDistFin", replace text
* Summary of results: financial assets/perm inc ratios
* SCF1992
gen FINYRATIO  = FIN/(PINCOME/4) 
sum FINYRATIO [weight= WGT]  if FINYRATIO <10000, d
pctile pctF = FINYRATIO [weight=WGT] if FINYRATIO <10000, nq(20) genp(percentF)
list percentF  pctF in 1/20
log close 

* LiqFINPlsRetYRATIO (liq financial assets plus ret asset/perm inc ratio) by percentile 
log using "results-WYDistLiqFINPlsRet", replace text
* Summary of results: liq financial assets plus ret asset/perm inc ratios
* SCF1992
gen LiqFINPlsRetYRATIO  = LiqFINPlsRet/(PINCOME/4) 
sum LiqFINPlsRetYRATIO [weight= WGT]  if LiqFINPlsRetYRATIO <10000, d
pctile pctLiqFPlsRet = LiqFINPlsRetYRATIO [weight=WGT] if LiqFINPlsRetYRATIO <10000, nq(20) genp(percentLiqFPlsRet)
list percentLiqFPlsRet  pctLiqFPlsRet in 1/20
log close 

* LiqFINYRATIO (liquid financial assets/perm inc ratio) by percentile 
log using "results-WYDistLiqFIN", replace text
* Summary of results: liquid financial assets/perm inc ratios
* SCF1992
gen LiqFINYRATIO  = LiqFIN/(PINCOME/4) 
sum LiqFINYRATIO [weight= WGT]  if LiqFINYRATIO <10000, d
pctile pctLiqF = LiqFINYRATIO [weight=WGT] if LiqFINYRATIO <10000, nq(20) genp(percentLiqF)
list percentLiqF  pctLiqF in 1/20
log close 


** Cumulative distribution of net worth
* normalize weight
gsort -NETW 
egen float TempWGT = pc( WGT)
drop WGT
replace TempWGT = TempWGT/100
rename TempWGT WGT

* calculate cumulative distribution from the top 
gen TempNETW = NETW*WGT
egen float DistNETW = pc( TempNETW)
gen cumNETW     = DistNETW[1]
replace cumNETW = DistNETW[_n] + cumNETW[_n-1] if _n>1

* show net worth held by top x% (note that the order is reversed from RATIOS (above))
sum cumNETW [weight= WGT] , d
pctile pctcumNETW = cumNETW [weight=WGT], nq(20) genp(percentNETW)
list percentNETW pctcumNETW in 1/20

/* 
* plot 
gen     percentile = WGT[1]
replace percentile = WGT[_n] + percentile[_n-1] if _n>1
replace percentile = (100-percentile*100)
gen CumNETWDist = 100-cumNETW
line CumNETWDist percentile
*/

* AGGREGATE Wealth (net worth) / perm inc ratio (note divided by quarterly perm inc)  
gen Temp = NETW * WGT
egen float MeanNETW = total(Temp)
drop Temp

gen Temp = PINCOME * WGT
egen float MeanPINCOME = total(Temp)
drop Temp

gen AggWYRATIO = MeanNETW/(MeanPINCOME/4)
mean AggWYRATIO /* show aggregate WYRATIO */


** Cumulative distribution of financial assets
* normalize weight
gsort -FIN 
egen float TempWGT = pc( WGT)
drop WGT
replace TempWGT = TempWGT/100
rename TempWGT WGT

* calculate cumulative distribution from the top 
gen TempFIN = FIN*WGT
egen float DistFIN = pc( TempFIN)
gen cumFIN     = DistFIN[1]
replace cumFIN = DistFIN[_n] + cumFIN[_n-1] if _n>1

* show financial assets held by top x% (note that the order is reversed from RATIOS (above))
log using "results-FINCumDist", replace text
* Summary of results: cumlative distriution of fin assets held by top x%
* SCF1992
sum cumFIN [weight= WGT] , d
pctile pctcumFIN = cumFIN [weight=WGT], nq(20) genp(percentFIN)
list percentFIN pctcumFIN in 1/20

/* 
* plot 
gen     percentileFIN = WGT[1]
replace percentileFIN = WGT[_n] + percentileFIN[_n-1] if _n>1
replace percentileFIN = (100-percentileFIN*100)
gen CumFINDist = 100-cumFIN
line CumFINDist percentileFIN
*/

* AGGREGATE financial assets / perm inc ratio (note divided by quarterly perm inc)  
gen Temp = FIN * WGT
egen float MeanFIN = total(Temp)
drop Temp
gen AggFINYRATIO = MeanFIN/(MeanPINCOME/4)
mean AggFINYRATIO /* show aggregate FINYRATIO */

log close


** Cumulative distribution of liq financial assets plus ret asset
* normalize weight
gsort -LiqFINPlsRet 
egen float TempWGT = pc( WGT)
drop WGT
replace TempWGT = TempWGT/100
rename TempWGT WGT

* calculate cumulative distribution from the top 
gen TempLiqFINPlsRet = LiqFINPlsRet*WGT
egen float DistLiqFINPlsRet = pc( TempLiqFINPlsRet)
gen cumLiqFINPlsRet     = DistLiqFINPlsRet[1]
replace cumLiqFINPlsRet = DistLiqFINPlsRet[_n] + cumLiqFINPlsRet[_n-1] if _n>1

* show liq financial assets plus ret asset held by top x% (note that the order is reversed from RATIOS (above))
log using "results-LiqFINPlsRetCumDist", replace text
* Summary of results: cumlative distriution of fin assets held by top x%
* SCF1992
sum cumLiqFINPlsRet [weight= WGT] , d
pctile pctcumLiqFINPlsRet = cumLiqFINPlsRet [weight=WGT], nq(20) genp(percentLiqFINPlsRet)
list percentLiqFINPlsRet pctcumLiqFINPlsRet in 1/20

/* 
* plot 
gen     percentileLiqFINPlsRet = WGT[1]
replace percentileLiqFINPlsRet = WGT[_n] + percentileLiqFINPlsRet[_n-1] if _n>1
replace percentileLiqFINPlsRet = (100-percentileLiqFINPlsRet*100)
gen CumLiqFINPlsRetDist = 100-cumLiqFINPlsRet
line CumLiqFINPlsRetDist percentileLiqFINPlsRet
*/

* AGGREGATE liq financial assets plus ret asset/ perm inc ratio (note divided by quarterly perm inc)  
gen Temp = LiqFINPlsRet * WGT
egen float MeanLiqFINPlsRet = total(Temp)
drop Temp
gen AggLiqFINPlsRetYRATIO = MeanLiqFINPlsRet/(MeanPINCOME/4)
mean AggLiqFINPlsRetYRATIO /* show aggregate LiqFINPlsRetYRATIO */

log close


***************
** Cumulative distribution of liquid financial assets
* normalize weight
gsort -LiqFIN 
egen float TempWGT = pc( WGT)
drop WGT
replace TempWGT = TempWGT/100
rename TempWGT WGT

* calculate cumulative distribution from the top 
gen TempLiqFIN = LiqFIN*WGT
egen float DistLiqFIN = pc( TempLiqFIN)
gen cumLiqFIN     = DistLiqFIN[1]
replace cumLiqFIN = DistLiqFIN[_n] + cumLiqFIN[_n-1] if _n>1

* show LiqFINancial assets held by top x% (note that the order is reversed from RATIOS (above))
log using "results-LiqFINCumDist", replace text
* Summary of results: cumlative distriution of LiqFIN assets held by top x%
* SCF1992
sum cumLiqFIN [weight= WGT] , d
pctile pctcumLiqFIN = cumLiqFIN [weight=WGT], nq(20) genp(percentLiqFIN)
list percentLiqFIN pctcumLiqFIN in 1/20

/* 
* plot 
gen     percentileLiqFIN = WGT[1]
replace percentileLiqFIN = WGT[_n] + percentileLiqFIN[_n-1] if _n>1
replace percentileLiqFIN = (100-percentileLiqFIN*100)
gen CumLiqFINDist = 100-cumLiqFIN
line CumLiqFINDist percentileLiqFIN
*/

* AGGREGATE LiqFINancial assets / perm inc ratio (note divided by quarterly perm inc)  
gen Temp = LiqFIN * WGT
egen float MeanLiqFIN = total(Temp)
drop Temp
gen AggLiqFINYRATIO = MeanLiqFIN/(MeanPINCOME/4)
mean AggLiqFINYRATIO /* show aggregate LiqFINYRATIO */

log close 

