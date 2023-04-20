#include <stdio.h>
#include <stdlib.h>
#include <sys/timex.h>

#define TAI_OFFSET 37

int main(void)
{
	struct timex timex = {
		.modes		= ADJ_TAI,
		.constant	= TAI_OFFSET
	};

	if (adjtimex(&timex) == -1) {
		perror("adjtimex failed to set CLOCK_TAI offset");
		return EXIT_FAILURE;
	}

	return EXIT_SUCCESS;
}
