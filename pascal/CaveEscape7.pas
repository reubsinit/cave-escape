program GameMain;
uses SplashKit, sysUtils;

const
  GRAVITY = 0.08;
  MAX_SPEED = 5;
  JUMP_RECOVERY_BOOST = 2;
  POLE_SCROLL_SPEED = -2;
  NUM_POLES = 4;
  GAME_FONT_SIZE = 21;

type
  PoleData = record
    UpPole: Sprite;
    DownPole: Sprite;
  end;

  Poles = array [0..NUM_POLES - 1] of PoleData;

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

procedure ResetPoleData(var poles: PoleData);
begin
  FreeSprite(poles.UpPole);
  FreeSprite(poles.DownPole);
  poles := GetRandomPoles();
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

procedure UpdatePoles(var poles: Poles);
var
  i: Integer;
begin
  for i:= Low(poles) to High(poles) do
  begin
    UpdateSprite(poles[i].UpPole);
    UpdateSprite(poles[i].DownPole);

    if ((SpriteX(poles[i].UpPole) + SpriteWidth(poles[i].UpPole)) < 0) and ((SpriteX(poles[i].DownPole) + SpriteWidth(poles[i].DownPole)) < 0) then
    begin
      ResetPoleData(poles[i]);
    end;
  end;
end;

procedure DrawPoles(poles: Poles);
var
  i: Integer;
begin
  for i:= Low(poles) to High(poles) do
  begin
    DrawSprite(poles[i].UpPole);
    DrawSprite(poles[i].DownPole);
  end;
end;

procedure Main();
var
  player: Sprite;
  gamePoles: Poles;
  i: Integer;
begin
  OpenWindow('Cave Escape', 432, 768);
  LoadResourceBundle('CaveEscape', 'CaveEscape.txt');

  player := GetNewPlayer();

  for i:= Low(gamePoles) to High(gamePoles) do
  begin
    gamePoles[i] := GetRandomPoles();
  end;

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
