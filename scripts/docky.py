#!/usr/bin/python3

import sys, getopt
from enum import Enum, auto, unique
import subprocess

@unique
class Action(Enum):
    CONNECT = "connect"
    IP = "ip"
    LOGS = "logs"
    KILL = "kill"


class Arguments:
    def __init__(self, image_name:str) -> None:
        self.image_name = image_name
        pass

    def __str__(self) -> str:
        return f"{self.image_name}"

def get_args():
    import argparse

    parser = argparse.ArgumentParser(description='Example with non-optional arguments')
    parser.add_argument('action', action="store", type=Action, choices=list(Action))
    parser.add_argument('-i', action="store", default=None, dest="image_name")

    return parser.parse_args()

def get_id_by_image_name(image_name: str, all_containers: bool = False):
    cmd = ["docker", "ps", "-q", "--filter", f"ancestor={image_name}", "--format='{{.ID}}'"]
    cmd = cmd + ["-a"] if all_containers else cmd
    with subprocess.Popen(cmd, stdout=subprocess.PIPE) as proc:
        r = proc.stdout.read().decode('utf-8').replace("'", "").replace("\n", " ").strip().split()
        return r

def get_id_by_image_name_contains(image_name: str):
    with subprocess.Popen(["docker", "ps"], stdout=subprocess.PIPE) as proc:
        try:
            outs, errs = proc.communicate(timeout=15)
            filtered = [line.decode("utf-8").split()[0] for line in outs.splitlines() if image_name in line.decode("utf-8")]
            return filtered                
        except subprocess.TimeoutExpired:
            proc.kill()
            outs, errs = proc.communicate()        
    

def print_logs(image_name: str):
    print("Not done yet")

def connect(image_name: str):
    import os
    ids = get_id_by_image_name_contains(image_name)
    if(len(ids) == 1):
        print(f"Connecting to {image_name} id: {ids[0]}")
        os.system(f"docker exec -it {ids[0]} /bin/sh")
    else:
        print("Error, too many ids found")

def get_ip(image_name: str):
    ids = get_id_by_image_name_contains(image_name)
    result = {}
    for id in ids:
        r = run_cmd(["docker", "inspect", "-f", "'{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'", id])
        result[id] = r
    print(result)

def kill_by_image_name(image_name: str):
    ids = get_id_by_image_name_contains(image_name)
    if(len(ids) > 0):
        print(f"Killing pods {ids}")
        for id in ids:
            run_cmd(["docker", "kill", id ])
            run_cmd(["docker", "rm", id])
    else:
        print("Nothing to kill")

def run_cmd(cmd: 'list(str)', print_result: bool = False):
    with subprocess.Popen(cmd, stdout=subprocess.PIPE) as proc:
        r = proc.stdout.read().decode('ascii').replace("\n", " ").strip()
        if(print_result):
            print(r)
        return r

def main(argv):
    results = get_args()
    if results.action == Action.LOGS:
        print_logs(results.image_name)
    elif results.action == Action.CONNECT:
        connect(results.image_name)
    elif results.action == Action.IP:
        get_ip(results.image_name)
    elif results.action == Action.KILL:
        kill_by_image_name(results.image_name)
        
if __name__ == "__main__":
   main(sys.argv[1:])