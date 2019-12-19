state("CodeVein-Win64-Shipping")
{
}

state("CodeVein-Win64-Shipping", "1.9903.8.6465")
{
  bool isLoading : 0x3C482D0;
  bool notTitleScreen : 0x402B2C4;
}

state("CodeVein-Win64-Shipping", "1.9913.8.7163")
{
  bool isLoading : 0x3D262D0;
  bool notTitleScreen : 0x40CCF44;
}

state("CodeVein-Win64-Shipping", "1.9913.8.8150")
{
  bool isLoading : 0x3D272D0;
  bool notTitleScreen : 0x40CDFC4;
}

state("CodeVein-Win64-Shipping", "1.9913.8.9227")
{
  bool isLoading : 0x3D272D0;
  bool notTitleScreen : 0x40CDFC4;
}

state("CodeVein-Win64-Shipping", "1.9950.9.953")
{
  bool isLoading : 0x4100680;
  bool notTitleScreen : 0x412ABC4;
}

init
{
  string[] versions = {"1.9903.8.6465", "1.9913.8.7163", "1.9913.8.8150", "1.9913.8.9227", "1.9950.9.953"};

  FileVersionInfo fvi = modules.First().FileVersionInfo;
  string fileVersion = String.Format("{0}.{1}.{2}.{3}",
				     fvi.FileMajorPart,
				     fvi.FileMinorPart,
				     fvi.FileBuildPart,
				     fvi.FilePrivatePart);
  if (Array.IndexOf(versions, fileVersion) >= 0) {
    version = fileVersion;
  } else {
    version = "";
  }

  vars.isLoading = false;
  vars.startTimer = false;
  vars.startState = Int32.MaxValue;
  vars.startTimerState = 3;
}

update
{
  if (version == "") {
    return false;
  }

  vars.isLoading = current.isLoading;

  // Immediately reset the start flag. The game should only start on a
  // single frame.
  vars.startTimer = false;

  // This is a very hacky way to infer the very start of the
  // game--just count the number of loading screens after starting a
  // new game. LiveSplit must first "see" the title screen for this to
  // work, and assumes that all runs begin by selecting "New
  // Game".
  if (!current.notTitleScreen) {
    // Being on the title screen makes us eligible to click New Game.
    vars.startState = 0;
  } else if (vars.startState < vars.startTimerState
	     && !current.isLoading
	     && old.isLoading) {
    // After X load cycles have completed, we can start the timer.
    if (++vars.startState == vars.startTimerState) {
      vars.startTimer = true;
    }
  }
}

start
{
  return vars.startTimer;
}

isLoading
{
  return vars.isLoading;
}

