state("CodeVein-Win64-Shipping")
{
}

state("CodeVein-Win64-Shipping", "1.9903.8.6465")
{
  bool isLoading : 0x3C482D0;
}

init
{
  string[] versions = {"1.9903.8.6465"};

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
}

update
{
  if (version == "") {
    return false;
  }

  vars.isLoading = current.isLoading;
}

isLoading
{
  return vars.isLoading;
}
