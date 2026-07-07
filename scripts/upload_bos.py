#!/usr/bin/env python3
"""Upload exported static site files to Baidu BOS with bce-python-sdk."""

from __future__ import annotations

import mimetypes
import os
import sys
from pathlib import Path

from baidubce.auth.bce_credentials import BceCredentials
from baidubce.bce_client_configuration import BceClientConfiguration
from baidubce.services.bos.bos_client import BosClient

ROOT_DIR = Path(__file__).resolve().parents[1]
DEFAULT_DIST_DIR = ROOT_DIR / "apps" / "web" / "out"
HTML_CACHE = "no-cache, no-store, must-revalidate"
NEXT_ASSET_CACHE = "public, max-age=31536000, immutable"
STATIC_CACHE = "public, max-age=3600"


def require_env(name: str) -> str:
    value = os.getenv(name)
    if not value:
        print(f"Missing required environment variable: {name}", file=sys.stderr)
        raise SystemExit(1)
    return value


def build_object_key(file_path: Path, dist_dir: Path, prefix: str) -> str:
    relative_key = file_path.relative_to(dist_dir).as_posix()
    clean_prefix = prefix.strip("/")

    if clean_prefix:
        return f"{clean_prefix}/{relative_key}"

    return relative_key


def cache_control_for(object_key: str) -> str:
    if object_key.endswith(".html"):
        return HTML_CACHE

    if "/_next/" in f"/{object_key}":
        return NEXT_ASSET_CACHE

    return STATIC_CACHE


def content_type_for(file_path: Path) -> str | None:
    content_type, _ = mimetypes.guess_type(file_path.name)
    return content_type


def iter_files(dist_dir: Path) -> list[Path]:
    return sorted(path for path in dist_dir.rglob("*") if path.is_file())


def main() -> int:
    access_key = require_env("BOS_ACCESS_KEY")
    secret_key = require_env("BOS_SECRET_KEY")
    bucket = require_env("BOS_BUCKET")
    region = os.getenv("BOS_REGION", "bj")
    endpoint = os.getenv("BOS_ENDPOINT", f"https://{region}.bcebos.com")
    prefix = os.getenv("BOS_PREFIX", "")
    dist_dir = Path(os.getenv("DIST_DIR") or os.getenv("OUT_DIR") or DEFAULT_DIST_DIR).resolve()

    if not dist_dir.is_dir():
        print(f"Static output directory not found: {dist_dir}", file=sys.stderr)
        return 1

    client = BosClient(
        BceClientConfiguration(
            credentials=BceCredentials(access_key, secret_key),
            endpoint=endpoint,
        )
    )

    files = iter_files(dist_dir)
    print(f"Uploading {len(files)} files from {dist_dir} to bos://{bucket}/{prefix.strip('/')}")

    for file_path in files:
        object_key = build_object_key(file_path, dist_dir, prefix)
        user_headers = {"Cache-Control": cache_control_for(object_key)}
        content_type = content_type_for(file_path)

        upload_kwargs = {
            "bucket": bucket,
            "key": object_key,
            "file_name": str(file_path),
            "user_headers": user_headers,
        }
        if content_type:
            upload_kwargs["content_type"] = content_type

        client.put_object_from_file(**upload_kwargs)
        print(f"Uploaded {object_key}")

    print("BOS upload complete.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
