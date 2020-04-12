// Distributed with a free-will license.
// Use it any way you want, profit or free, provided it fits in the licenses of its associated works.
// SI7021
// This code is designed to work with the SI7021_I2CS I2C Mini Module available from ControlEverything.com.
// https://www.controleverything.com/content/Humidity?sku=SI7021_I2CS#tabs-0-product_tabset-2

#include <stdio.h>
#include <stdlib.h>
#include <linux/i2c-dev.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <sys/types.h>
#include <unistd.h>
#include <termios.h> /* POSIX Terminal Control Definitions */
#include <errno.h>   /* ERROR Number Definitions           */



void main()
{
	// Create I2C bus
	int file;
	char *bus = "/dev/i2c-2";
	if((file = open(bus, O_RDWR)) < 0) 
	{
		printf("Failed to open the bus. \n");
		exit(1);
	}
	// Get I2C device, SI7021 I2C address is 0x40(64)
	ioctl(file, I2C_SLAVE, 0x40);

        	int fd;/*File Descriptor*/

		/*------------------------------- Opening the Serial Port -------------------------------*/

		/* Change /dev/ttyUSB0 to the one corresponding to your system */

        	fd = open("/dev/ttymxc0",O_RDWR | O_NOCTTY | O_NDELAY);	                                       

	
		/*---------- Setting the Attributes of the serial port using termios structure --------- */
		
		struct termios SerialPortSettings;	/* Create the structure                          */
		tcgetattr(fd, &SerialPortSettings);	/* Get the current attributes of the Serial port */
		cfsetispeed(&SerialPortSettings,B115200); /* Set Read  Speed as 9600                       */
		cfsetospeed(&SerialPortSettings,B115200); /* Set Write Speed as 9600                       */
		SerialPortSettings.c_cflag &= ~PARENB;   /* Disables the Parity Enable bit(PARENB),So No Parity   */
		SerialPortSettings.c_cflag &= ~CSTOPB;   /* CSTOPB = 2 Stop bits,here it is cleared so 1 Stop bit */
		SerialPortSettings.c_cflag &= ~CSIZE;	 /* Clears the mask for setting the data size             */
		SerialPortSettings.c_cflag |=  CS8;      /* Set the data bits = 8                                 */
		SerialPortSettings.c_cflag &= ~CRTSCTS;       /* No Hardware flow Control                         */
		SerialPortSettings.c_cflag |= CREAD | CLOCAL; /* Enable receiver,Ignore Modem Control lines       */ 	
		SerialPortSettings.c_iflag &= ~(IXON | IXOFF | IXANY);          /* Disable XON/XOFF flow control both i/p and o/p */
		SerialPortSettings.c_iflag &= ~(ICANON | ECHO | ECHOE | ISIG);  /* Non Cannonical mode                            */
		SerialPortSettings.c_oflag &= ~OPOST;/*No Output Processing*/


	while(1){
	// Send humidity measurement command(0xF5)
	char config[1] = {0xF5};
	int  bytes_written  = 0;  	/* Value for storing the number of bytes written to the port */ 
	char humi[32]="";
	char ct[32]="";
	write(file, config, 1);
	sleep(1);

	// Read 2 bytes of humidity data
	// humidity msb, humidity lsb
	char data[2] = {0};
	if(read(file, data, 2) != 2)
	{
		printf("Error : Input/output Error HUMEDAD \n");
	}
	else
	{
		// Convert the data
		float humidity = (((data[0] * 256 + data[1]) * 125.0) / 65536.0) - 6;
		sprintf(humi,"Humidity : %.2f ",humidity);
		// Output data to screen
		bytes_written = write(fd,humi,sizeof(humi));/* use write() to send data to */
	}

	// Send temperature measurement command(0xF3)
	config[0] = 0xF3;
	write(file, config, 1); 
	sleep(1);

	// Read 2 bytes of temperature data
	// temp msb, temp lsb
	if(read(file, data, 2) != 2)
	{
		printf("Error : Input/output Error TEMPERATURA \n");
	}
	else
	{
		// Convert the data
		float cTemp = (((data[0] * 256 + data[1]) * 175.72) / 65536.0) - 46.85;
		sprintf(ct,"Temp : %.2f \n\r ",cTemp);
		// Output data to screen
		bytes_written = write(fd,ct,sizeof(ct));/* use write() to send data to */
	}}
}
