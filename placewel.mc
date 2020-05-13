/*----------------------------------------------------------------------+
|                                                                       |
|   ***placewell.mc***     3-8-1995                                     |
|                                                                       |
|                 MDL program to import column formatted ASCII point    |
|                 files into an IGDS design file as spot elevation      |
|                 text.  This program has been modified to use the AAPG |
|		  CSD codes for the formations.                         |
|                                                                       |
|   James McDonald                                                      |
|   Division of Geological Survey                                       |
|   Ohio Department of Natural Resources                                |
|   4383 Fountain Square Drive                                          |
|   Columbus, OH  43220                                                 |
| --------------------------------------------------------------------  |
|                                                                       |
|      The concept of this MDL program was originally derived from the  |
|      MDL program, PNTDATA, that was written by Bill Steinbock for     |
|      the Corps of Engineers.  It was sigificantly modified by         |
|      James McDonald of the Divsion of Geological Survey, Ohio         |
|      Department of Natural Resources to produce this MDL program,     |
|      PLACEWEL.                                                        |
|                                                                       |
+----------------------------------------------------------------------*/

/*----------------------------------------------------------------------+
|                                                                       |
|   Include Files                                                       |
|                                                                       |
+----------------------------------------------------------------------*/
#include    <mselems.h>
#include    <msdefs.h>
#include    <global.h>
#include    <scanner.h>
#include    <msinputq.h>
#include    <userfnc.h>
#include    <mdl.h>
#include    <cexpr.h>
#include    <rscdefs.h>
#include    <dlogitem.h>
#include    <dlogbox.h>
#include    <tcb.h>
#include    <cmdlist.h>
#include    <refernce.h>

FILE *fi1,*fo1,*fo2;

#define     MAX             150
#define     GRAFIC          1160
#define     MYPREFS         111L


#include    "placedlg.h"

#ifdef unix
   char sepchar = '/';
#else
   char sepchar = 92;
#endif

/*----------------------------------------------------------------------+
|                                                                       |
|   Local function declarations                                         |
|                                                                       |
+----------------------------------------------------------------------*/
Private int     select_pushButtonHook();
Private int     run_pushButtonHook();
Private int     dialogBoxHook();

/*----------------------------------------------------------------------+
|                                                                       |
|   Private Global variables                                            |
|                                                                       |
+----------------------------------------------------------------------*/
Private pntInfo pntinfo;

Private char	CSD_timecode [400] [3], CSD_fmcode [400] [8], geoabbr [400] [6],
		DOGS_fmcode [400] [8], DOGS_abbr[400] [6], fmname [200] [30];

Private	double	textsize_label, textsize_well;

Private DialogBox   *db;

Private DialogHookInfo  uHooks[] =
    {
    {HOOKID_DialogBox,          dialogBoxHook},
    {HOOKITEMID_File_Select,    select_pushButtonHook},
    {HOOKITEMID_Run,            run_pushButtonHook},
    }; 


typedef struct ENABLE
	{
	int	apino;
	int	ctynum;
	int	wellid;
	int	permno;
	double	xcoord;
	double	ycoord;
	char	nszone;
	double	longitude;
	double	latitude;
	int	td;
	int	elev;
	char	type;
	char	class[4];
	char	status[2];
	double	top4;
	int	ipgas;
	int	ipoil;
	char	fmtd[7];
	char	prodfm[7];
	char	twp[20];
	char	lease[35];
	char	compname[25];
	char	quad[25];
	char	misctx1[30];
	char	misctx2[30];
	int	miscnum1;
	int	miscnum2;
	double	miscdec1;
	double	miscdec2;
	char	miscfm1[7];
	char	mdatco1[2];
	int	mdattop1;
	int	mdatbot;
	char	mdatco2[2];
	int	mdattop2;
	int	mdatbot2;
	double	utmx;
	double	utmy;
	} Enable;

Private Enable enable;

typedef struct Enable_Params
	{
	int	apino_start;
	int	apino_end;
	int	ctynum_start;
	int	ctynum_end;
	int	wellid_start;
	int	wellid_end;
	int	permno_start;
	int	permno_end;
	int	xcoord_start;
	int	xcoord_end;
	int	ycoord_start;
	int	ycoord_end;
	int	nszone_start;
	int	nszone_end;
	int	long_start;
	int	long_end;
	int	lat_start;
	int	lat_end;
	int	td_start;
	int	td_end;
	int	elev_start;
	int	elev_end;
	int	type_start;
	int	type_end;
	int	class_start;
	int	class_end;
	int	status_start;
	int	status_end;
	int	top4_start;
	int	top4_end;
	int	ipgas_start;
	int	ipgas_end;
	int	ipoil_start;
	int	ipoil_end;
	int	fmtd_start;
	int	fmtd_end;
	int	prodfm_start;
	int	prodfm_end;
	int	twp_start;
	int	twp_end;
	int	lease_start;
	int	lease_end;
	int	compname_start;
	int	compname_end;
	int	quad_start;
	int	quad_end;
	int	misctx1_start;
	int	misctx1_end;
	int	misctx2_start;
	int	misctx2_end;
	int	miscnum1_start;
	int	miscnum1_end;
	int	miscnum2_start;
	int	miscnum2_end;
	int	miscdec1_start;
	int	miscdec1_end;
	int	miscdec2_start;
	int	miscdec2_end;
	int	miscfm1_start;
	int	miscfm1_end;
	int	mdatco1_start;
	int	mdatco1_end;
	int	mdattop1_start;
	int	mdattop1_end;
	int	mdatbot_start;
	int	mdatbot_end;
	int	mdatco2_start;
	int	mdatco2_end;
	int	mdattop2_start;
	int	mdattop2_end;
	int	mdatbot2_start;
	int	mdatbot2_end;
	int	utmx_start;
	int	utmx_end;
	int	utmy_start;
	int	utmy_end;
	} Enable_params;

Private Enable_params enable_params;

/*----------------------------------------------------------------------+
|                                                                       |
|       get_string -- function read a substring given the start and     |
|                     ending positions                                  |
+----------------------------------------------------------------------*/
Private void get_string
(
char    *buf,
int     start_pos,
int     end_pos,
char    *return_string
)
    {
    int i,count=0;

    for (i=start_pos-1; i<end_pos; i++, count++)
	{
	if (buf[i] != '\n')
	    *(return_string+count) = buf[i];
	else
	    {
	    *(return_string+count) = 0;
	    return;
	    }
	}
    *(return_string+count) = 0;
    }


/*------------------------------------------------------------------------+
|                                                                         |
|       spcs2latlong - function converts Ohio State Plane South           |
|                      Coordinates to Latitude/Longitude                  |
+------------------------------------------------------------------------*/
void spcs2latlong(float x, float y, float *latitude, float *longitude, int nszone)
	{
	double rad2deg=57.29577951;
	double deg2rad=0.017453292;
	double pi=3.141592654;
	double a=20925832.16;        /*radius of the earth r=6378206.4 m*/
	double e2=0.006768658;
	double e;
	double phi1n=0.705694794;
	double phi2n=0.727802298;
	double phi1s=0.676024196;
	double phi2s=0.698713477;
	double phi0n=0.692313936;
	double lamda0n=1.439896633;
	double phi0s=0.663225115;
	double lamda0s=1.439896633;
	double n,f,rho,rho0,theta;
	double phi;
	double lamda;
	double phiold;
	double m,m1,m2;
	double t,t0,t1,t2,tnew;
	/**************************************/
	/* compute the latitude and longitude */
	/**************************************/
	x=2000000-x;
	phi= *latitude*deg2rad;
	lamda= *longitude*deg2rad;
	if(nszone=='N')
		{
		e=sqrt(e2);
		m=cos(phi)/sqrt(1.0-e2*pow(sin(phi),2.0));
		m1=cos(phi1n)/sqrt(1.0-e2*pow(sin(phi1n),2.0));
		m2=cos(phi2n)/sqrt(1.0-e2*pow(sin(phi2n),2.0));
		t=tan(pi/4.0-phi/2.0)/pow((1.0-e*sin(phi))/(1.0+e*sin(phi)),e/2.0);
		t0=tan(pi/4.0-phi0n/2.0)/pow((1.0-e*sin(phi0n))/(1.0+e*sin(phi0n)),e/2.0);
		t1=tan(pi/4.0-phi1n/2.0)/pow((1.0-e*sin(phi1n))/(1.0+e*sin(phi1n)),e/2.0);
		t2=tan(pi/4.0-phi2n/2.0)/pow((1.0-e*sin(phi2n))/(1.0+e*sin(phi2n)),e/2.0);
		n=(log(m1)-log(m2))/(log(t1)-log(t2));
		f=m1/(n*pow(t1,n));
		rho0=a*f*pow(t0,n);
		rho=sqrt(pow((double) x,2.0)+pow((rho0-(double) y),2.0));
		theta=atan2((double) x,(rho0-(double) y));
		tnew=pow(rho/(a*f),1.0/n);
		phi=pi/2.0-2.0*atan(tnew);
		phiold=0.0;
		while(fabs(phi-phiold)>=0.00000000000001)
			{
			phiold=phi;
			phi=pi/2.0-2.0*atan(tnew*pow((1.0-e*sin(phi))/(1.0+e*sin(phi)),e/2.0));
			}
		lamda=theta/n+lamda0n;
		*latitude=phi*rad2deg;
		*longitude=lamda*rad2deg;
		}
	if (nszone=='S')
		{
		e=sqrt(e2);
		m=cos(phi)/sqrt(1.0-e2*pow(sin(phi),2.0));
		m1=cos(phi1s)/sqrt(1.0-e2*pow(sin(phi1s),2.0));
		m2=cos(phi2s)/sqrt(1.0-e2*pow(sin(phi2s),2.0));
		t=tan(pi/4.0-phi/2.0)/pow((1.0-e*sin(phi))/(1.0+e*sin(phi)),e/2.0);
		t0=tan(pi/4.0-phi0s/2.0)/pow((1.0-e*sin(phi0s))/(1.0+e*sin(phi0s)),e/2.0);
		t1=tan(pi/4.0-phi1s/2.0)/pow((1.0-e*sin(phi1s))/(1.0+e*sin(phi1s)),e/2.0);
		t2=tan(pi/4.0-phi2s/2.0)/pow((1.0-e*sin(phi2s))/(1.0+e*sin(phi2s)),e/2.0);
		n=(log(m1)-log(m2))/(log(t1)-log(t2));
		f=m1/(n*pow(t1,n));
		rho0=a*f*pow(t0,n);
		rho=sqrt(pow((double) x,2.0)+pow((rho0-(double) y),2.0));
		theta=atan2((double) x,(rho0-(double) y));
		tnew=pow(rho/(a*f),1.0/n);
		phi=pi/2.0-2.0*atan(tnew);
		phiold=0.0;
		while(fabs(phi-phiold)>=0.00000000000001)
			{
			phiold=phi;
			phi=pi/2.0-2.0*atan(tnew*pow((1.0-e*sin(phi))/(1.0+e*sin(phi)),e/2.0));
			}
		lamda=theta/n+lamda0s;
		*latitude=phi*rad2deg;
		*longitude=lamda*rad2deg;
		}
	}
/*------------------------------------------------------------------------+
|                                                                         |
|       latlong2spcs - function converts Latitude/Longitude to Ohio State |
|                      Plane South Coordinates                            |
+------------------------------------------------------------------------*/
void latlong2spcs(float *x, float *y, float latitude, float longitude, int nszone)
	{
	double deg2rad=0.017453292;
	double pi=3.141592654;
	double a=20925832.16;        /*radius of the earth r=6378206.4 m*/
	double e2=0.006768658;
	double e;
	double phi0n=0.692313936;
	double phi1n=0.705694794;
	double phi2n=0.727802298;
	double phi0s=0.663225115;
	double phi1s=0.676024196;
	double phi2s=0.698713477;
	double lamda0n=1.439896633;
	double lamda0s=1.439896633;
	double n,f,rho,rho0,theta;
	double phi;
	double lamda;
	double phiold;
	double m,m1,m2;
	double t,t0,t1,t2,tnew;
	/**************************************************/
	/* compute the south zone state plane coordinates */
	/**************************************************/
	if (nszone == 'S')
		{
		phi=latitude*deg2rad;
		lamda=longitude*deg2rad;
		e=sqrt(e2);
		m=cos(phi)/sqrt(1.0-e2*pow(sin(phi),2.0));
		m1=cos(phi1s)/sqrt(1.0-e2*pow(sin(phi1s),2.0));
		m2=cos(phi2s)/sqrt(1.0-e2*pow(sin(phi2s),2.0));
		t=tan(pi/4.0-phi/2.0)/pow((1.0-e*sin(phi))/(1.0+e*sin(phi)),e/2.0);
		t0=tan(pi/4.0-phi0s/2.0)/pow((1.0-e*sin(phi0s))/(1.0+e*sin(phi0s)),e/2.0);
		t1=tan(pi/4.0-phi1s/2.0)/pow((1.0-e*sin(phi1s))/(1.0+e*sin(phi1s)),e/2.0);
		t2=tan(pi/4.0-phi2s/2.0)/pow((1.0-e*sin(phi2s))/(1.0+e*sin(phi2s)),e/2.0);
		n=(log(m1)-log(m2))/(log(t1)-log(t2));
		f=m1/(n*pow(t1,n));
		rho0=a*f*pow(t0,n);
		rho=a*f*pow(t,n);
		theta=n*(lamda-lamda0s);
		*x=rho*sin(theta);
		*x=2000000-*x;
		*y=rho0-rho*cos(theta);
		}
	/**************************************************/
	/* compute the south zone state plane coordinates */
	/**************************************************/
	if (nszone == 'N')
		{
		phi=latitude*deg2rad;
		lamda=longitude*deg2rad;
		e=sqrt(e2);
		m=cos(phi)/sqrt(1.0-e2*pow(sin(phi),2.0));
		m1=cos(phi1n)/sqrt(1.0-e2*pow(sin(phi1n),2.0));
		m2=cos(phi2n)/sqrt(1.0-e2*pow(sin(phi2n),2.0));
		t=tan(pi/4.0-phi/2.0)/pow((1.0-e*sin(phi))/(1.0+e*sin(phi)),e/2.0);
		t0=tan(pi/4.0-phi0n/2.0)/pow((1.0-e*sin(phi0n))/(1.0+e*sin(phi0n)),e/2.0);
		t1=tan(pi/4.0-phi1n/2.0)/pow((1.0-e*sin(phi1n))/(1.0+e*sin(phi1n)),e/2.0);
		t2=tan(pi/4.0-phi2n/2.0)/pow((1.0-e*sin(phi2n))/(1.0+e*sin(phi2n)),e/2.0);
		n=(log(m1)-log(m2))/(log(t1)-log(t2));
		f=m1/(n*pow(t1,n));
		rho0=a*f*pow(t0,n);
		rho=a*f*pow(t,n);
		theta=n*(lamda-lamda0n);
		*x=rho*sin(theta);
		*x=2000000-*x;
		*y=rho0-rho*cos(theta);
		}
	}
/*----------------------------------------------------------------------+
|                                                                       |
|       get_fmcode -- function reads a the formation codes and saves    |
|                     them in memory                                    |
+----------------------------------------------------------------------*/
Private void get_fmcode
( 
int	*i
)
	{
	int	j, result;
	fi1=fopen("fmcode.asc","r");
	fo1=fopen("fmout.asc","w");
	*i=0;
	while(!feof(fi1))
		{
		fscanf(fi1,"%s %s %s %s %s\n", 
			&CSD_timecode [*i] [0], &CSD_fmcode [*i] [0], &geoabbr [*i] [0],
			&DOGS_fmcode [*i] [0], &DOGS_abbr [*i] [0]);
		fprintf(fo1,"%s %s %s %s %s\n", 
			CSD_timecode [*i] , CSD_fmcode [*i] , geoabbr [*i] ,
			DOGS_fmcode [*i] , DOGS_abbr [*i]);
		++*i;
		}
	*i=*i-1;
	fclose(fi1);
	fclose(fo1);
	}

/*----------------------------------------------------------------------+
|                                                                       |
|               place_text                                              |
|                                                                       |
+----------------------------------------------------------------------*/
Private int     place_text
(
char    *txtString,
int	Color,
int	Weight,
int	Level,
int	Location
)
    {
    TextParam       txtParam;
    TextSizeParam   txtSize;
    MSElementUnion  element;
    RotMatrix       rMatrix;
    int             status;
    int             style=0;
    Dpoint3d        vertex, tempoffset;

    /* --- calculate rotation matrix --- */
    mdlRMatrix_getIdentity (&rMatrix);
    mdlRMatrix_rotate (&rMatrix, &rMatrix, 0.0, 0.0,
			pntinfo.angle*fc_piover180);

    mdlParams_setActive(0,ACTIVEPARAM_FONT);
    txtParam.font            = tcb->actfont;
    txtParam.style           = -1;
    txtParam.viewIndependent = FALSE;
    txtSize.mode             = TXT_BY_TILE_SIZE;

    txtSize.size.width       = textsize_label;
    txtSize.size.height      = textsize_label;
    vertex.x                 = enable.xcoord;
    vertex.y                 = enable.ycoord;
    vertex.z                 = 0.0;

    switch (Location)
	{
	case 0:
		tempoffset.x=vertex.x;
		tempoffset.y=vertex.y + textsize_label;
		txtParam.just=TXTJUST_CB;
		break;
	case 1:
		tempoffset.x=vertex.x + textsize_label;
		tempoffset.y=vertex.y + textsize_label;
		txtParam.just=TXTJUST_LC; 
		break;
	case 2: 
		tempoffset.x=vertex.x + textsize_label;
		tempoffset.y=vertex.y;
		txtParam.just=TXTJUST_LC;
		break;
	case 3:
		tempoffset.x=vertex.x + textsize_label;
		tempoffset.y=vertex.y - textsize_label;
		txtParam.just=TXTJUST_LC; 
		break;
	case 4:
		tempoffset.x=vertex.x;
		tempoffset.y=vertex.y - textsize_label;
		txtParam.just=TXTJUST_CT; 
		break;
	case 5:
		tempoffset.x=vertex.x - textsize_label;
		tempoffset.y=vertex.y - textsize_label;
		txtParam.just=TXTJUST_RC; 
		break;
	case 6:
		tempoffset.x=vertex.x - textsize_label;
		tempoffset.y=vertex.y;
		txtParam.just=TXTJUST_RC; 
		break;
	case 7:
		tempoffset.x=vertex.x - textsize_label;
		tempoffset.y=vertex.y + textsize_label;
		txtParam.just=TXTJUST_RC; 
		break;
	}

    status = mdlText_create (&element, NULL, txtString, &tempoffset, &txtSize,
			     &rMatrix, &txtParam, NULL);
	
    if (status)
	{
	mdlOutput_printf (MSG_ERROR, "Error placing text %s - status=%d",
			  txtString, status);
	return;
	}

    /* --- set style, weight, and color --- */
    mdlElement_setSymbology  (&element, &Color, &Weight, &style);
    mdlElement_setProperties (&element, &Level, NULL, NULL, NULL,
			      NULL, NULL, NULL, NULL);

    mdlElement_add (&element);
    }

/*----------------------------------------------------------------------+
|                                                                       |
|               place_well                                              |
|                                                                       |
+----------------------------------------------------------------------*/
Private int     place_well
(
int	Color,
int	Weight,
int	Level
)
    {
    TextParam       txtParam;
    TextSizeParam   txtSize;
    MSElementUnion  element;
    RotMatrix       rMatrix;
    int             status;
    int             style=0;
    Dpoint3d        vertex;
    /* --- calculate rotation matrix --- */
    mdlRMatrix_getIdentity (&rMatrix);
    mdlRMatrix_rotate (&rMatrix, &rMatrix, 0.0, 0.0,
			pntinfo.angle*fc_piover180);
    mdlParams_setActive(126,ACTIVEPARAM_FONT);
    txtParam.font            = tcb->actfont;
    txtParam.just            = TXTJUST_CC;
    txtParam.style           = -1;
    txtParam.viewIndependent = FALSE;
    txtSize.mode             = TXT_BY_TILE_SIZE;

    txtSize.size.width       = textsize_well;
    txtSize.size.height      = textsize_well;
    vertex.x                 = enable.xcoord;
    vertex.y                 = enable.ycoord;
    vertex.z                 = 0.0;

    /*--- Place well symbol ---*/
    if (enable.ipoil > 0)
	{
	status = mdlText_create (&element, NULL, "R", &vertex, &txtSize,
		&rMatrix, &txtParam, NULL);
	mdlElement_setSymbology  (&element, &Color, &Weight, &style);
	mdlElement_setProperties (&element, &Level, NULL, NULL, NULL,
		NULL, NULL, NULL, NULL);
	mdlElement_add (&element);
	if (status)
		{
		mdlOutput_printf (MSG_ERROR, "Error placing text %s - status=%d",
			  "R", status);
		return;
		}
	}
    if (enable.ipgas > 0)
	{
	status = mdlText_create (&element, NULL, "S", &vertex, &txtSize,
		&rMatrix, &txtParam, NULL);
	mdlElement_setSymbology  (&element, &Color, &Weight, &style);
	mdlElement_setProperties (&element, &Level, NULL, NULL, NULL,
		NULL, NULL, NULL, NULL);
	mdlElement_add (&element);
	if (status)
		{
		mdlOutput_printf (MSG_ERROR, "Error placing text %s - status=%d",
			  "S", status);
		return;
		}
	}
    if (!fabs(strcmp(enable.status,"A")))
	{
	status = mdlText_create (&element, NULL, "W", &vertex, &txtSize,
		&rMatrix, &txtParam, NULL);
	mdlElement_setSymbology  (&element, &Color, &Weight, &style);
	mdlElement_setProperties (&element, &Level, NULL, NULL, NULL,
		NULL, NULL, NULL, NULL);
	mdlElement_add (&element);
	if (status)
		{
		mdlOutput_printf (MSG_ERROR, "Error placing text %s - status=%d",
			  "W", status);
		return;
		}
	}
    if (!fabs(strcmp(enable.status,"PA")))
	{
	status = mdlText_create (&element, NULL, "G", &vertex, &txtSize,
		&rMatrix, &txtParam, NULL);
	mdlElement_setSymbology  (&element, &Color, &Weight, &style);
	mdlElement_setProperties (&element, &Level, NULL, NULL, NULL,
		NULL, NULL, NULL, NULL);
	mdlElement_add (&element);
	if (status)
		{
		mdlOutput_printf (MSG_ERROR, "Error placing text %s - status=%d",
			  "G", status);
		return;
		}
	}
    if (!fabs(strcmp(enable.status,"I")))
	{
	status = mdlText_create (&element, NULL, "D", &vertex, &txtSize,
		&rMatrix, &txtParam, NULL);
	mdlElement_setSymbology  (&element, &Color, &Weight, &style);
	mdlElement_setProperties (&element, &Level, NULL, NULL, NULL,
		NULL, NULL, NULL, NULL);
	mdlElement_add (&element);
	if (status)
		{
		mdlOutput_printf (MSG_ERROR, "Error placing text %s - status=%d",
			  "D", status);
		return;
		}
	}
    if ((enable.ipoil == 0) && (enable.ipgas == 0) &&
	fabs(strcmp(enable.status,"A")) && fabs(strcmp(enable.status,"PA")) && fabs(strcmp(enable.status,"I")))
		{ 
		status = mdlText_create (&element, NULL, "B", &vertex, &txtSize,
			&rMatrix, &txtParam, NULL);
		mdlElement_setSymbology  (&element, &Color, &Weight, &style);
		mdlElement_setProperties (&element, &Level, NULL, NULL, NULL,
			NULL, NULL, NULL, NULL);
		mdlElement_add (&element);
		if (status)
			{
			mdlOutput_printf (MSG_ERROR, "Error placing text %s - status=%d",
				"B", status);
			return;
			}
		} 
    }

/*----------------------------------------------------------------------+
|                                                                       |
|               read_enable_params                                             |
|                                                                       |
+----------------------------------------------------------------------*/
Private int     read_enable_params
(
void
)
	{
	enable_params.apino_start=1;
	enable_params.apino_end=10;
	enable_params.ctynum_start=11;
	enable_params.ctynum_end=13;
	enable_params.wellid_start=14;
	enable_params.wellid_end=14;
	enable_params.permno_start=7;
	enable_params.permno_end=10;
	enable_params.xcoord_start=20;
	enable_params.xcoord_end=26;
	enable_params.ycoord_start=27;
	enable_params.ycoord_end=33;
	enable_params.nszone_start=34;
	enable_params.nszone_end=34;
	enable_params.long_start=35;
	enable_params.long_end=46;
	enable_params.lat_start=47;
	enable_params.lat_end=57;
	enable_params.td_start=58;
	enable_params.td_end=62;
	enable_params.elev_start=63;
	enable_params.elev_end=67;
	enable_params.type_start=68;
	enable_params.type_end=68;
	enable_params.class_start=69;
	enable_params.class_end=72;
	enable_params.status_start=73;
	enable_params.status_end=74;
	enable_params.top4_start=90;
	enable_params.top4_end=94;
	enable_params.ipgas_start=325;
	enable_params.ipgas_end=329;
	enable_params.ipoil_start=330;
	enable_params.ipoil_end=333;
	enable_params.fmtd_start=334;
	enable_params.fmtd_end=339;
	enable_params.prodfm_start=340;
	enable_params.prodfm_end=345;
	enable_params.twp_start=346;
	enable_params.twp_end=365;
	enable_params.lease_start=366;
	enable_params.lease_end=400;
	enable_params.compname_start=401;
	enable_params.compname_end=425;
	enable_params.quad_start=426;
	enable_params.quad_end=450;
	enable_params.misctx1_start=451;
	enable_params.misctx1_end=480;
	enable_params.misctx2_start=481;
	enable_params.misctx2_end=510;
	enable_params.miscnum1_start=511;
	enable_params.miscnum1_end=520;
	enable_params.miscnum2_start=521;
	enable_params.miscnum2_end=530;
	enable_params.miscdec1_start=531;
	enable_params.miscdec1_end=540;
	enable_params.miscdec2_start=541;
	enable_params.miscdec2_end=550;
	enable_params.miscfm1_start=551;
	enable_params.miscfm1_end=556;
	enable_params.mdatco1_start=557;
	enable_params.mdatco1_end=558;
	enable_params.mdattop1_start=559;
	enable_params.mdattop1_end=563;
	enable_params.mdatbot_start=564;
	enable_params.mdatbot_end=568;
	enable_params.mdatco2_start=569;
	enable_params.mdatco2_end=570;
	enable_params.mdattop2_start=571;
	enable_params.mdattop2_end=575;
	enable_params.mdatbot2_start=576;
	enable_params.mdatbot2_end=580;
	enable_params.utmx_start=581;
	enable_params.utmx_end=587;
	enable_params.utmy_start=588;
	enable_params.utmy_end=594;
	}

/*----------------------------------------------------------------------+
|                                                                       |
|     read_enable_point -- function read a point from the point file    |
|                   If the point code is a decimal then the optional    |
|                   label flag is set and the label returned            |
+----------------------------------------------------------------------*/
Private int read_enable_point
(
FILE   *data
)
    {
    int     num;
    char    buffer[600], *result, tmp[40];

    while (TRUE)
	{
	result = fgets(buffer,600,data);
	if (buffer[0] == ';' && result != NULL)
	    continue;
	if(result == NULL)
	    return (2);   /* end of point file */

	/* --- get northing (Y) --- */
	get_string (buffer, enable_params.ycoord_start, enable_params.ycoord_end, tmp);
      	if ((num=sscanf(tmp,"%lf",&enable.ycoord))!= 1)
		{
		return(1);
		} 

	/* --- get easting (X) --- */
	get_string (buffer, enable_params.xcoord_start, enable_params.xcoord_end, tmp);
	if ((num=sscanf(tmp,"%lf",&enable.xcoord))!= 1)
		{
		return(1);
		} 

	/* --- get elevation (Z) --- */
	get_string (buffer, enable_params.elev_start, enable_params.elev_end, tmp);
	if ((num=sscanf(tmp,"%d",&enable.elev))!= 1)
		{
		return(1);
		} 

	/* --- get North-South Zone indicator (nszone) --- */
	get_string (buffer, enable_params.nszone_start, enable_params.nszone_end, tmp);
	if ((num=sscanf(tmp,"%c",&enable.nszone))!= 1)
		{
		return(1);
		} 

	/* --- get Latitude (enable.latitude) --- */
	get_string (buffer, enable_params.lat_start, enable_params.lat_end, tmp);
      	if ((num=sscanf(tmp,"%lf",&enable.latitude))!= 1)
		{
		return(1);
		} 

	/* --- get Longitude (enable.longitude) --- */
	get_string (buffer, enable_params.long_start, enable_params.long_end, tmp);
      	if ((num=sscanf(tmp,"%lf",&enable.longitude))!= 1)
		{
		return(1);
		} 

	/* --- get permit number (permno) --- */
	get_string (buffer, enable_params.permno_start, enable_params.permno_end, tmp);
	if ((num=sscanf(tmp,"%d",&enable.permno))!= 1)
		{
		return(1);
		} 

	/* --- get producing formation (prodfm) --- */
	get_string (buffer, enable_params.prodfm_start, enable_params.prodfm_end, tmp);
	if ((num=sscanf(tmp,"%s",enable.prodfm))!= 1)
		{
		return(1);
		} 

	/* --- get plugged back formation (plugfm, using miscfm1 variable from GIPSIE) --- */
	get_string (buffer, enable_params.miscfm1_start, enable_params.miscfm1_end, tmp);
	if ((num=sscanf(tmp,"%s",enable.miscfm1))!= 1)
		{
		return(1);
		} 

	/* --- get formation at td (fmtd) --- */
	get_string (buffer, enable_params.fmtd_start, enable_params.fmtd_end, tmp);
	if ((num=sscanf(tmp,"%s",enable.fmtd))!= 1)
		{
		return(1);
		} 

	/* --- get the well status (enable.status) --- */
	get_string (buffer, enable_params.status_start, enable_params.status_end, tmp);
	if ((num=sscanf(tmp,"%s",enable.status))!= 1)
		{
		return(1);
		} 

	/* --- get the initial production of gas (enable.ipgas) --- */
	get_string (buffer, enable_params.ipgas_start, enable_params.ipgas_end, tmp);
	if ((num=sscanf(tmp,"%d", &enable.ipgas))!= 1)
		{
		return(1);
		} 

	/* --- get the initial production of oil (enable.ipoil) --- */
	get_string (buffer, enable_params.ipoil_start, enable_params.ipoil_end, tmp);
	if ((num=sscanf(tmp,"%d", &enable.ipoil))!= 1)
		{
		return(1);
		} 

	return (0);
	}
    }

/*----------------------------------------------------------------------+
|                                                                       |
|               processData                                             |
|                                                                       |
+----------------------------------------------------------------------*/
Private int     processData
(
FILE *data
)
    {
    float   lat_deg,lat_min,lat_sec;
    float   long_deg,long_min,long_sec;
    int     status = 0;
    int     result, i, k;
    int     count = 0, num_fmcodes;
    char    text[40], tmp_geoabbr[6];

    /* --- Read Fm Codes --- */
    get_fmcode (&num_fmcodes); 

    /* --- Scale and Offset the Text --- */
    switch (pntinfo.textSize)
	{
	case 0:						/*   8 pt   */
		textsize_label = 0.110833333;
		textsize_well = 0.110833333;
		break;
	case 1:						/*   10 pt   */
		textsize_label = 0.13854;
		textsize_well = 0.13854;
		break;
	case 2:						/*   12 pt   */
		textsize_label = 0.16625;
		textsize_well = 0.16625;
		break;
	case 3:						/* DCMS 1&2 Size */
		textsize_label = 0.05;
		textsize_well = 0.08;
		break;
	case 4:						/* DCMS 3 Size */
		textsize_label = 0.06;
		textsize_well = 0.10;
		break;
	}
    switch (pntinfo.scale)
	{
	case 0:						/* 1:1320 */
		textsize_label = 1320.000*textsize_label;
		textsize_well = 1320.000*textsize_well;
		break;
	case 1:						/* 1:24000 */
		textsize_label = 2000.000*textsize_label;
		textsize_well = 2000.000*textsize_well;
		break;
	case 2:						/* 1:62500 */
		textsize_label = 5208.333*textsize_label;
		textsize_well = 5208.333*textsize_well;
		break;
	case 3:						/* 1:100000 */
		textsize_label = 8333.333*textsize_label;
		textsize_well = 8333.333*textsize_well;
		break;
	case 4:						/* 1:250000 */
		textsize_label = 20833.333*textsize_label;
		textsize_well = 20833.333*textsize_well;
		break;
	case 5:						/* 1:500000 */
		textsize_label = 41666.666*textsize_label;
		textsize_well = 41666.666*textsize_well;
		break;
	}

    /* --- process file line by line --- */
    while (TRUE)
	{
	count++;
	/* --- print points processed every 10 --- */
	if (!(count%10)) 
	    mdlOutput_printf (MSG_MESSAGE, "Processing point - %-d", count);

	/* --- read line from file --- */
	status = read_enable_point(data); 

	if (!status)
		{
		/*--- Covert Coordinates if nessary ---*/
		switch (pntinfo.coordsys)
			{
			case 0:
				if(enable.xcoord==0.0)
					{
					latlong2spcs(&enable.xcoord,&enable.ycoord,
						enable.latitude,enable.longitude, 'S'); 
					}
				if(enable.nszone=='N')
					{
					spcs2latlong(enable.xcoord,enable.ycoord,
						&enable.latitude,&enable.longitude,enable.nszone);
					latlong2spcs(&enable.xcoord,&enable.ycoord,
						enable.latitude,enable.longitude, 'S'); 
					}
				break;
			case 1:
				if(enable.xcoord==0.0)
					{
					latlong2spcs(&enable.xcoord,&enable.ycoord,
						enable.latitude,enable.longitude, 'N'); 
					}
				if(enable.nszone=='S')
					{
					spcs2latlong(enable.xcoord,enable.ycoord,
						&enable.latitude,&enable.longitude,enable.nszone);
					latlong2spcs(&enable.xcoord,&enable.ycoord,
						enable.latitude,enable.longitude, 'N');
					}
				break;

			}
                /* --- Place Well Symbol and Text --- */
		if (pntinfo.pl_wellsym)  
			{
	        	place_well (pntinfo.wellsymColor, pntinfo.wellsymWeight,
				pntinfo.wellsymLevel); 
			}
		if (pntinfo.pl_permit)  
			{
			sprintf(text,"%d",enable.permno);
			place_text (text, pntinfo.permitColor, pntinfo.permitWeight,
				pntinfo.permitLevel, pntinfo.loc_permit);
			}
		if (pntinfo.pl_elev)  
			{
			sprintf(text,"%d",enable.elev);
			place_text (text, pntinfo.elevColor, pntinfo.elevWeight,
				pntinfo.elevLevel, pntinfo.loc_elev);
			}
		if (pntinfo.pl_prodfm)  
			{
			k=0;
			while ((k <= num_fmcodes) && fabs(strcmp(enable.prodfm, &CSD_fmcode [k] [0])))
				{
				++k;
				}
			if (fabs(strcmp(enable.prodfm, "NONE")))
				{
				if (fabs(strcmp(enable.miscfm1, "NONE")))
					{
					result=strlen(DOGS_abbr [k]);
					tmp_geoabbr [0] = '(';
					for ( i=1; i <= result; ++i)
						{
						tmp_geoabbr [i]= DOGS_abbr [k] [i-1];
						}
					tmp_geoabbr [i]= ')';
					tmp_geoabbr [i+1]= '\0';
					place_text (&tmp_geoabbr [0], pntinfo.prodfmColor, 
						pntinfo.prodfmWeight, pntinfo.prodfmLevel, 
						pntinfo.loc_prodfm + 1);
					}
				else
					{
					place_text (&DOGS_abbr [k] [0], pntinfo.prodfmColor, 
						pntinfo.prodfmWeight, pntinfo.prodfmLevel, 
						pntinfo.loc_prodfm);
					}
				}
			}
		if (pntinfo.pl_plugbkfm)  
			{
			k=0;
			while ((k <= num_fmcodes) && fabs(strcmp(enable.miscfm1, &CSD_fmcode [k] [0])))
				{
				++k;
				}
			if (fabs(strcmp(enable.miscfm1, "NONE")))
				{
				place_text (&DOGS_abbr [k] [0], pntinfo.plugbkfmColor, 
					pntinfo.plugbkfmWeight, pntinfo.plugbkfmLevel, 
					pntinfo.loc_plugbkfm);
				}
			}
		if (pntinfo.pl_fmtd)  
			{
			k=0;
			while ((k <= num_fmcodes) && fabs(strcmp(enable.fmtd, &CSD_fmcode [k] [0])))
				{
				++k;
				}
			if (strcmp(enable.fmtd, "37105") > 1 )
				{
				result=strlen(DOGS_abbr [k]);
				tmp_geoabbr [0] = '[';
				for ( i=1; i <= result; ++i)
					{
					tmp_geoabbr [i]= DOGS_abbr [k] [i-1];
					}
				tmp_geoabbr [i]= ']';
				tmp_geoabbr [i+1]= '\0';
				place_text (&tmp_geoabbr [0], pntinfo.fmtdColor, 
					pntinfo.fmtdWeight, pntinfo.fmtdLevel, 
					pntinfo.loc_fmtd);
				}
			}
		continue;
		}
	if (status == 1)
	    {
	    mdlOutput_printf (MSG_MESSAGE, "Error Processing Point # %d",
			      count);
	    continue;
	    }

	if (status == 2)
	    {
	    mdlOutput_printf (MSG_MESSAGE, "End of File - %d Points Processed",
			      count);
	    return (SUCCESS);
	    }
	}
    return (SUCCESS);
    }

/*----------------------------------------------------------------------+
|                                                                       |
| name          convertPointFile                                        |
|                                                                       |
+----------------------------------------------------------------------*/
Private void    convertPointFile
(
void
)
    {
    int     i;
    char    message[132];
    ULong   fileMask[8];
    FILE    *att, *data;

    /* --- initialize fit view file mask --- */
    fileMask[0]=1L;
    for (i=1; i<8; i++)
	fileMask[i] = 0L;

    /* --- open parameter file --- */
    read_enable_params( );

    /* --- open data file --- */
    if ((data = fopen(pntinfo.pointFile,"r+")) == NULL)
	{
	sprintf (message, "Can't Open ASCII Point File %s", pntinfo.pointFile);
	mdlDialog_openAlert (message);
	return;
	}

    mdlCurrTrans_begin ();
    mdlCurrTrans_masterUnitsIdentity (TRUE);

    /* --- process point file ---- */
    processData (data);

    /* --- fit view 1 --- */
    mdlView_fit (0, fileMask);

    mdlCurrTrans_end ();

    /* --- close the dialog box --- */
    mdlWindow_close (db, FALSE, TRUE);
    }

/*----------------------------------------------------------------------+
|                                                                       |
| name          getFile                                                 |
|                                                                       |
+----------------------------------------------------------------------*/
Private void    getFile
(
char *filename,
char *defaultExtension,
char *prompt
)   
    {
    int     status;
    int     stringLength;
    char    dir[MAXDIRLENGTH], localSpec[132];

    /* --- get current working directory --- */
    mdlFile_getcwd (dir, MAXDIRLENGTH);
    stringLength        = strlen (dir);
    if (dir[stringLength-1] != sepchar)
	{
	dir[stringLength]   = sepchar;
	dir[stringLength+1] = 0;
	}

    /* --- use the built in dialog box to get the file name --- */
    if (mdlDialog_fileOpen (localSpec, NULL, 0, NULL, defaultExtension,
			    dir, prompt))
	return;
    else
	strcpy (filename, localSpec);
    }

/*----------------------------------------------------------------------+
|                                                                       |
| name          select_pushButtonHook                                   |
|                                                                       |
+----------------------------------------------------------------------*/
Private int     select_pushButtonHook
(
DialogItemMessage   *dimP
)
    {
    char        keyin[100];
    DialogItem  *diP;

    dimP->msgUnderstood = TRUE;

    switch (dimP->messageType)
	{
	case DITEM_MESSAGE_BUTTON:
	    switch (dimP->dialogItemP->rawItemP->itemHookArg)
		{
		case PUSHBUTTONID_Ascii:
		    getFile (pntinfo.pointFile, "*.asc",
			     "Define ASCII Point File");
		    break;
		}
	    mdlDialog_itemsSynch (dimP->db);
	    break;

	default:
	    dimP->msgUnderstood = FALSE;
	    break;
	}
    }

/*----------------------------------------------------------------------+
|                                                                       |
| name          run_pushButtonHook                                      |
|                                                                       |
+----------------------------------------------------------------------*/
Private int     run_pushButtonHook
(
DialogItemMessage   *dimP
)
    {
    char        keyin[100];
    DialogItem  *diP;

    dimP->msgUnderstood = TRUE;

    switch (dimP->messageType)
	{
	case DITEM_MESSAGE_BUTTON:
	    switch (dimP->dialogItemP->rawItemP->itemHookArg)
		{
		case PUSHBUTTONID_Okay:
		    db = dimP->db;          /* save pointer to dialog box */
		    convertPointFile ();
		    break;
		case PUSHBUTTONID_Quit:
		    mdlWindow_close (dimP->db, FALSE, TRUE);
		    break;
		}
	    break;

	default:
	    dimP->msgUnderstood = FALSE;
	    break;
	}
    }

/*----------------------------------------------------------------------+
|                                                                       |
| name          dialogBoxHook                                           |
|                                                                       |
+----------------------------------------------------------------------*/
Private void    dialogBoxHook
(
DialogMessage   *dmP        /* => a ptr to a dialog message */
)
    {
    int status;

    /* --- ignore any messages being sent to modal dialog hook --- */
    if (dmP->dialogId != DIALOGID_Pntdata)
	return;
    
    dmP->msgUnderstood = TRUE;
    switch (dmP->messageType)
	{
	case DIALOG_MESSAGE_CREATE:
	    break;

	case DIALOG_MESSAGE_DESTROY:
	    /* --- unload this mdl task when the Dialog is closed --- */
	    mdlDialog_cmdNumberQueue (FALSE, CMD_MDL_UNLOAD,
				      mdlSystem_getCurrTaskID(), TRUE);
	    break;
	    
	default:
	    dmP->msgUnderstood = FALSE;
	    break;
	}
    }
/*----------------------------------------------------------------------+
|									|
| name          pntdata_unloadFunction                                  |
|									|
+----------------------------------------------------------------------*/
Private int     pntdata_unloadFunction
(
void
)       
    {
    RscFileHandle   userPrefsH;
    pntInfo         *pntRscP;
    char            userPrefsFileName[MAXFILELENGTH];
    int             status;

    /* --- Check for an existing user preferences file --- */
    if ((status = mdlFile_find (userPrefsFileName, "myprefs.rsc",
                               "MS_DATA", "rsc")) == SUCCESS)
        {
        status = mdlResource_openFile (&userPrefsH, userPrefsFileName,
                                       RSC_READWRITE);
        }

    /* --- If existing userpref not found, create a new one. --- */
    if (status != SUCCESS)
	{
	/* --- Generate a user pref file name. --- */
        mdlFile_create (userPrefsFileName, userPrefsFileName, "MS_DATA", "rsc");

	/* --- Create the user pref file. --- */
        mdlResource_createFile (userPrefsFileName, "My Preferences", MYPREFS);

	/* --- Open the new user pref file. --- */
        mdlResource_openFile (&userPrefsH, userPrefsFileName, RSC_READWRITE);
        }

    /* --- if we can't open file exit function --- */
    if (userPrefsH == NULL)
        return FALSE;

    pntRscP = (pntInfo *)mdlResource_load (userPrefsH, RTYPE_Pntd, RSCID_Pntd);

    if (!pntRscP)
	{
        /* --- Our pref resource does not exist, so add it --- */
        mdlResource_add (userPrefsH, RTYPE_Pntd, RSCID_Pntd,
                         &pntinfo, sizeof(pntInfo),NULL);
        }
    else
	{
        /* --- Write out the updated resource --- */
        *pntRscP = pntinfo;
        mdlResource_write (pntRscP);
        mdlResource_free  (pntRscP);
	}

    /* --- Close user preference file ---- */
    mdlResource_closeFile (userPrefsH);
    mdlState_startDefaultCommand ();

    return  FALSE;
    }

/*----------------------------------------------------------------------+
|									|
| name          pntdata_setDefaults                                     |
|									|
+----------------------------------------------------------------------*/
Private void    pntdata_setDefaults
(  
void
)
    {
    char                    userPrefsFileName[MAXFILELENGTH];
    int                     status;
    RscFileHandle           rfHandle, userPrefsH;
    pntInfo                 *pntRscP=NULL;

    /* --- Check for an existing user preferences file --- */
    if ((status = mdlFile_find (userPrefsFileName, "myprefs.rsc",
                               "MS_DATA", "rsc")) == SUCCESS)
        {
        status = mdlResource_openFile (&userPrefsH, userPrefsFileName,
                                       RSC_READWRITE);
        }

    /* --- If userpref found try to read default values --- */
    if (status == SUCCESS)
	{
        pntRscP = mdlResource_load (userPrefsH, RTYPE_Pntd, RSCID_Pntd);

        if (pntRscP)
            {
            /* --- Copy from resource into structure --- */
            memcpy (&pntinfo, pntRscP, sizeof(pntInfo));

            /* --- Free the memory used by the rsc --- */
            mdlResource_free (pntRscP);

            /* --- close the use preference file --- */
            mdlResource_closeFile (userPrefsH);
            return;
            }
        /* --- close the use preference file --- */
        mdlResource_closeFile (userPrefsH);
        }

    /* --- Set default values --- */
	pntinfo.angle           = 0.0;
	pntinfo.textSize        = 0;
	pntinfo.scale		= 3;
	pntinfo.coordsys	= 3;
	pntinfo.loc_permit	= 4;
	pntinfo.loc_elev	= 1;
	pntinfo.loc_lease	= 3;
	pntinfo.loc_ip		= 2;
	pntinfo.loc_prodfm	= 4;
	pntinfo.loc_plugbkfm	= 1;
	pntinfo.loc_fmtd	= 1;
	pntinfo.pl_wellsym	= 1;
	pntinfo.pl_permit	= 1;
	pntinfo.pl_elev		= 0;
	pntinfo.pl_lease	= 0;
	pntinfo.pl_ip		= 0;
	pntinfo.pl_prodfm	= 1;
	pntinfo.pl_plugbkfm	= 1;
	pntinfo.pl_fmtd		= 1;
	pntinfo.wellsymLevel	= 1;
        pntinfo.wellsymColor	= 1;
        pntinfo.wellsymWeight	= 0;
	pntinfo.permitLevel	= 1;
        pntinfo.permitColor	= 1;
        pntinfo.permitWeight	= 0;
        pntinfo.elevLevel	= 1;
        pntinfo.elevColor	= 1;
        pntinfo.elevWeight	= 1;
        pntinfo.leaseLevel	= 1;
        pntinfo.leaseColor	= 1;
        pntinfo.leaseWeight	= 1;
        pntinfo.ipLevel		= 1;
        pntinfo.ipColor		= 1;
        pntinfo.ipWeight	= 1;
        pntinfo.prodfmLevel	= 1;
        pntinfo.prodfmColor	= 1;
        pntinfo.prodfmWeight	= 1;
        pntinfo.plugbkfmLevel	= 1;
        pntinfo.plugbkfmColor	= 1;
        pntinfo.plugbkfmWeight	= 1;
        pntinfo.fmtdLevel	= 1;
        pntinfo.fmtdColor	= 1;
        pntinfo.fmtdWeight	= 1;
    }

/*----------------------------------------------------------------------+
|									|
| name		main							|
|									|
+----------------------------------------------------------------------*/
int		main 
(
void
)	
    {
    RscFileHandle   rfHandle;
    char            *setP;
    
    /* --- Publish the dialog item hooks --- */
    mdlDialog_hookPublish (sizeof(uHooks)/sizeof(DialogHookInfo), uHooks);

    /* --- Open our file for access to command table and dialog --- */
    mdlResource_openFile (&rfHandle, NULL, FALSE);
    
    /* ---  Publish locTextInfoP for access by the dialog manager --- */
    setP = mdlCExpression_initializeSet (VISIBILITY_DIALOG_BOX |
                                         VISIBILITY_DEBUGGER, 0, FALSE);

    mdlDialog_publishComplexVariable (setP, "pnt_info", "pntinfo", &pntinfo);

    /* --- set defaults --- */
    pntdata_setDefaults ();

    pntinfo.pointFile[0]=0;

    /* --- Set up function to get called at unload time --- */
    mdlSystem_setFunction (SYSTEM_UNLOAD_PROGRAM, pntdata_unloadFunction);

    /* --- Open the dialog box --- */
    mdlDialog_open (NULL, DIALOGID_Pntdata);
    
    return;
    }
