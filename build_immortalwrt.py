import urllib.request
import urllib.error
import json
import sys

# Target profile and package manifest configuration
target_profile = "google,gale"
packages = [
    "base-files", "uci", "netifd", "dropbear", "dnsmasq", 
    "iptables", "fstools", "luci", "luci-theme-bootstrap", 
    "nano", "htop", "kmod-wireguard", "sing-box"
]

print(f"Requesting build for {target_profile} with packages: {packages}")

# Correct endpoint schema for build requests on the Attended Sysupgrade server
api_url = "https://sysupgrade.openwrt.org/api/v1/build"

payload = {
    "profile": target_profile,
    "packages": packages,
    "release": "snapshot"  # Adjust version string if targeting a specific release
}

data = json.dumps(payload).encode("utf-8")
req = urllib.request.Request(
    api_url, 
    data=data, 
    headers={
        "Content-Type": "application/json", 
        "User-Agent": "Python-ASU-Client"
    }
)

try:
    with urllib.request.urlopen(req) as response:
        result = json.loads(response.read().decode("utf-8"))
        print("Build request successfully sent and processed:", result)
except urllib.error.HTTPError as e:
    print(f"HTTP Error {e.code}: {e.reason}", file=sys.stderr)
    try:
        error_body = e.read().decode("utf-8")
        print(f"Server response details: {error_body}", file=sys.stderr)
    except Exception:
        pass
    sys.exit(1)
except Exception as e:
    print(f"An unexpected error occurred: {e}", file=sys.stderr)
    sys.exit(1)
