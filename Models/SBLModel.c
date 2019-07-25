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
#define	p1_19   (*amigo_model).pars[6]
#define	p1_21   (*amigo_model).pars[7]
#define	p1_23   (*amigo_model).pars[8]
#define	p1_25   (*amigo_model).pars[9]
#define	p1_27   (*amigo_model).pars[10]
#define	p1_29   (*amigo_model).pars[11]
#define	p1_31   (*amigo_model).pars[12]
#define	p1_33   (*amigo_model).pars[13]
#define	p1_35   (*amigo_model).pars[14]
#define	p1_37   (*amigo_model).pars[15]
#define	p1_39   (*amigo_model).pars[16]
#define	p1_41   (*amigo_model).pars[17]
#define	p1_43   (*amigo_model).pars[18]
#define	p1_49   (*amigo_model).pars[19]
#define	p1_51   (*amigo_model).pars[20]
#define	p1_53   (*amigo_model).pars[21]
#define	p1_55   (*amigo_model).pars[22]
#define	p1_57   (*amigo_model).pars[23]
#define	p1_59   (*amigo_model).pars[24]
#define	p1_61   (*amigo_model).pars[25]
#define	p1_63   (*amigo_model).pars[26]
#define	p1_65   (*amigo_model).pars[27]
#define	p1_67   (*amigo_model).pars[28]
#define	p1_69   (*amigo_model).pars[29]
#define	p1_71   (*amigo_model).pars[30]
#define	p1_73   (*amigo_model).pars[31]
#define	p1_75   (*amigo_model).pars[32]
#define	p1_77   (*amigo_model).pars[33]
#define	p1_79   (*amigo_model).pars[34]
#define	p1_81   (*amigo_model).pars[35]
#define	p1_83   (*amigo_model).pars[36]
#define	p1_687  (*amigo_model).pars[37]
#define	p1_727  (*amigo_model).pars[38]
#define	p1_767  (*amigo_model).pars[39]
#define	p1_1533 (*amigo_model).pars[40]
#define	p1_1573 (*amigo_model).pars[41]
#define	p2_2    (*amigo_model).pars[42]
#define	p2_3    (*amigo_model).pars[43]
#define	p2_11   (*amigo_model).pars[44]
#define	p2_13   (*amigo_model).pars[45]
#define	p2_15   (*amigo_model).pars[46]
#define	p2_17   (*amigo_model).pars[47]
#define	p2_19   (*amigo_model).pars[48]
#define	p2_21   (*amigo_model).pars[49]
#define	p2_23   (*amigo_model).pars[50]
#define	p2_25   (*amigo_model).pars[51]
#define	p2_27   (*amigo_model).pars[52]
#define	p2_29   (*amigo_model).pars[53]
#define	p2_31   (*amigo_model).pars[54]
#define	p2_33   (*amigo_model).pars[55]
#define	p2_35   (*amigo_model).pars[56]
#define	p2_37   (*amigo_model).pars[57]
#define	p2_39   (*amigo_model).pars[58]
#define	p2_41   (*amigo_model).pars[59]
#define	p2_43   (*amigo_model).pars[60]
#define	p2_365  (*amigo_model).pars[61]
#define	p2_419  (*amigo_model).pars[62]
#define	p2_469  (*amigo_model).pars[63]
#define U_IPTG	((*amigo_model).controls_v[0][(*amigo_model).index_t_stim]+(t-(*amigo_model).tlast)*(*amigo_model).slope[0][(*amigo_model).index_t_stim])
#define U_ATC 	((*amigo_model).controls_v[1][(*amigo_model).index_t_stim]+(t-(*amigo_model).tlast)*(*amigo_model).slope[1][(*amigo_model).index_t_stim])
/* Right hand side of the system (f(t,x,p))*/
int amigoRHS(realtype t, N_Vector y, N_Vector ydot, void *data){
	AMIGO_model* amigo_model=(AMIGO_model*)data;

	/* *** Definition of the algebraic variables *** */


	/* *** Equations *** */

	dRFP=p1_2*RFP+p1_9*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/1.1,1))),2))+p1_11*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/1.1,2))),2))+p1_13*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/2.1,1))),2))+p1_15*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/2.1,2))),2))+p1_17*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/3.1,1))),2))+p1_19*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/3.1,2))),2))+p1_21*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/4.1,1))),2))+p1_23*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/4.1,2))),2))+p1_25*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/5.1,1))),2))+p1_27*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/5.1,2))),2))+p1_29*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/6.1,1))),2))+p1_31*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/6.1,2))),2))+p1_33*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/7.1,1))),2))+p1_35*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/7.1,2))),2))+p1_37*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/8.1,1))),2))+p1_39*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/8.1,2))),2))+p1_41*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/9.1,1))),2))+p1_43*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/9.1,2))),2))+p1_49*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/1.1,1))),2))+p1_51*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/1.1,2))),2))+p1_53*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/2.1,1))),2))+p1_55*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/2.1,2))),2))+p1_57*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/3.1,1))),2))+p1_59*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/3.1,2))),2))+p1_61*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/4.1,1))),2))+p1_63*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/4.1,2))),2))+p1_65*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/5.1,1))),2))+p1_67*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/5.1,2))),2))+p1_69*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/6.1,1))),2))+p1_71*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/6.1,2))),2))+p1_73*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/7.1,1))),2))+p1_75*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/7.1,2))),2))+p1_77*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/8.1,1))),2))+p1_79*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/8.1,2))),2))+p1_81*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/9.1,1))),2))+p1_83*1/(1+pow((RFP/2)*(1/(1+pow(U_IPTG/9.1,2))),2))+p1_687*1/(1+pow((RFP/18)*(1/(1+pow(U_IPTG/0.1,2))),2))+p1_727*1/(1+pow((RFP/19)*(1/(1+pow(U_IPTG/0.1,2))),2))+p1_767*1/(1+pow((RFP/20)*(1/(1+pow(U_IPTG/0.1,2))),2))+p1_1533*1/(1+pow((GFP/19)*(1/(1+pow(U_ATC/2.1,1))),2))+p1_1573*1/(1+pow((GFP/20)*(1/(1+pow(U_ATC/2.1,1))),2));
	dGFP=p2_2*RFP+p2_3*GFP+p2_11*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/1.1,2))),2))+p2_13*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/2.1,1))),2))+p2_15*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/2.1,2))),2))+p2_17*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/3.1,1))),2))+p2_19*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/3.1,2))),2))+p2_21*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/4.1,1))),2))+p2_23*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/4.1,2))),2))+p2_25*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/5.1,1))),2))+p2_27*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/5.1,2))),2))+p2_29*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/6.1,1))),2))+p2_31*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/6.1,2))),2))+p2_33*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/7.1,1))),2))+p2_35*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/7.1,2))),2))+p2_37*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/8.1,1))),2))+p2_39*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/8.1,2))),2))+p2_41*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/9.1,1))),2))+p2_43*1/(1+pow((RFP/1)*(1/(1+pow(U_IPTG/9.1,2))),2))+p2_365*1/(1+pow((RFP/91)*(1/(1+pow(U_IPTG/0.1,1))),2))+p2_419*1/(1+pow((GFP/1)*(1/(1+pow(U_ATC/3.1,2))),2))+p2_469*1/(1+pow((GFP/11)*(1/(1+pow(U_ATC/6.1,1))),2));

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
