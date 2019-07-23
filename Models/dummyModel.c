#include <amigoRHS.h>

#include <math.h>

#include <amigoJAC.h>

#include <amigoSensRHS.h>


	/* *** Definition of the states *** */

#define	RFP_s Ith(y,0)
#define	GFP_s Ith(y,1)
#define iexp amigo_model->exp_num

	/* *** Definition of the sates derivative *** */

#define	dRFP_s Ith(ydot,0)
#define	dGFP_s Ith(ydot,1)

	/* *** Definition of the parameters *** */

#define	kL_p_m0    (*amigo_model).pars[0]
#define	kL_p_m     (*amigo_model).pars[1]
#define	theta_T    (*amigo_model).pars[2]
#define	theta_aTc  (*amigo_model).pars[3]
#define	n_aTc      (*amigo_model).pars[4]
#define	n_T        (*amigo_model).pars[5]
#define	kT_p_m0    (*amigo_model).pars[6]
#define	kT_p_m     (*amigo_model).pars[7]
#define	theta_L    (*amigo_model).pars[8]
#define	theta_IPTG (*amigo_model).pars[9]
#define	n_IPTG     (*amigo_model).pars[10]
#define	n_L        (*amigo_model).pars[11]
#define	k_iptg     (*amigo_model).pars[12]
#define	k_aTc      (*amigo_model).pars[13]
#define u_IPTG	((*amigo_model).controls_v[0][(*amigo_model).index_t_stim]+(t-(*amigo_model).tlast)*(*amigo_model).slope[0][(*amigo_model).index_t_stim])
#define u_aTc 	((*amigo_model).controls_v[1][(*amigo_model).index_t_stim]+(t-(*amigo_model).tlast)*(*amigo_model).slope[1][(*amigo_model).index_t_stim])
/* Right hand side of the system (f(t,x,p))*/
int amigoRHS(realtype t, N_Vector y, N_Vector ydot, void *data){
	AMIGO_model* amigo_model=(AMIGO_model*)data;

	/* *** Definition of the algebraic variables *** */


	/* *** Equations *** */

	dRFP_s=1/0.1386*(kL_p_m0+(kL_p_m/(1+pow(GFP_s/theta_T*(1/(1+pow(u_aTc/theta_aTc,n_aTc))),n_T))))-0.0165*RFP_s;
	dGFP_s=1/0.1386*(kT_p_m0+(kT_p_m/(1+pow(RFP_s/theta_L*(1/(1+pow(u_IPTG/theta_IPTG,n_IPTG))),n_L))))-0.0165*GFP_s;

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

#define	 RFP_s (amigo_model->sim_results[0][j]) 
#define	 GFP_s (amigo_model->sim_results[1][j]) 



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
				RFP=RFP_s;
				GFP=GFP_s;

			}

		 break;
		#define	 RFP amigo_model->obs_results[0][j] 
		#define	 GFP amigo_model->obs_results[1][j] 

		 case 1:


			 for (j = 0; j < amigo_model->n_times; ++j){

				t=amigo_model->t[j];
				RFP=RFP_s;
				GFP=GFP_s;

			}

		 break;
		#define	 RFP amigo_model->obs_results[0][j] 
		#define	 GFP amigo_model->obs_results[1][j] 

		 case 2:


			 for (j = 0; j < amigo_model->n_times; ++j){

				t=amigo_model->t[j];
				RFP=RFP_s;
				GFP=GFP_s;

			}

		 break;
		#define	 RFP amigo_model->obs_results[0][j] 
		#define	 GFP amigo_model->obs_results[1][j] 

		 case 3:


			 for (j = 0; j < amigo_model->n_times; ++j){

				t=amigo_model->t[j];
				RFP=RFP_s;
				GFP=GFP_s;

			}

		 break;
		#define	 RFP amigo_model->obs_results[0][j] 
		#define	 GFP amigo_model->obs_results[1][j] 

		 case 4:


			 for (j = 0; j < amigo_model->n_times; ++j){

				t=amigo_model->t[j];
				RFP=RFP_s;
				GFP=GFP_s;

			}

		 break;
		#define	 RFP amigo_model->obs_results[0][j] 
		#define	 GFP amigo_model->obs_results[1][j] 

		 case 5:


			 for (j = 0; j < amigo_model->n_times; ++j){

				t=amigo_model->t[j];
				RFP=RFP_s;
				GFP=GFP_s;

			}

		 break;
		#define	 RFP amigo_model->obs_results[0][j] 
		#define	 GFP amigo_model->obs_results[1][j] 

		 case 6:


			 for (j = 0; j < amigo_model->n_times; ++j){

				t=amigo_model->t[j];
				RFP=RFP_s;
				GFP=GFP_s;

			}

		 break;

	}

	

}

#define	 RFP_s (amigo_model->sens_results[0][j][k]) 
#define	 GFP_s (amigo_model->sens_results[1][j][k]) 



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
					RFP=RFP_s;
					GFP=GFP_s;
				}
			}
		 break;

		 case 1:

		#define	 RFP amigo_model->sens_obs[0][j][k] 
		#define	 GFP amigo_model->sens_obs[1][j][k] 

			 for (j = 0; j < amigo_model->n_total_x; ++j){
				 for (k = 0; k < amigo_model->n_times; ++k){

				t=amigo_model->t[k];
					RFP=RFP_s;
					GFP=GFP_s;
				}
			}
		 break;

		 case 2:

		#define	 RFP amigo_model->sens_obs[0][j][k] 
		#define	 GFP amigo_model->sens_obs[1][j][k] 

			 for (j = 0; j < amigo_model->n_total_x; ++j){
				 for (k = 0; k < amigo_model->n_times; ++k){

				t=amigo_model->t[k];
					RFP=RFP_s;
					GFP=GFP_s;
				}
			}
		 break;

		 case 3:

		#define	 RFP amigo_model->sens_obs[0][j][k] 
		#define	 GFP amigo_model->sens_obs[1][j][k] 

			 for (j = 0; j < amigo_model->n_total_x; ++j){
				 for (k = 0; k < amigo_model->n_times; ++k){

				t=amigo_model->t[k];
					RFP=RFP_s;
					GFP=GFP_s;
				}
			}
		 break;

		 case 4:

		#define	 RFP amigo_model->sens_obs[0][j][k] 
		#define	 GFP amigo_model->sens_obs[1][j][k] 

			 for (j = 0; j < amigo_model->n_total_x; ++j){
				 for (k = 0; k < amigo_model->n_times; ++k){

				t=amigo_model->t[k];
					RFP=RFP_s;
					GFP=GFP_s;
				}
			}
		 break;

		 case 5:

		#define	 RFP amigo_model->sens_obs[0][j][k] 
		#define	 GFP amigo_model->sens_obs[1][j][k] 

			 for (j = 0; j < amigo_model->n_total_x; ++j){
				 for (k = 0; k < amigo_model->n_times; ++k){

				t=amigo_model->t[k];
					RFP=RFP_s;
					GFP=GFP_s;
				}
			}
		 break;

		 case 6:

		#define	 RFP amigo_model->sens_obs[0][j][k] 
		#define	 GFP amigo_model->sens_obs[1][j][k] 

			 for (j = 0; j < amigo_model->n_total_x; ++j){
				 for (k = 0; k < amigo_model->n_times; ++k){

				t=amigo_model->t[k];
					RFP=RFP_s;
					GFP=GFP_s;
				}
			}
		 break;
	}
}


void amigo_Y_at_tcon(void* data,realtype t, N_Vector y){
	AMIGO_model* amigo_model=(AMIGO_model*)data;


}
