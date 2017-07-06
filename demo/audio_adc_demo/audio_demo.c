 /*
 * Audio playback demo application
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 */
 
#include <stdio.h>
#include <sys/types.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/soundcard.h>
#include <sys/poll.h>
#include <pthread.h>
#include <math.h>
#include <signal.h>
#include <sys/time.h>
#include <time.h>
#include <pthread.h>
#include <errno.h>
#include <sys/ioctl.h>

char *pcmfiles[] = {
		"./8k.pcm",
		"./11.025k.pcm"
};

const int samplerate[] = {
		8000,
		11025
};

int p_dsp, p_mixer;

int close_audio_play_device()
{
 
  close(p_dsp);
  close(p_mixer);
	
  return 0;	
}

int open_audio_play_device()
{
	printf("*****\n");
	p_dsp = open("/dev/dsp", O_RDWR);
	if( p_dsp < 0 ){
		printf("Open dsp error\n");
		return -1;
	}
	printf("====\n");	
	p_mixer = open("/dev/mixer", O_RDWR);
	if( p_mixer < 0 ){
		printf("Open mixer error\n");
		return -1;
	}

	return 0;
}

int play_pcm(char *file, int samplerate)
{
	int data, oss_format, channels, sample_rate;	
	char *buffer;
	
	//printf("<=== %s ===>\n", file);
	open_audio_play_device();
	
	FILE *fd;
	fd = fopen(file, "r+");
    if(fd == NULL)
    {
    	printf("open %s error!\n", file);
    	return 0;
    }
    
//	data = 0x5050;
	data = 0x5A5A;	
	oss_format=AFMT_S16_LE;/*standard 16bit little endian format, support this format only*/
	sample_rate = samplerate;
	channels = 2;
	ioctl(p_dsp, SNDCTL_DSP_SETFMT, &oss_format);
	ioctl(p_mixer, MIXER_WRITE(SOUND_MIXER_PCM), &data);
	ioctl(p_dsp, SNDCTL_DSP_SPEED, &sample_rate);
	ioctl(p_dsp, SNDCTL_DSP_CHANNELS, &channels);
			
	int frag;
	ioctl(p_dsp, SNDCTL_DSP_GETBLKSIZE, &frag);
	buffer = (char *)malloc(frag);
	printf("frag=%s\n", buffer);	
	
	fread(buffer, 1, frag, fd);	
	while(!feof(fd))	
	{		
		audio_buf_info info;			
		do{			
			ioctl(p_dsp , SNDCTL_DSP_GETOSPACE , &info);			
			usleep(100);
		}while(info.bytes < frag);
		
		fd_set writefds;
		struct timeval tv;
		tv.tv_sec       = 0;
		tv.tv_usec      = 0;
		FD_ZERO( &writefds );
		FD_SET( p_dsp , &writefds );
		tv.tv_sec       = 0;
		tv.tv_usec      = 0;
		
		select( p_dsp + 1 , NULL , &writefds , NULL, &tv );
		if( FD_ISSET( p_dsp, &writefds ))
		{	
			write(p_dsp, buffer, frag);   			
			fread(buffer, 1, frag, fd);
		}	
		usleep(100);
	}
	
	int bytes;
	ioctl(p_dsp,SNDCTL_DSP_GETODELAY,&bytes);
	int delay = bytes / (sample_rate * 2 * channels);	
	sleep(delay);
	
	printf("Stop Play\n");
	fclose(fd);
	free(buffer);
	close_audio_play_device();

	return 0;
}

int main()
{
	int i;
	for(i = 0;i < 2;i ++)
	{
		printf("play:%d\n",i);
		play_pcm(pcmfiles[i], samplerate[i]);
	}
	return 0;
}
