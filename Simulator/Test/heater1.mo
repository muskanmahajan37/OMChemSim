within Simulator.Test;

package heater1
  model ms
    extends Simulator.Streams.Material_Stream;
    //material stream extended
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    //thermodynamic package Raoults law is extended
  end ms;

  model heat
    //instance of chemsep database
    import data = Simulator.Files.Chemsep_Database;
    //instance of methanol
    parameter data.Methanol meth;
    //instance of ethanol
    parameter data.Ethanol eth;
    //instance of water
    parameter data.Water wat;
    //instance of heater
    parameter Integer Nc = 3;
    parameter data.General_Properties comp[Nc] = {meth, eth, wat};
    Simulator.Unit_Operations.Heater heater1(Pdel = 101325, Eff = 1, Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-36, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    //instances of composite material stream
    Simulator.Test.heater1.ms inlet(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-80, 4}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
    Simulator.Test.heater1.ms outlet(Nc = Nc, C = C, T(start = 353), x_pc(start = {{0.33, 0.33, 0.34}, {0.24, 0.31, 0.43}, {0.44, 0.34, 0.31}}), P(start = 101325)) annotation(
      Placement(visible = true, transformation(origin = {20, 8}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
    //instance of energy stream
    Simulator.Streams.Energy_Stream energy annotation(
      Placement(visible = true, transformation(origin = {-75, -35}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  equation
  connect(energy.Out, heater1.En) annotation(
      Line(points = {{-62, -35}, {-62, -34.5}, {-46, -34.5}, {-46, -14}}));
  connect(inlet.Out, heater1.In) annotation(
      Line(points = {{-68, 4}, {-58, 4}, {-58, -4}, {-46, -4}}));
  connect(heater1.Out, outlet.In) annotation(
      Line(points = {{-26, -4}, {-26, -8}, {8, -8}, {8, 8}}));
  equation
    inlet.x_pc[1, :] = {0.33, 0.33, 0.34};
//mixture molar composition
    inlet.P = 202650;
//input pressure
    inlet.T = 320;
//input temperature
    inlet.F_p[1] = 100;
//input molar flow
    heater1.Q = 2000000;
//heat added
  end heat;
end heater1;