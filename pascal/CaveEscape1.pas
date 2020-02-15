program GameMain;
uses SplashKit, sysUtils;

procedure Main();
begin
  OpenWindow('Cave Escape', 432, 768);

  repeat // The game loop...
    ProcessEvents();
    ClearScreen(ColorWhite);
    RefreshScreen(60);
  until WindowCloseRequested('Cave Escape');
end;

begin
  Main();
end.
