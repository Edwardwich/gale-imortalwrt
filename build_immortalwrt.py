import urllib.request
import urllib.error
import json
import sys

# Define target configuration
target_profile = "google,gale"
packages = [
    "base-files", "uci", "netifd", "dropbear", "dnsmasq", 
    "iptables", "fstools", "luci", "luci-theme-bootstrap", 
    "nano", "htop", "kmod-wireguard", "sing-box"
]

print(f"Requesting build for {target_profile} with packages: {packages}")

# Ensure you use the correct API endpoint (update domain if using a custom instance)
api_url = "https://sysupgrade.openwrt.org/api/v1/build" 

payload = {
    "profile": target_profile,
    "packages": packages,
    "release": "snapshot"  # Adjust version/release if targeting a specific stable branch
}

data = json.dumps(payload).encode("utf-8")
req = urllib.request.Request(
    api_url, 
    data=data, 
    headers={"Content-Type": "application/json", "User-Agent": "Python-Client"}
)

try:
    with urllib.request.urlopen(req) as response:
        result = json.loads(response.read().decode("utf-8"))
        print("Build request successful:", result)
except urllib.error.HTTPError as e:
    print(f"HTTP Error {e.code}: {e.reason}", file=sys.stderr)
    print("Check if the profile name exists or if the API endpoint path is correct.", file=sys.stderr)
    sys.exit(1)
except Exception as e:
    print(f"An unexpected error occurred: {e}", file=sys.stderr)
    sys.exit(1)
