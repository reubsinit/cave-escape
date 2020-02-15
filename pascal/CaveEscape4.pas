program GameMain;
uses SplashKit, sysUtils;

const
  GRAVITY = 0.08;
  MAX_SPEED = 5;
  JUMP_RECOVERY_BOOST = 2;

function GetNewPlayer(): Sprite;
begin
  result := CreateSprite(BitmapNamed('Player'), AnimationScriptNamed('PlayerAnimations'));
  SpriteSetX(result, ScreenWidth() / 2 - SpriteWidth(result));
  SpriteSetY(result, ScreenHeight() / 2);
  SpriteStartAnimation(result, 'Fly');
end;

procedure HandleInput(var player: Sprite);
begin
  if KeyTyped(SPACE_KEY) then
  begin
    SpriteSetDy(player, SpriteDy(player) - JUMP_RECOVERY_BOOST);
  end;
end;

procedure UpdateVelocity(var player: Sprite);
begin
  SpriteSetDy(player, SpriteDy(player) + GRAVITY);

  if SpriteDy(player) > MAX_SPEED then
  begin
    SpriteSetDy(player, MAX_SPEED);
  end
  else if SpriteDy(player) < -(MAX_SPEED) then
  begin
    SpriteSetDy(player, -(MAX_SPEED));
  end;
end;

procedure Main();
var
  player: Sprite;
begin
  OpenWindow('Cave Escape', 432, 768);
  LoadResourceBundle('CaveEscape', 'CaveEscape.txt');

  player := GetNewPlayer();

  repeat // The game loop...
    ProcessEvents();
    ClearScreen(ColorWhite);
    UpdateVelocity(player);
    HandleInput(player);
    UpdateSprite(player);
    DrawSprite(player);
    RefreshScreen(60);
  until WindowCloseRequested('Cave Escape');
end;

begin
  Main();
end.
