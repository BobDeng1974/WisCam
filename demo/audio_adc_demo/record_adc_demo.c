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

int p_dsp, p_mixer;
static volatile int rec_volume;
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


int play_pcm_single(char *file, int samplerate)
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
    
	data = 0x5050;
	oss_format=AFMT_S16_LE;/*standard 16bit little endian format, support this format only*/
	sample_rate = samplerate;
	channels = 1;
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

signed short applicbuf[2048];
int record_to_pcm_adc(char *file, int samplerate, int seconds)
{
	int audio_fd, music_fd, mixer_fd, count;
	int format;
	int channels = 1;   
	int totalbyte= samplerate * channels * 2 * seconds;
	int total = 0;
//	int speed;
	
	printf("Sample rate = %d\n", samplerate);
	printf("Second = %d\n", seconds);
	printf("totalbyte = %d\n", totalbyte);

	if ((audio_fd = open("/dev/dsp1",O_RDONLY,0)) == -1) 
	{
		perror("/dev/dsp1");
		return -1;
	}
	printf("open dsp1 successful\n");
	if ((mixer_fd = open("/dev/mixer1", O_WRONLY)) == -1) 
    {
      	perror("open /dev/mixer1 error");
        return -1;
    }
	printf("open mixer1 successful\n");
	/*  Setting Sampling Parameters
		1. sample format
		2. number of channels
		3. sampling rate
	*/
	format = AFMT_S16_LE;
	if (ioctl(audio_fd,SNDCTL_DSP_SETFMT, &format) == -1) 
	{
		perror("SNDCTL_DSP_SETFMT");
		return -1;	
	}	
/*	
	if (ioctl(audio_fd, SNDCTL_DSP_CHANNELS, & channels) == -1) 
	{
		perror("SNDCTL_DSP_CHANNELS");
		return;
	}
*/
	if (ioctl(audio_fd, SNDCTL_DSP_SPEED, &samplerate) == -1) 
	{
		perror("SNDCTL_DSP_SPEED");
		return -1;
	} 
//	else 
//		printf("Actual Speed : %d \n",speed);
	

	/* Volume control */
	if ((mixer_fd = open("/dev/mixer1", O_WRONLY)) == -1) {
      	perror("open /dev/mixer1 error");
        return -1;
    }
	printf("open mixer successful\n");
	ioctl(mixer_fd , MIXER_WRITE(SOUND_MIXER_PCM), &rec_volume);	
	printf("set mic volume = 0x%x   !!!\n", rec_volume);

	//recording
	if ((music_fd = open("./rec.pcm", O_CREAT|O_WRONLY|O_TRUNC, 0)) == -1)
	{
		
        perror("rec.pcm");
        return -1;
    }      		
    
	/* 	recording three minutes
		
		sample format :16bit
		channel num: 2 channels
		sample rate = speed                                                             
		data rate = speed * 2 * 2	bytes/sec
	*/

    while (total != totalbyte)
    {
		if(totalbyte - total >= 2048)
			count = 2048;
		else 
			count = totalbyte - total;
		
    		read(audio_fd, applicbuf, count);
        write(music_fd, applicbuf, count);
		total += count;   		
	}

	close(mixer_fd);
	close(audio_fd);
	close(music_fd);

	return 0;
}


int main()
{
	
	int  loop, sr;
	int buf;
	printf("Record and then Play (one channel, by FA93 ADC)\n");
	printf("\nRec Seconds:");
			scanf("%d", &loop);
			
			printf("Sample Rate(8000, 11025, 12000 or 16000):");
			scanf("%d", &sr);
			
			printf("Record volume (0 - 100) :");
			scanf("%d", &rec_volume);

			if (rec_volume > 100) rec_volume = 100;					

			buf = rec_volume;
			rec_volume <<= 8;
			rec_volume |= buf;								

			printf(" *** Recording ***\n");
			printf("SampleRate=%d, Time=%d sec, Volume=%d\n", sr, loop, buf);		

//			record_to_pcm_single("./rec.pcm", sr, loop);
			record_to_pcm_adc("./rec.pcm", sr, loop);
	
			printf("\nDone, Now play it ...\n");
	
			getchar();
			play_pcm_single("./rec.pcm", sr);
	return 0;
}
