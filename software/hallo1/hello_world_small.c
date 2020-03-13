/* 
 * "Small Hello World" example. 
 * 
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example 
 * designs. It requires a STDOUT  device in your system's hardware. 
 *
 * The purpose of this example is to demonstrate the smallest possible Hello 
 * World application, using the Nios II HAL library.  The memory footprint
 * of this hosted application is ~332 bytes by default using the standard 
 * reference design.  For a more fully featured Hello World application
 * example, see the example titled "Hello World".
 *
 * The memory footprint of this example has been reduced by making the
 * following changes to the normal "Hello World" example.
 * Check in the Nios II Software Developers Manual for a more complete 
 * description.
 * 
 * In the SW Application project (small_hello_world):
 *
 *  - In the C/C++ Build page
 * 
 *    - Set the Optimization Level to -Os
 * 
 * In System Library project (small_hello_world_syslib):
 *  - In the C/C++ Build page
 * 
 *    - Set the Optimization Level to -Os
 * 
 *    - Define the preprocessor option ALT_NO_INSTRUCTION_EMULATION 
 *      This removes software exception handling, which means that you cannot 
 *      run code compiled for Nios II cpu with a hardware multiplier on a core 
 *      without a the multiply unit. Check the Nios II Software Developers 
 *      Manual for more details.
 *
 *  - In the System Library page:
 *    - Set Periodic system timer and Timestamp timer to none
 *      This prevents the automatic inclusion of the timer driver.
 *
 *    - Set Max file descriptors to 4
 *      This reduces the size of the file handle pool.
 *
 *    - Check Main function does not exit
 *    - Uncheck Clean exit (flush buffers)
 *      This removes the unneeded call to exit when main returns, since it
 *      won't.
 *
 *    - Check Don't use C++
 *      This builds without the C++ support code.
 *
 *    - Check Small C library
 *      This uses a reduced functionality C library, which lacks  
 *      support for buffering, file IO, floating point and getch(), etc. 
 *      Check the Nios II Software Developers Manual for a complete list.
 *
 *    - Check Reduced device drivers
 *      This uses reduced functionality drivers if they're available. For the
 *      standard design this means you get polled UART and JTAG UART drivers,
 *      no support for the LCD driver and you lose the ability to program 
 *      CFI compliant flash devices.
 *
 *    - Check Access device drivers directly
 *      This bypasses the device file system to access device drivers directly.
 *      This eliminates the space required for the device file system services.
 *      It also provides a HAL version of libc services that access the drivers
 *      directly, further reducing space. Only a limited number of libc
 *      functions are available in this configuration.
 *
 *    - Use ALT versions of stdio routines:
 *
 *           Function                  Description
 *        ===============  =====================================
 *        alt_printf       Only supports %s, %x, and %c ( < 1 Kbyte)
 *        alt_putstr       Smaller overhead than puts with direct drivers
 *                         Note this function doesn't add a newline.
 *        alt_putchar      Smaller overhead than putchar with direct drivers
 *        alt_getchar      Smaller overhead than getchar with direct drivers
 *
 */

#include "sys/alt_stdio.h"
#include "io.h"
#include "system.h"
#include <unistd.h> //e.g. //usleep(5000000); is 5 seconds

#define BYTESPERWORD 				1
#define REG_MIX_CONTROL				0* BYTESPERWORD
#define REG_MIX_STATUS 				1* BYTESPERWORD
#define REG_MIX_IN0_XOFFSET 		8* BYTESPERWORD
#define REG_MIX_IN0_YOFFSET 		9* BYTESPERWORD
#define REG_MIX_IN0_INPUTCONTROL 	10* BYTESPERWORD
#define REG_MIX_IN0_LAYERPOSITION 	11* BYTESPERWORD
#define REG_MIX_IN0_STATICALPHA 	12* BYTESPERWORD

#define REG_SCAL_CONTROL			0* BYTESPERWORD
#define REG_SCAL_STATUS		  		1* BYTESPERWORD
#define REG_SCAL_WIDTH				3* BYTESPERWORD
#define REG_SCAL_HEIGHT				4* BYTESPERWORD

void waitWithLed(int ticks, int tickTimeMs);
void setStartPosition(int x, int y);
void printStatus();
void setSize(int x, int y);


int main()
{
	int x_pos = 0, y_pos = 0;
	int width = 320, height = 448;
	int max_pos = 50;

	printStatus();

	alt_putstr("\n\rInitializeren van mixer en scaler na LED geroffel...");
	waitWithLed(60, 40);
	IOWR(ALT_VIP_CL_MIXER_0_BASE, REG_MIX_CONTROL, 0x1);
	IOWR(MAIN_SCALER_BASE, REG_SCAL_CONTROL, 0x1);
	alt_putstr("-->Klaar met instellen.\n\r");
	printStatus();

	waitWithLed(4, 1000);

	alt_putstr("beginpositie instellen na LED geroffel...");
	waitWithLed(60, 40);
	IOWR(ALT_VIP_CL_MIXER_0_BASE, REG_MIX_IN0_XOFFSET , 30);
	IOWR(ALT_VIP_CL_MIXER_0_BASE, REG_MIX_IN0_YOFFSET , 30);
	alt_putstr("-->Klaar met instellen.\n\r");
	printStatus();

	waitWithLed(5, 1000);

	alt_putstr("scaler grootte instellen na LED geroffel...");
	waitWithLed(60, 40);
	IOWR(MAIN_SCALER_BASE, REG_SCAL_WIDTH , width);
	IOWR(MAIN_SCALER_BASE, REG_SCAL_HEIGHT , height);
	alt_putstr("-->Klaar met instellen.\n\r");
	printStatus();

	waitWithLed(5, 1000);
/*
	alt_putstr("consume input 0 na LED geroffel...");
	waitWithLed(60, 40);
	IOWR(ALT_VIP_CL_MIXER_0_BASE, REG_MIX_IN0_INPUTCONTROL , 0x2);
	alt_putstr("-->Klaar met instellen.\n\r");

	waitWithLed(6, 1000);

	alt_putstr("enable en consume input 0 na LED geroffel...");
	waitWithLed(60, 40);
	IOWR(ALT_VIP_CL_MIXER_0_BASE, REG_MIX_IN0_INPUTCONTROL , 0x3);
	alt_putstr("-->Klaar met instellen.\n\r");

	waitWithLed(6, 1000);
*/
	alt_putstr("enable input 0 na LED geroffel...");
	waitWithLed(60, 40);
	IOWR(ALT_VIP_CL_MIXER_0_BASE, REG_MIX_IN0_INPUTCONTROL , 0x1);
	alt_putstr("-->Klaar met instellen.\n\r");
	printStatus();

	alt_putstr("Dat was het.\n\r");

  /* Event loop never exits. */
  while (1)
  {
	  int curr_width, curr_height;

  	  waitWithLed(1, 1000);
  	  setStartPosition(x_pos, y_pos);
  	  curr_width = width + (x_pos * 5);
  	  curr_height = height + (x_pos * 3);
  	  setSize(curr_width, curr_height);

  	  alt_printf("pos=(%x,%x), size=(%x,%x)\n\r", x_pos, y_pos, curr_width, curr_height);
  	  printStatus();

  	  if (x_pos >= max_pos || y_pos >= max_pos)
  	  {
  		x_pos = 0;
  		y_pos = 0;
  	  }
  	  else
  	  {
  		  x_pos++;
  		  y_pos++;
  	  }
  }

  return 0;
}

void waitWithLed(int ticks, int tickTimeMs)
{
	for (int i = 0; i < ticks; i++)
		{
		  IOWR(PIO_0_BASE, 0x00, 0x3);
		  usleep(tickTimeMs/2 * 1000);
		  IOWR(PIO_0_BASE, 0x00, 0x0);
		  usleep(tickTimeMs/2 * 1000);
		}
	return;
}

void setStartPosition(int x, int y)
{
	IOWR(ALT_VIP_CL_MIXER_0_BASE, REG_MIX_IN0_XOFFSET , x);
	IOWR(ALT_VIP_CL_MIXER_0_BASE, REG_MIX_IN0_YOFFSET , y);
}

void printStatus()
{
	int status;

	status = IORD(ALT_VIP_CL_MIXER_0_BASE, REG_MIX_STATUS);
	alt_printf("***  Mixer status is nu:  %x  ***\n\r", status);
	status = IORD(MAIN_SCALER_BASE, REG_SCAL_STATUS);
	alt_printf("***  Scaler status is nu: %x  ***\n\r", status);
	return;
}

void setSize(int x, int y)
{
	IOWR(MAIN_SCALER_BASE, REG_SCAL_WIDTH , x);
	IOWR(MAIN_SCALER_BASE, REG_SCAL_HEIGHT , y);
}
