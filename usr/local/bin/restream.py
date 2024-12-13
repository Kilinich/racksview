from flask import Flask, Response
import socket
import time
from waitress import serve

app = Flask(__name__)

TCP_SERVER_HOST = "127.0.0.1"
TCP_SERVER_PORT_MAIN = 8080
TCP_SERVER_PORT_PREVIEW = 8080
BOUNDARY_STRING = "--ThisRandomString"

@app.route('/main')
def mjpeg_stream_main():
    def generate_main():
        while True:
            try:
                with socket.create_connection((TCP_SERVER_HOST, TCP_SERVER_PORT_MAIN)) as sock:
                    while True:
                        data = sock.recv(4096)
                        if not data:
                            # no wait
                            break
                        yield data
            except socket.error as e:
                print(f"Error connecting to {TCP_SERVER_HOST}:{TCP_SERVER_PORT_MAIN}: {e}")
                # Wait before attempting to reconnect
                time.sleep(1)
    headers = {
        "Content-Type": f"multipart/x-mixed-replace; boundary={BOUNDARY_STRING}"
    }
    return Response(generate_main(), headers = headers)

@app.route('/preview')
def mjpeg_stream_preview():
    def generate_preview():
        while True:
            try:
                with socket.create_connection((TCP_SERVER_HOST, TCP_SERVER_PORT_PREVIEW)) as sock:
                    while True:
                        data = sock.recv(4096)
                        if not data:
                            break
                        yield data
            except socket.error as e:
                print(f"Error connecting to {TCP_SERVER_HOST}:{TCP_SERVER_PORT_PREVIEW}: {e}")
                time.sleep(1)

    headers = {
        "Content-Type": f"multipart/x-mixed-replace; boundary={BOUNDARY_STRING}"
    }
    return Response(generate_preview(), headers=headers)


if __name__ == '__main__':
    serve(app, host='0.0.0.0', port=8080)
