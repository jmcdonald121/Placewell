/*----------------------------------------------------------------------+
|                                                                       |
|   ***placedlg.h***     12-2-1993                                      |
|                                                                       |
|                    dialog box definitions                             |
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
#include <basetype.h>

#define DIALOGID_Pntdata            1

#define HOOKID_DialogBox            1
#define HOOKITEMID_File_Select      2
#define HOOKITEMID_Run              3

#define PUSHBUTTONID_Ascii          2
#define PUSHBUTTONID_Okay           3
#define PUSHBUTTONID_Quit           4

#define TEXTID_PointFile            3
#define TEXTID_WellSymLevel         4
#define TEXTID_WellSymColor         5
#define TEXTID_WellSymWeight        6
#define TEXTID_PermitLevel          7
#define TEXTID_PermitColor          8
#define TEXTID_PermitWeight         9
#define TEXTID_ElevLevel           10
#define TEXTID_ElevColor           11
#define TEXTID_ElevWeight          12
#define TEXTID_LeaseLevel          13
#define TEXTID_LeaseColor          14
#define TEXTID_LeaseWeight         15
#define TEXTID_IPLevel             16
#define TEXTID_IPColor             17
#define TEXTID_IPWeight            18
#define TEXTID_ProdFmLevel         19
#define TEXTID_ProdFmColor         20
#define TEXTID_ProdFmWeight        21
#define TEXTID_PlugBkFmLevel       22
#define TEXTID_PlugBkFmColor       23
#define TEXTID_PlugBkFmWeight      24
#define TEXTID_FmTDLevel           25
#define TEXTID_FmTDColor           26
#define TEXTID_FmTDWeight          27

#define OPTIONBUTTONID_Scale            1
#define OPTIONBUTTONID_PermitLocation   2
#define OPTIONBUTTONID_ElevLocation     3
#define OPTIONBUTTONID_LeaseLocation    4
#define OPTIONBUTTONID_IPLocation       5
#define OPTIONBUTTONID_ProdFmLocation   6
#define OPTIONBUTTONID_PlugBkFmLocation 7
#define OPTIONBUTTONID_FmTDLocation     8
#define OPTIONBUTTONID_CoordSys         9
#define OPTIONBUTTONID_TextSize        10 

#define TOGGLEID_WellSym            1
#define TOGGLEID_PermitNumber       2
#define TOGGLEID_Elev               3
#define TOGGLEID_LeaseNumber        4
#define TOGGLEID_IP                 5
#define TOGGLEID_ProdFm             6
#define TOGGLEID_PlugBkFm           7
#define TOGGLEID_FmTD               8

/*----------------------------------------------------------------------+
|                                                                       |
|   Resource Type and ID for Prefs                                      |
|                                                                       |
+----------------------------------------------------------------------*/
#define RTYPE_Pntd                     'Pntd'
#define RSCID_Pntd                      1


/*----------------------------------------------------------------------+
|                                                                       |
|   Local Structure Definitions                                         |
|                                                                       |
+----------------------------------------------------------------------*/
typedef struct pnt_info
    {
    int		textSize;
    double  angle;
    char    pointFile[66];
    int     scale;
    int     coordsys;
    int	   loc_permit;
    int	   loc_elev;
    int	   loc_lease;
    int	   loc_ip;
    int	   loc_prodfm;
    int	   loc_plugbkfm;
    int	   loc_fmtd;
    int     pl_wellsym;
    int     pl_permit;
    int	   pl_elev;
    int     pl_lease;    
    int	   pl_ip;
    int	   pl_prodfm;
    int	   pl_plugbkfm;
    int	   pl_fmtd;
    int     wellsymLevel;
    int     wellsymColor;
    int     wellsymWeight;
    int     permitLevel;
    int     permitColor;
    int     permitWeight;
    int     elevLevel;
    int     elevColor;
    int     elevWeight;
    int     leaseLevel;
    int     leaseColor;
    int     leaseWeight;
    int     ipLevel;
    int     ipColor;
    int     ipWeight;
    int     prodfmLevel;
    int     prodfmColor;
    int     prodfmWeight;
    int     plugbkfmLevel;
    int     plugbkfmColor;
    int     plugbkfmWeight;
    int     fmtdLevel;
    int     fmtdColor;
    int     fmtdWeight;
    }
    pntInfo;

