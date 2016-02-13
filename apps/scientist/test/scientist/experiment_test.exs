defmodule Scientist.ExperimentTest do
  use ExSpec, async: true
  doctest Scientist

  import Scientist.Experiment

  describe "experiment/1" do
    it "assigns a name" do
      assert experiment("test").name == "test"
    end

    it "generates a unique identifier" do
      assert experiment("test").uuid
    end
  end

  # describe "control/2" do
  #   it "assigns a control function to the experiment" do
  #     result =
  #       experiment("Test experiment")
  #       |> control(fn -> IO.puts "Hello world" end)
  #
  #     assert result.control
  #   end
  # end

  # describe "candidate/2" do
  #   it "assigns a candidate to the experiment" do
  #     result =
  #       experiment("Test")
  #       |> candidate(fn -> IO.puts "Hello world" end)
  #
  #     assert result.candidate
  #   end
  #
  #   # it "allows multiple candidates to be assigned" do
  #   #   result =
  #   #     experiment("Test")
  #   #     |> candidate(fn -> 1 end)
  #   #     |> candidate(fn -> 1 end)
  #   #
  #   #   assert Enum.count(result.candidates) == 2
  #   # end
  # end

  describe "run/1" do
    it "yields the controls result" do
      result =
        experiment("Test experiment")
        |> control(fn -> 3 + 3 end)
        |> candidate(fn -> 3 + 4 end)
        |> run

      assert result == 6
    end

    context "when there is no candidate" do
      it "yields the controls result" do
        result =
          experiment("Test experiment")
          |> control(fn -> 3 + 3 end)
          |> run

        assert result == 6
      end
    end
  end
end
