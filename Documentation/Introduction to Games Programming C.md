# 1. Iteration One

In the first iteration of Cave Escape, you will implement the boiler plate code for a simple game. The boiler plater code includes the instructions to open a graphics window and the execution of a basic game loop, where all of the instructions that you implement will be called from.

## What to Expect

Once you're finished working through and implementing iteration one, you should have something that looks just like this:


![Iteration One](imgs/iteration_1.png)


That's it! Just a blank graphics window, but we'll work on that blank canvas in future iterations.

## Code

### - Complete Code
The complete code for iteration one is as follows:

```c
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
```

### - How it's Working
The ```main()``` procedure, as demonstrated in the code above, is responsible for executing all of the instructions required for our game to run. The instructions are executed in sequence, meaning that the code within the ```main()``` procedure will be executed in the exact order in which it is specified.

So, that being said, let's take a moment to analyse the ```main()``` procedure and the instructions it is executing. The sequence is as follows:

  1. Firstly, a call to ```open_window()``` is made, where we can see the title of the window being opened is Cave Escape and the width and height of the window is 432 by 768 pixels.
  2. The game loop is opened. The game loop will loop over and over, until the user closes the window, meaning all of the instructions will be continually executed for as long as the loop is running. Note that the condition of the loop is ```window_close_requested("Cave Escape")```.
     * The following instructions are executed within the game loop:
      1. ```process_events()``` is called. ```process_events()``` is used to listen for any user input made while the program is running.
      2. We then clear the screen with ```clear_screen()``` before we draw anything to it (we're not drawing anything in this iteration, but that will come soon!).
      3. We then refresh the screen with ```refresh_screen(60)``` so that we can see what we've drawn.

### Have a Crack
Now it's time for you to have a go at implementing iteration one on your own. You'll have to type the instructions above into your text editor. Try and resist the urge to copy and paste code if it arrises, as typing it out helps build your understanding in regards to what the code is doing. When you're done, you'll need to build and run your code to see if it is all working. If you encounter any build errors, you'll have to resolve those and build and run again.

---
# 2. Iteration Two

In the second iteration of Cave Escape, you will implement the functionality to have your game produce a graphical representation of the player. The player will be drawn to the centre of the graphics window and come complete with an animation!

## What to Expect

Once you're finished working through and implementing iteration two, you should have something that looks just like this:


![Iteration Two](imgs/iteration_2.gif)


What's different from iteration one? We've got a graphical representation of the game's player! Now let's take a look at how this is implemented.

## Code

### - New Code
The new code in iteration two is as follows:

#### Addition one
```c    
sprite get_new_player()
{
  sprite result;
  result = create_sprite(bitmap_named("Player"), animation_script_named("PlayerAnimations"));
  sprite_set_x(result, screen_width() / 2 - sprite_width(result));
  sprite_set_y(result, screen_height() / 2);
  sprite_start_animation(result, "Fly");

  return result;
}
```
- The ```get_new_player()``` function, as demonstrated in the code above, is used to generate the data associated with the player entity that we'll be using in our game. It's important to note that functions use a special variable called ```result``` to store the value in that they calculate. So, in short, the function is creating a sprite for the player, setting the sprite's location to the centre of the screen and setting an animation for the sprite. Once the function finishes, it returns the sprite it creates (the ```result``` variable).

### - Complete Code
The complete code for iteration two can be found [here](../c/cave_escape_2.cpp).

### - You've Changed, Main
```c
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
```

Take a close look at the ```main()``` procedure. A few things have changed in order to cater for our new ```get_new_player()``` function as well as drawing our player to the screen. The sprite that the function ```get_new_player()``` returns is assigned to a variable called ```player``` and then within the game loop, the player sprite is updated and drawn.

### Have a Crack
Now it's time for you to have a go at implementing iteration two on your own. As before, you'll have to type the instructions above into your text editor. Continue to try and resist the urge to copy and paste code if it arrises, as typing it out helps build your understanding in regards to what the code is doing. When you're done, you'll need to build and run your code to see if it is all working. If you encounter any build errors, you'll have to resolve those and build and run again.

---
# 3. Iteration Three

In the third iteration of Cave Escape, you will implement the functionality to give your player the ability to fly! Well, almost. You're going to add some velocity to the player so that it's not just stuck in the middle of the screen, instead, when you're finished, the player will fall right off the bottom of the screen!

## What to Expect

Once you're finished working through and implementing iteration three, you should have something that looks just like this:


![Iteration Three](imgs/iteration_3.gif)


So with some velocity, the game is a little more dynamic than it previously was in iteration two.

## Code

### - New Code
The new code in iteration three is as follows:

#### Addition one
```c
#define GRAVITY 0.08
#define MAX_SPEED 5
```
- We've taken the time to add some constant values that are going to be used in the calculation of the player's velocity. Those values represent an imposed ```GRAVITY``` and a ```MAX_SPEED``` in regards to what we want to impose as the maximum velocity the player can move, or fall at.

#### Addition two
```c    
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
```
- The ```update_velocity()``` procedure, as demonstrated in the code above, uses these two new constant values to determine what the player's speed will be by using conditional statements. The conditional statements ensure that ```if``` the player is not already falling at the ```MAX_SPEED```, increase it's velocity, ```else if``` the player is already falling at the ```MAX_SPEED```, ensure that it stays falling at the ```MAX_SPEED``` rather than going any faster.

### - Complete Code
The complete code for iteration three can be found [here](../c/cave_escape_3.cpp).

### - Take a Look at Main
```c
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
      update_velocity(player);
      update_sprite(player);
      draw_sprite(player);
      refresh_screen(60);

    } while(!window_close_requested("Cave Escape"));

    return 0;
}
```

The ```main()``` procedure has now changed. Notice that in the game loop, there's now a call to the new procedure ```update_velocity()```. This ensures that for each time the game loop executes, we're ensuring that we're updating the player's velocity accordingly.

### Have a Crack
Now it's time for you to have a go at implementing iteration three on your own. Give it a crack and see how you go.

---
# 4. Iteration Four

In the fourth iteration of Cave Escape, we will actually implement the ability to have you control the way the player flies. Instead of the player just falling into the abyss, as it was in iteration three, iteration four sees the inclusion of the logic required to keep the player on the screen by using keyboard input. In particular, we're going to make it so that every time the space bar is pressed, the player is going to fly a little higher, and further away from the bottom of the screen.

## What to Expect

Once you're finished working through and implementing iteration four, you should have something that looks just like this:


![Iteration Four](imgs/iteration_4.gif)


Look at that! Control over the player's velocity!

## Code

### - New Code
The new code in iteration four is as follows:

#### Addition one (Note: There is a new constant value)
```c
#define GRAVITY 0.08
#define MAX_SPEED 5
#define JUMP_RECOVERY_BOOST 2
```
- In order to be able to control the player's velocity with user input, we've had to add a new constant value called ```JUMP_RECOVERY_BOOST```. The reason for this will become more clear when we talk about the new procedure ```handle_input()```.

#### Addition two
```c    
void handle_input(sprite player)
{
  if (key_typed(SPACE_KEY))
  {
    sprite_set_dy(player, sprite_dy(player) - JUMP_RECOVERY_BOOST);
  }
}
```
- The new procedure ```handle_input()``` is implemented to listen for user input while the game is running. Specifically, the input it's listening for is when the space bar is pressed. Every time the space bar is pressed, the ```handle_input()``` procedure will decrement the value of the constant ```JUMP_RECOVERY_BOOST``` from the player's current velocity, meaning, that each time the space bar is pressed, the player will fall a little slower, but only briefly. The aim is to have the user continually press the space bar to keep the player on the screen and give it the affect of flying!

### - Complete Code
The complete code for iteration four can be found [here](../c/cave_escape_4.cpp).

### - Main has Changed, Again
```c
int main()
{
    sprite player;

    open_window("Cave Escape", 432, 768);
    load_resource_bundle("CaveEscape", "CaveEscape.txt");

    player = get_new_player();

    do
    {
      process_events();
      clear_screen(ColorWhite);
      update_velocity(player);
      handle_input(player);
      update_sprite(player);
      draw_sprite(player);
      refresh_screen(60);

    } while(!window_close_requested("Cave Escape"));

    return 0;
}
```

The ```main()``` procedure has now changed. Notice that in the game loop, there's now a call to the new procedure ```handle_input()```. This ensures that for each time the game loop executes, we're ensuring that we're listening for any user input, specifically, if the space bar has been pressed. Now we have a more functional game where the user finally has some control over the way the game behaves.


### Have a Crack
Now it's time for you to have a go at implementing iteration four on your own.

---
# 5. Iteration Five

In the fifth iteration of Cave Escape, we add quite a bit of functionality, more so than in the previous iterations. We're up for a big step with this one. We're going to add an obstacle. We'll refer to the obstacle as a set of poles. It's the aim of the game to avoid the poles, but we'll worry about that later. For now, let's just worry about getting the poles onto the screen. So, this iteration concerns the generation of a single set of poles as well as the way the poles behave.

## What to Expect

Once you're finished working through and implementing iteration five, you should have something that looks just like this:


![Iteration Five](imgs/iteration_5.gif)


While iteration five is quite a bit involved, in terms of new code required, it adds loads of functionality to our game and now, more than ever, it's looking more and more like a game.

## Code

### - New Code
The new code in iteration five is as follows:

#### Addition one (Note: There is a new constant value)
```c
#define GRAVITY 0.08
#define MAX_SPEED 5
#define JUMP_RECOVERY_BOOST 2
#define POLE_SCROLL_SPEED -2
```
- The poles that we're adding to the game will move horizontally across the screen, from left to right. In order to cater for this, we've added another constant called ```POLE_SCROLL_SPEED``` in order to keep track of the speed at which the poles travel across the screen.

#### Addition two
```c    
typedef struct pole_data
{
  sprite up_pole, down_pole;
} pole_data;
```
- In order to be able to keep track of the data required to add the poles to the game, we've added a record called ```pole_data```. If you take a look at the ```pole_data``` record, you'll notice that it has two fields as sprites. ```pole_data``` needs two sprites because one pole will come down from the top of the screen and the other will come up from the bottom.

#### Addition three
```c    
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
```
- Now, we need some logic in order to be able to add the poles to the game so that we can see them. Firstly, we've got a new function called ```get_random_poles()```, which is responsible for generating the data associated with the poles. This function behaves similarly to the function ```get_new_player()```, as discussed in iteration two. ```get_random_poles()``` assigns the top and bottom poles their own sprites, sets their x location to a random location off the far right of the screen (this is intentional because we want to see the poles scroll onto the screen from the right) and sets their y locations so that they appear to be coming down from the top and up from the bottom of the screen. Finally, the function assigns their delta x, or horizontal movement speed to that of the value of the constant ```POLE_SCROLL_SPEED```.

#### Addition four
```c    
void update_poles(pole_data poles)
{
  update_sprite(poles.up_pole);
  update_sprite(poles.down_pole);
}
```
- A procedure called ```update_poles()``` has been added to update the poles.

#### Addition five
```c    
void draw_poles(pole_data poles)
{
  draw_sprite(poles.up_pole);
  draw_sprite(poles.down_pole);
}
```
- A procedure called ```draw_poles()``` has been added to draw the poles to the screen.

### - Complete Code
The complete code for iteration five can be found [here](../c/cave_escape_5.cpp).

### - More Changes to Main
```c
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
      clear_screen(ColorWhite);
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
```
The ```main()``` procedure has now changed. Notice that we're now using our new function ```get_random_poles()``` and assigning the value it returns to a variable called ```game_poles```. In order to move the poles across the screen and draw them, we've added the calls to the procedures ```update_poles()``` and ```draw_poles()``` within the game loop.

### Have a Crack
Now it's time for you to have a go at implementing iteration five on your own.

---
# 6. Iteration Six

In the sixth iteration of Cave Escape, we're going to make a few additions to ensure that once the poles move off the far left of the screen, they get moved back default position. This will ensure that the poles can be reused as obstacles.

## What to Expect

Once you're finished working through and implementing iteration six, you should have something that looks just like this:


![Iteration Six](imgs/iteration_6.gif)


The poles are much better when they wrap around the game screen!

## Code

### - New Code
The new code in iteration six is as follows:

#### Addition one
```c
void reset_pole_data(pole_data poles)
{
  free_sprite(poles.up_pole);
  free_sprite(poles.down_pole);
  poles = get_random_poles();
}
```
- We've added a new procedure called ```reset_pole_data()``` that is going to reset the poles once they move off the left of screen. Notice that it calls the function ```get_random_poles()``` that we implemented before. It makes sense to reuse code where you can, and the poles that the function ```get_random_poles()``` returns are exactly what we need when we have to reset them.

#### Addition two (Note: ```update_poles()``` has had code added to it)
```c    
void update_poles(pole_data poles)
{
  update_sprite(poles.up_pole);
  update_sprite(poles.down_pole);

  if ((sprite_x(poles.up_pole) + sprite_width(poles.up_pole) < 0) && (sprite_x(poles.down_pole) + sprite_width(poles.down_pole) < 0))
  {
    reset_pole_data(poles);
  }
}
```
- We've modified ```update_poles()``` to check to see if the poles have moved off the left of the screen and ```if``` they have, we simply reset them.

### - Complete Code
The complete code for iteration six can be found [here](../c/cave_escape_6.cpp).

### - Any Changes to Main
Not in this iteration. Hurray!

### Have a Crack
Now it's time for you to have a go at implementing iteration six on your own.

---
# 7. Iteration Seven

In iteration seven of Cave Escape, we're going to implement the logic to have more than one set of poles. One set of poles is simply not challenging enough, and the overall change in logic to suit such functionality is quite minor.

## What to Expect

Once you're finished working through and implementing iteration seven, you should have something that looks just like this:


![Iteration Seven](imgs/iteration_7.gif)


Now we have lots of poles!

## Code

### - New Code
The new code in iteration seven is as follows:

#### Addition one (Note: There is a new constant value)
```c
#define GRAVITY 0.08
#define MAX_SPEED 5
#define JUMP_RECOVERY_BOOST 2
#define POLE_SCROLL_SPEED -2
#define NUM_POLES 4
```
- We've added a constant called ```NUM_POLES``` to store the number of sets of poles we want in the game. The code provided has ```NUM_POLES``` being equal to the value of four, so this means there will be exactly four sets of poles in the game.

#### Addition two
```c    
typedef struct pole_data poles[NUM_POLES];
```
- The second addition is an array of ```pole_data``` called ```Poles```. This array is where our four sets of poles will be stored. You can see the array is declared as such ```typedef struct pole_data poles[NUM_POLES];```. It's important to understand the logic in the square bracers ```[NUM_POLES]```. Now, ```NUM_POLES``` is four and computers are zero based, meaning that our first set of poles is actually denoted the numerical value of zero, the second set is denoted one, the third set two and the fourth set three! Moving on.

#### Addition three (Note: ```update_poles()``` has had code added to it)
```c    
void update_poles(poles poles)
{
  int i;

  for (i = 0; i < NUM_POLES; i++)
  {
    update_sprite(poles[i].up_pole);
    update_sprite(poles[i].down_pole);

    if ((sprite_x(poles[i].up_pole) + sprite_width(poles[i].up_pole) < 0) && (sprite_x(poles[i].down_pole) + sprite_width(poles[i].down_pole) < 0))
    {
      reset_pole_data(poles[i]);
    }
  }
}
```
- ```update_poles()``` has only changed to work with our new array of poles instead of just working with a single set of poles. Notice that the procedure is using a ```for``` loop to make sure every set of poles in the array is updated.

#### Addition four (Note: ```draw_poles()``` has had code added to it)
```c    
void draw_poles(poles poles)
{
  int i;

  for (i = 0; i < NUM_POLES; i++)
  {
    draw_sprite(poles[i].up_pole);
    draw_sprite(poles[i].down_pole);
  }
}
```
-  ```draw_poles()``` has only changed to work with our new array of poles instead of just working with a single set of poles. Notice that the procedure is using a ```for``` loop to make sure every set of poles in the array is drawn.

### - Complete Code
The complete code for iteration seven can be found [here](../c/cave_escape_7.cpp).

### - Any Changes to Main
```c
int main()
{
    sprite player;
    poles game_poles;
    int i;

    open_window("Cave Escape", 432, 768);
    load_resource_bundle("CaveEscape", "CaveEscape.txt");

    player = get_new_player();

    for (i = 0; i < NUM_POLES; i++)
    {
      game_poles[i] = get_random_poles();
    }

    do
    {
      process_events();
      clear_screen(ColorWhite);
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
```
Instead of the variable ```game_poles``` being a value of ```pole_data```, it is now a value of our array, ```poles```. We've also added a ```for``` loop to ensure that we set up all of the poles for the game.

### Have a Crack
Now it's time for you to have a go at implementing iteration seven on your own.

---
# 8. Iteration Eight

In iteration eight of Cave Escape, we're going to focus a fair bit on polishing the game in terms of visual aesthetics and code presentation. Visually, the game is going to be practically complete after the eighth iteration. We're going to include a scrolling background for the game to help set the scene. The code tidy up involved in iteration eight is purely for convention and to conform to best practice of having well presented, readable code. This iteration sees the addition of nine new code additions, so it is quite busy.

## What to Expect

Once you're finished working through and implementing iteration eight, you should have something that looks just like this:


![Iteration Eight](imgs/iteration_8.gif)


That scrolling background really complements the theme of the game!

## Code

### - New Code
The new code in iteration eight is as follows:

#### Addition one (Note: There is a new constant value and the constant ```POLE_SCROLL_SPEED``` has been changed to ```FOREGROUND_FOREROOF_POLE_SCROLL_SPEED```)
```c
#define GRAVITY 0.08
#define MAX_SPEED 5
#define JUMP_RECOVERY_BOOST 2
#define FOREGROUND_FOREROOF_POLE_SCROLL_SPEED -2
#define BACKGROUND_SCROLL_SPEED -1
#define NUM_POLES 4
```
- In order to cater for the game's new visual background, we've changed the constant ```POLE_SCROLL_SPEED``` to ```FOREGROUND_FOREROOF_POLE_SCROLL_SPEED```, because the roof element of the background is going to have the same scrolling speed as the poles. We've also added another constant ```BACKGROUND_SCROLL_SPEED``` to store the value at which we want the background to scroll at. These values ```FOREGROUND_FOREROOF_POLE_SCROLL_SPEED``` and ```BACKGROUND_SCROLL_SPEED``` are different because we want to create parallax scrolling.

#### Addition two
```c    
typedef struct background_data
{
  sprite foreroof, foreground, background;
} background_data;
```
- ```background_data()``` has been added to house all the information related to the game's background. Notice it consists of three separate sprites, ```foreroof```, ```foreground``` and ```background```.

#### Addition three
```c    
typedef struct game_data
{
  sprite player;
  background_data scene;
  poles poles;
} game_data;
```
-  The record ```game_data``` has been added to house all the information that the game relies upon, like the player, background and the poles. We'll talk more about this a little later when we discuss how the ```main()``` procedure has changed in this iteration.

#### Addition four
```c    
background_data get_new_background()
{
  background_data result;
  result.background = create_sprite(bitmap_named("Background"));
  sprite_set_x(result.background, 0);
  sprite_set_y(result.background, 0);
  sprite_set_dx(result.background, BACKGROUND_SCROLL_SPEED);

  result.foreground = create_sprite(bitmap_named("Foreground"), animation_script_named("ForegroundAminations"));
  sprite_set_x(result.foreground, 0);
  sprite_set_y(result.foreground, screen_height() - sprite_height(result.foreground));
  sprite_set_dx(result.foreground, FOREGROUND_FOREROOF_POLE_SCROLL_SPEED);
  sprite_start_animation(result.foreground, "Fire");

  result.foreroof = create_sprite(bitmap_named("Foreroof"));
  sprite_set_x(result.foreroof, 0);
  sprite_set_y(result.foreroof, 0);
  sprite_set_dx(result.foreroof, FOREGROUND_FOREROOF_POLE_SCROLL_SPEED);

  return result;
}
```
- Now, we need some logic in order to be able to add the background to the game so that we can see it. Firstly, we've got a new function called ```get_new_background()```, which is responsible for generating the data associated with the background. This function behaves similarly to the functions ```get_new_player()``` and ```get_random_poles()```. ```get_new_background()``` returns a value of ```background_data()```, and as you can see, it is responsible for setting all of the values within the ```background_data()``` record. It sets the sprites for the ```foreroof```, ```foreGround``` and ```background```, as well as their locations and the animation for the ```foreGround``` sprite. Because the background has a scrolling affect, the delta x, or horizontal movement speed of the three sprites have been set accordingly.

#### Addition five

```c
void update_background(background_data *scene)
{
  update_sprite(scene->foreground);
  update_sprite(scene->foreroof);
  update_sprite(scene->background);

  if (sprite_x(scene->foreground) <= -(sprite_width(scene->foreground) / 2))
  {
    sprite_set_x(scene->foreground, 0);
    sprite_set_x(scene->foreroof, 0);
  }
  if (sprite_x(scene->background) <= -(sprite_width(scene->background) / 2))
  {
    sprite_set_x(scene->background, 0);
  }
}
```

- A new procedure called ```update_background()``` has been added to ensure the background wraps continuously around the screen, similar to the fashion in which the poles do. The logic within the procedure makes sure that the game scene always renders the background in a manner which makes the scrolling of the images seem infinite.

#### Addition six
```c
void update_player(sprite player)
{
  update_velocity(player);
  update_sprite(player);
}
```
- The procedure ```update_player()``` has been added so that the logic to update the player can be moved out of the ```main()``` procedure into a separate procedure which focusses exclusively on managing the player element. We've done this to conform to good conventional practice and to apply what is called modular decomposition. Briefly, modular decomposition involves separating code into logical blocks, which are focussed on a specific task, I.e. updating the player.

#### Addition seven
```c
void update_game(game_data* game)
{
  handle_input(game->player);
  update_background(&game->scene);
  update_player(game->player);
  update_poles(game->poles);
}
```
- A procedure called ```update_game()``` has been added, for the same reasons as the procedure ```update_player()```. More application of good practice and a general code tidy up.

#### Addition eight
```c
void draw_game(game_data* game)
{
  draw_sprite(game->scene.background);
  draw_poles(game->poles);
  draw_sprite(game->scene.foreroof);
  draw_sprite(game->scene.foreground);
  draw_sprite(game->player);
}
```
- Yet another procedure has been added to apply modular decomposition to our game. ```draw_game()``` has been created to house all the calls, which are responsible for drawing the game elements to the screen.

#### Addition nine
```c
void set_up_game(game_data* game)
{
  int i;

  load_resource_bundle("CaveEscape", "CaveEscape.txt");
  for (i = 0; i < NUM_POLES; i++)
  {
    game->poles[i] = get_random_poles();
  }
  game->player = get_new_player();
  game->scene = get_new_background();
}
```
- Finally, this big iteration concludes with the addition of a new procedure called ```set_up_game()```. Out of good practice, we've move all the game setup calls from the ```main()``` procedure into a single procedure called ```set_up_game()```. It is here where all the game elements are instantiated, such as the player, background and poles.

### - Complete Code
The complete code for iteration eight can be found [here](../c/cave_escape_8.cpp).

### - A Little Change to Main
```c
int main()
{
    game_data game;

    open_window("Cave Escape", 432, 768);
    set_up_game(&game);

    do
    {
      process_events();
      clear_screen(ColorWhite);
      update_game(&game);
      draw_game(&game);
      refresh_screen(60);

    } while(!window_close_requested("Cave Escape"));

    return 0;
}

```

Look how tidy the ```main()``` procedure looks now after our code tidy up. We now only have a single variable called ```game```, which is a value of ```game_data```. We call our new procedure ```set_up_game()``` before the game loop to set the game up, then in our game loop, we have calls to ```update_game()``` and ```draw_game()```, which handle everything else that the game depends on.

### Have a Crack
Now it's time for you to have a go at implementing iteration eight on your own.

---
# 9. Iteration Nine

Iteration nine is going to be quite a big one too, where there are some big changes to improve gameplay in order to make our game....well, more of a game. In this iteration, we're going to add some music to give the game it's own little soundtrack, which will make the experience more immersive. The big changes, on top of the music, are the addition of collisions, so the player can collide with the environment, a scoring system and the ability to have the game reset if the player does collide with the environment. Iteration nine very nearly implements a completely functional game, ready for shipping.

## What to Expect

Once you're finished working through and implementing iteration nine, you should have something that looks just like this:


![Iteration Nine](imgs/iteration_9.gif)


We're getting closer and closer to a complete game!

## Code

### - New Code
The new code in iteration nine is as follows:

#### Addition one (Note: There is a new constant value)
```c
#define GRAVITY 0.08
#define MAX_SPEED 5
#define JUMP_RECOVERY_BOOST 2
#define FOREGROUND_FOREROOF_POLE_SCROLL_SPEED -2
#define BACKGROUND_SCROLL_SPEED -1
#define NUM_POLES 4
#define GAME_FONT_SIZE 21
```

- We've added a constant called ```GAME_FONT_SIZE``` to represent the game's font size. See Addition 12.

#### Addition two (Note: The record ```pole_data``` has changed)
```c
typedef struct pole_data
{
  bool score_limiter;
  sprite up_pole, down_pole;
} pole_data;
```
- We've added a field to our record ```pole_data``` called ```score_limiter()```. We need this to be able to make the scoring system work. We'll talk more about that soon. Promise.

#### Addition three
```c    
typedef struct player
{
  sprite sprite;
  int score;
  bool is_dead;
} player;
```
- We've added a new record called ```player```. Our player can no longer just be a sprite. If you take a look at the record, you'll notice it has three fields. The first of which is our player sprite. The next being the ```score``` and the third being a field called ```is_dead```. We need this field to tell the game when the player dies, from colliding with the environment.

#### Addition four (Note: The record ```game_data``` has changed)
```c    
typedef struct game_data
{
  player player;
  background_data scene;
  poles poles;
} game_data;
```
- The ```game_data``` record has changed only slightly. Instead of the ```player``` field being just a sprite, it is now a value of our new record ```player```.

#### Addition five (Note: The function ```get_new_player()``` has changed)
```c    
player get_new_player()
{
  player result;
  result.sprite = create_sprite(bitmap_named("Player"), animation_script_named("PlayerAnimations"));
  sprite_set_x(result.sprite, screen_width() / 2 - sprite_width(result.sprite));
  sprite_set_y(result.sprite, screen_height() / 2);
  sprite_start_animation(result.sprite, "Fly");
  result.score = 0;
  result.is_dead = false;

  return result;
}
```
- Our function ```get_new_player()``` has had to change in order to support the new scoring system as well as our collision system. In the function we now set the ```score``` to zero and set the player to be alive when the function is called.

#### Addition six (Note: The function ```get_random_poles()``` has changed)
```c
pole_data get_random_poles()
{
  pole_data result;
  result.up_pole = create_sprite(bitmap_named("UpPole"));
  result.down_pole = create_sprite(bitmap_named("DownPole"));
  sprite_set_x(result.up_pole, screen_width() + rnd(1200));
  sprite_set_y(result.up_pole, screen_height() - sprite_height(result.up_pole) -  rnd(bitmap_height(bitmap_named("Foreground"))));
  sprite_set_x(result.down_pole, sprite_x(result.up_pole));
  sprite_set_y(result.down_pole, rnd(bitmap_height(bitmap_named("Foreroof"))));
  sprite_set_dx(result.up_pole, FOREGROUND_FOREROOF_POLE_SCROLL_SPEED);
  sprite_set_dx(result.down_pole, FOREGROUND_FOREROOF_POLE_SCROLL_SPEED);
  result.score_limiter = true;

  return result;
}
```
- The ```get_random_poles()``` function has also changed. Only slightly, though. Notice that now the function sets the ```pole_data``` value that it returns to have a ```score_limiter()``` value of ```true``` and also, the positioning of the poles in terms of their vertical position is random. Because we have the roof and the floor, we can position the poles more dynamically. Now, we're going to use the ```score_limiter()``` to increment the ```score``` of the player every time they pass a set of poles. Once they pass a set of poles, the player's* ```score``` will be incremented and the ```score_limiter()``` for that set of poles will be set to ```false```. The reasoning behind this will become more clear when we talk about the changes made to ```update_poles()```.

#### Addition seven (Note: The procedure ```update_poles()``` has changed)
```c
void update_poles(game_data *game)
{
  int i;

  for (i = 0; i < NUM_POLES; i++)
  {
    update_sprite(game->poles[i].up_pole);
    update_sprite(game->poles[i].down_pole);

    if ((sprite_x(game->poles[i].up_pole) < sprite_x(game->player.sprite)) && (game->poles[i].score_limiter == true))
    {
      game->poles[i].score_limiter = false;
      game->player.score++;
    }

    if (sprite_offscreen(game->poles[i].up_pole) && sprite_offscreen(game->poles[i].down_pole) && (game->poles[i].score_limiter == false))
    {
      reset_pole_data(&game->poles[i]);
    }
  }
}
```
- Now we're going to take a look at the changes made to ```update_poles()```. Take a close look at the conditional statements in this procedure. In particular, let's focus on this conditional section of code here ```if SpriteX (poles[i].UpPole) < (SpriteX(player.Playing)) then``` to understand why we need the ```score_limiter()```. Firstly, we're checking to see if the player has passed any poles. That's what the first ```if``` statement is checking for. Now, the ```if``` statement inside the first one (we call this nested) is checking to see if the ```score_limiter()``` is ```true```, and ```if``` it is, we then set it to ```false``` and increment the ```Player's``` ```score```. Now, it has to change to ```false``` because, if it never did, once the player passes some poles, the first ```if``` statement would be ```true``` and the ```Player's``` score would keep incrementing because the player would be beyond the poles. Phew. Tongue twisting. The best way to see the bug that this would cause is to remove the nested ```if``` statement and see what happens for yourself.

#### Addition eight
```c
void check_for_collisions(game_data *game)
{
  int i;

  if (sprite_collision(game->player.sprite, game->scene.foreground) || sprite_collision(game->player.sprite, game->scene.foreroof))
  {
    game->player.is_dead = true;
    return;
  }

  for (i = 0; i < NUM_POLES; i++)
  {
    if (sprite_collision(game->player.sprite, game->poles[i].up_pole) || sprite_collision(game->player.sprite, game->poles[i].down_pole))
    {
      game->player.is_dead = true;
      return;
    }
  }
}
```
- We've got a new procedure called ```check_for_collisions()```. The role of this procedure is to check to see if the player has collided with any of the eligible game elements (the poles, the roof and the floor). ```If``` the player does collide with anything that it shouldn't, we set the ```Player's``` ```is_dead``` to ```true```.

#### Addition nine
```c
void reset_player(player *player)
{
  free_sprite(player->sprite);
  *player = get_new_player();
}
```
- Another new procedure called ```reset_player()``` has been added to reset the ```player``` to a default state. When we mention default state, we mean a new game where the score is zero and the player has to start over. This procedure is only used when the ```player``` dies (collides with the environment).

#### Addition ten
```c
void reset_game(game_data *game)
{
  int i;

  reset_player(&game->player);
  for (i = 0; i < NUM_POLES; i++)
  {
    reset_pole_data(&game->poles[i]);
  }
}
```
- A procedure called ```reset_game()``` has been added to reset the game to the default state. This procedure is only used when the player dies.

#### Addition eleven (Note: The procedure ```update_game()``` has changed)
```c
void update_game(game_data *game)
{
  if (!game->player.is_dead)
  {
    check_for_collisions(game);
    handle_input(game->player.sprite);
    update_background(game->scene);
    update_player(game->player.sprite);
    update_poles(game);
  }
  else
  {
    reset_game(game);
  }
}
```
- The procedure ```update_game()``` has changed in order to act upon the player dying. So, as long as the player is not dead, we want the game to run normally, you know, with poles scrolling across the screen that the player has to avoid. If the player has died, ```update_game()``` knows when that happens and will reset the game.

#### Addition twelve (Note: The procedure ```draw_game()``` has changed)
```c
void draw_game(game_data* game)
{
  char str[15];
  sprintf(str, "%d", game->player.score);

  draw_sprite(game->scene.background);
  draw_poles(game->poles);
  draw_sprite(game->scene.foreroof);
  draw_sprite(game->scene.foreground);
  draw_sprite(game->player.sprite);
  draw_text(str, COLOR_WHITE, "GameFont", GAME_FONT_SIZE, 10, 0);
}
```
- Finally, ```draw_game()``` has changed to simply draw the score to the top left of the screen so that we can see how good....or bad we are at playing.

### - Complete Code
The complete code for iteration nine can be found [here](../c/cave_escape_9.cpp).

### - You're the Same, Main
Main has not changed.

### Have a Crack
Now it's time for you to have a go at implementing iteration nine on your own.

---
# 10. Iteration Ten

Iteration ten is the final iteration for the game! In this final iteration we will add a menu to the game so that it only starts when the player is ready.

## What to Expect

Once you're finished working through and implementing iteration ten, you should have something that looks just like this:


![Iteration Ten](imgs/iteration_10.gif)


We're done now!

## Code

### - New Code
The new code in iteration ten is as follows:

#### Addition one
```c
enum player_state{MENU, PLAY};
```
- We've added an enumeration called ```player_state``` with two values, ```MENU``` and ```PLAY```. This enumeration is going to be used to help the game determine whether or not to show the menu or to let the player play.

#### Addition two (Note: The record ```player``` has changed)
```c    
typedef struct player
{
  sprite sprite;
  int score;
  bool is_dead;
  player_state state;
} player;
```
-  Now because of the addition of the enumeration ```player_state```, we've changed the ```player``` record to house the current game state. The new field is called ```State```.

#### Addition three (Note: The function ```get_new_player()``` has changed)
```c    
player get_new_player()
{
  player result;
  result.sprite = create_sprite(bitmap_named("Player"), animation_script_named("PlayerAnimations"));
  sprite_set_x(result.sprite, screen_width() / 2 - sprite_width(result.sprite));
  sprite_set_y(result.sprite, screen_height() / 2);
  sprite_start_animation(result.sprite, "Fly");
  result.score = 0;
  result.is_dead = false;
  result.state = MENU;

  return result;
}
```
- The function ```get_new_player()``` has changed to set the value of the ```players's``` new field ```state``` to ```MENU```. This way, we can ensure that the game starts in the menu state.

#### Addition four (Note: The procedure ```handle_input()``` has changed)
```c    
void handle_input(sprite player, player_state* state)
{
  if (key_typed(SPACE_KEY) && (*state = PLAY))
  {
    sprite_set_dy(player, sprite_dy(player) - JUMP_RECOVERY_BOOST);
  }
  else if (key_typed(SPACE_KEY))
  {
    *state = PLAY;
  }
}
```
- The procedure ```handle_input()``` has changed to accommodate for the new menu state being implemented. Basically, the change ensures that ```if``` the game hasn't started yet (the ```player's``` ```state``` is ```MENU```) and the player presses the space bar, we want to set the ```players's``` ```state``` to ```PLAY```. If the player is already playing, then just handle the input like we normally would by boosting the player's velocity.

#### Addition five (Note: The procedure ```update_player()``` has changed)
```c
void update_player(sprite player, player_state state)
{
  if (state == PLAY)
  {
    update_velocity(player);
  }
  update_sprite(player);
}
```
- ```update_player()``` has also changed to suit the new menu state. The changes made ensure that we only update the player's velocity ```if``` the current ```state``` is set to ```PLAY```. Otherwise, the player will just hover in the middle of the screen. We're doing this so that the player only starts moving when we are ready to play!

#### Addition six (Note: The procedure ```update_game()``` has changed)
```c
void update_game(game_data *game)
{
  if (!game->player.is_dead)
  {
    check_for_collisions(game);
    handle_input(game->player.sprite, &game->player.state);
    update_background(game->scene);
    update_player(game->player.sprite, game->player.state);
    if (game->player.state == PLAY)
    {
      update_poles(game);
    }
  }
  else
  {
    reset_game(game);
  }
}
```
- ```update_game()``` also has a change to suit the menu state. The changes ensure that the poles only scroll across the screen if the player has started playing the game.

#### Addition seven (Note: The procedure ```draw_game()``` has changed)
```c
void draw_game(game_data* game)
{
  char str[15];
  sprintf(str, "%d", game->player.score);

  draw_sprite(game->scene.background);
  draw_poles(game->poles);
  draw_sprite(game->scene.foreroof);
  draw_sprite(game->scene.foreground);
  draw_sprite(game->player.sprite);
  if (game->player.state == PLAY)
  {
    draw_text(str, COLOR_WHITE, "GameFont", GAME_FONT_SIZE, 10, 0);
  }
  else if (game->player.state == MENU)
  {
    draw_bitmap(bitmap_named("Logo"), 0, 40);
    draw_text("PRESS SPACE!",
    COLOR_WHITE,
    "GameFont",
    screen_width() / 2 - text_width(font_named("GameFont"), "PRESS SOACE!") / 2,
    sprite_y(game->player.sprite) + text_height(font_named("GameFont"), " ") * 2);
  }
}

```
- Finally, ```draw_game()``` also has some minor changes. This is where we're drawing our new menu. So, ```if``` the player is not playing the game yet, we draw a menu to the screen for them, giving them instructions on how to start playing.

### - Complete Code
The complete code for iteration ten can be found [here](../c/cave_escape_10.cpp).

### - Main Remains the Same
It really does.

### Have a Crack
Now it's time for you to have a go at implementing iteration ten on your own. You've done really well and you're pretty much done!
