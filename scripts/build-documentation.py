#!/usr/bin/env python3
"""Build each stable release tag into a versioned GitHub Pages artifact."""

import html
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile


ROOT = Path(__file__).resolve().parents[1]
SITE = ROOT / ".build/site"


def run(*args, cwd=ROOT):
    subprocess.run(args, cwd=cwd, check=True)


def main():
    tags = subprocess.check_output(
        ["git", "tag", "--list"], cwd=ROOT, text=True
    ).splitlines()
    versions = sorted(
        (tag for tag in tags if re.fullmatch(r"(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)", tag)),
        key=lambda tag: tuple(map(int, tag.split("."))),
        reverse=True,
    )
    if not versions:
        raise SystemExit("No stable release tags found (expected e.g. 0.1.0).")
    repository = os.environ.get("GITHUB_REPOSITORY", "thebriancompany/swift-brian-ui")
    base_path = repository.split("/")[-1]
    if SITE.exists():
        shutil.rmtree(SITE)
    SITE.mkdir(parents=True)

    for version in versions:
        print(f"Building BrianUI {version}", flush=True)
        with tempfile.TemporaryDirectory(prefix="brianui-docc-") as directory:
            source = Path(directory)
            archive = source / "source.tar"
            run("git", "archive", "--format=tar", f"--output={archive}", f"refs/tags/{version}")
            run("tar", "-xf", str(archive), "-C", str(source))
            run("swift", "build", "-c", "release", cwd=source)
            run("swift", "package", "dump-symbol-graph", "--skip-synthesized-members", cwd=source)
            run(
                "xcrun", "docc", "convert", "Sources/BrianUI/BrianUI.docc",
                "--additional-symbol-graph-dir", ".build/out/symbolgraph",
                "--fallback-display-name", "BrianUI",
                "--fallback-bundle-identifier", "com.thebriancompany.BrianUI",
                "--output-path", str(SITE / version),
                "--hosting-base-path", f"{base_path}/{version}",
                "--warnings-as-errors", cwd=source,
            )
            (SITE / version / "index.html").write_text(
                '<!doctype html><html lang="ko"><meta charset="utf-8">'
                '<meta http-equiv="refresh" content="0; url=documentation/brianui/">'
                f'<title>BrianUI {version}</title>'
                '<a href="documentation/brianui/">API 문서 열기</a></html>', encoding="utf-8",
            )

    links = "\n".join(
        f'<li><a href="{version}/documentation/brianui/">BrianUI {html.escape(version)}</a></li>'
        for version in versions
    )
    (SITE / "index.html").write_text(
        '<!doctype html><html lang="ko"><meta charset="utf-8">'
        '<meta name="viewport" content="width=device-width, initial-scale=1">'
        f'<title>BrianUI 문서</title><h1>BrianUI 문서</h1><ul>{links}</ul></html>',
        encoding="utf-8",
    )
    (SITE / ".nojekyll").touch()
    print(f"Built {len(versions)} version(s) into {SITE}")


if __name__ == "__main__":
    main()
