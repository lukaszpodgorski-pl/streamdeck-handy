import { access, constants } from "node:fs/promises";
import { platform, homedir } from "node:os";
import { join } from "node:path";

const CANDIDATES: Record<NodeJS.Platform, string[]> = {
  darwin: [
    "/Applications/Handy.app/Contents/MacOS/Handy",
    join(homedir(), "Applications/Handy.app/Contents/MacOS/Handy"),
  ],
  win32: [
    "C:\\Program Files\\Handy\\handy.exe",
    join(homedir(), "AppData\\Local\\Programs\\Handy\\handy.exe"),
    join(homedir(), "AppData\\Local\\Handy\\handy.exe"),
  ],
  linux: [
    "/usr/bin/handy",
    "/usr/local/bin/handy",
    join(homedir(), ".local/bin/handy"),
  ],
  aix: [],
  freebsd: [],
  openbsd: [],
  sunos: [],
  android: [],
  haiku: [],
  cygwin: [],
  netbsd: [],
};

async function exists(path: string): Promise<boolean> {
  try {
    await access(path, constants.X_OK);
    return true;
  } catch {
    return false;
  }
}

export async function resolveHandyBinary(
  override?: string,
): Promise<string | null> {
  if (override && (await exists(override))) return override;

  const candidates = CANDIDATES[platform()] ?? [];
  for (const c of candidates) {
    if (await exists(c)) return c;
  }
  if (platform() === "linux") return "handy";
  return null;
}
