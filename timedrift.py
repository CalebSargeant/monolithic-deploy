import requests
from xml.etree import ElementTree as ET
from datetime import datetime, timezone
import ntplib

def get_ntp_time(ntp_server="time.cloudflare.com"):
    """Fetch the current time from an NTP server."""
    ntp_client = ntplib.NTPClient()
    response = ntp_client.request(ntp_server, version=3)
    # Convert NTP time to a Python datetime object
    ntp_time = datetime.utcfromtimestamp(response.tx_time).replace(tzinfo=timezone.utc)
    return ntp_time

def get_camera_time(ip, username, password):
    """Fetch the current time from the Hikvision camera."""
    url = f"http://{ip}/ISAPI/System/time"
    response = requests.get(url, auth=(username, password), timeout=5)

    if response.status_code == 200:
        xml_tree = ET.fromstring(response.text)

        # Define the namespace
        namespace = {'ns': 'http://www.hikvision.com/ver20/XMLSchema'}

        # Find the localTime element using the namespace
        local_time = xml_tree.find('ns:localTime', namespace)
        if local_time is None:
            print("localTime element not found in the XML response.")
            return None

        # Convert localTime (ISO 8601) to a Python datetime object
        camera_time = datetime.fromisoformat(local_time.text)
        return camera_time
    else:
        print(f"Failed to query time for {ip}: {response.status_code}")
        return None

def calculate_time_offset(reference_time, target_time):
    """Calculate the time difference in seconds between two datetime objects."""
    return (reference_time - target_time).total_seconds()

# Example usage
if __name__ == "__main__":
    # NTP server and camera details
    ntp_server = "time.cloudflare.com"
    ip = "hcs084w10sc.sn.mynetname.net:5880"
    username = "platform1"
    password = "Pl#tf0rm1"

    # Get NTP and camera times
    ntp_time = get_ntp_time(ntp_server)
    print(f"NTP Time (UTC): {ntp_time}")

    camera_time = get_camera_time(ip, username, password)
    if camera_time:
        print(f"Camera Time (Local): {camera_time}")

        # Compare times
        offset = calculate_time_offset(ntp_time, camera_time)
        print(f"Time Offset: {offset:.2f} seconds")