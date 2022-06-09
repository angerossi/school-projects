unit Game1p_u;             //Angelo Rossi

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, ShellApi;

type
  TfrmMathDuelGameSingle = class(TForm)
    pnlHPAI: TPanel;
    lblAI: TLabel;
    lblHPAI: TLabel;
    pgbHPAI: TProgressBar;
    tmrAIQuestion: TTimer;
    lblMiss: TLabel;
    imgCharAI: TImage;
    tmrAICharMove: TTimer;
    imgSpellAI: TImage;
    imgArrowAI: TImage;
    pnlQuestionAI: TPanel;
    pnlHP1: TPanel;
    lblP1: TLabel;
    lblHP1: TLabel;
    pgbHP1: TProgressBar;
    tmrP1Question: TTimer;
    imgCharP1: TImage;
    tmrP1CharMove: TTimer;
    imgSpellP1: TImage;
    imgArrowP1: TImage;
    pnlQuestionP1: TPanel;
    pnlAnswerP1: TPanel;
    btnP1A: TButton;
    btnP1B: TButton;
    btnP1C: TButton;
    btnP1D: TButton;
    pnlP1Block: TPanel;
    btnNextQP1: TButton;
    lblQuestionT1: TLabel;
    lblQuestionT2: TLabel;
    tmrMiss: TTimer;
    procedure FormShow(Sender: TObject);
    procedure btnNextQP1Click(Sender: TObject);
    procedure btnP1AClick(Sender: TObject);
    procedure btnP1BClick(Sender: TObject);
    procedure btnP1CClick(Sender: TObject);
    procedure btnP1DClick(Sender: TObject);
    procedure tmrP1QuestionTimer(Sender: TObject);
    procedure tmrP1CharMoveTimer(Sender: TObject);
    procedure tmrAIQuestionTimer(Sender: TObject);
    procedure tmrAICharMoveTimer(Sender: TObject);
    procedure tmrMissTimer(Sender: TObject);
  private
    { Private declarations }
         iDamageP1, iDamageAI, iAnswer, iPlayerAnswer, iTimerCount, iTimerReturn, iTimerMoveCount, iRandomTimeChance1, iRandomTimeChance2, iTimeChanceInc, iCorrectChance, iAITurn, iCountMissDelay, iScore, iSTimer : integer;
         sQuestion : string;

  public
    { Public declarations }
  end;

var
  frmMathDuelGameSingle: TfrmMathDuelGameSingle;

implementation

uses Math_Duel_u, Math;

{$R *.dfm}

procedure TfrmMathDuelGameSingle.FormShow(Sender: TObject);
begin
     Randomize;

     pnlQuestionP1.Caption := '';
     iScore := 0;
     tmrP1Question.Enabled := False;
     tmrAIQuestion.Enabled := False;
     pnlP1Block.Show;
     btnNextQP1.Show;
     lblMiss.Hide;

     pgbHP1.Position := 100;
     pgbHPAI.position := 100;

     lblP1.Caption := frmMainMenu.sCharNameP1;

          //Load picture and assign damage
          case frmMainMenu.iCharP1 of           //0=warrior, 1=ranger, 2=mage

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


     case frmMainMenu.iCharAI of           //0=warrior, 1=ranger, 2=mage

     0 : begin
              imgCharAI.Picture.LoadFromFile('char\warriorR.jpg');
              iDamageAI := 15;
         end;

     1 : begin
              imgCharAI.Picture.LoadFromFile('char\rangerR.jpg');
              imgArrowAI.Picture.LoadFromFile('char\arrowR.jpg');
              imgArrowAI.Visible := false;
              iDamageAI := 20;
         end;

     2 : begin
              imgCharAI.Picture.LoadFromFile('char\mageR.jpg');
              imgSpellAI.Picture.LoadFromFile('char\spellR.jpg');
              imgSpellAI.Visible := false;
              iDamageAI := 25;
         end;
     end;
end;
////////////////////////////////////////////////////////////////////////////////

                        //Player turn

procedure TfrmMathDuelGameSingle.btnNextQP1Click(Sender: TObject);
var
   iRandomFormula, iVal1, iVal2, iVal3, iSwitch, iDiv, iRandomAnswer1, iRandomAnswer2, iRandomAnswer3, iRandomButtonPos  : integer;
begin
               if pgbHPAI.Position <= 0 then
               begin
                    frmMainMenu.Show;
                    frmMathDuelGameSingle.Hide;
                    ShellExecute(handle,'open',PChar('scratchfiles\P1WINS.sb2'), '','',SW_MAXIMIZE);
               end;

               if pgbHP1.Position <= 0 then
               begin
                    frmMainMenu.Show;
                    frmMathDuelGameSingle.Hide;
                    ShellExecute(handle,'open',PChar('scratchfiles\AIWINS.sb2'), '','',SW_MAXIMIZE);
               end;
               
               iSTimer := 10;
               iCountMissDelay := 0;
               iTimerMoveCount := 0;
               iTimerReturn := 0;
               iTimerCount := 0;
               lblMiss.Hide;
               pnlQuestionAI.Caption := '';
               btnNextQP1.Caption := 'NEXT QUESTION';
               btnNextQP1.Hide;
               pnlP1Block.Hide;
               iRandomFormula := Random(3) +1;

               //Making the question and answer
                  case frmMainMenu.iCharP1 of           //0=warrior, 1=ranger, 2=mage

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
                  pnlQuestionP1.Caption := sQuestion;
                  iRandomButtonPos := Random(4) + 1;
                  iRandomAnswer1 := 0;
                  iRandomAnswer2 := 0;
                  iRandomAnswer3 := 0;

                  while (iRandomAnswer1 = iRandomAnswer2) or (iRandomAnswer1 = iRandomAnswer3 ) or (iRandomAnswer2 = iRandomAnswer3) or (iRandomAnswer1 = iAnswer) or (iRandomAnswer2 = iAnswer) or (iRandomAnswer3 = iAnswer) do
                  begin
                       iRandomAnswer1 := RandomRange((iAnswer-10), (iAnswer+10));
                       iRandomAnswer2 := RandomRange((iAnswer-10), (iAnswer+10));
                       iRandomAnswer3 := RandomRange((iAnswer-10), (iAnswer+10));
                  end;

                  btnP1A.Caption := IntToStr(iAnswer);
                  btnP1B.Caption := IntToStr(iRandomAnswer1);
                  btnP1C.Caption := IntToStr(iRandomAnswer2);
                  btnP1D.Caption := IntToStr(iRandomAnswer3);

                  case iRandomButtonPos of
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

     tmrP1Question.Enabled := true;
     lblQuestionT1.Caption := '10s';
     lblQuestionT2.Caption := '10s';

end;

procedure TfrmMathDuelGameSingle.btnP1AClick(Sender: TObject);
begin
     tmrP1Question.Enabled := False;
     lblQuestionT1.Caption := '';
     lblQuestionT2.Caption := '';
     iPlayerAnswer := StrToInt(btnP1A.Caption);

     if iPlayerAnswer = iAnswer then
        tmrP1CharMove.Enabled := True

     else
     begin
          lblMiss.Show;
          tmrMiss.Enabled := true;
          pnlP1Block.Show;
          iTimerMoveCount := 0;
          iTimerReturn := 0;
          iTimerCount := 0;
          iTimeChanceInc := 11;
          pnlQuestionP1.Caption := '';
          tmrAIQuestion.Enabled := true;
          lblQuestionT1.Caption := '10s';
          lblQuestionT2.Caption := '10s';
     end;
end;

procedure TfrmMathDuelGameSingle.btnP1BClick(Sender: TObject);
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
          tmrMiss.Enabled := true;
          pnlP1Block.Show;
          iTimerMoveCount := 0;
          iTimerReturn := 0;
          iTimerCount := 0;
          iTimeChanceInc := 11;
          pnlQuestionP1.Caption := '';
          tmrAIQuestion.Enabled := true;
          lblQuestionT1.Caption := '10s';
          lblQuestionT2.Caption := '10s';
     end;
end;

procedure TfrmMathDuelGameSingle.btnP1CClick(Sender: TObject);
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
          tmrMiss.Enabled := true;
          pnlP1Block.Show;
          iTimerMoveCount := 0;
          iTimerReturn := 0;
          iTimerCount := 0;
          iTimeChanceInc := 11;
          pnlQuestionP1.Caption := '';
          tmrAIQuestion.Enabled := true;
          lblQuestionT1.Caption := '10s';
          lblQuestionT2.Caption := '10s';
     end;
end;

procedure TfrmMathDuelGameSingle.btnP1DClick(Sender: TObject);
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
          tmrMiss.Enabled := true;
          pnlP1Block.Show;
          iTimerMoveCount := 0;
          iTimerReturn := 0;
          iTimerCount := 0;
          lblMiss.Hide;
          iTimeChanceInc := 11;
          pnlQuestionP1.Caption := '';
          tmrAIQuestion.Enabled := true;
          lblQuestionT1.Caption := '10s';
          lblQuestionT2.Caption := '10s';
     end;
end;

procedure TfrmMathDuelGameSingle.tmrP1QuestionTimer(Sender: TObject);
begin
     lblQuestionT1.Caption := IntToStr(9 - iTimerCount) + 's';
     lblQuestionT2.Caption := IntToStr(9 - iTimerCount) + 's';


     if iTimerCount = 9 then
     begin
          tmrP1Question.Enabled := False;
          lblQuestionT1.Caption := '';
          lblQuestionT2.Caption := '';
          lblMiss.Show;
          tmrMiss.Enabled := true;
          pnlP1Block.Show;

     end;
     Inc(iTimerCount);
     Dec(iSTimer);
end;

procedure TfrmMathDuelGameSingle.tmrP1CharMoveTimer(Sender: TObject);
begin
     Inc(iTimerMoveCount);
     case frmMainMenu.iCharP1 of                   //0=warrior, 1=ranger, 2=mage

     0 : begin
              if iTimerReturn = 0 then
                 imgCharP1.Left := imgCharP1.Left + 16
              else
                  imgCharP1.Left := imgCharP1.Left - 16;

              if iTimerMoveCount = 24 then
              begin
                   iTimerReturn := 1;
              end;

              if (iTimerMoveCount = 48) and (iTimerReturn = 1) then
              begin
                   pgbHPAI.Position := pgbHPAI.Position - iDamageP1 + iTimerCount;
                   iScore := iScore + (10 * iSTimer) + 100;
                   tmrP1CharMove.Enabled := False;
                   pnlP1Block.Show;

                   iTimerMoveCount := 0;
                   iTimerReturn := 0;
                   iTimerCount := 0;
                   iTimeChanceInc := 11;
                   pnlQuestionP1.Caption := '';
                   tmrAIQuestion.Enabled := true;
                   lblQuestionT1.Caption := '10s';
                   lblQuestionT2.Caption := '10s';


                   if pgbHPAI.Position <= 0 then
                   begin
                        btnNextQP1.Caption := 'PLAYER 1 WON!';
                        btnNextQP1.Show;
                        tmrAIQuestion.Enabled := false;
                        pnlQuestionP1.Caption := 'Score:' + IntToStr(iScore);
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
                   pgbHPAI.Position := pgbHPAI.Position - iDamageP1 + iTimerCount;
                   iScore := iScore + (10 * iSTimer) + 100;
                   tmrP1CharMove.Enabled := False;
                   pnlP1Block.Show;

                   iTimerMoveCount := 0;
                   iTimerReturn := 0;
                   iTimerCount := 0;
                   iTimeChanceInc := 11;
                   pnlQuestionP1.Caption := '';
                   tmrAIQuestion.Enabled := true;
                   lblQuestionT1.Caption := '10s';
                   lblQuestionT2.Caption := '10s';


                   if pgbHPAI.Position <= 0 then
                   begin
                        btnNextQP1.Caption := 'PLAYER 1 WON!';
                        btnNextQP1.Show;
                        tmrAIQuestion.Enabled := false;
                        pnlQuestionP1.Caption := 'Score:' + IntToStr(iScore);
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
                   pgbHPAI.Position := pgbHPAI.Position - iDamageP1 + iTimerCount;
                   iScore := iScore + (10 * iSTimer) + 100;
                   iTimerCount := iTimerCount * 2;
                   tmrP1CharMove.Enabled := False;
                   pnlP1Block.Show;

                   iTimerMoveCount := 0;
                   iTimerReturn := 0;
                   iTimerCount := 0;
                   iTimeChanceInc := 11;
                   pnlQuestionP1.Caption := '';
                   tmrAIQuestion.Enabled := true;
                   lblQuestionT1.Caption := '10s';
                   lblQuestionT2.Caption := '10s';


                   if pgbHPAI.Position <= 0 then
                   begin
                        btnNextQP1.Caption := 'PLAYER 1 WON!';
                        btnNextQP1.Show;
                        tmrAIQuestion.Enabled := false;
                        pnlQuestionP1.Caption := 'Score:' + IntToStr(iScore);
                   end;
              end;
         end;
     end;
end;

procedure TfrmMathDuelGameSingle.tmrMissTimer(Sender: TObject);       //Displays 'MISS' for 1 sec
begin
      lblMiss.Hide;
      tmrMiss.Enabled := false;
end;

////////////////////////////////////////////////////////////////////////////////

                            //AI turn

procedure TfrmMathDuelGameSingle.tmrAIQuestionTimer(Sender: TObject);
begin
     lblQuestionT1.Caption := IntToStr(9 - iTimerCount) + 's';
     lblQuestionT2.Caption := IntToStr(9 - iTimerCount) + 's';


     if iTimerCount = 9 then
     begin
          lblQuestionT1.Caption := '';
          lblQuestionT2.Caption := '';
          lblMiss.Show;
          btnNextQP1.Show;
          tmrAIQuestion.Enabled := false;
     end;

     iRandomTimeChance1 := RandomRange(1, iTimeChanceInc);       //Generates Random numbers every tick. The Range of the
     iRandomTimeChance2 := RandomRange(1, iTimeChanceInc);       //numbers decrease as the timer ticks. The program tests
     iCorrectChance := Random(5) + 1;                            //if the numbers are the same every tick. If they are,
                                                                 //the program tests if another random number is 1,2,3
     if iRandomTimeChance1 = iRandomTimeChance2 then             //or 4. If it is, damage is dealt based on how much time
     begin                                                       //was taken to answer.
          if iCorrectChance in [1..4] then
          tmrAICharMove.Enabled := True
          else
          begin
               lblMiss.Show;
               lblQuestionT1.Caption := '';
               lblQuestionT2.Caption := '';
               btnNextQP1.Show;
          end;
          tmrAIQuestion.Enabled := false;
     end;
     Inc(iTimerCount);
     Dec(iTimeChanceInc);
end;

procedure TfrmMathDuelGameSingle.tmrAICharMoveTimer(Sender: TObject);
begin
     Inc(iTimerMoveCount);
     case frmMainMenu.iCharAI of                   //0=warrior, 1=ranger, 2=mage

     0 : begin
              if iTimerReturn = 0 then
                 imgCharAI.Left := imgCharAI.Left - 16
              else
                  imgCharAI.Left := imgCharAI.Left + 16;

              if iTimerMoveCount = 24 then
              begin
                   iTimerReturn := 1;
              end;

              if (iTimerMoveCount = 48) and (iTimerReturn = 1) then
              begin
                   pgbHP1.Position := pgbHP1.Position - iDamageAI + iTimerCount;
                   tmrAICharMove.Enabled := False;
                   btnNextQP1.Show;
                   lblQuestionT1.Caption := '';
                   lblQuestionT2.Caption := '';

                   if pgbHP1.Position <= 0 then
                   begin
                        btnNextQP1.Caption := 'AI WON!';
                        btnNextQP1.Show;
                        pnlQuestionP1.Caption := 'Score:' + IntToStr(iScore);
                   end;
              end;


         end;
     1 : begin
              if iTimerReturn = 0 then
              begin
                   imgArrowAI.Visible := True;
                   imgArrowAI.Left := imgArrowAI.Left - 8
              end
              else
              begin
                   imgArrowAI.Visible := false;
                   imgArrowAI.Left := imgArrowAI.Left + 8;
              end;

              if iTimerMoveCount = 48 then
                 iTimerReturn := 1;

              if (iTimerMoveCount = 96) and (iTimerReturn = 1) then
              begin
                   pgbHP1.Position := pgbHP1.Position - iDamageP1 + iTimerCount;
                   tmrAICharMove.Enabled := False;
                   btnNextQP1.Show;
                   lblQuestionT1.Caption := '';
                   lblQuestionT2.Caption := '';

                   if pgbHP1.Position <= 0 then
                   begin
                        btnNextQP1.Caption := 'AI WON!';
                        btnNextQP1.Show;
                        pnlQuestionP1.Caption := 'Score:' + IntToStr(iScore);
                   end;
              end;
         end;
     2 : begin
              if iTimerReturn = 0 then
              begin
                   imgSpellAI.Visible := True;
                   imgSpellAI.Left := imgSpellAI.Left - 8
              end
              else
              begin
                   imgSpellAI.Visible := false;
                   imgSpellAI.Left := imgSpellAI.Left + 8;
              end;

              if iTimerMoveCount = 48 then
                 iTimerReturn := 1;


              if (iTimerMoveCount = 96) and (iTimerReturn = 1) then
              begin
                   iTimerCount := iTimerCount * 2;
                   tmrAICharMove.Enabled := False;
                   pgbHP1.Position := pgbHP1.Position - iDamageP1 + iTimerCount;
                   btnNextQP1.Show;
                   lblQuestionT1.Caption := '';
                   lblQuestionT2.Caption := '';

                   if pgbHP1.Position <= 0 then
                   begin
                        btnNextQP1.Caption := 'AI WON!';
                        btnNextQP1.Show;
                        pnlQuestionP1.Caption := 'Score:' + IntToStr(iScore);
                   end;
              end;
         end;
     end;

end;


end.
