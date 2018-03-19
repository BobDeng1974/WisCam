#ifndef __WISCAM_CONFIG_H__
#define __WISCAM_CONFIG_H__

typedef enum {
        eCONFIG_GROUP_UNKNOWN   = -1,
        eCONFIG_GROUP_WIFI,
        eCONFIG_GROUP_STREAM,
        eCONFIG_GROUP_NABTO,
		eCONFIG_GROUP_APMSG,
		eCONFIG_GROUP_STAMSG,
		eCONFIG_GROUP_APSTAMSG,
		eCONFIG_GROUP_VERSION,
		eCONFIG_GROUP_CNT,
} E_CONFIG_GROUP;


static char *s_astrConfigFile[eCONFIG_GROUP_CNT] = {
	DEF_CONF_PATH_NUWICAM_WIFI,
	DEF_CONF_PATH_NUWICAM_STREAM,
	DEF_CONF_PATH_NUWICAM_NABTO,
	DEF_CONF_PATH_NUWICAM_APMSG,
	DEF_CONF_PATH_NUWICAM_STAMSG,
	DEF_CONF_PATH_NUWICAM_APSTAMSG,
	DEF_CONF_PATH_NUWICAM_VERSION,
};

static char *g_astrGroupName[] = {
	"wifi",
	"stream",
	"nabto",
	"apmsg",
	"stamsg",
	"apstamsg",
	"version",
	NULL,
};

static char *g_astrNAbtoParam[]={
	"nabto_id",
	"nabto_key",
	"nabto_uuid",
	NULL,
};

static char *g_astrWifiParam[] = {
	"BOOTPROTO",
	"IPADDR",
	"GATEWAY",
	"SSID",
	"AUTH_MODE",
	"ENCRYPT_TYPE",
	"AUTH_KEY",
	"WPS_TRIG_KEY",
	"AP_IPADDR",
	"AP_SSID",
	"AP_AUTH_MODE",
	"AP_ENCRYPT_TYPE",
	"AP_AUTH_KEY",
	"AP_CHANNEL",
	
	NULL,
};

static char *g_astrStreamParam[] = {
	"VINWIDTH",
	"VINHEIGHT",
	"JPEGENCWIDTH",
	"JPEGENCHEIGHT",
	"BITRATE",
	NULL,
};

static char *g_astrApMsgParam[] = {
	"ap_ssid",
	"ap_key",
	"ap_bssid",
	"ap_ipaddr",
	"ap_channel",
	"ap_gateway",
	NULL,
};

static char *g_astrStaMsgParam[] = {
	"sta_ssid",
	"sta_key",
	"sta_bssid",
	"sta_ipaddr",
	"sta_gateway",
	NULL,
};
static char *g_astrApStaMsgParam[] = {
	"ap_ssid",
	"ap_key",
	"ap_bssid",
	"ap_ipaddr",
	"ap_channel",
	"ap_gateway",
	"sta_ssid",
	"sta_key",
	"sta_bssid",
	"sta_ipaddr",
	"sta_gateway",
	NULL,
};

static char *g_astrVersion[] = {
	"version",
	NULL,
};

static char **g_astrParamGroup[] = {
	g_astrWifiParam,
	g_astrStreamParam,
	g_astrNAbtoParam,
	g_astrApMsgParam,
	g_astrStaMsgParam,
	g_astrApStaMsgParam,
	g_astrVersion,
};

#endif //__WISCAM_CONFIG_H__
