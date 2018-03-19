#include "mongoose.h"
#include <strings.h>
#include "wiscam-server.h"


#define RK_HTTP_DEFAULT_PORT "9999"
//#define RK_HTTP_DEFAULT_SSL_CERT "ssl/server.pem"
//#define RK_HTTP_DEFAULT_SSL_KEY "ssl/server.key"
#define RK_HTTP_DEFAULT_WEB_PATH "/mnt/nuwicam/www/restweb"

RK_HTTP_PARAMS api_http_param;

static int is_equal(const struct mg_str *s1, const struct mg_str *s2) {
  return s1->len == s2->len && memcmp(s1->p, s2->p, s2->len) == 0;
}

/* get uri host */
const char *getUriHost(struct http_message *hm, size_t baseUriLen)
{
	char *p = NULL;
	const char *uriObj;
	
	if((hm->uri.len == (baseUriLen + 1)) || (hm->uri.len == (baseUriLen + 2))){  //uri: wiscam.api/v1/xxx/lists to list all
		return "list_all"; 
	}else if(hm->uri.len > (baseUriLen + 1)){                                    //uri: wiscam.api/v1/xxx/lists/XXX to list XXX
		uriObj = hm->uri.p + baseUriLen + 2;
		if((p = strstr(uriObj, " HTTP/1.1"))){
			*p = '\0';
		}
		return uriObj;                                                           //return XXX
	}else{
		printf("Failed, uri too less\n");
	}

	return NULL;
}

/* GET Method Function */
int rk_get_method(struct http_message *hm, struct mg_connection *nc)
{
	const char *listStr;
	char respData[1024];
	char *listParam = NULL, *listVal = NULL;
	static const struct mg_str api_audio_lists = MG_MK_STR(RK_PLATFORM_API"audio/lists");
	static const struct mg_str api_video_lists = MG_MK_STR(RK_PLATFORM_API"video/lists");
	static const struct mg_str api_wifi_lists = MG_MK_STR(RK_PLATFORM_API"wifi/lists");
	static const struct mg_str api_wifi_scan = MG_MK_STR(RK_PLATFORM_API"wifi/scanning");
	static const struct mg_str api_nabto_lists = MG_MK_STR(RK_PLATFORM_API"nabto/lists");
	static const struct mg_str api_get_version = MG_MK_STR(RK_PLATFORM_API"version");

	memset(respData, 0, sizeof(respData));

	/* list audio params */
	if(mg_strstr(hm->uri, api_audio_lists)){

		mg_printf(nc, "%s", "HTTP/1.1 501 Not Implemented\r\n"RK_HTTP_HEADER);
		return -1;

	/* list video params */
	}else if(mg_strstr(hm->uri, api_video_lists)){

		listParam = configs_list_all("stream");
		listStr = getUriHost(hm, api_video_lists.len);
		
		if(listStr == NULL){
			mg_printf(nc, "%s", "HTTP/1.1 400 Bad Request\r\n"RK_HTTP_HEADER);
		/* list all video params */	
		}else if(!strcmp(listStr, "list_all")){
			sprintf(respData,"{%s}",listParam);
		/* list the specified param */	
		}else{
			listParam = configs_list("stream",listStr);
			sprintf(respData,"{%s}",listParam);
		}

	/* list wifi params */
	}else if(mg_strstr(hm->uri, api_wifi_lists)){

		listStr = getUriHost(hm, api_wifi_lists.len);
		/* list all the ap & sta params */
		if(!strcmp(listStr, "list_all")){
			printf("apsta listStr: %s\n",listStr);
			if((system("/mnt/nuwicam/bin/wifimsg.sh apsta")) != 0)
			{
				mg_printf(nc, "%s", "HTTP/1.1 404 Not Found\r\n"RK_HTTP_HEADER);
				printf("apsta messages failed\n");
				return -1;
			}

			if((listParam = configs_list_all("apstamsg")) != NULL)
			{
				sprintf(respData,"{\"apstamessages\": [{%s}]",listParam);
			}
			system("rm /mnt/nuwicam/etc/apstamsg_config");
		
		/* list ap params */
		}else if((listVal = strstr(listStr, "ap")) != NULL){
			listVal += strlen("ap");
			if((system("/mnt/nuwicam/bin/wifimsg.sh ap")) != 0)
			{
				mg_printf(nc, "%s", "HTTP/1.1 404 Not Found\r\n"RK_HTTP_HEADER);
				printf("ap messages failed\n");
				return -1;
			}
			/* list all ap params */
			if(!strcmp(listVal, "")){
				if((listParam = configs_list_all("apmsg")) != NULL){
					sprintf(respData,"{\"apmessage\": [{%s}]",listParam);
				}
			/* list specified ap param */
			}else{
				listParam = configs_list("apmsg",(listVal+1));
				sprintf(respData,"{%s}",listParam);
			}
			system("rm /mnt/nuwicam/etc/apmsg_config");

		/* list sta params */
		}else if((listVal = strstr(listStr, "sta")) != NULL){
			listVal += strlen("sta");
			if((system("/mnt/nuwicam/bin/wifimsg.sh sta")) != 0)
			{
				mg_printf(nc, "%s", "HTTP/1.1 404 Not Found\r\n"RK_HTTP_HEADER);
				printf("ap messages failed\n");
				return -1;
			}

			/* list all sta params */
			if(!strcmp(listVal, "")){
				if((listParam = configs_list_all("stamsg")) != NULL){
					sprintf(respData,"{\"stamessage\": [{%s}]",listParam);
				}
			/* list specified sta param */
			}else{
				listParam = configs_list("stamsg",(listVal+1));
				sprintf(respData,"{%s}",listParam);
			}
			system("rm /mnt/nuwicam/etc/stamsg_config");

		}else{
			printf("error listStr: %s\n",listStr);
			mg_printf(nc, "%s", "HTTP/1.1 400 Bad Request\r\n"RK_HTTP_HEADER);
			return -1;
		}

	/* scan wifi nearby */
	}else if(mg_strstr(hm->uri, api_wifi_scan)){

		printf("wifi scanning lll\n");
		if((wifi_scanning(nc)) != 0){
			mg_printf(nc, "%s", "HTTP/1.1 500 Internal Server Error\r\n"RK_HTTP_HEADER);
			return -1;
		}else
			return 0;

	/* list nabto params */
	}else if(mg_strstr(hm->uri, api_nabto_lists)){
		
		listParam = configs_list_all("nabto");
		listStr = getUriHost(hm, api_nabto_lists.len);
		
		if(listStr == NULL){
			mg_printf(nc, "%s", "HTTP/1.1 400 Bad Request\r\n"RK_HTTP_HEADER);
			return -1;
		/* list all nabto params */
		}else if(!strcmp(listStr, "list_all")){
			sprintf(respData,"{%s}",listParam);
		
		/* list specified nabto param */
		}else{
			listParam = configs_list("nabto",listStr);
			sprintf(respData,"{%s}",listParam);
		}

	/* get version */
	}else if(mg_strstr(hm->uri, api_get_version)){
		listParam = configs_list_all("version");
		sprintf(respData,"{%s}",listParam);
	}else{
		mg_printf(nc, "%s", "HTTP/1.1 501 Not Implemented\r\n"RK_HTTP_HEADER);
		return -1;
	}

	free(listParam);
//	mg_printf(nc, "%s",RK_DEF_JSON_HEADER);
//	mg_printf(nc, "%s",respData);
  	mg_printf(nc, "%s", "HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n");
  	mg_printf_http_chunk(nc, "%s", respData);
  	mg_send_http_chunk(nc, "", 0); /* Send empty chunk, the end of response */
	return 0;
}

/* PUT Method Function */
int rk_put_method(struct http_message *hm, struct mg_connection *nc)
{
	char *p = NULL;
	char respBuff[256];
	int iRet = 0;

	static const struct mg_str api_wifi_restart = MG_MK_STR(RK_PLATFORM_API"wifi/restart");
	static const struct mg_str api_audio_modify = MG_MK_STR(RK_PLATFORM_API"audio/modify");
	static const struct mg_str api_video_modify = MG_MK_STR(RK_PLATFORM_API"video/modify");
	static const struct mg_str api_wifi_modify = MG_MK_STR(RK_PLATFORM_API"wifi/modify");
	static const struct mg_str api_nabto_modify = MG_MK_STR(RK_PLATFORM_API"nabto/modify");

	memset(respBuff,0,sizeof(respBuff));
	if(hm->query_string.p != NULL){
		if((p = strstr(hm->query_string.p, " HTTP/1.1")))
			*p = '\0';
	}

	/* modify audio params */
	if(mg_strstr(hm->uri, api_audio_modify)){

		mg_printf(nc, "%s", "HTTP/1.1 501 Not Implemented\r\n"RK_HTTP_HEADER);
		return -1;

	/* modify video params */
	}else if(mg_strstr(hm->uri, api_video_modify)){

		iRet = configs_update(hm->query_string.p, "stream");
			
	/* modify wifi params */
	}else if(mg_strstr(hm->uri, api_wifi_modify)){

		iRet = configs_update(hm->query_string.p, "wifi");

	/* modify nabto params */
	}else if(mg_strstr(hm->uri, api_nabto_modify)){

		iRet = configs_update(hm->query_string.p, "nabto");

	/* restart wifi */
	} else if(mg_strstr(hm->uri, api_wifi_restart)){
		system("/mnt/nuwicam/bin/go_networking.sh");
		
	}else{
		mg_printf(nc, "%s", "HTTP/1.1 501 Not Implemented\r\n"RK_HTTP_HEADER);
		return -1;
	}

	/* response Json format 0: success, -1: fail */
//	mg_printf(nc, "%s",RK_DEF_JSON_HEADER);
 // 	mg_printf(nc, "{ \"value\": %d }", iRet);
  	mg_printf(nc, "%s", "HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n");
  	mg_printf_http_chunk(nc, "{ \"value\": %d }", iRet);
  	mg_send_http_chunk(nc, "", 0); /* Send empty chunk, the end of response */
	
	return 0;
}

/* POST Method Function */
int rk_post_method(struct http_message *hm, struct mg_connection *nc)
{
	printf("http_method: %s\n", hm->method.p);
	mg_printf(nc, "%s", "HTTP/1.1 501 Not Implemented\r\n"RK_HTTP_HEADER);
	return 0;
}

/* DELETE Method Function */
int rk_delete_method(struct http_message *hm, struct mg_connection *nc)
{
	printf("http_method: %s\n", hm->method.p);
	mg_printf(nc, "%s", "HTTP/1.1 501 Not Implemented\r\n"RK_HTTP_HEADER);
	return 0;
}

static void ev_handler(struct mg_connection *nc, int ev, void *ev_data)
{
//	struct mg_str *hd_serv, *hd_cacheCtrl, *hd_contType;
	static const struct mg_str s_get_method = MG_MK_STR("GET");
	static const struct mg_str s_put_method = MG_MK_STR("PUT");
	static const struct mg_str s_post_method = MG_MK_STR("POST");
	static const struct mg_str s_delele_method = MG_MK_STR("DELETE");

	static const struct mg_str api_prefix = MG_MK_STR(RK_PLATFORM_API);
	struct http_message *hm = (struct http_message *)ev_data;

	switch(ev){

	case MG_EV_HTTP_REQUEST:
		
		/* get http header */
/*		printf("Request: %s\n",hm->message.p);
		if(((hd_serv = mg_get_http_header(hm,"Server")) == NULL)){
			printf("Header Server error\n");
			break;
		}
		if((hd_cacheCtrl = mg_get_http_header(hm,"Cache-Control")) == NULL){
			printf("Header Cache-Control error\n");
			break;
		}
		if((hd_contType = mg_get_http_header(hm,"Content-Type")) == NULL)
		{
			printf("Header Content-Type error\n");
			break;
		}

		printf("%s,%s,%s\n",hd_serv->p, hd_cacheCtrl->p, hd_contType->p);
		if((strstr(hd_serv->p, RK_PLATFORM_API) != NULL) && (strstr(hd_cacheCtrl->p, "no-store, no-cache") != NULL) && (strstr(hd_contType->p, "application/json") != NULL))
		{
			printf("header ok\n");
		}else{
			printf("header error\n");
			break;
		}
*/
		/* query url wiscam.api/v1 */
		if(mg_strncmp(hm->uri, api_prefix,api_prefix.len)){

			/* get method: GET */
			if(is_equal(&hm->method, &s_get_method)){ 

				rk_get_method(hm,nc);

			/* get method: PUT */
			}else if(is_equal(&hm->method, &s_put_method)){

				rk_put_method(hm,nc);

			/* get method: POST */
			}else if(is_equal(&hm->method, &s_post_method)){

				rk_post_method(hm,nc);

			/* get method: DELETE */
			}else if(is_equal(&hm->method, &s_delele_method)){

				rk_delete_method(hm,nc);

			/* no such a method */
			}else{
				mg_printf(nc, "%s", "HTTP/1.1 405 Method Not Allowed\r\n"RK_HTTP_HEADER);
			}
		}else{
			/* Serve static content */
			mg_serve_http(nc, hm, api_http_param.s_http_server_opts);
		}
		break;

	default:
		break;

	}
}

int main(int argc, const char *argv[])
{
	struct mg_mgr mgr;
	struct mg_connection *nc;
	struct mg_bind_opts bind_opts;
	int i;
	
	api_http_param.s_http_port = RK_HTTP_DEFAULT_PORT;
//	api_http_param.s_ssl_cert = RK_HTTP_DEFAULT_SSL_CERT;
//	api_http_param.s_ssl_key = RK_HTTP_DEFAULT_SSL_KEY;
	api_http_param.s_http_server_opts.document_root = RK_HTTP_DEFAULT_WEB_PATH;
	
	mg_mgr_init(&mgr,NULL);

	if(argc > 0){
		for(i = 1; i < argc; i++){
			if (strcmp(argv[i], "-w") == 0 && i + 1 < argc) {
				api_http_param.s_http_server_opts.document_root = argv[++i];
			} else if (strcmp(argv[i], "-p") == 0 && i + 1 < argc) {
				api_http_param.s_http_port = argv[++i];
//			} else if (strcmp(argv[i], "-s") == 0 && i + 1 < argc) {
//				api_http_param.s_ssl_cert = argv[++i];
			} else {
				fprintf(stderr, "Unknown option: [%s]\n", argv[i]);
				return -1;
			}
		}
	}

	/*open listening socket*/
	memset(&bind_opts,0,sizeof(bind_opts));
//	bind_opts.ssl_cert = api_http_param.s_ssl_cert;
//	bind_opts.ssl_key = api_http_param.s_ssl_key;
	bind_opts.error_string = &api_http_param.err;

	if((nc = mg_bind_opt(&mgr, api_http_param.s_http_port,ev_handler,bind_opts)) == NULL)
	{
		printf("Failed to listening\n");
		return -1;
	}
	mg_set_protocol_http_websocket(nc);
	api_http_param.s_http_server_opts.enable_directory_listing = "yes";
	printf("Start Server On Port: %s, web_root: %s\n",api_http_param.s_http_port,api_http_param.s_http_server_opts.document_root);
	
	for(;;){
		mg_mgr_poll(&mgr,1000);
	}
	mg_mgr_free(&mgr);

	return 0;
}
