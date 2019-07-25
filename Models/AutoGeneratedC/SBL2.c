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
#define	p1_767  (*amigo_model).pars[1]
#define	p1_1573 (*amigo_model).pars[2]
#define	p2_2    (*amigo_model).pars[3]
#define	p2_3    (*amigo_model).pars[4]
#define	p2_365  (*amigo_model).pars[5]
#define	p2_419  (*amigo_model).pars[6]
#define	p2_469  (*amigo_model).pars[7]
#define U_IPTG	((*amigo_model).controls_v[0][(*amigo_model).index_t_stim]+(t-(*amigo_model).tlast)*(*amigo_model).slope[0][(*amigo_model).index_t_stim])
#define U_ATC 	((*amigo_model).controls_v[1][(*amigo_model).index_t_stim]+(t-(*amigo_model).tlast)*(*amigo_model).slope[1][(*amigo_model).index_t_stim])
/* Right hand side of the system (f(t,x,p))*/
int amigoRHS(realtype t, N_Vector y, N_Vector ydot, void *data){
	AMIGO_model* amigo_model=(AMIGO_model*)data;

	/* *** Definition of the algebraic variables *** */


	/* *** Equations *** */

	dRFP=p1_2*RFP+p1_767*1/(1+pow((RFP/20)*(1/(1+pow(U_IPTG/0.1,2))),2))+p1_1573*1/(1+pow((GFP/20)*(1/(1+pow(U_ATC/2.1,1))),2));
	dGFP=p2_2*RFP+p2_3*GFP+p2_365*1/(1+pow((RFP/91)*(1/(1+pow(U_IPTG/0.1,1))),2))+p2_419*1/(1+pow((GFP/1)*(1/(1+pow(U_ATC/3.1,2))),2))+p2_469*1/(1+pow((GFP/11)*(1/(1+pow(U_ATC/6.1,1))),2));

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
