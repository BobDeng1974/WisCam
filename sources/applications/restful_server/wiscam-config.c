/*
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <errno.h>
#include <stdint.h>
*/
#include <string.h>
#include "wiscam-server.h"
#include "wiscam-config.h"
#include "mongoose.h"

/*convert a hexadecimal ASCII character to integer*/
int hex_char_to_int(char in)
{
    if(in >= '0' && in <= '9')
        return in - '0';

    if(in >= 'a' && in <= 'f')
        return (in - 'a') + 10;

    if(in >= 'A' && in <= 'F')
        return (in - 'A') + 10;

    return -1;
}
/* replace %XX with the character code it represents */
int unescape(char *string)
{
    char *source = string, *destination = string;
    int src, dst, length = strlen(string), rc;

    /* iterate over the string */
    for(dst = 0, src = 0; src < length; src++) {

        /* is it an escape character? */
        if(source[src] != '%') {
            /* no, so just go to the next character */
            destination[dst] = source[src];
            dst++;
            continue;
        }

        /* yes, it is an escaped character */

        /* check if there are enough characters */
        if(src + 2 > length) {
            return -1;
            break;
        }

        /* perform replacement of %## with the corresponding character */
        if((rc = hex_char_to_int(source[src+1])) == -1) return -1;
        destination[dst] = rc * 16;
        if((rc = hex_char_to_int(source[src+2])) == -1) return -1;
        destination[dst] += rc;

        /* advance pointers, here is the reason why the resulting string is shorter */
        dst++; src += 2;
    }

    /* ensure the string is properly finished with a null-character */
    destination[dst] = '\0';

    return 0;
}

int 	// > 0: string data, 0: only newline, < 0: EOF
ReadLine(
	char	*pBuf,
	int		iBufByteSize,
	FILE	*stream
)
{
	int     chGet,
			iReadBytes = 0;

	while ((chGet = fgetc(stream)) != EOF) {
		if (chGet == '\r')
			chGet = '\n';

		pBuf[iReadBytes++] = chGet;

		if (chGet == '\n')
			break;

		if (iReadBytes == iBufByteSize)
			break;
	}

	if (iReadBytes == 0 && chGet == EOF)
		return -1;

	pBuf[iReadBytes] = 0;

	return iReadBytes;
}	// ReadLine

int
ReadParamStr(
	E_CONFIG_GROUP	eConfigGroup,
	char			*strParamName,
	char			*strParamValue,
	int				iParamByteSize		// Byte size of strParamValue
)
{
	char	*strConfigFilePath	= s_astrConfigFile[eConfigGroup];
	FILE	*fConfig = fopen(strConfigFilePath, "r");

	char	*pTmpPtr	= NULL,
				pReadBuf[256];

	int		iReadBytes;

	if (strParamName == NULL || strParamValue == NULL || iParamByteSize == 0)
		return -1;


	if (strConfigFilePath == NULL)
		return -2;


	if (fConfig == NULL)
		return -3;

	memset(strParamValue, 0, iParamByteSize);

	while ((iReadBytes = ReadLine(pReadBuf, sizeof(pReadBuf), fConfig)) > 0) {
		if ((pTmpPtr = strstr(pReadBuf, strParamName)) == pReadBuf) {
			pTmpPtr += strlen(strParamName);

			if (strstr(strParamName, "SSID") != NULL)
				sscanf(pTmpPtr, " \"%[^\"]s", strParamValue);
			else
				sscanf(pTmpPtr, " %s", strParamValue);
			break;
		}
	}

	fclose(fConfig);
	
	return 0;
}	// ReadParamStr

int
WriteParamStr(
	E_CONFIG_GROUP	eConfigGroup,
	char			*strParamName,
	char			*strParamValue
)
{
	int		iRet = 0;
	char	*strConfigFilePath;
	char    strNewConfigFilePath[128];

	if (strParamName == NULL || strParamValue == NULL)
		return -1;

	strConfigFilePath = s_astrConfigFile[eConfigGroup];
	sprintf(strNewConfigFilePath, "%s.new",  strConfigFilePath );

	{
		FILE	*fConfig		= fopen(strConfigFilePath, "r"),
					   *fNewConfig		= fopen(strNewConfigFilePath, "w+");
		char	pReadBuf[256];
		int		iReadBytes;

		if (fConfig == NULL || fNewConfig == NULL) {
			return -1;
		}
		while ((iReadBytes = ReadLine(pReadBuf, sizeof(pReadBuf), fConfig)) > 0) {
			if (strstr(pReadBuf, strParamName) == pReadBuf) {
				if (strstr(strParamName, "SSID") != NULL)
					fprintf(fNewConfig, "%s \"%s\"\n", strParamName, strParamValue);
				else
					fprintf(fNewConfig, "%s %s\n", strParamName, strParamValue);
			}
			else
				fprintf(fNewConfig, "%s", pReadBuf);
		}
		fclose(fConfig);
		fclose(fNewConfig);
		remove(strConfigFilePath);
		rename(strNewConfigFilePath, strConfigFilePath);
		sync();
	}

	return iRet;
}	// WriteParamStr

E_CONFIG_GROUP configs_search_groupname (char* pHeadPtr)
{
	int i;
	for ( i=0 ;i <eCONFIG_GROUP_CNT ;i++ ) 
		if (!strcmp(pHeadPtr, g_astrGroupName[i])){
			return i;			

		}
	return eCONFIG_GROUP_UNKNOWN;
	
}

/* list all options */
char *configs_list_all (char *groupName)
{
	char	*pTmp = NULL;
	int		iGrpIdx;

	int 	iIdx = 0;
	char 	strParamValue[128];
	char 	pBuf[128];
//	char 	szOuputData[1024];
	char 	*pRet = (char *)malloc(1024);
	E_CONFIG_GROUP eConfigGroupId = eCONFIG_GROUP_UNKNOWN;
	memset(pRet, 0, 1024);

	if((eConfigGroupId = configs_search_groupname(groupName)) == eCONFIG_GROUP_UNKNOWN)
	{
		free(pRet);
		printf("No Such Group Id\n");
		return NULL;
	}

	while ( (g_astrParamGroup[eConfigGroupId][iIdx]) != NULL ) {

		memset(strParamValue, 0, sizeof(strParamValue));
		ReadParamStr(eConfigGroupId, g_astrParamGroup[eConfigGroupId][iIdx], strParamValue, sizeof(strParamValue));

		if ((pTmp = strrchr(g_astrParamGroup[eConfigGroupId][iIdx], '.')) == NULL) {
			pTmp = g_astrParamGroup[eConfigGroupId][iIdx];
			sprintf(pBuf, "\"%s\": \"%s\"", pTmp, strParamValue);
		}
		else {
			sscanf(g_astrParamGroup[eConfigGroupId][iIdx], "%*[^\[][%d]%*s", &iGrpIdx);
			pTmp = pTmp + 1;
			sprintf(pBuf, "\"%s_%d\": \"%s\"", pTmp, iGrpIdx, strParamValue);
		}
		strcat(pRet, pBuf);
		if((strstr(pBuf,"ap_gateway") != NULL) && (!strcmp(groupName,"apstamsg")))
			strcat(pRet, "}");
		iIdx++;

		if (g_astrParamGroup[eConfigGroupId][iIdx] != NULL){
			strcat(pRet, ", " );
			if((strstr(pBuf,"ap_gateway") != NULL) && (!strcmp(groupName, "apstamsg")))
				strcat(pRet, "{" );
		}
	}
	
	if ( pRet[0] == '\0' )
		return NULL;
	
	return pRet;
}

/* list one option */
char *configs_list(char *groupName, const char *uriVal)
{
	int is_match = 0;
	int iIdx = 0;
	int	iGrpIdx = 0;
	char *pTmp;
	char strParamValue[128];
//	char pBuf[128];
	char *pParamName = (char *)uriVal;
	char *pRet = (char *)malloc(128);
	E_CONFIG_GROUP eConfigGroupId = eCONFIG_GROUP_UNKNOWN;

	memset(strParamValue, 0, sizeof(strParamValue));
	memset(pRet, 0, 128);
	if(!strcmp(groupName, "stream")){

		if(!strcmp(pParamName, "bitrate")){
			strcpy(pParamName, "BITRATE");
		}else if(!strcmp(pParamName, "vin_width")){
			strcpy(pParamName, "VINWIDTH");
		}else if(!strcmp(pParamName, "vin_height")){
			strcpy(pParamName, "VINHEIGHT");
		}else if(!strcmp(pParamName, "jpegenc_width")){
			strcpy(pParamName, "JPEGENCWIDTH");
		}else if(!strcmp(pParamName, "jpegenc_height")){
			strcpy(pParamName, "JPEGENCHEIGHT");
		}else{
			printf("uri video value name error\n");
			return NULL;
		}
	}
	if((eConfigGroupId = configs_search_groupname(groupName)) == eCONFIG_GROUP_UNKNOWN)
	{
		free(pRet);
		printf("No Such Group Id\n");
		return NULL;
	}
	while ( (g_astrParamGroup[eConfigGroupId][iIdx]) != NULL ) {
		if(!strcmp((g_astrParamGroup[eConfigGroupId][iIdx]), pParamName)){
			is_match = 1;
			ReadParamStr(eConfigGroupId, g_astrParamGroup[eConfigGroupId][iIdx], strParamValue, sizeof(strParamValue));
			if ((pTmp = strrchr(g_astrParamGroup[eConfigGroupId][iIdx], '.')) == NULL) {
				pTmp = g_astrParamGroup[eConfigGroupId][iIdx];
				sprintf(pRet, "\"%s\": \"%s\"", pTmp, strParamValue);
			}
			else {
				sscanf(g_astrParamGroup[eConfigGroupId][iIdx], "%*[^\[][%d]%*s", &iGrpIdx);
				pTmp = pTmp + 1;
				sprintf(pRet, "\"%s_%d\": \"%s\"", pTmp, iGrpIdx, strParamValue);
			}
		}
		iIdx ++;
	}
	if(!is_match){
		free(pRet);
		return "no match";
	}

	return pRet;
}

/* change config files */
int configs_update (const char *uriVal, char *groupName)
{
	int iRet = -1;
	char *pSavePtr = NULL;
	char *pParamName, *pParamValue;
	char paramVal[128];
	E_CONFIG_GROUP	eGroupID = eCONFIG_GROUP_UNKNOWN ;

	if ((eGroupID=configs_search_groupname(groupName)) != eCONFIG_GROUP_UNKNOWN)
	{
		char *pToken = strtok_r((char *)uriVal, "&", &pSavePtr);
		iRet=0;
		while (pToken != NULL) {
			pParamName = strtok(pToken, "=");
			pParamValue = pParamName + strlen(pParamName) + 1;
			strcpy(paramVal, pParamValue);
			if(unescape(paramVal) == -1){
				printf("url unescape failed\n");
				return -1;
			}

			if(!strcmp(groupName, "wifi")){

				if(!strcmp(pParamName, "ap_ssid")){
					strcpy(pParamName, "AP_SSID");
				}else if(!strcmp(pParamName, "ap_key")){ // Auto Encryption
					strcpy(pParamName, "AP_AUTH_KEY");
					printf("ap_key-val: %s",paramVal);
					if(paramVal != NULL)
					{
						if ( WriteParamStr(eGroupID, "AP_AUTH_MODE", "WPA2PSK") != 0 )
						{
							iRet=-1;
							break;
						}
						if ( WriteParamStr(eGroupID, "AP_ENCRYPT_TYPE", "AES") != 0 )
						{
							iRet=-1;
							break;
						}

					}else{
						printf("AP Key error\n");
						return -1;
					}
					
				}else if(!strcmp(pParamName, "ap_ipaddr")){
					strcpy(pParamName, "AP_IPADDR");
				}else if(!strcmp(pParamName, "ap_channel")){
					strcpy(pParamName, "AP_CHANNEL");
				}else if(!strcmp(pParamName, "sta_ssid")){
					strcpy(pParamName, "SSID");
				}else if(!strcmp(pParamName, "sta_key")){
					strcpy(pParamName, "AUTH_KEY");
				}else{
					printf("uri wifi value name error\n");
					return -1;
				}

			}else if(!strcmp(groupName, "stream")){

				if(!strcmp(pParamName, "bitrate")){
					strcpy(pParamName, "BITRATE");
				}else if(!strcmp(pParamName, "vin_width")){
					strcpy(pParamName, "VINWIDTH");
				}else if(!strcmp(pParamName, "vin_height")){
					strcpy(pParamName, "VINHEIGHT");
				}else if(!strcmp(pParamName, "jpegenc_width")){
					strcpy(pParamName, "JPEGENCWIDTH");
				}else if(!strcmp(pParamName, "jpegenc_height")){
					strcpy(pParamName, "JPEGENCHEIGHT");
				}else{
					printf("uri video value name error\n");
					return -1;
				}
			}

			if ( WriteParamStr(eGroupID, pParamName, paramVal) != 0 )
			{
				iRet=-1;
				break;
			}
			pToken = strtok_r(NULL, "&", &pSavePtr);
		}
	}
	return iRet;
}

/* scan wifi messages nearby */
int wifi_scanning(struct mg_connection *nc)
{
	char *pTmpPtr, *p;
	int flag = 0;
	char pReadBuf[512], strWifiMessage[512];
	char strType[4][100] = {"",};
	int iReadBytes,i = 0;
	for(i=0;i<4;i++)
		bzero(strType[i], sizeof(strType[i]));
	memset(pReadBuf,0,sizeof(pReadBuf));
	memset(strWifiMessage,0,sizeof(strWifiMessage));
	/* scan wifi message to a file */
	if(!system("/mnt/nuwicam/wifi/iwlist wlan0 scanning > /mnt/nuwicam/etc/wifiscan_config;sleep 1")){
		FILE *fConfig = fopen(DEF_CONF_PATH_NUWICAM_SCANWIFI, "r");
		if(fConfig == NULL)
		{
			printf("Open file %s failed\n",DEF_CONF_PATH_NUWICAM_SCANWIFI);
			return -1;
		}
		mg_printf(nc, "%s",RK_DEF_JSON_HEADER"{\"wifimessage\": [");
  		//mg_printf(nc, "%s", "HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n{\"wifimessage\": [");
		while((iReadBytes = ReadLine(pReadBuf, sizeof(pReadBuf), fConfig)) > 0)	
		{

			int len = strlen(pReadBuf);
			pReadBuf[len - 1] = '\0';
			if((pTmpPtr = strstr(pReadBuf," - Address: ")) != NULL)
			{
				if(flag){
					mg_printf(nc, "%s", ",");
					flag = 0;
				}
				pTmpPtr += strlen(" - Address: ");
				strcpy(strType[0],pTmpPtr);

			}else if((pTmpPtr = strstr(pReadBuf,"    ESSID:"))){

				pTmpPtr += strlen("    ESSID:");
				strcpy(strType[1],pTmpPtr);

			}else if((pTmpPtr = strstr(pReadBuf," (Channel "))){

				pTmpPtr += strlen(" (Channel ");
				strcpy(strType[2],pTmpPtr);
				if((p = strstr(strType[2],")")))
					*p = '\0';

			}else if((pTmpPtr = strstr(pReadBuf, "    Extra:fm="))){
				sprintf(strWifiMessage,
						"{\"ssid\":%s,\"bssid\":\"%s\",\"channel\":\"%s\"}", 
						strType[1], strType[0], strType[2]);
				mg_printf(nc, "%s", strWifiMessage);
//  				mg_printf_http_chunk(nc, "%s", strWifiMessage);
				flag = 1;

			}
		}
		mg_printf(nc, "%s", "]}");
  		//mg_send_http_chunk(nc, "", 0); /* Send empty chunk, the end of response */

		fclose(fConfig);
	}else{
		printf("create wifiscan FILE failed!!!\n");
		return -1;
	}

	system("rm /mnt/nuwicam/etc/wifiscan_config");

	return 0;
}
