(* PlotCFuncandDeltaMZero.m *)
(* This file plots c func of the most patient and Delta m = 0 line *)



SetDirectory[NotebookDirectory[]];
If[Directory[] != NoAggShockDir, SetDirectory[NoAggShockDir]]; (* If this file is run in DoAll file and current folder is "Mathematica", current folder is changed to "NoAggShock". *)

ClearAll["Global`*"];

Print["============================================================="];
Print["Plot consumption function and \!\(\[DoubleStruckCapitalE]\_\[ScriptT]\)[\[CapitalDelta]\!\(\*SubscriptBox[\[ScriptM],\(\[ScriptT] +1\)]\)]=0 line"];

(* Messege off *)
Off[General::"spell1"]; 
Off[Permutations::"obslt"];
Off[General::"obspkg"];
Off[InterpolatingFunction::"dmval"];
Off[NIntegrate::"ncvb"];
Off[FindMinimum::"lstol"];

TimeS = SessionTime[];  

Model  = Seven;  (* Indicates that the model is Dist with time pref factors approximated by seven points *)
Perm   = Yes;    (* Perm shock is on *)
KS     = No;     (* Income process is NOT KS *)
MatchLiqFinPlsRetAssets  = No; 

(* Set parameter values and set up routines *)
<<Params.m;
<<SetupSolve.m;
<<SimFuncs.m;                                     (* Load "Simulate" *) 


diff = Import["diff.txt","List"][[1]]; 
Betamiddle = Import["Betamiddle.txt","List"][[1]]; 


(* solve consumption function *)
  ConstructcInterpFunc[Betamiddle + 3 diff];
  cInterpFunc1 = cInterpFunc;

(*
  ConstructcInterpFunc[Betamiddle + 2 diff];
  cInterpFunc2  = cInterpFunc;

  ConstructcInterpFunc[Betamiddle +   diff];
  cInterpFunc3  = cInterpFunc;

  ConstructcInterpFunc[Betamiddle];
  cInterpFunc4  = cInterpFunc;

  ConstructcInterpFunc[Betamiddle-  diff];
  cInterpFunc5  = cInterpFunc;

  ConstructcInterpFunc[Betamiddle- 2 diff];
  cInterpFunc6  = cInterpFunc;

  ConstructcInterpFunc[Betamiddle- 3 diff];
  cInterpFunc7  = cInterpFunc;
*)

mMax = 1000;
cMax = 15; 

(*
mMax = 300;
cMax = 6; 
*)

cMin = 0; 


(*
mMax = 10;
cMin = 0; 
cMax = 4; 
*)



maxis = Table[0.2 m, {m, 0, mMax/0.2}];

caxisMostPatient = Last[cInterpFunc1][maxis]; (* consumption of most patient *)

CFuncPlot = 
 ListLinePlot[Transpose[{maxis, caxisMostPatient}], 
  InterpolationOrder -> 1, 
  PlotRange -> {{0, mMax}, {cMin, cMax}}, 
(*
  PlotStyle -> {Black, Thickness[0.005]}
*)
  PlotStyle -> {Black, Thickness[0.004]}
(*
  PlotStyle  -> {Black, Dashing[{0.015, 0.015}], Thickness[0.001]}
*)
]; 

(* calc Delta m = 0 line (consumption that makes an increase zero) *)

(*
Etmtp1[m_] := Sum[

      atp1        = m - Last[cInterpFunc][m];
      Psitp1   = PsiVec[[PsiLoop]];
      Thetatp1 = ThetaVec[[ThetaLoop]];

      PsiVecProb[[PsiLoop]] ThetaVecProb[[ThetaLoop]] ( ((RSS - \[Delta])/(1 - ProbOfDeath)) atp1/(Psitp1) + Thetatp1 )

  ,{PsiLoop,Length[PsiVec]}
  ,{ThetaLoop,Length[ThetaVec]}
]; (* End Sum *)
*)

sumA = Sum[

      Psitp1   = PsiVec[[PsiLoop]];
      Thetatp1 = ThetaVec[[ThetaLoop]];

      PsiVecProb[[PsiLoop]] ThetaVecProb[[ThetaLoop]] ( ((RSS - \[Delta])) /(Psitp1)  )

  ,{PsiLoop,Length[PsiVec]}
  ,{ThetaLoop,Length[ThetaVec]}
]; (* End Sum *)


sumB = Sum[
      Thetatp1 = ThetaVec[[ThetaLoop]];
      ThetaVecProb[[ThetaLoop]] Thetatp1
  ,{ThetaLoop,Length[ThetaVec]}
]; (* End Sum *)

DeltaMZero = ((sumA-1) maxis + sumB)/sumA; (* Delta m = 0 line (consumption that makes an increase zero) *)

DeltaMZeroPlot =  ListLinePlot[Transpose[{maxis, DeltaMZero}], 
  InterpolationOrder -> 1, 
  PlotRange -> {{0, mMax}, {cMin, cMax}}, 
(*
  PlotStyle -> {Black, Thickness[0.005]}
*)
  PlotStyle  -> {Black, Dashing[{0.015, 0.015}], Thickness[0.004]}
]; 

cDiff = DeltaMZero-caxisMostPatient;
Print["\!\(\[DoubleStruckCapitalE]\_\[ScriptT]\)[\[CapitalDelta]\!\(\*SubscriptBox[\[ScriptM],\(\[ScriptT] +1\)]\)]=0 - \!\(\[ScriptC]\_\[ScriptT]\) at large \[ScriptM] "];
Print[cDiff[[-1]]]; 


(* plot figure *)
CFuncandDeltaMZeroPlot = 
 Show[{CFuncPlot, DeltaMZeroPlot}, 
  Graphics[Text["\[UpArrow] \!\(\[ScriptC]\_\[ScriptT]\) (solid line)" , {400, 5}, {-1,0}]],
  Graphics[Text["\!\(\[DoubleStruckCapitalE]\_\[ScriptT]\)[\[CapitalDelta]\!\(\*SubscriptBox[\[ScriptM],\(\[ScriptT] +1\)]\)]=0 \[DownArrow] " , {37, 5}, {-1,0}]],

  PlotRangeClipping -> False, 
  ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio},
  AxesLabel -> {\[ScriptM], None},
  TextStyle -> {FontSize -> 14}
]

Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/figures/CFuncandDeltaMZeroPlot.EPS", CFuncandDeltaMZeroPlot, "EPS"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/figures/CFuncandDeltaMZeroPlot.PNG", CFuncandDeltaMZeroPlot, "PNG"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/figures/CFuncandDeltaMZeroPlot.pdf", CFuncandDeltaMZeroPlot, "pdf"];



(* Display time spent *)  
Print[" Time spent to plot funcs (minutes):  ", (SessionTime[]-TimeS)/60];

