program GameMain;
uses SplashKit, sysUtils;

const
  GRAVITY = 0.08;
  MAX_SPEED = 5;
  JUMP_RECOVERY_BOOST = 2;
  FOREGROUND_FOREROOF_POLE_SCROLL_SPEED = -2;
  BACKGROUND_SCROLL_SPEED = -1;
  NUM_POLES = 4;
  GAME_FONT_SIZE = 21;

type
    PoleData = record
      ScoreLimiter: Boolean;
      UpPole: Sprite;
      DownPole: Sprite;
    end;

    Poles = array [0..NUM_POLES] of PoleData;

    GamePoles = record
      ReleaseDistance: Integer;
      Poles: Poles;
    end;

    PlayerState = (Menu, Play);

    BackgroundData = record
      Foreroof: Sprite;
      Foreground: Sprite;
      Background: Sprite;
    end;

    Player = record
      Sprite: Sprite;
      Score: Integer;
      IsDead: Boolean;
      State: PlayerState;
    end;

    GameData = record
      Player: Player;
      Scene: BackgroundData;
      GamePoles: GamePoles;
    end;

function GetNewPlayer(): Player;
begin
  result.Sprite := CreateSprite(BitmapNamed('Player'), AnimationScriptNamed('PlayerAnimations'));
  SpriteSetX(result.Sprite, ScreenWidth() / 2 - SpriteWidth(result.Sprite));
  SpriteSetY(result.Sprite, ScreenHeight() / 2);
  SpriteStartAnimation(result.Sprite, 'Fly');
  result.Score := 0;
  result.IsDead := false;
  result.State := Menu;
end;

function GetRandomPoles(): PoleData;
begin
  result.UpPole := CreateSprite(BitmapNamed('UpPole'));
  result.DownPole := CreateSprite(BitmapNamed('DownPole'));
  SpriteSetX(result.UpPole, ScreenWidth());
  SpriteSetY(result.UpPole, ScreenHeight() - SpriteHeight(result.UpPole) - RND(BitmapHeight(BitmapNamed('Foreground'))));
  SpriteSetX(result.DownPole, SpriteX(result.UpPole));
  SpriteSetY(result.DownPole, RND(BitmapHeight(BitmapNamed('Foreroof'))));
  SpriteSetDx(result.UpPole, 0);
  SpriteSetDx(result.DownPole, 0);
  result.ScoreLimiter := true;
end;

function GetNewBackground(): BackgroundData;
begin
  result.Background := CreateSprite(BitmapNamed('Background'));
  SpriteSetX(result.Background, 0);
  SpriteSetY(result.Background, 0);
  SpriteSetDx(result.Background, BACKGROUND_SCROLL_SPEED);

  result.Foreground := CreateSprite(BitmapNamed('Foreground'), AnimationScriptNamed('ForegroundAminations'));
  SpriteSetX(result.Foreground, 0);
  SpriteSetY(result.Foreground, ScreenHeight() - SpriteHeight(result.Foreground));
  SpriteSetDx(result.Foreground, FOREGROUND_FOREROOF_POLE_SCROLL_SPEED);
  SpriteStartAnimation(result.Foreground, 'Fire');

  result.Foreroof := CreateSprite(BitmapNamed('Foreroof'));
  SpriteSetX(result.Foreroof, 0);
  SpriteSetY(result.Foreroof, 0);
  SpriteSetDx(result.Foreroof, FOREGROUND_FOREROOF_POLE_SCROLL_SPEED);
end;

procedure HandleInput(var player: Player);
begin
  if KeyTyped(SPACE_KEY) and (player.State = Play) then
  begin
    SpriteSetDy(player.Sprite, SpriteDy(player.Sprite) - JUMP_RECOVERY_BOOST);
  end
  else if KeyTyped(SPACE_KEY) then
  begin
    player.State := Play;
  end;
end;

procedure CheckForCollisions(var game: GameData);
var
  i: Integer;
begin
  if (SpriteCollision(game.Player.Sprite, game.Scene.Foreground)) or (SpriteCollision(game.Player.Sprite, game.Scene.Foreroof)) then
  begin
    game.Player.IsDead := true;
    exit;
  end;

  for i := Low(game.GamePoles.Poles) to High(game.GamePoles.Poles) do
  begin
    if SpriteCollision(game.Player.Sprite, game.GamePoles.Poles[i].UpPole) or SpriteCollision(game.Player.Sprite, game.GamePoles.Poles[i].DownPole)then
    begin
      game.Player.IsDead := true;
      exit;
    end;
  end;
end;

procedure MarkPoleForMovement(var poles: Poles; var releaseDistance: Integer);
var
  i: Integer;
begin
  releaseDistance += FOREGROUND_FOREROOF_POLE_SCROLL_SPEED;
  if releaseDistance <= 0 then
  begin
    for i := Low(poles) to High(poles) do
    begin
      if SpriteDx(poles[i].UpPole) = 0 then
      begin
        SpriteSetDx(poles[i].UpPole, FOREGROUND_FOREROOF_POLE_SCROLL_SPEED);
        SpriteSetDx(poles[i].DownPole, FOREGROUND_FOREROOF_POLE_SCROLL_SPEED);
        releaseDistance := BitmapWidth(BitmapNamed('UpPole')) + RND(BitmapWidth(BitmapNamed('UpPole')));
        break;
      end;
    end;
  end;
end;

procedure ResetPoleData(var pole: PoleData);
begin
  FreeSprite(pole.UpPole);
  FreeSprite(pole.DownPole);
  pole := GetRandomPoles();
end;

procedure ResetPlayer(var player: Player);
begin
  FreeSprite(player.Sprite);
  player := GetNewPlayer();
end;

procedure ResetGame(var game: GameData);
var
  i: Integer;
begin
  ResetPlayer(game.Player);
  for i:= Low(game.GamePoles.Poles) to High(game.GamePoles.Poles) do
  begin
    ResetPoleData(game.GamePoles.Poles[i]);
  end;
end;

procedure UpdateVelocity(player: Sprite);
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

procedure UpdatePoles(var poles: Poles; var releaseDistance: Integer; var player: Player);
var
  i: Integer;
begin
  MarkPoleForMovement(poles, releaseDistance);
  for i:= Low(poles) to High(poles) do
  begin
    UpdateSprite(poles[i].UpPole);
    UpdateSprite(poles[i].DownPole);

    if SpriteX (poles[i].UpPole) < (SpriteX(player.Sprite)) then
    begin
      if (poles[i].ScoreLimiter = true) then
      begin
        poles[i].ScoreLimiter := false;
        player.Score += 1;
      end;
    end;

    if ((SpriteX(poles[i].UpPole) + SpriteWidth(poles[i].UpPole)) < 0) and ((SpriteX(poles[i].DownPole) + SpriteWidth(poles[i].DownPole)) < 0) and (poles[i].ScoreLimiter = false) then
    begin
      ResetPoleData(poles[i]);
    end;
  end;
end;

procedure UpdateBackground(var scene: BackgroundData);
begin
  UpdateSprite(scene.ForeGround);
  UpdateSprite(scene.Foreroof);
  updateSprite(scene.Background);
  if (SpriteX(scene.Foreground) <= -(SpriteWidth(scene.ForeGround) / 2)) then
  begin
    SpriteSetX(scene.Foreground, 0);
    SpriteSetX(scene.Foreroof, 0);
  end;
  if (SpriteX(scene.Background) <= -(SpriteWidth(scene.Background) / 2)) then
  begin
    SpriteSetX(scene.Background, 0);
  end;
end;

procedure UpdatePlayer(player: Player);
begin
  if (player.State = Play) then
  begin
    UpdateVelocity(player.Sprite);
  end;
  UpdateSprite(player.Sprite);
end;

procedure UpdateGame(var game: GameData);
begin
  if not (game.Player.IsDead) then
  begin
    CheckForCollisions(game);
    HandleInput(game.Player);
    UpdateBackground(game.Scene);
    UpdatePlayer(game.Player);
    if (game.Player.State = Play) then
    begin
      UpdatePoles(game.GamePoles.Poles, game.GamePoles.ReleaseDistance, game.Player);
    end;
  end
  else //The player has died :(
  begin
    ResetGame(game);
  end;
end;

procedure DrawPoles(const poles: Poles);
var
  i: Integer;
begin
  for i:= Low(poles) to High(poles) do
  begin
    DrawSprite(poles[i].UpPole);
    DrawSprite(poles[i].DownPole);
  end;
end;

procedure DrawGame(const game: GameData);
begin
  DrawSprite(game.Scene.Background);
  DrawPoles(game.GamePoles.Poles);
  DrawSprite(game.Scene.Foreroof);
  DrawSprite(game.Scene.ForeGround);
  DrawSprite(game.Player.Sprite);
  if (game.Player.State = Play) then
  begin
    DrawText(IntToStr(game.Player.Score), ColorWhite, 'GameFont', GAME_FONT_SIZE, 10, 0);
  end
  else if (game.Player.State = Menu) then
  begin
    DrawBitmap(BitmapNamed('Logo'), 0, 40);
    DrawText('PRESS SPACE!',
    ColorWhite,
    'GameFont',
    GAME_FONT_SIZE,
    ScreenWidth() / 2 - TextWidth('PRESS SPACE!', FontNamed('GameFont'), GAME_FONT_SIZE) / 2,
    SpriteY(game.Player.Sprite) + TextHeight(' ', FontNamed('GameFont'), GAME_FONT_SIZE) * 2);
  end;
end;

procedure SetUpGame(var game: GameData);
var
  i: Integer;
begin
  LoadResourceBundle('CaveEscape', 'CaveEscape.txt');
  for i:= Low(game.GamePoles.Poles) to High(game.GamePoles.Poles) do
  begin
    game.GamePoles.Poles[i] := GetRandomPoles();
  end;
  game.GamePoles.ReleaseDistance := 0;
  game.Player.State := Menu;
  game.Player := GetNewPlayer();
  game.Scene := GetNewBackground();
  FadeMusicIn('GameMusic', -1, 15000);
end;

procedure Main();
var
  game: GameData;
begin
  OpenWindow('Cave Escape', 432, 768);
  SetUpGame(game);

  repeat // The game loop...
    ProcessEvents();
    ClearScreen(ColorWhite);
    UpdateGame(game);
    DrawGame(game);
    RefreshScreen(60);
  until WindowCloseRequested('Cave Escape');
end;

begin
  Main();
end.
