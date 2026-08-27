import json
import os
import time
import urllib.request

# Configuration
# Change target, profile, and version as needed for Google Wifi (gale)
# Usually Google Wifi (gale) uses the ipq40xx target.
VERSION = "snapshot"  # or specific version like "23.05.5"
PROFILE = "google,gale"  # Target profile ID for Google Wifi
PACKAGES = [
    "luci-app-firewall",
    "kmod-usb3",
    # Add any other packages you need here
]

ASU_URL = "https://firmware-selector.immortalwrt.org"


def request_build():
  print(f"[*] Requesting build for {PROFILE} on version {VERSION}...")
  data = json.dumps(
      {"version": VERSION, "target": PROFILE.split(",")[0], "profile": PROFILE, "packages": PACKAGES}
  ).encode("utf-8")

  req = urllib.request.Request(
      f"{ASU_URL}/api/build",
      data=data,
      headers={"Content-Type": "application/json"},
  )

  try:
    with urllib.request.urlopen(req) as response:
      result = json.loads(response.read().decode("utf-8"))
      return result
  except Exception as e:
    print(f"[-] Error triggering build request: {e}")
    return None


def poll_and_download(request_data):
  if not request_data or "request_hash" not in request_data:
    print("[-] Invalid build request response.")
    return

  req_hash = request_data["request_hash"]
  print(f"[*] Build requested successfully. Request Hash: {req_hash}")
  print("[*] Waiting for build to complete...")

  while True:
    time.sleep(10)
    try:
      with urllib.request.urlopen(f"{ASU_URL}/api/build/{req_hash}") as response:
        status_data = json.loads(response.read().decode("utf-8"))

        status = status_data.get("status")
        print(f"[*] Current Build Status: {status}")

        if status == "complete":
          print("[+] Build completed successfully!")
          download_files(status_data.get("images", []))
          break
        elif status == "failed":
          print("[-] Build failed on the remote server.")
          print(status_data)
          break
    except Exception as e:
      print(f"[!] Error checking status: {e}")


def download_files(images):
  os.makedirs("firmware_output", exist_ok=True)
  for img in images:
    # img can be factory, sysupgrade, etc.
    if "url" in img:
      file_url = ASU_URL + img["url"] if img["url"].startswith("/") else img["url"]
      file_name = os.path.join("firmware_output", img.get("name", "firmware.bin"))
      print(f"[*] Downloading {file_name} from {file_url}...")

      urllib.request.urlretrieve(file_url, file_name)
      print(f"[+] Saved: {file_name}")


if __name__ == "__main__":
  build_info = request_build()
  if build_info:
    poll_and_download(build_info)
