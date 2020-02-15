program GameMain;
uses SplashKit, sysUtils;

const
  GRAVITY = 0.08;
  MAX_SPEED = 5;
  JUMP_RECOVERY_BOOST = 2;
  POLE_SCROLL_SPEED = -2;

type
  PoleData = record
    UpPole: Sprite;
    DownPole: Sprite;
  end;

function GetNewPlayer(): Sprite;
begin
  result := CreateSprite(BitmapNamed('Player'), AnimationScriptNamed('PlayerAnimations'));
  SpriteSetX(result, ScreenWidth() / 2 - SpriteWidth(result));
  SpriteSetY(result, ScreenHeight() / 2);
  SpriteStartAnimation(result, 'Fly');
end;

function GetRandomPoles(): PoleData;
begin
  result.UpPole := CreateSprite(BitmapNamed('UpPole'));
  result.DownPole := CreateSprite(BitmapNamed('DownPole'));
  SpriteSetX(result.UpPole, ScreenWidth() + RND(1200));
  SpriteSetY(result.UpPole, ScreenHeight() - SpriteHeight(result.UpPole));
  SpriteSetX(result.DownPole, SpriteX(result.UpPole));
  SpriteSetY(result.DownPole, 0);
  SpriteSetDx(result.UpPole, POLE_SCROLL_SPEED);
  SpriteSetDx(result.DownPole, POLE_SCROLL_SPEED);
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

procedure UpdatePoles(var poles: PoleData);
begin
  UpdateSprite(poles.UpPole);
  UpdateSprite(poles.DownPole);
end;

procedure DrawPoles(poles: PoleData);
begin
  DrawSprite(poles.UpPole);
  DrawSprite(poles.DownPole);
end;

procedure Main();
var
  player: Sprite;
  gamePoles: PoleData;
begin
  OpenWindow('Cave Escape', 432, 768);
  LoadResourceBundle('CaveEscape', 'CaveEscape.txt');

  player := GetNewPlayer();

  gamePoles := GetRandomPoles();

  repeat // The game loop...
    ProcessEvents();
    ClearScreen(ColorWhite);
    UpdateVelocity(player);
    HandleInput(player);
    UpdateSprite(player);
    DrawSprite(player);
    UpdatePoles(gamePoles);
    DrawPoles(gamePoles);
    RefreshScreen(60);
  until WindowCloseRequested('Cave Escape');
end;

begin
  Main();
end.
