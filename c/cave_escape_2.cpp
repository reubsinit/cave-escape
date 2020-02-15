#include <stdio.h>
#include "splashkit.h"

sprite get_new_player()
{
  sprite result;
  result = create_sprite(bitmap_named("Player"), animation_script_named("PlayerAnimations"));
  sprite_set_x(result, screen_width() / 2 - sprite_width(result));
  sprite_set_y(result, screen_height() / 2);
  sprite_start_animation(result, "Fly");0)

  return result;
}

int main()
{
    sprite player;

    open_window("Cave Escape", 432, 768);
    load_resource_bundle("CaveEscape", "CaveEscape.txt");

    player = get_new_player();

    do // The game loop...
    {
      process_events();
      clear_screen(COLOR_WHITE);
      update_sprite(player);
      draw_sprite(player);
      refresh_screen(60);
    } while(!window_close_requested("Cave Escape"));

    return 0;
}
