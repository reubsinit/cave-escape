program GameMain;
uses SplashKit, sysUtils;

function GetNewPlayer(): Sprite;
begin
  result := CreateSprite(BitmapNamed('Player'), AnimationScriptNamed('PlayerAnimations'));
  SpriteSetX(result, ScreenWidth() / 2 - SpriteWidth(result));
  SpriteSetY(result, ScreenHeight() / 2);
  SpriteStartAnimation(result, 'Fly');
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
    UpdateSprite(player);
    DrawSprite(player);
    RefreshScreen(60);
  until WindowCloseRequested('Cave Escape');
end;

begin
  Main();
end.
