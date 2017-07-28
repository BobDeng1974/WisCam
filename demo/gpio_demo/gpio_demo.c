/*
 * GPIO Driver Test/Example Program
 *
 * Compile with:
 *  gcc -s -Wall -Wstrict-prototypes gpio.c -o gpiotest
 *
 *
 * Note :
 *   PORT NAME[PIN] = GPIO [id]	
 *
 *   PORTA[ 0]      = gpio[ 0x00]
 *   PORTA[ 1]      = gpio[ 0x01]	  
 *                  :
 *   PORTA[31]      = gpio[ 0x1F]
 *   PORTB[ 0]      = gpio[ 0x20]
 *                  :
 *   PORTB[31]      = gpio[ 0x3F]
 *                  :
 *                  :
 *                  :
 *   PORTE[ 0]      = gpio[ 0x80]
 *                  :
 *                  :
 *   PORTE[31]      = gpio[ 0x9F]
 */

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <poll.h>
//
// dir = 'i' for input
// dir = 'o' for output
//
int config_port(int port , const char dir)
{
	FILE *fp;
	char port_str[80];
//	char buffer[10];
	// equivalent shell command "echo 32 > export" to export the port 
	if ((fp = fopen("/sys/class/gpio/export", "w")) == NULL) {
		printf("Cannot open export file.\n");
		return(-1);
	}
	fprintf(fp, "%d", port); 
	fclose(fp);

	// equivalent shell command "echo out > direction" to set the port as an input  
	sprintf(port_str , "/sys/class/gpio/gpio%d/direction" , port);
	printf("%s\n" , port_str);
	if ((fp = fopen(port_str, "rb+")) == NULL) {
		printf("Cannot open direction file\n [%s]\n" , port_str);
		return(-1);
	}
	if (dir == 'i')
		fprintf(fp, "in");
	if (dir == 'o')
		fprintf(fp, "out");
	fclose(fp);
	return (0);
}
/*
int out_port(int port, int value)
{
	FILE *fp;
	char port_str[80];

	sprintf(port_str , "/sys/class/gpio/gpio%d/value" , port);
	if ((fp = fopen(port_str, "rb+")) == NULL) {
		printf("Cannot open value file\n [%s]\n", port_str);
		return(-1);
	}
	if(value)
		fwrite("1", 1, 1, fp);
	else
		fwrite("0", 1, 1, fp);
//	fwrite(buffer, sizeof(char), sizeof(buffer) - 1, fp);			
	printf("\nout: %d\n", value);
	fclose(fp);
	return (0);
}

int in_port(int port)
{
	FILE *fp;
	char port_str[80];
	char buffer[10];
	int value;

	// equivalent shell command "cat value"    		
	sprintf(port_str , "/sys/class/gpio/gpio%d/value" , port);
	if ((fp = fopen(port_str, "rb+")) == NULL) {
		printf("Cannot open value file for input\n[%s]\n",port_str);
		return(-1);
	}
	fread(buffer, sizeof(char), sizeof(buffer) - 1, fp);
	value = atoi(buffer);
	printf(">>> in: [%d]", value);
	fclose(fp);
	return value;
}

/////////////////////////////////////////////////////////////////////
int gpio_set(int port, int value)
{
	out_port(port , value);
	return 0;
}
int gpio_get(int port)
{
	return in_port(port);
}
*/

// 0-->none, 1-->rising, 2-->falling, 3-->both

static int gpio_edge(int port, int edge)

{

	const char dir_str[] = "none\0rising\0falling\0both"; 

	int ptr;

	char path[64];  

	int fd; 

	switch(edge){

	case 0:

		ptr = 0;

		break;

	case 1:

		ptr = 5;

		break;

	case 2:

		ptr = 12;

		break;

	case 3:

		ptr = 20;

		break;

	default:

		ptr = 0;

	} 



	snprintf(path, sizeof(path), "/sys/class/gpio/gpio%d/edge", port);  

	fd = open(path, O_WRONLY);  

	if (fd < 0) {  

		printf("Failed to open gpio edge for writing!\n");  

		return -1;  

	}  



	if (write(fd, &dir_str[ptr], strlen(&dir_str[ptr])) < 0) {  

		printf("Failed to set edge!\n");  

		return -1;  

	}  



	close(fd);  

	return 0;  

}


int main(void)
{
	int port = 5; //Start from PortA5
	char buff[10];
	char path[128];
	int gpio_fd,ret;
	printf("\n**** GPIO Test Program ****\n");

	config_port(port,'i'); //set gpia5 “input mode”
	gpio_edge(port,3); //set edge trigger “both”
	snprintf(path,sizeof(path),"/sys/class/gpio/gpio%d/value",port);
	if((gpio_fd = open(path,O_RDONLY))<0)//open value 1:high level 0:low level
	{
		printf("open value fail\n");
		return -1;
	}

	/*read value 1:high level 0:low level 
	* if you want to set level,write to value 0 or 1
	*/

	if((ret = read(gpio_fd,buff,sizeof(buff)))<0)
	{
		printf("read value fail\n");
	}
	
	
	int i;
	int new_value=atoi(buff);
	int old_value=atoi(buff);
	while(1)
	{
		for(i=0;i<5;i++){
			memset(buff,0,sizeof(buff));
			if((ret = lseek(gpio_fd,0,SEEK_SET))<0)
			{
				printf("lseek fail\n");
			}

			if((ret = read(gpio_fd,buff,sizeof(buff)))<0)		
				printf("read fail\n");

			new_value = atoi(buff);
			if(new_value != old_value)
			{
				sleep(1);
				printf("button:%d\n",new_value);

				if(i==4)
				{
					printf("time to recover\n");		
					system("/mnt/nuwicam/bin/recover.sh");
				}
			}
			if(new_value == old_value)
				break;
		}
		usleep(500000);	
	}
	close(gpio_fd);

	return 0;
}
