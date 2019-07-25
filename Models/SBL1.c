#include <amigoRHS.h>

#include <math.h>

#include <amigoJAC.h>

#include <amigoSensRHS.h>


	/* *** Definition of the states *** */

#define	RFP Ith(y,0)
#define	GFP Ith(y,1)
#define iexp amigo_model->exp_num

	/* *** Definition of the sates derivative *** */

#define	dRFP Ith(ydot,0)
#define	dGFP Ith(ydot,1)

	/* *** Definition of the parameters *** */

#define	p1_2    (*amigo_model).pars[0]
#define	p1_9    (*amigo_model).pars[1]
#define	p1_11   (*amigo_model).pars[2]
#define	p1_13   (*amigo_model).pars[3]
#define	p1_15   (*amigo_model).pars[4]
#define	p1_17   (*amigo_model).pars[5]
#define	p1_18   (*amigo_model).pars[6]
#define	p1_19   (*amigo_model).pars[7]
#define	p1_21   (*amigo_model).pars[8]
#define	p1_22   (*amigo_model).pars[9]
#define	p1_23   (*amigo_model).pars[10]
#define	p1_25   (*amigo_model).pars[11]
#define	p1_26   (*amigo_model).pars[12]
#define	p1_27   (*amigo_model).pars[13]
#define	p1_28   (*amigo_model).pars[14]
#define	p1_29   (*amigo_model).pars[15]
#define	p1_30   (*amigo_model).pars[16]
#define	p1_31   (*amigo_model).pars[17]
#define	p1_32   (*amigo_model).pars[18]
#define	p1_33   (*amigo_model).pars[19]
#define	p1_34   (*amigo_model).pars[20]
#define	p1_35   (*amigo_model).pars[21]
#define	p1_36   (*amigo_model).pars[22]
#define	p1_37   (*amigo_model).pars[23]
#define	p1_38   (*amigo_model).pars[24]
#define	p1_39   (*amigo_model).pars[25]
#define	p1_40   (*amigo_model).pars[26]
#define	p1_41   (*amigo_model).pars[27]
#define	p1_42   (*amigo_model).pars[28]
#define	p1_43   (*amigo_model).pars[29]
#define	p1_49   (*amigo_model).pars[30]
#define	p1_51   (*amigo_model).pars[31]
#define	p1_53   (*amigo_model).pars[32]
#define	p1_55   (*amigo_model).pars[33]
#define	p1_57   (*amigo_model).pars[34]
#define	p1_58   (*amigo_model).pars[35]
#define	p1_59   (*amigo_model).pars[36]
#define	p1_61   (*amigo_model).pars[37]
#define	p1_62   (*amigo_model).pars[38]
#define	p1_63   (*amigo_model).pars[39]
#define	p1_65   (*amigo_model).pars[40]
#define	p1_66   (*amigo_model).pars[41]
#define	p1_67   (*amigo_model).pars[42]
#define	p1_69   (*amigo_model).pars[43]
#define	p1_70   (*amigo_model).pars[44]
#define	p1_71   (*amigo_model).pars[45]
#define	p1_73   (*amigo_model).pars[46]
#define	p1_74   (*amigo_model).pars[47]
#define	p1_75   (*amigo_model).pars[48]
#define	p1_77   (*amigo_model).pars[49]
#define	p1_78   (*amigo_model).pars[50]
#define	p1_79   (*amigo_model).pars[51]
#define	p1_80   (*amigo_model).pars[52]
#define	p1_81   (*amigo_model).pars[53]
#define	p1_82   (*amigo_model).pars[54]
#define	p1_83   (*amigo_model).pars[55]
#define	p1_93   (*amigo_model).pars[56]
#define	p1_95   (*amigo_model).pars[57]
#define	p1_97   (*amigo_model).pars[58]
#define	p1_99   (*amigo_model).pars[59]
#define	p1_101  (*amigo_model).pars[60]
#define	p1_102  (*amigo_model).pars[61]
#define	p1_103  (*amigo_model).pars[62]
#define	p1_105  (*amigo_model).pars[63]
#define	p1_107  (*amigo_model).pars[64]
#define	p1_109  (*amigo_model).pars[65]
#define	p1_111  (*amigo_model).pars[66]
#define	p1_113  (*amigo_model).pars[67]
#define	p1_115  (*amigo_model).pars[68]
#define	p1_117  (*amigo_model).pars[69]
#define	p1_119  (*amigo_model).pars[70]
#define	p1_121  (*amigo_model).pars[71]
#define	p1_123  (*amigo_model).pars[72]
#define	p1_135  (*amigo_model).pars[73]
#define	p1_137  (*amigo_model).pars[74]
#define	p1_139  (*amigo_model).pars[75]
#define	p1_141  (*amigo_model).pars[76]
#define	p1_142  (*amigo_model).pars[77]
#define	p1_143  (*amigo_model).pars[78]
#define	p1_145  (*amigo_model).pars[79]
#define	p1_147  (*amigo_model).pars[80]
#define	p1_149  (*amigo_model).pars[81]
#define	p1_151  (*amigo_model).pars[82]
#define	p1_153  (*amigo_model).pars[83]
#define	p1_155  (*amigo_model).pars[84]
#define	p1_157  (*amigo_model).pars[85]
#define	p1_159  (*amigo_model).pars[86]
#define	p1_161  (*amigo_model).pars[87]
#define	p1_163  (*amigo_model).pars[88]
#define	p1_175  (*amigo_model).pars[89]
#define	p1_179  (*amigo_model).pars[90]
#define	p1_181  (*amigo_model).pars[91]
#define	p1_182  (*amigo_model).pars[92]
#define	p1_183  (*amigo_model).pars[93]
#define	p1_185  (*amigo_model).pars[94]
#define	p1_187  (*amigo_model).pars[95]
#define	p1_189  (*amigo_model).pars[96]
#define	p1_191  (*amigo_model).pars[97]
#define	p1_193  (*amigo_model).pars[98]
#define	p1_195  (*amigo_model).pars[99]
#define	p1_197  (*amigo_model).pars[100]
#define	p1_199  (*amigo_model).pars[101]
#define	p1_201  (*amigo_model).pars[102]
#define	p1_203  (*amigo_model).pars[103]
#define	p1_219  (*amigo_model).pars[104]
#define	p1_222  (*amigo_model).pars[105]
#define	p1_223  (*amigo_model).pars[106]
#define	p1_225  (*amigo_model).pars[107]
#define	p1_227  (*amigo_model).pars[108]
#define	p1_229  (*amigo_model).pars[109]
#define	p1_231  (*amigo_model).pars[110]
#define	p1_233  (*amigo_model).pars[111]
#define	p1_235  (*amigo_model).pars[112]
#define	p1_237  (*amigo_model).pars[113]
#define	p1_239  (*amigo_model).pars[114]
#define	p1_241  (*amigo_model).pars[115]
#define	p1_243  (*amigo_model).pars[116]
#define	p1_259  (*amigo_model).pars[117]
#define	p1_263  (*amigo_model).pars[118]
#define	p1_267  (*amigo_model).pars[119]
#define	p1_271  (*amigo_model).pars[120]
#define	p1_273  (*amigo_model).pars[121]
#define	p1_275  (*amigo_model).pars[122]
#define	p1_277  (*amigo_model).pars[123]
#define	p1_279  (*amigo_model).pars[124]
#define	p1_281  (*amigo_model).pars[125]
#define	p1_283  (*amigo_model).pars[126]
#define	p1_287  (*amigo_model).pars[127]
#define	p1_299  (*amigo_model).pars[128]
#define	p1_303  (*amigo_model).pars[129]
#define	p1_307  (*amigo_model).pars[130]
#define	p1_311  (*amigo_model).pars[131]
#define	p1_315  (*amigo_model).pars[132]
#define	p1_319  (*amigo_model).pars[133]
#define	p1_321  (*amigo_model).pars[134]
#define	p1_323  (*amigo_model).pars[135]
#define	p1_343  (*amigo_model).pars[136]
#define	p1_347  (*amigo_model).pars[137]
#define	p1_351  (*amigo_model).pars[138]
#define	p1_355  (*amigo_model).pars[139]
#define	p1_359  (*amigo_model).pars[140]
#define	p1_363  (*amigo_model).pars[141]
#define	p1_383  (*amigo_model).pars[142]
#define	p1_387  (*amigo_model).pars[143]
#define	p1_391  (*amigo_model).pars[144]
#define	p1_395  (*amigo_model).pars[145]
#define	p1_399  (*amigo_model).pars[146]
#define	p1_403  (*amigo_model).pars[147]
#define	p1_423  (*amigo_model).pars[148]
#define	p1_427  (*amigo_model).pars[149]
#define	p1_431  (*amigo_model).pars[150]
#define	p1_435  (*amigo_model).pars[151]
#define	p1_439  (*amigo_model).pars[152]
#define	p1_443  (*amigo_model).pars[153]
#define	p1_463  (*amigo_model).pars[154]
#define	p1_467  (*amigo_model).pars[155]
#define	p1_471  (*amigo_model).pars[156]
#define	p1_475  (*amigo_model).pars[157]
#define	p1_479  (*amigo_model).pars[158]
#define	p1_483  (*amigo_model).pars[159]
#define	p1_503  (*amigo_model).pars[160]
#define	p1_506  (*amigo_model).pars[161]
#define	p1_507  (*amigo_model).pars[162]
#define	p1_511  (*amigo_model).pars[163]
#define	p1_515  (*amigo_model).pars[164]
#define	p1_519  (*amigo_model).pars[165]
#define	p1_523  (*amigo_model).pars[166]
#define	p1_546  (*amigo_model).pars[167]
#define	p1_547  (*amigo_model).pars[168]
#define	p1_551  (*amigo_model).pars[169]
#define	p1_555  (*amigo_model).pars[170]
#define	p1_559  (*amigo_model).pars[171]
#define	p1_563  (*amigo_model).pars[172]
#define	p1_566  (*amigo_model).pars[173]
#define	p1_582  (*amigo_model).pars[174]
#define	p1_586  (*amigo_model).pars[175]
#define	p1_587  (*amigo_model).pars[176]
#define	p1_591  (*amigo_model).pars[177]
#define	p1_595  (*amigo_model).pars[178]
#define	p1_599  (*amigo_model).pars[179]
#define	p1_603  (*amigo_model).pars[180]
#define	p1_606  (*amigo_model).pars[181]
#define	p1_607  (*amigo_model).pars[182]
#define	p1_622  (*amigo_model).pars[183]
#define	p1_626  (*amigo_model).pars[184]
#define	p1_627  (*amigo_model).pars[185]
#define	p1_631  (*amigo_model).pars[186]
#define	p1_635  (*amigo_model).pars[187]
#define	p1_639  (*amigo_model).pars[188]
#define	p1_643  (*amigo_model).pars[189]
#define	p1_647  (*amigo_model).pars[190]
#define	p1_662  (*amigo_model).pars[191]
#define	p1_666  (*amigo_model).pars[192]
#define	p1_667  (*amigo_model).pars[193]
#define	p1_671  (*amigo_model).pars[194]
#define	p1_675  (*amigo_model).pars[195]
#define	p1_679  (*amigo_model).pars[196]
#define	p1_683  (*amigo_model).pars[197]
#define	p1_702  (*amigo_model).pars[198]
#define	p1_706  (*amigo_model).pars[199]
#define	p1_707  (*amigo_model).pars[200]
#define	p1_711  (*amigo_model).pars[201]
#define	p1_715  (*amigo_model).pars[202]
#define	p1_719  (*amigo_model).pars[203]
#define	p1_723  (*amigo_model).pars[204]
#define	p1_742  (*amigo_model).pars[205]
#define	p1_746  (*amigo_model).pars[206]
#define	p1_747  (*amigo_model).pars[207]
#define	p1_751  (*amigo_model).pars[208]
#define	p1_755  (*amigo_model).pars[209]
#define	p1_759  (*amigo_model).pars[210]
#define	p1_763  (*amigo_model).pars[211]
#define	p1_767  (*amigo_model).pars[212]
#define	p1_782  (*amigo_model).pars[213]
#define	p1_786  (*amigo_model).pars[214]
#define	p1_787  (*amigo_model).pars[215]
#define	p1_791  (*amigo_model).pars[216]
#define	p1_795  (*amigo_model).pars[217]
#define	p1_799  (*amigo_model).pars[218]
#define	p1_803  (*amigo_model).pars[219]
#define	p1_827  (*amigo_model).pars[220]
#define	p1_1566 (*amigo_model).pars[221]
#define	p2_2    (*amigo_model).pars[222]
#define	p2_3    (*amigo_model).pars[223]
#define	p2_284  (*amigo_model).pars[224]
#define	p2_419  (*amigo_model).pars[225]
#define	p2_640  (*amigo_model).pars[226]
#define	p2_673  (*amigo_model).pars[227]
#define	p2_687  (*amigo_model).pars[228]
#define	p2_691  (*amigo_model).pars[229]
#define	p2_693  (*amigo_model).pars[230]
#define	p2_695  (*amigo_model).pars[231]
#define	p2_773  (*amigo_model).pars[232]
#define	p2_777  (*amigo_model).pars[233]
#define U_IPTG	((*amigo_model).controls_v[0][(*amigo_model).index_t_stim]+(t-(*amigo_model).tlast)*(*amigo_model).slope[0][(*amigo_model).index_t_stim])
#define U_ATC 	((*amigo_model).controls_v[1][(*amigo_model).index_t_stim]+(t-(*amigo_model).tlast)*(*amigo_model).slope[1][(*amigo_model).index_t_stim])
/* Right hand side of the system (f(t,x,p))*/
int amigoRHS(realtype t, N_Vector y, N_Vector ydot, void *data){
	AMIGO_model* amigo_model=(AMIGO_model*)data;

	/* *** Definition of the algebraic variables *** */


	/* *** Equations *** */

	dRFP=p1_2*RFP+p1_9*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/1.1,1))),2))+p1_11*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/1.1,2))),2))+p1_13*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/2.1,1))),2))+p1_15*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/2.1,2))),2))+p1_17*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/3.1,1))),2))+p1_18*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/3.1,2))),1))+p1_19*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/3.1,2))),2))+p1_21*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/4.1,1))),2))+p1_22*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/4.1,2))),1))+p1_23*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/4.1,2))),2))+p1_25*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/5.1,1))),2))+p1_26*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/5.1,2))),1))+p1_27*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/5.1,2))),2))+p1_28*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/6.1,1))),1))+p1_29*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/6.1,1))),2))+p1_30*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/6.1,2))),1))+p1_31*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/6.1,2))),2))+p1_32*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/7.1,1))),1))+p1_33*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/7.1,1))),2))+p1_34*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/7.1,2))),1))+p1_35*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/7.1,2))),2))+p1_36*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/8.1,1))),1))+p1_37*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/8.1,1))),2))+p1_38*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/8.1,2))),1))+p1_39*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/8.1,2))),2))+p1_40*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/9.1,1))),1))+p1_41*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/9.1,1))),2))+p1_42*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/9.1,2))),1))+p1_43*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/9.1,2))),2))+p1_49*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/1.1,1))),2))+p1_51*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/1.1,2))),2))+p1_53*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/2.1,1))),2))+p1_55*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/2.1,2))),2))+p1_57*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/3.1,1))),2))+p1_58*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/3.1,2))),1))+p1_59*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/3.1,2))),2))+p1_61*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/4.1,1))),2))+p1_62*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/4.1,2))),1))+p1_63*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/4.1,2))),2))+p1_65*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/5.1,1))),2))+p1_66*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/5.1,2))),1))+p1_67*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/5.1,2))),2))+p1_69*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/6.1,1))),2))+p1_70*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/6.1,2))),1))+p1_71*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/6.1,2))),2))+p1_73*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/7.1,1))),2))+p1_74*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/7.1,2))),1))+p1_75*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/7.1,2))),2))+p1_77*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/8.1,1))),2))+p1_78*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/8.1,2))),1))+p1_79*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/8.1,2))),2))+p1_80*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/9.1,1))),1))+p1_81*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/9.1,1))),2))+p1_82*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/9.1,2))),1))+p1_83*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/9.1,2))),2))+p1_93*1/(1+pow((RFP/3)*(1/(1+pow(U_IPTG/2.1,1))),2))+p1_95*1/(1+pow((RFP/3)*(1/(1+pow(U_IPTG/2.1,2))),2))+p1_97*1/(1+pow((RFP/3)*(1/(1+pow(U_IPTG/3.1,1))),2))+p1_99*1/(1+pow((RFP/3)*(1/(1+pow(U_IPTG/3.1,2))),2))+p1_101*1/(1+pow((RFP/3)*(1/(1+pow(U_IPTG/4.1,1))),2))+p1_102*1/(1+pow((RFP/3)*(1/(1+pow(U_IPTG/4.1,2))),1))+p1_103*1/(1+pow((RFP/3)*(1/(1+pow(U_IPTG/4.1,2))),2))+p1_105*1/(1+pow((RFP/3)*(1/(1+pow(U_IPTG/5.1,1))),2))+p1_107*1/(1+pow((RFP/3)*(1/(1+pow(U_IPTG/5.1,2))),2))+p1_109*1/(1+pow((RFP/3)*(1/(1+pow(U_IPTG/6.1,1))),2))+p1_111*1/(1+pow((RFP/3)*(1/(1+pow(U_IPTG/6.1,2))),2))+p1_113*1/(1+pow((RFP/3)*(1/(1+pow(U_IPTG/7.1,1))),2))+p1_115*1/(1+pow((RFP/3)*(1/(1+pow(U_IPTG/7.1,2))),2))+p1_117*1/(1+pow((RFP/3)*(1/(1+pow(U_IPTG/8.1,1))),2))+p1_119*1/(1+pow((RFP/3)*(1/(1+pow(U_IPTG/8.1,2))),2))+p1_121*1/(1+pow((RFP/3)*(1/(1+pow(U_IPTG/9.1,1))),2))+p1_123*1/(1+pow((RFP/3)*(1/(1+pow(U_IPTG/9.1,2))),2))+p1_135*1/(1+pow((RFP/4)*(1/(1+pow(U_IPTG/2.1,2))),2))+p1_137*1/(1+pow((RFP/4)*(1/(1+pow(U_IPTG/3.1,1))),2))+p1_139*1/(1+pow((RFP/4)*(1/(1+pow(U_IPTG/3.1,2))),2))+p1_141*1/(1+pow((RFP/4)*(1/(1+pow(U_IPTG/4.1,1))),2))+p1_142*1/(1+pow((RFP/4)*(1/(1+pow(U_IPTG/4.1,2))),1))+p1_143*1/(1+pow((RFP/4)*(1/(1+pow(U_IPTG/4.1,2))),2))+p1_145*1/(1+pow((RFP/4)*(1/(1+pow(U_IPTG/5.1,1))),2))+p1_147*1/(1+pow((RFP/4)*(1/(1+pow(U_IPTG/5.1,2))),2))+p1_149*1/(1+pow((RFP/4)*(1/(1+pow(U_IPTG/6.1,1))),2))+p1_151*1/(1+pow((RFP/4)*(1/(1+pow(U_IPTG/6.1,2))),2))+p1_153*1/(1+pow((RFP/4)*(1/(1+pow(U_IPTG/7.1,1))),2))+p1_155*1/(1+pow((RFP/4)*(1/(1+pow(U_IPTG/7.1,2))),2))+p1_157*1/(1+pow((RFP/4)*(1/(1+pow(U_IPTG/8.1,1))),2))+p1_159*1/(1+pow((RFP/4)*(1/(1+pow(U_IPTG/8.1,2))),2))+p1_161*1/(1+pow((RFP/4)*(1/(1+pow(U_IPTG/9.1,1))),2))+p1_163*1/(1+pow((RFP/4)*(1/(1+pow(U_IPTG/9.1,2))),2))+p1_175*1/(1+pow((RFP/5)*(1/(1+pow(U_IPTG/2.1,2))),2))+p1_179*1/(1+pow((RFP/5)*(1/(1+pow(U_IPTG/3.1,2))),2))+p1_181*1/(1+pow((RFP/5)*(1/(1+pow(U_IPTG/4.1,1))),2))+p1_182*1/(1+pow((RFP/5)*(1/(1+pow(U_IPTG/4.1,2))),1))+p1_183*1/(1+pow((RFP/5)*(1/(1+pow(U_IPTG/4.1,2))),2))+p1_185*1/(1+pow((RFP/5)*(1/(1+pow(U_IPTG/5.1,1))),2))+p1_187*1/(1+pow((RFP/5)*(1/(1+pow(U_IPTG/5.1,2))),2))+p1_189*1/(1+pow((RFP/5)*(1/(1+pow(U_IPTG/6.1,1))),2))+p1_191*1/(1+pow((RFP/5)*(1/(1+pow(U_IPTG/6.1,2))),2))+p1_193*1/(1+pow((RFP/5)*(1/(1+pow(U_IPTG/7.1,1))),2))+p1_195*1/(1+pow((RFP/5)*(1/(1+pow(U_IPTG/7.1,2))),2))+p1_197*1/(1+pow((RFP/5)*(1/(1+pow(U_IPTG/8.1,1))),2))+p1_199*1/(1+pow((RFP/5)*(1/(1+pow(U_IPTG/8.1,2))),2))+p1_201*1/(1+pow((RFP/5)*(1/(1+pow(U_IPTG/9.1,1))),2))+p1_203*1/(1+pow((RFP/5)*(1/(1+pow(U_IPTG/9.1,2))),2))+p1_219*1/(1+pow((RFP/6)*(1/(1+pow(U_IPTG/3.1,2))),2))+p1_222*1/(1+pow((RFP/6)*(1/(1+pow(U_IPTG/4.1,2))),1))+p1_223*1/(1+pow((RFP/6)*(1/(1+pow(U_IPTG/4.1,2))),2))+p1_225*1/(1+pow((RFP/6)*(1/(1+pow(U_IPTG/5.1,1))),2))+p1_227*1/(1+pow((RFP/6)*(1/(1+pow(U_IPTG/5.1,2))),2))+p1_229*1/(1+pow((RFP/6)*(1/(1+pow(U_IPTG/6.1,1))),2))+p1_231*1/(1+pow((RFP/6)*(1/(1+pow(U_IPTG/6.1,2))),2))+p1_233*1/(1+pow((RFP/6)*(1/(1+pow(U_IPTG/7.1,1))),2))+p1_235*1/(1+pow((RFP/6)*(1/(1+pow(U_IPTG/7.1,2))),2))+p1_237*1/(1+pow((RFP/6)*(1/(1+pow(U_IPTG/8.1,1))),2))+p1_239*1/(1+pow((RFP/6)*(1/(1+pow(U_IPTG/8.1,2))),2))+p1_241*1/(1+pow((RFP/6)*(1/(1+pow(U_IPTG/9.1,1))),2))+p1_243*1/(1+pow((RFP/6)*(1/(1+pow(U_IPTG/9.1,2))),2))+p1_259*1/(1+pow((RFP/7)*(1/(1+pow(U_IPTG/3.1,2))),2))+p1_263*1/(1+pow((RFP/7)*(1/(1+pow(U_IPTG/4.1,2))),2))+p1_267*1/(1+pow((RFP/7)*(1/(1+pow(U_IPTG/5.1,2))),2))+p1_271*1/(1+pow((RFP/7)*(1/(1+pow(U_IPTG/6.1,2))),2))+p1_273*1/(1+pow((RFP/7)*(1/(1+pow(U_IPTG/7.1,1))),2))+p1_275*1/(1+pow((RFP/7)*(1/(1+pow(U_IPTG/7.1,2))),2))+p1_277*1/(1+pow((RFP/7)*(1/(1+pow(U_IPTG/8.1,1))),2))+p1_279*1/(1+pow((RFP/7)*(1/(1+pow(U_IPTG/8.1,2))),2))+p1_281*1/(1+pow((RFP/7)*(1/(1+pow(U_IPTG/9.1,1))),2))+p1_283*1/(1+pow((RFP/7)*(1/(1+pow(U_IPTG/9.1,2))),2))+p1_287*1/(1+pow((RFP/8)*(1/(1+pow(U_IPTG/0.1,2))),2))+p1_299*1/(1+pow((RFP/8)*(1/(1+pow(U_IPTG/3.1,2))),2))+p1_303*1/(1+pow((RFP/8)*(1/(1+pow(U_IPTG/4.1,2))),2))+p1_307*1/(1+pow((RFP/8)*(1/(1+pow(U_IPTG/5.1,2))),2))+p1_311*1/(1+pow((RFP/8)*(1/(1+pow(U_IPTG/6.1,2))),2))+p1_315*1/(1+pow((RFP/8)*(1/(1+pow(U_IPTG/7.1,2))),2))+p1_319*1/(1+pow((RFP/8)*(1/(1+pow(U_IPTG/8.1,2))),2))+p1_321*1/(1+pow((RFP/8)*(1/(1+pow(U_IPTG/9.1,1))),2))+p1_323*1/(1+pow((RFP/8)*(1/(1+pow(U_IPTG/9.1,2))),2))+p1_343*1/(1+pow((RFP/9)*(1/(1+pow(U_IPTG/4.1,2))),2))+p1_347*1/(1+pow((RFP/9)*(1/(1+pow(U_IPTG/5.1,2))),2))+p1_351*1/(1+pow((RFP/9)*(1/(1+pow(U_IPTG/6.1,2))),2))+p1_355*1/(1+pow((RFP/9)*(1/(1+pow(U_IPTG/7.1,2))),2))+p1_359*1/(1+pow((RFP/9)*(1/(1+pow(U_IPTG/8.1,2))),2))+p1_363*1/(1+pow((RFP/9)*(1/(1+pow(U_IPTG/9.1,2))),2))+p1_383*1/(1+pow((RFP/10)*(1/(1+pow(U_IPTG/4.1,2))),2))+p1_387*1/(1+pow((RFP/10)*(1/(1+pow(U_IPTG/5.1,2))),2))+p1_391*1/(1+pow((RFP/10)*(1/(1+pow(U_IPTG/6.1,2))),2))+p1_395*1/(1+pow((RFP/10)*(1/(1+pow(U_IPTG/7.1,2))),2))+p1_399*1/(1+pow((RFP/10)*(1/(1+pow(U_IPTG/8.1,2))),2))+p1_403*1/(1+pow((RFP/10)*(1/(1+pow(U_IPTG/9.1,2))),2))+p1_423*1/(1+pow((RFP/11)*(1/(1+pow(U_IPTG/4.1,2))),2))+p1_427*1/(1+pow((RFP/11)*(1/(1+pow(U_IPTG/5.1,2))),2))+p1_431*1/(1+pow((RFP/11)*(1/(1+pow(U_IPTG/6.1,2))),2))+p1_435*1/(1+pow((RFP/11)*(1/(1+pow(U_IPTG/7.1,2))),2))+p1_439*1/(1+pow((RFP/11)*(1/(1+pow(U_IPTG/8.1,2))),2))+p1_443*1/(1+pow((RFP/11)*(1/(1+pow(U_IPTG/9.1,2))),2))+p1_463*1/(1+pow((RFP/12)*(1/(1+pow(U_IPTG/4.1,2))),2))+p1_467*1/(1+pow((RFP/12)*(1/(1+pow(U_IPTG/5.1,2))),2))+p1_471*1/(1+pow((RFP/12)*(1/(1+pow(U_IPTG/6.1,2))),2))+p1_475*1/(1+pow((RFP/12)*(1/(1+pow(U_IPTG/7.1,2))),2))+p1_479*1/(1+pow((RFP/12)*(1/(1+pow(U_IPTG/8.1,2))),2))+p1_483*1/(1+pow((RFP/12)*(1/(1+pow(U_IPTG/9.1,2))),2))+p1_503*1/(1+pow((RFP/13)*(1/(1+pow(U_IPTG/4.1,2))),2))+p1_506*1/(1+pow((RFP/13)*(1/(1+pow(U_IPTG/5.1,2))),1))+p1_507*1/(1+pow((RFP/13)*(1/(1+pow(U_IPTG/5.1,2))),2))+p1_511*1/(1+pow((RFP/13)*(1/(1+pow(U_IPTG/6.1,2))),2))+p1_515*1/(1+pow((RFP/13)*(1/(1+pow(U_IPTG/7.1,2))),2))+p1_519*1/(1+pow((RFP/13)*(1/(1+pow(U_IPTG/8.1,2))),2))+p1_523*1/(1+pow((RFP/13)*(1/(1+pow(U_IPTG/9.1,2))),2))+p1_546*1/(1+pow((RFP/14)*(1/(1+pow(U_IPTG/5.1,2))),1))+p1_547*1/(1+pow((RFP/14)*(1/(1+pow(U_IPTG/5.1,2))),2))+p1_551*1/(1+pow((RFP/14)*(1/(1+pow(U_IPTG/6.1,2))),2))+p1_555*1/(1+pow((RFP/14)*(1/(1+pow(U_IPTG/7.1,2))),2))+p1_559*1/(1+pow((RFP/14)*(1/(1+pow(U_IPTG/8.1,2))),2))+p1_563*1/(1+pow((RFP/14)*(1/(1+pow(U_IPTG/9.1,2))),2))+p1_566*1/(1+pow((RFP/15)*(1/(1+pow(U_IPTG/0.1,2))),1))+p1_582*1/(1+pow((RFP/15)*(1/(1+pow(U_IPTG/4.1,2))),1))+p1_586*1/(1+pow((RFP/15)*(1/(1+pow(U_IPTG/5.1,2))),1))+p1_587*1/(1+pow((RFP/15)*(1/(1+pow(U_IPTG/5.1,2))),2))+p1_591*1/(1+pow((RFP/15)*(1/(1+pow(U_IPTG/6.1,2))),2))+p1_595*1/(1+pow((RFP/15)*(1/(1+pow(U_IPTG/7.1,2))),2))+p1_599*1/(1+pow((RFP/15)*(1/(1+pow(U_IPTG/8.1,2))),2))+p1_603*1/(1+pow((RFP/15)*(1/(1+pow(U_IPTG/9.1,2))),2))+p1_606*1/(1+pow((RFP/16)*(1/(1+pow(U_IPTG/0.1,2))),1))+p1_607*1/(1+pow((RFP/16)*(1/(1+pow(U_IPTG/0.1,2))),2))+p1_622*1/(1+pow((RFP/16)*(1/(1+pow(U_IPTG/4.1,2))),1))+p1_626*1/(1+pow((RFP/16)*(1/(1+pow(U_IPTG/5.1,2))),1))+p1_627*1/(1+pow((RFP/16)*(1/(1+pow(U_IPTG/5.1,2))),2))+p1_631*1/(1+pow((RFP/16)*(1/(1+pow(U_IPTG/6.1,2))),2))+p1_635*1/(1+pow((RFP/16)*(1/(1+pow(U_IPTG/7.1,2))),2))+p1_639*1/(1+pow((RFP/16)*(1/(1+pow(U_IPTG/8.1,2))),2))+p1_643*1/(1+pow((RFP/16)*(1/(1+pow(U_IPTG/9.1,2))),2))+p1_647*1/(1+pow((RFP/17)*(1/(1+pow(U_IPTG/0.1,2))),2))+p1_662*1/(1+pow((RFP/17)*(1/(1+pow(U_IPTG/4.1,2))),1))+p1_666*1/(1+pow((RFP/17)*(1/(1+pow(U_IPTG/5.1,2))),1))+p1_667*1/(1+pow((RFP/17)*(1/(1+pow(U_IPTG/5.1,2))),2))+p1_671*1/(1+pow((RFP/17)*(1/(1+pow(U_IPTG/6.1,2))),2))+p1_675*1/(1+pow((RFP/17)*(1/(1+pow(U_IPTG/7.1,2))),2))+p1_679*1/(1+pow((RFP/17)*(1/(1+pow(U_IPTG/8.1,2))),2))+p1_683*1/(1+pow((RFP/17)*(1/(1+pow(U_IPTG/9.1,2))),2))+p1_702*1/(1+pow((RFP/18)*(1/(1+pow(U_IPTG/4.1,2))),1))+p1_706*1/(1+pow((RFP/18)*(1/(1+pow(U_IPTG/5.1,2))),1))+p1_707*1/(1+pow((RFP/18)*(1/(1+pow(U_IPTG/5.1,2))),2))+p1_711*1/(1+pow((RFP/18)*(1/(1+pow(U_IPTG/6.1,2))),2))+p1_715*1/(1+pow((RFP/18)*(1/(1+pow(U_IPTG/7.1,2))),2))+p1_719*1/(1+pow((RFP/18)*(1/(1+pow(U_IPTG/8.1,2))),2))+p1_723*1/(1+pow((RFP/18)*(1/(1+pow(U_IPTG/9.1,2))),2))+p1_742*1/(1+pow((RFP/19)*(1/(1+pow(U_IPTG/4.1,2))),1))+p1_746*1/(1+pow((RFP/19)*(1/(1+pow(U_IPTG/5.1,2))),1))+p1_747*1/(1+pow((RFP/19)*(1/(1+pow(U_IPTG/5.1,2))),2))+p1_751*1/(1+pow((RFP/19)*(1/(1+pow(U_IPTG/6.1,2))),2))+p1_755*1/(1+pow((RFP/19)*(1/(1+pow(U_IPTG/7.1,2))),2))+p1_759*1/(1+pow((RFP/19)*(1/(1+pow(U_IPTG/8.1,2))),2))+p1_763*1/(1+pow((RFP/19)*(1/(1+pow(U_IPTG/9.1,2))),2))+p1_767*1/(1+pow((RFP/20)*(1/(1+pow(U_IPTG/0.1,2))),2))+p1_782*1/(1+pow((RFP/20)*(1/(1+pow(U_IPTG/4.1,2))),1))+p1_786*1/(1+pow((RFP/20)*(1/(1+pow(U_IPTG/5.1,2))),1))+p1_787*1/(1+pow((RFP/20)*(1/(1+pow(U_IPTG/5.1,2))),2))+p1_791*1/(1+pow((RFP/20)*(1/(1+pow(U_IPTG/6.1,2))),2))+p1_795*1/(1+pow((RFP/20)*(1/(1+pow(U_IPTG/7.1,2))),2))+p1_799*1/(1+pow((RFP/20)*(1/(1+pow(U_IPTG/8.1,2))),2))+p1_803*1/(1+pow((RFP/20)*(1/(1+pow(U_IPTG/9.1,2))),2))+p1_827*1/(1+pow((GFP/1)*(1/(1+pow(U_ATC/5.1,2))),2))+p1_1566*1/(1+pow((GFP/20)*(1/(1+pow(U_ATC/0.1,2))),1));
	dGFP=p2_2*RFP+p2_3*GFP+p2_284*1/(1+pow((RFP/71)*(1/(1+pow(U_IPTG/0.1,1))),1))+p2_419*1/(1+pow((GFP/1)*(1/(1+pow(U_ATC/3.1,2))),2))+p2_640*1/(1+pow((GFP/51)*(1/(1+pow(U_ATC/9.1,1))),1))+p2_673*1/(1+pow((GFP/61)*(1/(1+pow(U_ATC/7.1,1))),2))+p2_687*1/(1+pow((GFP/71)*(1/(1+pow(U_ATC/0.1,2))),2))+p2_691*1/(1+pow((GFP/71)*(1/(1+pow(U_ATC/1.1,2))),2))+p2_693*1/(1+pow((GFP/71)*(1/(1+pow(U_ATC/2.1,1))),2))+p2_695*1/(1+pow((GFP/71)*(1/(1+pow(U_ATC/2.1,2))),2))+p2_773*1/(1+pow((GFP/91)*(1/(1+pow(U_ATC/2.1,1))),2))+p2_777*1/(1+pow((GFP/91)*(1/(1+pow(U_ATC/3.1,1))),2));

	return(0);

}


/* Jacobian of the system (dfdx)*/
int amigoJAC(long int N, realtype t, N_Vector y, N_Vector fy, DlsMat J, void *user_data, N_Vector tmp1, N_Vector tmp2, N_Vector tmp3){
	AMIGO_model* amigo_model=(AMIGO_model*)user_data;

	return(0);
}

/* R.H.S of the sensitivity dsi/dt = (df/dx)*si + df/dp_i */
int amigoSensRHS(int Ns, realtype t, N_Vector y, N_Vector ydot, int iS, N_Vector yS, N_Vector ySdot, void *data, N_Vector tmp1, N_Vector tmp2){
	AMIGO_model* amigo_model=(AMIGO_model*)data;

	return(0);

}

#define	 RFP (amigo_model->sim_results[0][j]) 
#define	 GFP (amigo_model->sim_results[1][j]) 



void amigoRHS_get_OBS(void* data){

	int j;

	double t;
	AMIGO_model* amigo_model=(AMIGO_model*)data;


	 switch (amigo_model->exp_num){

		#define	 RFP_o amigo_model->obs_results[0][j] 
		#define	 GFP_o amigo_model->obs_results[1][j] 

		 case 0:


			 for (j = 0; j < amigo_model->n_times; ++j){

				t=amigo_model->t[j];
				RFP_o=RFP;
				GFP_o=GFP;

			}

		 break;

	}

	

}

#define	 RFP (amigo_model->sens_results[0][j][k]) 
#define	 GFP (amigo_model->sens_results[1][j][k]) 



void amigoRHS_get_sens_OBS(void* data){
	int j,k;

	double t;

	AMIGO_model* amigo_model=(AMIGO_model*)data;


	 switch (amigo_model->exp_num){


		 case 0:

		#define	 RFP_o amigo_model->sens_obs[0][j][k] 
		#define	 GFP_o amigo_model->sens_obs[1][j][k] 

			 for (j = 0; j < amigo_model->n_total_x; ++j){
				 for (k = 0; k < amigo_model->n_times; ++k){

				t=amigo_model->t[k];
					RFP_o=RFP;
					GFP_o=GFP;
				}
			}
		 break;
	}
}


void amigo_Y_at_tcon(void* data,realtype t, N_Vector y){
	AMIGO_model* amigo_model=(AMIGO_model*)data;


}
