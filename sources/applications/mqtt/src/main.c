#include <stdio.h>
#include <stdlib.h>
#include "commen.h"

extern RK_SensorInf rk_sensorinf;
//MqttOpts opts = {(char *)"wiscam-cx-clientid", 0, (char*)"\n", QOS2, NULL, NULL, (char*)"demo.cloudmatix.com", 1883};
MqttOpts opts = {1888,QOS2, "wiscam-cx-clientid", "d.cloudmatix.com"};

/*
void usage()
{
	printf("MQTT stdout subscriber\n");
	printf("Usage: stdoutsub clientid <uuid>, where options are:\n");
	printf("  --host <hostname> (default is localhost)\n");
	printf("  --port <port> (default is 1883)\n");
	printf("  --qos <qos> (default is 2)\n");
	printf("  --delimiter <delim> (default is \\n)\n");
	printf("  --clientid <clientid> (default is hostname+timestamp)\n");
	printf("  --username none\n");
	printf("  --password none\n");
	printf("  --showtopics <on or off> (default is on if the topic has a wildcard, else off)\n");
	exit(-1);
}

void getopts(int argc, char** argv)
{
	int count = 2;
	
	while (count < argc)
	{
		if (strcmp(argv[count], "--qos") == 0)
		{
			if (++count < argc)
			{
				if (strcmp(argv[count], "0") == 0)
					opts.qos = QOS0;
				else if (strcmp(argv[count], "1") == 0)
					opts.qos = QOS1;
				else if (strcmp(argv[count], "2") == 0)
					opts.qos = QOS2;
				else
					usage();
			}
			else
				usage();
		}
		else if (strcmp(argv[count], "--host") == 0)
		{
			if (++count < argc)
				opts.host = argv[count];
			else
				usage();
		}
		else if (strcmp(argv[count], "--port") == 0)
		{
			if (++count < argc)
				opts.port = atoi(argv[count]);
			else
				usage();
		}else if (strcmp(argv[count], "--username") == 0)
		{
			if (++count < argc)
				opts.username = argv[count];
			else
				usage();
		}
		else if (strcmp(argv[count], "--password") == 0)
		{
			if (++count < argc)
				opts.password = argv[count];
			else
				usage();
		}
		else if (strcmp(argv[count], "--delimiter") == 0)
		{
			if (++count < argc)
				opts.delimiter = argv[count];
			else
				opts.nodelimiter = 1;
		}
		else if (strcmp(argv[count], "--showtopics") == 0)
		{
			if (++count < argc)
			{
				if (strcmp(argv[count], "on") == 0)
					opts.showtopics = 1;
				else if (strcmp(argv[count], "off") == 0)
					opts.showtopics = 0;
				else
					usage();
			}
			else
				usage();
		}
		count++;
	}
	
}
*/
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

		if (chGet == '\n'){
			break;
		}

		if (iReadBytes == iBufByteSize)
			break;
	}

	if (iReadBytes == 0 && chGet == EOF)
		return -1;

	pBuf[iReadBytes] = 0;

	return iReadBytes;
}	// ReadLine

int getParams(void)
{
	int iReadBytes = 0;
	char pReadBuf[64];
	char *pTmpPtr = NULL;
	int slen = 0;
	FILE	*nfConfig = fopen(NABTO_CONF, "r");
	if(nfConfig == NULL)
	{
		printf("open nabto config failed\n");
		return -1;
	}
	FILE	*mfConfig = fopen(MQTT_CONF, "r");
	if(mfConfig == NULL)
	{
		printf("open mqtt config failed\n");
		return -1;
	}

	while((iReadBytes = ReadLine(pReadBuf, sizeof(pReadBuf), nfConfig)) > 1)
	{
		slen = strlen(pReadBuf);
		pReadBuf[slen-1] = '\0';
		if((pTmpPtr = strstr(pReadBuf, "nabto_uuid ")) == pReadBuf){
			memset(opts.clientid,0,32);
			pTmpPtr += strlen("nabto_uuid ");
			strcpy(opts.clientid, pTmpPtr);
		}
	}
	fclose(nfConfig);

	while((iReadBytes = ReadLine(pReadBuf, sizeof(pReadBuf), mfConfig)) > 0)
	{
		slen = strlen(pReadBuf);
		pReadBuf[slen-1] = '\0';
		if((pTmpPtr = strstr(pReadBuf, "mqtt_host ")) == pReadBuf){
			memset(opts.host,0,128);
			pTmpPtr += strlen("mqtt_host ");
			strcpy(opts.host, pTmpPtr);
		}else if((pTmpPtr = strstr(pReadBuf, "mqtt_port ")) == pReadBuf){
			pTmpPtr += strlen("mqtt_port ");
			opts.port = atoi(pTmpPtr);
		}
	}

	fclose(mfConfig);

	return 0;
}

int main(int argc, char **argv)
{

	if(getParams() != 0){
		return -1;
	}
//	if (argc > 1)
//		getopts(argc,argv);
	/* Init Sensor */
	rk_sensorinf.s_init();

	mqttmsg(rk_sensorinf, opts);
	
	return 0;
}
