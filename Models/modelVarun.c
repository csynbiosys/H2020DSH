#include <amigoRHS.h>

#include <math.h>

#include <amigoJAC.h>

#include <amigoSensRHS.h>


	/* *** Definition of the states *** */

#define	L_RFP   Ith(y,0)
#define	T_GFP   Ith(y,1)
#define	IPTGi   Ith(y,2)
#define	aTci    Ith(y,3)
#define	mrnaRFP Ith(y,4)
#define	mrnaGFP Ith(y,5)
#define iexp amigo_model->exp_num

	/* *** Definition of the sates derivative *** */

#define	dL_RFP   Ith(ydot,0)
#define	dT_GFP   Ith(ydot,1)
#define	dIPTGi   Ith(ydot,2)
#define	daTci    Ith(ydot,3)
#define	dmrnaRFP Ith(ydot,4)
#define	dmrnaGFP Ith(ydot,5)

	/* *** Definition of the parameters *** */

#define	g_mG       (*amigo_model).pars[0]
#define	g_mR       (*amigo_model).pars[1]
#define	theta_T    (*amigo_model).pars[2]
#define	theta_aTc  (*amigo_model).pars[3]
#define	theta_L    (*amigo_model).pars[4]
#define	theta_IPTG (*amigo_model).pars[5]
#define	sc_T_molec (*amigo_model).pars[6]
#define	sc_L_molec (*amigo_model).pars[7]
#define	k_iptg     (*amigo_model).pars[8]
#define	k_aTc      (*amigo_model).pars[9]
#define	n_mrnaRFP  (*amigo_model).pars[10]
#define	k_mrnaRFP  (*amigo_model).pars[11]
#define	n_mrnaGFP  (*amigo_model).pars[12]
#define	k_mrnaGFP  (*amigo_model).pars[13]
#define	n_T        (*amigo_model).pars[14]
#define	n_aTc      (*amigo_model).pars[15]
#define	n_L        (*amigo_model).pars[16]
#define	n_IPTG     (*amigo_model).pars[17]
#define u_IPTG	((*amigo_model).controls_v[0][(*amigo_model).index_t_stim]+(t-(*amigo_model).tlast)*(*amigo_model).slope[0][(*amigo_model).index_t_stim])
#define u_aTc 	((*amigo_model).controls_v[1][(*amigo_model).index_t_stim]+(t-(*amigo_model).tlast)*(*amigo_model).slope[1][(*amigo_model).index_t_stim])
/* Right hand side of the system (f(t,x,p))*/
int amigoRHS(realtype t, N_Vector y, N_Vector ydot, void *data){
	AMIGO_model* amigo_model=(AMIGO_model*)data;

	/* *** Definition of the algebraic variables *** */


	/* *** Equations *** */

	dL_RFP=sc_L_molec*(pow(mrnaRFP,n_mrnaRFP)/(pow(mrnaRFP,n_mrnaRFP)+pow(k_mrnaRFP,n_mrnaRFP))-L_RFP);
	dT_GFP=sc_T_molec*(pow(mrnaGFP,n_mrnaGFP)/(pow(mrnaGFP,n_mrnaGFP)+pow(k_mrnaGFP,n_mrnaGFP))-T_GFP);
	dIPTGi=k_iptg*(u_IPTG-IPTGi);
	daTci=k_aTc*(u_aTc-aTci);
	dmrnaRFP=g_mR*((1/(1+pow(T_GFP/theta_T,n_T)))*(1/(1+pow(aTci/theta_aTc,n_aTc)))-mrnaRFP);
	dmrnaGFP=g_mG*((1/(1+pow(L_RFP/theta_L,n_L)))*(1/(1+pow(IPTGi/theta_IPTG,n_IPTG)))-mrnaGFP);

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

#define	 L_RFP   (amigo_model->sim_results[0][j]) 
#define	 T_GFP   (amigo_model->sim_results[1][j]) 
#define	 IPTGi   (amigo_model->sim_results[2][j]) 
#define	 aTci    (amigo_model->sim_results[3][j]) 
#define	 mrnaRFP (amigo_model->sim_results[4][j]) 
#define	 mrnaGFP (amigo_model->sim_results[5][j]) 



void amigoRHS_get_OBS(void* data){

	int j;

	double t;
	AMIGO_model* amigo_model=(AMIGO_model*)data;


	 switch (amigo_model->exp_num){

		#define	 RFP amigo_model->obs_results[0][j] 
		#define	 GFP amigo_model->obs_results[1][j] 

		 case 0:


			 for (j = 0; j < amigo_model->n_times; ++j){

				t=amigo_model->t[j];
				RFP = L_RFP;
				GFP = T_GFP;

			}

		 break;
		#define	 RFP amigo_model->obs_results[0][j] 
		#define	 GFP amigo_model->obs_results[1][j] 

		 case 1:


			 for (j = 0; j < amigo_model->n_times; ++j){

				t=amigo_model->t[j];
				RFP = L_RFP;
				GFP = T_GFP;

			}

		 break;
		#define	 RFP amigo_model->obs_results[0][j] 
		#define	 GFP amigo_model->obs_results[1][j] 

		 case 2:


			 for (j = 0; j < amigo_model->n_times; ++j){

				t=amigo_model->t[j];
				RFP = L_RFP;
				GFP = T_GFP;

			}

		 break;
		#define	 RFP amigo_model->obs_results[0][j] 
		#define	 GFP amigo_model->obs_results[1][j] 

		 case 3:


			 for (j = 0; j < amigo_model->n_times; ++j){

				t=amigo_model->t[j];
				RFP = L_RFP;
				GFP = T_GFP;

			}

		 break;
		#define	 RFP amigo_model->obs_results[0][j] 
		#define	 GFP amigo_model->obs_results[1][j] 

		 case 4:


			 for (j = 0; j < amigo_model->n_times; ++j){

				t=amigo_model->t[j];
				RFP = L_RFP;
				GFP = T_GFP;

			}

		 break;
		#define	 RFP amigo_model->obs_results[0][j] 
		#define	 GFP amigo_model->obs_results[1][j] 

		 case 5:


			 for (j = 0; j < amigo_model->n_times; ++j){

				t=amigo_model->t[j];
				RFP = L_RFP;
				GFP = T_GFP;

			}

		 break;
		#define	 RFP amigo_model->obs_results[0][j] 
		#define	 GFP amigo_model->obs_results[1][j] 

		 case 6:


			 for (j = 0; j < amigo_model->n_times; ++j){

				t=amigo_model->t[j];
				RFP = L_RFP;
				GFP = T_GFP;

			}

		 break;
		#define	 RFP amigo_model->obs_results[0][j] 
		#define	 GFP amigo_model->obs_results[1][j] 

		 case 7:


			 for (j = 0; j < amigo_model->n_times; ++j){

				t=amigo_model->t[j];
				RFP = L_RFP;
				GFP = T_GFP;

			}

		 break;
		#define	 RFP amigo_model->obs_results[0][j] 
		#define	 GFP amigo_model->obs_results[1][j] 

		 case 8:


			 for (j = 0; j < amigo_model->n_times; ++j){

				t=amigo_model->t[j];
				RFP = L_RFP;
				GFP = T_GFP;

			}

		 break;
		#define	 RFP amigo_model->obs_results[0][j] 
		#define	 GFP amigo_model->obs_results[1][j] 

		 case 9:


			 for (j = 0; j < amigo_model->n_times; ++j){

				t=amigo_model->t[j];
				RFP = L_RFP;
				GFP = T_GFP;

			}

		 break;
		#define	 RFP amigo_model->obs_results[0][j] 
		#define	 GFP amigo_model->obs_results[1][j] 

		 case 10:


			 for (j = 0; j < amigo_model->n_times; ++j){

				t=amigo_model->t[j];
				RFP = L_RFP;
				GFP = T_GFP;

			}

		 break;
		#define	 RFP amigo_model->obs_results[0][j] 
		#define	 GFP amigo_model->obs_results[1][j] 

		 case 11:


			 for (j = 0; j < amigo_model->n_times; ++j){

				t=amigo_model->t[j];
				RFP = L_RFP;
				GFP = T_GFP;

			}

		 break;
		#define	 RFP amigo_model->obs_results[0][j] 
		#define	 GFP amigo_model->obs_results[1][j] 

		 case 12:


			 for (j = 0; j < amigo_model->n_times; ++j){

				t=amigo_model->t[j];
				RFP = L_RFP;
				GFP = T_GFP;

			}

		 break;

	}

	

}

#define	 L_RFP   (amigo_model->sens_results[0][j][k]) 
#define	 T_GFP   (amigo_model->sens_results[1][j][k]) 
#define	 IPTGi   (amigo_model->sens_results[2][j][k]) 
#define	 aTci    (amigo_model->sens_results[3][j][k]) 
#define	 mrnaRFP (amigo_model->sens_results[4][j][k]) 
#define	 mrnaGFP (amigo_model->sens_results[5][j][k]) 



void amigoRHS_get_sens_OBS(void* data){
	int j,k;

	double t;

	AMIGO_model* amigo_model=(AMIGO_model*)data;


	 switch (amigo_model->exp_num){


		 case 0:

		#define	 RFP amigo_model->sens_obs[0][j][k] 
		#define	 GFP amigo_model->sens_obs[1][j][k] 

			 for (j = 0; j < amigo_model->n_total_x; ++j){
				 for (k = 0; k < amigo_model->n_times; ++k){

				t=amigo_model->t[k];
					RFP = L_RFP;
					GFP = T_GFP;
				}
			}
		 break;

		 case 1:

		#define	 RFP amigo_model->sens_obs[0][j][k] 
		#define	 GFP amigo_model->sens_obs[1][j][k] 

			 for (j = 0; j < amigo_model->n_total_x; ++j){
				 for (k = 0; k < amigo_model->n_times; ++k){

				t=amigo_model->t[k];
					RFP = L_RFP;
					GFP = T_GFP;
				}
			}
		 break;

		 case 2:

		#define	 RFP amigo_model->sens_obs[0][j][k] 
		#define	 GFP amigo_model->sens_obs[1][j][k] 

			 for (j = 0; j < amigo_model->n_total_x; ++j){
				 for (k = 0; k < amigo_model->n_times; ++k){

				t=amigo_model->t[k];
					RFP = L_RFP;
					GFP = T_GFP;
				}
			}
		 break;

		 case 3:

		#define	 RFP amigo_model->sens_obs[0][j][k] 
		#define	 GFP amigo_model->sens_obs[1][j][k] 

			 for (j = 0; j < amigo_model->n_total_x; ++j){
				 for (k = 0; k < amigo_model->n_times; ++k){

				t=amigo_model->t[k];
					RFP = L_RFP;
					GFP = T_GFP;
				}
			}
		 break;

		 case 4:

		#define	 RFP amigo_model->sens_obs[0][j][k] 
		#define	 GFP amigo_model->sens_obs[1][j][k] 

			 for (j = 0; j < amigo_model->n_total_x; ++j){
				 for (k = 0; k < amigo_model->n_times; ++k){

				t=amigo_model->t[k];
					RFP = L_RFP;
					GFP = T_GFP;
				}
			}
		 break;

		 case 5:

		#define	 RFP amigo_model->sens_obs[0][j][k] 
		#define	 GFP amigo_model->sens_obs[1][j][k] 

			 for (j = 0; j < amigo_model->n_total_x; ++j){
				 for (k = 0; k < amigo_model->n_times; ++k){

				t=amigo_model->t[k];
					RFP = L_RFP;
					GFP = T_GFP;
				}
			}
		 break;

		 case 6:

		#define	 RFP amigo_model->sens_obs[0][j][k] 
		#define	 GFP amigo_model->sens_obs[1][j][k] 

			 for (j = 0; j < amigo_model->n_total_x; ++j){
				 for (k = 0; k < amigo_model->n_times; ++k){

				t=amigo_model->t[k];
					RFP = L_RFP;
					GFP = T_GFP;
				}
			}
		 break;

		 case 7:

		#define	 RFP amigo_model->sens_obs[0][j][k] 
		#define	 GFP amigo_model->sens_obs[1][j][k] 

			 for (j = 0; j < amigo_model->n_total_x; ++j){
				 for (k = 0; k < amigo_model->n_times; ++k){

				t=amigo_model->t[k];
					RFP = L_RFP;
					GFP = T_GFP;
				}
			}
		 break;

		 case 8:

		#define	 RFP amigo_model->sens_obs[0][j][k] 
		#define	 GFP amigo_model->sens_obs[1][j][k] 

			 for (j = 0; j < amigo_model->n_total_x; ++j){
				 for (k = 0; k < amigo_model->n_times; ++k){

				t=amigo_model->t[k];
					RFP = L_RFP;
					GFP = T_GFP;
				}
			}
		 break;

		 case 9:

		#define	 RFP amigo_model->sens_obs[0][j][k] 
		#define	 GFP amigo_model->sens_obs[1][j][k] 

			 for (j = 0; j < amigo_model->n_total_x; ++j){
				 for (k = 0; k < amigo_model->n_times; ++k){

				t=amigo_model->t[k];
					RFP = L_RFP;
					GFP = T_GFP;
				}
			}
		 break;

		 case 10:

		#define	 RFP amigo_model->sens_obs[0][j][k] 
		#define	 GFP amigo_model->sens_obs[1][j][k] 

			 for (j = 0; j < amigo_model->n_total_x; ++j){
				 for (k = 0; k < amigo_model->n_times; ++k){

				t=amigo_model->t[k];
					RFP = L_RFP;
					GFP = T_GFP;
				}
			}
		 break;

		 case 11:

		#define	 RFP amigo_model->sens_obs[0][j][k] 
		#define	 GFP amigo_model->sens_obs[1][j][k] 

			 for (j = 0; j < amigo_model->n_total_x; ++j){
				 for (k = 0; k < amigo_model->n_times; ++k){

				t=amigo_model->t[k];
					RFP = L_RFP;
					GFP = T_GFP;
				}
			}
		 break;

		 case 12:

		#define	 RFP amigo_model->sens_obs[0][j][k] 
		#define	 GFP amigo_model->sens_obs[1][j][k] 

			 for (j = 0; j < amigo_model->n_total_x; ++j){
				 for (k = 0; k < amigo_model->n_times; ++k){

				t=amigo_model->t[k];
					RFP = L_RFP;
					GFP = T_GFP;
				}
			}
		 break;
	}
}


void amigo_Y_at_tcon(void* data,realtype t, N_Vector y){
	AMIGO_model* amigo_model=(AMIGO_model*)data;


}
