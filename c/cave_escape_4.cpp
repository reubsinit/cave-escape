#include <stdio.h>
#include "splashkit.h"

#define GRAVITY 0.08
#define MAX_SPEED 5
#define JUMP_RECOVERY_BOOST 2

sprite get_new_player()
{
  sprite result;
  result = create_sprite(bitmap_named("Player"), animation_script_named("PlayerAnimations"));
  sprite_set_x(result, screen_width() / 2 - sprite_width(result));
  sprite_set_y(result, screen_height() / 2);
  sprite_start_animation(result, "Fly");

  return result;
}

void handle_input(sprite player)
{
  if (key_typed(SPACE_KEY))
  {
    sprite_set_dy(player, sprite_dy(player) - JUMP_RECOVERY_BOOST);
  }
}

void update_velocity(sprite player)
{
  sprite_set_dy(player, sprite_dy(player) + GRAVITY);

  if (sprite_dy(player) > MAX_SPEED)
  {
    sprite_set_dy(player, MAX_SPEED);
  }
  else if (sprite_dy(player) < -(MAX_SPEED))
  {
    sprite_set_dy(player, -(MAX_SPEED));
  }
}

int main()
{
    sprite player;

    open_window("Cave Escape", 432, 768);
    load_resource_bundle("CaveEscape", "CaveEscape.txt");

    player = get_new_player();

    do
    {
      process_events();
      clear_screen(COLOR_WHITE);
      update_velocity(player);
      handle_input(player);
      update_sprite(player);
      draw_sprite(player);
      refresh_screen(60);

    } while(!window_close_requested("Cave Escape"));

    return 0;
}
