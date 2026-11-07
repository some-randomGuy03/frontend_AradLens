# -*- coding: utf-8 -*-
"""AradLens — development server: fișiere statice + /api/ reverse proxy.

În producție nginx face proxy-ul (deploy/nginx/default.conf); acest mic
server stdlib imită acel comportament local, ca panoul de categorii să
meargă și pe http://127.0.0.1:8010 fără docker.

Pornire:  python dev_server.py          (port 8010)
"""

import http.server
import sys
import urllib.error
import urllib.request

PORT = 8010
UPSTREAM = "https://api.aradlens.binarysquad.club"
FORWARDED_HEADERS = ("Authorization", "Content-Type", "Accept", "User-Agent")


class Handler(http.server.SimpleHTTPRequestHandler):

    # erori curate în consolă, nu trace-uri uriașe
    def log_message(self, fmt, *args):
        sys.stderr.write("[http] " + (fmt % args) + "\n")

    # --------------------- /api -> API-ul central ---------------------
    def _proxy(self):
        path = self.path[len("/api"):] or "/"

        length = int(self.headers.get("Content-Length") or 0)
        body = self.rfile.read(length) if length else None
        req = urllib.request.Request(UPSTREAM + path, data=body, method=self.command)
        for h in FORWARDED_HEADERS:
            if h in self.headers:
                req.add_header(h, self.headers[h])
        try:
            with urllib.request.urlopen(req, timeout=20) as up:
                data = up.read()
                status = up.status
                ctype = up.headers.get("Content-Type", "application/json")
        except urllib.error.HTTPError as e:
            data = e.read()
            status = e.code
            ctype = e.headers.get("Content-Type", "application/json")
        except Exception:
            data = b'{"detail":"Dev proxy nu a putut contacta API-ul AradLens"}'
            status = 502
            ctype = "application/json"
        self.send_response(status)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        if data:
            self.wfile.write(data)

    # --------------------- rutele HTTP ---------------------
    def do_GET(self):
        if self.path.startswith("/api"):
            return self._proxy()
        return super().do_GET()

    def do_HEAD(self):
        if self.path.startswith("/api"):
            return self._proxy()
        return super().do_HEAD()

    def do_POST(self):
        if self.path.startswith("/api"):
            return self._proxy()
        self.send_error(405)

    def do_PUT(self):
        if self.path.startswith("/api"):
            return self._proxy()
        self.send_error(405)

    def do_DELETE(self):
        if self.path.startswith("/api"):
            return self._proxy()
        self.send_error(405)

    def end_headers(self):
        # nu memorăm în cache răspunsurile API; trebuie să fie mereu proaspete
        if self.path.startswith("/api"):
            self.send_header("Cache-Control", "no-store")
        super().end_headers()


if __name__ == "__main__":
    server = http.server.ThreadingHTTPServer(("127.0.0.1", PORT), Handler)
    print("AradLens dev: static + /api proxy pe http://127.0.0.1:%d" % PORT)
    server.serve_forever()
