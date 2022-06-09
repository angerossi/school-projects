unit Game2p_u;             //Angelo Rossi


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, ComCtrls, ShellApi;

type
  TfrmMathDuelGameMulti = class(TForm)
    pnlHP1: TPanel;
    lblP1: TLabel;
    lblHP1: TLabel;
    pgbHP1: TProgressBar;
    pnlHP2: TPanel;
    lblP2: TLabel;
    lblHP2: TLabel;
    pgbHP2: TProgressBar;
    lblQuestionT1: TLabel;
    lblQuestionP1: TLabel;
    imgCharP1: TImage;
    imgCharP2: TImage;
    pnlAnswerP1: TPanel;
    btnP1A: TButton;
    btnP1B: TButton;
    btnP1C: TButton;
    btnP1D: TButton;
    pnlAnswerP2: TPanel;
    btnP2A: TButton;
    btnP2D: TButton;
    btnP2C: TButton;
    btnP2B: TButton;
    pnlP2Block: TPanel;
    lblQuestionT2: TLabel;
    lblQuestionP2: TLabel;
    pnlP1Block: TPanel;
    tmrP1Question: TTimer;
    btnNextQP1: TButton;
    btnNextQP2: TButton;
    lblMiss: TLabel;
    tmrP2Question: TTimer;
    tmrP1CharMove: TTimer;
    tmrP2CharMove: TTimer;
    imgSpellP1: TImage;
    pnlQuestionP1: TPanel;
    pnlQuestionP2: TPanel;
    imgArrowP1: TImage;
    imgArrowP2: TImage;
    imgSpellP2: TImage;
    procedure btnNextQP1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnP1AClick(Sender: TObject);
    procedure btnP1BClick(Sender: TObject);
    procedure btnP1CClick(Sender: TObject);
    procedure btnP1DClick(Sender: TObject);
    procedure btnNextQP2Click(Sender: TObject);
    procedure btnP2AClick(Sender: TObject);
    procedure btnP2BClick(Sender: TObject);
    procedure btnP2CClick(Sender: TObject);
    procedure btnP2DClick(Sender: TObject);
    procedure tmrP1QuestionTimer(Sender: TObject);
    procedure tmrP2QuestionTimer(Sender: TObject);
    procedure tmrP1CharMoveTimer(Sender: TObject);
    procedure tmrP2CharMoveTimer(Sender: TObject);
  private
    { Private declarations }
         iDamageP1, iDamageP2, iAnswer, iPlayerAnswer, iTimerCount, iTimerReturn, iTimerMoveCount, iScore, iScore2, iSTimer : integer;
         sQuestion : string;

///////////////////////////////////////////////////////////////

  public
    { Public declarations }
  end;

var
  frmMathDuelGameMulti: TfrmMathDuelGameMulti;

implementation

uses Math_Duel_u, Math;

{$R *.dfm}

procedure TfrmMathDuelGameMulti.FormShow(Sender: TObject);
begin
     Randomize;

     iScore := 0;                                    //Resets all necessary variables and outputs
     iScore2 := 0;
     pnlQuestionP1.Caption := '';
     pnlQuestionP2.Caption := '';
     tmrP1Question.Enabled := False;
     tmrP2Question.Enabled := False;
     pnlP1Block.Show;
     pnlP2Block.Show;
     btnNextQP1.Show;
     btnNextQP2.Hide;
     lblMiss.Hide;

     pgbHP1.Position := 100;
     pgbHP2.position := 100;

     lblP1.Caption := frmMainMenu.sCharNameP1;
     lblP2.Caption := frmMainMenu.sCharNameP2;

                                                          //Load picture and assign damage
          case frmMainMenu.iCharP1 of                     //0=warrior, 1=ranger, 2=mage

     0 : begin
              imgCharP1.Picture.LoadFromFile('char\warriorL.jpg');
              iDamageP1 := 15;
         end;

     1 : begin
              imgCharP1.Picture.LoadFromFile('char\rangerL.jpg');
              imgArrowP1.Picture.LoadFromFile('char\arrowL.jpg');
              imgArrowP1.Visible := false;
              iDamageP1 := 20;
         end;

     2 : begin
              imgCharP1.Picture.LoadFromFile('char\mageL.jpg');
              imgSpellP1.Picture.LoadFromFile('char\spellL.jpg');
              imgSpellP1.Visible := false;
              iDamageP1 := 25;
         end;

     end;


     case frmMainMenu.iCharP2 of                           //0=warrior, 1=ranger, 2=mage

     0 : begin
              imgCharP2.Picture.LoadFromFile('char\warriorR.jpg');
              iDamageP2 := 15;
         end;

     1 : begin
              imgCharP2.Picture.LoadFromFile('char\rangerR.jpg');
              imgArrowP2.Picture.LoadFromFile('char\arrowR.jpg');
              imgArrowP2.Visible := false;
              iDamageP2 := 20;
         end;

     2 : begin
              imgCharP2.Picture.LoadFromFile('char\mageR.jpg');
              imgSpellP2.Picture.LoadFromFile('char\spellR.jpg');
              imgSpellP2.Visible := false;
              iDamageP2 := 25;
         end;
     end;


end;
////////////////////////////////////////////////////////////////////////////////

                          //Player 1 turn

procedure TfrmMathDuelGameMulti.btnNextQP1Click(Sender: TObject);
var
   iRandomFormula, iVal1, iVal2, iVal3, iSwitch, iDiv, iRandomAnswer1, iRandomAnswer2, iRandomAnswer3, iRandomButtonPos  : integer;
begin
               if pgbHP2.Position <= 0 then          //Tests to see if player 2 is dead. If true, opens celebration page
               begin
                    frmMainMenu.Show;
                    frmMathDuelGameMulti.Hide;
                    ShellExecute(handle,'open',PChar('scratchfiles\P1WINS.sb2'), '','',SW_MAXIMIZE);
               end;
               iSTimer := 10;
               iTimerMoveCount := 0;                           //Resets necessary variable and outputs
               iTimerReturn := 0;
               iTimerCount := 0;
               lblMiss.Hide;
               pnlQuestionP2.Caption := '';
               btnNextQP1.Caption := 'NEXT QUESTION';
               btnNextQP1.Hide;
               pnlP1Block.Hide;
               iRandomFormula := Random(3) +1;

                                                        //Randomly generating the question and answer
                  case frmMainMenu.iCharP1 of           //0=warrior, 1=ranger, 2=mage

                  0 : begin
                           case iRandomFormula of                 //2 formulas for Warrior

                           1 : begin
                                    iVal1 := Random(21);
                                    iVal2 := Random(21);

                                    sQuestion := IntToStr(iVal1) + ' + ' + IntToStr(iVal2) + ' =';
                                    iAnswer := iVal1 + iVal2;
                               end;
                           2 : begin
                                    iVal1 := Random(21);
                                    iVal2 := Random(21);

                                    sQuestion := IntToStr(iVal1) + ' + ' + IntToStr(iVal2) + ' =';
                                    iAnswer := iVal1 + iVal2;
                               end;
                           3 : begin
                                    iVal1 := Random(21);
                                    iVal2 := Random(21);
                                    if iVal2 > iVal1 then           //For minus sums, 1st value must be bigger
                                    begin
                                         iSwitch := iVal1;
                                         iVal1 := iVal2;
                                         iVal2 := iSwitch;
                                    end;
                                    sQuestion := IntToStr(iVal1) + ' - ' + IntToStr(iVal2) + ' =';
                                    iAnswer := iVal1 - iVal2;
                               end;
                           4 : begin
                                    iVal1 := Random(21);
                                    iVal2 := Random(21);
                                    if iVal2 > iVal1 then
                                    begin
                                         iSwitch := iVal1;
                                         iVal1 := iVal2;
                                         iVal2 := iSwitch;
                                    end;
                                    sQuestion := IntToStr(iVal1) + ' - ' + IntToStr(iVal2) + ' =';
                                    iAnswer := iVal1 - iVal2;
                               end;
                           end;
                      end;

                  1 : begin
                           case iRandomFormula of                //2 formulas for Ranger

                           1 : begin
                                    iVal1 := (Random(10)+1);
                                    iVal2 := (Random(10)+1);
                                    iDiv := iVal1 * iVal2;

                                    sQuestion := IntToStr(iVal1) + ' X ' + IntToStr(iVal2) + ' =';
                                    iAnswer := iVal1 * iVal2;
                               end;
                           2 : begin
                                    iVal1 := (Random(10)+1);
                                    iVal2 := (Random(10)+1);
                                    iDiv := iVal1 * iVal2;

                                    sQuestion := IntToStr(iVal1) + ' X ' + IntToStr(iVal2) + ' =';
                                    iAnswer := iVal1 * iVal2;
                               end;
                           3 : begin
                                    iVal1 := (Random(10)+1);
                                    iVal2 := (Random(10)+1);
                                    iDiv := iVal1 * iVal2;

                                    sQuestion := IntToStr(iDiv) + ' ÷ ' + IntToStr(iVal2) + ' =';
                                    iAnswer := iVal1;
                               end;
                           4 : begin
                                    iVal1 := (Random(10)+1);
                                    iVal2 := (Random(10)+1);
                                    iDiv := iVal1 * iVal2;

                                    sQuestion := IntToStr(iDiv) + ' ÷ ' + IntToStr(iVal2) + ' =';
                                    iAnswer := iVal1;
                               end;
                           end;
                      end;

                  2 : begin
                           case iRandomFormula of                  //4 formulas for Mage

                           1 : begin
                                    iVal1 := Random(13);
                                    iVal2 := Random(13);
                                    iVal3 := Random(16);

                                    sQuestion := IntToStr(iVal1) + ' X ' + IntToStr(iVal2) + ' + ' + IntToStr(iVal3) + ' =';
                                    iAnswer := (iVal1 * iVal2) + iVal3;
                               end;
                           2 : begin
                                    iVal1 := Random(13);
                                    iVal2 := Random(13);
                                    iVal3 := Random(16);

                                    if iVal2 > iVal1 then
                                    begin
                                         iSwitch := iVal1;
                                         iVal1 := iVal2;
                                         iVal2 := iSwitch;
                                    end;
                                    iVal3 := RandomRange(0, (iVal1 * iVal2));

                                    sQuestion := IntToStr(iVal1) + ' X ' + IntToStr(iVal2) + ' - ' + IntToStr(iVal3) + ' =';
                                    iAnswer := (iVal1 * iVal2) - iVal3;
                                end;
                           3 : begin
                                    iVal1 := Random(12)+1;
                                    iVal2 := Random(12)+1;
                                    iVal3 := Random(16);
                                    iDiv := iVal1 * iVal2;           //1st value must be divisible my second value

                                    sQuestion := IntToStr(iDiv) + ' ÷ ' + IntToStr(iVal2) + ' + ' + IntToStr(iVal3) + ' =';
                                    iAnswer := iVal1 + iVal3;
                               end;
                           4 : begin
                                    iVal1 := Random(12)+1;
                                    iVal2 := Random(12)+1;
                                    iDiv := iVal1 * iVal2;

                                    if iVal2 > iVal1 then
                                    begin
                                         iSwitch := iVal1;
                                         iVal1 := iVal2;
                                         iVal2 := iSwitch;
                                    end;

                                    iVal3 := RandomRange(0, iVal1);
                                    sQuestion := IntToStr(iDiv) + ' ÷ ' + IntToStr(iVal2) + ' - ' + IntToStr(iVal3) + ' =';
                                    iAnswer := iVal1 - iVal3;
                               end;
                           end;
                      end;
                  end; //end of formula and question/answer case statement


                  //Assigning question and answer to button caption
                  pnlQuestionP1.Caption := sQuestion;
                  iRandomButtonPos := Random(4) + 1;
                  iRandomAnswer1 := 0;                          //Reseting incorrect answers
                  iRandomAnswer2 := 0;
                  iRandomAnswer3 := 0;

                  while (iRandomAnswer1 = iRandomAnswer2) or (iRandomAnswer1 = iRandomAnswer3 ) or (iRandomAnswer2 = iRandomAnswer3) or (iRandomAnswer1 = iAnswer) or (iRandomAnswer2 = iAnswer) or (iRandomAnswer3 = iAnswer) do
                  begin
                       iRandomAnswer1 := RandomRange((iAnswer-10), (iAnswer+10));         //Randomly generating incorrect, different answers
                       iRandomAnswer2 := RandomRange((iAnswer-10), (iAnswer+10));
                       iRandomAnswer3 := RandomRange((iAnswer-10), (iAnswer+10));
                  end;

                  btnP1A.Caption := IntToStr(iAnswer);                    //asigning answers to button captions
                  btnP1B.Caption := IntToStr(iRandomAnswer1);
                  btnP1C.Caption := IntToStr(iRandomAnswer2);
                  btnP1D.Caption := IntToStr(iRandomAnswer3);

                  case iRandomButtonPos of                     //Random number selects which order the answers go on the buttons
                  1 : begin
                           btnP1A.Caption := IntToStr(iAnswer);
                           btnP1B.Caption := IntToStr(iRandomAnswer1);
                           btnP1C.Caption := IntToStr(iRandomAnswer2);
                           btnP1D.Caption := IntToStr(iRandomAnswer3);
                      end;
                  2 : begin
                           btnP1A.Caption := IntToStr(iRandomAnswer1);
                           btnP1B.Caption := IntToStr(iAnswer);
                           btnP1C.Caption := IntToStr(iRandomAnswer3);
                           btnP1D.Caption := IntToStr(iRandomAnswer2);
                      end;
                  3 : begin
                           btnP1A.Caption := IntToStr(iRandomAnswer2);
                           btnP1B.Caption := IntToStr(iRandomAnswer3);
                           btnP1C.Caption := IntToStr(iAnswer);
                           btnP1D.Caption := IntToStr(iRandomAnswer1);
                      end;
                  4 : begin
                           btnP1A.Caption := IntToStr(iRandomAnswer3);
                           btnP1B.Caption := IntToStr(iRandomAnswer2);
                           btnP1C.Caption := IntToStr(iRandomAnswer1);
                           btnP1D.Caption := IntToStr(iAnswer);
                      end;
                  end;

     tmrP1Question.Enabled := true;                //Start question timer
     lblQuestionT1.Caption := '10s';
     lblQuestionT2.Caption := '10s';

end;

procedure TfrmMathDuelGameMulti.btnP1AClick(Sender: TObject);
begin
     tmrP1Question.Enabled := False;
     lblQuestionT1.Caption := '';
     lblQuestionT2.Caption := '';
     iPlayerAnswer := StrToInt(btnP1A.Caption);

     if iPlayerAnswer = iAnswer then             //Tests if answer is correct.
        tmrP1CharMove.Enabled := True

     else
     begin
          lblMiss.Show;
          pnlP1Block.Show;
          btnNextQP2.Show;
     end;

end;

procedure TfrmMathDuelGameMulti.btnP1BClick(Sender: TObject);
begin
     tmrP1Question.Enabled := False;
     lblQuestionT1.Caption := '';
     lblQuestionT2.Caption := '';
     iPlayerAnswer := StrToInt(btnP1B.Caption);

     if iPlayerAnswer = iAnswer then
        tmrP1CharMove.Enabled := True

     else
     begin
          lblMiss.Show;
          pnlP1Block.Show;
          btnNextQP2.Show;
     end;

end;
procedure TfrmMathDuelGameMulti.btnP1CClick(Sender: TObject);
begin
     tmrP1Question.Enabled := False;
     lblQuestionT1.Caption := '';
     lblQuestionT2.Caption := '';
     iPlayerAnswer := StrToInt(btnP1C.Caption);

     if iPlayerAnswer = iAnswer then
        tmrP1CharMove.Enabled := True
     else
     begin
          lblMiss.Show;
          pnlP1Block.Show;
          btnNextQP2.Show;
     end;

end;

procedure TfrmMathDuelGameMulti.btnP1DClick(Sender: TObject);
begin
     tmrP1Question.Enabled := False;
     lblQuestionT1.Caption := '';
     lblQuestionT2.Caption := '';
     iPlayerAnswer := StrToInt(btnP1D.Caption);

     if iPlayerAnswer = iAnswer then
        tmrP1CharMove.Enabled := True

     else
     begin
          lblMiss.Show;
          pnlP1Block.Show;
          btnNextQP2.Show;
     end;

end;
////////////////////////////////////////////////////////////////////////////////

                           // Player 1 timers

procedure TfrmMathDuelGameMulti.tmrP1QuestionTimer(Sender: TObject);
begin
     lblQuestionT1.Caption := IntToStr(9 - iTimerCount) + 's';       //Displays how much time is left
     lblQuestionT2.Caption := IntToStr(9 - iTimerCount) + 's';


     if iTimerCount = 9 then                        //Tests if time has run out
     begin
          tmrP1Question.Enabled := False;
          lblQuestionT1.Caption := '';
          lblQuestionT2.Caption := '';
          lblMiss.Show;
          pnlP1Block.Show;
          btnNextQP2.Show;
     end;
     Inc(iTimerCount);
     Dec(iSTimer);
end;

procedure TfrmMathDuelGameMulti.tmrP1CharMoveTimer(Sender: TObject);     //If answer is correct, runs this timer
begin
     Inc(iTimerMoveCount);
     case frmMainMenu.iCharP1 of                   //0=warrior, 1=ranger, 2=mage

     0 : begin
              if iTimerReturn = 0 then                          //Move the Warrior right then left on timer tick
                 imgCharP1.Left := imgCharP1.Left + 16
              else
                  imgCharP1.Left := imgCharP1.Left - 16;

              if iTimerMoveCount = 24 then                   //Returns warrior to normal position
              begin
                   iTimerReturn := 1;
              end;

              if (iTimerMoveCount = 48) and (iTimerReturn = 1) then      //Tests if warriour has finished movement
              begin
                   pgbHP2.Position := pgbHP2.Position - iDamageP1 + iTimerCount;    //Deals damage: Damage of character - time taken to answer
                   iScore := iScore + (10 * iSTimer) + 100;                   //Calculates score: 100 + 10 x time left
                   tmrP1CharMove.Enabled := False;
                   pnlP1Block.Show;
                   btnNextQP2.Show;

                   if pgbHP2.Position <= 0 then                        //Tests if Player 2 is dead. Sets label and displays score if true
                   begin
                        btnNextQP1.Caption := 'PLAYER 1 WON!';
                        btnNextQP1.Show;
                        btnNextQP2.Hide;
                        pnlQuestionP1.Caption := 'Score:' + IntToStr(iScore);
                        pnlQuestionP2.Caption := 'Score:' + IntToStr(iScore2);
                   end;
              end;


         end;
     1 : begin
              if iTimerReturn = 0 then
              begin
                   imgArrowP1.Visible := True;
                   imgArrowP1.Left := imgArrowP1.Left + 8
              end
              else
              begin
                   imgArrowP1.Visible := false;
                   imgArrowP1.Left := imgArrowP1.Left - 8;
              end;

              if iTimerMoveCount = 48 then
                 iTimerReturn := 1;

              if (iTimerMoveCount = 96) and (iTimerReturn = 1) then
              begin
                   pgbHP2.Position := pgbHP2.Position - iDamageP1 + iTimerCount;
                   iScore := iScore + (10 * iSTimer) + 100;
                   tmrP1CharMove.Enabled := False;
                   pnlP1Block.Show;
                   btnNextQP2.Show;

                   if pgbHP2.Position <= 0 then
                   begin
                        btnNextQP1.Caption := 'PLAYER 1 WON!';
                        btnNextQP1.Show;
                        btnNextQP2.Hide;
                        pnlQuestionP1.Caption := 'Score:' + IntToStr(iScore);
                        pnlQuestionP2.Caption := 'Score:' + IntToStr(iScore2);
                   end;
              end;
         end;
     2 : begin
              if iTimerReturn = 0 then
              begin
                   imgSpellP1.Visible := True;
                   imgSpellP1.Left := imgSpellP1.Left + 8
              end
              else
              begin
                   imgSpellP1.Visible := false;
                   imgSpellP1.Left := imgSpellP1.Left - 8;
              end;

              if iTimerMoveCount = 48 then
                 iTimerReturn := 1;


              if (iTimerMoveCount = 96) and (iTimerReturn = 1) then
              begin
                   iTimerCount := iTimerCount * 2;
                   tmrP1CharMove.Enabled := False;
                   pnlP1Block.Show;
                   btnNextQP2.Show;
                   pgbHP2.Position := pgbHP2.Position - iDamageP1 + iTimerCount;
                   iScore := iScore + (10 * iSTimer) + 100;

                   if pgbHP2.Position <= 0 then
                   begin
                        btnNextQP1.Caption := 'PLAYER 1 WON!';
                        btnNextQP1.Show;
                        btnNextQP2.Hide;
                        pnlQuestionP1.Caption := 'Score:' + IntToStr(iScore);
                        pnlQuestionP2.Caption := 'Score:' + IntToStr(iScore2);
                   end;
              end;
         end;
     end;
end;



////////////////////////////////////////////////////////////////////////////////

                            //Player 2 turn

procedure TfrmMathDuelGameMulti.btnNextQP2Click(Sender: TObject);
var
   iRandomFormula, iVal1, iVal2, iVal3, iSwitch, iDiv, iRandomAnswer1, iRandomAnswer2, iRandomAnswer3, iRandomButtonPos  : integer;
begin
               if pgbHP1.Position <= 0 then
               begin
                    frmMainMenu.Show;
                    frmMathDuelGameMulti.Hide;
                    ShellExecute(handle,'open',PChar('scratchfiles\P2WINS.sb2'), '','',SW_MAXIMIZE);
               end;
               iSTimer := 10;
               iTimerMoveCount := 0;
               iTimerReturn := 0;
               iTimerCount := 0;
               lblMiss.Hide;
               pnlQuestionP1.Caption := '';
               btnNextQP2.Hide;
               pnlP2Block.Hide;
               iRandomFormula := Random(3) +1;

               //Making the question and answer
                  case frmMainMenu.iCharP2 of           //0=warrior, 1=ranger, 2=mage

                  0 : begin
                           case iRandomFormula of

                           1 : begin
                                    iVal1 := Random(21);
                                    iVal2 := Random(21);

                                    sQuestion := IntToStr(iVal1) + ' + ' + IntToStr(iVal2) + ' =';
                                    iAnswer := iVal1 + iVal2;
                               end;
                           2 : begin
                                    iVal1 := Random(21);
                                    iVal2 := Random(21);

                                    sQuestion := IntToStr(iVal1) + ' + ' + IntToStr(iVal2) + ' =';
                                    iAnswer := iVal1 + iVal2;
                               end;
                           3 : begin
                                    iVal1 := Random(21);
                                    iVal2 := Random(21);
                                    if iVal2 > iVal1 then
                                    begin
                                         iSwitch := iVal1;
                                         iVal1 := iVal2;
                                         iVal2 := iSwitch;
                                    end;
                                    sQuestion := IntToStr(iVal1) + ' - ' + IntToStr(iVal2) + ' =';
                                    iAnswer := iVal1 - iVal2;
                               end;
                           4 : begin
                                    iVal1 := Random(21);
                                    iVal2 := Random(21);
                                    if iVal2 > iVal1 then
                                    begin
                                         iSwitch := iVal1;
                                         iVal1 := iVal2;
                                         iVal2 := iSwitch;
                                    end;
                                    sQuestion := IntToStr(iVal1) + ' - ' + IntToStr(iVal2) + ' =';
                                    iAnswer := iVal1 - iVal2;
                               end;
                           end;
                      end;

                  1 : begin
                           case iRandomFormula of

                           1 : begin
                                    iVal1 := (Random(10)+1);
                                    iVal2 := (Random(10)+1);
                                    iDiv := iVal1 * iVal2;

                                    sQuestion := IntToStr(iVal1) + ' X ' + IntToStr(iVal2) + ' =';
                                    iAnswer := iVal1 * iVal2;
                               end;
                           2 : begin
                                    iVal1 := (Random(10)+1);
                                    iVal2 := (Random(10)+1);
                                    iDiv := iVal1 * iVal2;

                                    sQuestion := IntToStr(iVal1) + ' X ' + IntToStr(iVal2) + ' =';
                                    iAnswer := iVal1 * iVal2;
                               end;
                           3 : begin
                                    iVal1 := (Random(10)+1);
                                    iVal2 := (Random(10)+1);
                                    iDiv := iVal1 * iVal2;

                                    sQuestion := IntToStr(iDiv) + ' ÷ ' + IntToStr(iVal2) + ' =';
                                    iAnswer := iVal1;
                               end;
                           4 : begin
                                    iVal1 := (Random(10)+1);
                                    iVal2 := (Random(10)+1);
                                    iDiv := iVal1 * iVal2;

                                    sQuestion := IntToStr(iDiv) + ' ÷ ' + IntToStr(iVal2) + ' =';
                                    iAnswer := iVal1;
                               end;
                           end;
                      end;

                  2 : begin
                           case iRandomFormula of

                           1 : begin
                                    iVal1 := Random(13);
                                    iVal2 := Random(13);
                                    iVal3 := Random(16);

                                    sQuestion := IntToStr(iVal1) + ' X ' + IntToStr(iVal2) + ' + ' + IntToStr(iVal3) + ' =';
                                    iAnswer := (iVal1 * iVal2) + iVal3;
                               end;
                           2 : begin
                                    iVal1 := Random(13);
                                    iVal2 := Random(13);
                                    iVal3 := Random(16);

                                    if iVal2 > iVal1 then
                                    begin
                                         iSwitch := iVal1;
                                         iVal1 := iVal2;
                                         iVal2 := iSwitch;
                                    end;
                                    iVal3 := RandomRange(0, (iVal1 * iVal2));

                                    sQuestion := IntToStr(iVal1) + ' X ' + IntToStr(iVal2) + ' - ' + IntToStr(iVal3) + ' =';
                                    iAnswer := (iVal1 * iVal2) - iVal3;
                                end;
                           3 : begin
                                    iVal1 := Random(12)+1;
                                    iVal2 := Random(12)+1;
                                    iVal3 := Random(16);
                                    iDiv := iVal1 * iVal2;

                                    sQuestion := IntToStr(iDiv) + ' ÷ ' + IntToStr(iVal2) + ' + ' + IntToStr(iVal3) + ' =';
                                    iAnswer := iVal1 + iVal3;
                               end;
                           4 : begin
                                    iVal1 := Random(12)+1;
                                    iVal2 := Random(12)+1;
                                    iDiv := iVal1 * iVal2;

                                    if iVal2 > iVal1 then
                                    begin
                                         iSwitch := iVal1;
                                         iVal1 := iVal2;
                                         iVal2 := iSwitch;
                                    end;

                                    iVal3 := RandomRange(0, iVal1);
                                    sQuestion := IntToStr(iDiv) + ' ÷ ' + IntToStr(iVal2) + ' - ' + IntToStr(iVal3) + ' =';
                                    iAnswer := iVal1 - iVal3;
                               end;
                           end;
                      end;
                  end; //end of formula case

                  //Assigning question and answer to button caption
                  pnlQuestionP2.Caption := sQuestion;
                  iRandomButtonPos := Random(4) + 1;
                  iRandomAnswer1 := 0;
                  iRandomAnswer2 := 0;
                  iRandomAnswer3 := 0;

                  while (iRandomAnswer1 = iRandomAnswer2) or (iRandomAnswer1 = iRandomAnswer3 ) or (iRandomAnswer2 = iRandomAnswer3) or (iRandomAnswer1 = iAnswer) or (iRandomAnswer2 = iAnswer) or (iRandomAnswer3 = iAnswer)  do
                  begin
                       iRandomAnswer1 := RandomRange((iAnswer-10), (iAnswer+10));
                       iRandomAnswer2 := RandomRange((iAnswer-10), (iAnswer+10));
                       iRandomAnswer3 := RandomRange((iAnswer-10), (iAnswer+10));
                  end;

                  btnP2A.Caption := IntToStr(iAnswer);
                  btnP2B.Caption := IntToStr(iRandomAnswer1);
                  btnP2C.Caption := IntToStr(iRandomAnswer2);
                  btnP2D.Caption := IntToStr(iRandomAnswer3);

                  case iRandomButtonPos of
                  1 : begin
                           btnP2A.Caption := IntToStr(iAnswer);
                           btnP2B.Caption := IntToStr(iRandomAnswer1);
                           btnP2C.Caption := IntToStr(iRandomAnswer2);
                           btnP2D.Caption := IntToStr(iRandomAnswer3);
                      end;
                  2 : begin
                           btnP2A.Caption := IntToStr(iRandomAnswer1);
                           btnP2B.Caption := IntToStr(iAnswer);
                           btnP2C.Caption := IntToStr(iRandomAnswer3);
                           btnP2D.Caption := IntToStr(iRandomAnswer2);
                      end;
                  3 : begin
                           btnP2A.Caption := IntToStr(iRandomAnswer2);
                           btnP2B.Caption := IntToStr(iRandomAnswer3);
                           btnP2C.Caption := IntToStr(iAnswer);
                           btnP2D.Caption := IntToStr(iRandomAnswer1);
                      end;
                  4 : begin
                           btnP2A.Caption := IntToStr(iRandomAnswer3);
                           btnP2B.Caption := IntToStr(iRandomAnswer2);
                           btnP2C.Caption := IntToStr(iRandomAnswer1);
                           btnP2D.Caption := IntToStr(iAnswer);
                      end;
                  end;

     tmrP2Question.Enabled := true;
     lblQuestionT1.Caption := '10s';
     lblQuestionT2.Caption := '10s';

end;


procedure TfrmMathDuelGameMulti.btnP2AClick(Sender: TObject);
begin
     tmrP2Question.Enabled := False;
     lblQuestionT1.Caption := '';
     lblQuestionT2.Caption := '';
     iPlayerAnswer := StrToInt(btnP2A.Caption);

     if iPlayerAnswer = iAnswer then
        tmrP2CharMove.Enabled := True
     else
     begin
          lblMiss.Show;
          pnlP2Block.Show;
          btnNextQP1.Show;
     end;

end;

procedure TfrmMathDuelGameMulti.btnP2BClick(Sender: TObject);
begin
     tmrP2Question.Enabled := False;
     lblQuestionT1.Caption := '';
     lblQuestionT2.Caption := '';
     iPlayerAnswer := StrToInt(btnP2B.Caption);

     if iPlayerAnswer = iAnswer then
        tmrP2CharMove.Enabled := True
     else
     begin
          lblMiss.Show;
          pnlP2Block.Show;
          btnNextQP1.Show;
     end;

end;

procedure TfrmMathDuelGameMulti.btnP2CClick(Sender: TObject);
begin
     tmrP2Question.Enabled := False;
     lblQuestionT1.Caption := '';
     lblQuestionT2.Caption := '';
     iPlayerAnswer := StrToInt(btnP2C.Caption);

     if iPlayerAnswer = iAnswer then
        tmrP2CharMove.Enabled := True
     else
     begin
          lblMiss.Show;
          pnlP2Block.Show;
          btnNextQP1.Show;
     end;

end;

procedure TfrmMathDuelGameMulti.btnP2DClick(Sender: TObject);
begin
     tmrP2Question.Enabled := False;
     lblQuestionT1.Caption := '';
     lblQuestionT2.Caption := '';
     iPlayerAnswer := StrToInt(btnP2D.Caption);

     if iPlayerAnswer = iAnswer then
        tmrP2CharMove.Enabled := True
     else
     begin
          lblMiss.Show;
          pnlP2Block.Show;
          btnNextQP1.Show;
     end;

end;

////////////////////////////////////////////////////////////////////////////////

                         //Player 2 question timer
procedure TfrmMathDuelGameMulti.tmrP2QuestionTimer(Sender: TObject);
begin
     lblQuestionT1.Caption := IntToStr(9 - iTimerCount) + 's';
     lblQuestionT2.Caption := IntToStr(9 - iTimerCount) + 's';


     if iTimerCount = 9 then
     begin
          tmrP1Question.Enabled := False;
          lblQuestionT1.Caption := '';
          lblQuestionT2.Caption := '';
          lblMiss.Show;
          pnlP2Block.Show;
          btnNextQP1.Show;
     end;
     Inc(iTimerCount);
     Dec(iSTimer);
end;


procedure TfrmMathDuelGameMulti.tmrP2CharMoveTimer(Sender: TObject);
begin
     Inc(iTimerMoveCount);
     case frmMainMenu.iCharP2 of                   //0=warrior, 1=ranger, 2=mage

     0 : begin
              if iTimerReturn = 0 then
                 imgCharP2.Left := imgCharP2.Left - 16
              else
                  imgCharP2.Left := imgCharP2.Left + 16;

              if iTimerMoveCount = 24 then
              begin
                   iTimerReturn := 1;
              end;

              if (iTimerMoveCount = 48) and (iTimerReturn = 1) then
              begin
                   if frmMainMenu.iCharP2 = 2 then
                   iTimerCount := iTimerCount * 2;

                   pgbHP1.Position := pgbHP1.Position - iDamageP2 + iTimerCount;
                   iScore2 := iScore2 + (10 * iSTimer) + 100;
                   tmrP2CharMove.Enabled := False;
                   pnlP2Block.Show;
                   btnNextQP1.Show;

                   if pgbHP1.Position <= 0 then
                   begin
                        btnNextQP2.Caption := 'PLAYER 2 WON!';
                        btnNextQP2.Show;
                        btnNextQP1.Hide;
                        pnlQuestionP1.Caption := 'Score:' + IntToStr(iScore);
                        pnlQuestionP2.Caption := 'Score:' + IntToStr(iScore2);
                   end;
              end;


         end;
     1 : begin
              if iTimerReturn = 0 then
              begin
                   imgArrowP2.Visible := True;
                   imgArrowP2.Left := imgArrowP2.Left - 8
              end
              else
              begin
                   imgArrowP2.Visible := false;
                   imgArrowP2.Left := imgArrowP2.Left + 8;
              end;

              if iTimerMoveCount = 48 then
                 iTimerReturn := 1;

              if (iTimerMoveCount = 96) and (iTimerReturn = 1) then
              begin
                   if frmMainMenu.iCharP2 = 2 then
                   iTimerCount := iTimerCount * 2;

                   pgbHP1.Position := pgbHP1.Position - iDamageP2 + iTimerCount;
                   iScore2 := iScore2 + (10 * iSTimer) + 100;
                   tmrP2CharMove.Enabled := False;
                   pnlP2Block.Show;
                   btnNextQP1.Show;

                   if pgbHP1.Position <= 0 then
                   begin
                        btnNextQP2.Caption := 'PLAYER 2 WON!';
                        btnNextQP2.Show;
                        btnNextQP1.Hide;
                        pnlQuestionP1.Caption := 'Score:' + IntToStr(iScore);
                        pnlQuestionP2.Caption := 'Score:' + IntToStr(iScore2);
                   end;
              end;
         end;
     2 : begin
              if iTimerReturn = 0 then
              begin
                   imgSpellP2.Visible := True;
                   imgSpellP2.Left := imgSpellP2.Left - 8
              end
              else
              begin
                   imgSpellP2.Visible := false;
                   imgSpellP2.Left := imgSpellP2.Left + 8;
              end;

              if iTimerMoveCount = 48 then
                 iTimerReturn := 1;


              if (iTimerMoveCount = 96) and (iTimerReturn = 1) then
              begin
                   if frmMainMenu.iCharP2 = 2 then
                   iTimerCount := iTimerCount * 2;

                   pgbHP1.Position := pgbHP1.Position - iDamageP2 + iTimerCount;
                   iScore2 := iScore2 + (10 * iSTimer) + 100;
                   tmrP2CharMove.Enabled := False;
                   pnlP2Block.Show;
                   btnNextQP1.Show;

                   if pgbHP1.Position <= 0 then
                   begin
                        btnNextQP2.Caption := 'PLAYER 2 WON!';
                        btnNextQP2.Show;
                        btnNextQP1.Hide;
                        pnlQuestionP1.Caption := 'Score:' + IntToStr(iScore);
                        pnlQuestionP2.Caption := 'Score:' + IntToStr(iScore2);
                   end;
              end;
         end;
     end;
end;

end.
