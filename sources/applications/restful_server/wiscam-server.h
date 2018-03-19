#ifndef __WISCAM_SERVE_H__
#define __WISCAM_SERVE_H__

#include "mongoose.h"

#define RK_PLATFORM_API "wiscam.api/v1/"

#define RK_HTTP_HEADER "Cache-Control: no-store, no-cache\r\n" \
	"Content-Type: application/json\r\n\r\n"

#define RK_DEF_JSON_HEADER "HTTP/1.1 200 OK\r\n"RK_HTTP_HEADER
#define RK_POST_STATE(buf, x) sprintf(buf,"HTTP/1.1 200 OK\r\n"RK_HTTP_HEADER"{\"value\": \"%d\"}", x)


/*struct of http params*/
typedef struct{
	struct mg_serve_http_opts s_http_server_opts;
	const char *s_http_port;
	const char *s_ssl_cert;
	const char *s_ssl_key;
	const char *err;
}RK_HTTP_PARAMS;

#define	DEF_CONF_PATH_NUWICAM			"/mnt/nuwicam/etc/"
#define	DEF_CONF_PATH_NUWICAM_WIFI		DEF_CONF_PATH_NUWICAM"network_config"
#define	DEF_CONF_PATH_NUWICAM_STREAM	DEF_CONF_PATH_NUWICAM"stream_config"
#define	DEF_CONF_PATH_NUWICAM_NABTO		DEF_CONF_PATH_NUWICAM"nabtonat_config"
#define	DEF_CONF_PATH_NUWICAM_APMSG		DEF_CONF_PATH_NUWICAM"apmsg_config"
#define	DEF_CONF_PATH_NUWICAM_STAMSG	DEF_CONF_PATH_NUWICAM"stamsg_config"
#define	DEF_CONF_PATH_NUWICAM_APSTAMSG	DEF_CONF_PATH_NUWICAM"apstamsg_config"
#define DEF_CONF_PATH_NUWICAM_SCANWIFI  DEF_CONF_PATH_NUWICAM"wifiscan_config"
#define DEF_CONF_PATH_NUWICAM_VERSION   DEF_CONF_PATH_NUWICAM"wiscam.version"


extern char *configs_list_all (char *pHeadPtr);
extern char *configs_list(char *groupName, const char *pParamName);
extern int configs_update(const char *uriVal, char *groupName);
extern int wifi_scanning(struct mg_connection *nc);

#endif //__WISCAM_SERVE_H__
