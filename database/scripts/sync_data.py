#!/usr/bin/env python3
import shutil
import sys
from pathlib import Path

root = Path(__file__).parent.parent.parent
source = root / "database" / "outputs"
targets = {
    "app": root / "app" / "assets" / "data",
    "server": root / "server" / "data",
}

target = sys.argv[1] if len(sys.argv) > 1 else "all"
to_sync = targets if target == "all" else {target: targets.get(target)}

if not source.exists() or (target != "all" and target not in targets):
    sys.exit(1)

for name, dst in to_sync.items():
    if dst.exists():
        shutil.rmtree(dst)
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copytree(source, dst)
