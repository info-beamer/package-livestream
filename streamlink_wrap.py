#!/usr/bin/python3
from hosted import config
config.restart_on_update()

import time, traceback, threading, sys, os
from queue import Queue
from ibquery import InfoBeamerQuery

def run_in_thread(fn):
    def loop():
        while 1:
            try:
                fn()
            except:
                print >>sys.stderr, "error in %r. retrying"
                traceback.print_exc()
                time.sleep(1)
    t = threading.Thread(target=loop)
    t.daemon = True
    t.start()

q = Queue()

def channel_monitor():
    ib = InfoBeamerQuery('127.0.0.1')
    con = ib.node("root").io(raw=True)

    for line in con:
        stream_url = line.strip()
        if stream_url:
            q.put(stream_url)
            break

    for line in con:
        now_url = line.strip()
        if now_url != stream_url:
            break
    os.kill(os.getpid(), 9)

run_in_thread(channel_monitor)

def start_stream(url):
    while len(sys.argv) > 1:
        sys.argv.pop()
    sys.argv.extend([
        "-l", "debug",
        "--player-external-http",
        "--player-external-http-port", "8000",
        url, "best",
    ])
    print(repr(sys.argv))
    from streamlink_cli.main import main
    try:
        main()
    except SystemExit:
        sys.stderr.write("Cannot start stream. waiting 30 seconds\n")
        time.sleep(30)

stream_url = q.get().decode('utf8')
start_stream(stream_url)
