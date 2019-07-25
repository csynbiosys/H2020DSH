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
#define	p1_727  (*amigo_model).pars[1]
#define	p1_767  (*amigo_model).pars[2]
#define	p1_1573 (*amigo_model).pars[3]
#define	p2_2    (*amigo_model).pars[4]
#define	p2_3    (*amigo_model).pars[5]
#define	p2_9    (*amigo_model).pars[6]
#define	p2_11   (*amigo_model).pars[7]
#define	p2_13   (*amigo_model).pars[8]
#define	p2_15   (*amigo_model).pars[9]
#define	p2_17   (*amigo_model).pars[10]
#define	p2_19   (*amigo_model).pars[11]
#define	p2_21   (*amigo_model).pars[12]
#define	p2_23   (*amigo_model).pars[13]
#define	p2_25   (*amigo_model).pars[14]
#define	p2_27   (*amigo_model).pars[15]
#define	p2_29   (*amigo_model).pars[16]
#define	p2_31   (*amigo_model).pars[17]
#define	p2_33   (*amigo_model).pars[18]
#define	p2_35   (*amigo_model).pars[19]
#define	p2_37   (*amigo_model).pars[20]
#define	p2_39   (*amigo_model).pars[21]
#define	p2_41   (*amigo_model).pars[22]
#define	p2_43   (*amigo_model).pars[23]
#define	p2_365  (*amigo_model).pars[24]
#define	p2_419  (*amigo_model).pars[25]
#define	p2_469  (*amigo_model).pars[26]
#define U_IPTG	((*amigo_model).controls_v[0][(*amigo_model).index_t_stim]+(t-(*amigo_model).tlast)*(*amigo_model).slope[0][(*amigo_model).index_t_stim])
#define U_ATC 	((*amigo_model).controls_v[1][(*amigo_model).index_t_stim]+(t-(*amigo_model).tlast)*(*amigo_model).slope[1][(*amigo_model).index_t_stim])
/* Right hand side of the system (f(t,x,p))*/
int amigoRHS(realtype t, N_Vector y, N_Vector ydot, void *data){
	AMIGO_model* amigo_model=(AMIGO_model*)data;

	/* *** Definition of the algebraic variables *** */

