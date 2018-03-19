#ifndef __commen_H__
#define __commen_H__

#include "MQTTClient.h"
#define NABTO_CONF  "/mnt/nuwicam/etc/nabtonat_config"
#define MQTT_CONF  "/mnt/nuwicam/etc/mqtt_config"

typedef struct SensorInf{
	int (*s_init)(void);
	int (*s_open)(void);
	int (*s_close)(void);
	char *(*s_read)(void);
	int (*s_write)(void);
}RK_SensorInf;

typedef struct LedInf{
	int (*l_read)(void);
	int (*l_write)(int status);
}RK_LedInf;

typedef struct OPTS_STRUCT
{
	int port;
	enum QoS qos;
	char clientid[32];
	char host[128];
}MqttOpts;

/*opts =
{
	(char *)"wiscam-cx-clientid", 0, (char*)"\n", QOS2, NULL, NULL, (char*)"demo.cloudmatix.com", 1883, 0
};
*/
#endif
