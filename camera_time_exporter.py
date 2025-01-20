import time
import requests
from xml.etree import ElementTree as ET
from datetime import datetime, timezone
from prometheus_client import start_http_server, Gauge

# Define Prometheus metrics
CAMERA_TIME_OFFSET = Gauge('camera_time_offset_seconds', 'Time offset between camera and NTP', ['camera'])


def get_ntp_time(ntp_server="time.cloudflare.com"):
    """Fetch the current time from an NTP server."""
    from ntplib import NTPClient
    ntp_client = NTPClient()
    response = ntp_client.request(ntp_server, version=3)
    ntp_time = datetime.fromtimestamp(response.tx_time, timezone.utc)
    return ntp_time


def get_camera_time(ip, username, password):
    """Fetch the current time from the Hikvision camera."""
    url = f"http://{ip}/ISAPI/System/time"
    response = requests.get(url, auth=(username, password), timeout=5)
    if response.status_code == 200:
        xml_tree = ET.fromstring(response.text)
        namespace = {'ns': 'http://www.hikvision.com/ver20/XMLSchema'}
        local_time = xml_tree.find('ns:localTime', namespace)
        if local_time is None:
            print(f"localTime element not found for camera: {ip}")
            return None
        camera_time = datetime.fromisoformat(local_time.text)
        return camera_time
    else:
        print(f"Failed to query time for camera: {ip} (HTTP {response.status_code})")
        return None


def monitor_cameras():
    """Monitor camera time offsets."""
    cameras = [
        {"ip": "hcs084w10sc.sn.mynetname.net:5880", "username": "platform1", "password": "Pl#tf0rm1", "name": "Camera1"}
    ]

    ntp_time = get_ntp_time()
    for camera in cameras:
        camera_time = get_camera_time(camera['ip'], camera['username'], camera['password'])
        if camera_time:
            offset = (ntp_time - camera_time).total_seconds()
            CAMERA_TIME_OFFSET.labels(camera=camera['name']).set(offset)


if __name__ == "__main__":
    # Start the Prometheus HTTP server
    start_http_server(8000)  # Expose metrics on port 8000
    print("Camera Time Exporter is running on port 8000...")

    # Continuously monitor cameras
    while True:
        monitor_cameras()
        time.sleep(60)  # Scrape interval