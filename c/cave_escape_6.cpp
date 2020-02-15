#include <stdio.h>
#include "splashkit.h"

#define GRAVITY 0.08
#define MAX_SPEED 5
#define JUMP_RECOVERY_BOOST 2
#define POLE_SCROLL_SPEED -2

typedef struct pole_data
{
  sprite up_pole, down_pole;
} pole_data;

sprite get_new_player()
{
  sprite result;
  result = create_sprite(bitmap_named("Player"), animation_script_named("PlayerAnimations"));
  sprite_set_x(result, screen_width() / 2 - sprite_width(result));
  sprite_set_y(result, screen_height() / 2);
  sprite_start_animation(result, "Fly");

  return result;
}

pole_data get_random_poles()
{
  pole_data result;
  result.up_pole = create_sprite(bitmap_named("UpPole"));
  result.down_pole = create_sprite(bitmap_named("DownPole"));
  sprite_set_x(result.up_pole, screen_width() + rnd(1200));
  sprite_set_y(result.up_pole, screen_height() - sprite_height(result.up_pole));
  sprite_set_x(result.down_pole, sprite_x(result.up_pole));
  sprite_set_y(result.down_pole, 0);
  sprite_set_dx(result.up_pole, POLE_SCROLL_SPEED);
  sprite_set_dx(result.down_pole, POLE_SCROLL_SPEED);

  return result;
}

void handle_input(sprite player)
{
  if (key_typed(SPACE_KEY))
  {
    sprite_set_dy(player, sprite_dy(player) - JUMP_RECOVERY_BOOST);
  }
}

void reset_pole_data(pole_data poles)
{
  free_sprite(poles.up_pole);
  free_sprite(poles.down_pole);
  poles = get_random_poles();
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

void update_poles(pole_data poles)
{
  update_sprite(poles.up_pole);
  update_sprite(poles.down_pole);

  if ((sprite_x(poles.up_pole) + sprite_width(poles.up_pole) < 0) && (sprite_x(poles.down_pole) + sprite_width(poles.down_pole) < 0))
  {
    reset_pole_data(poles);
  }
}

void draw_poles(pole_data poles)
{
  draw_sprite(poles.up_pole);
  draw_sprite(poles.down_pole);
}

int main()
{
    sprite player;
    pole_data game_poles;

    open_window("Cave Escape", 432, 768);
    load_resource_bundle("CaveEscape", "CaveEscape.txt");

    player = get_new_player();

    game_poles = get_random_poles();

    do
    {
      process_events();
      clear_screen(COLOR_WHITE);
      update_velocity(player);
      handle_input(player);
      update_sprite(player);
      draw_sprite(player);
      update_poles(game_poles);
      draw_poles(game_poles);
      refresh_screen(60);

    } while(!window_close_requested("Cave Escape"));

    return 0;
}
