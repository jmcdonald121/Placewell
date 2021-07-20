/*----------------------------------------------------------------------+
|                                                                       |
|   ***placedlg.r***     12-2-1993                                      |
|                                                                       |
|                   dialog box resource file for pntdata.mc             |
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
#include <rscdefs.h>
#include <dlogbox.h>
#include <dlogids.h>

#include "placedlg.h"

/*----------------------------------------------------------------------+
|                                                                       |
|   Locate Text Dialog Box                                              |
|                                                                       |
+----------------------------------------------------------------------*/
#define  OVERALLWIDTH   77*XC
#define  OVERALLHEIGHT  GENY(29.5)
#define  BW             8*XC

#define  GB1W           25*XC
#define  GB1H           GENY(8.0)
#define  GB3W           58*XC
#define  GB3H           GENY(3.0)

#define  FW1            4*XC
#define  FW2            12*XC
#define  FW2A           13*XC
#define  FW2B           21*XC
#define  FW3            35*XC

#define  X1             1*XC
#define  X2             12*XC
#define  X2A            9.5*XC
#define  X2B            X2A+(12*XC)

#define  X3             2.5*X1
#define  X4             10.5*X1

#define  X5             7*XC

#define  X6             GB1W+XC
#define  X7             X6+X3-X1
#define  X8             X6+X4-X1

#define  X9              X2A+(49*XC)
#define  X10             X7
#define  X11             X10+15*XC

#define  X12            2*GB1W+XC
#define  X13            X12+X3-X1
#define  X14            X12+X4-X1

#define  X15            X12+2.5*X1



#define  Y1             GENY(1.1)
#define  Y2             Y1 + GENY(1.5)
#define  Y3             Y2 + GENY(1.9)
#define  Y4             Y3 + GENY(1.9)
#define  Y5             Y4 + GENY(1.9)
#define  Y6             Y5 + GENY(1.9)
#define  Y6A            Y6 + GENY(0.5)
#define  Y7             Y6 + GENY(1.9)
#define  Y8             Y7 + GENY(2.75)
#define  Y9             Y8 + GENY(1.5)
#define  Y10            Y9 + GENY(1.9)
#define  Y11            Y10 + GENY(1.9)

#define  Y12            Y11 + GENY(2.75) + 6*GENY(1.9)
#define  Y13            Y12 + GENY(1.5)
#define  Y13A           Y12 + GENY(1.3)
#define  Y14            Y13 + GENY(2.3)
#define  Y14A           Y13 + GENY(2)
#define  Y15            Y14 + GENY(3.2)

#define  Y21		2*Y1 + GB1H
#define  Y22		Y21+Y2-Y1
#define  Y23		Y21+Y3-Y1
#define  Y24		Y21+Y4-Y1
#define  Y25		Y21+Y5-Y1
#define  Y26		Y21+Y6-Y1

#define  Y27		3*Y1 + 2*GB1H
#define  Y28		Y27+Y2-Y1
#define  Y29		Y27+Y3-Y1
#define  Y30		Y27+Y4-Y1
#define  Y31		Y27+Y5-Y1
#define  Y32		Y27+Y6-Y1

#define  Y33		4*Y1 + 3*GB1H
#define  Y34		Y33+Y2-Y1
#define  Y35		Y33+Y2-Y1+GENY(0.2)

#define  Y36		5*Y1 + 3*GB1H + GB3H


DialogBoxRsc DIALOGID_Pntdata =
    {
    DIALOGATTR_DEFAULT,
    OVERALLWIDTH, OVERALLHEIGHT,
    NOHELP, MHELP, HOOKID_DialogBox, NOPARENTID,
    "Place Well Data - PLACEWEL",
{
    {{ X1,  Y1, GB1W, GB1H}, GroupBox,                                   0,  ON, 0,            "Well Symbol", ""},
    {{ X3,  Y2, FW2B,    0}, ToggleButton,                TOGGLEID_WellSym,  ON, 0,                       "", ""},
    {{ X4,  Y3,  FW1,    0},         Text,             TEXTID_WellSymLevel,  ON, 0,                       "", ""},
    {{ X4,  Y4,  FW1,    0},         Text,             TEXTID_WellSymColor,  ON, 0,                       "", ""},
    {{ X4,  Y5,  FW1,    0},         Text,            TEXTID_WellSymWeight,  ON, 0,                       "", ""},

    {{ X6,  Y1, GB1W, GB1H},     GroupBox,                               0,  ON, 0,          "Permit Number", ""},
    {{ X7,  Y2, FW2B,    0}, ToggleButton,           TOGGLEID_PermitNumber,  ON, 0,                       "", ""},
    {{ X8,  Y3,  FW1,    0},         Text,              TEXTID_PermitLevel,  ON, 0,                       "", ""},
    {{ X8,  Y4,  FW1,    0},         Text,              TEXTID_PermitColor,  ON, 0,                       "", ""},
    {{ X8,  Y5,  FW1,    0},         Text,             TEXTID_PermitWeight,  ON, 0,                       "", ""},
    {{ X8,  Y6, FW2A,    0}, OptionButton,   OPTIONBUTTONID_PermitLocation,  ON, 0,                       "", ""}, 

    {{X12,  Y1, GB1W, GB1H},     GroupBox,                               0,  ON, 0,                 "Subsea", ""},
    {{X13,  Y2, FW2B,    0}, ToggleButton,                   TOGGLEID_Elev,  ON, 0,                       "", ""},
    {{X14,  Y3,  FW1,    0},         Text,                TEXTID_ElevLevel,  ON, 0,                       "", ""},
    {{X14,  Y4,  FW1,    0},         Text,                TEXTID_ElevColor,  ON, 0,                       "", ""},
    {{X14,  Y5,  FW1,    0},         Text,               TEXTID_ElevWeight,  ON, 0,                       "", ""},
    {{X14,  Y6, FW2A,    0}, OptionButton,     OPTIONBUTTONID_ElevLocation,  ON, 0,                       "", ""}, 

    {{ X1, Y21, GB1W, GB1H},     GroupBox,                               0, OFF, 0,           "Lease Number", ""},
    {{ X3, Y22, FW2B,    0}, ToggleButton,            TOGGLEID_LeaseNumber, OFF, 0,                       "", ""},
    {{ X4, Y23,  FW1,    0},         Text,               TEXTID_LeaseLevel, OFF, 0,                       "", ""},
    {{ X4, Y24,  FW1,    0},         Text,               TEXTID_LeaseColor, OFF, 0,                       "", ""},
    {{ X4, Y25,  FW1,    0},         Text,              TEXTID_LeaseWeight, OFF, 0,                       "", ""},
    {{ X4, Y26, FW2A,    0}, OptionButton,    OPTIONBUTTONID_LeaseLocation, OFF, 0,                       "", ""}, 

    {{ X6, Y21, GB1W, GB1H},     GroupBox,                               0, OFF, 0,     "Initial Production", ""},
    {{ X7, Y22, FW2B,    0}, ToggleButton,                     TOGGLEID_IP, OFF, 0,                       "", ""},
    {{ X8, Y23,  FW1,    0},         Text,                  TEXTID_IPLevel, OFF, 0,                       "", ""},
    {{ X8, Y24,  FW1,    0},         Text,                  TEXTID_IPColor, OFF, 0,                       "", ""},
    {{ X8, Y25,  FW1,    0},         Text,                 TEXTID_IPWeight, OFF, 0,                       "", ""},
    {{ X8, Y26, FW2A,    0}, OptionButton,       OPTIONBUTTONID_IPLocation, OFF, 0,                       "", ""}, 

    {{X12, Y21, GB1W, GB1H},     GroupBox,                               0,  ON, 0,    "Producing Formation", ""},
    {{X13, Y22, FW2B,    0}, ToggleButton,                 TOGGLEID_ProdFm,  ON, 0,                       "", ""},
    {{X14, Y23,  FW1,    0},         Text,              TEXTID_ProdFmLevel,  ON, 0,                       "", ""},
    {{X14, Y24,  FW1,    0},         Text,              TEXTID_ProdFmColor,  ON, 0,                       "", ""},
    {{X14, Y25,  FW1,    0},         Text,             TEXTID_ProdFmWeight,  ON, 0,                       "", ""},
    {{X14, Y26, FW2A,    0}, OptionButton,   OPTIONBUTTONID_ProdFmLocation,  ON, 0,                       "", ""}, 

    {{ X1, Y27, GB1W, GB1H},     GroupBox,                               0,  ON, 0, "Plugged Back Formation", ""},
    {{ X3, Y28, FW2B,    0}, ToggleButton,               TOGGLEID_PlugBkFm,  ON, 0,                       "", ""},
    {{ X4, Y29,  FW1,    0},         Text,            TEXTID_PlugBkFmLevel,  ON, 0,                       "", ""},
    {{ X4, Y30,  FW1,    0},         Text,            TEXTID_PlugBkFmColor,  ON, 0,                       "", ""},
    {{ X4, Y31,  FW1,    0},         Text,           TEXTID_PlugBkFmWeight,  ON, 0,                       "", ""},
    {{ X4, Y32, FW2A,    0}, OptionButton, OPTIONBUTTONID_PlugBkFmLocation,  ON, 0,                       "", ""}, 

    {{ X6, Y27, GB1W, GB1H},     GroupBox,                               0,  ON, 0,        "Formation at TD", ""},
    {{ X7, Y28, FW2B,    0}, ToggleButton,                   TOGGLEID_FmTD,  ON, 0,                       "", ""},
    {{ X8, Y29,  FW1,    0},         Text,                TEXTID_FmTDLevel,  ON, 0,                       "", ""},
    {{ X8, Y30,  FW1,    0},         Text,                TEXTID_FmTDColor,  ON, 0,                       "", ""},
    {{ X8, Y31,  FW1,    0},         Text,               TEXTID_FmTDWeight,  ON, 0,                       "", ""},
    {{ X8, Y32, FW2A,    0}, OptionButton,     OPTIONBUTTONID_FmTDLocation,  ON, 0,                       "", ""}, 

    {{X2A, Y33, GB3W, GB3H},     GroupBox,                               0,  ON, 0,                  "Files", ""},
    {{X2B, Y34,  FW3,    0},         Text,                TEXTID_PointFile,  ON, 0,                       "", ""},
    {{ X9, Y35,   BW,    0},   PushButton,              PUSHBUTTONID_Ascii,  ON, 0,                       "", ""},
    {{X10, Y36,   BW,    0},   PushButton,               PUSHBUTTONID_Okay,  ON, 0,                       "", ""},
    {{X11, Y36,   BW,    0},   PushButton,               PUSHBUTTONID_Quit,  ON, 0,                       "", ""},

    {{X14, Y29,  FW2,    0}, OptionButton,            OPTIONBUTTONID_Scale,  ON, 0,                       "", ""},
    {{X14, Y30,  FW2,    0}, OptionButton,         OPTIONBUTTONID_TextSize,  ON, 0,                       "", ""},
    {{X15, Y31, FW2B,    0}, OptionButton,         OPTIONBUTTONID_CoordSys,  ON, 0,                       "", ""}
}
    };

/*----------------------------------------------------------------------+
|                                                                       |
|      Text Items                                                       |
|                                                                       |
+----------------------------------------------------------------------*/
DItem_TextRsc TEXTID_WellSymLevel =
    {
    NOCMD, LCMD, NOSYNONYM, NOHELP, MHELP, NOHOOK, NOARG, 
    2, "%d", "%d", "1", "63", NOMASK, CONCAT,
    "Level:",
    "pntinfo.wellsymLevel"
    };

DItem_TextRsc TEXTID_WellSymColor =
    {
    NOCMD, LCMD, NOSYNONYM, NOHELP, MHELP, NOHOOK, NOARG, 
    3, "%d", "%d", "0", "255", NOMASK, CONCAT,
    "Color:",
    "pntinfo.wellsymColor"
    };

DItem_TextRsc TEXTID_WellSymWeight =
    {
    NOCMD, LCMD, NOSYNONYM, NOHELP, MHELP, NOHOOK, NOARG, 
    2, "%d", "%d", "0", "31", NOMASK, CONCAT,
    "Weight:",
    "pntinfo.wellsymWeight"
    };

DItem_TextRsc TEXTID_PermitLevel =
    {
    NOCMD, LCMD, NOSYNONYM, NOHELP, MHELP, NOHOOK, NOARG, 
    2, "%d", "%d", "1", "63", NOMASK, CONCAT,
    "Level:",
    "pntinfo.permitLevel"
    };

DItem_TextRsc TEXTID_PermitColor =
    {
    NOCMD, LCMD, NOSYNONYM, NOHELP, MHELP, NOHOOK, NOARG, 
    3, "%d", "%d", "0", "255", NOMASK, CONCAT,
    "Color:",
    "pntinfo.permitColor"
    };

DItem_TextRsc TEXTID_PermitWeight =
    {
    NOCMD, LCMD, NOSYNONYM, NOHELP, MHELP, NOHOOK, NOARG, 
    2, "%d", "%d", "0", "31", NOMASK, CONCAT,
    "Weight:",
    "pntinfo.permitWeight"
    };


DItem_TextRsc TEXTID_ElevLevel =
    {
    NOCMD, LCMD, NOSYNONYM, NOHELP, MHELP, NOHOOK, NOARG, 
    2, "%d", "%d", "1", "63", NOMASK, CONCAT,
    "Level:",
    "pntinfo.elevLevel"
    };

DItem_TextRsc TEXTID_ElevColor =
    {
    NOCMD, LCMD, NOSYNONYM, NOHELP, MHELP, NOHOOK, NOARG, 
    3, "%d", "%d", "0", "255", NOMASK, CONCAT,
    "Color:",
    "pntinfo.elevColor"
    };

DItem_TextRsc TEXTID_ElevWeight =
    {
    NOCMD, LCMD, NOSYNONYM, NOHELP, MHELP, NOHOOK, NOARG, 
    2, "%d", "%d", "0", "31", NOMASK, CONCAT,
    "Weight:",
    "pntinfo.elevWeight"
    };

DItem_TextRsc TEXTID_LeaseLevel =
    {
    NOCMD, LCMD, NOSYNONYM, NOHELP, MHELP, NOHOOK, NOARG, 
    2, "%d", "%d", "1", "63", NOMASK, CONCAT,
    "Level:",
    "pntinfo.leaseLevel"
    };

DItem_TextRsc TEXTID_LeaseColor =
    {
    NOCMD, LCMD, NOSYNONYM, NOHELP, MHELP, NOHOOK, NOARG, 
    3, "%d", "%d", "0", "255", NOMASK, CONCAT,
    "Color:",
    "pntinfo.leaseColor"
    };

DItem_TextRsc TEXTID_LeaseWeight =
    {
    NOCMD, LCMD, NOSYNONYM, NOHELP, MHELP, NOHOOK, NOARG, 
    2, "%d", "%d", "0", "31", NOMASK, CONCAT,
    "Weight:",
    "pntinfo.leaseWeight"
    };

DItem_TextRsc TEXTID_IPLevel =
    {
    NOCMD, LCMD, NOSYNONYM, NOHELP, MHELP, NOHOOK, NOARG, 
    2, "%d", "%d", "1", "63", NOMASK, CONCAT,
    "Level:",
    "pntinfo.ipLevel"
    };

DItem_TextRsc TEXTID_IPColor =
    {
    NOCMD, LCMD, NOSYNONYM, NOHELP, MHELP, NOHOOK, NOARG, 
    3, "%d", "%d", "0", "255", NOMASK, CONCAT,
    "Color:",
    "pntinfo.ipColor"
    };

DItem_TextRsc TEXTID_IPWeight =
    {
    NOCMD, LCMD, NOSYNONYM, NOHELP, MHELP, NOHOOK, NOARG, 
    2, "%d", "%d", "0", "31", NOMASK, CONCAT,
    "Weight:",
    "pntinfo.ipWeight"
    };

DItem_TextRsc TEXTID_ProdFmLevel =
    {
    NOCMD, LCMD, NOSYNONYM, NOHELP, MHELP, NOHOOK, NOARG, 
    2, "%d", "%d", "1", "63", NOMASK, CONCAT,
    "Level:",
    "pntinfo.prodfmLevel"
    };

DItem_TextRsc TEXTID_ProdFmColor =
    {
    NOCMD, LCMD, NOSYNONYM, NOHELP, MHELP, NOHOOK, NOARG, 
    3, "%d", "%d", "0", "255", NOMASK, CONCAT,
    "Color:",
    "pntinfo.prodfmColor"
    };

DItem_TextRsc TEXTID_ProdFmWeight =
    {
    NOCMD, LCMD, NOSYNONYM, NOHELP, MHELP, NOHOOK, NOARG, 
    2, "%d", "%d", "0", "31", NOMASK, CONCAT,
    "Weight:",
    "pntinfo.prodfmWeight"
    };

DItem_TextRsc TEXTID_PlugBkFmLevel =
    {
    NOCMD, LCMD, NOSYNONYM, NOHELP, MHELP, NOHOOK, NOARG, 
    2, "%d", "%d", "1", "63", NOMASK, CONCAT,
    "Level:",
    "pntinfo.plugbkfmLevel"
    };

DItem_TextRsc TEXTID_PlugBkFmColor =
    {
    NOCMD, LCMD, NOSYNONYM, NOHELP, MHELP, NOHOOK, NOARG, 
    3, "%d", "%d", "0", "255", NOMASK, CONCAT,
    "Color:",
    "pntinfo.plugbkfmColor"
    };

DItem_TextRsc TEXTID_PlugBkFmWeight =
    {
    NOCMD, LCMD, NOSYNONYM, NOHELP, MHELP, NOHOOK, NOARG, 
    2, "%d", "%d", "0", "31", NOMASK, CONCAT,
    "Weight:",
    "pntinfo.plugbkfmWeight"
    };

DItem_TextRsc TEXTID_FmTDLevel =
    {
    NOCMD, LCMD, NOSYNONYM, NOHELP, MHELP, NOHOOK, NOARG, 
    2, "%d", "%d", "1", "63", NOMASK, CONCAT,
    "Level:",
    "pntinfo.fmtdLevel"
    };

DItem_TextRsc TEXTID_FmTDColor =
    {
    NOCMD, LCMD, NOSYNONYM, NOHELP, MHELP, NOHOOK, NOARG, 
    3, "%d", "%d", "0", "255", NOMASK, CONCAT,
    "Color:",
    "pntinfo.fmtdColor"
    };

DItem_TextRsc TEXTID_FmTDWeight =
    {
    NOCMD, LCMD, NOSYNONYM, NOHELP, MHELP, NOHOOK, NOARG, 
    2, "%d", "%d", "0", "31", NOMASK, CONCAT,
    "Weight:",
    "pntinfo.fmtdWeight"
    };

DItem_TextRsc TEXTID_PointFile =
    {
    NOCMD, LCMD, NOSYNONYM, NOHELP, MHELP, NOHOOK, NOARG, 
    66, "%s", "%s", "", "", NOMASK, CONCAT,
    "ASCII Point:",
    "pntinfo.pointFile"
    };

/*----------------------------------------------------------------------+
|                                                                       |
|      Push Button Items                                                |
|                                                                       |
+----------------------------------------------------------------------*/
DItem_PushButtonRsc PUSHBUTTONID_Ascii =
    {
    NOT_DEFAULT_BUTTON, NOHELP, MHELP, 
    HOOKITEMID_File_Select, PUSHBUTTONID_Ascii, NOCMD, MCMD, "",
    "Select"
    }

DItem_PushButtonRsc PUSHBUTTONID_Okay =
    {
    NOT_DEFAULT_BUTTON, NOHELP, MHELP, 
    HOOKITEMID_Run, PUSHBUTTONID_Okay, NOCMD, MCMD, "",
    "Run"
    }

DItem_PushButtonRsc PUSHBUTTONID_Quit =
    {
    NOT_DEFAULT_BUTTON, NOHELP, MHELP, 
    HOOKITEMID_Run, PUSHBUTTONID_Quit, NOCMD, MCMD, "",
    "Cancel"
    }
/*----------------------------------------------------------------------+
|                                                                       |
|      Option Button Items                                              |
|                                                                       |
+----------------------------------------------------------------------*/
DItem_OptionButtonRsc OPTIONBUTTONID_Scale =
	{
		NOSYNONYM, NOHELP, MHELP, NOHOOK,NOARG,
		"Scale :",	
		"pntinfo.scale",
		{
		{NOTYPE, NOICON, NOCMD, LCMD, 0, NOMASK, ON, "1:1320"}, 
		{NOTYPE, NOICON, NOCMD, LCMD, 1, NOMASK, ON, "1:24000"}, 
		{NOTYPE, NOICON, NOCMD, LCMD, 2, NOMASK, ON, "1:62500"}, 
		{NOTYPE, NOICON, NOCMD, LCMD, 3, NOMASK, ON, "1:100000"},
		{NOTYPE, NOICON, NOCMD, LCMD, 4, NOMASK, ON, "1:250000"},
		{NOTYPE, NOICON, NOCMD, LCMD, 5, NOMASK, ON, "1:500000"}
		}
	};

DItem_OptionButtonRsc OPTIONBUTTONID_TextSize =
	{
		NOSYNONYM, NOHELP, MHELP, NOHOOK,NOARG,
		"Text Size :",	
		"pntinfo.textSize",
		{
		{NOTYPE, NOICON, NOCMD, LCMD, 0, NOMASK, ON, "8 pt."}, 
		{NOTYPE, NOICON, NOCMD, LCMD, 1, NOMASK, ON, "10 pt"}, 
		{NOTYPE, NOICON, NOCMD, LCMD, 2, NOMASK, ON, "12 pt."}, 
		{NOTYPE, NOICON, NOCMD, LCMD, 3, NOMASK, ON, "DCMS 1&2"},
		{NOTYPE, NOICON, NOCMD, LCMD, 4, NOMASK, ON, "DCMS 3"}
		}
	};

DItem_OptionButtonRsc OPTIONBUTTONID_CoordSys =
	{
		NOSYNONYM, NOHELP, MHELP, NOHOOK,NOARG,
		"",	
		"pntinfo.coordsys",
		{
		{NOTYPE, NOICON, NOCMD, LCMD, 0, NOMASK,  ON, "Ohio - State Plane South"}, 
		{NOTYPE, NOICON, NOCMD, LCMD, 1, NOMASK,  ON, "Ohio - State Plane North"}, 
		{NOTYPE, NOICON, NOCMD, LCMD, 2, NOMASK, OFF,              "UTM Zone 17"}, 
		{NOTYPE, NOICON, NOCMD, LCMD, 3, NOMASK, OFF,              "UTM Zone 18"}
		}
	};


DItem_OptionButtonRsc OPTIONBUTTONID_PermitLocation =
	{
		NOSYNONYM, NOHELP, MHELP, NOHOOK,NOARG,
		"Location :",	
		"pntinfo.loc_permit",
		{
		{NOTYPE, NOICON, NOCMD, LCMD, 0, NOMASK, ON, "Top"}, 
		{NOTYPE, NOICON, NOCMD, LCMD, 1, NOMASK, ON, "Upper Right"}, 
		{NOTYPE, NOICON, NOCMD, LCMD, 2, NOMASK, ON, "Right"},
		{NOTYPE, NOICON, NOCMD, LCMD, 3, NOMASK, ON, "Lower Right"},
		{NOTYPE, NOICON, NOCMD, LCMD, 4, NOMASK, ON, "Bottom"},
		{NOTYPE, NOICON, NOCMD, LCMD, 5, NOMASK, ON, "Lower Left"},
		{NOTYPE, NOICON, NOCMD, LCMD, 6, NOMASK, ON, "Left"},
		{NOTYPE, NOICON, NOCMD, LCMD, 7, NOMASK, ON, "Upper Left"}
		}
	};

DItem_OptionButtonRsc OPTIONBUTTONID_ElevLocation =
	{
		NOSYNONYM, NOHELP, MHELP, NOHOOK,NOARG,
		"Location :",	
		"pntinfo.loc_elev",
		{
		{NOTYPE, NOICON, NOCMD, LCMD, 0, NOMASK, ON, "Top"}, 
		{NOTYPE, NOICON, NOCMD, LCMD, 1, NOMASK, ON, "Upper Right"}, 
		{NOTYPE, NOICON, NOCMD, LCMD, 2, NOMASK, ON, "Right"},
		{NOTYPE, NOICON, NOCMD, LCMD, 3, NOMASK, ON, "Lower Right"},
		{NOTYPE, NOICON, NOCMD, LCMD, 4, NOMASK, ON, "Bottom"},
		{NOTYPE, NOICON, NOCMD, LCMD, 5, NOMASK, ON, "Lower Left"},
		{NOTYPE, NOICON, NOCMD, LCMD, 6, NOMASK, ON, "Left"},
		{NOTYPE, NOICON, NOCMD, LCMD, 7, NOMASK, ON, "Upper Left"}
		}
	};

DItem_OptionButtonRsc OPTIONBUTTONID_LeaseLocation =
	{
		NOSYNONYM, NOHELP, MHELP, NOHOOK,NOARG,
		"Location :",	
		"pntinfo.loc_lease",
		{
		{NOTYPE, NOICON, NOCMD, LCMD, 0, NOMASK, ON, "Top"}, 
		{NOTYPE, NOICON, NOCMD, LCMD, 1, NOMASK, ON, "Upper Right"}, 
		{NOTYPE, NOICON, NOCMD, LCMD, 2, NOMASK, ON, "Right"},
		{NOTYPE, NOICON, NOCMD, LCMD, 3, NOMASK, ON, "Lower Right"},
		{NOTYPE, NOICON, NOCMD, LCMD, 4, NOMASK, ON, "Bottom"},
		{NOTYPE, NOICON, NOCMD, LCMD, 5, NOMASK, ON, "Lower Left"},
		{NOTYPE, NOICON, NOCMD, LCMD, 6, NOMASK, ON, "Left"},
		{NOTYPE, NOICON, NOCMD, LCMD, 7, NOMASK, ON, "Upper Left"}
		}
	};

DItem_OptionButtonRsc OPTIONBUTTONID_IPLocation =
	{
		NOSYNONYM, NOHELP, MHELP, NOHOOK,NOARG,
		"Location :",	
		"pntinfo.loc_ip",
		{
		{NOTYPE, NOICON, NOCMD, LCMD, 0, NOMASK, ON, "Top"}, 
		{NOTYPE, NOICON, NOCMD, LCMD, 1, NOMASK, ON, "Upper Right"}, 
		{NOTYPE, NOICON, NOCMD, LCMD, 2, NOMASK, ON, "Right"},
		{NOTYPE, NOICON, NOCMD, LCMD, 3, NOMASK, ON, "Lower Right"},
		{NOTYPE, NOICON, NOCMD, LCMD, 4, NOMASK, ON, "Bottom"},
		{NOTYPE, NOICON, NOCMD, LCMD, 5, NOMASK, ON, "Lower Left"},
		{NOTYPE, NOICON, NOCMD, LCMD, 6, NOMASK, ON, "Left"},
		{NOTYPE, NOICON, NOCMD, LCMD, 7, NOMASK, ON, "Upper Left"}
		}
	};

DItem_OptionButtonRsc OPTIONBUTTONID_ProdFmLocation =
	{
		NOSYNONYM, NOHELP, MHELP, NOHOOK,NOARG,
		"Location :",	
		"pntinfo.loc_prodfm",
		{
		{NOTYPE, NOICON, NOCMD, LCMD, 0, NOMASK, ON, "Top"}, 
		{NOTYPE, NOICON, NOCMD, LCMD, 1, NOMASK, ON, "Upper Right"}, 
		{NOTYPE, NOICON, NOCMD, LCMD, 2, NOMASK, ON, "Right"},
		{NOTYPE, NOICON, NOCMD, LCMD, 3, NOMASK, ON, "Lower Right"},
		{NOTYPE, NOICON, NOCMD, LCMD, 4, NOMASK, ON, "Bottom"},
		{NOTYPE, NOICON, NOCMD, LCMD, 5, NOMASK, ON, "Lower Left"},
		{NOTYPE, NOICON, NOCMD, LCMD, 6, NOMASK, ON, "Left"},
		{NOTYPE, NOICON, NOCMD, LCMD, 7, NOMASK, ON, "Upper Left"}
		}
	};

DItem_OptionButtonRsc OPTIONBUTTONID_PlugBkFmLocation =
	{
		NOSYNONYM, NOHELP, MHELP, NOHOOK,NOARG,
		"Location :",	
		"pntinfo.loc_plugbkfm",
		{
		{NOTYPE, NOICON, NOCMD, LCMD, 0, NOMASK, ON, "Top"}, 
		{NOTYPE, NOICON, NOCMD, LCMD, 1, NOMASK, ON, "Upper Right"}, 
		{NOTYPE, NOICON, NOCMD, LCMD, 2, NOMASK, ON, "Right"},
		{NOTYPE, NOICON, NOCMD, LCMD, 3, NOMASK, ON, "Lower Right"},
		{NOTYPE, NOICON, NOCMD, LCMD, 4, NOMASK, ON, "Bottom"},
		{NOTYPE, NOICON, NOCMD, LCMD, 5, NOMASK, ON, "Lower Left"},
		{NOTYPE, NOICON, NOCMD, LCMD, 6, NOMASK, ON, "Left"},
		{NOTYPE, NOICON, NOCMD, LCMD, 7, NOMASK, ON, "Upper Left"}
		}
	};

DItem_OptionButtonRsc OPTIONBUTTONID_FmTDLocation =
	{
		NOSYNONYM, NOHELP, MHELP, NOHOOK,NOARG,
		"Location :",	
		"pntinfo.loc_fmtd",
		{
		{NOTYPE, NOICON, NOCMD, LCMD, 0, NOMASK, ON, "Top"}, 
		{NOTYPE, NOICON, NOCMD, LCMD, 1, NOMASK, ON, "Upper Right"}, 
		{NOTYPE, NOICON, NOCMD, LCMD, 2, NOMASK, ON, "Right"},
		{NOTYPE, NOICON, NOCMD, LCMD, 3, NOMASK, ON, "Lower Right"},
		{NOTYPE, NOICON, NOCMD, LCMD, 4, NOMASK, ON, "Bottom"},
		{NOTYPE, NOICON, NOCMD, LCMD, 5, NOMASK, ON, "Lower Left"},
		{NOTYPE, NOICON, NOCMD, LCMD, 6, NOMASK, ON, "Left"},
		{NOTYPE, NOICON, NOCMD, LCMD, 7, NOMASK, ON, "Upper Left"}
		}
	};

/*----------------------------------------------------------------------+
|                                                                       |
|      Toggle Button Items                                              |
|                                                                       |
+----------------------------------------------------------------------*/
DItem_ToggleButtonRsc TOGGLEID_WellSym = 
	{
		NOCMD, MCMD, NOSYNONYM, NOHELP, MCMD, NOHOOK, NOARG,
		NOMASK, NOINVERT,
		"Place Well Symbol",
		"pntinfo.pl_wellsym"
	};

DItem_ToggleButtonRsc TOGGLEID_PermitNumber = 
	{
		NOCMD, MCMD, NOSYNONYM, NOHELP, MCMD, NOHOOK, NOARG,
		NOMASK, NOINVERT,
		"Place Permit",
		"pntinfo.pl_permit"
	};

DItem_ToggleButtonRsc TOGGLEID_Elev = 
	{
		NOCMD, MCMD, NOSYNONYM, NOHELP, MCMD, NOHOOK, NOARG,
		NOMASK, NOINVERT,
		"Place Subsea",
		"pntinfo.pl_elev"
	};

DItem_ToggleButtonRsc TOGGLEID_LeaseNumber = 
	{
		NOCMD, MCMD, NOSYNONYM, NOHELP, MCMD, NOHOOK, NOARG,
		NOMASK, NOINVERT,
		"Place Lease No.",
		"pntinfo.pl_lease"
	};

DItem_ToggleButtonRsc TOGGLEID_IP = 
	{
		NOCMD, MCMD, NOSYNONYM, NOHELP, MCMD, NOHOOK, NOARG,
		NOMASK, NOINVERT,
		"Place IP",
		"pntinfo.pl_ip"
	};

DItem_ToggleButtonRsc TOGGLEID_ProdFm = 
	{
		NOCMD, MCMD, NOSYNONYM, NOHELP, MCMD, NOHOOK, NOARG,
		NOMASK, NOINVERT,
		"Place Producing Fm.",
		"pntinfo.pl_prodfm"
	};

DItem_ToggleButtonRsc TOGGLEID_PlugBkFm = 
	{
		NOCMD, MCMD, NOSYNONYM, NOHELP, MCMD, NOHOOK, NOARG,
		NOMASK, NOINVERT,
		"Place Plugged Back Fm.",
		"pntinfo.pl_plugbkfm"
	};

DItem_ToggleButtonRsc TOGGLEID_FmTD = 
	{
		NOCMD, MCMD, NOSYNONYM, NOHELP, MCMD, NOHOOK, NOARG,
		NOMASK, NOINVERT,
		"Place Formation at TD",
		"pntinfo.pl_fmtd"
	};


