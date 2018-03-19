#include <stdio.h>
#include "commen.h"
#define LED_FILE "/sys/class/leds/LINK/trigger"

/* read led status 1: on, 0: off */
int RK_LedRead(void)
{
	int status = 0;
	char buff[64];
	FILE *fp = fopen(LED_FILE, "r");
	if(fp == NULL){
		printf("open %s failed\n",LED_FILE);
		return -1;
	}

	fread(buff, sizeof(char), sizeof(buff), fp);
	if(strstr(buff, "[default-on]") != NULL)
		status = 1;
	else if(strstr(buff, "[none]") != NULL)
		status = 0;
	else
		status = -1;

	fclose(fp);
	return status;

}

/* control led status 1: on, 0: off */
int RK_LedWrite(int status)
{
	FILE *fp = fopen(LED_FILE, "r+");
	if(fp == NULL){
		printf("open %s failed\n",LED_FILE);
		return -1;
	}
	
	if(status){
		fwrite("default-on",10,1,fp);
	}else{
		fwrite("none",4,1,fp);
	}

	fclose(fp);
	return 0;
}

RK_LedInf rk_ledinf = {
	.l_read 	= RK_LedRead,
	.l_write 	= RK_LedWrite,
};
