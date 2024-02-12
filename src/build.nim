import std/osproc

import cligen


proc debugBuild(): int =
  execCmd "nim c -o:p_indusiatus.exe src\\p_indusiatus.nim"


proc releaseBuild(): int =
  execCmd "nim c -d:release -o:p_indusiatus.exe src\\p_indusiatus.nim"


proc main(status = "debug"): int =
  case status
  of "debug":
    debugBuild()
  of "release":
    releaseBuild()
  else:
    1


when isMainModule:
  dispatch(main, help = {
    "status": "debug or release"
  })
