#include <stdio.h>
#include "splashkit.h"

int main()
{
    open_window("Cave Escape", 432, 768);

    do // The game loop...
    {
      process_events();
      clear_screen(COLOR_WHITE);
      refresh_screen(60);
    } while(!window_close_requested("Cave Escape"));

    return 0;
}
