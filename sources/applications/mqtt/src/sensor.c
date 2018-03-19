#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "commen.h"

typedef struct SensorData{
	int sd_temprature;
	int sd_humidity;
	int sd_light;
	char *sd_pled;
}RK_SensorData;

extern RK_LedInf rk_ledinf;

/* Init dev such as I2C or others */
int RK_SensorInitInf(void)
{
	return 0;
}

/* Open dev */
int RK_SensorOpenInf(void)
{
	return 0;
}

/* Close dev */
int RK_SensorCloseInf(void)
{
	return 0;
}

/* Read data from data, here to simulate some data */
char *RK_SensorReadInf(void)
{

	static char ssDataBuf[128];
	RK_SensorData *sensordata = (RK_SensorData *)malloc(sizeof(RK_SensorData));

	sensordata->sd_temprature = rand()%35;
	sensordata->sd_light = rand()%100;

	if(rk_ledinf.l_read() == 1)
		sensordata->sd_pled = "on";
	else if(rk_ledinf.l_read() == 0)
		sensordata->sd_pled = "off";
	else{
		sensordata->sd_pled = "nled";
		printf("led status error\n");
	}

	sprintf(ssDataBuf,"{\"temperature\":%d,\"light\":%d,\"led\":\"%s\"}", sensordata->sd_temprature, sensordata->sd_light, sensordata->sd_pled);

	free(sensordata);
	return ssDataBuf;
}

/* Write data to dev */
int RK_SensorWriteInf(void)
{
	return 0;
}

RK_SensorInf rk_sensorinf = {
	.s_init 	= RK_SensorInitInf,
	.s_open 	= RK_SensorOpenInf,
	.s_close 	= RK_SensorCloseInf,
	.s_read 	= RK_SensorReadInf,
	.s_write 	= RK_SensorWriteInf,
};
