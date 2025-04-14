import os
import argparse

def check(msg, key, sign):
    if len(msg) != len(key):
        print "Wrong input. Length mismatch!!"
    else:
        output = crypto(msg, key, sign)
        print output.lower()

def crypto(msg, key, sign):
    original = []
    for i in range(len(msg)):
        x = (ord(msg[i]) + (sign * ord(key[i]))) % 26
        x += ord("A")
        original.append(chr(x))
    return ''.join(original)


# To parse the arguments passed
def argument_parser(): 
    parser = argparse.ArgumentParser()
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--encode", action="store_true", help="For encoding a string")
    group.add_argument("--decode", action="store_true",help="For decoding")
    parser.add_argument("msg", help="Text to be encoded or decoded")
    parser.add_argument("key", help="Key to encrypt or decrypt")
    args = parser.parse_args()
    return args


if __name__ == "__main__":
    args = argument_parser()

    msg = str.upper(args.msg)
    key = str.upper(args.key)

    sign = 1 if args.encode else -1

    check(msg, key, sign)

