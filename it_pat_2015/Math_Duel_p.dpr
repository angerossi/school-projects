program Math_Duel_p;

uses
  Forms,
  Math_Duel_u in 'Math_Duel_u.pas' {frmMainMenu},
  Game2p_u in 'gamefiles2\Game2p_u.pas' {frmMathDuelGameMulti},
  Game1p_u in 'gamefiles1\Game1p_u.pas' {frmMathDuelGameSingle};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMainMenu, frmMainMenu);
  Application.CreateForm(TfrmMathDuelGameMulti, frmMathDuelGameMulti);
  Application.CreateForm(TfrmMathDuelGameSingle, frmMathDuelGameSingle);
  Application.Run;
end.
