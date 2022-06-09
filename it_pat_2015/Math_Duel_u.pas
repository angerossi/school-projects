unit Math_Duel_u;     //Angelo Rossi

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, jpeg, ComCtrls, ShellApi;

type
  TfrmMainMenu = class(TForm)
    pgcMathDuel: TPageControl;
    tbsMainMenu: TTabSheet;
    tbsMultiplayer: TTabSheet;
    tbsSingleplayer: TTabSheet;
    tbsInstructions: TTabSheet;
    tbsHighScores: TTabSheet;
    pnlMathDuel: TPanel;
    lblMathDuel: TLabel;
    lblSlogan: TLabel;
    btnMulti: TButton;
    imgPVP: TImage;
    btnSingle: TButton;
    imgPVE: TImage;
    bmbExit: TBitBtn;
    btnInstr: TButton;
    btnHS: TButton;
    btnCredits: TButton;
    pnlCharSelMul: TPanel;
    lblCharSelMul: TLabel;
    grbP1: TGroupBox;
    lblCharName1: TLabel;
    edtCharName1: TEdit;
    rdgCharSel1: TRadioGroup;
    grbP2: TGroupBox;
    lblCharName2: TLabel;
    edtCharName2: TEdit;
    rdgCharSel2: TRadioGroup;
    btnBackMulti: TButton;
    btnProceedMul: TButton;
    pnlCharSelSin: TPanel;
    lblCharSelSin: TLabel;
    grbPlayer: TGroupBox;
    lblCharNamePlayer: TLabel;
    edtCharNamePlayer: TEdit;
    rdgCharSelPlayer: TRadioGroup;
    grbAI: TGroupBox;
    rdgCharSelAI: TRadioGroup;
    btnBackSingle: TButton;
    btnProceedSin: TButton;
    pnlInstructions: TPanel;
    lblInstructions: TLabel;
    memInstr: TMemo;
    btnBackInstr: TButton;
    pnlHS: TPanel;
    lblHS: TLabel;
    lblHighestSlbl: TLabel;
    lblHighestS: TLabel;
    memHS: TMemo;
    btnBackHS: TButton;
    lblBeta: TLabel;
    lvlVersion: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure btnMultiClick(Sender: TObject);
    procedure btnSingleClick(Sender: TObject);
    procedure btnInstrClick(Sender: TObject);
    procedure btnHSClick(Sender: TObject);
    procedure btnBackMultiClick(Sender: TObject);
    procedure btnBackSingleClick(Sender: TObject);
    procedure btnBackInstrClick(Sender: TObject);
    procedure btnBackHSClick(Sender: TObject);
    procedure btnProceedMulClick(Sender: TObject);
    procedure btnProceedSinClick(Sender: TObject);
    procedure btnCreditsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }


        sCharNameP1, sCharNameP2 : string;
        iCharP1, iCharP2, iCharAI : integer;

/////////////////////////////////////////////////////////////////////////


  end;

var
  frmMainMenu: TfrmMainMenu;

implementation

uses Game2p_u, Game1p_u;



{$R *.dfm}

procedure TfrmMainMenu.FormActivate(Sender: TObject);
begin
     frmMainMenu.Visible := true;
     frmMathDuelGameMulti.Visible := false;
     frmMathDuelGameSingle.Visible := false;

     pgcMathDuel.Pages[0].TabVisible := false;
     pgcMathDuel.Pages[1].TabVisible := false;
     pgcMathDuel.Pages[2].TabVisible := false;
     pgcMathDuel.Pages[3].TabVisible := false;
     pgcMathDuel.Pages[4].TabVisible := false;

     pgcMathDuel.ActivePage := tbsMainMenu;



end;


procedure TfrmMainMenu.btnHSClick(Sender: TObject);
begin
     pgcMathDuel.ActivePage := tbsHighScores;
end;

procedure TfrmMainMenu.btnBackMultiClick(Sender: TObject);
begin
     pgcMathDuel.ActivePage := tbsMainMenu;
end;

procedure TfrmMainMenu.btnBackSingleClick(Sender: TObject);
begin
     pgcMathDuel.ActivePage := tbsMainMenu;
end;

procedure TfrmMainMenu.btnBackInstrClick(Sender: TObject);
begin
     pgcMathDuel.ActivePage := tbsMainMenu;
end;

procedure TfrmMainMenu.btnBackHSClick(Sender: TObject);
begin
     pgcMathDuel.ActivePage := tbsMainMenu;
end;

procedure TfrmMainMenu.btnSingleClick(Sender: TObject);
begin
     pgcMathDuel.ActivePage := tbsSingleplayer;
     edtCharNamePlayer.Clear;                                      //Reset input
     edtCharNamePlayer.SetFocus;
     rdgCharSelPlayer.ItemIndex := -1;
     rdgCharSelAI.ItemIndex := -1;
end;

procedure TfrmMainMenu.btnMultiClick(Sender: TObject);
begin
     pgcMathDuel.ActivePage := tbsMultiplayer;

     edtCharName1.Clear;                                           //Reset input
     edtCharName2.clear;
     edtCharName1.SetFocus;
     rdgCharSel1.ItemIndex := -1;
     rdgCharSel2.ItemIndex := -1;
end;

procedure TfrmMainMenu.btnCreditsClick(Sender: TObject);
begin
     ShellExecute(handle,'open',PChar('scratchfiles\CREDITS.sb2'), '','',SW_MAXIMIZE);
end;

procedure TfrmMainMenu.btnInstrClick(Sender: TObject);
begin
     pgcMathDuel.ActivePage := tbsInstructions;
     memInstr.Lines.LoadFromFile('INSTRUCTIONS.txt');
     memInstr.ReadOnly := True;
end;

procedure TfrmMainMenu.btnProceedMulClick(Sender: TObject);      //User input validation for multiplayer
var
    iLoopCtrl1, iLoopCtrl2, iLengthP1, iLengthP2, iFail, iFail2, iFail3 : integer;

begin
     sCharNameP1 := edtCharName1.Text;
     sCharNameP2 := edtCharName2.Text;

     iLengthP1 := Length(sCharNameP1);
     iLengthP2 := Length(sCharNameP2);
     iFail := 0;
     iFail2 := 0;
     iFail3 := 0;

     if (edtCharName1.Text = '') or (edtCharName2.Text = '') then     //Tests if the names are the same
        iFail := 1;

     for iLoopCtrl1 := 1 to iLengthP1 do
     begin
          if iFail = 0 then
          begin
               if sCharNameP1[iLoopCtrl1] in ['a'..'z','A'..'Z'] then    //Tests if the name is only letters
               else
                   iFail := 1;
          end;
     end;


     for iLoopCtrl2 := 1 to iLengthP2 do
     begin
          if iFail = 0 then
          begin
               if sCharNameP2[iLoopCtrl2] in ['a'..'z','A'..'Z'] then    //Tests if the name is only letters
               else
                   iFail := 1;
          end;
     end;

     if sCharNameP1 = sCharNameP2 then
        iFail3 := 1;

     if rdgCharSel1.ItemIndex = -1 then
        iFail2 := 1;

     if rdgCharSel2.ItemIndex = -1 then
        iFail2 := 1;


     if (iFail = 1) and (iFail2 = 0) and (iFail3 = 0) then
        ShowMessage('Please enter a valid character name (Only letters)');

     if (iFail = 0) and (iFail2 = 1) and (iFail3 = 0) then
        ShowMessage('Please choose a character');

     if (iFail = 0) and (iFail2 = 0) and (iFail3 = 1) then
        ShowMessage('Please enter different character names');

     if (iFail = 1) and (iFail2 = 1) and (iFail3 = 0) then
        ShowMessage('Please enter a valid character name (Only letters) and choose a character');

     if (iFail = 0) and (iFail2 = 1) and (iFail3 = 1) then
        ShowMessage('Please enter different character names and choose a character');

     if (iFail = 1) and (iFail2 = 0) and (iFail3 = 1) then
        ShowMessage('Please enter a valid character name and enter different character names');

     if (iFail = 1) and (iFail2 = 1) and (iFail3 = 1) then
        ShowMessage('Please enter a valid character name, enter different character names and choose a character');


     if (iFail = 0) and (iFail2 = 0) and (iFail3 = 0) then          //If no input errors are present, saves names and switches forms
     begin
          iCharP1 := rdgCharSel1.ItemIndex;
          iCharP2 := rdgCharSel2.ItemIndex;
          frmMainMenu.Hide;
          frmMathDuelGameMulti.Show
     end;

end;

procedure TfrmMainMenu.btnProceedSinClick(Sender: TObject);      //User Input validation for Singleplayer
var
    iLoopCtrl, iLength, iFail, iFail2, iFail3 : integer;
begin
     sCharNameP1 := edtCharNamePlayer.Text;

     iLength := Length(sCharNameP1);
     iFail := 0;
     iFail2 := 0;
     iFail3 := 0;

     if (edtCharNamePlayer.Text = '') then
        iFail := 1;

     for iLoopCtrl := 1 to iLength do
     begin
          if iFail = 0 then
          begin
               if sCharNameP1[iLoopCtrl] in ['a'..'z','A'..'Z'] then
               else
                   iFail := 1;
          end;
     end;

     if rdgCharSelPlayer.ItemIndex = -1 then
        iFail2 := 1;

     if rdgCharSelAI.ItemIndex = -1 then
        iFail3 := 1;


     if (iFail = 1) and (iFail2 = 0) and (iFail3 = 0) then
        ShowMessage('Please enter a valid character name (Only letters)');

     if (iFail = 0) and (iFail2 = 1) and (iFail3 = 0) then
        ShowMessage('Please choose a character');

     if (iFail = 0) and (iFail2 = 0) and (iFail3 = 1) then
        ShowMessage('Please choose an AI difficulty');

     if (iFail = 1) and (iFail2 = 1) and (iFail3 = 0) then
        ShowMessage('Please enter a valid character name (Only letters) and choose a character');

     if (iFail = 0) and (iFail2 = 1) and (iFail3 = 1) then
        ShowMessage('Please choose a character and an AI difficulty');

     if (iFail = 1) and (iFail2 = 0) and (iFail3 = 1) then
        ShowMessage('Please enter a valid character name and choose an AI difficulty');

     if (iFail = 1) and (iFail2 = 1) and (iFail3 = 1) then
        ShowMessage('Please enter a valid character name, choose a character and choose a character');


     if (iFail = 0) and (iFail2 = 0) and (iFail3 = 0) then
     begin
          iCharP1 := rdgCharSelPlayer.ItemIndex;
          iCharAI := rdgCharSelAI.ItemIndex;
          frmMainMenu.Hide;
          frmMathDuelGameSingle.Show;
     end;
end;



end.
