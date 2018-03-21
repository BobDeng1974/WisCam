/*******************************************************************************
 * Copyright (c) 2012, 2016 IBM Corp.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * and Eclipse Distribution License v1.0 which accompany this distribution. 
 *
 * The Eclipse Public License is available at 
 *   http://www.eclipse.org/legal/epl-v10.html
 * and the Eclipse Distribution License is available at 
 *   http://www.eclipse.org/org/documents/edl-v10.php.
 *
 * Contributors:
 *    Ian Craggs - initial contribution
 *    Ian Craggs - change delimiter option from char to string
 *    Al Stockdill-Mander - Version using the embedded C client
 *    Ian Craggs - update MQTTClient function names
 *******************************************************************************/

/*
 
 stdout subscriber publish
 
 compulsory parameters:
 
  topic to subscribe to
 
 defaulted parameters:
 
	--host demo.cloudmatix.com
	--port 1883
	--qos 2
	--delimiter \n
	--clientid wiscam-cx-clientid
	
	--userid none
	--password none

*/
#include <stdio.h>
#include <memory.h>
#include "MQTTClient.h"

#include <signal.h>

#include <sys/time.h>

#include "commen.h"

volatile int toStop = 0;

extern RK_LedInf rk_ledinf;



void cfinish(int sig)
{
	signal(SIGINT, NULL);
	toStop = 1;
}


void messageArrived(MessageData* md)
{
	MQTTMessage* message = md->message;

	printf("%.*s\t", md->topicName->lenstring.len, md->topicName->lenstring.data);
	if((strstr(message->payload, "\"led\":") != NULL) && (strstr(message->payload, "\"on\""))){
		rk_ledinf.l_write(1);
		
	}else if((strstr(message->payload, "\"led\":") != NULL) && (strstr(message->payload, "\"off\""))){
		rk_ledinf.l_write(0);
	}else
		printf("subscribe led status error\n");
	//fflush(stdout);
}

int mqttmsg(RK_SensorInf rk_sensorinf, MqttOpts opts)
{
	int rc = 0;
	MQTTMessage pub_msg;
	unsigned char sndbuf[100];
	unsigned char readbuf[100];
	char pubTopc[64] = "upstate/",
		 subTopc[64] = "downstate/";
	char *pubStr;

	printf("host: %s, port %d, clientid: %s, qos: %d\n",opts.host,opts.port,opts.clientid,opts.qos);

	strcat(pubTopc, opts.clientid);
	strcat(subTopc, opts.clientid);

	Network n;
	MQTTClient c;

	signal(SIGINT, cfinish);
	signal(SIGTERM, cfinish);

	NetworkInit(&n);
	if((rc = NetworkConnect(&n, opts.host, opts.port)) != 0)
		printf("NetworkConnect failed: %d\n", rc);
	MQTTClientInit(&c, &n, 1000, sndbuf, sizeof(sndbuf), readbuf, sizeof(readbuf));
 
	MQTTPacket_connectData data = MQTTPacket_connectData_initializer; 
	data.willFlag = 0;
	data.MQTTVersion = 3;
	data.clientID.cstring = opts.clientid;
//	data.username.cstring = opts.username;
//	data.password.cstring = opts.password;

	data.keepAliveInterval = 60;
	data.cleansession = 1;
	printf("Connecting to %s %d\n", opts.host, opts.port);
	
	rc = MQTTConnect(&c, &data);
	if(rc != 0)
		printf("Connected failed: %d\n", rc);
	else
		printf("Connected: %d\n", rc);

	rc = MQTTSubscribe(&c, subTopc, opts.qos, messageArrived);
	if(rc != 0)
		printf("rc from mqtt subscribe is %d\n", rc);
	
	while(!toStop){
		if(rc != 0){
			if((rc = NetworkConnect(&n, opts.host, opts.port)) != 0)
				rc = MQTTConnect(&c, &data);
		}

		pubStr = rk_sensorinf.s_read();

		pub_msg.qos = QOS0;
		pub_msg.payload = pubStr;
		pub_msg.payloadlen = strlen(pubStr);
		
		rc = MQTTPublish(&c, pubTopc, &pub_msg);
		if((rc = MQTTYield(&c, 5000)) != 0)
			printf("MQTTYield failed: %d\n",rc);

	}

	printf("Stopping\n");

	MQTTDisconnect(&c);
	NetworkDisconnect(&n);

	return 0;
}


