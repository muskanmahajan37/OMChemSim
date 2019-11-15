within Simulator.Test;

package PFR_Test
  model MS
    extends Simulator.Streams.Material_Stream;
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  end MS;

  model PFR_Test_II
  //*****Advicable to Select the First Component as the Base Component*****\\
  //========================================================================
  //Header Files and Packages
    import data = Simulator.Files.Chemsep_Database;
    parameter data.Ethyleneoxide eth;
    parameter data.Ethyleneglycol eg;
    parameter data.Water wat;
    parameter Integer Nc = 3;
    parameter data.General_Properties C[Nc] = {eth, wat, eg};
  
  //========================================================================
  //Instantiation of Streams and Blocks
   Simulator.Test.PFR_Test.MS S1(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
   Simulator.Test.PFR_Test.MS S2(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
   Simulator.Unit_Operations.PF_Reactor.PFR B1(Nc = 3, Nr = 1, C = {eth, wat, eg}, Mode = 2, Phase = 3,  Tdef = 410) annotation(
      Placement(visible = true, transformation(origin = { 3, -1}, extent = {{-33, -33}, {33, 33}}, rotation = 0)));
   Simulator.Streams.Energy_Stream Energy annotation(
      Placement(visible = true, transformation(origin = {-14, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    
  equation
  
  //========================================================================
  //Connections
    connect(Energy.outlet, B1.En) annotation(
      Line(points = {{-4, -54}, {2, -54}, {2, 0}, {4, 0}}, color = {255, 0, 0}));
    connect(B1.Out, S2.inlet) annotation(
      Line(points = {{36, 0}, {80, 0}, {80, 0}, {80, 0}}, color = {0, 70, 70}));
    connect(S1.outlet, B1.In) annotation(
      Line(points = {{-60, 0}, {-30, 0}, {-30, 0}, {-30, 0}}, color = {0, 70, 70}));

  //========================================================================
  //Inputs and Specifications
    S1.compMolFrac[1, :] = {0.2, 0.8, 0};
    S1.P = 101325;
    S1.T = 395;
    S1.F_p[1] = 100;
    B1.X_r[1] = 0.0741;
  end PFR_Test_II;
end PFR_Test;